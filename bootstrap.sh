#!/bin/bash

epel_install() {

  wget -q -O epel-release-7.rpm http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
  sudo rpm -Uvh epel-release-7.rpm

}

yum_install() {

  sudo yum -y install $1
}


format_sdb() {

MOUNTED=`mount | grep -c sdb`
if [ "$MOUNTED" == "0" ]; then

 parted /dev/sdb mklabel msdos
 parted /dev/sdb mkpart primary 512 100%
 mkfs.xfs /dev/sdb1
 mkdir /mnt/disk
 echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /mnt/disk   xfs   noatime,nobarrier   0   0 >> /etc/fstab
 mount /mnt/disk

fi

}


docker_install() {

if [ ! -f /usr/local/bin/docker ]
then
   sudo wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O /usr/local/bin/docker
   sudo chmod +x /usr/local/bin/docker
else
   echo docker instaliran
fi

}

epel_install
yum_install bind-utils
# ne trebamo ansible na ciljnom hostu
# yum_install ansible

yum_install dkms
format_sdb


