set -e

rm -rf build
mkdir build
cd build

export CNAME=rasp

../deps.sh
../cross.sh

source ../base.sh

../bin.sh
../openssl.sh
../pcre.sh
../zlib.sh
../zip.sh
../bz2.sh
../libpng.sh
../libjpeg.sh
../freetype.sh
../ncurses.sh
../readline.sh
../gmp.sh
../curl.sh
../python.sh
../lua.sh
../libxml2.sh
../php.sh
