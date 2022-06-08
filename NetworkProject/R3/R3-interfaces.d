auto eth0
iface eth0 inet static
    network 172.16.8.72/30
    netmask 255.255.255.252
    broadcast 172.16.8.75
    address 172.16.8.74
    gateway 172.16.8.73

auto eth1
iface eth1 inet static
    network 172.16.0.0/23
    netmask 255.255.254.0
    broadcast 172.16.1.255
    address 172.16.0.1

auto eth2
iface eth2 inet static
    network 172.16.2.0/23
    netmask 255.255.254.0
    broadcast 172.16.3.255
    address 172.16.2.1

#R3 --> TAP:
post-up route add -net 172.16.8.76/30 gw 172.16.8.73 dev eth0

#R3 --> RED
post-up route add -net 172.16.8.0/26 gw 172.16.8.73 dev eth0

#R3 --> CD2
post-up route add -net 172.16.8.64/30 gw 172.16.8.73 dev eth0

#R3 --> GREEN
post-up route add -net 172.16.4.0/22 gw 172.16.8.73 dev eth0

#R3 --> CD4
post-up route add -net 172.16.8.68/30 gw 172.16.8.73 dev eth0