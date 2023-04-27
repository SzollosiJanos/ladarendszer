int showtrade(int client){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]==666){
		return;
	}
	if(isvalidtradepartner(client)){
		showtrademain(client);
		return;
	}

	if(g_tradepartner[client]<0){
		CPrintToChat(client,"%T","trade error already in trade",client);
		return;
	}
	trade_reset(client);
	
	Menu menu = CreateMenu(SelectTradePartner);

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	char nev[100];
	char asd2[11];
	for (int i = 0; i < MAXPLAYERS; i++)
	{
		if(g_tradepartner[i]>0){
			continue;
		}
		if (IsValidClient(i) && i != client)
		{
		if (!CheckCommandAccess(i, "sm_adminflaggg", ADMFLAG_CUSTOM2) || GetClientTeam(i) != 1)
			{
				GetClientName(i, nev, sizeof(nev));
					ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
				Format(asd2, sizeof(asd2), "%d", i);
				menu.AddItem(asd2, nev);
			}
		}
	}
	menu.Display(client, 60);
}



public int SelectTradePartner(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int target = StringToInt(info);
		if(g_tradepartner[target]<0 || g_tradepartner[client]<0){
			CPrintToChat(client,"%T %T","Server Name",client,"trade error already in trade",client);
			return Plugin_Handled;
		}
		g_tradepartner[client]=-target;
		g_tradepartner[target]=-client;
		sendtradeinvite(client,target);
		CreateTimer(20.0,DeleteTradeInvite,client);
		CreateTimer(20.0,DeleteTradeInvite,target);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}


public Action:DeleteTradeInvite(Handle timer, int client)
{
	if(g_tradepartner[client]<0 || g_tradepartner[client]==client){
		g_tradepartner[client]=0;
		CPrintToChat(client,"%T %T","Server Name",client,"trade expired",client);
	}
}

void sendtradeinvite(int client, int target){
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[200];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client,formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	char nev[50];
	GetClientName(client,nev,sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	Format(asd2,sizeof(asd2),"%T","got invite",target,nev);
	menu.DrawText(asd2);
	menu.DrawText(" ");
	menu.CurrentKey = 3;
	menu.DrawItem("Igen");
	menu.DrawItem("Nem");
	menu.Send(target, sendtradeinvitehandler, 20);
	delete menu;
}


public int sendtradeinvitehandler(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(item==3){
			if(g_tradepartner[client]<0 && g_tradepartner[g_tradepartner[client]*-1]<0){
				g_tradepartner[client]=g_tradepartner[client]*-1;
				g_tradepartner[g_tradepartner[client]]=client;
				trade_reset(client);
				trade_reset(g_tradepartner[client]);
				showtrademain(client);
				showtrademain(g_tradepartner[client]);
			}
		}
		
	}
}


