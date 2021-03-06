VERSION=${VERSION-5.4.33}

set -e +h

wget "http://php.net/get/php-$VERSION.tar.gz/from/this/mirror" "--output-document=php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

export PATH=$PATH:$PREFIX/bin
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -R$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -R$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib\
    -R$PREFIX/$HOST/sysroot/usr/lib"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib\
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
    --enable-embed=static --enable-bcmath --enable-mysqlnd --enable-sockets\
    --enable-zip --disable-phar --with-mysql --with-mysqli --with-gd --with-openssl\
    --without-pear --without-iconv --with-mysql=mysqlnd --with-pdo-mysql=mysqlnd\
    --with-config-file-path=/usr/lib --with-curl=$PREFIX --with-gmp=$PREFIX\
    --with-bz2=$PREFIX --with-zlib-dir=$PREFIX --with-freetype-dir=$PREFIX\
    --with-png-dir=$PREFIX --with-jpeg-dir=$PREFIX --with-libxml-dir=$PREFIX\
    --with-openssl-dir=$PREFIX
make && make install
