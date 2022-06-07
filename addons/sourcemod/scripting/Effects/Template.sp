/*

	Made by your_name_here


	Your config/function prefix should follow the convention of:
		Chaos_EffectName
	Replace 'EffectName' with a fitting name.


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

	Add this file as include to Effects/Effectlist.sp.
	
 */


/*
	Runs on the OnMapStart function. Use this to precache any models or textures.
*/
public void Chaos_EffectName_OnMapStart(){
	
}

/*
	INIT function is run on MapStart and after the configs have been executed
	This may run twice on occasion. // todo

	Use this for precaching model or materials, or hooking events.
	Your callback functions should begin with Chaos_EffectName
*/
public void Chaos_EffectName_INIT(){
	
}

/* This is used when the effect is fired */
public void Chaos_EffectName_START(){

}

/* The reset function will fire once the timer has finished, where EndChaos will be true. */
/* It will also fire on round end, where EndChaos will be false. */
public Action Chaos_EffectName_RESET(bool EndChaos){

}

/* Remove or comment out if not used */
public Action Chaos_EffectName_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}

/* Remove or comment out if not used */
public Action Chaos_EffectName_OnEntityCreated(int ent, const char[] classname){

}

/* Remove or comment out if not used */
public Action Chaos_EffectName_OnGameFrame(){

}


/*
	If you want to prevent the plugin from automatically announcing the effect, keep this
	Otherwise, remove it or return false

	If removed, assume it returns false.

	
	Use AnnounceChaos("Chaos_FakeTeleport"); when needed.
*/
public bool Chaos_EffectName_CustomAnnouncement(){
	return false;
}


/* Used to indicate that the effect should not have a duration, even if one is set in the config. */
public bool Chaos_EffectName_HasNoDuration(){
	return false;
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
