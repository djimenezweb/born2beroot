# ARCHITECTURE
arch="$(uname -s -n -r)"
kern="$(uname -v -m -o)"

# CPU
cpu_phys="$(nproc)"
cpu_sockets="$(lscpu | grep "Socket(s)" | awk '{print $2}')"
cpu_cores="$(lscpu | grep "Core(s) per socket" | awk '{print $2}')"
cpu_threads="$(lscpu | grep "Thread(s) per socket" | awk '{print $2}')"
# Avoid expr cpu_virtual="$(expr $cpu_sockets \* $cpu_cores \* $cpu_threads)"
cpu_virtual="$(( cpu_sockets * cpu_cores * cpu_threads ))"

# MEMORY
# 7th column = Available memory
# 2nd column = Total memory
mem_avail="$(free -m | grep "Mem" | awk '{print $7}' | xargs)"
mem_total="$(free -m | grep "Mem" | awk '{print $2}' | xargs)"
# Avoid expr mem_pcent="$(expr 100 \* $mem_avail / $mem_total | xargs)"
mem_pcent="$(( 100 * mem_avail / mem_total ))"

# DISK
dsk_avail="$(df -BM --output='avail' . | awk 'NR==2' | xargs)"
dsk_total="$(df -BM --output='size' . | awk 'NR==2' | xargs)"
dsk_pcent="$(df --output='pcent' . | awk 'NR==2' | xargs)"

# NETWORK
# ifconfig is not installed by default on Debian
# Better use this:
# ip_addr=$(hostname -I | awk '{print $1}')
# mac_addr=$(ip link show | awk '/ether/ {print $2; exit}')
ip_addr="$(ifconfig | grep inet | awk 'NR==1 {print $2}')"
mac_addr="$(ifconfig | grep ether | awk 'NR==1 {print $2}')"

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
echo "#Virtual CPUs:    $cpu_virtual"
echo "#Memory Usage:    $mem_avail/$mem_total MB ($mem_pcent%)"
echo "#Disk Usage:      $dsk_avail/$dsk_total ($dsk_pcent)"
echo "#CPU load:        $()"
echo "#Last boot:       $last_boot"
echo "#LVM use:         $lvs_active"
echo "#TCP Connections: $tcp_conn ESTABLISHED"
echo "#Logged users:    $loggedusr"
echo "#IP addr / MAC:   $ip_addr ($mac_addr)"
echo "#Sudo commands:   $()"
