#!/bin/bash
echo "1. Disable  AP depend service"
sudo systemctl disable dnsmasq.service 
sudo systemctl unmask hostapd
sudo systemctl disable hostapd




