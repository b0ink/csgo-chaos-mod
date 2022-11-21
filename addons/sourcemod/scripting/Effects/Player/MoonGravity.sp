public void Chaos_MoonGravity(effect_data effect){
	effect.Title = "Low Gravity";
	effect.Duration = 30;
	effect.AddAlias("LowGravity");
}

//TODO: Re-apply effect when player respawns

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





