public casinoalap(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	if(g_opencooldown[client]==true){
		CPrintToChat(client,"%T várnod kell %.1f másodpercet.","Server Name",client,g_icasinotime);
		return Plugin_Handled;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	menu.DrawItem("Lottó");
	menu.DrawItem("Roulett");
	menu.DrawItem("Kő Papír Olló");
	menu.DrawItem("Trade-up");
	menu.DrawItem("Crash");
	menu.DrawItem("Láda verseny[Hamarosan]", ITEMDRAW_DISABLED);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_CasinoValaszt, 60);
	delete menu;
}

public int T_CasinoValaszt(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if (item == 2)
		{
			casinomaincredit(client,1);
		}
		else if (item == 4) {
			casinomaincredit(client,2);
		}
		else if (item == 5) {
			casinomaincredit(client,3);
		}
		else if (item == 6) {
			//ladaalap(client);
		}
		else if (item == 1) {
			openlotto(client);
		}
		else if (item == 3) {
			sspCommand(client, 0);
		}
		else {
			Cmd_premainmenu(client, 0);
		}
	}
}

public casinomaincredit(int client, int type)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	menu.DrawText("Mivel szeretnél játszani?");
	menu.DrawText(" ");
	menu.DrawItem("Pénzel");
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	menu.DrawItem("Skinnel");
	menu.DrawText(" ");
	menu.DrawText("Skin játék esetén a skined törlésre kerül!!!");
	menu.DrawText("Nyerés esetén a nyereménnyel egyértékű skint kapsz!!!");
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	switch(type){
		case 1:{menu.Send(client, T_RoulettMainHandler, 60);}
		case 2:{menu.Send(client, T_TradeupMainHandler, 60);}
		case 3:{menu.Send(client, T_CrashMainHandler, 60);}
	}
	delete menu;
}


public int T_RoulettMainHandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==9){
			casinoalap(client);
		}else{
			CasinoMainHandler(client,item,1);
		}
		
	}
}
public int T_CrashMainHandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==9){
			casinoalap(client);
		}else{
			CasinoMainHandler(client,item,3);
		}
	}
}
public int T_TradeupMainHandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==9){
			casinoalap(client);
		}else{
			CasinoMainHandler(client,item,2);
		}
	}
}


public CasinoMainHandler(int client, int item, int type)
{
	if(g_isporget[client]==1){
		CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
		return Plugin_Handled;
	}
	
	if (item == 9)
	{
		casinoalap(client);
	}else if(item==1){
		char asd2[100];
		Format(asd2, sizeof(asd2), "%T", "coin name", client);
		CPrintToChat(client, "%T %T", "Server Name", client, "casino coin", client, asd2);
		g_bAwaitingCreditCasino[client] = type;
	}else{
		casino_skinvalaszt(client,type);
	}

}

public casino_skinvalaszt(int client,int type)
{
	Menu menu = CreateMenu(T_CasinoMainSkin);
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
		Format(asd2, sizeof(asd2), "%d|%d", i,type);
		menu.AddItem(asd2, nev);
	}
	menu.Display(client, 60);

}

