#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <multicolors>
#include <cstrike>

#undef REQUIRE_PLUGIN
#include <DynamicChannels>
#define REQUIRE_PLUGIN

#pragma newdecls required
#pragma semicolon 1

#define PLUGIN_DESCRIPTION "Spawn from over 100+ random effects every 15 seconds to ensue chaos towards you and your enemies"
#define PLUGIN_VERSION "0.3.5"

#define TWITCH_ENABLED


public Plugin myinfo = {
	name = "CS:GO Chaos Mod",
	author = "BOINK",
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = "https://github.com/b0ink/csgo-chaos-mod"
};


char 	g_Prefix[64] = "[{lime}CHAOS{default}]";
char 	g_Prefix_HasTimerEnded[] = "<<{darkred}Ended{default}>>";
char 	g_Prefix_MegaChaos[] = "\n<<{orange}C H A O S{default}>>";


#define SOUND_BELL "buttons/bell1.wav"
#define SOUND_COUNTDOWN "ui/beep07.wav"

#define HIDEHUD_CROSSHAIR           (1 << 8)	// Hide crosshairs

#define LoopAllEntities(%1,%2,%3) for(int %1 = 0; %1 < %2;%1++) if(IsValidEntity(%1) && IsValidEdict(%1)) if(GetEdictClassname(%1, %3, 64))
#define LoopAllEffects(%1,%2) for(int %2 = 0; %2 < 999; %2++) if(%2 < ChaosEffects.Length) if(ChaosEffects.GetArray(%2, %1, sizeof(%1)))
#define LoopAllMetaEffects(%1,%2) for(int %2 = 0; %2 < 999; %2++) if(%2 < ChaosEffects.Length) if(ChaosEffects.GetArray(%2, %1, sizeof(%1))) if(%1.IsMetaEffect)
#define LoopAllClients(%1) 		for(int %1 = 1; %1 <= MaxClients; %1++)
#define LoopValidPlayers(%1) 	for(int %1 = 1; %1 <= MaxClients; %1++) if(IsClientInGame(%1) && (GetClientTeam(%1) == CS_TEAM_T || GetClientTeam(%1) == CS_TEAM_CT))
#define LoopAlivePlayers(%1) 	for(int %1 = 1; %1 <= MaxClients; %1++) if(ValidAndAlive(%1))

char g_sWeapons[][64] = {
	"weapon_glock", "weapon_p250", "weapon_fiveseven", "weapon_deagle", "weapon_elite", "weapon_hkp2000", "weapon_tec9", "weapon_nova", "weapon_xm1014", "weapon_sawedoff", "weapon_m249", "weapon_negev", "weapon_mag7", "weapon_mp7", "weapon_ump45", "weapon_p90", "weapon_bizon", "weapon_mp9", "weapon_mac10", "weapon_famas", "weapon_m4a1", "weapon_aug", "weapon_galilar", "weapon_ak47", "weapon_sg556", "weapon_ssg08", "weapon_awp", "weapon_scar20", "weapon_g3sg1",
};

char g_sSkyboxes[][] = {
	"cs_baggage_skybox_", "cs_tibet", "embassy", "italy", "jungle", "office", "sky_cs15_daylight01_hdr", "sky_cs15_daylight02_hdr", "sky_cs15_daylight03_hdr", "sky_cs15_daylight04_hdr", "sky_day02_05", "nukeblank", "sky_venice", "sky_csgo_cloudy01", "sky_csgo_night02", "sky_csgo_night02b", "vertigo", "vertigoblue_hdr", "sky_dust", "vietnam"
};

char mapName[64];

bool 	g_bCanSpawnChickens = true;
bool 	g_bCanSpawnEffect = true;

int 	g_iTotalEffectsRanThisRound = 0; 	// Effects run in current round
int		g_iTotalRoundsThisMap = 0;			// Round count tracker

int		g_iEffectsSinceMeta = 0; 			// Total effects run since the last meta effect
char	g_sPreviousMetaEffect[64] = "";

Handle	g_iChaosRoundTime_Timer = INVALID_HANDLE;
int 	g_iChaosRoundTime = 0;	 			// Starts counting from round start, including freeze time
int 	ChaosMapCount = 0;					// Total effects run in the current map


bool 	g_bMegaChaosIsActive = false;

char 	g_sSelectedChaosEffect[64] = "";
char 	g_sForceCustomEffect[64] = ""; //overrides g_sSelectedChaosEffect
char 	g_sLastPlayedEffect[64] = "";

bool 	g_bPlaySound_Debounce = false;
bool 	g_bDisableRetryEffect = false;


bool 	g_bDynamicChannelsEnabled = false;


