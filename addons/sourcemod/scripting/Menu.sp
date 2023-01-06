void ShowMenu_Main(int client){
	if(!IsValidClient(client)) return;
	Menu menu = new Menu(Main_Handler);

	menu.SetTitle("CS:GO Chaos Mod"); //?
	int style = ITEMDRAW_DISABLED;

	if(CheckCommandAccess(client, "sm_slay", ADMFLAG_CHAT)){
		style = ITEMDRAW_DEFAULT;
	}

	if(g_cvChaosEnabled.BoolValue){
		if(g_NewEffect_Timer == INVALID_HANDLE){
			menu.AddItem("start-chaos-timer", "Start Timer", style);
		}
		menu.AddItem("toggle-chaos", "Disable Chaos", style);
	}else{
		menu.AddItem("toggle-chaos", "Enable Chaos", style);
	}
	if(g_bCanSpawnEffect && g_cvChaosEnabled.BoolValue){
		menu.AddItem("new-effect", "Spawn New Effect", style);
	}else{
		menu.AddItem("new-effect", "Spawn New Effect", ITEMDRAW_DISABLED);
	}


	menu.AddItem("help", "Help");
	// menu.AddItem("credits", "Credits");
	menu.AddItem("settings", "Settings");

	menu.ExitButton = true;
	//no back button
	menu.Display(client, 0);
}

void ToggleChaos(int client = -1){
	if(g_cvChaosEnabled.BoolValue){
		Command_StopChaos(client, 0);
	}else{
		Command_StartChaos(client, 0);
	}
}

