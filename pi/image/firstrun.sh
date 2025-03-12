#!/bin/bash

set +e

CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom set_hostname weather-station-rpi
else
   echo weather-station-rpi >/etc/hostname
   sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\tweather-station-rpi/g" /etc/hosts
fi
FIRSTUSER=`getent passwd 1000 | cut -d: -f1`
FIRSTUSERHOME=`getent passwd 1000 | cut -d: -f6`
if [ -f /usr/lib/raspberrypi-sys-mods/imager_custom ]; then
   /usr/lib/raspberrypi-sys-mods/imager_custom enable_ssh -k 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbtGQ4uq++EXpFZdb4Ph1o17QmptNSKh+/rAO7eoLGEHNUqBSJIddTRx1osd/9qcYmfsLsWU49rkYAvxsR+woCTmTFlTDu53sJxdk4/oqJJoLPGSBaNHZyOlz9aUlWVFc0BDoEQBAbKh0BQiRN/zv0Wr0T/qPcW4I2dXazN+ZNanIho30UkWjSLz+U7y4BBvccGdqu37HLFmopAlPbAcgOord5L7m6fxhaXgrprSBaFwg6rLACgNNKskWPBu9WkCpA+ridpk1pBZVHU4S9IAipmPi6NUuQ634CpzO59GwGe3Y+w1PQuRtK5FF/ef4PkRxoyXXZq7sZcJC5fg2hf9E84UW3rGVzV7av9iOu/tgUZvbPEahpPbTu6Hy1YbT2nh8E0GkpgalfZgEwkPFKwwq95Crj9OYLyULB9/RjicN9Cllh26xIHrywqJgR+QrziNIUO75CXccDbSSh1DfWp9VqwcCfy4N2K42NvB9eAqo56i+sDx6Jd3eDeSj4ew3fUyU= jferrero@jferrero-Precision-5530'
else
   install -o "$FIRSTUSER" -m 700 -d "$FIRSTUSERHOME/.ssh"
   install -o "$FIRSTUSER" -m 600 <(printf "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbtGQ4uq++EXpFZdb4Ph1o17QmptNSKh+/rAO7eoLGEHNUqBSJIddTRx1osd/9qcYmfsLsWU49rkYAvxsR+woCTmTFlTDu53sJxdk4/oqJJoLPGSBaNHZyOlz9aUlWVFc0BDoEQBAbKh0BQiRN/zv0Wr0T/qPcW4I2dXazN+ZNanIho30UkWjSLz+U7y4BBvccGdqu37HLFmopAlPbAcgOord5L7m6fxhaXgrprSBaFwg6rLACgNNKskWPBu9WkCpA+ridpk1pBZVHU4S9IAipmPi6NUuQ634CpzO59GwGe3Y+w1PQuRtK5FF/ef4PkRxoyXXZq7sZcJC5fg2hf9E84UW3rGVzV7av9iOu/tgUZvbPEahpPbTu6Hy1YbT2nh8E0GkpgalfZgEwkPFKwwq95Crj9OYLyULB9/RjicN9Cllh26xIHrywqJgR+QrziNIUO75CXccDbSSh1DfWp9VqwcCfy4N2K42NvB9eAqo56i+sDx6Jd3eDeSj4ew3fUyU= jferrero@jferrero-Precision-5530") "$FIRSTUSERHOME/.ssh/authorized_keys"
   echo 'PasswordAuthentication no' >>/etc/ssh/sshd_config
   systemctl enable ssh
fi
if [ -f /usr/lib/userconf-pi/userconf ]; then
   /usr/lib/userconf-pi/userconf 'weather' '$5$vN7oLnEcxG$eMwSb00MGCHDj4T1I81kSPgh4wzdiZ7ZQJqJ8GoPJD4'
else
   echo "$FIRSTUSER:"'$5$vN7oLnEcxG$eMwSb00MGCHDj4T1I81kSPgh4wzdiZ7ZQJqJ8GoPJD4' | chpasswd -e
   if [ "$FIRSTUSER" != "weather" ]; then
      usermod -l "weather" "$FIRSTUSER"
      usermod -m -d "/home/weather" "weather"
      groupmod -n "weather" "$FIRSTUSER"
      if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
         sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=weather/"
      fi
      if [ -f /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
         sed /etc/systemd/system/getty@tty1.service.d/autologin.conf -i -e "s/$FIRSTUSER/weather/"
      fi
      if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
         sed -i "s/^$FIRSTUSER /weather /" /etc/sudoers.d/010_pi-nopasswd
      fi
   fi
fi
rm -f /boot/firstrun.sh
sed -i 's| systemd.run.*||g' /boot/cmdline.txt
exit 0
