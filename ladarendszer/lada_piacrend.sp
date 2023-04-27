

public showpiacrend(int client)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");

	menu.DrawText(" ");
	char asd2[100];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client, formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	menu.DrawText("Piac rendezése:");

	char szoveg[200];
	// Format(p_osszesitett[client],sizeof(p_osszesitett[]),"GROUP BY id DESC");
	if (p_credit[client] == 0)
	{
		Format(szoveg, sizeof(szoveg), "%T szerint: [Növekvő]", "coin name", client);
	}
	else if (p_credit[client] == 1) {
		Format(szoveg, sizeof(szoveg), "%T szerint: [Csökkenő]", "coin name", client);
	}
	else {
		Format(szoveg, sizeof(szoveg), "%T szerint: Kikapcsolva", "coin name", client);
	}
	menu.DrawItem(szoveg);

	if (p_time[client] == 1)
	{
		Format(szoveg, sizeof(szoveg), "Idő szerint: [Növekvő]");
	}
	else if (p_time[client] == 0) {
		Format(szoveg, sizeof(szoveg), "Idő szerint: [Csökkenő]");
	}
	else {
		Format(szoveg, sizeof(szoveg), "Idő szerint: kikapcsolva");
	}
	menu.DrawItem(szoveg);
	if (p_fegyverid[client] == -1)
	{
		Format(szoveg, sizeof(szoveg), "Fegyver szerint: kikapcsolva");
	}
	else {
		Format(szoveg, sizeof(szoveg), "Fegyver szerint: %s", fegyveridtonev(p_fegyverid[client]));
	}
	menu.DrawItem(szoveg);
	if (p_color[client] == -1)
	{
		Format(szoveg, sizeof(szoveg), "Szín szerint: kikapcsolva");
	}
	else {
		Format(szoveg, sizeof(szoveg), "Szín szerint: %s", rareidtocolorname(client, p_color[client]));
	}
	menu.DrawItem(szoveg);

	menu.CurrentKey = 9;
	menu.DrawText(" ");
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "back", client);
	menu.DrawItem(exit2);
	menu.Send(client, T_PiacMain2, 60);
	delete menu;
}

public int T_PiacMain2(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char szoveg[100];
		char szam[11];
		if (item == 1)
		{
			p_time[client] = -1;
			if (p_credit[client] == -1 || p_credit[client] == 1)
			{
				p_credit[client] = 0;
				Format(p_osszesitett[client], sizeof(p_osszesitett[]), "GROUP BY credit ASC");
			}
			else {
				p_credit[client] = 1;
				Format(p_osszesitett[client], sizeof(p_osszesitett[]), "GROUP BY credit DESC");
			}
			showpiacrend(client);
		}
		else if (item == 2) {
			p_credit[client] = -1;
			if (p_time[client] == -1 || p_time[client] == 1)
			{
				p_time[client] = 0;
				Format(p_osszesitett[client], sizeof(p_osszesitett[]), "GROUP BY id DESC");
			}
			else {
				p_time[client] = 1;
				Format(p_osszesitett[client], sizeof(p_osszesitett[]), "GROUP BY id ASC");
			}
			showpiacrend(client);
		}
		else if (item == 4) {
			Menu menu = CreateMenu(T_PiacMainColor);
			menu.SetTitle("Válassz színt");
			Format(szam, sizeof(szam), "-1");
			menu.AddItem(szam, "Kikapcsolás");
			for (int i = 1; i <= 7; i++)
			{
				Format(szoveg, sizeof(szoveg), "%s", rareidtocolorname(client, i));
				Format(szam, sizeof(szam), "%d", i);
				menu.AddItem(szam, szoveg);
			}
			menu.Display(client, 60);
		}
		else if (item == 3) {
			Menu menu = CreateMenu(T_PiacMainFegyver);
			menu.SetTitle("Válassz fegyvert");
			Format(szam, sizeof(szam), "-1");
			menu.AddItem(szam, "Kikapcsolás");
			for (int i = 0; i <= 52; i++)
			{
				Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(i));
				Format(szam, sizeof(szam), "%d", i);
				menu.AddItem(szam, szoveg);
			}
			Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(4725));
			Format(szam, sizeof(szam), "%d", 4725);
			menu.AddItem(szam, szoveg);
			Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(5027));
			Format(szam, sizeof(szam), "%d", 5027);
			menu.AddItem(szam, szoveg);
			for (int i = 5030; i <= 5035; i++)
			{
				Format(szoveg, sizeof(szoveg), "%s", fegyveridtonev(i));
				Format(szam, sizeof(szam), "%d", i);
				menu.AddItem(szam, szoveg);
			}
			menu.Display(client, 60);
		}
		else {
			showegyeb(client);
		}
	}
}

public int T_PiacMainColor(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info);
		if (szam == -1)
		{
			Format(p_osszesitettw[client], sizeof(p_osszesitettw[]), "");
		}
		else {
			Format(p_osszesitettw[client], sizeof(p_osszesitettw[]), "AND rare=%d", szam);
		}
		p_color[client] = szam;
		showpiacrend(client);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}

public int T_PiacMainFegyver(Menu menu, MenuAction:mAction, int client, int item)
{
	if (mAction== MenuAction_Select)
	{
		char info[100];
		menu.GetItem(item, info, sizeof(info));
		int szam = StringToInt(info);
		if (szam == -1)
		{
			Format(p_osszesitettw2[client], sizeof(p_osszesitettw2[]), "");
		}
		else {
			Format(p_osszesitettw2[client], sizeof(p_osszesitettw2[]), "AND fegyver_id=%d", szam);
		}
		p_fegyverid[client] = szam;
		showpiacrend(client);
	}
	if(mAction==MenuAction_End)
    {
		if(menu!=null){
			delete menu;
		}
    }
}