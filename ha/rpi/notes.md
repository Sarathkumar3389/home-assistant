## install mqtt client
sudo apt update
sudo apt install mosquitto-clients


## enable publishing scripts

crontab -e

* * * * * /home/sarathkumar/home-assistant/ha/rpi/publish_rpi_desktop.sh
