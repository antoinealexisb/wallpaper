#!/bin/bash

###########################################
#
# changes the background image on Gnome and Xfce
#
# Author : Antoine-Alexis Bourdon
# Link : https://github.com/antoinealexisb/wallpaper
# Version : 1.0.0
# Dependency : libnotify-bin
#
###########################################

test "$#" -gt 1 && echo "Number of arguments too high , PLEASE GUY !!!!!!!!!" && exit 1

#if not param is soft and with param it's less soft but not hard.
if [[ "$#" -eq 0 ]]
then
	LINK="https://wallhaven.cc/search?categories=010&purity=100&sorting=random"
	echo $LINK
else
	LINK="https://wallhaven.cc/search?categories=010&purity=010&sorting=random"
fi

#variables
fileprefix=$HOME/Images/wallbase-wp-
todaywp=$fileprefix$(date +%y-%m-%d-%H-%M-%S).jpg

#######################################################
# Funtion check your internet connection
# #Args: None
# #Return: 1 (is good), 0 (no internet connection 😭)
#######################################################
function chkinternet {
	echo `wget -q -O - google.com | grep -c "<title>Google</title>"`
}

#######################################################
# note : install libnotify-bin to popup notification
# Function that sends a pop-up
# #Args: None
# #Return : None
#######################################################
function notify {
	if [[ -e /usr/bin/notify-send ]]
	then
		notify-send "Hey $USER" "I'm here for you 😊(in your Desktop 😜)" -i $todaywp
	fi
}

#Check connection 
while [ $(chkinternet) != "1" ]; do sleep 15; done
echo Internet connection is OK

#Donwload IMG
wget -O - $(wget -O - $LINK | grep -Eo "(https://wallhaven.cc/w/[0-9a-zA-Z]+)" | head -n 1) | grep -Eo "https://w.wallhaven.cc/full/[0-9a-zA-Z]+/wallhaven-[0-9a-zA-Z]+.[a-z]+" | wget -q -i - -O $todaywp 

#Is GOOD Information 😂
echo Photo downloaded

#According to the different graphics system 
if [[ -e /usr/bin/gsettings ]]
then
	gsettings set org.gnome.desktop.background picture-uri file:///$todaywp
elif [[ -e /usr/bin/xfconf-query ]]
then
	#Not work for ubuntu 18.04.4LTS
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s $todaywp
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s $todaywp
elif [[ -e /usr/bin/gconftool-2 ]]
then
	gconftool-2 --type string --set /desktop/gnome/background/picture_filename $todaywp
	gconftool-2 --type string --set /desktop/gnome/background/picture_options scaled
fi

#Notify 😊😊😊😊
notify

#Thanks for watching me. 😊😊
