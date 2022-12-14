SETUP(effect_data effect){
	effect.Title = "Fake Crash";
	effect.HasNoDuration = true;
	effect.HasCustomAnnouncement = true;
	effect.IncompatibleWith("Chaos_Lag");
}

START(){
	g_sForceCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ServerCommand("sv_cheats 1");
	int amount = GetRandomInt(5, 10);
	for(int i = 0; i <= amount; i++) ServerCommand("spike");
	ServerCommand("sv_cheats 0");

	CreateTimer(1.0, Timer_AnnounceFakeCrash);

}

public Action Timer_AnnounceFakeCrash(Handle timer){
	AnnounceChaos(GetChaosTitle("Chaos_FakeCrash"), -1.0);
}

CONDITIONS(){
	if(g_iChaosRoundTime < 30) return false; 
	return true;
}