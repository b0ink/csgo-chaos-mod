#define EFFECTNAME RapidFire

bool RapidFire = false;

SETUP(effect_data effect){
	effect.Title = "Rapid Fire";
	effect.Duration = 30;
	effect.AddFlag("firerate");
}

INIT(){
	HookEvent("weapon_fire", Chaos_RapidFire_WeaponFire);
}

public void Chaos_RapidFire_WeaponFire(Event event, char[] name, bool dbc){
	if(RapidFire){
	    RequestFrame(SetRapidFire, event.GetInt("userid"));
	}
}

public void SetRapidFire(int userid){
	FirePostFrame(userid, 1.8);
}

START(){
	RapidFire = true;
	cvar("weapon_accuracy_nospread", "1");
	cvar("weapon_recoil_scale", "0.5");
}

RESET(bool HasTimerEnded){
	ResetCvar("weapon_accuracy_nospread", "0", "1");
	ResetCvar("weapon_recoil_scale", "2", "0.5");
	RapidFire = false;
}

public void FirePostFrame(int userid, float speed){
    int client = GetClientOfUserId(userid);
    if(!ValidAndAlive(client)) return;

    int weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
    float curtime = GetGameTime();
    float nexttime = GetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack");

    nexttime -= curtime;
    nexttime *= 1.0/ speed; // 4.0 - multiplier
    nexttime += curtime;

    SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", nexttime);
    SetEntPropFloat(client, Prop_Send, "m_flNextAttack", 0.0);
} 