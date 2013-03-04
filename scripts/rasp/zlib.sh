VERSION="1.2.7"

wget -q "http://zlib.net/zlib-$VERSION.tar.gz"
tar -zxf "zlib-$VERSION.tar.gz"
rm -f "zlib-$VERSION.tar.gz"
cd zlib-$VERSION

export PATH=/opt/arm-rasp-linux-gnueabi/bin:$PATH
export CC=arm-rasp-linux-gnueabi-gcc
./configure --prefix=/opt/arm-rasp-linux-gnueabi --static
make && make install
