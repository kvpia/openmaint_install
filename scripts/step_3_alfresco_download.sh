#!/bin/bash

# =====================================================================================
# Крок 3: Завантаження інсталятора Alfresco
# =====================================================================================
# Цей скрипт відповідає лише за завантаження інсталяційного файлу Alfresco Community Edition.
# Він перевіряє обидва URL-адреси, щоб забезпечити успішне завантаження.

# Використання змінних з `variables.sh`
source scripts/variables.sh

print_header "Крок 3: Завантаження інсталятора Alfresco Community"
if [ ! -f "alfresco-community-installer-201707-linux-x64.bin" ]; then
    echo "Завантаження інсталятора Alfresco..."
    wget -O alfresco-community-installer-201707-linux-x64.bin "$ALFRESCO_URL"
    if [ $? -ne 0 ]; then
        echo "Завантаження з основного посилання не вдалося. Спроба завантажити з альтернативного джерела..."
        wget -O alfresco-community-installer-201707-linux-x64.bin "$ALFRESCO_FALLBACK_URL"
        if [ $? -ne 0 ]; then
            echo "Помилка: Завантаження інсталятора Alfresco не вдалося з обох джерел."
            exit 1
        fi
    fi
else
    echo "Інсталятор Alfresco вже існує, пропускаю завантаження."
fi
echo "Завантаження завершено."
