#!/bin/bash
## ----------PROYECTO FINAL LINUX PROTECO-------------##
## ------------PROLIN MAURICIO Y VANESSA--------------##
## ------------13 DE NOVIEMBRE DE 2020----------------##
## ----Juego del gato de 2 jugadores para shell-------##

#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
#COLORES:
BOLD="\e[1m"
RED="\e[1;31m"
RESET="\e[0m"
CYAN="\e[1;36m"
#COLORES CON BACKGROUND:
PURPURA="\e[1;45m"
YELLOW="\e[1;43m"
CYANBK="\e[1;46m"
BLUE="\e[4;44m"
REDBK="\e[4;41m"
GREEN="\e[1;42m"
REDBKL="\e[4;101m"

# Indica si ya no se desea jugar más
gameover=0
# Indica el final del juego, si es 1, ganó el jugador 1, si es 2, ganó el jugador 2 y si es 3, empate.
resultado=0
# Cuenta las casillas utilizadas, si es 9 y no hubo un ganador antes, resultado se vuelve 3 
contador=0 
#Arreglo que guarda las casillas utilizadas, si son 0 estan vacias, 1 y 2 para cada jugador respectivamente
casillas=(0 0 0 0 0 0 0 0 0)

#Imprime el primer gato, referencia para ingresar los números.
#* Una función puede recibir los argumentos que sean, estos se manejaran dentro
#* en el orden en que se pasaron. EN esta se usa el primero hasta el tercer argumento
function linea2() 
{		
	printf "$CYAN"			
	echo "_____________"	
	echo "|   |   |   |"
	echo "| $1 | $2 | $3 |"
	echo "|___|___|___|"
	printf "$RESET"
}

 #Imprime el tablero del gato con la nueva marca. Hay una conversión porque se pasan argumentos númericos y queremos imprimir "X", "O", " "(Espacio en blanco).
function linea()
{				
	array=(" " " " " ")		#* Arreglo auxiliar. De 3 elementos de espacios vacíos
	aux=("$1" "$2" "$3") #* Arreglo de los argumentos recibidos, se pasan de 3 en 3.
						#* Las banderas son:
						# 0=Espacio
						# 1="X", jugador 1
						# 2="O", jugador 2

	# Se llena el arreglo temporalmente segun los argumentos recibidos
	for (( i = 0; i < 3; i++ )); do
		if [ "${aux["${i}"]}" = 0 ]; then #*Este if se puede eliminar porque el arreglo array está inicializado en " "(Espacios).
			array["$i"]=" "
		fi
		if [ "${aux["${i}"]}" = 1 ]; then
			array["$i"]="X"
		fi
		if [ "${aux["${i}"]}" = 2 ]; then
			array["$i"]="O"
		fi
	done
	linea2 "${array[0]}" "${array[1]}" "${array[2]}"
}

# IMPRIME EL TABLERO CON NUMERO ED CASILLA PARA AYUDAR AL USUARIO
referencia()
{
	linea2 "1" "2" "3"
	linea2 "4" "5" "6"
	linea2 "7" "8" "9"
}

# HACE LA FUNCIÓN DE PREGUNTAR SI SE DESEA JUGAR DE NUEVO, DE SER ASÍ SETEA TODO EN 0, DE LO CONTRARIO SE DESPIDE
playagain()
{
	true=1
	while [ $true -eq "1" ]; do
		printf "$CYANBK ¿Desean jugar de nuevo? (s/n): $RESET"
		read answer
		if [ "$answer" == "s" ]; then
			#Setea todo en 0
			gameover=0
			resultado=0
			contador=0 
			casillas=(0 0 0 0 0 0 0 0 0)
			clear
			echo -e "\t\t$CYANBK ++++__GATO__++++$RESET"
			echo -e "\t$CYANBK  Jugador 1 es X. Jugador 2 es O $RESET"
			echo -e "$CYANBK Cada jugador ingrese el número de casilla que quiere$RESET"
			echo -e "$CYANBK    llenar con su simbolo basandose en el tablero.$RESET"
			return
		elif [ "$answer" == "n" ]; then
			printf "$CYANBK ¡GRACIAS POR JUGAR!$RESET \n"
			sleep 2
			clear
			exit 0
		else
			echo -e "$CYANBK Por favor ingrese una respuesta correcta. Intente de nuevo$RESET"
		fi	
	done
	
}

