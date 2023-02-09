#pragma semicolon 1

public void Chaos_Nice(EffectData effect){
	effect.Title = "Nice";
	// effect.Title = "Nice ( ͡° ͜ʖ ͡°)";
	effect.HasNoDuration = true;
}

public void Chaos_Nice_OnMapStart(){
	PrecacheSound("survival/money_collect_04.wav");
}

public void Chaos_Nice_START(){
	LoopValidPlayers(i){
		EmitSoundToClient(i, "survival/money_collect_04.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		EmitSoundToClient(i, "survival/money_collect_04.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		EmitSoundToClient(i, "survival/money_collect_04.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		SetClientMoney(i, 6969, true, true);
	}
}