bool OneBulletMag = false;
int g_iOffset_Clip1 = -1;

public void Chaos_OneBulletMag(effect_data effect){
	effect.Title = "One Bullet Mags";
	effect.Duration = 30;
	effect.AddFlag("ammo");
}

public void Chaos_OneBulletMag_INIT(){
	g_iOffset_Clip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");
	HookEvent("weapon_fire", 		Chaos_OneBulletMag_Event_OnWeaponFire);
}

void SetClipsTo1(int client){
	for (int j = 0; j < 2; j++){
		int iTempWeapon = -1;
		if ((iTempWeapon = GetPlayerWeaponSlot(client, j)) != -1) SetClip(iTempWeapon, 1, 1);
	}
}

public void Chaos_OneBulletMag_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(OneBulletMag){
		if(ValidAndAlive(client)){
			SetClipsTo1(client);
		}
	}
}

public void Chaos_OneBulletMag_START(){
	LoopAlivePlayers(i){
		SetClipsTo1(i);
	}
	OneBulletMag = true;
}

public void Chaos_OneBulletMag_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		CreateTimer(0.5, Timer_StripMags, client);
	}
}

public Action Timer_StripMags(Handle timer, int client){
	if(!ValidAndAlive(client)) return;
	SetClipsTo1(client);
}

public Action Chaos_OneBulletMag_RESET(bool HasTimerEnded){
	OneBulletMag = false;
	if(HasTimerEnded){ //don't need to do this if the round has ended, especially if the event didnt even happen
		char currentWeapon[64];
		LoopAlivePlayers(i){
			GetClientWeapon(i, currentWeapon, sizeof(currentWeapon));
			int wepID = -1;
			for(int slot = 0; slot < 2; slot++){ //pistol and primary are the only ones i care about
				if((wepID = GetPlayerWeaponSlot(i, slot)) != -1){
					char ClientWeaponName[64];
					GetWeaponClassname(wepID, ClientWeaponName, 64);
					if(IsValidEntity(wepID)){
						RemovePlayerItem(i, wepID);
						GivePlayerItem(i, ClientWeaponName);
					} 
				}
			}
			FakeClientCommand(i, "use %s", currentWeapon); //swap back to original weapon	
		}

	}
}

stock void SetClip(int weaponid,int ammosize, int clipsize) {
	SetEntData(weaponid, g_iOffset_Clip1, ammosize);
	if(clipsize >= 0){
		SetEntProp(weaponid, Prop_Send, "m_iPrimaryReserveAmmoCount", clipsize);
	}
}
