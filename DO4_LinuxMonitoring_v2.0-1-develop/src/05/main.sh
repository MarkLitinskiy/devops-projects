#! /bin/bash

function sortByAnswerCode() {
    $(rm -rf output 2>/dev/null) # удаляем файл вывода
    for ((i = 1; i <= 5; i++)); do
        $(cat ../04/logs/logfile${i}.log >>temp) # считываем все пять файлов логов в один временный
    done
    $(awk '{print $0}' temp | sort -k2 >output) # сортируем по коду ответа и записываем в файл вывода
    $(rm -rf temp 2>/dev/null)
}

function allUnicIp() {
    $(rm -rf output 2>/dev/null) # удаляем файл вывода
    for ((i = 1; i <= 5; i++)); do
        $(cat ../04/logs/logfile${i}.log >>temp) # считываем все пять файлов логов в один временный
    done
    $(awk '!seen[$1]++' temp | awk '{print $1}' >output) # выводим в файл output только уникальные ip
    $(rm -rf temp 2>/dev/null)
}

function allQueryWithError() {
    $(rm -rf output 2>/dev/null) # удаляем файл вывода
    for ((i = 1; i <= 5; i++)); do
        $(cat ../04/logs/logfile${i}.log >>temp) # считываем все пять файлов логов в один временный
    done
    $(awk '$2 ~ /^[4-5]/{print $0}' temp >output) # сортируем по коду ответа 4xx и 5xx
    $(rm -rf temp 2>/dev/null)
}

function allUnicIpWithErrors() {
    allQueryWithError
    $(awk '!seen[$1]++' output | awk '{print $1}' >output4) # выводим в файл output только уникальные ip
    $(rm -rf output 2>/dev/null)
}

if [[ -z $1 || ! -z $2 ]]; then # проверка на кол-во параметров
    echo "There can be only four parameters!"
    exit 1
elif [[ ! $1 =~ ^[1-4]+$ ]]; then # проверка на корректность ввода
    echo "The parameter can be only number 1-4"
    exit 1
else
    if [[ $1 -eq 1 ]]; then # вызов функции взависимости от параметра
        sortByAnswerCode
        echo "sortByAnswerCode"
    elif [[ $1 -eq 2 ]]; then
        allUnicIp
        echo "allUnicIp"
    elif [[ $1 -eq 3 ]]; then
        allQueryWithError
        echo "allQueryWithError"
    elif [[ $1 -eq 4 ]]; then
        allUnicIpWithErrors
        echo "allUnicIpWithErrors"
    fi
fi
