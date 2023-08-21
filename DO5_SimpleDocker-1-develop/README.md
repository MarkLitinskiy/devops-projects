# Simple Docker

1. [Готовый докер](#part-1-готовый-докер)
2. [Операции с контейнером](#part-2-операции-с-контейнером)
3. [Мини веб-сервер](#part-3-мини-веб-сервер)
4. [Свой докер](#part-4-свой-докер)
5. [Dockle](#part-5-dockle)
6. [Базовый Docker Compose](#part-6-базовый-docker-compose)

## Part 1. Готовый докер.
***
*  **Взять официальный докер образ с nginx и выкачать его при помощи `docker pull`**
    ![docker pull](part1/pt1.png)  
*  **Проверить наличие докер образа через `docker images`**
    ![docker images](part1/pt2.png)  
*  **Запустить докер образ через `docker run -d [image_id|repository]`**
    ![docker run](part1/pt3.png)  
*  **Проверить, что образ запустился через `docker ps`**
    ![docker ps](part1/pt4.png)  
*  **Посмотреть информацию о контейнере через `docker inspect [container_id|container_name]`**
    ![docker inspect](part1/pt5.png)  
*  **По выводу команды определить и поместить в отчёт размер контейнера, список замапленных портов и ip контейнера**
    Размер контейнера: 142151046;  
    Список замапленных портов: 80/tcp;  
    IP контейнера: 172.17.0.2;  
*  **Остановить докер образ через `docker stop [container_id|container_name]`**
    ![docker stop](part1/pt6.png)  
*  **Проверить, что образ остановился через `docker ps`**
    ![docker ps](part1/pt7.png)  
*  **Запустить докер с портами** *80* **и** *443* **в контейнере, замапленными на такие же порты на локальной машине, через команду `run`**
    ![docker run](part1/pt8.png)  
*  **Проверить, что в браузере по адресу `localhost:80` доступна стартовая страница** *nginx*
    ![localhost:80](part1/pt9.png)  
*  **Перезапустить докер контейнер через `docker restart [container  _id|container_name]`**
    ![docker restart](part1/pt10.png)  
*  **Проверить любым способом, что контейнер запустился**
    ![docker running](part1/pt11.png)  
***
## Part 2. Операции с контейнером.
*  **Прочитать конфигурационный файл** *nginx.conf* **внутри докер контейнера через команду `exec`**
    ![exec](part2/pt2.1.png)  
*  **Создать на локальной машине файл** *nginx.conf* **и Настроить в нем по пути /status отдачу страницы статуса сервера** *nginx*
    ![nginx.conf](part2/pt2.2.png)  
*  **Скопировать созданный файл** *nginx.conf* **внутрь докер образа через команду `docker cp`**
*  **Перезапустить** *nginx* **внутри докер образа через команду `exec`**
    ![docker cp & exec](part2/pt2.3.png)   
*  **Проверить, что по адресу** *localhost:80/status* **отдается страничка со статусом сервера** *nginx*
    ![localhost:80/status](part2/pt2.4.png)  
*  **Экспортировать контейнер в файл** *container.tar* **через команду `export`**
    ![docker export](part2/pt2.5.png)  
*  **Остановить контейнер**
    ![docker stop](part2/pt2.6.png)  
*  **Удалить образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры**
    ![docker rmi](part2/pt2.7.png)  
*  **Импортировать контейнер обратно через команду `import`**
`docker export e49a04868cf2 > container.tar`  
*  **Запустить импортированный контейнер**
*  **Проверить, что по адресу** *localhost:80/status* **отдается страничка со статусом сервера** *nginx*
    ![localhost:80/status](part2/pt2.8.png)
***
## Part 3. Мини веб-сервер.
*   **Написать мини сервер на** *C* **и** *FastCgi* **, который будет возвращать простейшую страничку с надписью** *Hello World!*
    ![mini web server](part3/img/pt3.1.png)  
*   **Запустить написанный мини сервер через `spawn-fcgi` на порту 8080**
    Создаём докер контейнер nginx и пробрасываем порт 81:  
    `docker run -d -p 81:81 nginx`  
    Установка необходимых библиотек:  
    `docker exec 0b51e8126762 apt-get -y install libfcgi-dev`  
    `docker exec 0b51e8126762 apt-get install spawn-fcgi`  
    `docker exec 0b51e8126762 apt-get -y install gcc`  
    Копирование файла .с в Докер контейнер:  
    `docker cp main.c 0b51e8126762:/main.c`  
    Компиляция файла в .fcgi:  
    `docker exec 0b51e8126762 gcc main.c -o main.fcgi -lfcgi`  
    Запуск fcgi сервера на порту 8080:  
    `spawn-fcgi -p 8080 -n main.fcgi`

*   **Написать свой** *nginx.conf* **, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080**
    ![nginx.conf](part3/img/pt3.2.png)  
    Копирование файла в докер:  
    `docker cp nginx/nginx.conf 0b51e8126762:etc/nginx`
*   **Проверить, что в браузере по** *localhost:81* **отдается написанная вами страничка**
    ![localhost:81](part3/img/pt3.3.png)  
***
## Part 4. Свой докер.
* **Написать свой докер образ**
    Текущий докер-образ:  
    - Собирает исходники мини сервера на FastCgi из Part 3;  
    - Запускает его на 8080 порту;
    - копирует внутрь образа написанный ./nginx/nginx.conf;
    - запускает nginx.  
    ![DockerFile](part4/img/pt4.1.png)
* **Собрать написанный докер образ через docker build при этом указав имя и тег**
    `docker build -t abalonef/part4 .`  
* **Проверить через docker images, что все собралось корректно**
    ![Docker images](part4/img/pt4.2.png)  
* **Запустить собранный докер образ с маппингом 81 порта на 80 на локальной машине и маппингом папки ./nginx внутрь контейнера по адресу, где лежат конфигурационные файлы nginx'а**
    ![run.sh](part4/img/pt4.3.png)
* **Проверить, что по localhost:80 доступна страничка написанного мини сервера**
    ![localhost](part4/img/pt4.4.png)
* **Дописать в ./nginx/nginx.conf проксирование странички /status, по которой надо отдавать статус сервера nginx**
* **Перезапустить докер образ**
* **Проверить, что теперь по localhost:80/status отдается страничка со статусом nginx**
    ![localhost](part4/img/pt4.5.png)
***
## Part 5. Dockle.
* **Просканировать образ из предыдущего задания через `dockle [image_id|repository]`**
    `dockle -ak NGINX_GPGKEY abalonef:part5`  
    ![dockle](part5/img/pt5.1.png)  
* **Исправить образ так, чтобы при проверке через dockle не было ошибок и предупреждений**
    Был добавлен новый пользователь с присвоенным доступом к нужным папкам. Также очистка кэша обнавлений.  
    ![dockle](part5/img/pt5.2.png)  
    ![dockle](part5/img/pt5.3.png)
***
## Part 6. Базовый Docker Compose.
* **Написать файл `docker-compose.yml`, с помощью которого:**
    - Поднять докер контейнер из Part 5 (он должен работать в локальной сети, т.е. не нужно использовать инструкцию EXPOSE и мапить порты на локальную машину);  
    - Поднять докер контейнер с nginx, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера;
         ![nginx](part6/img/pt6.1.png)
* **Замапить 8080 порт второго контейнера на 80 порт локальной машины**
    *Файл docker-compose.yml*:  
    ![yml](part6/img/pt6.3.png)
* **Собрать и запустить проект с помощью команд docker-compose build и docker-compose up**
    ![docker compose](part6/img/pt6.2.png)
* **Проверить, что в браузере по localhost:80 отдается написанная вами страничка, как и ранее**
    ![localhost](part6/img/pt6.4.png)
