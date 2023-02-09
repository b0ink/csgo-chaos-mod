#pragma semicolon 1


ArrayList 	ChaosEffects;
ArrayList 	PossibleChaosEffects;

Handle 		EffectsHistory = INVALID_HANDLE;

ArrayList 	PossibleMetaEffects;
ArrayList	MetaEffectsHistory;

/*
	Reset flags that are passed through to _RESET() functions
	Here are the 5 events can trigger the _RESET() function of an effect.
*/
#define RESET_COMMAND    		(1 << 0) /** Chaos was disabled via command or menu - resetting effects */
#define RESET_EXPIRED    		(1 << 0) /** Effect timer has expired */
#define RESET_ROUNDSTART        (1 << 1) /** Round start */
#define RESET_ROUNDEND          (1 << 2) /** Round End */
#define RESET_PLUGINEND         (1 << 3) /** Plugin was unloaded */

enum struct EffectData{
	char 		Title[64]; // 0th index for ease of sorting in configs.sp
	int 		ID;
	char 		FunctionName[64];
	
	int 		Duration;
	bool 		HasNoDuration;
	bool		OverrideDuration;
	bool		HasCustomAnnouncement;
	bool		Enabled;
	bool		IsMetaEffect;

	Handle		IncompatibleEffects;
	Handle		IncompatibleFlags;

	Handle		Aliases;
	Handle 		Timer;


	/* Forwards */
	Function START;
	Function RESET;

	Function Conditions;
	Function OnGameFrame;
	Function OnPlayerRunCmd;
	Function OnEntityCreated;
	Function OnEntityDestroyed;

	Function OnPlayerSpawn;

	void Run(){
		if(this.START != INVALID_FUNCTION){
			Log("Playing effect: %s", this.FunctionName);

			Call_StartFunction(GetMyHandle(), this.START);
			Call_Finish();

			float duration = this.GetDuration(); 
			if(duration > 0) this.Timer = CreateTimer(duration, Effect_Reset, this.ID);
			
			if(!this.HasCustomAnnouncement){
				AnnounceChaos(this.Title, this.GetDuration(), _, this.IsMetaEffect);
			}
			g_sLastPlayedEffect = this.FunctionName;
			g_iTotalEffectsRunThisMap++;
			ChaosEffects.SetArray(this.ID, this); // save timer
		}
	}

	void Reset(int ResetFlags){
		if(this.RESET != INVALID_FUNCTION){
			StopTimer(this.Timer);
			this.Timer = INVALID_HANDLE;
			ChaosEffects.SetArray(this.ID, this);
			
			Call_StartFunction(GetMyHandle(), this.RESET);
			Call_PushCell(ResetFlags);
			Call_Finish();
		
		}
	}


