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

function create_filebrowser() {
  echo "[*] Creating directories..."
  sudo mkdir -p /home/$USER/filebrowser || error_message "[-] Failed to create filebrowser folder!"
  
  echo "[*] Downloading filebrowser container..."
  docker pull filebrowser/filebrowser:latest
  echo "[*] Initialising filebrowser..."
  docker run -d \
      --name filebrowser \
      --restart unless-stopped \
      -v /home/$USER:/srv \
      -v /home/$USER/filebrowser/filebrowser.db:/database/filebrowser.db \
      -v /home/$USER/filebrowser/settings.json:/config/settings.json \
      -e PUID=$(id -u) \
      -e PGID=$(id -g) \
      -p 8123:80 \
      filebrowser/filebrowser:latest
}

internet_status
create_filebrowser
echo "[+] Successfully create a filebrowser docker container!"
