public void Chaos_FakeCrash(effect_data effect){
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_Lag");
}

public void Chaos_FakeCrash_START(){
	g_sCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ServerCommand("sv_cheats 1");
	int amount = GetRandomInt(5, 10);
	for(int i = 0; i <= amount; i++) ServerCommand("spike");
	ServerCommand("sv_cheats 0");

	CreateTimer(2.0, Timer_AnnounceFakeCrash);

}

public Action Timer_AnnounceFakeCrash(Handle timer){
	AnnounceChaos(GetChaosTitle("Chaos_FakeCrash"), -1.0);
}

public bool Chaos_FakeCrash_Conditions(){
	if(g_iChaos_Round_Time < 30) return false; 
	return true;
}