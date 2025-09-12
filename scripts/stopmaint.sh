#!/bin/bash

# ================================================================
# Скрипт для зупинки Alfresco та OpenMAINT.
# ================================================================

# Підключення змінних з файлу конфігурації
# Використовуємо /home/ubuntu/openmaint_install/scripts/variables.sh, оскільки скрипт буде запускатись звідти
source /home/ubuntu/openmaint_install/scripts/variables.sh

echo "--------------------------------------------------------"
echo "Зупинка Alfresco та OpenMAINT..."
echo "--------------------------------------------------------"

# Зупинка Alfresco (потрібні права root для /opt/alfresco)
echo "Зупинка Alfresco..."
sudo "$ALFRESCO_INSTALL_DIR/alfresco.sh" stop
# Видалення PID-файлу, якщо він існує, для запобігання конфліктам
if [ -f "$ALFRESCO_INSTALL_DIR/tomcat/temp/catalina.pid" ]; then
    echo "Видалення старого PID-файлу Alfresco..."
    sudo rm -f "$ALFRESCO_INSTALL_DIR/tomcat/temp/catalina.pid"
fi


# Зупинка OpenMAINT (від імені користувача openmaint)
echo "Зупинка OpenMAINT..."
# Перевіряємо, чи існує директорія OpenMAINT
if [ ! -d "$OPENMAINT_INSTALL_DIR" ]; then
    echo "Помилка: Директорія OpenMAINT '$OPENMAINT_INSTALL_DIR' не знайдена."
    echo "Будь ласка, переконайтеся, що OpenMAINT встановлено правильно."
    exit 1
fi

# Виконуємо команди від імені користувача openmaint
sudo -u openmaint "$OPENMAINT_INSTALL_DIR/bin/shutdown.sh"
# Видалення PID-файлу, якщо він існує, для запобігання конфліктам
if [ -f "$OPENMAINT_INSTALL_DIR/bin/catalina.pid" ]; then
    echo "Видалення старого PID-файлу OpenMAINT..."
    sudo rm -f "$OPENMAINT_INSTALL_DIR/bin/catalina.pid"
fi


echo "--------------------------------------------------------"
echo "Alfresco та OpenMAINT зупинено."
echo "--------------------------------------------------------"
