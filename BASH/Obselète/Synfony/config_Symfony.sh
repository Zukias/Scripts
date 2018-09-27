#!/bin/bash
# AIM : Configure un site pour dev sur symfony
# Il suffit simplement de répondre aux questions posé par le script
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

# Variables
script_name=$0
address_ip=$(hostname -I | cut -d " " -f 1)

function throwError() {
  echo "Erreur $1";exit 1
}

function saut() {
  echo
}

####################################

# Si le script n'est pas exécuté en root, quitter l'installation
if [[ $UID != 0 ]]; then
  throwError "$script_name doit être lancé en tant que root."
fi

# if [[ -f /usr/local/bin/symfony ]]; then
#   throwError "Symfony n'est pas installé. Veuillez exécuter 'install_symfony.sh avant'"
# fi

##################################
echo "#######################################"
echo "#        Configuration de symfony     #"
echo "#######################################"

saut
read -p "Nom du projet symfony : " PROJECTNAME
read -p "Emplacement du projet (par defaut /var/symfony/) [Entrer pour laisser par défaut]" PROJECTPATH
if [[ -z $PROJECTPATH ]]; then
  PROJECTPATH=/var/symfony/
fi

read -p "L'emplacement du projet sera $PROJECTPATH/$PROJECTNAME, cela  vous convient il ? [y/n] : " answer
if [[ $answer != y ]]; then
  echo "... Exit"; exit 1
fi

mkdir -p $PROJECTPATH/PROJECTNAME

saut

echo "Création du fichier de configuration apache dans /etc/apache2/sites-available/$PROJECTNAME.conf"
cat > /etc/apache2/sites-available/$PROJECTNAME.conf << EOF
<VirtualHost $address_ip:80>
  ServerName $address_ip
  DocumentRoot "$PROJECTPATH/$PROJECTNAME/"
  DirectoryIndex index.php
  <Directory "$PROJECTPATH/$PROJECTNAME/web/">
    AllowOverride All
    Allow from All
  </Directory>

   Alias /sf /usr/share/php/data/symfony/web/sf/
  <Directory "/usr/share/php/data/symfony/web/sf/">
    AllowOverride All
    Allow from All
  </Directory>
</VirtualHost>
EOF

saut
echo "Création du projet symfony"
symfony new $PROJECTPATH/$PROJECTNAME

saut
echo "Activation du paramètre du site..."
a2enmod rewrite && a2ensite $PROJECTNAME.conf && service apache2 reload
php /$PROJECTPATH/$PROJECTNAME/bin/console server:start 0.0.0.0:8000
saut

echo "Configuration du projet $PROJECTPATH/$PROJECTNAME au démarrage de la machine ..."
cat > /etc/apache2/sites-available/$PROJECTNAME.conf << EOF
# Symfony Projet au démarrage
php /$PROJECTPATH/$PROJECTNAME/bin/console server:start 0.0.0.0:8000

exit 0
EOF

echo "Récapitulatif : "
echo " - Accès au projet sur http://$address_ip:8000"
echo " - Emplacement physique du projet $PROJECTPATH/$PROJECTNAME"
saut
