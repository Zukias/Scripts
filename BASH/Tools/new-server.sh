#!/bin/bash

# AIM : Configuration automatique d'une nouvelle machine Debian ou Ubuntu
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : 27/10/2918

interface=
address_ip=
curent_hostname=
new_hostname=
netmask=
gateway=
dns_server=

# Fonction test exécution commande précédente
test_command()
{
	if [[ $? = 0 ]]; then
	echo "... Done"
	else echo " ... Error";exit 1
	fi
}

get_interface_name()
{
	interface=$(ip -o -4 route show to default | awk '{print $5}')
}

get_ip()
{
	echo
	echo "##### Nouvel configuration réseau #####"
	echo "!! Choisir une plage entre 10.21.1.200-10.21.1.XXX"
	read -p "Adresse IP (exemple 10.21.1.220) : " address_ip
}

get_netmask()
{
	echo
	read -p "Nouveau masque de sous réseau : " netmask
}

get_gateway()
{
	echo
	read -p "Nouveau @ de passerelle réseau : " gateway
}

get_dns()
{
	echo
	read -p "Nouveau @ serveur dns (1seul) : " dns_server
}

# Fonction permettant de générer une nouvelle configuration IP
set_ip() 
{
echo "Génération de la configuration réseau..."
get_interface_name
cat > /etc/network/interfaces << OEF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).
source /etc/network/interfaces.d/*
# The loopback network interface
auto lo
iface lo inet loopback
# The primary network interface                                              
auto $interface
iface $interface inet static
        address $address_ip
        netmask $netmask
        gateway $gateway
        dns-nameservers $dns_server
OEF

	test_command

	# Redémarrage des interfaces
	echo "Redémarrage des interfaces ..."
	ifdown $interface && ip addr flush $interface &&ifup $interface
	test_command
}

get_hostname()
{
	echo
	echo "##### Nouveau nom de serveur #####"
	curent_hostname=$(cat /etc/hostname)
	read -p "Nom du serveur : " new_hostname
}

# Configure un nouveau nom de machine
set_hostname() 
{
	echo "Génération du nouveau nom ..."
	sed -i "s/$curent_hostname/$new_hostname/g" /etc/hostname /etc/hosts
	test_command
}

# Mise à jour du système
update() 
{
	echo
	echo "##### Mise à jour #####"
	cmd=$(ping -c 3 google.fr)
	if [[ $? = 0 ]]; then
		apt-get update -y && apt-get upgrade -y
	fi
}

dependancies()
{
	apt-get install curl -y
}

# Récapitulatif des modifications
setup()
{
	echo "Hostname : $new_hostname"
	echo "Adresse IP du serveur : $address_ip"
	echo "Netmask : $netmask"
	echo "Gateway : $gateway"
	echo "Server DNS : $dns_server"
	echo
	read -p "Ces informations sont elles correctes ? [y/n] :" answer
	if [[ $answer = "y" ]]; then
		set_hostname
		set_ip
		update
	else echo "Exit ..."; exit 1
	fi

}


# Début script
clear
echo "#######################################"
echo "###### Configuration automatique ######"
echo "#######################################"

get_hostname
get_ip
get_netmask
get_gateway
get_dns
setup
