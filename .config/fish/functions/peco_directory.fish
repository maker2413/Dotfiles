function _peco_directory
  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv "|perl -pe 's/([ ()])/\\\\$1/g'|read foo
  else
    peco --layout=bottom-up |perl -pe 's/([ ()])/\\\\$1/g'|read foo
  end
  if [ $foo ]
    builtin cd $foo
  else
    commandline ''
  end
end

function peco_directory
  begin
    echo $HOME/.config
    echo $HOME/Code
    ls -ad */ | perl -pe "s#^#$PWD/#"
    ls -ad $HOME/Code/*
  end | sed -e 's/\/$//' | awk '!a[$0]++' | _peco_directory $argv
end
