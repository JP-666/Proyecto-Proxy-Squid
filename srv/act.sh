cd /srv

cat > /etc/network/interfaces << EOF
auto lo
iface lo inet loopback

auto eth1
iface eth1 inet static
  address $1/24
  netmask 255.255.255.0

auto eth0
iface eth0 inet dhcp
EOF

reboot # Con el servicio valdria, pero asi estamos 100% seguros de no romper nada
