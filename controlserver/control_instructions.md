# Add a network share
sudo nano /etc/fstab

//.file.core.windows.net/streamingstorage              /mnt/streamstorage            cifs credentials=/home/storagelogin.credentials,noauto,nofail,x-systemd.automount,x-systemd.device-timeout=90 0       0

create the crediantials file
sudo nano storagelogin.credentials

# Set up crontab -e

