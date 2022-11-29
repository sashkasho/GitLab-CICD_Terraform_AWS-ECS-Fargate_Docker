#!/bin/bash
sudo su -
apt update
apt install apache2 -y
ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body>Web-server on Apache with Private IP $ip</body></html>" > /var/www/html/index.html
ufw enable
ufw allow 'Apache'
systemctl restart apache2