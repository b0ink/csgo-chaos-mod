float g_Earthquake_Duration = 7.0;
public void Chaos_Earthquake_START(){
	LoopAlivePlayers(i){
		ScreenShake(i, _, g_Earthquake_Duration);
	}
}

public Action Chaos_Earthquake_RESET(bool HasTimerEnded){

}


public bool Chaos_Earthquake_HasNoDuration(){
	return true;
}

public bool Chaos_Earthquake_Conditions(){
	return true;
}