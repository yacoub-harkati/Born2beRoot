#!/bin/bash

archi=$(uname -a)
pcore=$(grep "physical id" /proc/cpuinfo | wc -l)
vcore=$(nproc --all)
umem=$(free -m | awk 'NR==2{printf "%d", $3}')
tmem=$(free -m | awk 'NR==2{printf $2}')
pmem=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
pdisk=$(df -m | grep "^/dev" |  grep -v "/boot" |  awk '{used_disk+=substr($5, 1, length($5))} END {printf "%.2f%%", used_disk}')
tdisk=$(df -m | grep "^/dev" |  grep -v "/boot" |  awk '{total_disk+=substr($2, 1, length($2))} END {printf "%d", total_disk}')
udisk=$(df -m | grep "^/dev" |  grep -v "/boot" |  awk '{used_disk+=substr($3, 1, length($3))} END {printf "%d", used_disk}')
cpu_usage=$(mpstat | grep "all " | awk '{printf "%.2f%%", 100 - $NF}')
last_reboot=$(who -b | awk '{print $3 " " $4}')
islvm=$(lsblk | grep "lvm" | awk 'NR==1{if($6=="lvm") islvm="yes"; else is="no"} END {print islvm}')
tcpc=$(netstat -t | grep "ESTABLISHED" | wc -l)
clog=$(who | wc -l)
hostname_ip=$(hostname -I)
mac=$(ip l | awk '$1=="link/ether"{print $2}')
sudo_cmd=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)

wall "#Architecture: $archi
#CPU physical :$pcore
#vCPU : $vcore
#Memory Usage: $umem MB/$tmem MB ($pmem)
#Disk Usage: $udisk MB/$tdisk MB ($pdisk)
#CPU load: $cpu_usage
#Last boot: $last_reboot
#LVM use: $islvm
#Connections TCP : $tcpc ESTABLISHED
#User log: $clog
#Network: IP $hostname_ip ($mac)
#Sudo : $sudo_cmd cmd"