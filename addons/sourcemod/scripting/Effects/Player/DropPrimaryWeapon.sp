SETUP(effect_data effect){
	effect.Title = "Drop Primary Weapon";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
}

START(){
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