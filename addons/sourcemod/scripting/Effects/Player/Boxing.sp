char BoxingBellSfx[] = "ambient/misc/brass_bell_e.wav"

public void Chaos_Boxing(effect_data effect){
	effect.Title = "Boxing";
	effect.Duration = 30;

	effect.IncompatibleWith("Chaos_KnifeFight");
	effect.IncompatibleWith("Chaos_AlienKnifeFight");
}


public void Chaos_Boxing_OnMapStart(){
	PrecacheSound(BoxingBellSfx, true);
}

public void Chaos_Boxing_START(){
	LoopAlivePlayers(i){
		int knife = GetPlayerWeaponSlot(i, CS_SLOT_KNIFE);
		if(IsValidEntity(knife)){
			RemovePlayerItem(i, knife);
		}

		int fists = CreateEntityByName("weapon_fists");
		DispatchSpawn(fists);
		EquipPlayerWeapon(i, fists);
		FakeClientCommand(i, "use weapon_fists");

		SDKUnhook(i, SDKHook_WeaponSwitch, Boxing_BlockGuns);
		SDKHook(i, SDKHook_WeaponSwitch, Boxing_BlockGuns);
	}

	CreateTimer(0.2, Boxing_PlaySound, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.4, Boxing_PlaySound, _, TIMER_FLAG_NO_MAPCHANGE);
	CreateTimer(0.6, Boxing_PlaySound, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Boxing_BlockGuns(int client, int weapon) {
	char WeaponName[32];
	GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
	if(
		StrContains(WeaponName, "fists") == -1 &&
		StrContains(WeaponName, "c4") == -1
		){
			FakeClientCommand(client, "use weapon_fists");
			return Plugin_Handled;
	}

	return Plugin_Continue;
}

public void Chaos_Boxing_RESET(bool HasTimerEnded){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_WeaponSwitch, Boxing_BlockGuns);
	}

	if(HasTimerEnded){
		char classname[64];
		LoopAlivePlayers(i){
			int fists = GetPlayerWeaponSlot(i, CS_SLOT_KNIFE);
			if(IsValidEntity(fists) && GetEdictClassname(fists, classname, 64)){
				if(StrContains(classname, "fists") != -1){
					RemovePlayerItem(i, fists);
				}
			}
			int knife = GetPlayerWeaponSlot(i, CS_SLOT_KNIFE);
			if(!IsValidEntity(knife) || (GetEdictClassname(knife, classname, 64) && StrContains(classname, "knife") == -1)){
				GivePlayerItem(i, "weapon_knife");
				FakeClientCommand(i, "use weapon_knife");
			}
		}
	}
}

Action Boxing_PlaySound(Handle timer){
	LoopAlivePlayers(i){
		EmitSoundToClient(i, BoxingBellSfx, _, _, SNDLEVEL_RAIDSIREN, _, 0.7);
	}
	return Plugin_Stop;
}