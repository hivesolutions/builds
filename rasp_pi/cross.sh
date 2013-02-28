VERSION="1.17.0"

wget -q "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-$VERSION.tar.bz2"
tar -jxf "crosstool-ng-$VERSION.tar.bz2"
rm -f "crosstool-ng-$VERSION.tar.bz2"
cd crosstool-ng-$VERSION

./configure
make && make install

mkdir config
cd config
wget -q "https://raw.github.com/hivesolutions/builds/master/rasp_pi/defconfig"
ct-ng olddefconfig
ct-ng build
