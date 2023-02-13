#pragma semicolon 1

public void Chaos_NoHeads(EffectData effect){
	effect.Title = "No Heads";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_HeadshotOnly");
	effect.AddFlag("playermodel");
}

char NoHead_T_Path[PLATFORM_MAX_PATH] = "models/player/custom_player/legacy/tm_leet_variantk_nohead.mdl";
char NoHead_CT_Path[PLATFORM_MAX_PATH] = "models/player/custom_player/legacy/ctm_st6_nohead.mdl";

bool noHeadsMaterials = true;

public void Chaos_NoHeads_OnMapStart(){
	PrecacheModel(NoHead_T_Path, true);
	PrecacheModel(NoHead_CT_Path, true);
	
	AddFileToDownloadsTable(NoHead_CT_Path);
	AddFileToDownloadsTable(NoHead_T_Path);

	AddFileToDownloadsTable("models/player/custom_player/legacy/ctm_st6_nohead.dx90.vtx");
	AddFileToDownloadsTable("models/player/custom_player/legacy/ctm_st6_nohead.phy");
	AddFileToDownloadsTable("models/player/custom_player/legacy/ctm_st6_nohead.vvd");
	AddFileToDownloadsTable("models/player/custom_player/legacy/tm_leet_variantk_nohead.dx90.vtx");
	AddFileToDownloadsTable("models/player/custom_player/legacy/tm_leet_variantk_nohead.phy");
	AddFileToDownloadsTable("models/player/custom_player/legacy/tm_leet_variantk_nohead.vvd");

	if(!FileExists(NoHead_T_Path)) noHeadsMaterials = false;
	if(!FileExists(NoHead_CT_Path)) noHeadsMaterials = false;
}
public void Chaos_NoHeads_START(){
	LoopAlivePlayers(i){
		SetNoHeadModel(i);
	}
}

void SetNoHeadModel(int client){
	if(GetClientTeam(client) == CS_TEAM_T){
		SetEntityModel(client, NoHead_T_Path);
	}else{
		SetEntityModel(client, NoHead_CT_Path);
	}
}


public void Chaos_NoHeads_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		RestorePlayerModels();
	}
}


public void Chaos_NoHeads_OnPlayerSpawn(int client){
	SetNoHeadModel(client);
}

public bool Chaos_NoHeads_Conditions(bool EffectRunRandomly){
	return noHeadsMaterials;
}