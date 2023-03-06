#pragma semicolon 1

public void Chaos_HighMouseSens(EffectData effect){
	effect.Title = "High Mouse Sens";
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_LockPlayersAim");
}

public void Chaos_HighMouseSens_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	if(mouse[0] != 0 || mouse[1] != 0){
		float newAngles[3];
		newAngles = angles;
		newAngles[0] += (mouse[1] * 1.5);
		newAngles[1] -= (mouse[0] * 1.5);
		TeleportEntity(client, NULL_VECTOR, newAngles, NULL_VECTOR);
	}
}