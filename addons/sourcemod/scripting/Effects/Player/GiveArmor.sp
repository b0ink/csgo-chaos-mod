#pragma semicolon 1

public void Chaos_GiveArmor(EffectData effect) {
	effect.Title = "Give Kevlar";
	effect.HasNoDuration = true;
}

public void Chaos_GiveArmor_START() {
	LoopAlivePlayers(i) {
		if(GetEntProp(i, Prop_Data, "m_ArmorValue") < 100){
			SetEntProp(i, Prop_Data, "m_ArmorValue", 100, 1);
		}
	}
}