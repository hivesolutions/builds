FILE=${FILE-scudum.img}
SIZE=${SIZE-4294967296}
OFFSET=${OFFSET-1048576}
BLOCK_SIZE=${BLOCK_SIZE-4096}
BOOT_SIZE=${BOOT_SIZE-1073741824}
SWAP_SIZE=${SWAP_SIZE-2147483648}
BOOT_SIZE_F=${BOOT_SIZE_F-+1G}
SWAP_SIZE_F=${SWAP_SIZE_F-+2G}
SLEEP_TIME=3

SIZE_B=$(expr $SIZE / $BLOCK_SIZE)
DIR=$(dirname $(readlink -f $0))

dd if=/dev/zero of=$FILE bs=$BLOCK_SIZE count=$SIZE_B

(echo n; echo p; echo 1; echo ; echo $BOOT_SIZE_F; echo a; echo 1; echo w) | fdisk -H 255 -S 63 $FILE
sleep $SLEEP_TIME
(echo n; echo p; echo 2; echo ; echo $SWAP_SIZE_F; echo t; echo 2; echo 82; echo w) | fdisk -H 255 -S 63 $FILE
sleep $SLEEP_TIME
(echo n; echo p; echo 3; echo ; echo ; echo w) | fdisk $FILE
sleep $SLEEP_TIME

DEV_NAME=$(losetup -f --show $FILE)
DEV_INDEX=${DEV_NAME:${#DEV_NAME} - 1}
DEV_BOOT=/dev/loop$(expr $DEV_INDEX + 1)
DEV_SWAP=/dev/loop$(expr $DEV_INDEX + 2)
DEV_ROOT=/dev/loop$(expr $DEV_INDEX + 3)

BOOT_OFFSET=$(expr $OFFSET)
SWAP_OFFSET=$(expr $BOOT_OFFSET + $BOOT_SIZE)
ROOT_OFFSET=$(expr $SWAP_OFFSET + $SWAP_SIZE)

losetup -o $BOOT_OFFSET $DEV_BOOT $DEV_NAME
losetup -o $SWAP_OFFSET $DEV_SWAP $DEV_NAME
losetup -o $ROOT_OFFSET $DEV_ROOT $DEV_NAME

DEV_NAME=$DEV_NAME DEV_BOOT=$DEV_BOOT DEV_SWAP=$DEV_SWAP DEV_ROOT=$DEV_ROOT $DIR/install.sh

losetup -d $DEV_ROOT
losetup -d $DEV_SWAP
losetup -d $DEV_BOOT
sleep $SLEEP_TIME

losetup -d $DEV_NAME
