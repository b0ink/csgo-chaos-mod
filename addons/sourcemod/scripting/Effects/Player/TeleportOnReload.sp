bool TeleportOnReload = false;

public void Chaos_TeleportOnReload(EffectData effect){
	effect.Title = "Teleport On Reload";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
	HookEvent("weapon_reload", Chaos_TeleportOnReload_Event_WeaponReload);
}

public void Chaos_TeleportOnReload_START(){
	TeleportOnReload = true;
}

public void Chaos_TeleportOnReload_RESET(){
	TeleportOnReload = false;
}

public void Chaos_TeleportOnReload_Event_WeaponReload(Event event, const char[] name, bool dontBroadcast){
	if(!TeleportOnReload) return;
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(ValidAndAlive(client)){
		DoRandomTeleport(client);
	}
}

public bool Chaos_TeleportOnReload_Conditions(){
	if(!ValidMapPoints()){
		return false;
	}
	return true;
}