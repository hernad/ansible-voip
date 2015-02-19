#!/bin/bash

service NetworkManager stop
chkconfig NetworkManager off
service network start
sudo chkconfig network on

yum install -y epel-release
yum install -y curl

curl -o /etc/yum.repos.d/mkosek-freeipa-epel-7.repo https://copr.fedoraproject.org/coprs/mkosek/freeipa/repo/epel-7/mkosek-freeipa-epel-7.repo

yum -y install freeipa-server bind bind-dyndb-ldap perl

#ipa-server-install --setup-dns --no-forwarders

#Client :

#curl -o /etc/yum.repos.d/mkosek-freeipa-epel-7.repo https://copr.fedoraproject.org/coprs/mkosek/freeipa/repo/epel-7/mkosek-freeipa-epel-7.repo

#yum install freeipa-client

#ipa-client-install --enable-dns-updates --mkhomedir

#https://www.digitalocean.com/community/tutorials/how-to-setup-additional-entropy-for-cloud-servers-using-haveged
yum install -y haveged
systemctl start haveged.service

PASSWORD=Password123
REALM=BRING.OUT.TEST
IPA_SERVER=ipa.bring.out.test
IPA_IP=192.168.33.50
IPA_SERVER_R=ipa-2.bring.out.test
IPA_IP_R=192.168.33.60

SSH_OPTS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

if [ "$1" == "server" ] ; then
  ifconfig enp0s8 192.168.33.50
  ipa-server-install --unattended -a $PASSWORD --hostname=$IPA_SERVER -r $REALM -P password -p $PASSWORD  --setup-dns --ip-address=$IPA_IP --forwarder=8.8.8.8
  echo $PASSWORD | ipa-replica-prepare $IPA_SERVER_R --ip-address $IPA_IP_R
  #cat /dev/zero | ssh-keygen -q -N ""
  #cp /home/vagrant/.ssh/id_rsa* /vagrant
  #cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  cp /var/lib/ipa/replica-info-${IPA_SERVER_R}.gpg /vagrant/
fi

if [ "$1" == "replica" ] ; then
  ifconfig enp0s8 192.168.33.60
  cp /vagrant/id_rsa* /home/vagrant/.ssh/
  chown root /tmp/id_rsa
  chmod 0600 /tmp/id_rsa
  #scp $SSH_OPTS vagrant@192.168.33.50:/var/lib/ipa/replica-info-${IPA_SERVER_R}.gpg /tmp/
  echo $PASSWORD | ipa-replica-install /vagrant/replica-info-${IPA_SERVER_R}.gpg 
fi

