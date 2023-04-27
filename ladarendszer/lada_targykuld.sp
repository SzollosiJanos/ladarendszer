

public targykuld(int client)
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
	Format(asd2, sizeof(asd2), "%T", "case", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "key", client);
	menu.DrawItem(asd2);
	Format(asd2, sizeof(asd2), "%T", "skin", client);
	menu.DrawItem(asd2);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_Targykuldname, 60);
	delete menu;
}

public int T_Targykuldname(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		if (item == 9) { showegyeb(client); }
		else if (item == 3) {
			Menu menu2 = CreateMenu(T_Targykuld);
			menu2.SetTitle("Válassz játékost");
			char asd2[11];
			for (int i = 0; i <= MAXPLAYERS; i++)
			{
				if (IsValidClient(i) && i != client)
				{
					if (!CheckCommandAccess(i, "sm_adminflaggg", ADMFLAG_CUSTOM2) || GetClientTeam(i) != 1)
					{
						IntToString(i, asd2, sizeof(asd2));
						char nev[100];
						GetClientName(i, nev, sizeof(nev));
						ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
						menu2.AddItem(asd2, nev);
					}
				}
			}
			menu2.Display(client, 60);
		}
		else if (item == 1) {
			Menu menu3 = CreateMenu(T_Targykuldlada);
			menu3.SetTitle("Válassz játékost");
			char asd2[11];
			for (int i = 0; i <= MAXPLAYERS; i++)
			{
				if (IsValidClient(i) && i != client)
				{
					if (!CheckCommandAccess(i, "sm_adminflaggg", ADMFLAG_CUSTOM2) || GetClientTeam(i) != 1)
					{
						IntToString(i, asd2, sizeof(asd2));
						char nev[100];
						GetClientName(i, nev, sizeof(nev));
						ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
						menu3.AddItem(asd2, nev);
					}
				}
			}
			menu3.Display(client, 60);
		}
		else if (item == 2) {
			Menu menu3 = CreateMenu(T_Targykuldkulcs);
			menu3.SetTitle("Válassz játékost");
			char asd2[11];
			for (int i = 0; i <= MAXPLAYERS; i++)
			{
				if (IsValidClient(i) && i != client)
				{
					if (!CheckCommandAccess(i, "sm_adminflaggg", ADMFLAG_CUSTOM2) || GetClientTeam(i) != 1)
					{
						IntToString(i, asd2, sizeof(asd2));
						char nev[100];
						GetClientName(i, nev, sizeof(nev));
						ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
						menu3.AddItem(asd2, nev);
					}
				}
			}
			menu3.Display(client, 60);
		}
	}
}

public int T_Targykuldlada(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int target = StringToInt(info);
		targykuldladavalaszt(client, target);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public targykuldladavalaszt(int client, int target)
{
	Menu menu = CreateMenu(T_Targykuldladaskin);
	menu.SetTitle("Válassz ládát");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		Format(asd2, sizeof(asd2), "%d|%d", i, target);
		Format(szoveg, sizeof(szoveg), "%s láda: %d", ladaidtonev(i), g_lada[client][i][0]);
		if (g_lada[client][i][0] > 0)
		{
			menu.AddItem(asd2, szoveg);
		}
		else {
			menu.AddItem(asd2, szoveg, ITEMDRAW_DISABLED);
		}
	}
	menu.Display(client, 60);
}

public int T_Targykuldladaskin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][11];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int target = StringToInt(str[1]);
		int skin   = StringToInt(str[0]);
		ladaatkuldbiztos(client, target, skin);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

ladaatkuldbiztos(int client, int target, int skin)
{
	Menu menu = CreateMenu(T_Targykuldladaconfirm);
	menu.SetTitle("Biztos át akarod küldeni?");
	char almafa[64];
	Format(almafa, sizeof(almafa), "%N", target);
	menu.AddItem("4", almafa, ITEMDRAW_DISABLED);
	Format(almafa, sizeof(almafa), "%s láda", ladaidtonev(skin));
	menu.AddItem("5", almafa, ITEMDRAW_DISABLED);
	char info[32];
	Format(info, sizeof(info), "%d|%d", skin, target);
	menu.AddItem(info, "Igen");
	menu.AddItem("nem", "Nem");
	menu.Display(client, 60);
}

