SCRIPT_NAME=server.py
BINARY_NAME=jmail
INSTALL_DIR=/usr/bin
SERVICE_NAME=jmail.service
SYSTEMD_DIR=/etc/systemd/system

.PHONY: instalar borrar

instalar:
	@echo "Instalando J-Mail..."
	# Crear directorio de correos (Aunque esto lo hace el 'servidor' en si, pero por si acaso :D
	mkdir -p /jmail/perdido
	cp $(SCRIPT_NAME) $(INSTALL_DIR)/$(BINARY_NAME)
	chmod +x $(INSTALL_DIR)/$(BINARY_NAME)
	cp $(SERVICE_NAME) $(SYSTEMD_DIR)/
	systemctl daemon-reload
	systemctl enable $(SERVICE_NAME)
	systemctl restart $(SERVICE_NAME)
	@echo "J-Mail instalado y corriendo como servicio."

borrar:
	@echo "Desinstalando J-Mail..."
	systemctl stop $(SERVICE_NAME)
	systemctl disable $(SERVICE_NAME)
	rm -f $(SYSTEMD_DIR)/$(SERVICE_NAME)
	rm -f $(INSTALL_DIR)/$(BINARY_NAME)
	systemctl daemon-reload
	@echo "J-Mail eliminado del sistema."
