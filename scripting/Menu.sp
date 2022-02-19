//todo create a settings menu


void HideHud(int client){
	if(IsValidClient(client)){
		g_HideHud[client] = true;
	}
}


void ShowHud(int client){
	if(IsValidClient(client)){
		g_HideHud[client] = false;
	}
}

void ShowMenu_Main(int client){
	if(!IsValidClient(client)) return;
	Menu menu = new Menu(Main_Handler);
	

	menu.SetTitle("CS:GO Chaos Mod"); //?
	if(g_bChaos_Enabled){
		menu.AddItem("toggle-chaos", "Disable Chaos");
	}else{
		menu.AddItem("toggle-chaos", "Enable Chaos");
	}

	if(g_bCanSpawnEffect){
		menu.AddItem("new-effect", "Spawn New Effect");
	}else{
		menu.AddItem("new-effect", "Spawn New Effect", ITEMDRAW_DISABLED);
	}

	// menu.AddItem("help", "Help");
	menu.AddItem("credits", "Credits");
	menu.AddItem("settings", "Settings");

	menu.ExitButton = true;
	menu.Display(client, 0);
	HideHud(client);
}

void ToggleChaos(int client = -1){
	if(g_bChaos_Enabled){
		Command_StopChaos(client, 0);
	}else{
		Command_StartChaos(client, 0);
	}
}

public int Main_Handler(Menu menu, MenuAction action, int param1, int param2){
	ShowHud(param1);
	
	/* If an option was selected, tell the client about the item. */
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			if(StrEqual(info, "new-effect", false)){
				ShowMenu_Effects(param1, true);
			}else if(StrEqual(info, "toggle-chaos", false)){
				ToggleChaos(param1);
			}else if(StrEqual(info, "credits", false)){
				
			}else if(StrEqual(info, "settings")){
				ShowMenu_Settings(param1);
			}
		}
	}else if (action == MenuAction_Cancel){

	}else if (action == MenuAction_End){
		delete menu;
	}
}



void ShowMenu_Effects(int client, bool AllowRandom = false){
	if(!IsValidClient(client)) return;
	HideHud(client);
	Menu menu = new Menu(Effect_Selection);
	menu.SetTitle("Select Chaos Effect");
	char title[64];
	char title2[64];
	char title3[1][64];
	char final_title[128];
	if(AllowRandom) menu.AddItem("", "Random Effect"); //KEEP ID BLANK

	if(AllowRandom) PoolChaosEffects();
	
	for(int i = 0; i < GetArraySize(Possible_Chaos_Effects); i++){
		GetArrayString(Possible_Chaos_Effects, i, title, sizeof(title));
		FormatEx(title2, sizeof(title2), "%s", title[6]); //remove Chaos_ Prefix
		ExplodeString(title2, ".", title3, sizeof(title3), sizeof(title3[]), false);
		FormatEx(final_title, sizeof(final_title), "%s", GetChaosTitle(title3[0]));
		menu.AddItem(title, final_title);
	}
	menu.ExitButton = true;
	menu.Display(client, 0);

	g_HideHud[client] = true;
	if(g_DynamicChannel){
		SetHudTextParams(0.01, 0.42, 0.1, 37, 186, 255, 0, 0, 1.0, 0.0, 0.0);
		ShowHudText(client, GetDynamicChannel(1), "");
	}

}



//todo: refactor all the actual spawning into ChooseEffect (add paramater)

public int Effect_Selection(Menu menu, MenuAction action, int param1, int param2){
	ShowHud(param1);

	/* If an option was selected, tell the client about the item. */
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			g_sSelectedChaosEffect = info;
			if(g_sSelectedChaosEffect[0]){
				if(g_bCanSpawnEffect && g_bChaos_Enabled){
					g_bDecidingChaos = true;
					g_bClearChaos = false;
					Chaos();
				}else{
					ReplyToCommand(param1, "[Chaos] Sorry, no effects can be spawned in right now.");
					if(!g_bChaos_Enabled){
						ReplyToCommand(param1, "[Chaos] use !startchaos to re-enable Chaos.");
					}
				}
			}else{
				ChooseEffect(null, true);
			}

		}
	}else if (action == MenuAction_Cancel){
		// PrintToServer("Client %d's menu was cancelled.  Reason: %d", param1, param2);
	}else if (action == MenuAction_End){
		delete menu;
	}
}



