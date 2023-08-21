#!bin/bash

# Сборка изображения
docker build -t abalonef:part5 .

# brew install goodwithtech/r/dockle
dockle --accept-key NGINX_GPGKEY abalonef:part5

# Сборка контейнера
docker run -d -p 80:81 abalonef:part5

ContainerID=$(docker ps | awk '/abalonef/ {print $1}')
ImageID=$(docker images | awk '/abalonef/ {print $3}')

# Удаление созданных контейнеров и изображений
docker stop $ContainerID
docker rm $ContainerID
docker rmi $ImageID

exit 1