#!/bin/bash

# Nomad_Portal Installer
# A portable website deployment solution that works from any USB drive

# Color definitions for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Print banner with monospace/OCR-inspired look
echo -e "${BLUE}"
echo "+--------------------------------------------------------------+"
echo "|                                                              |"
echo "|  ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ██████╗               |"
echo "|  ████╗  ██║██╔═══██╗████╗ ████║██╔══██╗██╔══██╗              |"
echo "|  ██╔██╗ ██║██║   ██║██╔████╔██║███████║██║  ██║              |"
echo "|  ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║  ██║              |"
echo "|  ██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██████╔╝              |"
echo "|  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝               |"
echo "|         ██████╗  ██████╗ ██████╗ ████████╗ █████╗ ██╗        |"
echo "|         ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗██║        |"
echo "|         ██████╔╝██║   ██║██████╔╝   ██║   ███████║██║        |"
echo "|         ██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══██║██║        |"
echo "|         ██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗   |"
echo "|         ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝   |"
echo "|                                                              |"
echo "|          YOUR PORTABLE DIGITAL PRESENCE ON THE GO            |"
echo "|                                                              |"
echo "+--------------------------------------------------------------+"
echo -e "${NC}"

# Check if running with sudo/root permissions
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root or with sudo${NC}"
  exit 1
fi

# Function to list available USB drives
list_usb_drives() {
  echo -e "${YELLOW}Scanning for USB drives...${NC}"
  echo ""
  
  # Find removable devices
  lsblk -d -o NAME,SIZE,MODEL,TRAN | grep "usb" || echo -e "${RED}No USB drives detected${NC}"
  echo ""
}

# Function to install necessary packages
install_dependencies() {
  echo -e "${YELLOW}Installing necessary components for Nomad_Portal...${NC}"
  
  # Create temp directory for downloads
  mkdir -p /tmp/nomad_portal_installer
  cd /tmp/nomad_portal_installer
  
  # Download portable packages
  echo -e "Downloading lightweight web server..."
  wget -q https://github.com/lighttpd/lighttpd1.4/archive/lighttpd-1.4.69.tar.gz -O lighttpd.tar.gz
  
  echo -e "Downloading ngrok..."
  wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O ngrok.tgz
  
  echo -e "${GREEN}Downloads completed${NC}"
}

