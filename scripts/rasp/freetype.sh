VERSION=${VERSION-2.4.11}

wget -q "http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION.tar.gz"
tar -zxf "freetype-$VERSION.tar.gz"
rm -f "freetype-$VERSION.tar.gz"
cd freetype-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX --disable-shared
make && make install
