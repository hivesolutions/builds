set -e +h

git clone git://github.com/hivesolutions/builds.git
cd builds/include/android

mkdir -p $PREFIX/include
cp *.h $PREFIX/include
