#!/bin/sh
nmcli r wifi off
nmcli r wifi on
nmcli r wifi
sleep 1.5
sudo iwconfig wlp3s0 txpower 10
sudo cp ~/brightness /sys/class/backlight/gmux_backlight/brightness
nmcli con up '!CrossFit Blackwater Is Awesome'
