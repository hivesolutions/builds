VERSION=${VERSION-2.4.11}

set -e +h

wget "http://download.savannah.gnu.org/releases/freetype/freetype-$VERSION.tar.gz"
tar -zxf "freetype-$VERSION.tar.gz"
rm -f "freetype-$VERSION.tar.gz"
cd freetype-$VERSION

export PATH=$PATH:$PREFIX/bin
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX --disable-shared
make && make install