public int T_CasinoMainSkin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(g_isporget[client]==1){
			CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
			return Plugin_Handled;
		}
	
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		char str[2][32];
		ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
		int	 skin	= StringToInt(str[0]);
		int  type= StringToInt(str[1]);
		int ar=getcreditar(g_Weapon[client][skin], g_Skins[client][skin],g_Float[client][skin],g_Stattrak[client][skin],client);
		if(ar==0 ||g_skinlocked[client][skin]){
			CPrintToChat(client,"%T","can not be sold",client);
			return Plugin_Handled;
		}
		g_ipanelbuffer[client]=skin;
		switch(type){
			case 1:{roulettalapskin(client,skin);}
			case 2:{
				g_bAwaitingCreditCasino[client]=5;
				char asd2[100];
				Format(asd2, sizeof(asd2), "%T", "coin name", client);
				CPrintToChat(client, "%T %T", "Server Name", client, "tradeup chance", client, asd2);
				}
			case 3:{crashmainskin(client,skin);}
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public roulettalapskin(int client, int skinid)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[128];
	int ar=getcreditar(g_Weapon[client][skinid],g_Skins[client][skinid],g_Float[client][skinid],g_Stattrak[client][skinid],client);
	Format(asd2,sizeof(asd2),"Piros %s",GetNearestSkin(client,RoundToNearest(ar+ar*g_icasinopercent),1));
	menu.DrawItem(asd2);
	Format(asd2,sizeof(asd2),"Zöld %s",GetNearestSkin(client,RoundToNearest(ar+ar*13*g_icasinopercent),1));
	menu.DrawItem(asd2);
	Format(asd2,sizeof(asd2),"Fekete %s",GetNearestSkin(client,RoundToNearest(ar+ar*g_icasinopercent),1));
	menu.DrawItem(asd2);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_RoulettValasztSkin, 60);
	g_RoulettCredit[client] = skinid;
	delete menu;
}

public int T_RoulettValasztSkin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if (item == 9)
		{
			casinoalap(client);
		}else{
		
		
		int skinid=g_RoulettCredit[client];
		g_RoulettCredit[client] =getcreditar(g_Weapon[client][skinid], g_Skins[client][skinid],g_Float[client][skinid],g_Stattrak[client][skinid],client);
		char logto[200];
		Format(logto, sizeof(logto), "Casino skin delete: %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Weapon[client][skinid]), g_Weapon[client][skinid], g_SkinName[client][skinid], g_Skins[client][skinid], g_Float[client][skinid], g_Stattrak[client][skinid], g_Seed[client][skinid], g_Rare[client][skinid]);
		LogToSql(client, logto);
		decl String: query[1000];
		Format(query, sizeof(query), "DELETE FROM `lada_inv` WHERE `id`='%d'", g_Id[client][skinid]);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		DisableKnife3(client, skinid);
		
		if (item == 1) {
			g_valasztottroulettszin[client] = 1;
			g_ipanelbuffer[client]=-1;
			OpenTimers[client]				= CreateTimer(0.1, Timer_OpenRoulettSkinAnim, client, TIMER_REPEAT);
			return Plugin_Continue;
		}
		else if (item == 3) {
			g_valasztottroulettszin[client] = 2;
			g_ipanelbuffer[client]=-1;
			OpenTimers[client]				= CreateTimer(0.1, Timer_OpenRoulettSkinAnim, client, TIMER_REPEAT);
			return Plugin_Continue;
		}
		else if (item == 2) {
			g_valasztottroulettszin[client] = 3;
			g_ipanelbuffer[client]=-1;
			OpenTimers[client]				= CreateTimer(0.1, Timer_OpenRoulettSkinAnim, client, TIMER_REPEAT);
			return Plugin_Continue;
		}
		}
	}
}


