# sets the execution break on error so that if any
# of the commands fails the execution is broken
set +e

# removes any previously existing build directory
# and re-constructs the directory changing into it
rm -rf build
mkdir build
cd build

# loads the complete set of environment variables
# that are going to be used in the build process
source ../base.sh

# creates the proper tools directory where the
# build toolchain is going to be set and sets
# it as the root directory of the system
mkdir -pv $SCUDUM/tools
ln -sv $SCUDUM/tools /

# changes the default remembering option and the
# creation mask for the current user
set +h
umask 022

# runs the complete set of package specific scripts
# in order to build their source code properly
../tools/binutils.sh
../tools/gcc.pass1.sh
../tools/linux-headers.sh
../tools/glibc.sh
