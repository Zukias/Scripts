#!/bin/bash
# AIM : Install graylog sur Debian/Ubuntu 
# L'installation est fonctionnel sur un serveur fraichement installé
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

if [[ $UID != 0 ]]; then
	echo "Le script doit être exécuté en tant que root";exit 1
fi

echo "Installation des prérequis"
apt-get update && sudo apt-get upgrade -y
apt-get install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen -y

echo "Installation de MangoDB"
apt-get install mongodb-server -y 

echo "Préparation de l'installation de elasticsearch"
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update && sudo apt-get install elasticsearch -y

# Importation de la configuration
scp root@10.21.1.238:/etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/

# Redemarrage des services
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl restart elasticsearch.service

# Installation de Graylog
wget https://packages.graylog2.org/repo/packages/graylog-2.2-repository_latest.deb
dpkg -i graylog-2.2-repository_latest.deb
apt-get update && sudo apt-get install graylog-server

# Importation de la configuration
scp root@10.21.1.238:/etc/graylog/server/server.conf /etc/graylog/server/

# Redemarrage des services
systemctl daemon-reload
systemctl enable graylog-server.service
systemctl start graylog-server.service