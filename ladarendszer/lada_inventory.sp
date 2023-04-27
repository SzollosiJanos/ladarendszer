

public showplayeritems(int client){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	Panel menu = new Panel();

		menu.SetTitle(" » MegoltElek ládarendszer « ");
		menu.DrawText(" ");
		char asd2[100];
		Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client,formatosszeg(g_credits[client]));
		menu.DrawText(asd2);
		menu.DrawText(" ");

		menu.DrawItem("Inventory");
		menu.DrawItem("Rendezett inventory");
		menu.DrawText(" ");
		menu.CurrentKey = 9;
		char exit2[50];
		Format(exit2, sizeof(exit2), "%T", "back", client);
		menu.DrawItem(exit2);
		menu.Send(client, showplayeritemshandler, 60);
		delete menu;
}


public int showplayeritemshandler(Menu menu2, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		if(item==1){
			showplayeritems2(client,-1);
		}else if(item==2){
			sortinventory(client);
		}else{
			Cmd_mainmenu(client);
		}
	}
}


int sortinventory(int client){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char szam[100];
	char szoveg[100];
	Menu menu = CreateMenu(T_InvMainFegyver);
	menu.SetTitle("Válassz fegyvert");
	Format(szam, sizeof(szam), "-1");
	for (int i = 0; i <= 52; i++)
	{
		if(!hasweaponid(client,i)){
			continue;
		}
		Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(i));
		Format(szam, sizeof(szam), "%d", i);
		menu.AddItem(szam, szoveg);
	}
	Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(4725));
	Format(szam, sizeof(szam), "%d", 4725);
	if(hasweaponid(client,4725)){
		menu.AddItem(szam, szoveg);
	}
	
	Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(5027));
	Format(szam, sizeof(szam), "%d", 5027);
	if(hasweaponid(client,5027)){
		menu.AddItem(szam, szoveg);
	}
	for (int i = 5030; i <= 5035; i++)
	{
		if(!hasweaponid(client,i)){
			continue;
		}
		Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(i));
		Format(szam, sizeof(szam), "%d", i);
		menu.AddItem(szam, szoveg);
	}
	menu.Display(client, 60);
}