public int T_Targykuldladaconfirm(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][11];
		if (StrEqual(info, "nem"))
		{
			Cmd_mainmenu(client);
		}
		else {
			ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
			int target = StringToInt(str[1]);
			int skin   = StringToInt(str[0]);
			if (g_lada[client][skin][0] > 0)
			{
				ladaatkuldve(client, target, skin);
			}
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public ladaatkuldve(int client, int target, int skinid)
{
	char nev[50];
	GetClientName(target, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	CPrintToChat(client, "%T %T", "Server Name", client, "case send", client, nev);
	GetClientName(client, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	CPrintToChat(target, "%T %T", "Server Name", target, "case got", target, nev, ladaidtonev(skinid));
	ladaatkuldbiztos(client, target, skinid);
	addlada(target,skinid,1);
	addlada(client,skinid,-1);
}

public int T_Targykuldkulcs(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int target = StringToInt(info);
		targykuldkulcsvalaszt(client, target);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public targykuldkulcsvalaszt(int client, int target)
{
	Menu menu = CreateMenu(T_Targykuldkulcsskin);
	menu.SetTitle("Válassz kulcsot");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		Format(asd2, sizeof(asd2), "%d|%d", i, target);
		Format(szoveg, sizeof(szoveg), "%s kulcs: %d", ladaidtonev(i), g_lada[client][i][1]);
		if (g_lada[client][i][1] > 0)
		{
			menu.AddItem(asd2, szoveg);
		}
		else {
			menu.AddItem(asd2, szoveg, ITEMDRAW_DISABLED);
		}
	}
	menu.Display(client, 60);
}

public int T_Targykuldkulcsskin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][11];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int target = StringToInt(str[1]);
		int skin   = StringToInt(str[0]);
		kulcsatkuldbiztos(client, target, skin);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

kulcsatkuldbiztos(int client, int target, int skin)
{
	char info[32];
	Format(info, sizeof(info), "%d|%d", skin, target);
	Menu menu = CreateMenu(T_Targykuldkulcsconfirm);
	menu.SetTitle("Biztos át akarod küldeni?");
	char almafa[64];
	Format(almafa, sizeof(almafa), "%N", target);
	menu.AddItem("4", almafa, ITEMDRAW_DISABLED);
	Format(almafa, sizeof(almafa), "%s kulcs", ladaidtonev(skin));
	menu.AddItem("5", almafa, ITEMDRAW_DISABLED);
	menu.AddItem(info, "Igen");
	menu.AddItem("nem", "Nem");
	menu.Display(client, 60);
}

public int T_Targykuldkulcsconfirm(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][11];
		if (StrEqual(info, "nem"))
		{
			Cmd_mainmenu(client);
		}
		else {
			ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
			int target = StringToInt(str[1]);
			int skin   = StringToInt(str[0]);
			if (g_lada[client][skin][1] > 0)
			{
				kulcsatkuldve(client, target, skin);
			}
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public kulcsatkuldve(int client, int target, int skinid)
{
	char nev[50];
	GetClientName(target, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	CPrintToChat(client, "%T %T", "Server Name", client, "key send", client, nev);
	GetClientName(client, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	CPrintToChat(target, "%T %T", "Server Name", target, "key got", target, nev, ladaidtonev(skinid));
	addkey(target,skinid,1);
	addkey(client,skinid,-1);
}

public int T_Targykuld(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int target = StringToInt(info);
		targykuldskinvalaszt(client, target);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public targykuldskinvalaszt(int client, int target)
{
	Menu menu = CreateMenu(T_Targykuldskin);
	menu.SetTitle("Válassz skint");
	char asd2[11];
	char nev[100];
	for (int i = g_DB[client] - 1; i > 0; i--)
	{
		if (g_Stattrak[client][i] == 0)
		{
			if (g_fegyvid[client][Getfegyverid(client, i)] == i)
			{
				Format(nev, sizeof(nev), "%s%s | %s %s [E]", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
			}
			else {
				Format(nev, sizeof(nev), "%s%s | %s %s", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
			}
		}
		else {
			if (g_fegyvid[client][Getfegyverid(client, i)] == i)
			{
				Format(nev, sizeof(nev), "%s%s | %s ST %s [E]", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
			}
			else {
				Format(nev, sizeof(nev), "%s%s | %s ST %s", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
			}
		}
		Format(asd2, sizeof(asd2), "%d|%d", i, target);
		menu.AddItem(asd2, nev);
	}
	menu.Display(client, 60);
}

public int T_Targykuldskin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][11];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int	 target = StringToInt(str[1]);
		int	 skin	= StringToInt(str[0]);
		Menu menu	= CreateMenu(T_Targykuldconfirm);
		menu.SetTitle("Biztos át akarod küldeni?");
		char almafa[64];
		Format(almafa, sizeof(almafa), "%N", target);
		menu.AddItem("4", almafa, ITEMDRAW_DISABLED);
		if (g_Stattrak[client][skin] == 0)
		{
			if (g_fegyvid[client][Getfegyverid(client, skin)] == skin)
			{
				Format(almafa, sizeof(almafa), "%s%s | %s %s [E]", rareidtostart(client, g_Rare[client][skin]), fegyveridtonev(g_Weapon[client][skin]), g_SkinName[client][skin], GetKopottsagFromFloatRovid(g_Float[client][skin]));
			}
			else {
				Format(almafa, sizeof(almafa), "%s%s | %s %s", rareidtostart(client, g_Rare[client][skin]), fegyveridtonev(g_Weapon[client][skin]), g_SkinName[client][skin], GetKopottsagFromFloatRovid(g_Float[client][skin]));
			}
		}
		else {
			if (g_fegyvid[client][Getfegyverid(client, skin)] == skin)
			{
				Format(almafa, sizeof(almafa), "%s%s | %s ST %s [E]", rareidtostart(client, g_Rare[client][skin]), fegyveridtonev(g_Weapon[client][skin]), g_SkinName[client][skin], GetKopottsagFromFloatRovid(g_Float[client][skin]));
			}
			else {
				Format(almafa, sizeof(almafa), "%s%s | %s ST %s", rareidtostart(client, g_Rare[client][skin]), fegyveridtonev(g_Weapon[client][skin]), g_SkinName[client][skin], GetKopottsagFromFloatRovid(g_Float[client][skin]));
			}
		}
		menu.AddItem("5", almafa, ITEMDRAW_DISABLED);
		menu.AddItem(info, "Igen");
		menu.AddItem("nem", "Nem");
		menu.Display(client, 60);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int T_Targykuldconfirm(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][11];
		if (StrEqual(info, "nem"))
		{
			Cmd_mainmenu(client);
		}
		else {
			ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
			int target = StringToInt(str[1]);
			int skin   = StringToInt(str[0]);
			skinatkuldve(client, target, skin);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public skinatkuldve(int client, int target, int skinid)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	g_Skins[target][g_DB[target]]		  = g_Skins[client][skinid];
	g_Weapon[target][g_DB[target]]		  = g_Weapon[client][skinid];
	g_Stattrak[target][g_DB[target]]	  = g_Stattrak[client][skinid];
	g_StattrakCount[target][g_DB[target]] = 0;
	g_Seed[target][g_DB[target]]		  = g_Seed[client][skinid];
	g_Float[target][g_DB[target]]		  = g_Float[client][skinid];
	Format(g_SkinName[target][g_DB[target]], sizeof(g_SkinName[][]), "%s", g_SkinName[client][skinid]);
	g_Id[target][g_DB[target]]	 = g_Id[client][skinid];
	g_Rare[target][g_DB[target]] = g_Rare[client][skinid];
	g_DB[target]++;
	
	char fegyvernevfromid[100];
	Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Weapon[target][g_DB[target]]));
	ShowHintImageHelper(target,g_SkinName[target][g_DB[target]],fegyvernevfromid);
	char nev[50];
	GetClientName(target, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	CPrintToChat(client, "%T %T", "Server Name", client, "skin send", client, nev);
	GetClientName(client, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	CPrintToChat(target, "%T %T", "Server Name", target, "skin got", target, nev, rareidtocolor(g_Rare[target][g_DB[target] - 1]), fegyveridtonev(g_Weapon[target][g_DB[target] - 1]), g_SkinName[target][g_DB[target] - 1]);

	char logto[200];
	char steam_id_log[32];
	GetClientAuthId(target, AuthId_Steam2, steam_id_log, sizeof(steam_id_log));
	Format(logto, sizeof(logto), "Skint küldött(%s): %s(%d) %s(%d) f:%d st:%d s:%d r:%d", steam_id_log, fegyveridtonev(g_Weapon[client][skinid]), g_Weapon[client][skinid], g_SkinName[client][skinid], g_Skins[client][skinid], g_Float[client][skinid], g_Stattrak[client][skinid], g_Seed[client][skinid], g_Rare[client][skinid]);
	LogToSql(client, logto);
	GetClientAuthId(client, AuthId_Steam2, steam_id_log, sizeof(steam_id_log));
	Format(logto, sizeof(logto), "Skint kapott(%s): %s(%d) %s(%d) f:%d st:%d s:%d r:%d", steam_id_log, fegyveridtonev(g_Weapon[client][skinid]), g_Weapon[client][skinid], g_SkinName[client][skinid], g_Skins[client][skinid], g_Float[client][skinid], g_Stattrak[client][skinid], g_Seed[client][skinid], g_Rare[client][skinid]);
	LogToSql(target, logto);
	decl String: query[2000];
	char steam_id[32];
	GetClientAuthId(target, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	char playername[100];
	GetClientName(target,playername,sizeof(playername));
	ReplaceString(playername, sizeof(playername), "'", "");
					ReplaceString(playername, sizeof(playername), "\"", "");
					ReplaceString(playername, sizeof(playername), ";", "");
	int buffer_len_playername = strlen(playername) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, playername, v_playername, buffer_len_playername);
	Format(query, sizeof(query), "UPDATE `lada_inv` SET skin_stattrak_count=0,steam_id='%s',player_name='%s' WHERE id='%d'", v_steam_id, v_playername, g_Id[target][g_DB[target] - 1]);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	DisableKnife3(client, skinid);
	Cmd_mainmenu(client);
}
