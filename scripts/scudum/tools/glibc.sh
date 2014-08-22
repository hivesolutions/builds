VERSION=${VERSION-2.17}

wget -q "http://ftp.gnu.org/gnu/glibc/glibc-$VERSION.tar.xz"
tar -Jxf "glibc-$VERSION.tar.xz"
rm -f "glibc-$VERSION.tar.xz"
cd glibc-$VERSION

if [ ! -r /usr/include/rpc/types.h ]; then
    su -c 'mkdir -p /usr/include/rpc'
    su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'
fi

cd ..
mkdir glibc-build
cd glibc-build

../glibc-$VERSION/configure\
    --prefix=/tools\
    --host=$SCUDUM_TARGET\
    --build=$(../glibc-$VERSION/scripts/config.guess)\
    --disable-profile\
    --enable-kernel=2.6.25\
    --with-headers=/tools/include\
    libc_cv_forced_unwind=yes\
    libc_cv_ctors_header=yes\
    libc_cv_c_cleanup=yes

make && make install
