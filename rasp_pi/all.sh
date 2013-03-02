rm -rf build
mkdir build
cd build

../cross.sh

export CFLAGS="-O3"

../openssl.sh
../pcre.sh
../ncurses.sh
../readline.sh
../gmp.sh
../python.sh
../lua.sh
../libxml2.sh
../php.sh
