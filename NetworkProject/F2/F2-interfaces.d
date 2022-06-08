auto eth0
iface eth0 inet static
    network 172.16.8.68/30
    netmask 255.255.255.252
    broadcast 172.16.8.71
    address 172.16.8.70
    gateway 172.16.8.69

auto eth1
iface eth1 inet static
    network 172.16.8.72/30
    netmask 255.255.255.252
    broadcast 172.16.8.75
    address 172.16.8.73

#F2-->TAP
post-up route add -net 172.16.8.76/30 gw 172.16.8.69 dev eth0

#F2-->RED
post-up route add -net 172.16.8.0/26 gw 172.16.8.69 dev eth0

#F2-->CD2
post-up route add -net 172.16.8.64/30 gw 172.16.8.69 dev eth0

#F2--> GREEN
post-up route add -net 172.16.4.0/22 gw 172.16.8.69 dev eth0

#F2-->DMZ
post-up route add -net 172.16.0.0/22 gw 172.16.8.74 dev eth1
