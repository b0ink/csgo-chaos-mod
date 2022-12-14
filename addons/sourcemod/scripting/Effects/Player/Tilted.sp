SETUP(effect_data effect){
	effect.Title = "Tilted";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_LockPlayersAim");
}

float tiltedAngle = 30.0;
START(){
	float angles[3];

	if(GetURandomInt() % 2 == 0){
		tiltedAngle = -30.0;
	}else{
		tiltedAngle = 30.0;
	}

	LoopAlivePlayers(i){
		GetClientEyeAngles(i, angles);
		angles[2] = tiltedAngle;
		TeleportEntity(i, NULL_VECTOR, angles, NULL_VECTOR);
	}
}

RESET(bool HasTimerEnded){
	float angles[3];
	LoopAlivePlayers(i){
		GetClientEyeAngles(i, angles);
		angles[2] = 0.0;
		TeleportEntity(i, NULL_VECTOR, angles, NULL_VECTOR);
	}
}

public void Chaos_Tilted_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		float angles[3];
		GetClientEyeAngles(client, angles);
		angles[2] = tiltedAngle;
		TeleportEntity(client, NULL_VECTOR, angles, NULL_VECTOR);
	}
}