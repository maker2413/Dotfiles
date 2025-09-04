# Main file for fish command completions. This file contains various
# common helper functions for the command completions. All actual
# completions are located in the completions subdirectory.

# Set default field separators
set -g IFS \n\ \t
set -qg __fish_added_user_paths
or set -g __fish_added_user_paths

# For one-off upgrades of the fish version, see __fish_config_interactive.fish
if not set -q __fish_initialized
    set -U __fish_initialized 0
    if set -q __fish_init_2_39_8
        set __fish_initialized 2398
    else if set -q __fish_init_2_3_0
        set __fish_initialized 2300
    end
end

# Create the default command_not_found handler
function __fish_default_command_not_found_handler
    printf "fish: Unknown command: %s\n" (string escape -- $argv[1]) >&2
end

if status --is-interactive
    # Enable truecolor/24-bit support for select terminals
    # Ignore Screen and emacs' ansi-term as they swallow the sequences, rendering the text white.
    if not set -q STY
        and not string match -q -- 'eterm*' $TERM
        and begin
            set -q KONSOLE_PROFILE_NAME # KDE's konsole
            or string match -q -- "*:*" $ITERM_SESSION_ID # Supporting versions of iTerm2 will include a colon here
            or string match -q -- "st-*" $TERM # suckless' st
            or test -n "$VTE_VERSION" -a "$VTE_VERSION" -ge 3600 # Should be all gtk3-vte-based terms after version 3.6.0.0
            or test "$COLORTERM" = truecolor -o "$COLORTERM" = 24bit # slang expects this
        end
        # Only set it if it isn't to allow override by setting to 0
        set -q fish_term24bit
        or set -g fish_term24bit 1
    end
else
    # Hook up the default as the principal command_not_found handler
    # in case we are not interactive
    function __fish_command_not_found_handler --on-event fish_command_not_found
        __fish_default_command_not_found_handler $argv
    end
end

# Set default search paths for completions and shellscript functions
# unless they already exist

# __fish_data_dir, __fish_sysconf_dir, __fish_help_dir, __fish_bin_dir
# are expected to have been set up by read_init from fish.cpp

# Grab extra directories (as specified by the build process, usually for
# third-party packages to ship completions &c.
set -l __extra_completionsdir
set -l __extra_functionsdir
set -l __extra_confdir
if test -f $__fish_data_dir/__fish_build_paths.fish
    source $__fish_data_dir/__fish_build_paths.fish
end

# Compute the directories for vendor configuration.  We want to include
# all of XDG_DATA_DIRS, as well as the __extra_* dirs defined above.
set -l xdg_data_dirs
if set -q XDG_DATA_DIRS
    set --path xdg_data_dirs $XDG_DATA_DIRS
    set xdg_data_dirs (string replace -r '([^/])/$' '$1' -- $xdg_data_dirs)/fish
else
    set xdg_data_dirs $__fish_data_dir
end

set -l vendor_completionsdirs $xdg_data_dirs/vendor_completions.d
set -l vendor_functionsdirs $xdg_data_dirs/vendor_functions.d
set -l vendor_confdirs $xdg_data_dirs/vendor_conf.d

# Ensure that extra directories are always included.
if not contains -- $__extra_completionsdir $vendor_completionsdirs
    set -a vendor_completionsdirs $__extra_completionsdir
end
if not contains -- $__extra_functionsdir $vendor_functionsdirs
    set -a vendor_functionsdirs $__extra_functionsdir
end
if not contains -- $__extra_confdir $vendor_confdirs
    set -a vendor_confdirs $__extra_confdir
end

# Set up function and completion paths. Make sure that the fish
# default functions/completions are included in the respective path.
if not set -q fish_function_path
    set fish_function_path $__fish_config_dir/functions $__fish_sysconf_dir/functions $vendor_functionsdirs $__fish_data_dir/functions
else if not contains -- $__fish_data_dir/functions $fish_function_path
    set -a fish_function_path $__fish_data_dir/functions
end

if not set -q fish_complete_path
    set fish_complete_path $__fish_config_dir/completions $__fish_sysconf_dir/completions $vendor_completionsdirs $__fish_data_dir/completions $__fish_user_data_dir/generated_completions
else if not contains -- $__fish_data_dir/completions $fish_complete_path
    set -a fish_complete_path $__fish_data_dir/completions
end

# This cannot be in an autoload-file because `:.fish` is an invalid filename on windows.
function : -d "no-op function"
    # for compatibility with sh, bash, and others.
    # Often used to insert a comment into a chain of commands without having
    # it eat up the remainder of the line, handy in Makefiles.
    # This command always succeeds
    true
end

# This is a Solaris-specific test to modify the PATH so that
# Posix-conformant tools are used by default. It is separate from the
# other PATH code because this directory needs to be prepended, not
# appended, since it contains POSIX-compliant replacements for various
# system utilities.

