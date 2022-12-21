#define EFFECTNAME Invis

SETUP(effect_data effect){
	effect.Title = "Where did everyone go?";
	effect.Duration = 30;
}

START(){
	cvar("sv_disable_immunity_alpha", "1");
	LoopAlivePlayers(client){
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, 255, 255, 255, 50);
	}
}

RESET(bool HasTimerEnded){
	LoopAlivePlayers(client){
		SetEntityRenderMode(client , RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
	}
}

public void Chaos_Invis_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, 255, 255, 255, 50);
	}
}