DIR=$(dirname $(readlink -f $0))
export PATH=$DIR:$PATH
bash
exit $?
