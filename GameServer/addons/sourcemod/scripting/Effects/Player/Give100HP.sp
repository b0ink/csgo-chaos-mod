#define EFFECTNAME Give100HP

SETUP(effect_data effect){
	effect.Title = "Give all players +100 HP";
	effect.Duration = 30;
	effect.HasNoDuration = true;
}

START(){
	LoopAlivePlayers(i){
		int currenthealth = GetClientHealth(i);
		SetEntityHealth(i, currenthealth + 100);
	}
}