	bool CanRunEffect(bool EffectRunRandomly){
		//TODO: slowly remove conditions and check .IsCompatible
		bool response = true;
		if(this.Conditions != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), this.Conditions);
			Call_PushCell(EffectRunRandomly);
			Call_Finish(response);
		}
		return response;
	}


	float GetDuration(bool raw = false){
		if(this.HasNoDuration){
			return -1.0;
		}
		float OverwriteDuration = g_cvChaosOverrideDuration.FloatValue;
		float duration = float(this.Duration);
		if(raw){
			return duration;
		}
		//TODO: change announcechaos to only take the config name, automatically get the duration
		// no need for defaults anymore as config is the only default

		if(OverwriteDuration < -1.0){
			Log("Cvar 'OverwriteEffectDuration' set Out Of Bounds in Chaos_Settings.cfg, effects will use their durations in Chaos_Effects.cfg");
			OverwriteDuration = -1.0;
		}
		if(OverwriteDuration != -1.0 && !this.OverrideDuration){
			duration = OverwriteDuration;
		}else{
			if(duration == -1.0){
				return -1.0;
			}
			if(duration < 0 ){
				duration = SanitizeTime(duration);
			}else{
				if(duration != SanitizeTime(duration)){
					Log("Incorrect duration set for %s. You set: %f, defaulting to: %f", this.FunctionName, duration, SanitizeTime(duration));
					duration = SanitizeTime(duration);
				}
			}
		}


		return duration;
	}

	
	//TODO: flag cache - when effect is run add all flags to a cache, ensure the next x effects dont have those flags, eventually clear after one or something
	void AddFlag(char[] flagName){
		if(this.IncompatibleFlags == INVALID_HANDLE){
			this.IncompatibleFlags = CreateArray(128);
		}
		PushArrayString(this.IncompatibleFlags, flagName);
	}
	

	void IncompatibleWith(char[] effectName){
		if(this.IncompatibleEffects == INVALID_HANDLE){
			this.IncompatibleEffects = CreateArray(128);
		}
		PushArrayString(this.IncompatibleEffects, effectName);
	}


	bool IsCompatible(){
		if(this.IncompatibleEffects != INVALID_HANDLE){
			char effectName[128];
			for(int i = 0; i < GetArraySize(this.IncompatibleEffects); i++){
				GetArrayString(this.IncompatibleEffects, i, effectName, sizeof(effectName));
				if(IsChaosEffectRunning(effectName)){
					return false;
				}
			}
		}
		
		if(AreIncompatibleEffectsRunning(this.FunctionName)) return false; // check if this effect is incompatible in a currently running effect

		if(this.IncompatibleFlags == INVALID_HANDLE) return true; // no flags to check
		char flagName[128];
		for(int i = 0; i < GetArraySize(this.IncompatibleFlags); i++){
			GetArrayString(this.IncompatibleFlags, i, flagName, sizeof(flagName));
			if(AreEffectsWithFlagRunning(flagName)){
				return false;
			}
		}

		return true;	
	}


	void AddAlias(char[] effectName){
		if(this.Aliases == INVALID_HANDLE){
			this.Aliases = CreateArray(255);
		}
		PushArrayString(this.Aliases, effectName);
	}
}

bool AreIncompatibleEffectsRunning(char[] effectName){
	EffectData liveEffect;
	char incompatibleEffect[128];

	LoopAllEffects(liveEffect, index){
		if(liveEffect.Timer != INVALID_HANDLE){
			if(liveEffect.IncompatibleEffects == INVALID_HANDLE) continue;
			for(int i = 0; i < GetArraySize(liveEffect.IncompatibleEffects); i++){
				GetArrayString(liveEffect.IncompatibleEffects, i, incompatibleEffect, sizeof(incompatibleEffect));
				if(StrEqual(incompatibleEffect, effectName)){
					return true;
				}
			}
		}
	}

	return false;
}

bool IsChaosEffectRunning(char[] effectName){
	EffectData effect;
	LoopAllEffects(effect, index){
		if(effect.Timer != INVALID_HANDLE && StrEqual(effect.FunctionName, effectName, false)){
			return true;
		}
	}
	return false;
}

bool AreEffectsWithFlagRunning(char[] flagName){
	EffectData effect;
	LoopAllEffects(effect, index){
		if(effect.Timer != INVALID_HANDLE && effect.IncompatibleFlags != INVALID_HANDLE){
			if(FindStringInArray(effect.IncompatibleFlags, flagName) != -1){
				return true;
			}
			// for(int i = 0; i < GetArraySize(effect.IncompatibleFlags); i++){
			// 	GetArrayString(effect.IncompatibleFlags, i, effectsFlag, sizeof(effectsFlag));
			// 	if(StrEqual(effectsFlag, flagName)){
			// 		return true;
			// 	}
			// }
		}
	}

	return false;
}


public Action Effect_Reset(Handle timer, int effect_id){
	EffectData effect;
	LoopAllEffects(effect, index){
		if(effect.ID == effect_id){
			effect.Reset(RESET_EXPIRED);
			ChaosEffects.SetArray(index, effect);
			break;
		}
	}
	return Plugin_Continue;
}

