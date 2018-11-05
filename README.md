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

After reboot you can test it with uname -a which should give you generic and run
sudo modprobe snd-aloop pcm_substreams=1
