#pragma semicolon 1

public void Chaos_Shields(EffectData effect) {
	effect.Title = "Shields";
	effect.HasNoDuration = true;
	effect.RunForwardWhileInactive("OnPlayerRunCmd");
}

public void Chaos_Shields_START() {
	char playerWeapon[62];
	LoopAlivePlayers(i) {
		GetClientWeapon(i, playerWeapon, sizeof(playerWeapon));
		int entity = CreateEntityByName("weapon_shield");
		if(entity > 0) {
			DispatchSpawn(entity);
			EquipPlayerWeapon(i, entity);
			DispatchKeyValue(entity, "CanBePickedUp", "1");

			SetEntPropEnt(i, Prop_Data, "m_hActiveWeapon", entity);
			if(StrContains(playerWeapon, "knife", false) != -1) {
				SwitchToKnife(i);
				InstantSwitch(i, -1);
			} else {
				FakeClientCommand(i, "use %s", playerWeapon);
				InstantSwitch(i, -1);
			}
		}
	}
}

public void Chaos_Shields_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed, int mouse[2]) {
	if(!ValidAndAlive(client)) return;

	if(buttons & IN_USE) {
		int ent = GetClientAimTarget(client, false);
		if(IsValidEntity(ent) && ent > 0) {
			int owner = GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity");
			if(ValidAndAlive(owner)) {
				return;
			}

			float pos[3];
			GetEntPropVector(ent, Prop_Data, "m_vecOrigin", pos);
			float clientPos[3];
			GetClientAbsOrigin(client, clientPos);
			
			if(GetVectorDistance(pos, clientPos) > 200) {
				return;
			}

			char classname[64];
			if(GetEdictClassname(ent, classname, sizeof(classname))) {
				if(StrEqual(classname, "weapon_shield")) {
					EquipPlayerWeapon(client, ent);
				}
			}
		}
	}
}