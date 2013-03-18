FILE=${FILE-scudum.img}
DEV_NAME=${DEV_NAME-/dev/null}
BOOT_SIZE=${BOOT_SIZE-+1G}
SWAP_SIZE=${SWAP_SIZE-+2G}
NAME=${NAME-scudum}
SCUDUM=${SCUDUM-/tmp/scudum}
SCUDUM_PEN=${SCUDUM_PEN-/tmp/scudum-pen}
TARGET=${TARGET-/mnt/drop/$NAME}
LOADER=${LOADER-grubt}
REBUILD=${REBUILD-0}
DEPLOY=${DEPLOY-1}
SQUASH=${SQUASH-1}

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

SCUDUM=$SCUDUM $DIR/initrd.sh

cd $SCUDUM
tar -zcf images/root.tar.gz root
tar -zcf images/dev.tar.gz dev
tar -zcf images/etc.tar.gz etc
cd $CUR

if [ "$SQUASH" == "1" ]; then
    ISO_DIR=/tmp/$NAME.iso.dir

    mksquashfs $SCUDUM $NAME.sqfs
    mkdir -pv $ISO_DIR
    cp -rp $SCUDUM/boot $SCUDUM/isolinux $SCUDUM/initrd $ISO_DIR
    mv $NAME.sqfs $ISO_DIR
else
    ISO_DIR=$SCUDUM
fi

#### TENHO DE COPIAR OS DIRECTORIO TODOS E DEPOIS INSTALAR BOOT FILE
SLEEP_TIME=3
(echo n; echo p; echo 1; echo ; echo $BOOT_SIZE; echo a; echo 1; echo w) | fdisk /dev/sdc
sleep $SLEEP_TIME
mkdir -pv $SCUDUM_PEN
mount /dev/sdc1 $SCUDUM_PEN
cp -rp $ISO_DIR/* $SCUDUM_PEN
umount $SCUDUM_PEN

dd if=/dev/sdc of=$FILE bs=1M
############


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
