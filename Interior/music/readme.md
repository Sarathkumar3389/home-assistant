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

## MPD config
sudo nano /etc/mpd.conf


making Mountable:
sudo nano /etc/smb-credentials
username=sarathkumar
password=schizophrenic


sudo nano /etc/fstab
sudo mount -t cifs //192.168.0.10/shared /mnt/share   -o credentials=/etc/smb-credentials,uid=$(id -u mpd),gid=$(getent group audio | cut -d: -f3),iocharset=utf8,vers=3.0


mpc play config:
sudo nano /etc/mpd.conf


