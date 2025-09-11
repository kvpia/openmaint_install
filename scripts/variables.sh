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
OPENMAINT_DB_NAME="openmaint_db"

# GeoServer
GEOSERVER_URL="https://sourceforge.net/projects/geoserver/files/GeoServer/2.21.0/geoserver-2.21.0-bin.zip/download"
GEOSERVER_INSTALL_DIR="/opt/geoserver"
GEOSERVER_USER="geoserver_user"

# OpenMAINT
OPENMAINT_VERSION="4.0.4"
OPENMAINT_URL="https://downloads.sourceforge.net/project/openmaint/2.4/openmaint-4.0.4.zip"
