export CFLAGS="-O3 -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s"
export HOST="arm-rasp-linux-gnueabi"
export CROSS="arm-rasp-linux-"
export BUILD="arm"
export PREFIX=/opt/$HOST
export MAKEFLAGS="-j 4"
