#pragma semicolon 1

public void Chaos_DropAllWeapons(EffectData effect){
	effect.Title = "Drop All Weapons";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
	effect.IncompatibleWith("Chaos_KnifeFight");
}

public void Chaos_DropAllWeapons_START(){
	LoopAlivePlayers(client){
		float timer = 0.0;
		
		int size = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
		for (int i; i < size; i++){
			int item = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", i);
			if (item == -1) continue;
			DataPack pack = new DataPack();
			pack.WriteCell(client);
			pack.WriteCell(item);
			CreateTimer(timer, Timer_DropWeaponIndex, pack);
			timer += 0.1;
		}
	}
}

Action Timer_DropWeaponIndex(Handle timer, DataPack pack){
	pack.Reset();
	int client = pack.ReadCell();
	int weapon = pack.ReadCell();
	if(ValidAndAlive(client) && IsValidEntity(weapon)){
		char weaponName[64];
		GetEdictClassname(weapon, weaponName, 64);
		if(StrContains(weaponName, "knife") == -1 && StrContains(weaponName, "knife") == -1){
			CS_DropWeapon(client, weapon, true, true);
			ClientCommand(client, "playgamesound \"weapons/knife/knife_slash2.wav\"");
		}
	}
	delete pack;
	return Plugin_Stop;
}