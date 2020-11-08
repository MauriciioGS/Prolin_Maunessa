#!/bin/bash

## ----------PROYECTO FINAL LINUX PROTECO-----------------##
## ------------PROLIN MAURICIO Y VANESSA------------------##
## ------------13 DE NOVIEMBRE DE 2020--------------------##
## Formato de ejecución: ./arbolTree.sh nombre_directorio ##

dir=$1
pos=0
ubiact="/home/$USER"

#FUNCIÓN QUE RECORRE EL DIRECTORIO EN LA RUTA QUE RECIBE Y PREGUNTA SI EL DIRECTORIO LEÍDO ES EL QUE BUSCAMOS,
#DE NO SER ASÍ, LO DESCARTAMOS Y SEGUIMOS BUSCANDO EN MÁS DIRECTORIOS, DE SERLO AHORA LLAMA A LA FUNCIÓN
#ÁRBOL PARA IMPRIMIR SU CONTENIDO
dirSearch()
{
  for archivo in "$ubiact"/*; do

    #PARA ARCHIVOS TIPO -d (DIRECTORIO)
    if [ -d "${archivo}" ]; then
      #printf "${archivo}\n"

      if [ "${archivo##*/}" = "${dir}" ]; then
        #printf "Encontre a $dir\n"
        #pos=$(($1+4));
        ubiact=${ubiact}/${archivo##*/}
        cd "$ubiact"
        arbol 0 "$ubiact" 1
        cd ..
        ubiact=$(pwd)
        return
      fi
      pos=$(($1+4));
      ubiact=${ubiact}/${archivo##*/}
      cd "$ubiact"
      dirSearch $pos "$ubiact" 1
      cd ..
      ubiact=$(pwd)
    fi
  done
}


#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
#COLORES:
#VERDE=0;32
#AMARILLO=1;33
#AZUL=1;34
#PURPURA=0;35
#CYAN=36

#FUNCIÓN QUE IMPRIME EL CONTENIDO DE UN DIRECTORIO EN LA RUTA QUE RECIBE EN FORMATO
#TIPO COMANDO TREE
arbol()
{

  cont=0
  rama=0

  #IMPRIMIMIR EL ÚNTO DE UBICACIÓN ACTUAL
  if [ $1 -eq 0 ];then
    printf "   \e[1;33m.\e[0m\n"
    printf "   \e[1;33m${dir}\e[0m\n"
  fi

  #IMPRIMIR TODOS LOS ARCHIVOS QUE COMIENCEN CON: <RUTA ACTUAL>/
  #VA TOMANDO CADA ARCHIVO CON ESTA CONDICIÓN Y VALUA SU TIPO PARA DARLE FORMATO E IMPRIMIR
  for archivo in "$ubiact"/*; do

    #ESTE WHILE LE DA FORMATO DE IMPRESIÓN, IMPRIME LAS RAMAS
    while [ $cont -le $1 ]; do
      if [ $cont -eq 0 ]; then
        printf "   |"
      fi
      if [ $rama -eq 4 ]; then
        printf "|"
        rama=0
      fi
      printf " "

      rama=$(($rama+1))
      cont=$((cont+1))
    done
    rama=0

    #PARA ARCHIVOS TIPO -d (DIRECTORIO)
    if [ -d "${archivo}" ]; then
      printf "__ \e[1;33m${archivo##*/}\e[0m \n"
      pos=$(($1+4));
      ubiact=${ubiact}/${archivo##*/}
      cd "$ubiact"
      arbol $pos "$ubiact" 1
      cd ..
      ubiact=$(pwd)

    #PARA ARCHIVOS TIPO -x (EXECUTABLE)
    elif [ -x "$archivo" ]; then
      printf "__ \e[1;34m${archivo##*/}\e[0m \n"

    #PARA ARCHIVOS TIPO -f (FILE, normales)
    elif [ -f "$archivo" ]; then
      printf "__ ${archivo##*/} \n"

    ##MP2,3 y 4 puede ser un switch

    #PARA ARCHIVOS TIPO MP2
    elif [ "${archivo##*.}" = "mp2" ]; then
      printf "__ \e[1;35m${archivo##*/}\e[0m \n"

    #PARA ARCHIVOS TIPO MP3
    elif [ "${archivo##*.}" = "mp3" ]; then
      printf "__ \e[1;32m${archivo##*/}\e[0m \n"

    #PARA ARCHIVOS TIPO MP4
    elif [ "${archivo##*.}" = "mp4" ];then
      printf "__ \e[1;36m${archivo##*/}\e[0m \n"

    ##___SE PUEDEN HACER SWITCH O ELIFS PARA MÁS TIPOS DE ARCHIVOS COMO PNG,TXT, ETC...__

    #SI NO HAY ARCHIVOS
    else
      printf "    (Vacio)\n"

    fi

    cont=0
  done
}

##__INICIO DEL SCRIPT__##
##VALIDA SI RECIBIÓ ALGO COMO ARGUMENTO, DE SER ASÍ, LLAMA A LA FUNCIÓN DIRSEARCH
##PARA ENCONTRAR LA UBICACIÓN DE ESE ARGUMENTO (DIRECTORIO) O INDICAR QUE NO EXISTE
#SI SU ARGUMENTO ES NULO ENTONCES LLAMA A ARBOL PARA IMPRIMIR LO DE LA UBICACIÓN ACTUAL
if [ -z "$dir" ]; then
  ubiact=$(pwd);
  dir="${ubiact##*/}"
  #printf "Nulo\n"
  arbol 0 "${ubiact}" 0
else
  #printf "${ubiact}\n"
  dirSearch 0 "${ubicact}" 0
fi 
   


