VERSION=${VERSION-6.0}

wget -q "http://ftp.isc.org/isc/libbind/$VERSION/libbind-$VERSION.tar.gz"
tar -zxf "libbind-$VERSION.tar.gz"
rm -f "libbind-$VERSION.tar.gz"
cd libbind-$VERSION

wget -q "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --enable-static --enable-threads
make && make install
