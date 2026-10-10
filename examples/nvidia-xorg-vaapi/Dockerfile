# Kodi 21 (Omega) driving a TV through an NVIDIA GPU, headless host.
#
# Example variant of this image for servers/NAS boxes instead of desktops:
#   * Kodi 21.3 from the distribution (no third-party PPA, no source build)
#   * a real Xorg server on the GPU (NVIDIA DDX) so Kodi drives an HDMI output
#   * nvidia-vaapi-driver: NVDEC exposed through VAAPI, so 10-bit HEVC (i.e. all
#     HDR content) is hardware decoded.
#
#   Why the VAAPI shim matters: Kodi's VDPAU decoder only maps
#   VDP_DECODER_PROFILE_HEVC_MAIN (8-bit).  "HEVC_MAIN10" does not appear in
#   xbmc/cores/VideoPlayer/DVDCodecs/Video/VDPAU.cpp in Matrix (19), Nexus (20),
#   Omega (21) or master, so on NVIDIA every 10-bit file falls back to ffmpeg
#   software decoding.  Measured on an RTX 2070 with a 4K Dolby Vision/HDR10
#   HEVC remux: ~1800% CPU and dropped frames before, ~110-390% CPU and no
#   dropped frames with VAAPI+NVDEC.
#
# Build:
#   docker build -t kodi-omega-nvidia examples/nvidia-xorg-vaapi
#
# See README.md in this directory for run/compose examples and the host
# requirements (passthrough of the GPU, /dev/dri, tty devices, audio).
FROM ubuntu:26.04

# Must match the driver of the host kernel module (nvidia-smi): the X driver and
# GLX server module below are extracted from that exact release.
ARG NVIDIA_DRIVER_VERSION=570.172.08
ARG DEBIAN_FRONTEND=noninteractive

# --- Kodi + Xorg + NVIDIA VAAPI shim ---------------------------------------
# The apt step prints a heartbeat so that a reverse proxy in front of a remote
# Docker daemon does not time the build stream out.
RUN set -eux; \
    apt-get update -qq; \
    ( apt-get install -y -qq --no-install-recommends \
        kodi kodi-inputstream-adaptive \
        xserver-xorg-core x11-utils x11-xserver-utils \
        nvidia-vaapi-driver libva2 libva-drm2 vainfo \
        libgl1 libglu1-mesa libegl1 libdrm2 \
        alsa-utils curl ca-certificates tzdata bash util-linux \
        >/tmp/apt.log 2>&1; echo $? >/tmp/apt.rc ) & \
    ap=$!; while kill -0 $ap 2>/dev/null; do echo "[apt] installing kodi + xorg + vaapi shim..."; sleep 10; done; \
    wait $ap || true; rc=$(cat /tmp/apt.rc); tail -6 /tmp/apt.log; [ "$rc" = "0" ]; \
    rm -rf /var/lib/apt/lists/*

# --- NVIDIA X driver (DDX) + GLX server module -----------------------------
# Taken from the official .run of the same version as the host kernel module.
# Not shipped by any distribution, and nvidia-container-toolkit only injects the
# user space GL/compute libraries, not the Xorg driver.
RUN set -eux; \
    ( curl -fsSLo /tmp/nv.run \
        "https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run" \
      && sh /tmp/nv.run --extract-only --target /tmp/nv >/tmp/nvextract.log 2>&1; echo $? >/tmp/nv.rc ) & \
    nv=$!; while kill -0 $nv 2>/dev/null; do echo "[nvidia] fetching/extracting ${NVIDIA_DRIVER_VERSION}..."; sleep 10; done; \
    wait $nv || true; rc=$(cat /tmp/nv.rc); tail -3 /tmp/nvextract.log; [ "$rc" = "0" ]; \
    install -Dm644 /tmp/nv/nvidia_drv.so /usr/lib/xorg/modules/drivers/nvidia_drv.so; \
    install -Dm644 "/tmp/nv/libglxserver_nvidia.so.${NVIDIA_DRIVER_VERSION}" \
        /usr/lib/xorg/modules/extensions/libglxserver_nvidia.so; \
    rm -rf /tmp/nv /tmp/nv.run /tmp/nvextract.log /tmp/nv.rc

# --- unprivileged runtime user (KODI_UID/KODI_GID below) -------------------
ARG KODI_UID=1000
ARG KODI_GID=1000
RUN set -eux; \
    groupadd -g "${KODI_GID}" kodi; \
    useradd -u "${KODI_UID}" -g "${KODI_GID}" -d /data -s /bin/bash kodi; \
    usermod -aG video,render,audio kodi || true; \
    install -d -o kodi -g kodi /data

COPY kodi-xorg.conf /etc/X11/kodi-xorg.conf
COPY kodi-xorg-entrypoint.sh /usr/local/bin/kodi-xorg-entrypoint.sh
COPY advancedsettings.xml sources.xml.example /usr/share/kodi-seed/
RUN chmod 0755 /usr/local/bin/kodi-xorg-entrypoint.sh

# Everything in the container uses NVDEC through VAAPI.
ENV LIBVA_DRIVER_NAME=nvidia

ENTRYPOINT ["/usr/local/bin/kodi-xorg-entrypoint.sh"]
