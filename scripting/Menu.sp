//todo create a settings menu


/**
	TODO
	when FakeClientCommand/ClientCommand ("slot1") is used, it activates menus, check 
	if g_hidehud is activated for that user
 */



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

	menu.AddItem("help", "Help");
	// menu.AddItem("credits", "Credits");
	menu.AddItem("settings", "Settings");

	menu.ExitButton = true;
	menu.Display(client, 0);
}

void ToggleChaos(int client = -1){
	if(g_bChaos_Enabled){
		Command_StopChaos(client, 0);
	}else{
		Command_StartChaos(client, 0);
	}
}

public int Main_Handler(Menu menu, MenuAction action, int param1, int param2){
	
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


int FindStringInArrayViaKeyword(Handle array, char[] keyword){
	char search_term[64];
	int index = -1;
	for(int i = 0; i < GetArraySize(array); i++){
		GetArrayString(array, i, search_term, sizeof(search_term));
		index = StrContains(search_term, keyword, false);
		if(index != -1) break;
	}
	return index;
}


void ShowMenu_Effects(int client, bool AllowRandom = false){
	if(!IsValidClient(client)) return;

	Menu menu = new Menu(Effect_Selection);
	menu.SetTitle("Select Chaos Effect");
	char function_name[64];
	// char title2[64];
	// char title3[1][64];
	char function_title[128];
	if(AllowRandom) menu.AddItem("", "Random Effect"); //KEEP ID BLANK

	if(AllowRandom) PoolChaosEffects();
	
	char search_function[64];
	for(int i = 0; i < GetArraySize(Effect_Titles); i++){ //should contain all 102 all time
		GetArrayString(Effect_Functions, i, search_function, sizeof(search_function));

		// int index = FindStringInArray(Possible_Chaos_Effects, search_function);
		int index = FindStringInArrayViaKeyword(Possible_Chaos_Effects, search_function);
		if(index != -1){
			GetArrayString(Effect_Titles, i, function_title, sizeof(function_title));
			GetArrayString(Effect_Functions, i, function_name, sizeof(function_name));

			menu.AddItem(function_name, function_title);

		}else{
			PrintToChatAll("size of possibleeffects: %i", GetArraySize(Possible_Chaos_Effects));
			PrintToChatAll("search: %s, found index: %i", search_function, index);
		}
		//todo half of them return -1;


		// GetArrayString(Possible_Chaos_Effects, i, title, sizeof(title));
		// FormatEx(title2, sizeof(title2), "%s", title[6]); //remove Chaos_ Prefix
		// ExplodeString(title2, ".", title3, sizeof(title3), sizeof(title3[]), false);
		// FormatEx(final_title, sizeof(final_title), "%s", GetChaosTitle(title3[0]));
	}
	menu.ExitButton = true;
	menu.Display(client, 0);

	if(g_DynamicChannel){
		SetHudTextParams(0.01, 0.42, 0.1, 37, 186, 255, 0, 0, 1.0, 0.0, 0.0);
		ShowHudText(client, GetDynamicChannel(1), "");
	}

}



//todo: refactor all the actual spawning into ChooseEffect (add paramater)

public int Effect_Selection(Menu menu, MenuAction action, int param1, int param2){

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
	Menu menu = new Menu(Settings_Handler);
	menu.SetTitle("Chaos Settings");	
	menu.AddItem("edit-effects", "Edit Effects"); // "Select an effect you'd like to edit" (list of ALL effects);
	menu.AddItem("edit-convars", "Edit ConVars");

	menu.ExitButton = true;
	menu.Display(client, 0);


}

public int Settings_Handler(Menu menu, MenuAction action, int param1, int param2){
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

	
}
public int EffectSetting_Handler(Menu menu, MenuAction action, int param1, int param2){
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


//todo handle MenuCancel_Timeout to bring back effect hud


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
		PrintToConsole(param1, "You selected item: %d (found? %d info: %s)", param2, found, info);
		if(found){
			UpdateConfig_UpdateEffect(param1, function_name, "duration", info);
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

// todo create a config README, this ^^ removes any comments from the existing cfg filef
// readme will also contain a link for default settings

//todo what if manual changes in game do actually create an override cfg file, so that when you update chaos all your changes will technically be saved
