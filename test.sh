gcc -o main  main.c

truncate --size=1G FAT.txt
sudo mkfs.fat FAT.txt
mkdir fat
sudo mount -t vfat FAT.txt fat

truncate --size=1G exFAT.txt
epm --auto install exfatprogs > /dev/null
sudo mkfs.exfat exFAT.txt
mkdir exFAT
sudo mount -t exfat exFAT.txt exFAT

truncate --size=1G ext4.txt
sudo mkfs.ext4 ext4.txt
mkdir ext4
sudo mount -t ext4 ext4.txt ext4

truncate --size=1G btrfs.txt
epm --auto install btrfs-progs > /dev/null
sudo mkfs.btrfs btrfs.txt
mkdir btrfs
sudo mount -t btrfs btrfs.txt btrfs

truncate --size=1G ntfs3g.txt
epm --auto install ntfs-3g > /dev/null
blockDevice3g=`sudo losetup -f`
sudo losetup $blockDevice3g ntfs3g.txt
sudo mkntfs $blockDevice3g
mkdir ntfs3g
sudo mount -t ntfs $blockDevice3g ntfs3g

truncate --size=1G ntfs.txt
blockDevice=`sudo losetup -f`
sudo losetup $blockDevice ntfs.txt
sudo mkntfs $blockDevice
mkdir ntfs
epm --auto remove ntfs-3g > /dev/null
sudo mount -t ntfs $blockDevice ntfs

truncate --size=1G zfs.txt
epm --auto install zfsutils-linux > /dev/null
zfsBlock=`sudo losetup -f`
sudo losetup $zfsBlock zfs.txt
sudo zpool create -f zfsTestPool $zfsBlock
mkdir zfs
sudo zfs set mountpoint=`pwd`/zfs zfsTestPool

echo -e "\nFAT file system check:"
./main fat
sudo bash testNameLength.sh fat
sudo umount fat
rmdir fat
rm FAT.txt

echo -e "\nexFAT file system check:"
./main exFAT
sudo bash testNameLength.sh exFAT
sudo umount exFAT
rmdir exFAT
rm exFAT.txt

echo -e "\next4 file system check:"
./main ext4
sudo bash testNameLength.sh ext4
sudo umount ext4
rmdir ext4
rm ext4.txt

echo -e "\nbtrfs file system check:"
./main btrfs
sudo bash testNameLength.sh btrfs
sudo umount btrfs
rmdir btrfs
rm btrfs.txt

echo -e "\nntfs(FUSE) file system check:"
./main ntfs3g
sudo bash testNameLength.sh ntfs3g
sudo umount ntfs3g
sudo losetup -d $blockDevice3g
rmdir ntfs3g
rm ntfs3g.txt

echo -e "\nntfs(read-only) file system check:"
./main ntfs
sudo bash testNameLength.sh ntfs
sudo umount ntfs
sudo losetup -d $blockDevice
rmdir ntfs
rm ntfs.txt

echo -e "\nzfs file system check:"
./main zfs
sudo bash testNameLength.sh
sudo zpool destroy zfsTestPool
sudo losetup -d $zfsBlock
rmdir zfs
rm zfs.txt

