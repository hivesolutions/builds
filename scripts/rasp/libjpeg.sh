VERSION=${VERSION-8d}

set -e +h

wget "http://www.ijg.org/files/jpegsrc.v$VERSION.tar.gz"
tar -zxf "jpegsrc.v$VERSION.tar.gz"
rm -f "jpegsrc.v$VERSION.tar.gz"
cd jpeg-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared
make && make install
