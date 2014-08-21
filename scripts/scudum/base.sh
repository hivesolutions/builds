# exports a series of environment variables that
# are going to be used through the build process
export SCUDUM=${SCUDUM-/mnt/scudum}
export LC_ALL=POSIX
export SCUDUM_TARGET=$(uname -m)-lfs-linux-gnu
export PATH=/tools/bin:/bin:/usr/bin
export PREFIX=/tools

# exports the unsafe configuration flag so that
# a root user may configure all the packages
export FORCE_UNSAFE_CONFIGURE=1

# allows compialtion using two threads at a give
# time, shoould perform faster on multi core based
# processors (required for fast compilation)
export MAKEFLAGS="-j 2"
