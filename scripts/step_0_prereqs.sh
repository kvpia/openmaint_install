# Цей скрипт готує систему для встановлення OpenMAINT та необхідних компонентів.
# Він оновлює систему і встановлює базові пакети та залежності.

# Оновлення списку пакетів
echo "Оновлення списку пакетів..."
sudo apt update -y

# Оновлення встановлених пакетів
echo "Оновлення встановлених пакетів..."
sudo apt upgrade -y

# Встановлення необхідних утиліт та бібліотек
echo "Встановлення необхідних утиліт: wget, unzip, libxrender1, libcups2, fontconfig, libc6, libglib2.0-0, libsm6, libxext6, libxrender1, libxtst6"
sudo apt install wget unzip git libxrender1 libcups2 fontconfig libc6 libglib2.0-0 libsm6 libxext6 libxrender1 libxtst6 -y

echo "Підготовка системи завершена."

