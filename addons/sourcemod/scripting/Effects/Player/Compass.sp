#pragma semicolon 1

/*
	Originally made by Popoklopsi
	https://forums.alliedmods.net/showthread.php?p=1920200
*/


Handle CompassTimer = INVALID_HANDLE;
bool PlayerCompass = false;
public void Chaos_Compass(effect_data effect){
	effect.Title = "Player Compass";
	effect.Duration = 30;
}


public void Chaos_Compass_START(){
	PlayerCompass = true;
	StopTimer(CompassTimer);
	CompassTimer = CreateTimer(0.1, Timer_UpdateCompass, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}


public void Chaos_Compass_RESET(bool HasTimerEnded){
	PlayerCompass = false;
	StopTimer(CompassTimer);
}


public Action Timer_UpdateCompass(Handle timer, any data){
	if(!PlayerCompass){
		return Plugin_Stop;
	}

	float clientOrigin[3];
	float searchOrigin[3];


	float vecPoints[3];
	float vecAngles[3];
	float clientAngles[3];

	char directionString[64];

	char textToPrint[64];

	for (int client = 1; client <= MaxClients; client++){
		if (ValidAndAlive(client)){
			int nearest;
			float near;
			float distance;
			GetClientAbsOrigin(client, clientOrigin);

			// Get closest enemy
			for (int search = 1; search <= MaxClients; search++){
				if (IsValidClient(search) && IsPlayerAlive(search) && search != client && (GetClientTeam(client) != GetClientTeam(search))){
					GetClientAbsOrigin(search, searchOrigin);
					distance = GetVectorDistance(clientOrigin, searchOrigin);

					if (near == 0.0){
						near = distance;
						nearest = search;
					}

					if (distance < near){
						near = distance;
						nearest = search;
					}
				}
			}


			if (nearest != 0){
				GetClientAbsOrigin(nearest, searchOrigin);
				GetClientAbsAngles(client, clientAngles);

				// Angles from origin
				MakeVectorFromPoints(clientOrigin, searchOrigin, vecPoints);
				GetVectorAngles(vecPoints, vecAngles);

				float diff = clientAngles[1] - vecAngles[1];

				// Correction
				if (diff < -180){
					diff = 360 + diff;
				}

				if (diff > 180){
					diff = 360 - diff;
				}


				// Determine direction
				if (diff >= -22.5 && diff < 22.5){
					// Up
					Format(directionString, sizeof(directionString), "\xe2\x86\x91");
				}else if (diff >= 22.5 && diff < 67.5){
					// right up
					Format(directionString, sizeof(directionString), "\xe2\x86\x97");
				}else if (diff >= 67.5 && diff < 112.5){
					// right
					Format(directionString, sizeof(directionString), "\xe2\x86\x92");
				}else if (diff >= 112.5 && diff < 157.5){
					// right down
					Format(directionString, sizeof(directionString), "\xe2\x86\x98");
				}else if (diff >= 157.5 || diff < -157.5){
					// down
					Format(directionString, sizeof(directionString), "\xe2\x86\x93");
				}else if (diff >= -157.5 && diff < -112.5){
					// down left
					Format(directionString, sizeof(directionString), "\xe2\x86\x99");
				}else if (diff >= -112.5 && diff < -67.5){
					// left
					Format(directionString, sizeof(directionString), "\xe2\x86\x90");
				}else if (diff >= -67.5 && diff < -22.5){
					// left up
					Format(directionString, sizeof(directionString), "\xe2\x86\x96");
				}


				// Distance to meters
				float dist = near * 0.01905;
				// Distance to feet
				dist = dist * 3.2808399;

				Format(textToPrint, sizeof(textToPrint), "%s\n(%.0f feet)\n%N", directionString, dist, nearest);
				PrintHintText(client, textToPrint);
			}
		}
	}

	return Plugin_Continue;
}