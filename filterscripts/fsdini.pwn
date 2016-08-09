// test gwrp
// IMPORTANTE NESTOR: Adaptar el script segun el gamemode usado con DINI
// Se debe crear "BanTemporal" en el registro dini
// IMPORTANTE NESTOR: Poner la ruta como lo tengas tu
// ban temporal en gettime() y dini: Zeus


#include <a_samp>
#include <dini>
#include <zcmd>

public OnPlayerConnect(playerid)
{
	new file[64];
	format(file, sizeof(file), "/users/%s.ini", NombreJ(playerid));
	new enbaneo = dini_Int(file,"BanTemporal");
    if(enbaneo && dini_Exists(file))
	{
 		if(enbaneo == 1)
 		{ 
   			Kick(playerid);
        }
		else
		{
  			if(enbaneo < gettime())
  			{
  			    dini_IntSet(file,"BanTemporal",0);
            }
			else Kick(playerid);
        }
    }
	return 1;
}

CMD:bantemporal(playerid, params[]) { //comando ban temporal
    new id, horas, razon[120], jcuenta[70];
    if(sscanf(params, "ids", id, horas, razon)) return SendClientMessage(playerid, -1, "Comando: /bantemp <playerid> <horas> <razón>");
    if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, -1, "La ID introducida no existe..");
    if(0 < horas < 3000)
	{
	    new string[100];
	    format(string, sizeof(string), "La razón es: %s", razon);
	    SendClientMessage(playerid, -1, string);
	    format(jcuenta, sizeof(jcuenta), "/users/%s.ini", NombreJ(id)); // cambiar ruta
	    dini_IntSet(jcuenta, "BanTemporal", (gettime() + (horas * 60 * 60)));
   		Kick(id);
	}
/*	else
	{
 		SendClientMessage(playerid, -1, "Solo puedes escoger hasta 3000 horas para banear.");
   	} */
    return 1;
}

NombreJ(playerid) // obtención del nombre
{
	new nombrejugador[MAX_PLAYER_NAME+1];
    GetPlayerName(playerid,nombrejugador,sizeof(nombrejugador));
    return nombrejugador;
}

//funcion adicional
sscanf(string[], format[], {Float,_}:...) //sscanf
{
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs();
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if (ch >= '0' && ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return 1;
 				}
				}
				while ((ch = string[stringPos]) && ch != ' ');
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					ch,
					num = 0;
				while ((ch = string[stringPos++]))
				{
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						case ' ':
						{
							break;
						}
						default:
						{
							return 1;
						}
					}
				}
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				new tmp[25];
				strmid(tmp, string, stringPos, stringPos+sizeof(tmp)-2);
				setarg(paramPos, 0, _:floatstr(tmp));
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != ' ')
					{
						setarg(paramPos, i++, ch);
					}
					if (!i) return 1;
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != ' ')
		{
			stringPos++;
		}
		while (string[stringPos] == ' ')
		{
			stringPos++;
		}
		paramPos++;
	}
	while (format[formatPos] == 'z') formatPos++;
	return format[formatPos];
}

