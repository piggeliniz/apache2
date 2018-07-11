#!/bin/bash
##################################################################################
##### LICENSE ####################################################################
##################################################################################
####                                                                          ####
#### Copyright (C) 2018 wuseman <info@sendit.nu>                              ####
####                                                                          ####
#### This program is free software: you can redistribute it and/or modify     ####
#### it under the terms of the GNU General Public License as published by     ####
#### the Free Software Foundation, either version 3 of the License, or        ####
#### (at your option) any later version.                                      ####
####                                                                          ####
#### This program is distributed in the hope that it will be useful,          ####
#### but WITHOUT ANY WARRANTY; without even the implied warranty of           ####
#### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            ####
#### GNU General Public License at <http://www.gnu.org/licenses/> for         ####
#### more details.                                                            ####
####                                                                          ####
##################################################################################
##### GREETINGS ##################################################################
##################################################################################
####                                                                          ####
#### To all developers that contributes to all kind of open source projects   ####
#### Keep up the good work!                                                   #<3#
####                                                                          ####
#### https://sendit.nu & https://github.com/wuseman                           ####
####                                                                          ####
##################################################################################
#### DESCRIPTION #################################################################
##################################################################################
####                                                                          ####
#### This script will install apache2 with ssl support, mysql & php on ubuntu ####
####                                                                          ####
#### Enjoy another awesome 'bash' script from wuseman. Questions? Conact me!  ####
####                                                                          ####
##################################################################################
#### Begin of code  ##############################################################
##################################################################################



clear
echo "This amazing script was made by:$e"
echo ' __   __   __  __    __   _______   ______   ______ ____    ______   _______  '
echo '|  \ |  \ |  \|  \  |  \ /       \ /      \ |      \    \  |      \ |       \ '
echo '| $$ | $$ | $$| $$  | $$|  $$$$$$$|  $$$$$$\| $$$$$$\$$$$\  \$$$$$$\| $$$$$$$\'
echo '| $$ | $$ | $$| $$  | $$ \$$    \ | $$    $$| $$ | $$ | $$ /      $$| $$  | $$'
echo '| $$_/ $$_/ $$| $$__/ $$ _\$$$$$$\| $$$$$$$$| $$ | $$ | $$|  $$$$$$$| $$  | $$'
echo ' \$$   $$   $$ \$$    $$|       $$ \$$     \| $$ | $$ | $$ \$$    $$| $$  | $$'
echo '  \$$$$$\$$$$   \$$$$$$  \$$$$$$$   \$$$$$$$ \$$  \$$  \$$  \$$$$$$$ \$$   \$$'
echo ''$e
echo '                                                                        enjoy!'
echo "================================================================================"
echo "Please wait...Updating repository.."$e
echo "================================================================================"
apt-get update 

echo "================================================================================"
echo "Please wait...Checking for new package upgrades.."$e
echo "================================================================================"
apt-get upgrade -y

echo "================================================================================"
echo "Installing apache2 mysql-server php libapache2-mod-php"$e
echo "php-mcrypt php-mysql for you......"$e
echo "================================================================================"
apt-get install apache2 mysql-server php libapache2-mod-php php-mcrypt php-mysql -y

echo "================================================================================"
echo "Enabling ssl module..."$e
echo "================================================================================"
a2enmod ssl

echo "================================================================================"
echo "Adding some settings for your security..."$e
echo "Adding new user and group for your apache2 setup"$e
echo "================================================================================"
echo "....Done"
groupadd http-wuseman
useradd -d /var/www/ -g http-wuseman -s /bin/nologin http-wuseman

sed -i s/'${APACHE_RUN_USER}'/'http-wuseman'/g /etc/apache2/apache2.conf
sed -i s/'${APACHE_RUN_GROUP}'/'http-wuseman'/g /etc/apache2/apache2.conf
echo -e "ServerSignature Off\nServerTokens Prod" >> /etc/apache2/apache2.conf
chown -R http-wuseman:http-wuseman /var/www
echo "================================================================================"
echo "Installing modsecurity..."$e
echo "================================================================================"
apt-get install libapache2-modsecurity
a2enmod mod-security

echo "================================================================================"
echo "Please wait...Restarting apache2.."$e
echo "================================================================================"
service apache2 restart
   mkdir /etc/apache2/ssl
a2ensite default-ssl.conf
service apache2 restart

echo "================================================================================"
echo "Please answer the questions to secure your mysql setup..."$e
echo "================================================================================"
mysql_secure_installation
  echo -e "<IfModule mod_dir.c>\nDirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm\n</IfModule>" >  /etc/apache2/mods-enabled/dir.conf
sudo systemctl restart apache2
  echo -e "<?php\nphpinfo();\n?>" > /var/www/html/index.php

echo "================================================================================"
echo "Setting up letsencrypt for you.."$e
echo "================================================================================"
add-apt-repository ppa:certbot/certbot

echo "================================================================================"
echo "Please wait...Updating repository for letsencrypt."$e
echo "================================================================================"
apt-get update
apt-get install python-certbot-apache -y

echo "================================================================================"
echo "Please enter wich hostname to setup certificates for (max 1 host)"$e
echo "================================================================================"
read -p "Hostname: " hostname 
certbot --apache -d $hostname
