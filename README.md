# Chaos Mod for CS:GO [122 EFFECTS] + Twitch Voting
Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique effects into your competitive games such as **Portal Guns, Snow, Saturation, Auto bunnyhopping, Fog, Explosive Bullets, Simon Says, Low Render Distance**, and much, much more! The effects are randomised and every 15 seconds a new one will spawn, keeping you and your enemies on your toes.

The list of effects can be found in [/configs/Chaos/Chaos_Effects.cfg](addons/sourcemod/configs/Chaos/Chaos_Effects.cfg).

# Twitch Voting
An [Electron](https://www.electronjs.org/) based app is currently being worked on to connect your Twitch account and your CS:GO server via RCON to pull effects from the server and allow users to vote for effects in your Twitch chat. A pop-up overlay can be used in [OBS](https://obsproject.com/) and a green-screen filter can be applied to overlay the effects and votes on stream.\
<br>
Release TBA.

# REQUIREMENTS:
- [Sourcemod 1.10+](https://sourcemod.net/)
- [Dynamic Channels](https://github.com/Vauff/DynamicChannels) (Included in this repo)
- [DHooks](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)

# INSTALLATION:
- Copy the contents in `addons/sourcemod/` into your server's `addons/sourcemod/` folder, including `configs`, `plugins`, and `translations`. The plugin will not work without these folders.
- Copy the contents in `materials/` into your server's `csgo/materials/` folder. You may also need a [Fast DL](https://steamcommunity.com/sharedfiles/filedetails/?id=486331092) setup for other players to download the assets off your server.
- Restart your server/load the plugin.

If you encounter any errors please check your error files as well as the plugin's generated `chaos_logs.log` file found in `/addons/sourcemod/logs`, and double check that the config files are in the correct location.

## Available Commands:
`sm_chaos`
- Displays a menu of Chaos options:
	- Enable/Disable Chaos | Start Timer
	- Spawn new effect from list
	- Settings
    	- Effects
    	- ConVars
  
`sm_effect <Effect Name | Search Term>`
- Brings up a menu of any effects containing the search term.

`sm_startchaos`
- Spawns a new effect immediately and starts the effect timer.

`sm_stopchaos`
- Pauses the Chaos Effect timer and resets all the effects.

`chaos_refreshconfig`
- Updates and re-parses configs.

## Config
Each effect can individually be enabled/disabled and have their duration adjusted within `configs/Chaos/Chaos_Effects.cfg`.\
More information about the Chaos config can be found [here](addons/sourcemod/configs/Chaos).

You can adjust the effect titles in [the translation files](https://github.com/b0ink/csgo-chaos-mod/tree/main/addons/sourcemod/translations) to appear differently in-game.

### In-Game Config Editor
Instead of manually editing the `Chaos_Effects.cfg` file, it is recommended to adjust the effects by using the `!chaos` command, and selecting `Settings->Effects`.

ANY changes you make in-game will create a `Chaos_Override.cfg` file in `addons/sourcemod/configs/Chaos/`, and automatically add/update your changes within the file. The effects found in `Chaos_Override.cfg` will have a higher priority over those same effects in `Chaos_Effects.cfg`. To revert to defaults, simply delete `Chaos_Override.cfg`.\
**Using this method means you can update Chaos to its latest version and corresponding config files without overwriting your changes.**

## Available ConVars:
`sm_chaos_enabled` | `Default. 1` | `Min. 0` | `Max. 1`
- Sets whether the Chaos plugin is enabled.\
Setting it to `1.0` will activate the interval timer and run an effect

`sm_chaos_interval` | `Default. 30` | `Min. 5` | `Max. 60`
- Sets how often (in seconds) a new effect will spawn

`sm_chaos_repeating` | `Default. 1` | `Min. 0` | `Max. 1`
- If set to `1.0`, random effects will continue to spawn at the rate of `sm_chaos_interval`.\
If set to `0.0`, only one effect will run at the start of the round.

`sm_chaos_override_duration` | `Default. -1` | `Min. -1` | `Max. 120`
- Override the duration (in seconds) of ALL effects.\
If set to `-1.0`, `Chaos_Effects.cfg` durations will be used.\
Set to `0.0` for infinite duration (Effect lasts the entire round).

`sm_chaos_twitch_enabled` | `Default. 0` | `Min. 0` | `Max. 1`
- Sets whether the chaos plugin can communicate with the Twitch Overlay app to allow voting for effects.\
If set to `0`, effects will be spawned at random.\
If set to `1`, 3 random effects will be displayed in the Twitch Overlay app and will spawn the most voted effect. (1 of the 3 effects will be spawned if there are no votes). 

Chaos ConVars are controlled through `sourcemod/configs/Chaos/Chaos_Convars.cfg`, or alternatively through the `!chaos->Settings` menu, which will automatically updating the ConVar config.


## Currently supported maps with working spawns
<sub>Spawns defined in [Chaos_Locations.cfg](addons/sourcemod/configs/Chaos_Locations.cfg) are used for teleporting players and spawning props. Running Chaos on an unsupported map will mean various effects will not run.</sub>
- Dust 2
- Mirage
- Inferno
- Nuke
- Vertigo
- Ancient
- Overpass
- Train
- Cache
- Cobblestone
- Office
- Agency
- Italy
- Assault
- Iris\
<sub>If you are running Chaos Mod on an 'unsupported' map, temporary spawn points will be generated based off players' location throughout the game</sub>

### Known issues:
- Certain resolutions (mostly widescreens, and in my case 2560x1080) cut off the HUD overlay on the right side of the screen, this means the announcement texts and bar timer might not look correct, lowering your resolution should fix this.
	- It is also recommended to **restart** CS:GO after adjusting your resolution, otherwise the HUD may appear much larger than it should be.
<p></p>

---

<p align="center">
<sub>Project started around the 8th of Septermber, 2021.</sub>
	<br>
	<br>
	<a href="https://www.paypal.com/donate/?hosted_button_id=D2RUGH8KTRXTJ" 
	target="_blank">
	<img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" alt="PayPal this" 
	title="PayPal – The safer, easier way to pay online!" border="0" />
	</a>
</p>