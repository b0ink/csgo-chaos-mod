#define EFFECTNAME RevealEnemyLocation

SETUP(effect_data effect){
	effect.Title = "Reveal Enemy Location";
	effect.HasNoDuration = true;
}

START(){
	ConVar radar = FindConVar("mp_radar_showall");

	if(radar.IntValue == 0){
		cvar("mp_radar_showall", "1");
		CreateTimer(0.2, Timer_ResetRadar); //use already made timer;
	}
}

public Action Timer_ResetRadar(Handle timer){
	cvar("mp_radar_showall", "0");
}

// CONDITIONS(){
// 	return true;
// }