#!/bin/bash

# ================================================================
# Скрипт для запуску Alfresco та OpenMAINT.
# ================================================================

# Шляхи встановлення
ALFRESCO_INSTALL_DIR="/opt/alfresco"
OPENMAINT_INSTALL_DIR="/home/openmaint/cmdbuild_30"

echo "--------------------------------------------------------"
echo "Запуск Alfresco та OpenMAINT..."
echo "--------------------------------------------------------"

# Зупинка та запуск Alfresco
# Це потрібно для уникнення проблем з файлами блокування (pid)
echo "Зупинка та запуск Alfresco..."
sudo "$ALFRESCO_INSTALL_DIR/alfresco.sh" stop
sudo rm -f "$ALFRESCO_INSTALL_DIR/tomcat/temp/catalina.pid"
sudo "$ALFRESCO_INSTALL_DIR/alfresco.sh" start

# Зупинка та запуск OpenMAINT
echo "Зупинка та запуск OpenMAINT..."
sudo -u openmaint "$OPENMAINT_INSTALL_DIR/bin/shutdown.sh"
sudo rm -f "$OPENMAINT_INSTALL_DIR/bin/catalina.pid"
sudo -u openmaint "$OPENMAINT_INSTALL_DIR/bin/startup.sh"

echo "--------------------------------------------------------"
echo "Alfresco та OpenMAINT успішно запущені!"
echo "--------------------------------------------------------"
