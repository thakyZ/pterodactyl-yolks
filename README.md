# Yolks

A curated collection of core images that can be used with Pterodactyl's Egg system. Each image is rebuilt
periodically to ensure dependencies are always up-to-date.

Images are hosted on `ghcr.io` and exist under the `games`, `installers`, and `yolks` spaces. The following logic
is used when determining which space an image will live under:

* `oses` — base images containing core packages to get you started.
* `games` — anything within the `games` folder in the repository. These are images built for running a specific game
or type of game.
* `installers` — anything living within the `installers` directory. These images are used by install scripts for different
Eggs within Pterodactyl, not for actually running a game server. These images are only designed to reduce installation time
and network usage by pre-installing common installation dependencies such as `curl` and `wget`.
* `yolks` — these are more generic images that allow different types of games or scripts to run. They're generally just
a specific version of software and allow different Eggs within Pterodactyl to switch out the underlying implementation. An
example of this would be something like Java or Python which are used for running bots, Minecraft servers, etc.

All of these images are available for `linux/amd64` and `linux/arm64` versions, unless otherwise specified, to use
these images on an arm64 system, no modification to them or the tag is needed, they should just work.

## Contributing

When adding a new version to an existing image, such as `java v42`, you'd add it within a child folder of `java`, so
`java/42/Dockerfile` for example. Please also update the correct `.github/workflows` file to ensure that this new version
is tagged correctly.

## Available Images

* [`base oses`](https://github.com/thakyz/pterodactyl_yolks/tree/main/oses)
  * [`alpine`](https://github.com/thakyz/pterodactyl_yolks/tree/main/oses/alpine)
    * `ghcr.io/thakyz/yolks:alpine`
  * [`debian`](https://github.com/thakyz/pterodactyl_yolks/tree/main/oses/debian)
    * [`debian`](https://github.com/thakyz/pterodactyl_yolks/tree/main/oses/debian/bookworm-slim)
      * `ghcr.io/thakyz/yolks:debian_bookworm-slim`
    * [`debian`](https://github.com/thakyz/pterodactyl_yolks/tree/main/oses/debian/buster-slim)
      * `ghcr.io/thakyz/yolks:debian_buster-slim`
* [`java`](https://github.com/thakyz/pterodactyl_yolks/tree/main/java)
  * [`java8`](https://github.com/thakyz/pterodactyl_yolks/tree/main/java/8)
    * `ghcr.io/thakyz/yolks:java_8`
  * [`java11`](https://github.com/thakyz/pterodactyl_yolks/tree/main/java/11)
    * `ghcr.io/thakyz/yolks:java_11`
  * [`java16`](https://github.com/thakyz/pterodactyl_yolks/tree/main/java/16)
    * `ghcr.io/thakyz/yolks:java_16`
  * [`java17`](https://github.com/thakyz/pterodactyl_yolks/tree/main/java/17)
    * `ghcr.io/thakyz/yolks:java_17`
* [`nodejs`](https://github.com/thakyz/pterodactyl_yolks/tree/main/nodejs)
  * [`node16`](https://github.com/thakyz/pterodactyl_yolks/tree/main/nodejs/16)
    * `ghcr.io/thakyz/yolks:nodejs_16`
* [`python`](https://github.com/thakyz/pterodactyl_yolks/tree/main/python)
  * [`python3.7`](https://github.com/thakyz/pterodactyl_yolks/tree/main/python/3.6)
    * `ghcr.io/thakyz/yolks:python_3.6`
* [`steamcmd`](https://github.com/thakyz/pterodactyl_yolks/tree/main/steamcmd)
  * [`proton`](https://github.com/thakyz/pterodactyl_yolks/tree/main/steamcmd/proton)
    * `ghcr.io/thakyz/yolks:steamcmd_proton`

### Installation Images

* [`alpine-install`](https://github.com/thakyz/pterodactyl_yolks/tree/master/installers/alpine)
  * `ghcr.io/thakyz/installers:alpine`

* [`debian-install`](https://github.com/thakyz/pterodactyl_yolks/tree/master/installers/debian)
  * `ghcr.io/thakyz/installers:debian`

## Other Links

[Pterodactyl Eggs](https://github.com/thakyZ/pterodactyl_eggs)
