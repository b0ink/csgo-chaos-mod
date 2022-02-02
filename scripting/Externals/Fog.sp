float mapFogStart = 0.0;
float mapFogEnd = 0.0;
// float mapFogEnd = 175.0;
float mapFogDensity = 0.995;
void findLight(){
	int ent;
	ent = FindEntityByClassname(-1, "env_fog_controller");
	if (ent != -1) {
		g_iFog = ent;
		DispatchKeyValue(g_iFog, "fogblend", "0");
		DispatchKeyValue(g_iFog, "fogcolor", "255 255 255");
		// DispatchKeyValue(g_iFog, "fogcolor", "255 0 0");
		DispatchKeyValue(g_iFog, "fogcolor2", "0 0 0");
		DispatchKeyValueFloat(g_iFog, "fogstart", mapFogStart);
		DispatchKeyValueFloat(g_iFog, "fogend", mapFogEnd);
		DispatchKeyValueFloat(g_iFog, "fogmaxdensity", mapFogDensity);
		AcceptEntityInput(g_iFog, "TurnOff");
    }
	else{
        g_iFog = CreateEntityByName("env_fog_controller");
        DispatchSpawn(g_iFog);
    }
}

void Fog_ON(){
	AcceptEntityInput(g_iFog, "TurnOn");
}

void Fog_OFF(){
	AcceptEntityInput(g_iFog, "TurnOff");
}

void ExtremeWhiteFog(){
	DispatchKeyValue(g_iFog, "fogcolor", "255 255 255");
	DispatchKeyValueFloat(g_iFog, "fogend", 400.0);
	DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 1.0);
	DispatchKeyValueFloat(g_iFog, "farz", -1.0);
	Fog_ON();
}
void NormalWhiteFog(){
	DispatchKeyValue(g_iFog, "fogcolor", "255 255 255");
	DispatchKeyValueFloat(g_iFog, "fogend", 800.0);
	DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.8);
	DispatchKeyValueFloat(g_iFog, "farz", -1.0);
	Fog_ON();
}

void ResetRenderDistance(){
	DispatchKeyValueFloat(g_iFog, "farz", -1.0);
}

void LowRenderDistance(){
	DispatchKeyValueFloat(g_iFog, "farz", 450.0);
}

void DiscoFog(){
	char color[32];
	FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
	DispatchKeyValue(g_iFog, "fogcolor", color);
	// DispatchKeyValue(g_iFog, "fogcolor", "255 255 255");
	DispatchKeyValueFloat(g_iFog, "fogend", 800.0);
	DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.92);
	// DispatchKeyValueFloat(g_iFog, "farz", -1.0);
	Fog_ON();
}

void Mexico(){
	DispatchKeyValue(g_iFog, "fogcolor", "138 86 22");
	DispatchKeyValueFloat(g_iFog, "fogend", 0.0);
	// DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.9989);
	// DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.75);
	DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.85);
	Fog_ON();
}

void LightsOff(){
	DispatchKeyValue(g_iFog, "fogcolor", "0 0 0");
	DispatchKeyValueFloat(g_iFog, "fogend", 0.0);
	DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.9989);
	// DispatchKeyValueFloat(g_iFog, "fogmaxdensity", 0.998);
	DispatchKeyValueFloat(g_iFog, "farz", -1.0);
	Fog_ON();
}