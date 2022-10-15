public void Chaos_MoonGravity(effect_data effect){
	effect.title = "Low Gravity";
	effect.duration = 30;
	effect.AddAlias("LowGravity");
}

public void Chaos_MoonGravity_START(){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 0.3);
	}
}

public Action Chaos_MoonGravity_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 1.0);
	}
}