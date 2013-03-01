VERSION="6.2"

wget -q "ftp://ftp.cwru.edu/pub/bash/readline-$VERSION.tar.gz"
tar -zxf "readline-$VERSION.tar.gz"
rm -f "readline-$VERSION.tar.gz"
cd readline-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi
make && make install
