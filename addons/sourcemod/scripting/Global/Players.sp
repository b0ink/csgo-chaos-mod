//TODO: Similar to how Fog.sp's Fog_Stream Queue is handled, the same should be done to player data, eg:
/*
	enum struct player_data{
		float speed;
		float gravity;
		float airacceleration; https://forums.alliedmods.net/showthread.php?t=121739
		https://github.com/JoinedSenses/SM-Air-Accelerate-Control/blob/main/scripting/airaccel_control.sp
		float FOV
		..
	}
*/



enum struct player_data{
	float speed;
	float gravity;
	float airacceleration;
	float FOV;
	
	float Disable_LEFT;
	float Disable_RIGHT;
	float Disable_FORWARD;
	float Disable_BACK;

}