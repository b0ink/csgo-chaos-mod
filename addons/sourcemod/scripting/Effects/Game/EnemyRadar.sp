#pragma semicolon 1

public void Chaos_EnemyRadar(effect_data effect){
	effect.Title = "Enemy Radar";
	effect.Duration = 30;
}
public void Chaos_EnemyRadar_START(){
	cvar("mp_radar_showall", "1");
}

public void Chaos_EnemyRadar_RESET(int ResetType){
	ResetCvar("mp_radar_showall", "0", "1");
}