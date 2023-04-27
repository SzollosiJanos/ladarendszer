

public int T_Boltkulcs(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[32];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info, 10);
		a_boltkulcs(client, szam);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

a_boltkulcs(int client, int szam)
{
	if (g_credits[client] >= g_kulcsar[szam])
	{
		Menu menu = CreateMenu(T_Boltkulcsconfirm);
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

public T_Boltkulcsconfirm(Menu menu, MenuAction:mAction, int client, int item)
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
		if (g_credits[client] >= (g_kulcsar[lada] * szam))
		{
			char asd2[1000];
			char osszeg[50];
			Format(osszeg, sizeof(osszeg), "%s", formatosszeg(g_kulcsar[lada]*szam));
			Format(asd2, sizeof(asd2), "%T", "coin name", client);
			Format(asd2, sizeof(asd2), "%T", "key bought", client, ladaidtonev(lada), osszeg, asd2);
			CPrintToChat(client, "%T %s", "Server Name", client, asd2);

			addkey(client,lada,szam);
			addcredit(client, -g_kulcsar[lada] * szam);
			a_boltkulcs(client, lada);
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