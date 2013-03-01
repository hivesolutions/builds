VERSION="5.9"

wget -q "http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$VERSION.tar.gz"
tar -zxf "ncurses-$VERSION.tar.gz"
rm -f "ncurses-$VERSION.tar.gz"
cd ncurses-$VERSION

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH
./configure --host=arm-unknown-linux-gnueabi --build=arm --prefix=/opt/arm-unknown-linux-gnueabi
make && make install
