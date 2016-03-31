#!/bin/sh
# Created by Clark 2014.07.16
# Contact Emaill: linchengkuang@foxmail.com
# Name: nginx_geo_install.sh
# This script is used to install geo module on nginx
# Version 2.0
function GitInstall () {
	yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-devel
	cd ~
	wget https://git-core.googlecode.com/files/git-1.8.5.5.tar.gz
	tar -zvxf ~/git-1.8.5.5.tar.gz
	cd git-1.8.5.5
	make prefix=/usr/local/git all
	make prefix=/usr/local/git install
	ln -s /usr/local/git/bin/* /usr/bin/
	cd -
}

# Install AMH AMProxy (AMProyx is not necessary for GEO, but for this script running correctly.)
amh module download AMProxy-2.0
amh module AMProxy-2.0 install

# Install GEO nginx module
cd ~
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
sed -i 's#\#base#base#g' /etc/yum.repos.d/epel.repo 
sed -i 's#mirror#\#mirror#g' /etc/yum.repos.d/epel.repo
yum install -y GeoIP GeoIP-devel perl-Geo-IP
rm -f epel-release-6-8.noarch.rpm

# Install GEO IP data
/usr/local/nginx/sbin/nginx -V
mkdir temp
cd temp
#wget http://code.amysql.com/files/nginx-1.4.4.tar.gz
#tar -xzvf nginx-1.4.4.tar.gz
#cd nginx-1.4.4

wget http://nginx.org/download/nginx-1.8.0.tar.gz
tar -xzvf nginx-1.8.0.tar.gz
cd nginx-1.8.0

NGINX_CONFIGURE=$(/usr/local/nginx/sbin/nginx -V 2> /tmp/nginx_configure && cat /tmp/nginx_configure | grep 'configure arguments' | cut -d: -f2 && rm -f /tmp/nginx_configure)
./configure ${NGINX_CONFIGURE} --with-http_geoip_module --with-http_realip_module
make
cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx_bak
amh nginx stop
wait
cp -f objs/nginx /usr/local/nginx/sbin/nginx
amh nginx start
/usr/local/nginx/sbin/nginx -s reload
/usr/local/nginx/sbin/nginx -V

# Download Geo Country and City
cd /root/temp
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
mkdir /var/GeoIP
mv GeoIP.dat.gz /var/GeoIP/
mv GeoLiteCity.dat.gz /var/GeoIP/
gunzip -f /var/GeoIP/GeoIP.dat.gz
gunzip -f /var/GeoIP/GeoLiteCity.dat.gz

# Configure GEO 
sed '/include\ vhost/i \\tinclude\ conf\.d\/\*\.conf\;' -i /usr/local/nginx/conf/nginx.conf

#sed '/default\_type/i \\tinclude\ conf\.d\/location\/eu.conf\;' -i nginx.conf  

# Restart AMH
service amh-start restart
