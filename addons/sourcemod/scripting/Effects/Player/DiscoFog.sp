#pragma semicolon 1

bool g_bDiscoFog = false;
Handle g_DiscoFog_Timer_Repeat = INVALID_HANDLE;

public void Chaos_DiscoFog(EffectData effect){
	effect.Title = "Disco Fog";
	effect.Duration = 30;
	effect.AddFlag("fog");
}

public void Chaos_DiscoFog_START(){
	DiscoFog();
	g_bDiscoFog = true;
	g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);
}

public void Chaos_DiscoFog_RESET(int ResetType){
	StopTimer(g_DiscoFog_Timer_Repeat);
	g_bDiscoFog = false;
	DiscoFog(true);
	// Fog_OFF();
}

public Action Timer_NewFogColor(Handle timer){
	if(g_bDiscoFog){
		char color[32];
		FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
		DispatchKeyValue(g_iFog, "fogcolor", color);
	}else{
		StopTimer(g_DiscoFog_Timer_Repeat);
	}
	return Plugin_Continue;
}
