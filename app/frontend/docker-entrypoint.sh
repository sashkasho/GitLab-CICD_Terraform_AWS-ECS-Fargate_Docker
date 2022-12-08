#!/usr/bin/env sh
set -eu

envsubst '${APP_ELB_DNS_NAME}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"