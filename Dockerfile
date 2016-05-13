FROM rhel7:latest

USER root

MAINTAINER Shah_Zobair

ENV NGINX_VERSION 1.9.2-1.el7.ngx

ADD nginx.repo /etc/yum.repos.d/nginx.repo

RUN curl -sO http://nginx.org/keys/nginx_signing.key && \
    rpm --import ./nginx_signing.key && \
    yum install -y nginx-${NGINX_VERSION} && \
    yum clean all && \
    rm -f ./nginx_signing.key

# forward request and error logs to docker log collector
RUN chmod -R 777 /var/log/nginx /var/cache/nginx/
RUN chmod 644 /etc/nginx/*
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
