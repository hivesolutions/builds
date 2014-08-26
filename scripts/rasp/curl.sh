VERSION=${VERSION-7.29.0}

set -e

wget -q "http://curl.haxx.se/download/curl-$VERSION.tar.gz"
tar -zxf "curl-$VERSION.tar.gz"
rm -f "curl-$VERSION.tar.gz"
cd curl-$VERSION

wget -q "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PREFIX/bin:$PATH
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib\
    -R$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -R$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib\
    -R$PREFIX/$HOST/sysroot/usr/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared --enable-ipv6 --with-ssl --with-zlib
make && make install
