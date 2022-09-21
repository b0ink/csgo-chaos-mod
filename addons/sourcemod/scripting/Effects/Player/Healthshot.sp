public void Chaos_Healthshot(effect_data effect){
	effect.title = "Healthshot";
	effect.HasNoDuration = true;
}

public void Chaos_Healthshot_START(){
	int amount = GetRandomInt(1,3);
	LoopAlivePlayers(i){
			for(int j = 1; j <= amount; j++){
			GivePlayerItem(i, "weapon_healthshot");
		}
	}
}