public Action Hook_WeaponSwitch(int client, int weapon){
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_Hook_WeaponSwitch", Chaos_EffectData_Buffer.config_name);
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

	return Plugin_Changed;
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
	return Plugin_Changed;
} 

public Action Hook_OnPreThink(int client){
	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_Hook_OnPreThink", Chaos_EffectData_Buffer.config_name);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		Action return_type;
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(client); 
			Call_Finish();
			if(return_type != Plugin_Continue) return return_type;
		}
	}

	return Plugin_Changed;
}



//allow players to take damage during noclip
public Action Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype) {

	if(g_NoFallDamage > 0 && damagetype == DMG_FALL){
		damage = 0.0;
		return Plugin_Changed;
	}

	LoopAllEffects(Chaos_EffectData_Buffer, index){
		Format(Chaos_EventName_Buffer, sizeof(Chaos_EventName_Buffer), "%s_Hook_OnTakeDamage", Chaos_EffectData_Buffer.config_name);
		Function func = GetFunctionByName(GetMyHandle(), Chaos_EventName_Buffer);
		Action return_type;
		if(func != INVALID_FUNCTION){
			Call_StartFunction(GetMyHandle(), func);
			Call_PushCell(victim); 
			Call_PushCellRef(attacker);
			Call_PushCellRef(inflictor);
			Call_PushFloatRef(damage);
			Call_PushCellRef(damagetype);
			Call_Finish();
			if(return_type != Plugin_Continue) return return_type;
		}
	}

	return Plugin_Changed;
}