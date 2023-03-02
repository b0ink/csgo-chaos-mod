public void Chaos_ExpensiveAmmo(EffectData effect){
	effect.Title = "Expensive Ammo";
	effect.Duration = 30;
}

bool ExpensiveAmmo = false;
public void Chaos_ExpensiveAmmo_INIT(){
	HookEvent("weapon_fire", Chaos_ExpensiveAmmo_Event_WeaponFire);
}

public void Chaos_ExpensiveAmmo_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(!ValidAndAlive(client)) return;
	if(ExpensiveAmmo){
		SetClientMoney(client, -50);
	}
}

public void Chaos_ExpensiveAmmo_START(){
	ExpensiveAmmo = true;
}

public void Chaos_ExpensiveAmmo_RESET(int ResetType){
	ExpensiveAmmo = false;
}