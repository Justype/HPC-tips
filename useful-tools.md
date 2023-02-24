# OpenConnect - VPN

[OpenConnect](https://github.com/openconnect/openconnect) is a open source version of [Cisco AnyConnect](https://www.cisco.com/c/en_be/products/security/anyconnect-secure-mobility-client/index.html)

authgroup options

- `NYU VPN: NYU-NET Traffic Only`
- `NYU VPN: All Traffic`

```bash
sudo openconnect \
    --background \
    --protocol=anyconnect \
    --authgroup="NYU VPN: NYU-NET Traffic Only" \
    --user="<NetID>" \
    --form-entry main:password="<password>" \
    --form-entry main:secondary_password="push" \
    vpn.nyu.edu
```

# Rclone - backup files

[Rclone](https://rclone.org/) is a command-line program to manage files on cloud storage. It is very useful for backing up data on HPC to Google Drive.

[Rclone Docs](https://rclone.org/docs/) and [rclone tutoril - NYU HPC](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers/transferring-cloud-storage-data-with-rclone)

Here is my script to make life easier.

1. load the module
2. enter the path only once, not twice
3. (put it into `~/.bashrc`, only run this at home directory)

```bash
rc () {
    module load rclone/1.60.1
    case $1 in
        copy|c|1) rclone -v copy gnyu:greene/$2 ~/$2;;
        copyto|ct|2) rclone -v copyto gnyu:greene/$2 ~/$2;;
        sync|s) rclone -vi sync gnyu:greene/$2 ~/$2;;
        *) printf "ONLY at home directory\ncopy(c) | sync(s) for folders\ncopyto(ct) for files\n";;
    esac
}

rcto () {
    module load rclone/1.60.1
    case $1 in
        copy|c|1) rclone -v copy $1 ~/$2 gnyu:greene/$2;;
        copyto|ct|2) rclone -v copyto $1 ~/$2 gnyu:greene/$2;;
        sync|s) rclone -vi sync ~/$2 gnyu:greene/$2;;
        *) printf "ONLY at home directory\ncopy(c) | sync(s) for folders\ncopyto(ct) for files\n";;
    esac
}
```

- `gnyu` is the name of remote.
- `rclone copy` for copying files in folder
- `rclone copyto` for copying files
- `rclone sync` for sycing files in folder (one direction)
  - `-i, --interactive` to prevent deleting something important.