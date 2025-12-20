# Me falta crear codigo que comprueba las variaables
# del entorno y genera un archivo con las variables
# en cosas/ y ademas de eso tambien añade algo como
#
# if [[ $1 == "--info" ]]
# then
#      echo "La variable $tal es cual"
#      echo "La variable $noseque es nosecuantos"
# fi
#
# Para permitir al script "root.sh" decirle "cuales
# son las variables que tienen el fichero de variables"
# sin tener que hacer mas codigo, esto se puede hacer
# con un for, o, si sabemos que el numero de variables
# no va a cambiar, estaticamente, en un lenguaje con
# arrays (QUE FUNCIONEN BIEN*) podria hacer un Array
# o un Diccionario con las variables y su valor y guardar
# solo eso en un fichero .json o algo por el estilo.
#
# * Los arrays de Bash son raros. Muy raros.
