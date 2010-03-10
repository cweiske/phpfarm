#!/bin/bash
#
# phpfarm
#
# Installs multiple versions of PHP beside each other.
# Both CLI and CGI versions are compiled.
# Sources are fetched from museum.php.net if no
# corresponding file bzips/php-$version.tar.bz2 exists.
#
# Usage:
# ./compile.sh 5.3.1
#
# You should add ../inst/bin to your $PATH to have easy access
# to all php binaries. The executables are called
# php-$version and php-cgi-$version
#
# In case the options in options.sh do not suit you or you just need
# different options for different php versions, you may create
# custom-options-$version.sh scripts that define a $configoptions
# variable. See options.sh for more details.
#
# Put pyrus.phar into bzips/ to automatically get version-specific
# pyrus/pear2 commands.
#
# Author: Christian Weiske <cweiske@php.net>
#

version=$1
vmajor=`echo ${version%%.*}`
vminor=`echo ${version%.*}`
vminor=`echo ${vminor#*.}`
vpatch=`echo ${version##*.}`
vcomp=`printf "%02d%02d%02d\n" $vmajor $vminor $vpatch`

#directory of this file. all php srces are extrated in it
basedir="`dirname "$0"`"
cd "$basedir"
basedir=`pwd`
#directory of php sources of specific version
srcdir="php-$version"
#directory with source archives
bzipsdir='bzips'
#directory phps get installed into
instbasedir="$basedir/../inst"
#directory this specific version gets installed into
instdir="$instbasedir/php-$version"
#directory where all bins are symlinked
shbindir="$instbasedir/bin"

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
        echo 'Source file not found:'
        echo "$srcfile"
        #FIXME: use php4 if version is that
        url="http://museum.php.net/php5/php-$version.tar.bz2"
	wget -P "$bzipsdir" "$url"
	if [ ! -f "$srcfile" ]; then
	    echo "Fetching source from museum failed:"
	    echo $url
            exit 2
	fi
    fi
    #extract
    tar xjvf "$srcfile"
fi


source 'options.sh' "$version" "$vmajor" "$vminor" "$vpatch"
cd "$srcdir"
#configuring
#TODO: do not configure when config.nice exists
./configure \
 --prefix="$instdir" \
 --exec-prefix="$instdir" \
 --enable-debug \
 --disable-short-tags \
 --without-pear \
 $configoptions

if [ $? -gt 0 ]; then
    echo configure.sh failed.
    exit 3
fi

#compile sources
#make clean
make

if [ "$?" -gt 0 ]; then
    echo make failed.
    exit 4
fi

make install
if [ "$?" -gt 0 ]; then
    echo make install failed.
    exit 5
fi

#copy php.ini
initarget="$instdir/lib/php.ini"
if [ -f "php.ini-development" ]; then
    #php 5.3
    cp "php.ini-development" "$initarget"
elif [ -f "php.ini-recommended" ]; then
    #php 5.1, 5.2
    cp "php.ini-recommended" "$initarget"
else
    echo "No php.ini file found."
    echo "Please copy it manually to $instdir/lib/php.ini"
fi
#set default ini values
cd "$basedir"
if [ -f "$initarget" ]; then
    #fixme: make the options unique or so
    custom="custom-php.ini"
    [ ! -f $custom ] && cp "default-custom-php.ini" "$custom"
    [ -f $custom ] && cat "$custom" >> "$initarget"
    custom="custom-php-$vmajor.ini"
    [ -f $custom ] && cat "$custom" >> "$initarget"
    custom="custom-php-$vmajor.$vminor.ini"
    [ -f $custom ] && cat "$custom" >> "$initarget"
    custom="custom-php-$vmajor.$vminor.$vpatch.ini"
    [ -f $custom ] && cat "$custom" >> "$initarget"
fi

#create bin
[ ! -d "$shbindir" ] && mkdir "$shbindir"
if [ ! -d "$shbindir" ]; then
    echo "Cannot create shared bin dir"
    exit 6
fi
#symlink all files

#php may be called php.gcno
bphp="$instdir/bin/php"
bphpgcno="$instdir/bin/php.gcno"
if [ -f "$bphp" ]; then 
    ln -fs "$bphp" "$shbindir/php-$version"
elif [ -f "$bphpgcno" ]; then
    ln -fs "$bphpgcno" "$shbindir/php-$version"
else
    echo "no php binary found"
    exit 7    
fi

#php-cgi may be called php.gcno
bphpcgi="$instdir/bin/php-cgi"
bphpcgigcno="$instdir/bin/php-cgi.gcno"
if [ -f "$bphpcgi" ]; then 
    ln -fs "$bphpcgi" "$shbindir/php-cgi-$version"
elif [ -f "$bphpcgigcno" ]; then
    ln -fs "$bphpcgigcno" "$shbindir/php-cgi-$version"
else
    echo "no php-cgi binary found"
    exit 8
fi

ln -fs "$instdir/bin/php-config" "$shbindir/php-config-$version"
ln -fs "$instdir/bin/phpize" "$shbindir/phpize-$version"

cd "$basedir"
./pyrus.sh "$version" "$instdir"
