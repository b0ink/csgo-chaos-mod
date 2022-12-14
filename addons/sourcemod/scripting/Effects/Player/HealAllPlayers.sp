SETUP(effect_data effect){
	effect.Title = "Heal All Players";
	effect.HasNoDuration = true;
}

START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, 100);
	}
}