#!/bin/bash
# -*- coding: utf-8 -*-

FILE=${FILE-scudum.img}
SIZE=${SIZE-2147483648}
BLOCK_SIZE=${BLOCK_SIZE-4096}
BOOT_SIZE=${BOOT_SIZE_F-+512M}
SWAP_SIZE=${SWAP_SIZE_F-+64M}
SCHEMA=${SCHEMA-stored}
LOADER=${LOADER-grub}
SLEEP_TIME=3

SIZE_B=$(expr $SIZE / $BLOCK_SIZE)
DIR=$(dirname $(readlink -f $0))

dd if=/dev/zero of=$FILE bs=$BLOCK_SIZE count=$SIZE_B

(echo n; echo p; echo 1; echo ; echo $BOOT_SIZE; echo a; echo 1; echo w) | fdisk -H 255 -S 63 $FILE
sleep $SLEEP_TIME && sync
(echo n; echo p; echo 2; echo ; echo $SWAP_SIZE; echo t; echo 2; echo 82; echo w) | fdisk -H 255 -S 63 $FILE
sleep $SLEEP_TIME && sync
(echo n; echo p; echo 3; echo ; echo ; echo w) | fdisk -H 255 -S 63 $FILE
sleep $SLEEP_TIME && sync

DEV_NAME=$(losetup -f --show $FILE)
DEV_INDEX=${DEV_NAME:${#DEV_NAME} - 1}
DEV_BOOT=/dev/mapper/loop$DEV_INDEXp1
DEV_SWAP=/dev/mapper/loop$DEV_INDEXp2
DEV_ROOT=/dev/mapper/loop$DEV_INDEXp3

kpartx -a $DEV_NAME

DEV_NAME=$DEV_NAME DEV_BOOT=$DEV_BOOT DEV_SWAP=$DEV_SWAP\
    DEV_ROOT=$DEV_ROOT SCHEMA=$SCHEMA LOADER=$LOADER $DIR/install.sh

sync
kpartx -d $DEV_NAME
losetup -d $DEV_NAME
sync
