#!/bin/bash

# Farbdefinitionen
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Sprachauswahl
echo "Please select your language:"
echo "1. English"
echo "2. Deutsch"
read -p "Enter your choice (1 or 2): " lang_choice

# Funktion zur Übersetzung
translate() {
    case "$lang_choice" in
        1)
            case "$1" in
                "welcome_msg")
                    echo "====================================================="
                    echo "============ FiveM with TxAdmin Installer ============"
                    echo "====================================================="
                    echo "This script was created by SirRezi and modified by XenoKeks."
                    echo
                    ;;
                "abort_msg")
                    echo -e "${GREEN}Installation aborted.${NC}"
                    ;;
                "update_packages")
                    echo -e "${YELLOW}Updating package list...${NC}"
                    ;;
                "upgrade_system")
                    echo -e "${YELLOW}Performing system upgrade...${NC}"
                    ;;
                "install_packages")
                    echo -e "${YELLOW}Installing required packages...${NC}"
                    ;;
                "create_fivem_dir")
                    echo -e "${YELLOW}Creating FiveM server directory...${NC}"
                    ;;
                "download_fivem_server")
                    echo -e "${YELLOW}Downloading FiveM server...${NC}"
                    ;;
                "extract_fivem_server")
                    echo -e "${YELLOW}Extracting FiveM server...${NC}"
                    ;;
                "create_server_data_dir")
                    echo -e "${YELLOW}Creating FiveM server data directory and configuring...${NC}"
                    ;;
                "set_permissions")
                    echo -e "${YELLOW}Setting permissions...${NC}"
                    ;;
                "start_server")
                    echo -e "${YELLOW}Starting FiveM server...${NC}"
                    ;;
                "server_start_hint")
                    echo "The server has been started with your input. Please note down the initial code from txAdmin and visit the displayed URL in your browser to create your main account. Then you can exit the server by pressing CTRL+X and start it again with 'screen' to keep it running even when you close or exit the console."
                    echo
                    ;;
                "installation_complete")
                    echo "====================================================="
                    echo "============ Installation is complete ==============="
                    echo "====================================================="
                    echo
                    ;;
                *)
                    echo "$1"
                    ;;
            esac
            ;;
        2)
            case "$1" in
                "welcome_msg")
                    echo "====================================================="
                    echo "============ FiveM mit TxAdmin Installer ============"
                    echo "====================================================="
                    echo "Dieses Skript wurde von SirRezi erstellt und modifiziert von XenoKeks."
                    echo
                    ;;
                "abort_msg")
                    echo -e "${GREEN}Installation abgebrochen.${NC}"
                    ;;
                "update_packages")
                    echo -e "${YELLOW}Aktualisiere Paketliste...${NC}"
                    ;;
                "upgrade_system")
                    echo -e "${YELLOW}Führe Systemaktualisierung durch...${NC}"
                    ;;
                "install_packages")
                    echo -e "${YELLOW}Installiere erforderliche Pakete...${NC}"
                    ;;
                "create_fivem_dir")
                    echo -e "${YELLOW}Erstelle FiveM-Server-Verzeichnis...${NC}"
                    ;;
                "download_fivem_server")
                    echo -e "${YELLOW}Lade FiveM-Server herunter...${NC}"
                    ;;
                "extract_fivem_server")
                    echo -e "${YELLOW}Entpacke FiveM-Server...${NC}"
                    ;;
                "create_server_data_dir")
                    echo -e "${YELLOW}Erstelle FiveM-Server-Daten-Verzeichnis und konfiguriere...${NC}"
                    ;;
                "set_permissions")
                    echo -e "${YELLOW}Setze Berechtigungen...${NC}"
                    ;;
                "start_server")
                    echo -e "${YELLOW}Starte FiveM-Server...${NC}"
                    ;;
                "server_start_hint")
                    echo "Der Server wurde mit deiner gewünschten Eingabe gestartet. Bitte notiere dir den Initialcode von txAdmin und rufe die angezeigte URL in deinem Browser auf. Erstelle damit deinen Hauptaccount. Dann kannst du mit STRG+X den Server beenden und mit Screen wieder starten, damit dieser weiterläuft, wenn du die Konsole schließt bzw. beendest."
                    echo
                    ;;
                "installation_complete")
                    echo "====================================================="
                    echo "============ Installation ist fertig ================"
                    echo "====================================================="
                    echo
                    ;;
                *)
                    echo "$1"
                    ;;
            esac
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Funktion zur Eingabeaufforderung mit Standardwert
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local value

    read -p "$prompt [$default]: " value
    echo "${value:-$default}"
}

