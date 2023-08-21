#! /bin/bash

if [[ ! -z $1 ]]; then # есть первый параметр
echo "Parameters can not be!"; exit 1
else
./info.sh
./write_info.sh
fi