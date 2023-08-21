#!bin/bash

# Сборка контейнера и запуск
docker build -t abalonef:part5 .
docker run -d -p 80:81 abalonef:part5

#Проверка порта 80 (localhost:80) и localhost:80/status
sleep 2
ServerAnswer=$(curl 127.0.0.1:80)
Status=$(curl 127.0.0.1:80/status)
curl 127.0.0.1:80
if [[ $ServerAnswer == "Hello World!" ]]
then 
echo "\033[42m\033[30m SUCCSESS! \033[0m"
else 
echo "\033[41m ERROR! \033[0m"
fi
echo "\033[45m\033[30mlocalhost:80/status:\033[0m"
echo "\033[32m $Status \033[0m" 

ContainerID=$(docker ps | awk '/abalonef/ {print $1}')
ImageID=$(docker images | awk '/abalonef/ {print $3}')

# Удаление созданных контейнеров и изображений
docker stop $ContainerID
docker rm $ContainerID
docker rmi $ImageID

exit 1