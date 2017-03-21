#!/bin/bash
# This script changes the default server port, document root
# Just change the values below to your liking

port=8080
document_root=/var/www/html-hole

## Editing below this line at your own risk

echo " : : : Changing document root of lighttpd server to /var/www/html-hole"
sed 's:"/var/www/html":"'$document_root'":g' /etc/lighttpd/lighttpd.conf \
	| sudo tee /etc/lighttpd/lighttpd.conf

echo " : : : Changing server port to 8080"
sed 's:server.port *= [1-9][0-9]\+:server.port\t = '$port':g' /etc/lighttpd/lighttpd.conf \
	| sudo tee /etc/lighttpd/lighttpd.conf

echo " : : : Moving web interface to new document root "
mkdir -p "${document_root}/admin"
mv /var/www/html/admin/ "${document_root}/admin"

echo " : : : Pointing chronometer to new web interface address "

sed 's:127.0.0.1/admin/:127.0.0.1\:'$port'/admin/:g' /opt/pihole/chronometer.sh \
	| sudo tee /opt/pihole/chronometer.sh

echo " : : : Restarting lighttpd service for changes to take effect "
sudo systemctl restart lighttpd
