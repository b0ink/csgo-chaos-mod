bool IncreasedNadeDamage = false;
SETUP(effect_data effect){
	effect.Title = "Increased Nade Damage";
	effect.Duration = 30;
	effect.AddAlias("Grenade");
}


START(){
	IncreasedNadeDamage = true;
}


RESET(bool HasTimerEnded){
	IncreasedNadeDamage = false;
}


public void Chaos_IncreasedNadeDamage_OnEntityCreated(int ent, const char[] classname){
	if(!IncreasedNadeDamage) return;

	if(StrEqual(classname, "hegrenade_projectile")){
		SDKHook(ent, SDKHook_SpawnPost, Chaos_IncreasedNadeDamage_OnGrenadeSpawn);
	}
}


public void Chaos_IncreasedNadeDamage_OnGrenadeSpawn(int grenade){
	CreateTimer(0.01, Timer_ChangeGrenadeDamage, grenade, TIMER_FLAG_NO_MAPCHANGE);
}


public Action Timer_ChangeGrenadeDamage(Handle timer, int grenade){
	float flGrenadePower = GetEntPropFloat(grenade, Prop_Send, "m_flDamage");
	float flGrenadeRadius = GetEntPropFloat(grenade, Prop_Send, "m_DmgRadius");
	
	SetEntPropFloat(grenade, Prop_Send, "m_flDamage", (flGrenadePower*1.4)); // 1.3 default
	SetEntPropFloat(grenade, Prop_Send, "m_DmgRadius", (flGrenadeRadius*3.0)); // 2.5 default
}