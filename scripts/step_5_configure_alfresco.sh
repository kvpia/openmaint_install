#!/bin/bash

# =====================================================================================
# Крок 5: Налаштування Alfresco
# =====================================================================================
# Цей скрипт змінює порти в `server.xml`, копіює додаткові файли конфігурації
# та перезапускає службу.
# Використання змінних та функцій з `variables.sh`
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 5: Налаштування Alfresco"

ALFRESCO_CONFIG_DIR="alfresco/extension"
DESTINATION_DIR="$ALFRESCO_INSTALL_DIR/tomcat/shared/classes/alfresco/extension"
SERVER_XML_PATH="$ALFRESCO_INSTALL_DIR/tomcat/conf/server.xml"

# Зупинка Alfresco, якщо він запущений
echo "Зупинка Alfresco, щоб внести зміни..."
if sudo $ALFRESCO_INSTALL_DIR/alfresco.sh status | grep -q "Running"; then
    sudo $ALFRESCO_INSTALL_DIR/alfresco.sh stop
    echo "Службу Alfresco зупинено."
else
    echo "Служба Alfresco вже зупинена."
fi

# Редагування файлу server.xml для зміни портів
echo "Зміна портів у файлі $SERVER_XML_PATH..."
if [ -f "$SERVER_XML_PATH" ]; then
    sudo sed -i 's/Server port="8005"/Server port="8006"/' "$SERVER_XML_PATH"
    sudo sed -i 's/Connector port="8080"/Connector port="8081"/' "$SERVER_XML_PATH"
    echo "Порти успішно змінено."
else
    echo "Помилка: Файл $SERVER_XML_PATH не знайдено."
    exit 1
fi

echo "Перевірка наявності необхідних файлів у папці '$ALFRESCO_CONFIG_DIR'..."
if [ ! -f "$ALFRESCO_CONFIG_DIR/cmdbuild-model-context.xml" ] || [ ! -f "$ALFRESCO_CONFIG_DIR/cmdbuild-model.xml" ]; then
    echo "Помилка: Необхідні файли конфігурації не знайдені."
    echo "Будь ласка, вручну завантажте та помістіть файли 'cmdbuild-model-context.xml' та 'cmdbuild-model.xml' у папку '$ALFRESCO_CONFIG_DIR'."
    echo "Завантажити файли можна за посиланнями:"
    echo "  - cmdbuild-model-context.xml: https://drive.google.com/uc?export=download&id=1aq785ZbzxSxK3VyJCjndDPjsJLrNNpVQ"
    echo "  - cmdbuild-model.xml: https://drive.google.com/uc?export=download&id=1zxCq-p1SPcm7F5Iko4ltBC1uFv1lfRyt"
    exit 1
fi

echo "Створення каталогу розширень, якщо він не існує..."
if [ ! -d "$DESTINATION_DIR" ]; then
    sudo mkdir -p "$DESTINATION_DIR"
    sudo chown -R $ALFRESCO_USER:$ALFRESCO_USER "$DESTINATION_DIR"
fi

echo "Копіювання файлів конфігурації..."
sudo cp "$ALFRESCO_CONFIG_DIR/cmdbuild-model-context.xml" "$DESTINATION_DIR/"
sudo cp "$ALFRESCO_CONFIG_DIR/cmdbuild-model.xml" "$DESTINATION_DIR/"

echo "Налаштування дозволів для скопійованих файлів..."
sudo chown $ALFRESCO_USER:$ALFRESCO_USER "$DESTINATION_DIR/cmdbuild-model-context.xml"
sudo chown $ALFRESCO_USER:$ALFRESCO_USER "$DESTINATION_DIR/cmdbuild-model.xml"

echo "Перезапуск служби Alfresco, щоб застосувати зміни..."
sudo $ALFRESCO_INSTALL_DIR/alfresco.sh start

echo "Перезапуск завершено."
echo "Після завершення всіх скриптів ви можете отримати доступ до Alfresco за адресою: http://YOUR-IP:8081/share"
