#!/bin/bash

arch=$(uname -a)
ph_cpu=$(grep "physical id" /proc/cpuinfo | wc -l)
v_cpu=$(grep "processor" /proc/cpuinfo | wc -l)
f_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
u_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
p_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
f_disk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
u_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
p_disk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft += $2} END {printf("%d"), ut/ft*100}')
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs |  awk '{printf("%.1f%%"), $1 + $3}')
last_reboot=$(who -b | cut -d " " -f 13-14)
lvm_count=$(lsblk | grep lvm | wc -l)
lvm_use=$(if [ $lvm_count -gt 0 ]; then echo yes; else echo no; fi)
tcp_connect=$(netstat | grep tcp | grep ESTABLISHED | wc -l)
user_log=$(who | cut -d " " -f 1 | sort -u | wc -l)
ip=$(hostname -I)
mac=$(ip address | grep ether | cut -d " " -f 6)
sudo_cmd_count=$(grep -a COMMAND /var/log/sudo/sudo.log | wc -l)

wall "
        #Architecture: $arch
        #CPU physical : $ph_cpu
        #vCPU : $v_cpu
        #Memory Usage: $u_ram/${f_ram}MB ($p_ram%)
        #Disk Usage: $u_disk/${f_disk}Gb ($p_disk%)
        #CPU load: $cpu_load
        #Last boot: $last_reboot
        #LVM use: $lvm_use
        #Connexions TCP : $tcp_connect ESTABLISHED
        #User log: $user_log
        #Network: IP $ip($mac)
        #Sudo : $sudo_cmd_count cmd"
