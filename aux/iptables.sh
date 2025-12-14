#!/bin/bash
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
if [[ ! $profesores == "no" ]]
then
	echo "Los profesores pasaran por el proxy"
	iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j REDIRECT --to-port 3128
	iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j REDIRECT --to-port 3129
fi
echo "Los profesores NO pasaran por el proxy"

echo "Añadiendo red 1..."
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s9 -p tcp --dport 443 -j REDIRECT --to-port 3129
echo "Añadiendo red 2..."
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -A PREROUTING -i enp0s10 -p tcp --dport 443 -j REDIRECT --to-port 3129
echo "Reiniciando"
netfilter-persistent save
