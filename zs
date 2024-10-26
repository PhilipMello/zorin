#!/usr/bin/env bash
# Author
author="Philip Mello <@Microsoft>"
# Version
version="1.0"
# License
license="MIT"
# Date
current_date=$(date +'%b %d, %Y')
# GitHub
github='https://github.com/PhilipMello/'

script="ZorinOS Pos-Installation"
description="Tools and Packages"

echo "
 ______          _        ____   _____ 
|___  /         (_)      / __ \ / ____| $version
   / / ___  _ __ _ _ __ | |  | | (___   $current_date
  / / / _ \| '__| | '_ \| |  | |\___ \  $author
 / /_| (_) | |  | | | | | |__| |____) | $license
/_____\___/|_|  |_|_| |_|\____/|_____/ 
$github 

# --------------------------------------------------------------
# Script     : $script
# Description: $description
# --------------------------------------------------------------
# How to use: Execute zs
# Exemples:
# Manual: zs -h OR zs --h OR zs --help
# --------------------------------------------------------------
"
WHITE=""
BLUE="\033[97;104m"
YELLOW="\033[97;103m"
CYAN="\033[97;106m"
MAGENTA="\033[97;45m"
GREEN="\033[97;102m"
RED="\033[97;41m"
ENDCOLOR="\e[0m"

