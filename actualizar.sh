function_verify () {
 
  ### INTALAR VERSION DE SCRIPT
  v1=$(curl -sSL "https://raw.githubusercontent.com/Waldo60/A-peru/main/Install/Version")
  echo "$v1" > /etc/versin_script
  #echo "$v1" > /etc/versin_script_new
  }
atualiza_fun() {
    fun_ip
    SCPinstal="$HOME/install"
    verificar_arq() {
        case $1 in
        "menu" | "message.txt") ARQ="${SCPdir}/" ;;                                                                       #Menu
        "usercodes") ARQ="${SCPusr}/" ;;                                                                                  #Panel SSRR
        "C-SSR.sh" | "proxy.sh") ARQ="${SCPinst}/" ;;                                                                     #Panel SSR
        "openssh.sh") ARQ="${SCPinst}/" ;;                                                                                #OpenVPN
        "squid.sh") ARQ="${SCPinst}/" ;;                                                                                  #Squid
        "dropbear.sh") ARQ="${SCPinst}/" ;;                                                                               #Instalacao
        "openvpn.sh") ARQ="${SCPinst}/" ;;                                                                                #Instalacao
        "ssl.sh") ARQ="${SCPinst}/" ;;                                                                                    #Instalacao
        "shadowsocks.sh" | "proxy.sh" | "python.py") ARQ="${SCPinst}/" ;;                                                 #Instalacao
        "Shadowsocks-libev.sh" | "slowdns.sh") ARQ="${SCPinst}/" ;;                                                       #Instalacao
        "Shadowsocks-R.sh") ARQ="${SCPinst}/" ;;                                                                          #Instalacao
        "v2ray.sh") ARQ="${SCPinst}/" ;;                                                                                  #Instalacao
        "budp.sh") ARQ="${SCPinst}/" ;;                                                                                   #Instalacao
        "sockspy.sh" | "PDirect.py" | "PPub.py" | "PPriv.py" | "POpen.py" | "PGet.py" | "python.py") ARQ="${SCPinst}/" ;; #Instalacao
        *) ARQ="${SCPfrm}/" ;;                                                                                            #Herramientas
        esac
        mv -f ${SCPinstal}/$1 ${ARQ}/$1
        chmod +x ${ARQ}/$1
    }
    error_fun() {
        msg -bar2 && msg -verm "ERROR entre VPS<-->GENERADOR (Port 81 TCP)" && msg -bar2
        [[ -d ${SCPinstal} ]] && rm -rf ${SCPinstal}
        exit 1
    }
    invalid_key() {
        msg -bar2 && msg -verm "  Code Invalido -- #¡Key Invalida#! " && msg -bar2
        [[ -e $HOME/lista-arq ]] && rm -r $HOME/lista-arq
        exit 1
    }
    while [[ ! $Key ]]; do
        clear
        clear
        msg -bar
        msg -tit
        echo -e "\033[1;91m      ACTUALIZAR FICHEROS DEL SCRIPT VPS-MX"
        msg -bar2 && msg -ne "\033[1;93m          >>> INTRODUZCA LA KEY ABAJO <<<\n   \033[1;37m" && read Key
        tput cuu1 && tput dl1
    done
    msg -ne "    # Verificando Key # : "
    cd $HOME
    wget -O $HOME/lista-arq $(ofus "$Key")/$IP >/dev/null 2>&1 && echo -e "\033[1;32m Code Correcto de KEY" || {
        echo -e "\033[1;91m Code Incorrecto de KEY"
        invalid_key
        exit
    }
    IP=$(ofus "$Key" | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') && echo "$IP" >/usr/bin/vendor_code
    sleep 1s
    function_verify
    updatedb
    if [[ -e $HOME/lista-arq ]] && [[ ! $(cat $HOME/lista-arq | grep "Code de KEY Invalido!") ]]; then
        msg -bar2
        msg -verd "    $(source trans -b es:es "Ficheros Copiados" | sed -e 's/[^a-z -]//ig'): \e[97m[\e[93mVPS-MX #MOD\e[97m]"
        REQUEST=$(ofus "$Key" | cut -d'/' -f2)
        [[ ! -d ${SCPinstal} ]] && mkdir ${SCPinstal}
        pontos="."
        stopping="Configurando Directorios"
        for arqx in $(cat $HOME/lista-arq); do
            msg -verm "${stopping}${pontos}"
            wget --no-check-certificate -O ${SCPinstal}/${arqx} ${IP}:81/${REQUEST}/${arqx} >/dev/null 2>&1 && verificar_arq "${arqx}" || error_fun
            tput cuu1 && tput dl1
            pontos+="."
        done
        sleep 1s
        msg -bar2
        listaarqs="$(locate "lista-arq" | head -1)" && [[ -e ${listaarqs} ]] && rm $listaarqs
        cat /etc/bash.bashrc | grep -v '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' >/etc/bash.bashrc.2
        echo -e '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' >>/etc/bash.bashrc.2
        mv -f /etc/bash.bashrc.2 /etc/bash.bashrc
        echo "${SCPdir}/menu" >/usr/bin/menu && chmod +x /usr/bin/menu
        echo "${SCPdir}/menu" >/usr/bin/VPSMX && chmod +x /usr/bin/VPSMX
        echo "$Key" >${SCPdir}/key.txt
        [[ -d ${SCPinstal} ]] && rm -rf ${SCPinstal}
        rm -rf /root/lista-arq
        [[ ${#id} -gt 2 ]] && echo "es" >${SCPidioma} || echo "es" >${SCPidioma}
        echo -e "${cor[2]}               ACTUALIZACION COMPLETA "
        echo -e "         COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
        echo -e "  \033[1;31m               sudo VPSMX o menu             \033[0;37m" && msg -bar2
        rm -rf $HOME/lista-arq
    else
        invalid_key
    fi
    exit 1
}
