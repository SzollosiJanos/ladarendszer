fegyveridtoname(int fegyver_id)
{
	new String:fegyvername[64];
	switch (fegyver_id)
	{
		case 0:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_awp");
		}
		case 1:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_ak47");
		}
		case 2:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_m4a1");
		}
		case 3:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_m4a1_silencer");
		}
		case 4:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_deagle");
		}
		case 5:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_usp_silencer");
		}
		case 6:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_hkp2000");
		}
		case 7:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_glock");
		}
		case 8:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_elite");
		}
		case 9:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_p250");
		}
		case 10:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_cz75a");
		}
		case 11:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_fiveseven");
		}
		case 12:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_tec9");
		}
		case 13:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_revolver");
		}
		case 14:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_nova");
		}
		case 15:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_xm1014");
		}
		case 16:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_mag7");
		}
		case 17:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_sawedoff");
		}
		case 18:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_m249");
		}
		case 19:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_negev");
		}
		case 20:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_mp9");
		}
		case 21:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_mac10");
		}
		case 22:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_mp7");
		}
		case 23:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_ump45");
		}
		case 24:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_p90");
		}
		case 25:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_bizon");
		}
		case 26:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_famas");
		}
		case 27:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_galilar");
		}
		case 28:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_ssg08");
		}
		case 29:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_aug");
		}
		case 30:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_sg556");
		}
		case 31:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_scar20");
		}
		case 32:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_g3sg1");
		}
		case 33:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_karambit");
		}
		case 34:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_m9_bayonet");
		}
		case 35:
		{
			Format(fegyvername, sizeof(fegyvername), "bayonet");
		}
		case 36:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_survival_bowie");
		}
		case 37:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_butterfly");
		}
		case 38:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_flip");
		}
		case 39:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_push");
		}
		case 40:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_tactical");
		}
		case 41:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_falchion");
		}
		case 42:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_gut");
		}
		case 43:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_ursus");
		}
		case 44:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_gypsy_jackknife");
		}
		case 45:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_stiletto");
		}
		case 46:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_widowmaker");
		}
		case 47:
		{
			Format(fegyvername, sizeof(fegyvername), "weapon_mp5sd");
		}
		case 48:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_css");
		}
		case 49:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_cord");
		}
		case 50:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_canis");
		}
		case 51:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_outdoor");
		}
		case 52:
		{
			Format(fegyvername, sizeof(fegyvername), "knife_skeleton");
		}
	}
	return fegyvername;
}

