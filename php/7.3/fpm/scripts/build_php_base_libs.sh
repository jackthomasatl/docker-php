#!/bin/bash

if [ -n "$HTTP_PROXY" ]; then
    pear config-set http_proxy "$HTTP_PROXY"
fi

# Possible: bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip
BASE_PHP_MODULES=(
  'bz2' \                           ## Compression library
  'ctype' \                         ## Character typing library (required by symfony)
  'curl' \                          ## Http library
  'fileinfo' \                      ## File meta data library / magic mime support
  'gd' \                            ## Image transform library
  'gettext' \                       ## Language transform library
  'hash' \                          ## Hashing library
  'iconv' \                         ## ? (required by symfony)
  'json' \                          ## json encode/decode
  'mbstring' \                      ## Multi byte string encoding library (UTF-8) (required by symfony)
  'opcache' \                       ## Byte code opcache (required by symfony)
  'pcntl' \                         ## Process control library - allows us to fork a php process for search indexing / cache operations
  'pdo' 'pdo_mysql' 'pdo_sqlite' \  ## Database connector + mysql / sqlite support
  'posix' \                         ## Posix process information library (required by symfony)
  'pspell' \                        ## Spell check
  'session' \                       ## Session management
  'tokenizer' \                     ## File analyzation library (required by symfony)
  'xml' \                           ## Xml encode/decode (required by symfony)
  'zip' \                           ## Compression library
)

BZ2_LIBS='libbz2-dev'
CURL_LIBS='curl libcurl4 libcurl4-gnutls-dev'
GD_LIBS='libgd-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev'
PDO_LIBS='libldb-dev freetds-dev libsybdb5 libpq-dev'
PSPELL_LIBS='libpspell-dev'
SQLITE_LIBS='sqlite3 libsqlite3-dev'
XML_LIBS='libxml2-dev ' #Soap too
ZIP_LIBS='zip unzip libzip-dev'

echo "Installing dependencies: "
apt-get update \
  && apt-get install -q -y --no-install-recommends \
    $BZ2_LIBS \
    $CURL_LIBS \
    $GD_LIBS \
    $PDO_LIBS \
    $PSPELL_LIBS \
    $SQLITE_LIBS \
    $XML_LIBS \
    $ZIP_LIBS

for module_name in "${BASE_PHP_MODULES[@]}"; do
  echo -e "\n\n\n\n\n"
  echo "PHP EXT Install: $module_name";

  ## preconditions
  case "$module_name" in

    'gd')
      docker-php-ext-configure "$module_name" \
          --with-gd \
          --with-webp-dir \
          --with-jpeg-dir \
          --with-png-dir \
          --with-zlib-dir \
          --with-xpm-dir \
          --with-freetype-dir \
          --enable-gd-native-ttf
      ;;

  esac

  ## compile
  case "$module_name" in

    *)
      docker-php-ext-install -j$(nproc) "$module_name"
      ;;

  esac

  ## error?
  if [ "$?" -gt 0 ]; then
    echo "Failed to install $module_name"
    exit 1
  fi
done
