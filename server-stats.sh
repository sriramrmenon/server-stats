#!/bin/bash

echo "========================================"
echo " SERVER RESOURCE USAGE"
echo " Host: $(hostname)"
echo " Date: $(date)"
echo "========================================"

echo
echo "===== CPU USAGE ====="
CPU_IDLE=$(top -bn1 | awk '/Cpu\(s\)/ {print $8}')
CPU_USED=$(awk "BEGIN {printf \"%.1f\", 100 - $CPU_IDLE}")
echo "CPU Used: ${CPU_USED}%"
echo "CPU Idle: ${CPU_IDLE}%"

echo
echo "===== MEMORY USAGE ====="
free -h | awk '
/^Mem:/ {
    printf "Total: %s\nUsed:  %s (%.1f%%)\nFree/Available: %s (%.1f%%)\n",
    $2, $3, ($3/$2)*100, $7, ($7/$2)*100
}'

echo
echo "===== DISK USAGE ====="
df -h -x tmpfs -x devtmpfs | awk '
NR==1 {
    printf "%-25s %-10s %-10s %-10s %-10s %-20s\n",
    "Filesystem", "Size", "Used", "Free", "Used%", "Mounted"
}
NR>1 {
    printf "%-25s %-10s %-10s %-10s %-10s %-20s\n",
    $1, $2, $3, $4, $5, $6
}'

echo
echo "===== TOP 5 PROCESSES BY CPU ====="
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head -n 6

echo
echo "===== TOP 5 PROCESSES BY MEMORY ====="
ps -eo pid,user,comm,%mem,%cpu --sort=-%mem | head -n 6

echo
echo "========================================"
