#!/bin/sh
BACKEND_URL=admin
echo "---------Please Note--------------"
echo "The content of the List File should be:"
echo "website1.com"
echo "website2.com"
echo "website3.com"
echo "----------------------------------"
read -p "Enter List File Name: " LISTNAME
read -p "Enter new magento backend url (default:admin): " BACKEND_URL_CUSTOM
LIST=`cat $LISTNAME`
if [[ -n $BACKEND_URL_CUSTOM ]]; then
  BACKEND_URL=$BACKEND_URL_CUSTOM
fi
for WEBSITE_NAME in $LIST
do
  if [[ -f "/home/wwwroot/$WEBSITE_NAME/web/app/etc/local.xml" ]]; then
    sed -i "s/<frontName>.*$/<frontName><\![CDATA[$BACKEND_URL]]><\/frontName>/" /home/wwwroot/$WEBSITE_NAME/web/app/etc/local.xml
    rm -rf /home/wwwroot/$WEBSITE_NAME/web/var/cache/*
    echo "$WEBSITE_NAME Magento backend url has been update."
  else
    echo "$WEBSITE_NAME is not mangento."
  fi
done;
