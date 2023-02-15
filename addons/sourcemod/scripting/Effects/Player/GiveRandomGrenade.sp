#pragma semicolon 1

public void Chaos_GiveRandomGrenade(EffectData effect){
	effect.Title = "Give Random Grenade";
	
	effect.HasCustomAnnouncement = true;
	effect.HasNoDuration = true;
}

char grenades[][] = {
	"weapon_hegrenade",
	"weapon_molotov",
	"weapon_flashbang",
	"weapon_smokegrenade",
	"weapon_decoy",
	"weapon_tagrenade",
	"weapon_diversion",
};

public void Chaos_GiveRandomGrenade_START(){
	char grenadeAnnounce[128];
	char grenadeType[64];
	FormatEx(grenadeAnnounce, 64, "%s", GetChaosTitle("Chaos_GiveRandomGrenade_Custom"));
	int rand = GetURandomInt() % 6;
	switch(rand){
		case 0: grenadeType = "HE Grenade";
		case 1: grenadeType = "Molotov";
		case 2: grenadeType = "Flashbang";
		case 3: grenadeType = "Smoke Grenade";
		case 4: grenadeType = "Decoy Gremade";
		case 5: grenadeType = "Wallhack Grenade";
		case 6: grenadeType = "Diversion Grenade";
	}

	Format(grenadeAnnounce, 64, "%s %s", grenadeAnnounce, grenadeType);

	LoopValidPlayers(i){
		GivePlayerItem(i, grenades[rand]);
	}

	AnnounceChaos(grenadeAnnounce, GetChaosTime("Chaos_GiveRandomGrenade"));
}