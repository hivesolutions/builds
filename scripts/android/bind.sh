VERSION=${VERSION-9.10.1}

set -e +h

wget "ftp://ftp.isc.org/isc/bind9/$VERSION/bind-$VERSION.tar.gz"
tar -zxf "bind-$VERSION.tar.gz"
rm -f "bind-$VERSION.tar.gz"
cd bind-$VERSION

wget "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PATH:$PREFIX/bin
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared --enable-static
make && make install
