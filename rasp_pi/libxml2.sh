VERSION="2.9.0"

wget -q "http://xmlsoft.org/sources/libxml2-$VERSION.tar.gz"
tar -zxf "libxml2-$VERSION.tar.gz"
rm -f "libxml2-$VERSION.tar.gz"
cd libxml2-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
export CFLAGS="-O3"
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi
make && make install
