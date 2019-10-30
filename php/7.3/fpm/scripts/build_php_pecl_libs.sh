#!/bin/bash

if [ -n "$HTTP_PROXY" ]; then
    pear config-set http_proxy "$HTTP_PROXY"
fi

PECL_PHP_MODULES=(
  'apcu'              ## APC User Cache
  'imagick'           ## Image transform library
  'memcached'         ## Memcached driver
  'oauth'             ## Oauth client / server libraries
  'redis'             ## Redis driver
  'yaml'              ## Yaml encode/decode
)

IMAGICK_LIBS='libmagickwand-dev' #
MEMCACHED_LIBS='libmemcached-dev'
YAML_LIBS='libyaml-dev'

echo "Installing dependencies: "
apt-get update \
  && apt-get install -q -y --no-install-recommends \
    $IMAGICK_LIBS \
    $MEMCACHED_LIBS \
    $SQLITE_LIBS \
    $YAML_LIBS

for module_name in "${PECL_PHP_MODULES[@]}"; do
  echo -e "\n\n\n\n\n"
  echo "PECL EXT Install: $module_name";

  pecl_module_name="$module_name"

  case "$module_name" in

    'apcu')
        pecl_module_name = 'apcu-5.1.11';
        ;;

  esac

  pecl -v install "$pecl_module_name" \
    && docker-php-ext-enable "$module_name"

  ## error?
  if [ "$?" -gt 0 ]; then
    echo "Failed to install $module_name"
    exit 1
  fi
done
