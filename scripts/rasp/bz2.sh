VERSION=${VERSION-1.0.6}

set -e +h

wget "http://www.bzip.org/$VERSION/bzip2-$VERSION.tar.gz"
tar -zxf "bzip2-$VERSION.tar.gz"
rm -f "bzip2-$VERSION.tar.gz"
cd bzip2-$VERSION

export PATH=$PREFIX/bin:$PATH
make bzip2 bzip2recover CC=$HOST-gcc CFLAGS="$CFLAGS"
make install PREFIX=$PREFIX
