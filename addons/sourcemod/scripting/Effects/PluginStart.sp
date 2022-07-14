

/*
	Any Required
*/
public void Chaos_OnPluginStart(){
	HookEvents();
}



/*
	ADD ALL YOUR REQUIRED HOOKED EVENTS HERE.

	This on runs on 'OnPluginStart'
*/
public void HookEvents(){
	HookEvent("weapon_fire", 		Chaos_OneBulletOneGun_Event_OnWeaponFire);
	HookEvent("weapon_fire", 		Chaos_InfiniteAmmo_Event_OnWeaponFire);
	HookEvent("weapon_fire", 		Chaos_OneBulletMag_Event_OnWeaponFire);
	HookEvent("weapon_fire", 		Chaos_PortalGuns_Event_OnWeaponFire); //, EventHookMode_Post);

	HookEventEx("weapon_fire", 		Chaos_Aimbot_Event_WeaponFire, EventHookMode_Pre);
	HookEventEx("player_blind", 	Chaos_Aimbot_Event_PlayerBlind, EventHookMode_Pre);
	
	HookEvent("bomb_planted", 		Chaos_C4Chicken_Event_BombPlanted);

	HookEvent("bullet_impact", 		Chaos_ExplosiveBullets_Event_BulletImpact);
	AddTempEntHook("Shotgun Shot", 	Chaos_ExplosiveBullets_Hook_BulletShot);

	
}