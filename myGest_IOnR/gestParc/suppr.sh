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
    echo "1. Afficher les tables "
    echo "2. Afficher les infos d'une table"
    echo "3. supprimer des données dans la table Equipement"
    echo "4. supprimer des données dans la table TypeE"
    echo "5. Retour au menu"
    echo "6. Je quitte la base de donnée "
    echo ""
    echo -n "
choisir une option (1-5):"
    read OPTION
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
sup_Equip(){
 echo " entrez l id de l'équipement à supprimer"
      read id_Equipement
 # vérification si l id existe ou pas"
 id_existe=$(mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -se "select 1 from Equipement where id=$id_Equipement limit 1;")
       if [ $id_existe ]; then
         # on supprime
         mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "delete from Equipement where id=$id_Equipement;"
         echo "l'équipement avec l id $id_Equipement est supprimé avec succé"
      else
         echo "Aucun équipement trouvé avec cet id !"
      fi
}

sup_Typ(){
 echo " entrez l id du TypeE à supprimer"
       read id_TypeE
 # vérification si l id existe ou pas"
 id_verif=$(mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -se "select 1 from TypeE where id=$id_TypeE limit 1;")
 if [ $id_verif ]; then
 # on supprime
 mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "delete from TypeE where id=$id_TypeE;"
 echo "le type d'équipement avec l id $id_TypeE est supprimé avec succé"
 else
 echo "Aucun type d'équipement trouvé avec cet id !"
 fi
}

#Boucle pour afficher le menu jusquà ce que l'utilisateur decide de quitter
while true; do       # il va faire l'operation tant k la condition est vraie 
     menu           # il affiche le contenu du menu dejà  déclaré en haut
    case $OPTION in # apres avoir afficher le menu , il attends une option
         1)         # l'option saisie est stocker dans $OPTION
            mes_tables  # case permet de traiter les differents options saisie
            ;;
         2)
            infos_tables
            ;;
         3)
            sup_Equip
            ;;
         4)
            sup_Typ
            ;;
         5)
            figlet "Au  revoir !"    # si on tape l'option 5 on quite le script
            break   # avec break on revient au debut du script ou à un autre script si nécessaire 
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
