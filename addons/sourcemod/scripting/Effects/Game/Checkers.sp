#pragma semicolon 1

bool Checkers = false;
bool checkersMaterials = true;
int checkersToggle[MAXPLAYERS+1];


public void Chaos_Checkers(EffectData effect){
	effect.Title = "Checkers";
	effect.Duration = 30;
	effect.AddAlias("Overlay");
	effect.AddAlias("Visual");
	effect.AddFlag("r_screenoverlay");

	HookEvent("weapon_fire", Chaos_Checkers_Event_WeaponFire);
}

public void Chaos_Checkers_OnMapStart(){
	PrecacheDecal("ChaosMod/Checkers_1.vmt", true);
	PrecacheDecal("ChaosMod/Checkers_1.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/Checkers_1.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/Checkers_1.vmt");

	if(!FileExists("materials/ChaosMod/Checkers_1.vmt")) checkersMaterials = false;
	if(!FileExists("materials/ChaosMod/Checkers_1.vtf")) checkersMaterials = false;

	PrecacheDecal("ChaosMod/Checkers_2.vmt", true);
	PrecacheDecal("ChaosMod/Checkers_2.vtf", true);
	AddFileToDownloadsTable("materials/ChaosMod/Checkers_2.vtf");
	AddFileToDownloadsTable("materials/ChaosMod/Checkers_2.vmt");

	if(!FileExists("materials/ChaosMod/Checkers_2.vmt")) checkersMaterials = false;
	if(!FileExists("materials/ChaosMod/Checkers_2.vtf")) checkersMaterials = false;
}


public void Chaos_Checkers_START(){
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"/ChaosMod/Checkers_1.vtf\"");
	}
	Checkers = true;
}

public void Chaos_Checkers_OnPlayerSpawn(int client){
	ClientCommand(client, "r_screenoverlay \"/ChaosMod/Checkers_1.vtf\"");
}


public void Chaos_Checkers_RESET(bool EndChaos){
	Checkers = false;
	LoopValidPlayers(i){
		ClientCommand(i, "r_screenoverlay \"\"");
	}
}


public void Chaos_Checkers_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast){
	if(!Checkers) return;
	int client = GetClientOfUserId(event.GetInt("userid"));

	checkersToggle[client] = 1 - checkersToggle[client];

	ClientCommand(client, "r_screenoverlay \"/Chaos/Checkers_%i.vtf\"", checkersToggle[client]+1);
}


public bool Chaos_Checkers_Conditions(bool EffectRunRandomly){
	return checkersMaterials;
}