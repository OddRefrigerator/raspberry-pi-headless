#Raspberry Pi headless setup for Raspberry Pi OS
Adjust files as needed and copy everything to the /boot partition on the SD card

#Tested with 2022-09-06-raspios-bullseye-arm64.img.xz
xzcat ~/iso/2022-09-06-raspios-bullseye-arm64.img.xz | sudo dd of=/dev/sda status=progress bs=4M oflag=sync

/boot/userconf.txt
Password for the pi user
ENCRYPTED_PASSWORD from echo "steve:$(echo 'TheFlyingFish' | openssl passwd -6 -stdin)" > userconf.txt

/boot/ssh
enable ssh server

/boot/wpa_supplicant.conf
Wi-Fi setup

#WIP 
/boot/cmdline.txt
Updated cmdline.txt to firstrun.sh on first boot. 
Find partion UUID to update cmdline.txt file  blkid -p /dev/sda1 | egrep PART_ENTRY_UUID

#WIP
/boot/firstrun.sh
BASH script to perform setup of Wi-Fi, SSH, hostname, user creation, time zone and keyboard/localization


