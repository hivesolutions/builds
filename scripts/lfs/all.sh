
##------------------------------------------------------



mkfs.ext2 /dev/sdb1
mkfs.ext3 /dev/sdb3
mkswap /dev/sdb2

### directory creation

export LFS=/mnt/lfs

mkdir -v $LFS/tools
ln -sv $LFS/tools /



#### ENVIRONMENT SETTINGHS


set +h
umask 022
export LFS=/mnt/lfs
export LC_ALL=POSIX
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=/tools/bin:/bin:/usr/bin
export PREFIX=/tools
export LFS LC_ALL LFS_TGT PATH

# exports the unsafe configuration flag so that
# a root user may configure all the packages
export FORCE_UNSAFE_CONFIGURE=1

# allows compialtion using two threads at a give
# time, shoould perform faster on multi core based
# processors (required for fast compilation)
export MAKEFLAGS="-j 2"


############################ BINUTILS FIRST PASS ####################


wget -q "http://ftp.gnu.org/gnu/binutils/binutils-2.23.1.tar.bz2"
tar -jxf "binutils-2.23.1.tar.bz2"
rm -f "binutils-2.23.1.tar.bz2"
cd binutils-2.23.1

./configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib \
    --target=$LFS_TGT --disable-nls --disable-werror

make
case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
make install

cd ..   #TOODo REMOVE THIS !!!

##---------------------------------GCC (FIRST PASS) ---------------------

wget -q "http://ftp.gnu.org/gnu/gcc/gcc-4.7.2/gcc-4.7.2.tar.bz2"
tar -jxf "gcc-4.7.2.tar.bz2"
rm -f "gcc-4.7.2.tar.bz2"
cd gcc-4.7.2

# downloads all the requirements for the current gcc builds
# should 
./contrib/download_prerequisites

for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g'\
        -e 's@/usr@/tools@g' $file.orig > $file
    echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
    touch $file.orig
done

sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure

cd ..
mkdir gcc-build
cd gcc-build

../gcc-4.7.2/configure\
    --target=$LFS_TGT \
    --prefix=/tools \
    --with-sysroot=$LFS\
    --with-newlib\
    --without-headers\
    --with-local-prefix=/tools\
    --with-native-system-header-dir=/tools/include\
    --disable-nls\
    --disable-shared\
    --disable-multilib\
    --disable-decimal-float\
    --disable-threads\
    --disable-libmudflap\
    --disable-libssp\
    --disable-libgomp\
    --disable-libquadmath\
    --enable-languages=c

make && make install

ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`



cd ..   #TOODo REMOVE THIS !!!

###-------------------------------------KERNEL HEADERS-------------------------------

wget -q "https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.2.tar.bz2"
tar -jxf "linux-3.8.2.tar.bz2"
rm -f "linux-3.8.2.tar.bz2"
cd linux-3.8.2

make mrproper
make headers_check
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

cd ..   #TOODo REMOVE THIS !!!

###--------------------------------------------GLIBC ----------------------------------

wget -q "http://ftp.gnu.org/gnu/glibc/glibc-2.17.tar.xz"
tar -Jxf "glibc-2.17.tar.xz"
rm -f "glibc-2.17.tar.xz"
cd glibc-2.17

if [ ! -r /usr/include/rpc/types.h ]; then
  su -c 'mkdir -p /usr/include/rpc'
  su -c 'cp -v sunrpc/rpc/*.h /usr/include/rpc'
fi

cd ..
mkdir glibc-build
cd glibc-build

../glibc-2.17/configure\
    --prefix=/tools\
    --host=$LFS_TGT\
    --build=$(../glibc-2.17/scripts/config.guess)\
    --disable-profile\
    --enable-kernel=2.6.25\
    --with-headers=/tools/include\
    libc_cv_forced_unwind=yes\
    libc_cv_ctors_header=yes\
    libc_cv_c_cleanup=yes

make && make install

cd ..   #TOODo REMOVE THIS !!!

############    BINUTILS pass 2------------------------------

wget -q "http://ftp.gnu.org/gnu/binutils/binutils-2.23.1.tar.bz2"
tar -jxf "binutils-2.23.1.tar.bz2"
rm -f "binutils-2.23.1.tar.bz2"
cd binutils-2.23.1

CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ./configure\
    --prefix=/tools\
    --disable-nls\
    --with-lib-path=/tools/lib

make && make install

make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

cd ..   #TOODo REMOVE THIS !!!

############    GCC pass 2------------------------------

wget -q "http://ftp.gnu.org/gnu/gcc/gcc-4.7.2/gcc-4.7.2.tar.bz2"
tar -jxf "gcc-4.7.2.tar.bz2"
rm -f "gcc-4.7.2.tar.bz2"
cd gcc-4.7.2

# downloads all the requirements for the current gcc builds
# should 
./contrib/download_prerequisites

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

cp -v gcc/Makefile.in{,.tmp}
sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp \
  > gcc/Makefile.in

for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g'\
        -e 's@/usr@/tools@g' $file.orig > $file
    echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
    touch $file.orig
done

sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure

cd ..
mkdir gcc-build
cd gcc-build

CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ../gcc-4.7.2/configure\
    --prefix=/tools\
    --with-local-prefix=/tools\
    --with-native-system-header-dir=/tools/include\
    --enable-clocale=gnu\
    --enable-shared\
    --enable-threads=posix\
    --enable-__cxa_atexit\
    --enable-languages=c,c++\
    --disable-libstdcxx-pch\
    --disable-multilib\
    --disable-bootstrap\
    --disable-libgomp
    
make && make install

ln -sv gcc /tools/bin/cc

#### ----------------------------------------------------

../tcl.sh
../expect.sh
../dejagnu.sh
../check.sh
../ncurses.sh
../bash.sh
../bzip2.sh
../coreutils.sh
../diffutils.sh
../file.sh
../findutils.sh
../gawk.sh
../gettext.sh
../grep.sh
../gzip.sh
../m4.sh
../make.sh
../patch.sh
../perl.sh
../sed.sh
../tar.sh
../texinfo.sh
../xz.sh

strip --strip-debug /tools/lib/*
strip --strip-unneeded /tools/{,s}bin/*

