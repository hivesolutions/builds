VERSION=${VERSION-5.4.12}

set -e +h

wget "http://museum.php.net/php5/php-$VERSION.tar.gz"
tar -zxf "php-$VERSION.tar.gz"
rm -f "php-$VERSION.tar.gz"
cd php-$VERSION

wget "https://raw.github.com/hivesolutions/patches/master/config/config.sub" "--output-document=config.sub"
export PATH=$PATH:$PREFIX/bin
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib"
export EXTRA_CFLAGS="-lresolv"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --enable-embed=static --disable-all
make && make install
