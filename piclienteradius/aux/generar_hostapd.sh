#!/bin/bash

if [[ ! -d cosas ]]
then
	mkdir -p cosas
fi

if [[ -f cosas/hostapd.conf ]]
then
	echo
	echo "(!) YA EXISTE UN ARCHIVO HOSTAPD.CONF EN LA CARPETA COSAS"
	echo
fi

read -p "¿IP del servidor? (172.16.1.1) ?> " ipradius
read -p "¿Contraseña de RADIUS? (skibidi69) ?> " cont
read -p "¿Interfaz de WiFi? (wlan0) ?> " int
read -p "¿Nombre de la red? (WiFi Alumnos) ?> " red




if [[ -z $ipradius ]]
then
	ipradius=172.16.1.1
fi

if [[ -z $cont ]]
then
	cont="skibidi69"
fi

if [[ -z $int ]]
then
	int=wlan0
fi

if [[ -z $red ]]
then
	red="WiFi Alumnos"
fi





echo "
interface=$int
driver=nl80211
ssid=$red
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
country_code=ES
wpa=2
wpa_key_mgmt=WPA-EAP
rsn_pairwise=CCMP
auth_server_addr=$ipradius
auth_server_port=1812
auth_server_shared_secret=$cont
ieee8021x=1
" > cosas/hostapd.conf
