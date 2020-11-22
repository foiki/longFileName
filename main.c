#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>

#if __APPLE__
#include <sys/param.h>
#include <sys/mount.h>
#elif __linux__
#include <sys/vfs.h>
#elif
printf("Unknown OS!")
#endif

#define EXT4_SUPER_MAGIC      0xef53
#define MSDOS_SUPER_MAGIC     0x4d44
#define EXFAT_SUPER_MAGIC     0x2011BAB0UL
#define FUSE_SUPER_MAGIC      0x65735546
#define NTFS_SB_MAGIC         0x5346544e
#define HPFS_SUPER_MAGIC      0xf995e849
#define BTRFS_SUPER_MAGIC     0x9123683e

const char *fsType2str(long type) {
    static struct fsname {
        long type;
        const char *name;
    } table[] = {
        { EXT4_SUPER_MAGIC, "EXT4" },
        { MSDOS_SUPER_MAGIC, "FAT" },
        { EXFAT_SUPER_MAGIC, "exFAT"},
        { FUSE_SUPER_MAGIC, "FUSE" },
        { NTFS_SB_MAGIC, "NTFS" },
        { HPFS_SUPER_MAGIC, "HPFS" },
        { BTRFS_SUPER_MAGIC, "BTRFS" },
        { 0, NULL },
    };
    static char unknown[100];
    
    for (int i = 0; table[i].type != 0; i++)
        if (table[i].type == type)
            return table[i].name;

    sprintf(unknown, "unknown type:");
    return unknown;
}

int isFileExistsAccess(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Wrong number of parameters! Enter only the path to the file or directory!\n");
        return 1;
        
    }
    if (access(argv[1], F_OK) != 0) {
		printf("No such file or directory: %s\n", argv[1]);
    	return 1;
	}
    return 0;
}

int main(int argc, char *argv[]) {
    
    if (isFileExistsAccess(argc, argv)) {
        return 0;
        
    }

    struct statfs fs;
    char *file = argv[1];
    int result = statfs(file, & fs);
    if (result != 0) {
        fprintf(stderr, "File: %s, An error occured: %s\n",
                argv[1], strerror(errno));
        return errno;
    }

    #if __APPLE__
        printf("tf_type: %s\n", fs.f_fstypename);
    #elif __linux__
        printf("tf_type: %s %#lx\n", fsType2str(fs.f_type), fs.f_type);
        printf("tf_namelen: %ld\n", fs.f_namelen);
    #endif

    return 0;
}