int Getweaponidfromname(const char[] weapon)
{
	int idg = 35;
	if (StrContains(weapon, "awp") != -1) { idg = 0; }
	else if (StrContains(weapon, "ak47") != -1) {
		idg = 1;
	}
	else if (StrContains(weapon, "m4a1") != -1) {
		idg = 2;
	}
	else if (StrContains(weapon, "m4a1_silencer") != -1) {
		idg = 3;
	}
	else if (StrContains(weapon, "deagle") != -1) {
		idg = 4;
	}
	else if (StrContains(weapon, "usp_silencer") != -1) {
		idg = 5;
	}
	else if (StrContains(weapon, "hkp2000") != -1) {
		idg = 6;
	}
	else if (StrContains(weapon, "glock") != -1) {
		idg = 7;
	}
	else if (StrContains(weapon, "elite") != -1) {
		idg = 8;
	}
	else if (StrContains(weapon, "p250") != -1) {
		idg = 9;
	}
	else if (StrContains(weapon, "cz75a") != -1) {
		idg = 10;
	}
	else if (StrContains(weapon, "fiveseven") != -1) {
		idg = 11;
	}
	else if (StrContains(weapon, "tec9") != -1) {
		idg = 12;
	}
	else if (StrContains(weapon, "revolver") != -1) {
		idg = 13;
	}
	else if (StrContains(weapon, "nova") != -1) {
		idg = 14;
	}
	else if (StrContains(weapon, "xm1014") != -1) {
		idg = 15;
	}
	else if (StrContains(weapon, "mag7") != -1) {
		idg = 16;
	}
	else if (StrContains(weapon, "sawedoff") != -1) {
		idg = 17;
	}
	else if (StrContains(weapon, "m249") != -1) {
		idg = 18;
	}
	else if (StrContains(weapon, "negev") != -1) {
		idg = 19;
	}
	else if (StrContains(weapon, "mp9") != -1) {
		idg = 20;
	}
	else if (StrContains(weapon, "mac10") != -1) {
		idg = 21;
	}
	else if (StrContains(weapon, "mp7") != -1) {
		idg = 22;
	}
	else if (StrContains(weapon, "ump45") != -1) {
		idg = 23;
	}
	else if (StrContains(weapon, "p90") != -1) {
		idg = 24;
	}
	else if (StrContains(weapon, "bizon") != -1) {
		idg = 25;
	}
	else if (StrContains(weapon, "famas") != -1) {
		idg = 26;
	}
	else if (StrContains(weapon, "galilar") != -1) {
		idg = 27;
	}
	else if (StrContains(weapon, "ssg08") != -1) {
		idg = 28;
	}
	else if (StrContains(weapon, "aug") != -1) {
		idg = 29;
	}
	else if (StrContains(weapon, "sg556") != -1) {
		idg = 30;
	}
	else if (StrContains(weapon, "scar20") != -1) {
		idg = 31;
	}
	else if (StrContains(weapon, "g3sg1") != -1) {
		idg = 32;
	}
	else if (StrContains(weapon, "knife_karambit") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_m9_bayonet") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "bayonet") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_survival_bowie") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_butterfly") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_flip") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_push") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_tactical") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_falchion") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_gut") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_ursus") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_gypsy_jackknife") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_stiletto") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_widowmaker") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "mp5sd") != -1) {
		idg = 34;
	}
	else if (StrContains(weapon, "knife_css") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_cord") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_canis") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_outdoor") != -1) {
		idg = 33;
	}
	else if (StrContains(weapon, "knife_skeleton") != -1) {
		idg = 33;
	}
	if (StrContains(weapon, "knife") != -1) { idg = 33; }
	if (StrContains(weapon, "default") != -1) { idg = 33; }
	// ide nem kellenek kesztyűk!!!
	return idg;
}

rareidtostart(int client, int rarre)
{
	new String:fegyvername[64];
	switch (rarre)
	{
		case 1:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "blue_s", client);
		}
		case 2:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "purple_s", client);
		}
		case 3:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "pink_s", client);
		}
		case 4:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "red_s", client);
		}
		case 5:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "gold_s", client);
		}
		case 6:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "red_s", client);
		}
		case 7:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "red_s", client);
		}
		case 8:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "custom_s", client);
		}
	}
	return fegyvername;
}

