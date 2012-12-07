# Crea la base de datos, usuario y tablas para JSDSL
# Asume acceso al mysql como root sin password

case $1 in
createdb)
	echo "Creando base de datos para JSDSL..."
	mysql -u root -e "CREATE DATABASE jsdsl"
	mysql -u root -e "CREATE USER 'jsdsl'@'localhost' IDENTIFIED BY 'redhat01'"
	mysql -u root -e "CREATE TABLE jsdsl.command_history (id MEDIUMINT NOT NULL AUTO_INCREMENT, time_stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ticket_number CHAR(30), user_name CHAR(30), server VARCHAR(20), command VARCHAR(100), PRIMARY KEY (id))"
	mysql -u root -e "GRANT ALL ON jsdsl.* TO 'jsdsl'@'localhost'"
	echo "Base para JSDSL creada."
;;
destroydb)
	"Destruyendo base de datos JSDSL..."
	mysql -u root -e "DROP DATABASE jsdsl"
	mysql -u root -e "DROP USER 'jsdsl'@'localhost'"
	echo "Base de JSDSL destruida, usuario removido"
;;
createenv)
	JSDIR=/tmp/jsdsl
	if [ ! -e $JSDIR ]
	then
		echo "$JSDIR no existe, creando..."
		mkdir -p $JSDIR
		cp ./jsdslcli $JSDIR/
		echo "Directorio creado, archivos copiados."
	elif [ -e $JSDIR ]
	then
		if [ ! -e $JSDIR/jsdslcli ]
		then
			"No existe $JSDIR/jsdscli, creando..."
			cp ./jsdslcli $JSDIR/
			"Archivo(s) copiado(s)."
		fi
	fi
	sudo useradd -m -s /tmp/jsdsl/jsdslcli jsuser
	# te falta cambiar el password aca
;;
destroyenv)
	echo "Removiendo directorio(s)..."
	rm -rf $JSDIR
	sudo userdel -r jsuser
	echo "Ambiente destruido."
;;
createall)
	$0 createdb
	$0 createenv
;;
destroyall)
	$0 destroydb
	$0 destroyenv
;;
*)
	echo "Opciones: createall, destroyall, createdb, destroydb, createenv o destroyenv"
;;
esac
