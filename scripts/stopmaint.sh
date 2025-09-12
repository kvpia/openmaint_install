#!/bin/bash

# ================================================================
# Скрипт для зупинки Alfresco та OpenMAINT.
# ================================================================

# Підключення змінних з файлу конфігурації
source /home/ubuntu/openmaint_install/scripts/variables.sh

echo "--------------------------------------------------------"
echo "Зупинка Alfresco та OpenMAINT..."
echo "--------------------------------------------------------"

# Зупинка Alfresco
echo "Зупинка Alfresco..."
sudo "$ALFRESCO_INSTALL_DIR/alfresco.sh" stop

# Зупинка OpenMAINT
echo "Зупинка OpenMAINT..."
sudo -u openmaint "$OPENMAINT_INSTALL_DIR/bin/shutdown.sh"

echo "--------------------------------------------------------"
echo "Alfresco та OpenMAINT зупинено."
echo "--------------------------------------------------------"
