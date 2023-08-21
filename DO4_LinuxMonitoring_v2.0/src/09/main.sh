#! /bin/bash

function cpu_stat() {
    local cpu=$(top -bn1 | grep "Cpu(s)" | # сбор самой метрики
        sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |
        awk '{print 100 - $1}')
    echo "# HELP cpu_usage CPU usage in percentage" >>/var/www/metrics/index.html
    echo "# TYPE cpu_usage gauge" >>/var/www/metrics/index.html
    echo "cpu_usage{cpu=\"cpu1\"} ${cpu}" >>/var/www/metrics/index.html
}

function mem_stat() {
    local mem=$(top -bn1 | grep "MiB Mem" | awk '{print $6}') # сбор метрики (свободной оперативной памяти)
    echo "# HELP mem_free is available RAM" >>/var/www/metrics/index.html
    echo "# TYPE mem_free histogram" >>/var/www/metrics/index.html
    echo "mem_free{mem=\"mem1\"} ${mem}" >>/var/www/metrics/index.html
}

function space_stat() {
    local space=$(df / -BM | grep "/" | awk '{print $4}' | awk -F"M" '{print $1}') # сбор метрики (свободного места на диске)
    echo "# HELP space_free is available space" >>/var/www/metrics/index.html
    echo "# TYPE space_free histogram" >>/var/www/metrics/index.html
    echo "space_free{space=\"space1\"} ${space}" >>/var/www/metrics/index.html
}

if [[ ! -z $1 ]]; then
    echo "The script could start only without parameters!"
else
    while true; do
        touch /var/www/metrics/index.html
        cpu_stat
        mem_stat
        space_stat
        sleep 3
        rm /var/www/metrics/index.html
    done
fi
