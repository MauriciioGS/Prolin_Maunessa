#!/bin/bash

## -----------------PROYECTO FINAL LINUX PROTECO--------------------##
## -------------------PROLIN MAURICIO Y VANESSA---------------------##
## --------------------13 DE NOVIEMBRE DE 2020----------------------##
## -----------------------------------------------------------------##
## Juego: Ahorcado. Utiliza un diccionario de palabras para elegir  ##
## alguna para que el usuario la adivine, es como un catalogo de    ##
## palabras para ofrecer, este se encuentra en dictionary.dat       ##

#FORMATO DE COLOR:
#CAMBIO DE COLOR:  \e[<tipo_letra>;<código_color>m
#RESETEO DE COLOR:  \e[0m
#COLORES:
BOLD="\e[1m"
ORANGE="\e[1;33m"
YELLOW="\e[1;43m" #o 
RED="\e[1;31m"
#CYAN=36
RESET="\e[0m"
#COLORES CON BACKGROUND:
PURPURA="\e[1;45m"
BLUE="\e[4;44m"
REDBK="\e[1;41m"
ORANGEBK="\e[4;43m"

#Se declaran 3 arreglos auxiliares en la ejecución del juego y uno fundamental
declare -a words  # words recibe las palabras del diccionario
declare -a word_array  # recibe a la palabra en total, todas sus letras y las almacena
declare -a alphabet_array  #  sera de utilidad para guardar las letras del abecedario y mostrarle al usuario cuales ya utilizó
alphabet=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")
#VARIABLES ÚTILES PARA LA EJECUCIÓN
i=0
error=0
correct=0
char=0
gameover=0
error=0
correct=0

# LEE EL ARCHIVO dictionary.dat REDIRECCIONANDO SU CONTENIDO PARA DESPUÉS LEERLO LINEA POR LINEA Y GUARDAR ESAS PALABRAS EN EL ARREGLO words
read_file()
{
	exec 3<&0
	exec 0< dictionary.dat
	while read LINEA
	do
		words[i]=$LINEA
		i=`expr $i + 1`
	done
	exec 0<&3
}

