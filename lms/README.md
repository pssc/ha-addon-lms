# Home Assistant Community Add-on: lms (Logitech Media Server)

A complete and easy way to run the [Logitech Media Server][lms].

[Logitech Media Server][lms] is a cross-platform streaming media server that supports a wide range
 of formats, including AAC, AIFF, FLAC, Ogg Vorbis, MP3, WAV, and WMA.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpssc%2Fha-addon-lms%2F) or use the following addon repo manually https://github.com/pssc/ha-addon-lms/ in the supervisor addon tab following the stacked triple dots and selecting repositories.

This addon is based on the debian package for version 8.3.1 from https://downloads.slimdevices.com/
| :warning: Unfortunately the latest Squeezebox Radio firmware (7.7.3) comes with a bug which prevents it from connecting correctly to Logitech Media Server 8+. See https://github.com/Logitech/slimserver#sb-radio-and-logitech-media-server-8 for details and an easy mitigation. |
| --- |

![Release][release-shield] ![Project Stage][project-stage-shield] ![Project Maintenance][maintenance-shield] [![Discord][discord-shield]][discord] [![Community Forum][forum-shield]][forum]<br>
![Supports i386 Architecture][i386-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports aarch64 Architecture][aarch64-shield]

This addon provides flexible disk layout options, additional customisation of packages and start-up to allow migration of existing setups.  As well as the installation of plugins and dependencies.
An additional related addon is available a [squeezelite player](https://github.com/pssc/ha-addon-squeezelite) for the Logitech Media Server.

* Flexible disk layout options (WIP, NFS, CIFS, dirs, links, /Media are available)
* Migration from existing installs (WIP)
* rsync support (WIP)
* osync support (WIP)
* tmpfs options (planned)
* *Most certainly* doesn't mine bitcoin on your home automation server.  Definitely no.

See the [Docs on GitHub](https://github.com/pssc/ha-addon-lms/tree/master/lms/DOCS.md) for all the details, or just install the add-on and open the Web UI.

## Support
Create an [issue on github][issues], or if its a general query ask on the [home assistant thread][forum]

The i386 build is becomming increasingly difficult and should be considered at risk.

[maintenance-shield]: https://img.shields.io/maintenance/yes/2023.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-beta-yellow.svg
[release-shield]: https://img.shields.io/badge/version-v8.3.1.56-blue.svg
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[discord-shield]: https://img.shields.io/discord/478094546522079232.svg

[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-yellow.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg

[lms]: https://forums.slimdevices.com/
[forum]: https://community.home-assistant.io/t/home-assistant-community-addon-logitech-media-server-lms/338137
[issues]: https://github.com/pssc/ha-addon-lms/issues
[discord]: https://discord.me/hassioaddons
