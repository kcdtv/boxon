# boxon.sh [![Bash4.2-shield]](http://tldp.org/LDP/abs/html/bashver4.html#AEN21220) [![License-shield]](https://raw.githubusercontent.com/v1s1t0r1sh3r3/airgeddon/master/LICENSE.md)  
![0day]

# **Description**  

This script scans and detects the metworks that are vulnerable to the WPS scurity breach described here: https://github.com/t6x/reaver-wps-fork-t6x/wiki/Introducing-a-new-way-to-crack-WPS:-Option--p-with-an-Arbitrary-String  
It is focused on the French situation and comes as a pedsagogical tool for this full disclosure: http://www.crack-wifi.com/forum/topic-12166-0day-crack-box-sfr-nb6v-en-deux-secondes-par-pin-null.html  
*Edit*: SFR customers are invited by their ISP to change (for free) their box for a last generation one that is not affected by this security breach.   
  
  
# **Dependencies**  
  
Wash from `reaver 1.6.1` (or any superior version) and its dependencies. To install `reaver 1.6.1` (and other versions) visit: https://github.com/t6x/reaver-wps-fork-t6x  
  
  
# **Usage**  

- Clone this repository
```
git clone https://github.com/kcdtv/boxon.git
```   
- Locate your shell in the downloaded branch   
```
cd boxon
```
- Launch the script invoking bash with administrator privileges
```
sudo bash boxon.sh
```
  
  
# **Synopsis**  
  
User will be asked to choose one interface if severals are detected  
![script]  
The scan can be done in both 2.4GHz and 5GHz frecuencies and vulnerables targets are detected live.  
More to come.  
Follow the evolution here http://www.crack-wifi.com/forum/topic-12166-0day-crack-box-sfr-nb6v-en-deux-secondes-par-pin-null.html


# **Supported devices list**  

- **NEUF box**  
NB4-SER-r2  
NB4-FXC-r2  
- **Numéricable (Castlenet)**  
CBV38Z4EN  
- **SFR box**  
NB4-FXC-r1  
NB6V-FXC-r0  
NB6V-FXC-r1  
NB6V-FXC-r2
NB6V-SER-r0  
- **Livebox (Orange)**  
SagemcomFast3965_LB2.8


# **Credits**

Thanks and greetings to www.crack-wifi.com community


  
  
[Bash4.2-shield]: https://img.shields.io/badge/bash-4.2%2B-blue.svg?style=flat-square&colorA=273133&colorB=00db00 "Bash 4.2 or later"  

[License-shield]: https://img.shields.io/badge/license-GPL%20v3%2B-blue.svg?style=flat-square&colorA=273133&colorB=bd0000 "GPL v3+"  

[0day]: https://www.wifi-libre.com/img/members/3/cooltext254176200235321.gif  

[script]: http://pix.toile-libre.org/upload/original/1502974500.png
