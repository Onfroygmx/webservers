#!/bin/bash
#
# Author : Onf
# Version: 1.0
#

while getopts d:a:f: flag
do
    case "${flag}" in
        d) domainname=${OPTARG};;
        a) age=${OPTARG};;
        f) fullname=${OPTARG};;
    esac
done$

## Create VHosts folders
sudo mkdir -pv /srv/http/ap1
sudo mkdir -pv /srv/http/ap2

## Extract mods and configuration files to the conf folder
sudo cp /etc/http/conf/httpd.conf /etc/http/conf/httpd.default.conf
sudo tar -xvf conf/apache-2.4.46.tar.gz -C /etc/httpd/conf

#TO DO
sed -i 's/devserver/"$domainname"/g' /etc/hosts
sed -i 's/devserver/dev/g' /etc/httpd/conf/vhosts/ap1.conf
sed -i 's/devserver/dev/g' /etc/httpd/conf/vhosts/ap2.conf
