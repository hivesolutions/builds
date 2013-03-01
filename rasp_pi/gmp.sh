VERSION="5.1.1"

wget -q "ftp://ftp.gmplib.org/pub/gmp-$VERSION/gmp-$VERSION.tar.bz2"
tar -jxf "gmp-$VERSION.tar.bz2"
rm -f "gmp-$VERSION.tar.bz2"
cd gmp-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
export CFLAGS="-O3"
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi
make && make install
