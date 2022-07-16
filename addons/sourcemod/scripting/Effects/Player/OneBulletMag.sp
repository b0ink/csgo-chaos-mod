//weapon fire
bool g_bOneBulletMag = false;
int g_iOffset_Clip1 = -1;
public void Chaos_OneBulletMag_INIT(){
	g_iOffset_Clip1 = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");

}

public void Chaos_OneBulletMag_Event_OnWeaponFire(Event event, const char[] name, bool dontBroadcast){
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(g_bOneBulletMag){
		if(ValidAndAlive(client)){
			for (int j = 0; j < 2; j++){
				int iTempWeapon = -1;
				if ((iTempWeapon = GetPlayerWeaponSlot(client, j)) != -1) SetClip(iTempWeapon, 1, 1);
			}
		}
	}
}
	//One bullet magazine handler


public void Chaos_OneBulletMag_START(){
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			for (int j = 0; j < 2; j++){
				int iTempWeapon = -1;
				if ((iTempWeapon = GetPlayerWeaponSlot(i, j)) != -1) SetClip(iTempWeapon, 1, 1);
			}
		}
	}
	g_bOneBulletMag = true;
}

public Action Chaos_OneBulletMag_RESET(bool HasTimerEnded){
	g_bOneBulletMag = false;
	if(HasTimerEnded){ //don't need to do this if the round has ended, especially if the event didnt even happen
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				char currentWeapon[64];
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
}

public bool Chaos_OneBulletMag_HasNoDuration(){
	return false;
}

public bool Chaos_OneBulletMag_Conditions(){
	return true;
}

stock void SetClip(int weaponid,int ammosize, int clipsize) {
	SetEntData(weaponid, g_iOffset_Clip1, ammosize);
	if(clipsize >= 0){
		SetEntProp(weaponid, Prop_Send, "m_iPrimaryReserveAmmoCount", clipsize);
	}
}
