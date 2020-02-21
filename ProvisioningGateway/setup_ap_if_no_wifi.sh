#!/bin/bash
#https://www.raspberryconnect.com/projects/65-raspberrypi-hotspot-accesspoints/158-raspberry-pi-auto-wifi-hotspot-switch-direct-connection
echo "==========start to setup wifi hotspot when no internet connection==========="
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y hostapd dnsmasq
#The installers will have set up the programme so they run when the pi is started. For this setup they only need to be started if the home router is not found. 
#So automatic startup needs to be disabled and by default hostapd is masked so needs to be unmasked. This is done with the following commands:
sudo systemctl unmask hostapd

sudo systemctl disable hostapd
sudo systemctl disable dnsmasq

#create the config file
#sudo mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.org
sudo cp ./config_ap/hostapd.conf /etc/hostapd/hostapd.conf

# Now the defaults file needs to be updated to point to where the config file is stored.
sudo mv /etc/default/hostapd /etc/default/hostapd.org
sudo cp ./config_ap/hostapd /etc/default/hostapd

# Backup the interfaces
sudo cp /etc/network/interfaces /etc/network/interfaces-backup

#Backup  and add  nohook wpa_supplicant
# dhcpcd is dhcp client. At first release DHCPclient from wlan0 ( see in autohotspotscript.sh)
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.org
sudo cp ./config_ap/dhcpcd.conf /etc/dhcpcd.conf

#DNSmasq configuration
#Next dnsmasq needs to be configured to allow the Rpi to act as a router 
#and issue ip addresses. Open the dnsmasq.conf file with
sudo cp ./config_ap/dnsmasq.conf /etc/dnsmasq.conf


# Creating the autohotspot script (The service will start from this point at startup)
# THis script will check if there are no internet ==>turn on wifi ap
# sudo chmod +x ./config_ap/autohotspot.sh
sudo cp ./config_ap/autohotspot.sh /usr/bin/autohotspot
sudo chmod +x /usr/bin/autohotspot

#Next we have to create a service which will run the autohotspot script when the Raspberry Pi starts up
sudo cp ./config_ap/autohotspot.service /etc/systemd/system/autohotspot.service
sudo systemctl enable autohotspot.service

echo "==========finish setup wifi hotspot when no internet connection==========="





