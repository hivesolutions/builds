#!/bin/bash
# -*- coding: utf-8 -*-

DEV_NAME=${DEV_NAME-/dev/null}
DEV_BOOT=${DEV_BOOT-/dev/null}
DEV_SWAP=${DEV_SWAP-/dev/null}
DEV_ROOT=${DEV_ROOT-/dev/null}
BOOT_FS=${BOOT_FS-ext2}
ROOT_FS=${ROOT_FS-ext3}
LOADER=${LOADER-grub}
SCUDUM=${SCUDUM-/tmp/scudum}

if [ $DEV_ROOT == $DEV_BOOT ]; then BOOT_FS=$ROOT_FS; fi

if [ $DEV_BOOT != /dev/null ]; then mkfs.$BOOT_FS $DEV_BOOT && rm -rf $BOOT_FS/lost+found; fi
if [ $DEV_ROOT != /dev/null ]; then mkfs.$ROOT_FS $DEV_ROOT && rm -rf $ROOT_FS/lost+found; fi
if [ $DEV_SWAP != /dev/null ]; then mkswap $DEV_SWAP; fi

eval $(blkid -o export $DEV_BOOT)
BOOT_UUID=$UUID
eval $(blkid -o export $DEV_ROOT)
ROOT_UUID=$UUID
eval $(blkid -o export $DEV_SWAP)
SWAP_UUID=$UUID

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
if [ $DEV_ROOT != $DEV_BOOT ]; then
    mkdir -pv $SCUDUM/boot
    mount -v $DEV_BOOT $SCUDUM/boot
fi

cd $SCUDUM

wget "http://hole1.hive:9090/drop/scudum/scudum-latest.tar.gz"
tar -zxf scudum-latest.tar.gz
rm -v scudum-latest.tar.gz

cp -p $SCUDUM/etc/fstab.orig $SCUDUM/etc/fstab

mount -v --bind /dev $SCUDUM/dev
mount -vt devpts devpts $SCUDUM/dev/pts
mount -vt proc proc $SCUDUM/proc
mount -vt sysfs sysfs $SCUDUM/sys

case $LOADER in
    grub)
        echo "UUID=$ROOT_UUID / $ROOT_FS defaults,noatime 0 1" >> $SCUDUM/etc/fstab
        echo "UUID=$SWAP_UUID none swap pri=1 0 0" >> $SCUDUM/etc/fstab
        if [ $DEV_ROOT != $DEV_BOOT ]; then
            echo "UUID=$BOOT_UUID /boot $BOOT_FS noauto,noatime 1 2" >> $SCUDUM/etc/fstab
        fi

        cat $SCUDUM/boot/grub/grub.cfg.tpl | sed -e "s/\${BOOT_FS}/$BOOT_FS/"\
            -e "s/\${ROOT_UUID}/$ROOT_UUID/" > $SCUDUM/boot/grub/grub.cfg

        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME grub-install $DEV_NAME
        ;;

    extlinux|isolinux)
        echo "tmpfs / tmpfs defaults 0 0" >> $SCUDUM/etc/fstab

        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME dd if=/usr/lib/syslinux/mbr.bin\
            conv=notrunc bs=440 count=1 of=$DEV_NAME

        chroot $SCUDUM /usr/bin/env -i\
            HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
            DEV_NAME=$DEV_NAME extlinux --install /boot
        ;;
esac

cd /

sync
umount -v $SCUDUM/sys
umount -v $SCUDUM/proc
umount -v $SCUDUM/dev/pts
umount -v $SCUDUM/dev

if [ $DEV_ROOT != $DEV_BOOT ]; then
    umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
fi
umount -v $SCUDUM && rm -rvf $SCUDUM
