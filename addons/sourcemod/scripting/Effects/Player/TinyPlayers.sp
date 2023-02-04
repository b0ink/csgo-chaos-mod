char defaultTinyModels[MAXPLAYERS+1][PLATFORM_MAX_PATH];

char tinyPlayer[] = "models/player/custom_player/boink/tm_phoenix_variantf_tiny.mdl";
char tinyPlayerPhy[] = "models/player/custom_player/boink/tm_phoenix_variantf_tiny.phy";
char tinyPlayerVvd[] = "models/player/custom_player/boink/tm_phoenix_variantf_tiny.vvd";
char tinyPlayerVtx[] = "models/player/custom_player/boink/tm_phoenix_variantf_tiny.dx90.vtx";
bool TinyPlayers = false;

bool tinyPlayerModels = true;
public void Chaos_TinyPlayers(effect_data effect){
	effect.Title = "Tiny Player Knife Fight";
	effect.Duration = 30;
}

public void Chaos_TinyPlayers_OnMapStart(){

	if(!FileExists(tinyPlayer)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerPhy)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerVvd)) tinyPlayerModels = false;
	if(!FileExists(tinyPlayerVtx)) tinyPlayerModels = false;

	if(!tinyPlayerModels) return;
	
	AddFileToDownloadsTable(tinyPlayer);
	AddFileToDownloadsTable(tinyPlayerPhy);
	AddFileToDownloadsTable(tinyPlayerVvd);
	AddFileToDownloadsTable(tinyPlayerVtx);
	PrecacheModel(tinyPlayer, true);
}

public void Chaos_TinyPlayers_START(){
	TinyPlayers = true;
	HookBlockAllGuns();


	LoopAlivePlayers(i){
		FakeClientCommand(i, "use weapon_knife");

		GetEntPropString(i, Prop_Data, "m_ModelName", defaultTinyModels[i], PLATFORM_MAX_PATH);
		SetEntityModel(i, tinyPlayer);

		SDKHook(i, SDKHook_PostThink, PostThink);
	}
}

public void Chaos_TinyPlayers_RESET(bool HasTimerEnded){
	TinyPlayers = false;
	
	UnhookBlockAllGuns();

	LoopAlivePlayers(i){
		if(defaultTinyModels[i][0] != '\0'){
			SetEntityModel(i, defaultTinyModels[i]);
		}
		if(HasTimerEnded){
			if(!HasMenuOpen(i)){
				ClientCommand(i, "slot1");
			}
		}
	}
}

// public void Chaos_TinyPlayers_OnGameFrame(){
// 	LoopAlivePlayers(i){
// 		float vec[3];
// 		GetEntPropVector(i, Prop_Send, "m_vecOrigin", vec);
// 		vec[2] -= 15.0;
// 		SetEntPropVector(i, Prop_Send, "m_vecOrigin", vec); 
// 	}
// }

public void PostThink(int client){
	if(!TinyPlayers) return;

	if(!IsFakeClient(client)){
		SetEntProp(client, Prop_Data, "m_fFlags", 131329);
		SetEntProp(client, Prop_Data, "m_bDucked", 0);
		SetEntProp(client, Prop_Data, "m_bDucking", 0);
		SetEntPropFloat(client, Prop_Data, "m_flLastDuckTime", 0.0);
		SetEntProp(client, Prop_Data, "m_bInDuckJump", 0);
		SetEntProp(client, Prop_Data, "m_bHasWalkMovedSinceLastJump", 1);
	}
	float vec[3];
	vec[0] = 0.0;
	vec[1] = 0.0;
	vec[2] = 32.0;
	SetEntPropVector(client, Prop_Data, "m_vecViewOffset", vec);
}

public bool Chaos_TinyPlayers_Conditions(bool EffectRunRandomly){
	return tinyPlayerModels;
}