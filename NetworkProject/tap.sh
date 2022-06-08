#!/bin/bash

#creare l'interfaccia di rete tap0 (linux)
tunctl -g netdev -t tap0

#configurazione di tap0
ifconfig tap0 172.16.8.77 
ifconfig tap0 netmask 255.255.255.252
ifconfig tap0 broadcast 172.16.8.79

#attivazione scheda di rete
ifconfig tap0 up

#regole di firewalling per redirigere il traffico
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i tap0 -j ACCEPT

#abilita il forward su host locale
sysctl -w net.ipv4.ip_forward=1

#aggiungiamo la rotta verso gns3
route add -net 172.168.0.0/12 gw 172.168.8.78