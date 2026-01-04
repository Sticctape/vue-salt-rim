#!/bin/sh

envsubst < /var/www/html/config.js.template > /var/www/html/config.js

exec nginx -g "daemon off;"
