set +e

rm -rf build
mkdir build
cd build

source ../base.sh

../pcre.sh
../libxml2.sh
../php.sh
