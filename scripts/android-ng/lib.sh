set -e

git clone git://github.com/hivesolutions/builds.git
cd builds/include/android-ng

mkdir -p $PREFIX/lib
cp *.h $PREFIX/lib
