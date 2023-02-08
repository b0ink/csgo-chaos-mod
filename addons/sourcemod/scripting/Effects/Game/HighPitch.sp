/*
	Thankyou! https://github.com/Mikusch
*/

bool HighPitch = false;
public void Chaos_HighPitch(effect_data effect){
	effect.Title = "High Pitch";
	effect.Duration = 30;
	effect.AddFlag("pitch");
}


public void Chaos_HighPitch_INIT(){
	AddNormalSoundHook(Chaos_HighPitch_NormalSoundHook);
	AddAmbientSoundHook(Chaos_HighPitch_AmbientSoundHook);
}


public void Chaos_HighPitch_START(){
	HighPitch = true;
}


public void Chaos_HighPitch_RESET(bool HasTimerEnded){
	HighPitch = false;
}


Action Chaos_HighPitch_NormalSoundHook(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags, char soundEntry[PLATFORM_MAX_PATH], int &seed){
	if(!HighPitch) return Plugin_Continue;
	pitch = 150;
	return Plugin_Changed;
}


Action Chaos_HighPitch_AmbientSoundHook(char sample[PLATFORM_MAX_PATH], int& entity, float& volume, int& level, int& pitch, float pos[3], int& flags, float& delay){
	if(!HighPitch) return Plugin_Continue;
	pitch = 150;
	return Plugin_Changed;
}