#!/bin/bash

version=$1
phpize_location="../../inst/bin/phpize-${version}"
php_config="../../inst/bin/php-config-${version}"

if [[ ${version} == '' ]]; then
    phpize_location='phpize'
    php_config='php-config'
fi

extensions=$(ls -p | grep '/')
current_dir=$(pwd)

for extension in $extensions; do
    cd "${current_dir}/${extension}"
    make clean && ${phpize_location} && ./configure --with-php-config=${php_config} && make && make install
done

