

public openshop(int client)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if(g_tradepartner[client]!=0||g_tradepartner[client]==666){
		return Plugin_Handled;
	}
	Menu menu = CreateMenu(T_Bolt);
	menu.SetTitle("%Tod: %s", "coin name", client, formatosszeg(g_credits[client]));
	menu.AddItem("ladak", "Ládák");
	menu.AddItem("kulcsok", "Kulcsok");
	menu.Display(client, 60);
}

public int T_Bolt(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		if (StrEqual(info, "ladak"))
		{
			Menu menu = CreateMenu(T_Boltlada);
			menu.SetTitle("%Tod: %s", "coin name", client, formatosszeg(g_credits[client]));
			char szoveg[64];
			char asd2[11];
			for (int i = 0; i <= maxloadedlada; i++)
			{
				Format(szoveg, sizeof(szoveg), "%s láda: %s", ladaidtonev(i), formatosszeg(g_ladaar[i]));
				IntToString(i, asd2, sizeof(asd2));
				if (g_ladabuylada[i]==0)
				{
					menu.AddItem(asd2, szoveg, ITEMDRAW_DISABLED);
				}
				else {
					
					int iflag;
					bool okay=false;
					char flag[10];
					for(int k=0;k<21;k++){
						Format(flag,sizeof(flag),"%c",g_flagtoopen[i][k]);
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
			
					if(okay==true || StrEqual(g_flagtoopen[i],"")){
						menu.AddItem(asd2, szoveg);
					}else{
						menu.AddItem(asd2, szoveg,ITEMDRAW_DISABLED);
					}
				}
			}
			menu.Display(client, 60);
		}
		else if (StrEqual(info, "kulcsok"))
		{
			Menu menu = CreateMenu(T_Boltkulcs);
			menu.SetTitle("%Tod: %s", "coin name", client, formatosszeg(g_credits[client]));
			char szoveg[64];
			char asd2[11];
			for (int i = 0; i <= maxloadedlada; i++)
			{
				Format(szoveg, sizeof(szoveg), "%s ládakulcs: %s", ladaidtonev(i), formatosszeg(g_kulcsar[i]));
				IntToString(i, asd2, sizeof(asd2));
				if (g_ladabuykulcs[i]==0)
				{
					menu.AddItem(asd2, szoveg, ITEMDRAW_DISABLED);
				}
				else {
					int iflag;
					bool okay=false;
					char flag[10];
					for(int k=0;k<21;k++){
						Format(flag,sizeof(flag),"%c",g_flagtoopen[i][k]);
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
			
					if(okay==true || StrEqual(g_flagtoopen[i],"")){
						menu.AddItem(asd2, szoveg);
					}else{
						menu.AddItem(asd2, szoveg,ITEMDRAW_DISABLED);
					}
				}
			}
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

a_boltlada(int client, int szam)
{
	if (g_credits[client] >= g_ladaar[szam])
	{
		Menu menu = CreateMenu(T_Boltladaconfirm);
		menu.SetTitle("Biztos meg szeretnéd vásárolni?");
		char szoveg[100];
		Format(szoveg, sizeof(szoveg), "%d+1", szam);
		menu.AddItem(szoveg, "Igen, 1 darab");
		Format(szoveg, sizeof(szoveg), "%d+10", szam);
		menu.AddItem(szoveg, "Igen, 10 darab");
		Format(szoveg, sizeof(szoveg), "%d+25", szam);
		menu.AddItem(szoveg, "Igen, 25 darab");
		Format(szoveg, sizeof(szoveg), "%d+50", szam);
		menu.AddItem(szoveg, "Igen, 50 darab");
		Format(szoveg, sizeof(szoveg), "%d+100", szam);
		menu.AddItem(szoveg, "Igen, 100 darab");
		menu.AddItem("-1", "Nem");
		menu.Display(client, 60);
	}
	else {
		char asd277[1000];
		Format(asd277, sizeof(asd277), "%T", "coin name", client);
		Format(asd277, sizeof(asd277), "%T", "Not enough coin", client, asd277);
		CPrintToChat(client, "%T %s", "Server Name", client, asd277);
		openshop(client);
	}
}

public int T_Boltlada(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info, 10);
		a_boltlada(client, szam);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public T_Boltladaconfirm(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		if (StrEqual(info, "-1"))
		{
			return Plugin_Handled;
		}
		char str[2][50];
		ExplodeString(info, "+", str, sizeof(str), sizeof(str[]));
		int lada = StringToInt(str[0], 10);
		int szam = StringToInt(str[1], 10);
		if (g_credits[client] >= (g_ladaar[lada] * szam))
		{
			char asd2[1000];
			Format(asd2, sizeof(asd2), "%T", "coin name", client);
			char osszeg[50];
			Format(osszeg, sizeof(osszeg), "%s",formatosszeg(g_ladaar[lada] * szam));
			Format(asd2, sizeof(asd2), "%T", "case bought", client, ladaidtonev(lada), osszeg, asd2);
			CPrintToChat(client, "%T %s", "Server Name", client, asd2);
			addcredit(client, -g_ladaar[lada] * szam);
			addlada(client,lada,szam);
			a_boltlada(client, lada);
		}
		else {
			openshop(client);
		}
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}