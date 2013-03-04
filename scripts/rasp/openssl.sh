VERSION="1.0.1e"

wget -q "http://www.openssl.org/source/openssl-$VERSION.tar.gz"
tar -zxf "openssl-$VERSION.tar.gz"
rm -f "openssl-$VERSION.tar.gz"
cd openssl-$VERSION

export cross=$CROSS
export PATH=$PREFIX/bin:$PATH
./config --prefix=$PREFIX
./Configure dist --prefix=$PREFIX
make CC="$HOST-gcc" AR="$HOST-ar r" RANLIB="$HOST-ranlib"
make install