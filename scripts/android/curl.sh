VERSION=${VERSION-7.29.0}

wget -q "http://curl.haxx.se/download/curl-$VERSION.tar.gz"
tar -zxf "curl-$VERSION.tar.gz"
rm -f "curl-$VERSION.tar.gz"
cd curl-$VERSION

export PATH=$PREFIX/bin:$PATH
export CFLAGS="-O3"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib\
    -R$PREFIX/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared --enable-ipv6 --with-ssl --with-zlib
make && make install
