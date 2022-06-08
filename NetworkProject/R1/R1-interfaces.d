auto eth0
iface eth0 inet static
    network 172.16.8.68/30
    netmask 255.255.255.252
    broadcast 172.16.8.71
    address 172.16.8.69

auto eth1
iface eth1 inet static 
    network 172.16.4.0/23
    netmask 255.255.254.0
    broadcast 172.16.5.255
    address 172.16.4.1

auto eth2
iface eth2 inet static
    network 172.16.6.0/24
    netmask 255.255.255.0
    broadcast 172.16.6.255
    address 172.16.6.1

auto eth3
iface eth3 inet static
    network 172.16.8.64/30
    netmask 255.255.255.252
    broadcast 172.16.8.67
    address 172.16.8.66
    gateway 172.16.8.65

#R1-->TAP
post-up route add -net 172.16.8.76/30 gw 172.16.8.65 dev eth3

#R1-->RED
post-up route add -net 172.16.8.0/26 gw 172.16.8.65 dev eth3

#R1-->CD5
post-up route add -net 172.16.8.72/30 gw 172.16.8.70 dev eth0

#R1-->DMZ
post-up route add -net 172.16.0.0/22 gw 172.16.8.70 dev eth0