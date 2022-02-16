Handle EffectHud_Name = INVALID_HANDLE;
Handle EffectHud_Time = INVALID_HANDLE;
Handle EffectHud_NoDuration = INVALID_HANDLE;

int g_HudTime = -1;
void HUD_INIT(){
	EffectHud_Name = 		CreateArray(256);
	EffectHud_Time = 		CreateArray(1);
	EffectHud_NoDuration = 	CreateArray(1);
}

void HUD_ROUNDEND(){
	ClearArray(EffectHud_Name);
	ClearArray(EffectHud_Time);
	ClearArray(EffectHud_NoDuration);
}

//15 seconds for all times with -1 (healthshots, etc.)

void AddEffectToHud(char[] message, float time = -1.0){
	PushArrayString(EffectHud_Name, message);
	if(time == -1.0){
		PushArrayCell(EffectHud_NoDuration, 1);
		PushArrayCell(EffectHud_Time, 20);	
	}else{
		PushArrayCell(EffectHud_NoDuration, 0);
		PushArrayCell(EffectHud_Time, RoundToFloor(time));	
	}
	PrintTimer(g_HudTime);
}

void PrintEffects(){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i) && !g_HideHud[i]){
			char chunk[2048];
			int EffectTime = -1;
			char EffectName[256];
			for(int effect = 0; effect < GetArraySize(EffectHud_Name); effect++){
				GetArrayString(EffectHud_Name, effect, EffectName, sizeof(EffectName));
				EffectTime = GetArrayCell(EffectHud_Time, effect);
				int originalTime = EffectTime;
				int noDuration = GetArrayCell(EffectHud_NoDuration, effect);
				if(EffectTime > 20) EffectTime = 20;
				Format(chunk, sizeof(chunk), "%s\n%s ", chunk, EffectName);
				int blocks = EffectTime / 3;
				if(noDuration == 0){
					if(originalTime > 120){
						Format(chunk, sizeof(chunk), "%s ∞", chunk);
					}else{
						for(int g = 1; g <= blocks; g++){
							Format(chunk, sizeof(chunk), "%s▓", chunk);
						}
					}
				}
			}
			//.37 y;
			SetHudTextParams(0.01, 0.42, 1.0, 37, 186, 255, 0, 0, 1.0, 0.0, 0.0);
			ShowHudText(i, GetDynamicChannel(1), "%s", chunk);
		}
	}
	bool removedAny = false;
	while(!removedAny){
		removedAny = false;
		for(int i = 0; i < GetArraySize(EffectHud_Name); i++){
			int EffectTime = GetArrayCell(EffectHud_Time, i);
			if(EffectTime < 2 && !removedAny){
				RemoveFromArray(EffectHud_Name, i);
				RemoveFromArray(EffectHud_Time, i);
				RemoveFromArray(EffectHud_NoDuration, i);
				removedAny = true;
				break;
			}
		}
		if(!removedAny) break;
	}
}



void PrintTimer(int time){
	for(int i = 0; i <= MaxClients; i++){
		if(IsValidClient(i)){
			SetHudTextParams(-1.0, 0.06, 1.0, 200, 0, 220, 0, 0, 1.0, 0.0, 0.0);
			ShowHudText(i, GetDynamicChannel(0), "%i", time);
		}
	}
}

Action Timer_DisplayEffects(Handle timer){
	for(int i = 0; i < GetArraySize(EffectHud_Name); i++){
		SetArrayCell(EffectHud_Time, i, GetArrayCell(EffectHud_Time, i) - 1);
	}
	PrintEffects();
}

Action Timer_Display(Handle timer = null, int time){
	g_HudTime = time;
	PrintTimer(time);
	if(time > 1 && g_bChaos_Enabled && g_bCanSpawnEffect) CreateTimer(1.0, Timer_Display, time - 1);
}