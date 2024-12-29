#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y
systemctl enable nginx
systemctl restart nginx 
systemctl status nginx 
mkdir /var/www/html/mobile/
echo "<h1> Hello All Welcome to Mobile Application </h1>" > /var/www/html/mobile/index.html