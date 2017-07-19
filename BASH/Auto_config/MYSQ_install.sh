#!/bin/bash
# AIM : Installation d'un serveur de base de données MYSQL sur Ubuntu/Debian
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

# Check si le script est exécuté en tant que root
if [[ $UID != 0 ]]; then
	echo "Executer en tant que root";exit 1
fi

update()
{
	apt-get update -y
}

# Mot de passe
get_password() {
	read -sp "Mot de passe root MYSQL : " PASS1
	echo
	read -sp "Confirmer mot de passe : " PASS2
	echo
	if [[ $PASS1 != $PASS2 ]]; then
		echo "Les mots de passe ne corespondent pas"; exit 1
	fi
}

# Installation des dépendances
echo -e " Installation des dépendances ..."
echo -e " ... Update en cours"
update
echo
echo " Installation de debconf-utils en cours ..."
apt-get install debconf-utils -y && clear

# Variable d'environnement
export DEBIAN_FRONTED="nointeractive"

# Installation de mariadb-server
echo "Installation de mariadb-server en cours ...."
get_password

echo "mysql-server mysql-server/root_password password $PASS1" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $PASS1" | debconf-set-selections

apt-get install mysql-server -y