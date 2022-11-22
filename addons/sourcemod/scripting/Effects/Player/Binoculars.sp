public void Chaos_Binoculars(effect_data effect){
	effect.Title = "Binoculars";
	effect.Duration = 30;
}

public void Chaos_Binoculars_OnMapStart(){
	PrecacheDecal("Chaos/binoculars.vmt", true);
	PrecacheDecal("Chaos/binoculars.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/binoculars.vtf");
	AddFileToDownloadsTable("materials/Chaos/binoculars.vmt");
}
int binocularsFOV;

public void Chaos_Binoculars_START(){
	binocularsFOV = GetRandomInt(20,30);
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", binocularsFOV);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", binocularsFOV);
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

public void Chaos_Binoculars_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_iFOV", binocularsFOV);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", binocularsFOV);
	}
}