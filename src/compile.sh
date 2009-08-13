#!/bin/sh
version=$1
#directory of this file. all php srces are extrated in it
basedir="`dirname "$0"`"
#directory of php sources of specific version
srcdir="php-$version"
#directory with source archives
bzipsdir='bzips'
#directory phps get installed into
instbasedir="$basedir/../inst"
#directory this specific version gets installed into
instdir="$instbasedir/php-$version"


cd "$basedir"

#we need a php version
if [ "x$version" = 'x' ]; then
    echo 'Please specify php version'
    exit 1
fi


#already extracted?
if [ ! -d "$srcdir" ]; then
    echo 'Source directory does not exist; trying to extract'
    srcfile="$bzipsdir/php-$version.tar.bz2"
    if [ ! -f "$srcfile" ]; then
        #FIXME: fetch from museum
        echo 'Source file not found:'
        echo "$srcfile"
        exit 2
    fi
    #extract
    tar xjvf "$srcfile"
fi


source 'options.sh'
cd "$srcdir"
#configuring
#TODO: do not configure when config.nice exists
./configure \
 --prefix="$instdir" \
 --exec-prefix="$instdir" \
 --program-suffix="$version" \
 --enable-debug \
 --disable-short-tags \
 $configoptions
#TODO: source other options
#TODO: check if configure worked
#TODO: make
#TODO: make test
#TODO: make install
