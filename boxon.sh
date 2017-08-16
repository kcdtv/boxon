#! /bin/bash
version=1.0.2

# boxon.sh est un script bash qui détecte les réseaux WiFi vulnérables à un attaque WPS avec un PIN vide (valeur "null"). 
# Pour plus d'info sur cette brèche de sécurité critique allez à http://www.crack-wifi.com/forum/topic-12166-0day-crack-box-sfr-nb6v-en-deux-secondes-par-pin-null.html
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
# Contact author: kcdtv@wifi-libre.com

# Copyright (C) 2017 kcdtv @ www.crack-wifi.com

# Global variables:
# - Colours
nocolour="\033[0;37m"
orange="\033[38;5;202m"
red="\033[1;31m"
yellow="\033[1;33m"
white="\033[1;37m"
purpple="\033[0;35m"

# Functions

Screen()
{
echo -e "$purpple
                         ▄▄▄▄·       ▐▄• ▄        ▐ ▄ 
                        ▐█ ▀█▪▪      █▌█▌▪▪     •█▌▐█
                        ▐█▀▀█▄ ▄█▀▄  ·██·  ▄█▀▄ ▐█▐▐▌
                        ██▄▪▐█▐█▌.▐▌▪▐█·█▌▐█▌.▐▌██▐█▌
                        ·▀▀▀▀  ▀█▄▀▪•▀▀ ▀▀ ▀█▄▀▪▀▀ █▪ 
$nocolour
Copyleft (C) 2017 kcdtv @ www.crack-wifi.com"
}

Goodbye()
{
rm /tmp/interfaces /tmp/iwdev /tmp/scan /tmp/translog /tmp/log 2>/dev/null
Screen
exit 0
}

## Regular scan (perfect if you want to check quickly and precisly if your PA is vulnerable)
Regularscan()
{
wash -i $iface -j $ac >> /tmp/scan &
washPID=$!
  for (( i=0; ;i+=4 ))
    do
      clear
      echo -e "$orange▐█$purpple   Temps de scan: $orange$i$white secondes. Les réseaux en$orange orange$white sont vulnérables
$orange▐█$purpple   Pressez$white <$purpple CTRL$white +$purpple C$white > pour arrêter le scanneur$nocolour

        bssid      Canal RSSI    essid        modèle (si vulnérable)" 

        while read line
          do
            bssid=$( echo $line | awk -F '"' '{ print $4}')
            essid=$( echo $line | awk -F '"' '{ print $8}')
            channel=$(echo 0$( echo $line | awk -F '"' '{ print $11}' | awk '{ print $2}' | tr -d ',' )| rev | cut -c 1-2 | rev)
            rssi=$( echo $line | awk -F '"' '{ print $13}' | cut -c4-6 )
            vulnerable=$( echo $line | grep -o -E 'NB4-SER-r2|NB4-FXC-r1|NB4-FXC-r2|NB6V-FXC-r0|NB6V-FX-r1|NB6V-FX-r2|NB6V2-FXC-r0|NB6V-SER-r0|SagemcomFast3965|CBV38Z4EN|ZXHN H108N|ZXHN H298N' | uniq )
              if [ -n "$vulnerable" ];
                then 
                  echo -e " $orange $bssid  $white$channel  $rssi  $orange$essid   $vulnerable$nocolour"
                else
                  echo -e " $white $bssid  $channel  $rssi  $essid$nocolour"
               fi  
        done < /tmp/scan
      sleep 3
  done
kill $washPID 
}

########################### SCRIPT STARTS HERE ############################################## 

echo -e "$purpple
                         ▄▄▄▄·       ▐▄• ▄        ▐ ▄ 
                        ▐█ ▀█▪▪      █▌█▌▪▪     •█▌▐█
                        ▐█▀▀█▄ ▄█▀▄  ·██·  ▄█▀▄ ▐█▐▐▌
                        ██▄▪▐█▐█▌.▐▌▪▐█·█▌▐█▌.▐▌██▐█▌
                        ·▀▀▀▀  ▀█▄▀▪•▀▀ ▀▀ ▀█▄▀▪▀▀ █▪

      _ ,       $white       ,     $purpple  _ _ _  __ $white      ,        -              
     [|)etecteur$white  de  reseaux$purpple   \/\/i[|-i$white  vulnerables  a  une  attaque

            $purpple        _ _ _ _    $white         $purpple   _ () _  $white                       
            $purpple         \/\/||)(( $white avec  un$purpple  ||)[][|\|$white  null                 
            $purpple             L|  ))$white         $purpple  L|       $white                       
 
$nocolour                 modèles affectés par la faille WPS PIN NULL:

          $white   NB4-SER-r2$purpple NB4-FXC-r2$nocolour   réseaux:$white NEUF-XXXX
$purpple    NB4-FXC-r1$white NB6V-SER-r0$purpple NB6V-FXC-r0$nocolour/$white-r1$nocolour/$purpple-r2)$nocolour  réseaux:$white SFR-XXXX
             $white SagemcomFast3965_LB2.8$nocolour  réseaux:$purpple Livebox-XXXX 
             $purpple CBV38Z4EN$nocolour (Castlenet)   réseaux:$white  Numéricable 