effect_data 	Chaos_EffectData_Buffer;
char 			Chaos_EventName_Buffer[64];


Handle 		g_NewEffect_Timer = INVALID_HANDLE;

#include "ConVars.sp"
#include "Effects/Effect.sp"

// Shared by multiple effects
#include "Global/InstantWeaponSwitch.sp"
#include "Global/Fog.sp"
#include "Global/ColorCorrection.sp"
#include "Global/Weather.sp"
#include "Global/Players.sp"
#include "Global/Spawns.sp"


#include "Effects/EffectsList.sp"
#include "Effects/EffectNames.sp"

float BellVolume[MAXPLAYERS+1] = {0.5, ...};


#include "Commands.sp"
#include "Hud.sp"
#include "Configs.sp"
#include "Menu.sp"
#include "Twitch.sp"

#include "Forwards.sp"


public Action Timer_Advertisement(Handle timer){
	CPrintToChatAll("Thanks for playing {lightblue}CS:GO Chaos Mod{default}!\xe2\x80\xa9Visit {orange}csgochaosmod.com {default}to add this mod to your server!");
	return Plugin_Continue;
}

public Action Timer_CreateHostage(Handle timer){
	CreateHostageRescue();
	return Plugin_Continue;
}


Action ChooseEffect(Handle timer = null, bool CustomRun = false){
	if(!CustomRun) g_NewEffect_Timer = INVALID_HANDLE;
	if(!g_bCanSpawnEffect) return Plugin_Continue;
	if(!g_cvChaosEnabled.BoolValue && !CustomRun) return Plugin_Continue;

	char Random_Effect[64] = "-";
	int randomEffect = -1;
	int attempts = 0;
	g_sLastPlayedEffect = "";

	PoolChaosEffects();

	if(g_MapCoordinates == INVALID_HANDLE){
		ParseMapCoordinates("Chaos_Locations");
	}

	bool twitchEffect = false;

	if(g_cvChaosTwitchEnabled.BoolValue && !g_bMegaChaosIsActive && !CustomRun){
		if(Twitch_Votes.Length != 0){
			effect_data effect;
			if(GetEffectData(g_sForceCustomEffect, effect)){
				g_sForceCustomEffect = effect.FunctionName;
				twitchEffect = true;
				
				if(!effect.CanRunEffect()){
					g_sForceCustomEffect = "";
				}
			}else{
				g_sForceCustomEffect = "";
			}

		}
	}
	// effect_data test;
	// LoopAllEffects(test, index){
	// 	if(test.Enabled == false){
	// 		PrintToChatAll("%s is disabled!", test.Title);
	// 	}
	// }

	if(g_sForceCustomEffect[0] != '\0'){ //run from menu, or from twitch list
		// FormatEx(g_sSelectedChaosEffect, sizeof(g_sSelectedChaosEffect), "%s", g_sForceCustomEffect);
		effect_data effect;
		LoopAllEffects(effect, index){
			if(StrEqual(effect.FunctionName, g_sForceCustomEffect, false)){
				effect.Run();
				if(!g_bMegaChaosIsActive && twitchEffect){
					g_iEffectsSinceMeta++;
				}
				break;
			}
		}
	}else{ // running random effect!
		effect_data effect;
		int totalEffects = ChaosEffects.Length;
	
		while(g_sLastPlayedEffect[0] == '\0'){ // no longer
			attempts++;
			do{
				// randomEffect = GetRandomInt(0, totalEffects - 1);
				randomEffect = GetURandomInt() % totalEffects;

				ChaosEffects.GetArray(randomEffect, effect, sizeof(effect));
				if(
					effect.Enabled &&
					(!Effect_Recently_Played(effect.FunctionName) || CustomRun) &&
					effect.Timer == INVALID_HANDLE &&
					effect.IsCompatible() &&
					!effect.IsMetaEffect &&
					effect.CanRunEffect()
				){
					Random_Effect = effect.FunctionName;
					effect.Run();
					if(!g_bMegaChaosIsActive){ // just in case?
						g_iEffectsSinceMeta++;
					}
					PushArrayString(EffectsHistory, effect.FunctionName);

					float average = float((PossibleChaosEffects.Length / 4) * 3); //idk
					if(GetArraySize(EffectsHistory) > average) RemoveFromArray(EffectsHistory, 0);
				}

			}while(Random_Effect[0] == '\0');

			if(attempts > 900){
				LogError("Clearing effect history");
				ClearArray(EffectsHistory); //fail safe
				break;
			}
		}
	}

	LogEffect(g_sLastPlayedEffect);

	PrintEffects();
	g_sForceCustomEffect  = "";
	if(g_bPlaySound_Debounce == false){
		//Prevent overlapping sounds
		g_bPlaySound_Debounce = true;
		LoopValidPlayers(i){
			EmitSoundToClient(i, SOUND_BELL, _, _, SNDLEVEL_RAIDSIREN, _, BellVolume[i]);
		}	
		CreateTimer(0.2, Timer_ResetPlaySound);
	}

	if(CustomRun) return Plugin_Continue;


	if(!CustomRun &&  ((g_iTotalRoundsThisMap >= 5 || !GameModeUsesC4()) && (GetURandomInt() % 100) <= 40 && g_iEffectsSinceMeta >= 20 && g_iChaosRoundTime < 30)){
		g_iEffectsSinceMeta = 0;
		g_iTotalRoundsThisMap = 0; // at minimum space out meta every 5 rounds

		effect_data metaEffect;
		bool metaAlreadyRunning = false;
		PossibleMetaEffects.Clear();
		LoopAllMetaEffects(metaEffect, index){
			// PrintToChatAll("%s s", metaEffect.Title);
			if(metaEffect.CanRunEffect() && metaEffect.Enabled){
				if(g_sPreviousMetaEffect[0] != '\0'){
					if(StrEqual(metaEffect.FunctionName, g_sPreviousMetaEffect)){
						continue;
					}
				}
				PossibleMetaEffects.PushArray(metaEffect, sizeof(metaEffect));
			}
			if(metaEffect.Timer != INVALID_HANDLE){
				metaAlreadyRunning = true;
			}
		}

		//TODO: have a fixed array of meta effects and scramble them, go through all effects, then rescramble

		if(!metaAlreadyRunning && PossibleMetaEffects.Length > 0) {
			// int random = GetRandomInt(0, PossibleMetaEffects.Length - 1);
			int random = GetURandomInt() % PossibleMetaEffects.Length;
			PossibleMetaEffects.GetArray(random, metaEffect, sizeof(metaEffect));
			g_sForceCustomEffect = metaEffect.FunctionName;
			g_sPreviousMetaEffect = g_sForceCustomEffect;
			MetaEffectsHistory.PushArray(metaEffect);
			ChooseEffect(null, true);
		}
		// History too full, clear it to allow old ones to be spawned.
		if(MetaEffectsHistory.Length > PossibleMetaEffects.Length - 1){
			MetaEffectsHistory.Clear();
		}

	}


	StopTimer(g_NewEffect_Timer);

	if(g_cvChaosRepeating.BoolValue){
		if(g_cvChaosTwitchEnabled.BoolValue){
			Twitch_PoolNewVotingEffects(); // pull 4 effects, this WILL add them into the effect cooldown.
			expectedTimeForNewEffect = GetTime() + g_ChaosEffectInterval + 2;
			CreateTimer(2.0, Timer_DelayNewInterval);
		}else{
			g_NewEffect_Timer = CreateTimer(float(g_ChaosEffectInterval), ChooseEffect);
			expectedTimeForNewEffect =  GetTime() + g_ChaosEffectInterval;
			if(g_bDynamicChannelsEnabled){
				Timer_Display(null, g_ChaosEffectInterval);
			}
		}


		g_iTotalEffectsRanThisRound++;
	}
	return Plugin_Continue;
}

