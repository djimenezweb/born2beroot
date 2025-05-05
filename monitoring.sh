# MEMORY (free)
# 7th column = Available memory
# 2nd column = Total memory
mem_avail="$(free -m | grep "Mem" | awk '{print $7}')"
mem_total="$(free -m | grep "Mem" | awk '{print $2}')"
mem_pcent="$(expr 100 \* $mem_avail / $mem_total)"

# DISK (df)
dsk_avail="$(df -BM --output='avail' . | awk 'NR==2')"
dsk_total="$(df -BM --output='size' . | awk 'NR==2')"
dsk_pcent="$(df --output='pcent' . | awk 'NR==2')"

echo "#Architecture:    $(uname -s) $(uname -n) $(uname -r)"
echo "                  $(uname -v) $(uname -m) $(uname -p) $(uname -i) $(uname -o)"
echo "#CPU physical:    $(nproc)"
echo "#CPU virtual:     $()"
echo "#Memory Usage:    $(echo $mem_avail)/$(echo $mem_total)MB ($(echo $mem_pcent)%)"
echo "#Disk Usage:      $(echo $dsk_avail)/$(echo $dsk_total) ($(echo $dsk_pcent))"
echo "#CPU load:        $()"
echo "#Last boot:       $(last reboot -n 1 -F | grep "reboot")"
echo "#LVM use:         $()"
echo "#TCP Connections: $()"
echo "#Logged users:    $(who | wc -l)"
echo "#IP addr / MAC:   $(hostname -i)"
echo "#Sudo commands:   $()"