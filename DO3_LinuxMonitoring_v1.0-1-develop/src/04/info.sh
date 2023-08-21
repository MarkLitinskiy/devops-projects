#! /bin/bash

value_names=$(./find_color_code.sh $1 $2)
values=$(./find_color_code.sh $3 $4)
end_color='\e[0m'


time_zone=$(timedatectl | grep "Time zone" | awk '{print $3 $4 $5}')
os=$(lsb_release -ds)
date=$(date +"%d %b %Y %H:%M:%S")
uptime=$(uptime -p | awk '{print $2 " " $3 " " $4 " " $5}')
uptime_sec=$(cat /proc/uptime | awk '{print $1}')
ip=$(hostname -I)
mask=$(ifconfig | sed -n -e '/netmask/p' | sed 1q | awk '{print $4}')
gateway=$(ip route | grep default | sed 1q | awk '{print $3}')
ram_total=$(free -m | awk '/^Mem:/ { printf("%.3f\n", $2/1024) }')
ram_used=$(free -m | awk '/^Mem:/ { printf("%.3f\n", $3/1024) }')
ram_free=$(free -m | awk '/^Mem:/ { printf("%.3f\n", $4/1024) }')
space_root=$(df / | grep "/" | awk '{printf "%.3f\n", $2/1024}')
space_root_used=$(df / | grep "/" | awk '{printf "%.3f\n", $3/1024}')
space_root_free=$(df / | grep "/" | awk '{printf "%.3f\n", $4/1024}')

echo -e "${value_names}HOSTNAME${end_color} = ${values}$HOSTNAME${end_color}"
echo -e "${value_names}TIMEZONE${end_color} = ${values}$time_zone${end_color}"
echo -e "${value_names}USER${end_color} = ${values}$USER${end_color}"
echo -e "${value_names}OS${end_color} = ${values}$os${end_color}"
echo -e "${value_names}DATE${end_color} = ${values}$date${end_color}"
echo -e "${value_names}UPTIME${end_color} = ${values}$uptime${end_color}"
echo -e "${value_names}UPTIME_SEC${end_color} = ${values}$uptime_sec${end_color}"
echo -e "${value_names}IP${end_color} = ${values}$ip${end_color}"
echo -e "${value_names}MASK${end_color} = ${values}$mask${end_color}"
echo -e "${value_names}GATEWAY${end_color} = ${values}$gateway${end_color}"
echo -e "${value_names}RAM_TOTAL${end_color} = ${values}$ram_total Gb${end_color}"
echo -e "${value_names}RAM_USED${end_color} = ${values}$ram_used Gb${end_color}"
echo -e "${value_names}RAM_FREE${end_color} = ${values}$ram_free Gb${end_color}"
echo -e "${value_names}SPACE_ROOT${end_color} = ${values}$space_root Mb${end_color}"
echo -e "${value_names}SPACE_ROOT_USED${end_color} = ${values}$space_root_used Mb${end_color}"
echo -e "${value_names}SPACE_ROOT_FREE${end_color} = ${values}$space_root_free Mb${end_color}"