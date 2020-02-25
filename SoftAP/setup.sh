#!/bin/bash
setup_path="$(pwd)"
echo "------->1. Stop auto service"
# don't  let it done  auto
# stop  current running instance
sudo systemctl stop dnsmasq.service
# disable restart service
sudo systemctl disable dnsmasq.service 
sudo systemctl stop hostapd
sudo systemctl unmask hostapd
sudo systemctl disable hostapd

sudo killall dnsmasq
sudo killall hostapd
#############################################
echo "------->2. Install Flashpage as  the service"

flashpage_path="$setup_path/CaptivePortal"
cd $flashpage_path
sudo npm install

#create excutable file
sudo bash -c 'cat > /usr/bin/start_captiveportal.sh' << EOF
#!/bin/bash
sudo "$(which node)" "$flashpage_path/captive_portal.js"
EOF
sudo chmod +x /usr/bin/start_captiveportal.sh

cd  $setup_path
sudo cp -f ./config_ap/captiveportal.service /etc/systemd/system/captiveportal.service

#############################################
echo "------->3. Setup autohotspot service run once  at pwr on"
#create startup executables
sudo bash -c 'cat > /usr/bin/autohotspot.sh' << EOF
#!/bin/bash
cd "$setup_path/bin"
sudo ./check_connect_then_start_soft_ap.sh
EOF
sudo chmod +x /usr/bin/autohotspot.sh

sudo chmod +x "$setup_path/bin/check_connect_then_start_soft_ap.sh"
sudo chmod +x "$setup_path/bin/start_ap_fork.sh"
sudo cp -f ./config_ap/autohotspot.service /etc/systemd/system/autohotspot.service
sudo cp -f ./config_ap/autohotspot.service /etc/systemd/system/autohotspot.service

#default wifi client configuration
sudo cp -f ./config_ap/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

echo "------->4. Enable  service"

sudo systemctl enable autohotspot.service
sudo systemctl enable captiveportal.service
