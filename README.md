# Chaos Mod for CS:GO [150 EFFECTS] <sub> + YouTube & Twitch Voting</sub>
Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique game-changing effects into your rounds such as **Portal Guns, Snow, Saturation, Auto bunnyhopping, Fog, Explosive Bullets, Simon Says, Low Render Distance**, and much, much more! The effects are randomised and every 15 seconds a new one will spawn, keeping you and your enemies on your toes.

### The list of effects can be found [here](https://csgochaosmod.com/effects/).

##### Plugin is supported for both Competitive and Deathmatch configs.

# Screenshots
<p align="center">
	<img src="https://csgochaosmod.com/gallery/chaos_1.jpg" 	width="375" title="LSD">
	<img src="https://csgochaosmod.com/gallery/chaos_2.jpg" 	width="375" title="Extreme Fog">
	<img src="https://csgochaosmod.com/gallery/chaos_5.jpg" 	width="375" title="Alien Knife Fight">
	<img src="https://csgochaosmod.com/gallery/chaos_7.jpg" 	width="375" title="Thunderstorm">
	<img src="https://csgochaosmod.com/gallery/chaos_9.jpg" 	width="375" title="Binoculars">
	<img src="https://csgochaosmod.com/gallery/chaos_10.jpg" 	width="375" title="Deep Fried">
</p>


# Twitch & YouTube Chat Voting
Open source & Download to the [CS:GO Chaos Mod Voting Overlay](https://github.com/b0ink/csgo-chaos-mod-voting-overlay).
Basic instructions are available in the [README.md](https://github.com/b0ink/csgo-chaos-mod-voting-overlay#readme)

The app generates 4 random effects for your Twitch chat to choose from, the highest voted effect gets picked, or if proportional voting is enabled (currently by default), each effect has a certain chance of being picked at random.
A voting panel will pop up that can be keyed out with a green screen using OBS. Users can type a number in chat that will add to the count in the effect list.

<p align="center">
	<img src="https://csgochaosmod.com/gallery/twitch-overlay/App_1.PNG" 	width="250" title="Twitch Setup">
	<img src="https://csgochaosmod.com/gallery/twitch-overlay/App_2.PNG" 	width="250" title="YouTube Setup">
	<img src="https://csgochaosmod.com/gallery/twitch-overlay/Voting_3.PNG" width="250" title="Voting Panel">
</p>
<br>

# REQUIREMENTS:
- [Sourcemod 1.11+](https://sourcemod.net/)
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

## Config
You can adjust the effect's duration and enable/disable it by using the "!chaos" command, and selecting `Settings -> Effects`.

ANY changes you make in-game will create a "Chaos_Override.cfg" file in "addons/sourcemod/configs/Chaos/", and automatically add/update your changes within the file. Anything in this file with be used instead of the plugin defaults (which in most cases is Enabled and 30 seconds duration).

Using this method means you can update Chaos to its latest version and corresponding config files without overwriting your changes.
More information about the Chaos config can be found here.


## Available ConVars:
`sm_chaos_enabled` | `Default. 1` | `Min. 0` | `Max. 1`
- Sets whether the Chaos plugin is enabled.\
Setting it to `1.0` will activate the interval timer and run an effect

`sm_chaos_prefix` | `Default. "[{lime}CHAOS{default}]"`
- Sets the Prefix of Chaos chat messages such as effect spawns (Multicolors supported).

`sm_chaos_interval` | `Default. 30` | `Min. 5` | `Max. 60`
- Sets how often (in seconds) a new effect will spawn

`sm_chaos_repeating` | `Default. 1` | `Min. 0` | `Max. 1`
- If set to `1.0`, random effects will continue to spawn at the rate of `sm_chaos_interval`.\
If set to `0.0`, only one effect will run at the start of the round.

`sm_chaos_override_duration` | `Default. -1` | `Min. -1` | `Max. 120`
- Override the duration (in seconds) of ALL effects.\
If set to `-1.0`, the plugin's default durations will be used.\
Set to `0.0` for infinite duration (Effect lasts the entire round).

`sm_chaos_twitch_enabled` | `Default. 0` | `Min. 0` | `Max. 1`
- Sets whether the chaos plugin can communicate with the Twitch Overlay app to allow voting for effects.\
If set to `0`, effects will be spawned at random.\
If set to `1`, 3 random effects will be displayed in the Twitch Overlay app and will spawn the most voted effect. (1 of the 3 effects will be spawned if there are no votes). 

`sm_chaos_effect_timer_color` | `Default. "220 0 220 0"`
- Set the RGBA values of the Effect Timer countdown. (Default is purple)

`sm_chaos_effect_list_color` | `Default. "37 186 255 0"`
- Set the RGBA values of the Effect List on the side. (Default is blue)

`sm_chaos_effect_timer_position` | `Default. "-1 0.06"`
- Sets the xy position of the effect timer. Ranges from 0 and 1. -1 is center.

`sm_chaos_effect_list_position` | `Default. "0.01 0.42"`
- Sets the xy position of the effect list. Ranges from 0 and 1. -1 is center.

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
- Lake
- Iris\
<sub>If you are running Chaos Mod on an 'unsupported' map, temporary spawn points will be generated based off players' location throughout the game</sub>

### Known issues:
- Certain resolutions (mostly widescreens, and in my case 2560x1080) cut off the HUD overlay on the right side of the screen, this means the announcement texts and bar timer might not look correct, lowering your resolution should fix this.
	- It is also recommended to **restart** CS:GO after adjusting your resolution, otherwise the HUD may appear much larger than it should be.
	- 4k resolutions by default have an extremely enlarged HUD that makes the game unplayable, setting it to 1080p and restarting your game should fix this.
	- An alternative method is to set `-w 1920 -h 1080` in your CS:GO's launch options.
- Experienced some issues with models showing up as error boxes, or overlays not being displayed correctly, restarting your game fixes this issue after downloading the materials.
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