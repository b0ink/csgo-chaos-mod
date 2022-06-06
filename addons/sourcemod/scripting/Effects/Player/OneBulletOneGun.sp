//weapon fire
bool OneBulletOneGun = false;
public void Chaos_OneBulletOneGun_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	char szWeaponName[32];
	event.GetString("weapon", szWeaponName, sizeof(szWeaponName));
	int client = GetClientOfUserId(event.GetInt("userid"));
	weaponJump(client, szWeaponName);

	if(OneBulletOneGun){
		if( StrContains(szWeaponName, "weapon_knife") == -1){
			CreateTimer(0.1, Timer_GiveRandomWeapon_OneShotOneGun, client);
		}
	}
}

public Action Timer_GiveRandomWeapon_OneShotOneGun(Handle timer, int client){
	GiveAndSwitchWeapon(client, g_sWeapons[GetRandomInt(0, sizeof(g_sWeapons) - 1)]);
}


public void Chaos_OneBulletOneGun_START(){
	OneBulletOneGun = true;
}

public Action Chaos_OneBulletOneGun_RESET(bool EndChaos){
	OneBulletOneGun = false;
}


public bool Chaos_OneBulletOneGun_HasNoDuration(){
	return false;
}

public bool Chaos_OneBulletOneGun_Conditions(){
	return true;
}