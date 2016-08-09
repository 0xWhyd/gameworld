// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <mSelection>

#define FILTERSCRIPT

enum pMueble
{
	pTieneMueble,
	pObjetoID
};
new PlayerInfo[MAX_PLAYERS][pMueble];
new Float:X,Float:Y,Float:Z, Float:fAngle,Objeto_Por_Jugador[MAX_PLAYERS];
new muebles = mS_INVALID_LISTID;
new bool:guardando[MAX_PLAYERS];
public OnFilterScriptInit()
{
	muebles = LoadModelSelectionMenu("obmuebles.txt");
	new File:hFile = fopen("mueblesguardados.inc", io_readwrite);
	if(!hFile)
	{
	    print("CMUEBLES: Archivo msaved.inc no ha sido encontrado. Por ende ha sido creado en la carpeta scriptfiles.");
	    print(" - - - - - - Gracias por bajar el FS y conservar los creditos. - - - - - - - - -");
		fwrite(hFile, "/* Si quieres convertir este código en el tipo de xStreamer o otro ve a www.convertffs.com\r\nRecuerda que el script fue por JustBored */\r\n");
	    fclose(hFile);
	}
	if(hFile)
	{
		print("CMUEBLES: Archivo mueblesguardados.inc cargado en la carpeta scriptfiles");
		return 1;
	}
	return 1;
}
zcmd(cmueble, playerid, params[])
{
    ShowModelSelectionMenu(playerid, muebles, "Muebles", 0x4A5A6BBB, 0x88888899, 0xFAFAFA);
	return 1;
}
zcmd(colocarm, playerid, params[])
{
	if(PlayerInfo[playerid][pTieneMueble] == 1)
	{
		GetPlayerPos(playerid, X,Y,Z);
		GetPlayerFacingAngle(playerid, fAngle);
		Objeto_Por_Jugador[playerid] = CreateObject(PlayerInfo[playerid][pObjetoID], X,Y,Z, 0,0,fAngle,100.0);
		EditObject(playerid, Objeto_Por_Jugador[playerid]);
		SendClientMessage(playerid, 0xFF000FF, "Ahora, cuando termines de posicionar el objeto utiliza /guardarob y clickea en el objeto.");
	}
	return 1;
}
public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == muebles)
	{
	    if(response)
	    {
			PlayerInfo[playerid][pTieneMueble] = 1;
			PlayerInfo[playerid][pObjetoID] = modelid;
			SendClientMessage(playerid, 0xFF0000FF, "Has creado el objeto.  ahora utiliza /colocarm para editar el objeto. ");
   		}else SendClientMessage(playerid, 0xFF0000FF, "Operación cancelada.");
	}
	return 1;
}
zcmd(guardarob, playerid, params[])
{
    SelectObject(playerid);
    SendClientMessage(playerid, 0xFF0000FF, "Ahora clickea en el objeto.");
    guardando[playerid] = true;
    return 1;
}
zcmd(ayuda, playerid, params[])
{
	SendClientMessage(playerid, -1, "Ayuda: /cmueble /colocarm /guardarob /ayuda");
	return 1;
}
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	if(type == SELECT_OBJECT_GLOBAL_OBJECT)
    {
		if(guardando[playerid] == true)
		{
			SendClientMessage(playerid, 0xFF0000FF, "Posición del objeto guardada.");
        	new File: hFile;
			hFile = fopen("mueblesguardados.inc", io_append);
			if(hFile)
			{
				GetObjectPos(objectid, X,Y,Z);
 				new Float:rX,Float:rY,Float:rZ;
  				GetObjectRot(objectid,rX,rY,rZ);
   				new string2[256];
    			format(string2, 256, "CreateObject(%d, %f,%f,%f,%f,%f,%f,100.0\r\n",PlayerInfo[playerid][pObjetoID], X,Y,Z,rX,rY,rZ);
    			fwrite(hFile, string2);
			}
			fclose(hFile);
			CancelEdit(playerid);
		}
    }
    return 1;
}
