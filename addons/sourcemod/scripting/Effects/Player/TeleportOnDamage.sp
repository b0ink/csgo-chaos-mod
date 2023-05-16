bool TeleportOnDamage = false;

public void Chaos_TeleportOnDamage(EffectData effect){
	effect.Title = "Teleport When You Take Damage";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
	HookEvent("player_hurt", Chaos_TeleportOnDamage_Event_PlayerHurt);
}

public void Chaos_TeleportOnDamage_START(){
	TeleportOnDamage = true;
}

public void Chaos_TeleportOnDamage_RESET(){
	TeleportOnDamage = false;
}

public void Chaos_TeleportOnDamage_Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast){
	if(!TeleportOnDamage) return;
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(ValidAndAlive(client)){
		DoRandomTeleport(client);
	}
}

public bool Chaos_TeleportOnDamage_Conditions(){
	if(!ValidMapPoints()){
		return false;
	}
	return true;
}