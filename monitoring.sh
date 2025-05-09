#!/bin/bash

# ARCHITECTURE
arch="$(uname -a)"

# CPU
cpu_phys="$(nproc)"
cpu_sockets="$(lscpu | awk '/Socket\(s\)/ {print $NF}')"
cpu_cores="$(lscpu | awk '/Core\(s\) per socket/ {print $NF}')"
cpu_threads="$(lscpu | awk '/Thread\(s\) per core/ {print $NF}')"
cpu_virtual="$(( cpu_sockets * cpu_cores * cpu_threads ))"

# MEMORY
# 3rd column = Used memory
# 2nd column = Total memory
mem_used="$(free -m | awk '/Mem/ {print $3}' | xargs)"
mem_total="$(free -m | awk '/Mem/ {print $2}' | xargs)"
mem_pcent="$(( 100 * $mem_used / $mem_total ))"

# DISK
dsk_used="$(df -BM --total --output='used' | tail -1 | xargs)"
dsk_total="$(df -BM --total --output='size' | tail -1 | xargs)"
dsk_pcent="$(df --total --output='pcent' | tail -1 | xargs)"

# CPU LOAD
# Requires sysstat
cpu_load="$(mpstat | tail -1 | awk '{print 100 - $NF}')%"

# NETWORK
ip_addr=$(hostname -I | awk '{print $1}')
mac_addr=$(ip link | awk '/ether/ {print $2}')

# BOOT
last_boot="$(uptime -s)"

# LVS
# Can be done running lvs but needs lvm2 package
lvs_count="$(lsblk | grep lvm | wc -l)"
if [ $lvs_count -gt 1 ]; then
	lvs_active="Yes"
else
	lvs_active="No"
fi

# ESTABLISHED TCP CONNECTIONS
tcp_conn="$(ss -tH state established | wc -l)"

# LOGGED USERS
loggedusr="$(who -q | sed -n 's/^# users=//p')"

# SUDO COMMANDS
sudo_comm="$(journalctl _COMM=sudo | grep COMMAND | wc -l)"

echo "architecture    : $arch"
echo "physical CPUs   : $cpu_phys"
echo "virtual CPUs    : $cpu_virtual"
echo "memory usage    : ${mem_used}M / ${mem_total}M (${mem_pcent}%)"
echo "disk usage      : ${dsk_used} / ${dsk_total} (${dsk_pcent})"
echo "CPU load        : $cpu_load"
echo "last boot       : $last_boot"
echo "LVM use         : $lvs_active"
echo "TCP connections : $tcp_conn established"
echo "logged users    : $loggedusr"
echo "ip address      : $ip_addr"
echo "mac address     : $mac_addr"
echo "sudo commands   : $sudo_comm"
