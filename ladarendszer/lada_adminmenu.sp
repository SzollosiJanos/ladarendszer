

public Cmd_adminmenu(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	menu.DrawItem("Láda random playernek");
	menu.DrawItem("Kulcs random playernek");
	menu.DrawItem("Más játékos inventoryja");
	menu.DrawText(" ");
	menu.DrawItem("Új láda hozzáadása");
	menu.DrawItem("Láda szerkesztése");
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, AdminMenu, 60);
	delete menu;
}

public int AdminMenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if (item == 1)
		{
			int	 random;
			char nev[64];
			int	 addok = 1;
			while (addok != -1)
			{
				random = GetRandomInt(0, MAXPLAYERS);
				if (IsValidClient(random))
				{
					bool ok=false;
					while(ok==false){
						addok = GetRandomInt(0, maxloadedlada);
						if(g_ladadropadminadd[addok]==1){
							ok=true;
						}
					}
					GetClientName(random, nev, sizeof(nev));
					ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
					char logto[200];
					char steam_id_log[32];
					GetClientAuthId(random, AuthId_Steam2, steam_id_log, sizeof(steam_id_log));
					Format(logto, sizeof(logto), "Ládát addolt: %s %s", ladaidtonev(addok), steam_id_log);
					LogToSql(client, logto);
					addlada(random,addok,1);
					for (int k = 0; k < MAXPLAYERS; k++)
					{
						if (IsValidClient(k))
						{
							CPrintToChat(k, "%T %T", "Server Name", k, "admin case", k, nev, ladaidtonev(addok));
						}
					}

					addok = -1;
				}
			}
			Cmd_adminmenu(client);
		}
		else if (item == 2) {
			int	 random;
			char nev[64];
			int	 addok = 1;
			while (addok != -1)
			{
				random = GetRandomInt(0, MAXPLAYERS);
				if (IsValidClient(random))
				{
					bool ok=false;
					while(ok==false){
						addok = GetRandomInt(0, maxloadedlada);
						if(g_ladadropadminadd[addok]==1){
							ok=true;
						}
					}
					GetClientName(random, nev, sizeof(nev));
					ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
					char logto[200];
					char steam_id_log[32];
					GetClientAuthId(random, AuthId_Steam2, steam_id_log, sizeof(steam_id_log));
					Format(logto, sizeof(logto), "Kulcsot addolt: %s %s", ladaidtonev(addok), steam_id_log);
					LogToSql(client, logto);
					addkey(random,addok,1);
					for (int k = 0; k < MAXPLAYERS; k++)
					{
						if (IsValidClient(k))
						{
							CPrintToChat(k, "%T %T", "Server Name", k, "admin key", k, nev, ladaidtonev(addok));
						}
					}
					addok = -1;
				}
			}
			Cmd_adminmenu(client);
		}
		else if (item == 3) {
			showotherplayer(client);
		}else if (item == 4) {
			g_awaitladacucc[client]=1;
			CPrintToChat(client,"{darkred}Add meg az új láda nevét!!");
		}else if (item == 5) {
			editladachoose(client,0);
		}
		else {
			Cmd_premainmenu(client, 0);
		}
	}
}

public void editladachoose(int client, int at)
{

	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[100];
	int counter=0;
	for (int i = at*6; i <= maxloadedlada; i++)
	{
		Format(asd2, sizeof(asd2), "%s láda", ladaidtonev(i));
		menu.DrawItem(asd2);
		counter++;
		if(counter==6){
			break;
		}
	}
	g_ipanelbuffer[client]=at;
	menu.DrawText(" ");
	menu.CurrentKey = 7;
	if(at==0){
		menu.DrawItem("Előző oldal",ITEMDRAW_DISABLED);
	}else{
		menu.DrawItem("Előző oldal");
	}
	if((at+1)*6>=maxloadedlada){
		menu.DrawItem("Következő oldal",ITEMDRAW_DISABLED);
	}else{
		menu.DrawItem("Következő oldal");
	}
	
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, editladainsystem, 60);
	delete menu;
}

