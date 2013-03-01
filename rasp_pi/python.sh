VERSION="2.7.3"

wget -q "http://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz"
tar -zxf "Python-$VERSION.tgz"
rm -f "Python-$VERSION.tgz"
cd Python-$VERSION

./configure
mkdir Parser
make python Parser/pgen
mv python hostpython
mv Parser/pgen Parser/hostpgen
make distclean

wget -q "https://raw.github.com/hivesolutions/patches/master/python/Python-$VERSION-xcompile.patch"
patch -p1 < Python-$VERSION-xcompile.patch
rm -f "Python-$VERSION-xcompile.patch"

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH

CC=arm-unknown-linux-gnueabi-gcc CXX=arm-unknown-linux-gnueabi-g++\
    AR=arm-unknown-linux-gnueabi-ar RANLIB=arm-unknown-linux-gnueabi-ranlib\
    ./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi --enable-shared 

make HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="arm-unknown-linux-gnueabi-gcc -shared"\
    CROSS_COMPILE=arm-unknown-linux-gnueabi- CROSS_COMPILE_TARGET=yes HOSTARCH=arm-unknown-linux-gnueabi BUILDARCH=arm

make install HOSTPYTHON=./hostpython BLDSHARED="arm-unknown-linux-gcc -shared"\
    CROSS_COMPILE=arm-unknown-linux-gnueabi- CROSS_COMPILE_TARGET=yes prefix=/opt/arm-unknown-linux-gnueabi

rm -rf Parser
rm -f python
