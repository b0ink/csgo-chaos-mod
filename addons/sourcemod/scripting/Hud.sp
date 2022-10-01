ArrayList HudData;

enum struct hud_effect_data{
	char name[256];
	int time;
	bool HasNoDuration;
	bool meta;

	bool isMeta(){
		return this.meta;
	}
} 


int g_HudTime = -1;
void HUD_INIT(){
	HudData = new ArrayList(sizeof(hud_effect_data));
}


void HUD_ROUNDEND(){
	HudData.Clear();
}


bool g_HideHud[MAXPLAYERS+1] = {false, ...};

void ResetHud(){
	LoopValidPlayers(i){
		g_HideHud[i] = false;
	}
}
//15 seconds for all times with -1 (healthshots, etc.)

void AddEffectToHud(char[] message, float time = -1.0, bool isMeta){
	hud_effect_data effect;
	Format(effect.name, sizeof(effect.name), "%s", message);

	if(time == -1.0){
		effect.HasNoDuration = true;
		effect.time = 20;
	}else{
		effect.HasNoDuration = false;
		effect.time = RoundToFloor(time);
	}
	effect.meta = isMeta;
	HudData.PushArray(effect);
	PrintTimer(g_HudTime);
}

void RemoveHudByName(char[] EffectName){
	hud_effect_data effect;
	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		if(StrEqual(effect.name, EffectName, false)){
			HudData.Erase(i);
			break;
		}
	}
	PrintTimer(g_HudTime);
}

void PrintEffects(){
	char chunk[2048];
	char chunk_meta[2048];
	int EffectTime = -1;

	hud_effect_data effect;

	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		EffectTime = effect.time;
		int originalTime = EffectTime;
		if(EffectTime > 20) EffectTime = 20;
		int blocks = EffectTime / 3;

		if(effect.isMeta()){
			Format(chunk, sizeof(chunk), "%s\n", chunk);
			Format(chunk_meta, sizeof(chunk), "%s\n%s ", chunk_meta, effect.name);

			// * Assume meta always has duration (120s), ignore check
			for(int g = 1; g <= blocks; g++){
				Format(chunk_meta, sizeof(chunk_meta), "%s▓", chunk_meta);
				// Format(chunk, sizeof(chunk), "%s▌", chunk);
				// Format(chunk, sizeof(chunk), "%s▪", chunk);
				// Format(chunk, sizeof(chunk), "%s⧯", chunk);
			}
		}else{
			if(Meta_IsWhatsHappeningEnabled()) continue;
			
			Format(chunk_meta, sizeof(chunk_meta), "%s\n", chunk_meta);

			Format(chunk, sizeof(chunk), "%s\n%s ", chunk, effect.name);


			if(!effect.HasNoDuration){
				if(originalTime > 120){
					Format(chunk, sizeof(chunk), "%s ∞", chunk);
				}else{
					for(int g = 1; g <= blocks; g++){
						Format(chunk, sizeof(chunk), "%s▓", chunk);
						// Format(chunk, sizeof(chunk), "%s▌", chunk);
						// Format(chunk, sizeof(chunk), "%s▪", chunk);
						// Format(chunk, sizeof(chunk), "%s⧯", chunk);
					}
				}
			}
		}

	}

	LoopValidPlayers(i){
		if(HasMenuOpen(i)) continue;

		//.37 y;
		SetHudTextParams(0.01, 0.42, 1.5, 37, 186, 255, 0, 0, 1.0, 0.0, 0.0);
		if(g_DynamicChannel){
			ShowHudText(i, GetDynamicChannel(1), "%s", chunk);
		}else{
			ShowHudText(i, -1, "%s", chunk);
		}



		SetHudTextParams(0.01, 0.42, 1.5, 252, 227, 0, 0, 0, 1.0, 0.0, 0.0);
		if(g_DynamicChannel){
			ShowHudText(i, GetDynamicChannel(2), "%s", chunk_meta);
		}else{
			ShowHudText(i, -1, "%s", chunk);
		}
	}


	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		EffectTime = effect.time;
		if(EffectTime <= 1){
			HudData.Erase(i);
			i--;
		}
	}
}


void PrintTimer(int time){
	LoopValidPlayers(i){
		if(time > -1){
			if(time <= 3){
				SetHudTextParams(-1.0, 0.06, 1.5, 200, 0, 0, 0, 0, 1.0, 0.0, 0.0);
				if(g_DynamicChannel){
					ShowHudText(i, GetDynamicChannel(3), "New effect in:\n%i", time);
				}else{
					ShowHudText(i, -1, "New effect in:\n%i", time);
				}
				// if(time > 0) EmitSoundToClient(i, SOUND_COUNTDOWN, _, _, SNDLEVEL_RAIDSIREN, _, 0.4);
			}else{
				SetHudTextParams(-1.0, 0.06, 1.5, 200, 0, 220, 0, 0, 1.0, 0.0, 0.0);
				if(g_DynamicChannel){
					ShowHudText(i, GetDynamicChannel(3), "New effect in:\n%i", time);	
				}else{
					ShowHudText(i, -1, "New effect in:\n%i", time);	
				}
	
			}
		}
	}
}


Action Timer_DisplayEffects(Handle timer){
	hud_effect_data effect;
	for(int i = 0; i < HudData.Length; i++){
		HudData.GetArray(i, effect, sizeof(effect));
		effect.time = effect.time - 1;
		HudData.SetArray(i, effect, sizeof(effect));
	}
	PrintEffects();
}


Action Timer_Display(Handle timer = null, int time){
	g_HudTime = time;
	PrintTimer(time);
	if(time > 1 && g_bChaos_Enabled && g_bCanSpawnEffect) CreateTimer(1.0, Timer_Display, time - 1);
}