#!/bin/bash

normal_icon="🔋"
low_battery_icon="🪫 "
capacity=$(cat /sys/class/power_supply/BAT0/capacity)
capacity_level=$(cat /sys/class/power_supply/BAT0/capacity_level)

if [ "$capacity_level" != "Normal" ]; then
  echo "$low_battery_icon:$capacity" 
else
  echo "$normal_icon:$capacity"
fi
