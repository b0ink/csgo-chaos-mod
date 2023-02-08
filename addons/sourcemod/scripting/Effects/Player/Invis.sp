#pragma semicolon 1

public void Chaos_Invis(effect_data effect){
	effect.Title = "Where did everyone go?";
	effect.Duration = 30;
}

public void Chaos_Invis_START(){
	cvar("sv_disable_immunity_alpha", "1");
	LoopAlivePlayers(client){
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, 255, 255, 255, 50);
	}
}

public void Chaos_Invis_RESET(int ResetType){
	LoopAlivePlayers(client){
		SetEntityRenderMode(client , RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
	}
}

public void Chaos_Invis_OnPlayerSpawn(int client){
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 255, 255, 255, 50);
}