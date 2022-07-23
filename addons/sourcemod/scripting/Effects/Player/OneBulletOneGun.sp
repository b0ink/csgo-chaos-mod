bool OneBulletOneGun = false;

public void Chaos_OneBulletOneGun_INIT(){
	OneBulletOneGun = false;
}

char g_OBOG_WeaponName[32];
public void Chaos_OneBulletOneGun_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	event.GetString("weapon", g_OBOG_WeaponName, sizeof(g_OBOG_WeaponName));
	int client = GetClientOfUserId(event.GetInt("userid"));
	weaponJump(client, g_OBOG_WeaponName);

	if(OneBulletOneGun){
		if(StrContains(g_OBOG_WeaponName, "weapon_knife") == -1){
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

public Action Chaos_OneBulletOneGun_RESET(bool HasTimerEnded){
	OneBulletOneGun = false;
}