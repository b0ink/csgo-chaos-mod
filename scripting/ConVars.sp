ConVar 	g_cvChaosEnabled;
bool        g_bChaos_Enabled = true;

ConVar 	g_cvChaosEffectInterval;
float       g_fChaos_EffectInterval = 15.0;

ConVar 	g_cvChaosRepeating;
bool        g_bChaos_Repeating = true;

ConVar 	g_cvChaosOverrideDuration;
float       g_fChaos_OverwriteDuration = -1.0;




void CreateConVars(){
    CreateConVar("csgo_chaos_mod_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);

    g_cvChaosEnabled = CreateConVar("sm_chaos_enabled", "1", "Sets whether the Chaos plugin is enabled", _, true, 0.0, true, 1.0);
    g_cvChaosEffectInterval = CreateConVar("sm_chaos_interval", "15.0", "Sets the interval for Chaos effects to run", _, true, 5.0, true, 60.0);
    g_cvChaosRepeating = CreateConVar("sm_chaos_repeating", "1", "Sets whether effects will continue to spawn after the first one of the round", _, true, 0.0, true, 1.0);
    g_cvChaosOverrideDuration = CreateConVar("sm_chaos_override_duration", "-1", "Sets the duration for ALL effects, use -1 to use Chaos_Effects.cfg durations, use 0.0 for no expiration.", _, true, -1.0, true, 120.0);

    HookConVarChange(g_cvChaosEnabled, 				ConVarChanged);
    HookConVarChange(g_cvChaosEffectInterval, 		ConVarChanged);
    HookConVarChange(g_cvChaosRepeating, 			ConVarChanged);
    HookConVarChange(g_cvChaosOverrideDuration, 	ConVarChanged);
}

void UpdateCvars(){
	g_bChaos_Enabled = g_cvChaosEnabled.BoolValue;
	g_fChaos_EffectInterval = g_cvChaosEffectInterval.FloatValue;
	g_bChaos_Repeating = g_cvChaosRepeating.BoolValue;
	g_fChaos_OverwriteDuration = g_cvChaosOverrideDuration.FloatValue;
}

// ConVar g_ConVar_Accelerate;
// ConVar g_ConVar_AirAccelerate;

// float Client_Accelerations[MAXPLAYERS+1]= {5.5, ...};
// float Client_AirAccelerations[MAXPLAYERS+1]= {12.0, ...};

void FindConVars(){
	// g_ConVar_Accelerate = FindConVar("sv_accelerate");
	// g_ConVar_AirAccelerate = FindConVar("sv_airaccelerate");

	// int flags = GetConVarFlags(g_ConVar_Accelerate);

	// flags &= ~FCVAR_NOTIFY;
	// flags &= ~FCVAR_REPLICATED;

	// SetConVarFlags( g_ConVar_Accelerate, flags );

	// int flags2 = GetConVarFlags(g_ConVar_AirAccelerate);

	// flags2 &= ~FCVAR_NOTIFY;
	// flags2 &= ~FCVAR_REPLICATED;

	// SetConVarFlags(g_ConVar_AirAccelerate, flags2);
}

// void SetAccelerate(int client){
//     if(g_bNoStrafe || g_bNoForwardBack){
// 	    SetConVarFloat( g_ConVar_Accelerate, Client_Accelerations[client] );
// 	    SetConVarFloat( g_ConVar_AirAccelerate, Client_AirAccelerations[client] );
// 	}
// }

public void ConVarChanged(ConVar convar, char[] oldValue, char[] newValue){
	if(convar == g_cvChaosEnabled){
		if(StringToInt(oldValue) == 0 && StringToInt(newValue) == 1){
			g_bChaos_Enabled = true;
			ChooseEffect(null);
		}else if(StringToInt(newValue) == 0){
			g_bChaos_Enabled = false;
			StopTimer(g_NewEffect_Timer);
		}
	}else if(convar == g_cvChaosEffectInterval){
		g_fChaos_EffectInterval = StringToFloat(newValue);
	}else if(convar == g_cvChaosRepeating){
		if(StringToInt(oldValue) == 1 && StringToInt(newValue) == 0){
			g_bChaos_Repeating = false;
			StopTimer(g_NewEffect_Timer);
		}else if(StringToInt(newValue) == 1){
			g_bChaos_Repeating = true;
		}
	} else if(convar == g_cvChaosOverrideDuration){
		g_fChaos_OverwriteDuration = StringToFloat(newValue); 
	}
}