/*
	Keep in mind this does "pause" the game time, meaning the duration of this effect is much longer as stated
*/

public void Chaos_Lag(effect_data effect){
	effect.title = "Lag";
	effect.duration = 30;
}

bool FakeLag = false;
public void Chaos_Lag_START(){
	FakeLag = true;
	CreateTimer(3.0, Timer_FakeLag);
}

public Action Timer_FakeLag(Handle timer){
	if(!FakeLag) return;
	ServerCommand("sv_cheats 1");

	int amount = 1;
	
	int chance = GetRandomInt(0, 100);
	if(chance <= 5){
		amount = 4;
	}else if(chance <= 25){
		amount = 3;
	}else if(chance <= 40){
		amount = 2;
	} //else stay as default value

	for(int i = 0; i <= amount; i++) ServerCommand("spike");

	ServerCommand("sv_cheats 0");
	CreateTimer(GetRandomFloat(1.0, 5.0), Timer_FakeLag);
}

public Action Chaos_Lag_RESET(bool HasTimerEnded){
	FakeLag = false;
}