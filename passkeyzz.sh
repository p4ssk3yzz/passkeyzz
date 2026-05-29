#!/usr/bin/env bash

# ----------------------------------------
# PASSKEYZZ - Network Toolkit
# Author: Pascal Muju
# Version: 1.0
# ----------------------------------------

# --- Color Codes ---
ORANGE='\033[38;5;208m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

# --- Root Check ---
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] This tool must be run with sudo!${NC}"
   echo -e "${YELLOW}Usage: sudo ./passkeyzz.sh${NC}"
   exit 1
fi

# --- Dependency Check ---
check_deps() {
    local deps=("curl" "speedtest-cli" "arp-scan")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -ne 0 ]]; then
        echo -e "${YELLOW}[!] Installing missing dependencies...${NC}"
        
        if command -v apt &> /dev/null; then
            apt update -y && apt install -y "${missing[@]}"
        elif command -v yum &> /dev/null; then
            yum install -y "${missing[@]}"
        elif command -v pacman &> /dev/null; then
            pacman -Sy --noconfirm "${missing[@]}"
        else
            echo -e "${RED}[!] Please install manually: ${missing[*]}${NC}"
            exit 1
        fi
    fi
}

# --- ASCII Banner ---
show_banner() {
    clear
    echo -e "${ORANGE}"
    echo "██████╗  █████╗ ███████╗███████╗██╗  ██╗███████╗██╗   ██╗███████╗███████╗"
    echo "██╔══██╗██╔══██╗██╔════╝██╔════╝██║ ██╔╝██╔════╝╚██╗ ██╔╝╚══███╔╝╚══███╔╝"
    echo "██████╔╝███████║███████╗███████╗█████╔╝ █████╗   ╚████╔╝   ███╔╝   ███╔╝"
    echo "██╔═══╝ ██╔══██║╚════██║╚════██║██╔═██╗ ██╔══╝    ╚██╔╝   ███╔╝   ███╔╝"
    echo "██║     ██║  ██║███████║███████║██║  ██╗███████╗   ██║   ███████╗███████╗"
    echo "╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝"
    echo -e "${NC}"
    echo -e "${ORANGE}${BOLD}                 script by Pascal Muju${NC}"
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  🔥 PASSKEYZZ NETWORK TOOLKIT - READY 🔥${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# --- Option 1: My IP ---
show_my_ip() {
    echo -e "${BLUE}[*] Fetching your IP...${NC}\n"
    
    local public_ip=$(curl -s ifconfig.me)
    local local_ip=$(hostname -I | awk '{print $1}')
    
    echo -e "${GREEN}🌍 Public IP:${NC} $public_ip"
    echo -e "${GREEN}🏠 Local IP:${NC} $local_ip"
    echo ""
    read -p "Press [Enter] to return to menu..."
}

# --- Option 2: Test Internet Speed ---
test_speed() {
    echo -e "${BLUE}[*] Testing internet speed...${NC}\n"
    
    if ! command -v speedtest-cli &> /dev/null; then
        echo -e "${RED}[!] Installing speedtest-cli...${NC}"
        apt install speedtest-cli -y &> /dev/null
    fi
    
    speedtest-cli --simple
    echo ""
    read -p "Press [Enter] to return to menu..."
}

# --- Option 3: Scan for devices on my network ---
scan_network() {
    echo -e "${BLUE}[*] Scanning for devices on your network...${NC}\n"
    
    local network=$(ip route | grep -m1 '^default via' | awk '{print $3}' | cut -d. -f1-3)
    local subnet="${network}.0/24"
    
    echo -e "${YELLOW}[+] Scanning $subnet ...${NC}\n"
    
    if command -v arp-scan &> /dev/null; then
        arp-scan --localnet --quiet | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}'
    else
        echo -e "${RED}[!] Installing arp-scan...${NC}"
        apt install arp-scan -y &> /dev/null
        arp-scan --localnet --quiet | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}'
    fi
    
    echo ""
    read -p "Press [Enter] to return to menu..."
}

# --- Option 4: Scan open ports on a web ---
scan_ports() {
    echo -e "${BLUE}[*] Scan open ports on a web${NC}\n"
    read -p "Enter target domain: " target
    
    if [[ -z "$target" ]]; then
        echo -e "${RED}[!] No target entered.${NC}"
        sleep 1
        return
    fi
    
    echo -e "${YELLOW}[+] Scanning open ports on $target ...${NC}\n"
    
    common_ports=(21 22 23 25 53 80 110 135 139 143 443 445 993 995 1723 3306 3389 5432 5900 8080)
    
    for port in "${common_ports[@]}"; do
        timeout 1 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null && echo -e "${GREEN}✔ Port $port is OPEN${NC}" || echo -e "${RED}✘ Port $port is CLOSED${NC}"
    done
    
    echo ""
    read -p "Press [Enter] to return to menu..."
}

# --- Option 5: Goodbye ---
goodbye() {
    echo -e "${RED}[ ! ] passkeyzz is shutting down...${NC}"
    echo -e "${YELLOW}Thanks for using PASSKEYZZ - Pascal Muju${NC}"
    echo -e "${CYAN}Goodbye! 👋${NC}"
    exit 0
}

# --- Main Menu ---
main_menu() {
    while true; do
        show_banner
        echo -e "${ORANGE}┌────────────────────────────────────────────┐${NC}"
        echo -e "${ORANGE}│           📡 SELECT AN OPTION                │${NC}"
        echo -e "${ORANGE}└────────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "  ${GREEN}[1]${NC} My IP"
        echo -e "  ${GREEN}[2]${NC} Test Internet speed"
        echo -e "  ${GREEN}[3]${NC} Scan for devices on my network"
        echo -e "  ${GREEN}[4]${NC} Scan open ports on a web"
        echo -e "  ${GREEN}[5]${NC} Goodbye!!"
        echo ""
        echo -e "${CYAN}────────────────────────────────────────────────${NC}"
        read -p "➜ Choose [1-5]: " choice
        
        case $choice in
            1) show_my_ip ;;
            2) test_speed ;;
            3) scan_network ;;
            4) scan_ports ;;
            5) goodbye ;;
            *) echo -e "${RED}[!] Invalid option.${NC}"; sleep 1 ;;
        esac
    done
}

# --- Run ---
check_deps
main_menu