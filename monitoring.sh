# ARCHITECTURE
arch="$(uname -s -n -r)"
kern="$(uname -v -m -o)"

# CPU
cpu_phys="$(nproc)"
cpu_sockets="$(lscpu | awk '/Socket\(s\)/ {print $2}')"
cpu_cores="$(lscpu | awk '/Core\(s\) per socket/ {print $4}')"
cpu_threads="$(lscpu | awk '/Thread\(s\) per core/ {print $4}')"
cpu_virtual="$(( cpu_sockets * cpu_cores * cpu_threads ))"

# MEMORY
# 7th column = Available memory
# 2nd column = Total memory
mem_avail="$(free -m | awk '/Mem/ {print $7}' | xargs)"
mem_total="$(free -m | awk '/Mem/ {print $2}' | xargs)"
mem_pcent="$(( 100 * $mem_avail / $mem_total ))"

# DISK
dsk_avail="$(df -BG --total --output='avail' | awk 'NR==2' | xargs)"
dsk_total="$(df -BG --total --output='size' | awk 'NR==2' | xargs)"
dsk_pcent="$(df --total --output='pcent' | awk 'NR==2' | xargs)"

# NETWORK
ip_addr=$(hostname -I | awk '{print $1}')
mac_addr=$(ip link show | awk '/ether/ {print $2; exit}')

# BOOT
last_boot="$(uptime -s)"

# LVS
lvs_count="$(lvs | wc -l)"
if [ $lvs_count -gt 1 ]; then
	lvs_active="Yes"
else
	lvs_active="No"
fi

# ESTABLISHED TCP CONNECTIONS
tcp_conn="$(ss -tH state established | wc -l)"

# LOGGED USERS
loggedusr="$(who | wc -l)"

echo "#Architecture:    $arch"
echo "                  $kern"
echo "#Physical CPUs:   $cpu_phys"
echo "#Virtual CPUs:    $cpu_virtual ---IMPROVE---"
echo "#Memory Usage:    ${mem_avail}/${mem_total} MB (${mem_pcent}%)"
echo "#Disk Usage:      ${dsk_avail}/${dsk_total} (${dsk_pcent}) ---WRONG---"
echo "#CPU load:        $()---TO DO---"
echo "#Last boot:       $last_boot"
echo "#LVM use:         $lvs_active"
echo "#TCP Connections: $tcp_conn ESTABLISHED"
echo "#Logged users:    $loggedusr"
echo "#IP addr / MAC:   $ip_addr (${mac_addr})"
echo "#Sudo commands:   $()---TO DO---"
