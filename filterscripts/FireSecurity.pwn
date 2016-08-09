/*
                                    Copyright(c), [Dz]Aftermath
 ______________________________________________________________________________________________
|                                                                                              |
|                                                                                              |
|    * FilterScript creado por [Dz]Aftermath.                                                  |
|    - Todos los derechos reservados.                                                          |
|    - Recopilación de [Dz]Aftermath.                                                          |
|    - Agradecimientos: Spell, Rcons, L[O]G4N & xRicard[O]x                                    |
|    - Includes: CleoFuck, creado por Lorenc.                                                  |
|    - Códigos adicionales: Rcons, Spell.                                                      |                                        |
|______________________________________________________________________________________________|


                                  FilterScript - [FS]Seguridad
                                 ------------------------------
*/

//==============================================================================
// Includes.
//==============================================================================
#include <a_samp>
#include <CleoFuck>
//==============================================================================
// Pragma.
//==============================================================================
#pragma tabsize 0
//==============================================================================
//------------------------------------------------------------------------------
//                         Configuración.
//------------------------------------------------------------------------------
//==============================================================================
//==============================================================================
// Defines - Protecciones.
//==============================================================================
#define AntiBot 1 // Para desactivar el Anti Bot, simplemente coloque "0" en la línea.
#define AntiJoin 1 // Para desactivar el Anti Join Flood, simplemente coloque "0" en la línea.
#define AntiCrash 1 // Para desactivar el Anti Car Crash, simplemente coloque "0" en la línea.
#define AntiArmas 1 // Para desactivar el Anti Armas prohibidas, simplemente coloque "0" en la línea.
#define AntiCleo 1 // Para desactivar el Anti Cleo Hack, simplemente coloque "0" en la línea.
#define AntiScore 1 // Para desactivar el Anti Score Hack, simplemente coloque "0" en la línea.
#define AntiRakSAMP 1 // Para desactivar el Anti RakSA-MP, simplemente coloque "0" en la línea.
//==============================================================================
// Defines - Colores.
//==============================================================================
#define Cyan 0x00FFFFFF
#define Gris 0xC0C0C0AA
#define Rojo 0xFF0000AA
#define Verde 0x21DD00FF
//==============================================================================
// Defines - Anti Join Flood.
//==============================================================================
#define MenorTiempo   10000
#define Logueos       2
//==============================================================================
// AntiAmx.
//==============================================================================
AntiAmx()
{
new a[][] =
{
"Unarmed (Fist)",
"Brass K"
};
#pragma unused a
}
//==============================================================================
// Forwards.
//==============================================================================
forward Detect(playerid);
//==============================================================================
// News.
//==============================================================================
new Barra[MAX_PLAYERS] = {-1,...}, Advertencias[MAX_PLAYERS] = {0,...}, bool:BotServidor[MAX_PLAYERS] = {false, ...}, Jugadores = MAX_PLAYERS;
new Muertes[MAX_PLAYERS];
new MuerteReciente[MAX_PLAYERS];
new EntrarIP[10][20];
new EntrarCuenta[10];
//==============================================================================
//------------------------------------------------------------------------------
//                         Publics.
//------------------------------------------------------------------------------
//==============================================================================
//==============================================================================
// Public - OnFilterScriptInit.
//==============================================================================
public OnFilterScriptInit()
{
print("[FS]Sistema FireSecurity activado.");
AntiAmx();
return 1;
}
//==============================================================================
// Public - OnFilterScriptExit.
//==============================================================================
public OnFilterScriptExit()
{
print("[FS]Sistema FireSecurity desactivado.");
AntiAmx();
return 1;
}
//==============================================================================
// Public - OnPlayerConnect.
//==============================================================================
public OnPlayerConnect(playerid)
{
#if defined AntiJoin 1
new Texto[1000];
new Nombre[MAX_PLAYER_NAME];
if(IsPlayerNPC(playerid))
return 1;
new Entradas = 0;
new RegistroIP[20];
new Cuenta = GetTickCount();
new Nick[MAX_PLAYER_NAME];
new Codigo;
new Jugador;
new Menu[1024];
if(DetectarIP(ObtenerIP(playerid)) >= 10) return BanearBots(playerid), 0;
Jugadores = playerid > Jugadores ? playerid : IDMayor(),
BotServidor[playerid] = bool:IsPlayerNPC(playerid),
Advertencias[playerid] = 0;
Muertes[playerid] = 0;
MuerteReciente[playerid] = 0;
GetPlayerIp(playerid, RegistroIP, 19);
GetPlayerName(playerid, Nick, MAX_PLAYER_NAME);
for(Codigo = 0; Codigo < 10; Codigo++)
{
if(strlen(EntrarIP[Codigo]) < 10)  continue;
if(strcmp(RegistroIP, EntrarIP[Codigo], true) == 0)
{
if((Cuenta - MenorTiempo) < EntrarCuenta[Codigo])
{
Entradas++;
}
}
}
if (Entradas >= Logueos)
{
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Baneado por intento de Join Flood.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - FireSecurity: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido baneado. Razón: {B50000}Posible Join Flood.", Nombre);
SendClientMessageToAll(-1, Texto);
BanEx(playerid, "[<!>] Baneado por intento de Join Flood.");
}
for (Codigo = 9; Codigo > 0; Codigo--)
{
Jugador = Codigo - 1;
format(EntrarIP[Codigo], 19, "%s", EntrarIP[Jugador]);
EntrarCuenta[Codigo] = EntrarCuenta[Jugador];
}
format(EntrarIP[0], 19, "%s", RegistroIP);
EntrarCuenta[0] = Cuenta;
#endif
return 1;
}
//==============================================================================
// Public - OnPlayerDisconnect.
//==============================================================================
public OnPlayerDisconnect(playerid, reason)
{
Jugadores = IDMayor(playerid);
if(BotServidor[playerid]) BotServidor[playerid] = false;
if(Barra[playerid] != -1)
{
KillTimer(Barra[playerid]);
Barra[playerid] = -1;
}
Advertencias[playerid] = 0;
return 1;
}
//==============================================================================
// Public - Detect.
//==============================================================================
public Detect(playerid)
{
new Ping = GetPlayerPing(playerid);
if(Ping <= 0 || Ping >= 100000)
{
if(Advertencias[playerid] >= 1) BanearBots(playerid);
else Advertencias[playerid]++, Barra[playerid] = SetTimerEx("Detectar", 1500, false, "Ping", playerid);
}
return 0;
}
//==============================================================================
// Public - OnPlayerDeath.
//==============================================================================
public OnPlayerDeath(playerid, killerid, reason)
{
#if defined AntiScore 1
new Texto[1000];
new Nombre[MAX_PLAYER_NAME];
new Menu[1024];
if(Muertes[playerid] == 0)
{
MuerteReciente[playerid] = gettime();
}
Muertes[playerid]++;
if(Muertes[playerid] == 5)
{
if((gettime() - MuerteReciente[playerid]) <= 5)
{
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Baneado por posible intento de Score Hack.  \n", 1024);
strcat(Menu, "{FFFFFF} Si es un error desinstale los mods y hable con un administrador.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido baneado. Razón: Posible intento de Score Hack.", Nombre);
SendClientMessageToAll(-1, Texto);
BanEx(playerid, "[<!>] Baneado por posible Score Hack.");
}
else if((gettime() - MuerteReciente[playerid]) > 5)
{
Muertes[playerid] = 0;
}
}
#endif
return 1;
}
//==============================================================================
// Public - OnPlayerKeyStateChange.
//==============================================================================
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
#if defined AntiArmas 1
new Menu[1024];
if(newkeys & KEY_FIRE && ArmaProhibida(playerid))
{
new Arma, Balas;
GetPlayerWeaponData(playerid, 7, Arma, Balas);
SetPlayerHealth(playerid, 0);
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Arma prohibida detectada.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
#endif
return 1;
}
return 1;
}
//==============================================================================
// Public - OnPlayerEnterVehicle.
//==============================================================================
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
#if defined AntiRakSAMP 1
new Texto[256];
new Nombre[MAX_PLAYER_NAME];
new Menu[1024];
if(!IsPlayerConnected(playerid)) return 0;
if(!AutoPermitido(GetVehicleModel(vehicleid)))
{
DestroyVehicle(vehicleid);
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Expulsado por posible intento de RakSA-MP.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido expulsado. Razón: Posible intento de RakSA-MP.", Nombre);
SendClientMessageToAll(Gris, Texto);
Kick(playerid);
#endif
}
return 1;
}
//==============================================================================
// Public - OnPlayerCleoDetected.
//==============================================================================
public OnPlayerCleoDetected(playerid, cleoid)
{
#if defined AntiCleo 1
switch(cleoid)
{
case CLEO_CARWARP:
{
new Texto[256];
new Nombre[MAX_PLAYER_NAME];
new Menu[1024];
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Expulsado por posible intento de Car Warp.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido expulsado. Razón: Posible Car Warp.", Nombre);
SendClientMessageToAll(Gris, Texto);
Kick(playerid);
}
case CLEO_CARSWING:
{
new Texto[1000];
new Nombre[MAX_PLAYER_NAME];
new Menu[1024];
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Expulsado por posible intento de Car Swing.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido expulsado. Razón: Posible Car Swing.", Nombre);
SendClientMessageToAll(Gris, Texto);
Kick(playerid);
}
case CLEO_CAR_PARTICLE_SPAM:
{
new Texto[1000];
new Nombre[MAX_PLAYER_NAME];
new Menu[1024];
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Expulsado por posible intento de Cleo Spam.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido expulsado. Razón: Posible Cleo Spam.", Nombre);
SendClientMessageToAll(Gris, Texto);
Kick(playerid);
}
}
#endif
return 1;
}
//==============================================================================
// Public - OnVehicleMod.
//==============================================================================
public OnVehicleMod(playerid, vehicleid, componentid)
{
#if defined AntiCrash 1
if((IsPlayerInRangeOfPoint(playerid,2,617.5303,-1.9900,1000.651) && GetPlayerInterior(playerid) == 1) ||
(IsPlayerInRangeOfPoint(playerid,2,616.7830,-74.8150,997.772) && GetPlayerInterior(playerid) == 2) ||
(IsPlayerInRangeOfPoint(playerid,2,615.2862,-124.2390,997.697) && GetPlayerInterior(playerid) == 3)) return 1;
new Menu[1024];
new Texto[256];
new Nombre[MAX_PLAYER_NAME];
switch(componentid)
{
case 1008..1010: if(AutoProhibido(playerid)) RemoveVehicleComponent(vehicleid, componentid);
}
if(!AutoCrash(GetVehicleModel(vehicleid), componentid)) RemoveVehicleComponent(vehicleid, componentid);
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Usted ha sido expulsado por posible cheat de Car Crasher.  \n", 1024);
strcat(Menu, "{FFFFFF} Si es un error, evite tunear su auto con lo último que le puso.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido expulsado. Razón: Posible Crasher.", Nombre);
SendClientMessageToAll(Gris, Texto);
Kick(playerid);
#endif
return 1;
}
//==============================================================================
// Stock - DetectarIP.
//==============================================================================
stock DetectarIP(IP[])
{
new Codigo = 0;
for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !strcmp(ObtenerIP(i), IP)) Codigo++;
return Codigo;
}
//==============================================================================
// Stock - ObtenerIP.
//==============================================================================
stock ObtenerIP(playerid)
{
new IP[16];
GetPlayerIp(playerid, IP, sizeof(IP));
return IP;
}
//==============================================================================
// Stock - BanearBots.
//==============================================================================
stock BanearBots(playerid)
{
#if defined AntiBot 1
new IP[32];
new Texto[256];
new Nombre[MAX_PLAYER_NAME];
new Menu[1024];
GetPlayerIp(playerid, IP, sizeof(IP));
for(new i = 0, PingUp = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !BotServidor[i])
{
PingUp = GetPlayerPing(i);
if(i == playerid || !strcmp(IP, ObtenerIP(i)) || PingUp <= 0 || PingUp >= 50000)
{
Menu[0]='\0';
strcat(Menu, "{FFFFFF} Baneado por intento de Bot.  \n", 1024);
ShowPlayerDialog(playerid, 9046, DIALOG_STYLE_MSGBOX, " {FF0000}Advertencia - UrbanCity-AntiCheat: ", Menu, "Aceptar", "Cerrar") ;
GetPlayerName(playerid, Nombre, sizeof(Nombre));
format(Texto, sizeof(Texto), "[{B50000}UrbanCity-{FFFFFF}AntiCheat] {B50000}%s {FFFFFF}ha sido baneado. Razón: Posible Bot.", Nombre);
SendClientMessageToAll(Gris, Texto);
BanEx(playerid, "[<!>] Baneado por intento de Bot.");
if(Barra[i] != -1)
{
KillTimer(Barra[i]);
Barra[i] = -1;
}
}
}
format(IP, sizeof(IP), "banip %s", IP);
return SendRconCommand(IP);
#endif
}
//==============================================================================
// Stock - AutoPermitido.
//==============================================================================
stock AutoPermitido(vehicleid)
{
if(vehicleid < 400 || vehicleid > 611) return false;
else return true;
}
//==============================================================================
// Stock - Jugador2.
//==============================================================================
stock Jugador2(playerid)
{
new name[MAX_PLAYER_NAME];
GetPlayerName(playerid, name, sizeof(name));
return name;
}

