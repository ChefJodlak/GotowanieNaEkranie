#!/bin/bash
# Squid Installer
# Author: ChefJodla
# Email: jodlaksde@gmail.com
# Github: https://github.com/ChefJodlak/GotowanieNaEkranie

read -e -p "Jak chcesz zeby sie serwery nazywaly(tylko male litery, cyfry, bez spacji)?: " name
read -e -p "Ile serwerow chcesz postawic? " max


for (( c=1; c<= max; c++ ))
do  
	if [ $c -le $((max /9)) ]
	then
		zone=europe-west1-b
	elif [ $c -le $(((max /9)*2)) ]
	then
		zone=europe-west1-c
	elif [ $c -le $(((max /9)*3)) ]
	then
		zone=europe-west1-d
	elif [ $c -le $(((max /9)*4)) ]
	then
		zone=europe-west4-a
	elif [ $c -le $(((max /9)*5)) ]
	then
		zone=europe-west4-b
	elif [ $c -le $(((max /9)*6)) ]
	then
		zone=europe-west4-c
	elif [ $c -le $(((max /9)*7)) ]
	then
		zone=europe-north1-a
	elif [ $c -le $(((max /9)*8)) ]
	then
		zone=europe-north1-b
	elif [ $c -le $(((max /9)*9)) ]
	then
		zone=europe-north1-c
	fi
	yes | gcloud compute instances create $name$c --machine-type="f1-micro" --image-family="centos-6" --image-project=centos-cloud --tags=http-server,https-server --zone=$zone --metadata startup-script='#! /bin/bash

yum -y update
wget https://www.openssl.org/source/openssl-1.0.2q.tar.gz
tar -xvzf openssl-1.0.2q.tar.gz
cd openssl-1.0.2q
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make install
yum install -y squid 
yum install httpd-tools -y
wget -O /etc/squid/squid.conf https://raw.githubusercontent.com/ChefJodlak/GotowanieNaEkranie/master/config1.conf --no-check-certificate
squid -z
chkconfig squid on
cd /etc/squid
mkdir ssl_cert
chown squid:squid ssl_cert
chmod 700 ssl_cert
cd ssl_cert
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout myCA.pem  -out myCA.pem -subj "/C=PL/ST=Polska/L=Mazowieckie/O=Test/OU=Test/CN=google.com/emailAddress=test@test.com"
service squid restart
touch /etc/squid/squid_access; htpasswd -b /etc/squid/squid_access admin admin
'&
sleep 5
done