void ShowMenu_Settings(int client){
	if(!IsValidClient(client)) return;
	HideHud(client);
	Menu menu = new Menu(Settings_Handler);
	menu.SetTitle("Chaos Settings");	
	menu.AddItem("edit-effects", "Edit Effects"); // "Select an effect you'd like to edit" (list of ALL effects);
	menu.AddItem("edit-convars", "Edit ConVars");

	menu.ExitButton = true;
	menu.Display(client, 0);
	g_HideHud[client] = true;


}

public int Settings_Handler(Menu menu, MenuAction action, int param1, int param2){
	ShowHud(param1);
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			if(StrEqual(info, "edit-effects", false)){
				Showmenu_EditAllEffects(param1);
			}else if(StrEqual(info, "edit-convars", false)){

			}
		}
	}else if (action == MenuAction_Cancel){
		// PrintToServer("Client %d's menu was cancelled.  Reason: %d", param1, param2);
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void Showmenu_EditAllEffects(int client){
	HideHud(client);
	Menu menu = new Menu(EditAllEffects_Handler);

	menu.SetTitle("Select an effect to edit.");

	char name[128];
	char function_name[64];

	for(int i = 0; i < GetArraySize(Effect_Functions); i++){
		GetArrayString(Effect_Titles, i, name, sizeof(name));
		GetArrayString(Effect_Functions, i, function_name, sizeof(function_name));
		bool enabled = IsChaosEnabled(function_name);
		Format(name, sizeof(name), "%s %s", name, enabled ? "[ON]" : "[OFF]");
		menu.AddItem(function_name, name);
	}

	menu.ExitButton = true;
	menu.Display(client, 0);


}

public int EditAllEffects_Handler(Menu menu, MenuAction action, int param1, int param2){
	ShowHud(param1);

	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			ShowMenu_EffectSetting(param1, info);
		}
	}else if (action == MenuAction_Cancel){
		// PrintToServer("Client %d's menu was cancelled.  Reason: %d", param1, param2);
	}else if (action == MenuAction_End){
		delete menu;
	}
}

void ShowMenu_EffectSetting(int client, char[] function_name){
	HideHud(client);

	char effect_title[128];
	FormatEx(effect_title, sizeof(effect_title), "%s", GetChaosTitle(function_name));
	
	char enabled_status[128];
	FormatEx(enabled_status, sizeof(enabled_status), "Enabled: %s", IsChaosEnabled(function_name) ? "ON" : "OFF");	
	char effect_duration[128];
	FormatEx(effect_duration, sizeof(effect_duration), "Duration: %f", GetChaosTime(function_name ,-1.0, true));	

	char menu_title[256];
	FormatEx(menu_title, sizeof(menu_title), "Edit settings for %s", effect_title);

	Menu menu = new Menu(EffectSetting_Handler);

	menu.SetTitle(menu_title);

	menu.AddItem("setting-enabled", 			enabled_status);
	if(GetChaosTime(function_name ,-1.0, true) == -1){
		menu.AddItem("setting-effect_duration", 	effect_duration, ITEMDRAW_DISABLED);
	}else{
		menu.AddItem("setting-effect_duration", 	effect_duration);
	}
	menu.AddItem(function_name, "function_name", ITEMDRAW_NOTEXT);

	

	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
	g_HideHud[client] = true;

	
}
public int EffectSetting_Handler(Menu menu, MenuAction action, int param1, int param2){
	ShowHud(param1);
	char function_name[64];
	GetMenuItem(menu, 2, function_name, sizeof(function_name));
	// PrintToChatAll("the found function is %s", function_name);
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			if(StrEqual(info, "setting-enabled", false)){
				if(IsChaosEnabled(function_name)){
					UpdateConfig_UpdateEffect(param1, function_name, "enabled", "0");
				}else{
					UpdateConfig_UpdateEffect(param1, function_name, "enabled", "1");
				}
				ShowMenu_EffectSetting(param1, function_name);
			}else if(StrEqual(info, "setting-effect_duration", false)){
				ShowMenu_SetDuration(param1, function_name);
			}
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			Showmenu_EditAllEffects(param1);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}





// void ShowMenu_ToggleEffect(int client, char[] function_name){
// 	//check if chaos enabled, disable the ON/OFF button depending on which one..
// 	HideHud(client);

// 	char effect_title[128];
// 	FormatEx(effect_title, sizeof(effect_title), "%s", GetChaosTitle(function_name));

// 	char menu_title[256];
// 	FormatEx(menu_title, sizeof(menu_title), "Edit settings for %s", effect_title);

// 	Menu menu = new Menu(ToggleEffect_Handler);

// 	menu.SetTitle(menu_title);

