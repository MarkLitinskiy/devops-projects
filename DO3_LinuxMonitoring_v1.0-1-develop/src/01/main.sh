#! /bin/bash

re='^[0-9]+$' # регулярное выражение для числа

if [[ -z $1 ]]; then # если первый параметр пустой
echo "Parameter is empty!"; exit 1
elif [[ ! -z $2 ]]; then # если есть второй параметр
echo "There can be only one parameter!"; exit 1
elif [[ $1 =~ $re ]]; then # если первый параметр соответствует регулярному выражению
echo "Parameter is a number!"; exit 1
else echo "$1"
fi