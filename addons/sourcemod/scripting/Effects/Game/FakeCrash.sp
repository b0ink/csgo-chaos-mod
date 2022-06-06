public void Chaos_FakeCrash_START(){
	g_sCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ServerCommand("sv_cheats 1");
	int amount = GetRandomInt(5, 10);
	for(int i = 0; i <= amount; i++) ServerCommand("spike");
	ServerCommand("sv_cheats 0");
}

public Action Chaos_FakeCrash_RESET(bool EndChaos){

}


public bool Chaos_FakeCrash_HasNoDuration(){
	return false;
}

public bool Chaos_FakeCrash_Conditions(){
	return true;
}