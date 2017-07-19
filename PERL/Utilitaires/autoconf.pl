#!/usr/bin/perl
# AIM : Auto configuration machine Debian / Ubuntu
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

use strict;
use warnings;

my $version = "0.2";
my $host ;
print "Nom du serveur : " ;
$host=<STDIN> ;
chomp ($host) ;

my $ip ;
print "Adresse IP : " ;
$ip=<STDIN> ;
chomp ($ip) ;

my $mask ;
print "Masque reseau : " ;
$mask=<STDIN> ;
chomp ($mask) ;

my $gw ;
print "Passerelle par defaut : " ;
$gw=<STDIN> ;
chomp ($gw) ;

my $dns1 ;
print "DNS primaire : " ;
$dns1=<STDIN> ;
chomp ($dns1) ;

my $domain ;
print "Domaine : " ;
$domain=<STDIN> ;
chomp ($domain) ;

# les paquets a installer
my $packages ;
print "Selection les paquets à installer (bout à bout séparer par un \";\") : " ;
$packages=<STDIN> ;
chomp ($packages) ;

#AIM : Fonction putconf : Ecrit une configuration dans un fichier spécifié
#PARAMS : Chemin du fichier, contenue du fichier
#RETURN : None
sub putconf {
        my ($file, $msg)= @_;
        print "Generation du fichier $file ...\n";
        my $dat = `date`;
        open (FILE, ">$file") or die "Erreur ecriture fichier $file : $! \n";
        print FILE "### $version - putconf - $dat" if ($file ne "/etc/hostname") ;
        print FILE $msg;
        close FILE;
};

system "aptitude install $packages" if ($packages);

putconf("/etc/hostname", "$host\n");

putconf ("/etc/hosts",
"127.0.0.1      localhost.localdomain localhost
127.0.1.1       $host
$ip     $host.$domain $host
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
"
);

putconf ("/etc/network/interfaces",
"
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
        address $ip
        netmask $mask
        gateway $gw
"
);

putconf ("/etc/resolv.conf",
"domain $domain
nameserver $dns1
"
);