public int editladainsystem(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		int szam = (g_ipanelbuffer[client]*6)+item-1;
		if(item==7){
			editladachoose(client,g_ipanelbuffer[client]-1);
			return Plugin_Continue;
		}else if(item==8){
			editladachoose(client,g_ipanelbuffer[client]+1);
			return Plugin_Continue;
		}else if(item==9){
			return Plugin_Handled;
		}
		Panel menu = new Panel();
		g_awaitladacuccinput[client]=szam;
		menu.SetTitle(" » MegoltElek ládarendszer « ");

		menu.DrawText(" ");
		char szoveg[150];
		Format(szoveg,sizeof(szoveg),"név: %s",g_ladanev[szam]);
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Ölés esetén droppolhat: %s",g_ladadropkill[szam]==1?"igen":"nem");
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Map végén droppolhat: %s",g_ladadropmapend[szam]==1?"igen":"nem");
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Admin addolhatja: %s",g_ladadropadminadd[szam]==1?"igen":"nem");
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Kulcs vásárolható: %s",g_ladabuykulcs[szam]==1?"igen":"nem");
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Láda vásárolható: %s",g_ladabuylada[szam]==1?"igen":"nem");
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Kulcs ára: %d",g_kulcsar[szam]);
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Láda ára: %d",g_ladaar[szam]);
		menu.DrawItem(szoveg);
		Format(szoveg,sizeof(szoveg),"Flagek: %s",g_flagtoopen[szam]);
		menu.DrawItem(szoveg);
		menu.CurrentKey = 9;
		menu.DrawText(" ");
		char exit2[50];
		Format(exit2, sizeof(exit2), "%T", "back", client);
		menu.DrawItem(exit2);
		menu.Send(client, LadaEditMenu, 60);
		delete menu;
	}
}



public int LadaEditMenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char query[255];
		switch(item){
			case 1:{
				g_awaitladacucc[client]=2;
				CPrintToChat(client,"{darkred}Add meg az új láda nevét!!");
			}
			case 2:{
				Format(query,sizeof(query),"UPDATE lada_cases set can_drop_kill='%d' where id='%d'",g_ladadropkill[g_awaitladacuccinput[client]]==1?0:1,g_awaitladacuccinput[client]);
				SQL_TQuery(hDatabase, T_AddLada, query, client);
			}
			case 3:{
				Format(query,sizeof(query),"UPDATE lada_cases set can_drop_mapend='%d' where id='%d'",g_ladadropmapend[g_awaitladacuccinput[client]]==1?0:1,g_awaitladacuccinput[client]);
				SQL_TQuery(hDatabase, T_AddLada, query, client);
			}
			case 4:{
				Format(query,sizeof(query),"UPDATE lada_cases set can_drop_adminadd='%d' where id='%d'",g_ladadropadminadd[g_awaitladacuccinput[client]]==1?0:1,g_awaitladacuccinput[client]);
				SQL_TQuery(hDatabase, T_AddLada, query, client);
			}
			case 5:{
				Format(query,sizeof(query),"UPDATE lada_cases set can_buy_kulcs='%d' where id='%d'",g_ladabuykulcs[g_awaitladacuccinput[client]]==1?0:1,g_awaitladacuccinput[client]);
				SQL_TQuery(hDatabase, T_AddLada, query, client);
			}
			case 6:{
				Format(query,sizeof(query),"UPDATE lada_cases set can_buy_lada='%d' where id='%d'",g_ladabuylada[g_awaitladacuccinput[client]]==1?0:1,g_awaitladacuccinput[client]);
				SQL_TQuery(hDatabase, T_AddLada, query, client);
			}
			case 7:{
				g_awaitladacucc[client]=3;
				CPrintToChat(client,"{darkred}Add meg az új kulcs árat!!");
			}
			case 8:{
				g_awaitladacucc[client]=4;
				CPrintToChat(client,"{darkred}Add meg az új láda árat!!");
			}
			case 9:{
				g_awaitladacucc[client]=5;
				CPrintToChat(client,"{darkred}Add meg az új láda flagjeit!!");
			}
		}
		
	}
}


public showotherplayer(int client)
{
	Menu menu = CreateMenu(OtherPlayerSelect);

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	char nev[100];
	char asd2[11];
	for (int i = 0; i < MAXPLAYERS; i++)
	{
		if (IsValidClient(i) && i != client)
		{
			GetClientName(i, nev, sizeof(nev));
			ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
			Format(asd2, sizeof(asd2), "%d", i);
			menu.AddItem(asd2, nev);
		}
	}
	menu.Display(client, 60);
}

