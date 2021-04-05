#!/bin/bash

# Fail immediately if any errors occur
set -e

echo
echo "################################################################"
echo "  Cache [sudo] password                                             "
echo "################################################################"
echo

sudo -K
sudo true;

echo
echo "################################################################"
echo "  Updating the system                                           "
echo "################################################################"
echo

sudo apt update
sudo apt full-upgrade -y

echo
echo "################################################################"
echo "  Installing requirements                                       "
echo "################################################################"
echo

## probar a ver cuales vienen incluidos
sudo apt install -y \
    apt-transport-https \
    software-properties-common

echo
echo "################################################################"
echo "  Installing Git                                                "
echo "################################################################"
echo

if ! location=$(type -p "git"); then
    sudo apt install -y git
fi

echo
echo "################################################################"
echo "  Installing Screenfetch                                        "
echo "################################################################"
echo

if ! location=$(type -p "screenfetch"); then
    sudo apt install -y screenfetch
fi

echo
echo "################################################################"
echo "  Installing Docker                                             "
echo "################################################################"
echo

if ! location=$(type -p "pip3"); then
  sudo apt install -y python3-pip
fi

repositories=$(grep ^[^#] /etc/apt/sources.list /etc/apt/sources.list.d/*)
if ! repository=$(echo "$repositories" | grep "download.docker.com"); then
    curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=armhf signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
fi

if ! location=$(type -p "docker"); then
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
fi

if ! location=$(type -p "docker-compose"); then
    sudo pip3 install docker-compose
fi

# https://zoilomora.net/2019/10/17/cambiar-el-rango-de-red-de-docker/
sudo tee /etc/docker/daemon.json << EOF
{
  "default-address-pools": [
    {
      "base": "10.10.0.0/16",
      "size": 24
    }
  ]
}
EOF

echo
echo "################################################################"
echo "  Updating the system                                           "
echo "################################################################"
echo

sudo apt update
sudo apt --fix-broken install
sudo apt upgrade -y
sudo apt autoremove -y