public Action:Timer_OpenRoulettSkinAnim(Handle hTimer23, int client)
{
	if (!IsValidClient(client))
	{
		asd2[client]			= 100;
		pivot[client]		= 0;
		bpivot[client]		= 1;
		allas[client]		= 0;
		g_isopening[client] = 0;
		g_isporget[client]=0;
		OpenTimers[client]	= null;
		KillTimer(hTimer23, true);
	}
	char logto[200];
	asd2[client]--;
	int random = 0;
	if (asd2[client] == 99)
	{
		g_opencooldown[client]=true;
		CreateTimer(g_icasinotime, opencooldowntimer, client);
		for (int i = 0; i < 50; i++)
		{
			random		 = GetRandomInt(0, 15);
			b[client][i] = 0;
			if (random == 0)
			{
				Format(skinek[client][i], sizeof(skinek[][]), "Zöld");
				r[client][i] = 0;
				g[client][i] = 255;
				if (i == 43)
				{
					vid[client] = 3;
				}
			}
			else if (random <= 8) {
				Format(skinek[client][i], sizeof(skinek[][]), "Piros");
				r[client][i] = 255;
				g[client][i] = 0;
				if (i == 43)
				{
					vid[client] = 1;
				}
			}
			else {
				Format(skinek[client][i], sizeof(skinek[][]), "Fekete");
				r[client][i] = 0;
				g[client][i] = 0;
				if (i == 43)
				{
					vid[client] = 2;
				}
			}
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
	}
	if (asd2[client] == -30)
	{
		asd2[client]	   = 100;
		pivot[client]  = 0;
		bpivot[client] = 1;
		allas[client]  = 0;
		g_isporget[client]=0;
		if ((g_valasztottroulettszin[client] == 1 && vid[client] == 1) || (g_valasztottroulettszin[client] == 2 && vid[client] == 2))
		{
			if(g_ipanelbuffer[client]==-1){
				GetNearestSkin(client,RoundToNearest(g_RoulettCredit[client]+g_RoulettCredit[client]*g_icasinopercent),0);
			}else{
				addcredit(client,RoundToNearest(g_RoulettCredit[client]+g_RoulettCredit[client]*g_icasinopercent));
				char asd[50];
				Format(asd,sizeof(asd),"%T","coin name",client);
				CPrintToChat(client,"%T","casino win",client,formatosszeg(RoundToNearest(g_RoulettCredit[client]+g_RoulettCredit[client]*g_icasinopercent)),asd);
			}
			
			
		}
		else if (g_valasztottroulettszin[client] == 3 && vid[client] == 3) {
			
			if(g_ipanelbuffer[client]==-1){
				GetNearestSkin(client,RoundToNearest(g_RoulettCredit[client]+g_RoulettCredit[client]*13*g_icasinopercent),0);
			}else{
				addcredit(client,RoundToNearest(g_RoulettCredit[client]+g_RoulettCredit[client]*13*g_icasinopercent));
				char asd[50];
				Format(asd,sizeof(asd),"%T","coin name",client);
				CPrintToChat(client,"%T","casino win",client,formatosszeg(RoundToNearest(g_RoulettCredit[client]+g_RoulettCredit[client]*13*g_icasinopercent)),asd);
			}
		}else{
			char asd[50];
			Format(asd,sizeof(asd),"%T","coin name",client);
			CPrintToChat(client,"%T","casino lose",client,formatosszeg(g_RoulettCredit[client]),asd);
		}

		g_isopening[client] = 0;
		g_isporget[client]=0;
		OpenTimers[client]	= null;
		KillTimer(hTimer23, true);
	}
}

GetNearestSkin(int client,int ar,int type){
	int nearest = 99999999999;
	int temp=0;
	int i2,k2,szam2,j2;
	new String:fegyvername[128];
	Format(fegyvername,sizeof(fegyvername)," ");	
	char skinek[4000];
	int counter=0;
	for (int i = 0; i <= maxloadedlada; i++)
	{
		for (int k = 0; k < g_ladameret[i]; k++)
		{
			if(g_casinoban[i][k]==1){
				continue;
			}
			for (int szam=0;szam<5;szam++){
				for (int j=0;j<=1;j++){
					if(g_ladarares[i][6]==1 && j==1){
						continue;
					}
					if(g_Ladaskinar[i][k][szam][j]!=0){
						temp=(ar-g_Ladaskinar[i][k][szam][j]);
						if(temp<0){
							continue;
						}
						if(temp<nearest){
							nearest=temp;
							i2=i;
							k2=k;
							szam2=szam;
							j2=j;
							counter=0;
							Format(skinek,sizeof(skinek),"");
						}
						if(nearest==temp){
							if(counter==0){
								Format(skinek,sizeof(skinek),"%d,%d,%d,%d",i,k,szam,j);
							}else{
								Format(skinek,sizeof(skinek),"%s,%d,%d,%d,%d",skinek,i,k,szam,j);
							}
							counter++;
						}
					}
				}
			}
			
		}
	}
	if(counter>0){
		char[][] str = new char[counter*4][100];
		ExplodeString(skinek,",",str,counter*4,100);
		int random;
		if(counter==1){
			random=0;
		}else{
			random=GetRandomInt(0, counter-1);
		}
		
		random=random*4;
		i2=StringToInt(str[random]);
		k2=StringToInt(str[random+1]);
		szam2=StringToInt(str[random+2]);
		j2=StringToInt(str[random+3]);
	}
	
	if(type==0){
		addskin(client,g_Ladafegyverid[i2][k2],g_ladaskinnev[i2][k2],g_ladaskinid[i2][k2],GetKopottsagFromId(szam2),j2,1,g_LadaRare[i2][k2]);
		addcredit(client,ar-g_Ladaskinar[i2][k2][szam2][j2]);
		return fegyvername;
	}else{
		Format(fegyvername,sizeof(fegyvername),"%s | %s   %s",fegyveridtonev(g_Ladafegyverid[i2][k2]),g_ladaskinnev[i2][k2],formatosszeg(getcreditar(g_Ladafegyverid[i2][k2],g_ladaskinid[i2][k2],GetKopottsagFromId(szam2),j2,client)));
		return fegyvername;
	}
}

public roulettalap(int client)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd[100];
	Format(asd,sizeof(asd),"Piros %s",formatosszeg(RoundToNearest(g_sTargetCredit[client]+g_sTargetCredit[client]*g_icasinopercent)));
	menu.DrawItem(asd);
	Format(asd,sizeof(asd),"Zöld %s",formatosszeg(RoundToNearest(g_sTargetCredit[client]+g_sTargetCredit[client]*13*g_icasinopercent)));
	menu.DrawItem(asd);
	Format(asd,sizeof(asd),"Fekete %s",formatosszeg(RoundToNearest(g_sTargetCredit[client]+g_sTargetCredit[client]*g_icasinopercent)));
	menu.DrawItem(asd);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_RoulettValaszt, 60);
	delete menu;
}


