#!/bin/bash
#Created by Clark Lin 2016.3.24

function GetVncPasswd(){
        echo ""
        echo "---------Please Note--------------"
        echo "This script is used to install Gnome Desktop and VNC service on Ubuntu 14.04"
        echo "----------------------------------"
        read -p "Please enter the VNC password you want (default: vncuser): " VNC_PW
        read -p "Please enter the VNC port you want (default: 74): " VNC_PORT
}

function ChangeUbuntuSources(){
	sudo echo "deb http://cn.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list
	sudo echo "deb http://cn.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb http://cn.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list
	sudo echo "deb http://cn.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
	sudo apt-get update
	sudo echo "103.245.222.133 raw.githubusercontent.com" >> /etc/hosts
}

function InstallGnome(){
	sudo apt-get -y install xorg gdm ubuntu-desktop gnome-core
}

function InstallVnc(){
	sudo apt-get -y install vnc4server language-pack-zh-hant-base language-pack-zh-hans-base screenlets ttf-wqy-zenhei
}
 
function InstallBorwer(){
	sudo apt-get install firefox
	if [[ ! -a "maxthon-browser-stable_1.0.5.3_amd64.deb" ]]; then
		sudo wget bm.jacashop.com/download/maxthon-browser-stable_1.0.5.3_amd64.deb
	fi
	sudo dpkg -i maxthon-browser-stable_1.0.5.3_amd64.deb
	if [[ ! -a "google-chrome-stable_current_amd64.deb" ]]; then
		sudo wget wget bm.jacashop.com/download/google-chrome-stable_current_amd64.deb
	fi
	sudo dpkg -i google-chrome-stable_current_amd64.deb
 	sudo apt-get install -f -y
 }

function ConfitVnc(){
	useradd vncuser
	mkdir /home/vncuser/
	chown -Rf vncuser.vncuser /home/vncuser/
	su - vncuser -c "(echo $VNC_PW && echo $VNC_PW) | vncserver :$VNC_PORT"
	su - vncuser -c "vncserver -kill :$VNC_PORT"
	su - vncuser -c "rm ~/.vnc/xstartup"
	su - vncuser -c "cd ~/.vnc/ && wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/.vnc/xstartup"
	su - vncuser -c "chmod a+x ~/.vnc/xstartup"
	mkdir /home/vncuser/Desktop/
	cd /home/vncuser/Desktop/
	if [[ ! -a "/home/vncuser/Desktop/firefox.desktop" ]]; then
		wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/Desktop/firefox.desktop
	fi
	if [[ ! -a "/home/vncuser/Desktop/google-chrome.desktop" ]]; then
		wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/Desktop/google-chrome.desktop
	fi
	if [[ ! -a "/home/vncuser/Desktop/libreoffice-calc.desktop" ]]; then
		wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/Desktop/libreoffice-calc.desktop
	fi
	if [[ ! -a "/home/vncuser/Desktop/libreoffice-writer.desktop" ]]; then
		wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/Desktop/libreoffice-writer.desktop
	fi
	if [[ ! -a "/home/vncuser/Desktop/maxthon.desktop" ]]; then
		wget https://raw.githubusercontent.com/ClarkLin/docker-ubuntu-gnome-vnc/master/Desktop/maxthon.desktop
	fi
	chown -Rf vncuser.vncuser /home/vncuser/
	chmod a+x /home/vncuser/Desktop/*.desktop
}

function StartVnc(){
	echo "su - vncuser -c \"vncserver :$VNC_PORT\"" > /etc/rc.local
	echo 'exit 0' >> /etc/rc.local
	su - vncuser -c "vncserver -kill :$VNC_PORT"
	rm -rf /tmp/.X*
	su - vncuser -c "vncserver :$VNC_PORT"
}

function Main(){
	VNC_PW=vncuser
	VNC_PORT=74
	GetVncPasswd
	ChangeUbuntuSources
	InstallGnome
	InstallVnc
	InstallBorwer
	ConfitVnc
	StartVnc
}

Main
