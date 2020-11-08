#!/bin/bash
## ----------PROYECTO FINAL LINUX PROTECO-------------##
## ------------PROLIN MAURICIO Y VANESSA--------------##
## ------------13 DE NOVIEMBRE DE 2020----------------##
## ----------Muestra la fecha en formato:-------------##
## -------------DIA NUMERO_DIA MES ANO----------------##

#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
RESET="\e[0m"
GREEN="\e[1;42m"

DAY=`date +"%A"`
NUMBDAY=`date +"%d"`
MONTH=`date +"%B"`
YEAR=`date +"%Y"`
echo -e "$GREEN System Date: $DAY $NUMBDAY de $MONTH de $YEAR$RESET\n"