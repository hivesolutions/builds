FILE_IN=${FILE_IN-scudum.img}
FILE_OUT=${FILE_IN-scudum.vdi}

DIR=$(dirname $(readlink -f $0))

FILE=$FILE_IN $DIR/install.img.sh

VBoxManage convertdd $FILE_IN $FILE_OUT