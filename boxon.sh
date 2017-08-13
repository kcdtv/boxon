#! /bin/bash
version=1.0

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

                        $white   NB4-SER-r2$purpple  (NEUF-XXXX)
                        $purpple  NB6V-SER-r0$white  (SFR-XXXX) 
                        $white   NB4-FXC-r1$purple  (SFR-XXXX)
                        $purpple  NB6V-FXC-r0$white  (SFR-XXXX)
                    $white SagemcomFast3965$purpple  (Livebox-XXXX) 
$nocolour
Copyleft (C) 2017 kcdtv @ www.crack-wifi.com"
echo -e "$purpple▐█$white   Vérification privilèges$nocolour"
whoami | grep root || { echo -e "$red▐█   Erreur$nocolour - Absence de privilèges d'administrateur. Veuillez lancer le script en utilisant$yellow sudo$nocolour ou$yellow su$nocolour.  
$red▐█   Exit.$nocolour"; exit 1; }
echo -e "$purpple▐█$white   Vérification reaver$nocolour"
which reaver || { echo -e "$red▐█   Erreur$nocolour -$yellow Reaver$nocolour n'est pas installé. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; } 
reaver  &>> /tmp/versionreaver
grep "Reaver v1.6." /tmp/versionreaver || { echo -e "$red▐█   Error$nocolour - Vous devez actualiser reaver. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; }
rm /tmp/versionreaver
echo -e "$purpple▐█$white   Vérification wash$nocolour"
which wash || { echo -e "$red▐█   Erreur$nocolour -$yellow Wash$nocolour n'est pas installé. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; }
wash  &>> /tmp/versionwash
grep "Wash v1.6." /tmp/versionwash || { echo -e "$red▐█   Erreur$nocolour - Vous devez actualiser wash. Installez $yellow Reaver v1.6.1$nocolour (ou version supèrieure) en allant à:$white https://github.com/t6x/reaver-wps-fork-t6x$nocolour 
$red▐█   Exit.$nocolour"; exit 1; }
rm /tmp/versionwash
echo -e "$purpple▐█$white   Vérification distribution$nocolour"
uname -r | grep kali || { echo -e "$red▐█   Erreur$nocolour - Désolé, la première version du script fonctionne uniquement avec$yellow Kali Linux.  
$red▐█   Exit.$nocolour"; exit 1; }
rm /tmp/versionwash
airmon-ng | grep phy &>> /tmp/interfaces
  if [ ! -s /tmp/interfaces ];
    then
      echo -e "$red▐█   Erreur$nocolour -  Aucune interface wifi compatible mode moniteur n'est détectée.
$red▐█   Exit.$nocolour"
  elif [ "$(grep -c phy /tmp/interfaces)" == 1 ];
    then 
      interface=$( awk '{ print $2 }' /tmp/interfaces )
      echo -e "$purpple▐█$white   Une seule interface WiFi est détectée et a été sélectionnée: $orange$interface$nocolour"
       if [ -z "$(echo $interface | grep mon)" ];
          then   
            echo -e "$purpple▐█$white   Activation mode moniteur$nocolour"
            airmon-ng start $interface
            interface=$( echo "$(echo $interface)mon")
        fi
  else
      echo -e "$purpple▐█$white   Plusieurs interfaces wifi disponibles. Choisissez.$nocolour"
      while [ -z "$interface" ]; 
        do
        echo -e "
        Num      Interface	Driver		Chipset"
        nl < /tmp/interfaces
        echo ""
        echo -e "$purpple▐█$white   Interface:$orange"
        read -r -n 1 -ep "     " number
        interface=$(awk '{ print $2 }' /tmp/interfaces | sed "$number!d" 2>/dev/null )   
           if [ -z "$interface" ]; 
             then
                echo -e "$red▐█   Error$nocolour -$white Numéro interface incorrect ($orange$number$white).$nocolour"
           else
                echo -e "$purpple▐█$white   Interface $orange$interface$white selectionnée$nocolour"
                  if [ -z "$(echo $interface | grep mon)" ];
                    then   
                      echo -e "$purpple▐█$white   Activation mode moniteur$nocolour"
                      airmon-ng start $interface
                      interface=$( echo "$(echo $interface)mon")
                  fi 
           fi 
      done
  fi
wash -i $interface -j >> /tmp/scan &
washPID=$!
trap 'break' SIGINT
  for (( i=0; ;i+=4 ))
    do
      clear
echo -e "$purpple
                         ▄▄▄▄·       ▐▄• ▄        ▐ ▄ 
                        ▐█ ▀█▪▪      █▌█▌▪▪     •█▌▐█
                        ▐█▀▀█▄ ▄█▀▄  ·██·  ▄█▀▄ ▐█▐▐▌
                        ██▄▪▐█▐█▌.▐▌▪▐█·█▌▐█▌.▐▌██▐█▌
                        ·▀▀▀▀  ▀█▄▀▪•▀▀ ▀▀ ▀█▄▀▪▀▀ █▪ 
$nocolour
Copyleft (C) 2017 kcdtv @ www.crack-wifi.com
$orange▐█$purpple   Temps de scan: $orange$i$white secondes. Les réseaux en$orange orange$whute sont vulnérables
$orange▐█$purpple   Pressez <$purpple CTRL$white +$purpple C$white > pour arrêter le scanneur$nocolour

        bssid          essid    Canal RSSI     " 

        while read line
          do
            bssid=$( echo $line | awk -F '"' '{ print $4}')
            essid=$( echo $( echo $line | awk -F '"' '{ print $8}')********  | cut -c -11 )
            channel=$(echo 0$( echo $line | awk -F '"' '{ print $11}' | awk '{ print $2}' | tr -d ',' )| rev | cut -c 1-2 | rev)
            rssi=$( echo $line | awk -F '"' '{ print $13}' | cut -c4-6 )
              if [ -n "$(echo $line | grep 'NB4-SER-r2')" ] || [ -n "$(echo $line | grep 'NB4-FXC-r1')" ] || [ -n "$(echo $line | grep 'NB6V-FXC-r0')" ] || [ -n "$(echo $line | grep 'NB6V-SER-r0')" ] || [ -n "$(echo $line | grep 'SagemcomFast3965')" ] ;
                then 
                  echo -e " $orange $bssid  $essid$white  $channel  $rssi  $red réseau vulnérable$nocolour"
                else
                  echo -e " $white $bssid  $essid  $channel  $rssi"
               fi  
           
        done < /tmp/scan
      sleep 3
  done
trap - SIGINT
kill $washPID
rm -r /tmp/interfaces /tmp/scan
echo -e "$nocolour
Copyleft (C) 2017 kcdtv @ www.crack-wifi.com"
exit 0
  
