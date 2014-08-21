export TOOLCHAIN="android-toolchain"
export HOST="arm-linux-androideabi"
export CROSS="arm-linux-"
export BUILD="arm"
export PREFIX=/opt/$TOOLCHAIN
export CFLAGS="-O3 -L$PREFIX/lib -I$PREFIX/include"