void showtrademain(int client){
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[200];
	Format(asd2,sizeof(asd2),"%T","trade max",client);
	menu.DrawText(asd2);
	menu.DrawText(" ");
	
	char nev[50];
	GetClientName(g_tradepartner[client],nev,sizeof(nev));
		ReplaceString(nev, sizeof(nev), "'", "");
					ReplaceString(nev, sizeof(nev), "\"", "");
					ReplaceString(nev, sizeof(nev), ";", "");
	Format(asd2,sizeof(asd2),"%T","trade partner",client,nev);
	menu.DrawText(asd2);
	menu.DrawText(" ");
	Format(asd2,sizeof(asd2),"%T","trade coin client",client,formatosszeg(g_tradecoin[client]));
	menu.DrawItem(asd2);
	Format(asd2,sizeof(asd2),"%T","trade coin target",client,formatosszeg(g_tradecoin[g_tradepartner[client]]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	Format(asd2,sizeof(asd2),"%T","trade item client",client);
	menu.DrawItem(asd2);
	Format(asd2,sizeof(asd2),"%T","trade item target",client);
	menu.DrawItem(asd2);
	menu.DrawText(" ");
	Format(asd2,sizeof(asd2),"%T","trade item add",client);
	menu.DrawItem(asd2);
	Format(asd2,sizeof(asd2),"%T","trade item remove",client);
	menu.DrawItem(asd2);
	menu.DrawText(" ");
	if(g_tradeready[client]){
		Format(asd2,sizeof(asd2),"%T","trade cancel accept",client);
		menu.DrawItem(asd2);
	}else{
		Format(asd2,sizeof(asd2),"%T","trade accept",client);
		menu.DrawItem(asd2);
	}
	Format(asd2,sizeof(asd2),"%T","trade cancel",client);
	menu.DrawItem(asd2);
	menu.CurrentKey = 9;
	menu.DrawText(" ");
	menu.DrawItem("Menü frissítése");
	menu.Send(client, showtrademainhandler, 60);
	delete menu;
}

public int showtrademainhandler(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else if(item==1){
			g_tradecoininserted[client]=true;
			CPrintToChat(client,"%T %T","Server Name",client,"trade coin chat",client);
		}else if(item==2){
			trade_listitems(client,client);
		}else if(item==3){
			trade_listitems(client,g_tradepartner[client]);
		}else if(item==4){
			trade_additems(client);
		}else if(item==5){
			trade_removeitems(client);
		}else if(item==6){
			if(g_tradeready[client]==true){
				g_tradeready[client]=false;
				CPrintToChat(g_tradepartner[client],"%T %T","Server Name",g_tradepartner[client],"trade cancelled",g_tradepartner[client]);
			}else{
				g_tradeready[client]=true;
				CPrintToChat(g_tradepartner[client],"%T %T","Server Name",g_tradepartner[client],"trade accepted",g_tradepartner[client]);
			}
			
			if(g_tradeready[client]==true && g_tradeready[g_tradepartner[client]]==true){
				CPrintToChat(client,"%T %T","Server Name",client,"trade send",client);
				CPrintToChat(g_tradepartner[client],"%T %T","Server Name",g_tradepartner[client],"trade send",g_tradepartner[client]);
				CreateTimer(5.0,SendTradeOffer,client);
			}
			showtrade(client);
		}else if(item==7){
			CPrintToChat(g_tradepartner[client],"A partnered elutasította a cserét!");
			g_tradepartner[g_tradepartner[client]]=0;
			trade_reset(g_tradepartner[client]);
			g_tradepartner[client]=0;
			trade_reset(client);
			
		}else if(item==9){
			showtrade(client);
		}
		
	}
}


void trade_additems(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[200];
	Format(asd2,sizeof(asd2),"%T","trade max",client);
	menu.DrawText(" ");
	menu.DrawItem("Ládák");
	menu.DrawItem("Kulcsok");
	menu.DrawItem("Skinek");
	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, trade_additemshandler, 60);
	
	delete menu;
}


public int trade_additemshandler(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else if(item==1){
			trade_addcases(client);
		}else if(item==2){
			trade_addkeys(client);
		}else if(item==3){
			trade_addskins(client);
		}else{
			showtrade(client);
		}
		
	}
}


void trade_addcases(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_addcaseshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_lada[client][i][0]==0 || g_lada[client][i][0]<=g_tradelada[client][i]){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s láda: %d", ladaidtonev(i), g_lada[client][i][0]);
		menu.AddItem(asd2, szoveg);
	}
	menu.Display(client, 60);
	
}

public int trade_addcaseshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else{
			char info[100];
			menu.GetItem(item, info, sizeof(info));
			int	 lada	  = StringToInt(info, 10);
			g_tradelada[client][lada]++;
			tradechanged(client);
			showtrade(client);
		}
		
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

void trade_addkeys(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_addkeyshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_lada[client][i][1]==0 ||g_lada[client][i][1]<=g_tradekulcs[client][i]){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s ládakulcs: %d", ladaidtonev(i), g_lada[client][i][1]);
		menu.AddItem(asd2, szoveg);
	}
	menu.Display(client, 60);
	
}


public int trade_addkeyshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else{
			char info[100];
			menu.GetItem(item, info, sizeof(info));
			int	 lada	  = StringToInt(info, 10);
			g_tradekulcs[client][lada]++;
			tradechanged(client);
			showtrade(client);
		}
		
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}


