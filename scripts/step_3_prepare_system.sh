#!/bin/bash

# =====================================================================================
# Крок 3: Підготовка системи
# =====================================================================================
# Цей скрипт встановлює необхідні бібліотеки та залежності,
# а також створює користувача Alfresco.
# Отримання директорії, де знаходиться поточний скрипт
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
# Підключення змінних
source "$SCRIPT_DIR/variables.sh"

print_header "Крок 3: Підготовка системи (встановлення залежностей та створення користувача)"

echo "Оновлення списку пакетів..."
sudo apt update

echo "Встановлення графічних бібліотек та інших залежностей..."
sudo apt install -y fontconfig libsm6 libice6 libxrender1 libxext6 libcups2 libglu1-mesa libcairo2 libgl1

echo "Створення користувача 'alfresco' та додавання його до групи 'sudo'..."
if ! id "alfresco" &>/dev/null; then
    sudo adduser alfresco --disabled-password --gecos ""
    sudo usermod -aG sudo alfresco
    echo "Користувача 'alfresco' створено."
else
    echo "Користувач 'alfresco' вже існує."
fi

echo "Підготовка системи завершена."
