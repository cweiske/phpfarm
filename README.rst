phpfarm
=======

Set of scripts to install a dozen of PHP versions in parallel on a system.
It also creates a Pyrus installation for each PHP version.
Primarily developed for PEAR's continuous integration machine.

The PHP source packages are fetched from ``museum.php.net`` (which is not
always up-to-date), the official php.net download pages and the
pre-release channels.
If a file cannot be found, try to fetch it manually and put it into
``src/bzips/``


Setup
-----
- Check out phpfarm from git:
  ``git clone git://git.code.sf.net/p/phpfarm/code phpfarm``
- ``cd phpfarm/src/``
- ``./compile.sh 5.3.0``
- PHP gets installed into ``phpfarm/inst/php-$version/``
- ``phpfarm/inst/bin/php-$version`` is also executable.
  You should add ``inst/bin`` to your ``$PATH``, i.e.
  ``PATH="$PATH:$HOME/phpfarm/inst/bin"`` in ``.bashrc``,
  as well as ``inst/current-bin``.


Customization
-------------
Default configuration options are in ``src/options.sh``.
You may create version-specific custom option files:

- ``custom-options.sh``
- ``custom-options-5.sh``
- ``custom-options-5.3.sh``
- ``custom-options-5.3.1.sh``

The shell script needs to define a variable "``$configoptions``" with
all ``./configure`` options.
Do not try to change ``prefix`` and ``exec-prefix``.

``php.ini`` values may also be customized:

- ``custom-php.ini``
- ``custom-php-5.ini``
- ``custom-php-5.3.ini``
- ``custom-php-5.3.1.ini``


Switching default PHP versions
------------------------------
Using the command ``switch-phpfarm``, you can make one of the installed
PHP versions the default one that gets run when just typing ``php``::

    $ switch-phpfarm
    Switch the currently active PHP version of phpfarm
    Available versions:
     5.2.17
     5.3.16
     5.4.6
    $ switch-phpfarm 5.4.6
    Setting active PHP version to 5.4.6
    PHP 5.4.6 (cli) (built: Sep 13 2012 11:24:56) (DEBUG)

You need to have ``inst/current-bin`` in your ``$PATH`` to make this work.



About phpfarm
-------------
Written by Christian Weiske, cweiske@cweiske.de

Homepage: https://sourceforge.net/p/phpfarm

Licensed under the `AGPL v3`__ or later.

__ http://www.gnu.org/licenses/agpl