void trade_listitems(int client, int target){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[200];
	Format(asd2,sizeof(asd2),"%T","trade max",client);
	menu.DrawText(" ");
	menu.DrawItem("Ládák");
	menu.DrawItem("Kulcsok");
	menu.DrawItem("Skinek");
	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	if(client==target){
		menu.Send(client, trade_listitemshandler, 60);
	}else{
		menu.Send(client, trade_listitemshandler2, 60);
	}
	
	delete menu;
}



public int trade_listitemshandler(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else if(item==1){
			trade_listcases(client,client);
		}else if(item==2){
			trade_listkeys(client,client);
		}else if(item==3){
			trade_listskins(client,client);
		}else{
			showtrade(client);
		}
		
	}
}

public int trade_listitemshandler2(Menu menu2, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else if(item==1){
			trade_listcases(client,g_tradepartner[client]);
		}else if(item==2){
			trade_listkeys(client,g_tradepartner[client]);
		}else if(item==3){
			trade_listskins(client,g_tradepartner[client]);
		}else{
			showtrade(client);
		}
		
	}
}

void trade_listcases(int client, int target){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_listcaseshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradelada[target][i]==0){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s láda: %d", ladaidtonev(i), g_tradelada[target][i]);
		menu.AddItem(asd2, szoveg,ITEMDRAW_DISABLED);
	}
	menu.Display(client, 60);
}

void trade_listkeys(int client, int target){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_listcaseshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradekulcs[target][i]==0){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s ládakulcs: %d", ladaidtonev(i), g_tradekulcs[target][i]);
		menu.AddItem(asd2, szoveg,ITEMDRAW_DISABLED);
	}
	menu.Display(client, 60);
}

void trade_listskins(int client, int target){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_listcaseshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i < 100; i++)
	{
		if(g_tradeskin[target][i]==-1){
			continue;
		}
		IntToString(g_tradeskin[target][i], asd2, sizeof(asd2));
		char almafa[500];
		if (g_Stattrak[target][g_tradeskin[target][i]])
		{
			Format(almafa, sizeof(almafa), "%s%s ST", rareidtostart(target, g_Rare[target][g_tradeskin[target][i]]), fegyveridtonev(g_Weapon[target][g_tradeskin[target][i]]));
		}
		else {
			Format(almafa, sizeof(almafa), "%s%s", rareidtostart(target, g_Rare[target][g_tradeskin[target][i]]), fegyveridtonev(g_Weapon[target][g_tradeskin[target][i]]));
		}
		Format(almafa, sizeof(almafa), "%s\n%s", almafa, g_SkinName[target][g_tradeskin[target][i]]);
		menu.AddItem("4", almafa, ITEMDRAW_DISABLED);
	}
	menu.Display(client, 60);
}


public int trade_listcaseshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}



bool isvalidtradepartner(int client){
	if(IsValidClient(client) && IsValidClient(g_tradepartner[client]) && client == g_tradepartner[g_tradepartner[client]] && client!=g_tradepartner[client]){
		return true;
	}
	return false;
}

void tradechanged(int client){
	CPrintToChat(g_tradepartner[client],"%T %T","Server Name",g_tradepartner[client],"trade changed",g_tradepartner[client]);
	g_tradeready[g_tradepartner[client]]=false;
	g_tradeready[client]=false;
}






void trade_removeitems(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[200];
	Format(asd2,sizeof(asd2),"%T","trade max",client);
	menu.DrawText(" ");
	menu.DrawItem("Ládák");
	menu.DrawItem("Kulcsok");
	menu.DrawItem("Skinek");
	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, trade_removeitemshandler, 60);
	
	delete menu;
}


public int trade_removeitemshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else if(item==1){
			trade_removecases(client);
		}else if(item==2){
			trade_removekeys(client);
		}else if(item==3){
			trade_removeskins(client);
		}else{
			showtrade(client);
		}
		
	}
}


void trade_removecases(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_removecaseshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradelada[client][i]==0){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s láda: %d", ladaidtonev(i), g_tradelada[client][i]);
		menu.AddItem(asd2, szoveg);
	}
	menu.Display(client, 60);
	
}

public int trade_removecaseshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else{
			char info[100];
			menu.GetItem(item, info, sizeof(info));
			int	 lada	  = StringToInt(info, 10);
			g_tradelada[client][lada]--;
			tradechanged(client);
			showtrade(client);
		}
		
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

