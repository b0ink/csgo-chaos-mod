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
	char grenadeAnnounce[64];
	int rand = GetURandomInt() % 6;
	switch(rand){
		case 0: grenadeAnnounce = "HE Grenade";
		case 1: grenadeAnnounce = "Molotov";
		case 2: grenadeAnnounce = "Flashbang";
		case 3: grenadeAnnounce = "Smoke Grenade";
		case 4: grenadeAnnounce = "Decoy Gremade";
		case 5: grenadeAnnounce = "Wallhack Grenade";
		case 6: grenadeAnnounce = "Diversion Grenade";
	}

	Format(grenadeAnnounce, 64, "Give all players a %s", grenadeAnnounce);
	
	LoopValidPlayers(i){
		GivePlayerItem(i, grenades[rand]);
	}
	AnnounceChaos(grenadeAnnounce, GetChaosTime("Chaos_GiveRandomGrenade"));
}