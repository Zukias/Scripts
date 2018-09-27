# Outil pour server Linux

## Les scripts

### new-server.sh

Permet de configurer de facon static la configuration reseau d'un server  : 

- IP
- Netmask
- Gateway
- DNS

Permet de renommer le serveur

- Hostname

#### Fonctionnement

Lancer le script 

`bash new-server.sh`

Puis repondre aux questions.

### init-devstack.sh

Permet de preparer le serveur pour l'installation openstack single VM via le script fourni sur le site Openstack.

#### Fonctionnement

Lancer le script puis executer cette commande 

`su stack -c bash /home/stack/devstack/stack.sh -l`