fegyveridtonev(int fegyver_id)
{
	new String:fegyvername[64];
	switch (fegyver_id)
	{
		case 0:
		{
			Format(fegyvername, sizeof(fegyvername), "AWP");
		}
		case 1:
		{
			Format(fegyvername, sizeof(fegyvername), "AK-47");
		}
		case 2:
		{
			Format(fegyvername, sizeof(fegyvername), "M4A4");
		}
		case 3:
		{
			Format(fegyvername, sizeof(fegyvername), "M4A1-S");
		}
		case 4:
		{
			Format(fegyvername, sizeof(fegyvername), "Desert Eagle");
		}
		case 5:
		{
			Format(fegyvername, sizeof(fegyvername), "USP-S");
		}
		case 6:
		{
			Format(fegyvername, sizeof(fegyvername), "P2000");
		}
		case 7:
		{
			Format(fegyvername, sizeof(fegyvername), "Glock-18");
		}
		case 8:
		{
			Format(fegyvername, sizeof(fegyvername), "Dual Berettas");
		}
		case 9:
		{
			Format(fegyvername, sizeof(fegyvername), "P250");
		}
		case 10:
		{
			Format(fegyvername, sizeof(fegyvername), "CZ75-Auto");
		}
		case 11:
		{
			Format(fegyvername, sizeof(fegyvername), "Five-SeveN");
		}
		case 12:
		{
			Format(fegyvername, sizeof(fegyvername), "Tec-9");
		}
		case 13:
		{
			Format(fegyvername, sizeof(fegyvername), "R8-Revolver");
		}
		case 14:
		{
			Format(fegyvername, sizeof(fegyvername), "Nova");
		}
		case 15:
		{
			Format(fegyvername, sizeof(fegyvername), "XM1014");
		}
		case 16:
		{
			Format(fegyvername, sizeof(fegyvername), "MAG-7");
		}
		case 17:
		{
			Format(fegyvername, sizeof(fegyvername), "Sawed-Off");
		}
		case 18:
		{
			Format(fegyvername, sizeof(fegyvername), "M249");
		}
		case 19:
		{
			Format(fegyvername, sizeof(fegyvername), "Negev");
		}
		case 20:
		{
			Format(fegyvername, sizeof(fegyvername), "MP9");
		}
		case 21:
		{
			Format(fegyvername, sizeof(fegyvername), "MAC-10");
		}
		case 22:
		{
			Format(fegyvername, sizeof(fegyvername), "MP7");
		}
		case 23:
		{
			Format(fegyvername, sizeof(fegyvername), "UMP-45");
		}
		case 24:
		{
			Format(fegyvername, sizeof(fegyvername), "P90");
		}
		case 25:
		{
			Format(fegyvername, sizeof(fegyvername), "PP-Bizon");
		}
		case 26:
		{
			Format(fegyvername, sizeof(fegyvername), "FAMAS");
		}
		case 27:
		{
			Format(fegyvername, sizeof(fegyvername), "Galil AR");
		}
		case 28:
		{
			Format(fegyvername, sizeof(fegyvername), "SSG 08");
		}
		case 29:
		{
			Format(fegyvername, sizeof(fegyvername), "AUG");
		}
		case 30:
		{
			Format(fegyvername, sizeof(fegyvername), "SG 553");
		}
		case 31:
		{
			Format(fegyvername, sizeof(fegyvername), "SCAR-20");
		}
		case 32:
		{
			Format(fegyvername, sizeof(fegyvername), "G3SG1");
		}
		case 33:
		{
			Format(fegyvername, sizeof(fegyvername), "Karambit");
		}
		case 34:
		{
			Format(fegyvername, sizeof(fegyvername), "M9 bayonet");
		}
		case 35:
		{
			Format(fegyvername, sizeof(fegyvername), "Bayonet");
		}
		case 36:
		{
			Format(fegyvername, sizeof(fegyvername), "Bowie Knife");
		}
		case 37:
		{
			Format(fegyvername, sizeof(fegyvername), "Butterfly Knife");
		}
		case 38:
		{
			Format(fegyvername, sizeof(fegyvername), "Flip Knife");
		}
		case 39:
		{
			Format(fegyvername, sizeof(fegyvername), "Shadow daggers");
		}
		case 40:
		{
			Format(fegyvername, sizeof(fegyvername), "Huntsman Knife");
		}
		case 41:
		{
			Format(fegyvername, sizeof(fegyvername), "Falchion Knife");
		}
		case 42:
		{
			Format(fegyvername, sizeof(fegyvername), "Gut Knife");
		}
		case 43:
		{
			Format(fegyvername, sizeof(fegyvername), "Ursus Knife");
		}
		case 44:
		{
			Format(fegyvername, sizeof(fegyvername), "Navaja Knife");
		}
		case 45:
		{
			Format(fegyvername, sizeof(fegyvername), "Stiletto Knife");
		}
		case 46:
		{
			Format(fegyvername, sizeof(fegyvername), "Talon Knife");
		}
		case 47:
		{
			Format(fegyvername, sizeof(fegyvername), "MP5-SD");
		}
		case 48:
		{
			Format(fegyvername, sizeof(fegyvername), "Classic Knife");
		}
		case 49:
		{
			Format(fegyvername, sizeof(fegyvername), "Paracord Knife");
		}
		case 50:
		{
			Format(fegyvername, sizeof(fegyvername), "Survival Knife");
		}
		case 51:
		{
			Format(fegyvername, sizeof(fegyvername), "Nomad Knife");
		}
		case 52:
		{
			Format(fegyvername, sizeof(fegyvername), "Skeleton Knife");
		}
		case 4725:
		{
			Format(fegyvername, sizeof(fegyvername), "Broken Fang Gloves");
		}
		case 5027:
		{
			Format(fegyvername, sizeof(fegyvername), "Bloodhound Gloves");
		}
		case 5030:
		{
			Format(fegyvername, sizeof(fegyvername), "Sport Gloves");
		}
		case 5031:
		{
			Format(fegyvername, sizeof(fegyvername), "Driver Gloves");
		}
		case 5032:
		{
			Format(fegyvername, sizeof(fegyvername), "Hand Wraps");
		}
		case 5033:
		{
			Format(fegyvername, sizeof(fegyvername), "Moto Gloves");
		}
		case 5034:
		{
			Format(fegyvername, sizeof(fegyvername), "Specialist Gloves");
		}
		case 5035:
		{
			Format(fegyvername, sizeof(fegyvername), "Hydra Gloves");
		}
	}
	return fegyvername;
}

