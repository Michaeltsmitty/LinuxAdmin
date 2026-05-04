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
hostname -i 
ip address show #shows ipv4 ,ipv6,mac address


echo "Ping test:"
ping -c 4 google.com #pings google 4 times

echo "open and listening ports:"
ss -tuln # shows any open and listening sockets

echo "Dns Information:"
resolvectl status #shows info about dns such as that it is local stub resolver

echo "Netplan Configuration:"
ls /etc/netplan #shows where net config is located 
cat /etc/netplan/*.yaml #shows data in the network config such as enpos3 and if dchp is on or off

 echo "saving results to log file NetworkDumpReport.txt"
 }| tee NetworkDumpReport.txt | less # logs it to a file and also makes it scrollable 

