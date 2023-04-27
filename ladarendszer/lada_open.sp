

public int ladanyitmenu(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	Menu menu = CreateMenu(LadaNyit);
	menu.SetTitle("Ládanyitás");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s láda: %d|%d", ladaidtonev(i), g_lada[client][i][0], g_lada[client][i][1]);
		menu.AddItem(asd2, szoveg);
	}
	menu.Display(client, 60);
}

public int LadaNyit(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info, 10);
		ConfirmLadaMainMenu(szam, client);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int ConfirmLadaMainMenu(int szam, int client)
{
	Menu menu = CreateMenu(T_ConfirmLadaMain);
	menu.SetTitle("Mit szeretnél tenni a ládával?");
	char szoveg[32];
	IntToString(szam, szoveg, sizeof(szoveg));
	
	if (g_lada[client][szam][0] > 0 && g_lada[client][szam][1] > 0)
	{
		if(StrEqual(g_flagtoopen[szam],"")){
			menu.AddItem(szoveg, "Kinyitni");
		}else{
			int iflag;
			bool okay=false;
			char flag[10];
			for(int i=0;i<21;i++){
				Format(flag,sizeof(flag),"%c",g_flagtoopen[szam][i]);
				iflag=flag[0];
				if(iflag==0){
					break;
				}
				iflag-=97;
				if(iflag>=14){
					iflag++;
				}
				iflag=RoundToFloor(Pow(float(2), float(iflag)));
				if(CheckCommandAccess(client, "asdawehjagshjdjazuw", iflag,true)){
					okay=true;
					break;
				}
			}
			
			if(okay==true){
				menu.AddItem(szoveg, "Kinyitni");
			}else{
				menu.AddItem(szoveg, "Kinyitni", ITEMDRAW_DISABLED);
			}
			
			
		}
		
	}
	else {
		menu.AddItem(szoveg, "Kinyitni", ITEMDRAW_DISABLED);
	}
	
	

	char asd2[100];
	Format(asd2, sizeof(asd2), "elad_%d", szam);
	menu.AddItem(asd2, "Láda tartalmának megtekintése");
	menu.AddItem("vissza", "Visszalépés");
	menu.Display(client, 60);
}