# Funktion zur Bestätigung mit Standardwert
confirm_with_default() {
    local prompt="$1"
    local default="$2"
    local value

    read -p "$prompt (y/n) [$default]: " value
    case "${value:-$default}" in
        [Yy])
            echo "yes"
            ;;
        [Nn])
            echo "no"
            ;;
        *)
            echo "no"
            ;;
    esac
}

# Funktion zum Herunterladen von Dateien
download_file() {
    local url="$1"
    local destination="$2"

    wget -O "$destination" "$url"
}

# Funktion zum Ausführen von Befehlen mit Fortschrittsanzeige
run_command_with_progress() {
    local command="$1"
    local description="$2"

    echo -e "${YELLOW}$description...${NC}"
    eval "$command"
}

# Funktion zum Starten des FiveM-Servers
start_server() {
    local server_dir="$1"

    cd "$server_dir"
    run_command_with_progress "bash run.sh +exec server.cfg" "Starting FiveM server"
}

# Begrüßungsnachricht
translate "welcome_msg"

# Meldung über das System von SirRezi und Abfrage zur Installation
choice=$(confirm_with_default "Do you want to start the installation of FiveM with TxAdmin?" "yes")

if [[ "$choice" != "yes" ]]; then
    translate "abort_msg"
    exit 0
fi

# Pakete aktualisieren
translate "update_packages"
run_command_with_progress "apt update" "Updating package list"
run_command_with_progress "apt upgrade -y" "Performing system upgrade"

# Benötigte Pakete installieren
translate "install_packages"
run_command_with_progress "apt-get install -y xz-utils git screen" "Installing required packages"

# FiveM-Server-Verzeichnis erstellen
translate "create_fivem_dir"
server_dir=$(prompt_with_default "Enter the folder name for the FiveM server" "server")
mkdir -p "/home/FiveM/$server_dir"
cd "/home/FiveM/$server_dir"

# FiveM-Server herunterladen und entpacken
translate "download_fivem_server"
server_url=$(prompt_with_default "Enter the download URL for the FiveM server" "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/6537-f2c6ed5f64cc5a71ca0d9505f9b72bb015d370d6/fx.tar.xz")
download_file "$server_url" "fx.tar.xz"
translate "extract_fivem_server"
run_command_with_progress "tar xf fx.tar.xz" "Extracting FiveM server"
run_command_with_progress "rm fx.tar.xz" "Cleaning up"

# FiveM-Server-Daten-Verzeichnis erstellen und konfigurieren
translate "create_server_data_dir"
server_data_dir=$(prompt_with_default "Enter the installation directory for the server data" "/home/FiveM/server-data")
clone_url=$(prompt_with_default "Enter the Git clone URL for the server data" "https://github.com/citizenfx/cfx-server-data.git")
mkdir -p "$server_data_dir"
cd "$server_data_dir"
run_command_with_progress "git clone $clone_url $server_data_dir" "Cloning server data repository"

# Berechtigungen setzen
translate "set_permissions"
run_command_with_progress "chmod +x run.sh" "Setting permissions"

# FiveM-Server starten
choice=$(confirm_with_default "Do you want to start the FiveM server?" "yes")
if [[ "$choice" == "yes" ]]; then
    translate "server_start_hint"
    start_server "/home/FiveM/$server_dir"
fi

# Erfolgsmeldung anzeigen
translate "installation_complete"

exit 0
