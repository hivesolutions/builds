SCUDUM=${SCUDUM-/tmp/scudum}
PATH=${PATH-/}

rm -rf ramdisk
dd if=/dev/zero of=ramdisk bs=1k count=32768
losetup /dev/loop1 ramdisk

mke2fs /dev/loop1
mkdir -pv /mnt/loop1

mount /dev/loop1 /mnt/loop1 
rm -rf /mnt/loop1/lost+found 
cp -dpR $SCUDUM/initrd/* /mnt/loop1/

umount /mnt/loop1
losetup -d /dev/loop1

rm -rf /mnt/loop1

gzip -9 -c ramdisk > $SCUDUM$PATH/initrd.img

rm -rf ramdisk