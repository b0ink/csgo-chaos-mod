//todo create a settings menu



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
	menu.AddItem("credits", "Credits");
	menu.AddItem("settings", "Settings");

	menu.ExitButton = true;
	menu.Display(client, 0);
	g_HideHud[client] = true;
}

void ToggleChaos(int client = -1){
	if(g_bChaos_Enabled){
		Command_StopChaos(client, 0);
	}else{
		Command_StartChaos(client, 0);
	}
}

public int Main_Handler(Menu menu, MenuAction action, int param1, int param2){
	if(IsValidClient(param1)) g_HideHud[param1] = false;

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
				
			}
		}
	}else if (action == MenuAction_Cancel){

	}else if (action == MenuAction_End){
		delete menu;
	}
}



void ShowMenu_Effects(int client, bool AllowRandom = false){
	if(!IsValidClient(client)) return;
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



//todo: fact all the spawning into ChooseEffect (add paramater)

public int Effect_Selection(Menu menu, MenuAction action, int param1, int param2){
	if(IsValidClient(param1)){
		g_HideHud[param1] = false;
	}
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

