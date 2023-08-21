#! /bin/bash

numbstr=1  # счётчик строки в файле
filename=current.txt

echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo "$(du -h -d 10 $1 2>/dev/null | sort -hr | head -n 6)" > $filename  # запись во временный файл 6 самых больших директорий
sed -i '1d' $filename  # удаляем первую строчку, так как она содержит изначальную директорию, остаётся 5
while read line; do
echo "${numbstr} - $(cat $filename | sed -n ${numbstr}p | awk '{ printf("%s\n", $2) }')/, $(cat $filename | sed -n ${numbstr}p | awk '{ printf("%s\n", $1) }')"  # парсим файл для корректного вывода
((numbstr++))
done < "$filename"
$(rm ${filename})  # удаляем временный файл

