/*
 *	
 *  Case System plugin made by:         MegoltElek    https://forums.alliedmods.net/member.php?u=306454
 *	Weapons and gloves plugin made by:  kgns          https://forums.alliedmods.net/member.php?u=279636
 *	Rock paper scissors plugin made by: Totenfluch    https://forums.alliedmods.net/member.php?u=166543
 *
 **/
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <PTaH>
#include <weapons>
#include <multicolors>
#include <autoexecconfig>
#include <discord>
#include <fpvm_interface>
#include <clientprefs>
#include <vip_core>


// only use this if you want to use my custom ranks plugin too
#if defined RAB
	#include <hexstocks>
	#include <hextags>
#endif


#pragma semicolon 1
#include "ladarendszer/incl.sp"


public Plugin myinfo =
{
	name		= "MegoltElek Ladarendszer",
	author		= "MegoltElek",
	description = "MegoltElek ladarendszer",
	version		= VERSION,
	url			= "https://steamcommunity.com/id/megoltelekhun/"
};

public OnPluginStart()
{
	g_sound = RegClientCookie("elekcase_sound", "Turn on or off the case open sound", CookieAccess_Private);
	ReadConfig();
	RegConsoleCmd("sm_gift", Cmd_gift, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_credits", Cmd_credits, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_balance", Cmd_credits, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_topcredits", Cmd_topc, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_topcredit", Cmd_topc, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_topbalance", Cmd_topc, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_ladanyitas", Cmd_openlada, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_nyit", Cmd_openlada, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_nyitas", Cmd_openlada, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_open", Cmd_openlada, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_opencase", Cmd_openlada, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_inv", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_piac", Cmd_piac, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_ws", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_bolt", Cmd_bolt, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_elad", Cmd_elad, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_sell", Cmd_elad, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_casino", Cmd_casino, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_gambling", Cmd_casino, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_shop", Cmd_bolt, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_store", Cmd_bolt, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_jatekos", Cmd_jatekos, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_knife", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_lada", Cmd_premainmenu, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_skin", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_skins", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_case", Cmd_premainmenu, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_gloves", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_glove", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_eldiven", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_gllang", Cmd_inv, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_openanim", Cmd_openanim, "Open ladarendszer mainmenu");
	RegConsoleCmd("sm_lotto", Cmd_openlotto, "Open lotto mainmenu");
	RegConsoleCmd("sm_lottery", Cmd_openlotto, "Open lotto mainmenu");
	RegConsoleCmd("sm_ticket", Cmd_openlotto, "Open lotto mainmenu");
	#if defined RAB
		RegAdminCmd("sm_chatcolor", Command_chatcolor, ADMFLAG_CUSTOM5, "chat színt állít");
		RegAdminCmd("sm_chattag", Command_chattag, ADMFLAG_CUSTOM5, "chat taget állít");
		RegAdminCmd("sm_namecolor", Command_namecolor, ADMFLAG_CUSTOM5, "chat taget állít");
		RegAdminCmd("sm_color", Command_colors, ADMFLAG_CUSTOM5, "chat színek");
		RegAdminCmd("sm_colors", Command_colors, ADMFLAG_CUSTOM5, "chat színek");
		RegAdminCmd("sm_addvip", cmd_addvip, ADMFLAG_ROOT, "VIP hozzáadása a rendszerhez");
	#endif
	RegConsoleCmd("sm_givecredits", Command_GiveCredits, "Kreditet addol");
	RegConsoleCmd("sm_ofk", Command_GiveKnifeFix, "...");
	RegConsoleCmd("sm_kpo", sspCommand, "Opens the SSP Menu");
	RegConsoleCmd("sm_srp", sspCommand, "Opens the SSP Menu");
	RegConsoleCmd("sm_blockssp", blockSSPCommand, "Blocks SSP invites");
	RegConsoleCmd("sm_unblockssp", unblockSSPCommand, "unblocks SSP invites");
	RegConsoleCmd("sm_togglessp", toggleSSPCommand, "toggles the Block for SSP invites");
	RegConsoleCmd("sm_giveskin", Command_GiveSkin, "Skint addol");
	RegConsoleCmd("sm_trade", Cmd_trade, "Trade menu");
	RegConsoleCmd("sm_csere", Cmd_trade, "Trade menu");
	RegConsoleCmd("sm_ref", Cmd_ref, "Referal menu");
	RegConsoleCmd("sm_invite", Cmd_ref, "Referal menu");
	RegConsoleCmd("sm_stopopen", Cmd_stopopen, "Referal menu");
	RegConsoleCmd("sm_ladacommands", Command_ladacommands, "parancsok megtekintése");
	AddCommandListener(ChatListener, "say");
	AddCommandListener(ChatListener, "say2");
	AddCommandListener(ChatListener, "say_team");
	char sConfig[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sConfig, PLATFORM_MAX_PATH, "configs/elekcase/configuration.txt");
	
	if(custom_kv != INVALID_HANDLE) CloseHandle(custom_kv);
	
	custom_kv = CreateKeyValues("CustomModels");
	FileToKeyValues(custom_kv, sConfig);
	
	BuildPath(Path_SM, sConfig, PLATFORM_MAX_PATH, "configs/elekcase/quests.txt");
	if(quest_kv != INVALID_HANDLE) CloseHandle(quest_kv);
	
	quest_kv = CreateKeyValues("Quest");
	FileToKeyValues(quest_kv, sConfig);
	VerifyTable();
	StartSQL();
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("round_start", Event_roundstart);
	//lada_cheat
	HookEvent("player_spawn", Event_PlayerSpawn);
    HookEvent("round_end", Event_RoundEnd);
	lada_initcheat();
	//
	betoltve = 0;
	LoadTranslations("srp.phrases");
	CreateTimer(g_fGiveClientCredits, GiveClientCredits, _, TIMER_REPEAT);
	CreateTimer(g_fGiveClientCredits, GiveClientBonusCreditName, _, TIMER_REPEAT);
	delete g_smWeaponIndex;
	g_smWeaponIndex = new StringMap();
	for (int i = 0; i < sizeof(g_WeaponClasses); i++)
	{
		g_smWeaponIndex.SetValue(g_WeaponClasses[i], i);
		//g_smWeaponDefIndex.SetValue(g_WeaponClasses[i], g_iWeaponDefIndex[i]);
	}
	if(VIP_IsVIPLoaded())
	{
		VIP_OnVIPLoaded();
	}
}


public Event_roundstart(Handle:event, const String:name[], bool:dontBroadcast)
{
	char query[255];
	Format(query, sizeof(query), "SELECT timestamp,UNIX_TIMESTAMP(Now()) FROM lada_lottotimer");
	SQL_TQuery(hDatabase, T_GetLottoTimerWinner, query, 0);
} 

public void OnMapStart()
{
	AddFileToDownloadsTable("sound/rab_knife_unbox.mp3");
	PrecacheSound("rab_knife_unbox.mp3");
	#if defined RAB
		AddFileToDownloadsTable("sound/join_sounds/vip_join_astronaut.mp3");
		PrecacheSound("join_sounds/vip_join_astronaut.mp3");
	#endif
	AddFileToDownloadsTable("sound/music/elekcase/case_unlock.mp3");
	PrecacheSound("music/elekcase/case_unlock.mp3");
	AddFileToDownloadsTable("models/props/crates/csgo_drop_crate_elekcase.mdl");
	AddFileToDownloadsTable("models/props/crates/csgo_drop_crate_elekcase.vvd");
	AddFileToDownloadsTable("models/props/crates/csgo_drop_crate_elekcase.dx90.vtx");
	AddFileToDownloadsTable("materials/models/tomymodels/csgo_drop_crate_elekcase.vmt");
	AddFileToDownloadsTable("materials/models/tomymodels/csgo_drop_crate_elekcase.vtf");
	
	
	new String:imFile[PLATFORM_MAX_PATH];
	new String:line[192];
	
	BuildPath(Path_SM, imFile, sizeof(imFile), "configs/elekcase/downloads.txt");
	
	Handle file = OpenFile(imFile, "r");
	
	if(file != INVALID_HANDLE)
	{
		while (!IsEndOfFile(file))
		{
			if (!ReadFileLine(file, line, sizeof(line)))
			{
				break;
			}
			
			TrimString(line);
			if( strlen(line) > 0 && FileExists(line))
			{
				AddFileToDownloadsTable(line);
			}
		}

		CloseHandle(file);
	}
	else
	{
		LogError("[ElekCase] no file found for downloads (configs/elekcase/downloads.txt)");
	}
	//lada_cheat
	resetPlayerVars(0);
}


public void OnPluginEnd() 
{
	destoryGlows();
	if(CanTestFeatures() && GetFeatureStatus(FeatureType_Native, "VIP_UnregisterFeature") == FeatureStatus_Available)
	{
		VIP_UnregisterFeature(g_szFeature1);
		VIP_UnregisterFeature(g_szFeature3);
		VIP_UnregisterFeature(g_szFeature4);
		VIP_UnregisterFeature(g_szFeature5);
		VIP_UnregisterFeature(g_szFeature6);
		VIP_UnregisterFeature(g_szFeature7);
	}
}