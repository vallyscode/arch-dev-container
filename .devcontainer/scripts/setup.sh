#!/bin/sh

pacman --noconfirm -Syu
pacman --noconfirm -S \
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
runuser -l $USERNAME -c "ccurl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bashurl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
runuser -l $USERNAME -c ". /home/$USERNAME/.nvm/nvm.sh && nvm install 16 && nvm use 16"

# aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip

# sam cli
pip install aws-sam-cli

# rust
pacman --noconfirm -S gcc make valgrind
curl --proto '=https' --tlsv1.2 -sSfL https://sh.rustup.rs > install.sh
chmod +x install.sh
chown $USERNAME:$USERNAME /install.sh
runuser -l $USERNAME -c "/install.sh -y"
rm /install.sh

# vscode extensions
runuser -l $USERNAME -c ". /home/$USERNAME/.nvm/nvm.sh && npm install -g yo generator-code"

# Go hugo
pacman --noconfirm -S hugo

# Golang
GO_VERSION=1.19.4
curl -sSLO https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# Java
JAVA_VERSION=19
curl -sSLO https://corretto.aws/downloads/latest/amazon-corretto-${JAVA_VERSION}-x64-linux-jdk.tar.gz
tar -C /home/$USERNAME -xzf amazon-corretto-${JAVA_VERSION}-x64-linux-jdk.tar.gz
rm amazon-corretto-${JAVA_VERSION}-x64-linux-jdk.tar.gz

# Maven
MVN_VERSION=3.8.6
curl -sSLO https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
tar -C /home/$USERNAME -xzf apache-maven-${MVN_VERSION}-bin.tar.gz
rm apache-maven-${MVN_VERSION}-bin.tar.gz
