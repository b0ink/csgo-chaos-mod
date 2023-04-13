#pragma semicolon 1

public void Chaos_DropCurrentWeapon(EffectData effect){
	effect.Title = "Drop Current Weapon";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
}

public void Chaos_DropCurrentWeapon_START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
		ClientCommand(i, "playgamesound \"weapons/knife/knife_slash2.wav\"");
	}
}