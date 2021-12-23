/*
	if simon says is active
		> repeat the hint text of what the command is
	

	simon says ideas
	=if it says simon says, and 
	> Simon says  ...
		> Don't strafe > Strafe


*/

bool g_bg_Simon_Active = false;
bool g_bg_Simon_Says = false; // whether to say simon says or not
int g_Simon_Says_Action = -1;
char g_Simon_ActionText[64];
int g_time = -1;
Handle msg_timer = INVALID_HANDLE;
float g_SimonSays_Duration = 10.0;
#define SS_STRAFE 1;
#define SS_CROUCH 2;

void GenerateSimonOrder(){
	g_Simon_Says_Action = GetRandomInt(1,4);
	g_Simon_Says = true;
	if(GetRandomInt(0, 100) <= 50){
		g_Simon_Says = false;
	}
	if(g_Simon_Says_Action == 1){
		g_Simon_ActionText = "Strafe.";
	}
	if(g_Simon_Says_Action == 2){
		g_Simon_ActionText = "Move Forwards/Backwards.";
	}
	if(g_Simon_Says_Action == 3){
		g_Simon_ActionText = "Don't Jump.";
		g_Simon_Says = true;
	}
	if(g_Simon_Says_Action == 4){
		g_Simon_ActionText = "Crouch.";
	}
	// g_time = 13;
	g_time = RoundToFloor(g_SimonSays_Duration) + 3;


}

bool g_bplayersToDamage[MAXPLAYERS+1];
void SimonSays(int client, int &buttons, int &iImpulse, float fVel[3] = {0.0, 0.0, 0.0}, float fAngles[3] = {0.0, 0.0, 0.0}, int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){
// void SimonSays(int client, bool g_bstrafing, bool g_brunning){
	// if(!g_Simon_Active) return
	// playersToDamage[client] = false;
	if(fVel[0] || fAngles[0]){
		//remove warnings!
	}
	if(g_Simon_Says_Action == 1){
		bool g_bstrafing = false;
		if(buttons & IN_MOVELEFT) strafing = true;
		if(buttons & IN_MOVERIGHT) strafing = true;
		if(strafing){
			if(!g_Simon_Says) playersToDamage[client] = true;
		}else{
			if(g_Simon_Says) playersToDamage[client] = true;
		}
	}
	
	if(g_Simon_Says_Action == 2){
		bool g_brunning = false;
		if(buttons & IN_FORWARD) running = true;
		if(buttons & IN_BACK) running = true;
		if(running){
			if(!g_Simon_Says) playersToDamage[client] = true;
		}else{
			if(g_Simon_Says) playersToDamage[client] = true;
		}
	}

	if(g_Simon_Says_Action == 3){
		bool g_bjumping = false;
		if(buttons & IN_JUMP) jumping = true;
		if(jumping){
			if(g_Simon_Says) playersToDamage[client] = true;
		}
	}
		
	if(g_Simon_Says_Action == 4){
		bool g_bcrouching = false;
		if(buttons & IN_DUCK) crouching = true;
		if(crouching){
			if(!g_Simon_Says) playersToDamage[client] = true;
		}else{
			if(g_Simon_Says) playersToDamage[client] = true;
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
	msg_timer = CreateTimer(1.0, Timer_ShowAction, _,TIMER_REPEAT);
}

public Action Timer_ShowAction(Handle timer){
	g_time--;
	char message[128];
	if(g_time > 10){
		int countdown = g_time - 10;
		FormatEx(message, sizeof(message), "Simon says starting in %i...", countdown);
		// DisplayCenterTextToAll("Simon says starting in %i...", countdown);
		DisplayCenterTextToAll(message);
	}else{
		if(g_time >= 0){
			for(int i = 0; i <= MaxClients; i++){
				if(IsValidClient(i)){
					if(playersToDamage[i]){
						DamagePlayer(i);
						playersToDamage[i] = false;
					}
				}
			}
			FormatEx(message, sizeof(message), "<< SIMON SAYS >>\n\n");
			if(g_Simon_Says){
				Format(message, sizeof(message), "%sSimon Says ", message);
			}
			Format(message, sizeof(message), "%s%s (%i)", message, g_Simon_ActionText, g_time);
			DisplayCenterTextToAll(message);
		}else{
			g_Simon_Active = false;
			KillMessageTimer();
		}
	}


}

void KillMessageTimer(){
	if(msg_timer != INVALID_HANDLE){
		KillTimer(msg_timer);
		msg_timer = INVALID_HANDLE;
	}
	// StopTimer(msg_timer);
}