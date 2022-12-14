SETUP(effect_data effect){
	effect.Title = "Insane Gravity";
	effect.Duration = 30;
}

START(){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 15.0);
	}
}

RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 1.0);
	}
}

public void Chaos_InsaneGravity_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntityGravity(client, 15.0);
	}
}