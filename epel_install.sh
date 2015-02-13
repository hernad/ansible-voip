#!/bin/bash

wget -q -O epel-release-7.rpm http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo rpm -Uvh epel-release-7.rpm
sudo yum -y install ansible
sudo yum -y install dkms
