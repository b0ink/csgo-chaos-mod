#pragma semicolon 1

public void Chaos_DropCurrentWeapon(effect_data effect){
	effect.Title = "Drop Current Weapon";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
}

public void Chaos_DropCurrentWeapon_START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
	}
}