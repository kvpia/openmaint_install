# Цей скрипт встановлює PostgreSQL 17, необхідну базу даних для OpenMAINT.

# Додавання ключа GPG для репозиторію PostgreSQL
echo "Додавання ключа GPG для репозиторію PostgreSQL..."
sudo apt-get install -y wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Додавання репозиторію PostgreSQL
echo "Додавання репозиторію PostgreSQL..."
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Оновлення списку пакетів
echo "Оновлення списку пакетів..."
sudo apt update -y

# Встановлення PostgreSQL 17
echo "Встановлення PostgreSQL 17..."
sudo apt install postgresql-17 -y

# Перевірка статусу сервісу PostgreSQL
echo "Перевірка статусу сервісу PostgreSQL..."
sudo systemctl status postgresql

echo "Встановлення PostgreSQL 17 завершено."
