#!/bin/bash

# =====================================================================================
# Крок 4: Завантаження та встановлення Alfresco
# =====================================================================================
# Цей скрипт завантажує та встановлює пакет Alfresco.
# Використання змінних та функцій з `variables.sh`
source scripts/variables.sh

print_header "Крок 4: Завантаження та встановлення Alfresco"

# URL для завантаження
ALFRESCO_DOWNLOAD_URL="https://sourceforge.net/projects/alfresco/files/Alfresco%20201707%20Community/alfresco-community-installer-201707-linux-x64.bin/download"
ALFRESCO_ARCHIVE_NAME="alfresco-community-installer-201707-linux-x64.bin"
ALFRESCO_ARCHIVE_DIR="alfresco_temp"

echo "Створення тимчасового каталогу '$ALFRESCO_ARCHIVE_DIR'..."
mkdir -p "$ALFRESCO_ARCHIVE_DIR"

echo "Завантаження Alfresco з '$ALFRESCO_DOWNLOAD_URL'..."
if ! wget -O "$ALFRESCO_ARCHIVE_DIR/$ALFRESCO_ARCHIVE_NAME" "$ALFRESCO_DOWNLOAD_URL"; then
    echo "Помилка: Не вдалося завантажити файл Alfresco. Перевірте URL або підключення до Інтернету."
    exit 1
fi

echo "Надання прав на виконання інсталятору..."
chmod a+x "$ALFRESCO_ARCHIVE_DIR/$ALFRESCO_ARCHIVE_NAME"

echo "Запуск інсталятора Alfresco в текстовому режимі..."
sudo "$ALFRESCO_ARCHIVE_DIR/$ALFRESCO_ARCHIVE_NAME" --mode text

echo "Видалення тимчасових файлів..."
rm -rf "$ALFRESCO_ARCHIVE_DIR"

echo "Завантаження та встановлення завершено."
