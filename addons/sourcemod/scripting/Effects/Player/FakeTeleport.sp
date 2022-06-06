float FakeTelport_loc[MAXPLAYERS+1][3];

public void Chaos_FakeTeleport_START(){
	// float duration = 3.0;
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			GetClientAbsOrigin(i, vec);
			FakeTelport_loc[i] = vec;
		}
	}
	DoRandomTeleport();
	CreateTimer(3.0, Timer_EndTeleport);
}

public Action Timer_EndTeleport(Handle timer){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			float vec[3];
			vec = FakeTelport_loc[i];
			TeleportEntity(i, vec, NULL_VECTOR, NULL_VECTOR);
		}
	}
	AnnounceChaos(GetChaosTitle("Chaos_FakeTeleport"), -1.0);
}

public Action Chaos_FakeTeleport_RESET(bool EndChaos){
	if(EndChaos){

	}
}




public bool Chaos_FakeTeleport_CustomAnnouncement(){
	return true;
}

public bool Chaos_FakeTeleport_HasNoDuration(){
	return false;
}

public bool Chaos_FakeTeleport_Conditions(){
	if(!ValidMapPoints()) return false;
	return true;
}