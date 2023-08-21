#!/bin/bash

# main.sh /home/marcus/test 4 az 5 az.az 3kb

if [[ -z $1 || -z $2 || -z $3 || -z $4 || -z $5 || -z $6 || ! -z $7 ]]; then # проверка на кол-во параметров
    echo "There can be only six parameters!"
    exit 1
elif [[ ! $2 =~ ^[0-9]+$ ]]; then
    echo "The second parameter should be a number!"
    exit 1
elif [[ ! ($3 =~ ^[A-Za-z]+$ && $(echo $3 | wc -m) -le 8) ]]; then
    echo "The third parameter should be only alphabet letters!"
    exit 1
elif [[ ! $4 =~ ^[0-9]+$ ]]; then
    echo "The fourth parameter should be a number!"
    exit 1
elif [[ ! ($5 =~ ^[A-Za-z]+(\.)[A-Za-z]+$ && $(echo $5 | cut -d'.' -f1 | wc -m) -le 8 && $(echo $5 | cut -d'.' -f2 | wc -m) -le 4) ]]; then
    echo "The fiveth parameter should use alphabet letters
        (no more than 7 characters for the name, no more than 3 characters for the extension)!"
    exit 1
elif [[ ! $6 =~ ^[1-9][0-9]?(kb)$|^100(kb)$ ]]; then
    echo "The sixth parameter should be file size in kilobytes, but not more than 100"
    exit 1
else
    $(touch logfile.log) #  Создание log-файла
    ./dir_generator.sh $1 $2 $3 $4 $5 $6
fi
