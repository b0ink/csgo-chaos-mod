#pragma semicolon 1

bool g_bLoose_Trigger = false;
bool ShouldAttack[MAXPLAYERS+1];

public void Chaos_LooseTrigger(EffectData effect){
	effect.Title = "Loose Trigger";
	effect.Duration = 10;
	effect.OverrideDuration = true; //TODO: add a min-max duration property, server owner should be able to reduce this to 5seconds instead of 10sec lock
}

public void Chaos_LooseTrigger_INIT(){
	HookEvent("weapon_fire", Chaos_LooseTrigger_WeaponFire);
}

// Loose Trigger num generator for specific numbers
int LT_NumGen(int num1, num2 = -1, num3 = -1, num4 = -1, num5 = -1){
	ArrayList numberSet = new ArrayList();
	if(num1 > 0) numberSet.Push(num1);
	if(num2 > 0) numberSet.Push(num2);
	if(num3 > 0) numberSet.Push(num3);
	if(num4 > 0) numberSet.Push(num4);
	if(num5 > 0) numberSet.Push(num5);

	return numberSet.Get(GetURandomInt() % numberSet.Length);
}

// Locally plays weapon sounds as the loose trigger has server-side trouble

void Chaos_LooseTrigger_WeaponFire(Event event, const char[] name, bool dontBroadcast){
	if(!g_bLoose_Trigger) return;
	
	char weaponName[64];
	event.GetString("weapon", weaponName, 64);
	int client = GetClientOfUserId(event.GetInt("userid"));
	char soundPath[PLATFORM_MAX_PATH];
	Format(weaponName, 64, "%s", weaponName[7]);
	PrintToChatAll(weaponName);
	if(StrEqual(weaponName, "ak47")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/ak47/ak47_01.wav");
	}else if(StrEqual(weaponName, "aug")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/aug/aug_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "awp")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/awp/awp_0%i.wav", LT_NumGen(1, 2));
	}else if(StrEqual(weaponName, "bizon")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/bizon/bizon_0%i.wav", LT_NumGen(1, 2));
	}else if(StrEqual(weaponName, "cz75a")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/cz75a/cz75_0%i.wav", LT_NumGen(1, 2, 3));
	}else if(StrEqual(weaponName, "deagle")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/deagle/deagle_0%i.wav", LT_NumGen(1, 2));
	}else if(StrEqual(weaponName, "elite")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/elite/elites_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "famas")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/famas/famas_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "fiveseven")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/fiveseven/fiveseven_01.wav ");
	}else if(StrEqual(weaponName, "g3sg1")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/g3sg1/g3sg1_01.wav", LT_NumGen(1, 2, 3));
	}else if(StrEqual(weaponName, "galilar")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/galilar/galil_0%i.wav", LT_NumGen(1, 2, 3));
	}else if(StrEqual(weaponName, "glock")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/glock18/glock_0%i.wav", LT_NumGen(1, 2));
	}else if(StrEqual(weaponName, "hkp2000")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/hkp2000/hkp2000_0%i.wav", LT_NumGen(1, 2, 3));
	}else if(StrContains(weaponName, "knife") != -1){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/knife/knife_slash%i.wav", LT_NumGen(1, 2));
	}else if(StrEqual(weaponName, "m249")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/m249/m249-1.wav");
	}else if(StrEqual(weaponName, "m4a1")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/m4a1/m4a1_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "mac10")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/mac10/mac10_0%i.wav", LT_NumGen(1, 2, 3));
	}else if(StrEqual(weaponName, "mag7")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/mag7/mag7_0%i.wav", LT_NumGen(1, 2));
	}else if(StrEqual(weaponName, "mp5sd")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/mp5/mp5_01.wav");
	}else if(StrEqual(weaponName, "mp7")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/mp7/mp7_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "mp9")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/mp9/mp9_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "negev")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/negev/negev_0%i.wav", LT_NumGen(1, 2, 3, 4, 5));
	}else if(StrEqual(weaponName, "nova")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/nova/nova-1.wav");
	}else if(StrEqual(weaponName, "p250")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/p250/p250_0%i.wav", LT_NumGen(1, 2, 3));
	}else if(StrEqual(weaponName, "sawedoff")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/sawedoff/sawedoff-1.wav");
	}else if(StrEqual(weaponName, "scar20")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/scar20/scar20_0%i.wav", LT_NumGen(1, 2, 3));
	}else if(StrEqual(weaponName, "sg556")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/sg556/sg556_0%i.wav", LT_NumGen(1, 2, 3, 4));
	}else if(StrEqual(weaponName, "ssg08")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/ssg08/ssg08_01.wav");
	}else if(StrEqual(weaponName, "taser")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/taser/taser_shoot.wav");
	}else if(StrEqual(weaponName, "tec9")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/tec9/tec9_02.wav");
	}else if(StrEqual(weaponName, "ump45")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/ump45/ump45_0%i.wav", GetRandomInt(0, 1) == 0 ? 2 : 4);
	}else if(StrEqual(weaponName, "usp_silencer")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/usp/usp_0%i.wav", GetRandomInt(0, 3));
	}else if(StrEqual(weaponName, "xm1014")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/xm1014/xm1014-1.wav");
	}else if(StrEqual(weaponName, "p90")){
		FormatEx(soundPath, PLATFORM_MAX_PATH, "weapons/p90/p90_0%i.wav", LT_NumGen(1, 2, 3));
	}
	
	
	ClientCommand(client, "playgamesound %s", soundPath);
}


public void Chaos_LooseTrigger_START(){
	g_bLoose_Trigger = true;
}

public void Chaos_LooseTrigger_RESET(int ResetType){
	g_bLoose_Trigger = false;
}

public void Chaos_LooseTrigger_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]){
	if (g_bLoose_Trigger) {
		ShouldAttack[client] = !ShouldAttack[client];
		if(ShouldAttack[client]){
			buttons &= ~IN_ATTACK;
		}else{
			buttons |= IN_ATTACK;
		}
	}
}