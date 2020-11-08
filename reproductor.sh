#!/bin/bash
## ----------PROYECTO FINAL LINUX PROTECO-------------##
## ------------PROLIN MAURICIO Y VANESSA--------------##
## ------------13 DE NOVIEMBRE DE 2020----------------##
## Script que permite simular la función de un reproductor##
## haciendo uso de la herramienta mpg123 para Linux,  ##
## la cual es requisito para la ejecución de este     ##
## script. Permite navegar entre carpetas y obtener   ##
## los archivos .mp3 de estas                         ##


#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
#COLORES:
#BOLD="\e[1m"
#NARANJA="\[0;33m"
YELLOW="\e[1;33m" 
#RED="\e[1;31m"
#CYAN=36
RESET="\e[0m"
#COLORES CON BACKGROUND:
#PURPURA="\e[1;45m"
BLUEBK="\e[1;44m"
REDBK="\e[4;41m"
GRAYBK="\e[1;100m"

# VARIABLES PARA LLEVAR EL CONTROL DE LAS UBICACIONES Y RUTAS
ubiact=''
ubicAux="/home/$USER"
ubiCamb=''
dir=''

# VARIABLE PARA LA POSICIÓN EN LAS FUNCIONES DE ARBOS Y BUSQUEDA
pos=0
# ARREGLO PARA GUARDAR EN ÉL LAS CANCIONES DE UNA CARPETA (LISTA DE REPRODUCCION)
declare -a canciones 

# VERIFICA SI ESTÁ INSTALADO mpg123
check()
{
  route=`which mpg123`
  if [ -z $route ]; then
    true=1
    while [[ $true -eq 1 ]]; do
      printf "\n$RED Para usar este script es necesario tener mpg123 instalado; ¿Desea instalarlo para continuar?(si/no):$RESET "
      read answ
      case $answ in
        'si' )
          sudo apt update
          sudo apt install mpg123
          break
        ;;
        'no' )
          printf "$RED No se instalara ningun paquete. No se puede continuar con la ejecución de esta terminal.$RESET\n"
          exit
        ;;
        * )
          printf "$RED Por favor, ingrese una opción correcta (si/no)$RESET\n"
        ;;
      esac  
    done
  fi
}

