#pragma semicolon 1

bool 	g_bDynamicChannelsEnabled = false;

bool  HideTimer[MAXPLAYERS+1];
bool  HideEffectList[MAXPLAYERS+1];
bool  HideAnnouncement[MAXPLAYERS+1];

bool  UseTimerBar[MAXPLAYERS+1] = {true, ...};
bool  UseHtmlHud[MAXPLAYERS+1];

ArrayList HudData;

enum struct EffectHudData{
	char name[256];
	int time;
	bool HasNoDuration;
	bool IsMetaEffect;

	bool isMeta(){
		return this.IsMetaEffect;
	}
} 


int g_HudTime = -1;
void HUD_INIT(){
	HudData = new ArrayList(sizeof(EffectHudData));
}


void HUD_ROUNDEND(){
	HudData.Clear();
}


bool g_HideHud[MAXPLAYERS+1] = {false, ...};

void ResetHud(){
	LoopValidPlayers(i){
		g_HideHud[i] = false;
	}
}
//15 seconds for all times with -1 (healthshots, etc.)

void AddEffectToHud(char[] message, float time = -1.0, bool isMeta){
	EffectHudData effect;
	Format(effect.name, sizeof(effect.name), "%s", message);

	if(time == -1.0){
		effect.HasNoDuration = true;
		effect.time = 20;
	}else{
		effect.HasNoDuration = false;
		effect.time = RoundToFloor(time);
	}
	effect.IsMetaEffect = isMeta;
	HudData.PushArray(effect);
	PrintTimer(g_HudTime);
}

void RemoveHudByName(char[] EffectName){
	EffectHudData effect;
	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		if(StrEqual(effect.name, EffectName, false)){
			HudData.Erase(i);
			break;
		}
	}
	PrintTimer(g_HudTime);
}

void PrintEffects(){
	char chunk[2048];
	char chunk_meta[2048];
	int EffectTime = -1;

	EffectHudData effect;

	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		EffectTime = effect.time;
		int originalTime = EffectTime;
		if(EffectTime > 20) EffectTime = 20;
		int blocks = EffectTime / 3;

		if(effect.isMeta()){
			Format(chunk, sizeof(chunk), "%s\n", chunk);
			Format(chunk_meta, sizeof(chunk), "%s\n%s ", chunk_meta, effect.name);

			// * Assume meta always has duration (120s), ignore check
			for(int g = 1; g <= blocks; g++){
				Format(chunk_meta, sizeof(chunk_meta), "%s▓", chunk_meta);
				// Format(chunk, sizeof(chunk), "%s▌", chunk);
				// Format(chunk, sizeof(chunk), "%s▪", chunk);
				// Format(chunk, sizeof(chunk), "%s⧯", chunk);
			}
		}else{
			if(Meta_IsWhatsHappeningEnabled()) continue;
			
			Format(chunk_meta, sizeof(chunk_meta), "%s\n", chunk_meta);

			Format(chunk, sizeof(chunk), "%s\n%s ", chunk, effect.name);


			if(!effect.HasNoDuration){
				if(originalTime > 120){
					Format(chunk, sizeof(chunk), "%s ∞", chunk);
				}else{
					for(int g = 1; g <= blocks; g++){
						Format(chunk, sizeof(chunk), "%s▓", chunk);
						// Format(chunk, sizeof(chunk), "%s▌", chunk);
						// Format(chunk, sizeof(chunk), "%s▪", chunk);
						// Format(chunk, sizeof(chunk), "%s⧯", chunk);
					}
				}
			}
		}

	}

	LoopValidPlayers(i){
		if(HasMenuOpen(i)) continue;
		if(HideEffectList[i]) continue;
		//.37 y;
		// SetHudTextParams(0.01, 0.42, 1.5, 37, 186, 255, 0, 0, 1.0, 0.0, 0.0);
		SetHudTextParams(g_ChaosEffectList_Position[0], g_ChaosEffectList_Position[1], 1.5, 
			g_ChaosEffectList_Color[0],
			g_ChaosEffectList_Color[1],
			g_ChaosEffectList_Color[2],
			g_ChaosEffectList_Color[3], 0, 1.0, 0.0, 0.0);

		if(g_bDynamicChannelsEnabled){
			ShowHudText(i, GetDynamicChannel(1), "%s", chunk);
		}else{
			ShowHudText(i, -1, "%s", chunk);
		}




		SetHudTextParams(g_ChaosEffectList_Position[0], g_ChaosEffectList_Position[1], 1.5, 252, 227, 0, 0, 0, 1.0, 0.0, 0.0);
		if(g_bDynamicChannelsEnabled){
			ShowHudText(i, GetDynamicChannel(2), "%s", chunk_meta);
		}else{
			ShowHudText(i, -1, "%s", chunk);
		}
	}


	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		EffectTime = effect.time;
		if(EffectTime <= 1){
			HudData.Erase(i);
			i--;
		}
	}
}

