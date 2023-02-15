#pragma semicolon 1

public void Chaos_DropPrimaryWeapon(EffectData effect){
	effect.Title = "Drop Primary Weapon";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
}

public void Chaos_DropPrimaryWeapon_START(){
	LoopAlivePlayers(i){
		if(!HasMenuOpen(i)){
			ClientCommand(i, "slot2;slot1");
		}
	}
	CreateTimer(0.1, Timer_DropPrimary);
}

Action Timer_DropPrimary(Handle timer){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
	}
	return Plugin_Continue;
}