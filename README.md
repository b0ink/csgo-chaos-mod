# Chaos Mod for CS:GO [101 EFFECTS]

Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique effects into competitive or casual play such as **Portal Guns, Fog, Explosive Bullets, Simon Says, Low Render Distance**, and much, much more!


# INSTALLATION:
- Copy over `Chaos.smx` from the `/plugins/` folder into your csgo/addons/sourcemod/plugins/ folder.
- Copy over the `Chaos` folder from the `/configs` folder into your csgo/addons/sourcemod/configs/ folder.
- Restart your server/load the plugin.

If you encounter any errors please check your error files as well as the plugin's generated `chaos_logs.log` file found in `/csgo/addons/sourcemod/logs`, and double check that the config files are in the correct location.

# Available Commands:
```
sm_chaos <Effect Name>         - Runs a new random effect if no argument provided, otherwise finds the effect using the argument.
sm_startchaos                  - Spawns a new effect immediately and starts the effect timer.
sm_stopchaos                   - Pauses the Chaos Effect timer and resets all the effects.
chaos_refreshconfig            - Updates and re-parses configs.
```

<!-- # Known Issues -->

The list of effects can be found /configs/Chaos/Chaos_Effects.cfg.

Project started around the 8th of Septermber, 2021.