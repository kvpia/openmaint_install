#!/bin/bash
# Отримання директорії, де знаходиться поточний скрипт
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
# Підключення змінних
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 2: Встановлення PostgreSQL 17 (сумісно з Ubuntu 24.04)"
echo "Додавання офіційного репозиторію PostgreSQL..."
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /usr/share/keyrings/postgresql.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list >/dev/null

echo "Оновлення списку пакетів..."
apt update -y

echo "Встановлення PostgreSQL 17..."
apt install postgresql-17 postgresql-client-17 postgresql-contrib-17 -y

print_header "Встановлення PostGIS (опціонально)"
apt install postgis postgresql-17-postgis-3 libpostgis-java -y

print_header "Налаштування PostgreSQL"
echo "Зміна пароля для користувача 'postgres'..."
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';"

echo "Встановлення та налаштування PostgreSQL завершено."
