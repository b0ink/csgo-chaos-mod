#define EFFECTNAME Spin180

SETUP(effect_data effect){
	effect.Title = "180 Spin";
	effect.HasNoDuration = true;
}

START(){
	float angs[3];
	LoopAlivePlayers(i){
		GetClientEyeAngles(i, angs);
		angs[1] = angs[1] + 180;
		TeleportEntity(i, NULL_VECTOR, angs, NULL_VECTOR);
	}
}