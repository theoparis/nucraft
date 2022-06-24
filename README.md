# nucraft

Nushell x Minecraft

## Introduction

This project is a collection of [nushell](https://nushell.sh/book) scripts.
In this project you can find a simple minecraft launcher, and a jar patcher.
The jar patching script allows one to patch the java class files within minecraft.
Then you can bundle everything together in a final jar file that can be ran using
the launcher script.
If you want to you can also specify extra libraries to include in the final jar
by entering them as maven dependencies in the `build.toml` file.

## Usage

### Fetching Minecraft

```nushell
./src/build.nu
```

### Bundling the Final Jar

```nushell
use src/patcher.nu [ bundle_jar ]
bundle_jar --output work/client-bundled.jar work/classes
```

## Launching Minecraft

First, you need to define the `MINECRAFT_USERNAME` and `MINECRAFT_PASSWORD` variables
inside your nushell env file. You can find this file in `~/.config/nushell/env.nu` on Linux.

```nushell
let-env MINECRAFT_USERNAME = "myaccount@gmail.com"
let-env MINECRAFT_PASSWORD = "12345678"
```

Now you can launch the game!

```nushell
./src/launcher.nu --mcjar work/client-bundled.jar --mainclass net.minecraft.client.main.Main
```
