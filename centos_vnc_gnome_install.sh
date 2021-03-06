#!/bin/bash
#Created by Clark Lin 2016.3.28

function GetVncPasswd(){
        echo ""
        echo "---------Please Note--------------"
        echo "This script is used to install Gnome Desktop and VNC service on Ubuntu 14.04"
        echo "----------------------------------"
        read -p "Please enter the VNC password you want (default: vncuser): " VNC_PW
        read -p "Please enter the VNC port you want (default: 74): " VNC_PORT
}


function InstallGnome(){
	yum check-update
	yum groupinstall -y "X Window System"
	yum install -y gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
	unlink /etc/systemd/system/default.target
	ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target
	yum install -y libreoffice-writer libreoffice-calc
	yum install -y ghostscript-chinese-zh_CN.noarch
}

function InstallVnc(){
	yum install -y tigervnc-server
	cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:$VNC_PORT.service
	sed -i 's#<USER>#vncuser#g' /etc/systemd/system/vncserver@:$VNC_PORT.service
	systemctl daemon-reload
}

function InstallBrower(){
	if [[ ! -a "google-chrome-stable_current_x86_64.rpm" ]]; then
		wget bm.jacashop.com/download/google-chrome-stable_current_x86_64.rpm
	fi
	yum localinstall -y google-chrome-stable_current_x86_64.rpm
}

function ConfigVnc(){
	(echo $VNC_PW && echo $VNC_PW) | adduser vncuser
	su - vncuser -c "(echo $VNC_PW && echo $VNC_PW) | vncserver :$VNC_PORT"
	su - vncuser -c "vncserver -kill :$VNC_PORT"
	yum update -y
}

function StartVnc(){
	sudo systemctl enable vncserver@:$VNC_PORT.service
	sudo systemctl start vncserver@:$VNC_PORT.service
	wait
	if [[ ! -a "/home/vncuser/Desktop/google-chrome.desktop" ]]; then
		cp /usr/share/applications/google-chrome.desktop /home/vncuser/Desktop/
	fi
	if [[ ! -a "/home/vncuser/Desktop/libreoffice-writer.desktop" ]]; then
		cp /usr/share/applications/libreoffice-writer.desktop /home/vncuser/Desktop/
	fi
	if [[ ! -a "/home/vncuser/Desktop/libreoffice-calc.desktop" ]]; then
		cp /usr/share/applications/libreoffice-calc.desktop /home/vncuser/Desktop/
	fi
	chown vncuser -Rf /home/vncuser/Desktop/*
	chmod a+x /home/vncuser/Desktop/*.desktop
}

function Main(){
	GetVncPasswd
	InstallGnome
	InstallVnc
	InstallBrower
	ConfigVnc
	StartVnc
}

Main
