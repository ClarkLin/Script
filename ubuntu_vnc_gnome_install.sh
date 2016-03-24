#!/bin/bash
#Created by Clark Lin 2016.3.24

function GetVncPasswd(){
        echo ""
        echo "---------Please Note--------------"
        echo "This script is used to install Gnome Desktop and VNC service on Ubuntu 14.04"
        echo "----------------------------------"
        read -p "Please enter the VNC password you want (default: vncuser): " VNC_PW
}

function ChangeUbuntuSources(){
	sudo echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list
	sudo echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
	sudo apt-get update
	sudo echo "103.245.222.133 raw.githubusercontent.com" >> /etc/hosts
}

function InstallGnome(){
	sudo apt-get -y install xorg gdm ubuntu-desktop gnome-core
}

function InstallVnc(){
	sudo apt-get -y install vnc4server language-pack-zh-hant-base language-pack-zh-hans-base screenlets
}

function ConfitVnc(){
	useradd vncuser
	mkdir /home/vncuser/
	mkdir /home/vncuser/.vnc
	chown -Rf vncuser /home/vncuser/
	su - vncuser -c "(echo $VNC_PW && echo $VNC_PW) | vncpasswd"
	su - vncuser -c "cd ~/.vnc/ && wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/.vnc/xstartup"
}

function StartVnc(){
	echo 'su - vncuser -c "vncserver :74"' >> /etc/rc.local
	su - vncuser -c "vncserver -kill :74"
	rm /tmp/.X*
	su - vncuser -c "vncserver :74"
}

function Main(){
	VNC_PW=vncuser
	GetVncPasswd
	ChangeUbuntuSources
	InstallGnome
	InstallVnc
	ConfitVnc
	StartVnc
}

Main
