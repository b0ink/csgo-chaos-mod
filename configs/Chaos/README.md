# CS:GO Chaos Mod Config

`Chaos_Effects.cfg` can be used to Enable/Disable any effect, as well as editing its `"name"` and `"duration"`.

Effects are indexed by their function name used within the plugin, for example:

```
"Chaos_PortalGuns"
{
	"name"			"Portal Guns"
	"description"	"Teleport where you shoot"
	"enabled"		"1"
	"duration"		"20"
}
```
`"Chaos_PortalGuns"` references the function name within `scripting/Effects.sp`. **Do not edit this line or it will no longer run.**

`"name"` can be edited to change the title that appears in-game for that effect. Colors from `Multicolors.inc` are supported (Colors appear in game chat).

`"enabled" [1 (Enabled) | 0 (Disabled)]` will determine whether the effect has a chance to run or not. Disabling it will also prevent you from running it manually.

`"duration" [Min. 5 Seconds] [Max. 120 Seconds]` will determine how long the effect will run. Setting it to 0 will make the effect last until the end of the round.

**Effects that currently have the duration set to `-1` implies that the effect does not have any duration, and is a one off effect. Changing its duration will not alter the effect.**

`"description"` is only used for reference.

# In-Game Config Editor (Recommended)

The command `!chaos` can be used in-game to edit the config.

`!chaos ->  Settings -> Edit Effects`

**ANY changes you make in-game will create a `Chaos_Override.cfg` file in `addons/configs/Chaos/`, and automatically add/update your changes within the file. The effects found in `Chaos_Override.cfg` will have a higher priority over those same effects in `Chaos_Effects.cfg`. This method is encouraged to ensure you keep your changes when updating `Chaos_Effects.cfg` to the latest version.**