#!/bin/bash
clear
ROUGE='\033[0;31m'
VERT='\033[0;32m'
NC='\033[0m'
echo "+---------------------------------+"
echo "|        Teste d'IP en ICMP       |"
echo "+---------------------------------+"
echo "Veuillez saisir une IP :"
read ip

if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "Envoi de la requête ICMP en cours.."

	if ping -c 1 -W 1 "$ip" &> /dev/null; then
        echo -e "${VERT}L'adresse $ip répond !${NC}"
	else
        echo -e "${ROUGE}L'adresse $ip ne répond pas !${NC}"
	fi
else
	echo "Veuillez saisir une IP dans un format valide !"
	echo "(ex: 192.x.x.x // 172.x.x.x // 10.x.x.x)"
	sleep 3
	clear
	./testIP.sh
fi
