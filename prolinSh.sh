#!/bin/bash

## ----------PROYECTO FINAL LINUX PROTECO-------------##
## ------------PROLIN MAURICIO Y VANESSA--------------##
## ------------13 DE NOVIEMBRE DE 2020----------------##

##CHEQUEO DE PAQUETES INSTALADOS (PARA REPRODUCTOR)
##SOLO FALTA REPRODUCTOR

#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
#COLORES:
BOLD="\e[1m"
#NARANJA="\[0;33m"
YELLOW="\e[1;33m" #o 
RED="\e[1;31m"
#CYAN=36
RESET="\e[0m"
#COLORES CON BACKGROUND:
PURPURA="\e[1;45m"
BLUE="\e[4;44m"
REDBK="\e[4;41m"

user=""
password=""
	
# VERIFICA SI ESTÁ INSTALADO PYTHON, PYTHON VIENE INSTALADO POR DEFECTO EN LAS DISTRIBUCIONEX LINUX PERO NO ESTÁ DE MAS VERIFICAR
check()
{
  route=`which python`
  if [ -z route ]; then
  	true=1
  	while [[ $true -eq 1 ]]; do
  		printf "\n$RED Para usar esta terminal es necesario tener python3 instalado; ¿Desea instalarlo para continuar?(si/no):$RESET "
  		read answ
  		case $answ in
	  		'si' )
				sudo apt update
				sudo apt install python3

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

# REALIZA LA RECEPCIÓN DEL USUARIO Y CONTRASEÑA Y VALIDA QUE EN VERDAD SE HAYAN INGRESADO VALORES
login()
{
  true=1
  while [[ $true -eq 1 ]]; do
    # bandera -e habilita la interpretación de escapes \
    # bandera  -n no genera el salto de línea final
    echo -e -n "$PURPURA User:$RESET" 
    read user
    echo -e -n "$PURPURA Contraseña:$RESET"
    read -s password   # bandera -s secret hace que no se vea lo que se escribe
    if [ -z "$user" ]; then
    	echo -e "$RED Por favor ingrese un usuario valido.$RESET\n" 
    elif [ -z "$password" ]; then
    	echo -e "$RED Por favor ingrese una contraseña valida.$RESET\n"
    else
    	return
    fi
  done
}

#							#
#	COMIENZA EL PROGRAMA	#
#							#

# trap indica las acciones a realizar una vez recibida una señal, en este caso usamos las señales generadas
# por un Ctrl + c (SIGINTP o 2) y Ctrl + z (SIGTSTP o 20), con el caracter: "" le decimos que no haga nada
#trap "" SIGINT  
trap "" SIGTSTP 
# INICIA EL PROCESO DE LOGIN
login
# VERIFICAMOS SI EL USUARIO TIENE INSTALDA LA HERRAMIENTA NECESARIA PARA EL LOGIN
check
# BUSCA AL USUARIO EN etc/shadow Y GUARDA EN "mtch_line" LA LINEA DE COINCIDENCIA, SI ES QUE EXISTE
line=`sudo -S grep -r $user /etc/shadow` 
# IFS, VARIABLE DE ENTORNO QUE INDICA EL VALOR DE SEPARACION DE CADENAS POR DEFECTO. AL CAMBIARLO, LE DECIMOS QUE SIMBOLO QUEREMOS COMO SEPARADOR
IFS='$' 
# PASA LO RECIBIDO EN mtch_line A UN ARREGLO CON EL FORMATO DE SEPARACIÓN, UN ELEMENTO DEL ARREGLO SERA PRECEDIDO Y/O SUCEDIDO DE UN '$'
read -a array <<< "$line" 
# ES IMPORTANTE DEVOLVER A SU VALOR IFS
IFS=' ' 

