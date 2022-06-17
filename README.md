## Docker php56-fpm image

Docker php56-fpm image, based on alpine image.

- Alpine
- PHP 5.6.4
- GD Support
- Memchache 2.2.4 support
- Memchached 2.2.0 support
- Redis 4.3.0 support

## How to use?

DockerHub repository: https://hub.docker.com/r/johnnyworks/php56-fpm

You can set your website up by using `docker-compose`

Here is sample of **docker-compose.yml**

```
version: '3.7'
services:
  nginx:
    image: johnnyworks/nginx:alpine
    restart: always
    container_name: my-nginx
    ulimits:
      nofile:
        soft: 10240
        hard: 10240
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - ./www:/data
      - ./conf:/etc/nginx/conf.d
    logging:
      driver: 'json-file'
      options:
        max-file: '2'
        max-size: '2m'
    networks:
      - default
  php:
    image: johnnyworks/php56-fpm:alpine
    restart: always
    container_name: my-php-fpm
    ulimits:
      nofile:
        soft: 10240
        hard: 10240
    volumes:
      - ./www:/data
      - ./php.ini:/usr/local/etc/php/php.ini
      - ./phpfpm.conf:/usr/local/etc/php-fpm.d/www.conf
    logging:
      driver: 'json-file'
      options:
        max-file: '2'
        max-size: '2m'
    networks:
      - default
networks:
  default:
```

Put correspond files to following path

- conf/nginx.conf
- php.ini
- phpfpm.conf

and `www` folder for web root.

then using commands to start your web server.

```
# docker-compose up -d
```
