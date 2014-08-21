VERSION=${VERSION-9.4.1}

wget -q "http://ftp.isc.org/isc/bind9/$VERSION/bind-$VERSION.tar.gz"
tar -zxf "bind-$VERSION.tar.gz"
rm -f "bind-$VERSION.tar.gz"
cd bind-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --enable-static --disable-shared --enable-libbind\
    --disable-atomic --disable-linux-caps --enable-threads
make && make install
