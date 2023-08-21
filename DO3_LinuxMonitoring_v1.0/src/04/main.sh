#! /bin/bash

value_names_back='1'  # дефолтная конфигурация
value_names_font='2'
values_back='3'
values_font='4'

count_str=$(wc -l < colors.conf)  # подсчёт количества строк в файле конфигурации
count_str=$(( $count_str + 1 ))

if [ "$count_str" -gt 4 ]; then  # если в файле > 4 строк
echo "Error in configuration file!"; exit 1
elif [ "$count_str" -lt 4 ]; then  # если в файле < 4 строк
count_str="-1"
fi

if [[ $count_str -ne -1 ]]; then  # парсинг из файла если там 4 строки
value_names_back=$(grep column1_background colors.conf | awk '/column1_background/ {print substr($0,length,1)}')
value_names_font=$(grep column1_font_color colors.conf | awk '/column1_font_color/ {print substr($0,length,1)}')
values_back=$(grep column2_background colors.conf | awk '/column2_background/ {print substr($0,length,1)}')
values_font=$(grep column2_font_color colors.conf | awk '/column2_font_color/ {print substr($0,length,1)}')
fi

./check_parameters.sh $value_names_back $value_names_font $values_back $values_font
echo ""
./print_configuration.sh $value_names_back $value_names_font $values_back $values_font $count_str exit 1
