rm -rf build
mkdir build
cd build

../cross.sh

export CFLAGS="-O3 -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s"
export HOST="arm-rasp-linux-gnueabi"
export CROSS="arm-rasp-linux-"
export BUILD="arm"
export PREFIX=/opt/$HOST

../bin.sh
../openssl.sh
../pcre.sh
../zlib.sh
../zip.sh
../bz2.sh
../libpng.sh
../libjpeg.sh
../freetype.sh
../ncurses.sh
../readline.sh
../gmp.sh
../curl.sh
../python.sh
../lua.sh
../libxml2.sh
../php.sh
