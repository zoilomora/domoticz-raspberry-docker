#!/bin/bash

# Fail immediately if any errors occur
set -e

echo
echo "################################################################"
echo "  Cache [sudo] password                                         "
echo "################################################################"
echo

sudo -K
sudo true;

echo
echo "################################################################"
echo "  Updating the system                                           "
echo "################################################################"
echo

sudo apt-get update
sudo apt-get dist-upgrade -y

echo
echo "################################################################"
echo "  Installing requirements                                       "
echo "################################################################"
echo

## probar a ver cuales vienen incluidos
sudo apt-get install -y \
    apt-transport-https \
    software-properties-common

echo
echo "################################################################"
echo "  Installing Git                                                "
echo "################################################################"
echo

if ! location=$(type -p "git"); then
    sudo apt-get install -y git
fi

echo
echo "################################################################"
echo "  Installing Screenfetch                                        "
echo "################################################################"
echo

if ! location=$(type -p "screenfetch"); then
    sudo apt-get install -y screenfetch
fi

echo
echo "################################################################"
echo "  Installing Docker                                             "
echo "################################################################"
echo

# Install building tools
sudo apt-get install -y \
  build-essential \
  python3-pip \
  python3-dev \
  python3-testresources \
  libssl-dev \
  libffi-dev \
  cargo

sudo pip3 install --upgrade setuptools
sudo pip3 install wheel

NODENAME=$(uname -n)
RELEASE=$(lsb_release -cs)

case $NODENAME in
    "raspberrypi")
        case $RELEASE in
            "buster")
                GPG="raspbian"
                DEB="raspbian buster"
            ;;
            *)
                error "raspberrypi: $RELEASE unknown!"
            ;;
        esac
    ;;
    "odroidxu4")
        case $RELEASE in
            "buster")
                GPG="debian"
                DEB="debian buster"
            ;;
            "focal")
                GPG="ubuntu"
                DEB="ubuntu eoan"
            ;;
            *)
                error "odroidxu4: $RELEASE unknown!"
            ;;
        esac
    ;;
    *)
        error "$NODENAME unknown!"
    ;;
esac

repositories=$(grep ^[^#] /etc/apt/sources.list /etc/apt/sources.list.d/*)
if ! repository=$(echo "$repositories" | grep "download.docker.com"); then
    curl -fsSL "https://download.docker.com/linux/$GPG/gpg" | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=armhf signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DEB stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
fi

if ! location=$(type -p "docker"); then
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
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

# Uninstall building tools
sudo apt-get remove -y \
  python3-dev \
  libssl-dev \
  libffi-dev \
  cargo

echo
echo "################################################################"
echo "  Updating the system                                           "
echo "################################################################"
echo

sudo apt-get update
sudo apt-get install -f
sudo apt-get upgrade -y
sudo apt-get autoremove -y
