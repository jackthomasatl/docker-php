# jackthomasatl/docker-php:7.3.8-fpm-dev

FROM jackthomasatl/docker-php:7.3.8-fpm

COPY ./scripts/* /opt/docker/scripts/

# Php Modules
RUN /bin/bash /opt/docker/scripts/build_php_pecl_dev_libs.sh
RUN /bin/bash /opt/docker/scripts/install_dev_utils.sh

# Move configs in
COPY ./config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Install Dev Utils
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN /bin/bash /opt/docker/scripts/install_dev_utils.sh
COPY ./tools /opt/docker/tools
ENV PATH="/opt/docker/tools:${PATH}"
