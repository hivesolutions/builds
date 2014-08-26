VERSION=${VERSION-1.5.14}

set -e

wget -q "http://prdownloads.sourceforge.net/libpng/libpng-$VERSION.tar.gz?download" "--output-document=libpng-$VERSION.tar.gz"
tar -zxf "libpng-$VERSION.tar.gz"
rm -f "libpng-$VERSION.tar.gz"
cd libpng-$VERSION

export PATH=$PREFIX/bin:$PATH
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -R$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -R$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib\
    -R$PREFIX/$HOST/sysroot/usr/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX --disable-shared
make && make install
