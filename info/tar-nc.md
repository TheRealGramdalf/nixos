Try using `pv` for a progress meter?

```bash
#!/usr/bin/env bash

PORT='69'
HOST='192.168.1.5'

# Use tar to create a zstd-compressed sparse archive (using numeric perms/mode), a high recordsize to help nc, excluding files listed in tar-exclude, ignoring wildcards
# This uses `nc -N` to terminate the connection when it recieves an EOF. In order for it to work properly, this machine needs to be the "client" - it should connect to the already listening server (waiting to extract) and push the archive to it.
tar --create --zstd --sparse --to-stdout --owner=3296 --group=1920470591 --mode=770 --record-size=4096 --format=gnu -C /tmp mnt | nc -N $HOST $PORT 

# This wasn't working
# --exclude-from=/tmp/tar-exclude --no-wildcards

# For example:
# Start a netcat server on port 69 (nice), piping all output to `tar`. `tar` then uses stdin (`-f -`), and in this case, simply lists the files recieved.
# nc -l 69 | tar --zstd -f - --list
```


```bash
#!/usr/bin/env bash
PORT='69'
JOBNAME='WDExternal2T'
DEST='/tank/smb/Data/BackBackups'
LOGDIR='/persist/services/copylogs'

echo "Opening port $PORT, ready to recieve a connection"
nixos-firewall-tool open tcp $PORT

echo "Beginning ncp at $(date)" >> "$LOGDIR/$JOBNAME.log"
echo "Beginning ncp at $(date)" >> "$LOGDIR/$JOBNAME.err"

nc -l 69 | tar --strip-components=1 --atime-preserve=system --same-permissions --same-owner --extract --zstd -f - -C $DEST/$JOBNAME --verbose 2>>$LOGDIR/$JOBNAME.err 1>>$LOGDIR/$JOBNAME.log
```