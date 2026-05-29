# passkeyzz

A simple open-source Bash networking toolkit.

## Features

- Reveal your public IP address
- Test internet download/upload speed
- Scan local network devices and vendor names
- Scan open ports on a target domain or IP
- Clean colorful terminal interface

---

## Screenshot

See `passkeyzz.png`

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/passkeyzz.git
cd passkeyzz
```

### 2. Make the script executable

```bash
chmod +x passkeyzz.sh
```

### 3. Install required tools

```bash
sudo apt update
sudo apt install curl nmap arp-scan speedtest-cli
```

---

## Usage

Run the tool using:

```bash
sudo ./passkeyzz.sh
```

---

## Menu Options

1. My IP  
2. Test Internet speed  
3. Scan for devices on my network  
4. Scan open ports on a web  
5. Goodbye!!

---

## Author

Script by Pascal Muju

---

## Disclaimer

Use responsibly and only on networks/systems you own or are authorized to test.
PASSKEYZZ is a **network reconnaissance and security testing tool** designed exclusively for:
- ✅ Authorized security professionals conducting **penetration testing** with written permission
- ✅ System administrators managing **their own networks**
- ✅ Educational purposes in **controlled lab environments**
- ✅ Personal network analysis on **devices you own**

**YOU ARE NOT AUTHORIZED TO USE THIS TOOL IF:**
- ❌ You intend to scan networks, IP addresses, or domains without explicit permission
- ❌ You plan to use this tool for any malicious, unauthorized, or illegal activities
- ❌ You are in a jurisdiction where network scanning tools are restricted or prohibited
- ❌ You do not fully understand and accept these terms
