# AIM : Copie la base Firebird de Cegid dans l'environnement de developpement pour Florent
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

Copy-Item -Path "\\SRV21800T\Firebird\bin\pmi.fdb" -Destination "\\SRV21800T\User\Developpement\CegidPMI_Database_Dev\"