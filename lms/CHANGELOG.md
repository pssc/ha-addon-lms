## [0.0.46] 2021-07-05

### Changes
 - Multi part Docker build to reduce image size for perl modules build
 - remove support of squeezelite/localplayer to its own addon https://github.com/pssc/ha-addon-squeezelite
 - Refactor udev support.
 - Update base to debian-addon 4.2.2
 - LMS fixed to version 8.1.1

## [0.0.45] 2021-06-05

### Fixes
 - Fix image build issues
 - Fix memory based run mount
 - Fix /proc/asound after enabling audio
 - Fix for pulse audio permission issues with squeezebox running as an alternate user

### Changes
 - Change to pre built images
 - Change /config to allow exec for plugins to work better
 - Chnage output from lms to be line buffered for better logging 

### Added
 - Audio support in container
 - Packages for sqeezelite decoding possibly via localPlayer addon

## [0.0.44] 2020-03-07

### Fixes
 - tmpfs chnages
 - random volume creation
 - Minor information message correction

## [0.0.41] 2020-01-14

### Fixes
 - build

### Changes
 - tidy debug build package install

### Added
 - use init to mount tmpfs for /var/run, if started with right perms

## [0.0.40] 2020-01-14

### Changes
 - Build CPAN modules from source
 - Reduce image size
 - Reduce layers
 - turn of debug by default.

## [0.0.40] 2020-01-05

### Fixes
 - adm64 build
 - squeezy config for sensors

### Changes
 - Tidy Dockerfile whitespace

## [0.0.38] 2020-12-29

### Added
 - Sensors
 - Add extfat support
 - Support for media dir

### Fixes
 - Setup reqirements

## [0.0.37] 2020-08-05

### Added
 - Documentation, split and updated
 - udev supoort for direct mounting

### Changes
 - Better logging of mounts
 - Auto set name from container name.
 - Generic dir creation

### Fixes
 - package installation

## [0.0.36] 2020-06-07
### Added
 - Allow for custom init scripts and packages

### Changes
 - Increase shutdown timeout to allow cleanup and run from ram
 - Use better logos and icons 
 - Make build image versions consistant
 - Be more descriptive and indicate self build repo
 - Better description to Docker image labels 
 - Better logging of mounts
 - Auto set name from container name.

### Fixes
 - Ajax requests for ingress for trackstat
 - Change log formatting 

## [0.0.34] 2020-06-18
### Added
 - README.md for addon interface desribing basic addional functions

### Changes

### Fixes
 - Change log formatting

## [0.0.33] 2020-05-17
### Added
- Support for multiple links
- Support for multiple mounts
- Support for multiple directories
- Change log ;-)

### Changes
- Expire single mount support

### Fixes
- Container startup ordering