ladaidtonev(int fegyver_id)
{
	return g_ladanev[fegyver_id];
}

int Getfegyverid(int client, int id)
{
	int idg = g_Weapon[client][id];
	if (g_Weapon[client][id] > 32) { idg = 33; }
	if (g_Weapon[client][id] == 47) { idg = 34; }
	if (g_Weapon[client][id] >= 53) { idg = 35; }
	return idg;
}

public int GetRandomRare(int ladaid, int client)
{
	int minoseg;
	int idgfloat;
	bool isvip=false;
	if(VIP_IsClientVIP(client) && VIP_IsClientFeatureUse(client, g_szFeature3) &&VIP_IsClientFeatureUse(client, g_szFeature4) &&VIP_IsClientFeatureUse(client, g_szFeature5) &&VIP_IsClientFeatureUse(client, g_szFeature6)&& VIP_IsClientFeatureUse(client, g_szFeature7))
	{
		isvip=true;
	}
	while(1){
		minoseg = GetRandomInt(1, 100000);
		if ((minoseg <= g_iopenrarity6 || (isvip&&minoseg <= RoundFloat(g_iopenrarity6*VIP_GetClientFeatureFloat(client, g_szFeature7))))&&g_ladarares[ladaid][7]==1) {
			idgfloat = 8;
		}else if ((minoseg <= g_iopenrarity5+g_iopenrarity6 || (isvip&&minoseg <= RoundFloat((g_iopenrarity5+g_iopenrarity6)*VIP_GetClientFeatureFloat(client, g_szFeature3))))&& (g_ladarares[ladaid][5]==1 || g_ladarares[ladaid][6]==1))
		{
			if(g_ladarares[ladaid][5]==1){
				idgfloat = 6;
			}else{
				idgfloat = 7;
			}
		}
		else if ((minoseg <= g_iopenrarity5 + g_iopenrarity4 +g_iopenrarity6 || (isvip&&minoseg <= RoundFloat((g_iopenrarity5 + g_iopenrarity4 +g_iopenrarity6)*VIP_GetClientFeatureFloat(client, g_szFeature4))))&&g_ladarares[ladaid][3]==1) {
			idgfloat = 4;
		}
		else if((minoseg <= g_iopenrarity5 + g_iopenrarity4 +g_iopenrarity6 + g_iopenrarity3|| (isvip&&minoseg <= RoundFloat((g_iopenrarity5 + g_iopenrarity4 +g_iopenrarity6+ g_iopenrarity3)*VIP_GetClientFeatureFloat(client, g_szFeature5))))&&g_ladarares[ladaid][2]==1)  {
			idgfloat = 3;
		}
		else if((minoseg <= g_iopenrarity5 + g_iopenrarity4 +g_iopenrarity6 + g_iopenrarity3+ g_iopenrarity2|| (isvip&&minoseg <= RoundFloat((g_iopenrarity5 + g_iopenrarity4 +g_iopenrarity6+ g_iopenrarity3+ g_iopenrarity2)*VIP_GetClientFeatureFloat(client, g_szFeature6))))&&g_ladarares[ladaid][1]==1) {
			idgfloat = 2;
		}
		else if(g_ladarares[ladaid][0]==1) {
			idgfloat = 1;
		}else if(g_ladarares[ladaid][4]==1){
			idgfloat = 5;
		}else{
			continue;
		}
		return idgfloat;
	}
}