if begin; not set -q FISH_UNIT_TESTS_RUNNING; and test -d /usr/xpg4/bin; end
    not contains -- /usr/xpg4/bin $PATH
    and set PATH /usr/xpg4/bin $PATH
end

# Add a handler for when fish_user_path changes, so we can apply the same changes to PATH
function __fish_reconstruct_path -d "Update PATH when fish_user_paths changes" --on-variable fish_user_paths
    set -l local_path $PATH

    for x in $__fish_added_user_paths
        set -l idx (contains --index -- $x $local_path)
        and set -e local_path[$idx]
    end

    set -g __fish_added_user_paths
    if set -q fish_user_paths
        # Explicitly split on ":" because $fish_user_paths might not be a path variable,
        # but $PATH definitely is.
        for x in (string split ":" -- $fish_user_paths[-1..1])
            if set -l idx (contains --index -- $x $local_path)
                set -e local_path[$idx]
            else
                set -ga __fish_added_user_paths $x
            end
            set -p local_path $x
        end
    end

    set -xg PATH $local_path
end

# Launch debugger on SIGTRAP
function fish_sigtrap_handler --on-signal TRAP --no-scope-shadowing --description "Signal handler for the TRAP signal. Launches a debug prompt."
    breakpoint
end

# Whenever a prompt is displayed, make sure that interactive
# mode-specific initializations have been performed.
# This handler removes itself after it is first called.
function __fish_on_interactive --on-event fish_prompt
    __fish_config_interactive
    functions -e __fish_on_interactive
end

# Set the locale if it isn't explicitly set. Allowing the lack of locale env vars to imply the
# C/POSIX locale causes too many problems. Do this before reading the snippets because they might be
# in UTF-8 (with non-ASCII characters).
__fish_set_locale

# "." alias for source; deprecated
function . -d 'Evaluate a file (deprecated, use "source")' --no-scope-shadowing --wraps source
    if [ (count $argv) -eq 0 ] && isatty 0
        echo "source: using source via '.' is deprecated, and stdin doesn't work."\n"Did you mean 'source' or './'?" >&2
        return 1
    else
        source $argv
    end
end

# Upgrade pre-existing abbreviations from the old "key=value" to the new "key value" syntax.
# This needs to be in share/config.fish because __fish_config_interactive is called after sourcing
# config.fish, which might contain abbr calls.
if test $__fish_initialized -lt 2300
    if set -q fish_user_abbreviations
        set -l fab
        for abbr in $fish_user_abbreviations
            set -a fab (string replace -r '^([^ =]+)=(.*)$' '$1 $2' -- $abbr)
        end
        set fish_user_abbreviations $fab
    end
end

# Some things should only be done for login terminals
# This used to be in etc/config.fish - keep it here to keep the semantics
if status --is-login
    if command -sq /usr/libexec/path_helper
        # Adapt construct_path from the macOS /usr/libexec/path_helper
        # executable for fish; see
        # https://opensource.apple.com/source/shell_cmds/shell_cmds-203/path_helper/path_helper.c.auto.html .
        function __fish_macos_set_env -d "set an environment variable like path_helper does (macOS only)"
            set -l result

            # Populate path according to config files
            for path_file in $argv[2] $argv[3]/*
                if [ -f $path_file ]
                    while read -l entry
                        if not contains -- $entry $result
                            test -n "$entry"
                            and set -a result $entry
                        end
                    end <$path_file
                end
            end

            # Merge in any existing path elements
            for existing_entry in $$argv[1]
                if not contains -- $existing_entry $result
                    set -a result $existing_entry
                end
            end

            set -xg $argv[1] $result
        end

        __fish_macos_set_env 'PATH' '/etc/paths' '/etc/paths.d'
        if [ -n "$MANPATH" ]
            __fish_macos_set_env 'MANPATH' '/etc/manpaths' '/etc/manpaths.d'
        end
        functions -e __fish_macos_set_env
    end

    # Put linux consoles in unicode mode.
    if test "$TERM" = linux
        and string match -qir '\.UTF' -- $LANG
        and command -sq unicode_start
        unicode_start
    end
end

# Invoke this here to apply the current value of fish_user_path after
# PATH is possibly set above.
__fish_reconstruct_path

# Allow %n job expansion to be used with fg/bg/wait
# `jobs` is the only one that natively supports job expansion
function __fish_expand_pid_args
    for arg in $argv
        if string match -qr '^%\d+$' -- $arg
            # set newargv $newargv (jobs -p $arg)
            jobs -p $arg
            if not test $status -eq 0
                return 1
            end
        else
            printf "%s\n" $arg
        end
    end
end

for jobbltn in bg fg wait disown
    function $jobbltn -V jobbltn
        builtin $jobbltn (__fish_expand_pid_args $argv)
    end
end

function kill
    command kill (__fish_expand_pid_args $argv)
end

# As last part of initialization, source the conf directories.
# Implement precedence (User > Admin > Extra (e.g. vendors) > Fish) by basically doing "basename".
set -l sourcelist
for file in $__fish_config_dir/conf.d/*.fish $__fish_sysconf_dir/conf.d/*.fish $vendor_confdirs/*.fish
    set -l basename (string replace -r '^.*/' '' -- $file)
    contains -- $basename $sourcelist
    and continue
    set sourcelist $sourcelist $basename
    # Also skip non-files or unreadable files.
    # This allows one to use e.g. symlinks to /dev/null to "mask" something (like in systemd).
    [ -f $file -a -r $file ]
    and source $file
