#pragma semicolon 1

public void Chaos_InsaneGravity(effect_data effect){
	effect.Title = "Insane Gravity";
	effect.Duration = 30;
}

public void Chaos_InsaneGravity_START(){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 8.0);
	}
}

public void Chaos_InsaneGravity_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 1.0);
	}
}

public void Chaos_InsaneGravity_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntityGravity(client, 15.0);
	}
}