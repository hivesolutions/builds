VERSION_="1.2.50"

wget -q "http://prdownloads.sourceforge.net/libpng/libpng-$VERSION_.tar.gz?download" "--output-document=libpng-$VERSION_.tar.gz"
tar -zxf "libpng-$VERSION_.tar.gz"
rm -f "libpng-$VERSION_.tar.gz"
cd libpng-$VERSION_

export PATH=$PREFIX/bin:$PATH
export CFLAGS="$CFLAGS -I$PREFIX/include\
    -L$PREFIX/lib\
    -R$PREFIX/lib\
    -L$PREFIX/usr/lib\
    -R$PREFIX/usr/lib\
    -L$PREFIX/$HOST/sysroot/usr/lib\
    -R$PREFIX/$HOST/sysroot/usr/lib"
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
make && make install