void trade_removekeys(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_removekeyshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradekulcs[client][i]==0){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		Format(szoveg, sizeof(szoveg), "%s ládakulcs: %d", ladaidtonev(i), g_tradekulcs[client][i]);
		menu.AddItem(asd2, szoveg);
	}
	menu.Display(client, 60);
	
}


public int trade_removekeyshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else{
			char info[100];
			menu.GetItem(item, info, sizeof(info));
			int	 lada	  = StringToInt(info, 10);
			g_tradekulcs[client][lada]--;
			tradechanged(client);
			showtrade(client);
		}
		
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}


void trade_removeskins(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_removeskinshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	for (int i = 0; i < 100; i++)
	{
		if(g_tradeskin[client][i]==-1){
			continue;
		}
		IntToString(i, asd2, sizeof(asd2));
		char almafa[500];
		if (g_Stattrak[client][g_tradeskin[client][i]])
		{
			Format(almafa, sizeof(almafa), "%s%s ST", rareidtostart(client, g_Rare[client][g_tradeskin[client][i]]), fegyveridtonev(g_Weapon[client][g_tradeskin[client][i]]));
		}
		else {
			Format(almafa, sizeof(almafa), "%s%s", rareidtostart(client, g_Rare[client][g_tradeskin[client][i]]), fegyveridtonev(g_Weapon[client][g_tradeskin[client][i]]));
		}
		Format(almafa, sizeof(almafa), "%s\n%s", almafa, g_SkinName[client][g_tradeskin[client][i]]);
		menu.AddItem(asd2, almafa);
	}
	menu.Display(client, 60);
}


public int trade_removeskinshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else{
			char info[100];
			menu.GetItem(item, info, sizeof(info));
			int	 skin	  = StringToInt(info, 10);
			g_tradeskin[client][skin]=-1;
			tradechanged(client);
			showtrade(client);
			
		}
		
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}




void trade_addskins(int client){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	Menu menu = CreateMenu(trade_addskinshandler);
	menu.SetTitle(" » MegoltElek ládarendszer « ");
	char asd2[11];
	char szoveg[100];
	bool okay=true;
	for (int i = 1; i < g_DB[client]; i++)
	{
		if(g_fegyvid[client][Getfegyverid(client, i)]==i || g_skinlocked[client][i]){
			continue;
		}
		
		for(int j=0;j<100;j++){
			if(i==g_tradeskin[client][j]){
				okay=false;
				break;
			}
		}
		
		if(okay==false){
			okay=true;
			continue;
		}
		
		IntToString(i, asd2, sizeof(asd2));
		char almafa[500];
		if (g_Stattrak[client][i])
		{
			Format(almafa, sizeof(almafa), "%s%s ST", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]));
		}
		else {
			Format(almafa, sizeof(almafa), "%s%s", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]));
		}
		Format(almafa, sizeof(almafa), "%s\n%s", almafa, g_SkinName[client][i]);
		menu.AddItem(asd2, almafa);
	}
	menu.Display(client, 60);
}


public int trade_addskinshandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		if(!isvalidtradepartner(client))
		{
			g_tradepartner[client]=0;
		}else{
			char info[100];
			menu.GetItem(item, info, sizeof(info));
			int	 skin	  = StringToInt(info, 10);
			for (int i=0;i<100;i++){
				if(g_tradeskin[client][i]!=-1){
					continue;
				}
				g_tradeskin[client][i]=skin;
				break;
			}
			tradechanged(client);
			showtrade(client);
		}
		
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}



public Action:SendTradeOffer(Handle timer, int client)
{
	if(isvalidtradepartner(client) && g_tradeready[client] && g_tradeready[g_tradepartner[client]]){
		trade_sendcases(client, g_tradepartner[client]);
		trade_sendkeys(client, g_tradepartner[client]);
		trade_sendcredits(client, g_tradepartner[client]);
		trade_sendskins(client, g_tradepartner[client]);
		CPrintToChat(client,"Sikeres csere");
		CPrintToChat(g_tradepartner[client],"Sikeres csere");
		int temp2=g_tradepartner[client];
		g_tradepartner[g_tradepartner[client]]=666;
		g_tradepartner[client]=666;
		restart(client);
		restart(temp2);
		CreateTimer(10.0,resetpartner,temp2);
		CreateTimer(10.0,resetpartner2,temp2);
		CreateTimer(11.0,resetpartner,client);
		CreateTimer(11.0,resetpartner2,client);
	}
}


