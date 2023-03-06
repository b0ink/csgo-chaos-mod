#pragma semicolon 1

public void Chaos_CrabPeople(EffectData effect){
	effect.Title = "Crabs";
	effect.Duration = 30;
}

public void Chaos_CrabPeople_OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &iSubType, int &cmdnum, int &tickcount, int &seed, int mouse[2]){
	buttons |= IN_DUCK;
}