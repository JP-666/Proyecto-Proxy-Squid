#!/bin/bash
# Cambia cosas para ajustarse a los requisitos

IP=192.168.1.1
NETWORK=192.168.1.0
INICIAL=192.168.1.50
FINAL=192.168.1.250
NETMASK=255.255.255.0
BROAD=192.168.1.255


sed "s/10.0.0.1/$IP/g" < cosas/interfaces > cosas/interfaces.custom




echo "ddns-update-style none;" > cosas/dhcp.custom
echo "default-lease-time 600;" >> cosas/dhcp.custom
echo "max-lease-time 7200;" >> cosas/dhcp.custom
echo "authoritative;" >> cosas/dhcp.custom


sed "s/subnet 10.0.0.0 netmask 255.255.255.0/subnet $NETWORK netmask $NETMASK/g" < cosas/dhcp | grep subnet >> cosas/dhcp.custom
echo "	option domain-name-servers 8.8.8.8, 8.8.4.4;" >> cosas/dhcp.custom
echo "	option domain-name redinsti;" >> cosas/dhcp.custom
sed "s/range 10.0.0.100 10.0.0.200/range $INICIAL $FINAL/g" < cosas/dhcp | grep range >> cosas/dhcp.custom
sed "s/option routers 10.0.0.1/option routers $IP/g" < cosas/dhcp | grep routers >> cosas/dhcp.custom
sed "s/option broadcast-address 10.0.0.255/option broadcast-address $BROAD/g" < cosas/dhcp | grep broadcast >> cosas/dhcp.custom
echo "	default-lease-time 600;" >> cosas/dhcp.custom
echo "	max-lease-time 7200;" >> cosas/dhcp.custom
echo "}" >> cosas/dhcp.custom

