# Home Assistant Add-on: Logitech Media Server

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Find the "Logitech Media Server" add-on and click it.
3. Click on the "INSTALL" button.

## Support Notes

I only support it running on 9k you can run it on other ports its untested and unproven.

## Kown Issues
 - Permssions somtimes get nuked and reset to root, known to be an issue with restores from backup, lms doesn't run as root, try toggiling the `'set_permissions` option to correct this.

## How to use

Navigate to the web UI via ingress or directly on port 9000 on your ha server and configure.

### iFrame

substitute hassio.local for you network ip or hostname for home assitant.

```
panel_iframe:

  music:
    title: LMS
    url: http://hassio.local:9000/
    icon: mdi:music-circle-outline
```

## Add-on Configuration

The LMS server add-on can be tweaked to your liking. This section
describes each of the add-on configuration options.

### Basic

default locations
 - /config/lms
This can get quite big due to the chache directory unformiantuly the cache directory isnt just a cache and contains state, so does need to be backed up if you want to restore correctly. For 20k songs somting around the ~650MB is not unexpected. WIP on a cache clean service so this can be done before backup, through this will incease ware on an SD card.

Addional software over lms.
 - osync
 - rsync
 - squeezy

Example basic config:-

```yaml
          "mounts": [],
          "dirs": [],
          "links": [],
          "init_commands": [],
          "packages": []
```

### NAS

NAS mounting in the addon via the settings. So for nfs and cifs/smb3 example:-

```
mounts:
  - 'thepi4.lan:/srv/store/music/ /data/mnt/nfs'
  - '-t smb3 -o user=ha,pass=xxxx //testpi.lan/share /data/mnt/cifs'
  - '--bind /media/music /data/mnt/music'
dirs:
 - /data/mnt/cifs
 - /data/mnt/nfs

links:
  - dest: /data/mnt/music/collection
    link: /var/music
  - link: /srv/storage/incomming/new-music
    dest: /data/mnt/music/new-music
  - link: /srv/storage/music/playlists
    dest: /data/mnt/music/playlists
```
This is all to make sure the mount point exists in an unbacked-up area and the mount options. The  use of links to give more friendly paths,
So in my setup I have mounted media in the underlying OS and then substituted a bind mount for the raw nfs and also used links to make it look like my previous Linux install remain the same so all the paths for trackstat remain the same as I migrated that database.


## AddonOtpions
---

### Option group `Environment`

Flexible disk layout options, additional customisation of packages and startup to allow migration of existing setups.  As well as the installation of plugins.

---

### Option: `skin` (optional)

Name of skin to use for ingress interface.  In this case the material skin is an extra skin installable through lms.  Please do this before enabling this option and restartig the HA addon.  Each skin requires custom support for ingress, currently only material has been tested over the default.

```yaml
skin: material
```

### Option: `mounts` (required may be empty)

Note these paths are not backed up ```[ "/data/music", "/data/mount", "/data/mnt" ]```,

```yaml
mounts:
  - '-t nfs storage-music.lan:/srv/store/music /data/mnt/music'
  - /device/path/name /mount/point/path/location
  - /dev/disk/by-id/dm-name-storage-music /mnt
```

These mounted filesystems are only available in there own container lms's one in the case.

You may need to turn protection mode off, for some devie access for example local disks.

Operation is a describled for debian mount command, best try it out in the terminal addon first to see if it works then just remove the mount command prefix and add to the config as above.

```
mount [-fnrsvw] [-t vfstype] [-o options] device dir
```

### Option: `dirs` (required may be empty)

Directories to create.

```yaml
dirs:
  - /data/mnt/music
```

### Option: `links` (required may be empty)

Links to create.

```yaml
links:
  - dest: /data/mnt/music
    link: /var/music
```

#### Option: `packages` (required may be empty)

Allows you to specify additional [Debian packages][debian-packages] to be
installed in your environment (e.g., Python, Joe, Irssi).

**Note**: _Adding many packages will result in a longer start-up
time for the add-on._

```yaml
packages:
  - rsync
```
#### Option: `init_commands` (required may be empty)

Customize your environment even more with the `init_commands` option.
Add one or more shell commands to the list, and they will be executed every
single time this add-on starts. Before LMS starts

```yaml
init_commands:
  - /config/lms/scripts/fixups.sh
```

### Option group `LMS`

Options affecting the LMS server

---

### Option: `options`

Additional options string to run LMS server with.

```yaml
options: '--nosb1slimp3sync'
```

## Support

Got questions?

You have several options to get them answered:

- The Home Assistant [Community Forum LMS and Squeezelite addon topic][forum].
- The [Home Assistant Discord Chat Server][discord].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

In case you've found a bug, please [open an issue on GitHub][issues].

[debian-packages]: https://packages.debian.org/

[lms]: https://forums.slimdevices.com/
[forum]: https://community.home-assistant.io/t/home-assistant-community-addon-logitech-media-server-lms/338137
[issues]: https://github.com/pssc/ha-addon-lms/issues
[repository]: https://github.com/pssc/ha-addon-lms

[discord]: https://discord.gg/c5DvZ4e
[reddit]: https://reddit.com/r/homeassistant
