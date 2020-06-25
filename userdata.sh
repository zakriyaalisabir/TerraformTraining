#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl stop firewalld
cd /var/www/html
echo "this is my test site" > index.html