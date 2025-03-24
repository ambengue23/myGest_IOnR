#!/bin/bash

clear
echo "Outils reseau"|figlet
quitter=1
while [[ $quitter -ne 0 ]]
do
echo -e "\nMenu :"
echo "1) Tester une IP"
echo "2) Tester un port TCP"
echo "3) Consulter les IP actives"
echo "4) Générer un .txt depuis la BDD"
echo "0) Retour au menu principal"
echo -e "Veuillez choisir une option :"
read choix
case $choix in 
	1 )
		bash outilsRx/1-testIP.sh
		;;
	2 )
		bash outilsRx/2-testTCP.sh
		;;
	3 )
		bash outilsRx/3-checkValid.sh
		;;
	4 )
		bash outilsRx/4-generTxt.sh
		;;
	0 )
		quitter=0
		;;
	* )
		echo "Erreur dans la saisie, veuillez réessayer"
		sleep 2
		;;
esac
done
