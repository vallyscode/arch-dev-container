#!/bin/sh

yes | pacman -Syu
yes | pacman -S \
    sudo \
    zsh \
    zsh-completions \
    openssh \
    git \
    zip \
    unzip \
    python \
    python-pip 

USERNAME=${1}
USER_UID=${2}
USER_GID=${3}

groupadd --gid $USER_GID $USERNAME && \
    useradd -s /bin/zsh --uid $USER_UID --gid $USERNAME -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

mv /tmp/scripts/.zshrc /home/$USERNAME/ && chown $USERNAME:$USERNAME /home/$USERNAME/.zshrc
mv /tmp/scripts/.zprofile /home/$USERNAME/ && chown $USERNAME:$USERNAME /home/$USERNAME/.zprofile
mv /tmp/scripts/.gitconfig /home/$USERNAME/ && chown $USERNAME:$USERNAME /home/$USERNAME/.gitconfig

# nodejs
runuser -l $USERNAME -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
runuser -l $USERNAME -c ". /home/$USERNAME/.nvm/nvm.sh && nvm install 14 && nvm use 14"

# aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip

# sam cli
pip install aws-sam-cli

# rust
yes | pacman -S gcc make valgrind
curl --proto '=https' --tlsv1.2 -sSfL https://sh.rustup.rs > install.sh
chmod +x install.sh
chown $USERNAME:$USERNAME /install.sh
runuser -l $USERNAME -c "/install.sh -y"
rm /install.sh

# vscode extensions
runuser -l $USERNAME -c ". /home/$USERNAME/.nvm/nvm.sh && npm install -g yo generator-code"

# Golang
ENV GO111MODULE=auto
curl -sSLO https://golang.org/dl/go1.17.6.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz
rm go1.17.6.linux-amd64.tar.gz
