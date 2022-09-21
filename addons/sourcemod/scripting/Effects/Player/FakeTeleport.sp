float FakeTelport_loc[MAXPLAYERS+1][3];

public void Chaos_FakeTeleport(effect_data effect){
	//TODO: announce it as "Random Teleport", then change the name to "Fake Teleport"
	effect.title = "Fake Teleport";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_EffectName");
}

public void Chaos_FakeTeleport_START(){
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, FakeTelport_loc[i]);
	}

	DoRandomTeleport();
	CreateTimer(3.0, Timer_EndTeleport);
}

public Action Timer_EndTeleport(Handle timer){
	LoopAlivePlayers(i){
		TeleportEntity(i, FakeTelport_loc[i], NULL_VECTOR, NULL_VECTOR);
	}
	AnnounceChaos(GetChaosTitle("Chaos_FakeTeleport"), -1.0);
}

public bool Chaos_FakeTeleport_Conditions(){
	if(!ValidMapPoints()) return false;
	return true;
}