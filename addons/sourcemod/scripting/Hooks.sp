public Action Hook_WeaponSwitch(int client, int weapon){
	
	for(int i = 0; i < alleffects.Length; i++){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_Hook_WeaponSwitch", Chaos_EffectData_Buffer.config_name);
		alleffects.GetArray(i, Chaos_EffectData_Buffer, sizeof(Chaos_EffectData_Buffer));
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		Action return_type;
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(client); 
			Call_PushCell(weapon);
			Call_Finish(return_type);
			if(return_type != Plugin_Continue) return return_type;
		}
	}

	return Plugin_Continue;
}

//DISABLE WEAPON DROP DURING RANDOM WEAPON EVENT
public Action Hook_WeaponDrop(int client,int weapon){
	if(weapon != -1 && IsValidEntity(weapon)){
		if(!g_bPlayersCanDropWeapon){
			char WeaponName[32];
			GetEdictClassname(weapon, WeaponName, sizeof(WeaponName));
			if(StrContains(WeaponName, "c4") == -1){ //allow c4 drops
				return Plugin_Handled; 
			}
		}
	}
	return Plugin_Continue;
} 

//NoScope
public Action Hook_OnPreThink(int client){
	// int iWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	// SetNoScope(iWeapon);
	
	for(int i = 0; i < alleffects.Length; i++){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_Hook_OnPreThink", Chaos_EffectData_Buffer.config_name);
		alleffects.GetArray(i, Chaos_EffectData_Buffer, sizeof(Chaos_EffectData_Buffer));
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		Action return_type;
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(client); 
			Call_Finish();
			if(return_type != Plugin_Continue) return return_type;
		}
	}
	return Plugin_Continue;
}



//allow players to take damage during noclip
public Action Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) {

	if(g_NoFallDamage > 0 && damagetype == DMG_FALL){
		damage = 0.0;
		return Plugin_Changed;
	}

	for(int i = 0; i < alleffects.Length; i++){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_Hook_OnTakeDamage", Chaos_EffectData_Buffer.config_name);
		alleffects.GetArray(i, Chaos_EffectData_Buffer, sizeof(Chaos_EffectData_Buffer));
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		Action return_type;
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(victim); 
			Call_PushCellRef(attacker);
			Call_PushCellRef(inflictor);
			Call_PushCellRef(damage);
			Call_PushCellRef(damagetype);
			Call_Finish();
			if(return_type != Plugin_Continue) return return_type;
		}
	}

	return Plugin_Continue;
}
public Action Hook_OnTakeDamagePost(int victim, int attacker){

}

public void Hook_PreThinkPost(int client){
	
}