public Action Timer_DelayNewInterval(Handle timer){
	StopTimer(g_NewEffect_Timer);
	g_NewEffect_Timer = CreateTimer(float(g_ChaosEffectInterval), ChooseEffect);
	if(g_bDynamicChannelsEnabled){
		Timer_Display(null, g_ChaosEffectInterval);
	}
	return Plugin_Stop;
}

public Action Timer_ResetPlaySound(Handle timer){
	g_bPlaySound_Debounce = false;
	return Plugin_Continue;
}

//Used if there's no map data found for the map that renders the event useless
//TODO: to be removed, some like AutoPlant still rely on it as its difficult to make those checks
public void RetryEffect(){
	Log("RETRYING EVENT..");
	if(g_bDisableRetryEffect){
		Log("Retries are currently disabled.");
		return;
	}
	StopTimer(g_NewEffect_Timer);
	g_sForceCustomEffect = "";
	g_sSelectedChaosEffect = "";
	ChooseEffect(INVALID_HANDLE);
}

public Action ResetRoundChaos(Handle timer){
	RemoveChickens(false);
	Fog_OFF();

	effect_data effect;
	LoopAllEffects(effect, index){
		effect.Reset(effect.Timer != INVALID_HANDLE);
	}
	return Plugin_Continue;
}


#include "Events.sp"
#include "Helpers.sp"