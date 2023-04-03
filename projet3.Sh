#!/bin/bash
echo "-------- WELCOME TO MY CRUD ---------"
  echo "1-Loging"
while true
do
  echo "2-Sign In"
  read -p "" choice
  case $choice in
       1)read -p "Enter your username :" username
         echo -n "Enter your password :"
         read -s passwd
        test=$(jq -r '.[] | select(.username=="'$username'" and .password=="'$passwd'")' users1.json)
        if [ "$test" ]
        then
                echo "Bienvenu $username" 
                   break
        else
                echo "Inscrivez vous s'il vous plaît car vous n'existez pas dans bd"
        fi;;
       2)read -p "Enter your username:" username
         echo -n "Enter your password:"
         read -s  passwd
          jq '. += [{"username":"'$username'","password":"'$passwd'","tache":[]}]' user1.json > tmp && mv tmp users1.json
        jq '.' users1.json
        echo "Bienvenu $username"
         break;;
  esac
done
function menu(){
while true
do
    echo "MENU $1"
    echo -e "1-Entrer une tache \n 2-Lister les taches \n 3-Modifier une tache \n 4-Supprimer une tache \n 5-Quitter"
    read -p "Faite votre choix:" choix
    case $choix in
            1)echo -n "Entrer une tache :"
              read  task
              jq '. | map(if .username=="'$1'" and .password=="'$2'" then .tache +=["'$task'"] else . end)' users1.json > tmp && mv tmp users1.json
              jq '.[] | select(.username=="'$1'" and password=="'$2'")' users1.json 
              ;;
              # Lister les tâches
            2)jq '.[] | select(.username=="'$1'" and .password=="'$2'") | .tache' userS1.json 
            ;;
              # Modification des tâches
            3)read -p "Entrer la tache à modifier:" atache ntach
                jq '. |= map(if .username=="'$1'" and .password=="'$2'" then .tache |= map(if .=="'$tache'" then "'$ntach'" else . end) else . end)' users1.json >tmp && mv tmp users1.json
                jq '.' users1.json
              ;;
            4)read -p "Entrer la tache à supprime:" task
              jq 'del(.[] | select(.username=="'$1'" and .password=="'$2'")|.tache[]| select(.== "'$task'"))'  users1.json >tmp && mv tmp users1.json 
              jq '.' users1.json
              ;;
             5) break;;
   esac
done
}
menu $username $passwd


