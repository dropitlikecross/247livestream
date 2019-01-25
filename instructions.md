


# 247livestream
24/7 Live Stream Project


Run serversetup.sh to install all requirements and system environments.

    sudo sh serversetup.sh


# ALSA
This is the sound system used by linux. I wasn't able to get it working on the Azure Kernel so we will have to change to the Generic Kernel.
''Note: This is only applies to Azure hosted servers and is a workaround''

Check that you are on generic:

    cat /boot/grub/grub.cfg

If you are, confirm by:

    sudo modprobe snd-aloop pcm_substreams=1


In order to do that we need to change linux kernel to generic so modprobe snd-aloop works.

    sudo nano /etc/default/grub 

and set

    GRUB_DEFAULT=“1>2”
then

    sudo update-grub

And then reboot now to take this in effect. After rebooting you can test it with 

    uname -a

 

You should see the generic kernel. Then run:

    sudo modprobe snd-aloop pcm_substreams=1

Alternatively you can remove the azure kernels:

    ls /lib/modules

    sudo apt-get autoremove --purge 4.15.0-1036-azure

Remove all versions of -azure. You may need to reboot once and remove the updated version.



# Add a network share

    sudo nano /etc/fstab

Add your azure shared storage. I've left a generic name as a guide:

    //.file.core.windows.net/streamingstorage              /mnt/streamstorage            cifs credentials=/home/storagelogin.credentials,noauto,nofail,x-systemd.automount,x-systemd.device-timeout=90 0       0

Create the credentials file and fill it in with your login details. You can place the credetials in fstab if you prefer.

    sudo nano storagelogin.credentials
Mount the network drives:

    sudo mount -a -t cifs



# MPC
**Installing MPC to play the music.**

    sudo usermod -a -G stream2 mpd
    sudo usermod -a -G audio mpd
    
    sudo nano /etc/mpd.conf

Change the music directory to the music directory of your preference. (Azure shared storage)

    mpc update

Use "mpc ls | mpc add" to add all files to the playlist.

    mpc ls | mpc add

I recommend the following settings for MPC:

    mpc repeat on | mpc shuffle | mpc play

More on MPC:
http://manpages.ubuntu.com/manpages/trusty/man1/mpc.1.html


**Note:**
Run the stream first then run the audio as there is an ALSA clash otherwise.

