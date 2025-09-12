#!/bin/bash

# ================================================================
# Скрипт для запуску Alfresco та OpenMAINT.
# ================================================================

# Підключення змінних з файлу конфігурації
# Використовуємо /home/ubuntu/openmaint_install/scripts/variables.sh, оскільки скрипт буде запускатись звідти
source /home/ubuntu/openmaint_install/scripts/variables.sh

echo "--------------------------------------------------------"
echo "Запуск Alfresco та OpenMAINT..."
echo "--------------------------------------------------------"

# Запуск Alfresco (потрібні права root для /opt/alfresco)
echo "Запуск Alfresco..."
sudo "$ALFRESCO_INSTALL_DIR/alfresco.sh" start
# Видалення PID-файлу, якщо він існує, для запобігання конфліктам
if [ -f "$ALFRESCO_INSTALL_DIR/tomcat/temp/catalina.pid" ]; then
    echo "Видалення старого PID-файлу Alfresco..."
    sudo rm -f "$ALFRESCO_INSTALL_DIR/tomcat/temp/catalina.pid"
    # Повторна спроба запуску після видалення PID, якщо потрібно
    # sudo "$ALFRESCO_INSTALL_DIR/alfresco.sh" start
fi


# Запуск OpenMAINT (від імені користувача openmaint)
echo "Запуск OpenMAINT..."
# Перевіряємо, чи існує директорія OpenMAINT
if [ ! -d "$OPENMAINT_INSTALL_DIR" ]; then
    echo "Помилка: Директорія OpenMAINT '$OPENMAINT_INSTALL_DIR' не знайдена."
    echo "Будь ласка, переконайтеся, що OpenMAINT встановлено правильно."
    exit 1
fi

# Створення директорії логів, якщо вона не існує, з правильними правами
if [ ! -d "$OPENMAINT_INSTALL_DIR/logs" ]; then
    echo "Створення директорії логів для OpenMAINT: $OPENMAINT_INSTALL_DIR/logs"
    sudo mkdir -p "$OPENMAINT_INSTALL_DIR/logs"
    sudo chown -R openmaint:openmaint "$OPENMAINT_INSTALL_DIR/logs" # Надання прав користувачу openmaint
fi

# Створення пустого файлу catalina.out, якщо він не існує, з правильними правами
if [ ! -f "$OPENMAINT_INSTALL_DIR/logs/catalina.out" ]; then
    echo "Створення пустого файлу логів OpenMAINT: $OPENMAINT_INSTALL_DIR/logs/catalina.out"
    sudo touch "$OPENMAINT_INSTALL_DIR/logs/catalina.out"
    sudo chown -R openmaint:openmaint "$OPENMAINT_INSTALL_DIR/logs/catalina.out" # Надання прав користувачу openmaint
fi


# Виконуємо команди від імені користувача openmaint
sudo -u openmaint "$OPENMAINT_INSTALL_DIR/bin/startup.sh"

echo "--------------------------------------------------------"
echo "Alfresco та OpenMAINT запущено."
echo "--------------------------------------------------------"
