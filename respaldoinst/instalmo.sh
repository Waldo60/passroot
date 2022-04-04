#!/bin/bash
clear
rm $(pwd)/$0 &> /dev/null

if [ `whoami` != 'root' ] 
   then 
     echo -e "Debes ser root para ejecutar el Instalador" 
   exit 
fi

msg () {
BRAN='\033[1;37m' && VERMELHO='\e[31m' && VERDE='\e[32m' && AMARELO='\e[33m'
MAGENTA='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' &&NEGRITO='\e[1m' && SEMCOR='\e[0m'
 case $1 in
  -ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -azu)cor="${AZUL}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm)cor="${AMARELO}${NEGRITO}[!] ${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
  -azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bra)cor="${VERMELHO}" && echo -ne "${cor}${2}${SEMCOR}";;
  "-bar2"|"-bar")cor="${NEGRITO}——————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
 esac
}

#-------------------------------------------------------------------BARRA DE ESPERA-----------------------------------------------------------------------
fun_bar () {
comando="$1"
 _=$(
$comando > /dev/null 2>&1
) & > /dev/null
pid=$!
while [[ -d /proc/$pid ]]; do
echo -ne "  \033[1;33m["
   for((i=0; i<40; i++)); do
   echo -ne "\033[1;31mx"
   sleep 0.1
   done
echo -ne "\033[1;33m]"
sleep 1s
echo
tput cuu1 && tput dl1
done
echo -ne "  \033[1;39m[\033[1;30m========================================\033[1;39m] - \033[1;32m ✅ \033[0m\n"
sleep 1s
}

####-------------------------------------------------REINICIAR UPDATER Y RECONFIGURAR HORARIO----------------------------------------------------------------
msg -bar2
echo -e " \e[97m\033[1;37m   ꧁ঔৣ☬✞ 🐯 |SCRIPT| - |VPS-BU| 🐯 ✞☬ঔৣ꧂     \e[37m"
msg -bar2
msg -azu "                  INSTALANDO"
msg -bar2

## Script name
SCRIPT_NAME=vpsmxup
## Install directory
WORKING_DIR_ORIGINAL="$(pwd)"
INSTALL_DIR_PARENT="/usr/local/vpsmxup/"
INSTALL_DIR=${INSTALL_DIR_PARENT}${SCRIPT_NAME}/
mkdir -p "/etc/vpsmxup/" &> /dev/null

## ---------------------------------------------------------------AUTO ACTULIZADOR Y PACKS NECESARY-----------------------------------------------------------
msg -bar2
echo -e "\033[97m    1 INTENTANDO DETENER UPDATER SECUNDARIO " 
fun_bar " killall apt apt-get > /dev/null 2>&1 "
echo -e "\033[97m    2 INTENTANDO RECONFIGURAR UPDATER "
fun_bar " dpkg --configure -a > /dev/null 2>&1 "
echo -e "\033[97m    3 INSTALANDO S-P-C "
fun_bar " apt-get install software-properties-common -y > /dev/null 2>&1"
echo -e "\033[97m    4 INSTALANDO LIBRERIA UNIVERSAL "
fun_bar " sudo apt-add-repository universe -y > /dev/null 2>&1"
echo -e "\033[97m    5 INSTALANDO PYTHON "
fun_bar " sudo apt-get install python -y > /dev/null 2>&1"
apt-get install python -y &>/dev/null
echo -e "\033[97m    6 INSTALANDO NET-TOOLS "
fun_bar "apt-get install net-tools -y > /dev/null 2>&1"
apt-get install net-tools -y &>/dev/null
apt-get install curl -y > /dev/null 2>&1
service ssh restart > /dev/null 2>&1
echo -e "\033[97m    7 DESACTIVANDO PASS ALFANUMERICO "
sed -i 's/.*pam_cracklib.so.*/password sufficient pam_unix.so sha512 shadow nullok try_first_pass #use_authtok/' /etc/pam.d/common-password > /dev/null 2>&1 
fun_bar "service ssh restart > /dev/null 2>&1 "
msg -bar2

#-----------------------------------------------------------------------cambiopass-----------------------------------------------------------------------
msg -bar2
echo -e "\033[93m              AGREGAR/EDITAR PASS ROOT\033[97m" 
msg -bar
[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
	echo 'PasswordAuthentication yes' > /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
	sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
service ssh restart > /dev/null
#-------------------------------------------------------------------------clear-----------------------------------------------------------------------
echo -e "\033[1;31mESTABLECER LA CONTRASEÑA ROOT\033[0m"

read -p "   [ S | N ]: " -e -i s exit   
[[ "$exit" = "n" || "$exit" = "N" ]] && exit

sleep 1s; passwd && rm .bashrc

## Install/update
if [ ! -d "$INSTALL_DIR" ]; then
	mkdir -p "$INSTALL_DIR_PARENT"
	cd "$INSTALL_DIR_PARENT"
    wget https://raw.githubusercontent.com/Waldo60/A-peru/main/Install/zzupdate.default.conf -O /usr/local/vpsmxup/vpsmxup.default.conf  &> /dev/null
	rm -rf /usr/local/vpsmxup/vpsmxup.sh
    wget https://raw.githubusercontent.com/Waldo60/A-peru/main/Install/zzupdate.sh -O /usr/local/vpsmxup/vpsmxup.sh &> /dev/null
	chmod +x /usr/local/vpsmxup/vpsmxup.sh
	rm -rf /usr/bin/vpsmxup
    wget https://raw.githubusercontent.com/Waldo60/A-peru/main/Install/zzupdate.sh -O /usr/bin/vpsmxup &> /dev/null
	chmod +x /usr/bin/vpsmxup
fi

sleep 5
msg -bar2
##----------------------------------------------------------------------VPS-MOD-----------------------------------------------------------------------
read -t 20 -n 1 -rsp $'\033[1;39m           Preciona Enter Para continuar\n'
##----------------------------------------------------------------------- Restore working directory --------------------------------------------------
cd $WORKING_DIR_ORIGINAL
clear
vpsmxup
