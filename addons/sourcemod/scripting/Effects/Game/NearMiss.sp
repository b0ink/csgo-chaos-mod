bool NearMiss = false;

char NearMissSFX[][] = {
	"weapons/fx/nearmiss/bulletltor01.wav",
	"weapons/fx/nearmiss/bulletltor06.wav",
	"weapons/fx/nearmiss/bulletltor07.wav",
	"weapons/fx/nearmiss/bulletltor08.wav",
	"weapons/fx/nearmiss/bulletltor09.wav",
	"weapons/fx/nearmiss/bulletltor10.wav",
	"weapons/fx/nearmiss/bulletltor11.wav",
	"weapons/fx/nearmiss/bulletltor13.wav",
	"weapons/fx/nearmiss/bulletltor14.wav",
	"weapons/fx/rics/ric3.wav",
	"weapons/fx/rics/ric4.wav",
	"weapons/fx/rics/ric5.wav",
};

public void Chaos_NearMiss(EffectData effect){
	effect.Title = "Near Miss";
	effect.Duration = 30;
}

public void Chaos_NearMiss_START(){
	NearMiss = true;
	CreateTimer(0.3, Timer_NearMissSound, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE)
}

Action Timer_NearMissSound(Handle timer){
	if(!NearMiss) return Plugin_Stop;

	int random = GetURandomInt() % sizeof(NearMissSFX);

	LoopValidPlayers(i){
		ClientCommand(i, "playgamesound %s", NearMissSFX[random]);
	}

	return Plugin_Continue;
}

public void Chaos_NearMiss_RESET(int ResetType){
	NearMiss = false;
}