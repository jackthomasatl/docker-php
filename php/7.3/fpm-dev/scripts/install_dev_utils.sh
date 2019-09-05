#!/bin/bash

export COMPOSER_ALLOW_SUPERUSER=1

apt-get update \
  && apt-get install -q -y --no-install-recommends \
    vim \
    wget \
    mariadb-client \
    pv \
    git \
    openssh-client

## Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /usr/bin/composer

## Node
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
