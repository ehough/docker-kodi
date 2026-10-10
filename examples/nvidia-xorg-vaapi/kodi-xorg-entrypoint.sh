#!/bin/bash
# Kodi 21 (Omega) on the NVIDIA HDMI output (TrueNAS NAS).
#
# 1. provides /dev/nvidia-modeset (TrueNAS' driver install does not create it and
#    the NVIDIA X driver needs it to set display modes);
# 2. runs Xorg on the GPU (NVIDIA DDX) on the TV output and keeps DPMS off;
# 3. runs Kodi as the unprivileged user, with SIGTERM handling for clean exit.
set -e

DISPLAY_NUM="${KODI_XORG_DISPLAY:-:0}"
XORG_CONF=/etc/X11/kodi-xorg.conf
XORG_LOG=/data/.kodi/temp/Xorg.log
UID_GID=568

[ -e /dev/nvidia-modeset ] || mknod /dev/nvidia-modeset c 195 254
chmod 666 /dev/nvidia-modeset

mkdir -p /data/.kodi/temp /data/.kodi/userdata
chown -R ${UID_GID}:${UID_GID} /data

# seed default config once -- never overwrite user changes
for f in advancedsettings.xml sources.xml; do
    [ -f "/data/.kodi/userdata/$f" ] || cp "/usr/share/kodi-seed/$f" "/data/.kodi/userdata/$f"
    chown ${UID_GID}:${UID_GID} "/data/.kodi/userdata/$f"
done

# stale locks from an unclean shutdown would block the new server
rm -f "/tmp/.X${DISPLAY_NUM#:}-lock" "/tmp/.X11-unix/X${DISPLAY_NUM#:}" 2>/dev/null || true

echo "[kodi-xorg] starting Xorg on the NVIDIA HDMI output"
Xorg ${DISPLAY_NUM} -config ${XORG_CONF} -logfile ${XORG_LOG} \
    -noreset -sharevts -novtswitch -ac -nolisten tcp &

ready=0
for _ in $(seq 1 60); do
    if su kodi -c "DISPLAY=${DISPLAY_NUM} xdpyinfo >/dev/null 2>&1"; then
        ready=1
        break
    fi
    sleep 1
done

if [ "$ready" != "1" ]; then
    echo "[kodi-xorg] ERROR: Xorg did not come up on ${DISPLAY_NUM}; see ${XORG_LOG}" >&2
    exit 1
fi

OUTPUT=$(su kodi -c "DISPLAY=${DISPLAY_NUM} xrandr 2>/dev/null | grep -m1 ' connected'" || true)
echo "[kodi-xorg] Xorg up on ${DISPLAY_NUM} ${OUTPUT}"

# kiosk: never blank the TV (X DPMS blanked the output after 10 min idle)
DISPLAY=${DISPLAY_NUM} xset -dpms s off s noblank >/dev/null 2>&1 || true

stop_kodi() {
    echo "[kodi-xorg] container stopping -- SIGTERM to Kodi"
    pkill -TERM -x kodi.bin 2>/dev/null || true
    for _ in $(seq 1 20); do
        pgrep -x kodi.bin >/dev/null || break
        sleep 1
    done
    [ -n "${kodi_child:-}" ] && kill -TERM "$kodi_child" 2>/dev/null || true
}
trap stop_kodi TERM INT

# Kodi runs unprivileged; HOME/KODI_DATA keep its profile in the mounted volume
setpriv --reuid=${UID_GID} --regid=${UID_GID} --init-groups \
    env HOME=/data DISPLAY=${DISPLAY_NUM} KODI_DATA=/data/.kodi \
    /usr/bin/kodi --standalone &
kodi_child=$!

wait "$kodi_child" || true
echo "[kodi-xorg] Kodi exited; container will stop"
