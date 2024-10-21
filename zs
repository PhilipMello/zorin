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
    sudo apt-get install \
    wget curl nano htop atop \
    zip unzip p7zip iperf3 stow nmap \
    tcpdump netcat-openbsd mtr sed jq \
    lnav sipcalc ipcalc inetutils-* net-tools \
    namp libmpv1 libxcb-xinerama0 libxcb-cursor0 libnss3 \
    apache2-utils \
    rar unrar -y
}

function zs_install_apps () {
    echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing ZorinOS Apps${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    sudo snap install code --classic
    sudo snap install code sublime-text --classic
    sudo snap install gtkhash
    sudo snap install android-studio --classic
    sudo snap install brave
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install ./google-chrome-stable_current_amd64.deb
    rm -rf google-chrome-stable_current_amd64.deb
    sudo apt-get install cpu-x
    sudo apt-get install gtkhash
    sudo snap install whatsie
    sudo snap install postman

    sudo apt-get install ./discord-*.deb
    rm -rf discord-*.deb

    sudo apt-get install ./microsoft-edge-stable_*.deb
    rm -rf microsoft-edge-stable_*.deb

    # https://docs.ankiweb.net/platform/linux/installing.html
    sudo apt install libxcb-xinerama0 libxcb-cursor0 libnss3
    tar xaf Downloads/anki-2XXX-linux-qt6.tar.zst
    cd anki-2XXX-linux-qt6
    sudo ./install.sh
    cd
    rm -rf anki-2XXX-linux-qt6
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
# https://docs.docker.com/desktop/release-notes/

# Install using the apt repository
echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing Docker Desktop & CLI${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    curl -sSL https://get.docker.com/ | CHANNEL=stable sh
    sudo systemctl enable --now docker
    sudo apt install gnome-terminal -y
    sudo apt-get install docker-desktop -y

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
    wget https://download.virtualbox.org/virtualbox/7.1.2/virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb
    sudo apt-get install ./virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb -y
    rm -rf virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb
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
echo "1. Install Pakcages ()"
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
