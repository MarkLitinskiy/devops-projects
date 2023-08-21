#! /bin/bash

$current  # текущий параметр скрипта в цикле
$count  # номер столбца для описания цветовой схемы
$back_or_font  # тип бэкграунд или шрифт для описания цветовой схемы

if [[ $5 -eq -1 ]]; then  # цветовая схема по дефолту
echo "Column 1 background = default (black)"
echo "Column 1 font color = default (white)"
echo "Column 2 background = default (red)"
echo "Column 2 font color = default (blue)"
else 
for var in $1 $2 $3 $4  # проходим по 4 параметрам
do
case $var in
    '1')
    current='white' # белый
    ;;
    '2')
    current='red' # красный
    ;;
    '3')
    current='green' # зелёный
    ;;
    '4')
    current='blue' # синий
    ;;
    '5')
    current='purple' # пурпурный
    ;;
    '6')
    current='black' # чёрный
    ;;
esac

if [[ var -eq $1 ]] || [[ var -eq $2 ]]; then  # определение номера столбца
count='1' 
elif [[ var -eq $3 ]] || [[ var -eq $4 ]]; then
count='2'
fi

if [[ var -eq $1 ]] || [[ var -eq $3 ]]; then  # определение типа
back_or_font='background' 
else back_or_font='font color'
fi

echo "Column ${count} ${back_or_font} = ${var} (${current})"  # вывод цветовой схемы для текущего параметра
done
fi