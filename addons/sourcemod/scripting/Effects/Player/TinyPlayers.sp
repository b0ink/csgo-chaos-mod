/*

	Inspired by defuJ to learn how to create the models myself: https://www.youtube.com/watch?v=94GW85NT998
	Proportion trick: https://www.youtube.com/watch?v=XPGYcG1CG78
	defuJ also helped guide me at the very end to the right place on how to modify player collision hull :D
	
*/

#pragma semicolon 1

float g_fNewHullValues[] = {
	0.0,   0.0,  64.0,

	-16.0, -16.0,   0.0,
	16.0,  16.0,  36.0,

	-16.0, -16.0,  0.0,
	16.0,  16.0,  54.0,
	// 16.0,  16.0,  36.0,
	0.0,   0.0,  46.0,
	// 0.0,   0.0,  28.0,

	-10.0, -10.0, -10.0,
	10.0 , 10.0,  10.0,

	0.0,   0.0,  14.0
};

//!NITE: expect these to change after csgo updates
float g_fOriginalHullValues[] = {
	0.0,   0.0,  64.0,

	-16.0, -16.0,   0.0,
	16.0,  16.0,  72.0,

	-16.0, -16.0,  0.0,
	16.0,  16.0,  54.0,
	0.0,   0.0,  46.0,

	-10.0, -10.0, -10.0,
	10.0 , 10.0,  10.0,

	0.0,   0.0,  14.0
};

Address g_CSViewVectors;

float g_fOldHullValues[sizeof( g_fNewHullValues )];
bool FoundCSViewVectors = false;



char defaultTinyModels[MAXPLAYERS+1][PLATFORM_MAX_PATH];


char tinyPlayer_t[] = "models/player/custom_player/boink/tm_leet_variantb_tiny.mdl";
char tinyPlayerPhy_t[] = "models/player/custom_player/boink/tm_leet_variantb_tiny.phy";
char tinyPlayerVvd_t[] = "models/player/custom_player/boink/tm_leet_variantb_tiny.vvd";
char tinyPlayerVtx_t[] = "models/player/custom_player/boink/tm_leet_variantb_tiny.dx90.vtx";

char tinyPlayer_ct[] = "models/player/custom_player/boink/ctm_sas_varianta_tiny.mdl";
char tinyPlayerPhy_ct[] = "models/player/custom_player/boink/ctm_sas_varianta_tiny.phy";
char tinyPlayerVvd_ct[] = "models/player/custom_player/boink/ctm_sas_varianta_tiny.vvd";
char tinyPlayerVtx_ct[] = "models/player/custom_player/boink/ctm_sas_varianta_tiny.dx90.vtx";


bool TinyPlayers = false;

bool tinyPlayerModels = true;

public void Chaos_TinyPlayers(effect_data effect){
	effect.Title = "Tiny Players";
	effect.Duration = 30;
}

public void Chaos_TinyPlayers_OnMapStart(){
	Handle hGameConf = LoadGameConfigFile("changehull.games");
	FoundCSViewVectors = false;

	if(hGameConf != INVALID_HANDLE){
		g_CSViewVectors = GameConfGetAddress(hGameConf, "g_CSViewVectors");
		if(g_CSViewVectors != Address_Null){
			FoundCSViewVectors = true;

			for(int i = 0; i < sizeof(g_fNewHullValues); i++ ){
				g_fOldHullValues[i] = view_as<float>( LoadFromAddress( g_CSViewVectors + view_as<Address>( i*4 ), NumberType_Int32 ) );
				StoreToAddress(g_CSViewVectors + view_as<Address>( i*4 ), view_as<int>( g_fOriginalHullValues[i] ), NumberType_Int32 );
			}
		}
	}

	delete hGameConf;

	if(!FileExists(tinyPlayer_t)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerPhy_t)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerVvd_t)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerVtx_t)) tinyPlayerModels = false;


	if(!FileExists(tinyPlayer_ct)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerPhy_ct)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerVvd_ct)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerVtx_ct)) tinyPlayerModels = false;

	if(!tinyPlayerModels) return;

	AddFileToDownloadsTable(tinyPlayer_t);
	AddFileToDownloadsTable(tinyPlayerPhy_t);
	AddFileToDownloadsTable(tinyPlayerVvd_t);
	AddFileToDownloadsTable(tinyPlayerVtx_t);

	AddFileToDownloadsTable(tinyPlayer_ct);
	AddFileToDownloadsTable(tinyPlayerPhy_ct);
	AddFileToDownloadsTable(tinyPlayerVvd_ct);
	AddFileToDownloadsTable(tinyPlayerVtx_ct);

	PrecacheModel(tinyPlayer_t, true);
	PrecacheModel(tinyPlayer_ct, true);
}

