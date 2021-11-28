

/*
	name = "Chicken C4",
	author = "Mitch.",
	description = "CHICKEN C4 WAT.",
	version = PLUGIN_VERSION,
	url = "http://snbx.info/"
*/
//CHICKEN c4
bool g_c4Chicken = false;
bool visibleChicken = true;
public void C4Chicken(){
	if(!g_c4Chicken) return;
	int c4 = -1;
	c4 = FindEntityByClassname(c4, "planted_c4");
	if(c4 != -1) {
		int chicken = CreateEntityByName("chicken");
		if(chicken != -1) {
			// int player = GetClientOfUserId(GetEventInt(event, "userid"));
			float pos[3];
			// GetEntPropVector(player, Prop_Data, "m_vecOrigin", pos);

			GetEntPropVector(c4, Prop_Data, "m_vecOrigin", pos);
			
			TeleportEntity(chicken, pos, NULL_VECTOR, NULL_VECTOR); //NOW MOVED HERE FOR TESTING
			DispatchSpawn(chicken);
			SetEntProp(chicken, Prop_Data, "m_takedamage", 0);
			SetEntProp(chicken, Prop_Send, "m_fEffects", 0);
		

			// TeleportEntity(chicken, pos, NULL_VECTOR, NULL_VECTOR); //USED TO BE HERE
			// pos[2] -= 15.0;
			float origin[3] = {0.0, 0.0, 0.0};
			pos[2] += 15.0;
			TeleportEntity(c4, pos, origin, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(c4, "SetParent", chicken, c4, 0);
			g_c4chickenEnt = chicken;
			if(visibleChicken) {
				// pos[2] += 15.0;
				TeleportEntity(chicken, NULL_VECTOR, NULL_VECTOR, NULL_VECTOR);
			} else {
				SetEntityRenderMode(chicken, RENDER_NONE);
			}
		}
	}
}