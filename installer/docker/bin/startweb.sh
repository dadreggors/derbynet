#!/bin/bash

#php-fpm81 && chmod 777 /var/run/php-fpm.sock && nginx -g 'daemon off'
php-fpm81 && nginx -g 'daemon off;'