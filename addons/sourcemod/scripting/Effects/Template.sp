/*
	Made by your_name_here

	Your config/function prefix should follow the convention of:
		Chaos_EffectName
	Replace 'EffectName' with a fitting name of your effect.


	Add the following to Chaos_Effects.cfg in Configs:
		"Chaos_EffectName"
		{
			"enabled"		"1"
			"duration"		"25" // change the duration to an appropriate 'default' time
		}

	Add the following to chaos.phrases.txt in Translations:
	    "Chaos_EffectName_Title"
		{
			"en"    "Name Of Effect"
		}
		"Chaos_EffectName_Description"
		{
			"en"    "Short description of the effect"
		}

	#include this file within Effects/$0.sp.
	
 */

public bool Chaos_$0(effect_data effect){
	effect.title = "Effect Name";
	effect.duration = 30;
	// Mark effects that cannot be run at the same time.
	effect.incompatibleWith("Chaos_BreakTime") ;
	effect.incompatibleWith("Chaos_Funky");

	// Alternative keywords to target this effect (Chaos_EffectName and the title is used by default)
	effect.AddAlias("Keyword");
	effect.AddAlias("Keyword2");

 	// Remove this line if it is a timed effect
	// effect.HasNoDuration();

	// The title of the effect will automatically be announced/added to the hud when it's run. Use this to prevent it.
	// Use AnnounceChaos("Chaos_$0") //TODO
	effect.HasCustomAnnouncement = false;

}



/*
	Runs on the OnMapStart function. Use this to precache any models or textures.
*/
public void Chaos_$0_OnMapStart(){
	
}

/*
	Runs OnPluginStart.
	Use this to hook events
*/
public void Chaos_$0_INIT(){
	
}

/* This is used when the effect is fired */
public void Chaos_$0_START(){

}

/* The reset function will fire once the timer has finished, where HasTimerEnded will be true. */
/* It will also fire on round end, where HasTimerEnded will be false. */
public Action Chaos_$0_RESET(bool HasTimerEnded){

}

/* Remove or comment out if not used */
public Action Chaos_$0_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}

/* Remove or comment out if not used */
public Action Chaos_$0_OnEntityCreated(int ent, const char[] classname){

}

/* Remove or comment out if not used */
public Action Chaos_$0_OnGameFrame(){

}

/*
	A final check before running the effect.
	Returning false will force the plugin to pick another effect.

	eg. If your effect requires map points to teleport to or spawn props at, you can use:
		if(!ValidMapPoints()) return false;
*/
public bool Chaos_EffectName_Conditions(){
	return true;
}



// isHostageMap();
// g_iFog
// g_iChaos_Round_Count
// mapName
// ValidMapPoints
// ValidBombSpawns
// g_bCanSpawnChickens
// g_bC4Chicken
// GetSlowScriptTimeout