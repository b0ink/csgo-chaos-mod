public void Chaos_Invis_START(){
	int alpha = 50;

	cvar("sv_disable_immunity_alpha", "1");

	LoopAlivePlayers(client){
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, 255, 255, 255, alpha);
	}
}

public Action Chaos_Invis_RESET(bool HasTimerEnded){
	LoopAlivePlayers(client){
		SetEntityRenderMode(client , RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
	}

}

public bool Chaos_Invis_HasNoDuration(){
	return false;
}

public bool Chaos_Invis_Conditions(){
	return true;
}