#!/bin/bash

## ----------PROYECTO FINAL LINUX PROTECO-------------##
## ------------PROLIN MAURICIO Y VANESSA--------------##
## ------------13 DE NOVIEMBRE DE 2020----------------##

#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
#COLORES:
BOLD="\e[1m"
#YELLOW="\e[1;33m"
#RED="\e[1;31m"
RESET="\e[0m"
#COLORES CON BACKGROUND:
NARANJA="\e[1;43m"
#PURPURA="\e[1;45m"
GREEN="\e[1;42m"
CYAN="\e[1;46m"

var=1024
obt=`cat /proc/meminfo | grep "MemTotal" | grep "[1-9].*" -o`
let prim=$obt/$var
let seg=$prim/$var
let ram=$seg/$var
f1=`cat /proc/meminfo | grep "MemFree" | grep "[1-9].*" -o`
let f2=$f1/$var
let f3=$f2/$var
let free=$f3/var
obt2=`cat /proc/meminfo | grep "SwapTotal" | grep "[1-9].*" -o`
let sw1=$obt2/$var
let sw2=$sw1/$var
let swap=$sw2/$var


#SO=`cat /proc/sys/kernel/ostype`
#Kernel=`cat /proc/version | awk {'print $3'}`
#Procesador=`cat /proc/cpuinfo | grep --max-count=1 "model name"`
#VProcesador=`cat /proc/cpuinfo | grep "cpu MHz"`
#CProcesador=`cat /proc/cpuinfo | grep --max-count=1 "cache size"`


printf "\t\t$NARANJA **********----INFORMACION DEL SISTEMA----**********$RESET\n"
printf "\t\t$NARANJA Sistema Operativo: `cat /proc/sys/kernel/ostype` $RESET\n"
printf "\t\t$NARANJA Versión del Kernel: `cat /proc/version | awk {'print $3'}`$RESET\n"

printf "\n\t\t$CYAN ----------INFORMACION DE LA MEMORIA---------- $RESET\n"
printf "\t\t$CYAN RAM (utilizable): $ram Gb$RESET\n"
printf "\t\t$CYAN Memoria libre: $free Gb$RESET\n"
printf "\t\t$CYAN Swap: $swap Gb$RESET\n"
printf "\n\t\t$CYAN ----------INFORMACION DEL PROCESADOR---------- $RESET\n"
printf "\t\t$CYAN Procesador: `cat /proc/cpuinfo | grep --max-count=1 "model name"`$RESET\n"
printf "\t\t$CYAN Memoria cache: `cat /proc/cpuinfo | grep "cpu MHz"`$RESET\n"
printf "\t\t$CYAN Velocidad de nucleo: `cat /proc/cpuinfo | grep --max-count=1 "cache size"` $RESET\n"

printf "\n\t\t$GREEN ----------INFORMACION DE USUARIOS----------\n"
w
printf "$RESET\n"