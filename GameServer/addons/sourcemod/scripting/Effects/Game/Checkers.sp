#define EFFECTNAME Checkers

bool Checkers = false;
bool checkersMaterials = true;
int checkersToggle[MAXPLAYERS+1];


SETUP(effect_data effect){
	effect.Title = "Checkers";
	effect.Duration = 30;
}


INIT(){
	HookEvent("weapon_fire", Chaos_Checkers_Event_WeaponFire);
}


ONMAPSTART(){
	PrecacheDecal("Chaos/Checkers_1.vmt", true);
	PrecacheDecal("Chaos/Checkers_1.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/Checkers_1.vtf");
	AddFileToDownloadsTable("materials/Chaos/Checkers_1.vmt");

	if(!FileExists("materials/Chaos/Checkers_1.vmt")) checkersMaterials = false;
	if(!FileExists("materials/Chaos/Checkers_1.vtf")) checkersMaterials = false;

	PrecacheDecal("Chaos/Checkers_2.vmt", true);
	PrecacheDecal("Chaos/Checkers_2.vtf", true);
	AddFileToDownloadsTable("materials/Chaos/Checkers_2.vtf");
	AddFileToDownloadsTable("materials/Chaos/Checkers_2.vmt");

	if(!FileExists("materials/Chaos/Checkers_2.vmt")) checkersMaterials = false;
	if(!FileExists("materials/Chaos/Checkers_2.vtf")) checkersMaterials = false;
}


START(){
	Add_Overlay("/Chaos/Checkers_1.vtf");
	Checkers = true;
}


RESET(bool HasTimerEnded){
	Checkers = false;
	Remove_Overlay("/Chaos/Checkers_1.vtf");
	Remove_Overlay("/Chaos/Checkers_2.vtf");
}


public void Chaos_Checkers_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast){
	if(!Checkers) return;
	int client = GetClientOfUserId(event.GetInt("userid"));

	checkersToggle[client] = 1 - checkersToggle[client];

	ClientCommand(client, "r_screenoverlay \"/Chaos/Checkers_%i.vtf\"", checkersToggle[client]+1);
}


CONDITIONS(){
	if(!CanRunOverlayEffect()) return false;
	return checkersMaterials;
}