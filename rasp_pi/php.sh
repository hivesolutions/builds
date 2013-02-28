VERSION="5.4.12"

wget -q "http://www.php.net/get/php-$VERSION.tar.gz/from/this/mirror" "--output-document=php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
export LDFLAGS="-ldl"
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi\
    -enable-embed=static --disable-libxml --disable-dom --disable-simplexml --disable-xml\
    --disable-xmlreader --disable-xmlwriter --disable-phar --without-pear --without-iconv\
    --with-config-file-path=/usr/lib
make && make install
