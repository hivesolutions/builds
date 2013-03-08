DEV_NAME=${DEV_NAME-/dev/null}
DEV_BOOT=${DEV_BOOT-/dev/null}
DEV_SWAP=${DEV_SWAP-/dev/null}
DEV_ROOT=${DEV_ROOT-/dev/null}
SCUDUM=${SCUDUM-/tmp/scudum}

mkfs.ext2 $DEV_BOOT
mkfs.ext3 $DEV_ROOT
mkswap $DEV_SWAP

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
mkdir -pv $SCUDUM/boot
mount -v $DEV_BOOT $SCUDUM/boot

cd $SCUDUM

wget "http://hole1.hive:9090/extra/scudum/scudum-latest.tar.gz"
tar -zxf scudum-latest.tar.gz
rm -v scudum-latest.tar.gz

mount -v --bind /dev $SCUDUM/dev
mount -vt devpts devpts $SCUDUM/dev/pts
mount -vt proc proc $SCUDUM/proc
mount -vt sysfs sysfs $SCUDUM/sys

#chroot $SCUDUM /usr/bin/env -i\
#    HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
#    DEV_NAME=$DEV_NAME grub-install $DEV_NAME

#chroot $SCUDUM /usr/bin/env -i\
#    HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
#    DEV_NAME=$DEV_NAME extlinux --install /boot

#chroot $SCUDUM /usr/bin/env -i\
#    HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
#    DEV_NAME=$DEV_NAME dd if=/usr/lib/syslinux/mbr.bin\
#    conv=notrunc bs=440 count=1 of=$DEV_NAME

cd /

umount -v $SCUDUM/sys
umount -v $SCUDUM/proc
umount -v $SCUDUM/dev/pts
umount -v $SCUDUM/dev

umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
umount -v $SCUDUM && rm -rvf $SCUDUM
