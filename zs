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

function zs_install_apps () {
    echo -e "
    +-----------------------------------------------------------+
    |${GREEN}Installing ZorinOS Apps${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    sudo snap install code --classic
    sudo snap install code sublime-text --classic
    sudo snap install gtkhash
    sudo snap install android-studio --classic
    sudo snap install brave
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm -rf google-chrome-stable_current_amd64.deb
    sudo apt-get install cpu-x -y
    sudo apt-get install gtkhash -y
    sudo snap install whatsie
    sudo snap install postman
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
echo "
'https://docs.docker.com/desktop/install/linux/ubuntu/#install-docker-desktop'
"
sudo apt install gnome-terminal -y
sudo apt-get install ./docker-desktop-amd64.deb -y
sudo rm -rf docker-desktop-amd64.deb
}

function zs_install_virtualbox() {
# VirtualBox
echo -e "
    +-----------------------------------------------------------+
    |${MAGENTA}Installing Oracle VirtualBox on Ubuntu${ENDCOLOR}
    +-----------------------------------------------------------+
    "
    wget https://download.virtualbox.org/virtualbox/7.1.2/virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb
    sudo apt-get install virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb -y
    rm -rf virtualbox-7.1_7.1.2-164945~Ubuntu~jammy_amd64.deb
}

function zs_install_all() {
    zs_install_apps
    zs_install_docker_desktop
    zs_install_virtualbox
}

# <-- Manual - BEGIN
manual() {
    echo -e "Parameters:
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
elif [[ $1 == "--install-apps" ]]; then
    zs_install_apps
    exit 0
elif [[ $1 == "--install-docker-desktop" ]]; then
    zs_install_docker_desktop
    exit 0
elif [[ $1 == "--install-virtualbox" ]]; then
    zs_install_virtualbox
    exit 0
elif [[ $1 == "--install-all" ]]; then
    zs_install_all
    exit 0
fi

echo "Choose an option:"
echo "1. Install Apps"
echo "2. Install Docker Desktop"
echo "3. Install VirtualBox"
echo "4. Install All"
read option

case $option in
    1)
        zs_install_apps
        ;;
    2)  
        zs_install_docker_desktop
        ;;
    3)
        zs_install_virtualbox
        ;;
    4)
        zs_install_all
        ;;
    *)
        echo "Invalid option"
        ;;
esac
