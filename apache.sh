#!/bin/bash
#
# Author : Onf
# Version: 1.0
#
## Create VHosts folders
sudo mkdir -pv /srv/http/ap1
sudo mkdir -pv /srv/http/ap2

## Extract mods and configuration files to the conf folder
sudo cp /etc/http/conf/httpd.conf /etc/http/conf/httpd.default.conf
tar -xvf apache.tar.gz -C /etc/httpd/conf
