SETUP(effect_data effect){
	effect.Title = "Healthshot";
	effect.HasNoDuration = true;
}

START(){
	int amount = GetRandomInt(1,3);
	LoopAlivePlayers(i){
			for(int j = 1; j <= amount; j++){
			GivePlayerItem(i, "weapon_healthshot");
		}
	}
}