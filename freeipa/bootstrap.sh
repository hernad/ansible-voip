#!/bin/bash

ifconfig enp0s8 192.168.33.50

yum install -y curl

curl -o /etc/yum.repos.d/mkosek-freeipa-epel-7.repo https://copr.fedoraproject.org/coprs/mkosek/freeipa/repo/epel-7/mkosek-freeipa-epel-7.repo

yum -y install freeipa-server bind bind-dyndb-ldap perl

#ipa-server-install --setup-dns --no-forwarders

#Client :

#curl -o /etc/yum.repos.d/mkosek-freeipa-epel-7.repo https://copr.fedoraproject.org/coprs/mkosek/freeipa/repo/epel-7/mkosek-freeipa-epel-7.repo

#yum install freeipa-client

#ipa-client-install --enable-dns-updates --mkhomedir

PASSWORD=Password123
REALM=LOCALDOMAIN
IPA_SERVER=ipa.localdomain
IPA_IP=192.168.33.50
ipa-server-install --unattended -a $PASSWORD --hostname=$IPA_SERVER -r $REALM -P password -p $PASSWORD  --setup-dns --ip-address=$IPA_IP --forwarder=8.8.8.8
