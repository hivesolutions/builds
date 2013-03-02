export CFLAGS="-O3"

rm -rf build
mkdir build
cd build

../cross.sh
../openssl.sh
../pcre.sh
../ncurses.sh
../readline.sh
../gmp.sh
../python.sh
../lua.sh
../libxml2.sh
../php.sh