# Function to prepare USB drive
prepare_usb() {
  local usb_device=$1
  local mount_point="/mnt/nomad_portal_temp"
  
  echo -e "${YELLOW}Preparing USB drive ${usb_device} for Nomad_Portal...${NC}"
  
  # Create mount point if it doesn't exist
  mkdir -p $mount_point
  
  # Mount the USB drive
  mount /dev/$usb_device $mount_point
  
  # Create directory structure
  mkdir -p $mount_point/nomad_portal
  mkdir -p $mount_point/nomad_portal/server
  mkdir -p $mount_point/nomad_portal/www
  mkdir -p $mount_point/nomad_portal/bin
  mkdir -p $mount_point/nomad_portal/logs
  
  # Extract packages to USB
  tar -xf /tmp/nomad_portal_installer/lighttpd.tar.gz -C $mount_point/nomad_portal/server
  tar -xf /tmp/nomad_portal_installer/ngrok.tgz -C $mount_point/nomad_portal/bin
  
  # Create default website files
  echo "<!DOCTYPE html>
<html>
<head>
    <title>Nomad_Portal - Portable Web Presence</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            margin: 0;
            padding: 0;
            background-color: #121212;
            color: #00ff00;
        }
        .terminal {
            max-width: 900px;
            margin: 50px auto;
            background: #1e1e1e;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 4px 30px rgba(0, 255, 0, 0.1);
            border: 1px solid #00aa00;
        }
        h1 {
            color: #00ff00;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
        }
        .ascii-art {
            color: #00ff00;
            text-align: center;
            font-size: 10px;
            line-height: 10px;
            white-space: pre;
            margin: 20px 0;
        }
        p {
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .prompt:before {
            content: '> ';
            color: #00ff00;
        }
        .prompt {
            margin-left: 20px;
        }
        .blink {
            animation: blink 1s infinite;
        }
        @keyframes blink {
            0%, 49% { opacity: 1; }
            50%, 100% { opacity: 0; }
        }
    </style>
</head>
<body>
    <div class='terminal'>
        <div class='ascii-art'>
███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ██████╗     ██████╗  ██████╗ ██████╗ ████████╗ █████╗ ██╗     
████╗  ██║██╔═══██╗████╗ ████║██╔══██╗██╔══██╗    ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗██║     
██╔██╗ ██║██║   ██║██╔████╔██║███████║██║  ██║    ██████╔╝██║   ██║██████╔╝   ██║   ███████║██║     
██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║  ██║    ██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══██║██║     
██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██████╔╝    ██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗
╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
        </div>
        <h1>SYSTEM ONLINE</h1>
        <p class='prompt'>Nomad_Portal successfully deployed</p>
        <p class='prompt'>Your portable digital presence is now active</p>
        <p class='prompt'>Edit the files in the 'www' directory on your USB drive to customize this website</p>
        <p class='prompt'>Connection status: <span style='color:#00ff00;'>ACTIVE</span></p>
        <p class='prompt blink'>_</p>
    </div>
</body>
</html>" > $mount_point/nomad_portal/www/index.html
  
  # Create favicon
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"48\" height=\"48\" viewBox=\"0 0 48 48\">
  <rect width=\"48\" height=\"48\" fill=\"#121212\" rx=\"5\" />
  <text x=\"8\" y=\"30\" font-family=\"monospace\" font-size=\"16\" fill=\"#00FF00\">N_P</text>
</svg>" > $mount_point/nomad_portal/www/favicon.svg
  
  # Create launcher script
  echo '#!/bin/bash

# Nomad_Portal Launcher
# This script launches a portable website from the USB drive

# Color definitions
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Determine script location (should be on the USB drive)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USB_ROOT="$(dirname "$SCRIPT_DIR")"

# Print banner with OCR/monospace style
echo -e "${BLUE}"
echo "+--------------------------------------------------------------+"
echo "|                                                              |"
echo "|  ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ██████╗               |"
echo "|  ████╗  ██║██╔═══██╗████╗ ████║██╔══██╗██╔══██╗              |"
echo "|  ██╔██╗ ██║██║   ██║██╔████╔██║███████║██║  ██║              |"
echo "|  ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║  ██║              |"
echo "|  ██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║██████╔╝              |"
echo "|  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝               |"
echo "|         ██████╗  ██████╗ ██████╗ ████████╗ █████╗ ██╗        |"
echo "|         ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗██║        |"
echo "|         ██████╔╝██║   ██║██████╔╝   ██║   ███████║██║        |"
echo "|         ██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══██║██║        |"
echo "|         ██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗   |"
echo "|         ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝   |"
echo "|                                                              |"
echo "|                  SYSTEM INITIALIZATION                       |"
echo "|                                                              |"
echo "+--------------------------------------------------------------+"
echo -e "${NC}"

# Function to check if port is available
check_port() {
    local port=$1
    if command -v netstat > /dev/null; then
        netstat -tuln | grep ":$port " > /dev/null
        return $?
    elif command -v ss > /dev/null; then
        ss -tuln | grep ":$port " > /dev/null
        return $?
    fi
    return 0 # Assume port is in use if we cannot check
}

# Find an available port starting from 8000
PORT=8000
while check_port $PORT; do
    PORT=$((PORT + 1))
    if [ $PORT -gt 9000 ]; then
        echo -e "${RED}Cannot find an available port between 8000-9000${NC}"
        exit 1
    fi
done

# Configure ngrok
echo -e "${YELLOW}[SYSTEM] Configuring secure tunnel...${NC}"
NGROK="$USB_ROOT/bin/ngrok"
chmod +x "$NGROK"

# Create temporary config for ngrok
NGROK_CONFIG="$USB_ROOT/logs/ngrok_config.yml"
echo "version: 2" > "$NGROK_CONFIG"
echo "web_addr: localhost:4040" >> "$NGROK_CONFIG"
echo "log_level: error" >> "$NGROK_CONFIG"

# Start web server (using Python for simplicity)
echo -e "${YELLOW}[SYSTEM] Initializing web server on port $PORT...${NC}"
cd "$USB_ROOT/www"

# Try different Python versions (for compatibility)
if command -v python3 > /dev/null; then
    python3 -m http.server $PORT > "$USB_ROOT/logs/server.log" 2>&1 &
elif command -v python > /dev/null; then
    python -m SimpleHTTPServer $PORT > "$USB_ROOT/logs/server.log" 2>&1 &
else
    echo -e "${RED}[ERROR] Python not found. Cannot start web server.${NC}"
    exit 1
fi

SERVER_PID=$!
echo "[SYSTEM] Web server process: $SERVER_PID"

# Start ngrok tunnel
echo -e "${YELLOW}[SYSTEM] Establishing global portal connection...${NC}"
"$NGROK" http $PORT --config="$NGROK_CONFIG" > "$USB_ROOT/logs/ngrok.log" 2>&1 &
NGROK_PID=$!

# Wait for ngrok to start
sleep 3

# Get the public URL
if command -v curl > /dev/null; then
    PUBLIC_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o "https://[a-zA-Z0-9.-]*\.ngrok\.io")