public int T_InvMainFegyver(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info);
		showplayeritems2(client,szam);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public showplayeritems2(int client,int weapon)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	int counter=0;
	if(g_tradepartner[client]==666||g_tradepartner[client]!=0){
		return;
	}
	if (g_isopening[client] == 0 && g_isporget[client]==0)
	{
		Menu menu = CreateMenu(PlayerInventory);
		menu.SetTitle("Raktár");
		char almafa[100];
		char asd2[10];
		for (int i = g_DB[client] - 1; i > 0; i--)
		{
			if(g_Rare[client][i]==8){
				if (g_Stattrak[client][i] == 0)
			{
				if (g_fegyvid[client][Getfegyverid(client, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s %s %s [E]", rareidtostart(client, g_Rare[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s %s %s", rareidtostart(client, g_Rare[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
			}
			else {
				if (g_fegyvid[client][Getfegyverid(client, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s %s ST %s [E]", rareidtostart(client, g_Rare[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s %s ST %s", rareidtostart(client, g_Rare[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
			}
			}else{
				if (g_Stattrak[client][i] == 0)
			{
				if (g_fegyvid[client][Getfegyverid(client, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s%s | %s %s [E]", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s%s | %s %s", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
			}
			else {
				if (g_fegyvid[client][Getfegyverid(client, i)] == i)
				{
					Format(almafa, sizeof(almafa), "%s%s | %s ST %s [E]", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
				else {
					Format(almafa, sizeof(almafa), "%s%s | %s ST %s", rareidtostart(client, g_Rare[client][i]), fegyveridtonev(g_Weapon[client][i]), g_SkinName[client][i], GetKopottsagFromFloatRovid(g_Float[client][i]));
				}
			}
			}
			IntToString(i, asd2, sizeof(asd2));
			if(weapon==-1 || g_Weapon[client][i]==weapon){
				if(g_multiplecaseopen[client]!=-1){
					menu.AddItem(asd2, almafa,ITEMDRAW_DISABLED);
				}else{
					menu.AddItem(asd2, almafa);
				}
				
				counter++;
			}
			
		}
		if (g_DB[client] == 1 || counter==0)
		{
			CPrintToChat(client, "%T %T", "Server Name", client, "error no skin2", client);
		}

		menu.Display(client, 60);
	}
	else {
		CPrintToChat(client, "%T %T", "Server Name", client, "error cant open cases", client);
	}
}

public int PlayerInventory(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int	 i	  = StringToInt(info, 10);
		showplayerskin(client,i);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int showplayerskin(int client, int i){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char query[1000];
	Format(query,sizeof(query),"Select skin_float from lada_inv where fegyver_id='%d' and skin_id='%d' order by skin_float Asc",g_Weapon[client][i],g_Skins[client][i]);
	char info[100];
	Format(info, sizeof(info), "%d|%d", client, i);
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, showplayerskinhandler, query, hPackedSQL);
}


public int showplayerskinhandler(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
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
	int i = StringToInt(str[1]);
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	int counter=0;
	int counted=-1;
	int temp;
	while(SQL_FetchRow(hndl)){
		temp=SQL_FetchInt(hndl,0);
		if(temp==g_Float[client][i] && counted==-1){
			counted=counter+1;
		}
		counter++;
	}
	showplayerskin2(client,i,counter,counted);
	return;
}

public int showplayerskin2(int client, int i,int counter, int counted){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char almafa[500];
	char asd2[100];
	char info[100];
	Format(info,sizeof(info),"%d",i);
	Menu menu = CreateMenu(PlayerSkinMenu);
		menu.SetTitle("Leltár");
		if (g_fegyvid[client][Getfegyverid(client, i)] != i)
		{
			Format(almafa, sizeof(almafa), "Fegyver használata");
			menu.AddItem(info, almafa);
		}
		else {
			Format(almafa, sizeof(almafa), "Fegyver levétele");
			Format(asd2, sizeof(asd2), "weapon_%s", info);
			menu.AddItem(asd2, almafa);
		}
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
		idg+=0.00001;
		Format(almafa, sizeof(almafa), "%s\nKopottság: %.5f\nRang: TOP %d \\ %d %s\nSeed: %d", almafa, idg,counted>RoundFloat(float(counter/2))?counter-counted+1:counted,counter,counted>RoundFloat(float(counter/2))?"Legkopottabb":"Legkevésbé kopott", g_Seed[client][i]);
		menu.AddItem("4", almafa, ITEMDRAW_DISABLED);
		Format(almafa, sizeof(almafa), "Fegyver eladása");
		Format(asd2, sizeof(asd2), "elad_%s", info);
		menu.AddItem(asd2, almafa);
		Format(asd2, sizeof(asd2), "lock_%s", info);
		if (g_skinlocked[client][i]==false)
		{
			Format(almafa, sizeof(almafa), "Fegyver zárolása");
		}
		else {
			Format(almafa, sizeof(almafa), "Fegyver zárolás feloldása");
		}
		menu.AddItem(asd2, almafa);
		Format(asd2, sizeof(asd2), "modosit_%s", info);
		menu.AddItem(asd2, "Fegyver módosítása");
		
		menu.AddItem("vissza", "Vissza");
		menu.Display(client, 60);
}


public int PlayerSkinMenu(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[100];
		char asd2[100];
		menu.GetItem(item, info, sizeof(info));
		if (StrContains(info, "vissza") != -1)
		{
			showplayeritems(client);
			return;
		}
		Format(asd2, sizeof(asd2), "%s", info);
		if (StrContains(info, "weapon_") != -1) {
			ReplaceString(asd2, sizeof(asd2), "weapon_", "");
			int i = StringToInt(asd2, 10);
			g_ipanelbuffer[client]=i;
			SaveCurrentStattrak2(client, i);
		}
		else if (StrContains(info, "elad_") != -1) {
			ReplaceString(asd2, sizeof(asd2), "elad_", "");
			int i = StringToInt(asd2, 10);
			g_ipanelbuffer[client]=i;
			eladskin(client, i);
		}else if (StrContains(info, "lock_") != -1) {
			ReplaceString(asd2, sizeof(asd2), "lock_", "");
			int i = StringToInt(asd2, 10);
			g_ipanelbuffer[client]=i;
			lockskin(client, i);
		}else if (StrContains(info, "modosit_") != -1) {
			ReplaceString(asd2, sizeof(asd2), "modosit_", "");
			int i = StringToInt(asd2, 10);
			g_ipanelbuffer[client]=i;
			modositskin(client, i);
		}
		else {
			int i = StringToInt(info, 10);
			g_ipanelbuffer[client]=i;
			SaveCurrentStattrak(client, i);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int modositskin(int client, int i){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
		Panel menu = new Panel();

		menu.SetTitle(" » MegoltElek ládarendszer « ");
		menu.DrawText(" ");
		char asd2[100];
		
		if(g_Stattrak[client][i]==1){
			Format(asd2, sizeof(asd2), "%T %s %T", "skin change stattrak off", client,formatosszeg(g_iStattrakOff),"coin name",client);
			if(g_credits[client]>g_iStattrakOff){
				menu.DrawItem(asd2);
			}else{
				menu.DrawItem(asd2,ITEMDRAW_DISABLED);
			}
		}else{
			Format(asd2, sizeof(asd2), "%T %s %T", "skin change stattrak on", client,formatosszeg(g_iStattrakOn),"coin name",client);
			if(g_credits[client]>g_iStattrakOn){
				menu.DrawItem(asd2);
			}else{
				menu.DrawItem(asd2,ITEMDRAW_DISABLED);
			}
		}
		float idg = float(g_Float[client][i]);
		idg		  = idg / 100000;
		Format(asd2, sizeof(asd2), "%T %s %T  %.5f", "skin change float", client,formatosszeg(g_ichangefloat),"coin name",client,idg);
		if(g_credits[client]>g_ichangefloat){
			menu.DrawItem(asd2);
		}else{
			menu.DrawItem(asd2,ITEMDRAW_DISABLED);
		}
		Format(asd2, sizeof(asd2), "%T %s %T  %d", "skin change seed", client,formatosszeg(g_ichangeseed),"coin name",client,g_Seed[client][i]);
		if(g_credits[client]>g_ichangeseed){
			menu.DrawItem(asd2);
		}else{
			menu.DrawItem(asd2,ITEMDRAW_DISABLED);
		}
		Format(asd2, sizeof(asd2), "%T %s %T  %s", "skin change nametag", client,formatosszeg(g_ichangenametag),"coin name",client,g_Nametag[client][i]);
		if(g_credits[client]>g_ichangenametag && g_Rare[client][g_ipanelbuffer[client]]!=7){
			menu.DrawItem(asd2);
		}else{
			menu.DrawItem(asd2,ITEMDRAW_DISABLED);
		}
		menu.DrawText(" ");
		menu.CurrentKey = 9;
		char exit2[50];
		Format(exit2, sizeof(exit2), "%T", "back", client);
		menu.DrawItem(exit2);
		menu.Send(client, modositskinhandler, 60);
		delete menu;
}


public int modositskinhandler(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char asd[100];
		char asd2[100];
		Format(asd2,sizeof(asd2),"%T","coin name",client);
		if(item==9){
			showplayerskin(client,g_ipanelbuffer[client]);
		}else if(item==1){
			if(g_Stattrak[client][g_ipanelbuffer[client]]){
				if(g_credits[client]>g_iStattrakOff){
					reroll(client,0);
					addcredit(client,-g_iStattrakOff);
				}else{
					Format(asd,sizeof(asd),"%T %T","Server Name",client,"Not enough coin",client,asd2);
				}
			}else{
				if(g_credits[client]>g_iStattrakOn){
					reroll(client,1);
					addcredit(client,-g_iStattrakOn);
				}else{
					Format(asd,sizeof(asd),"%T %T","Server Name",client,"Not enough coin",client,asd2);
				}
			}
			
		}else if(item==2){
			if(g_credits[client]>g_ichangefloat){
				reroll(client,2);
				addcredit(client,-g_ichangefloat);
			}else{
				Format(asd,sizeof(asd),"%T %T","Server Name",client,"Not enough coin",client,asd2);
			}
		}else if(item==3){
			if(g_credits[client]>g_ichangeseed){
				reroll(client,3);
				addcredit(client,-g_ichangeseed);
			}else{
				Format(asd,sizeof(asd),"%T %T","Server Name",client,"Not enough coin",client,asd2);
			}
		}else if(item==4){
			if(g_credits[client]>g_ichangenametag){
				g_changenametag[client]=true;
				CPrintToChat(client,"{darkred} Írd le a chatre a fegyvered új nametag-ét! Nametag törléséhez simán nyomj entert a chat-re!!");
			}else{
				Format(asd,sizeof(asd),"%T %T","Server Name",client,"Not enough coin",client,asd2);
			}
		}
		
	}
}

int reroll(int client, int type){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char query[1000];
	switch(type){
		case 0:{Format(query,sizeof(query),"update lada_inv set skin_stattrak=0 where id=%d",g_Id[client][g_ipanelbuffer[client]]);g_Stattrak[client][g_ipanelbuffer[client]]=0;}
		case 1:{Format(query,sizeof(query),"update lada_inv set skin_stattrak=1 where id=%d",g_Id[client][g_ipanelbuffer[client]]);g_Stattrak[client][g_ipanelbuffer[client]]=1;}
		case 2:{
			g_Float[client][g_ipanelbuffer[client]]=GetRandomKopottsag();
			Format(query,sizeof(query),"update lada_inv set skin_float=%d where id=%d",g_Float[client][g_ipanelbuffer[client]],g_Id[client][g_ipanelbuffer[client]]);
		}
		case 3:{
			g_Seed[client][g_ipanelbuffer[client]]=GetRandomInt(1, 1000);
			Format(query,sizeof(query),"update lada_inv set skin_seed=%d where id=%d",g_Seed[client][g_ipanelbuffer[client]],g_Id[client][g_ipanelbuffer[client]]);
		}
	}
	SQL_TQuery(hDatabase, T_ReRoll, query, client);
}



public T_ReRoll(Handle owner, Handle hndl, const String:error[], int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (hndl == INVALID_HANDLE)
	{
		LogError("[Ladarendszer] Query failed! %s", error);
	}
	modositskin(client,g_ipanelbuffer[client]);
	if(g_fegyvid[client][Getfegyverid(client, g_ipanelbuffer[client])]==g_ipanelbuffer[client]){
		LoadCurrentSkin(client, g_ipanelbuffer[client]);
	}
	return;
}

public int lockskin(int client, int i){
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	char query[1000];
	if(g_skinlocked[client][i]==false){
		g_skinlocked[client][i]=true;
		Format(query, sizeof(query), "UPDATE lada_inv set skin_locked=1 where id='%d'",g_Id[client][i]);
	}else{
		g_skinlocked[client][i]=false;
		Format(query, sizeof(query), "UPDATE lada_inv set skin_locked=0 where id='%d'",g_Id[client][i]);
	}
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	showplayerskin(client,i);
}

public int eladskin(int client, int i)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	Menu menu = CreateMenu(T_ConfirmSell);
	int	 rare = getcreditar(g_Weapon[client][i], g_Skins[client][i], g_Float[client][i], g_Stattrak[client][i], client);
	char asd2[200];
	if (rare <= 0 || g_skinlocked[client][i]==true)
	{
		Format(asd2, sizeof(asd2), "%T", "can not be sold", client);
		menu.SetTitle(asd2);
		menu.AddItem("-1", "Kilépés");
		menu.Display(client, 60);
		return Plugin_Handled;
	}
	float idg;
	idg = 1.0;
	idg -= g_fquicksell;
	Format(asd2, sizeof(asd2), "%T", "coin name", client);
	char osszeg[50];
	Format(osszeg, sizeof(osszeg), "%s", formatosszeg(rare));
	Format(asd2, sizeof(asd2), "%T", "confirm sell", client, osszeg, asd2, idg);
	menu.SetTitle(asd2);
	char szoveg[32];
	IntToString(i, szoveg, sizeof(szoveg));
	menu.AddItem(szoveg, "Igen");
	menu.AddItem("-1", "Nem");
	menu.Display(client, 60);
}

public int T_ConfirmSell(Menu menu, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info, 10);
		if (szam >= 0)
		{
			SkinElad(szam, client);
		}
		else {
			showplayeritems(client);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int SkinElad(int i, int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	decl String: query[1000];
	Format(query, sizeof(query), "DELETE FROM `lada_inv` WHERE `id`='%d'", g_Id[client][i]);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	float idg;
	idg = float(g_eladskincredit[client]);
	idg *= g_fquicksell;
	int rare = RoundFloat(idg);

	addado((g_eladskincredit[client] - rare));
	addcredit(client, rare);
	g_PlayerStats[client][6] += rare;
	char query8[1000];
	char steam_id8[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id8, sizeof(steam_id8));
	Format(query8, sizeof(query8), "UPDATE lada_stats set allcredit=allcredit+'%d' where steam_id='%s'", rare, steam_id8);
	SQL_TQuery(hDatabase, T_TestKnife4, query8, client);

	char asd2[1000];
	Format(asd2, sizeof(asd2), "%T", "coin name", client);
	char osszeg[50];
	Format(osszeg, sizeof(osszeg), "%s", formatosszeg(rare));
	Format(asd2, sizeof(asd2), "%T", "skin sell", client, osszeg, asd2);
	CPrintToChat(client, "%T %s", "Server Name", client, asd2);

	char logto[200];
	Format(logto, sizeof(logto), "Skint adott el(%d cr): %s(%d) %s(%d) f:%d st:%d s:%d r:%d", rare, fegyveridtonev(g_Weapon[client][i]), g_Weapon[client][i], g_SkinName[client][i], g_Skins[client][i], g_Float[client][i], g_Stattrak[client][i], g_Seed[client][i], g_Rare[client][i]);
	LogToSql(client, logto);
	DisableKnife3(client, i);
}

public int SaveCurrentStattrak2(int client, int i)
{
	DisableKnife3(client, i);
}

public int SaveCurrentStattrak(int client, int i)
{
	decl String: query[255];
	if (g_fegyvid[client][Getfegyverid(client, i)] != -1)
	{
		Format(query, sizeof(query), "UPDATE `lada_inv` SET `skin_last`='0' WHERE `id`='%d'", g_Id[client][g_fegyvid[client][Getfegyverid(client, i)]]);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	}
	g_ipanelbuffer[client]=g_fegyvid[client][Getfegyverid(client, i)];
	CreateTimer(1.0,resetskinlast,client);
	g_fegyvid[client][Getfegyverid(client, i)] = i;
	LoadCurrentSkin(client, i);
	showplayeritems(client);
}


public Action:resetskinlast(Handle timer, int client)
{
	decl String: query[255];
	if(g_ipanelbuffer[client]!=-1){
		Format(query, sizeof(query), "UPDATE `lada_inv` SET `skin_last`='0' WHERE `id`='%d'", g_Id[client][g_ipanelbuffer[client]]);
		SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	}
}

public int LoadCurrentSkin(int client, int i)
{
	char pref[100];
	Format(pref, sizeof(pref), "%s", fegyveridtoname(g_Weapon[client][i]));
	ReplaceString(pref, sizeof(pref), "weapon_", "");
	decl String: query[1000];
	char steam_id[32];
	GetClientAuthId(client, AuthId_Steam2, steam_id, sizeof(steam_id));
	int buffer_len = strlen(steam_id) * 2 + 1;
	new String: v_steam_id[buffer_len];
	SQL_EscapeString(hDatabase, steam_id, v_steam_id, buffer_len);
	float idg = float(g_Float[client][i]);
	idg		  = idg / 100000;
	if (Getfegyverid(client, i) == 33)
	{
		if(g_Rare[client][i]==8){
			felveszcustomskin(client,g_Weapon[client][i],g_SkinName[client][i]);
		}else{
			leveszcustomskin(client,g_Weapon[client][i]);
			Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `knife`='%d',`%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d',`%s_tag` ='%s' WHERE `steamid`='%s'", g_Weapon[client][i], pref, g_Skins[client][i], pref, idg, pref, g_Stattrak[client][i], pref, g_StattrakCount[client][i], pref, g_Seed[client][i],pref,g_Nametag[client][i], v_steam_id);
		}
	}
	else if (Getfegyverid(client, i) == 35) {
		Format(query, sizeof(query), "UPDATE `gloves` SET `t_group`='%d',`ct_group`='%d',`t_glove`='%d',`ct_glove`='%d',`t_float`='%f',`ct_float`='%f' WHERE `steamid`='%s'", g_Weapon[client][i], g_Weapon[client][i], g_Skins[client][i], g_Skins[client][i], idg, idg, v_steam_id);
	}
	else {
		if(g_Rare[client][i]==8){
			felveszcustomskin(client,g_Weapon[client][i],g_SkinName[client][i]);
		}else{
			leveszcustomskin(client,g_Weapon[client][i]);
			Format(query, sizeof(query), "UPDATE `weapons_weapons` SET `%s`='%d',`%s_float`='%f',`%s_trak`='%d',`%s_trak_count`='%d',`%s_seed`='%d',`%s_tag` ='%s'  WHERE `steamid`='%s'", pref, g_Skins[client][i], pref, idg, pref, g_Stattrak[client][i], pref, g_StattrakCount[client][i], pref, g_Seed[client][i],pref,g_Nametag[client][i], v_steam_id);
		}
	}

	char info[100];
	Format(info, sizeof(info), "%d|%d", client, Getfegyverid(client, i));
	Handle hPackedSQL = CreateDataPack();
	WritePackString(hPackedSQL, info);
	SQL_TQuery(hDatabase, T_TestKnife, query, hPackedSQL);
	Format(query, sizeof(query), "UPDATE `lada_inv` SET `skin_last`='1' WHERE `id`='%d'", g_Id[client][i]);
	SQL_TQuery(hDatabase, T_TestKnife4, query, client);
	char fegyvernevfromid[100];
	Format(fegyvernevfromid,sizeof(fegyvernevfromid),"%s",fegyveridtonev(g_Weapon[client][i]));
	ShowHintImageHelper(client,g_SkinName[client][i],fegyvernevfromid);
	return Plugin_Stop;
}

public T_TestKnife(Handle owner, Handle hndl, const String:error[], Handle hPackedSQL)
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
	int	 index	= StringToInt(str[1]);
	char asd2[100];
	if (index == 35)
	{
		FakeClientCommandEx(client, "sm_fegyverujratolt2");
	}
	else {
		Format(asd2, sizeof(asd2), "sm_fegyverujratolt %d", index);
		FakeClientCommandEx(client, asd2);
	}

	return;
}