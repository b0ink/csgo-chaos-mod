bool SlowFire = false;

public void Chaos_SlowFire(effect_data effect){
	effect.Title = "Slow Weapon Fire";
	effect.Duration = 30;
	effect.AddFlag("firerate");
}

public void Chaos_SlowFire_INIT(){
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

public void Chaos_SlowFire_START(){
	SlowFire = true;
}

public Action Chaos_SlowFire_RESET(bool HasTimerEnded){
	SlowFire = false;
}