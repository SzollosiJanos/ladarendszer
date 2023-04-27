

public void ReadConfig()
{
	LoadTranslations("ladarendszer.phrases");
	AutoExecConfig_SetFile("ElekCase_ladarendszer");
	AutoExecConfig_SetCreateFile(true);

	g_hGiveClientCredits		= AutoExecConfig_CreateConVar("GiveClientCredits", "300.0", "Credit adása a játékosnak x idő után");
	g_hGiveClientCreditsdefault = AutoExecConfig_CreateConVar("GiveClientCreditsdefault", "25", "Credit adása a játékosnak");
	g_hGiveClientCreditsvip		= AutoExecConfig_CreateConVar("GiveClientCreditsvip", "50", "Credit adása a játékosnak ha vip");
	g_hpricemessage				= AutoExecConfig_CreateConVar("pricemessage", "4000", "4000->40.00 creditbe felett üzenet kiírása");
	g_hpricemessagehang				= AutoExecConfig_CreateConVar("pricemessagehang", "4000", "4000->40.00 creditbe felett hang lejatszasa");
	g_hquicksell				= AutoExecConfig_CreateConVar("quicksellprice", "0.6", "quicksell esetén eredeti ár 60%-át kapja meg csak a játékos");
	g_hquicksellcsokkentett		= AutoExecConfig_CreateConVar("pricecsokkentett", "0.95", "piac és gift esetén az eredeti ár 95%-át kapja meg csak a játékos");
	g_hquickselllotto			= AutoExecConfig_CreateConVar("pricelottoad", "3", "3 dollár levonásra kerül a lottószelvényből, mint adó.");
	g_hlottoar					= AutoExecConfig_CreateConVar("pricelotto", "10", "10 dollárba kerül a lottó szelvényenként.");

	// g_hwebhookmessageopen = AutoExecConfig_CreateConVar("webhookmessageopen", "{\"content\":\"{MENTION}\",\"attachments\": [{\"color\": \"{COLOR}\",\"title\":\"{NICKNAME} ( {STEAMID} )\",\"fields\": [{\"title\": \"Fegyver:\",\"value\": \"{FEGYVER}\",\"short\": false},{\"title\": \"Float:\",\"value\": \"{FLOAT}\",\"short\": true},{\"title\": \"Seed:\",\"value\": \"{SEED}\",\"short\": true}]}]}", "Ládanyitás webhook üzenet");
	// g_hwebhookmessagelotto = AutoExecConfig_CreateConVar("webhookmessagelotto", "{\"content\":\"{MENTION}\",\"attachments\": [{\"color\": \"#ff0000\",\"title\":\"Lottó nyertese\",\"fields\": [{\"title\": \"Nyertes:\",\"value\": \"{WINNER}\",\"short\": false},{\"title\": \"Nyeremény:\",\"value\": \"{AMOUNT}.00 coin\",\"short\": true}]}]}", "Lotto üzenet");
	g_hopencooldown				= AutoExecConfig_CreateConVar("opencooldown", "5.0", "2 ládanyitás esetén a cooldown");
	g_hopenrarity6				= AutoExecConfig_CreateConVar("openrarity6", "10", "Ládanyitás esetén a különleges modell esélye 10=>0.01%");
	g_hopenrarity5				= AutoExecConfig_CreateConVar("openrarity5", "260", "Ládanyitás esetén a kés/kesztyű esélye 260=>0.26%");
	g_hopenrarity4				= AutoExecConfig_CreateConVar("openrarity4", "1000", "Ládanyitás esetén a piros skin esélye 1000=>1.00%");
	g_hopenrarity3				= AutoExecConfig_CreateConVar("openrarity3", "5240", "Ládanyitás esetén a rózsaszín skin esélye 5240=>5.24%");
	g_hopenrarity2				= AutoExecConfig_CreateConVar("openrarity2", "38500", "Ládanyitás esetén a lila skin esélye 38500=>38.50%");
	g_hopenfloat5				= AutoExecConfig_CreateConVar("openfloat5", "7", "Ládanyitás esetén a factory new esélye");
	g_hopenfloat4				= AutoExecConfig_CreateConVar("openfloat4", "8", "Ládanyitás esetén a minimal wear esélye");
	g_hopenfloat3				= AutoExecConfig_CreateConVar("openfloat3", "22", "Ládanyitás esetén a field tested esélye");
	g_hopenfloat2				= AutoExecConfig_CreateConVar("openfloat2", "7", "Ládanyitás esetén a well worn esélye");

	g_hnametagdollar			= AutoExecConfig_CreateConVar("nametagdollar", "elekcase", "x időnként extra kredit a nametag miatt");
	g_hinametagdollar			= AutoExecConfig_CreateConVar("intnametagdollar", "50", "nametag miatt kredit adása");

	g_hkilldollar				= AutoExecConfig_CreateConVar("killdollar", "10", "Kredit mennyisége ölés esetén");
	g_hkilldollarhead			= AutoExecConfig_CreateConVar("killdollarhead", "15", "Kredit mennyisége headshot esetén");
	g_hkilldollarknife			= AutoExecConfig_CreateConVar("killdollarknife", "20", "Kredit mennyisége késelés esetén");

	g_hStattrakOn				= AutoExecConfig_CreateConVar("stattrakon", "10000000", "stattrak állításának ára");
	g_hStattrakOff				= AutoExecConfig_CreateConVar("stattrakoff", "100000", "stattrak levételének ára");
	g_hchangeseed				= AutoExecConfig_CreateConVar("changeseed", "1000000", "seed újrasorsolásának ára");
	g_hchangefloat				= AutoExecConfig_CreateConVar("changefloat", "1000000", "float újrasorsolásának ára");
	g_hchangenametag			= AutoExecConfig_CreateConVar("changenametag", "1000000", "nametag állításának ára");

	g_hreferalinvited= AutoExecConfig_CreateConVar("referalinvited", "500000", "a meghívott mennyit kapjon");
	g_hreferalinviter= AutoExecConfig_CreateConVar("referalinviter", "100000", "a meghívó mennyit kapjon");
	g_hcasinopercent= AutoExecConfig_CreateConVar("casinopercent", "0.5", "casino nyereményhez szorzó");
	g_hcasinotime= AutoExecConfig_CreateConVar("casinotime", "30.0", "casino játékok közötti cooldown");
	// kpo-hoz cuccok
	g_hChatTag					= AutoExecConfig_CreateConVar("ssp_chattag", "Kő Papír Olló", "Kő papír olló előtti prefix");
	g_hMaxSSPThreshold			= AutoExecConfig_CreateConVar("ssp_maxThreshold", "50000", "maximum coin értéke amit lehet használni kő papír ollóban(ez 500 Taylor coin)");
	g_hMinSSPThreshold			= AutoExecConfig_CreateConVar("ssp_minThreshold", "1", "minimum  coin értéke amit lehet használni kő papír ollóban(ez 1 cent)");
	g_hSSPOnlyDead				= AutoExecConfig_CreateConVar("ssp_onlyDead", "0", "0 -> kikapcsolva, 1 -> csak halottak tudnak küldeni felkérést, 2 -> csak halottak tudnak játszani");
	g_hSSPOnlyDeadAdminOverride = AutoExecConfig_CreateConVar("ssp_onlyDeadAdminOverride", "1", "ssp_onyldead felülírása adminok esetén");
	g_hHouseMargin				= AutoExecConfig_CreateConVar("ssp_housemargin", "1.0", "nyertes hány százalékot kapjon meg a nyereségből (1.0-> 100%)");

	g_hCreditsChooserMenuValue1 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_1", "10", "menü 1. credit értéke");
	g_hCreditsChooserMenuValue2 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_2", "25", "menü 2. credit értéke");
	g_hCreditsChooserMenuValue3 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_3", "50", "menü 3. credit értéke");
	g_hCreditsChooserMenuValue4 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_4", "75", "menü 4. credit értéke");
	g_hCreditsChooserMenuValue5 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_5", "150", "menü 5. credit értéke");
	g_hCreditsChooserMenuValue6 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_6", "500", "menü 6. credit értéke");
	g_hCreditsChooserMenuValue7 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_7", "1000", "menü 7. credit értéke");
	g_hCreditsChooserMenuValue8 = AutoExecConfig_CreateConVar("ssp_creditsMenuOption_8", "2500", "menü 8. credit értéke");

	AutoExecConfig_CleanFile();
	AutoExecConfig_ExecuteFile();
	OnConfigsExecuted();
}

