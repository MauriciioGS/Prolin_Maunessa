#!/bin/bash
## ----------PROYECTO FINAL LINUX PROTECO-------------##
## ------------PROLIN MAURICIO Y VANESSA--------------##
## ------------13 DE NOVIEMBRE DE 2020----------------##
## ---Muestra la hora en formato de 24 hrs hh:mm:ss---##

#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
RESET="\e[0m"
GREEN="\e[1;42m"

#Date es un comando que devuelve la hora del sistema, con la opción "+%T" permite verla en formato 24 hrs
HOUR=`date +"%T"`
echo -e "$GREEN System Hour: $HOUR $RESET\n" 
