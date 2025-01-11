#!/bin/bash

DISCONNECTED_COLOR="#8c8c8c"

IP=$(ifconfig wlan0 |
    grep -Eo 'inet .+ netmask' |
    grep -Eo '[0-9\.]*' --color=never |
    tr -d '\n')
if [[ "$IP" ]]; then
    echo $IP
else
    echo "%{F$DISCONNECTED_COLOR}-%{F-}"
fi