public void OnConfigsExecuted()
{
	g_fGiveClientCredits		= GetConVarFloat(g_hGiveClientCredits);
	g_fGiveClientCreditsdefault = GetConVarInt(g_hGiveClientCreditsdefault);
	g_fGiveClientCreditsvip		= GetConVarInt(g_hGiveClientCreditsvip);
	g_fpricemessage				= GetConVarInt(g_hpricemessage);
	g_fpricemessagehang				= GetConVarInt(g_hpricemessagehang);
	g_fquicksell				= GetConVarFloat(g_hquicksell);
	g_fquicksellcsokkentett		= GetConVarFloat(g_hquicksellcsokkentett);
	g_iquickselllotto			= GetConVarInt(g_hquickselllotto);
	g_ilottoar					= GetConVarInt(g_hlottoar);
	Format(g_swebhookmessageopen, sizeof(g_swebhookmessageopen), "{\"content\":null,\"embeds\":[{\"title\":\"⌜{MENTION} {FEGYVER}⌟\",\"color\":16711823,\"fields\":[{\"name\":\"➣Játékos\",\"value\":\"{NICKNAME} ({STEAMID})\"},{\"name\":\"➣Fegyver\",\"value\":\"{FEGYVER}\"},{\"name\":\"➣Float\",\"value\":\"{FLOAT}\"},{\"name\":\"➣Seed\",\"value\":\"{SEED}\"},{\"name\":\"➣Ára\",\"value\":\"{PRICE} ErackÉrme\"}],\"image\":{\"url\":\"https://kepkuldes.com/images/2ea829a99a8423407b81a547d3d8d60b.png\"}}]}");
	Format(g_swebhookmessagelotto, sizeof(g_swebhookmessagelotto), "{  \"content\": null,  \"embeds\": [{\"title\": \"Gratulálunk! Meglett az eheti lottó nyertese!\",\"color\": 65535,\"fields\": [{\"name\": \"A lottó nyertese\",\"value\": \"{WINNER}\"}, { \"name\": \"Nyert összeg\", \"value\": \"{AMOUNT} ErackÉrme\" }, {\"name\": \"Vásárolj szelvényt a szerveren, hogy te is csatlakozz a következő sorsoláshoz!\",\"value\":\"s\"},{\"name\": \"A szerver IP címe:\",\"value\":\"217.144.54.240:27056\" } ], \"image\": {\"url\": \"https://kepkuldes.com/images/c5a4211bafb5580dea58f0431b0287ed.png\" } }]}");
	// GetConVarString(g_hwebhookmessageopen, g_swebhookmessageopen, sizeof(g_swebhookmessageopen));
	// GetConVarString(g_hwebhookmessagelotto, g_swebhookmessagelotto, sizeof(g_swebhookmessagelotto));
	g_fopencooldown = GetConVarFloat(g_hopencooldown);

	g_iopenrarity6	= GetConVarInt(g_hopenrarity6);
	g_iopenrarity5	= GetConVarInt(g_hopenrarity5);
	g_iopenrarity4	= GetConVarInt(g_hopenrarity4);
	g_iopenrarity3	= GetConVarInt(g_hopenrarity3);
	g_iopenrarity2	= GetConVarInt(g_hopenrarity2);

	g_iopenfloat5	= GetConVarInt(g_hopenfloat5) * 1000;
	g_iopenfloat4	= GetConVarInt(g_hopenfloat4) * 1000;
	g_iopenfloat3	= GetConVarInt(g_hopenfloat3) * 1000;
	g_iopenfloat2	= GetConVarInt(g_hopenfloat2) * 1000;

	GetConVarString(g_hnametagdollar, g_snametagdollar, sizeof(g_snametagdollar));
	g_inametagdollar   = GetConVarInt(g_hinametagdollar);

	g_ikilldollar	   = GetConVarInt(g_hkilldollar);
	g_ikilldollarhead  = GetConVarInt(g_hkilldollarhead);
	g_ikilldollarknife = GetConVarInt(g_hkilldollarknife);

	
	
	g_iStattrakOn = GetConVarInt(g_hStattrakOn);
	g_iStattrakOff = GetConVarInt(g_hStattrakOff);
	g_ichangeseed = GetConVarInt(g_hchangeseed);
	g_ichangefloat = GetConVarInt(g_hchangefloat);
	g_ichangenametag = GetConVarInt(g_hchangenametag);
	
	
	g_ireferalinvited = GetConVarInt(g_hreferalinvited);
	g_ireferalinviter = GetConVarInt(g_hreferalinviter);
	g_icasinopercent = GetConVarFloat(g_hcasinopercent);
	g_icasinotime = GetConVarFloat(g_hcasinotime);
	// kpo cuccok
	GetConVarString(g_hChatTag, ttag, sizeof(ttag));
	g_iMinSSPThreshold			= GetConVarInt(g_hMinSSPThreshold);
	g_iMaxSSPThreshold			= GetConVarInt(g_hMaxSSPThreshold);
	g_bDefaultOffForAdmins		= false;
	g_bUseMysqlForBlockSSP		= true;
	g_iSSPOnlyDead				= GetConVarInt(g_hSSPOnlyDead);
	g_bSSPOnlyDeadAdminOverride = GetConVarBool(g_hSSPOnlyDeadAdminOverride);
	g_bSSPOnlyDeadItemOverride	= false;
	g_fHouseMargin				= GetConVarFloat(g_hHouseMargin);
	g_bBlockChatCommand			= false;
	if (g_fHouseMargin > 1.0)
		SetFailState("Invalid 'ssp_housemargin' Value. Change it otherwise this can be exploided");

	g_iCreditsChooserMenuValue1 = GetConVarInt(g_hCreditsChooserMenuValue1);
	g_iCreditsChooserMenuValue2 = GetConVarInt(g_hCreditsChooserMenuValue2);
	g_iCreditsChooserMenuValue3 = GetConVarInt(g_hCreditsChooserMenuValue3);
	g_iCreditsChooserMenuValue4 = GetConVarInt(g_hCreditsChooserMenuValue4);
	g_iCreditsChooserMenuValue5 = GetConVarInt(g_hCreditsChooserMenuValue5);
	g_iCreditsChooserMenuValue6 = GetConVarInt(g_hCreditsChooserMenuValue6);
	g_iCreditsChooserMenuValue7 = GetConVarInt(g_hCreditsChooserMenuValue7);
	g_iCreditsChooserMenuValue8 = GetConVarInt(g_hCreditsChooserMenuValue8);

	if (g_bUseMysqlForBlockSSP)
	{
		char error[255];
		hDatabase = SQL_Connect("sspCredits", true, error, sizeof(error));
		SQL_SetCharset(hDatabase, "utf8");

		char CreateProtectedIdsTable[256];
		Format(CreateProtectedIdsTable, sizeof(CreateProtectedIdsTable), "CREATE TABLE IF NOT EXISTS `ssp_sspblocked` (`playerid` varchar(30) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;");
		SQL_TQuery(hDatabase, SQLErrorCheckCallback, CreateProtectedIdsTable);
	}
	
}

