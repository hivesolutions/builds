VERSION=${VERSION-0.10.1}

set -e

wget -q "http://www.nih.at/libzip/libzip-$VERSION.tar.gz"
tar -zxf "libzip-$VERSION.tar.gz"
rm -f "libzip-$VERSION.tar.gz"
cd libzip-$VERSION

export PATH=$PREFIX/bin:$PATH
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -R$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -R$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib\
    -R$PREFIX/$HOST/sysroot/usr/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared
make && make install
