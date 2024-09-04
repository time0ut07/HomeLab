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

function create_pi_hole() {
  echo "[*] Creating directories..."
  sudo mkdir -p /home/$USER/docker/pi_hole || error_message "[x] Failed to create pihole folder!"

  echo "[*] Downloading pihole container..."
  docker pull pihole/pihole:latest

  echo "[*] Initialising pihole..."
  docker run -d \
      --name pihole \
      --restart=unless-stopped \
      -e TZ="Asia/Kolkata" \
      -v "/home/$USER/docker/pi_hole/etc-pihole:/etc/pihole" \
      -v "/home/$USER/docker/pi_hole/etc-dnsmasq.d:/etc/dnsmasq.d" \
      -e VIRTUAL_HOST="pi.hole" \
      -e PROXY_LOCATION="pi.hole" \
      -e FTLCONF_LOCAL_IPV4="127.0.0.1" \ # might need to change to external ip
      --dns=127.0.0.1 --dns=1.1.1.1 \
      --hostname pi.hole \
      -p 53:53/tcp -p 53:53/udp \
      -p 8002:80 \
      pihole/pihole:latest
}

echo -e "time0ut - install pihole.sh"
internet_status
create_pi_hole
echo "[+] Successfully created a pihole docker container!"
echo
echo "Visit me @ http://localhost:8002"