# LE DAMOS A idx LA CONTRASEÑA ENCRIPTADA DEL USUARIO REGISTRADA EN EL SISTEMA 
idx="\$${array[1]}\$${array[2]}"
# CON AYUDA DE PYTHON Y CRYPT COMPROBAMOS LA CONTRASEÑA INGRESADA POR EL USUARIO CON LA REGISTRADA EN EL SISTEMA, CRYPT ES USADO PARA VERIFICAR CONTRASEÑAS DE UNIX
hash=`python -c 'import crypt; import sys; print crypt.crypt( sys.argv[1] , sys.argv[2])' $password $idx`
# GUARDA EN mtch_line EL NUMERO DE COINCIDENCIAS DE line EN hash 
mtch_line=`echo "$line" | grep -c "$hash"`
# SI ESE NUMERO DE COINCIDENCIAS ES 1 ENTONCES, LA CONTRASEÑA ES CORRECTA, DE LO CONTRARIO INFORMA DE CREDENCIALES INCORRECTAS	
if [ "$mtch_line" -eq 1 ]; then
	clear
	printf "\t\t\t**********----Bienvenido a la PROLIN ----**********\n"
	printf "\t\t**--Con el comando \"ayuda\" se muestran las opciones de comando disponibles--**\n"
	printf "\t\t\t       **--Para salir ingrese \"salir\" --**\n"
	true=1
  	while [[ $true -eq 1 ]]; do
	read -p "$(echo -e "$BOLD$PURPURA$user:$BOLD$PURPURA$PWD$RESET"$ "" )" command
	read -a aCommand <<< "$command" 
    case "${aCommand[0]}" in 
	  	'arbol')
			#CON LO SIGUIENTE PERMITE DIRECTORIOS CON ESPACIOS EN SU NOMBRE
			if [ "${aCommand[2]}" != "" ]; then
				aux=1
				arg="${aCommand[1]} ${aCommand[2]}"
				i=3
				while [[ $aux -eq 1 ]]; do
					if [ "${aCommand[i]}" != "" ]; then
						arg="$arg ${aCommand[i]}"
						i=$((i+1))
					else
						break
					fi					
				done
				bash arbolTree.sh "${arg}"
			else
				bash arbolTree.sh "${aCommand[1]}"
			fi
		;;

		'ayuda')
			printf "$PURPURA\n"
	        printf "\t|---------------------------------------------------------------------|\n"
	        printf "\t|                  AYUDA. Opciones disponibles                        |\n"
	        printf "\t|---------------------------------------------------------------------|\n"
	        printf "\t|Comando    |Descripcion                                              |\n"
	        printf "\t|---------------------------------------------------------------------|\n"
	        printf "\t|arbol      |imprime contenido de un directorio                       |\n"
	        printf "\t|           |Sintaxis: $ arbol <nombre_del_directorio>                |\n"
	        printf "\t|ayuda      |imprime esta tabla                                       |\n"
	        printf "\t|infosis    |imprime info del sistema(SO, arquitectura, etc.)         |\n"
	        printf "\t|hora       |imprime la hora del sistema en formato de 24 hrs hh:mm:ss|\n"
	        printf "\t|fecha      |imprime la fecha del sistema                             |\n"
	        printf "\t|buscar     |permite buscar cualquier archivo en la carpeta de usuario|\n"
	        printf "\t|           |Sintaxis: $ buscar <nombre_del_archivo> <nombre_del_directorio>|\n"
	        printf "\t|ahorcado   |carga el juego 'ahorcado' propio de esta terminal        |\n"
	        printf "\t|gato       |carga el juego 'gato' propio de esta terminal            |\n"
	        printf "\t|reproductor|permite reproducir archvos de audio y agrega caracteristicas de un reproductor de musica|\n"
	        printf "\t|cls        |limpia la pantalla (clear)                               |\n"
	        printf "\t|creditos   |nombre de los desarrolladores de esta terminal           |\n"
	        printf "\t|salir      |abandonar la terminal (exit)                             |\n"
	        printf "\t|---------------------------------------------------------------------|\n"
	        printf "$RESET\n"
		;;

		'infosis')
			bash infosis.sh
		;;

		'hora')
	        bash hora.sh
		;;
			
		'fecha')
			bash fecha.sh
		;;

		'buscar')
			##CHECAR LA MANERA DE RECIBIR LOS ARGUMENTOS DEBIDO A QUE ASÍ NO ACEPTA CARPETAS CON ESPACIOS PARA BUSCAR

			## VERIFICA QUE SE HAYAN RECIBIDO LOS ARGUMENTOS NECESARIOS PARA EJECUTAR EL COMANDO
			if [ -z "${aCommand[1]}" ]; then
				printf "$RED Faltan argumentos, ejecute 'ayuda' para mas informacion.$RESET\n"
			elif [ -z "${aCommand[2]}" ]; then
				printf "$RED Faltan argumentos, ejecute 'ayuda' para mas informacion.$RESET\n"
			else
				bash busqueda.sh "${aCommand[1]}" "${aCommand[2]}"
			fi
		;;

		'creditos')
			#FALTA COLOR DE VANESSA
			printf "\t$REDBK DESARROLLADORES: $RESET\n\t\t *--Vanessa Magin Gomez--*\n\t\t$BLUE *--Héctor Mauricio Garcia Serrano--* $RESET\n\t$REDBK Fecha de finalizacion: 8 Noviembre de 2020\n$RESET\n"
		;;

		'ahorcado')
	        bash ahorcado.sh
		;;
			
		'gato')
			bash gato.sh
		;;

		'reproductor')
	        bash reproductor.sh
		;;
			
		#OTROS COMANDOS UTILES
		'cls')
			clear
		;;
			
		'salir')
			exit
		;;
			
		## EN CASO DE USAR UN COMANDO DIFERENTE A LOS DISPONIBLES EN ESTA SHELL SE LO PASA AL SISTEMA
		*)
			command $command
		;;
	  esac
    done
else
	echo "Usuario o contraseña incorrectos."
fi