#Imprime el letrero de victoria
pwin()
{
	echo -e "$CYANBK"
	echo -e	"	     /\  \         /\  \         /\__\         /\  \         /\  \         /\  \         /\  \    "
	echo -e	"	    /::\  \       /::\  \       /::|  |       /::\  \       /::\  \        \:\  \       /::\  \   "
	echo -e	"	   /:/\:\  \     /:/\:\  \     /:|:|  |      /:/\:\  \     /:/\ \  \        \:\  \     /:/\:\  \  "
	echo -e	"	  /:/  \:\  \   /::\~\:\  \   /:/|:|  |__   /::\~\:\  \   _\:\~\ \  \       /::\  \   /::\~\:\  \ "
	echo -e	"	 /:/__/_\:\__\ /:/\:\ \:\__\ /:/ |:| /\__\ /:/\:\ \:\__\ /\ \:\ \ \__\     /:/\:\__\ /:/\:\ \:\__\ "
	echo -e	"	 \:\  /\ \/__/ \/__\:\/:/  / \/__|:|/:/  / \/__\:\/:/  / \:\ \:\ \/__/    /:/  \/__/ \:\~\:\ \/__/"
	echo -e	"	  \:\ \:\__\        \::/  /      |:/:/  /       \::/  /   \:\ \:\__\     /:/  /       \:\ \:\__\  "
	echo -e	"	   \:\/:/  /        /:/  /       |::/  /        /:/  /     \:\/:/  /     \/__/         \:\ \/__/  "
	echo -e	"	    \::/  /        /:/  /        /:/  /        /:/  /       \::/  /                     \:\__\    "
	echo -e	"	     \/__/         \/__/         \/__/         \/__/         \/__/                       \/__/    "
	echo -e "$RESET\n\n"
}

#Imprime el letrero de EMPATE
ptie()
{
	echo -e "$CYANBK"
	echo -e	"    /\  \         /\__\         /\  \         /\  \         /\  \         /\  \    "
	echo -e	"   /::\  \       /::|  |       /::\  \       /::\  \        \:\  \       /::\  \   "
	echo -e	"  /:/\:\  \     /:|:|  |      /:/\:\  \     /:/\:\  \        \:\  \     /:/\:\  \  "
	echo -e	" /::\~\:\  \   /:/|:|__|__   /::\~\:\  \   /::\~\:\  \       /::\  \   /::\~\:\  \ "
	echo -e	"/:/\:\ \:\__\ /:/ |::::\__\ /:/\:\ \:\__\ /:/\:\ \:\__\     /:/\:\__\ /:/\:\ \:\__\ "
	echo -e	"\:\~\:\ \/__/ \/__/~~/:/  / \/__\:\/:/  / \/__\:\/:/  /    /:/  \/__/ \:\~\:\ \/__/"
	echo -e	" \:\ \:\__\         /:/  /       \::/  /       \::/  /    /:/  /       \:\ \:\__\  "
	echo -e	"  \:\ \/__/        /:/  /         \/__/        /:/  /     \/__/         \:\ \/__/  "
	echo -e	"   \:\__\         /:/  /                      /:/  /                     \:\__\    "
	echo -e	"    \/__/         \/__/                       \/__/                       \/__/    "
	echo -e "\t\t\t\t¡¡FELICIDADES A AMBOS!!$RESET"
	echo -e "\n\n"
}


#							#
#	COMIENZA EL PROGRAMA	#
#							#
echo -e "\t\t$CYANBK ++++__GATO__++++$RESET"
echo -e "\t$CYANBK  Jugador 1 es X. Jugador 2 es O $RESET"
echo -e "$CYANBK Cada jugador ingrese el número de casilla que quiere$RESET"
echo -e "$CYANBK    llenar con su simbolo basandose en el tablero.$RESET"

#Se manda a imprimir el tablero con los argumentos del 1 al 9 que son las casillas
referencia

