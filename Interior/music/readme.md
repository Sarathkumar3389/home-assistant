## Music files are stored and network share
sudo nano /etc/samba/smb.conf

[share]
   path = /mnt/sda1/share
   browseable = yes
   read only = no
   guest ok = yes
   create mask = 0775
   directory mask = 0775
   force user = sarathkumar

sudo systemctl restart smbd
