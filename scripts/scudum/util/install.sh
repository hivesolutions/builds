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

mkdir -pv $SCUDUM
mount -v "$DRIVE"3 $SCUDUM
mkdir -pv $SCUDUM/boot
mount -v "$DRIVE"1 $SCUDUM/boot

cd $SCUDUM

wget -q "http://hole1.hive:9090/extra/scudum/scudum-latest.tar.gz"
tar -zxvf scudum-latest.tar.gz
rm -v scudum-latest.tar.gz

mount -v --bind /dev $SCUDUM/dev
mount -vt devpts devpts $SCUDUM/dev/pts
mount -vt proc proc $SCUDUM/proc
mount -vt sysfs sysfs $SCUDUM/sys

chroot $SCUDUM /usr/bin/env -i\
    HOME=/root PATH=/bin:/usr/bin:/sbin:/usr/sbin\
    DRIVE=$DRIVE grub-install $DRIVE

cd /

umount -v $SCUDUM/sys
umount -v $SCUDUM/proc
umount -v $SCUDUM/dev/pts
umount -v $SCUDUM/dev

umount -v $SCUDUM/boot && rm -rvf $SCUDUM/boot
umount -v $SCUDUM && rm -rvf $SCUDUM
