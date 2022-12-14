SETUP(effect_data effect){
	effect.Title = "Earthquake";
	effect.HasNoDuration = true;
}

float g_Earthquake_Duration = 7.0;
START(){
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
}
