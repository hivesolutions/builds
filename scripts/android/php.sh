VERSION="5.4.12"

wget -q "http://www.php.net/get/php-$VERSION.tar.gz/from/this/mirror" "--output-document=php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

wget -q "https://raw.github.com/hivesolutions/patches/master/config/config.sub"
export PATH=$PREFIX/bin:$PATH
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib"
phpize
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
cd -
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --enable-embed=static --enable-bcmath --enable-sockets --disable-phar\
    --disable-posix --without-pear --without-iconv --with-libxml-dir=$PREFIX\
    --with-config-file-path=/usr/lib
make && make install
