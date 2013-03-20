# Hive's Builds

Series of build scripts for automation.

## Scudum

Custom linux distribution that aims at providing an easy to use system for
[Viriatum](https://github.com/hivesolutions/viriatum) / [Automium](https://github.com/hivesolutions/automium) /
[Tiberium](https://github.com/hivesolutions/tiberium).

There are a series of [scripts](scripts/scudum/util) that aim at providing a simple to use toolchain for
scudum customization.

### Examples

To enter into the current scudum development environment located under `/dev/sdb` use the following command:

    chroot.sh

To crate an ISO image of the Scudum distrubtion running using the [ISOLINUX](http://www.syslinux.org) boot loader use the following command
taking note that the disk contents should be located at `/dev/sdb`:

    DEV_NAME=/dev/sdb make.iso.sh
  
In order to create a Virtual Box compatible image (VDI) issue the command:

    DEV_NAME=/dev/sdb make.vdi.sh

To create an img file of an hard drive and then install it on a device use (experimental):

    install.img.sh && sleep 10 && dd if=scudum.img of=/dev/sdb bs=1M

### Links

Initramfs on LFS http://www.linuxfromscratch.org/blfs/view/svn/postlfs/initramfs.html
