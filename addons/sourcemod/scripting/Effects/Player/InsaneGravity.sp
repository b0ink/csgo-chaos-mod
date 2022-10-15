public void Chaos_InsaneGravity(effect_data effect){
	effect.title = "Insane Gravity";
	effect.duration = 30;
}

public void Chaos_InsaneGravity_START(){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 15.0);
	}
	g_NoFallDamage++;
}

public Action Chaos_InsaneGravity_RESET(bool HasTimerEnded){
	LoopAlivePlayers(i){
		SetEntityGravity(i, 1.0);
	}
	if(g_NoFallDamage > 0) g_NoFallDamage--;
}