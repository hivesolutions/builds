VERSION=${VERSION-9.10.1}

set -e +h

wget "ftp://ftp.isc.org/isc/bind9/$VERSION/bind-$VERSION.tar.gz"
tar -zxf "bind-$VERSION.tar.gz"
rm -f "bind-$VERSION.tar.gz"
cd bind-$VERSION

wget "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PATH:$PREFIX/bin
BUILD_CC=$PREFIX/bin/$HOST-gcc ./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared --enable-static --without-openssl\
    --without-gssapi --with-libxml2=$PREFIX\
    --with-randomdev=/dev/random
make && make install
