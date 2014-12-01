VERSION="5.4.12"

set -e +h

wget "http://museum.php.net/php5/php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

wget "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PATH:$PREFIX/bin
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
    --enable-embed=static --enable-bcmath--enable-sockets --disable-phar\
    --without-pear --without-iconv --with-config-file-path=/usr/lib
make && make install
