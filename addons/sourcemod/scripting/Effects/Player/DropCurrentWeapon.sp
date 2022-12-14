SETUP(effect_data effect){
	effect.Title = "Drop Current Weapon";
	effect.HasNoDuration = true;
	effect.AddFlag("dropweapon");
}

START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "drop");
	}
}