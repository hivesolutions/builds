VERSION=${VERSION-1.2.7.3}

set -e +h

wget "http://zlib.net/fossils/zlib-$VERSION.tar.gz"
tar -zxf "zlib-$VERSION.tar.gz"
rm -f "zlib-$VERSION.tar.gz"
cd zlib-$VERSION

export PATH=$PATH:$PREFIX/bin
export CC=$HOST-gcc
./configure --prefix=$PREFIX --static
make && make install
