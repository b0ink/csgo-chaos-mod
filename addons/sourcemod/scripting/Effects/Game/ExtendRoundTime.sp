public void Chaos_ExtendRoundTime(effect_data effect){
	effect.Title = "Extend Round Time";
	effect.HasNoDuration = true;	
}

public void Chaos_ExtendRoundTime_START(){
    GameRules_SetProp("m_iRoundTime", GameRules_GetProp("m_iRoundTime", 4, 0) + 60, 4, 0, true);
}