$nocolour
Copyleft (C) 2017 kcdtv @ www.crack-wifi.com"
echo -e "$purpple▐█$white   Vérification privilèges$nocolour"
whoami | grep root || { echo -e "$red▐█   Erreur$nocolour - Absence de privilèges d'administrateur. Veuillez lancer le script en utilisant$yellow sudo$nocolour ou$yellow su$nocolour.  
$red▐█   Exit.$nocolour"; exit 1; }
echo -e "$purpple▐█$white   Vérification reaver$nocolour"
which reaver || { echo -e "$red▐█   Erreur$nocolour -$yellow Reaver$nocolour n'est pas installé. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; } 
reaver  &>> /tmp/versionreaver
grep "Reaver v1.6." /tmp/versionreaver || { echo -e "$red▐█   Erreur$nocolour - Vous devez actualiser reaver. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; }
rm /tmp/versionreaver
echo -e "$purpple▐█$white   Vérification wash$nocolour"
which wash || { echo -e "$red▐█   Erreur$nocolour -$yellow Wash$nocolour n'est pas installé. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; }
wash  &>> /tmp/versionwash
grep "Wash v1.6." /tmp/versionwash || { echo -e "$red▐█   Erreur$nocolour - Vous devez actualiser wash. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; }
rm /tmp/versionwash
airmon-ng | grep phy &>> /tmp/interfaces
  if [ ! -s /tmp/interfaces ];
    then
      echo -e "$red▐█   Erreur$nocolour -  Aucune interface wifi compatible mode moniteur n'est détectée.
$red▐█   Exit.$nocolour"
  fi
  if [ "$(grep -c phy /tmp/interfaces)" == 1 ];
    then 
      wlan=$( awk '{ print $2 }' /tmp/interfaces )
      echo -e "$purpple▐█$white   Une seule interface WiFi est détectée et a été selectionnée: $orange$wlan$nocolour"
  else
      echo -e "$purpple▐█$white   Plusieurs interfaces wifi disponibles. Choisissez.$nocolour"
        while [ -z "$wlan" ]; 
          do
            echo -e "
        Num      Interface	Driver		Chipset"
        nl < /tmp/interfaces
        echo ""
        echo -e "$purpple▐█$white   Interface:$orange"
        read -r -n 1 -ep "     " number
        wlan=$(awk '{ print $2 }' /tmp/interfaces | sed "$number!d" 2>/dev/null )   
           if [ -z "$wlan" ]; 
             then
                echo -e "$red▐█   Erreur$nocolour -$white Numéro interface incorrect ($orange$number$white).$nocolour"
           else
                echo -e "$purpple▐█$white   Interface $orange$wlan$white selectionnée$nocolour"
           fi 
        done
  fi  
iw dev &>> /tmp/iwdev
  if [ -n "$( grep -A 4  '\'"$wlan"'\b' /tmp/iwdev | grep monitor)" ];
    then
      iface="$wlan"
  else
      echo -e "$purpple▐█$white   Activation mode moniteur$nocolour" 
      driver=$( grep '\'"$wlan"'\b' /tmp/interfaces | awk '{ print $3 }' )
      if [[ "$driver" == "8812au" || "$driver" == "8814au" ]]; 
        then
          airmon-ng check kill
          ip link set $wlan down
          iwconfig $wlan mode monitor
          ip link set $wlan up
          iface="$wlan"
        else
          airmon-ng start $wlan
          phy=$( grep $wlan /tmp/interfaces | awk '{ print $1 }' | cut -c 4 )
          iface=$( iw dev | grep -A 1 "phy#$phy" | tail -n 1 | awk '{ print $2 }')
      fi   
  fi
phy=$( airmon-ng | grep '\'"$iface"'\b' | awk '{ print $1 }' )
aband=$( iw phy $phy info | grep -o "5200 MHz" )
  until [[ $choice == 4 ]]; 
    do
      Screen
      echo -e "           $white                     _ _             
                          $white     //\/\enu    
                     

$purpple             ▐█$yellow 1$white Scan Générique b/g/n (2,4GHz)$nocolour  
$purpple             ▐█$yellow 2$white Scan Générique a/ac (5GHz)$nocolour
$purpple             ▐█$yellow 3$white Garder un log des sessions effectuées
$purpple             ▐█$red 4$white Sortir

$purpple             ▐█$white Choix:$orange"
      read -r -n 1 -ep "                   " choice
      echo -e "$nocolour"
      unset -v ac
        case $choice in
          1 )
          trap 'break' SIGINT
          rm /tmp/scan
          Regularscan
          cat /tmp/scan >> /tmp/log
          trap - SIGINT
          ;;
          2 ) 
            if [[ -n "$aband" ]];
              then
                ac="-5" 
                trap 'break' SIGINT
                rm /tmp/scan
                Regularscan
                cat /tmp/scan >> /tmp/log
                trap - SIGINT
            else
                echo -e "$red▐█   Erreur$nocolour -  L'interface choisie n'est pas compatible avec la bande 5Ghz."         
            fi       
          ;;
          3 )
            while read line 
              do
                 if [ -n "$( echo line | grep -E 'NB4-SER|NB4-FXC|NB6V-FXC|NB6V-SER|SagemcomFast3965|ZXHN H108N|ZXHN H298N|ZXHN H218N|CBV38Z4EN' )" ];
                    then 
                      echo "$line" >> /tmp/translog
                  else
                    mac=$( echo $line | awk -F '"' '{ print $4}')
                    ssid=$( echo $line | awk -F '"' '{ print $8}')
                    canal=$(echo 0$( echo $line | awk -F '"' '{ print $11}' | awk '{ print $2}' | tr -d ',' )| rev | cut -c 1-2 | rev)    
                    echo "$mac  $canal  $ssid" >> /tmp/translog
                  fi
            done < /tmp/log
          uniq /tmp/translog >> ~/boxon$( date |  awk '{print $3$2$6$4}' | tr -d ':' ).log
          echo -e "$purpple▐█$white   Log sessions sauvegardé dans le fichier:$yellow /root/boxon$( date |  awk '{print $3$2$6$4}' | tr -d ':' ).log$nocolour" 
          ;;
          4 )
          Goodbye
          ;;
          * )
          echo -e "$red▐█   Erreur$nocolour: Option invalide" 
          ;; 
        esac   
  done 
exit 0 
