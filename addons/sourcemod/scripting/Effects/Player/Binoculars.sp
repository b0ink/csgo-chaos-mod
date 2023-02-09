#pragma semicolon 1

public void Chaos_Binoculars(EffectData effect){
	effect.Title = "Binoculars";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddFlag("r_screenoverlay");
}

bool binocularsMaterials = true;
int binocularsFOV;

public void Chaos_Binoculars_OnMapStart(){
	PrecacheDecal("ChaosMod/binoculars.vmt", true);
	PrecacheDecal("ChaosMod/binoculars.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/binoculars.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/binoculars.vmt");
	
	if(!FileExists("materials/ChaosMod/binoculars.vtf")) binocularsMaterials = false;
	if(!FileExists("materials/ChaosMod/binoculars.vmt")) binocularsMaterials = false;
}


public void Chaos_Binoculars_START(){
	binocularsFOV = GetRandomInt(20,30);
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", binocularsFOV);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", binocularsFOV);
	}
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/binoculars.vtf\"");
	}
}



public void Chaos_Binoculars_RESET(int ResetType){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", 0);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", 90);
	}
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}


public void Chaos_Binoculars_OnPlayerSpawn(int client){
	SetEntProp(client, Prop_Send, "m_iFOV", binocularsFOV);
	SetEntProp(client, Prop_Send, "m_iDefaultFOV", binocularsFOV);
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/binoculars.vtf\"");
}


public bool Chaos_Binoculars_Conditions(bool EffectRunRandomly){
	return binocularsMaterials;
}