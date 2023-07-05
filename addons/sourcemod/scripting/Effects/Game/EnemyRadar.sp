#pragma semicolon 1

public void Chaos_EnemyRadar(EffectData effect){
	effect.Title = "Enemy Radar";
	effect.Duration = 30;
	effect.BlockInCoopStrike = true;
}
public void Chaos_EnemyRadar_START(){
	cvar("mp_radar_showall", "1");
}

public void Chaos_EnemyRadar_RESET(int ResetType){
	if(ResetType & RESET_EXPIRED){
		ResetCvar("mp_radar_showall", "0", "1");
	}
}