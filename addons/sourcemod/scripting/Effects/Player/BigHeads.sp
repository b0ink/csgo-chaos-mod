#define EFFECTNAME BigHeads

SETUP(effect_data effect){
	effect.Title = "Big Heads";
	effect.Duration = 30;
}

char originalBigHeadModels[MAXPLAYERS+1][PLATFORM_MAX_PATH];

char BigHead_T_Path[PLATFORM_MAX_PATH] =   "models/player/custom_player/eminem/big_head/tm_phoenix.mdl";
char BigHead_CT_Path[PLATFORM_MAX_PATH] =  "models/player/custom_player/eminem/big_head/ctm_sas.mdl";

bool bigHeadsMaterials = true;

public void Chaos_BigHeads_OnMapStart(){
	PrecacheModel(BigHead_T_Path, true);
	PrecacheModel(BigHead_CT_Path, true);
	
	AddFileToDownloadsTable(BigHead_CT_Path);
	AddFileToDownloadsTable(BigHead_T_Path);

	AddFileToDownloadsTable("models/player/custom_player/eminem/big_head/tm_phoenix.vvd");
	AddFileToDownloadsTable("models/player/custom_player/eminem/big_head/tm_phoenix.phy");
	AddFileToDownloadsTable("models/player/custom_player/eminem/big_head/tm_phoenix.dx90.vtx");
	AddFileToDownloadsTable("models/player/custom_player/eminem/big_head/ctm_sas.vvd");
	AddFileToDownloadsTable("models/player/custom_player/eminem/big_head/ctm_sas.phy");
	AddFileToDownloadsTable("models/player/custom_player/eminem/big_head/ctm_sas.dx90.vtx");

	
	if(!FileExists(BigHead_T_Path)) bigHeadsMaterials = false;
	if(!FileExists(BigHead_CT_Path)) bigHeadsMaterials = false;
}
START(){
	LoopAlivePlayers(i){
		SetBigHeadModel(i);
	}
}

void SetBigHeadModel(int client){
	int team = GetClientTeam(client);
	GetClientModel(client, originalBigHeadModels[client], PLATFORM_MAX_PATH);

	if(team == CS_TEAM_T){
		SetEntityModel(client, BigHead_T_Path);
	}else{
		SetEntityModel(client, BigHead_CT_Path);
	}
}


RESET(bool HasTimerEnded){
	if(HasTimerEnded){
		LoopAlivePlayers(i){
			if(originalBigHeadModels[i][0] != '\0'){
				SetEntityModel(i, originalBigHeadModels[i]);
			}
		}
	}
}


public void Chaos_BigHeads_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetBigHeadModel(client);
	}
}

CONDITIONS(){
	return bigHeadsMaterials;
}