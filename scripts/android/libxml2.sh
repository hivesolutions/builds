VERSION=${VERSION-2.9.0}

wget -q "http://xmlsoft.org/sources/libxml2-$VERSION.tar.gz"
tar -zxf "libxml2-$VERSION.tar.gz"
rm -f "libxml2-$VERSION.tar.gz"
cd libxml2-$VERSION

wget -q "https://raw.github.com/hivesolutions/patches/master/libxml2/libxml2-$VERSION.android.patch"
patch -p1 < libxml2-$VERSION.android.patch
export PATH=$PREFIX/bin:$PATH
./configure --host=$HOST --build=$BUILD --prefix=$PREFIX\
    --disable-shared
make && make install
