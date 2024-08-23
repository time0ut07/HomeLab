#!/bin/bash

function error_message {
    echo -e "//e[91m\n$1//e[39m"
    exit 1
}

function internet_status() {
    echo  "[*] Determining internet status..."
    wget -q --spider http://github.com
    if [ $? -eq 0 ]; then
        echo "[+] You are online!"
    else
        error_message "[-] You are offline... go connect to the internet first!"
    fi
}

function install_docker() {
    curl -sSL https://get.docker.com | sh || error_message "[-] Failed to install docker..."
    sudo usermod -aG docker $USER || error_message "[-] Failed to add user into Docker user group..."
}

echo -e "time0ut - install_docker.sh"
echo
internet_status
echo
install_docker
echo "[+] Reboot machine for the changes to take effect!"
