# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [unreleased]

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