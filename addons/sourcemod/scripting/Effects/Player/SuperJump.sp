public void Chaos_SuperJump_START(){
	cvar("sv_jump_impulse", "590");
}

public Action Chaos_SuperJump_RESET(bool EndChaos){
	ResetCvar("sv_jump_impulse", "301", "590");
}

public bool Chaos_SuperJump_HasNoDuration(){
	return false;
}

public bool Chaos_SuperJump_Conditions(){
	return true;
}