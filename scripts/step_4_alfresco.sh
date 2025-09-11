#!/bin/bash

# =====================================================================================
# Крок 5: Налаштування Alfresco
# =====================================================================================
# Цей скрипт копіює додаткові файли конфігурації CMDBuild до Alfresco.
# Використання змінних та функцій з `variables.sh`
source scripts/variables.sh

print_header "Крок 5: Копіювання файлів конфігурації Alfresco"

# Шлях до папки з файлами конфігурації
ALFRESCO_CONFIG_DIR="alfresco/extension"
DESTINATION_DIR="$ALFRESCO_INSTALL_DIR/tomcat/shared/classes/alfresco/extension"

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

echo "Файли конфігурації скопійовано."
