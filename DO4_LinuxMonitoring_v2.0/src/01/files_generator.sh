#!/bin/bash
size=$(echo "$6" | grep -o '[0-9]' | tr -d '\n') #  размер файла(просто число)
date=$(date +"%d%m%y")                           #  переменная даты
currentprefix=$(echo $5 | cut -d'.' -f1)         #  подстрока с названием файла (возможные символы)
currentsuffix=$(echo $5 | cut -d'.' -f2)         #  подстрока с расширением файла (возможные символы)

countLettersInOriginSuffix=$(echo $currentsuffix | wc -m) #  Кол-во допустимых символов в расширении
counterOfletterSuffix=1                                   #  Счётчик положения вставки новой буквы в расширении
counterOfStepSuffix=2                                     #  Шаг предыдущего счётчика
cycleSuffix=1                                             #  счётчик цикла, когда будут вставлены все возможные буквы, и нужно начинать сначала

countLettersInOriginPrefix=$(echo $currentprefix | wc -m) #  Кол-во допустимых символов в названии
counterOfletterPrefix=1                                   #  Счётчик положения вставки новой буквы в названии
counterOfStepPrefix=2                                     #  Шаг предыдущего счётчика
cyclePreffix=1                                            #  счётчик цикла, когда будут вставлены все возможные буквы, и нужно начинать сначала

counterOfCreatedFiles=0                                                                                         #  счётчик созданных файлов
while [[ ! ($counterOfCreatedFiles -eq $4) && $(df / -BM | grep "/" | awk -F"M" '{ print $3 }') -ge 1024 ]]; do # если достаточно файлов
    # или в системе < 1 Гб
    if [[ $(echo $currentprefix | wc -m) -lt 5 ]]; then #  проверка, чтобы в названии было не меньше 4 символов
        let cyclePreffix+=0
    else
        $(touch "$7/$currentprefix"_"$date.$currentsuffix" 2>/dev/null)                                              #  создание файла
        $(fallocate -l $size"Kib" "$7/$currentprefix"_"$date.$currentsuffix" 2>/dev/null)                            #  коректировка размера файла
        if [ -f $7/$currentprefix"_"$date.$currentsuffix ]; then                                                     #  Если файл создался, записываем в логфайл
            $(echo -e "$d7/$currentprefix"_"$date.$currentsuffix\t$(date +"%d.%b.%Y %H:%M:%S")\t${6}" >>logfile.log) # Добавление записи в лог-файл
        fi
        let counterOfCreatedFiles+=1
    fi

    tempPrefix="${currentprefix:0:counterOfletterPrefix}"                                   #  Prefix #  Подстрока до вставки новой буквы
    currentprefix="$tempPrefix${tempPrefix:length-1}${currentprefix:counterOfletterPrefix}" #  Вставка новой буквы и конкатенация со второй подстрокой
    let counterOfletterPrefix+=$counterOfStepPrefix

    tempSuffix="${currentsuffix:0:counterOfletterSuffix}" #  Suffix
    currentsuffix="$tempSuffix${tempSuffix:length-1}${currentsuffix:counterOfletterSuffix}"
    let counterOfletterSuffix+=$counterOfStepSuffix

    if [[ $cycleSuffix -eq $countLettersInOriginSuffix ]]; then #  Если вставили все возможные буквы, начинаем снова с первой
        counterOfletterSuffix=$counterOfStepSuffix
        let counterOfStepSuffix+=1 #  увеличиваем шаг, так как каждой буквы теперь на одну больше
        cycleSuffix=1
    fi

    if [[ $cyclePrefix -eq $countLettersInOriginPrefix ]]; then
        counterOfletterPrefix=$counterOfStepPrefix
        let counterOfStepPrefix+=1
        cyclePrefix=1
    fi

    let cyclePrefix+=1 #  так как поставили букву, увел. счётчик цикла
    let cycleSuffix+=1

    if [[ $counterOfCreatedFiles -eq $4 || $(df / -BM | grep "/" | awk -F"M" '{ print $3 }') -le 1024 ]]; then #  если создали достаточно файлов
        break                                                                                                  #  или в системе < 1 Гб
    fi

done
