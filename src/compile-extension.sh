#!/bin/sh
# @see http://cweiske.de/tagebuch/phpfarm-install-extensions.htm
# @example ./compile-extension.sh xdebug 5.4.3

EXTENSION=$1
PHPVERSION=$2

mkdir src/extensions
rm -rf src/extensions/*
pecl download $EXTENSION
tar xvzf $EXTENSION*
cd $EXTENSION*
/opt/phpfarm/inst/bin/phpize-$PHPVERSION
./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-$PHPVERSION
make
make install
