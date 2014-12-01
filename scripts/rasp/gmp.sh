VERSION=${VERSION-5.1.1}

set -e +h

wget "ftp://ftp.gmplib.org/pub/gmp-$VERSION/gmp-$VERSION.tar.bz2"
tar -jxf "gmp-$VERSION.tar.bz2"
rm -f "gmp-$VERSION.tar.bz2"
cd gmp-$VERSION

export PATH=$PATH:$PREFIX/bin
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared
make && make install
