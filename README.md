#Chaos Mod for CS:GO [102 EFFECTS]

Inspired by [GTA V Chaos Mod](https://www.gta5-mods.com/scripts/chaos-mod-v-beta), CS:GO Chaos Mod brings over a 100+ unique effects into competitive or casual play such as Portal Guns, Fog, Explosive Bullets, Simon Says, Low Render Distance, and much, much more!


#INSTALLATION:
- Copy over `Chaos.smx` from the `plugins` folder into your csgo/addons/sourcemod/plugins/ folder.
- Copy over the `Chaos` folder from the `configs` folder into your csgo/addons/sourcemod/configs/ folder.
- Restart your server or load the plugin.

#Available Commands:
```
(todo; add other commands)
chaos_refreshconfig - Ban Flag Minimum - Updates and re parses configs.
```


#Known Issues
- When all the effects reset (1 second after the round ends), a potential game crash occurs what seems to be when its dealing with a ragdoll/dead player.
  Seems to be when the player dies at the SAME time as the reset.
  
- Soccerball effect only works on Dust 2 (need to test precaching the soccerball on other maps);


The list of effects can be found /configs/Chaos/Chaos_Effects.cfg. 