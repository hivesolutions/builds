FILE=${FILE-scudum.img}
DEV_NAME=${DEV_NAME-/dev/null}
BOOT_SIZE=${BOOT_SIZE-+1G}
SWAP_SIZE=${SWAP_SIZE-+2G}

DIR=$(dirname $(readlink -f $0))

dd if=/dev/zero of=$DEV_NAME bs=1M

FILE=$FILE DEV_NAME=$DEV_NAME BOOT_SIZE=$BOOT_SIZE SWAP_SIZE=$SWAP_SIZE $DIR/install.sh

dd if=$DEV_NAME of=$FILE bs=1M
dd if=/dev/zero of=$DEV_NAME bs=1M
