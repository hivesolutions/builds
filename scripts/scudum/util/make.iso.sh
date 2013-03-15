FILE=${FILE-scudum.iso}
DEV_NAME=${DEV_NAME-/dev/null}
BOOT_SIZE=${BOOT_SIZE-+1G}
SWAP_SIZE=${SWAP_SIZE-+2G}
SCUDUM=${SCUDUM-/tmp/scudum}
TARGET=${TARGET-/mnt/extra/$FILE}
REBUILD=${SCUDUM-0}
DEPLOY=${SCUDUM-1}

DEV_BOOT="$DEV_NAME"1
DEV_SWAP="$DEV_NAME"2
DEV_ROOT="$DEV_NAME"3

if [ "$DEPLOY" == "1" ]; then
    FILE=$TARGET
fi

DIR=$(dirname $(readlink -f $0))

if [ "$REBUILD" == "1" ]; then
    dd if=/dev/zero of=$DEV_NAME bs=1M

    DEV_NAME=$DEV_NAME BOOT_SIZE=$BOOT_SIZE SWAP_SIZE=$SWAP_SIZE\
        SCUDUM=$SCUDUM $DIR/install.dev.sh
fi

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
if [ $DEV_ROOT != $DEV_BOOT ]; then
    mkdir -pv $SCUDUM/boot
    mount -v $DEV_BOOT $SCUDUM/boot
fi

rm -rf ramdisk
dd if=/dev/zero of=ramdisk bs=1k count=32768
losetup /dev/loop1 ramdisk

mke2fs /dev/loop1
mkdir -p /mnt/loop1

mount /dev/loop1 /mnt/loop1 
rm -rf /mnt/loop1/lost+found 
cp -dpR $DEV_ROOT/initrd/* /mnt/loop1/

umount /mnt/loop1
losetup -d /dev/loop1

rm -rf /mnt/loop1

gzip -9 -c ramdisk > $DEV_ROOT/isolinux/initrd.img

rm -rf ramdisk

cd $DEV_ROOT
tar -zcf images/root.tar.gz root
tar -zcf images/dev.tar.gz dev
tar -zcf images/etc.tar.gz etc
cd ..

mkisofs -r -o $FILE \
   -b isolinux/isolinux.bin -c isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   $DEV_ROOT

rm -v $DEV_ROOT/images/root.tar.gz
rm -v $DEV_ROOT/images/dev.tar.gz
rm -v $DEV_ROOT/images/etc.tar.gz

if [ $DEV_ROOT != $DEV_BOOT ]; then
    umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
fi
umount -v $SCUDUM && rm -rvf $SCUDUM

if [ "$REBUILD" == "1" ]; then
    dd if=/dev/zero of=$DEV_NAME bs=1M
fi
