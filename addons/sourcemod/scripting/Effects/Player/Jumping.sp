bool g_bJumping = false;
Handle g_Jumping_Timer_Repeat = INVALID_HANDLE;

public void Chaos_Jumping_START(){
	StopTimer(g_Jumping_Timer_Repeat);
	g_bJumping = true;
	g_Jumping_Timer_Repeat = CreateTimer(0.3, Timer_ForceJump, _, TIMER_REPEAT);

}

public Action Chaos_Jumping_RESET(bool EndChaos){
	g_bJumping = false;
	StopTimer(g_Jumping_Timer_Repeat);
}

public bool Chaos_Jumping_HasNoDuration(){
	return false;
}

public bool Chaos_Jumping_Conditions(){
	return true;
}

public Action Timer_ForceJump(Handle timer){
	if(g_bJumping){
		for(int i = 0; i <= MaxClients; i++){
			if(ValidAndAlive(i)){
				float vec[3];
				GetEntPropVector(i, Prop_Data, "m_vecVelocity", vec);
				if(vec[2] == 0.0) { //ensure player isnt mid jump or falling down
					vec[0] = 0.0;
					vec[1] = 0.0;
					vec[2] = 300.0;
					SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", vec);
				}
			}
		}
	}else{
		StopTimer(g_Jumping_Timer_Repeat);
	}
}
