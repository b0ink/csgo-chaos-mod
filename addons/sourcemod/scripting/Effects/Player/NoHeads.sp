SETUP(effect_data effect){
	effect.Title = "No Heads";
	effect.Duration = 30;
}

char originalNoHeadModels[MAXPLAYERS+1][PLATFORM_MAX_PATH];

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
START(){
	LoopAlivePlayers(i){
		SetNoHeadModel(i);
	}
}

void SetNoHeadModel(int client){
	int team = GetClientTeam(client);
	GetClientModel(client, originalNoHeadModels[client], PLATFORM_MAX_PATH);

	if(team == CS_TEAM_T){
		SetEntityModel(client, NoHead_T_Path);
	}else{
		SetEntityModel(client, NoHead_CT_Path);
	}
}


RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			if(originalNoHeadModels[i][0] != '\0'){
				SetEntityModel(i, originalNoHeadModels[i]);
			}
		}
	}
}


public void Chaos_NoHeads_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetNoHeadModel(client);
	}
}

CONDITIONS(){
	return noHeadsMaterials;
}