# Comienza el ciclo que permite el juego
while [ $gameover = 0 ] 
	do
	# Auxiliares para el control de casillas
	aux1=0
	aux2=0
	# Valida casillas disponibles para marcar, si está libre, aux2 cambia de valor y sale
	while [[ $aux2 = 0 ]]; do 
		if [[ $contador = 9 ]]; then
			resultado=3	
		fi
		printf "$REDBK Jugador 1: ingrese la casilla que desea:$RESET"
		read num_intdo
		#Nota: teclear Enter en esta parte, lo toma como si hubiera tecleado la ultima posición.
		#Se arregló agregando las primeras 2 condiciones del sig if, la primera manda un error "Se espera un comparador unario", no sé
		#por qué sale pero aún así funciona xd pero se arregla con l comando 2>/dev/null que redirecciona el error a un cubo de basura 
		#unicamente admite valores [1,9], no admite otra tecla.
		#la tercera condición valida que el lugar esté libre	
		if [ $num_intdo -ge "1" 2>/dev/null ] && [ $num_intdo -le "9" ] && [ ${casillas[${num_intdo}-1]} = 0 ]; then
			casillas[${num_intdo}-1]=1 #* Coloca la bandera del jugador al arreglo casillas en la posición deseada
			((contador++)) 
			aux2=1 #* para salir del while que esta validando a aux2
		else
			#clear
			echo -e "$REDBK Casilla ocupada o invalida. Intente de nuevo.$RESET"
		fi
	done

	# Se revisa las combinaciones de casillas verticales y horizontales, si son iguales gana
	for (( i = 0; i < 9; i=i+3 )); do 
		if [ ${casillas[0+${i}]} = 1 ] && [ ${casillas[1+${i}]} = 1 ] && [ ${casillas[2+${i}]} = 1 ]; then
			resultado=${casillas[0+${i}]}
		fi
	done
	for (( i = 0; i < 3; i++ )); do
		if [ ${casillas[0+${i}]} = 1 ] && [ ${casillas[3+${i}]} = 1 ] && [ ${casillas[6+${i}]} = 1 ]; then
			resultado=${casillas[0+${i}]}
		fi
	done

	# Verifica la diagonal principal, si se cumple, vuelve resultado igual al jugador que completó la diagonal
	if [ ${casillas[0]} = 1 ] && [ ${casillas[4]} = 1 ] && [ ${casillas[8]} = 1 ]; then
		resultado=${casillas[0]}
	fi
	# Verifica la diagonal invertida, si se cumple, vuelve resultado igual al jugador que completó la diagonal
	if [ ${casillas[2]} = 1 ] && [ ${casillas[4]} = 1 ] && [ ${casillas[6]} = 1 ]; then
		resultado=${casillas[2]}
	fi
	
	# Se valuan los resultados al momento
	if [ $resultado -eq "1" ]; then
		clear
		echo -e "$REDBKL TABLERO FINAL:$RESET" 
		# Se imprime el tablero final
		for (( j = 0; j < 9; j=j+3 )); do 
			linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
		done
		echo -e "\t\t\t\t$REDBKL GANA EL JUGADOR: $resultado , ¡¡FELICIDADES!!$RESET"	
		pwin
		playagain
	elif [ $resultado -eq "3" ]; then
		clear
		echo -e "$REDBKL TABLERO FINAL:$RESET" 
		# Se imprime el tablero final
		for (( j = 0; j < 9; j=j+3 )); do 
			linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
		done	
		echo -e "\t\t\t\t\t$REDBKL ¡¡ EMPATE !!$RESET"
		ptie
		playagain
	elif [ $contador = 9 ]; then
		clear
		echo -e "$REDBKL TABLERO FINAL:$RESET" 
		# Se imprime el tablero final
		for (( j = 0; j < 9; j=j+3 )); do 
			linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
		done	
		echo -e "\t\t\t\t\t$REDBKL ¡¡ EMPATE !!$RESET"
		ptie
		playagain
	fi
	
	clear
	# Imprime el tablero del gato hasta el momento
	for (( j = 0; j < 9; j=j+3 )); do 
		linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}";
	done	
	referencia
	# Se repiten las lineas anteriores con valores para el jugador 2
	while [[ $aux1 = 0 ]]; do
		if [[ $contador = 9 ]]; then
			resultado=3
		fi
		printf "$REDBK Jugador 2: ingrese la casilla que desea:$RESET"
		read num_intdo
		if [ $num_intdo -ge "1" 2>/dev/null ] && [ $num_intdo -le "9" ] && [ ${casillas[${num_intdo}-1]} = 0 ]; then
			casillas[${num_intdo}-1]=2
			((contador++))
			aux1=1
		else
			echo -e "$REDBK Casilla ocupada, intente de nuevo.$RESET"
		fi
	done
	for (( i = 0; i < 9; i=i+3 )); do
		if [ ${casillas[0+${i}]} = 2 ] && [ ${casillas[1+${i}]} = 2 ] && [ ${casillas[2+${i}]} = 2 ]; then
			resultado=${casillas[0+${i}]}
		fi
	done
	for (( i = 0; i < 3; i++ )); do
		if [ ${casillas[0+${i}]} = 2 ] && [ ${casillas[3+${i}]} = 2 ] && [ ${casillas[6+${i}]} = 2 ]; then
			resultado=${casillas[0+${i}]}
		fi
	done
	if [ ${casillas[0]} = 2 ] && [ ${casillas[4]} = 2 ] && [ ${casillas[8]} = 2 ]; then
		resultado=${casillas[0]}
	fi
	if [ ${casillas[2]} = 2 ] && [ ${casillas[4]} = 2 ] && [ ${casillas[6]} = 2 ]; then
		resultado=${casillas[2]}
	fi
	clear
	for (( j = 0; j < 9; j=j+3 )); do
		linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
	done	
	
	if [ $resultado -eq "2" ]; then
		clear
		echo -e "$REDBKL TABLERO FINAL:$RESET"
		# Se imprime el tablero final
		for (( j = 0; j < 9; j=j+3 )); do 
			linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
		done	
		echo -e "\t\t\t\t$REDBKL GANA EL JUGADOR: $resultado , ¡¡FELICIDADES!!$RESET" 
		pwin
		playagain
	elif [ $resultado -eq "3" ]; then
		clear
		echo -e "$REDBKL TABLERO FINAL:$RESET"
		# Se imprime el tablero final
		for (( j = 0; j < 9; j=j+3 )); do 
			linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
		done	
		echo -e "\t\t\t\t\t$REDBKL ¡¡ EMPATE !!$RESET" 
		ptie
		playagain
	elif [ $contador = 9 ]; then
		clear
		echo -e "$REDBKL TABLERO FINAL:$RESET" 
		# Se imprime el tablero final
		for (( j = 0; j < 9; j=j+3 )); do 
			linea "${casillas[0+"${j}"]}" "${casillas[1+"${j}"]}" "${casillas[2+"${j}"]}"
		done	
		echo -e "\t\t\t\t\t$REDBKL ¡¡ EMPATE !!$RESET"
		ptie
		playagain
	fi	
	referencia
done



