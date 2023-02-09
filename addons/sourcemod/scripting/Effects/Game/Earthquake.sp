#pragma semicolon 1

public void Chaos_Earthquake(EffectData effect){
	effect.Title = "Earthquake";
	effect.HasNoDuration = true;
}

float g_Earthquake_Duration = 7.0;
public void Chaos_Earthquake_START(){
	LoopAlivePlayers(i){
		ScreenShake(i, _, g_Earthquake_Duration);
	}
}

stock int ScreenShake(int iClient, float fAmplitude = 50.0, float duration = 7.0){
	Handle hMessage = StartMessageOne("Shake", iClient, 1);
	
	PbSetInt(hMessage, "command", 0);
	PbSetFloat(hMessage, "local_amplitude", fAmplitude);
	PbSetFloat(hMessage, "frequency", 255.0);
	PbSetFloat(hMessage, "duration", duration);
	
	EndMessage();
	return 0;
}
