public void Chaos_InsaneGravity_START(){
	SetPlayersGravity(15.0);
	g_NoFallDamage++;
}

public Action Chaos_InsaneGravity_RESET(bool HasTimerEnded){
	SetPlayersGravity(1.0);
	if(g_NoFallDamage > 0) g_NoFallDamage--;
}