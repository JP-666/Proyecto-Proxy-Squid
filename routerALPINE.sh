#!/bin/ash
# Alpine NO recomienda ejecutar sistemas dedicados como no-superusuario. Se asume que estas haciendolo todo con/como superusuario. 
# Alpine usa "ash", no "bash", esto funciona, punto.

######## Cambia esto si lo necesitas ########

interfaz_fuera=eth0
interfaz_interna=eth1

#############################################







######## REDES ########

cat > /etc/network/interfaces << EOF

auto lo
iface lo inet loopback

auto eth1
iface eth1 inet static
	address 10.0.0.1
	network 10.0.0.0
	netmask 255.255.255.0
	broadcast 10.0.0.255

auto eth0
iface eth0 inet dhcp
# Consideramos que nuestra maquina recibe IP dinamica de fuera, del host


EOF
######################







######## DNS ########
echo "10.0.0.1 router.local" > /etc/hosts.dnsmasq
echo "10.0.0.1 routerdentro.local" >> /etc/hosts.dnsmasq
#####################





######## DHCP ########
cat > /etc/dnsmasq.conf << EOF
addn-hosts=/etc/hosts.dnsmaq # Esto es para decirle que somos router.local y routerdentro.local
conf-dir=/etc/dnsmasq.d/,*.conf
dhcp-range=10.0.0.10,10.0.0.250,255.255.255.0
dhcp-option=option:router,10.0.0.1
dhcp-option=option:dns-server,8.8.8.8

EOF
######################









######## Cosas de los ajustes del sistema ########
echo "net.ipv4.ip_forward=1" | tee /etc/sysctl.conf

# Cuidado! Que esto borra todo el contenido de systctl.conf
# Pero bueno, como se va a hacer en una maquina Alpine limpia, no importa.

sysctl -p
# Carga la nueva configuracion de systctl de los ajustes
##################################################








######## Instalaciones ########
apk add iptables dnsmasq
# Para poder enviar y recibir
###############################






######## Activar ########
rc-update add iptables
rc-update add dnsmasq
# Esto vendria a ser 'systemctl enable --now iptables'
#########################






#############################################
###########PARTE DEL IPTABLES################
#############################################
iptables -A FORWARD -i $interfaz_interna -j ACCEPT
# Cualquier cosa que SALGA, aceptamos
iptables -t nat -A POSTROUTING -o $interfaz_fuera -j MASQUERADE
# Traducimos la IP de dentro a fuera
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.5:3128
# Cualquier cosa que venga en el pre-routing, lo pasamos a 10.0.0.5:3128
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.5:3128
# Tambien, pero por el puerto 80 para trafico no seguro.
/etc/init.d/iptables save
# Esto no deberia hacer falta?
#############################################
#############################################
#############################################
#############################################






######## Y ya, por ultimo, recargamos las redes y... Tachan! ########

rc-service networking restart

#####################################################################
