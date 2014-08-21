VERSION=${VERSION-2.23.1}

wget -q "http://ftp.gnu.org/gnu/binutils/binutils-$VERSION.tar.bz2"
tar -jxf "binutils-$VERSION.tar.bz2"
rm -f "binutils-$VERSION.tar.bz2"
cd binutils-$VERSION

./configure --prefix=/tools --with-sysroot=$SCUDUM --with-lib-path=/tools/lib \
    --target=$SUCUDUM_TARGET --disable-nls --disable-werror

make
case $(uname -m) in
    x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
make install
