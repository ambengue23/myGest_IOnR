#!/bin/bash
clear
ROUGE='\033[0;31m'
VERT='\033[0;32m'
JAUNE='\033[0;33m'
NC='\033[0m'
echo "+----------------------------------------------+"
echo "|        Test d'IP actives depuis la BDD       |"
echo "+----------------------------------------------+"
#authentification et verif
read -p "Nom d'utilisateur de MySQL : " usr
read -s -p "Veuillez saisir le mot de passe : " mdp
echo ""
echo -e "${JAUNE}Vérification de l'authentification..${NC}"
sleep 2
mysql -u "$usr" -p"mdp" -e "exit" 2>/dev/null
if [ $? -ne 0 ]; then
	echo -e "${ROUGE}Identifiant incorrect ou inéxistant, veuillez recommencez.${NC}"
	exit 1
fi
echo -e "${VERT}Authentification réussie !${NC}"
sleep 1
clear


#Interaction utilisateur bdd
mysql -u $usr -p'$mdp' -e "show databases;"
echo "Dans quelle BDD se trouvent vos adresses IP :"
read chdb
db_exist=$(mysql -u $usr -p'$mdp' -se "show databases like '$chdb';")
if [[ -z "$db_exist" ]];then
	echo -e "${ROUGE}Erreur${NC}, la base de donnée ${JAUNE}$chdb${NC} n'existe pas."
	echo "Veuillez saisir une table existante."
	exit 1
else
	mysql -u $usr -p'$mdp' -e "use $chdb;" -e "show tables;"
	echo "Dans quelle Tablese trouvent vos adresses IP :"
	read chtable
	tb_bexist=$(mysql -u $usr -p'$mdp' -D"$chdb" -se "show tables like '$chtable';")
	if [[ -z "$tb_bexist" ]];then
		echo -e "${ROUGE}Erreur${NC}, la table ${JAUNE}$chtable${NC} n'existe pas dans ${JAUNE}$chdb${NC}."
		echo "Veuillez saisir une table existante."
		exit 1
	else
		mysql -u $usr -p'$mdp' -e "use $chdb;" -e "select * from $chtable;"
		#exportation des noms et ip en fichier txt
		echo "Veuillez sélectionnez les colonnes contenant les noms et adresses IP (séparées par des virgules) :"
		read chx
		export="IPchk.txt"
		mysql -u $usr -p'$mdp' -e "use $chdb;" -e "select $chx from $chtable;" > $export
		sleep 2
		clear
		echo -e "${VERT}Exportation réussie.${NC}"
		sleep 1
		echo "Voici les éléments exportés :"
		cat $export
		sleep 3
		clear
		echo "Test des IP en cours..."
		sleep 1
		while read nom ip; do
			if [[ "$nom" == "nom" && "$ip" == "adIP" ]]; then
				continue
			fi
				if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
			        if ping -c 1 -W 1 $ip &> /dev/null; then
		            	echo -e "$nom : $ip : ${VERT}active${NC}"
					else
						echo -e "$nom : $ip : ${ROUGE}inactive${NC}"
					fi
				else
					echo "Adresse IP invalide détectée pour $nom : '$ip'"
				fi
	done < "$export"
	sleep 0.5
	echo "----------------"
	echo "Vérification terminée."
	rm IPchk.txt
	fi
fi