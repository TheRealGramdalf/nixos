#!/usr/bin/env bash

PORT='69'
HOST='192.168.1.5'

# Use tar to create a zstd-compressed sparse archive (using numeric perms/mode), a high recordsize to help nc, excluding files listed in tar-exclude, ignoring wildcards
# This uses `nc -N` to terminate the connection when it recieves an EOF. In order for it to work properly, this machine needs to be the "client" - it should connect to the already listening server (waiting to extract) and push the archive to it.
tar --create --zstd --sparse --to-stdout --owner=3296 --group=1920470591 --mode=770 --record-size=4096 --format=gnu -C /tmp mnt | nc -N $HOST $PORT 
