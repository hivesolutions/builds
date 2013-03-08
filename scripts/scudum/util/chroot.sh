DEV_NAME=${DEV_NAME-/dev/sdb}
DEV_BOOT=${DEV_BOOT-"$DEV_NAME"1}
DEV_ROOT=${DEV_ROOT-"$DEV_NAME"3}
SCUDUM=${SCUDUM-/mnt/scudum}

mkdir -pv $SCUDUM
mount -v $DEV_ROOT $SCUDUM
mkdir -pv $SCUDUM/boot
mount -v $DEV_BOOT $SCUDUM/boot

chroot $SCUDUM /usr/bin/env -i\
    HOME=/root TERM="$TERM" PS1='\u:\w\$ '\
    PATH=/bin:/usr/bin:/sbin:/usr/sbin\
    /bin/bash --login
