#!/bin/bash
clear
ROUGE='\033[0;31m'
VERT='\033[0;32m'
JAUNE='\033[0;33m'
NC='\033[0m'
echo "+---------------------------------------------------+"
echo "|        Teste de port en TCP ouvert d'une IP       |"
echo "+---------------------------------------------------+"
echo "Veuillez saisir une IP :"
read ip
#verif de l'ip (son format)
if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	if ping -c 1 -W 1 $ip &> /dev/null; then
	    echo -e "$ip : ${VERT}active${NC}"
		echo "Veuillez saisir un port :"
		read port
		#verif du port (si compris entre 1 et 65535)
		if [[ "$port" =~ [0-9]+$ ]] && [[ "$port" -gt 1 ]] && [[ "$port" -lt 65535 ]]; then
			echo "Envoi de la requête TCP en cours..."
			sleep 1.5
			echo "Veuillez attendre."
			#avec open, renvoi 0 et le port est ouvert, 1 si il est fermer grace a 2>&1
			if nc -zv $ip $port 2>&1 | grep -q "open"; then
				echo -e "Le port $port de la machine $ip est ${VERT}OUVERT${NC}." #echo -e avec les variables ${COULEUR}texte
			else
				echo -e "Le port $port de la machine $ip est ${ROUGE}FERME${NC}."
			fi
		else
			echo "Veuillez saisir un port valide compris entre 1 et 65535 !"
			sleep 3
			clear
			exit 1
		fi
	else
		echo -e "$ip : ${ROUGE}inactive${NC}, aucune vérifications de peut être effectuée."
	fi
	
else
	echo "Veuillez saisir une IP dans un format valide !"
	echo "(ex: 192.x.x.x // 172.x.x.x // 10.x.x.x)"
	sleep 3
	clear
	exit 1
fi