//==============================================================================
// Stock - IDMayor.
//==============================================================================
stock IDMayor(exceptof = INVALID_PLAYER_ID)
{
new MaxID = 0;
for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && i != exceptof && i > MaxID) MaxID = i;
return MaxID;
}
//==============================================================================
// Stock - AutoProhibido.
//==============================================================================
stock AutoProhibido(playerid)
{
new Auto = GetPlayerVehicleID(playerid);
#define MAX_INVALID_NOS_VEHICLES 52
new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
{
581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 417, 425, 469, 487, 512, 520, 563, 593,
509, 481, 510, 472, 473, 493, 520, 595, 484, 430, 453, 432, 476, 497, 513, 533, 577,
452, 446, 447, 454, 590, 569, 537, 538, 570, 449, 519, 460, 488, 511, 519, 548, 592
};
if(IsPlayerInAnyVehicle(playerid))
{
for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
{
if(GetVehicleModel(Auto) == InvalidNosVehicles[i]) return true;
}
}
return false;
}
//==============================================================================
// Stock - AutoCrash.
//==============================================================================
stock AutoCrash(modelid, componentid)
{
if(componentid == 1025 || componentid == 1073 || componentid == 1074 || componentid == 1075 || componentid == 1076 ||
componentid == 1077 || componentid == 1078 || componentid == 1079 || componentid == 1080 || componentid == 1081 ||
componentid == 1082 || componentid == 1083 || componentid == 1084 || componentid == 1085 || componentid == 1096 ||
componentid == 1097 || componentid == 1098 || componentid == 1087 || componentid == 1086)
return true;
switch (modelid)
{
case 400: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010);
case 401: return (componentid == 1005 || componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 114 || componentid == 1020 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 402: return (componentid == 1009 || componentid == 1009 || componentid == 1010);
case 404: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007);
case 405: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1014 || componentid == 1023 || componentid == 1000);
case 409: return (componentid == 1009);
case 410: return (componentid == 1019 || componentid == 1021 || componentid == 1020 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 411: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 412: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 415: return (componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 418: return (componentid == 1020 || componentid == 1021 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1016);
case 419: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 420: return (componentid == 1005 || componentid == 1004 || componentid == 1021 || componentid == 1019 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1003);
case 421: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1023 || componentid == 1016 || componentid == 1000);
case 422: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1017 || componentid == 1007);
case 426: return (componentid == 1005 || componentid == 1004 || componentid == 1021 || componentid == 1019 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003);
case 429: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 436: return (componentid == 1020 || componentid == 1021 || componentid == 1022 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 438: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 439: return (componentid == 1003 || componentid == 1023 || componentid == 1001 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1017 || componentid == 1007 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1013);
case 442: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 445: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 451: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 458: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 466: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 467: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 474: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 475: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 477: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1017 || componentid == 1007);
case 478: return (componentid == 1005 || componentid == 1004 || componentid == 1012 || componentid == 1020 || componentid == 1021 || componentid == 1022 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010);
case 479: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 480: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 489: return (componentid == 1005 || componentid == 1004 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1016 || componentid == 1000);
case 491: return (componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 492: return (componentid == 1005 || componentid == 1004 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1016 || componentid == 1000);
case 496: return (componentid == 1006 || componentid == 1017 || componentid == 1007 || componentid == 1011 || componentid == 1019 || componentid == 1023 || componentid == 1001 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1003 || componentid == 1002 || componentid == 1142 || componentid == 1143 || componentid == 1020);
case 500: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010);
case 506: return (componentid == 1009);
case 507: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 516: return (componentid == 1004 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1015 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007);
case 517: return (componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1023 || componentid == 1016 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 518: return (componentid == 1005 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 526: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 527: return (componentid == 1021 || componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1014 || componentid == 1015 || componentid == 1017 || componentid == 1007);
case 529: return (componentid == 1012 || componentid == 1011 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 533: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 534: return (componentid == 1126 || componentid == 1127 || componentid == 1179 || componentid == 1185 || componentid == 1100 || componentid == 1123 || componentid == 1125 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1180 || componentid == 1178 || componentid == 1101 || componentid == 1122 || componentid == 1124 || componentid == 1106);
case 535: return (componentid == 1109 || componentid == 1110 || componentid == 1113 || componentid == 1114 || componentid == 1115 || componentid == 1116 || componentid == 1117 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1120 || componentid == 1118 || componentid == 1121 || componentid == 1119);
case 536: return (componentid == 1104 || componentid == 1105 || componentid == 1182 || componentid == 1181 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1184 || componentid == 1183 || componentid == 1128 || componentid == 1103 || componentid == 1107 || componentid == 1108);
case 540: return (componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
case 541: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 542: return (componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1015);
case 545: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 546: return (componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
case 547: return (componentid == 1142 || componentid == 1143 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1016 || componentid == 1003 || componentid == 1000);
case 549: return (componentid == 1012 || componentid == 1011 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 550: return (componentid == 1005 || componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003);
case 551: return (componentid == 1005 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1023 || componentid == 1016 || componentid == 1003);
case 555: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 558: return (componentid == 1092 || componentid == 1089 || componentid == 1166 || componentid == 1165 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1168 || componentid == 1167 || componentid == 1088 || componentid == 1091 || componentid == 1164 || componentid == 1163 || componentid == 1094 || componentid == 1090 || componentid == 1095 || componentid == 1093);
case 559: return (componentid == 1065 || componentid == 1066 || componentid == 1160 || componentid == 1173 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1159 || componentid == 1161 || componentid == 1162 || componentid == 1158 || componentid == 1067 || componentid == 1068 || componentid == 1071 || componentid == 1069 || componentid == 1072 || componentid == 1070 || componentid == 1009);
case 560: return (componentid == 1028 || componentid == 1029 || componentid == 1169 || componentid == 1170 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1141 || componentid == 1140 || componentid == 1032 || componentid == 1033 || componentid == 1138 || componentid == 1139 || componentid == 1027 || componentid == 1026 || componentid == 1030 || componentid == 1031);
case 561: return (componentid == 1064 || componentid == 1059 || componentid == 1155 || componentid == 1157 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1154 || componentid == 1156 || componentid == 1055 || componentid == 1061 || componentid == 1058 || componentid == 1060 || componentid == 1062 || componentid == 1056 || componentid == 1063 || componentid == 1057);
case 562: return (componentid == 1034 || componentid == 1037 || componentid == 1171 || componentid == 1172 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1149 || componentid == 1148 || componentid == 1038 || componentid == 1035 || componentid == 1147 || componentid == 1146 || componentid == 1040 || componentid == 1036 || componentid == 1041 || componentid == 1039);
case 565: return (componentid == 1046 || componentid == 1045 || componentid == 1153 || componentid == 1152 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1150 || componentid == 1151 || componentid == 1054 || componentid == 1053 || componentid == 1049 || componentid == 1050 || componentid == 1051 || componentid == 1047 || componentid == 1052 || componentid == 1048);
case 566: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 567: return (componentid == 1129 || componentid == 1132 || componentid == 1189 || componentid == 1188 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1187 || componentid == 1186 || componentid == 1130 || componentid == 1131 || componentid == 1102 || componentid == 1133);
case 575: return (componentid == 1044 || componentid == 1043 || componentid == 1174 || componentid == 1175 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1176 || componentid == 1177 || componentid == 1099 || componentid == 1042);
case 576: return (componentid == 1136 || componentid == 1135 || componentid == 1191 || componentid == 1190 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1192 || componentid == 1193 || componentid == 1137 || componentid == 1134);
case 579: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 580: return (componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
case 585: return (componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
case 587: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 589: return (componentid == 1005 || componentid == 1004 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1024 || componentid == 1013 || componentid == 1006 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007);
case 600: return (componentid == 1005 || componentid == 1004 || componentid == 1020 || componentid == 1022 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1017 || componentid == 1007);
case 602: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
case 603: return (componentid == 1144 || componentid == 1145 || componentid == 1142 || componentid == 1143 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
}
return false;
}
//==============================================================================
// Stock - ArmaProhibida.
//==============================================================================
stock ArmaProhibida(playerid)
{
new Arma = GetPlayerWeapon(playerid);
if( Arma == 44|| Arma == 45)
{
return true;
}
return false;
}

// © SkyStudios SA-MP: Todos los derechos reservados.
