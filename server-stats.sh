#/bin/bash

echo "========Server Performance Stats ==========="
echo "Generate on $(date)"
echo

#OS VERSION
echo "OS Version:"
cat /etc/*release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo

#Who you are loggin in as
echo " User you are logging in as..."
whoami

# Uptime
echo "Uptime:"
uptime -p
echo

# Load Average
echo "Load Average:"
uptime | awk -F'load average:' '{ print $2 }'
echo

# CPU Usage
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | \
awk '{print "Used: " 100 - $8 "% | Idle: " $8 "%"}'
echo

# Memory Usage
echo "Memory Usage:"
free -h | awk '/Mem:/ {
    used=$3; free=$4; total=$2;
    used_p=($3/$2)*100;
    printf "Used: %s | Free: %s | Total: %s | Usage: %.2f%%\n", used, free, total, used_p
}'
echo

# Disk Usage
echo "Disk Usage (Root / Partition):"
df -h / | awk 'NR==2 {
    printf "Used: %s | Available: %s | Total: %s | Usage: %s\n", $3, $4, $2, $5
}'
echo

# Top 5 processes by CPU usage
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo

# Top 5 processes by Memory usage
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo

# Failed login attempts
echo "Failed Login Attempts:"
journalctl -xe | grep "Failed password" | wc -l
echo

echo "========== End of Report =========="
