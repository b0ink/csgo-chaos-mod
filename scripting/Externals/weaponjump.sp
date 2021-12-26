bool g_bTaserRound = false;
float g_fTaserKnockback = -1000.0; 

/* Knockback weapon property                                                 */
#define C_WEAPON_PROPERTY_KNOCKBACK     (0)
/* Velocity weapon property                                                  */
#define C_WEAPON_PROPERTY_VELOCITY      (1)
/* Ground weapon property                                                    */
#define C_WEAPON_PROPERTY_GROUND        (2)
/* Maximum weapon property                                                   */
#define C_WEAPON_PROPERTY_MAXIMUM       (3)

/* Players weapon jump                                                       */
bool gl_bPlayerWeaponJump        [MAXPLAYERS + 1];
/* Players weapon jump velocity                                              */
float     gl_vPlayerWeaponJumpVelocity[MAXPLAYERS + 1][3];

public void WeaponJumpDisconnect_Handler(int iClient){
   // Initialize the client data
    gl_bPlayerWeaponJump        [iClient]    = false;
    gl_vPlayerWeaponJumpVelocity[iClient][0] = 0.0;
    gl_vPlayerWeaponJumpVelocity[iClient][1] = 0.0;
    gl_vPlayerWeaponJumpVelocity[iClient][2] = 0.0;
}
public void WeaponJumpConnect_Handler(int iClient){
	// Initialize the client data
	SDKHook(iClient, SDKHook_PostThinkPost, OnPlayerPostThinkPost);
	gl_bPlayerWeaponJump        [iClient]    = false;
	gl_vPlayerWeaponJumpVelocity[iClient][0] = 0.0;
	gl_vPlayerWeaponJumpVelocity[iClient][1] = 0.0;
	gl_vPlayerWeaponJumpVelocity[iClient][2] = 0.0;
}


// public void OnWeaponFirePost(Event hEvent, const char[] szName, bool g_bbDontBroadcast)
public void weaponJump(int client, char[] szWeaponName){
	int iPlayer = client;
	// int iPlayer = GetClientOfUserId(hEvent.GetInt("userid"));
	if(IsValidClient(iPlayer)){
        int iWeapon = GetEntPropEnt(iPlayer, Prop_Send, "m_hActiveWeapon");
        if (GetEntProp(iWeapon, Prop_Send, "m_iClip1") > 0){

			if(StrContains(szWeaponName, "taser") != -1 && g_bTaserRound){
					float flKnockback = g_fTaserKnockback;
					// float flKnockback = -750.0;
					float flVelocity = 0.0;
					bool g_bGround = true;
                    // Check if the player can weapon jump on ground
					if (!(GetEntityFlags(iPlayer) & FL_ONGROUND) || g_bGround){
						float vPlayerVelocity[3];
						float vPlayerEyeAngles[3];
						float vPlayerForward[3];

						// Get the player velocity
						GetEntPropVector(iPlayer, Prop_Data, "m_vecVelocity", vPlayerVelocity);

						// Get the player forward direction
						GetClientEyeAngles(iPlayer, vPlayerEyeAngles);
						GetAngleVectors(vPlayerEyeAngles, vPlayerForward, NULL_VECTOR, NULL_VECTOR);

						// Compute the player weapon jump velocity
						gl_vPlayerWeaponJumpVelocity[iPlayer][0] = vPlayerVelocity[0] * flVelocity - vPlayerForward[0] * flKnockback;
						gl_vPlayerWeaponJumpVelocity[iPlayer][1] = vPlayerVelocity[1] * flVelocity - vPlayerForward[1] * flKnockback;
						gl_vPlayerWeaponJumpVelocity[iPlayer][2] = vPlayerVelocity[2] * flVelocity - vPlayerForward[2] * flKnockback;

						// Set the player weapon jump
						gl_bPlayerWeaponJump[iPlayer] = true;
					}
                }
			}
		}

}

public void OnPlayerPostThinkPost(int iPlayer){
    if (gl_bPlayerWeaponJump[iPlayer]){
        if (IsPlayerAlive(iPlayer)){
            TeleportEntity(iPlayer, NULL_VECTOR, NULL_VECTOR, gl_vPlayerWeaponJumpVelocity[iPlayer]);
        }
        gl_bPlayerWeaponJump[iPlayer] = false;
    }
}