public void opensettings(int client)
{
	Panel menu = new Panel();

	menu.SetTitle(" » MegoltElek ládarendszer « ");
	menu.DrawText(" ");
	char asd2[100];
	Format(asd2, sizeof(asd2), "  ➤ %T: %s  ", "coin name", client, formatosszeg(g_credits[client]));
	menu.DrawText(asd2);
	menu.DrawText(" ");
	if (g_bIgnoringInvites[client])
	{
		Format(asd2, sizeof(asd2), "%T %T", "kpo challenges", client, "off", client);
		menu.DrawItem(asd2);
	}
	else {
		Format(asd2, sizeof(asd2), "%T %T", "kpo challenges", client, "on", client);
		menu.DrawItem(asd2);
	}

	if (g_open[client])
	{
		Format(asd2, sizeof(asd2), "%T %T", "case animation", client, "off", client);
		menu.DrawItem(asd2);
	}
	else {
		Format(asd2, sizeof(asd2), "%T %T", "case animation", client, "on", client);
		menu.DrawItem(asd2);
	}
	char buffer[64];
		
	GetClientCookie(client, g_sound, buffer, sizeof(buffer));
	if (StrEqual(buffer,"1"))
	{
		Format(asd2, sizeof(asd2), "%T %T", "case sound", client, "off", client);
		menu.DrawItem(asd2);
	}
	else {
		Format(asd2, sizeof(asd2), "%T %T", "case sound", client, "on", client);
		menu.DrawItem(asd2);
	}

	menu.DrawText(" ");
	menu.CurrentKey = 9;
	char exit2[50];
	Format(exit2, sizeof(exit2), "%T", "exit", client);
	menu.DrawItem(exit2);
	menu.Send(client, settingsmenu, 60);
	delete menu;
}

public int settingsmenu(Menu menu2, MenuAction:mAction, int client, int item)
{
	if(!playerisloaded(client)){
		return Plugin_Handled;
	}
	if (mAction== MenuAction_Select)
	{
		char info[32];

		switch (item)
		{
			case 1:
			{
				toggleSSPCommand(client, 0);
			}
			case 2:
			{
				Cmd_openanim(client, 0);
			}
			case 3:
			{
				char buffer[64];
		
				GetClientCookie(client, g_sound, buffer, sizeof(buffer));
				if(StrEqual(buffer, "1")) {
					SetClientCookie(client, g_sound, "0");
				}else{
					SetClientCookie(client, g_sound, "1");
				}
			}
		}
		if (item <= 3)
		{
			opensettings(client);
		}
	}
}



public void OnClientCookiesCached(int client) {
	if (IsFakeClient(client))
		return;
		
	if(IsClientConnected(client)) {
		char buffer[64];
		
		GetClientCookie(client, g_sound, buffer, sizeof(buffer));
		
		if(StrEqual(buffer, "")) {
			SetClientCookie(client, g_sound, "0");
			return;
		}
	}
}