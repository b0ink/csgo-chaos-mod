#pragma semicolon 1

bool AntiFlash = false;

public void Chaos_AntiFlash(EffectData effect){
	effect.Title = "Anti Flash";
	effect.Duration = 30;
}

public void Chaos_AntiFlash_INIT(){
	HookEvent("player_blind", AntiFlash_Event_PlayerBlind, EventHookMode_Pre);
}

public Action AntiFlash_Event_PlayerBlind(Event event, const char[] name, bool dontBroadcast){
	if(!AntiFlash) return Plugin_Continue;
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(ValidAndAlive(client)){
		SetEntPropFloat(client, Prop_Send, "m_flFlashMaxAlpha", 0.5);
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public void Chaos_AntiFlash_START(){
	AntiFlash = true;
}

public void Chaos_AntiFlash_RESET(){
	AntiFlash = false;
}