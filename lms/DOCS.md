# Home Assistant Add-on: Logitech Media Server

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Find the "Logitech Media Server" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

Navigate to the web UI via ingress or directly on port 9000 on your ha server and configure.

### iFrame

Sub hassio.local for you network ip or hostname

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

NAS mounting in the addon via the settings. So for nfs and cifs example:-

```
mounts:
  - 'thepi4.lan:/srv/store/music/ /data/mnt/nfs'
  - '-t cifs -o user=ha,pass=xxxx //testpi.lan/share /data/mnt/cifs'
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

Name of skin to use for ingress interface.

```yaml
skin: material
```

### Option: `mounts` (required may be empty)

Note these paths are not backed up ```[ "/data/music", "/data/mount", "/data/mnt" ]```,

```yaml
mounts:
  - '-t nfs storage-music.lan:/srv/store/music /data/mnt/music'
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
