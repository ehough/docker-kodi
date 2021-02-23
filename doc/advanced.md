# Advanced Topics

This page details available features that most users won't likely need.

* [Custom add-ons](#custom-add-ons)
* [Image Variants](#image-variants)
* [Custom Startup Behavior](#custom-startup-behavior)
* [Command-Line Shutdown](#command-line-shutdown)

---

## Custom add-ons

In an effort to control the size of this image, some optional Kodi add-ons (e.g. PVRs, audio formats, screensavers, games, and visualizations) are not bundled by default. If we included each add-on, the image would grow to over 1 GB in size and continue to expand over time.

Since this image is based on Linux, add-ons will [need to be installed manually](https://kodi.wiki/view/Ubuntu_binary_add-ons). So how can you install the add-ons you need? Easily build your own custom image using the `KODI_EXTRA_PACKAGES` [build argument](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg). Its value is a space-separated list of additional packages that you'd like to install into the image.

As an example, let's say that you want to run Kodi using this image, but you also want the [Pluto TV PVR add-on](https://kodi.wiki/view/Add-on:Pluto.TV) and a [Libretro core](https://kodi.wiki/view/Libretro) for [Atari](https://kodi.wiki/view/Game_add-ons#Libretro_cores). You could build a custom image using the command:

```shell script
docker build                                                        \
         --build-arg="kodi-pvr-plutotv kodi-game-libretro-atari800" \
         erichough/kodi
```

Add-on package names can be found [here](https://launchpad.net/~team-xbmc/+archive/ubuntu/ppa?field.series_filter=focal), and you can install *any* Ubuntu package that you'd like.

## Image Variants

You can run an older version of Kodi, if you'd like to, by using the appropriate image tag.

| tag       | Kodi
|-----------|--------------|
| `latest`  | v19 "Matrix" | 
| `leia`    | v18 "Leia"   | 
| `krypton` | v17 "Krypton"

## Custom Startup Behavior

By default, the container will invoke `kodi-standalone` upon startup. This will boot Kodi and should work 
well for most installations. If you would like to customize this behavior, you can utilize the environment variable 
`KODI_COMMAND` to call additional scripts or processes before starting Kodi. For example, to reduce the priority of the 
Kodi process:

    $ x11docker ... -- '--cap-add SYS_NICE --env KODI_COMMAND="nice kodi-standalone"' erichough/kodi
    
## Command-Line Shutdown

There are two ways to stop the running Kodi container from the command line:

1. **(Preferred) Send `SIGHUP` or `SIGTERM` to the `x11docker` process.** 

       $ kill -SIGTERM <pid>

   **WARNING**: If you run `x11docker` from a terminal, **do not use `Ctrl-C`**  to end the process as this will cause 
   Kodi to crash spectacularly. Instead, open another shell and use `kill`.
   
1. **Use `docker stop`**
   
       $ docker stop <containerid>
       
When the container receives a signal to terminate, from either of the two means above, it will ask Kodi to shut down 
gracefully and wait for up to 10 seconds before timing out and allowing Docker to forcefully terminate the container. 
Usually Kodi only takes a few seconds to shut down, so 10 seconds should be plenty of time. However if you would like to
extend this timeout for any reason, you can utilize the environment variable `KODI_QUIT_TIMEOUT`. For example, to wait 
120 seconds before timing out:

    $ x11docker ... -- '--env KODI_QUIT_TIMEOUT=120' erichough/kodi
    
Note that if you increase this timeout, you should *only* stop Kodi with `docker stop` *and* use its `--time` option to 
match your desired timeout. e.g.

    $ docker stop --time=120 <containerid>
    
Unless you really need more than 10 seconds, and for simplicity's sake, it's better to signal `x11docker` instead of 
using `docker stop`.
