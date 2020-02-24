wifidev="wlan0"
static_ip="10.0.0.1"
#inet 169.254.49.91  netmask 255.255.0.0  broadcast 169.254.255.255
echo "Check if  no internet  IP : 169.254.x.x, then  migrate to $static_ip"
check_and_set_static_IP(){
        #if detecting  "no internet IP" 
        if ifconfig "$wifidev"  | grep  "inet 169.254"
        then
                echo "No internet default  IP is detected : 169.254.x.x"
                echo "Change 169.254.x.x to $static_ip"
                sudo  ifconfig "$wifidev" "$static_ip" netmask 255.255.255.0
                sleep 10
                x=1
                while ! ifconfig "$wifidev"  | grep  "inet $static_ip" 
                do
                    echo "Try config IP 10.0.0.1 on AP interface at  $x times"
                    x=$(( $x + 1 ))
                    sudo  ifconfig "$wifidev" "$static_ip" netmask 255.255.255.0
                    sleep 10
                     if [ $x -gt 20]; then
                            echo "can not setup static ip $static_ip on AP gateway "
                            break
                     fi
                done
        else
                echo "Detect  normal ip :"
                ifconfig "$wifidev"  | grep  "inet" 
        fi
}
check_and_set_static_IP