public int GetKopottsagFromId(int szam)
{
	switch(szam){
		case 0:{return GetRandomInt(0, (g_iopenfloat5)-1);}
		case 1:{return GetRandomInt((g_iopenfloat5), (g_iopenfloat5 + g_iopenfloat4) - 1);}
		case 2:{return GetRandomInt((g_iopenfloat5 + g_iopenfloat4), (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3) - 1);}
		case 3:{return GetRandomInt((g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3), (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2) - 1);}
		case 4:{return GetRandomInt((g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2), 100000);}
	}
}


public int GetRandomKopottsag()
{
	int minoseg = GetRandomInt(1, 1000);
	int idgfloat;
	if (minoseg < 30)
	{
		idgfloat = GetRandomInt(0, (g_iopenfloat5)-1);
	}
	else if (minoseg < 180) {
		idgfloat = GetRandomInt((g_iopenfloat5), (g_iopenfloat5 + g_iopenfloat4) - 1);
	}
	else if (minoseg < 375) {
		idgfloat = GetRandomInt((g_iopenfloat5 + g_iopenfloat4), (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3) - 1);
	}
	else if (minoseg < 650) {
		idgfloat = GetRandomInt((g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3), (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2) - 1);
	}
	else {
		idgfloat = GetRandomInt((g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2), 100000);
	}
	return idgfloat;
}

GetKopottsagFromFloatRovid(int szam)
{
	char kopottsag[64];
	if (szam > 0 && szam < (g_iopenfloat5))
	{
		Format(kopottsag, sizeof(kopottsag), "Fn");
	}
	else if (szam >= (g_iopenfloat5) && szam < (g_iopenfloat5 + g_iopenfloat4)) {
		Format(kopottsag, sizeof(kopottsag), "Mw");
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4) && szam < (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3)) {
		Format(kopottsag, sizeof(kopottsag), "Ft");
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3) && szam < (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2)) {
		Format(kopottsag, sizeof(kopottsag), "Ww");
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2) && szam <= 100000) {
		Format(kopottsag, sizeof(kopottsag), "Bs");
	}
	return kopottsag;
}

GetKopottsagFromFloat(int szam)
{
	char kopottsag[64];
	if (szam > 0 && szam < (g_iopenfloat5))
	{
		Format(kopottsag, sizeof(kopottsag), "Factory New");
	}
	else if (szam >= (g_iopenfloat5) && szam < (g_iopenfloat5 + g_iopenfloat4)) {
		Format(kopottsag, sizeof(kopottsag), "Minimal Wear");
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4) && szam < (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3)) {
		Format(kopottsag, sizeof(kopottsag), "Field Tested");
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3) && szam < (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2)) {
		Format(kopottsag, sizeof(kopottsag), "Well Worn");
	}
	else if (szam >= (g_iopenfloat5 + g_iopenfloat4 + g_iopenfloat3 + g_iopenfloat2) && szam <= 100000) {
		Format(kopottsag, sizeof(kopottsag), "Battle Scarred");
	}
	return kopottsag;
}

