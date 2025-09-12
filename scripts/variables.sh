#!/bin/bash

# =====================================================================================
# Файл конфігурації для всіх скриптів встановлення
# =====================================================================================

# Функція для виведення заголовків
function print_header() {
    echo -e "\n\033[1;36m=================================================================\033[0m"
    echo -e "\033[1;36m$1\033[0m"
    echo -e "\033[1;36m=================================================================\033[0m"
}

# Alfresco
ALFRESCO_URL="https://master.dl.sourceforge.net/project/alfresco/Alfresco%20201707%20Community/alfresco-community-installer-201707-linux-x64.bin?viasf=1"
ALFRESCO_FALLBACK_URL="https://sourceforge.net/projects/alfresco/files/Alfresco%20201707%20Community/alfresco-community-installer-201707-linux-x64.bin/download"
ALFRESCO_INSTALL_DIR="/opt/alfresco-community"
ALFRESCO_USER="alfresco"

# PostgreSQL
POSTGRES_PASSWORD="postgres"
#OPENMAINT_DB_NAME="openmaint_db"

# Переконайтеся, що URL вказує на потрібну версію GeoServer
GEOSERVER_URL="https://sourceforge.net/projects/geoserver/files/GeoServer/2.21.0/geoserver-2.21.0-bin.zip/download" 
GEOSERVER_INSTALL_DIR="/opt/geoserver"
GEOSERVER_USER="geoserver"

# OpenMAINT
OPENMAINT_VERSION="4.0.4"
# Використовуйте наданий вами URL для WAR-файлу
OPENMAINT_WAR_URL="https://sourceforge.net/projects/openmaint/files/2.4/openmaint-2.4-4.0.4.war/download" 
# Зауважте: ваш файл variables.sh має URL для ZIP-архіву, але для OpenMAINT потрібен WAR-файл.
# Якщо ви хочете використати інший URL, оновіть його тут.
OPENMAINT_USER="openmaint" 
