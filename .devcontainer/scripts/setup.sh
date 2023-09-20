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
runuser -l $USERNAME -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"
runuser -l $USERNAME -c ". /home/$USERNAME/.nvm/nvm.sh && nvm install 18 && nvm use 18"

# aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip

# sam cli
curl -sSLO https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
./sam-installation/install
rm -rf aws-sam-cli-linux-x86_64.zip

# rust
pacman --noconfirm -S gcc make valgrind
curl --proto '=https' --tlsv1.2 -sSfL https://sh.rustup.rs > install.sh
chmod +x install.sh
chown $USERNAME:$USERNAME /install.sh
runuser -l $USERNAME -c "/install.sh -y"
rm /install.sh

# vscode extensions
runuser -l $USERNAME -c ". /home/$USERNAME/.nvm/nvm.sh && npm install -g yo generator-code"

# go hugo
pacman --noconfirm -S hugo

# golang
GO_VERSION=1.20.2
curl -sSLO https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz

# java
JAVA_VERSION=20
curl -sSLO https://corretto.aws/downloads/latest/amazon-corretto-${JAVA_VERSION}-x64-linux-jdk.tar.gz
rm -rf /usr/local/amazon-corretto-* && tar -C /usr/local -xzf amazon-corretto-${JAVA_VERSION}-x64-linux-jdk.tar.gz
rm amazon-corretto-${JAVA_VERSION}-x64-linux-jdk.tar.gz

# maven
MVN_VERSION=3.9.3
curl -sSLO https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
rm -rf /usr/local/apache-maven-* && tar -C /usr/local -xzf apache-maven-${MVN_VERSION}-bin.tar.gz
rm apache-maven-${MVN_VERSION}-bin.tar.gz

# .NET
NET_VERSION=6.0.414
curl -sSLO https://download.visualstudio.microsoft.com/download/pr/d97d1625-d7ed-444c-a7e9-e7b469842960/d8b97220d0d79119e3026da2b956854e/dotnet-sdk-${NET_VERSION}-linux-x64.tar.gz
rm -rf /usr/local/.dotnet && mkdir -p /usr/local/.dotnet && tar -C /usr/local/.dotnet -xzf dotnet-sdk-${NET_VERSION}-linux-x64.tar.gz
rm dotnet-sdk-${NET_VERSION}-linux-x64.tar.gz
