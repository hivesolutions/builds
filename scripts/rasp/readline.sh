VERSION=${VERSION-6.2}

wget -q "ftp://ftp.cwru.edu/pub/bash/readline-$VERSION.tar.gz"
tar -zxf "readline-$VERSION.tar.gz"
rm -f "readline-$VERSION.tar.gz"
cd readline-$VERSION

export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
make && make install
