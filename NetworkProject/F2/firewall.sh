#!/bin/sh

#FLUSH OF ALL CHAINS
iptables -F #--> flush
iptables -X #--> delete all chains

#Set default policy to DROP on all chains
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Create custom chains to handle network traffic
    #TAP TO DMZ
iptables -N tapDmz
iptables -N dmzTap

    #GREEN TO DMZ
iptables -N greenDmz
iptables -N dmzGreen

    #RED TO DMZ
iptables -N redDmz
iptables -N dmzRed

#Add our custom chains to the forward chain
iptables -A FORWARD -i eth0 -s 172.16.8.76/30 -d 172.16.0.0/22 -j tapDmz
iptables -A FORWARD -o eth0 -s 172.16.0.0/22 -d 172.16.8.76/30 -j dmzTap

iptables -A FORWARD -i eth0 -s 172.16.4.0/22 -d 172.16.0.0/22 -j greenDmz
iptables -A FORWARD -o eth0 -s 172.16.0.0/22 -d 172.16.4.0/22 -j dmzGreen

iptables -A FORWARD -i eth0 -s 172.16.8.0/26 -d 172.16.0.0/22 -j redDmz
iptables -A FORWARD -o eth0 -s 172.16.0.0/22 -d 172.16.8.0/26 -j dmzRed 

#CHAIN RULES
    ##TAP_DMZ##
iptables -A tapDmz -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A dmzTap -m state --state ESTABLISHED,RELATED -j ACCEPT

    ##GREEN_DMZ##
iptables -A greenDmz -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A dmzGreen -m state --state ESTABLISHED,RELATED -j ACCEPT

    ##RED_DMZ##
iptables -A redDmz -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A dmzRed -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
