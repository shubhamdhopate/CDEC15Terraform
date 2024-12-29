#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y
systemctl enable nginx
systemctl restart nginx 
systemctl status nginx 
mkdir /var/www/html/grocery/
echo "<h1> Hello All Welcome to Grocery Application </h1>" > /var/www/html/grocery/index.html