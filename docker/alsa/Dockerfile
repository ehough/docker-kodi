##########################################################################
#
# ehough/docker-kodi - Kodi in a Docker container (ALSA sound)
#
# https://github.com/ehough/docker-kodi
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
#
##########################################################################

FROM ehough/kodi-base:krypton

# install ALSA
RUN apt-get update                                        && \
    apt-get install -y --no-install-recommends libasound2 && \
    apt-get -y --purge autoremove                         && \
    rm -rf /var/lib/apt/lists/*
