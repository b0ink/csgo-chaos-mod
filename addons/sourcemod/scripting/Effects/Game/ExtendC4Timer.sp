public void Chaos_ExtendC4Timer(EffectData effect){
	effect.Title = "Extend C4 Timer";
	effect.HasNoDuration = true;
	effect.BlockInCoopStrike = true;
}

int bombExplosion = -1;
public void Chaos_ExtendC4Timer_INIT(){
    bombExplosion = FindSendPropInfo("CPlantedC4", "m_flC4Blow");
}

public void Chaos_ExtendC4Timer_START(){
	int c4 = -1;
	c4 = FindEntityByClassname(c4, "planted_c4");
	if(c4 == -1) return;

	float blowTime = GetEntDataFloat(c4, bombExplosion);
	SetEntDataFloat(c4, bombExplosion, blowTime + 30.0);
}

public bool Chaos_ExtendC4Timer_Conditions(bool EffetRunRandomly){
	if(!g_bBombPlanted || bombExplosion == -1) return false;
	return true;
}