bool GetEffectData(char[] function_name, EffectData return_data){
	EffectData effect;
	bool found = false;
	LoopAllEffects(effect, index){
		if(StrEqual(effect.FunctionName, function_name, false)){
			found = true;
			break;
		}
	}

	if(found) return_data = effect;
	return found;
	// return null;
}

float GetChaosTime(char[] EffectName, float defaultTime = 15.0, bool raw = false){
	float expire = defaultTime;
	EffectData effect;
	if(GetEffectData(EffectName, effect)){
		expire = effect.GetDuration(raw);
	}else{
		Log("[CONFIG] Could not find configuration for Effect: %s, using default of %f", EffectName, defaultTime);
	}
	return expire;
}

//TODO: remove the need for GetChaosTitle -> use GetEffectDate and use effect.Title more instead of this jank
char[] GetChaosTitle(char[] function_name){
	char return_string[128];

	EffectData effect;
	GetEffectData(function_name, effect);

	if(StrContains(function_name, "Chaos_") != -1){
		if(TranslationPhraseExists(function_name) && IsTranslatedForLanguage(function_name, LANG_SERVER)){
				FormatEx(return_string, sizeof(return_string), "%t", function_name, LANG_SERVER);
		}else{
			FormatEx(return_string, sizeof(return_string), "%s", effect.Title);
		}
	}else{
		FormatEx(return_string, sizeof(return_string), "%s", function_name);
	}

	return return_string;
}


void AnnounceChaos(char[] message, float EffectTime, bool endingChaos = false, bool megaChaos = false){
	if(!Meta_IsWhatsHappeningEnabled()){
		char announcingMessage[128];
		if(megaChaos){
			DisplayCenterTextToAll(message);
			Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_MegaChaos, message);
		}else if(endingChaos){
			Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix_HasTimerEnded, message);
		}else{
			DisplayCenterTextToAll(message);
			Format(announcingMessage, sizeof(announcingMessage), "%s %s", g_Prefix, message);
		}
		CPrintToChatAll(announcingMessage);
		PrintHTML(message);
	}


	//TODO: what if hud was purely based off which timers are active. .Run() would save the current game time to predict how long is left
	char EffectName[256];
	FormatEx(EffectName, sizeof(EffectName), "%s", RemoveMulticolors(message));

	if(!endingChaos && EffectTime > -2.0){
		if(EffectTime == 0.0){
			AddEffectToHud(EffectName, 9999.0, megaChaos);
		}else{
			AddEffectToHud(EffectName, EffectTime, megaChaos);
		}
	}
}


float SanitizeTime(float time){
	if(time <= 0) return 0.0;
	if(time < 5) return 5.0;
	if(time > 120) return 0.0;
	return time;
}


bool Effect_Recently_Played(char[] effect_name){
	bool found = false;
	if(FindStringInArray(EffectsHistory, effect_name) != -1){
		found = true;
	}
	return found;
}

void PoolChaosEffects(char[] effectName = ""){

	char alias[64];
	PossibleChaosEffects.Clear();
	EffectData effect;
	LoopAllEffects(effect, index){
		if(effectName[0] != '\0'){ //* if keyword was provided
			bool containsAlias = false;
			if(effect.Aliases != INVALID_HANDLE){
				for(int i = 0; i < GetArraySize(effect.Aliases); i++){
					GetArrayString(effect.Aliases, i, alias, sizeof(alias));
					if(StrContains(alias, effectName, false) != -1){
						containsAlias = true;
					}
				}
			}

			if(
				StrContains(effect.FunctionName, effectName, false) != -1 ||
				StrContains(effect.Title, effectName, false) != -1 ||
				containsAlias
			){
				PossibleChaosEffects.PushArray(effect, sizeof(effect));
			}
		}else{
			PossibleChaosEffects.PushArray(effect, sizeof(effect)); //* Show all but may be disabled in menu
		}
	}

	// Log("Size of pooled chaos effects: %i", PossibleChaosEffects.Length);
}
