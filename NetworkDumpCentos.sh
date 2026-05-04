#!/bin/bash
#Michael Smith
#4/29/2026
#Network Info Dump 
#purpose is to dump useful network information to the command line to view


{
echo "Linux Network Information Dump"

echo "Hostname:"
hostname #shows the hostname of the server

echo "Ip Address:"
hostname -i #shows ip address
ip address show #shows ipv4 ,ipv6,mac address


echo "Ping test:"
ping -c 4 google.com #pings google 4 times

echo "open and listening ports:"
ss -tuln # shows any open and listening sockets

echo "Dns Information:"
cat /etc/resolv.conf #shows info about dns servers

echo "Network Manager Configuration:"
 cd /etc/NetworkManager/system-connections #changes director to netmanager
 cat enp0s3.nmconnection #shows network manager information such as dhcp/static

 echo "saving results to log file NetworkDumpReport.txt"
 }| tee NetworkDumpReport.txt | less # logs it to a file and also makes it scrollable 