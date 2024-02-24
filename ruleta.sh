#!/bin/bash

function ctrl_c(){
echo -e "\n\n[+] Saliendo...\n"
 exit 1
}

#Ctrl+C
trap ctrl_c INT

function helpPanel(){
  echo -e "\n[+] Uso: $0 [opciones] [argumentos]\n"
  echo -e "[+] Opciones:\n"
  echo -e "\t-h) Muestra el panel de ayuda"
  echo -e "\t-m) Acepta como argumento la cantidad inicial de dinero a apostar"
  echo -e "\t-t) Acepta como argumento el nombre de la técnica a utilizar (martingala / reverseLabouchere)\n"
  echo -e "Ejemplo: $0 -m 100 -t martingala\n"
  
  exit 1
}

function martingala(){
  echo -e "\n[+] Su dinero actual es de: S/.$money\n"
  echo -n "Ingrese la cantidad a apostar: " && read bet
  echo -n "Desea apostar a número impar o par?: " && read oddEvenBet
  echo -e "\n[+] Su apuesta es de: S/.$bet y está apostando a los numeros de tipo: $oddEvenBet\n"
  backupBet=$bet
  money=$(($money-$bet))
  while [ $money -ge 0 ]; do
    echo -e "\n[+] Su apuesta es de: S/.$bet y le queda: S/.$money"
    backupMoney=$money
    randomNumber=$((RANDOM % 37))
    if [ $randomNumber -eq 0 ]; then
      echo -e "[-] Usted pierde porque salió el numero $randomNumber"
      bet=$(($bet*2))
    else
      if [ $oddEvenBet == "par" ]; then
        if [ $((randomNumber%2)) -eq 0 ]; then
          money=$(($money+$(($bet*2))))
          echo -e "[+] Usted gana porque el numero que salio es: $randomNumber y ahora su dinero actual es de: S/.$money"
          bet=$backupBet
        else
          echo -e "[-] Usted pierde porque salio el numero $randomNumber"
          bet=$(($bet*2))
        fi
      else
        if [ $((randomNumber%2)) -eq 0 ]; then
          echo -e "[-] Usted pierde porque salio el numero $randomNumber"
          bet=$(($bet*2))
        else
          money=$(($money+$(($bet*2))))
          echo -e "[+] Usted gana porque el numero que salio es: $randomNumber y ahora su dinero actual es de: S/.$money"
          bet=$backupBet
        fi
      fi
    fi
    money=$(($money-$bet))
  done

  echo -e "\n[+] Su siguiente apuesta sería de S/.$bet pero no cuenta con el dinero suficiente para seguir apostando a través de esta técnica."
  echo -e "[+] Usted se retira con: S/.$backupMoney"
  echo -e "[+] Se acabó el juego.\n"
}

function reverseLabouchere(){
  echo "Entramos a la función reverseLabouchere"
}

while getopts "m:t:h" opcion; do
  case "${opcion}" in
    m)money=${OPTARG};;
    t)technique="${OPTARG}";;
    h)helpPanel;;
  esac
done

if [ $money ] && [ $money -gt 0 ] && [ $technique ]; then
  if [ $technique == "martingala" ]; then
    martingala
  elif [ $technique == "reverseLabouchere" ]; then
    reverseLabouchere
  else
    echo -e "\n[-] Técnica no reconocida. Utiliza -h para ver la lista de técnicas disponibles.\n"
  fi
else
  helpPanel
fi


