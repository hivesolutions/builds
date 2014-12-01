VERSION=${VERSION-5.4.33}

set -e +h

wget "http://php.net/get/php-$VERSION.tar.gz/from/this/mirror" "--output-document=php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

wget "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PATH:$PREFIX/bin
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --enable-embed=static --enable-bcmath --enable-sockets --disable-phar\
    --disable-posix --without-pear --without-iconv --with-curl=$PREFIX\
    --with-libxml-dir=$PREFIX --with-config-file-path=/usr/lib
make && make install
