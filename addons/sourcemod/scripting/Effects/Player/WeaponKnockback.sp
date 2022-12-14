bool WeaponKnockback = false;

SETUP(effect_data effect){
	effect.Title = "Weapon Knockback";
	effect.Duration = 30;
	effect.AddAlias("Push");
}

START(){
	WeaponKnockback = true;
}

RESET(bool HasTimerEnded){
	WeaponKnockback = false;
}

INIT(){
	HookEvent("weapon_fire", Chaos_WeaponKnockback_Event_OnWeaponFire);
}

public void  Chaos_WeaponKnockback_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(WeaponKnockback){
		DoKnockback(client, 250.0);
	}
}