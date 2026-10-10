# Kodi 21 on an NVIDIA GPU, driving a TV from a headless host

This example builds a Kodi 21 (Omega) image that runs a real Xorg server on an
NVIDIA GPU and displays on the TV connected to that GPU's HDMI output - the
setup you want on a server or NAS with a passed-through card, rather than on a
desktop with x11docker.

It exists mainly for one reason: **hardware decoding of 10-bit HEVC (HDR)**.

## Why the VAAPI shim is needed

Kodi's VDPAU decoder only maps the 8-bit profile:

```
# xbmc/cores/VideoPlayer/DVDCodecs/Video/VDPAU.cpp (Matrix, Nexus, Omega, master)
#ifdef VDP_DECODER_PROFILE_HEVC_MAIN
{"HEVC_MAIN", VDP_DECODER_PROFILE_HEVC_MAIN},
```

`HEVC_MAIN10` does not appear anywhere in that file in any released branch, even
though every NVIDIA driver since ~410 advertises it (`vdpauinfo` lists
`HEVC_MAIN_10`).  Because all HDR content is 10-bit, Kodi therefore
**software-decodes every 4K HDR file on NVIDIA**.  `nvidia-vaapi-driver`
exposes NVDEC through VAAPI (which *does* map Main10), and Kodi 20/21 use
ffmpeg's VAAPI hwaccel path.

Measured on an RTX 2070 with a 4K Dolby Vision/HDR10 HEVC remux:

| | Kodi 19 + VDPAU | Kodi 21 + VAAPI/NVDEC |
|---|---|---|
| decoder | ffmpeg software, 12 threads | NVDEC (`VAProfileHEVCMain10`) |
| container CPU | 500-1789 % and dropping frames | 110-390 %, no dropped frames |
| dropped frames (Kodi drop-control log) | continuous | one, at playback start |

## Requirements

* The GPU must be available to the container (`runtime: nvidia` + the
  `NVIDIA_DRIVER_CAPABILITIES=all` / reservation shown in the compose example).
* `NVIDIA_DRIVER_VERSION` in the Dockerfile **must match the host kernel module**
  (`nvidia-smi`).  The X driver and the GLX server module are extracted from that
  exact `.run`; nvidia-container-toolkit injects the GL/compute libraries but not
  the Xorg driver.
* The TV must be connected to the GPU's HDMI output.  This container drives
  `HDMI-0` on `PCI:2:0:0`; adjust `kodi-xorg.conf` for your card.
* Kernel 5.4+ with `nvidia-drm.modeset=1`.

## How it works

1. The entrypoint creates `/dev/nvidia-modeset` (char `195:254`).  Some NAS
   distributions install the NVIDIA driver without that node, and the X driver
   cannot set any display mode without it - Xorg comes up on a 640x480 "NULL"
   mode otherwise.  The container needs
   `device_cgroup_rules: ["c 195:254 rwm"]` to be allowed to open it.
2. Xorg runs *as root* on the GPU: `/dev/tty0` is `0620 root:tty`, and the image
   has no setuid `Xorg.wrap`, so an unprivileged user cannot take the VT.
   `-sharevts -novtswitch` keep VT switching away from the host console.
3. `xset -dpms s off s noblank` keeps the display on: X's own DPMS blanks the
   output after 10 minutes even while Kodi runs, which looks like "Kodi
   stopped".
4. Kodi runs unprivileged (`KODI_UID`/`KODI_GID`, default 1000) with its profile
   in `/data`, and is stopped with SIGTERM for a clean shutdown.

## Audio: know your sink

The HDMI sink is often the TV itself, which usually advertises **2-channel
LPCM** only.  Check what it accepts:

```sh
sudo cat /proc/asound/card*/eld#*        # note: /proc/asound is masked in containers
```

A typical Samsung TV advertises LPCM 2ch, AC-3 6ch and DTS 6ch.  In that case:

* `audiooutput.channels = 2.0` (value 1) so decoded audio is downmixed properly.
  Leaving it at 5.1/7.1 makes Kodi push multichannel PCM at a 2-channel sink -
  the usual symptom is "I hear front left/right and surrounds but no centre and
  no subwoofer".
* enable passthrough only for the formats the sink advertises (AC-3 and DTS
  above).  Kodi 19/21 only offer the passthrough toggles the sink reports.

## Display timing

Set **Adjust display refresh rate** to *On start / stop*
(`videoplayer.adjustrefreshrate = 2`), otherwise a 23.976 fps film is paced into
a 60 Hz mode and looks stuttery.  Verify with `xrandr | grep '\*'` during
playback - the active mode should follow the content (e.g. 3840x2160@23.98).

## Remote control and security

* The webserver (HTTP JSON-RPC + web UI) supports HTTP Basic authentication -
  use it, and keep `advancedsettings.xml`'s `<services>` block authoritative if
  you also touch `guisettings.xml`: advancedsettings overrides it.
* The EventServer (TCP 9090 JSON-RPC over TCP, UDP 9777 remote input) has **no
  authentication whatsoever**; a client can drive Kodi with `{"jsonrpc": "2.0",
  "method": "JSONRPC.Ping", "id": 1}` over TCP 9090 and nothing else.  Leave it
  disabled unless the network is trusted, and never port-forward it.  Modern
  remotes (Kore, Yatse) work fine over the authenticated webserver.
* The EventServer requires a `HELO` packet before it accepts input, which its
  client libraries (and `kodi-send`) send automatically.

## Limitations

* Kodi on X11 has no HDR output path: HDR10 content is tone-mapped to SDR
  (Dolby Vision metadata is ignored).  The GPU decode still pays off; the
  residual CPU use seen in the table above is that tone mapping.
* Kodi 19 also lacks HEVC Main10 in its VDPAU decoder, so use Kodi 20+ for this
  approach (this example uses the distro's Kodi 21.3).
