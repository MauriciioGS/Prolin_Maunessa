#!/bin/bash

## -----------------PROYECTO FINAL LINUX PROTECO--------------------##
## -------------------PROLIN MAURICIO Y VANESSA---------------------##
## --------------------13 DE NOVIEMBRE DE 2020----------------------##
## Formato de ejecución : ./busqueda.sh nomb_archivo nomb_directorio##

arch=$1
dir=$2
## CON ESTO EMPEZARÁ LA BUSQUEDA DESDE EL HOME DEL USUARIO PASANDO POR TODOS SUS ARCHIVOS
ubiact="/home/$USER";


pos=0
ubicFin="";

#VARIABLES DE PRUEBA
#dir=""
#arch=""
#printf "$dir\n"
#printf "$arch\n"

#FUNCION QUE POR CADA ARCHIVO DENTRO DEL DIRECTORIO PREGUNTA SI ES EL QUE BUSCAMOS, DE SER 
#ASÍ RETORNA 1, SI NO ES, LO DESCARTA Y SIGUE CON LOS DEMAS ARCHIVOS
fileSearch()
{
  
  for archivo in "$ubiact"/*; do
    if [ "${archivo##*/}" = "${arch}" ]; then
      #printf "Encontre a $arch\n"
      ubicFin="${archivo}"
      #printf "${ubicFin}\n"
      return $((1))
    fi
  done
}

#FUNCIÓN QUE POR CADA ARCHIVO, EN LA UBICACIÓN QUE RECIBE, PREGUNTA SI EL DIRECTORIO LEÍDO 
#ES EL QUE BUSCAMOS, DE NO SER ASÍ, LO DESCARTAMOS Y SEGUIMOS BUSCANDO EN MÁS DIRECTORIOS 
#Y ARCHIVOS, DE SERLO AHORA BUSCAMOS DENTRO DE ÉL EL ARCHIVO INDICADO LLAMANDO A FILESEARCH
dirSearch()
{
  for archivo in "$ubiact"/*; do

    #PARA ARCHIVOS TIPO -d (DIRECTORIO)
    if [ -d "${archivo}" ]; then
      #printf "${archivo}\n"

      if [ "${archivo##*/}" = "${dir}" ]; then
        #printf "Encontre a $dir\n"
        pos=$(($1+4));
        ubiact=${ubiact}/${archivo##*/}
        cd "$ubiact"
        fileSearch $pos "$ubiact" 1
        # Salimos de la búsqueda si encontramos al archivo dentro del directorio
        # $? toma el estatus de la ultima vez ,esto es, lo que regresa fileSearch
        # IMPORTANTE: NO EJECUTAR NADA ENTRE LA LLAMADA A LA FUNCION Y EL IF, esto para que $? funcione
        if [ "$?" -eq 1 ]; then
          #printf "acabe\n"
          cd ..
          ubiact=$(pwd)
          return
        else
          printf "${arch} no existe en el directorio indicado: ${dir}\n"
          cd ..
          ubiact=$(pwd)
          exit
        fi
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

#COMIENZA LA BÚSQUEDA
dirSearch 0 "$ubiact" 0
## IMPRIMIMOS LA UBICACIÓN DEL ARCHIVO
printf "RUTA DE UBICACIÓN DEL ARCHIVO: \e[1;41m${ubicFin}\e[0m \n"