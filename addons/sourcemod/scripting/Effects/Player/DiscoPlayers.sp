Handle DiscoPlayers_TimerRepeat = INVALID_HANDLE;
bool DiscoPlayers = false;
public void Chaos_DiscoPlayers_START(){
	DiscoPlayers = true;
	Timer_DiscoPlayers();
	DiscoPlayers_TimerRepeat = CreateTimer(1.0, Timer_DiscoPlayers, _, TIMER_REPEAT);

}

public Action Chaos_DiscoPlayers_RESET(bool HasTimerEnded){
	StopTimer(DiscoPlayers_TimerRepeat);
	DiscoPlayers = false;
}

public Action Chaos_DiscoPlayers_OnPlayerRunCmd(int client, int &buttons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubType, int &iCmdNum, int &iTickCount, int &iSeed){

}


public bool Chaos_DiscoPlayers_HasNoDuration(){
	return false;
}

public bool Chaos_DiscoPlayers_Conditions(){
	return true;
}



Action Timer_DiscoPlayers(Handle timer = null){
	if(DiscoPlayers){
		LoopAlivePlayers(i){
			SetEntityRenderMode(i, RENDER_TRANSCOLOR);
			int color[3];
			color[0] = GetRandomInt(0, 255);
			color[1] = GetRandomInt(0, 255);
			color[2] = GetRandomInt(0, 255);
			int oldcolors[4];
			GetEntityRenderColor(i, oldcolors[0],oldcolors[1],oldcolors[2],oldcolors[3]);
			SetEntityRenderColor(i, color[0], color[1], color[2], oldcolors[3]);
		}
	}else{
		StopTimer(DiscoPlayers_TimerRepeat);
	}
}
