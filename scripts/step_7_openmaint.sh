#!/bin/bash

# =====================================================================================
# Крок 7: Встановлення OpenMAINT
# =====================================================================================
# Цей скрипт завантажує та встановлює WAR-файл OpenMAINT.
# Використання змінних та функцій з `variables.sh`
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 7: Встановлення OpenMAINT"

# Перевірка, чи існує каталог репозиторію, і встановлення шляху до нього
if [ -n "$SUDO_USER" ]; then
    HOME_DIR="/home/$SUDO_USER"
else
    HOME_DIR="$HOME"
fi

# Каталог для завантажень, розташований у домашній директорії користувача
INSTALL_DIR="$HOME_DIR/install_dir"
OPENMAINT_WAR_URL="https://netactuate.dl.sourceforge.net/project/openmaint/2.4/openmaint-2.4-4.0.4.war?viasf=1"
OPENMAINT_WAR_NAME="openmaint-2.4-4.0.4.war"
OPENMAINT_WAR_PATH="$INSTALL_DIR/$OPENMAINT_WAR_NAME"

# 1. Створення користувача OpenMAINT
echo "Створення користувача '$OPENMAINT_USER'..."
if ! id "$OPENMAINT_USER" &>/dev/null; then
    # Використовуємо --system для системного користувача, --no-create-home, якщо домашня директорія не потрібна для процесу
    sudo adduser --system --no-create-home --group "$OPENMAINT_USER"
    # Додавання до групи sudo, якщо це необхідно для виконання інсталяції
    sudo usermod -aG sudo "$OPENMAINT_USER" 
    echo "Користувача '$OPENMAINT_USER' створено."
else
    echo "Користувач '$OPENMAINT_USER' вже існує."
fi

# 2. Завантаження OpenMAINT WAR-файлу
echo "Створення каталогу для завантажень '$INSTALL_DIR'..."
mkdir -p "$INSTALL_DIR"

if [ -f "$OPENMAINT_WAR_PATH" ]; then
    echo "Інсталяційний WAR-файл OpenMAINT вже існує. Завантаження не потрібне."
else
    echo "Завантаження OpenMAINT з '$OPENMAINT_WAR_URL'..."
    if ! wget -O "$OPENMAINT_WAR_PATH" "$OPENMAINT_WAR_URL"; then
        echo "Помилка: Не вдалося завантажити файл OpenMAINT. Перевірте URL '$OPENMAINT_WAR_URL' або підключення до Інтернету."
        exit 1
    fi
fi

# 3. Встановлення OpenMAINT
echo "Запуск інсталяції OpenMAINT..."
# Перехід до директорії з WAR-файлом для коректного виконання команди install
cd "$INSTALL_DIR" || { echo "Не вдалося перейти до каталогу '$INSTALL_DIR'. Вихід."; exit 1; }

# Виконуємо інсталяцію. Припускаємо, що Java 17 вже встановлена (з попередніх кроків)
# --add-opens потрібне для деяких версій Java
echo "Виконання команди встановлення..."
if ! java --add-opens java.base/java.nio=ALL-UNNAMED -jar "$OPENMAINT_WAR_NAME" install; then
    echo "Помилка під час виконання інсталяції OpenMAINT."
    exit 1
fi

# Важливо: Переконайтеся, що користувач OpenMAINT має права на створені файли,
# якщо інсталятор створює їх не від його імені.
# Зазвичай, якщо інсталяція запускається від імені sudo, файли створюються з правами root.
# Можливо, знадобиться змінити власника директорії встановлення OpenMAINT, якщо вона буде створена.
# Наприклад: sudo chown -R $OPENMAINT_USER:$OPENMAINT_USER /шлях/до/директорії/openmaint

echo "Встановлення OpenMAINT завершено."
echo "Після встановлення вам може знадобитися вручну налаштувати автозапуск OpenMAINT, якщо це необхідно."
echo "Доступ до OpenMAINT: http://YOUR-IP:8080/cmdbuild/ui"

# Повернення до початкової директорії (не обов'язково, якщо run_all.sh це робить)
cd "$SCRIPT_DIR"