public void Chaos_TinyPlayers_START(){
	TinyPlayers = true;

	cvar("sv_jump_impulse", "275");
	LoopAlivePlayers(i){
		SetTinyPlayer(i);
	}

	if(g_CSViewVectors != Address_Null && FoundCSViewVectors){
		for( int i = 0; i < sizeof( g_fNewHullValues ); i++ ){
			StoreToAddress( g_CSViewVectors + view_as<Address>( i*4 ), view_as<int>( g_fNewHullValues[i] ), NumberType_Int32 );
		}
	}
}

void SetTinyPlayer(int client){
	GetEntPropString(client, Prop_Data, "m_ModelName", defaultTinyModels[client], PLATFORM_MAX_PATH);
	if(GetClientTeam(client) == CS_TEAM_CT){
		SetEntityModel(client, tinyPlayer_ct);
	}else{
		SetEntityModel(client, tinyPlayer_t);
	}
		

	SDKUnhook(client, SDKHook_PostThink, PostThink);
	SDKHook(client, SDKHook_PostThink, PostThink);
}


public void Chaos_TinyPlayers_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetTinyPlayer(client);
	}
}
public void Chaos_TinyPlayers_RESET(bool HasTimerEnded){
	TinyPlayers = false;
	ResetCvar("sv_jump_impulse", "301", "275");
	
	LoopValidPlayers(i){
		SDKUnhook(i, SDKHook_PostThink, PostThink);
	}
	
	LoopAlivePlayers(i){
		if(HasTimerEnded){
			if(defaultTinyModels[i][0] != '\0'){
				SetEntityModel(i, defaultTinyModels[i]);
			}
			if(!HasMenuOpen(i)){
				ClientCommand(i, "slot1");
			}
		}
	}


	if(g_CSViewVectors != Address_Null && FoundCSViewVectors){
        for(int i = 0; i < sizeof(g_fOriginalHullValues); i++ ){
			StoreToAddress(g_CSViewVectors + view_as<Address>( i*4 ), view_as<int>(g_fOriginalHullValues[i]), NumberType_Int32);
        }
    }
}


public void PostThink(int client){
	if(!TinyPlayers) return;

	// if(!IsFakeClient(client)){
	// 	SetEntProp(client, Prop_Data, "m_fFlags", 131329);
	// 	SetEntProp(client, Prop_Data, "m_bDucked", 0);
	// 	SetEntProp(client, Prop_Data, "m_bDucking", 0);
	// 	SetEntPropFloat(client, Prop_Data, "m_flLastDuckTime", 0.0);
	// 	SetEntProp(client, Prop_Data, "m_bInDuckJump", 0);
	// 	SetEntProp(client, Prop_Data, "m_bHasWalkMovedSinceLastJump", 1);
	// }
	float vec[3];
	vec[0] = 0.0;
	vec[1] = 0.0;
	vec[2] = 32.0;
	SetEntPropVector(client, Prop_Data, "m_vecViewOffset", vec);
}

public bool Chaos_TinyPlayers_Conditions(bool EffectRunRandomly){
	return tinyPlayerModels;
}
