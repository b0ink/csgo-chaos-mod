#define EFFECTNAME Jackpot


SETUP(effect_data effect){
	effect.Title = "Jackpot";
	effect.HasNoDuration = true;
}

ONMAPSTART(){
	PrecacheSound("survival/money_collect_04.wav");
}
START(){
	LoopValidPlayers(i){
		EmitSoundToClient(i, "survival/money_collect_04.wav", _, _, SNDLEVEL_RAIDSIREN, _, 0.5);
		SetClientMoney(i, 16000);
	}
}