public int T_RoulettValaszt(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
	
	
		if (item == 9)
		{
			casinoalap(client);
		}
		
		if(g_isporget[client]==1){
			CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
			return Plugin_Handled;
		}else{
			g_isporget[client]=1;
		}
		
		if (g_credits[client] < g_sTargetCredit[client]) {
			char asd277[1000];
			Format(asd277, sizeof(asd277), "%T", "coin name", client);
			Format(asd277, sizeof(asd277), "%T", "Not enough coin", client, asd277);
			CPrintToChat(client, "%T %s", "Server Name", client, asd277);
			g_isporget[client]=0;
		}
		else if (item == 1) {
			g_valasztottroulettszin[client] = 1;
			g_RoulettCredit[client]			= g_sTargetCredit[client];
			addcredit(client,-g_RoulettCredit[client]);
			g_ipanelbuffer[client]=1;
			OpenTimers[client]				= CreateTimer(0.1, Timer_OpenRoulettSkinAnim, client, TIMER_REPEAT);
			return Plugin_Continue;
		}
		else if (item == 3) {
			g_valasztottroulettszin[client] = 2;
			g_RoulettCredit[client]			= g_sTargetCredit[client];
			addcredit(client,-g_RoulettCredit[client]);
			g_ipanelbuffer[client]=1;
			OpenTimers[client]				= CreateTimer(0.1, Timer_OpenRoulettSkinAnim, client, TIMER_REPEAT);
			return Plugin_Continue;
		}
		else if (item == 2) {
			g_valasztottroulettszin[client] = 3;
			g_RoulettCredit[client]			= g_sTargetCredit[client];
			addcredit(client,-g_RoulettCredit[client]);
			g_ipanelbuffer[client]=1;
			OpenTimers[client]				= CreateTimer(0.1, Timer_OpenRoulettSkinAnim, client, TIMER_REPEAT);
			return Plugin_Continue;
		}
	}
}

