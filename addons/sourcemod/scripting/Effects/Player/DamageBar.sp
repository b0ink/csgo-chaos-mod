#define EFFECTNAME DamageBar

/*
	Thanks to https://github.com/Natanel-Shitrit/Damage-Bar
*/

bool DamageBar = false;

SETUP(effect_data effect){
	effect.Title = "Damage Bar";
	effect.Duration = 30;
}

INIT(){
	HookEvent("player_hurt", Chaos_DamageBar_Event_PlayerHurt);
}

public void Chaos_DamageBar_Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast){
	if(!DamageBar) return;

	int client = GetClientOfUserId(event.GetInt("userid"));
	Protobuf pb;
	pb = view_as<Protobuf>(StartMessageAll("UpdateScreenHealthBar"));

	int health = event.GetInt("health"), damage = event.GetInt("dmg_health");
	float max_health = float(GetEntProp(client, Prop_Data, "m_iMaxHealth"));
	
	pb.SetInt("entidx", client);
	pb.SetFloat("healthratio_old", float(health + damage) / max_health);
	pb.SetFloat("healthratio_new", float(health) / max_health);
	pb.SetInt("style", 0);
	
	EndMessage();
}


START(){
	DamageBar = true;
}

RESET(bool HasTimerEnded){
	DamageBar = false;
}