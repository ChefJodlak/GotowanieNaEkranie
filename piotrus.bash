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
done


