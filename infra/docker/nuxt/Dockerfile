FROM node:14.4.0-alpine

ARG CONTAINER_PORT

ENV HOME=/var/www/front \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0

WORKDIR /var/www/front

EXPOSE ${CONTAINER_PORT}