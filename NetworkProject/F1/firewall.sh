#!/bin/sh

#FLUSH OF ALL CHAINS
iptables -F #--> flush
iptables -X #--> delete all chains

#Set default policy to DROP on all chains
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Create custom chains to handle network traffic
    #RED TO GREEN
iptables -N redGreen
iptables -N greenRed

    #RED TO DMZ
iptables -N redDmz
iptables -N dmzRed

    #INET TO GREEN
iptables -N inetGreen
iptables -N greenInet

    #INET TO DMZ
iptables -N inetDmz
ipatbles -N dmzInet

#Add our custom chains to the forward chain
iptables -A FORWARD -i eth1 -d 172.16.4.0/22 -j redGreen
iptables -A FORWARD -o eth1 -s 172.16.4.0/22 -j greenRed

iptables -A FORWARD -i eth1 -d 172.16.0.0/22 -j redDmz
iptables -A FORWARD -o eth1 -s 172.16.0.0/22 -j dmzRed

iptables -A FORWARD -i eth0 -d 172.16.4.0/22 -j inetGreen
iptables -A FORWARD -o eth0 -s 172.16.4.0/22 -j greenInet

iptables -A FORWARD -i eth0 -o eth2 -d 172.16.0.0 -p tcp --dport 80 -j inetDmz #HTTP
iptables -A FORWARD -i eth0 -o eth2 -d 172.16.0.0 -p tcp --dport 25 -j inetDmz #SMTP
iptables -A FORWARD -i eth0 -o eth2 -d 172.16.0.0 -p tcp --dport 23 -j inetDmz #Telnet
iptables -A FORWARD -i eth0 -o eth2 -d 172.16.0.0 -p tcp --dport 21 -j inetDmz #FTP
iptables -A FORWARD -i eth0 -o eth2 -d 172.16.0.0 --dport 53 -j inetDmz #DNS
iptables -A FORWARD -i eth2 -o eth0 -s 172.16.0.0 -j dmzInet

    #CHAIN RULES
    ##RED_GREEN##
iptables -A redGreen -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A GreenRed -m state --state NEW,ESTABLISHED,RELATED  -j ACCEPT 

    ##RED_DMZ##
iptables -A redDmz -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A dmzRed -m state --state NEW,ESTABLISHED,RELATED  -j ACCEPT

    ##INET_GREEN##
iptables -A greenInet -m state --state NEW,ESTABLISHED,RELATE -j ACCEPT
iptables -A inetGreen -m state --state ESTABLISHED,RELATE -j ACCEPT

    ##INET_DMZ##
iptables -A inetDmz -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A dmzInet -m state --state ESTABLISHED,RELATED -j ACCEPT

    #NATTING
iptables -t nat -A PREROUTING -i eth0 --dport 80 -j DNAT --to-destination 172.16.0.2
iptables -t nat -A PREROUTING -i eth0 --dport 25 -j DNAT --to-destination 172.16.0.3
iptables -t nat -A PREROUTING -i eth0 --dport 23 -j DNAT --to-destination 172.16.2.3
iptables -t nat -A PREROUTING -i eth0 --dport 21 -j DNAT --to-destination 172.16.2.2