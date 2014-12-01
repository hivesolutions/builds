VERSION=${VERSION-1.20.0}

set -e +h

wget "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-$VERSION.tar.bz2"
tar -jxf "crosstool-ng-$VERSION.tar.bz2"
rm -f "crosstool-ng-$VERSION.tar.bz2"
cd crosstool-ng-$VERSION

./configure
make && make install

cd ..

mkdir config
cd config
wget "https://raw.github.com/hivesolutions/builds/master/scripts/$CNAME/defconfig"
ct-ng oldconfig
CT_ALLOW_BUILD_AS_ROOT_SURE=1 ct-ng build