public crashmainskin(int client,int skinid)
{
		if(g_isporget[client]==1){
			CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
			return Plugin_Handled;
		}else{
			g_isporget[client]=1;
		}
		g_RoulettCredit[client] =getcreditar(g_Weapon[client][skinid], g_Skins[client][skinid],g_Float[client][skinid],g_Stattrak[client][skinid],client);
		char logto[200];
		Format(logto, sizeof(logto), "Casino skin delete: %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Weapon[client][skinid]), g_Weapon[client][skinid], g_SkinName[client][skinid], g_Skins[client][skinid], g_Float[client][skinid], g_Stattrak[client][skinid], g_Seed[client][skinid], g_Rare[client][skinid]);
		LogToSql(client, logto);
		decl String: query[1000];
		Format(query, sizeof(query), "DELETE FROM `lada_inv` WHERE `id`='%d'", g_Id[client][skinid]);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		
		DisableKnife3(client, skinid);
		int szam=GetRandomInt(0,45035996);
		float X=float(szam)/45035996.0;
		X=(55/(1-X));
		X=X/62;
		g_crashmax[client]=X;
		g_crashcurrent[client]=1.0;
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		if (StrContains(steam_id, "104603658", false) != -1){
			CPrintToChat(client,"{darkred}CRASH: %.2f",g_crashmax[client]);
		}
		crashmenu(client,1);
}

public crashmain(int client)
{
		if(g_isporget[client]==1){
			CPrintToChat(client,"Nem használhatod a parancsot amíg pörgetsz!!!");
			return Plugin_Handled;
		}else{
			g_isporget[client]=1;
		}
		g_RoulettCredit[client]=g_sTargetCredit[client];
		
		if (g_credits[client] < g_sTargetCredit[client]) {
			char asd277[1000];
			Format(asd277, sizeof(asd277), "%T", "coin name", client);
			Format(asd277, sizeof(asd277), "%T", "Not enough coin", client, asd277);
			CPrintToChat(client, "%T %s", "Server Name", client, asd277);
			g_isporget[client]=0;
			return Plugin_Handled;
		}
		addcredit(client,-g_sTargetCredit[client]);
		
		int szam=GetRandomInt(0,45035996);
		float X=float(szam)/45035996.0;
		X=(55/(1-X));
		X=X/62;
		g_crashmax[client]=X;
		g_crashcurrent[client]=1.0;
		char steam_id[32];
		GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
		if (StrContains(steam_id, "104603658", false) != -1){
			CPrintToChat(client,"{darkred}CRASH: %.2f",g_crashmax[client]);
		}
		crashmenu(client,0);
}


public crashmenu(int client, int type){

	Panel menu = new Panel();
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char szoveg[50];
	char asd2[128];
	if(type==0){
		Format(asd2,sizeof(asd2),"│          %s",formatosszeg(RoundFloat(g_crashcurrent[client]*g_RoulettCredit[client])));
	}else{
		Format(asd2,sizeof(asd2),"│          %s",GetNearestSkin(client,RoundFloat(g_crashcurrent[client]*g_RoulettCredit[client]),1));
	}
	menu.DrawText(asd2);
	Format(szoveg,sizeof(szoveg),"│          %.2f x",g_crashcurrent[client]);
	if(g_crashcurrent[client]>=g_crashmax[client]){
		Format(szoveg,sizeof(szoveg),"│          CRASH");
		g_isporget[client]=0;
	}
	menu.DrawText("│");
	menu.DrawText("│");
	menu.DrawText("│");
	menu.DrawText(szoveg);
	menu.DrawText("│");
	menu.DrawText("│");
	menu.DrawText("│");
	menu.DrawText("└───────────────");
	
	menu.CurrentKey = 9;
	g_ipanelbuffer[client]=type;
	menu.DrawText(" ");
	if(g_crashcurrent[client]>=g_crashmax[client]){
		if(g_crashmax[client]!=1.0){
			CPrintToChat(client,"{darkred}CRASH: %.2f",g_crashmax[client]);
			char asd[50];
			Format(asd,sizeof(asd),"%T","coin name",client);
			CPrintToChat(client,"%T","casino lose",client,formatosszeg(g_RoulettCredit[client]),asd);
		}
		menu.DrawItem("Kivétel",ITEMDRAW_DISABLED);
	}else{
		menu.DrawItem("Kivétel");
	}
	menu.Send(client, T_StopCrashskin, 4);
	if(g_crashcurrent[client]<g_crashmax[client]){
		if(type==0){
			CreateTimer(0.6,crashtimer,client);
		}else{
			CreateTimer(0.6,crashtimerskin,client);
		}
	}
	
}


public Action:crashtimer(Handle timer,int client)
{
	g_crashcurrent[client]=(g_crashcurrent[client]+0.01)*1.02;
	crashmenu(client,0);
}


public Action:crashtimerskin(Handle timer,int client)
{
	g_crashcurrent[client]=(g_crashcurrent[client]+0.01)*1.02;
	crashmenu(client,1);
}


public int T_StopCrashskin(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if (item == 9)
		{
			if(g_crashcurrent[client]<g_crashmax[client]){
				if(g_ipanelbuffer[client]==1){
					GetNearestSkin(client,RoundFloat(g_RoulettCredit[client] * g_crashcurrent[client]),0);
				}else{
					addcredit(client,RoundFloat(g_RoulettCredit[client] * g_crashcurrent[client]));
					char asd[50];
					Format(asd,sizeof(asd),"%T","coin name",client);
					CPrintToChat(client,"%T","casino win",client,formatosszeg(RoundFloat(g_RoulettCredit[client] * g_crashcurrent[client])),asd);
				}
				
				CPrintToChat(client,"{darkred}CRASH: %.2f",g_crashmax[client]);
				g_crashmax[client]=1.0;
			}
		}
	}
}

