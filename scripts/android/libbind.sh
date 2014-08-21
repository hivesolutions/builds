VERSION=${VERSION-6.0}

wget -q "http://ftp.isc.org/isc/libbind/$VERSION/libbind-$VERSION.tar.gz"
tar -zxf "libbind-$VERSION.tar.gz"
rm -f "libbind-$VERSION.tar.gz"
cd libbind-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --enable-static --enable-threads
make && make install
