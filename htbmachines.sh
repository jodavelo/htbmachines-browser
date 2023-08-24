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

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js" 

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}"
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por un nombre de máquina${endColour}"
  echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por dirección IP${endColour}"
  echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por dificultad de una máquina${endColour}"
  echo -e "\t${purpleColour}o)${endColour}${grayColour} Buscar por el sistema operativo${endColour}"
  echo -e "\t${purpleColour}s)${endColour}${grayColour} Buscar por Skill${endColour}"
  echo -e "\t${purpleColour}y)${endColour}${grayColour} Obtener link de la resolución de la máquina en youtube${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function updateFiles(){

  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados${endColour}"
    tput cnorm
  else
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes...${endColour}"
    sleep 2
    tput civis
    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')
    
    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      rm bundle_temp.js
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones, lo tienes todo al dia ;)${endColour}"
    else 
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles${endColour}"
      sleep 1
      rm bundle.js && mv bundle_temp.js bundle.js
      echo -e "${yellowColour}[+]${endColour}${grayColour} Los archivos han sido actualizados${endColour}"
    fi

    tput cnorm
  fi
}

function searchMachine(){
  machineName="$1"

  machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
  if [ "$machineName_checker" ]; then
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la maquina${endColour}${blueColour} $machineName${endColour}${grayColour}:${endColour}\n"
  # cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
  name_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '1p' | awk '{print $1}')
  name=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '1p' | awk '{print $2}')
  
  ip_address_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '2p' | awk '{print $1}')
  ip_address=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '2p' | awk '{print $2}')
  
  so_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '3p' | awk '{print $1}')
  so=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '3p' | awk '{print $2}')

  level_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '4p' | awk '{print $1}')
  level=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '4p' | awk '{print $2}')
 
  skills_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '5p' | awk '{print $1}')
  skills=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '5p' | awk '{print $2}')

  certifications_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '6p' | awk '{print $1}')
  certifications=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '6p' | awk '{print $2}')

  link_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '7p' | awk '{print $1}')
  link=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '7p' | awk '{print $2}')

  ad_field=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '8p' | awk '{print $1}')
  activeD=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | sed -n '8p' | awk '{print $2}')

  echo -e "${greenColour}$name_field${endColour}${blueColour} $name${endColour}" 
  echo -e "${greenColour}$ip_address_field${endColour}${blueColour} $ip_address${endColour}"
  echo -e "${greenColour}$so_field${endColour}${blueColour} $so${endColour}"
  echo -e "${greenColour}$level_field${endColour}${blueColour} $level${endColour}"
  echo -e "${greenColour}$skills_field${endColour}${blueColour} $skills${endColour}"
  echo -e "${greenColour}$certifications_field${endColour}${blueColour} $certifications${endColour}"
  echo -e "${greenColour}$link_field${endColour}${yellowColour} $link${endColour}" 
  echo -e "${greenColour}$ad_field${endColour}${blueColour} $activeD${endColour}"

  else 
    echo -e "\n${redColour}[+] La máquina proporcionada no existe${endColour}\n"
  fi
  
}

function searchIP(){
  ipAddress="$1"
  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ",")"
  if [ "$machineName" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La maquina correspondiente para la IP${endColour}${blueColour} $ipAddress${endColour}${grayColour} es${endColour}${purpleColour} $machineName${endColour}\n"
  else 
    echo -e "\n${redColour}[+] La dirección IP proporcionada no existe${endColour}\n"
  fi
  #searchMachine $machineName
}

function getYoutubeLink(){
  machineName="$1"
  youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF {print $NF}')"
  if [ "$youtubeLink" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tutorial para la máquina${endColour}${purpleColour} $machineName${endColour}${grayColour} esta en el siguiente enlace:${endColour}${greenColour} $youtubeLink${endColour}"
  else 
    echo -e "\n${redColour}[+] La máquina proporcionada no existe${endColour}\n"
  fi
  #echo "Obtener enlace de youtube"
}

function getMachinesDifficulty(){
  difficulty="$1"
  results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$results_check" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que poseen un nivel de dificultad${endColour}${purpleColour} $difficulty${endColour}${grayColour}:${endColour}\n" 
    cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
  else 
    echo -e "\n${redColour}[+] La dificultad indicada no existe${endColour}\n"
  fi
}

function getOSMachines(){
  os="$1"
  os_results="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$os_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando las máquinas cuyo sistema operativo es:${endColour}${greenColour} $os${endColour}\n"
    cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] EL sistema operativo indicado no existe${endColour}\n"
  fi
}

function getOSDifficultyMachines(){
  difficulty="$1"
  os="$2"
  check_results="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$check_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando máquinas de dificultad${endColour}${greenColour} $difficulty${endColour}${grayColour} que tengan sistema operativo${endColour}${redColour} $os${endColour}:\n"
    cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
  else 
    echo -e "\n${redColour}[!] Se ha indicado una dificultad o sistema operativo incorrectos${endColour}\n"
  fi
  #echo -e "\n[!] Se va aplicar una búsqueda por la dificultad $difficulty y los sistemas operativos que sean $os\n"
}

function getSkill(){
  skill="$1"
  check_skill="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$check_skill" ];then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se representan las máquinas donde se práctica la Skill${endColour}${greenColour} $skill${endColour}"
    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF {print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] No se ha encontrado ninguna máquina con la Skill $skill ${endColour}\n"
  fi
}

# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:h" arg; do
  case $arg in
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG";  chivato_difficulty=1; let parameter_counter+=5;;
    o) os="$OPTARG"; chivato_os=1; let parameter_counter+=6;;
    s) skill="$OPTARG"; let parameter_counter+=7;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then 
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachinesDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getOSMachines $os
elif [ $parameter_counter -eq 7 ]; then
  getSkill "$skill"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
  getOSDifficultyMachines $difficulty $os
else
  helpPanel
fi
