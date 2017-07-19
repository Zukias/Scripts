#!/bin/bash
# AIM : Install symfony sur un serveur Ubuntu/Debian
# L'installation est fonctionnel sur un serveur fraichement installé
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

# Variables
script_name=$0

# Déclaration des fonctions
function echoPart() {
  echo "#######################################"
  echo "$1"
  echo "#######################################"
}

function throwError() {
  echo "Erreur $1";exit 1
}

function saut() {
  echo ""
}

function checkPackage() {
  if [[ ! $(apt list curl | grep $1) ]]; then
    apt install $1
  fi
}
####################################

# Test avant installation

# Si le script n'est pas exécuté en root, quitter l'installation
if [[ $UID != 0 ]]; then
  throwError "$script_name doit être lancé en tant que root."
fi

# Si aucune connexion internet n'est disponible, avertir l'utilisateur
cmd=$(ping -c 3 google.fr)
if [[ $? != 0 ]]; then
  throwError "Vérifer votre connexion internet --> 'ifconfig' and 'cat /etc/resolv.conf'"
fi

echo "#######################################"
echo "#        Installation de symfony      #"
echo "#######################################"
echo "Installation des dépendances"
saut
echo "Installation d'apache2..."
apt update
apt install apache2 -y
saut

echo "Installation de php..."
apt install php -y
saut

echo "Installation de php-xml..."
apt install php-xml -y
saut

echo "Installation de symfony"
mkdir -p /usr/local/bin
curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony
