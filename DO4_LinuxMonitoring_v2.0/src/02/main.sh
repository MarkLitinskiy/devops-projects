#!/bin/bash

#main.sh az az.az 3Mb
start_script_sec=$(date +"%s%3N") # запись времени начала скрипта
start_script_time=$(date +"%H:%M:%S")

if [[ -z $1 || -z $2 || -z $3 || ! -z $4 ]]; then # проверка на кол-во параметров
    echo "There can be only three parameters!"
    exit 1
elif [[ ! ($1 =~ ^[A-Za-z]+$ && $(echo $3 | wc -m) -le 8) ]]; then
    echo "The first parameter should be only alphabet letters!"
    exit 1
elif [[ ! ($2 =~ ^[A-Za-z]+(\.)[A-Za-z]+$ && $(echo $2 | cut -d'.' -f1 | wc -m) -le 8 && $(echo $2 | cut -d'.' -f2 | wc -m) -le 4) ]]; then
    echo "The second parameter should use alphabet letters
        (no more than 7 characters for the name, no more than 3 characters for the extension)!"
    exit 1
elif [[ ! $3 =~ ^[1-9][0-9]?(Mb)$|^100(Mb)$ ]]; then
    echo "The third parameter should be file size in Megabytes, but not more than 100"
    exit 1
else
    $(touch logfile.log) # Создание log-файла
    ./worm.sh $1 $2 $3
fi
end_script_sec=$(date +"%s%3N") # запись времени конца скрипта
end_script_time=$(date +"%H:%M:%S")
sec=$(echo "${end_script_sec} ${start_script_sec}" | awk '{printf "%.1f", ($1 - $2)/1000}') # время работы скрипта в секундах

#  вывод времени работы скрипта
echo "Script start time = $start_script_time"
echo "Script end time = $end_script_time"
echo "Script execution time (in seconds) = $sec"
