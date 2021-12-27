#!/bin/bash
sudo yum update -y
sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
mkdir -p /var/www/html
cd /var/www/html
echo "<html><h1>Hello World”</h1></html>" > index.html