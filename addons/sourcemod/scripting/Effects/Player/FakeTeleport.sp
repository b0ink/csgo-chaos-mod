#pragma semicolon 1

float FakeTelport_loc[MAXPLAYERS+1][3];
Handle FakeTeleportTimer = INVALID_HANDLE;
public void Chaos_FakeTeleport(EffectData effect){
	effect.Title = "Fake Teleport";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_EffectName");
}


public void Chaos_FakeTeleport_INIT(){
	HookEvent("round_end", Chaos_FakeTeleport_Event_RoundEnd);
}

public void Chaos_FakeTeleport_Event_RoundEnd(Event event, const char[] name, bool dontBroadcast){
	StopTimer(FakeTeleportTimer);
}

public void Chaos_FakeTeleport_START(){
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, FakeTelport_loc[i]);
	}
	char text[64];
	FormatEx(text, 64, "%s  ", GetChaosTitle("Chaos_RandomTeleport"));
	AnnounceChaos(text, -1.0);
	DoRandomTeleport();
	StopTimer(FakeTeleportTimer);
	FakeTeleportTimer = CreateTimer(3.0, Timer_EndTeleport);
}

public Action Timer_EndTeleport(Handle timer){
	LoopAlivePlayers(i){
		TeleportEntity(i, FakeTelport_loc[i], NULL_VECTOR, NULL_VECTOR);
	}
	AnnounceChaos(GetChaosTitle("Chaos_FakeTeleport"), -1.0);
	char text[64];
	FormatEx(text, 64, "%s  ", GetChaosTitle("Chaos_RandomTeleport"));
	RemoveHudByName(text);
	return Plugin_Continue;
}

public bool Chaos_FakeTeleport_Conditions(bool EffectRunRandomly){
	if(!ValidMapPoints()) return false;
	return true;
}