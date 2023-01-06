enum FENCE_TYPE {
	FENCE_WIDE,
	FENCE_THIN
};

ArrayList Fences;

enum struct fence_data {
	float location[3];
	float rotation_y;
	bool wide;
}

public void Chaos_FencedOff(effect_data effect){
	effect.Title = "Fenced Off";
	effect.Duration = 60;
}

public void Chaos_FencedOff_INIT(){
	Fences = new ArrayList(sizeof(fence_data));
}

#define FENCEMODEL_A "models/props_c17/fence02a.mdl"
#define FENCEMODEL_B "models/props_c17/fence02b.mdl"

public void Chaos_FencedOff_OnMapStart(){
	PrecacheModel(FENCEMODEL_A, true);
	PrecacheModel(FENCEMODEL_B, true);
	ParseFencesConfig();
}

public void Chaos_FencedOff_START(){
	Fences.Sort(Sort_Random, Sort_Float);

	fence_data fence;

	for(int i = 0; i < Fences.Length; i++){
		Fences.GetArray(i, fence, sizeof(fence));
		if(i < 7){
			SpawnFence(fence);
		}
	}
}


public void Chaos_FencedOff_RESET(){
	char classname[64];
	char targetname[64];
	LoopAllEntities(ent, GetMaxEntities(), classname){
		if(StrEqual(classname, "prop_dynamic") && GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == -1){
			GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));
			if(StrEqual(targetname, "FakeFence", false)){
				RemoveEntity(ent);
			}else{
				continue;
			}	
		}
	}
}

void SpawnFence(fence_data fenceData){
	int fence = CreateFence(FENCE_WIDE);
	float rot[3];
	rot[1] = fenceData.rotation_y;

	if(!fenceData.wide){
		TeleportEntity(fence, fenceData.location, rot, NULL_VECTOR);
		DispatchSpawn(fence);
		return;
	}


	// add small fences side by side, teleport all of them in a straight line, parent, then rotate

	float newLocation[3];

	int fence2 = CreateFence(FENCE_THIN);
	newLocation[1] += 100;
	TeleportEntity(fence2, newLocation, NULL_VECTOR, NULL_VECTOR);
	SetVariantString("!activator");
	AcceptEntityInput(fence2, "SetParent", fence, fence2, 0);
	
	int fence3 = CreateFence(FENCE_THIN);
	newLocation[1] -= 200;
	TeleportEntity(fence3, newLocation, NULL_VECTOR, NULL_VECTOR);
	SetVariantString("!activator");
	AcceptEntityInput(fence3, "SetParent", fence, fence3, 0);

	rot[1] = fenceData.rotation_y;
	TeleportEntity(fence, fenceData.location, rot, NULL_VECTOR);

	TeleportEntity(fence, fenceData.location, rot, NULL_VECTOR);
	DispatchSpawn(fence);
	DispatchSpawn(fence2);
	DispatchSpawn(fence3);
}

int CreateFence(FENCE_TYPE type){
	int fence = CreateEntityByName("prop_dynamic");
	if(type == FENCE_WIDE){
		SetEntityModel(fence, FENCEMODEL_A);
	}else{
		SetEntityModel(fence, FENCEMODEL_B);
	}
	DispatchKeyValue(fence, "StartDisabled", "true");
	DispatchKeyValue(fence, "Solid", "6");
	DispatchKeyValue(fence, "targetname", "FakeFence");
	AcceptEntityInput(fence, "EnableCollision");
	return fence;
}



void ParseFencesConfig(){
	Fences.Clear();
	
	char map[PLATFORM_MAX_PATH];
	GetCurrentMap(map, sizeof(map));

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "data/Chaos/Chaos_Fences.cfg");
	if(!FileExists(path)) return;

	KeyValues kv = new KeyValues("Maps");

	if(!kv.ImportFromFile(path)) return;
	if(!kv.JumpToKey(map)) return;
	if(!kv.GotoFirstSubKey(false)) return;

	do{
		char rawLocation[128];
		char rawLocationSplit[4][128];
		kv.GetString(NULL_STRING, rawLocation, sizeof(rawLocation));
		if(ExplodeString(rawLocation, " ", rawLocationSplit, 4, 128) == 4){
			fence_data fence;

			fence.location[0] = StringToFloat(rawLocationSplit[0]);
			fence.location[1] = StringToFloat(rawLocationSplit[1]);
			fence.location[2] = StringToFloat(rawLocationSplit[2]) - 10.0;
			fence.rotation_y = StringToFloat(rawLocationSplit[3]);

			char key[25];
			kv.GetSectionName(key, sizeof(key));
			if(StrEqual(key, "wide", false)){
				fence.wide = true;
			}

			Fences.PushArray(fence);
		}
		
	} while(kv.GotoNextKey(false));

	delete kv;
}

public bool Chaos_FencedOff_Conditions(){
	if(Fences.Length == 0) return false;
	return true;
}
