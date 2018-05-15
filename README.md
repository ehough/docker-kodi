# erichough/kodi

Dockerized Kodi with audio and video.

![Kodi screenshot](https://kodi.tv/sites/default/files/page/field_image/about--devices.jpg "Kodi screenshot")

## Features

* fully-functional [Kodi](https://kodi.tv/) installation in a [Docker](https://www.docker.com/) container
* **audio** ([ALSA or PulseAudio](https://kodi.wiki/view/Linux_audio)) and **video** (with optional OpenGL hardware 
  video acceleration) via [x11docker](https://github.com/mviereck/x11docker/)
* simple, Ubuntu-based image that adheres to the [official Kodi installation instructions](https://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux#Installing_Kodi_on_Ubuntu-based_distributions)
* clean shutdown of Kodi when its container is terminated

## Host Prerequisites

The host system will need the following:

1. **Linux** and [**Docker**](https://www.docker.com)

   Though not yet extensively tested, this image should work on any Linux distribution with a functional
   Docker installation.
   
1. **A connected display and speaker(s)**

   If you're looking for a headless Kodi installation, look elsewhere!

1. **[X](https://www.x.org/) or [Wayland](https://wayland.freedesktop.org/)**

   Ensure that the packages for an X or Wayland server are present on the Docker host. Please consult your OS's 
   documentation if you're not sure what to install. A display server does *not* need to be running ahead of time.

1. **[x11docker](https://github.com/mviereck/x11docker/)**

   `x11docker` allows Docker-based applications to utilize X and/or Wayland on the host. Please follow the `x11docker` 
   [installation instructions](https://github.com/mviereck/x11docker#installation) and ensure that you have a 
   [working setup](https://github.com/mviereck/x11docker#examples) on the Docker host.
       
## Usage

### Starting Kodi

Use `x11docker` to start the `erichough/kodi` Docker image (or one of its [variants](#image-variants)). Detailing the 
myriad of `x11docker` options is beyond the scope of this document; please consult the 
[`x11docker` documentation](https://github.com/mviereck/x11docker/) to find the set of options that work for your 
system.

Below is an example command (split into multiple lines for clarity) that starts Kodi with a fresh X.Org X server on 
virtual terminal 7 with PulseAudio sound, no window manager, hardware video acceleration, a persistent Kodi home 
directory, and a shared read-only Docker mount for media files:

    $ x11docker --xorg                                \
                --vt 7                                \
                --pulseaudio                          \
                --wm none                             \                
                --gpu                                 \
                --homedir /host/path/to/kodi/home     \
                -- "-v /host/path/to/media:/media:ro" \
                erichough/kodi
           
Note that the optional argument passed after `--`, which defines additional arguments to be passed to `docker run`, 
needs to be enclosed in quotes.

### Stopping Kodi

You can shut down Kodi just as you normally would; i.e. by using the power menu from the Kodi home screen. 
Behind the scenes, the Docker container and `x11docker` processes will terminate cleanly.

You can also [terminate the container from the command line](doc/advanced.md#command-line-shutdown).

### Example systemd Service Unit

    [Unit]
    Description=Dockerized Kodi
    Requires=docker.service
    After=network.target docker.service
    
    [Service]
    ExecStartPre=/usr/bin/docker pull erichough/kodi
    ExecStart=/usr/bin/x11docker ... erichough/kodi
    Restart=always
    KillMode=process
    
    [Install]
    WantedBy=multi-user.target

## Image Variants

The default `erichough/kodi` image should work well on all systems. Images tagged with `alsa` do not include PulseAudio
and are slightly smaller in size.

|                  | Universal (works everywhere) | ALSA *only* (slightly smaller image) |
|------------------|---------------------------------------------|--------------------------------------|
| **Kodi Krypton** |  `erichough/kodi`                    | `erichough/kodi:alsa`                |
|                  |                                             |                                      |

## Advanced

The [advanced topics](doc/advanced.md) documentation describes a few more useful features and functionality.

## Contributing

Constructive criticism and contributions are welcome! Please 
[submit an issue](https://github.com/ehough/docker-kodi/issues/new) or 
[pull request](https://github.com/ehough/docker-kodi/compare).

## Future Work

* Kodi PVR support