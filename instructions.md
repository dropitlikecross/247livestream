
# 247livestream
24/7 Live Stream Project


Run serversetup.sh to install all requirements.


# ALSA
This is the sound system used by linux
Check that you are on generic:

cat /boot/grub/grub.cfg

If you are, run 

sudo modprobe snd-aloop pcm_substreams=1

to confirm.

In order to do that we need to change linux kernel to generic so modprobe snd-aloop works.

sudo nano /etc/default/grub 

and set

GRUB_DEFAULT=“1>2”

sudo update-grub

And then reboot now to take this in effect

After reboot you can test it with 

uname -a 

which should give you generic and run

sudo modprobe snd-aloop pcm_substreams=1

**Note**
Set modprobe snd-aloop pcm_substreams=1 to run on boot

# Add a network share
sudo nano /etc/fstab

//.file.core.windows.net/streamingstorage              /mnt/streamstorage            cifs credentials=/home/storagelogin.credentials,noauto,nofail,x-systemd.automount,x-systemd.device-timeout=90 0       0

create the crediantials file
sudo nano storagelogin.credentials


# MPC

sudo usermod -a -G stream2 mpd
sudo usermod -a -G audio mpd

sudo nano /etc/mpd.conf

Change the music directory

mpc update

Use "mpc ls | mpc add" to add all files to the playlist.


mpc ls | mpc add

mpc repeat on | mpc shuffle | mpc play

More on MPC:
http://manpages.ubuntu.com/manpages/trusty/man1/mpc.1.html


**Note:**
Run the stream first then run the audio as there is an ALSA clash otherwise.


