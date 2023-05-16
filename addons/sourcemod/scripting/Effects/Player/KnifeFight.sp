#pragma semicolon 1

public void Chaos_KnifeFight(EffectData effect){
	effect.Title = "Knife Fight";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
}

public void Chaos_KnifeFight_START(){
	HookBlockAllGuns();
}

public void Chaos_KnifeFight_RESET(int ResetType){
	UnhookBlockAllGuns(ResetType);
}

public void Chaos_KnifeFight_OnPlayerSpawn(int client){
	HookBlockAllGuns(client);
}

public bool Chaos_KnifeFight_Conditions(bool EffectRunRandomly){
	if(GetBotCount() > 0) return false;
	return true;
}
// public Action Chaos_KnifeFight_Hook_WeaponSwitch(int client, int weapon){
// 	return BlockAllGuns(client, weapon);
// }