void ClearEffectList(int client){
	if(g_bDynamicChannelsEnabled){
		ShowHudText(client, GetDynamicChannel(2), "");
		ShowHudText(client, GetDynamicChannel(1), "");
	}else{
		ShowHudText(client, -1, "");
	}
}



void PrintTimer(int time){
	if(time <= 3){
		SetHudTextParams(g_ChaosEffectTimer_Position[0], g_ChaosEffectTimer_Position[1], 1.1, 200, 0, 0, 0, 0, 1.0, 0.0, 0.0);
		// if(time > 0) EmitSoundToClient(i, "ui/beep07.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.4);
	}else{
		SetHudTextParams(g_ChaosEffectTimer_Position[0], g_ChaosEffectTimer_Position[1], 1.1,
			g_ChaosEffectTimer_Color[0],
			g_ChaosEffectTimer_Color[1],
			g_ChaosEffectTimer_Color[2],
			g_ChaosEffectTimer_Color[3], 0, 1.0, 0.0, 0.0);
	}

	char text[128];
	int interval = g_ChaosEffectInterval;
	// //TODO: ratio works but only if its less than 30 -> either 5head fix it or just flash the bar to show its counting?

	float blocksPerSecond = 1.0 / (interval / 30.0);

	for(int i = 1; i <= 30; i++){
		if(i <= time * blocksPerSecond && time > 0){
			Format(text, 128, "%s▓", text);
		}else{
			Format(text, 128, "%s▒", text);
		}
	}

	LoopValidPlayers(i){
		if(IsFakeClient(i)) continue;
		if(HideTimer[i]) continue;

		if(time >= 0){
			if(g_bDynamicChannelsEnabled){
				if(UseTimerBar[i]){
					ShowHudText(i, GetDynamicChannel(3), text);	
				}else{
					ShowHudText(i, GetDynamicChannel(3), "New effect in:\n%i", time);	
				}
			}else{
				ShowHudText(i, -1, "New effect in:\n%i", time);	
			}
		}else{
			// if(g_bDynamicChannelsEnabled){
			// 	// ShowHudText(i, GetDynamicChannel(3), "");	
			// }else{
			// 	ShowHudText(i, -1, "");	
			// }
		}
	}
}

void PrintHTML(char[] message){
	Event newevent_message = CreateEvent("cs_win_panel_round");
	char htmlMsg[1024];
	FormatEx(htmlMsg, sizeof(htmlMsg), "<b><font size='15' color='#1BD508'>%s</font></b>", RemoveMulticolors(message));
	newevent_message.SetString("funfact_token", htmlMsg);

	LoopValidPlayers(i){
		if(!IsFakeClient(i) && UseHtmlHud[i]){
			newevent_message.FireToClient(i);
		}
	}
	newevent_message.Cancel(); 

	CreateTimer(3.9, Timer_ClearHTML); // 3.9 to allow a safe 1 second buffer if the effect interval is 5.0 seconds
}

Action Timer_ClearHTML(Handle timer){
	Event newevent_message = CreateEvent("cs_win_panel_round");
	newevent_message.SetString("funfact_token", "");
	
	LoopValidPlayers(i){
		if(!IsFakeClient(i)){
			newevent_message.FireToClient(i);
		}
	}
									
	newevent_message.Cancel(); 
	return Plugin_Continue;
}

Action Timer_DisplayEffects(Handle timer){
	EffectHudData effect;
	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		effect.time = effect.time - 1;
		HudData.SetArray(i, effect, sizeof(effect));
	}
	PrintEffects();
	return Plugin_Continue;
}


Action Timer_Display(Handle timer = null, int time){
	g_HudTime = time;
	PrintTimer(time);
	if(time > 0 && g_cvChaosEnabled.BoolValue && CanSpawnNewEffect()) CreateTimer(1.0, Timer_Display, time - 1);
	return Plugin_Continue;
}


void DisplayCenterTextToAll(char[] message){
	char finalMess[256];
	Format(finalMess, sizeof(finalMess), "%s", RemoveMulticolors(message));

	LoopValidPlayers(i){
		if(HideAnnouncement[i]) continue;
		
		if(IsPlayerAlive(i)){
			SetHudTextParams(-1.0, 0.8, 3.0, 255, 255, 255, 0, 0, 1.0, 0.5, 0.5);
		}else{
			SetHudTextParams(-1.0, 0.75, 3.0, 255, 255, 255, 0, 0, 1.0, 0.5, 0.5);
		}
		if(g_bDynamicChannelsEnabled){
			ShowHudText(i, GetDynamicChannel(0), "%s", finalMess);
		}else{
			ShowHudText(i, -1, "%s", finalMess);
			// PrintCenterText(i, "%s", finalMess);
		}
	}

}
