# Contributing

Please make a pull request on a new branch. Branches should be named in the manner of `development/*`. Please adorn commit messages with [gitmoji](https://gitmoji.carloscuesta.me/).

`include`s must be in alphabetical order, unless they conflict. `AddCSLuaFile`s must be in alphabetical order.

## Localization

If you'd like to translate the gamemode, take a look at `gamemode/i18/en.lua` as a starting point. Subsystems, powerups, etc. are not translated by default.

## Non-NSS Maps

The map editor can be found ingame on non-`nss_*` maps by pressing Q. You need a Superadmin rank to do this.

# Mapping

Use the `nss.fgd` provided in this repository.

## nss_terminal

Place as many of these as you like whereever you like. The gamemode can function with as few as just one of these (though it wouldn't really be too fun).

## nss_explosion_fx

Place these where you want explosion sprites to be on loss. Sprites will be about 2048 units in radius.

## nss_workbench

Place a couple of these sporadically through the level. This lets players build powerups.

## nss_ass

Place atmospheric stabilization systems whereever you like. They shouldn't cover the whole gameplay area. They have an effective radius of 256 units.

## nss_func_space

This is a volume that kills any players on touch. It will move the player's camera to the map camera position. It's designed to be placed near the top of bottomless pits or holes. In addition, if the VAC subsystem is destroyed, players will be sucked towards it.