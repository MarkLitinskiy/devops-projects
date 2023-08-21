#!bin/bash

docker compose build
docker compose up
ServerAnswer=$(curl 127.0.0.1:80)
curl 127.0.0.1:80
if [[ $ServerAnswer == "Hello World!" ]]
then 
echo "\033[42m\033[30m SUCCSESS! \033[0m"
else 
echo "\033[41m ERROR! \033[0m"
fi
echo "\033[45m\033[30mlocalhost:80/status:\033[0m"
echo "\033[32m $Status \033[0m" 

Container1ID=$(docker ps | awk '/part5/ {print $1}')
Container2ID=$(docker ps | awk '/nginx/ {print $1}')
ImageID=$(docker images | awk '/part6/ {print $3}')

# Удаление созданных контейнеров и изображений
docker stop $Container1ID
docker stop $Container2ID
docker rm $Container1ID
docker rm $Container2ID
docker rmi $ImageID

exit 1