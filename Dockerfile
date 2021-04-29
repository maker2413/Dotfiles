FROM archlinux:latest

RUN pacman -Syyu --noconfirm && \
    pacman -S --needed base-devel --noconfirm && \
    pacman -S emacs fish git neofetch openssh --noconfirm

RUN useradd -m -G wheel -s /bin/fish epost && \
    echo "epost ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER epost

WORKDIR /home/epost

RUN rm .bashrc && \
    git init . && \
    git remote add -t \* -f origin https://github.com/maker2413/DotFiles.git && \
    git checkout master

RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf paru-bin

RUN paru -S pyenv pyenv-virtualenv tfenv rbenv --noconfirm

RUN mkdir /home/epost/Code

WORKDIR /home/epost/Code

ENTRYPOINT [ "fish" ]
