public void Chaos_Shields_START(){
	char playerWeapon[62];
	for(int i = 0; i <= MaxClients; i++){
		if(ValidAndAlive(i)){
			GetClientWeapon(i, playerWeapon, sizeof(playerWeapon));
			int entity = CreateEntityByName("weapon_shield");
			if (entity > 0) {
				EquipPlayerWeapon(i, entity);
				SetEntPropEnt(i, Prop_Data, "m_hActiveWeapon" , entity);
				if(StrContains(playerWeapon, "knife", false) != -1){
					FakeClientCommand(i, "use weapon_knife");
					InstantSwitch(i, -1);
				}else{
					FakeClientCommand(i, "use %s", playerWeapon);
					InstantSwitch(i, -1);
				}
			}
		}
	}
}

public Action Chaos_Shields_RESET(bool EndChaos){

}

public Action Chaos_Shields_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_Shields_HasNoDuration(){
	return false;
}

public bool Chaos_Shields_Conditions(){
	return true;
}