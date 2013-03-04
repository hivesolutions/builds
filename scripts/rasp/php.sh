VERSION="5.4.12"

wget -q "http://www.php.net/get/php-$VERSION.tar.gz/from/this/mirror" "--output-document=php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

export PATH=$PREFIX/bin:$PATH
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -R$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -R$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib\
    -R$PREFIX/$HOST/sysroot/usr/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    -enable-embed=static --enable-bcmath --disable-phar\
    --without-pear --without-iconv --with-config-file-path=/usr/lib
make && make install
