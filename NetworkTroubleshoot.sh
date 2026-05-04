#!/bin/bash
# Michael Smith
# Server Troubleshooting Script
# Purpose: Ask for server version and give troubleshooting suggestions

echo "Linux Server Troubleshooter"
echo "Which server are you using?"
echo "1. Ubuntu Server"
echo "2. CentOS Server"
echo

read -p "Enter 1 or 2: " choice #takes in user input

echo

if [ "$choice" = "1" ]; then #if input is 1 chooses ubuntu server and gives trouble shooting tips for this server
    echo "You selected Ubuntu Server."
    echo
    echo "No internet connectivity:"
    echo "-Check IP address: ip addr" #shows ip info
    echo "-Check DNS: resolvectl status" #makes sure dns is working 
    echo "-Test DNS and internet connection: ping -c 4 google.com" 
    echo
    echo "Set a static IP address:"
    echo "-Ubuntu uses netplan."
    echo "-Check config files: ls /etc/netplan/"
    echo "-Edit with: sudo nano /etc/netplan/*.yaml" #nano allows to change the file
	echo "-change dhcp to no" #makes static ip
    echo "-Apply changes with: sudo netplan apply" #applys the setting ipv4 to no
    echo
    echo "DNS to check:"
    echo "-Check /etc/resolv.conf"
    echo "-Check resolvectl status" # shows dns information
    echo
    echo "Trace path to website:"
    echo "-Run traceroute google.com" #shows path data takes to get to google

elif [ "$choice" = "2" ]; then #if input is 1 chooses centos server and gives trouble shooting tips for this server
    echo "You selected CentOS Server."
    echo
    echo "No internet connectivity:"
    echo "-check IP address: ip addr" #shows ip address 
    echo "-Check DNS: cat /etc/resolv.conf" #shows whetther or not dns is working 
    echo "-Test DNS and internet connection: ping -c 4 google.com" #pings google 4 times this shows us if it gets through its connected to internet and also dns is working as we are using the google hostname
    echo
    echo "Set a static IP address:"
    echo "-CentOS commonly uses NetworkManager."
    echo "-Check connections: nmcli connection show" #shows network info like dns,ipv4,mac addres ipv6
    echo "-Edit network settings in"
    echo "/etc/NetworkManager/system-connections/" #location of network manager information including dchp
	echo "-change dhcp to no" #makes static ip
    echo "-Restart networking: sudo systemctl restart NetworkManager"
    echo
    echo "DNS to check:"
    echo "-Check /etc/resolv.conf"
    echo "-Check nmcli device show" #these two commands show all dns info
    echo
    echo "Trace path to website:"
    echo "-Run traceroute google.com" #shows path data takes to get to google

else
    echo "Invalid choice. Please run the script again and enter 1 or 2." #if neither 1 or 2 is chosen it picks this 
fi

echo
echo "Troubleshooting script complete."