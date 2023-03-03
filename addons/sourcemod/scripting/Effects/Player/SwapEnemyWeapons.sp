public void Chaos_SwapEnemyWeapons(EffectData effect){
	effect.Title = "Swap Weapons With Enemy Team";
	effect.HasNoDuration = true;
	effect.IncompatibleWith("Chaos_TaserParty");
}

public void Chaos_SwapEnemyWeapons_START(){
	ArrayList playerIndex_T = new ArrayList();
	ArrayList playerIndex_CT = new ArrayList();
	LoopAlivePlayers(i){
		if(GetClientTeam(i) == CS_TEAM_T){
				playerIndex_T.Push(i);
		}else{
			playerIndex_CT.Push(i);
		}
	}

	for(int i = 0; i < playerIndex_T.Length; i++){
		// PrintToChatAll("id: %i team: %i", playerIndex.Get(i), GetClientTeam(playerIndex.Get(i)));
		int client = playerIndex_T.Get(i);
		int target = playerIndex_CT.Get(i);
		
		ArrayList clientWeapons = new ArrayList();
		ArrayList targetWeapons = new ArrayList();

		char classname[64];
		for (int g; g <  GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons"); g++){
			int item = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", g);
			if (item == -1) continue;

			if(GetEdictClassname(item, classname, 64)){
				if(StrContains(classname, "knife") != -1) continue;
				if(StrContains(classname, "c4") != -1) continue;
				if(StrContains(classname, "fist") != -1) continue;
			}
			CS_DropWeapon(client, item, false, true);

			clientWeapons.Push(item);
		}

		for (int g; g < GetEntPropArraySize(target, Prop_Send, "m_hMyWeapons"); g++){
			int item = GetEntPropEnt(target, Prop_Send, "m_hMyWeapons", g);
			if (item == -1) continue;
			
			if(GetEdictClassname(item, classname, 64)){
				if(StrContains(classname, "knife") != -1) continue;
				if(StrContains(classname, "c4") != -1) continue;
				if(StrContains(classname, "fist") != -1) continue;
			}
			
			CS_DropWeapon(target, item, false, true);
			targetWeapons.Push(item);
		}

		for(int g = 0; g < clientWeapons.Length; g++){
			int weapon = clientWeapons.Get(g);
			if(IsValidEntity(weapon)){
				EquipPlayerWeapon(target, weapon);
			}
		}
		SwitchToPrimaryWeapon(target);

		for(int g = 0; g < targetWeapons.Length; g++){
			int weapon = targetWeapons.Get(g);
			if(IsValidEntity(weapon)){
				EquipPlayerWeapon(client, weapon);
			}
		}
		SwitchToPrimaryWeapon(client);


		delete clientWeapons;
		delete targetWeapons;
	}
	delete playerIndex_T;
	delete playerIndex_CT;
}

public bool Chaos_SwapEnemyWeapons_Conditions(){
	if(GetAliveCTCount() == GetAliveTCount()){
		return true;
	}
	return false;
}