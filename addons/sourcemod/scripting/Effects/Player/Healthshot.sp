public void Chaos_Healthshot_START(){
	int amount = GetRandomInt(1,3);
	LoopAlivePlayers(i){
			for(int j = 1; j <= amount; j++){
			GivePlayerItem(i, "weapon_healthshot");
		}
	}
}

public Action Chaos_Healthshot_RESET(bool HasTimerEnded){

}


public bool Chaos_Healthshot_HasNoDuration(){
	return true;
}

public bool Chaos_Healthshot_Conditions(){
	return true;
}