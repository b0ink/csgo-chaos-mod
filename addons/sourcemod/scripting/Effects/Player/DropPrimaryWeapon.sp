public void Chaos_DropPimaryWeapon(effect_data effect){
	effect.title = "Drop Primary Weapon";
	effect.HasNoDuration = true;
}

public void Chaos_DropPrimaryWeapon_START(){
	LoopAlivePlayers(i){
		if(!HasMenuOpen(i)){
			ClientCommand(i, "slot2;slot1");
		}
	}
	CreateTimer(0.1, Timer_DropPrimary);
}

public Action Timer_DropPrimary(Handle timer){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
	}
}