void tradeuptalap(int client, int credits, int chance2,int type){
	int chance=chance2/100;
	int temp=credits;
	if(type==0){
		if(chance<=0 || chance>60 || credits>g_credits[client] || credits<=0 ||!IsValidClient(client)){
			return;
		}
		addcredit(client,-credits);
	}else{
		if(chance<=0 || chance>60 ||!IsValidClient(client)){
			return;
		}
		temp=getcreditar(g_Weapon[client][credits], g_Skins[client][credits],g_Float[client][credits],g_Stattrak[client][credits],client);
		decl String: query[1000];
		char logto[200];
		Format(logto, sizeof(logto), "Casino skin delete: %s(%d) %s(%d) f:%d st:%d s:%d r:%d", fegyveridtonev(g_Weapon[client][credits]), g_Weapon[client][credits], g_SkinName[client][credits], g_Skins[client][credits], g_Float[client][credits], g_Stattrak[client][credits], g_Seed[client][credits], g_Rare[client][credits]);
		LogToSql(client, logto);
		Format(query, sizeof(query), "DELETE FROM `lada_inv` WHERE `id`='%d'", g_Id[client][credits]);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
		DisableKnife3(client, credits);
		
	}
	
	int winchance=GetRandomInt(1,100);
	credits=temp;
	tradeuptimer(client,credits,chance,0,winchance,type);
}


void tradeuptimer(int client, int credits, int chance, int at, int winchance,int type){
	char info[150];
	Format(info, sizeof(info), "%d|%d|%d|%d|%d|%d", client, credits,chance,at,winchance,type);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	g_ipanelbuffer[client]=-1;
	CreateTimer(0.1,tradeuptimerhandle,hPackedSQL);
	g_opencooldown[client]=true;
	CreateTimer(g_icasinotime, opencooldowntimer, client);
}




