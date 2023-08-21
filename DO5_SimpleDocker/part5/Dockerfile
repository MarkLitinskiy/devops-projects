FROM nginx:latest
USER root
RUN apt-get update && apt-get -y install libfcgi-dev spawn-fcgi gcc && \
    rm -rf /var/lib/apt/lists && mkdir /part4/
WORKDIR /part4/
COPY main.c /part4/
COPY nginx/nginx.conf /etc/nginx/
RUN gcc /part4/main.c -o main.fcgi -lfcgi && \
    useradd -d /home/abalonef -m -s /bin/bash abalonef && \
    usermod -aG adm,root,nginx abalonef && \
    chown -R abalonef:abalonef /etc/nginx/nginx.conf && \
    chown -R abalonef:abalonef /var/cache/nginx && \
    chown -R abalonef:abalonef /home && \
    touch /var/run/nginx.pid && \
    chown -R abalonef:abalonef /var/run/nginx.pid
USER abalonef
CMD spawn-fcgi -p 8080 ./main.fcgi && nginx -g "daemon off;"