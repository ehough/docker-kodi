# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018 - Eric Hough (eric@tubepress.com)
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


########################################################################################################################

# kodi-eventclients-kodi-send allows us to shut down Kodi gracefully upon container termination, but until Debian
# catches up to Leia, we'll need to use a multistage build to install /usr/bin/kodi-send

FROM ubuntu:bionic AS events_client

RUN apt-get update && apt-get install -y --no-install-recommends kodi-eventclients-kodi-send


########################################################################################################################

FROM ubuntu:bionic

COPY --from=events_client /usr/bin/kodi-send                    /usr/bin/kodi-send
COPY --from=events_client /usr/lib/python2.7/dist-packages/kodi /usr/lib/python2.7/dist-packages/kodi

# install the team-xbmc ppa
RUN apt-get update                                                        && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:team-xbmc/ppa                                  && \
    apt-get -y purge ca-certificates openssl software-properties-common   && \
    apt-get -y --purge autoremove                                         && \
    rm -rf /var/lib/apt/lists/*

# install base packages
# tzdata is necessary for timezone functionality (see https://github.com/mviereck/x11docker/issues/50)
RUN packages="kodi tzdata"                               && \
    apt-get update                                       && \
    apt-get install -y --no-install-recommends $packages && \
    apt-get -y --purge autoremove                        && \
    rm -rf /var/lib/apt/lists/*

# setup entry point
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# install optional packages. do this last so we can cache the above layers between branches
RUN packages="                                              \
    kodi-pvr-argustv                                        \
    kodi-pvr-dvblink                                        \
    kodi-pvr-dvbviewer                                      \
    kodi-pvr-filmon                                         \
    kodi-pvr-hdhomerun                                      \
    kodi-pvr-hts                                            \
    kodi-pvr-iptvsimple                                     \
    kodi-pvr-mediaportal-tvserver                           \
    kodi-pvr-mythtv                                         \
    kodi-pvr-nextpvr                                        \
    kodi-pvr-njoy                                           \
    kodi-pvr-octonet                                        \
    kodi-pvr-pctv                                           \
    kodi-pvr-stalker                                        \
    kodi-pvr-teleboy                                        \
    kodi-pvr-vbox                                           \
    kodi-pvr-vdr-vnsi                                       \
    kodi-pvr-vuplus                                         \
    kodi-pvr-wmc                                            \
    kodi-pvr-zattoo                                         \
    pulseaudio"                                          && \
    apt-get update                                       && \
    apt-get install -y --no-install-recommends $packages && \
    apt-get -y --purge autoremove                        && \
    rm -rf /var/lib/apt/lists/*
