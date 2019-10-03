#!/bin/bash

# Squid Installer
# Author: ChefJodla
# Email: jodlaksde@gmail.com
# Github: https://github.com/ChefJodlak/GotowanieNaEkranie

apt-get update && apt-get install squid apache2-utils httpd-tools -y
wget https://www.openssl.org/source/openssl-1.0.2q.tar.gz
tar -xvzf openssl-1.0.2q.tar.gz
cd openssl-1.0.2q
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make install
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
touch /etc/squid/squid_access; htpasswd -b /etc/squid/squid_access jodla jodla123