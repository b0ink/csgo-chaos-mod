public void Chaos_InsaneGravity_START(){
	SetPlayersGravity(15.0);
	g_NoFallDamage++;
}

public Action Chaos_InsaneGravity_RESET(bool EndChaos){
	SetPlayersGravity(1.0);
	if(g_NoFallDamage > 0) g_NoFallDamage--;
}


public bool Chaos_InsaneGravity_HasNoDuration(){
	return false;
}

public bool Chaos_InsaneGravity_Conditions(){
	return true;
}