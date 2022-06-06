bool g_bC4Chicken = false;
bool g_bVisibleChicken = true;

public void Chaos_C4Chicken_INIT(){
	HookEvent("bomb_planted", Chaos_C4Chicken_Event_BombPlanted);
}
public void Chaos_C4Chicken_START(){
	g_bC4Chicken = true;
}

public Action Chaos_C4Chicken_RESET(bool EndChaos){
	g_bC4Chicken = false;
	RemoveChickens();
	g_iC4ChickenEnt = -1;
}

public bool Chaos_C4Chicken_HasNoDuration(){
	return false;
}

public bool Chaos_C4Chicken_Conditions(){
	if(g_iC4ChickenEnt != -1) return false;
	return true;
}


void C4Chicken(){
	if(!g_bC4Chicken) return;
	int c4 = -1;
	c4 = FindEntityByClassname(c4, "planted_c4");
	if(c4 != -1) {
		int chicken = CreateEntityByName("chicken");
		if(chicken != -1) {
			float pos[3];
			GetEntPropVector(c4, Prop_Data, "m_vecOrigin", pos);
			
			TeleportEntity(chicken, pos, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(chicken);
			SetEntProp(chicken, Prop_Data, "m_takedamage", 0);
			SetEntProp(chicken, Prop_Send, "m_fEffects", 0);

			// pos[2] -= 15.0;
			float origin[3] = {0.0, 0.0, 0.0};
			pos[2] += 15.0;
			TeleportEntity(c4, pos, origin, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(c4, "SetParent", chicken, c4, 0);
			g_iC4ChickenEnt = chicken;
			if(g_bVisibleChicken) {
				// pos[2] += 15.0;
				TeleportEntity(chicken, NULL_VECTOR, NULL_VECTOR, NULL_VECTOR);
			} else {
				SetEntityRenderMode(chicken, RENDER_NONE);
			}
		}
	}
}


public Action Chaos_C4Chicken_Event_BombPlanted(Handle event, char[] name, bool dontBroadcast){
	C4Chicken();
}