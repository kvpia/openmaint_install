#!/bin/bash

# =====================================================================================
# Цей скрипт послідовно запускає всі кроки встановлення Alfresco.
# =====================================================================================

# Використання змінних з `variables.sh`, який знаходиться в поточній директорії
source variables.sh

echo "Послідовний запуск скриптів встановлення OpenMaint..."

# Крок 0: Встановлення попередніх вимог (pre-requisites)
./step_0_prereqs.sh
if [ $? -ne 0 ]; then echo "Помилка на кроці 0. Вихід."; exit 1; fi

# Крок 1: Встановлення Java 17
./step_1_install_java17.sh
if [ $? -ne 0 ]; then echo "Помилка на кроці 1. Вихід."; exit 1; fi

# Крок 2: Встановлення PostgreSQL 17
./step_2_install_postgres17.sh
if [ $? -ne 0 ]; then echo "Помилка на кроці 2. Вихід."; exit 1; fi

# Крок 3: Підготовка системи
./step_3_prepare_system.sh
if [ $? -ne 0 ]; then echo "Помилка на кроці 3. Вихід."; exit 1; fi

# Крок 4: Завантаження та встановлення Alfresco
./step_4_download_alfresco.sh
if [ $? -ne 0 ]; then echo "Помилка на кроці 4. Вихід."; exit 1; fi

# Крок 5: Налаштування Alfresco
./step_5_configure_alfresco.sh
if [ $? -ne 0 ]; then echo "Помилка на кроці 5. Вихід."; exit 1; fi

echo "Усі скрипти успішно виконано."
