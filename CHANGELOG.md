# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2019-05-28

### Changed

* Bump to [Kodi 18.2](https://kodi.tv/article/kodi-leia-182-release)

### Added

* Libretro cores
  * [Arcade (FB Alpha)](https://docs.libretro.com/library/fb_alpha/)
  * [Arcade (FB Alpha 2012)](https://docs.libretro.com/library/fb_alpha_2012/)
  * [Atari - 2600 (Stella)](http://docs.libretro.com/library/stella/)
  * [Atari - Jaguar (Virtual Jaguar)](http://docs.libretro.com/library/virtual_jaguar/)
  * [Doom (PrBoom)](http://docs.libretro.com/library/prboom/)
  * [Nintendo - Game Boy / Color (Gambatte)](http://docs.libretro.com/library/gambatte/)
  * [Nintendo - Game Boy / Color (TGB Dual)](http://docs.libretro.com/library/tgb_dual/)
  * [Nintendo - Game Boy Advance (VBA Next)](http://docs.libretro.com/library/vba_next/)
  * [ZX Spectrum (Fuse)](http://docs.libretro.com/library/fuse/)
* PVR add-on: [Sledovanitv.cz](https://kodi.wiki/view/Add-on:Sledovanitv.cz_PVR_Client)

## [2.1.0] - 2019-02-14

### Added

* Support for game controllers, joysticks, gamepads, etc.
* Support for Libretro cores as game add-ons
* Input stream add-ons ([#12](https://github.com/ehough/docker-kodi/pull/12)):
  * [Adaptive](https://github.com/peak3d/inputstream.adaptive)
  * [RTMP](https://github.com/xbmc/inputstream.rtmp)

### Removed

* `pulseaudio`, `alsa`, and `pvr` image tags as there was only a 6% savings in image size

## [2.0.1] - 2019-02-06

### Fixed

* Outgoing HTTPS connections failed due to missing CA certificates

## [2.0.0] - 2019-02-04

### Changed

* Upgrade to [Kodi 18.0 "Leia"](https://kodi.tv/article/kodi-180)

### Added

* New PVR add-ons
  * [FilmOn](https://kodi.wiki/view/PVR/Backend/FilmOn)
  * [Stalker](https://kodi.wiki/view/Add-on:Stalker_Client)
  * [Teleboy](https://kodi.wiki/view/Add-on:Teleboy_PVR_Client)
  * [WMC](https://kodi.wiki/view/Add-on:PVR_WMC_Client)
  * [Zattoo Box](https://kodi.wiki/view/Add-on:Zattoo_Box)
  

## [1.2.0] - 2018-09-06

### Added

* MediaPortal TV-Server PVR support

### Fixed

* Wrong timezone / timezone can not be set ([#5](https://github.com/ehough/docker-kodi/issues/5))

## [1.1.0] - 2018-05-24

### Added

* PVR support (#4)
* New selection of image tags: `latest`, `pulseaudio`, `alsa`, or `pvr`

### Changed

* Base image is now `ubuntu:bionic` (was `ubuntu:xenial`)
* Ditched `ca-certificates` as it was not needed

## [1.0.0] - 2018-05-15
Initial release.