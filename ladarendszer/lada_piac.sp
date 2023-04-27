

public showpiac(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[100];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client, formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	menu.DrawItem("Vásárlás");
	menu.DrawItem("Eladás");
	menu.DrawItem("Saját tárgyak");
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_PiacMain, 60);
	delete menu;
}

public int T_PiacMain(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if (item == 1)
		{
			char query[255];
			char steamid[32];
			GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
			Format(query, sizeof(query), "SELECT steam_id,credit,fegyver_id,skin_name,skin_id,skin_float,skin_stattrak,skin_seed,rare,id FROM lada_piac WHERE steam_id != '%s' %s %s %s", steamid, p_osszesitettw[client], p_osszesitettw2[client], p_osszesitett[client]);
			SQL_TQuery(hDatabase, PiacVasar, query, client);
		}
		else if (item == 2) {
			Menu menu = CreateMenu(T_PiacEladSelected);
			menu.SetTitle("Válassz tárgyat");
			char asd2[1000];
			char inf[1000];
			for (int i = g_DB[client] - 1; i > 0; i--)
			{
				float idg = float(g_Float[client][i]);
				idg		  = idg / 100000;
				Format(asd2, sizeof(asd2), "%d|%s|%d|%d|%d|%d|%d|%d|%d|%d", g_Weapon[client][i], g_SkinName[client][i], g_Skins[client][i], g_Float[client][i], g_Stattrak[client][i], g_Seed[client][i], g_Rare[client][i], g_Id[client][i], i, g_StattrakCount[client][i]);
				if (g_Stattrak[client][i] == 1)
				{
					Format(inf, sizeof(inf), "%s%s %s ST\nfloat:%.5f seed: %d", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], idg, g_Seed[client][i]);
				}
				else {
					Format(inf, sizeof(inf), "%s%s %s\nfloat:%.5f seed: %d", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], idg, g_Seed[client][i]);
				}
				menu.AddItem(asd2, inf);
			}
			menu.Display(client, 60);
		}
		else if (item == 3) {
			char query[255];
			char steamid[32];
			GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid), true);
			Format(query, sizeof(query), "SELECT steam_id,credit,fegyver_id,skin_name,skin_id,skin_float,skin_stattrak,skin_seed,rare,id,skin_stattrak_count FROM lada_piac WHERE steam_id = '%s'", steamid);
			SQL_TQuery(hDatabase, PiacSajat, query, client);
		}
		else {
			showegyeb(client);
		}
	}
}

public PiacSajat(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	int	 i_credit, i_fegyver_id, i_skin_id, i_skin_float, i_skin_stattrak, i_skin_seed, i_rarre, i_id, i_skin_stattrak_count;
	char i_skin_name[200];
	char steam_id[32];
	char asd2[1000];
	char inf[1000];
	Menu menu = CreateMenu(T_PiacSajatSelected);
	menu.SetTitle("Válassz tárgyat");
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, steam_id, sizeof(steam_id));
		i_credit	 = SQL_FetchInt(hndl, 1);
		i_fegyver_id = SQL_FetchInt(hndl, 2);
		SQL_FetchString(hndl, 3, i_skin_name, sizeof(i_skin_name));
		i_skin_id			  = SQL_FetchInt(hndl, 4);
		i_skin_float		  = SQL_FetchInt(hndl, 5);
		i_skin_stattrak		  = SQL_FetchInt(hndl, 6);
		i_skin_seed			  = SQL_FetchInt(hndl, 7);
		i_rarre				  = SQL_FetchInt(hndl, 8);
		i_id				  = SQL_FetchInt(hndl, 9);
		i_skin_stattrak_count = SQL_FetchInt(hndl, 10);
		float idg			  = float(i_skin_float);
		idg					  = idg / 100000;
		Format(asd2, sizeof(asd2), "%s|%d|%d|%s|%d|%d|%d|%d|%d|%d|%d|%d", steam_id, i_credit, i_fegyver_id, i_skin_name, i_skin_id, i_skin_float, i_skin_stattrak, i_skin_seed, i_rarre, i_id, i_skin_stattrak_count, client);
		if (i_skin_stattrak == 1)
		{
			Format(inf, sizeof(inf), "%s%s %s ST\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, i_rarre), fegyveridtonev(i_fegyver_id), i_skin_name, idg, i_skin_seed, "coin name", client, formatosszeg(i_credit));
		}
		else {
			Format(inf, sizeof(inf), "%s%s %s\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, i_rarre), fegyveridtonev(i_fegyver_id), i_skin_name, idg, i_skin_seed, "coin name", client, formatosszeg(i_credit));
		}
		menu.AddItem(asd2, inf);
	}
	menu.Display(client, 60);
	return;
}