function zs_install_pkgs() {
    echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing Pakcages${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    sudo apt-get update -y
    sudo apt-get install \
    wget curl nano htop atop \
    zip unzip p7zip iperf3 stow nmap \
    tcpdump netcat-openbsd mtr sed jq \
    lnav sipcalc ipcalc inetutils-* net-tools \
    nmap libmpv1 libxcb-xinerama0 libxcb-cursor0 libnss3 \
    apache2-utils \
    rar unrar -y
}

function zs_install_apps() {
    echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing ZorinOS Apps${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    sudo apt-get update -y
    sudo snap install code --classic
    sudo snap install code sublime-text --classic
    sudo snap install gtkhash
    sudo snap install android-studio --classic
    sudo snap install brave
    sudo apt-get install cpu-x
    sudo apt-get install gtkhash
    sudo snap install whatsie
    sudo snap install postman

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/Downloads
    sudo apt-get install ~/Downloads/./google-chrome-stable_current_amd64.deb
    rm -rf ~/Downloads/google-chrome-stable_*.deb

    wget https://stable.dl2.discordapp.net/apps/linux/0.0.72/discord-0.0.72.deb -P ~/Downloads
    sudo apt-get install ~/Downloads/./discord-*.deb
    rm -rf ~/Downloads/discord-*.deb

    wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_129.0.2792.79-1_amd64.deb -P ~/Downloads
    sudo apt-get install ~/Downloads/./microsoft-edge-stable_*.deb
    rm -rf ~/Downloads/microsoft-edge-stable_*.deb

    # https://docs.ankiweb.net/platform/linux/installing.html
    sudo apt install libxcb-xinerama0 libxcb-cursor0 libnss3 -y
    wget https://github.com/ankitects/anki/releases/download/24.06.3/anki-24.06.3-linux-qt6.tar.zst -P ~/Downloads
    tar xaf ~/Downloads/anki-2XXX-linux-qt6.tar.zst
    sudo ~/Downloads/anki-2XXX-linux-qt6/./install.sh
    rm -rf ~/Downloads/anki-2XXX-linux-qt6/
}

function zs_install_docker_cli() {
    # https://github.com/docker/docker-install

    echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing Docker CLI${ENDCOLOR}
    +-----------------------------------------------------------+
    " 
    curl -sSL https://get.docker.com/ | CHANNEL=stable sh
    sudo systemctl enable --now docker

    [ $? -eq 0 ] && echo -e "
    +-------------------------------------------------------+
    |${GREEN}Docker CLI installed successfully${ENDCOLOR}
    +-------------------------------------------------------+
    " && exit $?
}

function zs_install_docker_desktop() {
    # Install Docker Desktop on Linux
    # https://docs.docker.com/desktop/install/linux/

    # Install using the apt repository
    echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing Docker Desktop${ENDCOLOR}
    +-----------------------------------------------------------+
    "   
    # Add Docker's official GPG key:
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo -e "
    +----------------------------------------------------------------------------+
    |${MAGENTA}Add the repository to Apt sources:${ENDCOLOR}
    |'https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository'
    +-----------------------------------------------------------------------------+
    "  
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    echo -e "
    +----------------------------------------------------------------------------+
    |${MAGENTA}Installing Docker Desktop on Ubuntu${ENDCOLOR}
    |'https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository'
    +-----------------------------------------------------------------------------+
    "  
    # Install Docker Desktop on Ubuntu
    # https://docs.docker.com/desktop/release-notes/
    echo "
    'https://docs.docker.com/desktop/install/linux/ubuntu/#install-docker-desktop'
    "
    sudo apt install gnome-terminal -y
    sudo apt-get install docker-desktop

    # Post install
    # https://docs.docker.com/engine/install/linux-postinstall/
    sudo groupadd docker
    sudo usermod -aG docker,root $USER
    newgrp docker,root
    sudo systemctl enable --now docker.service
    sudo systemctl enable --now containerd.service


    which docker > /dev/null 2>&1
        [ $? -eq 0 ] && echo -e "
        +-------------------------------------------------------+
        |${GREEN}Docker Desktop & CLI installed successfully${ENDCOLOR}
        +-------------------------------------------------------+
        " && exit $?
}

function zs_install_virtualbox() {
# VirtualBox
echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing Oracle VirtualBox on Ubuntu${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    wget https://download.virtualbox.org/virtualbox/7.1.2/virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb -P ~/Downloads
    sudo apt-get install -P ~/Downloads/./virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb -y
    rm -rf -P ~/Downloads/virtualbox-*.deb
}

function zs_install_all() {
    zs_install_pkgs
    zs_install_apps
    zs_install_docker_desktop
    zs_install_virtualbox
}

# <-- Manual - BEGIN
manual() {
    echo -e "Parameters:
    --install-pkgs                 Install Packages
    --install-apps                 Install Apps
    --install-docker-desktop       Install Docker Desktop
    --install-docker-virtualbox    Install VirtualBox
    --install-all                  Install All
    "
    exit 0
}

# Manual - END -->

if [[ $1 == "-h" || $1 == "--help" || $1 == "--h" ]]; then
    manual
    exit 1
elif [[ $1 == "--install-pkgs" ]]; then
    zs_install_pkgs
    [ $? -eq 0 ] && echo "<--packages installed successfully-->" && exit $?
elif [[ $1 == "--install-apps" ]]; then
    zs_install_apps
    [ $? -eq 0 ] && echo "<--apps installed successfully-->" && exit $?
elif [[ $1 == "--install-docker-desktop" ]]; then
    zs_install_docker_desktop
    [ $? -eq 0 ] && echo "<--docker-desktop installed successfully-->" && exit $?
elif [[ $1 == "--install-virtualbox" ]]; then
    zs_install_virtualbox
    [ $? -eq 0 ] && echo "<--virtualbox installed successfully-->" && exit $?
elif [[ $1 == "--install-all" ]]; then
    zs_install_all
    [ $? -eq 0 ] && echo "<--all apps and pakcages installed successfully-->" && exit $?
fi

echo "Choose an option:"
echo "1. Install Pakcages (wget curl nano htop atop)"
echo "2. Install Apps"
echo "3. Install Docker Desktop"
echo "4. Install VirtualBox"
echo "5. Install All"
read option

case $option in
    1)
        zs_install_pkgs
        ;;
    2)
        zs_install_apps
        ;;
    3)  
        zs_install_docker_desktop
        ;;
    4)
        zs_install_virtualbox
        ;;
    5)
        zs_install_all
        ;;
    *)
        echo "Invalid option"
        ;;
esac
