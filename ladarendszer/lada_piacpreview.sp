

public piacmegtekint(int client, char info[300])
{
	if (g_dropped[client] == 1)
	{
		CPrintToChat(client,"Már nézel egy skint, várj egy kicsit.");
		return Plugin_Stop;
	}
	char str[11][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	char clsname[64];
	char pref[100];
	Format(pref, sizeof(pref), "%s", fegyveridtoname(StringToInt(str[2])));
	int fid2;
	if (StringToInt(str[2]) > 4000)
	{
		fid2 = 35;
	}
	else {
		fid2 = Getweaponidfromname(pref);
	}

	if (fid2 != 35)
	{
		int m_hActiveWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if (m_hActiveWeapon == -1) { return Plugin_Handled; }
		GetEntityClassname(m_hActiveWeapon, clsname, sizeof(clsname));
		int fid			  = Getweaponidfromname(clsname);
		g_dropped[client] = 1;
		ReplaceString(pref, sizeof(pref), "weapon_", "");
	}
	for (int i = 0; i < p_checkcounter[client]; i++)
	{
		if (p_checked[client][i] == StringToInt(str[9]))
		{
			CPrintToChat(client, "%T %T", "Server Name", client, "already checked skin", client);
			return Plugin_Stop;
		}
	}
	p_checked[client][p_checkcounter[client]] = StringToInt(str[9]);
	p_checkcounter[client]++;
	decl String: query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	float idg				= float(StringToInt(str[5]));
	idg						= idg / 100000;
	Handle hPackedSQL = CreateDataPack();
	char asd2[200];
	Format(asd2, sizeof(asd2), "%d|%d", client, fid2);
	WritePackString(hPackedSQL, asd2);
	if (fid2 == 33)
	{
		if(StringToInt(str[8])==8){
			felveszcustomskin(client,StringToInt(str[2]),str[3]);
		}else{
			leveszcustomskin(client,StringToInt(str[2]));
			Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='%d',`%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", StringToInt(str[2]), pref, StringToInt(str[4]), pref, idg, pref, 0, pref, 0, pref, StringToInt(str[7]), v_steam_id);
		}
	}
	else if (fid2 == 35) {
		Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='%d',`ct_group`='%d',`t_glove`='%d',`ct_glove`='%d',`t_float`='%f',`ct_float`='%f' WHERE `steamid`='%s'", StringToInt(str[2]), StringToInt(str[2]), StringToInt(str[4]), StringToInt(str[4]), idg, idg, v_steam_id);
	}
	else {
		if(StringToInt(str[8])==8){
			felveszcustomskin(client,StringToInt(str[2]),str[3]);
		}else{
			leveszcustomskin(client,StringToInt(str[2]));
			Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", pref, StringToInt(str[4]), pref, idg, pref, 0, pref, 0, pref, StringToInt(str[7]), v_steam_id);
		}
	}

	char info[100];
	for (int i = 0; i < 53; i++)
	{
		g_gotskinlasttime[client][i] = 1;
	}
	SQL_TQuery(hDatabase, T_TestKnife, query, hPackedSQL);

	Handle hPackedSQL2 = CreateDataPack();
	Format(asd2, sizeof(asd2), "%d|%d|%d", client, fid2, StringToInt(str[2]));
	WritePackString(hPackedSQL2, asd2);
	CreateTimer(0.6, RemoveSkin2, hPackedSQL2);
	CreateTimer(10.3, RemoveSkin3, hPackedSQL2);
}

public Action:RemoveSkin2(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[200];
	ReadPackString(hPackedSQL, info, sizeof(info));
	char str[3][100];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client				 = StringToInt(str[0]);
	Handle  hPackedSQL2 = CreateDataPack();
	char asd2[200];
	Format(asd2, sizeof(asd2), "%d|%d", client, StringToInt(str[1]));
	WritePackString(hPackedSQL2, asd2);
	g_dropped[client] = 1;
	for (int i = 0; i < 53; i++)
	{
		g_gotskinlasttime[client][i] = 0;
	}
	if (IsValidClient(client))
	{
		char pref[100];
		Format(pref, sizeof(pref), "%s", fegyveridtoname(StringToInt(str[2])));
		int fid = g_fegyvid[client][Getweaponidfromname(pref)];
		ReplaceString(pref, sizeof(pref), "weapon_", "");
		decl String: query[1000];
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		new buffer_len = strlen(steam_id) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);

		if (fid != -1)
		{
			float idg = float(g_Float[client][fid]);
			idg		  = idg / 100000;
			if (StringToInt(str[1]) == 33)
			{
				Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='%d',`%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", g_Weapon[client][fid], pref, g_Skins[client][fid], pref, idg, pref, g_Stattrak[client][fid], pref, g_StattrakCount[client][fid], pref, g_Seed[client][fid], v_steam_id);
			}
			else {
				Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", pref, g_Skins[client][fid], pref, idg, pref, g_Stattrak[client][fid], pref, g_StattrakCount[client][fid], pref, g_Seed[client][fid], v_steam_id);
			}

			if (StringToInt(str[1]) == 35)
			{
				Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='%d',`ct_group`='%d',`t_glove`='%d',`ct_glove`='%d',`t_float`='%f',`ct_float`='%f' WHERE `steamid`='%s'", g_Weapon[client][fid], g_Weapon[client][fid], g_Skins[client][fid], g_Skins[client][fid], idg, idg, v_steam_id);
			}
			SQL_TQuery(hDatabase, T_TestKnife4, query, hPackedSQL2);
		}
		else {
			if (StringToInt(str[1]) == 33)
			{
				Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='%d',`%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", 0, pref, 0, pref, 0, pref, 0, pref, 0, pref, 0, v_steam_id);
			}
			else {
				Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", pref, 0, pref, 0, pref, 0, pref, 0, pref, 0, v_steam_id);
			}

			if (StringToInt(str[1]) == 35)
			{
				Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='%d',`ct_group`='%d',`t_glove`='%d',`ct_glove`='%d',`t_float`='%f',`ct_float`='%f' WHERE `steamid`='%s'", 0, 0, 0, 0, 0, 0, v_steam_id);
			}
			SQL_TQuery(hDatabase, T_TestKnife4, query, hPackedSQL2);
		}
	}
}

public Action:RemoveSkin3(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[200];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[3][100];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client				 = StringToInt(str[0]);
	Handle  hPackedSQL2 = CreateDataPack();
	char asd2[200];
	Format(asd2, sizeof(asd2), "%d|%d", client, StringToInt(str[1]));
	WritePackString(hPackedSQL2, asd2);
	g_dropped[client] = 0;
	for (int i = 0; i < 53; i++)
	{
		g_gotskinlasttime[client][i] = 0;
	}
	if (IsValidClient(client))
	{
		char pref[100];
		Format(pref, sizeof(pref), "%s", fegyveridtoname(StringToInt(str[2])));
		int fid = g_fegyvid[client][Getweaponidfromname(pref)];
		ReplaceString(pref, sizeof(pref), "weapon_", "");
		decl String: query[1000];
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		new buffer_len = strlen(steam_id) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);

		if (fid != -1)
		{
			float idg = float(g_Float[client][fid]);
			idg		  = idg / 100000;
			if (StringToInt(str[1]) == 33)
			{
				if(g_Rare[client][fid]==8){
					felveszcustomskin(client,g_Weapon[client][fid],g_SkinName[client][fid]);
				}else{
					leveszcustomskin(client,g_Weapon[client][fid]);
					Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='%d',`%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", g_Weapon[client][fid], pref, g_Skins[client][fid], pref, idg, pref, g_Stattrak[client][fid], pref, g_StattrakCount[client][fid], pref, g_Seed[client][fid], v_steam_id);
				}
			}
			else {
				if(g_Rare[client][fid]==8){
					felveszcustomskin(client,g_Weapon[client][fid],g_SkinName[client][fid]);
				}else{
					leveszcustomskin(client,g_Weapon[client][fid]);
					Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", pref, g_Skins[client][fid], pref, idg, pref, g_Stattrak[client][fid], pref, g_StattrakCount[client][fid], pref, g_Seed[client][fid], v_steam_id);
				}
			}

			if (StringToInt(str[1]) == 35)
			{
				Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='%d',`ct_group`='%d',`t_glove`='%d',`ct_glove`='%d',`t_float`='%f',`ct_float`='%f' WHERE `steamid`='%s'", g_Weapon[client][fid], g_Weapon[client][fid], g_Skins[client][fid], g_Skins[client][fid], idg, idg, v_steam_id);
			}
			SQL_TQuery(hDatabase, T_TestKnife, query, hPackedSQL2);
		}
		else {
			if (StringToInt(str[1]) == 33)
			{
				leveszcustomskin(client,StringToInt(str[1]));
				Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='%d',`%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", 0, pref, 0, pref, 0, pref, 0, pref, 0, pref, 0, v_steam_id);
			}
			else {
				leveszcustomskin(client,StringToInt(str[1]));
				Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d'  WHERE `steamid`='%s'", pref, 0, pref, 0, pref, 0, pref, 0, pref, 0, v_steam_id);
			}

			if (StringToInt(str[1]) == 35)
			{
				Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='%d',`ct_group`='%d',`t_glove`='%d',`ct_glove`='%d',`t_float`='%f',`ct_float`='%f' WHERE `steamid`='%s'", 0, 0, 0, 0, 0, 0, v_steam_id);
			}
			SQL_TQuery(hDatabase, T_TestKnife, query, hPackedSQL2);
		}
	}
}

public Action:CS_OnCSWeaponDrop(client, weapon)
{
	new String:weapon_name[30];
	GetEntityClassname(weapon, weapon_name, sizeof(weapon_name));
	if (g_dropped[client] == 1)
	{
		return Plugin_Stop;
	}
}