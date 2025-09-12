#!/bin/bash

# =====================================================================================
# Крок 6: Встановлення та налаштування GeoServer
# =====================================================================================
# Цей скрипт встановлює GeoServer, налаштовує його порт
# та створює системну службу для автоматичного запуску.
# Використання змінних та функцій з `variables.sh`
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 6: Встановлення та налаштування GeoServer"

# Виправлення: визначення домашнього каталогу користувача, навіть якщо скрипт запущено з sudo
if [ -n "$SUDO_USER" ]; then
    USER_HOME="/home/$SUDO_USER"
else
    USER_HOME="$HOME"
fi

# Виправлення: забезпечення правильного використання змінних з variables.sh
# Перевірка, чи встановлені необхідні змінні, інакше зупинка.
if [ -z "$GEOSERVER_USER" ]; then
    echo "Помилка: Змінна GEOSERVER_USER не визначена у variables.sh."
    exit 1
fi
if [ -z "$GEOSERVER_URL" ]; then
    echo "Помилка: Змінна GEOSERVER_URL не визначена у variables.sh."
    exit 1
fi
if [ -z "$GEOSERVER_INSTALL_DIR" ]; then
    echo "Помилка: Змінна GEOSERVER_INSTALL_DIR не визначена у variables.sh."
    exit 1
fi

# Каталог для завантажень, розташований у домашній директорії користувача
INSTALL_DIR="$USER_HOME/install_dir"
# Ім'я файлу інсталятора
GEOSERVER_ARCHIVE_NAME=$(basename "$GEOSERVER_URL")
GEOSERVER_ARCHIVE_PATH="$INSTALL_DIR/$GEOSERVER_ARCHIVE_NAME"

echo "Створення каталогу для завантажень '$INSTALL_DIR'..."
mkdir -p "$INSTALL_DIR"

# 1. Створення користувача GeoServer
echo "Створення користувача '$GEOSERVER_USER'..."
if ! id "$GEOSERVER_USER" &>/dev/null; then
    # Використання --system означає, що це буде системний обліковий запис, що є стандартним для сервісів
    sudo adduser --system --no-create-home --group "$GEOSERVER_USER"
    # Додаємо користувача до групи sudo, якщо це потрібно для його роботи (але зазвичай для сервісів це не потрібно)
    # Якщо GeoServer не потребує прав sudo, цю команду можна видалити
    sudo usermod -aG sudo "$GEOSERVER_USER" 
    echo "Користувача '$GEOSERVER_USER' створено."
else
    echo "Користувач '$GEOSERVER_USER' вже існує."
fi

# 2. Завантаження GeoServer
if [ -f "$GEOSERVER_ARCHIVE_PATH" ]; then
    echo "Інсталяційний файл GeoServer '$GEOSERVER_ARCHIVE_NAME' вже існує. Завантаження не потрібне."
else
    echo "Завантаження GeoServer з '$GEOSERVER_URL'..."
    # Використовуємо wget з параметрами, що відображають прогрес
    if ! wget -P "$INSTALL_DIR" "$GEOSERVER_URL"; then
        echo "Помилка: Не вдалося завантажити файл GeoServer. Перевірте URL '$GEOSERVER_URL' або підключення до Інтернету."
        exit 1
    fi
fi

# 3. Розпакування та встановлення GeoServer
echo "Розпакування GeoServer до '$GEOSERVER_INSTALL_DIR'..."
# Переконаємося, що каталог встановлення існує
sudo mkdir -p "$GEOSERVER_INSTALL_DIR"
# Розпаковуємо файл
# Використовуємо -o для перезапису, якщо файл вже існує
# Використовуємо -d для вказівки каталогу призначення
sudo unzip -o "$GEOSERVER_ARCHIVE_PATH" -d "$GEOSERVER_INSTALL_DIR"

# Встановлення власника файлів GeoServer на створеного користувача
echo "Налаштування власника файлів '$GEOSERVER_USER' для '$GEOSERVER_INSTALL_DIR'..."
sudo chown -R $GEOSERVER_USER:$GEOSERVER_USER "$GEOSERVER_INSTALL_DIR"

# 4. Налаштування порту в start.ini
echo "Налаштування порту GeoServer..."
# Замінюємо рядок "jetty.http.port=8080" на "jetty.http.port=8082"
# Використовуємо sed для безпечного редагування файлу
# Спочатку перевіряємо, чи існує файл start.ini
START_INI_PATH="$GEOSERVER_INSTALL_DIR/bin/start.ini"
if [ -f "$START_INI_PATH" ]; then
    sudo sed -i 's/^jetty.http.port=8080/jetty.http.port=8082/' "$START_INI_PATH"
    echo "Порт GeoServer встановлено на 8082."
else
    echo "Помилка: Файл $START_INI_PATH не знайдено. Не вдалося налаштувати порт."
    # Можливо, варто вийти тут, але продовжимо, якщо користувач хоче спробувати запустити
fi

# 5. Створення системної служби
echo "Створення файлу служби 'geoserver.service'..."
# Перевірка, чи існує каталог /etc/systemd/system, інакше його створити (зазвичай він є)
sudo mkdir -p /etc/systemd/system
# Використання here document (<<EOF) для запису вмісту файлу служби
sudo bash -c "cat > /etc/systemd/system/geoserver.service <<EOF
[Unit]
Description=GeoServer Service
After=network.target postgresql.service

[Service]
Type=simple
User=$GEOSERVER_USER
Environment=\"GEOSERVER_HOME=$GEOSERVER_INSTALL_DIR\"
ExecStart=$GEOSERVER_INSTALL_DIR/bin/startup.sh
ExecStop=$GEOSERVER_INSTALL_DIR/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF"

# 6. Ввімкнення та запуск служби
echo "Перезавантаження конфігурації служб..."
sudo systemctl daemon-reload

echo "Ввімкнення та запуск служби GeoServer..."
sudo systemctl enable --now geoserver

echo "Встановлення GeoServer завершено."
echo "Доступ до GeoServer можна отримати за адресою: http://YOUR-IP:8082/geoserver"
