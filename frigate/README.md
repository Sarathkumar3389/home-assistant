# Script for frigate 

https://github.com/kornyhiv/frigatenvr-easyinstallation/blob/main/frigate_installer.sh


# Start / Stop / Delete the container

``` /home/sarathkumar/home-assistant/frigate_scripts/frigate.sh start ```

``` /home/sarathkumar/home-assistant/frigate_scripts/frigate.sh stop ```

``` /home/sarathkumar/home-assistant/frigate_scripts/frigate.sh delete ```


## Modifications on the script frigate.sh
 1. Commented out the coraltpu 1 
 
 2.   added below for interl GPU 
 # HWACCEL_ARGS="vaapi"
  HWACCEL_ARGS="-hwaccel vaapi -hwaccel_device /dev/dri/renderD128"



