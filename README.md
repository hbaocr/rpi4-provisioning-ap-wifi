# Raspberry 4  provisioning ap wifi using hostapd and dnsmasq

## 1. Introduction


* When power on RPI, if  their is no wifi connection, the wifi AP will  automatically run.( these ssid and password can be modified in `./config_ap/hostapd.conf`)
    * SSID : RPIWifiConfig
    * password : 1234567890
* When connecting to AP the setup page  will automatically  show off (only test on iphone  and Ipad and some android phone). By using  this page  you can configure to  connect  to your  own AP.


## 2. Requisition software

* Setup wifi country code

    ```
    sudo raspi-config
    #------>4. Location Options
    #-------------->I4 Change Wi-fi Country
    #---------------------> US United States
    ```
    
* Libs and software packages

    ```sh
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install -y python curl git  build-essential tmux  nano hostapd dnsmasq

    # don't  let it done  auto
    # stop  current running instance
    sudo systemctl stop dnsmasq.service
    # disable restart service
    sudo systemctl disable dnsmasq.service 

    sudo systemctl stop hostapd
    sudo systemctl unmask hostapd
    sudo systemctl disable hostapd
    ```

* NodeJS v12:

    ```sh
    # install nvm  and nodejs
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
    
    source ~/.bashrc
    
    nvm install v12
    # The  sudo only recognize the PATH  in secure_path in file in /etc/sudoers
    # To see more details : run cmd :  
    # sudo visudo
    # alias node and npm to  /usr/bin sothat thay can be found  and run in sudo mode
    sudo ln -s "$(which node)" /usr/bin/node
    sudo ln -s "$(which node)" /usr/lib/node
    sudo ln -s "$(which npm)"  /usr/bin/npm
    ```


## 3. Install WIFI AP and captiveportal

```sh
cd SoftAP
chmod +x  setup.sh 
sudo ./setup.sh 
```

This will setup 3 services:
* dnsmasg:  
    * DHCP server for  wifi AP o wlan0    
    * Fake DNS server  which  ressolve all the DNS queries  from connected device of  this AP  to 10.0.0.1, where  the  nodejs web captiveportal listen on port  10.0.0.1:80 
* hostapd :  
    * Once shoot start when powerup : check if no wifi connection on wlan0 then start AP ( wifi Access Point) depend on  hostapd  application. If having connection, don't start AP mode.
* captiveportal.service : 
    * This is run nodejs express  application as wificonfiguration  to let user  can  config  the  SSID and  password of wifi, they want  to connect to.
    * This bind on all interface of  RPI (  wlan0 and eth0)  at port 80
    * Redirect all unhandle uri to root url "/"
    * Only support http (  https may support in future)  

Boot process:
* `./bin/check_connect_then_start_soft_ap.sh` :  Check wifi in  90 sec, if no wifi connection  then run  `./bin/start_ap_fork.sh`
    *  Start hostapd  app with  config in `./config_ap/hostapd.conf`
    *  Wait 60 sec then start fake dns serser  and dhcpserver on  `wlan0`by running `dnsmasq`  with config in `./config_ap/dnsmasq.conf`
* Start flashpage nodejs webserver with sudo to listen  all and create captive Portal the  webserver src  in  `CaptivePortal`
    
After  running setup  you can have your own AP in next reboot. Or if  you want  to  bring it up now to test:
```sh
sudo /usr/bin/autohotspot.sh
```
or
```
cd bin
sudo ./check_connect_then_start_soft_ap
```

## 4. Reference link
* [https://www.raspberryconnect.com/projects/65-raspberrypi-hotspot-accesspoints/158-raspberry-pi-auto-wifi-hotspot-switch-direct-connection](https://www.raspberryconnect.com/projects/65-raspberrypi-hotspot-accesspoints/158-raspberry-pi-auto-wifi-hotspot-switch-direct-connection)
* [https://www.shellvoide.com/wifi/how-to-setup-captive-portal-login-with-rogue-ap-nginx/](https://www.shellvoide.com/wifi/how-to-setup-captive-portal-login-with-rogue-ap-nginx/)
* [https://socifi-doc.atlassian.net/wiki/spaces/SC/pages/94371841/DNS+Fix+to+keep+Android+Splash+Page+and+the+Captive+Portal+Notification+active](https://socifi-doc.atlassian.net/wiki/spaces/SC/pages/94371841/DNS+Fix+to+keep+Android+Splash+Page+and+the+Captive+Portal+Notification+active)
