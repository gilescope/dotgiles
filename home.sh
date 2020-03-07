#!/bin/sh
sudo iwconfig wlp3s0 txpower 11
sudo cp ~/brightness /sys/class/backlight/gmux_backlight/brightness
nmcli r wifi off
nmcli r wifi on
#nmcli r wifi
sleep 0.1
nmcli con up FloIsEpic
