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

# Каталог для завантажень, розташований у /home/ubuntu/
INSTALL_DIR="$HOME/install_dir"
GEOSERVER_ARCHIVE_NAME=$(basename "$GEOSERVER_URL")
GEOSERVER_ARCHIVE_PATH="$INSTALL_DIR/$GEOSERVER_ARCHIVE_NAME"

# 1. Створення користувача GeoServer
echo "Створення користувача '$GEOSERVER_USER'..."
if ! id "$GEOSERVER_USER" &>/dev/null; then
    sudo adduser --system --no-create-home --group "$GEOSERVER_USER"
    sudo usermod -aG sudo "$GEOSERVER_USER"
    echo "Користувача '$GEOSERVER_USER' створено."
else
    echo "Користувач '$GEOSERVER_USER' вже існує."
fi

# 2. Завантаження GeoServer
echo "Створення каталогу для завантажень '$INSTALL_DIR'..."
mkdir -p "$INSTALL_DIR"

if [ -f "$GEOSERVER_ARCHIVE_PATH" ]; then
    echo "Інсталяційний файл GeoServer вже існує. Завантаження не потрібне."
else
    echo "Завантаження GeoServer з '$GEOSERVER_URL'..."
    if ! wget -O "$GEOSERVER_ARCHIVE_PATH" "$GEOSERVER_URL"; then
        echo "Помилка: Не вдалося завантажити файл GeoServer. Перевірте URL або підключення до Інтернету."
        exit 1
    fi
fi

# 3. Розпакування та встановлення GeoServer
echo "Розпакування GeoServer до '$GEOSERVER_INSTALL_DIR'..."
sudo mkdir -p "$GEOSERVER_INSTALL_DIR"
sudo unzip -o "$GEOSERVER_ARCHIVE_PATH" -d "$GEOSERVER_INSTALL_DIR"
sudo chown -R $GEOSERVER_USER:$GEOSERVER_USER "$GEOSERVER_INSTALL_DIR"

# 4. Налаштування порту в start.ini
echo "Налаштування порту GeoServer (8082)..."
sudo sed -i 's/^jetty.http.port=8080/jetty.http.port=8082/' "$GEOSERVER_INSTALL_DIR/bin/start.ini"

# 5. Створення системної служби
echo "Створення файлу служби 'geoserver.service'..."
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
