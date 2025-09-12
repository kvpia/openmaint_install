#!/bin/bash

# ================================================================
# Скрипт для перевірки стану всіх встановлених служб.
# ================================================================

# Підключення змінних з файлу конфігурації
source /home/ubuntu/openmaint_install/scripts/variables.sh

# Функція для перевірки статусу служби systemd
check_systemd_service() {
    local service_name=$1
    echo -n "Перевірка стану служби '$service_name'... "
    if systemctl is-active --quiet "$service_name"; then
        echo -e "\033[32mАктивний\033[0m" # Зелений
    else
        echo -e "\033[31mНеактивний\033[0m" # Червоний
    fi
}

# Функція для перевірки наявності процесу
check_process() {
    local process_name=$1
    local description=$2
    echo -n "Перевірка стану '$description' ($process_name)... "
    if pgrep -f "$process_name" >/dev/null; then
        echo -e "\033[32mАктивний\033[0m" # Зелений
    else
        echo -e "\033[31mНеактивний\033[0m" # Червоний
    fi
}


echo "--------------------------------------------------------"
echo "Перевірка статусу основних служб..."
echo "--------------------------------------------------------"

# Перевірка PostgreSQL
check_systemd_service postgresql.service

# Перевірка Alfresco
# Alfresco зазвичай запускається як служба, але перевіримо і процесом на всяк випадок
echo "Перевірка Alfresco..."
if systemctl is-active --quiet alfresco.service; then
    echo -e "\033[32mАктивний (systemd)\033[0m"
elif pgrep -f "alfresco.sh" >/dev/null; then
    echo -e "\033[33mАктивний (процес alfresco.sh)\033[0m" # Жовтий
else
    echo -e "\033[31mНеактивний\033[0m"
fi

# Перевірка GeoServer (як systemd служба)
check_systemd_service geoserver.service

# Перевірка OpenMAINT (як процес, оскільки він запускається вручну або через скрипт)
echo "Перевірка OpenMAINT..."
# Перевірка наявності процесу 'java' з параметром, що вказує на cmdbuild
if pgrep -f "java.*$OPENMAINT_INSTALL_DIR/bin/startup.sh" >/dev/null; then
    echo -e "\033[32mАктивний\033[0m"
elif pgrep -f "java.*cmdbuild" >/dev/null; then # Альтернативна перевірка, якщо startup.sh не вказано
     echo -e "\033[33mАктивний (процес java cmdbuild)\033[0m" # Жовтий
else
    echo -e "\033[31mНеактивний\033[0m"
fi

echo "--------------------------------------------------------"
echo "Перевірка завершена."
echo "--------------------------------------------------------"
