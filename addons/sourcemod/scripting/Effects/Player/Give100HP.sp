#pragma semicolon 1

public void Chaos_Give100HP(effect_data effect){
	effect.Title = "Give all players +100 HP";
	effect.Duration = 30;
	effect.HasNoDuration = true;
}

public void Chaos_Give100HP_START(){
	LoopAlivePlayers(i){
		int currenthealth = GetClientHealth(i);
		SetEntityHealth(i, currenthealth + 100);
	}
}