rareidtocolor(int fegyver_id)
{
	new String:fegyvername[64];
	switch (fegyver_id)
	{
		case 1:
		{
			Format(fegyvername, sizeof(fegyvername), "{darkblue}");
		}
		case 2:
		{
			Format(fegyvername, sizeof(fegyvername), "{purple}");
		}
		case 3:
		{
			Format(fegyvername, sizeof(fegyvername), "{orchid}");
		}
		case 4:
		{
			Format(fegyvername, sizeof(fegyvername), "{darkred}");
		}
		case 5:
		{
			Format(fegyvername, sizeof(fegyvername), "{yellow}");
		}
		case 6:
		{
			Format(fegyvername, sizeof(fegyvername), "{darkred}");
		}
		case 7:
		{
			Format(fegyvername, sizeof(fegyvername), "{darkred}");
		}
		case 8:
		{
			Format(fegyvername, sizeof(fegyvername), "{lime}");
		}
	}
	return fegyvername;
}

rareidtocolorname(int client, int fegyver_id)
{
	new String:fegyvername[64];
	switch (fegyver_id)
	{
		case 1:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "blue_l", client);
		}
		case 2:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "purple_l", client);
		}
		case 3:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "pink_l", client);
		}
		case 4:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "red_l", client);
		}
		case 5:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "gold_l", client);
		}
		case 6:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "knife_l", client);
		}
		case 7:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "gloves_l", client);
		}
		case 8:
		{
			Format(fegyvername, sizeof(fegyvername), "%T", "custom_l", client);
		}
	}
	return fegyvername;
}

rareidtorgbcolor(int fegyver_id, int color)
{
	int fegyvername;
	switch (color)
	{
		case 1:
		{
			switch (fegyver_id)
			{
				case 1:
				{
					fegyvername = 63;
				}
				case 2:
				{
					fegyvername = 128;
				}
				case 3:
				{
					fegyvername = 199;
				}
				case 4:
				{
					fegyvername = 237;
				}
				case 5:
				{
					fegyvername = 255;
				}
				case 6:
				{
					fegyvername = 237;
				}
				case 7:
				{
					fegyvername = 237;
				}
				case 8:
				{
					fegyvername = 50;
				}
			}
		}
		case 2:
		{
			switch (fegyver_id)
			{
				case 1:
				{
					fegyvername = 72;
				}
				case 2:
				{
					fegyvername = 49;
				}
				case 3:
				{
					fegyvername = 36;
				}
				case 4:
				{
					fegyvername = 28;
				}
				case 5:
				{
					fegyvername = 247;
				}
				case 6:
				{
					fegyvername = 28;
				}
				case 7:
				{
					fegyvername = 28;
				}
				case 8:
				{
					fegyvername = 205;
				}
			}
		}
		case 3:
		{
			switch (fegyver_id)
			{
				case 1:
				{
					fegyvername = 204;
				}
				case 2:
				{
					fegyvername = 167;
				}
				case 3:
				{
					fegyvername = 177;
				}
				case 4:
				{
					fegyvername = 36;
				}
				case 5:
				{
					fegyvername = 79;
				}
				case 6:
				{
					fegyvername = 36;
				}
				case 7:
				{
					fegyvername = 36;
				}
				case 8:
				{
					fegyvername = 50;
				}
			}
		}
	}
	return fegyvername;
}

public bool IsInteger(String:buffer[])
{
	int len = strlen(buffer);
	int i=0;
	if(StrContains(buffer,"-")!=-1){
		i++;
	}
	for (; i < len; i++)
	{
		if (!IsCharNumeric(buffer[i]))
			return false;
	}

	return true;
}


public StrToLower(String:arg[])
{
	for (new i = 0; i < strlen(arg); i++)
	{
		arg[i] = CharToLower(arg[i]);
	}
}