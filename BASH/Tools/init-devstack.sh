#!/bin/bash

# AIM : Configuration des prérequis pour déploiement Devstack sur serveur de test Ubuntu 16.04
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None


# On installe les prérequis
apt-get -qqy update
sudo apt-get install git -qqy

# On créer l'utilisateur stack qui executera l'installation
useradd -m stack
chown stack:stack /home/stack
cd /home/stack
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
echo '[[local|localrc]]' > local.conf
echo ADMIN_PASSWORD=password >> local.conf
echo DATABASE_PASSWORD=password >> local.conf
echo RABBIT_PASSWORD=password >> local.conf
echo SERVICE_PASSWORD=password >> local.conf


chmod 0755 /home/stack/devstack/stack.sh

#Pour cette parti, le faire à la main en tant que root :

#su stack -c bash /home/stack/devstack/stack.sh -l