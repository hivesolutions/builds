VERSION=${VERSION-1.2.8}

set -e +h

wget "http://zlib.net/zlib-$VERSION.tar.gz"
tar -zxf "zlib-$VERSION.tar.gz"
rm -f "zlib-$VERSION.tar.gz"
cd zlib-$VERSION

export PATH=$PREFIX/bin:$PATH
export CC=$HOST-gcc
./configure --prefix=$PREFIX --static
make && make install
