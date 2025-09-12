#!/bin/bash

# =====================================================================================
# Крок 4: Завантаження та встановлення Alfresco
# =====================================================================================
# Цей скрипт завантажує та встановлює пакет Alfresco.
# Використання змінних та функцій з `variables.sh`
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 4: Завантаження та встановлення Alfresco"

# Каталог для завантажень, розташований у /home/ubuntu/
INSTALL_DIR="/home/ubuntu/install_dir"
# Ім'я файлу інсталятора
ALFRESCO_ARCHIVE_NAME="alfresco-community-installer-201707-linux-x64.bin"
# Шлях до інсталятора в локальній системі
ALFRESCO_INSTALLER_PATH="$INSTALL_DIR/$ALFRESCO_ARCHIVE_NAME"

echo "Створення каталогу для завантажень '$INSTALL_DIR'..."
mkdir -p "$INSTALL_DIR"

# Перевірка наявності файлу, щоб уникнути повторного завантаження
if [ -f "$ALFRESCO_INSTALLER_PATH" ]; then
    echo "Інсталяційний файл Alfresco вже існує. Завантаження не потрібне."
else
    # Завантаження, якщо файл не знайдено
    echo "Інсталяційний файл Alfresco не знайдено. Завантаження..."
    if ! wget -O "$ALFRESCO_INSTALLER_PATH" "$ALFRESCO_URL"; then
        echo "Помилка: Не вдалося завантажити файл Alfresco. Перевірте URL або підключення до Інтернету."
        exit 1
    fi
fi

echo "Надання прав на виконання інсталятору..."
chmod a+x "$ALFRESCO_INSTALLER_PATH"

echo "Запуск інсталятора Alfresco в текстовому режимі..."
sudo "$ALFRESCO_INSTALLER_PATH" --mode text

echo "Завантаження та встановлення завершено."
