#pragma semicolon 1

public void Chaos_QuakeFOV(effect_data effect){
	effect.Title = "Quake FOV";
	effect.Duration = 45;
}

int QuakeFov;

public void Chaos_QuakeFOV_START(){
	QuakeFov = GetRandomInt(140,160);
	LoopAlivePlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", QuakeFov);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", QuakeFov);
	}
}

public void Chaos_QuakeFOV_RESET(bool HasTimerEnded){
	LoopValidPlayers(i){
		SetEntProp(i, Prop_Send, "m_iFOV", 0);
		SetEntProp(i, Prop_Send, "m_iDefaultFOV", 90);
	}
}

public void Chaos_QuakeFOV_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntProp(client, Prop_Send, "m_iFOV", QuakeFov);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", QuakeFov);
	}
}