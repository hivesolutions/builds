set -e +h

rm -rf builds

git clone git://github.com/hivesolutions/builds.git
cd builds/include/android-ng

mkdir -p $PREFIX/include
cp *.h $PREFIX/include
