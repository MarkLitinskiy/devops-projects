#! /bin/bash

numbstr=1  # счётчик строки в файле
filename=current.txt

echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
echo "$(find $1 -type f -executable -exec du -sh {} + 2>/dev/null | sort -rh | head -n 10)" > $filename  # запись во временный файл 10 самых больших исполняемых файлов
while read line; do
ender=$(echo "$(cat $filename | sed -n ${numbstr}p | awk '{ printf("%s\n", $2) }' | md5sum | awk '{ printf("%s\n", $1) }')")  # Хэш файла
if [[ $line != "" ]]; then
echo "${numbstr} - $(cat $filename | sed -n ${numbstr}p | awk '{ printf("%s\n", $2) }'), $(cat $filename | sed -n ${numbstr}p | awk '{ printf("%s\n", $1) }'), ${ender}"  # парсим файл для корректного вывода
fi
((numbstr++))
done < "$filename"
$(rm ${filename})  # удаляем временный файл
