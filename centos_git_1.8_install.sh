#!/bin/sh
# Created by Clark 2014.06.23
# Contact Email: linchengkuang@foxmail.com
# Name: git1.8.5.5_install_centos.sh
# This script is used to instal git 1.8.5.5 on CentOS
# Version 1.0

cd ~
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-devel gcc
cd ~/download/
wget http://distfiles.macports.org/git-core/git-1.8.5.5.tar.gz

cd /usr/local/src
tar -zvxf ~/download/git-1.8.5.5.tar.gz
cd git-1.8.5.5
make prefix=/usr/local/git all
make prefix=/usr/local/git install

ln -s /usr/local/git/bin/* /usr/bin/
git version
