# loads the complete set of environment variables
# that are going to be used in the build process
source base.sh

# creates the complete set of partitions
# that are going to be used for the system
mkfs.ext2 /dev/sdb1
mkfs.ext3 /dev/sdb3
mkswap /dev/sdb2

# creates the proper tools directory where the
# build toolchain is going to be set and sets
# it as the root directory of the system
mkdir -pv $SCUDUM/tools
ln -sv $SUCUDUM/tools /

# changes the default remembering option and the
# creation mask for the current user
set +h
umask 022

# runs the complete set of package specific scripts
# in order to build their source code properly
tools/binutils.sh
