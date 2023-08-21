#! /bin/bash

case $1 in  # цвет бэка
    '1')
    color_back_code='\e[107m' # белый
    ;;
    '2')
    color_back_code='\e[101m' # красный
    ;;
    '3')
    color_back_code='\e[102m' # зелёный
    ;;
    '4')
    color_back_code='\e[104m' # синий
    ;;
    '5')
    color_back_code='\e[105m' # пурпурный
    ;;
    '6')
    color_back_code='\e[40m' # чёрный
    ;;
esac

case $2 in  # цвет фронта
    '1')
    color_front_code='\e[97m' # белый
    ;;
    '2')
    color_front_code='\e[91m' # красный
    ;;
    '3')
    color_front_code='\e[92m' # зелёный
    ;;
    '4')
    color_front_code='\e[94m' # синий
    ;;
    '5')
    color_front_code='\e[95m' # пурпурный
    ;;
    '6')
    color_front_code='\e[30m' # чёрный
    ;;
esac

echo "$color_front_code$color_back_code"