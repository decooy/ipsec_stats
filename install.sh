#!/bin/bash

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Install required packages
apt-get update
apt-get install -y python3 python3-pip

# Create directory for the application
mkdir -p /opt/ipsec_stats
cp main.py /opt/ipsec_stats/
cp requirements.txt /opt/ipsec_stats/

# Install Python dependencies
cd /opt/ipsec_stats
pip3 install -r requirements.txt

# Create systemd service file
cat > /etc/systemd/system/ipsec_stats.service << EOL
[Unit]
Description=IPsec Statistics Web Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/ipsec_stats
ExecStart=/usr/bin/python3 /opt/ipsec_stats/main.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize new service
systemctl daemon-reload

# Enable and start the service
systemctl enable ipsec_stats
systemctl start ipsec_stats

echo "Installation completed. Service is installed and running."
echo "You can check status with: systemctl status ipsec_stats"
echo "Service will automatically start on boot and restart on failure." 