#!/bin/bash


urlv="https://github.com/ventoy/PXE/releases/download/v1.0.21/iventoy-1.0.21-linux-free.tar.gz"
urli="https://???????/mx.iso" # CAMBIAME CUANDO VAYAS A PRESENTAR

wget $urlv -O iventoy.tar.gz

tar xvf iventoy.tar.gz

cd iventoy-*

# No se puede hacer nada por configurarlo. El usuario tiene que hacer todo.

./iventoy.sh start

read -p "Ahora ve a la direccion que se te indica arriba desde otro navegador. Configura el modo a \"external\". Cuando este listo, activa la red que se vaya a activar (10.0.0.1), cuando todo este, pulsa enter aqui"

echo "next-server 10.0.0.1;" >> /etc/dhcp/dhcpd.conf
echo "filename \"iventoy_loader_16000\";" >> /etc/dhcp/dhcpd.conf # El 17000 no funciona, por mucho que lo configures.

systemctl restart isc-dhcp-server

if [[ -f 'mx.iso' ]]
then
	mv ../mx.iso iso/mx.iso
else
	wget $urli -O iso/mx.iso
fi
