#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
orangeColour="\e[38;5;214m\033[1m"
pinkColour="\e[38;5;219m\033[1m"
brownColour="\e[38;5;94m\033[1m"
cyanColour="\e[0;96m\033[1m"
lightBlueColour="\e[0;94m\033[1m"
lightGreenColour="\e[0;92m\033[1m"
lightPurpleColour="\e[0;95m\033[1m"
lightYellowColour="\e[0;93m\033[1m"

function ctrl_c(){
    echo -e "\n\n${redColour}[!]${endColour} Saliendo...\n"
    tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

#########################################
#		Help Panel		#
#########################################

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
    echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios.${endColour}"
    echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por un nombre de máquina.${endColour}"
    echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por dirección IP.${endColour}"
    echo -e "\t${purpleColour}y)${endColour}${grayColour} Obtener link de la resolución de la máquina en Youtube.${endColour}"
    echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por nivel de dificultad de la máquina: Fácil, Media, Difícil, Insane.${endColour}"
    echo -e "\t${purpleColour}o)${endColour}${grayColour} Buscar las maquinas por su SO: Linux o Windows.${endColour}"
    echo -e "\t${purpleColour}s)${endColour}${grayColour} Buscar las maquinas por las skill necesarias para resolverlas.${endColour}"
    echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar panel de Ayuda.${endColour}\n"
}

#########################################
#             Search Machine            #
#########################################

function searchMachine(){
    machineName="$1"
    
    machineName_checker="$(cat bundle.js | awk  "/name: \"$machineName\"/, /resuelta/" | grep -vE "ip|id|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | awk '{$1="\033[0;32m" $1 "\033[0m"; print}')"
    
    if [ "$machineName_checker" ]; then
        
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la máquina${endColour}${purpleColour} $machineName${endColour}${grayColour}: ${endColour}\n"
        
        cat bundle.js | awk  "/name: \"$machineName\"/, /resuelta/" | grep -vE "ip|id|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | awk '{$1="\033[0;32m" $1 "\033[0m"; print}'
        echo -e "\n"
        
    else
        echo -e "\n${redColour}[!] La máquina proporcionada no existe.${endColour}\n"
    fi
}

#########################################
#              Update Files             #
#########################################

function updateFiles(){
    
    if [ ! -f bundle.js ]; then
        tput civis
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados. ${endColour}"
        tput cnorm
        
    else
        tput civis
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes... ${endColour}"
        
        curl -s $main_url > bundle_temp.js
        js-beautify bundle_temp.js | sponge bundle_temp.js
        md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
        md5_original_value=$(md5sum bundle.js | awk '{print $1}')
        
        if [ "$md5_temp_value" == "$md5_original_value" ]; then
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones.${endColour}"
            rm bundle_temp.js
        else
            
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han detectado actualizaciones disponibles, actualizando... ${endColour}"
            sleep 2
            rm bundle.js && mv bundle_temp.js bundle.js
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos han sido actualizados. ${endColour}"
            
        fi
        tput cnorm
    fi
}

#########################################
#               Search IP               #
#########################################

function searchIP(){
    ipAddress="$1"
    machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    
    if [ "$machineName" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} La máquina correspondiente para la ip${endColour}${blueColour} $ipAddress${endColour}${grayColour} es${endColour}${purpleColour} $machineName${endColour}\n"
        
    else
        echo -e "\n${redColour}[!] La IP proporcionada no existe.${endColour}\n"
        
    fi
}

#########################################
#           Get Youtube Link            #
#########################################

function getYoutubeLink(){
    machineName="$1"
    
    youtubeLink="$(awk "/name: \"$machineName\"/,/resuelta/" bundle.js | grep -vE "sku|ip|id" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print "\033[0;94m" $NF "\033[0m";}')"
    
    if [ -n "$youtubeLink" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tutorial para la máquina${endColour}${purpleColour} $machineName${endColour}${grayColour} está en el siguiente enlace:${endColour} $youtubeLink\n"
    else
        echo -e "\n${redColour}[!] La máquina no existe.${endColour}\n"
    fi
}

#########################################
#       Get Machines Difficulty         #
#########################################

function getMachinesDifficulty(){
    difficulty="$1"
    resultsCheck="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    if [ "$resultsCheck" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que poseen nivel de dificultad:${endColour} $difficulty\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!] La dificultad no existe.${endColour}\n"
    fi
}

#########################################
#          Get Machines OS              #
#########################################

function getOSMachines(){
    operativeSystem="$1"
    
    resultsCheck="$(cat bundle.js | grep "so: \"$operativeSystem\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    if [ "$resultsCheck" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que poseen el Sistema Operativo:${endColour}${greenColour} $operativeSystem${endColour}\n"
        cat bundle.js | grep "so: \"$operativeSystem\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!] La máquina no existe.${endColour}\n"
    fi
    
}

#########################################
#      Get OS Difficulty Machines       #
#########################################

function getOSDifficultyMachines(){
    difficulty="$1"
    operativeSystem="$2"
    resultsCheck="$(cat bundle.js | grep "so: \"$operativeSystem\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    echo -e "\n")"
    
    if [ "$resultsCheck" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando máquinas con dificultad${endColour}${pinkColour} $difficulty${endColour}${grayColour} y por el sistema operativo${endColour}${greenColour} $operativeSystem${endColour}\n"
        
        cat bundle.js | grep "so: \"$operativeSystem\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
        echo -e "\n"
    else
        echo -e "\n${redColour}[!] La máquina no existe.${endColour}\n"
    fi
}

#########################################
#          Get Machines Skills          #
#########################################

function getMachinesSkill(){
    skill="$1"
    resultsCheck="$(cat bundle.js | tr -d '"' | grep "$skill*" -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d ',' | column)"
    if [ "$resultsCheck" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando las máquinas con la skill${endColour}${pinkColour} $skill${endColour}\n"
        cat bundle.js | tr -d '"' | grep "$skill*" -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d ',' | column
        echo -e "\n"
    else
        echo -e "\n${redColour}[!] No hay máquinas resueltas con esa skill.${endColour}\n"
    fi 
}

# Indicadores
declare -i counter=0

# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0


while getopts "m:ui:y:d:o:s:h" flag; do
    case $flag in
        m) machineName="$OPTARG"; (( counter+=1));;
        u) ((counter+=2));;
        i) ipAddress="$OPTARG"; ((counter+=3));;
        y) machineName="$OPTARG"; ((counter+=4));;
        d) difficulty="$OPTARG"; chivato_difficulty=1; ((counter+=5));;
        o) operativeSystem="$OPTARG"; chivato_os=1; ((counter+=6));;
        s) skill="$OPTARG"; ((counter+=7));;
        h) ;;
    esac
done

if [ $counter -eq 1 ]; then
    searchMachine "$machineName"
    elif [ $counter -eq 2 ]; then
    updateFiles
    elif [ $counter -eq 3 ]; then
    searchIP "$ipAddress"
    elif [ $counter -eq 4 ]; then
    getYoutubeLink "$machineName"
    elif [ $counter -eq 5 ]; then
    getMachinesDifficulty "$difficulty"
    elif [ $counter -eq 6 ]; then
    getOSMachines "$operativeSystem"
    elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
    getOSDifficultyMachines $difficulty $operativeSystem
    elif [ $counter -eq 7 ]; then
    getMachinesSkill "$skill"
else
    helpPanel
fi



