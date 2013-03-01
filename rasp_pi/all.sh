export CFLAGS="-O3"

rm -rf build
mkdir build
cd build

../cross.sh
../openssl.sh
../pcre.sh
../ncurses.sh
../readline.sh
../libxml2.sh
../gmp.sh
../php.sh
../python.sh
../lua.sh
