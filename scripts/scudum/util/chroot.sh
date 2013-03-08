DEV_NAME=${DEV_NAME-/dev/sdb}
SCUDUM=${SCUDUM-/mnt/scudum}

mnt -v $DEV_NAME $SCUDUM

chroot $SCUDUM /usr/bin/env -i\
    HOME=/root TERM="$TERM" PS1='\u:\w\$ '\
    PATH=/bin:/usr/bin:/sbin:/usr/sbin\
    /bin/bash --login
