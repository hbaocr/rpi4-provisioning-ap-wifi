#!/bin/sh
sudo iwlist wlan0 scan | grep ESSID | awk -F: '{ print $2 }'