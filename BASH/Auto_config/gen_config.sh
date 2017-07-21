#!/bin/bash

# AIM : Configuration automatique d'une nouvelle machine Debian ou Ubuntu
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

interface=
address_ip=
curent_hostname=
new_hostname=

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
        netmask 255.255.0.0
        gateway 10.21.1.254
        dns-nameservers 10.21.1.208
        dns-domain aerauliq.dom
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
	echo
	read -p "Ces informations sont elles correctes ? [y/n] :" answer
	if [[ $answer = "y" ]]; then
		set_hostname
		set_ip	
		update
	else echo "Exit ..."; exit 1
	fi

}

install_symfony()
{
	bash <(curl -s http://css-docker:8080/scripts/Scripts/BASH/Synfony/install_Symfony.sh)
	bash <(curl -s http://css-docker:8080/scripts/Scripts/BASH/Synfony/config_Symfony.sh)

}

install_mysql_server()
{
	bash <(curl -s http://css-docker:8080/scripts/Scripts/BASH/Auto_config/MYSQ_install.sh)
}

install_menu()
{
	read -p "Installer des programmes ? [y/n] : " answer
	if [[ $answer = "y" ]]; then
		while [[ $opt != q ]]; do
			echo "##### Menu d'installation #####"
			echo " 	1 - Installer et configurer un projet symfony"
			echo "	2 - Installer mysql server"
			echo "	3 - Redémarrer le serveur après installation"
			echo "	q - Quitter"

			read -p "Que souhaitez vous installer ? : " opt

		        case $opt in
		                1)
		                        install_symfony
		                        ;;
		                2)
		                        install_mysql_server
		                        ;;
		                3)
		                        reboot
		                        ;;
		                q)
		                        echo "... Exit";break
		                        ;;
		                *)
		                        echo "... Invalid option";;
		        esac
		done
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
setup

install_menu
