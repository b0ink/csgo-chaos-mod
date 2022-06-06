public void Chaos_FakeCrash_INIT(){
	
}


public void Chaos_FakeCrash_START(){
	g_sCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ServerCommand("sv_cheats 1");
	int amount = GetRandomInt(5, 10);
	for(int i = 0; i <= amount; i++) ServerCommand("spike");
	ServerCommand("sv_cheats 0");

	AnnounceChaos(GetChaosTitle("Chaos_FakeCrash"), -1.0);

}

public Action Chaos_FakeCrash_RESET(bool EndChaos){

}


public bool Chaos_FakeCrash_HasNoDuration(){
	return true;
}

public bool Chaos_FakeCrash_CustomAnnouncement(){
	return true;
}

public bool Chaos_FakeCrash_Conditions(){
	if(g_iChaos_Round_Time < 30) return false; 
	return true;
}