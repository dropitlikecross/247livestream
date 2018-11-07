# Youtube DL
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl


# Add a network share
sudo nano /etc/fstab

//.file.core.windows.net/streamingstorage              /mnt/streamstorage            cifs credentials=/home/storagelogin.credentials,noauto,nofail,x-systemd.automount,x-systemd.device-timeout=90 0       0

create the crediantials file
sudo nano storagelogin.credentials

# Set up Cron Scripts

Place the sh scripts inside /etc/cron.daily
crontab -e is a bit overkill and I decided I didn't need it



