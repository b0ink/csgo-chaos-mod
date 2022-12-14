float FakeTelport_loc[MAXPLAYERS+1][3];

SETUP(effect_data effect){
	effect.Title = "Fake Teleport";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_EffectName");
}

START(){
	LoopAlivePlayers(i){
		GetClientAbsOrigin(i, FakeTelport_loc[i]);
	}

	AnnounceChaos("Random Teleport  ", -1.0);
	DoRandomTeleport();
	CreateTimer(3.0, Timer_EndTeleport);
}

public Action Timer_EndTeleport(Handle timer){
	LoopAlivePlayers(i){
		TeleportEntity(i, FakeTelport_loc[i], NULL_VECTOR, NULL_VECTOR);
	}
	AnnounceChaos(GetChaosTitle("Chaos_FakeTeleport"), -1.0);
	RemoveHudByName("Random Teleport  ");
}

CONDITIONS(){
	if(!ValidMapPoints()) return false;
	return true;
}