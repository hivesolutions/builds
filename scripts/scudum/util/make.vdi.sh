FILE_IN=${FILE_IN-scudum.img}
FILE_OUT=${FILE_IN-scudum.vdi}
DEV_NAME=${DEV_NAME-/dev/null}

DIR=$(dirname $(readlink -f $0))

FILE=$FILE_IN DEV_NAME=$DEV_NAME $DIR/make.img.sh

VBoxManage convertdd $FILE_IN $FILE_OUT
rm -v $FILE_IN
