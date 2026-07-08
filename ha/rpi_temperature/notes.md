## install mqtt client
sudo apt update
sudo apt install mosquitto-clients


## enable publishing scripts

crontab -e

* * * * * /home/sarathkumar/home-assistant/ha/temp_monitor/publish_rpi_desktop.sh >/dev/null 2>&1
