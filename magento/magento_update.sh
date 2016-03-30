#!/bin/sh
# Created by Clark 2014.07.16
# Contact Emaill: linchengkuang@foxmail.com
# Name: magento_update.sh
# This script is used to update mangeto version ( centos system and nginx service.)
# Version 4.0

function GetListFileName() {
    echo ""
    echo "---------Please Note--------------"
    echo "The content of the List File should be:"
    echo "Website1"
    echo "Website2"
    echo "Website3"
    echo "----------------------------------"
    read -p "Enter List File Name: " LIST_NAME
    LIST=`cat $LIST_NAME`
}

# Define Funciton CopyUpdateFiles
function CopyUpdateFiles() {
    UPDATE_FOLDER=${UPDATE_LOCATION}/magento-${VERSION}/magento/
    echo "magento-${VERSION}"
    sudo cp -rf ${UPDATE_FOLDER}/* ${UPDATE_FOLDER}/.htaccess ${WEB_FOLDER}
    chmod -R o+w ${WEB_FOLDER}/media ${WEB_FOLDER}/var
    chmod o+w  ${WEB_FOLDER}/app/etc
    chown -Rf www.www ${WEB_FOLDER}
}

# Define Function WaitForUpdateResult
function WaitForUpdateResult() {
    local n=0
    UPDATE_RESULT=1
    until [[ ${UPDATE_RESULT} == 0 ]]
    do
        UPDATE_RESULT=`cd ${WEB_FOLDER} && php index.php | grep report | wc -l`
        echo "UPDATE_RESULT = $UPDATE_RESULT"
        wait
        if [[ $n > 10 ]]; then
            echo "Magento Update Fail"
            exit 1
        else
            n=`expr $n + 1`
        fi
    done
}

function MysqlFix() {
    DB_NAME=`cat ${WEB_FOLDER}/app/etc/local.xml | grep dbname | cut -d [ -f 3 | cut -d ] -f 1`
    php /home/wwwroot/index/web/Cli/repdb.php --dbname=${DB_NAME}
}



function Main() {
    clear
    UPDATE_LOCATION="/root/magento-upgrade"
    WEB_LOCATION="/home/wwwroot"

    echo "1. From magento 1.4.2.0 update to 1.9.2.0"
    echo "2. From magento 1.7.0.2 update to 1.9.2.0"
    echo "3. From magento 1.9.0.1 update to 1.9.2.0"
    echo "4. From magento 1.6.0.0 update to 1.9.2.0"
    echo "Please Select:"
    read num

    case "$num" in
    [1] ) VERSION_LIST="1.5.0.1 1.6.0.0 1.6.1.0 1.6.2.0 1.7.0.0 1.7.0.1 1.7.0.2 1.8.0.0 1.8.1.0 1.9.0.0 1.9.0.1 1.9.1.0 1.9.1.1 1.9.2.0";;
    [2] ) VERSION_LIST="1.8.0.0 1.8.1.0 1.9.0.0 1.9.0.1 1.9.1.0 1.9.1.1 1.9.2.0";;
    [3] ) VERSION_LIST="1.9.1.0 1.9.1.1 1.9.2.0";;
    [4] ) VERSION_LIST="1.6.1.0 1.6.2.0 1.7.0.0 1.7.0.1 1.7.0.2 1.8.0.0 1.8.1.0 1.9.0.0 1.9.0.1 1.9.1.0 1.9.1.1 1.9.2.0";;
    *) echo "nothing,exit";;
    esac    

    GetListFileName
    for WEBSITE_NAME in $LIST
    do
        WEB_FOLDER=${WEB_LOCATION}/${WEBSITE_NAME}/web
        MysqlFix
        # Process Update Process
        for VERSION in $VERSION_LIST
        do
            CopyUpdateFiles
            WaitForUpdateResult     
        done
        rm ${WEB_FOLDER}/var/cache/* -rf
        rm ${WEB_FOLDER}/api -rf
        rm ${WEB_FOLDER}/app/code/core/Mage/GoogleCheckout -rf
        cp /root/removeimg.php ${WEB_FOLDER}/
        cd ${WEB_FOLDER}/ && php removeimg.php
        cd ${WEB_FOLDER}/shell/ && php indexer.php reindexall
    done;
}

Main
