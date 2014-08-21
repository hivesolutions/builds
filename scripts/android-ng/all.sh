set +e

rm -rf build
mkdir build
cd build

export CNAME=android-ng

../../rasp/deps.sh
../../rasp/cross.sh

source ../base.sh

../../rasp/bin.sh
../../rasp/openssl.sh
../../rasp/pcre.sh
../../rasp/zlib.sh
../../rasp/zip.sh
../../rasp/bz2.sh
../../rasp/libpng.sh
../../rasp/libjpeg.sh
../../rasp/freetype.sh
../../rasp/ncurses.sh
../../rasp/readline.sh
../../rasp/gmp.sh
../../rasp/curl.sh
../../rasp/python.sh
../../rasp/lua.sh
../../rasp/libxml2.sh
../../rasp/php.sh