public int Main_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			if(StrEqual(info, "new-effect", false)){
				ShowMenu_Effects(param1, true);
			}else if(StrEqual(info, "toggle-chaos", false)){
				ToggleChaos(param1);
			}else if(StrEqual(info, "credits", false)){
				
			}else if(StrEqual(info, "help", false)){
				CPrintToChat(param1, "{default}[{lime}CHAOS{default}] Visit {orange}https://csgochaosmod.com {default}for help with this plugin.");
			}else if(StrEqual(info, "settings")){
				ShowMenu_Settings(param1);
			}else if(StrEqual(info, "start-chaos-timer")){
				Command_StartChaos(param1, 0);
			}
		}
	}else if (action == MenuAction_Cancel){
		//main menu
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void ShowMenu_Effects(int client, bool AllowRandom = false){
	if(!IsValidClient(client)) return;

	Menu menu = new Menu(Effect_Selection);
	menu.SetTitle("Select Chaos Effect");

	char function_title[64];
	if(AllowRandom) menu.AddItem("", "Random Effect"); //KEEP ID BLANK

	if(AllowRandom) PoolChaosEffects();
	
	effect_data effect;
	for(int i = 0; i < PossibleChaosEffects.Length; i++){ //should contain all 102 all time
		PossibleChaosEffects.GetArray(i, effect, sizeof(effect));
		Format(function_title, sizeof(function_title), "%s", GetChaosTitle(effect.FunctionName));
		if(effect.CanRunEffect()){
			menu.AddItem(effect.FunctionName, function_title);
		}else{
			menu.AddItem(effect.FunctionName, function_title, ITEMDRAW_DISABLED);
		}
	}
	
	menu.ExitButton = true;
	if(AllowRandom) menu.ExitBackButton = true; 
	menu.Display(client, 0);

	SetHudTextParams(0.01, 0.42, 0.1, 37, 186, 255, 0, 0, 1.0, 0.0, 0.0);
	if(g_bDynamicChannelsEnabled){
		ShowHudText(client, GetDynamicChannel(1), "");
	}else{
		ShowHudText(client, -1, "");
	}

}


public int Effect_Selection(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			g_sSelectedChaosEffect = info;
			if(g_sSelectedChaosEffect[0] != '\0'){
				if(g_bCanSpawnEffect && g_cvChaosEnabled.BoolValue){
					Format(g_sForceCustomEffect, sizeof(g_sForceCustomEffect), "%s", g_sSelectedChaosEffect);
					ChooseEffect(null, true);
				}else{
					ReplyToCommand(param1, "[Chaos] Sorry, no effects can be spawned in right now.");
					if(!g_cvChaosEnabled.BoolValue){
						ReplyToCommand(param1, "[Chaos] Use !startchaos to re-enable Chaos.");
					}
				}
			}else{
				ChooseEffect(null, true);
			}

		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_Main(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}



void ShowMenu_Settings(int client){
	if(!IsValidClient(client)) return;

	int style = ITEMDRAW_DISABLED;

	if(CheckCommandAccess(client, "sm_slay", ADMFLAG_CHAT)){
		style = ITEMDRAW_DEFAULT;
	}

	Menu menu = new Menu(Settings_Handler);
	menu.SetTitle("Chaos Settings");	
	menu.AddItem("edit-effects", "Edit Effects", style); // "Select an effect you'd like to edit" (list of ALL effects);
	menu.AddItem("edit-convars", "Edit ConVars", style);
	menu.AddItem("edit-effect-volume", "Adjust Bell SFX Volume");
	menu.AddItem("edit-hud", "HUD");

	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int Settings_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			if(StrEqual(info, "edit-effects", false)){
				ShowMenu_EditAllEffects(param1);
			}else if(StrEqual(info, "edit-convars", false)){
				ShowMenu_EditConvars(param1);
			}else if(StrEqual(info, "edit-effect-volume", false)){
				ShowMenu_EditEffectVolume(param1);
			}else if(StrEqual(info, "edit-hud", false)){
				ShowMenu_HudSettings(param1);
			}
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_Main(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}
void ShowMenu_HudSettings(int client){
	if(!IsValidClient(client)) return;
	
	Menu menu = new Menu(HudSettings_Handler);
	menu.SetTitle("Toggle HUD Elements");
	// char currentVolume[128];
	// FormatEx(currentVolume, sizeof(currentVolume), "Adjust the volume of the bell sound when a new effect spawns:\nCurrent Volume: %i%%", RoundToZero(BellVolume[client] * 100.0));
	// menu.AddItem("-", currentVolume, ITEMDRAW_DISABLED);

	char TimerInfo[32];
	char EffectListInfo[32];
	char EffectAnnouncement[32];
	char UseHtmlHudInfo[32];

	FormatEx(TimerInfo, sizeof(TimerInfo), "Hide Timer: [%s]", HideTimer[client] ? "YES" : "NO");
	FormatEx(EffectListInfo, sizeof(EffectListInfo), "Hide Effect List: [%s]", HideEffectList[client] ? "YES" : "NO");
	FormatEx(EffectAnnouncement, sizeof(EffectAnnouncement), "Hide Announcement: [%s]", HideAnnouncement[client] ? "YES" : "NO");
	FormatEx(UseHtmlHudInfo, sizeof(UseHtmlHudInfo), "Alternate Announcement: [%s]", UseHtmlHud[client] ? "YES" : "NO");
	menu.AddItem("toggle-timer", TimerInfo);
	menu.AddItem("toggle-effectlist", EffectListInfo);
	menu.AddItem("toggle-effectannounce", EffectAnnouncement);
	menu.AddItem("toggle-usehtmlhud", UseHtmlHudInfo);
	menu.AddItem("alternate-hud-info", "Resolutions larger than 1080p will scale the HUD incorrectly.", ITEMDRAW_DISABLED);
	menu.AddItem("alternate-hud-info", "Use Alternate Announcement if you have this issue. Or start CS:GO at 1080p.", ITEMDRAW_DISABLED);
	// menu.AddItem("alternate-hud-info", "Starting CS:GO with a 1080p resolution will fix this issue.", ITEMDRAW_DISABLED);

	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int HudSettings_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			if(StrEqual(info, "toggle-timer", false)){
				HideTimer[param1] = !HideTimer[param1];
			}else if(StrEqual(info, "toggle-effectlist", false)){
				HideEffectList[param1] = !HideEffectList[param1];
			}else if(StrEqual(info, "toggle-effectannounce", false)){
				HideAnnouncement[param1] = !HideAnnouncement[param1];
			}else if(StrEqual(info, "toggle-usehtmlhud", false)){
				UseHtmlHud[param1] = !UseHtmlHud[param1];
			}
		}
		ShowMenu_HudSettings(param1);
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_Settings(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}



void ShowMenu_EditEffectVolume(int client){
	if(!IsValidClient(client)) return;
	
	Menu menu = new Menu(EditEffectVolume_Handler);
	menu.SetTitle("New Effect SFX Volume");
	char currentVolume[128];
	FormatEx(currentVolume, sizeof(currentVolume), "Adjust the volume of the bell sound when a new effect spawns:\nCurrent Volume: %i%%", RoundToZero(BellVolume[client] * 100.0));
	menu.AddItem("-", currentVolume, ITEMDRAW_DISABLED);

	char displayText[32];
	char infoText[32];
	for(int i = 0; i < 11; i++){
		Format(infoText, sizeof(infoText), "%i", i);
		Format(displayText, sizeof(displayText), "%i%%", i*10);
		float volumeCheck = float(i) / 10;
		if(volumeCheck == BellVolume[client]){
			Format(displayText, sizeof(displayText), "%s <", displayText);
			menu.AddItem(infoText, displayText, ITEMDRAW_DISABLED);
		}else{
			menu.AddItem(infoText, displayText);
		}
	}
	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int EditEffectVolume_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			float volume = StringToFloat(info) / 10;
			BellVolume[param1] = volume;
			EmitSoundToClient(param1, SOUND_BELL, _, _, SNDLEVEL_RAIDSIREN, _, BellVolume[param1]);
		}
		ShowMenu_EditEffectVolume(param1);
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_Settings(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void ShowMenu_EditConvars(int client){
	Menu menu = new Menu(EditConvars_Handler);
	menu.SetTitle("Select a ConVar to edit.");

	char ItemTitle[64];
	FormatEx(ItemTitle, sizeof(ItemTitle), "sm_chaos_enabled: %s", g_cvChaosEnabled.FloatValue ? "YES" : "NO");
	menu.AddItem("sm_chaos_enabled", ItemTitle);

	FormatEx(ItemTitle, sizeof(ItemTitle), "sm_chaos_interval: %.2f", g_cvChaosEffectInterval.FloatValue);
	menu.AddItem("sm_chaos_interval", ItemTitle);

	FormatEx(ItemTitle, sizeof(ItemTitle), "sm_chaos_repeating: %s", g_cvChaosRepeating.FloatValue ? "YES" : "NO");
	menu.AddItem("sm_chaos_repeating", ItemTitle);

	char override_customtext[32];
	if(g_cvChaosOverrideDuration.FloatValue == -1.0){
		override_customtext = "DISABLED";
	}else if(g_cvChaosOverrideDuration.FloatValue == 0.0){
		override_customtext = "LAST ALL ROUND";
	}else{
		FormatEx(override_customtext, 32, "All effects last %.2f Seconds", g_cvChaosOverrideDuration.FloatValue);
	}
	FormatEx(ItemTitle, sizeof(ItemTitle), "sm_chaos_override_duration: %s", override_customtext);
	menu.AddItem("sm_chaos_override_duration", ItemTitle);


	#if defined TWITCH_ENABLED
		float twitchEnabled = 0.0;
		if(g_cvChaosTwitchEnabled.BoolValue){
			twitchEnabled = 1.0;
		}

		FormatEx(ItemTitle, sizeof(ItemTitle), "sm_chaos_twitch_enabled: %s", twitchEnabled ? "YES" : "NO");
		menu.AddItem("sm_chaos_twitch_enabled", ItemTitle);
	#endif


	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

void ShowMenu_ConvarIncrements(int client, char[] convar){
	Menu menu = new Menu(ConvarIncrements_Handler);
	char title[64];

	FormatEx(title, sizeof(title), "Edit value for %s", convar);

	menu.SetTitle(title);

	ConVar editing_convar = FindConVar(convar); 

	float max_bound;
	GetConVarBounds(editing_convar, ConVarBound_Upper, max_bound);

	float min_bound;
	GetConVarBounds(editing_convar, ConVarBound_Lower, min_bound);

	menu.AddItem(convar,"convar_name" , ITEMDRAW_NOTEXT);

	bool showSeconds = false;
	float current_value = editing_convar.FloatValue;
	if(StrEqual(convar, "sm_chaos_override_duration", false)){
		showSeconds = true;
		Format(title, sizeof(title), "Current Value: %.2f\nSets the duration of ALL effects.\n", current_value);
	}else if(StrEqual(convar, "sm_chaos_repeating", false)){
		Format(title, sizeof(title), "Current Value: %.2f\nIf set to 0, only one effect will be spawned per round.\n", current_value);
	}else if(StrEqual(convar, "sm_chaos_interval", false)){
		showSeconds = true;
		Format(title, sizeof(title), "Current Value: %.2f\nHow often a new effect is spawned.\n", current_value);
	}else if(StrEqual(convar, "sm_chaos_twitch_enabled", false)){
		Format(title, sizeof(title), "Current Value: %.2f\nEnable twitch voting", current_value);
	}else{
		showSeconds = true;
		Format(title, sizeof(title), "Current Value: %.2f", current_value);
	}
	menu.AddItem(title, title, ITEMDRAW_DISABLED);
	
	char item_name[64];
	for(float i = min_bound; i <= max_bound; i++){
		Format(item_name, sizeof(item_name), "%.2f%s", i, showSeconds ? " Seconds": "");
		menu.AddItem(item_name, item_name);
	}
	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}
public int ConvarIncrements_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			char explodes[2][64];
			ExplodeString(info, " ", explodes, sizeof(explodes), sizeof(explodes[]));
			// PrintToChatAll("%s -- %s", explodes[0], explodes[1]);
			float seconds = StringToFloat(explodes[0]);
			char convar_name[64];
			GetMenuItem(menu, 0, convar_name, sizeof(convar_name));
			// PrintToChatAll("seconds is %f convar is %s", seconds, convar_name); 

			ConVar convar_editing = FindConVar(convar_name);

			//Rather than correctly editing the KV - the convar is set, then the config is rewritten based off new convars
			convar_editing.FloatValue = seconds;
			char newValue[64];
			FloatToString(seconds, newValue, sizeof(newValue));
			Update_Convar_Config();
			UpdateCvars();
			// Update_Settings(convar_name, newValue);

			ShowMenu_ConvarIncrements(param1, convar_name);
			PrintToChatAll("[Chaos] ConVar '%s' has been changed to %.2f", convar_name, seconds);
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_EditConvars(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void ToggleCvar(char[] cvar){
	ConVar ToChange = FindConVar(cvar);
	ToChange.IntValue = 1 - ToChange.IntValue;
	PrintToChatAll("[Chaos] ConVar '%s' has been changed to %.2f", cvar, ToChange.FloatValue);
	Update_Convar_Config();
}

public int EditConvars_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			if(StrEqual(info, "sm_chaos_enabled", false) || StrEqual(info, "sm_chaos_repeating", false)){
				ToggleCvar(info);
				ShowMenu_EditConvars(param1);
			}else{
				ShowMenu_ConvarIncrements(param1, info);
			}
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_Settings(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}


void ShowMenu_EditAllEffects(int client){
	Menu menu = new Menu(EditAllEffects_Handler);

	menu.SetTitle("Select an effect to edit.");

	char name[128];
	effect_data effect;
	LoopAllEffects(effect, index){
		Format(name, sizeof(name), "%s", GetChaosTitle(effect.FunctionName));
		bool enabled = effect.Enabled;
		Format(name, sizeof(name), "%s %s", name, enabled ? "[ON]" : "[OFF]");
		menu.AddItem(effect.FunctionName, name);
	}

	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int EditAllEffects_Handler(Menu menu, MenuAction action, int param1, int param2){
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			ShowMenu_EffectSetting(param1, info);
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_Settings(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void ShowMenu_EffectSetting(int client, char[] function_name){

	effect_data effect;
	GetEffectData(function_name, effect);

	char enabled_status[128];
	
	FormatEx(enabled_status, sizeof(enabled_status), "Enabled: %s", effect.Enabled ? "ON" : "OFF");	

	char effect_duration[128];
	FormatEx(effect_duration, sizeof(effect_duration), "Duration: %f", effect.GetDuration());	

	char menu_title[256];
	FormatEx(menu_title, sizeof(menu_title), "Edit settings for %s\n ", effect.Title);

	Menu menu = new Menu(EffectSetting_Handler);

	menu.SetTitle(menu_title);

	menu.AddItem("setting-enabled", 			enabled_status);
	// if(GetChaosTime(function_name ,-1.0, true) == -1){
	bool blacklisted = false;


	if(effect.HasNoDuration){
		blacklisted = true;
	}
	
	if(blacklisted){
		menu.AddItem("setting-effect_duration", 	"This effect has no duration.", ITEMDRAW_DISABLED);
	}else{
		menu.AddItem("setting-effect_duration", 	effect_duration);
	}
	menu.AddItem(function_name, "function_name", ITEMDRAW_NOTEXT);

	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int EffectSetting_Handler(Menu menu, MenuAction action, int param1, int param2){
	char function_name[64];
	GetMenuItem(menu, 2, function_name, sizeof(function_name));
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			if(StrEqual(info, "setting-enabled", false)){
				effect_data effect;
				GetEffectData(function_name, effect);
				if(effect.Enabled){
					UpdateConfig(param1, "Chaos_Override", "Effects", function_name, "enabled", "0");
				}else{
					UpdateConfig(param1, "Chaos_Override", "Effects", function_name, "enabled", "1");
				}
				ShowMenu_EffectSetting(param1, function_name);
			}else if(StrEqual(info, "setting-effect_duration", false)){
				ShowMenu_SetDuration(param1, function_name);
			}
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_EditAllEffects(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void ShowMenu_SetDuration(int client, char[] function_name){
	char effect_title[128];
	FormatEx(effect_title, sizeof(effect_title), "%s", GetChaosTitle(function_name));
	
	char menu_title[256];
	FormatEx(menu_title, sizeof(menu_title), "Set duration for %s", effect_title);

	Menu menu = new Menu(SetDuration_Handler);

	menu.SetTitle(menu_title);

	char currentDuration[25];
	FormatEx(currentDuration, sizeof(currentDuration), "Current Duratiom: %i", RoundToFloor(GetChaosTime(function_name, -1.0, true)));

	menu.AddItem(function_name, "function_name", ITEMDRAW_NOTEXT);
	menu.AddItem("_", currentDuration, ITEMDRAW_DISABLED);
	menu.AddItem("0", "0 (Infinite)");
	menu.AddItem("5", "5 seconds");
	menu.AddItem("10", "10 seconds");
	menu.AddItem("15", "15 seconds");
	menu.AddItem("20", "20 seconds");
	menu.AddItem("25", "25 seconds");
	menu.AddItem("30", "30 seconds");
	menu.AddItem("35", "35 seconds");
	menu.AddItem("40", "40 seconds");
	menu.AddItem("45", "45 seconds");
	menu.AddItem("50", "50 seconds");
	menu.AddItem("55", "55 seconds");
	menu.AddItem("60", "60 seconds");

	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int SetDuration_Handler(Menu menu, MenuAction action, int param1, int param2){
	char function_name[64];
	GetMenuItem(menu, 0, function_name, sizeof(function_name));
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		if(found){
			UpdateConfig(param1, "Chaos_Override", "Effects", function_name, "duration", info);
			ShowMenu_SetDuration(param1, function_name);
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			ShowMenu_EffectSetting(param1, function_name);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}