#define EFFECTNAME SlowFire

bool SlowFire = false;

SETUP(effect_data effect){
	effect.Title = "Slow Weapon Fire";
	effect.Duration = 30;
	effect.AddFlag("firerate");
}

INIT(){
	HookEvent("weapon_fire", Chaos_SlowFire_WeaponFire);
}

public void Chaos_SlowFire_WeaponFire(Event event, char[] name, bool dbc){
	if(SlowFire){
	    RequestFrame(SetSlowFire, event.GetInt("userid"));
	}
}

public void SetSlowFire(int userid){
	FirePostFrame(userid, 0.4);
}

START(){
	SlowFire = true;
}

RESET(bool HasTimerEnded){
	SlowFire = false;
}