#!/bin/sh
# Created by Clark 2014.01.26
# Contact Emaill: linchengkuang@foxmail.com
# Name: pythoninstall.sh
# This script is used to install Python 2.7 on Centos 6.3
# Version 1.1
# Refer to https://github.com/0xdata/h2o/wiki/Installing-python-2.7-on-centos-6.3.-Follow-this-sequence-exactly-for-centos-machine-only

# Install development tools
yum groupinstall -y "Development tools"
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel

# Create temp directory for installtion
cd ~ 
mkdir pyinstall
cd pyinstall

# Download, compile and install Python
wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2 --no-check-certificate
tar -xjf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure --prefix=/usr/local
make && make altinstall

# Create a symbolic link
#ln -s /usr/local/bin/python2.7 /usr/local/bin/python

# Install and configuring distribute
cd ~/pyinstall
wget http://pypi.python.org/packages/source/d/distribute/distribute-0.6.27.tar.gz --no-check-certificate
tar -xzf distribute-0.6.27.tar.gz
cd distribute-0.6.27
python2.7 setup.py install

# Delete temp directory
cd ~
rm pyinstall -rf