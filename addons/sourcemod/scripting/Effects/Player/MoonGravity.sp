#pragma semicolon 1

public void Chaos_MoonGravity(effect_data effect){
	effect.Title = "Low Gravity";
	effect.Duration = 30;
	effect.AddAlias("LowGravity");
}

public void Chaos_MoonGravity_START(){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 0.3);
	}
}

public void Chaos_MoonGravity_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 1.0);
	}
}

public void Chaos_MoonGravity_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntityGravity(client, 0.3);
	}
}