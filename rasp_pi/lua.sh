VERSION="5.1.5"

wget -q "http://www.lua.org/ftp/lua-$VERSION.tar.gz"
tar -zxf "lua-$VERSION.tar.gz"
rm -f "lua-$VERSION.tar.gz"
cd lua-$VERSION

wget -q "https://raw.github.com/hivesolutions/patches/master/lua/lua-$VERSION-xcompile.patch"
patch -p1 < lua-$VERSION-xcompile.patch
rm -f "lua-$VERSION-xcompile.patch"

export PATH=/opt/arm-unknown-linux-gnueabi/bin:$PATH 
make linux CC="arm-unknown-linux-gnueabi-gcc" AR="arm-unknown-linux-gnueabi-ar rcu"\
    RANLIB="arm-unknown-linux-gnueabi-ranlib" CFLAGS="-I/opt/arm-unknown-linux-gnueabi/include\
    -L/opt/arm-unknown-linux-gnueabi/lib -R/opt/arm-unknown-linux-gnueabi/lib"
make install INSTALL_TOP=/opt/arm-unknown-linux-gnueabi
ln -sf liblua5.1.so.0 /opt/arm-unknown-linux-gnueabi/lib/liblua5.1.so