elif command -v wget > /dev/null; then
    PUBLIC_URL=$(wget -qO- http://localhost:4040/api/tunnels | grep -o "https://[a-zA-Z0-9.-]*\.ngrok\.io")
else
    echo -e "${YELLOW}[WARNING] Cannot automatically determine the public URL."
    echo -e "Please visit http://localhost:4040 to find your public URL.${NC}"
    PUBLIC_URL="http://localhost:4040 (check the Web Interface)"
fi

echo -e "${GREEN}┌───────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}│         NOMAD_PORTAL ONLINE                   │${NC}"
echo -e "${GREEN}└───────────────────────────────────────────────┘${NC}"
echo -e "${GREEN}▶ Your portable website is now accessible at:${NC}"
echo -e "${BLUE}▶ $PUBLIC_URL${NC}"
echo -e "${YELLOW}▶ Local access: http://localhost:$PORT${NC}"
echo ""
echo -e "${YELLOW}[SYSTEM] Press Ctrl+C to disconnect portal when finished.${NC}"

# Set up cleanup function
cleanup() {
    echo -e "${YELLOW}[SYSTEM] Closing portal connection...${NC}"
    kill $SERVER_PID $NGROK_PID 2>/dev/null
    echo -e "${GREEN}[SYSTEM] Nomad_Portal disconnected. Safe to remove USB.${NC}"
    exit 0
}

# Register cleanup function for program termination
trap cleanup INT TERM EXIT

# Keep script running
while true; do
    sleep 1
done
' > $mount_point/nomad_portal/launch.sh
  chmod +x $mount_point/nomad_portal/launch.sh
  
  # Create a shortcut/autorun file
  echo '[Autorun]
label=Launch Nomad_Portal
action=Deploy Portable Website
open=launch_nomad_portal.bat
icon=nomad_portal/www/favicon.svg

[Content]
MusicFiles=false
PictureFiles=false
VideoFiles=false' > $mount_point/autorun.inf
  
  # Create Windows launcher batch file
  echo '@echo off
color 0A
echo +--------------------------------------------------------------+
echo ^|                                                              ^|
echo ^|  NOMAD_PORTAL                                                ^|
echo ^|  YOUR PORTABLE DIGITAL PRESENCE                              ^|
echo ^|                                                              ^|
echo +--------------------------------------------------------------+
echo.
echo Initializing Nomad_Portal...
cd /d %~dp0
cd nomad_portal
start "" "launch.sh"
echo.
echo If the launcher doesn't start automatically, please open a terminal
echo and run: bash nomad_portal/launch.sh
echo.
echo Press any key to exit...
pause >nul
exit' > $mount_point/launch_nomad_portal.bat
  
  # Create Unix/Linux launcher shell script
  echo '#!/bin/bash
cd "$(dirname "$0")/nomad_portal"
bash launch.sh' > $mount_point/launch_nomad_portal.sh
  chmod +x $mount_point/launch_nomad_portal.sh
  
  # Create a README file
  echo '# NOMAD_PORTAL

## Your Portable Digital Presence On The Go

Nomad_Portal allows you to instantly deploy and broadcast your website from any computer 
with an internet connection. Simply plug in your USB drive, launch the application, 
and your pre-loaded website becomes accessible worldwide through a secure tunnel connection.

### USAGE INSTRUCTIONS

1. **Windows Users**:
   - Double-click `launch_nomad_portal.bat` on the USB drive
   - Follow the on-screen instructions

2. **Linux/Mac Users**:
   - Open a terminal
   - Navigate to the USB drive
   - Run: `bash launch_nomad_portal.sh`

3. **Customizing Your Website**:
   - Edit files in the `nomad_portal/www` folder on the USB drive
   - The main page is `index.html`
   - Add any other assets (images, CSS, JS) to this folder

### TECHNICAL INFORMATION

Nomad_Portal creates a local web server on the host computer and establishes
a secure tunnel to make your website accessible from anywhere. The connection
remains active until you disconnect the USB drive or terminate the process.

No software is installed on the host computer - everything runs directly from
the USB drive and terminates cleanly when you disconnect.

---

Nomad_Portal - Created 2025
' > $mount_point/README.md
  
  # Unmount USB drive
  umount $mount_point
  
  echo -e "${GREEN}Nomad_Portal installation complete!${NC}"
}

