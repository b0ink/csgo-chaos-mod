#pragma semicolon 1

public void Chaos_Give100HP(EffectData effect){
	effect.Title = "Give all players +100 HP";
	effect.HasNoDuration = true;
}

public void Chaos_Give100HP_START(){
	LoopAlivePlayers(i){
		SetEntityHealth(i, GetClientHealth(i) + 100);
	}
}

public bool Chaos_Give100HP_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		if(GetRoundTime() < 15) return false;
	}
	return true;
}