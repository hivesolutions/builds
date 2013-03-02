VERSION="5.1.1"

wget -q "ftp://ftp.gmplib.org/pub/gmp-$VERSION/gmp-$VERSION.tar.bz2"
tar -jxf "gmp-$VERSION.tar.bz2"
rm -f "gmp-$VERSION.tar.bz2"
cd gmp-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
make && make install