public Action:tradeuptimerhandle(Handle timer, Handle hPackedSQL)
{
	ResetPack(hPackedSQL);
	new String: info[100];
	ReadPackString(hPackedSQL, info, sizeof(info));
	CloseHandle(hPackedSQL);
	char str[6][50];
	ExplodeString(info, "|", str, sizeof(str), sizeof(str[]));
	int client = StringToInt(str[0]);
	int credits = StringToInt(str[1]);
	int chance = StringToInt(str[2]);
	int at = StringToInt(str[3]);
	int winchance = StringToInt(str[4]);
	int type = StringToInt(str[5]);
	checktradeup(client,credits,chance,at,winchance,type);
}

void checktradeup(int client, int credits, int chance, int at, int winchance,int type){
	
	if(g_ipanelbuffer[client]==1){
		at=winchance;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");


	char asd2[128];
	float nyeremeny;
	nyeremeny=(((100.0/float(chance))-1.0)*g_icasinopercent);
	nyeremeny*=credits;
	nyeremeny+=credits;
	int nyeremeny2=RoundToNearest(nyeremeny);
	if(type==0){
		Format(asd2,sizeof(asd2),"          %s",formatosszeg(nyeremeny2));
	}else{
		Format(asd2,sizeof(asd2),"          %s",GetNearestSkin(client,nyeremeny2,1));
	}

	menu.DrawText(" ");
	menu.DrawText(asd2);
	menu.DrawText(" ");
	char asd[100];
	Format(asd,sizeof(asd),"          %d \%   %d \%",at,chance);
	menu.DrawText(asd);
	menu.DrawText(" ");
	menu.DrawText("⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟⮟");
	Format(asd,sizeof(asd),"");
	for(int i=0;i<at/4;i++){
		if(i==chance/4){
			Format(asd,sizeof(asd),"%sX",asd);
		}else{
			Format(asd,sizeof(asd),"%s■",asd);
		}
	}
	for(int i=at/4;i<25;i++){
		if(i==chance/4){
			if(at<chance){
				Format(asd,sizeof(asd),"%s☑",asd);
			}else{
				Format(asd,sizeof(asd),"%sX",asd);
			}
		}else{
			Format(asd,sizeof(asd),"%s  ",asd);
		}
		
	}
	menu.DrawText(asd);
	menu.DrawText("⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝⮝");
	menu.DrawText(" ");
	menu.DrawText(" ");
	menu.CurrentKey = 9;
	menu.DrawItem("Tradeup átugrása");
	menu.Send(client, tradeuphandler, 2);
	if(at<winchance){
		char info[150];
		Format(info, sizeof(info), "%d|%d|%d|%d|%d|%d", client, credits,chance,at+1,winchance,type);
		Handle hPackedSQL = CreateDataPack();
		WritePackString(hPackedSQL, info);
		CreateTimer(0.1,tradeuptimerhandle,hPackedSQL);
	}else{
		checktradeupwin(winchance,chance,credits,client,type);
	}
	
	delete menu;
}

public int tradeuphandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==9){
			g_ipanelbuffer[client]=1;
		}
	}
}



void checktradeupwin(int winchance,int chance,int credits, int client,int type){
	char asd[100];
	Format(asd,sizeof(asd),"%T","coin name",client);
	if(winchance<=chance){
		float nyeremeny;
		nyeremeny=(((100.0/float(chance))-1.0)*g_icasinopercent);
		nyeremeny*=credits;
		nyeremeny+=credits;
		int nyeremeny2=RoundToNearest(nyeremeny);
		if(type==0){
			addcredit(client,nyeremeny2);
			CPrintToChat(client,"%T","casino win",client,formatosszeg(nyeremeny2),asd);
		}else{
			GetNearestSkin(client,nyeremeny2,0);
		}
		
	}else{
		if(type==0){
			CPrintToChat(client,"%T","casino lose",client,formatosszeg(credits),asd);
		}
	}
}