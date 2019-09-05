#!/bin/bash

if [ -n "$HTTP_PROXY" ]; then
    pear config-set http_proxy "$HTTP_PROXY"
fi

PECL_PHP_MODULES=(
  'xdebug'            ## xDebug support for development, do not include in production
)

echo "Installing dependencies: "
for module_name in "${PECL_PHP_MODULES[@]}"; do
  echo -e "\n\n\n\n\n"
  echo "PECL EXT Install: $module_name";

  pecl_module_name="$module_name"

  case "$module_name" in

  esac

  pecl -v install "$pecl_module_name" \
    && docker-php-ext-enable "$module_name"

  ## error?
  if [ "$?" -gt 0 ]; then
    echo "Failed to install $module_name"
    exit 1
  fi
done
