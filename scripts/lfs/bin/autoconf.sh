VERSION="2.69"
tar -Jxf "autoconf-$VERSION.tar.xz"
cd autoconf-$VERSION

./configure --prefix=/usr
make
make check
make install

cd ..
rm -rf autoconf-$VERSION
