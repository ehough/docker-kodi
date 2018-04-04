#!/bin/bash

# ehough/docker-kodi - Kodi in a Docker container
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


##########################################################################
# This script is the entrypoint for the Kodi container and has two jobs:
#
# 1. start Kodi by calling kodi-standalone (configurable via environment
#    variable KODI_COMMAND).
#
# 2. cleanly stop Kodi when the container terminates, waiting up to 10
#    seconds (configurable via environment variable KODI_QUIT_TIMEOUT)
#    before itself exiting.
#
##########################################################################


readonly ENV_VAR_KODI_COMMAND="KODI_COMMAND"
readonly ENV_VAR_KODI_QUIT_TIMEOUT="KODI_QUIT_TIMEOUT"

log () {

  echo "---> $1"
}

get_sound_package () {

  for package in libasound2 pulseaudio; do

    if [[ "$(dpkg -s $package 2&> /dev/null)" -eq 0 ]]; then
      echo "$package"
      break
    fi
  done
}

stop_kodi () {

  if [[ -z $(pidof kodi.bin) ]]; then
    log "Kodi did not appear to be running"
    exit 0
  fi

  local timer
  local remaining
  local -r timeout="${!ENV_VAR_KODI_QUIT_TIMEOUT:-10}"
  timer=0

  log "asking Kodi to quit"
  kodi-send --action="Quit"

  while [[ $timer -lt $timeout && -n $(pidof kodi.bin) ]]; do

    remaining=$((timeout - timer))

    log "waiting for Kodi to terminate ($remaining seconds until timeout)"
    sleep 1
    timer=$((timer+1))
  done

  if [[ -z $(pidof kodi.bin) ]]; then
    log 'Kodi terminated successfully'
    exit 0
  fi

  log 'WARNING: timeout reached'
}

start_kodi () {

  local -r command="${!ENV_VAR_KODI_COMMAND:-kodi-standalone}"

  if [[ -z $(get_sound_package) ]]; then
    log "FATAL ERROR: libasound2 or pulseaudio is required to run Kodi"
    exit 1
  fi

  # gracefully stop Kodi whenever this script is terminated for any reason
  trap stop_kodi EXIT

  log "starting Kodi with command: $command"

  "$command"
}

start_kodi