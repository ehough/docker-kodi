# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018-2020 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM ubuntu:bionic

# install the team-xbmc ppa
RUN apt-get update                                                        && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:team-xbmc/ppa                                  && \
    apt-get -y purge openssl software-properties-common                   && \
    apt-get -y --purge autoremove                                         && \
    rm -rf /var/lib/apt/lists/*

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons
#  - kodi-game-libretro-*         Libretro cores
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-*            enables the use of gamepads, joysticks, game controllers, etc.
#  - kodi-pvr-*                   PVR add-ons
#  - kodi-screensaver-*           additional screensavers
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
RUN packages="                                               \
                                                             \
    ca-certificates                                          \
    kodi=2:18.7+*                                            \
    kodi-eventclients-kodi-send                              \
    kodi-game-libretro                                       \
    kodi-game-libretro-beetle-pce-fast                       \
    kodi-game-libretro-beetle-vb                             \
    kodi-game-libretro-beetle-wswan                          \
    kodi-game-libretro-bsnes-mercury-accuracy                \
    kodi-game-libretro-bsnes-mercury-balanced                \
    kodi-game-libretro-bsnes-mercury-performance             \
    kodi-game-libretro-desmume                               \
    kodi-game-libretro-fbalpha                               \
    kodi-game-libretro-fbalpha2012                           \
    kodi-game-libretro-fuse                                  \
    kodi-game-libretro-gambatte                              \
    kodi-game-libretro-prboom                                \
    kodi-game-libretro-stella                                \
    kodi-game-libretro-tgbdual                               \
    kodi-game-libretro-vba-next                              \
    kodi-game-libretro-virtualjaguar                         \
    kodi-inputstream-adaptive                                \
    kodi-inputstream-rtmp                                    \
    kodi-peripheral-joystick                                 \
    kodi-peripheral-xarcade                                  \
    kodi-pvr-argustv                                         \
    kodi-pvr-dvblink                                         \
    kodi-pvr-dvbviewer                                       \
    kodi-pvr-filmon                                          \
    kodi-pvr-hdhomerun                                       \
    kodi-pvr-hts                                             \
    kodi-pvr-iptvsimple                                      \
    kodi-pvr-mediaportal-tvserver                            \
    kodi-pvr-mythtv                                          \
    kodi-pvr-nextpvr                                         \
    kodi-pvr-njoy                                            \
    kodi-pvr-octonet                                         \
    kodi-pvr-pctv                                            \
    kodi-pvr-sledovanitv-cz                                  \
    kodi-pvr-stalker                                         \
    kodi-pvr-teleboy                                         \
    kodi-pvr-vbox                                            \
    kodi-pvr-vdr-vnsi                                        \
    kodi-pvr-vuplus                                          \
    kodi-pvr-wmc                                             \
    kodi-pvr-zattoo                                          \
    kodi-screensaver-asteroids                               \
    kodi-screensaver-asterwave                               \
    kodi-screensaver-biogenesis                              \
    kodi-screensaver-cpblobs                                 \
    kodi-screensaver-greynetic                               \
    kodi-screensaver-matrixtrails                            \
    kodi-screensaver-pingpong                                \
    kodi-screensaver-pyro                                    \
    kodi-screensaver-stars                                   \
    locales                                                  \
    pulseaudio                                               \
    tzdata"                                               && \
                                                             \
    apt-get update                                        && \
    apt-get install -y --no-install-recommends $packages  && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*

# setup entry point
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
