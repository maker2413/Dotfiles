#!/bin/sh

grep -qxF '[universe]' /etc/pacman.conf || sudo tee -a /etc/pacman.conf >/dev/null << 'EOF'
[universe]
Server = https://universe.artixlinux.org/$arch
Server = https://mirror1.artixlinux.org/universe/$arch
Server = https://mirror.pascalpuffke.de/artix-universe/$arch
Server = https://artixlinux.qontinuum.space/artixlinux/universe/os/$arch
Server = https://mirror1.cl.netactuate.com/artix/universe/$arch
Server = https://ftp.crifo.org/artix-universe/
EOF

sudo pacman -Sy --needed artix-archlinux-support --noconfirm;

grep -qxF '# Arch' /etc/pacman.conf || sudo tee -a /etc/pacman.conf >/dev/null <<'EOF'
# Arch
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch

[multilib]
Include = /etc/pacman.d/mirrorlist-arch
EOF
