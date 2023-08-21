#! /bin/bash
start_script=`date +"%s%3N"`

lastsym==${1: -1}  # срез строки - последнего символа
if [[ -z $1 ]]; then # если первый параметр пустой
echo "Parameter is empty!"; exit 1
elif [[ ! -z $2 ]]; then # если есть второй параметр
echo "There can be only one parameter!"; exit 1
elif [[ ! "$lastsym" == '=/' ]]; then # если последний символ параметра не /
echo "The parameter must end with /!"; exit 1
else 
./total_number_of_folders.sh $1
./top_five_folders_with_largest_size.sh $1
./total_number_of_files.sh $1
./number_of_type_files.sh $1
./top_ten_files_with_largest_size.sh $1
./top_ten_executable_files_with_largest_size.sh $1
fi
end_script=`date +"%s%3N"`
sec=$(echo "${end_script} ${start_script}" | awk '{printf "%.1f", ($1 - $2)/1000}')

echo "Script execution time (in seconds) = $sec"