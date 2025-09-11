#!/bin/bash

# =====================================================================================
# Головний скрипт для послідовного запуску всіх кроків встановлення
# =====================================================================================

# Вихід при першій помилці
set -e

# Використання змінних та функцій з файлу конфігурації
source scripts/variables.sh

# Перевірка прав sudo
if [[ $EUID -ne 0 ]]; then
   echo "Цей скрипт повинен бути запущений з правами 'sudo'."
   exit 1
fi

echo "Запуск скриптів встановлення. Це може зайняти деякий час..."

./scripts/step_0_prereqs.sh
./scripts/step_1_install_java17.sh
./scripts/step_2_install_postgres17.sh
./scripts/step_3_alfresco_download.sh
./scripts/step_4_alfresco.sh
./scripts/step_5_geoserver.sh
./scripts/step_6_openmaint.sh
./scripts/step_7_bimserver.sh
./scripts/step_8_create_run_scripts.sh

echo -e "\n\033[1;32m=================================================================\033[0m"
echo -e "\033[1;32mВстановлення завершено!\033[0m"
echo -e "\033[1;32m=================================================================\033[0m"
echo "Будь ласка, запустіть наступну команду, щоб запустити всі сервіси:"
echo "sudo ./startmaint.sh"
