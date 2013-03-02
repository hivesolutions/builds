VERSION="5.1.1"

wget -q "ftp://ftp.gmplib.org/pub/gmp-$VERSION/gmp-$VERSION.tar.bz2"
tar -jxf "gmp-$VERSION.tar.bz2"
rm -f "gmp-$VERSION.tar.bz2"
cd gmp-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
./configure --host=arm-rasp-linux-gnueabi --build=arm --prefix=/opt/arm-rasp-linux-gnueabi
make && make install