public int OtherPlayerSelect(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int target = StringToInt(info);
		showotherplayeritems(client, target);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public showotherplayeritems(int client, int target)
{
	Menu menu = CreateMenu(OtherPlayerInventory);
	char almafa[100];
	char nev[100];
	GetClientName(target, nev, sizeof(nev));
	ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	Format(almafa, sizeof(almafa), "%s %T:%s", nev, "coin name", client, formatosszeg(g_credits[target]));
	menu.SetTitle(almafa);
	char asd2[25];
	for (int i = g_DB[target] - 1; i > 0; i--)
	{
		if(g_Rare[target][i]==8){
				if (g_Stattrak[target][i] == 0)
			{
				if (g_fegyvid[target][Getfegyverid(target, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s %s %s [E]", rareidtostart(target, g_Rare[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s %s %s", rareidtostart(target, g_Rare[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
			}
			else {
				if (g_fegyvid[target][Getfegyverid(target, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s %s ST %s [E]", rareidtostart(target, g_Rare[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s %s ST %s", rareidtostart(target, g_Rare[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
			}
			}else{
				if (g_Stattrak[target][i] == 0)
			{
				if (g_fegyvid[target][Getfegyverid(target, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s%s | %s %s [E]", rareidtostart(target, g_Rare[target][i]), fegyveridtonev(g_Weapon[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s%s | %s %s", rareidtostart(target, g_Rare[target][i]), fegyveridtonev(g_Weapon[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
			}
			else {
				if (g_fegyvid[target][Getfegyverid(target, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s%s | %s ST %s [E]", rareidtostart(target, g_Rare[target][i]), fegyveridtonev(g_Weapon[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s%s | %s ST %s", rareidtostart(target, g_Rare[target][i]), fegyveridtonev(g_Weapon[target][i]), g_SkinName[target][i], GetKopottsagFromFloatRovid(g_Float[target][i]));
				}
			}
		Format(asd2,sizeof(asd2),"%d|%d",i,target);
		menu.AddItem(asd2, almafa);
		}
	}
	if (g_DB[target] == 1)
	{
		CPrintToChat(client, "%T %T", "Server Name", client, "error no skin", client);
	}
	
	menu.Display(client, 60);
}

public int OtherPlayerInventory(Menu menu, MenuAction:mAction, int target, int item)
{
	if (mAction== MenuAction_Select)
	{
		char almafa[500];
		char asd2[100];
		char info[100];
		char str[2][50];
		menu.GetItem(item, info, sizeof(info));
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int	 client	 = StringToInt(str[1]);
		int	 i		 = StringToInt(str[0]);
		Menu menu = CreateMenu(PlayerSkinMenuAdmin);
		menu.SetTitle("Leltár");
		if(g_Rare[client][i]==8){
			if (g_Stattrak[client][i])
			{
				Format(almafa, sizeof(almafa), "%s ST", rareidtostart(client, g_Rare[client][i]));
			}
			else {
				Format(almafa, sizeof(almafa), "%s", rareidtostart(client, g_Rare[client][i]));
			}
		}else{
			if (g_Stattrak[client][i])
			{
				Format(almafa, sizeof(almafa), "%s%s ST", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]));
			}
			else {
				Format(almafa, sizeof(almafa), "%s%s", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]));
			}
		}
		if(StrEqual(g_Nametag[client][i],"")){
			Format(almafa, sizeof(almafa), "%s\n%s", almafa, g_SkinName[client][i]);
		}else{
			Format(almafa, sizeof(almafa), "%s\n%s  [%s]", almafa, g_SkinName[client][i],g_Nametag[client][i]);
		}
		
		if (g_Stattrak[client][i])
		{
			Format(almafa, sizeof(almafa), "%s\nÖlések száma: %d", almafa, g_StattrakCount[client][i]);
		}
		else {
			Format(almafa, sizeof(almafa), "%s\nA fegyver nem stattrakos", almafa);
		}
		Format(almafa, sizeof(almafa), "%s\n%s", almafa, GetKopottsagFromFloat(g_Float[client][i]));
		float idg = float(g_Float[client][i]);
		idg		  = idg / 100000;
		Format(almafa, sizeof(almafa), "%s\nKopottság: %.5f\nSeed: %d", almafa, idg, g_Seed[client][i]);
		menu.AddItem("4", almafa, ITEMDRAW_DISABLED);
		char asd[50];
		Format(asd,sizeof(asd),"%d",client);
		menu.AddItem(asd, "Vissza");
		menu.Display(target, 60);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int PlayerSkinMenuAdmin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int	 target	 = StringToInt(info);
		showotherplayeritems(client,target);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}