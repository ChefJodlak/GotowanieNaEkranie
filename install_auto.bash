#!/bin/bash

# Squid Installer
# Author: ChefJodla
# Email: jodlaksde@gmail.com
# Github: https://github.com/ChefJodlak/GotowanieNaEkranie


read -e -p "How many Servers do you want to create?: " n


sudo yum -y update
sudo yum install -y squid 
sudo yum install httpd-tools -y
wget -O /etc/squid/squid.conf https://raw.githubusercontent.com/ChefJodlak/GotowanieNaEkranie/master/config.conf --no-check-certificate
sudo squid -z
sudo chkconfig squid on
touch /etc/squid/squid_access; htpasswd /etc/squid/squid_access admin
sudo service squid start

for (( c=1; c<=120; c++ ))
do  
	if(c<=8); then
		yes | gcloud compute instances create proxyproxy$c --image-family=centos-6 --image-project=centos-cloud --tags=http-server,https-server --zone=europe-west4-a --metadata startup-script='#! /bin/bash

		sudo su
		yum -y update
		yum install -y squid 
		yum install httpd-tools -y
		wget -O /etc/squid/squid.conf https://raw.githubusercontent.com/ChefJodlak/GotowanieNaEkranie/master/config.conf --no-check-certificate
		squid -z
		chkconfig squid on
		service squid start
		touch /etc/squid/squid_access; htpasswd -b /etc/squid/squid_access admin admin
		'
	elif (c<=16) then
				yes | gcloud compute instances create proxyproxy$c --image-family=centos-6 --image-project=centos-cloud --tags=http-server,https-server --zone=europe-west4-b --metadata startup-script='#! /bin/bash

		sudo su
		yum -y update
		yum install -y squid 
		yum install httpd-tools -y
		wget -O /etc/squid/squid.conf https://raw.githubusercontent.com/ChefJodlak/GotowanieNaEkranie/master/config.conf --no-check-certificate
		squid -z
		chkconfig squid on
		service squid start
		touch /etc/squid/squid_access; htpasswd -b /etc/squid/squid_access admin admin
		'
	fi
done


