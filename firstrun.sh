#!/bin/bash

set +e

echo '-------------------------------'
echo '|   Entering setup script     |'
echo '-------------------------------'

#Set hostname to rpi4
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
echo rpi4 >/etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\trpi4/g" /etc/hosts

#Configure first user
FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'steve' '$5$eNXy5osqZ6$qew7zqZqEe2YkucYOSX6pcg6r39emGZrsf.T4r52iG9'
else
   echo "$FIRSTUSER:"'$5$eNXy5osqZ6$qew7zqZqEe2YkucYOSX6pcg6r39emGZrsf.T4r52iG9' | chpasswd -e
   if [ "$FIRSTUSER" != "steve" ]; then
      usermod -l "steve" "$FIRSTUSER"
      usermod -m -d "/home/steve" "steve"
      groupmod -n "steve" "$FIRSTUSER"
      if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
         sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=steve/"
      fi
      if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
         sed /etc/systemd/system/getty@tty1.service.d/autologin.conf -i -e "s/$FIRSTUSER/steve/"
      fi
      if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
         sed -i "s/^$FIRSTUSER /steve /" /etc/sudoers.d/010_pi-nopasswd
      fi
   fi
fi

#Enable SSH service and disable password auth
echo 'PasswordAuthentication no' >>/etc/ssh/sshd_config
systemctl enable ssh

#Configure Wi-Fi
cat >/etc/wpa_supplicant/wpa_supplicant.conf <<'WPAEOF'
country=TH
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
 scan_ssid=1
 ssid="@GoldenSea-WiFi"
 key_mgmt=NONE
}

WPAEOF
chmod 600 /etc/wpa_supplicant/wpa_supplicant.conf
rfkill unblock wifi
for filename in /var/lib/systemd/rfkill/*:wlan ; do
  echo 0 > $filename
done

#Configure timezone and localization
rm -f /etc/localtime
echo "Asia/Bangkok" >/etc/timezone
dpkg-reconfigure -f noninteractive tzdata
cat >/etc/default/keyboard <<'KBEOF'
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""

KBEOF
dpkg-reconfigure -f noninteractive keyboard-configuration

#Disable Bluetooth service
systemctl disable bluetooth.service

echo '-------------------------------'
echo 'Updating software'
echo '-------------------------------'
#Update software repositories and do full upgrade
apt update
apt full-upgrade -y

#Install matchbox keyboard for onscreen keyboard support
apt install -y matchbox-keyboard

#Add Google Chrome repository and install Chrome unstable
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
apt install -y google-chrome-stable google-chrome-beta google-chrome-unstable

#Remove first run script and remove reference to script in /boot/cmdline.txt
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0