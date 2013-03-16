DEV_NAME=${DEV_NAME-/dev/sdb}
DEV_BOOT=${DEV_BOOT-"$DEV_NAME"1}
DEV_ROOT=${DEV_ROOT-"$DEV_NAME"3}
SCUDUM=${SCUDUM-/mnt/scudum}
VERSION=${VERSION-0.0.0}
FILE=${FILE-scudum-$VERSION.tar.gz}

BASE=$(pwd)

rm -fv $FILE

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
mkdir -pv $SCUDUM/boot
mount -v $DEV_BOOT $SCUDUM/boot

cd $SCUDUM/root
rm -rf *
rm -rf .*

cd $SCUDUM/tmp
rm -rf *
rm -rf .*

rm -rf $SCUDUM/sources
rm -f $SCUDUM/grub/grub.cfg
rm -f $SCUDUM/etc/fstab
cp -p $SCUDUM/etc/fstab.orig $SCUDUM/etc/fstab

cat "" > $SCUDUM/etc/resolv.conf

cd $SCUDUM
tar -zcvf $BASE/$FILE *

cd $BASE

umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
umount -v $SCUDUM && rm -rvf $SCUDUM
