VERSION=${VERSION-5.1.5}

set -e +h

wget "http://www.lua.org/ftp/lua-$VERSION.tar.gz"
tar -zxf "lua-$VERSION.tar.gz"
rm -f "lua-$VERSION.tar.gz"
cd lua-$VERSION

wget "https://raw.github.com/hivesolutions/patches/master/lua/lua-$VERSION-xcompile.patch"
patch -p1 < lua-$VERSION-xcompile.patch
rm -f "lua-$VERSION-xcompile.patch"

export PATH=$PATH:$PREFIX/bin
make linux CC="$HOST-gcc" AR="$HOST-ar rcu" RANLIB="$HOST-ranlib"\
    CFLAGS="-I$PREFIX/include -L$PREFIX/lib -R$PREFIX/lib $CFLAGS"
make install INSTALL_TOP=$PREFIX
ln -sf liblua5.1.so.0.0.0 $PREFIX/lib/liblua5.1.so.0
ln -sf liblua5.1.so.0 $PREFIX/lib/liblua5.1.so
