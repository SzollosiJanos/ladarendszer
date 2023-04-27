Command_TestOpen(int client, int szam)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	CaseOpenAnimation(client, szam);
	return Plugin_Handled;
}

public Action:StartOpenTimer(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client = StringToInt(str[0]);
	int	 szam	= StringToInt(str[1]);
	int	 prop	= StringToInt(str[2]);
	char asd2[100];
	Format(asd2, sizeof(asd2), "%d|%d|%d", client, szam, prop);
	Handle hPackedSQL2 = CreateDataPack();
	WritePackString(hPackedSQL2, asd2);
	CPrintToChat(client, "%T %T", "Server Name", client, "Animation ad", client);
	g_isopening[client] = 1;
	g_isporget[client]=1;
	OpenTimers[client]	= CreateTimer(0.1, Timer_OpenCaseAnim, hPackedSQL2, TIMER_REPEAT);
	return Plugin_Continue;
}

public void CaseOpenAnimation(int client, int szam)
{
	if (IsPlayerAlive(client) && (GetEntityFlags(client) & FL_ONGROUND) && !(GetEntityFlags(client) & FL_DUCKING))
	{
		int prop = CreateEntityByName("prop_dynamic_override");
		if (IsValidEntity(prop) && prop != -1)
		{
			float fPos[3], fAng[3];
			GetClientAbsOrigin(client, fPos);
			GetClientEyeAngles(client, fAng);
			DispatchKeyValue(prop, "model", "models/props/crates/csgo_drop_crate_elekcase.mdl");
			ActivateEntity(prop);
			DispatchSpawn(prop);

			fPos[0] = fPos[0] + (50 * (Sine(DegToRad(fAng[0]))));
			fPos[1] = fPos[1] + (50 * (Sine(DegToRad(fAng[1]))));
			fAng[0] = 0.0;
			fAng[1] += 90;

			TeleportEntity(prop, fPos, fAng, NULL_VECTOR);
			ClientCommand(client, "play %s", "ui/panorama/case_drop_01.wav");
			SetVariantString("fall");
			AcceptEntityInput(prop, "SetAnimation");
			AcceptEntityInput(prop, "Enable");

			HookSingleEntityOutput(prop, "OnAnimationDone", Case_OnAnimationDone, true);
			CreateParticleasd2(prop, "explosion_child_smoke_bottom", 10.0);
			CreateTimer(1.5, DelayUnlockSound, client, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(3.0, DelayOpenSound, client, TIMER_FLAG_NO_MAPCHANGE);
			char asd2[100];
			Format(asd2, sizeof(asd2), "%d|%d|%d", client, szam, prop);
			Handle hPackedSQL = CreateDataPack();
			WritePackString(hPackedSQL, asd2);
			CreateTimer(3.0, StartOpenTimer, hPackedSQL);
		}
	}
	else {
		char asd2[100];
		Format(asd2, sizeof(asd2), "%d|%d|-1", client, szam);
		Handle hPackedSQL = CreateDataPack();
		WritePackString(hPackedSQL, asd2);
		CreateTimer(0.1, StartOpenTimer, hPackedSQL);
	}
}

public void Case_OnAnimationDone(const char[] output, int caller, int activator, float delay)
{
	if (IsValidEntity(caller))
	{
		SetVariantString("open");
		AcceptEntityInput(caller, "SetAnimation");
	}
}

public Action:DelayUnlockSound(Handle timer, int client)
{
	ClientCommand(client, "play %s", "music/elekcase/case_unlock.mp3");
}

public Action:DelayOpenSound(Handle timer, int client)
{
	ClientCommand(client, "play %s", "ui/csgo_ui_crate_open.wav");
}

public Action:DelayOpenCase(Handle timer, int prop)
{
	if (IsValidEntity(prop) && prop != -1)
	{
		AcceptEntityInput(prop, "kill");
	}
}

public Action:Timer_OpenCaseAnim(Handle hTimer23, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	char str[3][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int szam   = StringToInt(str[1]);
	int prop   = StringToInt(str[2]);
	if (!IsValidClient(client))
	{
		asd2[client]			= 100;
		pivot[client]		= 0;
		bpivot[client]		= 1;
		allas[client]		= 0;
		g_isporget[client]=0;
		g_isopening[client] = 0;
		OpenTimers[client]	= null;
		KillTimer(hTimer23, true);
	}
	asd2[client] -= 2;
	if (asd2[client] == 99 || asd2[client] == 98)
	{
		g_PlayerStats[client][0]++;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query8, sizeof(query8), "UPDATE lada_stats set openedlada=openedlada+1 where steam_id='%s'", steam_id8);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		int n = g_ladameret[szam];
		int valasztott;
		int rng;
		int maxchance = 0;
		int asd22	  = 0;
		for (int i = 0; i < 50; i++)
		{
			rng = GetRandomRare(szam,client);
			for (int k = 0; k < n; k++)
			{
				if (g_LadaRare[szam][k] == rng)
				{
					maxchance += g_ladaskinchance[szam][k];
				}
			}
			int rng2 = GetRandomInt(0, maxchance);
			int j	 = 0;
			int ok	 = 1;
			while (j < n && ok == 1)
			{
				if (rng > 0)
				{
					if (g_LadaRare[szam][j] == rng)
					{
						asd22 = rng2 - g_ladaskinchance[szam][j];
						if (asd22 <= 0)
						{
							valasztott = j;
							ok		   = 0;
						}
						else {
							rng2 = asd22;
						}
					}
				}
				j++;
			}

			ok = 1;
			j  = 0;
			Format(skinek[client][i], sizeof(skinek[][]), "   %s | %s", fegyveridtonev(g_Ladafegyverid[szam][valasztott]), g_ladaskinnev[szam][valasztott]);
			r[client][i] = rareidtorgbcolor(rng, 1);
			g[client][i] = rareidtorgbcolor(rng, 2);
			b[client][i] = rareidtorgbcolor(rng, 3);
			if (i == 22)
			{
				vid[client] = valasztott;
			}
			maxchance = 0;
		}
	}
	if (asd2[client] == 80 || asd2[client] == 79)
	{
		bpivot[client] = 2;
	}
	else if (asd2[client] == 60 || asd2[client] == 59) {
		bpivot[client] = 3;
	}
	else if (asd2[client] == 50 || asd2[client] == 49) {
		bpivot[client] = 4;
	}
	else if (asd2[client] == 40 || asd2[client] == 39) {
		bpivot[client] = 5;
	}
	else if (asd2[client] == 30 || asd2[client] == 29) {
		bpivot[client] = 7;
	}
	else if (asd2[client] == 20 || asd2[client] == 19) {
		bpivot[client] = 10;
	}
	if (pivot[client] == 0)
	{
		pivot[client] = bpivot[client];
		SetHudTextParams(0.0, 0.40, 5.0, r[client][allas[client] + 1], g[client][allas[client] + 1], b[client][allas[client] + 1], 255, 1, 0, 0, 0);
		ShowHudText(client, 1, skinek[client][allas[client] + 1]);
		SetHudTextParams(0.0, 0.45, 5.0, r[client][allas[client] + 2], g[client][allas[client] + 2], b[client][allas[client] + 2], 255, 1, 0, 0, 0);
		ShowHudText(client, 2, skinek[client][allas[client] + 2]);
		SetHudTextParams(0.0, 0.50, 5.0, r[client][allas[client] + 3], g[client][allas[client] + 3], b[client][allas[client] + 3], 255, 1, 0, 0, 0);
		char szoveg[200];
		Format(szoveg, sizeof(szoveg), "-->%s<--", skinek[client][allas[client] + 3]);
		ReplaceString(szoveg, sizeof(szoveg), "   ", "");
		ShowHudText(client, 3, szoveg);
		SetHudTextParams(0.0, 0.55, 5.0, r[client][allas[client] + 4], g[client][allas[client] + 4], b[client][allas[client] + 4], 255, 1, 0, 0, 0);
		ShowHudText(client, 4, skinek[client][allas[client] + 4]);
		SetHudTextParams(0.0, 0.60, 5.0, r[client][allas[client] + 5], g[client][allas[client] + 5], b[client][allas[client] + 5], 255, 1, 0, 0, 0);
		ShowHudText(client, 5, skinek[client][allas[client] + 5]);
		allas[client]++;
	}
	if (pivot[client] == -1)
	{
		SetHudTextParams(0.0, 0.40, 5.0, r[client][allas[client]], g[client][allas[client]], b[client][allas[client]], 255, 1, 0, 0, 0);
		ShowHudText(client, 1, skinek[client][allas[client]]);
		SetHudTextParams(0.0, 0.45, 5.0, r[client][allas[client] + 1], g[client][allas[client] + 1], b[client][allas[client] + 1], 255, 1, 0, 0, 0);
		ShowHudText(client, 2, skinek[client][allas[client] + 1]);
		SetHudTextParams(0.0, 0.50, 5.0, r[client][allas[client] + 2], g[client][allas[client] + 2], b[client][allas[client] + 2], 255, 1, 0, 0, 0);
		char szoveg[200];
		Format(szoveg, sizeof(szoveg), "-->%s<--", skinek[client][allas[client] + 2]);
		ReplaceString(szoveg, sizeof(szoveg), "   ", "");
		ShowHudText(client, 3, szoveg);
		SetHudTextParams(0.0, 0.55, 5.0, r[client][allas[client] + 3], g[client][allas[client] + 3], b[client][allas[client] + 3], 255, 1, 0, 0, 0);
		ShowHudText(client, 4, skinek[client][allas[client] + 3]);
		SetHudTextParams(0.0, 0.60, 5.0, r[client][allas[client] + 4], g[client][allas[client] + 4], b[client][allas[client] + 4], 255, 1, 0, 0, 0);
		ShowHudText(client, 5, skinek[client][allas[client] + 4]);
		pivot[client]++;
	}
	pivot[client]--;
	if (asd2[client] == 0 || asd2[client] == -1)
	{
		pivot[client]  = -1;
		bpivot[client] = 1;
		char fegyvernevfromid[100];
		Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Ladafegyverid[szam][vid[client]]));
		ShowHintImageHelper(client,g_ladaskinnev[szam][vid[client]],fegyvernevfromid);
	}
	if (asd2[client] == -30 || asd2[client] == -31)
	{
		SetHudTextParams(0.0, 0.40, 5.0, r[client][allas[client]], g[client][allas[client]], b[client][allas[client]], 255, 1, 0, 0, 0);
		ShowHudText(client, 1, " ");
		SetHudTextParams(0.0, 0.45, 5.0, r[client][allas[client] + 1], g[client][allas[client] + 1], b[client][allas[client] + 1], 255, 1, 0, 0, 0);
		ShowHudText(client, 2, " ");
		SetHudTextParams(0.0, 0.50, 5.0, r[client][allas[client] + 2], g[client][allas[client] + 2], b[client][allas[client] + 2], 255, 1, 0, 0, 0);
		char szoveg[200];
		Format(szoveg, sizeof(szoveg), "%s", " ");
		ReplaceString(szoveg, sizeof(szoveg), "   ", "");
		ShowHudText(client, 3, szoveg);
		SetHudTextParams(0.0, 0.55, 5.0, r[client][allas[client] + 3], g[client][allas[client] + 3], b[client][allas[client] + 3], 255, 1, 0, 0, 0);
		ShowHudText(client, 4, " ");
		SetHudTextParams(0.0, 0.60, 5.0, r[client][allas[client] + 4], g[client][allas[client] + 4], b[client][allas[client] + 4], 255, 1, 0, 0, 0);
		ShowHudText(client, 5, " ");

		asd2[client]	   = 100;
		pivot[client]  = 0;
		bpivot[client] = 1;
		allas[client]  = 0;
		int	 idgfloat  = GetRandomKopottsag();
		int	 idgseed   = GetRandomInt(1, 1000);
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		char nev[100];
		GetClientName(client, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		int buffer_len = strlen(nev) * 2 + 1;
		new String: v_nev[buffer_len];
		SQL_EscapeString(hDatabase, nev, v_nev, buffer_len);
		int statt		= GetRandomInt(0, 100);
		int idgstattrak = 0;
		if (statt > 85 && g_LadaRare[szam][vid[client]] != 7)
		{
			idgstattrak = 1;
		}
		char query[1000];
		char idgname[200];
		Format(idgname, sizeof(idgname), "%s", g_ladaskinnev[szam][vid[client]]);
		ReplaceString(idgname, sizeof(idgname), "'", "");
		ReplaceString(idgname, sizeof(idgname), "'", "");
		Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d')", steam_id, v_nev, g_Ladafegyverid[szam][vid[client]], idgname, g_ladaskinid[szam][vid[client]], idgfloat, idgstattrak, idgseed, g_LadaRare[szam][vid[client]]);
		char jjjj[100];
		Format(jjjj, sizeof(jjjj), "%d|%d", client, prop);
		CloseHandle(hPackedSQL);
		Handle hPackedSQL2 = CreateDataPack();
		WritePackString(hPackedSQL2, jjjj);
		SQL_TQuery(hDatabase, T_InsertSkinAnim, query, hPackedSQL2);
		char logto[200];
		Format(logto, sizeof(logto), "Kinyitott egy %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Ladafegyverid[szam][vid[client]]), g_Ladafegyverid[szam][vid[client]], idgname, g_ladaskinid[szam][vid[client]], idgfloat, idgstattrak, idgseed, g_LadaRare[szam][vid[client]]);
		LogToSql(client, logto);
		if (g_LadaRare[szam][vid[client]] == 6)
		{
			g_PlayerStats[client][5]++;
			char query8[1000];
			char steam_id8[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
			Format(query, sizeof(query), "UPDATE lada_stats set opened6=opened6+1 where steam_id='%s'", steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		}
		else {
			g_PlayerStats[client][g_LadaRare[szam][vid[client]]]++;
			char query8[1000];
			char steam_id8[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
			Format(query, sizeof(query), "UPDATE lada_stats set opened%d=opened%d+1 where steam_id='%s'", g_LadaRare[szam][vid[client]], g_LadaRare[szam][vid[client]], steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		}
		g_isopening[client] = 0;
		g_isporget[client]=0;
		OpenTimers[client]	= null;
		ConfirmLadaMainMenu(szam, client);
		KillTimer(hTimer23, true);
	}
}

public Action:Cmd_openanim(int client, int argc)
{
	if (argc < 1)
	{
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		if (g_open[client] == 0)
		{
			char query[1000];
			Format(query, sizeof(query), "INSERT INTO `lada_blockopen`(`steam_id`,`open`) VALUES ('%s',1)", steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			CPrintToChat(client, "%T %T", "Server Name", client, "Animation turned off", client);
			g_open[client] = 1;
		}
		else {
			char query[1000];
			Format(query, sizeof(query), "DELETE FROM `lada_blockopen` where steam_id='%s'", steam_id);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			CPrintToChat(client, "%T %T", "Server Name", client, "Animation turned on", client);
			g_open[client] = 0;
		}
		return Plugin_Handled;
	}
}

Command_TestOpen2(int client)
{
	Handle datapack = CreateDataPack();
	char   asd2[100];
	int	   szam = GetRandomInt(0, maxloadedlada);
	Format(asd2, sizeof(asd2), "%d|%d", client, szam);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, asd2);
	CPrintToChat(client, "%T %T", "Server Name", client, "Animation ad", client);
	g_isopening[client] = 1;
	g_isporget[client]=1;
	OpenTimers[client]	= CreateTimer(0.1, Timer_OpenCaseAnim2, hPackedSQL, TIMER_REPEAT);
}

public Action:Timer_OpenCaseAnim2(Handle hTimer23, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int szam   = StringToInt(str[1]);
	if (!IsValidClient(client))
	{
		asd2[client]			= 100;
		pivot[client]		= 0;
		bpivot[client]		= 1;
		allas[client]		= 0;
		g_isporget[client]=0;
		g_isopening[client] = 0;
		OpenTimers[client]	= null;
		KillTimer(hTimer23, true);
	}
	asd2[client]--;
	if (asd2[client] == 99)
	{
		g_PlayerStats[client][0]++;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query8, sizeof(query8), "UPDATE lada_stats set openedlada=openedlada+1 where steam_id='%s'", steam_id8);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		int n;
		int valasztott;
		int rng;
		int maxchance = 0;
		int asd22	  = 0;
		for (int i = 0; i < 50; i++)
		{
			rng	 = 6;
			szam = GetRandomInt(0, maxloadedlada);
			n	 = g_ladameret[szam];
			if (g_ladarares[szam][5]==0)
			{
				rng = 7;
			}
			for (int k = 0; k < n; k++)
			{
				if (g_LadaRare[szam][k] == rng)
				{
					maxchance += g_ladaskinchance[szam][k];
				}
			}
			int rng2 = GetRandomInt(0, maxchance);
			int j	 = 0;
			int ok	 = 1;
			while (j < n && ok == 1)
			{
				if (rng > 0)
				{
					if (g_LadaRare[szam][j] == rng)
					{
						asd22 = rng2 - g_ladaskinchance[szam][j];
						if (asd22 <= 0)
						{
							valasztott = j;
							ok		   = 0;
						}
						else {
							rng2 = asd22;
						}
					}
				}
				j++;
			}

			ok = 1;
			j  = 0;
			Format(skinek[client][i], sizeof(skinek[][]), "   %s | %s", fegyveridtonev(g_Ladafegyverid[szam][valasztott]), g_ladaskinnev[szam][valasztott]);
			r[client][i] = rareidtorgbcolor(rng, 1);
			g[client][i] = rareidtorgbcolor(rng, 2);
			b[client][i] = rareidtorgbcolor(rng, 3);
			if (i == 43)
			{
				vid[client]	 = valasztott;
				vid2[client] = szam;
			}
			maxchance = 0;
		}
	}
	if (asd2[client] == 80)
	{
		bpivot[client] = 2;
	}
	else if (asd2[client] == 60) {
		bpivot[client] = 3;
	}
	else if (asd2[client] == 50) {
		bpivot[client] = 4;
	}
	else if (asd2[client] == 40) {
		bpivot[client] = 5;
	}
	else if (asd2[client] == 30) {
		bpivot[client] = 7;
	}
	else if (asd2[client] == 20) {
		bpivot[client] = 10;
	}
	if (pivot[client] == 0)
	{
		pivot[client] = bpivot[client];
		SetHudTextParams(0.0, 0.40, 5.0, r[client][allas[client] + 1], g[client][allas[client] + 1], b[client][allas[client] + 1], 255, 1, 0, 0, 0);
		ShowHudText(client, 1, skinek[client][allas[client] + 1]);
		SetHudTextParams(0.0, 0.45, 5.0, r[client][allas[client] + 2], g[client][allas[client] + 2], b[client][allas[client] + 2], 255, 1, 0, 0, 0);
		ShowHudText(client, 2, skinek[client][allas[client] + 2]);
		SetHudTextParams(0.0, 0.50, 5.0, r[client][allas[client] + 3], g[client][allas[client] + 3], b[client][allas[client] + 3], 255, 1, 0, 0, 0);
		char szoveg[200];
		Format(szoveg, sizeof(szoveg), "-->%s<--", skinek[client][allas[client] + 3]);
		ReplaceString(szoveg, sizeof(szoveg), "   ", "");
		ShowHudText(client, 3, szoveg);
		SetHudTextParams(0.0, 0.55, 5.0, r[client][allas[client] + 4], g[client][allas[client] + 4], b[client][allas[client] + 4], 255, 1, 0, 0, 0);
		ShowHudText(client, 4, skinek[client][allas[client] + 4]);
		SetHudTextParams(0.0, 0.60, 5.0, r[client][allas[client] + 5], g[client][allas[client] + 5], b[client][allas[client] + 5], 255, 1, 0, 0, 0);
		ShowHudText(client, 5, skinek[client][allas[client] + 5]);
		allas[client]++;
	}
	if (pivot[client] == -1)
	{
		SetHudTextParams(0.0, 0.40, 5.0, r[client][allas[client]], g[client][allas[client]], b[client][allas[client]], 255, 1, 0, 0, 0);
		ShowHudText(client, 1, skinek[client][allas[client]]);
		SetHudTextParams(0.0, 0.45, 5.0, r[client][allas[client] + 1], g[client][allas[client] + 1], b[client][allas[client] + 1], 255, 1, 0, 0, 0);
		ShowHudText(client, 2, skinek[client][allas[client] + 1]);
		SetHudTextParams(0.0, 0.50, 5.0, r[client][allas[client] + 2], g[client][allas[client] + 2], b[client][allas[client] + 2], 255, 1, 0, 0, 0);
		char szoveg[200];
		Format(szoveg, sizeof(szoveg), "-->%s<--", skinek[client][allas[client] + 2]);
		ReplaceString(szoveg, sizeof(szoveg), "   ", "");
		ShowHudText(client, 3, szoveg);
		SetHudTextParams(0.0, 0.55, 5.0, r[client][allas[client] + 3], g[client][allas[client] + 3], b[client][allas[client] + 3], 255, 1, 0, 0, 0);
		ShowHudText(client, 4, skinek[client][allas[client] + 3]);
		SetHudTextParams(0.0, 0.60, 5.0, r[client][allas[client] + 4], g[client][allas[client] + 4], b[client][allas[client] + 4], 255, 1, 0, 0, 0);
		ShowHudText(client, 5, skinek[client][allas[client] + 4]);
		pivot[client]++;
	}
	pivot[client]--;
	if (asd2[client] == 0)
	{
		pivot[client]  = -1;
		bpivot[client] = 1;
		char fegyvernevfromid[100];
		Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Ladafegyverid[vid2[client]][vid[client]]));
		ShowHintImageHelper(client,g_ladaskinnev[vid2[client]][vid[client]],fegyvernevfromid);
	}
	if (asd2[client] == -30)
	{
		CloseHandle(hPackedSQL);
		asd2[client]	   = 100;
		pivot[client]  = 0;
		bpivot[client] = 1;
		allas[client]  = 0;
		int	 idgfloat  = GetRandomKopottsag();
		int	 idgseed   = GetRandomInt(1, 1000);
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		char nev[100];
		GetClientName(client, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		new buffer_len = strlen(nev) * 2 + 1;
		new String: v_nev[buffer_len];
		SQL_EscapeString(hDatabase, nev, v_nev, buffer_len);
		int statt		= GetRandomInt(0, 100);
		int idgstattrak = 0;
		if (statt > 85 && g_LadaRare[vid2[client]][vid[client]] != 7)
		{
			idgstattrak = 1;
		}
		char query[1000];
		char idgname[200];
		Format(idgname, sizeof(idgname), "%s", g_ladaskinnev[vid2[client]][vid[client]]);
		ReplaceString(idgname, sizeof(idgname), "'", "");
		ReplaceString(idgname, sizeof(idgname), "'", "");
		Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d')", steam_id, v_nev, g_Ladafegyverid[vid2[client]][vid[client]], idgname, g_ladaskinid[vid2[client]][vid[client]], idgfloat, idgstattrak, idgseed, g_LadaRare[vid2[client]][vid[client]]);
		SQL_TQuery(hDatabase, T_InsertSkin, query, client);
		char logto[200];
		Format(logto, sizeof(logto), "Kinyitott egy %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Ladafegyverid[vid2[client]][vid[client]]), g_Ladafegyverid[vid2[client]][vid[client]], idgname, g_ladaskinid[vid2[client]][vid[client]], idgfloat, idgstattrak, idgseed, g_LadaRare[vid2[client]][vid[client]]);
		LogToSql(client, logto);
		if (g_LadaRare[vid2[client]][vid[client]] == 6)
		{
			g_PlayerStats[client][5]++;
			char query8[1000];
			char steam_id8[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
			Format(query8, sizeof(query8), "UPDATE lada_stats set opened6=opened6+1 where steam_id='%s'", steam_id8);
			SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		}
		else {
			g_PlayerStats[client][g_LadaRare[vid2[client]][vid[client]]]++;
			char query8[1000];
			char steam_id8[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
			Format(query8, sizeof(query8), "UPDATE lada_stats set opened%d=opened%d+1 where steam_id='%s'", g_LadaRare[vid2[client]][vid[client]], g_LadaRare[vid2[client]][vid[client]], steam_id8);
			SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
		}
		g_isopening[client] = 0;
		g_isporget[client]=0;
		OpenTimers[client]	= null;
		KillTimer(hTimer23, true);
	}
}

stock CreateParticleasd2(int ent, String:particleType[], Float: time)
{
	if (IsValidEntity(ent) && ent != -1)
	{
		new particle = CreateEntityByName("info_particle_system");

		decl String: name[64];

		if (IsValidEdict(particle) || IsValidEntity(ent))
		{
			new Float:position[3];
			GetEntPropVector(ent, Prop_Send, "m_vecOrigin", position);
			TeleportEntity(particle, position, NULL_VECTOR, NULL_VECTOR);
			GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
			DispatchKeyValue(particle, "targetname", "tf2particle");
			DispatchKeyValue(particle, "parentname", name);
			DispatchKeyValue(particle, "effect_name", particleType);
			DispatchSpawn(particle);
			SetVariantString(name);
			AcceptEntityInput(particle, "SetParent", particle, particle, 0);
			ActivateEntity(particle);
			AcceptEntityInput(particle, "start");
			CreateTimer(time, DeleteParticle, particle);
		}
	}
}

public Action:DeleteParticle(Handle timer, any: particle)
{
	if (IsValidEntity(particle))
	{
		new String: classN[64];
		GetEdictClassname(particle, classN, sizeof(classN));
		if (StrEqual(classN, "info_particle_system", false))
		{
			AcceptEntityInput(particle, "DestroyImmediately");
		}
	}
}

public T_InsertSkinAnim(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client = StringToInt(str[0]);
	int	 prop	= StringToInt(str[1]);
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "SELECT `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_stattrak_count`, `skin_seed`,`id`,`rare` FROM `lada_inv` WHERE `steam_id`='%s' ORDER BY `lada_inv`.`id` DESC", steam_id);
	char jjjj[100];
	Format(jjjj, sizeof(jjjj), "%d|%d", client, prop);
	Handle  hPackedSQL2 = CreateDataPack();
	WritePackString(hPackedSQL2, jjjj);

	SQL_TQuery(hDatabase, T_newskinloadAnim, query, hPackedSQL2);
	return;
}

public T_newskinloadAnim(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int prop   = StringToInt(str[1]);
	if (SQL_FetchRow(hndl))
	{
		g_Weapon[client][g_DB[client]] = SQL_FetchInt(hndl, 0);
		SQL_FetchString(hndl, 1, g_SkinName[client][g_DB[client]], sizeof(g_SkinName[][]));
		g_Skins[client][g_DB[client]]		  = SQL_FetchInt(hndl, 2);
		g_Float[client][g_DB[client]]		  = SQL_FetchInt(hndl, 3);
		g_Stattrak[client][g_DB[client]]	  = SQL_FetchInt(hndl, 4);
		g_StattrakCount[client][g_DB[client]] = SQL_FetchInt(hndl, 5);
		g_Seed[client][g_DB[client]]		  = SQL_FetchInt(hndl, 6);
		g_Id[client][g_DB[client]]			  = SQL_FetchInt(hndl, 7);
		int rarre							  = SQL_FetchInt(hndl, 8);
		g_Rare[client][g_DB[client]]		  = rarre;


		char nev[100];
		GetClientName(client, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		int idgar = getcreditar(g_Weapon[client][g_DB[client]], g_Skins[client][g_DB[client]], g_Float[client][g_DB[client]], g_Stattrak[client][g_DB[client]], client);
		if(idgar>g_hpricemessagehang){
			char buffer[64];
			for(int i=0;i<MAXPLAYERS;i++){
				if(IsValidClient(i)){
					GetClientCookie(i, g_sound, buffer, sizeof(buffer));
					if (StrEqual(buffer,"0")){
						EmitSoundToClient(i,"rab_knife_unbox.mp3");
					}
				}
			}
			SendDiscordMessage(client, g_DB[client], 1);
		}
		if (idgar > g_fpricemessage)
		{
			if (g_Stattrak[client][g_DB[client]] == 1)
			{
				for (int k = 1; k < MAXPLAYERS; k++)
				{
					if (IsValidClient(k))
					{
						CPrintToChat(k, "%T %T %s%s | %s ST  %s %T", "Server Name", k, "case opened", k, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
					}
				}
			}
			else {
				for (int k = 1; k < MAXPLAYERS; k++)
				{
					if (IsValidClient(k))
					{
						CPrintToChat(k, "%T %T %s%s | %s %s %T", "Server Name", k, "case opened", k, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
					}
				}
			}
			if (IsValidEntity(prop) && prop != -1)
			{
				CreateParticleasd2(prop, "c4_train_ground_primary_01", 10.0);
				CreateParticleasd2(prop, "weapon_confetti_omni_cheap", 10.0);
				CreateTimer(2.0, DelayOpenCase2, prop);
			}
		}
		else {
			if (g_Stattrak[client][g_DB[client]] == 1)
			{
				CPrintToChat(client, "%T %T %s%s | %s ST  %s %T", "Server Name", client, "case opened", client, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
			}
			else {
				CPrintToChat(client, "%T %T %s%s | %s %s %T", "Server Name", client, "case opened", client, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]], formatosszeg(idgar),"coin name",client);
			}
			if (IsValidEntity(prop) && prop != -1)
			{
				CreateParticleasd2(prop, "explosion_basic", 10.0);
				CreateTimer(0.1, DelayOpenCase, prop, TIMER_FLAG_NO_MAPCHANGE);
			}
		}

		g_DB[client]++;
	}
}

public Action:DelayOpenCase2(Handle timer, int prop)
{
	if (IsValidEntity(prop) && prop != -1)
	{
		CreateParticleasd2(prop, "explosion_basic", 10.0);
		AcceptEntityInput(prop, "kill");
		CreateTimer(0.1, DelayOpenCase, prop, TIMER_FLAG_NO_MAPCHANGE);
	}
}
