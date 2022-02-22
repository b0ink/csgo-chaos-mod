# Chaos Mod for CS:GO [101 EFFECTS]

Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique effects into your competitive games such as **Portal Guns, Fog, Explosive Bullets, Simon Says, Low Render Distance**, and much, much more! Every 15 seconds a random effect is triggered, causing chaos to your match.


# REQUIREMENTS:
- Sourcemod 1.10
- [Dynamic Channels](https://github.com/Vauff/DynamicChannels) (Optional, but recommended for HUD Text)
- [DHooks](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)

# INSTALLATION:
- Copy over `Chaos.smx` from the `/plugins/` folder into your `csgo/addons/sourcemod/plugins/` folder.
- Copy over the `Chaos` folder from the `/configs` folder into your `csgo/addons/sourcemod/configs/` folder.
- Copy over `DynamicChannels.smx` from [Dynamic Channels/plugins](https://github.com/Vauff/DynamicChannels/tree/master/plugins) into your `csgo/addons/sourcemod/plugins/` folder.
- Restart your server/load the plugin.

If you encounter any errors please check your error files as well as the plugin's generated `chaos_logs.log` file found in `/csgo/addons/sourcemod/logs`, and double check that the config files are in the correct location.

## Available Commands:
```
sm_chaos         				- Shows a Menu to control Chaos options.
sm_effect <Effect Name>			- Runs the effect if it matches with the argument.
sm_startchaos                  	- Spawns a new effect immediately and starts the effect timer.
sm_stopchaos                   	- Pauses the Chaos Effect timer and resets all the effects.

chaos_refreshconfig            	- Updates and re-parses configs.
```

## Available ConVars:
```
sm_chaos_enabled
sm_chaos_interval
sm_chaos_repeating
sm_chaos_override_duration
```

`sm_chaos_enabled` | `Default. 1.0` | `Min. 0.0` | `Max. 1.0`
- Sets whether the Chaos plugin is enabled.\
Setting it to `1.0` will activate the interval timer and run an effect

`sm_chaos_interval` | `Default. 15.0` | `Min. 5.0` | `Max. 60.0`
- Sets how often (in seconds) a new effect will spawn

`sm_chaos_repeating` | `Default. 1.0` | `Min. 0.0` | `Max. 1.0`
- If set to `1.0`, random effects will continue to spawn at the rate of `sm_chaos_interval`.\
If set to `0.0`, only one effect will run at the start of the round.

`sm_chaos_override_duration` | `Default. -1.0` | `Min. -1.0` | `Max. 120.0`
- Override the duration (in seconds) of ALL effects.\
If set to `-1.0`, `Chaos_Effects.cfg` durations will be used.\
Set to `0.0` for infinite duration.

---

<!-- # Known Issues -->

The list of effects can be found in [/configs/Chaos/Chaos_Effects.cfg](configs/Chaos/Chaos_Effects.cfg).\
Each effect can individually be enabled/disabled, as well as editing their duration.\
More information about the Chaos config can be found [here](configs/Chaos).

Project started around the 8th of Septermber, 2021.