end

# User Config
set -x EDITOR "emacs -nw"
set fish_greeting

# EXA Config
set -x EXA_COLORS "uu=35:gu=35"

# Basic aliases
alias brave-browser "brave"
alias em "emacs -nw"
alias cls "clear && echo \"Current directory:\" && exa -lag --icons"
alias journal "emacs -nw ~/Journal/"
alias startdocker "sudo systemctl start docker"
alias stopdocker "sudo systemctl stop docker"
alias startssh "sudo systemctl start sshd"
alias stopssh "sudo systemctl stop sshd"
alias tscale "sudo tailscale"
alias tmus "tmux"
alias updates "paru -Syyu"

# exa aliases
if type -q exa
  alias ll "exa -lag --icons"
  alias ls "exa"
else
  alias ll "ls -la"
end

# bat alias
if type -q bat
  alias cat "bat --color never"
end

# Aliases for git commands
alias ga "git add"
alias gc "git commit"
alias gch "git checkout"
alias gcm "git checkout master"
alias gd "git diff"
alias gl "git pull"
alias gs "git status"
alias gsp "git subtree push"
alias gsl "git subtree pull"
alias gp "git push"
alias gr "git restore"

# Aliases for kubectl commands
alias ka "kubectl apply"
alias kc "kubectl create"
alias kd "kubectl describe"
alias ke "kubectl exec"
alias kg "kubectl get"
alias kga "kubectl get all"
alias kr "kubectl delete"
alias kl "kubectl logs"

# Aliases for watching kubectl commands
alias wka "watch kubectl apply"
alias wkc "watch kubectl create"
alias wkd "watch kubectl describe"
alias wkg "watch kubectl get"
alias wkr "watch kubectl delete"

# Aliases for lxc
alias lc "lxc"
alias lcc "lxc launch"
alias lcd "lxc delete"
alias lci "lxc info"
alias lcl "lxc list"

# Aliases for terraform commands
alias tf "terraform"
alias tfa "terraform apply"
alias tfd "terraform destroy"
alias tfi "terraform init"
alias tfp "terraform plan"
alias tfw "terraform workspace"

function gotree
    if test -e .coverage-ignore.yaml
        go test -coverprofile coverage.out ./... && GO_COVER_IGNORE_COVER_PROFILE_PATH='coverage.out' go-cover-ignore && go-cover-treemap -percent -coverprofile coverage.out > coverage.svg
    else
        go test -coverprofile coverage.out ./... && go-cover-treemap -percent -coverprofile coverage.out > coverage.svg
    end
end

# Aliases for development
alias gocover "go test -coverprofile coverage.out && go tool cover -html=coverage.out"
alias linecount "find . -type f -print0 | wc -l --files0-from=-"
alias webdev "docker run --rm --name notes-web -v ~/Notes/WebSite:/usr/share/nginx/html:ro -p 8080:80 -d nginx"
alias webdevstop "docker stop notes-web"
alias wordcount "find . -type f -print0 | wc -w --files0-from=-"

if [ -t 0 ]
  if type -q neofetch
    neofetch
  end
end

# SSH Agent
if type -q ssh
  pgrep ssh-agent > /dev/null
  if test $status -eq 1
    eval (ssh-agent -c) > /dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  end
end

# Pyenv Setup
if type -q pyenv
  status is-interactive; and pyenv init --path | source
  pyenv init - | source
  # pyenv virtualenv-init - | source
end

# Tfenv Setup
if type -q tfenv
  set -p PATH $HOME/.tfenv/bin
end

# Krew Setup
if test -d $HOME/.krew/bin
  set -gx PATH $PATH $HOME/.krew/bin
end

# Go Setup
if test -d $HOME/go/bin
  set -gx PATH $PATH $HOME/go/bin
end

# Remove warning message from jupyter
set -gx PYDEVD_DISABLE_FILE_VALIDATION 1

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/epost/.lmstudio/bin
# End of LM Studio CLI section

# opencode
fish_add_path /home/epost/.opencode/bin