# Main program
echo -e "${YELLOW}Welcome to the Nomad_Portal Installer${NC}"
echo -e "This tool will prepare a USB drive to host your portable website on any computer."
echo ""

# List available USB drives
list_usb_drives

# Ask for USB drive selection
echo -e "${YELLOW}Enter the device name of your USB drive (e.g., sdb1):${NC}"
read usb_device

# Confirm selection
echo -e "${RED}WARNING: All data on /dev/$usb_device will be preserved, but some files may be overwritten.${NC}"
echo -e "${YELLOW}Are you sure you want to continue? (y/n)${NC}"
read confirm

if [[ $confirm == [Yy]* ]]; then
  # Install dependencies
  install_dependencies
  
  # Prepare USB drive
  prepare_usb $usb_device
  
  echo -e "${GREEN}+--------------------------------------------------------------+${NC}"
  echo -e "${GREEN}|                                                              |${NC}"
  echo -e "${GREEN}|                NOMAD_PORTAL INSTALLATION                     |${NC}"
  echo -e "${GREEN}|                      COMPLETE                                |${NC}"
  echo -e "${GREEN}|                                                              |${NC}"
  echo -e "${GREEN}+--------------------------------------------------------------+${NC}"
  echo ""
  echo -e "${YELLOW}To deploy your portable website:${NC}"
  echo -e "1. On Windows: Double-click 'launch_nomad_portal.bat' on the USB drive"
  echo -e "2. On Linux/Mac: Run 'bash launch_nomad_portal.sh' from the USB drive"
  echo -e "3. Edit files in the 'nomad_portal/www' folder to customize your website"
  echo ""
  echo -e "${BLUE}Thank you for using Nomad_Portal - Your digital presence on the go!${NC}"
else
  echo -e "${YELLOW}Installation cancelled.${NC}"
fi

# Clean up
rm -rf /tmp/nomad_portal_installer
