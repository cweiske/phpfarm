#!/bin/bash

extensions=$(ls -p | grep '/')
current_dir=$(pwd)

for extension in $extensions; do
    cd "${current_dir}/${extension}"
    make clean && phpize && ./configure && make && make install
done

