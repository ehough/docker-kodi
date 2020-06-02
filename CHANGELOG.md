# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [2.6.0] - 2020-06-02

### Changed

* Bump to [Kodi 18.7](https://kodi.tv/article/kodi-leia-187-release)

### Added

* Support for the [X-Arcade Tankstick](https://kodi.wiki/view/HOW-TO:X-Arcade_Tankstick_in_Kodi)

## [2.5.0] - 2020-03-03

### Changed

* Bump to [Kodi 18.6](https://kodi.tv/article/kodi-leia-186-release)

### Added

* Additional spoken language support via `locales` package ([#33](https://github.com/ehough/docker-kodi/issues/30))
* CpBlobs screensaver

## [2.4.0] - 2019-12-10

### Changed

* Bump to [Kodi 18.5](https://kodi.tv/article/kodi-leia-185-release)

### Added

* Libretro cores
  * [Bandai - WonderSwan/Color (Beetle Cygne)](http://docs.libretro.com/library/beetle_cygne/)
  * [NEC - PC Engine / CD (Beetle PCE FAST)](http://docs.libretro.com/library/beetle_pce_fast/)
  * [Nintendo - DS (DeSmuME)](http://docs.libretro.com/library/desmume/)
  * [Nintendo - SNES / Famicom (bsnes-mercury Accuracy)](http://docs.libretro.com/library/bsnes_mercury_accuracy/)
  * [Nintendo - SNES / Famicom (bsnes-mercury Balanced)](http://docs.libretro.com/library/bsnes_mercury_balanced/)
  * [Nintendo - SNES / Famicom (bsnes-mercury Performance)](http://docs.libretro.com/library/bsnes_mercury_performance/)
  * [Nintendo - Virtual Boy (Beetle VB)](http://docs.libretro.com/library/beetle_vb/)
* Kodi screensavers
  * [Asteroids](https://kodi.tv/addon/screensaver/asteroids)
  * [Asterwave](https://kodi.tv/addon/screensaver/asterwave)
  * [BioGenesis](https://kodi.tv/addon/screensaver/biogenesis)
  * [Greynetic](https://kodi.tv/addon/screensaver/greynetic)
  * [Matrix trails](https://kodi.tv/addon/screensaver/matrix-trails)
  * [Ping Pong](https://kodi.wiki/view/Add-on:Ping_Pong)
  * [Pyro](https://kodi.tv/addon/screensaver/pyro)
  * [Stars](https://kodi.tv/addon/screensaver/stars)

## [2.3.0] - 2019-06-27

### Changed

* Bump to [Kodi 18.3](https://kodi.tv/article/kodi-leia-183-release)

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
