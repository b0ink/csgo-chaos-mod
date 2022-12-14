#define EFFECTNAME NoScopeOnly

bool g_bNoscopeOnly = false;
int m_flNextSecondaryAttack = -1;

SETUP(effect_data effect){
	effect.Title = "No Scopes Only";
	effect.Duration = 30;
}

INIT(){
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
}


stock void SetNoScope(int weapon){
	if (IsValidEdict(weapon) && g_bNoscopeOnly){
		char classname[MAX_NAME_LENGTH];
		GetEdictClassname(weapon, classname, sizeof(classname));
		
		if (StrEqual(classname[7], "ssg08") || StrEqual(classname[7], "aug") || StrEqual(classname[7], "sg550") || StrEqual(classname[7], "sg552") || StrEqual(classname[7], "sg556") || StrEqual(classname[7], "awp") || StrEqual(classname[7], "scar20") || StrEqual(classname[7], "g3sg1"))
			SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 2.0);
	}
}

public Action Chaos_NoScopeOnly_Hook_OnPreThink(int client){
	int iWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	SetNoScope(iWeapon);
	return Plugin_Continue;
}

START(){
	
	LoopAlivePlayers(i){
		SDKHook(i, SDKHook_PreThink, Chaos_NoScopeOnly_Hook_OnPreThink);
	}

	g_bNoscopeOnly = true;
	LoopAlivePlayers(client){
		// If already scoping, switch weapon to exit scope, perhaps theres a better way TODO this
		if(GetEntProp(client, Prop_Send, "m_bIsScoped")){
			FakeClientCommand(client, "use weapon_knife");
			ClientCommand(client, "slot2;slot1");
		}
	}
}


RESET(bool HasTimerEnded){
	LoopAllClients(i){
		SDKUnhook(i, SDKHook_PreThink, Chaos_NoScopeOnly_Hook_OnPreThink);
	}
	g_bNoscopeOnly = false;
}

public void Chaos_NoScopeOnly_OnPlayerSpawn(int client, bool EffectIsRunning){
	if(EffectIsRunning){
		SDKHook(client, SDKHook_PreThink, Chaos_NoScopeOnly_Hook_OnPreThink);
	}
}