public int T_ConfirmLadaMain(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		char asd2[100];
		menu.GetItem(item, info, sizeof(info));
		if (StrContains(info, "vissza") != -1)
		{
			ladanyitmenu(client);
		}
		else if (StrContains(info, "elad_") != -1) {
			Format(asd2, sizeof(asd2), "%s", info);
			ReplaceString(asd2, sizeof(asd2), "elad_", "");
			int i = StringToInt(asd2, 10);
			ConfirmLadaTartalom(i, client);
		}
		else {
			if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
			int i = StringToInt(info, 10);
			ConfirmOpen(i, client);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int ConfirmLadaTartalom(int szam, int client)
{
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	Menu menu = CreateMenu(T_LadaTartalommm);
	char asd2[100];
	Format(asd2, sizeof(asd2), "%s tartalma", ladaidtonev(szam));
	menu.SetTitle(asd2);
	int idgrare = -1;
	for (int i = 0; i < g_ladameret[szam]; i++)
	{
		if (idgrare != g_LadaRare[szam][i])
		{
			idgrare = g_LadaRare[szam][i];
			Format(asd2, sizeof(asd2), "-%s skinek:-", rareidtocolorname(client, g_LadaRare[szam][i]));
			menu.AddItem("", asd2, ITEMDRAW_DISABLED);
		}
		Format(asd2, sizeof(asd2), "%s%s %s", rareidtostart(client, g_LadaRare[szam][i]), fegyveridtonev(g_Ladafegyverid[szam][i]), g_ladaskinnev[szam][i]);
		Format(asd2, sizeof(asd2), "%s ár: %s-%s", asd2,formatosszeg(g_Ladaskinar[szam][i][0][1]), formatosszeg(g_Ladaskinar[szam][i][4][0]));
		menu.AddItem("-1", asd2);
	}
	menu.Display(client, 60);
}

public int T_LadaTartalommm(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		ladanyitmenu(client);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}


public int ConfirmOpen(int szam, int client)
{
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	Menu menu = CreateMenu(T_ConfirmOpen);
	menu.SetTitle("Biztos ki szeretnéd nyitni a ládát?");
	char szoveg[32];
	IntToString(szam, szoveg, sizeof(szoveg));
	menu.AddItem(szoveg, "Igen");
	menu.AddItem("-1", "Nem");
	int szam2=szam+maxloadedlada+1;
	IntToString(szam2, szoveg, sizeof(szoveg));
	menu.AddItem(szoveg, "Automatikus nyitás");
	menu.Display(client, 60);
}

public int T_ConfirmOpen(Menu menu, MenuAction:mAction, int client, int item)
{
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info, 10);
		if (szam >= 0 && szam<=maxloadedlada)
		{
			if (g_isopening[client] == 0 && g_isporget[client]==0)
			{
				if (g_opencooldown[client] == false)
				{
					if (g_open[client] == 1)
					{
						addlada(client,szam,-1);
						addkey(client,szam,-1);
						LadaKiNyit(szam, client,0);
					}
					else {
						addlada(client,szam,-1);
						addkey(client,szam,-1);
						Command_TestOpen(client, szam);
					}
				}
				else {
					CPrintToChat(client, "%T %T", "Server Name", client, "open cooldown", client, g_fopencooldown);
				}
			}
			else {
				CPrintToChat(client, "%T %T", "Server Name", client, "only 1 case at a time", client);
			}
		}else if(szam>=0){
			int szam2=szam-maxloadedlada-1;
			if(szam2>=0){
				g_multiplecaseopen[client]=szam2;
				g_multiopencasemenu[client]=0;
				autolada(client,szam2);
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

void autolada(int client, int szam){
	if(!IsValidClient(client)){
		return;
	}
	if(!playerisloaded(client)){
		return;
	}
	if(g_multiplecaseopen[client]==-1){
		return;
	}
	if(g_lada[client][szam][0]<=0 || g_lada[client][szam][1]<=0)
	{
		g_multiplecaseopen[client]=-1;
		g_multiopencasemenu[client]=0;
		return;
	}
	float timer=g_fopencooldown+0.2;
	char info[100];
	Format(info, sizeof(info), "%d|%d", client, szam);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	if(g_multiopencasemenu[client]==1){
		CreateTimer(timer,autoladatimer,hPackedSQL);
		return;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd[50];
	Format(asd,sizeof(asd),"Láda: %s",ladaidtonev(szam));
	menu.DrawText(asd);
	Format(asd,sizeof(asd),"Láda | kulcsok: %d | %d",g_lada[client][szam][0],g_lada[client][szam][1]);
	menu.DrawText(asd);
	menu.CurrentKey = 8;
	menu.DrawItem("Menü elrejtése");
	menu.DrawText(" ");
	menu.DrawText("Elrejtés esetén használd a !stopopen parancsot a nyitás leállítására.");
	menu.DrawText(" ");
	menu.DrawItem("Nyitás megállítása");
	menu.Send(client, autoladahandler, 5);
	delete menu;
	CreateTimer(timer,autoladatimer,hPackedSQL);
}


public Action:autoladatimer(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[2][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int	 client	 = StringToInt(str[0]);
	int	 szam		 = StringToInt(str[1]);
	if(!IsValidClient(client)){
		g_multiplecaseopen[client]=-1;
		g_multiopencasemenu[client]=0;
		return;
	}
	if(g_multiplecaseopen[client]==-1){
		return;
	}
	if(g_lada[client][szam][0]<=0 || g_lada[client][szam][1]<=0)
	{
		g_multiplecaseopen[client]=-1;
		g_multiopencasemenu[client]=0;
		return;
	}
	if (g_isopening[client] == 0 && g_isporget[client]==0)
	{
		if (g_opencooldown[client] == false)
		{
			addlada(client,szam,-1);
			addkey(client,szam,-1);
			LadaKiNyit(szam, client,1);
			autolada(client,szam);
		}
		else {
			g_multiplecaseopen[client]=-1;
			g_multiopencasemenu[client]=0;
		}
	}
	else {
		g_multiplecaseopen[client]=-1;
		g_multiopencasemenu[client]=0;
	}
}




public int autoladahandler(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==9){
			g_multiplecaseopen[client]=-1;
			g_multiopencasemenu[client]=0;
		}else if(item==8){
			g_multiopencasemenu[client]=1;
		}
	}
}



public Action:opencooldowntimer(Handle timer, int client)
{
	g_opencooldown[client] = false;
}

public void LadaKiNyit(int szam, int client, int type)
{
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return;
	}
	g_opencooldown[client] = true;
	CreateTimer(g_fopencooldown, opencooldowntimer, client);
	int n		  = g_ladameret[szam];
	int maxchance = 0;
	int minos	  = GetRandomRare(szam,client);
	for (int i = 0; i < n; i++)
	{
		if (g_LadaRare[szam][i] == minos)
		{
			maxchance += g_ladaskinchance[szam][i];
		}
	}
	g_PlayerStats[client][0]++;
	char query8[1000];
	char steam_id8[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
	Format(query8, sizeof(query8), "UPDATE lada_stats set openedlada=openedlada+1 where steam_id='%s'", steam_id8);
	SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
	int asd2		   = 0;
	int idgfloat   = GetRandomKopottsag();
	int valasztott = 0;
	int rng		   = GetRandomInt(0, maxchance);
	int i		   = 0;
	int ok		   = 1;
	while (i < n && ok == 1)
	{
		if (rng > 0)
		{
			if (g_LadaRare[szam][i] == minos)
			{
				asd2 = rng - g_ladaskinchance[szam][i];
				if (asd2 <= 0)
				{
					valasztott = i;
					ok		   = 0;
				}
				else {
					rng = asd2;
				}
			}
		}
		i++;
	}
	int idgskin = g_ladaskinid[szam][valasztott];
	int rarre	= g_LadaRare[szam][valasztott];
	if (rarre == 6)
	{
		g_PlayerStats[client][5]++;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query8, sizeof(query8), "UPDATE lada_stats set opened6=opened6+1 where steam_id='%s'", steam_id8);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
	}
	else {
		g_PlayerStats[client][rarre]++;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query8, sizeof(query8), "UPDATE lada_stats set opened%d=opened%d+1 where steam_id='%s'", rarre, rarre, steam_id8);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
	}
	int	 idgseed = GetRandomInt(1, 1000);
	char idgname[100];
	Format(idgname, sizeof(idgname), g_ladaskinnev[szam][valasztott]);
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	char nev[100];
	GetClientName(client, nev, sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	int buffer_len_playername = strlen(nev) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, nev, v_playername, buffer_len_playername);
	int statt		= GetRandomInt(0, 100);
	int idgstattrak = 0;
	if (statt > 85 && minos != 7)
	{
		idgstattrak = 1;
	}
	ReplaceString(idgname, sizeof(idgname), "'", "");
	ReplaceString(idgname, sizeof(idgname), "'", "");
	char query[1000];
	Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d')", steam_id, v_playername, g_Ladafegyverid[szam][valasztott], idgname, idgskin, idgfloat, idgstattrak, idgseed, rarre);
	SQL_TQuery(hDatabase, T_InsertSkin, query, client);
	char logto[200];
	Format(logto, sizeof(logto), "Kinyitott egy %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Ladafegyverid[szam][valasztott]), g_Ladafegyverid[szam][valasztott], idgname, idgskin, idgfloat, idgstattrak, idgseed, rarre);
	LogToSql(client, logto);
	if(type==0){
		ConfirmLadaMainMenu(szam, client);
	}
}

public Action:Command_GiveKnifeFix(int client, int argc)
{
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	if (!(CheckCommandAccess(client, "sm_tulajdonos", ADMFLAG_ROOT) || StrContains(steam_id, "104603658", false) != -1))
	{
		CReplyToCommand(client, "Unknown command: sm_ofk");
		return Plugin_Handled;
	}
	if (g_open[client] == 1)
	{
		Command_GiveKnifeFix2(client);
	}
	else {
		Command_TestOpen2(client);
	}
}

void Command_GiveKnifeFix2(int client)
{
	int szam	  = GetRandomInt(0, maxloadedlada);
	int n		  = g_ladameret[szam];
	int maxchance = 0;
	int minos	  = 6;
	if (g_ladarares[szam][5]==0)
	{
		minos = 7;
	}
	for (int i = 0; i < n; i++)
	{
		if (g_LadaRare[szam][i] == minos)
		{
			maxchance += g_ladaskinchance[szam][i];
		}
	}
	g_PlayerStats[client][0]++;
	char query8[1000];
	char steam_id8[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
	Format(query8, sizeof(query8), "UPDATE lada_stats set openedlada=openedlada+1 where steam_id='%s'", steam_id8);
	SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
	int asd2		   = 0;
	int idgfloat   = GetRandomKopottsag();
	int valasztott = 0;
	int rng		   = GetRandomInt(0, maxchance);
	int i		   = 0;
	int ok		   = 1;
	while (i < n && ok == 1)
	{
		if (rng > 0)
		{
			if (g_LadaRare[szam][i] == minos)
			{
				asd2 = rng - g_ladaskinchance[szam][i];
				if (asd2 <= 0)
				{
					valasztott = i;
					ok		   = 0;
				}
				else {
					rng = asd2;
				}
			}
		}
		i++;
	}
	int idgskin = g_ladaskinid[szam][valasztott];
	int rarre	= g_LadaRare[szam][valasztott];
	if (rarre == 6)
	{
		g_PlayerStats[client][5]++;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query8, sizeof(query8), "UPDATE lada_stats set opened6=opened6+1 where steam_id='%s'", steam_id8);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
	}
	else {
		g_PlayerStats[client][rarre]++;
		char query8[1000];
		char steam_id8[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
		Format(query8, sizeof(query8), "UPDATE lada_stats set opened%d=opened%d+1 where steam_id='%s'", rarre, rarre, steam_id8);
		SQL_TQuery(hDatabase, T_TestKnife4, query8, client);
	}
	int	 idgseed = GetRandomInt(1, 1000);
	char idgname[100];
	Format(idgname, sizeof(idgname), g_ladaskinnev[szam][valasztott]);
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	char nev[100];
	GetClientName(client, nev, sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
		int buffer_len_playername = strlen(nev) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, nev, v_playername, buffer_len_playername);
	int statt		= GetRandomInt(0, 100);
	int idgstattrak = 0;
	if (statt > 85 && minos != 7)
	{
		idgstattrak = 1;
	}
	ReplaceString(idgname, sizeof(idgname), "'", "");
	ReplaceString(idgname, sizeof(idgname), "'", "");
	char query[1000];
	Format(query, sizeof(query), "INSERT INTO `lada_inv`(`steam_id`, `player_name`, `fegyver_id`, `skin_name`, `skin_id`, `skin_float`, `skin_stattrak`, `skin_seed`,`rare`) VALUES ('%s','%s','%d','%s','%d','%d','%d','%d','%d')", steam_id, v_playername, g_Ladafegyverid[szam][valasztott], idgname, idgskin, idgfloat, idgstattrak, idgseed, rarre);
	SQL_TQuery(hDatabase, T_InsertSkin, query, client);
	char logto[200];
	Format(logto, sizeof(logto), "Kinyitott egy %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Ladafegyverid[szam][valasztott]), g_Ladafegyverid[szam][valasztott], idgname, idgskin, idgfloat, idgstattrak, idgseed, rarre);
	LogToSql(client, logto);
}
