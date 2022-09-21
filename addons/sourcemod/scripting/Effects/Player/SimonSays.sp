Handle 	g_SimonSays_Timer = INVALID_HANDLE;
bool 	g_bSimon_Active = false;
bool 	g_bSimon_Says = false; // whether to say simon says or not
int 	g_Simon_Says_Action = -1;
char 	g_Simon_ActionText[64];
int 	g_time = -1;
bool g_bPlayersToDamage[MAXPLAYERS+1];

#define SS_STRAFE 1;
#define SS_CROUCH 2;


public void Chaos_SimonSays(effect_data effect){
	effect.title = "Simon Says";
	effect.HasNoDuration = true;
}

public void Chaos_SimonSays_START(){
	float duration = 10.0;
	GenerateSimonOrder(duration);
	StartMessageTimer();
	g_bSimon_Active = true;
}

public Action Chaos_SimonSays_RESET(bool HasTimerEnded){
	g_bSimon_Active = false;
	KillMessageTimer();
}

public bool Chaos_SimonSays_Conditions(){
	return true;
}

void GenerateSimonOrder(float duration){
	g_Simon_Says_Action = GetRandomInt(1,4);
	g_bSimon_Says = true;
	// if(GetRandomInt(0, 100) <= 50){
	// 	g_bSimon_Says = false;
	// }
	if(g_Simon_Says_Action == 1){
		g_Simon_ActionText = "Strafe.";
	}
	if(g_Simon_Says_Action == 2){
		g_Simon_ActionText = "Move Forwards/Backwards.";
	}
	if(g_Simon_Says_Action == 3){
		g_Simon_ActionText = "Don't Jump.";
		g_bSimon_Says = true;
	}
	if(g_Simon_Says_Action == 4){
		g_Simon_ActionText = "Crouch.";
	}
	// g_time = 13;
	g_time = RoundToFloor(duration) + 5;

}

public void Chaos_SimonSays_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
	if(g_time >= 10) return;
	if(!g_bSimon_Active) return;

	if(g_Simon_Says_Action == 1){
		bool strafing = false;
		if(buttons & IN_MOVELEFT) strafing = true;
		if(buttons & IN_MOVERIGHT) strafing = true;
		if(strafing){
			if(!g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}else{
			if(g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}
	}
	
	if(g_Simon_Says_Action == 2){
		bool running = false;
		if(buttons & IN_FORWARD) running = true;
		if(buttons & IN_BACK) running = true;
		if(running){
			if(!g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}else{
			if(g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}
	}

	if(g_Simon_Says_Action == 3){
		bool jumping = false;
		if(buttons & IN_JUMP) jumping = true;
		if(jumping){
			if(g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}
	}
		
	if(g_Simon_Says_Action == 4){
		bool crouching = false;
		if(buttons & IN_DUCK) crouching = true;
		if(crouching){
			if(!g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}else{
			if(g_bSimon_Says) g_bPlayersToDamage[client] = true;
		}
	}
}

void DamagePlayer(int client, int amount = 20){
	int original = GetClientHealth(client);
	SetEntityHealth(client, original - amount);
	if((original - amount) <= 0){
		ForcePlayerSuicide(client);
	}
}

void StartMessageTimer(){
	g_SimonSays_Timer = CreateTimer(1.0, Timer_ShowAction, _,TIMER_REPEAT);
}

public Action Timer_ShowAction(Handle timer){
	g_time--;
	char message[128];
	if(g_time > 11){
		int countdown = g_time - 10;
		FormatEx(message, sizeof(message), "Simon says starting in \n%i...", countdown);
		DisplayCenterTextToAll(message);
	}else{
		if(g_time >= 0){
			LoopAlivePlayers(i){
				if(g_bPlayersToDamage[i]){
					DamagePlayer(i);
					g_bPlayersToDamage[i] = false;
				}
			}
			// FormatEx(message, sizeof(message), "<< SIMON SAYS >>\n\n");
			if(g_bSimon_Says){
				Format(message, sizeof(message), "%sSimon Says ", message);
			}
			Format(message, sizeof(message), "%s%s\n(%i)", message, g_Simon_ActionText, g_time);
			DisplayCenterTextToAll(message);
		}else{
			g_bSimon_Active = false;
			KillMessageTimer();
		}
	}
}

void KillMessageTimer(){
	if(g_SimonSays_Timer != INVALID_HANDLE){
		KillTimer(g_SimonSays_Timer);
		g_SimonSays_Timer = INVALID_HANDLE;
	}
}