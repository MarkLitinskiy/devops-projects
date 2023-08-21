#!/bin/bash
date=$(date +"%d%m%y")                     #  Текущая дата
currentDirName=$1                          #  Текущее название папки в цикле
countLettersInDirOrigin=$(echo $1 | wc -m) #  Кол-во допустимых символов в названии
counterOfDirletter=1                       #  Счётчик положения вставки новой буквы в названии папки
counterOfDirStep=2                         #  Шаг предыдущего счётчика
countDir=1                                 #  Кол-во созданных директорий
randomCountDir=$(shuf -i 5-8 -n 1)         #  Случайное значение поддиректорий в папке (для каждой папки меняется)
randomCountFiles=$(shuf -i 10-15 -n 1)     #  Случайное значение файлов в папке (для каждой папки меняется)

checking_countDir() {                                                                       #  Проверочка для break ($1 - это кол-во созданных папок)
    if [[ $1 -ge 100 || $(df / -BM | grep "/" | awk -F"M" '{ print $3 }') -le 1024 ]]; then #  Если кол-во созданных папок 100 или в системе < 1 ГБ, завершаем
        result=1
    else
        result=0
    fi
}

creating_files() {
    size=$(echo "$3" | grep -o '[0-9]' | tr -d '\n') #  размер файла(просто число)
    currentprefix=$(echo $2 | cut -d'.' -f1)         #  подстрока с названием файла (возможные символы)
    currentsuffix=$(echo $2 | cut -d'.' -f2)         #  подстрока с расширением файла (возможные символы)

    countLettersInOriginSuffix=$(echo $currentsuffix | wc -m) #  Кол-во допустимых символов в расширении
    counterOfletterSuffix=1                                   #  Счётчик положения вставки новой буквы в расширении
    counterOfStepSuffix=2                                     #  Шаг предыдущего счётчика
    cycleSuffix=1                                             #  счётчик цикла, когда будут вставлены все возможные буквы, и нужно начинать сначала

    countLettersInOriginPrefix=$(echo $currentprefix | wc -m) #  Кол-во допустимых символов в названии
    counterOfletterPrefix=1                                   #  Счётчик положения вставки новой буквы в названии
    counterOfStepPrefix=2                                     #  Шаг предыдущего счётчика
    cyclePreffix=1                                            #  счётчик цикла, когда будут вставлены все возможные буквы, и нужно начинать сначала

    counterOfCreatedFiles=0                                                                                                        #  счётчик созданных файлов
    while [[ ! ($counterOfCreatedFiles -eq $randomCountFiles) && $(df / -BM | grep "/" | awk -F"M" '{ print $3 }') -ge 1024 ]]; do # если достаточно файлов
        # или в системе < 1 Гб
        if [[ $(echo $currentprefix | wc -m) -lt 5 ]]; then #  проверка, чтобы в названии было не меньше 4 символов
            let cyclePreffix+=0
        else
            $(touch $4/$currentprefix"_"$date.$currentsuffix 2>/dev/null)                                               #  создание файла
            $(fallocate -l $size"Mib" "$4/$currentprefix"_"$date.$currentsuffix" 2>/dev/null)                           #  коректировка размера файла
            if [ -f $4/$currentprefix"_"$date.$currentsuffix ]; then                                                    #  Если файл создался, записываем в логфайл
                $(echo -e "$4/$currentprefix"_"$date.$currentsuffix\t$(date +"%d.%b.%Y %H:%M:%S")\t${3}" >>logfile.log) # Добавление записи в лог-файл
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

        checking_countDir $countDir
        if [[ result -eq 1 ]]; then
            break
        fi

    done
    randomCountFiles=$(shuf -i 10-15 -n 1) #  обновление кол-ва файлов для создания в след. папке
}

for currentDir in /*; do
    #echo $currentDir;
    if [[ $currentDir == '/bin' || $currentDir == '/sbin' ]]; then
        continue
    fi

    for ((i = 0, j = 1; i < randomCountDir; i++, j++)); do #  i - кол-во необходимых папок
        #  j - контролирует цикл вставки всех букв по порядку
        if [[ $(echo $currentDirName | wc -m) -lt 5 ]]; then #  Если название папки меньше четырёх
            let i-=1                                         #  то пропускаем его
        else
            $(mkdir $currentDir/$currentDirName"_"$date 2>/dev/null)                                         #  Создание новой папки
            if [ -d $currentDir/$currentDirName"_"$date ]; then                                              #  Если каталог создался, записываем в логфайл
                $(echo -e "$currentDir/$currentDirName"_"$date\t$(date +"%d.%b.%Y %H:%M:%S")" >>logfile.log) # Добавление записи в лог-файл
            fi
            let countDir+=1                                             #  увеличиваем значение созданных папок
            creating_files $1 $2 $3 $currentDir/$currentDirName"_"$date # создание файлов в папке
        fi
        tempDir="${currentDirName:0:counterOfDirletter}" #  Подстрока до вставки новой буквы
        currentDirName="$tempDir${tempDir:length-1}${currentDirName:counterOfDirletter}"
        #  Вставка новой буквы и конкатенация со второй подстрокой
        let counterOfDirletter+=$counterOfDirStep
        if [[ $j -eq $countLettersInDirOrigin ]]; then #  Если вставили все возможные буквы, начинаем снова с первой
            counterOfDirletter=$counterOfDirStep
            let counterOfDirStep+=1 #  увеличиваем шаг, так как каждой буквы теперь на одну больше
            j=1
        fi

        checking_countDir $countDir
        if [[ result -eq 1 ]]; then
            break
        fi

    done
    randomCountDir=$(shuf -i 5-8 -n 1) #  обновление кол-ва подпапок для создания в след. папке

    checking_countDir $countDir
    if [[ result -eq 1 ]]; then
        break
    fi

done
