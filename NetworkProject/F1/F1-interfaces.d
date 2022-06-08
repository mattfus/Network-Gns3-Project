auto eth0
iface eth0 inet static
    network 172.16.8.76/30
    netmask 255.255.255.252
    broadcast 172.16.8.79
    address 172.16.8.78
    gateway 172.16.8.77

auto eth1
iface eth1 inet static 
    network 172.16.8.0/26
    netmask 255.255.255.192
    broadcast 172.16.8.63
    address 172.16.8.1

auto eth2
iface eth2 inet static
    network 172.16.8.64/30
    netmask 255.255.255.252
    broadcast 172.16.8.67
    address 172.16.8.65

#F1-->GREEN
post-up route add -net 172.16.4.0/22 gw 172.16.8.66 dev eth2

#F1-->CD4
post-up route add -net 172.16.8.68/30 gw 172.16.8.66 dev eth2

#F1-->CD5
post-up route add -net 172.16.8.72/30 gw 172.16.8.66 dev eth2

#F1-->DMZ
post-up route add -net 172.16.0.0/22 gw 172.16.8.66 dev eth2
