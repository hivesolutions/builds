VERSION="1.0.1e"

wget -q "http://www.openssl.org/source/openssl-$VERSION.tar.gz"
tar -zxf "openssl-$VERSION.tar.gz"
rm -f "openssl-$VERSION.tar.gz"
cd openssl-$VERSION

export cross=arm-unknown-linux-
export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
./config --prefix=/opt/arm-unknown-linux-gnueabi
./Configure dist --prefix=/opt/arm-unknown-linux-gnueabi
make CC="arm-unknown-linux-gnueabi-gcc" AR="arm-unknown-linux-gnueabi-ar r"\
    RANLIB="arm-unknown-linux-gnueabi-ranlib"
make install
