## [0.0.41] 2020-01-14

### Fixes
 - build

### Changes
 - tidy debug buid package install

### Added
 - use init to mount tmpfs fort var/run if started with right perms

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

