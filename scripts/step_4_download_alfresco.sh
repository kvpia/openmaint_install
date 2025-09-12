#!/bin/bash

# =====================================================================================
# Крок 4: Завантаження та встановлення Alfresco
# =====================================================================================
# Цей скрипт завантажує та встановлює пакет Alfresco, перевіряючи його цілісність
# та запобігаючи повторному завантаженню.
# Використання змінних та функцій з `variables.sh`
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 4: Завантаження та встановлення Alfresco"

# Каталог для всіх завантажень, розташований у /home/ubuntu/
INSTALL_DIR="/home/ubuntu/install_dir"
# Тимчасовий каталог для старих або пошкоджених файлів
ALFRESCO_ARCHIVE_TEMP_DIR="$INSTALL_DIR/temp"
# Ім'я файлу інсталятора
ALFRESCO_ARCHIVE_NAME="alfresco-community-installer-201707-linux-x64.bin"
# MD5-хеш файлу для перевірки цілісності
EXPECTED_MD5="4d994362a22f367eb74a896d194c25f4"
# Шлях до інсталятора в локальній системі
ALFRESCO_INSTALLER_PATH="$INSTALL_DIR/$ALFRESCO_ARCHIVE_NAME"

echo "Створення каталогу для завантажень '$INSTALL_DIR'..."
mkdir -p "$INSTALL_DIR"

# Перевірка наявності та цілісності файлу
if [ -f "$ALFRESCO_INSTALLER_PATH" ]; then
    echo "Інсталяційний файл Alfresco вже існує. Перевірка цілісності..."
    CURRENT_MD5=$(md5sum "$ALFRESCO_INSTALLER_PATH" | awk '{ print $1 }')

    if [ "$CURRENT_MD5" == "$EXPECTED_MD5" ]; then
        echo "Файл цілий. Завантаження не потрібне."
    else
        echo "MD5-хеш не збігається. Можливо, файл пошкоджений або застарілий."
        echo "Поточний хеш: $CURRENT_MD5"
        echo "Очікуваний хеш: $EXPECTED_MD5"
        
        # Переміщення пошкодженого файлу в тимчасову папку
        echo "Переміщення існуючого файлу до '$ALFRESCO_ARCHIVE_TEMP_DIR'..."
        mkdir -p "$ALFRESCO_ARCHIVE_TEMP_DIR"
        mv "$ALFRESCO_INSTALLER_PATH" "$ALFRESCO_ARCHIVE_TEMP_DIR/$ALFRESCO_ARCHIVE_NAME-old"
        
        # Завантаження нової версії
        echo "Завантаження нової версії Alfresco з '$ALFRESCO_URL'..."
        if ! wget -O "$ALFRESCO_INSTALLER_PATH" "$ALFRESCO_URL"; then
            echo "Помилка: Не вдалося завантажити файл Alfresco. Перевірте URL або підключення до Інтернету."
            exit 1
        fi
    fi
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
sudo "$ALFRESCO_INSTALLER_PATH" --mode text --enable-components services --disable-components alfresco,solr,postgresql,share,googledocs,libreoffice --prefix "$ALFRESCO_INSTALL_DIR" --alfresco_user "$ALFRESCO_USER" --alfresco_password "admin" --postgres_password "$POSTGRES_PASSWORD" --tomcat_port 8081 --shutdown_port 8006 --database_port 5433 --base_ip "172.168.0.69" --install_as_service 0

# Видалення тимчасових файлів
echo "Видалення тимчасових файлів..."
rm -rf "$ALFRESCO_ARCHIVE_TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "Помилка: Не вдалося видалити тимчасові файли у '$ALFRESCO_ARCHIVE_TEMP_DIR'."
fi

echo "Завантаження та встановлення завершено."
