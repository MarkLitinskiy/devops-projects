#! /bin/bash

function clean_with_logfile() { # очистка по лог-файлу 2-го задания
    for path in $( # выводит список созданных папок из логфайла
        cat ../02/logfile.log | awk 'NF == 3 {print $1}'
    ); do
        $(rm -rf ${path}) # удаляет папку/файл
    done
}

function clean_with_dateTime() {
    echo "Enter the date and time (example: YYYY-MM-DD HH:MM:SS)" # ввод временного промежутка
    read -p "Write start date and time: " start
    echo "Enter the date and time (example: YYYY-MM-DD HH:MM:SS)"
    read -p "Write end date and time: " end
    for file in $( # проходка по всем файлам и папкам системы
        find /* -name "*"
    ); do
        inode=$(stat -c "%i" ${file} 2>/dev/null) # вытащили inode файла/папки
        dat=$(
            debugfs -R "stat <${inode}>" \
                $(df ${file} 2>&1 | awk '/\// {print $1}') 2>&1 |
                awk '/crtime/ {print $4"\t"$5"\t"$6"\t"$7"\t"$8}' # вытащили дату создания
        )
        formatted_dat=$(date -d "$dat" +"%y-%m-%d %H:%M:%S") # преобразование даты в вид date

        if [[ "$(date -d "${start}" +%s)" -le "$(date -d "${formatted_dat}" +%s)" &&
        "$(date -d "${end}" +%s)" -ge "$(date -d "${formatted_dat}" +%s)" ]]; then # если дата файла/папки соответ. промежутку
            echo "${file}"
            $(rm -rf ${file}) # удаляем
        fi
    done
}

function clean_with_mask() {
    echo "Enter mask of direction (example: azsd_150623)" # ввод маски папки
    read -p "Write mask of direction: " mask
    letters=$(echo "$mask" | awk -F'_' '{print $1}') # буквы маски
    date=$(echo "$mask" | awk -F'_' '{print $2}')    # дата маски
    finder=${letters:0:1}\*${letters: -1}_$date      # маска вида перваябуква*последняябуква_дата

    for file in $( # проходка по всем файлам и папкам системы
        find /* -name "$finder"
    ); do
        $(rm -rf ${file}) # удаляем
    done
}

if [[ -z $1 || ! -z $2 || ! $1 =~ ^[1-3]+$ ]]; then # проверка корректности ввода
    echo "There can be only one parameter \"1-3\""
    exit 1
elif [[ $1 -eq 1 ]]; then # очистка по лог-файлу
    clean_with_logfile
    echo 'clean_with_logfile'
elif [[ $1 -eq 2 ]]; then # очистка по дате создания
    clean_with_dateTime
    echo 'clean_with_dateTime'
elif [[ $1 -eq 3 ]]; then # очистка по маске
    clean_with_mask
    echo 'clean_with_mask'
fi
