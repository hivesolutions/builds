VERSION="5.4.12"

wget -q "http://www.php.net/get/php-$VERSION.tar.gz/from/this/mirror" "--output-document=php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
export CFLAGS="$CFLAGS -I/opt/arm-unknown-linux-gnueabi/include\
    -L/opt/arm-unknown-linux-gnueabi/lib\
    -R/opt/arm-unknown-linux-gnueabi/lib\
    -L/opt/arm-unknown-linux-gnueabi/usr/lib\
    -R/opt/arm-unknown-linux-gnueabi/usr/lib\
    -L/opt/arm-unknown-linux-gnueabi/arm-unknown-linux-gnueabi/sysroot/usr/lib\
    -R/opt/arm-unknown-linux-gnueabi/arm-unknown-linux-gnueabi/sysroot/usr/lib"
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi\
    -enable-embed=static --enable-bcmath --disable-phar --without-pear --without-iconv\
    --with-config-file-path=/usr/lib
make && make install
