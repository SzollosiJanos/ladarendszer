#if defined ladarendszer_inc
  #endinput
#endif
#define ladarendszer_inc



public SharedPlugin __pl_case_system = {
	name = "MegoltElek_Ladarendszer",
	file = "ladarendszer.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

public void __pl_case_system_SetNTVOptional()
{
	MarkNativeAsOptional("lada_addcredit");
	MarkNativeAsOptional("lada_addcase");
	MarkNativeAsOptional("lada_addkey");
	MarkNativeAsOptional("lada_formatcredit");
	MarkNativeAsOptional("lada_getplayercredit");
}

/**
 *
 *   Ladarendszer include file version 0.0.4
 *   Made by: MegoltElek#1102
 *
 */


/**
 * Creditet ad a jatekosnak.
 *
 * @param client    A jatekos index.
 * @param credit    A credit mennyisege.
 * @return        Void
 */
native void lada_addcredit(int client, int credit);


/**
 * Ladat ad a jatekosnak.
 *
 * @param client    A jatekos index.
 * @param lada    A lada id-je.
 * @param number    A darabszam.
 * @return        Void
 */
native void lada_addcase(int client, int lada, int number);


/**
 * Kulcsot ad a jatekosnak.
 *
 * @param client    A jatekos index.
 * @param lada    A lada id-je.
 * @param number    A darabszam.
 * @return        Void
 */
native void lada_addkey(int client, int lada, int number);


/**
 * Kulcsot ad a jatekosnak.
 *
 * @param str    A szoveg, amibe bele kell helyezni a dollart formazva.   {CREDIT} jellel jelolve a helyet, ahova be lesz helyettesitve.
 * @param credit    A credit, amely be lesz helyettesítve formazva a {CREDIT} jellel jelolt helyre.
 * @return        Void
 */
native void lada_formatcredit(char[] str, int credit);


/**
 * Visszaadja az adott jatekos crediteinek szamat.
 *
 * @param client    A jatekos id-je.
 * @return        int
 */
native int lada_getplayercredit(int client);