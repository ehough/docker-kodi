# ehough/docker-kodi

Dockerized Kodi with audio and video.

![Kodi screenshot](https://kodi.wiki/images/3/33/Estuary-home.jpg "Kodi screenshot")

## Features

* fully-functional Kodi installation in a Docker container
* **audio** ([ALSA or PulseAudio](https://kodi.wiki/view/Linux_audio)) and **video** (with optional OpenGL hardware video acceleration) via [x11docker](https://github.com/mviereck/x11docker/)
* simple, Ubuntu-based image that adheres to the [official Kodi installation instructions](https://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux#Installing_Kodi_on_Ubuntu-based_distributions)
* clean shutdown of Kodi when its container is terminated

## Host Prerequisites

The Docker **host** will need the following:

1. **Linux**

   Though not extensively tested yet, this project should work on any Linux distribution.
   
1. **A connected display and speaker(s)**

   If you're looking for a headless Kodi installation, look elsewhere!
   
## Host Installation

1. Install **[X](https://www.x.org/) or [Wayland](https://wayland.freedesktop.org/)**

   Ensure that the packages for an X or Wayland server are present on the Docker host. Please consult your OS's documentation if you're not sure what to install. A display server does *not* need to be running ahead of time.

1. Install **[x11docker](https://github.com/mviereck/x11docker/)**

   `x11docker` allows Docker-based applications to utilize X and/or Wayland on the host. Please follow the `x11docker` [installation instructions](https://github.com/mviereck/x11docker#installation) and ensure that you have a [working setup](https://github.com/mviereck/x11docker#examples) on the Docker host.
       
## Usage


### Starting Kodi

Use `x11docker` to start your desired [Kodi image](#image-tags). Detailing the myriad of `x11docker` options is beyond the scope of this document. Please consult the [`x11docker` documentation](https://github.com/mviereck/x11docker/) to find the set of options that work for your system.

Below is an example command (split into multiple lines for clarity) that starts Kodi on a fresh X.Org X server on virtual terminal 7, with ALSA sound, no window manager, hardware video acceleration, a persistent Kodi home directory, and a shared read-only Docker volume for media files:

    $ x11docker --xorg                            \
                --vt 7                            \
                --alsa                            \
                --wm none                         \                
                --gpu                             \
                --homedir /host/path/to/kodi/home \
                --                                \
                -v /host/path/to/media:/media:ro  \
                erichough/kodi:alsa
                            
By default, the container's entry point will call `kodi-standalone` to start Kodi, which should work well for most installations. If you would like to customize this command, you can utilize the environment variable `KODI_COMMAND`.
This provides the capability to call additional scripts or processes before starting Kodi. For example, to reduce
the priority of the Kodi process:

    $ x11docker ... -- --cap-add SYS_NICE --env KODI_COMMAND="nice kodi-standalone" erichough/kodi

### Stopping Kodi

There are two ways to stop the running Kodi container:

1. **Send `SIGHUP` or `SIGTERM` to the `x11docker` process.** 

       $ kill -SIGTERM <pid>

   **WARNING**: Use *only* `SIGHUP` or `SIGTERM`. Do not use `Ctrl-C` or send any other signal as this can cause Kodi to crash spectacularly.
   
1. **`docker stop`** the Kodi container

       $ docker stop <containerid>
       
Either method will allow Kodi to shut down gracefully, waiting for up to 60 seconds before timing out. If you would
like to customize the timeout, you can utilize the environment variable `KODI_QUIT_TIMEOUT`. For example, to wait
120 seconds before timing out:

    $ x11docker ... -- --env KODI_QUIT_TIMEOUT=120 erichough/kodi

## Image Tags

* ALSA sound, Kodi Krypton
  * `erichough/kodi:latest`
  * `erichough/kodi:alsa`
  * `erichough/kodi:alsa-krypton`
  * `erichough/kodi:alsa-latest`
* PulseAudio sound, Kodi Krypton
  * `erichough/kodi:pulseaudio`
  * `erichough/kodi:pulseaudio-krypton`
  * `erichough/kodi:pulseaudio-latest`

## Contributing

Contributions are welcome! Please submit an issue or pull request.

## Future Work

* Kodi PVR support