#!/bin/bash
clear
echo "### Installation des regles IPTables de CentOS 7"
echo " "
echo " "
echo "Vérification de l'installation de IPTables et retrait de Firewall Daemon"
yum -y -q remove firewalld
yum -y -q install iptables iptables-services
while true; do
    read -p "Utilisez-vous un serveur FTP?" yn
    case $yn in
        [YyOo]* ) 
			echo "### Port 20,21 ouverts (FTP)..."
			iptables -A INPUT -p tcp -m tcp --dport 20 -j ACCEPT
			iptables -A INPUT -p udp -m udp --dport 20 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 21 -j ACCEPT
			iptables -A INPUT -p udp -m udp --dport 21 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
echo "### Port 22 ouvert (SSH)..."
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
while true; do
    read -p "Utilisez-vous un serveur DNS?" yna
    case $yna in
        [YyOo]* ) 
			echo "### Port 53 ouvert (DNS)..."
			iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
			iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
while true; do
    read -p "Utilisez-vous un serveur Web?" ynb
    case $ynb in
        [YyOo]* ) 
			echo "### Port 80,443 ouverts (HTTP/HTTPS)..."
			iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done


while true; do
    read -p "Utilisez-vous un serveur SMTP/POP?" ync
    case $ync in
        [YyOo]* ) 
			echo "### Port 25,110,143,587,993,995 ouverts (SMTP/POP normal et TLS)..."
			iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 587 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done

while true; do
    read -p "Utilisez-vous un serveur SHOUTCast ou compatible (port 8000/8001) ?" ynd
    case $ynd in
        [YyOo]* ) 
			echo "### Port 8000,8001 ouverts (SHOUTCats)..."
		iptables -A INPUT -p udp -m tcp --dport 8000 -j ACCEPT
		iptables -A INPUT -p udp -m tcp --dport 8001 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done

while true; do
    read -p "Utilisez-vous un serveur Red5/Flash ou compatible (port 19132) ?" yne
    case $yne in
        [YyOo]* ) 
			echo "### Port 19132 ouverts (Red5/Flash)..."
			iptables -A INPUT -p udp -m udp --dport 19132 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 19132 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done


while true; do
    read -p "Utilisez-vous le gestionnaire Webmin/Virtualmin ?" ynf
    case $ynf in
        [YyOo]* ) 
			echo "### Port 10000,20000 ouverts (Webmin/Virtualmin)..."
			iptables -A INPUT -p tcp -m tcp --dport 20000:20010 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 10000:10010 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 20000:20010 -j ACCEPT
			iptables -A INPUT -p tcp -m tcp --dport 10000:10010 -j ACCEPT
			break;;
        [Nn]* ) break;;
        * ) echo "Entrer Y pour oui ou N pour non.";;
    esac
done
echo "### Acceptes les connexions locales, ICMP et connexions établis..."
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m state -m tcp --dport 22 --state NEW -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
echo "### Sauvegarde de la configuration..."
iptables-save
echo "### Configuration terminé et sauvegardé"
