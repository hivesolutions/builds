VERSION=${VERSION-2.9.0}

set -e +h

wget "http://xmlsoft.org/sources/libxml2-$VERSION.tar.gz"
tar -zxf "libxml2-$VERSION.tar.gz"
rm -f "libxml2-$VERSION.tar.gz"
cd libxml2-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared
make && make install
