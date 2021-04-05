# Domoticz in the docker-version with Raspberry Pi
This is a **Quick Guide** on how to install **[Raspberry Pi OS]** with **[Docker]** container system and how to
configure a [home automation system] based on **[Domoticz]**, **[MQTT]** and **[Node-RED]**.

## Install Raspberry Pi OS
First we will have to download the **[Raspberry Pi OS image]**, this guide is based on version [2021-03-04].

Once downloaded, we will unzip the `.zip` and we will have an `.img`.

    2021-03-04-raspios-buster-armhf-lite.zip
    2021-03-04-raspios-buster-armhf-lite.img

Now we will have to burn the image on a MicroSD card. I do it with the [Etcher] software.

Insert the MicroSD card into our Raspberry Pi and connect the power. After starting the operating system, it will ask
us to log in. The [default username and password] are `pi` and `raspberry` respectively.

### Raspberry Pi settings
There are a number of Raspberry Pi specific settings that we would have to adjust:

First we run the `sudo raspi-config` command and the configuration menu will appear.
- **Enable SSH server:** Go to option `3` and `P2`.
- **Regional and language settings:** Go to option `5` and `L1`. I have selected `es_ES.UTF-8 UTF-8`.
- **Set Timezone:** Go to option `5` and `L2`. I have selected `Europe` and `Madrid`.
- **Set WLAN Country:** Go to option `5` and `L4`. I have selected `ES Spain`.
- **Expand Filesystem:** Go to option `6` and `A1`.

When finished click on `Finish` and it will ask if you would like to rebbot now. `Yes` selection.

Login again and see the **IP address** assigned by DHCP with the `ifconfig` command.
It is advisable to configure a **static ip** in our Router.

Login from our main computer for your future convenience and next steps with the `ssh [user]@[ip]` command.
For example: `ssh pi@192.168.0.100`.

## Software installation
Run the `curl -sS environment.sh | bash` command once logged into the Raspberry Pi.

It will ask you to enter the password (if you haven't changed it) `raspberry`.

Wait for the installation script to finish.

Now we reboot the system with the `sudo reboot` command.

Run the `curl -sS services.sh | bash` command once logged into the Raspberry Pi.

**Domoticz takes a while to start the first time, it has to generate the DH parameters**.

## Enjoy
System ready!
You can check the containers created with the `docker ps -a` command.

We have the following ports open:
- Domoticz: **8080**, **1443** and **6144**.
- MQTT: **1883** and **9001**.
- Node-RED: **1880**.

A folder will have been created in `~/docker` with all the necessary `docker-compose.yml`.

I recommend finding out about **Domoticz**, **MQTT** and **Node-RED** to configure the software to your liking.

## License
Licensed under the [Apache-2.0]

Read [LICENSE] for more information

[Raspberry Pi OS]: https://www.raspberrypi.org/software/operating-systems/
[Docker]: https://www.docker.com/
[home automation system]: https://en.wikipedia.org/wiki/Home_automation
[Domoticz]: https://www.domoticz.com/
[MQTT]: https://mqtt.org/
[Node-RED]: https://nodered.org/
[Raspberry Pi OS image]: https://www.raspberrypi.org/software/operating-systems/
[2021-03-04]: https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-03-25/2021-03-04-raspios-buster-armhf-lite.zip
[Etcher]: https://www.balena.io/etcher/
[default username and password]: https://www.raspberrypi.org/documentation/linux/usage/users.md

[Apache-2.0]: https://opensource.org/licenses/Apache-2.0
[LICENSE]: LICENSE
