#!/bin/bash

read -p 'Contra root? (toor) ? ' pwr
read -p 'Contra usuario01 (usuario-1) ? ' pwu

if [[ ! -d cosas/ ]]
then
	echo "Creando un directorio cosas para ti."
fi

if [[ -z $pwr ]]
then
	pwr=toor
fi

if [[ -z $pwu ]]
then
	pwu=usuario-1
fi

echo "d-i debian-installer/locale string es_ES.UTF-8
d-i localechooser/supported-locales multiselect es_ES.UTF-8
d-i keyboard-configuration/xkb-keymap select es
d-i keyboard-configuration/layoutcode string es
d-i console-setup/ask_detect boolean false

d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string debian-lab
d-i netcfg/get_domain string local
d-i netcfg/wireless_wep string

d-i mirror/country string ES
d-i mirror/http/hostname string ftp.es.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

d-i passwd/root-login boolean true
d-i passwd/root-password-crypted password $(mkpasswd $pwr)

d-i passwd/user-fullname string Usuario 01
d-i passwd/username string usuario01
d-i passwd/user-password-crypted password $(mkpasswd $pwu)
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

d-i clock-setup/utc boolean true
d-i time/zone string Europe/Madrid
d-i clock-setup/ntp boolean true

d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

tasksel tasksel/first multiselect standard, xfce-desktop
d-i pkgsel/include string openssh-server build-essential
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev string default
d-i finish-install/reboot_in_progress note" >> cosas/pre.cfg
