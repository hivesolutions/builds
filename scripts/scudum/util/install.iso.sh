#apt-get -y install kpartx

FILE=${FILE-scudum.raw}
SIZE=${SIZE-4294967296}
BLOCK_SIZE=${BLOCK_SIZE-4096}
SIZE_B=$(expr $SIZE / $BLOCK_SIZE)
DIR=$(dirname $(readlink -f $0))

echo "Creating raw file '$FILE' with $SIZE_B blocks..."

dd if=/dev/zero of=$FILE bs=$BLOCK_SIZE count=$SIZE_B

DEV_NAME=$(losetup -f --show $FILE)
kpartx -a $DEV_NAME

echo "Created raw file and set device at '$DEV_NAME'"

DRIVE=$DEV_NAME $DIR/install.sh

losetup -d $DEV_NAME
