mkfs.ext2 -d kickstart/rhel7-satellite -L OEMDRV modules/01_satellite_instance/oemdrv.img
mkfs.ext2 -d kickstart/rhel7 -L OEMDRV modules/02_client_instance/oemdrv-rhel7.img
mkfs.ext2 -d kickstart/rhel8 -L OEMDRV modules/02_client_instance/oemdrv-rhel8.img