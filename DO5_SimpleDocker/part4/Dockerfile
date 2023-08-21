FROM nginx:latest
RUN apt-get update && apt-get -y install libfcgi-dev spawn-fcgi gcc && rm -rf /var/lib/apt/lists && mkdir /part4/
WORKDIR /part4/
COPY main.c /part4/
COPY nginx/nginx.conf /etc/nginx/
RUN gcc /part4/main.c -o main.fcgi -lfcgi
CMD spawn-fcgi -p 8080 ./main.fcgi && nginx -g "daemon off;"