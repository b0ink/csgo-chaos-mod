public void Chaos_ReversedRecoil_START(){
	cvar("weapon_recoil_scale", "-5");
}

public Action Chaos_ReversedRecoil_RESET(bool EndChaos){
	ResetCvar("weapon_recoil_scale", "2", "-5");
}


public bool Chaos_ReversedRecoil_HasNoDuration(){
	return false;
}

public bool Chaos_ReversedRecoil_Conditions(){
	return true;
}