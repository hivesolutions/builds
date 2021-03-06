VERSION=${VERSION-2.7.3}

set -e +h

wget "http://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz"
tar -zxf "Python-$VERSION.tgz"
rm -f "Python-$VERSION.tgz"
cd Python-$VERSION

CFLAGS="-O2" ./configure
mkdir -p Parser
make python Parser/pgen
mv python hostpython
mv Parser/pgen Parser/hostpgen
make distclean

wget "https://raw.github.com/hivesolutions/patches/master/python/Python-$VERSION-xcompile.patch"
patch -p1 < Python-$VERSION-xcompile.patch
rm -f "Python-$VERSION-xcompile.patch"

export PATH=$PATH:$PREFIX/bin

CC=$HOST-gcc CXX=$HOST-g++ AR=$HOST-ar RANLIB=$HOST-ranlib\
    ./configure --host=$HOST --build=$BUILD --prefix=$PREFIX --enable-shared

make HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$HOST-gcc -shared"\
    CROSS_COMPILE=$HOST- CROSS_COMPILE_TARGET=yes HOSTARCH=$HOST BUILDARCH=$BUILD

make install HOSTPYTHON=./hostpython BLDSHARED="$HOST-gcc -shared"\
    CROSS_COMPILE=$HOST- CROSS_COMPILE_TARGET=yes prefix=$PREFIX

rm -rf Parser
rm -f python
