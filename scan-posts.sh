#!/bin/bash

# Author: Adrian Lujan Muñoz - aka: clhore


# Uso: chmod +x ./scan-ports.sh
# - ./scan-ports.sh --selectPorts <ip-address>
# - ./scan-ports.sh --fullScan <ip-address>


greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


trap ctrl_c INT
# control exit
function ctrl_c(){
	clear
	echo -e "\n${yellowColour}[*] ${endColour}${grayColour}Saliendo ${endColour}"
	sleep 0.2
	for i in "." ".." "...";
	do
		clear
		echo -e "\n${yellowColour}[*] ${endColour}${grayColour}Saliendo $i ${endColour}"
		sleep 0.2
	done
	tput cnorm
	exit 0
}

# help
function helpMenu(){
	echo -e "\n${yellowColour}[*] ${endColour}${grayColour}USO:${endColour} ./scan-posts.sh [option] <ip-address>"
	echo -e "\n\t${yellowColour}--selectPorts${endColour} - ${redColour}./scan-posts.sh --selectPorts ${grayColour}<ip-address>${endColour}"
	echo -e "\n\t${yellowColour}--fullScan${endColour} - ${redColour}./scan-posts.sh --fullScan ${grayColour}<ip-address>${endColour}"
}



# full Scan
function fullScan(){
	for port in {1..65535}; do
		timeout 1 bash -c "echo '' > /dev/tcp/$ip_address/$port" 2>/dev/null
		
		if [ $(echo $?) -eq 0 ]; then
			echo -e "\n\t${yellowColour}[${endColour}${turquoiseColour}*${endColour}${yellowColour}]${endColour} ${redColour}Port $port ${endColour}- ${grayColour}Port Open${endColour}"
		fi
	done; wait
}


# personal Scan
function personalScan(){
	for port in "${priority_ports[@]}"; do
       		timeout 1 bash -c "echo '' > /dev/tcp/$ip_address/$port" 2>/dev/null
		
		if [ $(echo $?) -eq 0 ]; then
			echo -e "\n\t${yellowColour}[${endColour}${turquoiseColour}*${endColour}${yellowColour}]${endColour} ${redColour}Port $port ${endColour}- ${grayColour}Port Open${endColour}"
		fi
	done
	sleep 0.5
}


# main function
if [ $1 == "--selectPorts" ]; then
	ip_address=$2
	read -p 'Enter ports: ' p
	priority_ports=($p)
	
	personalScan

elif [ $1 == "--fullScan" ]; then
	ip_address=$2

	fullScan
elif [ $1 == "--help" ] || [ $1 == "-h" ]; then
	helpMenu

else
    ctrl_c
fi
