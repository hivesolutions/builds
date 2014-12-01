set -e +h

git clone --depth 1 git://github.com/hivesolutions/builds.git
cd builds/include/android

mkdir -p $PREFIX/include
cp *.h $PREFIX/include
