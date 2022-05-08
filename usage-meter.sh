#! /bin/bash

printf "RAM;Disk;CPU\n"
cd $1
$2 &
pid=$!
sleep_time=$3

trap "kill $pid 2> /dev/null" EXIT

while kill -0 $pid 2> /dev/null; do
RAM=$(free -m | awk 'NR==2{printf "%.2f%%;", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s;", $5}')
CPU_USAGE=$(top -bn1 | grep '%Cpu' | awk '{print 100-$8 "%"}')
echo "$RAM$DISK$CPU_USAGE"
sleep $sleep_time
done

trap - EXIT
