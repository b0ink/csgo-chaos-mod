# Chaos Mod for CS:GO [101 EFFECTS]

Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique effects into competitive and casual play such as **Portal Guns, Fog, Explosive Bullets, Simon Says, Low Render Distance**, and much, much more! Every 15 seconds a random effect is triggered, challenging your competitive play!


# REQUIREMENTS:
- Sourcemod 1.10+
- [Dynamic Channels](https://github.com/Vauff/DynamicChannels) (Optional, but recommended for HUD Text)
- [DHooks](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)

# INSTALLATION:
- Copy over `Chaos.smx` from the `/plugins/` folder into your `csgo/addons/sourcemod/plugins/` folder.
- Copy over the `Chaos` folder from the `/configs` folder into your `csgo/addons/sourcemod/configs/` folder.
- Restart your server/load the plugin.

If you encounter any errors please check your error files as well as the plugin's generated `chaos_logs.log` file found in `/csgo/addons/sourcemod/logs`, and double check that the config files are in the correct location.

## Available Commands:
```
sm_chaos <Effect Name>         - Runs a new random effect if no argument provided, otherwise finds the effect using the argument.
sm_startchaos                  - Spawns a new effect immediately and starts the effect timer.
sm_stopchaos                   - Pauses the Chaos Effect timer and resets all the effects.
chaos_refreshconfig            - Updates and re-parses configs.
```

## Available ConVars:
```
sm_chaos_enabled "1.0"				| Sets whether the Chaos plugin is enabled. | Min. 0.0 | Max. 1.0
sm_chaos_interval "15.0"			| Sets the interval for new Chaos effects to run at. | Min. 5.0 | Max. 60.0
sm_chaos_repeating "1.0"			| Sets whether effects will continue to spawn after the first one of the round. | Min. 0.0 | Max. 1.0
sm_chaos_overwrite_duration "-1.0"		| Sets the duration for ALL effects, use -1.0 to use Chaos_Effects.cfg durations, use 0.0 for no expiration. | Min. 0.0 | Max. 120.0
```

<!-- # Known Issues -->

The list of effects can be found `/configs/Chaos/Chaos_Effects.cfg`.

Project started around the 8th of Septermber, 2021.