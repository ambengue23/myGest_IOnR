#!/bin/bash
clear
ROUGE='\033[0;31m'
VERT='\033[0;32m'
JAUNE='\033[0;33m'
NC='\033[0m'
echo "+--------------------------------------------------+"
echo "|        Générateur de fichier depuis la BDD       |"
echo "+--------------------------------------------------+"
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
echo "Depuis quelle BDD souhaitez-vous exporter des informations :"
read chdb
mysql -u $usr -p'$mdp' -e "use $chdb;" -e "show tables;"
echo "Depuis quelle Table souhaitez-vous exporter des informations :"
read chtable
mysql -u $usr -p'$mdp' -e "use $chdb;" -e "select * from $chtable;"


#exportation des données en fichier txt
echo "Quelles colonnes souhaitez-vous exporter (séparées par des virgules ou * pour tout) :"
read chx
export="archiveDB_$(date +%Y-%m-%d_%H-%M-%S).txt"
mysql -u $usr -p'$mdp' -e "use $chdb;" -e "select $chx from $chtable;" > $export
sleep 1
clear
echo -e "${VERT}Les données ont été exportées.${NC}"
cat archiveDB*
exit