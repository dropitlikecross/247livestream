# Youtube DL
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

#FFMPEG
sudo apt-get -y install ffmpeg


# Add a network share
sudo nano /etc/fstab

//.file.core.windows.net/streamingstorage              /mnt/streamstorage            cifs credentials=/home/storagelogin.credentials,noauto,nofail,x-systemd.automount,x-systemd.device-timeout=90 0       0

create the crediantials file
sudo nano storagelogin.credentials

# Set up Cron Scripts

Place the sh scripts inside /etc/cron.daily replace the mount location and url with your own.

    youtube-dl -i --download-archive "/mnt/streamstorage/music/gamingstream/archive.txt" -o "/mnt/streamstorage/music/gamingstream/songs/%(title)s.%(ext)s" -f bestaudio --audio-format mp3 "https://www.youtube.com/user/NoCopyrightSounds/videos" --reject-title "podcast" --reject-title "cinematic" --reject-title "mix" --geo-bypass --yes-playlist --playlist-start 1 --add-metadata -x "%(artist)s - %(title)s"
    
    youtube-dl -i --download-archive "/mnt/streamstorage/music/gamingstream/archive.txt" -o "/mnt/streamstorage/music/gamingstream/songs/%(title)s.%(ext)s" -f bestaudio --audio-format mp3 "https://www.youtube.com/playlist?list=PLZb6kNIh9TrHokGyJZrvJEhMpO78UMiQM" --reject-title "podcast" --reject-title "cinematic" --reject-title "mix" --geo-bypass --yes-playlist --playlist-start 1 --add-metadata -x "%(artist)s - %(title)s"
    
    
    date >> youtubesh.log



# Youtube DL Parameters
--download-archive "/home/archive.txt" -o "/home/music/songs/%(title)s.%(ext)s" -f bestaudio --audio-format mp3 "https://www.youtube.com/user/dropitlikecross/videos"- --reject-title "podcast" --reject-title "mix" --geo-bypass --playlist-start 1 --add-metadata -x --metadata-from-title "%(artist)s - %(title)s"

