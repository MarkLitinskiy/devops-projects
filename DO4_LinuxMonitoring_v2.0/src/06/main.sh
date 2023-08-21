#! /bin/bash

format="%h\t%s\t%m\t%d\t%t\t%U\t%u" # задаём формат лога (последовательность данных в логфайле), даты и времени
date_format="%Y-%m-%d"
time_format="%H:%M:%S"

if [ $# != 0 ]; then # не должно быть входных аргументов
    echo "Invalid number of arguments (should be 0)"
else
    if which xdpyinfo >/dev/null 2>&1; then # проверка есть ли графический интерфейс
        goaccess ../04/logs/*.log --log-format=$format \
            --date-format=$date_format --time-format=$time_format --output=index.html # есть
        open index.html
    else
        goaccess ../04/logs/*.log --log-format=$format \
            --date-format=$date_format --time-format=$time_format # нет
    fi
fi