# FUNCION QUE A PARTIR DE UNA UBICACIÓN BUSCA EN ELLA Y TODAS SUS CARPETAS EL DIRECTORIO QUE RECIBE COMO ARGUMENTO
dirSearch()
{
  for archivo in "$ubicAux"/*; do
    #PARA ARCHIVOS TIPO -d (DIRECTORIO)
    if [ -d "${archivo}" ]; then
      #printf "${archivo}\n"
      if [ "${archivo##*/}" = "${dir}" ]; then
        #printf "Encontre a $dir\n"
        #pos=$(($1+4));
        ubicAux=${ubicAux}/${archivo##*/}
        ubiCamb="${ubicAux}"
        cd "$ubicAux"
        #arbol 0 "$ubicAux" 1
        cd ..
        ubicAux=$(pwd)
        return
      fi
      pos=$(($1+4));
      ubicAux=${ubicAux}/${archivo##*/}
      cd "$ubicAux"
      dirSearch $pos "$ubicAux" 1
      cd ..
      ubicAux=$(pwd)
    fi
  done
}

# SIMULA LA FUNCION TREE
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

# IMPRIME ALGUNAS OPCIONES DE LA HERRAMIENTA mpg123
opciones_Rep()
{
  printf "\n\t$GRAYBK OPCIONES DEL REPRODUCTOR: $RESET\n"
  printf "\n\t$GRAYBK 's' or 'space' (stop) para detener la pista actual$RESET\n"
  printf "\n\t$GRAYBK 'f' siguiente pista$RESET\n"
  printf "\n\t$GRAYBK 'd' pista previa$RESET\n"
  printf "\n\t$GRAYBK 'b' repetir$RESET\n"
  printf "\n\t$GRAYBK '.' Adelante$RESET\n"
  printf "\n\t$GRAYBK 'a' Atras$RESET\n"
  printf "\n\t$GRAYBK '+' subir volumen$RESET\n"
  printf "\n\t$GRAYBK '-' bajar volumen$RESET\n"
  printf "\n\t$GRAYBK 'q' para terminar la reproduccion$RESET\n"
  printf "\n\t$GRAYBK 'h' para ver más opciones del reproductor$RESET\n"
}

# MEDIANTE CICLOS Y SWITCH-CASE SOPORTA LA ESTRUCTURA DEL MENU DEL REPRODUCTOR PARA CADA UNA DE SUS FUNCIONALIDADES
prebePlayer()
{

  #VARIABLES AUXILIARES DE TIPO LOCAL
  caso=0

  #* MIENTRAS op_usr NO SEA IGUAL A 6 ACTUA
  while [ $caso -eq 0 ]; do
    ubiact=$(pwd)
    caso=0
    rep=1
    #clear
    printf "\n\t$BLUEBK (((((((((((((0)))))))))))))                               (((((((((((((0)))))))))))))$RESET\n"
    printf "\t$BLUEBK (((((((((((((0)))))))))))))$GRAYBK REPRODUCTOR MP3 - PREBEPLAYER$RESET$BLUEBK (((((((((((((0)))))))))))))$RESET\n"
    printf "\t$BLUEBK (((((((((((((0)))))))))))))                               (((((((((((((0)))))))))))))$RESET\n"
    printf "\t$GRAYBK Directorio actual: $YELLOW$ubiact$RESET\n\n"
    printf "\t$BLUEBK 1.- Reproducir las canciones del Directorio actual$RESET\n"
    printf "\t$BLUEBK 2.- Cambiar de Directorio$RESET\n"
    printf "\t$BLUEBK 3.- Subir un Directorio$RESET\n"
    printf "\t$BLUEBK 4.- Mostrar las opciones del reproductor$RESET\n"
    printf "\t$BLUEBK 5.- Salir del reproductor PREBEPLAYER$RESET\n\n"
    printf "\t$BLUEBK Seleccione una opcion:$RESET "
    read op_usr
    # VALUA LA OPCIÓN INGRESADA POR EL USUARIO
    case $op_usr in
      "1" )
        # MIENTRAS REP SEA 1 REPITE EL MISMO MENU PARA LA REPRODUCCION DE CANCIONES SOBE UNA CARPETA
        while [ $rep -eq 1 ]; do
          clear
          op_usr2=''
          printf "\n\t$BLUEBK (((((((((((((0)))))))))))))$GRAYBK OPCIONES SOBRE LA LISTA ACTUAL:$BLUEBK (((((((((((((0)))))))))))))$RESET\n"
          cont=1
          # OBTIENE LOS ARCHIVOS MP3 DE LA CARPETA ACTUAL
          for file in $ubiact/*.mp3; do
            canciones[$(($cont-1))]="${file##*/}"
            cont=$(($cont+1))
          done
          carpeta="${ubiact##*/}"
          printf "\t$BLUEBK Carpeta: $carpeta $RESET\n"
          printf "\t$BLUEBK Canciones: $RESET\n"
          # IMPRIME LOS ARCHIVOS ANTES EXTRAIDOS EN UN FROMATO PRESENTABLE
          for (( i = 0; i < cont-1; i++ )); do
            printf "$GRAYBK\t\t$((i+1)).-${canciones[$i]}$RESET\n"
          done
          printf "\t$BLUEBK Canciones totales: $(($cont-1))$RESET\n"
          printf "\n\t$BLUEBK [ # ]: Reproduce el numero de cancion seleccionado$RESET"
          printf "\n\t$BLUEBK [ * ]: Reproduce todas las canciones de la lista$RESET"
          printf "\n\t$BLUEBK [ R ]: Reproduce la lista de canciones aleatoramente$RESET"
          printf "\n\t$BLUEBK [ 0 ]: Regresar al menú principal$RESET\n"
          printf "\n\t$BLUEBK Seleccione una opcion:$RESET "
          read op_usr2
          case $op_usr2 in
            '0' )
              rep=0
              ;;
            '*' )
              #Reproduce las canciones (archivos .mp3) ubicadas en la carpeta actual, todos los archivos cuya carpeta padre sea "${archivo##*/}"
              num=0
              for archivo in "$ubiact"/*; do
                if [ "${archivo##*.}" = "mp3" ]; then
                  printf "\n\t$GRAYBK REPRODUCIENDO LA PISTA $((num+1)).-${canciones[$num]}$RESET\n"
                  opciones_Rep
                  command mpg123 "${archivo##*/}"
                  ((num++))
                fi
              done
              rep=1
              clear
              ;;
            '#' )
              # REPRODUCE EL NUMERO DE CANCIÓN QUE DESEA EL USUARIO SEGUN LA LISTA DE CANCIONES ANTES MOSTRADA
              num=0
              printf "\n\t$BLUEBK Numero de cancion:$RESET "
              read num
              #Valida que haya ingresado un valor, de ser así se pasa esa canción (archivo) al programa
              if [ -z $num ]; then
                printf "$REDBK Por favor ingrese un numero.$RESET\n"
              #Checa que el valor introducido sea 0 < num < numero total de canciones, de no ser así le pide al usuario una opcion correcta
              elif [ $num -gt "0" ] && [ $num -le "$((cont-1))" ]; then
                printf "\n\t$GRAYBK REPRODUCIENDO LA PISTA $num.-${canciones[$num-1]}$RESET\n"
                opciones_Rep
                command mpg123 "${canciones[$num-1]}"
              else
                printf "$REDBK Por favor ingrese un numero valido. Total de canciones: $(($cont-1))$RESET\n"
              fi
              rep=1
              clear
              ;;
            'R' )
              # REPRODUCE DE MANERA ALEATORIA LAS CANCIONES
              printf "\t$GRAYBK REPRODUCCION ALEATORIA$RESET\n"
              opciones_Rep
              command mpg123 -z "${ubiact}"/*
              rep=1
              clear
              ;;
            * )
              printf "\n\t$REDBK Opcion invalida, intente de nuevo.$RESET\n"
              rep=1
              ;;
          esac
        done
        clear
        ;;
      "2" )
        printf "\n\t$BLUEBK (((((((((((((0)))))))))))))                               (((((((((((((0)))))))))))))$RESET\n"
        printf "\t$BLUEBK (((((((((((((0)))))))))))))$GRAYBK REPRODUCTOR MP3 - PREBEPLAYER$RESET$BLUEBK (((((((((((((0)))))))))))))$RESET\n"
        printf "\t$BLUEBK (((((((((((((0)))))))))))))                               (((((((((((((0)))))))))))))$RESET\n"
        printf "\t$GRAYBK Directorio actual: $YELLOW$ubiact$RESET\n\n"
        dir="${ubiact##*/}"
        arbol 0 "$ubiact" 1
        dir=''
        printf "\t$BLUEBK Nombre del Directorio (ingresa '.' para subir una carpeta o el nombre de un directorio en una ruta diferente):$RESET"
        read dir
        clear
        #Valida que el usuario haya ingresado un valor, despues, si es (.) se mueve una carpeta arriba y si es un nombre busca esa carpeta desde /home/usuario
        if [[ -z $dir ]]; then
          printf "$REDBK Por favor ingrese un nombre de Directorio valido.$RESET\n"          
        elif [[ $dir == '.' ]]; then
          cd ..
          ubiact=$(pwd)
          carpeta="${ubiact##*/}"
          printf "\t$BLUEBK Carpeta: $carpeta $RESET\n"
          arbol 0 "$ubiact" 1
        else
          printf "\t$BLUEBK Carpeta: $dir $RESET\n"
          dirSearch 0 "${dir}" 0
          cd "$ubiCamb"
          ubiact=$(pwd)
          arbol 0 "$ubiact" 1
        fi
        caso=0
        ;;
      "3" )
        cd ..
        ubiact=$(pwd)
        carpeta="${ubiact##*/}"
        printf "\t$BLUEBK Carpeta: $carpeta $RESET\n"
        arbol 0 "$ubiact" 1
        caso=0
        ;;
      "4" )
        opciones_Rep
        caso=0
        ;;
      "5" )
        printf "\t$BLUEBK ¡¡ GRACIAS POR USAR EL PREBEPLAYER, HASTA LA PROXIMA !!$RESET\n"
        sleep 2
        clear
        exit 0
        ;;
      * )
        printf "$REDBK Ingrese una opcion valida.$RESET\n"
        caso=0
        ;;
    esac
  done
}

#                       #
# COMIENZA EL PROGRAMA  #
#                       #
check
prebePlayer
exit 0