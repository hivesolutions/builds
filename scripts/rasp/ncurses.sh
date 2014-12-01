VERSION=${VERSION-5.9}

set -e +h

wget "http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$VERSION.tar.gz"
tar -zxf "ncurses-$VERSION.tar.gz"
rm -f "ncurses-$VERSION.tar.gz"
cd ncurses-$VERSION

export PATH=$PATH:$PREFIX/bin
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX
make && make install