public int T_PiacSajatSelected(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		char str[12][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		char  szoveg[300];
		float idg = float(StringToInt(str[5]));
		idg		  = idg / 100000;
		if (StringToInt(str[6]) == 1)
		{
			Format(szoveg, sizeof(szoveg), "%s%s %s ST\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(str[8])), fegyveridtonev(StringToInt(str[2])), str[3], idg, StringToInt(str[7]), "coin name", client,formatosszeg(StringToInt(str[1])));
		}
		else {
			Format(szoveg, sizeof(szoveg), "%s%s %s\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(str[8])), fegyveridtonev(StringToInt(str[2])), str[3], idg, StringToInt(str[7]), "coin name", client, formatosszeg(StringToInt(str[1])));
		}
		if(g_isporget[client]==1){
			CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
			return Plugin_Handled;
		}
		Menu menu = CreateMenu(T_ConfirmSajatBuy);
		menu.SetTitle("Biztos le szeretnéd venni a piacról?");
		menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
		menu.AddItem(info, "Igen");
		menu.AddItem("-1", "Nem");
		menu.Display(client, 60);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int T_ConfirmSajatBuy(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		char str[12][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		if (StrEqual(info, "-1")) { showpiac(client); }
		else {
			Handle  hPackedSQL = CreateDataPack();
			WritePackString(hPackedSQL, info);
			char query[1000];
			Format(query, sizeof(query), "Select credit from `lada_piac` where `id`='%d'", StringToInt(str[9]));
			SQL_TQuery(hDatabase, T_CheckPiacSkinVasar, query, hPackedSQL);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public T_CheckPiacSkinVasar(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	ResetPack(hPackedSQL);
	new String: info[300];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[12][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[11]);
	if (SQL_FetchRow(hndl))
	{
		char query[1000];
		Format(query, sizeof(query), "DELETE FROM `lada_piac` where id='%d'", StringToInt(str[9]));
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		CPrintToChat(client, "%T %T", "Server Name", client, "market sell cancelled", client);
		char logto[200];
		Format(logto, sizeof(logto), "Piac levétel(%d): %s(%d) %s(%d) f:%d st:%d s:%d r:%d", StringToInt(str[1]), fegyveridtonev(StringToInt(str[2])), StringToInt(str[2]), str[3], StringToInt(str[4]), StringToInt(str[5]), StringToInt(str[6]), StringToInt(str[7]), StringToInt(str[8]));
		LogToSql(client, logto);
		g_sTargetCredit[client] = StringToInt(str[1]);
		char nev[100];
		GetClientName(client, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		new buffer_len = strlen(nev) * 2 + 1;
		new String: v_nev[buffer_len];
		SQL_EscapeString(hDatabase, nev, v_nev, buffer_len);
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		buffer_len = strlen(steam_id) * 2 + 1;
		new String: v_steam_id[buffer_len];
		SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
		Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`, `skin_stattrak_count`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d','%d')", v_steam_id, v_nev, StringToInt(str[2]), str[3], StringToInt(str[4]), StringToInt(str[5]), StringToInt(str[6]), StringToInt(str[7]), StringToInt(str[8]), StringToInt(str[10]));
		SQL_TQuery(hDatabase, T_InsertSkin2, query, client);
	}
	else {
		CPrintToChat(client, "%T %T", "Server Name", client, "market already bought", client);
	}
	showpiac(client);
}

public T_InsertSkin2(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "SELECT `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_stattrak_count`, `skin_seed`,`id`,`rare` FROM `lada_inv` WHERE `steam_id`='%s' ORDER BY `lada_inv`.`id` DESC", steam_id);
	SQL_TQuery(hDatabase, T_newskinload2, query, client);
	return;
}

public T_newskinload2(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
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
		
		
		char fegyvernevfromid[100];
		Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Weapon[client][g_DB[client]]));
		ShowHintImageHelper(client,g_SkinName[client][g_DB[client]],fegyvernevfromid);
		int r, g, b;
		
		if (getcreditar(g_Weapon[client][g_DB[client]], g_Skins[client][g_DB[client]], g_Float[client][g_DB[client]], g_Stattrak[client][g_DB[client]], client) > g_fpricemessagehang)
		{
			SendDiscordMessage(client, g_DB[client], 2);
		}
		r = rareidtorgbcolor(rarre, 1);
		g = rareidtorgbcolor(rarre, 2);
		b = rareidtorgbcolor(rarre, 3);
		if (g_Stattrak[client][g_DB[client]] == 1)
		{
			SetHudTextParams(-1.0, 0.25, 10.0, r, g, b, 255, 5, 0, 0, 0);
			new String: Buffer[2146];
			Format(Buffer, sizeof(Buffer), "%s%s | %s ST", rareidtostart(client, g_Rare[client][g_DB[client]]), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]]);
			ShowHudText(client, -1, Buffer);
		}
		else {
			SetHudTextParams(-1.0, 0.25, 10.0, r, g, b, 255, 5, 0, 0, 0);
			new String: Buffer[2146];
			Format(Buffer, sizeof(Buffer), "%s%s | %s", rareidtostart(client, g_Rare[client][g_DB[client]]), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]]);
			ShowHudText(client, -1, Buffer);
		}

		g_DB[client]++;
	}
}

public int T_PiacEladSelected(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		char str[10][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		for (int k = 0; k < 10; k++)
		{
			Format(piacadat[client][k], sizeof(piacadat[][]), "%s", str[k]);
		}
		char asd2[100];
		Format(asd2, sizeof(asd2), "%T", "coin name", client);
		CPrintToChat(client, "%T %T", "Server Name", client, "market coin", client, asd2);

		g_bAwaitingCredit[client] = true;
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int PiacEladConfirm(int client)
{
	Menu menu = CreateMenu(T_ConfirmPiaceladas);
	menu.SetTitle("Biztos el szeretnéd adni?");
	char  szoveg[300];
	float idg = float(StringToInt(piacadat[client][3]));
	idg		  = idg / 100000;
	if (StringToInt(piacadat[client][4]) == 1)
	{
		Format(szoveg, sizeof(szoveg), "%s%s %s ST\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(piacadat[client][6])), fegyveridtonev(StringToInt(piacadat[client][0])), piacadat[client][1], idg, StringToInt(piacadat[client][5]), "coin name", client,formatosszeg(g_sTargetCredit[client]));
	}
	else {
		Format(szoveg, sizeof(szoveg), "%s%s %s\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(piacadat[client][6])), fegyveridtonev(StringToInt(piacadat[client][0])), piacadat[client][1], idg, StringToInt(piacadat[client][5]), "coin name", client, formatosszeg(g_sTargetCredit[client]));
	}
	menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
	menu.AddItem(piacadat[client][8], "Igen");
	menu.AddItem("-1", "Nem");
	menu.Display(client, 60);
}

public int T_ConfirmPiaceladas(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		if (StrEqual(info, "-1"))
		{
			showpiac(client);
		}
		else {
			int	 i = StringToInt(info);

			char asd2[1000];
			Format(asd2, sizeof(asd2), "%T", "coin name", client);
			char osszeg[50];
			Format(osszeg, sizeof(osszeg), "%s", formatosszeg(g_sTargetCredit[client]));
			Format(asd2, sizeof(asd2), "%T", "market sell success", client, osszeg, asd2);
			CPrintToChat(client, "%T %s", "Server Name", client, asd2);

			decl String: query[1000];
			Format(query, sizeof(query), "DELETE FROM `lada_inv` WHERE `id`='%d'", g_Id[client][i]);
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			char nev[100];
			GetClientName(client, nev, sizeof(nev));
				ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
			if (getcreditar(g_Weapon[client][i], g_Skins[client][i], g_Float[client][i], g_Stattrak[client][i], client) > g_fpricemessagehang)
			{
				SendDiscordMessage(client, i, 3);
			}
			if (g_Stattrak[client][i] == 1)
			{
				for (int k = 1; k < MAXPLAYERS; k++)
				{
					if (IsValidClient(k))
					{
						CPrintToChat(k, "%T %T %s%s | %s ST", "Server Name", k, "market sell", k, nev, rareidtocolor(g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i]);
					}
				}
			}
			else {
				for (int k = 1; k < MAXPLAYERS; k++)
				{
					if (IsValidClient(k))
					{
						CPrintToChat(k, "%T %T %s%s | %s", "Server Name", k, "market sell", k, nev, rareidtocolor(g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i]);
					}
				}
			}
			char logto[200];
			Format(logto, sizeof(logto), "Piac elad(%d): %s(%d) %s(%d) f:%d st:%d s:%d r:%d", g_sTargetCredit[client], fegyveridtonev(g_Weapon[client][i]), g_Weapon[client][i], g_SkinName[client][i], g_Skins[client][i], g_Float[client][i], g_Stattrak[client][i], g_Seed[client][i], g_Rare[client][i]);
			LogToSql(client, logto);
			DisableKnife3(client, i);
			Format(query, sizeof(query), "INSERT INTO `lada_piac`(`steam_id`,`credit`,`fegyver_id`,`skin_name`,`skin_id`,`skin_float`,`skin_stattrak`,`skin_stattrak_count`,`skin_seed`,`rare`) VALUES('%s','%d','%d','%s','%d','%d','%d','%d','%d','%d')", v_steam_id, g_sTargetCredit[client], StringToInt(piacadat[client][0]), piacadat[client][1], StringToInt(piacadat[client][2]), StringToInt(piacadat[client][3]), StringToInt(piacadat[client][4]), StringToInt(piacadat[client][9]), StringToInt(piacadat[client][5]), StringToInt(piacadat[client][6]));
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		}
		showpiac(client);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int DisableKnife3(int client, int i)
{
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	decl String: query[2000];
	Format(query, sizeof(query), "UPDATE `lada_inv` SET `skin_last`='0' WHERE `id`='%d'", g_Id[client][i]);
	SQL_TQuery(hDatabase, tolskinek, query, client);
	decl String: fnev[255];
	Format(fnev, sizeof(fnev), "%s", fegyveridtoname(g_Weapon[client][i]));
	ReplaceString(fnev, sizeof(fnev), "weapon_", "");
	int asd2 = Getfegyverid(client, i);
	if (g_fegyvid[client][asd2] == i)
	{
		if (asd2 == 33)
		{
			leveszcustomskin(client,g_Weapon[client][i]);
			Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='0' WHERE `steamid`='%s'", v_steam_id);
		}
		else if (asd2 == 35) {
			Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='0',`ct_group`='0',`t_glove`='0',`ct_glove`='0' WHERE `steamid`='%s'", v_steam_id);
		}
		else {
			leveszcustomskin(client,g_Weapon[client][i]);
			Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='0' WHERE `steamid`='%s'", fnev, v_steam_id);
		}
		Handle  hPackedSQL = CreateDataPack();
		char info[100];
		Format(info, sizeof(info), "%d|%d", client, Getfegyverid(client, i));
		WritePackString(hPackedSQL, info);
		SQL_TQuery(hDatabase, T_TestKnife, query, hPackedSQL);
		
	}
	else {
		restart(client);
	}
	return Plugin_Stop;
}

public tolskinek(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	restart(client);
	return;
}

public PiacVasar(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	int	 i_credit, i_fegyver_id, i_skin_id, i_skin_float, i_skin_stattrak, i_skin_seed, i_rarre, i_id;
	char i_skin_name[200];
	char steam_id[32];
	char asd2[1000];
	char inf[1000];
	Menu menu = CreateMenu(T_PiacVasarSelected);
	menu.SetTitle("Válassz tárgyat");
	while (SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, steam_id, sizeof(steam_id));
		i_credit	 = SQL_FetchInt(hndl, 1);
		i_fegyver_id = SQL_FetchInt(hndl, 2);
		SQL_FetchString(hndl, 3, i_skin_name, sizeof(i_skin_name));
		i_skin_id		= SQL_FetchInt(hndl, 4);
		i_skin_float	= SQL_FetchInt(hndl, 5);
		i_skin_stattrak = SQL_FetchInt(hndl, 6);
		i_skin_seed		= SQL_FetchInt(hndl, 7);
		i_rarre			= SQL_FetchInt(hndl, 8);
		i_id			= SQL_FetchInt(hndl, 9);
		float idg		= float(i_skin_float);
		idg				= idg / 100000;
		Format(asd2, sizeof(asd2), "%s|%d|%d|%s|%d|%d|%d|%d|%d|%d|%d", steam_id, i_credit, i_fegyver_id, i_skin_name, i_skin_id, i_skin_float, i_skin_stattrak, i_skin_seed, i_rarre, i_id, client);
		if (i_skin_stattrak == 1)
		{
			Format(inf, sizeof(inf), "%s%s %s ST\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, i_rarre), fegyveridtonev(i_fegyver_id), i_skin_name, idg, i_skin_seed, "coin name", client, formatosszeg(i_credit));
		}
		else {
			Format(inf, sizeof(inf), "%s%s %s\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, i_rarre), fegyveridtonev(i_fegyver_id), i_skin_name, idg, i_skin_seed, "coin name", client, formatosszeg(i_credit));
		}
		menu.AddItem(asd2, inf);
	}
	menu.Display(client, 60);
	return;
}

public int T_PiacVasarSelected(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		char str[11][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		char  szoveg[1000];
		float idg = float(StringToInt(str[5]));
		idg		  = idg / 100000;
		if (StringToInt(str[6]) == 1)
		{
			Format(szoveg, sizeof(szoveg), "%s%s %s ST\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(str[8])), fegyveridtonev(StringToInt(str[2])), str[3], idg, StringToInt(str[7]), "coin name", client,formatosszeg(StringToInt(str[1])) );
		}
		else {
			Format(szoveg, sizeof(szoveg), "%s%s %s\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(str[8])), fegyveridtonev(StringToInt(str[2])), str[3], idg, StringToInt(str[7]), "coin name", client,formatosszeg(StringToInt(str[1])));
		}

		Menu menu = CreateMenu(T_ConfirmPiacBuy2);
		menu.SetTitle("Mit szeretnél tenni a skinnel?");
		menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
		menu.AddItem(info, "Megvenni");
		char info2[300];
		Format(info2, sizeof(info2), "%s|XD", info);
		Format(szoveg, sizeof(szoveg), "Fegyver megtekintése\nMegtekintés működése:\n1. Szerezz egy megfelelő fegyvert!\n2. Nyomd meg a \"Fegyver megtekintése\" gombot!\n3. Az adott skint 10 másodpercig tudod megtekinteni megvásárlás előtt!\n4. A skin 10 másodperc után eltűnik.\n5. A skint újra csak mapváltás után tudod megtekinteni!");
		menu.AddItem(info2, szoveg);
		menu.Display(client, 60);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int T_ConfirmPiacBuy2(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		char str[12][50];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		char info2[300];
		Format(info2, sizeof(info2), "%s", info);
		ReplaceString(info2, sizeof(info2), "|XD", "");
		if (StrEqual(str[11], "XD"))
		{
			piacmegtekint(client, info2);
		}
		else {
			if(g_isporget[client]==1){
				CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
				return Plugin_Handled;
			}
		
			Menu menu = CreateMenu(T_ConfirmPiacBuy);
			menu.SetTitle("Biztos meg szeretnéd venni?");
			char  szoveg[1000];
			float idg = float(StringToInt(str[5]));
			idg		  = idg / 100000;
			if (StringToInt(str[6]) == 1)
			{
				Format(szoveg, sizeof(szoveg), "%s%s %s ST\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(str[8])), fegyveridtonev(StringToInt(str[2])), str[3], idg, StringToInt(str[7]), "coin name", client, formatosszeg(StringToInt(str[1])));
			}
			else {
				Format(szoveg, sizeof(szoveg), "%s%s %s\nfloat:%.5f seed: %d %T: %s", rareidtostart(client, StringToInt(str[8])), fegyveridtonev(StringToInt(str[2])), str[3], idg, StringToInt(str[7]), "coin name", client, formatosszeg(StringToInt(str[1])));
			}
			menu.AddItem("", szoveg, ITEMDRAW_DISABLED);
			menu.AddItem(info2, "Igen");
			menu.AddItem("-1", "Nem");
			menu.Display(client, 60);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int T_ConfirmPiacBuy(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[300];
		menu.GetItem(item, info, sizeof(info));
		char str[11][50];
		if (StrEqual(info, "-1"))
		{
			showpiac(client);
		}
		else {
			ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
			Handle  hPackedSQL = CreateDataPack();
			WritePackString(hPackedSQL, info);
			char query[1000];
			Format(query, sizeof(query), "Select credit from `lada_piac` where `id`='%d'", StringToInt(str[9]));
			SQL_TQuery(hDatabase, T_CheckPiacSkin, query, hPackedSQL);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public T_CheckPiacSkin(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	ResetPack(hPackedSQL);
	new String: info[300];
	ReadPackString(hPackedSQL, info, sizeof(info));
	char str[11][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[10]);
	if (SQL_FetchRow(hndl))
	{
		if (g_credits[client] < StringToInt(str[1]))
		{
			char asd277[1000];
			Format(asd277, sizeof(asd277), "%T", "coin name", client);
			Format(asd277, sizeof(asd277), "%T", "Not enough coin", client, asd277);
			CPrintToChat(client, "%T %s", "Server Name", client, asd277);
		}
		else {
			char query[1000];
			Format(query, sizeof(query), "DELETE FROM `lada_piac` where id='%d'", StringToInt(str[9]));
			SQL_TQuery(hDatabase, T_TestKnife4, query, client);

			addcredit(client, -StringToInt(str[1]));

			g_sTargetCredit[client] = RoundFloat(StringToInt(str[1]) * g_fquicksellcsokkentett);

			addado(RoundFloat(StringToInt(str[1]) * g_fquicksellcsokkentett));
			char asd2[1000];
			Format(asd2, sizeof(asd2), "%T", "coin name", client);
			char osszeg[50];
			Format(osszeg, sizeof(osszeg), "%s", formatosszeg(StringToInt(str[1])));
			Format(asd2, sizeof(asd2), "%T", "market buy success", client, osszeg, asd2);
			CPrintToChat(client, "%T %s", "Server Name", client, asd2);

			char nev[100];
			GetClientName(client, nev, sizeof(nev));
				ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
			char steam_id[32];
			GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
			new buffer_len = strlen(steam_id) * 2 + 1;
			new String: v_steam_id[buffer_len];
			SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
			buffer_len = strlen(nev) * 2 + 1;
			new String: v_nev[buffer_len];
			SQL_EscapeString(hDatabase, nev, v_nev, buffer_len);
			Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d')", v_steam_id, v_nev, StringToInt(str[2]), str[3], StringToInt(str[4]), StringToInt(str[5]), StringToInt(str[6]), StringToInt(str[7]), StringToInt(str[8]));
			SQL_TQuery(hDatabase, T_InsertSkin3, query, client);

			char logto[200];
			Format(logto, sizeof(logto), "Piac vásár(%d): %s(%d) %s(%d) f:%d st:%d s:%d r:%d", StringToInt(str[1]), fegyveridtonev(StringToInt(str[2])), StringToInt(str[2]), str[3], StringToInt(str[4]), StringToInt(str[5]), StringToInt(str[6]), StringToInt(str[7]), StringToInt(str[8]));
			LogToSql(client, logto);
			Format(query, sizeof(query), "UPDATE lada_playerlada set credits=credits+'%d' where `steam_id`='%s'", StringToInt(str[1]), str[0]);
			SQL_TQuery(hDatabase, T_TestKnife4, query, hPackedSQL);
			
		}
	}
	else {
		CPrintToChat(client, "%T %T", "Server Name", client, "market already bought", client);
	}
	CloseHandle(hPackedSQL);
	showpiac(client);
}

public T_InsertSkin3(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	char query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	new buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	Format(query, sizeof(query), "SELECT `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_stattrak_count`, `skin_seed`,`id`,`rare` FROM `lada_inv` WHERE `steam_id`='%s' ORDER BY `lada_inv`.`id` DESC", steam_id);
	SQL_TQuery(hDatabase, T_newskinload3, query, client);
	return;
}

public T_newskinload3(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
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
		int r, g, b;
			
		char fegyvernevfromid[100];
		Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Weapon[client][g_DB[client]]));
		ShowHintImageHelper(client,g_SkinName[client][g_DB[client]],fegyvernevfromid);
		
		if (getcreditar(g_Weapon[client][g_DB[client]], g_Skins[client][g_DB[client]], g_Float[client][g_DB[client]], g_Stattrak[client][g_DB[client]], client) > g_fpricemessagehang)
		{
			SendDiscordMessage(client, g_DB[client], 4);
		}
		r = rareidtorgbcolor(rarre, 1);
		g = rareidtorgbcolor(rarre, 2);
		b = rareidtorgbcolor(rarre, 3);
		char nev[100];
		GetClientName(client, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		if (g_Stattrak[client][g_DB[client]] == 1)
		{
			for (int k = 1; k < MAXPLAYERS; k++)
			{
				if (IsValidClient(k))
				{
					CPrintToChat(k, "%T %T %s%s | %s ST", "Server Name", k, "market bought", k, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]]);
				}
			}
			SetHudTextParams(-1.0, 0.25, 10.0, r, g, b, 255, 5, 0, 0, 0);
			new String: Buffer[2146];
			Format(Buffer, sizeof(Buffer), "%s%s | %s ST", rareidtostart(client, g_Rare[client][g_DB[client]]), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]]);
			ShowHudText(client, -1, Buffer);
		}
		else {
			for (int k = 1; k < MAXPLAYERS; k++)
			{
				if (IsValidClient(k))
				{
					CPrintToChat(k, "%T %T %s%s | %s", "Server Name", k, "market bought", k, nev, rareidtocolor(rarre), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]]);
				}
			}
			SetHudTextParams(-1.0, 0.25, 10.0, r, g, b, 255, 5, 0, 0, 0);
			new String: Buffer[2146];
			Format(Buffer, sizeof(Buffer), "%s%s | %s", rareidtostart(client, g_Rare[client][g_DB[client]]), fegyveridtonev(g_Weapon[client][g_DB[client]]), g_SkinName[client][g_DB[client]]);
			ShowHudText(client, -1, Buffer);
		}

		g_DB[client]++;
	}
}