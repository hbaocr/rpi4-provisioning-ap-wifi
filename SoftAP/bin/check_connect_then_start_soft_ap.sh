#!/bin/bash
wifidev="wlan0"
wifi_cnt=0
max_count=20
check_wifi_connect_at_pwr_on_then_start_ap(){
  
    until [ $wifi_cnt -gt $max_count ] #wait for wifi if busy, usb wifi is slower.
    do
        wifi_cnt=$((wifi_cnt + 1))
        echo "check connection count " $wifi_cnt
       
        if wpa_cli -i $wifidev status | grep ssid
        then
            
            if wpa_cli -i $wifidev status | grep ip_address
            then
                echo "wifi connect and having  IP"
                break
            else
                echo "wifi connect  and having no  IP"
            fi 
        
        else
            wpa_cli -i $wifidev status | grep wpa_state
            sleep 3
        fi
    done

    if [ $wifi_cnt -gt $max_count ]
    then
        echo "no wifi at start up. Start AP"
        # & ==> fork to new process to run AP
        sudo ./start_ap_fork.sh &
    fi
}

check_wifi_connect_at_pwr_on_then_start_ap