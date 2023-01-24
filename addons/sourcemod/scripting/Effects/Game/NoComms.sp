bool NoComms = false;

public void Chaos_NoComms(effect_data effect){
	effect.Title = "No Comms"
	effect.Duration = 30;
	effect.IncompatibleWith("Chaos_Chatterbox");
}

public void Chaos_NoComms_INIT(){
	AddCommandListener(Boxing_SayListener, "say");
	AddCommandListener(Boxing_SayListener, "say_team");
	AddCommandListener(Boxing_SayListener, "player_ping");
	AddCommandListener(Boxing_SayListener, "chatwheel_ping");
}

public Action Boxing_SayListener(int client, const char[] command, int argc){
	if(NoComms){
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void Chaos_NoComms_START(){
	NoComms = true;
	LoopValidPlayers(i){
		SetClientListeningFlags(i, VOICE_MUTED);
	}
}

public void Chaos_NoComms_RESET(){
	NoComms = false;
	LoopValidPlayers(i){
		SetClientListeningFlags(i, VOICE_NORMAL);
	}
}