// 	if(IsChaosEnabled(function_name)){
// 		menu.AddItem("setting-toggle_on", 	"Enable", ITEMDRAW_DISABLED);
// 		menu.AddItem("setting-toggle_off", 	"Disable");
// 	}else{
// 		menu.AddItem("setting-toggle_on", 	"Enable");
// 		menu.AddItem("setting-toggle_off", 	"Disable", ITEMDRAW_DISABLED);
// 	}
// 	menu.AddItem(function_name, "function_name", ITEMDRAW_NOTEXT);


// 	menu.ExitButton = true;
// 	menu.ExitBackButton = true; 
// 	menu.Display(client, 0);
// }



// public int ToggleEffect_Handler(Menu menu, MenuAction action, int param1, int param2){
// 	ShowHud(param1);
// 	char function_name[64];

// 	GetMenuItem(menu, 2, function_name, sizeof(function_name));
// 	// PrintToChatAll("222the found function is %s", function_name);

// 	if (action == MenuAction_Select){
// 		char info[64];
// 		bool found = menu.GetItem(param2, info, sizeof(info));
// 		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
// 		if(found){
// 			if(StrEqual(info, "setting-toggle_off", false)){
// 				// PrintToChatAll("Toggling OFF %s", function_name);
// 				UpdateConfig_ToggleEffect(function_name, false);
// 			}else if(StrEqual(info, "setting-toggle_on", false)){
// 				UpdateConfig_ToggleEffect(function_name, true);
// 				// PrintToChatAll("Toggling ON %s", function_name);
// 			}
// 		}
// 	}else if (action == MenuAction_Cancel){
// 		if(param2 ==  MenuCancel_ExitBack){
// 			// Showmenu_EditAllEffects(param1);
// 		}
// 	}else if (action == MenuAction_End){
// 		delete menu;
// 	}
// }

//todo handle MenuCancel_Timeout to bring back effect hud

void UpdateConfig_UpdateEffect(int client = -1, char[] function_name, char[] key, char[] newValue){
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/Chaos/Chaos_Effects.cfg");

	if(!FileExists(path)) return;

	KeyValues kvConfig = new KeyValues("Effects");
	if(!kvConfig.ImportFromFile(path)){
		Log("Unable to parse Key Values file %s", path);
		LogError("Unable to parse Key Values file %s", path);
		// SetFailState("Unable to parse Key Values file %s", path);
		return;
	}

	kvConfig.JumpToKey(function_name, true);
	kvConfig.SetString(key, newValue);
	kvConfig.Rewind();

	if(kvConfig.ExportToFile(path)){
		if(IsValidClient(client)){
			PrintToChatAll("Effect '%s' modified in config. Key '%s' has been set to '%s'", function_name, key, newValue);
			Log("Effect '%s' modified in config. Key '%s' has been set to '%s'", function_name, key, newValue);
			// PrintToChat(client, "[Chaos] Effect '%s' has been changed in the config. New value: '%s'.", function_name, newValue);
		}
		ParseChaosEffects();
	}else{
		if(IsValidClient(client)){
			PrintToChat(client, "[Chaos] Failed to update config.");
		}
	}

	delete 	kvConfig;

}



void ShowMenu_SetDuration(int client, char[] function_name){
	HideHud(client);

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
	
	// char menu_duration[64];
	// for(int i = 0; i <= 60; i = i +5){
	// 	if(i > 0){
	// 		Format(menu_duration, sizeof(menu_duration), "%i Seconds");
	// 	}else{
	// 		Format(menu_duration, sizeof(menu_duration), "0 (Infinite)");
	// 	}
	// 	menu.AddItem(i, menu_duration);
	// }


	menu.ExitButton = true;
	menu.ExitBackButton = true; 
	menu.Display(client, 0);
}

public int SetDuration_Handler(Menu menu, MenuAction action, int param1, int param2){
	ShowHud(param1);
	char function_name[64];
	GetMenuItem(menu, 0, function_name, sizeof(function_name));
	// PrintToChatAll("the found function is %s", function_name);
	if (action == MenuAction_Select){
		char info[64];
		bool found = menu.GetItem(param2, info, sizeof(info));
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			// int newDuration = StringToInt(found);
			UpdateConfig_UpdateEffect(param1, function_name, "duration", info);
			ShowMenu_SetDuration(param1, function_name);
		}
	}else if (action == MenuAction_Cancel){
		if(param2 ==  MenuCancel_ExitBack){
			//todo go back to effect
			ShowMenu_EffectSetting(param1, function_name);
		}
	}else if (action == MenuAction_End){
		delete menu;
	}
}

// todo create a config README, this ^^ removes any comments
// readme will also contain a link for default settings