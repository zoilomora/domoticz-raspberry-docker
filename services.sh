#!/bin/bash

echo
echo "################################################################"
echo "  Cache [sudo] password                                             "
echo "################################################################"
echo

sudo -K
sudo true;

mkdir ~/docker
cd ~/docker


echo
echo "################################################################"
echo "  Domoticz                                                      "
echo "################################################################"
echo

mkdir domoticz
cd domoticz
tee ./docker-compose.yml << EOF
version: '3.8'

services:
  domoticz:
    image: linuxserver/domoticz:stable-version-2020.2
    container_name: domoticz
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Madrid
    volumes:
      - ./config:/config
    ports:
      - 8080:8080
      - 6144:6144
      - 1443:1443
    restart: unless-stopped

EOF
docker-compose up -d
cd ~/docker


echo
echo "################################################################"
echo "  Node-RED                                                      "
echo "################################################################"
echo

## Node-RED
mkdir node-red
cd node-red
tee ./docker-compose.yml << EOF
version: '3.8'

services:
  node-red:
    container_name: node-red
    image: nodered/node-red:1.2.9
    environment:
      - TZ=Europe/Madrid
    ports:
      - 1880:1880
    volumes:
      - ./data:/data
    restart: unless-stopped

EOF
mkdir data
docker-compose up -d
cd ~/docker


echo
echo "################################################################"
echo "  MQTT                                                          "
echo "################################################################"
echo

## MQTT
mkdir mqtt
cd mqtt
tee ./docker-compose.yml << EOF
version: '3.8'

services:
  mqtt:
    container_name: mqtt
    image: eclipse-mosquitto:2.0.10
    ports:
      - 1883:1883
      - 9001:9001
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - ./config:/mosquitto/config
    restart: unless-stopped

EOF
mkdir config
docker run -it --rm -u root:root -v "$(pwd)"/config:/tmp/config eclipse-mosquitto:2.0.10 sh -c "cp /mosquitto/config/mosquitto.conf /tmp/config/mosquitto.conf && chown 1000:1000 /tmp/config/mosquitto.conf"
sudo sed -i "s/#listener/listener 1883/g" ./config/mosquitto.conf
sudo sed -i "s/#allow_anonymous false/allow_anonymous true/g" ./config/mosquitto.conf
docker-compose up -d
cd ~/docker
