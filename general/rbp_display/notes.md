#------------------- for touch-brightness control at boot 

sudo nano /etc/systemd/system/touch-brightness.service

    [Unit]
    Description=Touch Brightness Control
    After=multi-user.target

    [Service]
    ExecStart=/home/sarathkumar/screen-control.sh
    Restart=always
    User=sarathkumar
    Group=sarathkumar

    [Install]
    WantedBy=multi-user.target



sudo systemctl daemon-reload
sudo systemctl enable touch-brightness.service
sudo systemctl start touch-brightness.service


#------------------- For HA auto-start at boot
sudo apt update
sudo apt install -y chromium-browser unclutter


mkdir -p ~/.config/autostart
nano ~/.config/autostart/homeassistant.desktop
    [Desktop Entry]
    Type=Application
    Name=Home Assistant Kiosk
    Exec=sh -c "DISPLAY=:0 unclutter -idle 0 & chromium-browser --noerrdialogs --disable-infobars --kiosk http://homeassistant.local:8123"
    X-GNOME-Autostart-enabled=true

DISPLAY=:0 pkill -9 chromium

#--------------------- Making ip static
sudo nmcli connection modify "Wired connection 1" \
  ipv4.method manual \
  ipv4.addresses 192.168.0.14/24 \
  ipv4.gateway 192.168.0.1 \
  ipv4.dns 192.168.0.1 \
  ipv6.method ignore

sudo reboot

nmcli connection show "Wired connection 1" | grep ipv4.method


