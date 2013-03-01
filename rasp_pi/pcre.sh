VERSION="8.32"

wget -q "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$VERSION.tar.gz"
tar -zxf "pcre-$VERSION.tar.gz"
rm -f "pcre-$VERSION.tar.gz"
cd pcre-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi\
    --disable-shared --enable-static --disable-cpp
make && make install
