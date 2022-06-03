# Network-Gns3-Project
Small Gns3 network project for University purpose.

<h1> AREAS</h1>

 - DMZ => 2; 
 - RED => 1;
 - GREEN => 2;

<h2>COLLISION DOMAINS AND NETMASKS</h2>
 <b> COLLISION DOMAINS </b>
    formula: <code>NETMASK = 32 - x (2^x >= minIP+2)</code>
    
    -> CD1 (RED): minIP= 33+2 MASK/26
        (2^x >= 35) => x=6

    -> CD2 (Link to Link): minIP=2+2 MASK/30
        (2^x >= 4) => x=2

    -> CD4 (Link to Link): minIP=2+2 MASK/30
        (2^x >= 4) => x=2

    -> CD5 (Link to Link): minIP=2+2 MASK/30
        (2^x >= 4) => x=2

    -> CD6 (DMZ): minIP= 504+2 MASK/23
        (2^x >= 506) => x=9

    -> CD7 (DMZ): minIP= 353+2 MASK/23
        (2^x >= 355) => x=9

    -> CD8 (GREEN): minIP= 409+2 MASK/23
        (2^x >= 411) => x=9

    -> CD9 (GREEN): minIP= 209+2 MASK/24
        (2^x >= 211) => x=8

    -> CDTAP (Internet): minIP= 2+2 MASK/30
        (2^x >= 4) => x=2

*RIORDINIAMO PER DOMINI DI COLLISIONE DELLO STESSO TIPO*

*NEED TO SORT CDs BY TYPE*

    *Non è possibile accorpare aree uguali appartenenti a firewall/router diversi*
    *perchè non è possibile avere una rotta sola per due router diversi*
    
    *It's not possible to unify same areas belonging different firewalls/routers*
    *becouse we can't have the one route to different routers*

    CD_RED MASK 26
        ->CD1 /26
    
    CD_GREEN MASK 22
        ->CD8 /23
        ->CD9 /24
    
    CD_DMZ MASK 22
        ->CD6 /23
        ->CD7 /23

    CD2 (Link to Link) -> minIP 2 MASK/30
    CD4 (Link to Link) -> minIP 2 MASK/30
    CD5 (Link to Link) -> minIP 2 MASK/30
    TAP (Internet)   -> minIP 2 MASK/30

*MACRODOMINI - ACCORPAMENTI - RIORDINO PER MASCHERA*

*MACRODOMAINS/UNIFICATIONS - SORT BY NETMASK*

        CD_DMZ: 22
           CD6: /23
           CD7: /23
        
        CD_GREEN: 22
            CD8: /23
            CD9: /24

        CD_RED: 26
            CD1: 26



*ASSEGNAMENTO DEGLI INDIRIZZI IP ALLE SUBNET CON RETE TIPO B (172.16.0.0/12)*

*ALLOCATING IP ADDRESSES TO SUBNET -> NETWORK TYPE: B (172.16.0.0/12)*


    *AREA DMZ*
   
        CD6: MASK/23 172.16.0.0
            network: 172.16.0.0/23
            netmask: 23 -> 255.255.254.0
            broadcast: 172.16.1.255

        CD7: MASK/23 172.16.2.0
            network: 172.16.2.0/23
            netmask: 23 -> 255.255.254.0
            broadcast: 172.16.3.255

        CD_DMZ: MASK/22 172.16.0.0
            network: 172.16.0.0/22
            netmask: 22 -> 255.255.252.0 
            broadcast: 172.16.3.255 </code>
    
    
    *AREA GREEN*

        CD8: MASK/23 172.16.4.0
            network: 172.16.4.0/23
            netmask: 23 -> 255.255.255.254
            broadcast: 172.16.5.255

        CD9: MASK/24 172.16.6.0
            network: 172.16.6.0/24
            netmask: 24 -> 255.255.255.0
            broadcast: 172.16.6.255

        CD_GREEN: MASK/22 172.16.4.0
            network: 172.16.4.0/22
            netmask: 22 -> 255.255.252.0
            broadcast: 172.16.7.255

    *AREA RED*

        CD1: MASK/26 172.16.8.0
            network: 172.16.8.0/26
            netmask: 26 -> 255.255.255.192
            broadcast: 172.16.8.63

    *AREA CD2*

            network: 172.16.8.64/30
            netmask: 30 -> 255.255.255.252
            broadcast: 172.16.8.67

    *AREA CD4*

            network: 172.16.8.68/30
            netmask: 30 -> 255.255.255.252
            broadcast: 172.16.8.71

    *AREA CD5*

            network: 172.16.8.72/30
            netmask: 30 -> 255.255.255.252
            broadcast: 172.16.8.75

    *AREA TAP*

            network: 172.16.8.76/30
            netmask: 30 -> 255.255.255.252
            broadcast: 172.16.8.79

*<h2>CALCOLO DELLE ROTTE</h2>*
*<h2>ROUTING</h2>*

       COMANDO: route add -net x.x.x.x/mask gw x.x.x.x dev eth0
       Cmd : route add -net network/mask gw(gateway) x.x.x.x dev(ice) eth0

    *ROTTE DI F1*
            F1 --> GREEN: route add -net 172.16.4.0/22 gw 172.16.8.66 dev eth2
            F1 --> CD4: route add -net 172.16.8.68/30 gw 172.16.8.66 dev eth2
            F1 --> CD5: route add -net 172.16.8.72/30 gw 172.16.8.66 dev eth2
            F1 --> DMZ: route add -net 172.16.0.0/22 gw 172.16.8.66 dev eth2

    *ROTTE DI R1*
            R1 --> TAP: route add -net 172.16.8.76/30 gw 172.16.8.65 dev eth3
            R1 --> RED: route add -net 172.16.8.0/26 gw 172.16.8.65 dev eth3
            R1 --> CD5: route add -net 172.16.8.72/30 gw 172.16.8.70 dev eth0
            R1 --> DMZ: route add -net 172.16.0.0/22 gw 172.16.8.70 dev eth0

    *ROTTE DI F2*
            F2 --> TAP: route add -net 172.16.8.76/30 gw 172.16.8.69 dev eth0
            F2 --> RED: route add -net 172.16.8.0/26 gw 172.16.8.69 dev eth0
            F2 --> CD2: route add -net 172.16.8.64/30 gw 172.16.8.69 dev eth0
            F2 --> GREEN: route add -net 172.16.4.0/22 gw 172.16.8.69 dev eth0
            F2 --> DMZ: route add -net 172.16.0.0/22 gw 172.16.8.74 dev eth1

    *ROTTE DI R3*
            R3 --> TAP: route add -net 172.16.8.76/30 gw 176.16.8.73 dev eth0
            R3 --> RED: route add -net 172.16.8.0/26 gw 176.16.8.73 dev eth0
            R3 --> CD2: route add -net 172.16.8.64/30 gw 176.16.8.73 dev eth0
            R3 --> GREEN: route add -net 172.16.4.0/22 gw 176.16.8.73 dev eth0
            R3 --> CD4: route add -net 172.16.8.68 gw 176.16.8.73 dev eth0
