#!/bin/bash

date=$(date +"%d%m%y");                         #  Текущая дата
currentName=$3;                                 #  Текущее название папки в цикле
countLettersInOrigin=$(echo $3 | wc -m);        #  Кол-во допустимых символов в названии
counterOfletter=1;                              #  Счётчик положения вставки новой буквы в названии папки
counterOfStep=2;                                #  Шаг предыдущего счётчика
for (( i=0, j=1; i < $2; i++, j++));            #  i - кол-во необходимых папок
do                                              #  j - контролирует цикл вставки всех букв по порядку
    if [[ $(echo $currentName | wc -m) -lt 5 ]];#  Если название папки меньше четырёх
    then
        let i-=1;                               #  то пропускаем его
    else                                        
        $(mkdir "$1/$currentName"_"$date" 2>/dev/null);     #  Создание новой папки
        if [ -d $1/$currentName"_"$date ]; then             #  Если каталог создался, записываем в логфайл 
            $(echo -e "${1}/$currentName"_"$date\t$(date +"%d.%b.%Y %H:%M:%S")" >> logfile.log);  # Добавление записи в лог-файл
        fi
        ./files_generator.sh $1 $2 $3 $4 $5 $6 $1/$currentName"_"$date
    fi
    temp="${currentName:0:counterOfletter}";    #  Подстрока до вставки новой буквы
    currentName="$temp${temp:length-1}${currentName:counterOfletter}";
                                                #  Вставка новой буквы и конкатенация со второй подстрокой
    let counterOfletter+=$counterOfStep;        
    if [[ $j -eq $countLettersInOrigin ]]; then #  Если вставили все возможные буквы, начинаем снова с первой
        counterOfletter=$counterOfStep;
        let counterOfStep+=1;                   #  увеличиваем шаг, так как каждой буквы теперь на одну больше
        j=1;
    fi
done