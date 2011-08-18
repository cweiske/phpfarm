#!/bin/bash
#install pyrus specific to the given php version
# automatically tries to download latest pyrus version if
# there is none in bzips/

if [ $# -lt 2 ] ; then
    echo "pass version and PHP installation directory as parameters"
    exit 1
fi

version="$1"
instdir="$2"

if [ ! -d "$instdir" ]; then
    echo "PHP installation directory does not exist: $instdir"
    exit 2
fi

pwd=`pwd`
cd "`dirname "$0"`"
basedir=`pwd`
cd "$pwd"

pyrusphar="$basedir/bzips/pyrus.phar"
pyrustarget="$instdir/pyrus.phar"
if [ ! -f "$pyrusphar" ]; then
    #download pyrus from svn
    wget -O "$pyrusphar"\
        "http://pear2.php.net/pyrus.phar"
fi
if [ ! -f "$pyrusphar" ]; then
    echo "Please put pyrus.phar into bzips/"
    exit 3
fi

cp "$pyrusphar" "$pyrustarget"
mkdir -p "$instdir/pear"

pyrusbin="$instdir/bin/pyrus"
echo '#!/bin/sh'> "$pyrusbin"
echo "\"$instdir/bin/php\" \"$pyrustarget\" \"$instdir/pear\" \$@ " >> "$pyrusbin"
chmod +x "$pyrusbin"
"$pyrusbin" set php_prefix "$instdir/bin/"

#symlink
ln -sf "$pyrusbin" "$instdir/../bin/pyrus-$version"

echo "include_path=\".:$instdir/pear/php/\"" >> "$instdir/lib/php.ini"
