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
cd ext/mysqlnd
mv config9.m4 config.m4
sed -ie "s{<ext/mysqlnd/php_mysqlnd_config.h>{\"config.h\"{" mysqlnd_portability.h
phpize
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
cd -
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    -enable-embed=static --enable-bcmath --enable-mysqlnd\
    --disable-phar --with-mysql --with-mysqli --without-pear\
    --without-iconv --with-mysql=mysqlnd --with-pdo-mysql=mysqlnd\
    --with-config-file-path=/usr/lib
make && make install