#!/bin/bash
cpu=$(awk '{print $1}' < /proc/loadavg)
temp=$(sensors | awk '/Core 0/ {print $3}')
# echo $cpu / $temp
# echo  $cpu GHz 
echo  $cpu GHz 
