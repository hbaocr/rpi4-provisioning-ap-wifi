#!/bin/bash

#https://nodesource.com/blog/running-your-node-js-app-with-systemd-part-1/
# kill all fake dns server to let the app can pull the node_modules package
echo "kill all fake dns server to let the app can pull the node_modules package"
sudo killall dnsmasq
sleep 2

setup_path="$(pwd)"


echo "==========SetupCaptivePortal Flashpage==========="
echo "copy CaptivePortal and jump to /home/pi/CaptivePortal to setup module"
cp -rf CaptivePortal/ /home/pi/
cd /home/pi/CaptivePortal
npm install


echo "=========Go back to current setup path to continue setup==============="
echo $setup_path
cd $setup_path
# copy excuted file to target so that service can start
sudo cp ./config_ap/captiveportal.sh /usr/bin/captiveportal
sudo chmod +x /usr/bin/captiveportal

sudo cp ./config_ap/captiveportal.service /etc/systemd/system/captiveportal.service
sudo systemctl enable captiveportal.service

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
sudo cp -f ./config_ap/dnsmasq.conf /etc/dnsmasq.conf


# Creating the autohotspot script (The service will start from this point at startup)
# THis script will check if there are no internet ==>turn on wifi ap
# sudo chmod +x ./config_ap/autohotspot.sh
sudo cp ./config_ap/autohotspot.sh /usr/bin/autohotspot
sudo chmod +x /usr/bin/autohotspot

#Next we have to create a service which will run the autohotspot script when the Raspberry Pi starts up
sudo cp ./config_ap/autohotspot.service /etc/systemd/system/autohotspot.service
sudo systemctl enable autohotspot.service

echo "==========finish setup wifi hotspot when no internet connection==========="

#sudo iptables -t nat -A PREROUTING -d 0/0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1:80




