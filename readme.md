# Hive's Builds

Series of build scripts for automation of otherwise difficult taks. Most of these scripts have a
possible destructive behaviour and should be used carefully, in order to avoid any unexpected problem.

## Scudum

Custom linux distribution that aims at providing an easy to use system for
[Viriatum](https://github.com/hivesolutions/viriatum) / [Automium](https://github.com/hivesolutions/automium) /
[Tiberium](https://github.com/hivesolutions/tiberium).

There are a series of [scripts](scripts/scudum/util) that aim at providing a simple to use toolchain for
scudum customization.

### Examples

To enter into the current scudum development environment located under `/dev/sdb` use the following command:

    chroot.sh

To create an ISO image of the Scudum distribution running using the [ISOLINUX](http://www.syslinux.org) boot
loader use the following command taking note that the disk contents should be located at `/dev/sdb`:

    DEV_NAME=/dev/sdb make.iso.sh
    
Note that because the fstab file for the ISO version is different a rebuild operation should be performed
first to avoid problems, to do that use:

    DEV_NAME=/dev/sdb REBUILD=1 make.iso.sh
  
In order to create a Virtual Box compatible image (VDI) issue the command:

    DEV_NAME=/dev/sdb make.vdi.sh
    
To deploy a new version of the Scudum distrubtion to the repository use, note that the deployment
is going to use the `/mnt/builds/scudum` path by default but may be changed using the `TARGET` variable:

    VERSION=v1 deploy.sh

In order to work (change the scudum base system) you need to deploy the latest version into a local drive
(typically `/dev/sdb`) in order to do that use:

    DEV_NAME=/dev/sdb VERSION=latest install.dev.sh
    
Please be aware that `/dev/sdb` drive will be completely erased during this operation.

To create an `img` file of an hard drive and then install it on a device use (experimental):

    install.img.sh && sleep 10 && dd if=scudum.img of=/dev/sdb bs=1M

To restore the hard drive to the original (empty) state run the following command, note that this will
remove the scudum files from it.

    dd if=/dev/zero of=/dev/sdb bs=4096

### Links

Initramfs on LFS http://www.linuxfromscratch.org/blfs/view/svn/postlfs/initramfs.html
