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

FROM ubuntu:xenial

# install the team-xbmc ppa
RUN apt-get update                                                        && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:team-xbmc/ppa                                  && \
    apt-get -y purge software-properties-common                           && \
    apt-get -y --purge autoremove                                         && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN packages="kodi kodi-eventclients-xbmc-send ca-certificates" && \
    apt-get update                                              && \
    apt-get install -y --no-install-recommends $packages        && \
    apt-get -y --purge autoremove                               && \
    rm -rf /var/lib/apt/lists/*

# setup entry point
ADD entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# install ALSA
RUN apt-get update                                        && \
    apt-get install -y --no-install-recommends libasound2 && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*