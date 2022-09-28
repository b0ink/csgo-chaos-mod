int 	g_iFog = -1;



float mapFogStart = 0.0;
float mapFogEnd = 800.0;
// float mapFogEnd = 175.0;
float mapFogDensity = 0.995;

enum struct fog_data{
	char effectName[64];

	char blend[32];
	char color[32];
	char color2[32];

	char start[32];
	char end[32];
	char maxdensity[32];
	char farz[32];
	void SetDefault(){

	}
	// void SetDefault(){
	// 	this.fogblend = "0";
	// 	this.fogcolor = "255 255 255";
	// 	this.fogcolor2 = "0 0 0";
	// 	this.fogstart = 0.0;
	// 	this.fogend = 800.0;
	// 	this.fogmaxdensity = 0.5;
	// 	this.farz = -1.0;
	// }
}

ArrayList Fog_Stream;


// Fires on round end
void ClearFog(){
	Fog_Stream.Clear();
	UpdateFog();
}

void RemoveFog(char[] effectName, bool allInstances = false){
	fog_data fog;
	for(int i = 0; i < Fog_Stream.Length; i++){
		Fog_Stream.GetArray(i, fog, sizeof(fog));
		if(StrEqual(fog.effectName, effectName, false)){
			Fog_Stream.Erase(i);
			if(allInstances){
				RemoveFog(effectName, true);
			}
			break;
		}
	}
	UpdateFog();
}

void UpdateFog(){
	fog_data fog;
	if(Fog_Stream.Length > 0){
		Fog_Stream.GetArray(Fog_Stream.Length - 1, fog, sizeof(fog)); // Start from most recently added fog
		if(fog.blend[0]) 		DispatchKeyValue(g_iFog, "fogblend", fog.blend);
		if(fog.color[0]) 		DispatchKeyValue(g_iFog, "fogcolor", fog.color);
		if(fog.color2[0]) 		DispatchKeyValue(g_iFog, "fogcolor2", fog.color2);
		if(fog.start[0]) 		DispatchKeyValue(g_iFog, "fogstart", fog.start);
		if(fog.end[0]) 			DispatchKeyValue(g_iFog, "fogend", fog.end);
		if(fog.maxdensity[0]) 	DispatchKeyValue(g_iFog, "fogmaxdensity", fog.maxdensity);
		if(fog.farz[0]) 		DispatchKeyValue(g_iFog, "farz", fog.farz);
		// DispatchKeyValueFloat(g_iFog, "fogstart", fog.start);
		// DispatchKeyValueFloat(g_iFog, "fogend", fog.end);
		// DispatchKeyValueFloat(g_iFog, "fogmaxdensity", fog.maxdensity);
		// DispatchKeyValueFloat(g_iFog, "farz", fog.farz);
		Fog_ON();
	}else{
		Fog_OFF();
	}
		
}

void Find_Fog(){

	if(Fog_Stream == INVALID_HANDLE){
		Fog_Stream = new ArrayList(sizeof(fog_data));
	}else{
		Fog_Stream.Clear();
	}

	int ent = -1;
	if(
		StrEqual(mapName, "cs_office", false) ||
		StrEqual(mapName, "de_vertigo", false) ||
		StrEqual(mapName, "de_cache", false)
	){
		int index = -1;
		while ((index = FindEntityByClassname(index, "env_fog_controller")) != -1){
			RemoveEntity(index);
		}
		ent = CreateEntityByName("env_fog_controller");
		DispatchSpawn(ent);

	}else{
		ent = FindEntityByClassname(ent, "env_fog_controller");
		if(ent == -1){
			ent = CreateEntityByName("env_fog_controller");
		}
	}
	
	if (ent != -1) {
		g_iFog = ent;
		DispatchKeyValue(g_iFog, "Origin", "0 0 0");
		DispatchKeyValue(g_iFog, "fogblend", "0");
		DispatchKeyValue(g_iFog, "fogcolor", "255 255 255");
		// DispatchKeyValue(g_iFog, "fogcolor", "255 0 0");
		DispatchKeyValue(g_iFog, "fogcolor2", "0 0 0");
		DispatchKeyValueFloat(g_iFog, "fogstart", mapFogStart);
		DispatchKeyValueFloat(g_iFog, "fogend", mapFogEnd);
		DispatchKeyValueFloat(g_iFog, "fogmaxdensity", mapFogDensity);
		AcceptEntityInput(g_iFog, "TurnOff");
    }
}


void Fog_ON(){
	AcceptEntityInput(g_iFog, "TurnOn");
}

void Fog_OFF(){
	AcceptEntityInput(g_iFog, "TurnOff");
}

void ExtremeWhiteFog(bool removeFog = false){
	if(removeFog){
		RemoveFog("ExtremeWhiteFog");
		return;
	}
	fog_data fog;
	fog.effectName = "ExtremeWhiteFog";
	fog.SetDefault();
	fog.color = "255 255 255";
	fog.end = "400.0";
	fog.maxdensity = "1.0";

	Fog_Stream.PushArray(fog, sizeof(fog));
	UpdateFog();
}
void NormalWhiteFog(bool removeFog = false){
	if(removeFog){
		RemoveFog("NormalWhiteFog");
		return;
	}
	fog_data fog;
	fog.effectName = "NormalWhiteFog";
	fog.SetDefault();
	fog.color = "255 255 255";
	fog.end = "800.0";
	fog.maxdensity = "0.8";

	Fog_Stream.PushArray(fog, sizeof(fog));
	UpdateFog();
}

void MinimalFog(bool removeFog = false){
	if(removeFog){
		RemoveFog("MinimalFog");
		return;
	}
	fog_data fog;
	fog.effectName = "MinimalFog";
	fog.SetDefault();
	fog.color = "255 255 255";
	fog.end = "900.0";
	fog.maxdensity = "0.5";

	Fog_Stream.PushArray(fog, sizeof(fog));
	UpdateFog();

}

void ResetRenderDistance(){
	DispatchKeyValueFloat(g_iFog, "farz", -1.0);
}

void LowRenderDistance(){
	DispatchKeyValueFloat(g_iFog, "farz", 250.0);
}

void DiscoFog(bool removeFog = false){
	if(removeFog){
		RemoveFog("DiscoFog", true);
		return;
	}

	char color[32];
	FormatEx(color, sizeof(color), "%i %i %i", GetRandomInt(0,255), GetRandomInt(0,255), GetRandomInt(0,255));
	
	fog_data fog;
	fog.effectName = "DiscoFog";
	fog.SetDefault();
	fog.color = color;
	fog.end = "800.0";
	fog.maxdensity = "0.92";

	Fog_Stream.PushArray(fog, sizeof(fog));
	UpdateFog();
}

void Mexico(bool removeFog = false){
	if(removeFog){
		RemoveFog("Mexico");
		return;
	}

	fog_data fog;
	fog.effectName = "Mexico";
	fog.SetDefault();
	fog.color = "138 86 22";
	fog.end = "0.0";
	fog.maxdensity = "0.75";

	Fog_Stream.PushArray(fog, sizeof(fog));
	UpdateFog();
}

void LightsOff(bool removeFog = false){
	if(removeFog){
		RemoveFog("LightsOff");
		return;
	}

	fog_data fog;
	fog.effectName = "LightsOff";
	fog.SetDefault();
	fog.color = "0 0 0";
	fog.end = "0.0";
	fog.maxdensity = "0.99";

	Fog_Stream.PushArray(fog, sizeof(fog));
	UpdateFog();

	Fog_ON();
}