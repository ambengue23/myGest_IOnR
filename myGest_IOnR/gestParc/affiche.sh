#!/bin/bash

#Demande des infos de connexion à ma Bd
echo "veuillez saisir l'utilisateur"
 read USER
echo "veuillez saisir le mot de passe"
 read -s PASSWORD
echo "entrez l'hôte mysql"
 read HOST
# afficher mon menu 
menu() {
    echo ""
    figlet " MENU  PRINCIPAL "
    echo "1. Liste des bases de données"
    echo "2. Afficher les tables "
    echo "3. Afficher les infos d'une table"
    echo "4. Exécuter une requête sql"
    echo "5. Retour au menu"
    echo "6. Je quitte la base de donnée "
    echo ""
    echo -n "choisir une option (1-5):"
    read OPTION
}
# Fonction pour lister mes bd
mes_bd() {
    echo "La liste de mes bases de données disponile est:"
       mysql -h $HOST -u $USER -p$PASSWORD -e "show databases;"
}
# affichage des diiferentes tables de ma base de donnée 
mes_tables(){
 echo "veuillez saisir le nom de la base de donnée"
      read DATABASE
 echo "la liste des tables de la base de donnée $DATABASE est:"
      mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "show tables;"
}
#afficher les information sur une table
infos_tables() {
 echo "entrez le nom de la bd"
      read DATABASE
 echo "entrez le nom de la table"
      read TABLE
 echo "La liste des infos sur la table $TABLE dans la base de donnée $DATABASE est:"
     mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "select* from $TABLE;"
}
#fonction pour executer une requête SQL
ma_requete() {
 echo "entrez le nom de la bd"
     read DATABASE
 echo "entrez votre requête sql"
     read REQUETE
 echo "exécution de la requête sql ....."
     mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "$REQUETE"
}
#Boucle pour afficher le menu jusquà ce que l'utilisateur decide de quitter
while true; do       # il va faire l'operation tant k la condition est vraie 
     menu           # il affiche le contenu du menu dejà  déclaré en haut
    case $OPTION in # apres avoir afficher le menu , il attends une option
         1)         # l'option saisie est stocker dans $OPTION
            mes_bd  # case permet de traiter les differents options saisie
            ;;
         2)
            mes_tables
            ;;
         3)
            infos_tables
            ;;
         4)
            ma_requete
            ;;
         5)
            quitter=0
            figlet "Au  revoir !"    # si on tape l'option 5 on quite le script avec
           # exit 0
            ;;
         6)
           figlet "Je  quitte  la  base  de  donnée  !"
            exit 0
            ;;                  # la commande exit 0 . Le 0 indique une sortie réusie
         *)
            echo " option invalide. Veuillez choisir une option entre 1 et 5 !"
            ;;
     esac
done
