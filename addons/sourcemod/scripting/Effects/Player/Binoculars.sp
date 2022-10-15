public void Chaos_Binoculars(effect_data effect){
	effect.title = "Binoculars";
	effect.duration = 30;
}

public void Chaos_Binoculars_OnMapStart(){
	PrecacheDecal("Chaos/binoculars.vmt", true);
	PrecacheDecal("Chaos/binoculars.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/binoculars.vtf");
	AddFileToDownloadsTable("materials/Chaos/binoculars.vmt");
}

public void Chaos_Binoculars_START(){
	int RandomFOV = GetRandomInt(20,30);
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", RandomFOV);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", RandomFOV);
	}
	Add_Overlay("/Chaos/binoculars.vtf");
}

public Action Chaos_Binoculars_RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", 0);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", 90);
	}
	Remove_Overlay("/Chaos/binoculars.vtf");
}
