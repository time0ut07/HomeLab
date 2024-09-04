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

  echo "[*] Initialising pihole..."
  docker run -d \
      --name pihole \
      --restart=unless-stopped \
      -e TZ="Asia/Kolkata" \
      -v "/home/$USER/docker/pi_hole/etc-pihole:/etc/pihole" \
      -v "/home/$USER/docker/pi_hole/etc-dnsmasq.d:/etc/dnsmasq.d" \
      -e VIRTUAL_HOST="pi.hole" \
      -e PROXY_LOCATION="pi.hole" \
      -e FTLCONF_LOCAL_IPV4="localhost" \
      --dns=127.0.0.1 --dns=1.1.1.1 \
      --hostname pi.hole \
      -p 53:53/tcp -p 53:53/udp \
      -p 8002:80 \
      pihole/pihole:latest
}

function start_pi_hole() {
    printf "[*] Starting up pihole container..."
    for i in $(seq 1 20); do
        if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
            printf ' OK'
            echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: http://${IP}/admin/"
            exit 0
        else
            sleep 3
            printf '.'
        fi
    
        if [ $i -eq 20 ] ; then
            echo -e "\nTimed out waiting for Pi-hole start, consult your container logs for more info (\`docker logs pihole\`)"
            exit 1
        fi
}

echo -e "time0ut - install pihole.sh"
internet_status
create_pi_hole
echo "[+] Successfully created a pihole docker container!"
start_pi_hole
echo "[+] Successfully started pihole!"
echo
echo "Visit me @ http://localhost:8002"
