#!/bin/bash
#
# Author : Onf
# Version: 1.0
#

sudo pacman -Syu nginx php-fpm

while getopts d:a:f: flag
do
    case "${flag}" in
        d) domainname=${OPTARG};;
        a) age=${OPTARG};;
        f) fullname=${OPTARG};;
    esac
done

## Create VHosts folders
sudo mkdir -pv /usr/share/nginx/ng1
sudo mkdir -pv /usr/share/nginx/ng2

## Extract mods and configuration files to the conf folder
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.default.conf
sudo tar -xvf conf/nginx-1.20.tar.gz -C /etc/nginx/

## Copy test pages to doc roots
sudo cp index.* /usr/share/nginx/ng1
sudo cp index.* /usr/share/nginx/ng2

## Change html page to display vhost name
sudo sed -i 's/Apache!/NGINX!NG1/g' /usr/share/nginx/ng1/index.html
sudo sed -i 's/Apache!/NGINX!NG2/g' /usr/share/nginx/ng1/index.html

##  Replace domain name in all config files to separate dev/test/prod
sudo sed -i "s/devserver/"$domainname"/g" /etc/hosts
sudo sed -i "s/devserver/"$domainname"/g" /etc/nginx/sites-available/ng1.conf
sudo sed -i "s/devserver/"$domainname"/g" /etc/nginx/sites-available/ng2.conf
sudo sed -i "s/devserver/"$domainname"/g" /etc/nginx/sites-available/apache.conf

## replace ip adress to forward to apache server ap1
ip_proxypass=`sudo ip -4 addr show enp0s8 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
sudo sed -i "s/127.0.0.1/$ip_proxypass/g" /etc/nginx/sites-available/apache.conf

## Start and Enable services
systemctl start php-fpm
systemctl start nginx
systemctl enable php-fpm
systemctl enable nginx

echo "\033[0;36m To enable prowyin to apache webserver: Symlink apache.conf to sites enabled and restart"
echo "\033[0;36m All Configured: http://arch.$domainname.net"
