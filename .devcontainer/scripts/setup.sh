#!/bin/sh

yes | pacman -Syu
yes | pacman -S \
    sudo \
    zsh \
    zsh-completions \
    openssh \
    git

USERNAME=vscode
USER_UID=1000
USER_GID=1000

groupadd --gid $USER_GID $USERNAME && \
    useradd -s /bin/zsh --uid $USER_UID --gid $USERNAME -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

mv /tmp/scripts/.zshrc /home/$USERNAME/ && chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
mv /tmp/scripts/.gitconfig /home/$USERNAME/ && chown $USERNAME:$USERNAME /home/$USERNAME/.gitconfig

runuser -l $USERNAME -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
runuser -l $USERNAME -c '. /home/$USERNAME/.nvm/nvm.sh && nvm install --lts && nvm use --lts'
