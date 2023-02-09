#pragma semicolon 1

public void Chaos_Spin180(EffectData effect){
	effect.Title = "180 Spin";
	effect.HasNoDuration = true;
}

public void Chaos_Spin180_START(){
	float angs[3];
	LoopAlivePlayers(i){
		GetClientEyeAngles(i, angs);
		angs[1] = angs[1] + 180;
		TeleportEntity(i, NULL_VECTOR, angs, NULL_VECTOR);
	}
}