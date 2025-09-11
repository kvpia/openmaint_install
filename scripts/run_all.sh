#!/bin/bash

# =====================================================================================
# Цей скрипт послідовно запускає всі кроки встановлення Alfresco.
# Він може запускатися з будь-якої директорії та пропускати кроки.
# Використання: ./run_all.sh [початковий_крок]
# =====================================================================================

# Отримання директорії, де знаходиться скрипт, і перехід до неї
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$SCRIPT_DIR" || { echo "Не вдалося перейти до директорії скрипта. Вихід."; exit 1; }

# Підключення змінних
source variables.sh

print_header "Послідовний запуск скриптів встановлення OpenMaint..."

START_STEP=${1:-0} # За замовчуванням починаємо з кроку 0, якщо не вказано інше

# Виконання кроків
execute_step() {
    local step_num=$1
    local script_name=$2
    if [ "$START_STEP" -le "$step_num" ]; then
        ./"$script_name"
        if [ $? -ne 0 ]; then
            echo "Помилка на кроці $step_num. Вихід."
            exit 1
        fi
    else
        echo "Пропуск кроку $step_num: $script_name"
    fi
}

execute_step 0 "step_0_prereqs.sh"
execute_step 1 "step_1_install_java17.sh"
execute_step 2 "step_2_install_postgres17.sh"
execute_step 3 "step_3_prepare_system.sh"
execute_step 4 "step_4_download_alfresco.sh"
execute_step 5 "step_5_configure_alfresco.sh"

echo "Усі скрипти успішно виконано."
