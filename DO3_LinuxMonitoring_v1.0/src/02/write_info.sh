#! /bin/bash

echo "Do you wanna to write info? (Y/N)"
read ANSWER
if [[ $ANSWER == y ]] || [[ $ANSWER == Y ]]; then 
date=$(date +"%d_%m_%Y_%H_%M_%S")
./info.sh >> $date.status
echo "Writed to $date.status"
exit 1
else exit 1
fi