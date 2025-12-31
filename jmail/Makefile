SCRIPT_NAME=server.py
BINARY_NAME=jmail
INSTALL_DIR=/usr/bin
SERVICE_NAME=jmail.service
SYSTEMD_DIR=/etc/systemd/system
SCRIPT_S_NAME=sserver.py
SERVICE_S_NAME=sjmail.service
BINARY_S_NAME=sjmail
COMUN_NAME=jmail_comun.py


.PHONY: instalar borrar purgar

instalar:
	@echo "Instalando J-Mail..."
	# Crear directorio de correos (Aunque esto lo hace el 'servidor' en si, pero por si acaso :D
	mkdir -p /jmail/perdido
	chmod 777 -Rvf /jmail/
	cp $(COMUN_NAME) $(INSTALL_DIR)/$(COMUN_NAME)
	cp $(SCRIPT_NAME) $(INSTALL_DIR)/$(BINARY_NAME)
	chmod +x $(INSTALL_DIR)/$(BINARY_NAME)
	cp $(SERVICE_NAME) $(SYSTEMD_DIR)/
	systemctl daemon-reload
	systemctl enable --now $(SERVICE_NAME)
	@echo "J-Mail instalado y corriendo como servicio."


	cp $(SCRIPT_S_NAME) $(INSTALL_DIR)/$(BINARY_S_NAME)
	chmod +x $(INSTALL_DIR)/$(BINARY_S_NAME)
	cp $(SERVICE_S_NAME) $(SYSTEMD_DIR)/
	mkdir -p /etc/jmail
	openssl req -x509 -newkey rsa:4096 -keyout /etc/jmail/server.key -out /etc/jmail/server.crt -sha256 -days 365 -nodes

	# Lo de SJMAIL

	systemctl daemon-reload
	systemctl enable --now $(SERVICE_S_NAME)
	@echo "SJ-Mail instalado y corriendo como servicio."

borrar:
	@echo "Desinstalando J-Mail..."
	systemctl disable --now $(SERVICE_NAME)
	systemctl disable --now $(SERVICE_S_NAME)
	rm -f $(SYSTEMD_DIR)/$(SERVICE_NAME)
	rm -f $(SYSTEMD_S_DIR)/$(SERVICE_NAME)
	rm -f $(SCRIPT_S_NAME) $(INSTALL_DIR)/$(BINARY_S_NAME)
	rm -f $(INSTALL_DIR)/$(BINARY_NAME)
	systemctl daemon-reload
	@echo "J-Mail (Y SJ-Mail) eliminado del sistema."

purgar:
	@echo "Borrando los archivos"
	rm -rvf /jmail/*
