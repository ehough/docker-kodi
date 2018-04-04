# ehough/docker-kodi

Dockerized Kodi with audio and video.

![Kodi screenshot](https://kodi.wiki/images/3/33/Estuary-home.jpg "Kodi screenshot")

## Why?

This is the only setup that offers a fully-functional, Dockerized Kodi installation complete with audio and video.

This project is in an early stage of development, but has been operating on the author's HTPC for a long time without issue. Contributions and suggestions are welcome.

## Features

* video and audio via [x11docker](https://github.com/mviereck/x11docker/)
* optional hardware video acceleration
* sound via ALSA or PulseAudio
* simple, Ubuntu-based image that adheres to the [official Kodi installation instructions](https://kodi.wiki/view/HOW-TO:Install_Kodi_for_Linux#Installing_Kodi_on_Ubuntu-based_distributions)
* clean shutdown of Kodi when its container is terminated

## Host Requirements

The Docker **host** will need the following:

1. **Linux**

   Though not extensively tested yet, this project should work on any Linux distribution. Windows support is not yet implemented.
   
1. **A connected display & speakers**
   
## Installation

Installation is easy.
   
1. **Install [x11docker](https://github.com/mviereck/x11docker/)**

   `x11docker` allows Docker-based applications to utilize X and/or Wayland. Please follow the `x11docker` [installation instructions](https://github.com/mviereck/x11docker#installation) and ensure that you have a [working setup](https://github.com/mviereck/x11docker#examples).
   
1. **Install [X](https://www.x.org/) or [Wayland](https://wayland.freedesktop.org/)**

   Ensure that the packages for an X or Wayland server are installed. Please consult your OS's documentation if you're not sure what to install. A display server does *not* need to be running ahead of time.
   
1. **Clone this repo to your Docker host**
   
       $ git clone https://github.com/ehough/docker-kodi
       
   The exact location of your clone doesn't matter.
       
## Usage

`docker-kodi.sh` is the script that you will use to cleanly start and stop Kodi. It's a simple wrapper around `x11docker` and the Docker CLI.

    Usage: docker-kodi.sh [-a|--action <arg>] [-i|--image <arg>] [-h|--help] [-v|--verbose] [--] [<x11docker-argument-1>] ... [<x11docker-argument-n>] ...
        <x11docker-argument>: arguments to pass to x11docker
        -a,--action: action to perform (start, stop, or status (default: 'start')
        -i,--image: image name or identifier to execute (default: 'ehough/kodi:alsa')
        -h,--help: Prints help
        -v,--verbose: Set verbose output (can be specified multiple times to increase the effect)

### Starting Kodi

To start Kodi, invoke `docker-kodi.sh` with your desired image variant (`ehough/kodi:alsa` or `ehough/kodi:pulseaudio`) and arguments to `x11docker`. Arguments following the first `--` delimeter (if present) are passed directly to `x11docker`.
This gives you tremendous flexibility in configuring your environment.

e.g. for ALSA sound, no window manager, a new Xorg X server on virtual terminal 7, hardware video acceleration, a persistent Kodi home directory, and a shared read-only Docker volume for Kodi media:

    $ /path/to/docker-kodi.sh --image ehough/kodi:alsa          \
                              --                                \
                              --wm none                         \
                              --xorg                            \
                              --gpu                             \
                              --alsa							\
                              --homedir /host/path/to/kodi/home \
                              --vt 7							\
                              --								\
                              -v /host/path/to/media:/media:ro
                            
Detailing the myriad of `x11docker` options is beyond the scope of this document. Please consult the [`x11docker` documentation](https://github.com/mviereck/x11docker/) to find the set of options that work for your system.

### Stopping Kodi

Either `Ctrl-C` the running `docker-kodi.sh` process or call:

    $ docker-kodi.sh --action stop

Under the hood, this will call `docker stop` on the Kodi container, which allows Kodi to shut itself down properly.

## Contributing

Contributions are welcome! Please submit an issue or pull request.

## Future Work

* Windows support
* Kodi PVR support
