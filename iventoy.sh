#!/bin/bash


urlv="https://github.com/ventoy/PXE/releases/download/v1.0.21/iventoy-1.0.21-linux-free.tar.gz"
urli="https://???????/mx.iso"


echo "Ahora se empezara a descargar MX en segundo plano"
wget $urli &

wget $urlv -O iventoy.tar.gz

tar xvf iventoy.tar.gz

cd iventoy-*


echo "{
  \"dhcp_mode\": 1,
  \"server_ip\": \"192.168.1.50\",
  \"pxe_port\": 16000,
  \"http_port\": 17000
}" > data/config.json


./iventoy start

read -p "Ahora ve a la direccion que se te indica arriba desde otro navegador. Configura el modo a \"external\". Cuando este listo, activa la red que se vaya a activar (10.0.0.1), cuando todo este, pulsa enter aqui"

echo "next-server 10.0.0.1;" >> /etc/dhcp/dhcpd.conf
echo "filename \"iventoy_loader_17000\";" >> /etc/dhcp/dhcpd.conf


systemctl restart isc-dhcp-server

cp ../mx.iso iso/
