public void Chaos_DropCurrentWeapon(effect_data effect){
	effect.HasNoDuration = true;
}

public void Chaos_DropCurrentWeapon_START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
	}
}