#! /bin/bash

re='^[1-6]+$' # регулярное выражение для числа

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]] || [[ ! -z $5 ]]; then # если не 4 параметра
echo "Input error! There can be only four parameters!"; exit 1
elif [[ ! $1 =~ $re ]] || [[ ! $2 =~ $re ]] || [[ ! $3 =~ $re ]] || [[ ! $4 =~ $re ]]; then # если хоть один из параметров не число от 1-6
echo "Parameters can be only number (1-6)!"; exit 1
elif (( $1 == $2 )) || (( $3 == $4 )); then 
echo "The font and background colours of one column are match! Change your parameters and call the script again"; exit 1
else ./info.sh $1 $2 $3 $4 exit 1
fi