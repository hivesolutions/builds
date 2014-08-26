VERSION=${VERSION-8.35}

set -e

wget -q "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$VERSION.tar.gz"
tar -zxf "pcre-$VERSION.tar.gz"
rm -f "pcre-$VERSION.tar.gz"
cd pcre-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared --enable-static --disable-cpp
make && make install
