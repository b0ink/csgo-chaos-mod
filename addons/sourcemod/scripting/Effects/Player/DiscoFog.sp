bool g_bDiscoFog = false;
Handle g_DiscoFog_Timer_Repeat = INVALID_HANDLE;

SETUP(effect_data effect){
	effect.Title = "Disco Fog";
	effect.Duration = 30;
	effect.AddFlag("fog");
}

START(){
	DiscoFog();
	g_bDiscoFog = true;
	g_DiscoFog_Timer_Repeat = CreateTimer(1.0, Timer_NewFogColor, _,TIMER_REPEAT);
}

RESET(bool HasTimerEnded){
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
}
