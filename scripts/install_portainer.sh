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

function install_portainer() {
    echo "[*] Pulling Portainer Docker image..."
    sudo docker pull portainer/portainer-ce:latest || error_message "[-] Failed to pull Portainer docker image!"
    echo "[*] Running Portainer container..."
    sudo docker run -d -p 9000:9000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest || error_message "[-] Failed to create Portainer docker container!"
}

echo -e "time0ut - install_portainer.sh"
echo
internet_status
echo
install_portainer
