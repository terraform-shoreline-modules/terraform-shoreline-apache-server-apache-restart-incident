

#!/bin/bash



# Check memory usage

total_mem=$(free -m | awk '/^Mem:/{print $2}')

used_mem=$(free -m | awk '/^Mem:/{print $3}')

free_mem=$(free -m | awk '/^Mem:/{print $4}')

mem_percent=$(echo "scale=2; $used_mem/$total_mem * 100" | bc)



if (( $(echo "$mem_percent > 90" | bc -l) )); then

    echo "Memory usage is high (currently using ${used_mem}M out of ${total_mem}M)"

fi



# Check CPU usage

cpu_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

if (( $(echo "$cpu_percent > 90" | bc -l) )); then

    echo "CPU usage is high (currently using ${cpu_percent}%)"

fi

# Check disk space usage

total_disk=$(df -h | awk '$NF=="/"{printf "%d", $2}')

used_disk=$(df -h | awk '$NF=="/"{printf "%d", $3}')

free_disk=$(df -h | awk '$NF=="/"{printf "%d", $4}')

disk_percent=$(df -h | awk '$NF=="/"{print $5}' | sed 's/%//g')

if (( $(echo "$disk_percent > 90" | bc -l) )); then

    echo "Disk space usage is high (currently using ${disk_percent}%)"

fi

# Check Apache status

apache_status=$(systemctl status apache2 | grep "Active:" | awk '{print $2}')

if [ "$apache_status" != "active" ]; then

    echo "Apache is not running (status: ${apache_status})"

fi