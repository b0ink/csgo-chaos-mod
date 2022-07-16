bool g_bDiscoFog = false;
Handle g_DiscoFog_Timer_Repeat = INVALID_HANDLE;

public void Chaos_DiscoFog_START(){
	DiscoFog();
	g_bDiscoFog = true;
	g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);
}

public Action Chaos_DiscoFog_RESET(bool HasTimerEnded){
	StopTimer(g_DiscoFog_Timer_Repeat);
	g_bDiscoFog = false;
	Fog_OFF();
}

public Action Chaos_DiscoFog_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_DiscoFog_HasNoDuration(){
	return false;
}

public bool Chaos_DiscoFog_Conditions(){
	return true;
}

public Action Timer_NewFogColor(Handle timer){
	if(g_bDiscoFog){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(g_iFog, "fogcolor", color);
	}else{
		StopTimer(g_DiscoFog_Timer_Repeat);
	}
}
