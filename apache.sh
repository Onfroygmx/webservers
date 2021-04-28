#!/bin/bash
#
# Author : Onf
# Version: 1.0
#

sudo pacman -Syu apache php-apache php-fpm php-cgi mod_fcgid

while getopts d:a:f: flag
do
    case "${flag}" in
        d) domainname=${OPTARG};;
        a) age=${OPTARG};;
        f) fullname=${OPTARG};;
    esac
done

## Create VHosts folders
sudo mkdir -pv /srv/http/ap1
sudo mkdir -pv /srv/http/ap2

## Extract mods and configuration files to the conf folder
sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.default.conf
sudo tar -xvf conf/apache-2.4.46.tar.gz -C /etc/httpd/conf

## Copy test pages to doc roots
sudo cp index.* /srv/http/ap1/
sudo cp index.* /srv/http/ap2/

## Change html page to display vhost name
sudo sed -i 's/Apache!/Apache!AP1/g' /srv/http/ap1/index.html
sudo sed -i 's/Apache!/Apache!AP2/g' /srv/http/ap2/index.html

##  Replace domain name in all config files to separate dev/test/prod
sudo sed -i "s/devserver/"$domainname"/g" /etc/hosts
sudo sed -i "s/devserver/"$domainname"/g" /etc/httpd/conf/httpd.conf
sudo sed -i "s/devserver/"$domainname"/g" /etc/httpd/conf/vhosts/ap1.conf
sudo sed -i "s/devserver/"$domainname"/g" /etc/httpd/conf/vhosts/ap2.conf

## Start and Enable services
systemctl start php-fpm
systemctl start httpd
systemctl enable php-fpm
systemctl enable httpd

echo "All Configured: http://arch.$domainname.net:8080"
