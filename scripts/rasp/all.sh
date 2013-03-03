rm -rf build
mkdir build
cd build

../cross.sh

export CFLAGS="-O3 -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s"
export HOST="arm-rasp-linux-gnueabi"
export CROSS="arm-rasp-linux-"
export BUILD="arm"
export PREFIX=/opt/$HOST

../openssl.sh
../pcre.sh
../ncurses.sh
../readline.sh
../gmp.sh
../python.sh
../lua.sh
../libxml2.sh
../php.sh
