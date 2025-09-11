# Цей скрипт встановлює Java Development Kit (JDK) 17.

# Оновлення списку пакетів
sudo apt update -y

# Встановлення OpenJDK 17
echo "Встановлення OpenJDK 17..."
sudo apt install openjdk-17-jdk -y

# Перевірка версії Java
echo "Перевірка встановленої версії Java..."
java -version

echo "Встановлення Java 17 завершено."
