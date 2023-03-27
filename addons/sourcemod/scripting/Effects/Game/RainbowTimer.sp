public void Chaos_RainbowTimer(EffectData effect){
	effect.Title = "Rainbow Timer";
	effect.Duration = 30;
}

//TODO: Timer is only refreshed once a second so it doesn't get the smooth transition, HUD could be worth a rewrite at this point

int RainbowTimerColor[3];
bool RainbowTimer = false;

public void Chaos_RainbowTimer_START(){
	RainbowTimer = true;
}

public void Chaos_RainbowTimer_RESET(){
	RainbowTimer = false;
}

public void Chaos_RainbowTimer_OnGameFrame(EffectData effect){
	RainbowTimerColor[0] = RoundToNearest(Cosine((GetGameTime() * 1.0)  + 0) * 127.5 + 127.5);
	RainbowTimerColor[1] = RoundToNearest(Cosine((GetGameTime() * 1.0) + 2) * 127.5 + 127.5);
	RainbowTimerColor[2] = RoundToNearest(Cosine((GetGameTime() * 1.0) + 4) * 127.5 + 127.5);
}

bool IsRainbowTimerEffectActive(){
	return RainbowTimer;
}

void GetRainbowTimerColor(int buffer[3]){
	buffer = RainbowTimerColor;
}