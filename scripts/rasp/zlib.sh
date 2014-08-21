VERSION=${VERSION-1.2.7}

wget -q "http://zlib.net/fossils/zlib-$VERSION.tar.gz"
tar -zxf "zlib-$VERSION.tar.gz"
rm -f "zlib-$VERSION.tar.gz"
cd zlib-$VERSION

export PATH=$PREFIX/bin:$PATH
export CC=$HOST-gcc
./configure --prefix=$PREFIX --static --shared
make && make install
