FILE=${FILE-scudum.img}
PEN_NAME=${PEN_NAME-/dev/sdc}
DEV_NAME=${DEV_NAME-/dev/null}
BOOT_SIZE=${BOOT_SIZE-+1G}
SWAP_SIZE=${SWAP_SIZE-+2G}
NAME=${NAME-scudum}
SCUDUM=${SCUDUM-/tmp/scudum}
SCUDUM_PEN=${SCUDUM_PEN-/tmp/scudum-pen}
TARGET=${TARGET-/mnt/drop/$NAME}
LOADER=${LOADER-isolinux}
REBUILD=${REBUILD-0}
DEPLOY=${DEPLOY-1}
SQUASH=${SQUASH-1}
WINDOWS=${WINDOWS-1}
SLEEP_TIME=3

PEN_ROOT="$PEN_NAME"1
DEV_BOOT="$DEV_NAME"1
DEV_SWAP="$DEV_NAME"2
DEV_ROOT="$DEV_NAME"3

CUR=$(pwd)
DIR=$(dirname $(readlink -f $0))

if [ "$REBUILD" == "1" ]; then
    dd if=/dev/zero of=$DEV_NAME bs=1M

    DEV_NAME=$DEV_NAME BOOT_SIZE=$BOOT_SIZE SWAP_SIZE=$SWAP_SIZE\
        SCUDUM=$SCUDUM LOADER=$LOADER $DIR/install.dev.sh
fi

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
if [ $DEV_ROOT != $DEV_BOOT ]; then
    mkdir -pv $SCUDUM/boot
    mount -v $DEV_BOOT $SCUDUM/boot
fi

SCUDUM=$SCUDUM TARGET=/boot $DIR/initrd.sh

cd $SCUDUM
tar -zcf images/root.tar.gz root
tar -zcf images/dev.tar.gz dev
tar -zcf images/etc.tar.gz etc
cd $CUR

if [ "$SQUASH" == "1" ]; then
    ISO_DIR=/tmp/$NAME.iso.dir

    mksquashfs $SCUDUM $NAME.sqfs
    mkdir -pv $ISO_DIR
    cp -rp $SCUDUM/boot $ISO_DIR
    mv $NAME.sqfs $ISO_DIR
else
    ISO_DIR=$SCUDUM
fi

if [ "$WINDOWS" == "1" ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo a; echo 1; echo t; echo b; echo w) | fdisk $PEN_NAME
else
    (echo n; echo p; echo 1; echo ; echo ; echo a; echo 1; echo w) | fdisk $PEN_NAME
fi
sleep $SLEEP_TIME

if [ "$WINDOWS" == "1" ]; then
    mkfs.vfat $PEN_ROOT
else
    mkfs.ext4 $PEN_ROOT
fi

mkdir -pv $SCUDUM_PEN
mount -v $PEN_ROOT $SCUDUM_PEN
cp -rp $ISO_DIR/* $SCUDUM_PEN

mount -v --bind /dev $SCUDUM_PEN/dev
mount -vt devpts devpts $SCUDUM_PEN/dev/pts
mount -vt proc proc $SCUDUM_PEN/proc
mount -vt sysfs sysfs $SCUDUM_PEN/sys

if [ "$WINDOWS" == "1" ]; then
    dd if=/usr/lib/syslinux/mbr.bin conv=notrunc\
        bs=440 count=1 of=$PEN_NAME
    syslinux -s $PEN_ROOT
else
    chroot $SCUDUM_PEN /usr/bin/env -i\
        HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
        DEV_NAME=$PEN_NAME dd if=/usr/lib/syslinux/mbr.bin\
        conv=notrunc bs=440 count=1 of=$PEN_NAME

    chroot $SCUDUM_PEN /usr/bin/env -i\
        HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
        DEV_NAME=$PEN_NAME extlinux --install /boot
fi

umount -v $SCUDUM_PEN/sys
umount -v $SCUDUM_PEN/proc
umount -v $SCUDUM_PEN/dev/pts
umount -v $SCUDUM_PEN/dev
umount -v $SCUDUM_PEN

dd if=$PEN_NAME of=$FILE bs=1M

if [ "$SQUASH" == "1" ]; then
    rm -rf $ISO_DIR
fi

if [ "$DEPLOY" == "1" ]; then
    mv $FILE $TARGET
fi

rm -v $SCUDUM/images/root.tar.gz
rm -v $SCUDUM/images/dev.tar.gz
rm -v $SCUDUM/images/etc.tar.gz

if [ $DEV_ROOT != $DEV_BOOT ]; then
    umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
fi
umount -v $SCUDUM && rm -rvf $SCUDUM

if [ "$REBUILD" == "1" ]; then
    dd if=/dev/zero of=$DEV_NAME bs=1M
fi
