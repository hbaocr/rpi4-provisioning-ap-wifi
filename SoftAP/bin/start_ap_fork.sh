#!/bin/bash
wifidev="wlan0"
ip_gateway="10.0.0.1"
set_static_ip(){
        if ifconfig "$wifidev"  | grep  "inet $ip_gateway"
        then
                echo "already have config AP IP $ip_gateway"
        else
                echo "no config --> Try to set"
                x=1
                while ! ifconfig "$wifidev"  | grep  "inet $ip_gateway" 
                do
                    echo "Try config IP $ip_gateway on AP interface at  $x times"
                    x=$(( $x + 1 ))                     
                     sudo ifconfig "$wifidev" "$ip_gateway" netmask 255.255.255.0 
                     sleep 5
                     if [ $x -gt 10 ]
                     then
                            echo "can not setup static ip $ip_gateway on AP gateway "
                            break
                     fi
                done
        fi
}
start_hostapd(){
        echo "start hostapd"
        sudo killall hostapd
        sudo hostapd ../config_ap/hostapd.conf
}

start_dnsmasq(){
        if [ -z "$(ps -e | grep dnsmasq)" ]
        then
                echo "start new dnsmasag"
                sudo dnsmasq -C ../config_ap/dnsmasq.conf -d
        else
                echo "dnsmasq already started. Kill all and restart"
                sudo killall dnsmasq
                sudo dnsmasq -C ../config_ap/dnsmasq.conf -d
        fi    
}

sudo ifconfig "$wifidev" down
sleep 1
sudo ifconfig "$wifidev" up
echo "1.setup static IP address $ip_gateway"
set_static_ip

echo "2.start AP"
#  start subshell to  fork thread http://tldp.org/LDP/abs/html/subshells.html 
#  Running parallel processes in subshells by using &
start_hostapd & # fork this process and run parallel
sleep 60
echo "start dnsmag=====>"
start_dnsmasq # fork this process and run parallel