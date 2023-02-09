#pragma semicolon 1

bool QuickMath = false;

int QuickMathAnswer = 0;
int QuickMathNum1 = 0;
int QuickMathNum2 = 0;

bool QuickMathSolved[MAXPLAYERS+1];

public void Chaos_QuickMath(effect_data effect){
	effect.Title = "Quick Math";
	effect.Duration = 10;
	effect.IncompatibleWith("Chaos_BlindPlayers");
	effect.IncompatibleWith("Chaos_SleepyShooter");
}

public void Chaos_QuickMath_INIT(){
	AddCommandListener(QuickMath_SayListener, "say");	
	AddCommandListener(QuickMath_SayListener, "say_team");	
}

public Action QuickMath_SayListener(int client, const char[] command, int argc){
	if(!QuickMath) return Plugin_Continue;
	if(QuickMathSolved[client]) return Plugin_Continue;

	char text[64];
	GetCmdArg(1, text, 64);
	
	int answer = StringToInt(text);
	if(answer == QuickMathAnswer){
		QuickMathSolved[client] = true;
		PerformBlind(client, 0);
	}
	return Plugin_Continue;
}

public void Chaos_QuickMath_START(){
	LoopAlivePlayers(i){
		ClientCommand(i, "slot3");
		QuickMathSolved[i] = false;
		PerformBlind(i, 255, 0);
	}

	QuickMathNum1 = GetRandomInt(1, 20);
	QuickMathNum2 = GetRandomInt(1, 20);
	QuickMathAnswer = QuickMathNum1 + QuickMathNum2;
	QuickMath = true;

	CPrintToChatAll("%s Type the answer of [{orange}%i {default}+ {orange}%i{default}] in chat to see again!",g_Prefix, QuickMathNum1, QuickMathNum2);
	CPrintToChatAll("%s Type the answer of [{orange}%i {default}+ {orange}%i{default}] in chat to see again!",g_Prefix, QuickMathNum1, QuickMathNum2);
	CPrintToChatAll("%s Type the answer of [{orange}%i {default}+ {orange}%i{default}] in chat to see again!",g_Prefix, QuickMathNum1, QuickMathNum2);
	CPrintToChatAll("%s Type the answer of [{orange}%i {default}+ {orange}%i{default}] in chat to see again!",g_Prefix, QuickMathNum1, QuickMathNum2);
	CPrintToChatAll("%s Type the answer of [{orange}%i {default}+ {orange}%i{default}] in chat to see again!",g_Prefix, QuickMathNum1, QuickMathNum2);

	CreateTimer(1.0, Timer_PrintQuickMathPrompt, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

Action Timer_PrintQuickMathPrompt(Handle timer){
	if(!QuickMath) return Plugin_Stop;

	LoopAlivePlayers(i){
		if(QuickMathSolved[i]) continue;
		PrintHintText(i, "Type the answer of [%i + %i] in chat to see again!", QuickMathNum1, QuickMathNum2);
	}
	return Plugin_Continue;
}

public void Chaos_QuickMath_RESET(int ResetType){

	QuickMath = false;
	LoopAlivePlayers(i){
		PerformBlind(i, 0);
		if(ResetType & RESET_EXPIRED && !(ResetType & RESET_ROUNDEND)){
			if(!QuickMathSolved[i]){
				SlapPlayer(i, 50);
			}
		}
		QuickMathSolved[i] = true;
	}

}

public bool Chaos_QuickMath_Conditions(bool EffectRunRandomly){
	if(EffectRunRandomly){
		if(TotalEffectsRunThisMap() < 5) return false;
		if(GetRoundTime() > 30) return false;
	}
	return true;
}