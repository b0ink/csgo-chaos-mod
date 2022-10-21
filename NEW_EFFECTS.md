# Making your own effects

## Starter Template:
Name your file following the convention of `EffectName.sp` and place it in the respective category of `Meta`, `Player`, or `Game`.\
`Meta` is only for meta effects.\
`Player` is for effects that directly affect the player.\
`Game` is for effects that manipulates the environment, such as weather, image overlays, color corrections, etc.\
These are only used for organisation purposes.
```c++

/*
	Any instances of 'EffectName' should be replaced with an appropriate name for you effect.
	
	As long as all the naming conventions are strictly followed below, they will all be run automatically, without the need to be called elsewhere in the plugin.
*/

g_EffectName = false;

public void Chaos_EffectName(effect_data effect){
	effect.Title = "Effect Name";
	effect.Duration = 30;
	
	/*
	
	Optional configs: 

	effect.HasNoDuration = troe; // Use this if your effect isn't timed, eg. spawning models

	effect.AddAlias("SearchTerm"); // Allow the effect to show up when using "!effect searchterm"
	effect.IncompatibleWith("Chaos_DifferentEffectName"); // Prevents the effect running the same time with other effects

	// Prevents the plugin from announcing the effect name, and does not get added to the effect list (HUD).
	// Useful if you want to delay the Announcement -> use AnnounceChaos() manually
	effect.HasCustomAnnouncement = true; 

	effect.IsMetaEffect = true; // Marks the effect as a meta effect (rarely run)
	
	*/
}

public void Chaos_EffectName_INIT(){
	/*
	
	Runs on plugin start. Use this to Hook Events. This will only run ONCE.
	eg. 
		HookEvent("bullet_impact", Chaos_EffectName_Event_BulletImpact);
	*/
}

public void Chaos_EffectName_OnMapStart(){
	/*
	
	Runs on every map start, use this to precache textures, etc.
	eg. 
		PrecacheDecal("path/to/texture.vmt", true);
		AddFileToDownloadsTable("materials/path/to/texture.vmt");
		
	*/
}

public void Chaos_EffectName_START(){
	g_EffectName = true;
	// Runs when the effect is selected and
}

public void Chaos_EffectName_RESET(bool HasTimerEnded){
	// Runs when the effect is reset, also runs when the round ends/map changes/plugin reloaded
	// Use HasTimerEnded to strictly check if the effect has expired/used up its duration.
	/*
	eg.
		Reset any bools here..
		
		g_EffectName = false;
		if(HasTimerEnded){
			// Teleport players, set their movement speed, switch to a different weapon, etc.
			// Avoid resetting things outside of this function that would be reset by default on round change.
		}
		
	*/
}

public bool Chaos_EffectName_Conditions(){
	/*
		Check conditions to deterimne whether the effect can be run or not. This is the last final check before the effect is about to run. If returned false, 			another effect will be selected.
		
		If you're using map spawns to teleport to, you may want to use the following:
		if(!ValidMapPoints()) return false;
		
		Available checks:
		ValidMapPoints();
		isHostageMap();
		ValidBombSpawns();
		
		You can run custom checks such as:
		if(StrEqual(mapName, "de_dust2")){
			return false;
		}
		
	*/
	
	return true;
}

// Additional functions: (Run automatically if the correct naming convention is used)

public void 	Chaos_EffectName_OnEntityCreated(int ent, const char[] classname);

public Action 	Chaos_EffectName_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed);

public void 	Chaos_EffectName_OnGameFrame();

// + more to be configured if required, in order to avoid editing other files for your effect.

```

## Translations
Add the following to `addons/sourcemod/translations/chaos.phrases.txt`.
```
"Chaos_EffectName"
{
	"en"    "Effect Name"
}
```
If translations are missing on the server, the `effect.Title` will be used by the plugin

## Including your effect
Include your `EffectName.sp` inside of `addons/sourcemod/scripting/Effects/EffectsList.sp`
```c++
#include "Effects/Player/EffectName.sp"
```
Ensure that the contents of `EffectsList.sp` is sorted alphabetically in descending order.\
Add the name of your function to `addons/sourcemod/scripting/Effects/EffectNames.sp`. This is used to call your function and add your effect.
```c++
"Chaos_EffectName",
```
This should match the name of your function that sets up your effect:
```c++
public void Chaos_EffectName(effect_data effect)
```
