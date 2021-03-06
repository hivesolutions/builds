VERSION=${VERSION-6.2}

set -e +h

wget "ftp://ftp.cwru.edu/pub/bash/readline-$VERSION.tar.gz"
tar -zxf "readline-$VERSION.tar.gz"
rm -f "readline-$VERSION.tar.gz"
cd readline-$VERSION

export PATH=$PATH:$PREFIX/bin
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
make && make install