public Action:resetpartner(Handle timer, int client)
{
	g_tradepartner[client]=0;
}

public Action:resetpartner2(Handle timer, int client)
{
	restart(client);
	trade_reset(client);
}

public trade_sendskins(int client, int target)
{
	decl String: query[2000];
	char steam_id[32];
	
	
	
	GetClientAuthId(target, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	for(int i=0;i<100;i++){
		if(g_tradeskin[client][i]==-1)
		{
			continue;
		}
		char playername[100];
	GetClientName(target,playername,sizeof(playername));
		ReplaceString(playername, sizeof(playername), "'", "");
					ReplaceString(playername, sizeof(playername), "\"", "");
					ReplaceString(playername, sizeof(playername), ";", "");
	int buffer_len_playername = strlen(playername) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, playername, v_playername, buffer_len_playername);
		Format(query, sizeof(query), "UPDATE `lada_inv` SET skin_stattrak_count=0,steam_id='%s',player_name='%s',skin_last=0 WHERE id='%d'", v_steam_id, v_playername, g_Id[client][g_tradeskin[client][i]]);
		SQL_TQuery(hDatabase, T_tradeatad, query, client);
	}
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	for(int i=0;i<100;i++){
		if(g_tradeskin[target][i]==-1)
		{
			continue;
		}
		char playername[100];
	GetClientName(client,playername,sizeof(playername));
			ReplaceString(playername, sizeof(playername), "'", "");
					ReplaceString(playername, sizeof(playername), "\"", "");
					ReplaceString(playername, sizeof(playername), ";", "");
	int buffer_len_playername = strlen(playername) * 2 + 1;
	new String: v_playername[buffer_len_playername];
	SQL_EscapeString(hDatabase, playername, v_playername, buffer_len_playername);
		Format(query, sizeof(query), "UPDATE `lada_inv` SET skin_stattrak_count=0,steam_id='%s',player_name='%s',skin_last=0 WHERE id='%d'", v_steam_id, v_playername, g_Id[target][g_tradeskin[target][i]]);
		SQL_TQuery(hDatabase, T_tradeatad, query, target);
	}
}



public T_tradeatad(Handle owner, Handle hndl, const String:error[], int client)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	return;
}


void trade_sendcredits(int client, int target){
	addcredit(client,g_tradecoin[target]);
	addcredit(client,-g_tradecoin[client]);
	addcredit(target,g_tradecoin[client]);
	addcredit(target,-g_tradecoin[target]);
}

void trade_sendcases(int client, int target){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradelada[target][i]==0){
			continue;
		}
		addlada(client,i,g_tradelada[target][i]);
		addlada(target,i,-g_tradelada[target][i]);
	}
	
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradelada[client][i]==0){
			continue;
		}
		addlada(target,i,g_tradelada[client][i]);
		addlada(client,i,-g_tradelada[client][i]);
	}
	
}

void trade_sendkeys(int client, int target){
	if(!isvalidtradepartner(client))
	{
		g_tradepartner[client]=0;
	}
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradekulcs[target][i]==0){
			continue;
		}
		addkey(client,i,g_tradekulcs[target][i]);
		addkey(target,i,-g_tradekulcs[target][i]);
	}
	
	for (int i = 0; i <= maxloadedlada; i++)
	{
		if(g_tradekulcs[client][i]==0){
			continue;
		}
		addkey(target,i,g_tradekulcs[client][i]);
		addkey(client,i,-g_tradekulcs[client][i]);
	}
}

void trade_reset(int client){
		g_tradecoin[client]=0;
		g_tradecoininserted[client]=false;
		g_tradeready[client]=false;
		for (int i=0;i<100;i++){
			g_tradeskin[client][i]=-1;
		}
		for (int i=0;i<100;i++){
			g_tradelada[client][i]=0;
			g_tradekulcs[client][i]=0;
		}
}