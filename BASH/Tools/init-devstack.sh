#!/bin/bash

# AIM : Configuration des prérequis pour déploiement Devstack sur serveur de test Ubuntu 16.04
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None


# On installe les prérequis
apt-get -qqy update
sudo apt-get install git -qqy

# On créer l'utilisateur stack qui executera l'installation
useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cd /opt/stack/
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
echo '[[local|localrc]]' > local.conf
echo ADMIN_PASSWORD=password >> local.conf
echo DATABASE_PASSWORD=password >> local.conf
echo RABBIT_PASSWORD=password >> local.conf
echo SERVICE_PASSWORD=password >> local.conf
chown stack:stack /opt/stack/devstack
su stack

#Pour cette parti, le faire à la main en tant que root :

#su stack 
#bash /opt/stack/devstack/stack.sh