VERSION=${VERSION-9.5.2}

wget -q "http://ftp.isc.org/isc/bind9/$VERSION/bind-$VERSION.tar.gz"
tar -zxf "bind-$VERSION.tar.gz"
rm -f "bind-$VERSION.tar.gz"
cd bind-$VERSION

wget -q "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --enable-static --enable-libbind --disable-atomic\
    --disable-linux-caps --enable-threads
make && make install
