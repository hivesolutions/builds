export DRIVE=/dev/sdb
export BOOT_SIZE=+1G
export SWAP_SIZE=+2G
export SCUDUM=/tmp/scudum

(echo n; echo p; echo 1; echo ; echo $BOOT_SIZE; echo a; echo 1; echo w) | fdisk $DRIVE
sleep 1
(echo n; echo p; echo 2; echo ; echo $SWAP_SIZE; echo t; echo 2; echo 82; echo w) | fdisk $DRIVE
sleep 1
(echo n; echo p; echo 3; echo ; echo ; echo w) | fdisk $DRIVE
sleep 1

mkfs.ext2 "$DRIVE"1
mkfs.ext3 "$DRIVE"3
mkswap "$DRIVE"2

mkdir -p $SCUDUM
mount "$DRIVE"3 $SCUDUM
mkdir -p $SCUDUM/boot
mount "$DRIVE"1 $SCUDUM/boot

cd $SCUDUM

wget -q "http://hole1.hive:9090/extra/scudum/scudum-latest.tar.gz"
tar -zxvf scudum-v3.tar.gz
rm -v scudum-v3.tar.gz

mount -v --bind /dev $SCUDUM/dev
mount -vt devpts devpts $SCUDUM/dev/pts
mount -vt proc proc $SCUDUM/proc
mount -vt sysfs sysfs $SCUDUM/sys

chroot $SCUDUM /usr/bin/env -i\
    HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
    DRIVE=$DRIVE grub-install $DRIVE

cd /

umount $SCUDUM/sys
umount $SCUDUM/proc
umount $SCUDUM/dev/pts
umount $SCUDUM/dev

umount $SCUDUM/boot && rm -rf $SCUDUM/boot
umount $SCUDUM && rm -rf $SCUDUM
