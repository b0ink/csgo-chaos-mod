# Chaos Mod for CS:GO [101 EFFECTS]
Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique effects into your competitive games such as **Portal Guns, Fog, Explosive Bullets, Simon Says, Low Render Distance**, and much, much more! The effects are randomised and every 15 seconds a new one will spawn, keeping you and your enemies on your toes.

The list of effects can be found in [/configs/Chaos/Chaos_Effects.cfg](configs/Chaos/Chaos_Effects.cfg).

# REQUIREMENTS:
- Sourcemod 1.10
- [Dynamic Channels](https://github.com/Vauff/DynamicChannels) (Optional, but recommended for HUD Overlay)
- [DHooks](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)

# INSTALLATION:
- Copy over `Chaos.smx` from the `/plugins/` folder into your `/addons/sourcemod/plugins/` folder.
- Copy over the `Chaos` folder from the `/configs` folder into your `/addons/sourcemod/configs/` folder.
- Copy over `DynamicChannels.smx` from [Dynamic Channels/plugins](https://github.com/Vauff/DynamicChannels/tree/master/plugins) into your `/addons/sourcemod/plugins/` folder.
- Restart your server/load the plugin.

If you encounter any errors please check your error files as well as the plugin's generated `chaos_logs.log` file found in `/addons/sourcemod/logs`, and double check that the config files are in the correct location.

## Available Commands:
`sm_chaos`
- Displays a menu of Chaos options:
	- Enable/Disable Chaos
	- Spawn new effect from list
	- Settings
    	- Effects
    	- ConVars
  
`sm_effect <Effect Name>`
- Runs the effect if it matches the argument, if multiple are found a menu of options will show.

`sm_startchaos`
- Spawns a new effect immediately and starts the effect timer.

`sm_stopchaos`
- Pauses the Chaos Effect timer and resets all the effects.

`chaos_refreshconfig`
- Updates and re-parses configs.

## Config
Each effect can individually be enabled/disabled and have their duration adjusted within `configs/Chaos/Chaos_Effects.cfg`.\
More information about the Chaos config can be found [here](configs/Chaos).

### In-Game Config Editor
Instead of manually editing the `Chaos_Effects.cfg` file, it is recommended to adjust the effects by using the `!chaos` command, and selecting `Settings->Effects`.

ANY changes you make in-game will create a `Chaos_Override.cfg` file in `addons/sourcemod/configs/Chaos/`, and automatically add/update your changes within the file. The effects found in `Chaos_Override.cfg` will have a higher priority over those same effects in `Chaos_Effects.cfg`. To revert to defaults, simply delete `Chaos_Override.cfg`.\
**Using this method means you can update Chaos to its latest version and corresponding config files without overwriting your changes.**

## Available ConVars:
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

Project started around the 8th of Septermber, 2021.