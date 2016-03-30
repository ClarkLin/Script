#!/bin/sh
cd ~
wget http://git.oschina.net/renhao/renhao/raw/master/amh-4.2/php-5.6.4.tar.gz
tar zxvf php-5.6.4.tar.gz
cd php-5.6.4

./configure --prefix=/usr/local/php --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --with-openssl --with-zlib  --with-curl --enable-ftp --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --enable-gd-native-ttf --enable-mbstring --enable-zip --with-iconv=/usr/local/libiconv --without-pear --disable-fileinfo --enable-opcache --with-mcrypt --with-pdo-mysql=mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --enable-soap
make ZEND_EXTRA_LIBS='-liconv'
make install