# SELECCIONA ALEATORIAMENTE UNA PALABRA OBTENTIENDO UN NÚMERO EL CUÁL INTERPRETA COMO UN INDICE DENTRO DEL ARREGLO words, UNA VEZ ELEGIDO
# SETEA EL RESTO DEL ARREGLO EN 0, DESTACA ESA PALABRA
get_wordi()
{
	wordIndex=$RANDOM
	#* Se establece aleatoriamente un numero para tomar una palabra del dic, -ge es >=
	while [ $wordIndex -ge $i ]	
	do
		wordIndex=$RANDOM
	done
	aux=0
	#* Pone las palabras anteriores a la palabra seleccionada en cero, para encontrar el indice de la palabra
	#seleccioanda, esto es recorriendo el diccioanrio previamente almacenado en el arreglo words hasta el indice obtenido anteriormente. -lt es <
	while [ $aux -lt ${#words[${wordIndex}]} ]; do
		word_array[$aux]=0
		aux=`expr $aux + 1`
	done
}

# SOLICITA AL USUARIO QUE INGRESE UNA LETRA Y VERIFICA SI ESA LETRA SE ENCUENTRA EN LA PALABRA, DE SER ASÍ 
guessLetter()
{
	j=0
	correct=0
	printf "\t$ORANGEBK Digita una letra:$RESET " #Solicita una letra al usuario y la guarda
	read guessLetter
	char=$guessLetter
	if [ ${#guessLetter} -eq "1" ]; then
		guessLetter=`echo $guessLetter | tr "[:upper:]" "[:lower:]"` #Remplazamos mayusculas por minusculas
		
		#printf "ES: ${words[${wordIndex}]}\n"

		while [ $j -lt ${#words[${wordIndex}]} ]
		do
			# *Compara la letra introducida con la letra en la posición j de la palabra. Entra al arreglo de palabras en la posición de la palabra buscada
			# y a su vez subdivide esa palabra en caracteres, se compara la letra y la letra 'j' de la palabra, si son iguales se coloca en el arreglo con
			# las letra de la palabra un 1 en la posicion de dicha letra
			if [ "$guessLetter" == "${words[${wordIndex}]:$j:1}" ] 
			then
				word_array[${j}]=1
				correct=1
			fi
			j=`expr $j + 1`
		done
	fi
	# 
	r=0
	numbLetter=0
	while [ ! $r == ${#words[${wordIndex}]} ]
	do	
		numbLetter=`expr $numbLetter + ${word_array[$r]}`
		r=`expr $r + 1`
	done
}

# DESTACA LAS LETRAS INTRODUCIDAS POR EL USUARIO (DEL ABECEDARIO) AL MOMENTO DE SER LLAMADA, COLOCA (-) SI NO HA SIDO INTRODUCIDA E SUNA AYUDA EN EL JUEGO 
printAlphabet()
{
	mode=$1
	#* Si entra en modo facil imprime el alfabeto usado, de lo contrario no hace nada
	if [ $mode -eq "1" ]; then
		printf "$ORANGEBK MODO FACIL$RESET \n"
		printf "$ORANGEBK Letras introducidas:$RESET"
		aux=0
		while [ ! "$aux" == "26" ]
		do
			# *Coloca en el arreglo auxiliar (donde está el alfabeto) un 1 si la letra guardada en char esta en el abecedario, si esta en char es porque fue la introducida recientemente
			if [ "$char" == "${alphabet[$aux]}" ]; then
				alphabet_array[$aux]="1"
			fi
			
			# *Si en el arreglo hay un 1 esa posición es una letra acertada en el alfabeto no auxiliar, si no solo colocar (-)
			if [ ${alphabet_array[$aux]} == "1" ]; then
				printf "$ORANGEBK ${alphabet[$aux]}$RESET" 
			else
				printf "$ORANGEBK-$RESET" 
			fi
			((aux++))
		done
		printf "\n\n"
		char=""
	elif [ $mode -eq "2" ]; then
		printf "$ORANGEBK MODO NORMAL$RESET \n"
	else
		printf "$ORANGEBK MODO DIFICIL (SOLO 3 INTENTOS)$RESET \n"
	fi
}

# IMPRIME LAS LETRAS DE LA PALABRA COMO HAN SIDO ACERTADAS, IMPRIME (-) PARA LAS NO ACERTADAS
printWord()
{
	printf "$ORANGEBK PALABRA: $RESET"
	aux=0
	while [ ! $aux == ${#words[${wordIndex}]} ]
	do
		# *Si hay un 1 en la posición revisada, significa que esa letra ha sido acertada y prodece a imprimirla desde words, donde esta distinguida la palabra
		if [ ${word_array[${aux}]} -eq "1" ]; then
			printf "$ORANGEBK ${words[${wordIndex}]:$aux:1}$RESET" #*Especificamente aqui realiza la acción, pues diivide a la palabra en sus letras asignandole indices como en un arreglo y aux accede a un indice
		else
			printf "$ORANGEBK-$RESET"
		fi
		aux=`expr $aux + 1`
	done
	printf "\n\n"
}

#LAS SIGUIENTES FUNCIONES IMPRIMEN UNA PARTE DEL 'TABLERO' SEGUN SEAN LLAMADAS
drawHanged() 
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET"
}
drawHead() 
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "       _/_\_       |"
	echo -e "        (_)        |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET"
}
drawTorso() 
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "       _/_\_       |"
	echo -e "        (_)        |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET"
}
drawRArm() 
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "       _/_\_       |"
	echo -e "        (_)        |"
	echo -e "         |         |"
	echo -e "      ---|         |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET "
}
drawLArm() 
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "       _/_\_       |"
	echo -e "        (_)        |"
	echo -e "         |         |"
	echo -e "      ---|---      |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET "
}
drawRLeg() 
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "       _/_\_       |"
	echo -e "        (_)        |"
	echo -e "         |         |"
	echo -e "      ---|---      |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "        /          |"
	echo -e "      _/           |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET "
}
drawLeLeg()
{
	#clear
	echo -e "$ORANGE          __________"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "       _/_\_       |"
	echo -e "        (_)        |"
	echo -e "         |         |"
	echo -e "      ---|---      |"
	echo -e "         |         |"
	echo -e "         |         |"
	echo -e "        / \        |"
	echo -e "      _/   \_      |"
	echo -e "                   |"
	echo -e "      _____________|_____"
	echo -e "                          $RESET "
}

#Imprime el letrero de victoria
pwin()
{
	echo -e "$YELLOW"
	echo -e	"	     /\  \         /\  \         /\__\         /\  \         /\  \         /\  \         /\  \    "
	echo -e	"	    /::\  \       /::\  \       /::|  |       /::\  \       /::\  \        \:\  \       /::\  \   "
	echo -e	"	   /:/\:\  \     /:/\:\  \     /:|:|  |      /:/\:\  \     /:/\ \  \        \:\  \     /:/\:\  \  "
	echo -e	"	  /:/  \:\  \   /::\~\:\  \   /:/|:|  |__   /::\~\:\  \   _\:\~\ \  \       /::\  \   /::\~\:\  \ "
	echo -e	"	 /:/__/_\:\__\ /:/\:\ \:\__\ /:/ |:| /\__\ /:/\:\ \:\__\ /\ \:\ \ \__\     /:/\:\__\ /:/\:\ \:\__\ "
	echo -e	"	 \:\  /\ \/__/ \/__\:\/:/  / \/__|:|/:/  / \/__\:\/:/  / \:\ \:\ \/__/    /:/  \/__/ \:\~\:\ \/__/"
	echo -e	"	  \:\ \:\__\        \::/  /      |:/:/  /       \::/  /   \:\ \:\__\     /:/  /       \:\ \:\__\  "
	echo -e	"	   \:\/:/  /        /:/  /       |::/  /        /:/  /     \:\/:/  /     \/__/         \:\ \/__/  "
	echo -e	"	    \::/  /        /:/  /        /:/  /        /:/  /       \::/  /                     \:\__\    "
	echo -e	"	     \/__/         \/__/         \/__/         \/__/         \/__/                       \/__/   "
	echo -e "$RESET\n\n"
}

#Imprime el letrero de derrota
plost()
{
	echo -e "$REDBK"
	echo -e	"		 /\  \         /\  \         /\  \         /\  \          ___        /\  \         /\  \         /\  \    "
	echo -e	"	    /::\  \       /::\  \       /::\  \       /::\  \        /\  \      /::\  \        \:\  \       /::\  \   "
	echo -e	"	   /:/\:\  \     /:/\:\  \     /:/\:\  \     /:/\:\  \       \:\  \    /:/\ \  \        \:\  \     /:/\:\  \  "
	echo -e	"	  /::\~\:\  \   /::\~\:\  \   /::\~\:\  \   /:/  \:\__\      /::\__\  _\:\~\ \  \       /::\  \   /::\~\:\  \ "
	echo -e	"	 /:/\:\ \:\__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/__/ \:|__|  __/:/\/__/ /\ \:\ \ \__\     /:/\:\__\ /:/\:\ \:\__\ "
	echo -e	"	 \/__\:\/:/  / \:\~\:\ \/__/ \/_|::\/:/  / \:\  \ /:/  / /\/:/  /    \:\ \:\ \/__/    /:/  \/__/ \:\~\:\ \/__/"
	echo -e	"	      \::/  /   \:\ \:\__\      |:|::/  /   \:\  /:/  /  \::/__/      \:\ \:\__\     /:/  /       \:\ \:\__\  "
	echo -e	"	       \/__/     \:\ \/__/      |:|\/__/     \:\/:/  /    \:\__\       \:\/:/  /     \/__/         \:\ \/__/  "
	echo -e	"	                  \:\__\        |:|  |        \::/__/      \/__/        \::/  /                     \:\__\    "
	echo -e	"	                   \/__/         \|__|         ~~                        \/__/                       \/__/    "
	echo -e "PALABRA: \"${words[$wordIndex]}\"$RESET"
	echo -e "\n\n"
}

# ESTA FUNCIÓN REALIZA EL JUEGO EN MODO DIFICIL ****MODIFICAR****
hard()
{
	while [ "$gameover" == "0" ]; do #*Mientras no hayamos perdido aun podremos seguir jugando hasta que gameover sea 1
		aux=0
		#* Setea el arreglo alphabet_array con 26 valores en 0
		while [ ! "$aux" == "26" ]; do
			alphabet_array[$aux]=0
			aux=`expr $aux + 1` #*expr de expresion, nos ayuda a realizar cálculo de expresiones
		done

		word_array=0
		alphabet_array=0	
		error=0
		correct=0

		get_wordi 
		aux=0 
		drawHanged
		printAlphabet 3
		printWord

	    #* Se muestra la función para que el usuario haga el intento con cada letra, dependiendo el error y su número de error se va llenando el cuerpo del ahorcado
		while [[ ! "${numbLetter}" == "${#words[${wordIndex}]}" && ! "$error" == "3" ]]
		do
			guessLetter
		
			if [ $correct == "0" ]
			then 
				error=`expr $error + 1`
			fi	
		
			if [ $error == "0" ]
			then
				drawHanged
			elif [ $error == "1" ]
			then
				drawTorso
			elif [ $error == "2" ]
			then
				drawLArm
			elif [ $error == "3" ]
			then
				drawLeLeg
			fi
			printAlphabet 3
			printWord
		done
		#* Si los indices coinciden entonces significa que el usuario ganó
		if [ "${numbLetter}" == "${#words[${wordIndex}]}" ]; then
			pwin
			gameover=1
		fi
		#* Si se llegó al maximo de errores, imprime el letrero de perdida
		if [ $error == "3" ]; then
			plost
			gameover=1
		fi
		#* Cuando gameover sea 1 se ha terminado el juego, pero pregunta si desea jugar de nuevo
		if [ "$gameover" == "1" ]; then
			printf "\n\n$ORANGEBK ¿Deseas jugar de nuevo? (s/n): $RESET"
			read answer
			if [ "$answer" == "s" ]; then
				clear
				modes
			elif [ "$answer" == "n" ]; then
				printf "$ORANGEBK ¡GRACIAS POR JUGAR!$RESET \n"
				sleep 2
				clear
				exit 0
			fi
		fi
	done
}

# ES LA FUNCIÓN MÁS IMPORTANTE, LA QUE EJECUTA EL JUEGO LLAMANDO A LAS DEMÁS, PREGUNTA AL USUARIO QUE MODO DE JUEGO QUIERE JUGAR Y EN BASE A ELLO UTILIZA LAS FUNCIONES
modes()
{
	gameover=0
	error=0
	correct=0
	#COMIENZA EL JUEGO
	while [ "$gameover" == "0" ]; do #*Mientras no hayamos perdido aun podremos seguir jugando hasta que gameover sea 1
		aux=0
		answ=""
		printf "$ORANGEBK Elige la dificultad: f (para FACIL), n (para NORMAL), d (para DIFICIL)\n"
		printf "El modo FACIL muestra las letras del abecedario que has usado, en el modo NORMALse elimina la anterior funcion. El modo DIFICIL otorga menos intentos.\n"
		printf "Ingrese su eleccion:$RESET "
		read answ
		true=1
		while [ $true -eq 1 ]; do
			case $answ in
				'f' )
					mode=1
					break
					;;
				'n' )
					mode=2
					break
					;;
				'd' )
					hard
					;;
				* )
					printf "$REDBK Ingrese una opción correcta.$RESET \n"
			esac	
		done
		#* Setea el arreglo alphabet_array con 26 valores en 0
		while [ ! "$aux" == "26" ]; do
			alphabet_array[$aux]=0
			aux=`expr $aux + 1` #*expr de expresion, nos ayuda a realizar cálculo de expresiones
		done

		word_array=0
		alphabet_array=0	
		error=0
		correct=0

		get_wordi 
		aux=0 
		drawHanged
		printAlphabet $mode
		printWord

	    #* Se muestra la función para que el usuario haga el intento con cada letra, dependiendo el error y su número de error se va llenando el cuerpo del ahorcado
		while [[ ! "${numbLetter}" == "${#words[${wordIndex}]}" && ! "$error" == "6" ]]
		do
			guessLetter
		
			if [ $correct == "0" ]
			then 
				error=`expr $error + 1`
			fi	
		
			if [ $error == "0" ]
			then
				drawHanged
			elif [ $error == "1" ]
			then
				drawHead
			elif [ $error == "2" ]
			then
				drawTorso
			elif [ $error == "3" ]
			then
				drawRArm
			elif [ $error == "4" ]
			then
				drawLArm
			elif [ $error == "5" ]
			then
				drawRLeg
			elif [ $error == "6" ]
			then
				drawLeLeg
			fi
			printAlphabet $mode
			printWord
			
		done
		#* Si los indices coinciden entonces significa que el usuario ganó
		if [ "${numbLetter}" == "${#words[${wordIndex}]}" ]; then
			pwin
			gameover=1
		fi
		#* Si se llegó al maximo de errores, imprime el letrero de perdida
		if [ $error == "6" ]; then
			plost
			gameover=1
		fi
		#* Cuando gameover sea 1 se ha terminado el juego, pero pregunta si desea jugar de nuevo
		if [ "$gameover" == "1" ]; then
			printf "\n\n$ORANGEBK ¿Deseas jugar de nuevo? (s/n): $RESET"
			read answer
			if [ "$answer" == "s" ]; then
				gameover=0
				clear
			elif [ "$answer" == "n" ]; then
				printf "$ORANGEBK ¡GRACIAS POR JUGAR!$RESET \n"
				sleep 2
			fi
		fi
	done
	clear
	exit 0
}

#							#
#	COMIENZA EL PROGRAMA	#
#							#
# SE LEE EL DICCIONARIO
read_file
# SE ENTRA A LA FUNCIÓN DEL JUEGO
modes


