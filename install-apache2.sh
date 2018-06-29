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


r="\e[1;32m"
c="\e[1;36m"
e="\e[0m"
clear
echo -e $r"This amazing script was made by:$e"
echo -e $r' __   __   __  __    __   _______   ______   ______ ____    ______   _______  '$e
echo -e $r'|  \ |  \ |  \|  \  |  \ /       \ /      \ |      \    \  |      \ |       \ '$e
echo -e $r'| $$ | $$ | $$| $$  | $$|  $$$$$$$|  $$$$$$\| $$$$$$\$$$$\  \$$$$$$\| $$$$$$$\'$e
echo -e $r'| $$ | $$ | $$| $$  | $$ \$$    \ | $$    $$| $$ | $$ | $$ /      $$| $$  | $$'$e
echo -e $r'| $$_/ $$_/ $$| $$__/ $$ _\$$$$$$\| $$$$$$$$| $$ | $$ | $$|  $$$$$$$| $$  | $$'$e
echo -e $r' \$$   $$   $$ \$$    $$|       $$ \$$     \| $$ | $$ | $$ \$$    $$| $$  | $$'$e
echo -e $r'  \$$$$$\$$$$   \$$$$$$  \$$$$$$$   \$$$$$$$ \$$  \$$  \$$  \$$$$$$$ \$$   \$$'$e
echo -e $r''$e
echo -e $c'                                                                        enjoy!'$e
echo -e "\n================================================================================"
echo -e $r"Please wait...Updating repository.."$e
echo -e "================================================================================"
apt-get update 

echo -e "\n================================================================================"
echo -e $c"Please wait...Checking for new package upgrades.."$e
echo -e "================================================================================"
apt-get upgrade -y

echo -e "\n================================================================================"
echo -e $c"Installing apache2 mysql-server php libapache2-mod-php"$e
echo -e $c"php-mcrypt php-mysql for you......"$e
echo -e "================================================================================"
apt-get install apache2 mysql-server php libapache2-mod-php php-mcrypt php-mysql -y

echo -e "\n================================================================================"
echo -e $c"Enabling ssl module..."$e
echo -e "================================================================================"
a2enmod ssl

echo -e "\n================================================================================"
echo -e $c"Adding some settings for your security..."$e
echo -e $c"Adding new user and group for your apache2 setup"$e
echo -e "================================================================================"
echo -e "....Done"
groupadd http-wuseman
useradd -d /var/www/ -g http-wuseman -s /bin/nologin http-wuseman

sed -i s/'${APACHE_RUN_USER}'/'http-wuseman'/g /etc/apache2/apache2.conf
sed -i s/'${APACHE_RUN_GROUP}'/'http-wuseman'/g /etc/apache2/apache2.conf
echo -e "ServerSignature Off\nServerTokens Prod" >> /etc/apache2/apache2.conf
chown -R http-wuseman:http-wuseman /var/www
echo -e "\n================================================================================"
echo -e $c"Installing modsecurity..."$e
echo -e "================================================================================"
apt-get install libapache2-modsecurity
a2enmod mod-security

echo -e "\n================================================================================"
echo -e $c"Please wait...Restarting apache2.."$e
echo -e "================================================================================"
service apache2 restart
   mkdir /etc/apache2/ssl
a2ensite default-ssl.conf
service apache2 restart

echo -e "\n================================================================================"
echo -e $c"Please answer the questions to secure your mysql setup..."$e
echo -e "================================================================================"
mysql_secure_installation
  echo -e "<IfModule mod_dir.c>\nDirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm\n</IfModule>" >  /etc/apache2/mods-enabled/dir.conf
sudo systemctl restart apache2
  echo -e "<?php\nphpinfo();\n?>" > /var/www/html/index.php

echo -e "\n================================================================================"
echo -e $c"Setting up letsencrypt for you.."$e
echo -e "================================================================================"
add-apt-repository ppa:certbot/certbot

echo -e "\n================================================================================"
echo -e $c"Please wait...Updating repository for letsencrypt."$e
echo -e "================================================================================"
apt-get update
apt-get install python-certbot-apache -y

echo -e "\n================================================================================"
echo -e $c"Please enter wich hostname to setup certificates for (max 1 host)"$e
echo -e "================================================================================"
read -p "Hostname: " hostname 
certbot --apache -d $hostname
