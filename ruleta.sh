#!/bin/bash

function ctrl_c(){
  echo -e "\n\n[+] Saliendo...\n"
  tput cnorm && exit 1
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
  declare -i totalJugadas=0
  maxMoney=$money
  listadoMalaRacha=" "
  
  echo -e "\n[+] Su dinero actual es de: S/.$money\n"
  echo -n "Ingrese la cantidad de dinero a apostar: " && read bet
  echo -n "Desea apostar a número impar o par?: " && read oddEvenBet
  #echo -e "\n[+] Su apuesta es de: S/.$bet y está apostando a los numeros de tipo: $oddEvenBet\n"
  
  backupBet=$bet
  money=$(($money-$bet))

  tput civis
  while [ $money -ge 0 ]; do
    let totalJugadas+=1
    #echo -e "\n[+] Su apuesta es de: S/.$bet y le queda: S/.$money"
    backupMoney=$money
    randomNumber=$((RANDOM % 37))
    if [ $randomNumber -eq 0 ]; then
      #echo -e "[-] Usted pierde porque salió el numero $randomNumber"
      bet=$(($bet*2))
      listadoMalaRacha+="$randomNumber "
    else
      if [ $oddEvenBet == "par" ]; then
        if [ $((randomNumber%2)) -eq 0 ]; then
          money=$(($money+$(($bet*2))))
          #echo -e "[+] Usted gana porque el numero que salio es: $randomNumber y ahora su dinero actual es de: S/.$money"
          bet=$backupBet
          if [ $money -gt $maxMoney ]; then
            maxMoney=$money
          fi
          listadoMalaRacha=" "
        else
          #echo -e "[-] Usted pierde porque salio el numero $randomNumber"
          bet=$(($bet*2))
          listadoMalaRacha+="$randomNumber "
        fi
      else
        if [ $((randomNumber%2)) -eq 0 ]; then
          #echo -e "[-] Usted pierde porque salio el numero $randomNumber"
          bet=$(($bet*2))
          listadoMalaRacha+="$randomNumber "
        else
          money=$(($money+$(($bet*2))))
          #echo -e "[+] Usted gana porque el numero que salio es: $randomNumber y ahora su dinero actual es de: S/.$money"
          bet=$backupBet
          if [ $money -gt $maxMoney ]; then
            maxMoney=$money
          fi
          listadoMalaRacha=" "
        fi
      fi
    fi
    money=$(($money-$bet))
  done
  tput cnorm
  #echo -e "\n[+] Su siguiente apuesta sería de S/.$bet pero no cuenta con el dinero suficiente para seguir apostando a través de esta técnica."
  #echo -e "[+] Usted se retira con: S/.$backupMoney"
  echo -e "\n[!] Usted pierde!!!"
  echo -e "[+] Usted llegó a ganar un máximo de: S/.$maxMoney"
  echo -e "[+] Usted jugó $totalJugadas veces"
  echo -e "[+] Listado de las jugadas que lo llevaron a perder: [$listadoMalaRacha]"
  echo -e "[+] Se acabó el juego.\n"
}

function reverseLabouchere(){
  declare -i totalJugadas=0
  declare -a arrayBets=(1 2 3 4)
  backupArrayBets=(${arrayBets[@]})
  maxMoney=$money

  echo -e "\n[+] Su dinero actual es de: S/.$money\n"
  echo -n "Desea apostar a número impar o par?: " && read oddEvenBet
  #echo -e "\n[+] Su dinero actual es de: S/.$money y está apostando a los numeros de tipo: $oddEvenBet\n"
  
  bet=$((${arrayBets[0]}+${arrayBets[-1]}))
  let money-=$bet

  tput civis
  while [ $money -ge 0 ]; do
    let totalJugadas+=1
    #echo -e "\n[+] Su secuencia de apuesta es: ${arrayBets[@]}"
    #echo -e "[+] Su apuesta es de: S/.$bet y le queda: S/.$money"
    randomNumber=$((RANDOM % 37))
    if [ $randomNumber -eq 0 ]; then
      #echo -e "[-] Usted pierde porque salió el numero: $randomNumber"
      if [ ${#arrayBets[@]} -eq 1 ]; then
        unset arrayBets[0]
      else
        unset arrayBets[0]
        unset arrayBets[-1]
      fi
    else
      if [ $oddEvenBet == "par" ]; then
        if [ $((randomNumber%2)) -eq 0 ]; then
          money=$(($money+$(($bet*2))))
          #echo -e "[+] Usted gana porque el numero que salio es: $randomNumber y ahora su dinero actual es de: S/.$money"
          arrayBets+=($bet)
          if [ $money -gt $maxMoney ]; then
            maxMoney=$money
          fi
        else
          #echo -e "[-] Usted pierde porque salio el numero $randomNumber"
          if [ ${#arrayBets[@]} -eq 1 ]; then
            unset arrayBets[0]
          else
            unset arrayBets[0]
            unset arrayBets[-1]
          fi
        fi
      else
        if [ $((randomNumber%2)) -eq 0 ]; then
          #echo -e "[-] Usted pierde porque salio el numero $randomNumber"
          if [ ${#arrayBets[@]} -eq 1 ]; then
            unset arrayBets[0]
          else
            unset arrayBets[0]
            unset arrayBets[-1]
          fi
        else
          money=$(($money+$(($bet*2))))
          #echo -e "[+] Usted gana porque el numero que salio es: $randomNumber y ahora su dinero actual es de: S/.$money"
          arrayBets+=($bet)
          if [ $money -gt $maxMoney ]; then
            maxMoney=$money
          fi
        fi
      fi
    fi 
    arrayBets=(${arrayBets[@]})
    if [ ${#arrayBets[@]} -eq 0 ]; then
      arrayBets=(${backupArrayBets[@]})
      bet=$((${arrayBets[0]}+${arrayBets[-1]}))
    elif [ ${#arrayBets[@]} -eq 1 ]; then
      bet=${arrayBets[0]}
    else
      bet=$((${arrayBets[0]}+${arrayBets[-1]}))
    fi
    let money-=$bet
  done
  tput cnorm
  
  echo -e "\n[!] Usted ha perdido todo su dinero."
  echo -e "[+] Usted llegó a ganar un máximo de: S/.$maxMoney"
  echo -e "[+] Total de jugadas: $totalJugadas"
  echo -e "[+] Se acabó el juego.\n"
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
