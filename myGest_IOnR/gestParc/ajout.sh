#!/bin/bash

# Variables de connexion MySQL
HOST="localhost"
USER="Assane"
PASSWORD="btsinfo"
DATABASE="ma_bd"

# afficher mon menu
menu() {
    echo ""
    figlet " MENU  PRINCIPAL "
    echo "1. Liste des bases de données"
    echo "2. Afficher les tables "
    echo "3. Afficher les infos d'une table"
    echo "4. ajouter des données dans la table typeE"
    echo "5. ajouter des données dans la table équipement"
    echo "6. Retour au menu"
    echo "7. Je quitte la base de donnée "
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
ajout_typeE() {
# Demander les informations à l'utilisateur
echo "Entrez l'identifiant du TypeE :"
read id_TypeE
echo "Entrez le libellé :"
read libelle_TypeE

# Vérifier si le typeE existe déjà
id_verif=$(mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -se "SELECT id FROM TypeE WHERE id ='$id_TypeE' AND libelle ='$libelle_TypeE' LIMIT 1;")

# Si la table existe pas, on l'ajoute
if [ -z "$id_verif" ]
 then
    # on ajoute la table
    mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "insert into TypeE(id, libelle) values('$id_TypeE','$libelle_TypeE');"
    echo "TypeE '$libelle_TypeE' ajouté avec succès."
else
    echo "TypeE '$libelle_TypeE' existe déjà."
fi
}

ajout_Equipmt() {
echo "Entrez l'identifiant de l'équipement :"
read id_Equipement
echo "Entrez le nom de l'équipement:"
read nom_Equipement
echo "Entrez l'adresse ip de l'équipement :"
read adIP_Equipement
if [["$adIP_Equipement" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$]];then
        echo "Entrez l'adresse MAC de l'équipement :"
        read adMAC_Equipement
else
        echo "adresse ip invalide!"
        echo "Entrez à nouveau l'adresse ip de l'équipement :"
	read adIP_Equipement
fi
# Vérifier si l'Equipement existe déjà
id_verifE=$(mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -se "SELECT id FROM Equipement WHERE id = '$id_Equipement' LIMIT 1;")
# Ajouter l'équipement avec ID de TypeE
if [ -z "$id_EverifE" ]
then
    # on ajoute la table
mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -e "INSERT INTO Equipement (nom, adMAC, adIP, CIDR, idT, id_TypeE) VALUES ('$nom_Equipement', '$adMAC_Equipement', 'adIP_Equipement', 'CIDR_Equipement' $id_TypeE);"
echo "L'equipement '$nom_Equipement' a été ajoutée avec succé."
else
    echo "équipement '$nom_Equipement' existe déjà."
fi
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
            ajout_typeE
            ;;
         5)
           ajout_Equipmt
           ;;
         6)
            quitter=0
            figlet "Au  revoir !"    # si on tape l'option 5 on quite le script avec
           # exit 0
            ;;
         7)
           figlet "Je  quitte  la  base  de  donnée  !"
            exit 0
            ;;                  # la commande exit 0 . Le 0 indique une sortie réusie
         *)
            echo " option invalide. Veuillez choisir une option entre 1 et 5 !"
            ;;
     esac
done
done
