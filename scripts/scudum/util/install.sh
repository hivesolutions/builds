DEV_NAME=${DEV_NAME-/dev/null}
DEV_BOOT=${DEV_BOOT-/dev/null}
DEV_SWAP=${DEV_SWAP-/dev/null}
DEV_ROOT=${DEV_ROOT-/dev/null}
BOOT_FS=${BOOT_FS-ext2}
ROOT_FS=${ROOT_FS-ext3}
LOADER=${LOADER-grub}
SCUDUM=${SCUDUM-/tmp/scudum}

if [ $DEV_BOOT != /dev/null ]; then mkfs.$BOOT_FS $DEV_BOOT; fi
if [ $DEV_ROOT != /dev/null ]; then mkfs.$ROOT_FS $DEV_ROOT; fi
if [ $DEV_SWAP != /dev/null ]; then mkswap $DEV_SWAP; fi

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
if [ $DEV_ROOT != $DEV_BOOT ]; then
    mkdir -pv $SCUDUM/boot
    mount -v $DEV_BOOT $SCUDUM/boot
fi

cd $SCUDUM

wget "http://hole1.hive:9090/extra/scudum/scudum-latest.tar.gz"
tar -zxf scudum-latest.tar.gz
rm -v scudum-latest.tar.gz

mount -v --bind /dev $SCUDUM/dev
mount -vt devpts devpts $SCUDUM/dev/pts
mount -vt proc proc $SCUDUM/proc
mount -vt sysfs sysfs $SCUDUM/sys

case $LOADER in
    grub)
        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME grub-install $DEV_NAME
        ;;

    extlinux)
        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME extlinux --install /boot

        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME dd if=/usr/lib/syslinux/mbr.bin\
            conv=notrunc bs=440 count=1 of=$DEV_NAME
        ;;

    isolinux)
        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME extlinux --install /boot

        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME dd if=/usr/lib/syslinux/mbr.bin\
            conv=notrunc bs=440 count=1 of=$DEV_NAME
        ;;
esac

cd /

umount -v $SCUDUM/sys
umount -v $SCUDUM/proc
umount -v $SCUDUM/dev/pts
umount -v $SCUDUM/dev

if [ $DEV_ROOT != $DEV_BOOT ]; then
    umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
fi
umount -v $SCUDUM && rm -rvf $SCUDUM
