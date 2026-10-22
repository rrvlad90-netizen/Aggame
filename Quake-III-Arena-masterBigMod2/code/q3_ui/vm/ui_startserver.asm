data
align 4
LABELV gametype_items
address $68
address $69
address $70
address $71
address $72
address $73
address $74
address $75
address $76
address $77
byte 4 0
align 4
LABELV gametype_remap
byte 4 0
byte 4 3
byte 4 3
byte 4 3
byte 4 3
byte 4 3
byte 4 3
byte 4 4
byte 4 1
byte 4 4
align 4
LABELV gametype_remap2
byte 4 0
byte 4 8
byte 4 0
byte 4 1
byte 4 9
code
proc GametypeBits 36 8
file "../ui_startserver.c"
line 142
;1:/*
;2:===========================================================================
;3:Copyright (C) 1999-2005 Id Software, Inc.
;4:
;5:This file is part of Quake III Arena source code.
;6:
;7:Quake III Arena source code is free software; you can redistribute it
;8:and/or modify it under the terms of the GNU General Public License as
;9:published by the Free Software Foundation; either version 2 of the License,
;10:or (at your option) any later version.
;11:
;12:Quake III Arena source code is distributed in the hope that it will be
;13:useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
;14:MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;15:GNU General Public License for more details.
;16:
;17:You should have received a copy of the GNU General Public License
;18:along with Foobar; if not, write to the Free Software
;19:Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;20:===========================================================================
;21:*/
;22://
;23:/*
;24:=============================================================================
;25:
;26:START SERVER MENU *****
;27:
;28:=============================================================================
;29:*/
;30:
;31:
;32:#include "ui_local.h"
;33:
;34:
;35:#define GAMESERVER_BACK0		"menu/art/back_0"
;36:#define GAMESERVER_BACK1		"menu/art/back_1"
;37:#define GAMESERVER_NEXT0		"menu/art/next_0"
;38:#define GAMESERVER_NEXT1		"menu/art/next_1"
;39:#define GAMESERVER_FRAMEL		"menu/art/frame2_l"
;40:#define GAMESERVER_FRAMER		"menu/art/frame1_r"
;41:#define GAMESERVER_SELECT		"menu/art/maps_select"
;42:#define GAMESERVER_SELECTED		"menu/art/maps_selected"
;43:#define GAMESERVER_FIGHT0		"menu/art/fight_0"
;44:#define GAMESERVER_FIGHT1		"menu/art/fight_1"
;45:#define GAMESERVER_UNKNOWNMAP	"menu/art/unknownmap"
;46:#define GAMESERVER_ARROWS		"menu/art/gs_arrows_0"
;47:#define GAMESERVER_ARROWSL		"menu/art/gs_arrows_l"
;48:#define GAMESERVER_ARROWSR		"menu/art/gs_arrows_r"
;49:
;50:#define MAX_MAPROWS		2
;51:#define MAX_MAPCOLS		2
;52:#define MAX_MAPSPERPAGE	4
;53:
;54:#define	MAX_SERVERSTEXT	8192
;55:
;56:#define MAX_SERVERMAPS	64
;57:#define MAX_NAMELENGTH	16
;58:
;59:#define ID_GAMETYPE				10
;60:#define ID_PICTURES				11	// 12, 13, 14
;61:#define ID_PREVPAGE				15
;62:#define ID_NEXTPAGE				16
;63:#define ID_STARTSERVERBACK		17
;64:#define ID_STARTSERVERNEXT		18
;65:
;66:typedef struct {
;67:	menuframework_s	menu;
;68:
;69:	menutext_s		banner;
;70:	menubitmap_s	framel;
;71:	menubitmap_s	framer;
;72:
;73:	menulist_s		gametype;
;74:	menubitmap_s	mappics[MAX_MAPSPERPAGE];
;75:	menubitmap_s	mapbuttons[MAX_MAPSPERPAGE];
;76:	menubitmap_s	arrows;
;77:	menubitmap_s	prevpage;
;78:	menubitmap_s	nextpage;
;79:	menubitmap_s	back;
;80:	menubitmap_s	next;
;81:
;82:	menutext_s		mapname;
;83:	menubitmap_s	item_null;
;84:
;85:	qboolean		multiplayer;
;86:	int				currentmap;
;87:	int				nummaps;
;88:	int				page;
;89:	int				maxpages;
;90:	char			maplist[MAX_SERVERMAPS][MAX_NAMELENGTH];
;91:	int				mapGamebits[MAX_SERVERMAPS];
;92:} startserver_t;
;93:
;94:static startserver_t s_startserver;
;95:
;96:static const char *gametype_items[] = {
;97:	"Free For All",
;98:	"Team Deathmatch",
;99:	"TDM on CTF Maps",
;100:	"Base TDM",
;101:	"TDM One Life",
;102:	"One Life on CTF",
;103:	"Base Assault",
;104:	"CTF on TDM Maps",
;105:	"Tournament",
;106:	"Capture the Flag",
;107:	0
;108:};
;109:
;110:static int gametype_remap[] = {
;111:	GT_FFA,
;112:	GT_TEAM,
;113:	GT_TEAM,
;114:	GT_TEAM,
;115:	GT_TEAM,
;116:	GT_TEAM,
;117:	GT_TEAM,
;118:	GT_CTF,
;119:	GT_TOURNAMENT,
;120:	GT_CTF
;121:};
;122:
;123:static int gametype_remap2[] = {
;124:	0,
;125:	8,
;126:	0,
;127:	1,
;128:	9
;129:};
;130:
;131:// use ui_servers2.c definition
;132:extern const char* punkbuster_items[];
;133:
;134:static void UI_ServerOptionsMenu( qboolean multiplayer );
;135:
;136:
;137:/*
;138:=================
;139:GametypeBits
;140:=================
;141:*/
;142:static int GametypeBits( char *string ) {
line 147
;143:	int		bits;
;144:	char	*p;
;145:	char	*token;
;146:
;147:	bits = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 148
;148:	p = string;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $80
JUMPV
LABELV $79
line 149
;149:	while( 1 ) {
line 150
;150:		token = COM_ParseExt( &p, qfalse );
ADDRLP4 8
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 12
ADDRGP4 COM_ParseExt
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
line 151
;151:		if( token[0] == 0 ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $82
line 152
;152:			break;
ADDRGP4 $81
JUMPV
LABELV $82
line 155
;153:		}
;154:
;155:		if( Q_stricmp( token, "ffa" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $86
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $84
line 156
;156:			bits |= 1 << GT_FFA;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 157
;157:			continue;
ADDRGP4 $80
JUMPV
LABELV $84
line 160
;158:		}
;159:
;160:		if( Q_stricmp( token, "tourney" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $89
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $87
line 161
;161:			bits |= 1 << GT_TOURNAMENT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
line 162
;162:			continue;
ADDRGP4 $80
JUMPV
LABELV $87
line 165
;163:		}
;164:
;165:		if( Q_stricmp( token, "single" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $92
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $90
line 166
;166:			bits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 167
;167:			continue;
ADDRGP4 $80
JUMPV
LABELV $90
line 170
;168:		}
;169:
;170:		if( Q_stricmp( token, "team" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $95
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $93
line 171
;171:			bits |= 1 << GT_TEAM;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
line 172
;172:			continue;
ADDRGP4 $80
JUMPV
LABELV $93
line 175
;173:		}
;174:
;175:		if( Q_stricmp( token, "ctf" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $98
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $96
line 176
;176:			bits |= 1 << GT_CTF;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 177
;177:			continue;
LABELV $96
line 179
;178:		}
;179:	}
LABELV $80
line 149
ADDRGP4 $79
JUMPV
LABELV $81
line 181
;180:
;181:	return bits;
ADDRLP4 4
INDIRI4
RETI4
LABELV $78
endproc GametypeBits 36 8
bss
align 1
LABELV $100
skip 256
code
proc StartServer_Update 28 16
line 190
;182:}
;183:
;184:
;185:/*
;186:=================
;187:StartServer_Update
;188:=================
;189:*/
;190:static void StartServer_Update( void ) {
line 195
;191:	int				i;
;192:	int				top;
;193:	static	char	picname[MAX_MAPSPERPAGE][64];
;194:
;195:	top = s_startserver.page*MAX_MAPSPERPAGE;
ADDRLP4 4
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
line 197
;196:
;197:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $102
line 198
;198:	{
line 199
;199:		if (top+i >= s_startserver.nummaps)
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
ADDI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $106
line 200
;200:			break;
ADDRGP4 $124
JUMPV
LABELV $106
line 202
;201:
;202:		Com_sprintf( picname[i], sizeof(picname[i]), "levelshots/%s", s_startserver.maplist[top+i] );
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 $100
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $109
ARGP4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
ADDI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 204
;203:
;204:		s_startserver.mappics[i].generic.flags &= ~QMF_HIGHLIGHT;
ADDRLP4 12
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRU4
CNSTU4 4294967231
BANDU4
ASGNU4
line 205
;205:		s_startserver.mappics[i].generic.name   = picname[i];
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+4
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 $100
ADDP4
ASGNP4
line 206
;206:		s_startserver.mappics[i].shader         = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+68
ADDP4
CNSTI4 0
ASGNI4
line 209
;207:
;208:		// reset
;209:		s_startserver.mapbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
ADDRLP4 20
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRU4
CNSTU4 256
BORU4
ASGNU4
line 210
;210:		s_startserver.mapbuttons[i].generic.flags &= ~QMF_INACTIVE;
ADDRLP4 24
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRU4
CNSTU4 4294950911
BANDU4
ASGNU4
line 211
;211:	}
LABELV $103
line 197
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $102
line 213
;212:
;213:	for (; i<MAX_MAPSPERPAGE; i++)
ADDRGP4 $124
JUMPV
LABELV $121
line 214
;214:	{
line 215
;215:		s_startserver.mappics[i].generic.flags &= ~QMF_HIGHLIGHT;
ADDRLP4 8
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294967231
BANDU4
ASGNU4
line 216
;216:		s_startserver.mappics[i].generic.name   = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+4
ADDP4
CNSTP4 0
ASGNP4
line 217
;217:		s_startserver.mappics[i].shader         = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+68
ADDP4
CNSTI4 0
ASGNI4
line 220
;218:
;219:		// disable
;220:		s_startserver.mapbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
ADDRLP4 12
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRU4
CNSTU4 4294967039
BANDU4
ASGNU4
line 221
;221:		s_startserver.mapbuttons[i].generic.flags |= QMF_INACTIVE;
ADDRLP4 16
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 222
;222:	}
LABELV $122
line 213
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $124
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $121
line 226
;223:
;224:
;225:	// no servers to start
;226:	if( !s_startserver.nummaps ) {
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 0
NEI4 $135
line 227
;227:		s_startserver.next.generic.flags |= QMF_INACTIVE;
ADDRLP4 8
ADDRGP4 s_startserver+1688+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 230
;228:
;229:		// set the map name
;230:		strcpy( s_startserver.mapname.string, "NO MAPS FOUND" );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 $142
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 231
;231:	}
ADDRGP4 $136
JUMPV
LABELV $135
line 232
;232:	else {
line 234
;233:		// set the highlight
;234:		s_startserver.next.generic.flags &= ~QMF_INACTIVE;
ADDRLP4 8
ADDRGP4 s_startserver+1688+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294950911
BANDU4
ASGNU4
line 235
;235:		i = s_startserver.currentmap - top;
ADDRLP4 0
ADDRGP4 s_startserver+1940
INDIRI4
ADDRLP4 4
INDIRI4
SUBI4
ASGNI4
line 236
;236:		if ( i >=0 && i < MAX_MAPSPERPAGE ) 
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $146
ADDRLP4 0
INDIRI4
CNSTI4 4
GEI4 $146
line 237
;237:		{
line 238
;238:			s_startserver.mappics[i].generic.flags    |= QMF_HIGHLIGHT;
ADDRLP4 16
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRU4
CNSTU4 64
BORU4
ASGNU4
line 239
;239:			s_startserver.mapbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
ADDRLP4 20
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRU4
CNSTU4 4294967039
BANDU4
ASGNU4
line 240
;240:		}
LABELV $146
line 243
;241:
;242:		// set the map name
;243:		strcpy( s_startserver.mapname.string, s_startserver.maplist[s_startserver.currentmap] );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 s_startserver+1940
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 244
;244:	}
LABELV $136
line 246
;245:	
;246:	Q_strupr( s_startserver.mapname.string );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 247
;247:}
LABELV $99
endproc StartServer_Update 28 16
proc StartServer_MapEvent 0 0
line 255
;248:
;249:
;250:/*
;251:=================
;252:StartServer_MapEvent
;253:=================
;254:*/
;255:static void StartServer_MapEvent( void* ptr, int event ) {
line 256
;256:	if( event != QM_ACTIVATED) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $159
line 257
;257:		return;
ADDRGP4 $158
JUMPV
LABELV $159
line 260
;258:	}
;259:
;260:	s_startserver.currentmap = (s_startserver.page*MAX_MAPSPERPAGE) + (((menucommon_s*)ptr)->id - ID_PICTURES);
ADDRGP4 s_startserver+1940
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 11
SUBI4
ADDI4
ASGNI4
line 261
;261:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 262
;262:}
LABELV $158
endproc StartServer_MapEvent 0 0
proc StartServer_GametypeEvent 44 12
line 270
;263:
;264:
;265:/*
;266:=================
;267:StartServer_GametypeEvent
;268:=================
;269:*/
;270:static void StartServer_GametypeEvent( void* ptr, int event ) {
line 277
;271:	int			i;
;272:	int			count;
;273:	int			gamebits;
;274:	int			matchbits;
;275:	const char	*info;
;276:
;277:	if( event != QM_ACTIVATED) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $164
line 278
;278:		return;
ADDRGP4 $163
JUMPV
LABELV $164
line 281
;279:	}
;280:
;281:	count = UI_GetNumArenas();
ADDRLP4 20
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
line 282
;282:	s_startserver.nummaps = 0;
ADDRGP4 s_startserver+1944
CNSTI4 0
ASGNI4
line 283
;283:	if( s_startserver.gametype.curvalue == 7 ) {
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 7
NEI4 $167
line 288
;284:		/*
;285:		 * CTF on TDM Maps launches GT_CTF,
;286:		 * but displays ordinary team maps.
;287:		 */
;288:		matchbits = 1 << GT_TEAM;
ADDRLP4 12
CNSTI4 8
ASGNI4
line 289
;289:	}
ADDRGP4 $168
JUMPV
LABELV $167
line 290
;290:	else if( s_startserver.gametype.curvalue == 2 ||
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
EQI4 $180
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
EQI4 $180
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 6
NEI4 $171
LABELV $180
line 292
;291:		s_startserver.gametype.curvalue == 5 ||
;292:		s_startserver.gametype.curvalue == 6 ) {
line 296
;293:		/*
;294:		 * These modes use CTF maps but launch GT_TEAM.
;295:		 */
;296:		matchbits = 1 << GT_CTF;
ADDRLP4 12
CNSTI4 16
ASGNI4
line 297
;297:	}
ADDRGP4 $172
JUMPV
LABELV $171
line 298
;298:	else {
line 299
;299:		matchbits =
ADDRLP4 12
CNSTI4 1
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
LSHI4
ASGNI4
line 304
;300:			1 << gametype_remap[
;301:				s_startserver.gametype.curvalue
;302:			];
;303:
;304:		if( gametype_remap[
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
CNSTI4 0
NEI4 $183
line 306
;305:			s_startserver.gametype.curvalue
;306:		] == GT_FFA ) {
line 307
;307:			matchbits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 308
;308:		}
LABELV $183
line 309
;309:	}
LABELV $172
LABELV $168
line 310
;310:	for( i = 0; i < count; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $190
JUMPV
LABELV $187
line 311
;311:		info = UI_GetArenaInfoByNumber( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 UI_GetArenaInfoByNumber
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 24
INDIRP4
ASGNP4
line 313
;312:
;313:		gamebits = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $191
ARGP4
ADDRLP4 28
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 GametypeBits
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 32
INDIRI4
ASGNI4
line 314
;314:		if( !( gamebits & matchbits ) ) {
ADDRLP4 4
INDIRI4
ADDRLP4 12
INDIRI4
BANDI4
CNSTI4 0
NEI4 $192
line 315
;315:			continue;
ADDRGP4 $188
JUMPV
LABELV $192
line 318
;316:		}
;317:
;318:		Q_strncpyz( s_startserver.maplist[s_startserver.nummaps], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $196
ARGP4
ADDRLP4 36
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRLP4 36
INDIRP4
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 319
;319:		Q_strupr( s_startserver.maplist[s_startserver.nummaps] );
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 320
;320:		s_startserver.mapGamebits[s_startserver.nummaps] = gamebits;
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_startserver+2980
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 321
;321:		s_startserver.nummaps++;
ADDRLP4 40
ADDRGP4 s_startserver+1944
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 322
;322:	}
LABELV $188
line 310
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $190
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $187
line 323
;323:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
ADDRLP4 24
CNSTI4 4
ASGNI4
ADDRGP4 s_startserver+1952
ADDRGP4 s_startserver+1944
INDIRI4
ADDRLP4 24
INDIRI4
ADDI4
CNSTI4 1
SUBI4
ADDRLP4 24
INDIRI4
DIVI4
ASGNI4
line 324
;324:	s_startserver.page = 0;
ADDRGP4 s_startserver+1948
CNSTI4 0
ASGNI4
line 325
;325:	s_startserver.currentmap = 0;
ADDRGP4 s_startserver+1940
CNSTI4 0
ASGNI4
line 327
;326:
;327:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 328
;328:}
LABELV $163
endproc StartServer_GametypeEvent 44 12
proc StartServer_MenuEvent 24 8
line 336
;329:
;330:
;331:/*
;332:=================
;333:StartServer_MenuEvent
;334:=================
;335:*/
;336:static void StartServer_MenuEvent( void* ptr, int event ) {
line 337
;337:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $207
line 338
;338:		return;
ADDRGP4 $206
JUMPV
LABELV $207
line 341
;339:	}
;340:
;341:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 15
LTI4 $209
ADDRLP4 0
INDIRI4
CNSTI4 18
GTI4 $209
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $256-60
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $256
address $212
address $217
address $255
address $223
code
LABELV $212
line 343
;342:	case ID_PREVPAGE:
;343:		if( s_startserver.page > 0 ) {
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 0
LEI4 $210
line 344
;344:			s_startserver.page--;
ADDRLP4 8
ADDRGP4 s_startserver+1948
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 345
;345:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 346
;346:		}
line 347
;347:		break;
ADDRGP4 $210
JUMPV
LABELV $217
line 350
;348:
;349:	case ID_NEXTPAGE:
;350:		if( s_startserver.page < s_startserver.maxpages - 1 ) {
ADDRGP4 s_startserver+1948
INDIRI4
ADDRGP4 s_startserver+1952
INDIRI4
CNSTI4 1
SUBI4
GEI4 $210
line 351
;351:			s_startserver.page++;
ADDRLP4 8
ADDRGP4 s_startserver+1948
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 352
;352:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 353
;353:		}
line 354
;354:		break;
ADDRGP4 $210
JUMPV
LABELV $223
line 357
;355:
;356:	case ID_STARTSERVERNEXT:
;357:		trap_Cvar_SetValue(
ADDRGP4 $224
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 364
;358:			"g_gameType",
;359:			gametype_remap[
;360:				s_startserver.gametype.curvalue
;361:			]
;362:		);
;363:
;364:		trap_Cvar_SetValue(
ADDRGP4 $227
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 3
NEI4 $231
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $232
JUMPV
LABELV $231
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $232
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 369
;365:			"g_baseTDM",
;366:			s_startserver.gametype.curvalue == 3
;367:		);
;368:
;369:		trap_Cvar_SetValue(
ADDRGP4 $233
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 4
EQI4 $241
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
NEI4 $239
LABELV $241
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRGP4 $240
JUMPV
LABELV $239
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $240
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 375
;370:			"g_oneLifeTDM",
;371:			s_startserver.gametype.curvalue == 4 ||
;372:			s_startserver.gametype.curvalue == 5
;373:		);
;374:
;375:		trap_Cvar_SetValue(
ADDRGP4 $242
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 6
NEI4 $246
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $247
JUMPV
LABELV $246
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $247
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 380
;376:			"g_assaultMode",
;377:			s_startserver.gametype.curvalue == 6
;378:		);
;379:		
;380:		trap_Cvar_SetValue(
ADDRGP4 $248
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 7
NEI4 $252
ADDRLP4 20
CNSTI4 1
ASGNI4
ADDRGP4 $253
JUMPV
LABELV $252
ADDRLP4 20
CNSTI4 0
ASGNI4
LABELV $253
ADDRLP4 20
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 385
;381:			"g_autoCTF",
;382:			s_startserver.gametype.curvalue == 7
;383:		);
;384:
;385:		UI_ServerOptionsMenu(
ADDRGP4 s_startserver+1936
INDIRI4
ARGI4
ADDRGP4 UI_ServerOptionsMenu
CALLV
pop
line 388
;386:			s_startserver.multiplayer
;387:		);
;388:		break;
ADDRGP4 $210
JUMPV
LABELV $255
line 391
;389:
;390:	case ID_STARTSERVERBACK:
;391:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 392
;392:		break;
LABELV $209
LABELV $210
line 394
;393:	}
;394:}
LABELV $206
endproc StartServer_MenuEvent 24 8
proc StartServer_LevelshotDraw 48 20
line 402
;395:
;396:
;397:/*
;398:===============
;399:StartServer_LevelshotDraw
;400:===============
;401:*/
;402:static void StartServer_LevelshotDraw( void *self ) {
line 410
;403:	menubitmap_s	*b;
;404:	int				x;
;405:	int				y;
;406:	int				w;
;407:	int				h;
;408:	int				n;
;409:
;410:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 412
;411:
;412:	if( !b->generic.name ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $259
line 413
;413:		return;
ADDRGP4 $258
JUMPV
LABELV $259
line 416
;414:	}
;415:
;416:	if( b->generic.name && !b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $261
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $261
line 417
;417:		b->shader = trap_R_RegisterShaderNoMip( b->generic.name );
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRLP4 32
INDIRI4
ASGNI4
line 418
;418:		if( !b->shader && b->errorpic ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $263
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $263
line 419
;419:			b->shader = trap_R_RegisterShaderNoMip( b->errorpic );
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRP4
ARGP4
ADDRLP4 44
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
ADDRLP4 44
INDIRI4
ASGNI4
line 420
;420:		}
LABELV $263
line 421
;421:	}
LABELV $261
line 423
;422:
;423:	if( b->focuspic && !b->focusshader ) {
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $265
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
NEI4 $265
line 424
;424:		b->focusshader = trap_R_RegisterShaderNoMip( b->focuspic );
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDRLP4 36
INDIRI4
ASGNI4
line 425
;425:	}
LABELV $265
line 427
;426:
;427:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 428
;428:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 429
;429:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 430
;430:	h =	b->height;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 431
;431:	if( b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $267
line 432
;432:		UI_DrawHandlePic( x, y, w, h, b->shader );
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
ARGI4
ADDRGP4 UI_DrawHandlePic
CALLV
pop
line 433
;433:	}
LABELV $267
line 435
;434:
;435:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 436
;436:	y = b->generic.y + b->height;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ADDI4
ASGNI4
line 437
;437:	UI_FillRect( x, y, b->width, 28, colorBlack );
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1105199104
ARGF4
ADDRGP4 colorBlack
ARGP4
ADDRGP4 UI_FillRect
CALLV
pop
line 439
;438:
;439:	x += b->width / 2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
CNSTI4 2
DIVI4
ADDI4
ASGNI4
line 440
;440:	y += 4;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 441
;441:	n = s_startserver.page * MAX_MAPSPERPAGE + b->generic.id - ID_PICTURES;
ADDRLP4 20
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ADDI4
CNSTI4 11
SUBI4
ASGNI4
line 442
;442:	UI_DrawString( x, y, s_startserver.maplist[n], UI_CENTER|UI_SMALLFONT, color_orange );
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 20
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 444
;443:
;444:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 445
;445:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 446
;446:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 447
;447:	h =	b->height + 28;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
line 448
;448:	if( b->generic.flags & QMF_HIGHLIGHT ) {	
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 64
BANDU4
CNSTU4 0
EQU4 $271
line 449
;449:		UI_DrawHandlePic( x, y, w, h, b->focusshader );
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
ARGI4
ADDRGP4 UI_DrawHandlePic
CALLV
pop
line 450
;450:	}
LABELV $271
line 451
;451:}
LABELV $258
endproc StartServer_LevelshotDraw 48 20
bss
align 1
LABELV $274
skip 64
code
proc StartServer_MenuInit 20 12
line 459
;452:
;453:
;454:/*
;455:=================
;456:StartServer_MenuInit
;457:=================
;458:*/
;459:static void StartServer_MenuInit( void ) {
line 466
;460:	int	i;
;461:	int	x;
;462:	int	y;
;463:	static char mapnamebuffer[64];
;464:
;465:	// zero set all our globals
;466:	memset( &s_startserver, 0 ,sizeof(startserver_t) );
ADDRGP4 s_startserver
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3236
ARGI4
ADDRGP4 memset
CALLP4
pop
line 468
;467:
;468:	StartServer_Cache();
ADDRGP4 StartServer_Cache
CALLV
pop
line 470
;469:
;470:	s_startserver.menu.wrapAround = qtrue;
ADDRGP4 s_startserver+276
CNSTI4 1
ASGNI4
line 471
;471:	s_startserver.menu.fullscreen = qtrue;
ADDRGP4 s_startserver+280
CNSTI4 1
ASGNI4
line 473
;472:
;473:	s_startserver.banner.generic.type  = MTYPE_BTEXT;
ADDRGP4 s_startserver+288
CNSTI4 10
ASGNI4
line 474
;474:	s_startserver.banner.generic.x	   = 320;
ADDRGP4 s_startserver+288+12
CNSTI4 320
ASGNI4
line 475
;475:	s_startserver.banner.generic.y	   = 16;
ADDRGP4 s_startserver+288+16
CNSTI4 16
ASGNI4
line 476
;476:	s_startserver.banner.string        = "GAME SERVER";
ADDRGP4 s_startserver+288+60
ADDRGP4 $284
ASGNP4
line 477
;477:	s_startserver.banner.color         = color_white;
ADDRGP4 s_startserver+288+68
ADDRGP4 color_white
ASGNP4
line 478
;478:	s_startserver.banner.style         = UI_CENTER;
ADDRGP4 s_startserver+288+64
CNSTI4 1
ASGNI4
line 480
;479:
;480:	s_startserver.framel.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+360
CNSTI4 6
ASGNI4
line 481
;481:	s_startserver.framel.generic.name  = GAMESERVER_FRAMEL;
ADDRGP4 s_startserver+360+4
ADDRGP4 $292
ASGNP4
line 482
;482:	s_startserver.framel.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+360+44
CNSTU4 16384
ASGNU4
line 483
;483:	s_startserver.framel.generic.x	   = 0;  
ADDRGP4 s_startserver+360+12
CNSTI4 0
ASGNI4
line 484
;484:	s_startserver.framel.generic.y	   = 78;
ADDRGP4 s_startserver+360+16
CNSTI4 78
ASGNI4
line 485
;485:	s_startserver.framel.width  	   = 256;
ADDRGP4 s_startserver+360+76
CNSTI4 256
ASGNI4
line 486
;486:	s_startserver.framel.height  	   = 329;
ADDRGP4 s_startserver+360+80
CNSTI4 329
ASGNI4
line 488
;487:
;488:	s_startserver.framer.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+448
CNSTI4 6
ASGNI4
line 489
;489:	s_startserver.framer.generic.name  = GAMESERVER_FRAMER;
ADDRGP4 s_startserver+448+4
ADDRGP4 $306
ASGNP4
line 490
;490:	s_startserver.framer.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+448+44
CNSTU4 16384
ASGNU4
line 491
;491:	s_startserver.framer.generic.x	   = 376;
ADDRGP4 s_startserver+448+12
CNSTI4 376
ASGNI4
line 492
;492:	s_startserver.framer.generic.y	   = 76;
ADDRGP4 s_startserver+448+16
CNSTI4 76
ASGNI4
line 493
;493:	s_startserver.framer.width  	   = 256;
ADDRGP4 s_startserver+448+76
CNSTI4 256
ASGNI4
line 494
;494:	s_startserver.framer.height  	   = 334;
ADDRGP4 s_startserver+448+80
CNSTI4 334
ASGNI4
line 496
;495:
;496:	s_startserver.gametype.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_startserver+536
CNSTI4 3
ASGNI4
line 497
;497:	s_startserver.gametype.generic.name		= "Game Type:";
ADDRGP4 s_startserver+536+4
ADDRGP4 $320
ASGNP4
line 498
;498:	s_startserver.gametype.generic.flags	= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_startserver+536+44
CNSTU4 258
ASGNU4
line 499
;499:	s_startserver.gametype.generic.callback	= StartServer_GametypeEvent;
ADDRGP4 s_startserver+536+48
ADDRGP4 StartServer_GametypeEvent
ASGNP4
line 500
;500:	s_startserver.gametype.generic.id		= ID_GAMETYPE;
ADDRGP4 s_startserver+536+8
CNSTI4 10
ASGNI4
line 501
;501:	s_startserver.gametype.generic.x		= 320 - 24;
ADDRGP4 s_startserver+536+12
CNSTI4 296
ASGNI4
line 502
;502:	s_startserver.gametype.generic.y		= 368;
ADDRGP4 s_startserver+536+16
CNSTI4 368
ASGNI4
line 503
;503:	s_startserver.gametype.itemnames		= gametype_items;
ADDRGP4 s_startserver+536+76
ADDRGP4 gametype_items
ASGNP4
line 505
;504:
;505:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $333
line 506
;506:	{
line 507
;507:		x =	(i % MAX_MAPCOLS) * (128+8) + 188;
ADDRLP4 4
CNSTI4 136
ADDRLP4 0
INDIRI4
CNSTI4 2
MODI4
MULI4
CNSTI4 188
ADDI4
ASGNI4
line 508
;508:		y = (i / MAX_MAPROWS) * (128+8) + 96;
ADDRLP4 8
CNSTI4 136
ADDRLP4 0
INDIRI4
CNSTI4 2
DIVI4
MULI4
CNSTI4 96
ADDI4
ASGNI4
line 510
;509:
;510:		s_startserver.mappics[i].generic.type   = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632
ADDP4
CNSTI4 6
ASGNI4
line 511
;511:		s_startserver.mappics[i].generic.flags  = QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
CNSTU4 16388
ASGNU4
line 512
;512:		s_startserver.mappics[i].generic.x	    = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 513
;513:		s_startserver.mappics[i].generic.y	    = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 514
;514:		s_startserver.mappics[i].generic.id		= ID_PICTURES+i;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+8
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 11
ADDI4
ASGNI4
line 515
;515:		s_startserver.mappics[i].width  		= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+76
ADDP4
CNSTI4 128
ASGNI4
line 516
;516:		s_startserver.mappics[i].height  	    = 96;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+80
ADDP4
CNSTI4 96
ASGNI4
line 517
;517:		s_startserver.mappics[i].focuspic       = GAMESERVER_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+60
ADDP4
ADDRGP4 $352
ASGNP4
line 518
;518:		s_startserver.mappics[i].errorpic       = GAMESERVER_UNKNOWNMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+64
ADDP4
ADDRGP4 $355
ASGNP4
line 519
;519:		s_startserver.mappics[i].generic.ownerdraw = StartServer_LevelshotDraw;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+56
ADDP4
ADDRGP4 StartServer_LevelshotDraw
ASGNP4
line 521
;520:
;521:		s_startserver.mapbuttons[i].generic.type     = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984
ADDP4
CNSTI4 6
ASGNI4
line 522
;522:		s_startserver.mapbuttons[i].generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_NODEFAULTINIT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
CNSTU4 33028
ASGNU4
line 523
;523:		s_startserver.mapbuttons[i].generic.id       = ID_PICTURES+i;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+8
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 11
ADDI4
ASGNI4
line 524
;524:		s_startserver.mapbuttons[i].generic.callback = StartServer_MapEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+48
ADDP4
ADDRGP4 StartServer_MapEvent
ASGNP4
line 525
;525:		s_startserver.mapbuttons[i].generic.x	     = x - 30;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+12
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 30
SUBI4
ASGNI4
line 526
;526:		s_startserver.mapbuttons[i].generic.y	     = y - 32;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+16
ADDP4
ADDRLP4 8
INDIRI4
CNSTI4 32
SUBI4
ASGNI4
line 527
;527:		s_startserver.mapbuttons[i].width  		     = 256;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+76
ADDP4
CNSTI4 256
ASGNI4
line 528
;528:		s_startserver.mapbuttons[i].height  	     = 248;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+80
ADDP4
CNSTI4 248
ASGNI4
line 529
;529:		s_startserver.mapbuttons[i].generic.left     = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 530
;530:		s_startserver.mapbuttons[i].generic.top  	 = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 531
;531:		s_startserver.mapbuttons[i].generic.right    = x + 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+28
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 128
ADDI4
ASGNI4
line 532
;532:		s_startserver.mapbuttons[i].generic.bottom   = y + 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+32
ADDP4
ADDRLP4 8
INDIRI4
CNSTI4 128
ADDI4
ASGNI4
line 533
;533:		s_startserver.mapbuttons[i].focuspic         = GAMESERVER_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+60
ADDP4
ADDRGP4 $383
ASGNP4
line 534
;534:	}
LABELV $334
line 505
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $333
line 536
;535:
;536:	s_startserver.arrows.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+1336
CNSTI4 6
ASGNI4
line 537
;537:	s_startserver.arrows.generic.name  = GAMESERVER_ARROWS;
ADDRGP4 s_startserver+1336+4
ADDRGP4 $387
ASGNP4
line 538
;538:	s_startserver.arrows.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+1336+44
CNSTU4 16384
ASGNU4
line 539
;539:	s_startserver.arrows.generic.x	   = 260;
ADDRGP4 s_startserver+1336+12
CNSTI4 260
ASGNI4
line 540
;540:	s_startserver.arrows.generic.y	   = 400;
ADDRGP4 s_startserver+1336+16
CNSTI4 400
ASGNI4
line 541
;541:	s_startserver.arrows.width  	   = 128;
ADDRGP4 s_startserver+1336+76
CNSTI4 128
ASGNI4
line 542
;542:	s_startserver.arrows.height  	   = 32;
ADDRGP4 s_startserver+1336+80
CNSTI4 32
ASGNI4
line 544
;543:
;544:	s_startserver.prevpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1424
CNSTI4 6
ASGNI4
line 545
;545:	s_startserver.prevpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1424+44
CNSTU4 260
ASGNU4
line 546
;546:	s_startserver.prevpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1424+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 547
;547:	s_startserver.prevpage.generic.id	    = ID_PREVPAGE;
ADDRGP4 s_startserver+1424+8
CNSTI4 15
ASGNI4
line 548
;548:	s_startserver.prevpage.generic.x		= 260;
ADDRGP4 s_startserver+1424+12
CNSTI4 260
ASGNI4
line 549
;549:	s_startserver.prevpage.generic.y		= 400;
ADDRGP4 s_startserver+1424+16
CNSTI4 400
ASGNI4
line 550
;550:	s_startserver.prevpage.width  		    = 64;
ADDRGP4 s_startserver+1424+76
CNSTI4 64
ASGNI4
line 551
;551:	s_startserver.prevpage.height  		    = 32;
ADDRGP4 s_startserver+1424+80
CNSTI4 32
ASGNI4
line 552
;552:	s_startserver.prevpage.focuspic         = GAMESERVER_ARROWSL;
ADDRGP4 s_startserver+1424+60
ADDRGP4 $415
ASGNP4
line 554
;553:
;554:	s_startserver.nextpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1512
CNSTI4 6
ASGNI4
line 555
;555:	s_startserver.nextpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1512+44
CNSTU4 260
ASGNU4
line 556
;556:	s_startserver.nextpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1512+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 557
;557:	s_startserver.nextpage.generic.id	    = ID_NEXTPAGE;
ADDRGP4 s_startserver+1512+8
CNSTI4 16
ASGNI4
line 558
;558:	s_startserver.nextpage.generic.x		= 321;
ADDRGP4 s_startserver+1512+12
CNSTI4 321
ASGNI4
line 559
;559:	s_startserver.nextpage.generic.y		= 400;
ADDRGP4 s_startserver+1512+16
CNSTI4 400
ASGNI4
line 560
;560:	s_startserver.nextpage.width  		    = 64;
ADDRGP4 s_startserver+1512+76
CNSTI4 64
ASGNI4
line 561
;561:	s_startserver.nextpage.height  		    = 32;
ADDRGP4 s_startserver+1512+80
CNSTI4 32
ASGNI4
line 562
;562:	s_startserver.nextpage.focuspic         = GAMESERVER_ARROWSR;
ADDRGP4 s_startserver+1512+60
ADDRGP4 $433
ASGNP4
line 564
;563:
;564:	s_startserver.mapname.generic.type  = MTYPE_PTEXT;
ADDRGP4 s_startserver+1776
CNSTI4 9
ASGNI4
line 565
;565:	s_startserver.mapname.generic.flags = QMF_CENTER_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_startserver+1776+44
CNSTU4 16392
ASGNU4
line 566
;566:	s_startserver.mapname.generic.x	    = 320;
ADDRGP4 s_startserver+1776+12
CNSTI4 320
ASGNI4
line 567
;567:	s_startserver.mapname.generic.y	    = 440;
ADDRGP4 s_startserver+1776+16
CNSTI4 440
ASGNI4
line 568
;568:	s_startserver.mapname.string        = mapnamebuffer;
ADDRGP4 s_startserver+1776+60
ADDRGP4 $274
ASGNP4
line 569
;569:	s_startserver.mapname.style         = UI_CENTER|UI_BIGFONT;
ADDRGP4 s_startserver+1776+64
CNSTI4 33
ASGNI4
line 570
;570:	s_startserver.mapname.color         = text_color_normal;
ADDRGP4 s_startserver+1776+68
ADDRGP4 text_color_normal
ASGNP4
line 572
;571:
;572:	s_startserver.back.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1600
CNSTI4 6
ASGNI4
line 573
;573:	s_startserver.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_startserver+1600+4
ADDRGP4 $450
ASGNP4
line 574
;574:	s_startserver.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1600+44
CNSTU4 260
ASGNU4
line 575
;575:	s_startserver.back.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1600+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 576
;576:	s_startserver.back.generic.id	    = ID_STARTSERVERBACK;
ADDRGP4 s_startserver+1600+8
CNSTI4 17
ASGNI4
line 577
;577:	s_startserver.back.generic.x		= 0;
ADDRGP4 s_startserver+1600+12
CNSTI4 0
ASGNI4
line 578
;578:	s_startserver.back.generic.y		= 480-64;
ADDRGP4 s_startserver+1600+16
CNSTI4 416
ASGNI4
line 579
;579:	s_startserver.back.width  		    = 128;
ADDRGP4 s_startserver+1600+76
CNSTI4 128
ASGNI4
line 580
;580:	s_startserver.back.height  		    = 64;
ADDRGP4 s_startserver+1600+80
CNSTI4 64
ASGNI4
line 581
;581:	s_startserver.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_startserver+1600+60
ADDRGP4 $467
ASGNP4
line 583
;582:
;583:	s_startserver.next.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1688
CNSTI4 6
ASGNI4
line 584
;584:	s_startserver.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_startserver+1688+4
ADDRGP4 $471
ASGNP4
line 585
;585:	s_startserver.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1688+44
CNSTU4 272
ASGNU4
line 586
;586:	s_startserver.next.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1688+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 587
;587:	s_startserver.next.generic.id	    = ID_STARTSERVERNEXT;
ADDRGP4 s_startserver+1688+8
CNSTI4 18
ASGNI4
line 588
;588:	s_startserver.next.generic.x		= 640;
ADDRGP4 s_startserver+1688+12
CNSTI4 640
ASGNI4
line 589
;589:	s_startserver.next.generic.y		= 480-64;
ADDRGP4 s_startserver+1688+16
CNSTI4 416
ASGNI4
line 590
;590:	s_startserver.next.width  		    = 128;
ADDRGP4 s_startserver+1688+76
CNSTI4 128
ASGNI4
line 591
;591:	s_startserver.next.height  		    = 64;
ADDRGP4 s_startserver+1688+80
CNSTI4 64
ASGNI4
line 592
;592:	s_startserver.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_startserver+1688+60
ADDRGP4 $488
ASGNP4
line 594
;593:
;594:	s_startserver.item_null.generic.type	= MTYPE_BITMAP;
ADDRGP4 s_startserver+1848
CNSTI4 6
ASGNI4
line 595
;595:	s_startserver.item_null.generic.flags	= QMF_LEFT_JUSTIFY|QMF_MOUSEONLY|QMF_SILENT;
ADDRGP4 s_startserver+1848+44
CNSTU4 1050628
ASGNU4
line 596
;596:	s_startserver.item_null.generic.x		= 0;
ADDRGP4 s_startserver+1848+12
CNSTI4 0
ASGNI4
line 597
;597:	s_startserver.item_null.generic.y		= 0;
ADDRGP4 s_startserver+1848+16
CNSTI4 0
ASGNI4
line 598
;598:	s_startserver.item_null.width			= 640;
ADDRGP4 s_startserver+1848+76
CNSTI4 640
ASGNI4
line 599
;599:	s_startserver.item_null.height			= 480;
ADDRGP4 s_startserver+1848+80
CNSTI4 480
ASGNI4
line 601
;600:
;601:	Menu_AddItem( &s_startserver.menu, &s_startserver.banner );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 602
;602:	Menu_AddItem( &s_startserver.menu, &s_startserver.framel );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 603
;603:	Menu_AddItem( &s_startserver.menu, &s_startserver.framer );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 605
;604:
;605:	Menu_AddItem( &s_startserver.menu, &s_startserver.gametype );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 606
;606:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $504
line 607
;607:	{
line 608
;608:		Menu_AddItem( &s_startserver.menu, &s_startserver.mappics[i] );
ADDRGP4 s_startserver
ARGP4
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 609
;609:		Menu_AddItem( &s_startserver.menu, &s_startserver.mapbuttons[i] );
ADDRGP4 s_startserver
ARGP4
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 610
;610:	}
LABELV $505
line 606
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $504
line 612
;611:
;612:	Menu_AddItem( &s_startserver.menu, &s_startserver.arrows );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1336
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 613
;613:	Menu_AddItem( &s_startserver.menu, &s_startserver.prevpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1424
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 614
;614:	Menu_AddItem( &s_startserver.menu, &s_startserver.nextpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1512
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 615
;615:	Menu_AddItem( &s_startserver.menu, &s_startserver.back );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1600
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 616
;616:	Menu_AddItem( &s_startserver.menu, &s_startserver.next );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1688
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 617
;617:	Menu_AddItem( &s_startserver.menu, &s_startserver.mapname );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1776
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 618
;618:	Menu_AddItem( &s_startserver.menu, &s_startserver.item_null );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1848
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 620
;619:
;620:	StartServer_GametypeEvent( NULL, QM_ACTIVATED );
CNSTP4 0
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 StartServer_GametypeEvent
CALLV
pop
line 621
;621:}
LABELV $273
endproc StartServer_MenuInit 20 12
export StartServer_Cache
proc StartServer_Cache 100 16
line 630
;622:
;623:
;624:/*
;625:=================
;626:StartServer_Cache
;627:=================
;628:*/
;629:void StartServer_Cache( void )
;630:{
line 636
;631:	int				i;
;632:	const char		*info;
;633:	qboolean		precache;
;634:	char			picname[64];
;635:
;636:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );	
ADDRGP4 $450
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 637
;637:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );	
ADDRGP4 $467
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 638
;638:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT0 );	
ADDRGP4 $471
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 639
;639:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT1 );	
ADDRGP4 $488
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 640
;640:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMEL );	
ADDRGP4 $292
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 641
;641:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMER );	
ADDRGP4 $306
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 642
;642:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );	
ADDRGP4 $383
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 643
;643:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECTED );	
ADDRGP4 $352
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 644
;644:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $355
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 645
;645:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWS );
ADDRGP4 $387
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 646
;646:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSL );
ADDRGP4 $415
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 647
;647:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSR );
ADDRGP4 $433
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 649
;648:
;649:	precache = trap_Cvar_VariableValue("com_buildscript");
ADDRGP4 $518
ARGP4
ADDRLP4 76
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 72
ADDRLP4 76
INDIRF4
CVFI4 4
ASGNI4
line 651
;650:
;651:	s_startserver.nummaps = UI_GetNumArenas();
ADDRLP4 80
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRGP4 s_startserver+1944
ADDRLP4 80
INDIRI4
ASGNI4
line 653
;652:
;653:	for( i = 0; i < s_startserver.nummaps; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $523
JUMPV
LABELV $520
line 654
;654:		info = UI_GetArenaInfoByNumber( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 84
ADDRGP4 UI_GetArenaInfoByNumber
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 84
INDIRP4
ASGNP4
line 656
;655:
;656:		Q_strncpyz( s_startserver.maplist[i], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $196
ARGP4
ADDRLP4 88
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRLP4 88
INDIRP4
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 657
;657:		Q_strupr( s_startserver.maplist[i] );
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 658
;658:		s_startserver.mapGamebits[i] = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $191
ARGP4
ADDRLP4 92
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRLP4 96
ADDRGP4 GametypeBits
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_startserver+2980
ADDP4
ADDRLP4 96
INDIRI4
ASGNI4
line 660
;659:
;660:		if( precache ) {
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $528
line 661
;661:			Com_sprintf( picname, sizeof(picname), "levelshots/%s", s_startserver.maplist[i] );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $109
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 662
;662:			trap_R_RegisterShaderNoMip(picname);
ADDRLP4 8
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 663
;663:		}
LABELV $528
line 664
;664:	}
LABELV $521
line 653
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $523
ADDRLP4 0
INDIRI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $520
line 666
;665:
;666:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
ADDRLP4 84
CNSTI4 4
ASGNI4
ADDRGP4 s_startserver+1952
ADDRGP4 s_startserver+1944
INDIRI4
ADDRLP4 84
INDIRI4
ADDI4
CNSTI4 1
SUBI4
ADDRLP4 84
INDIRI4
DIVI4
ASGNI4
line 667
;667:}
LABELV $517
endproc StartServer_Cache 100 16
export UI_StartServerMenu
proc UI_StartServerMenu 0 4
line 675
;668:
;669:
;670:/*
;671:=================
;672:UI_StartServerMenu
;673:=================
;674:*/
;675:void UI_StartServerMenu( qboolean multiplayer ) {
line 676
;676:	StartServer_MenuInit();
ADDRGP4 StartServer_MenuInit
CALLV
pop
line 677
;677:	s_startserver.multiplayer = multiplayer;
ADDRGP4 s_startserver+1936
ADDRFP4 0
INDIRI4
ASGNI4
line 678
;678:	UI_PushMenu( &s_startserver.menu );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 679
;679:}
LABELV $533
endproc UI_StartServerMenu 0 4
data
align 4
LABELV dedicated_list
address $536
address $537
address $538
byte 4 0
align 4
LABELV playerType_list
address $539
address $540
address $541
byte 4 0
align 4
LABELV playerTeam_list
address $542
address $543
byte 4 0
align 4
LABELV botSkill_list
address $544
address $545
address $546
address $547
address $548
byte 4 0
align 4
LABELV assaultMiddleItem_list
address $549
address $550
address $551
address $552
address $553
address $554
address $555
address $556
address $557
address $558
address $559
address $560
address $561
address $562
byte 4 0
align 4
LABELV respawnTime_list
address $563
address $564
address $565
address $566
address $567
address $568
address $569
address $570
byte 4 0
align 4
LABELV respawnTime_values
byte 4 0
byte 4 2
byte 4 3
byte 4 5
byte 4 7
byte 4 10
byte 4 15
byte 4 20
code
proc BotAlreadySelected 12 8
line 828
;680:
;681:
;682:
;683:/*
;684:=============================================================================
;685:
;686:SERVER OPTIONS MENU *****
;687:
;688:=============================================================================
;689:*/
;690:
;691:#define ID_PLAYER_TYPE			20
;692:#define ID_MAXCLIENTS			21
;693:#define ID_DEDICATED			22
;694:#define ID_GO					23
;695:#define ID_BACK					24
;696:
;697:#define PLAYER_SLOTS			12
;698:
;699:
;700:typedef struct {
;701:	menuframework_s		menu;
;702:
;703:	menutext_s			banner;
;704:
;705:	menubitmap_s		mappic;
;706:	menubitmap_s		picframe;
;707:
;708:	menulist_s			dedicated;
;709:	menufield_s			timelimit;
;710:	menufield_s			fraglimit;
;711:	menufield_s			flaglimit;
;712:	menuradiobutton_s	friendlyfire;
;713:	menufield_s			hostname;
;714:	menuradiobutton_s	pure;
;715:	menulist_s			botSkill;
;716:	menufield_s			additionalSlots;
;717:	menuradiobutton_s	noPowerups;
;718:	menuradiobutton_s	noHealth;
;719:	menuradiobutton_s	noArmor;
;720:	menuradiobutton_s	noMegaHealth;
;721:	menuradiobutton_s	noPersonalTeleporter;
;722:	menuradiobutton_s	noPlasmaBFG;
;723:	menuradiobutton_s	noGrenadeRocket;
;724:	menuradiobutton_s 	noRailgun;
;725:	menuradiobutton_s	enableBlaster;
;726:	menulist_s 			assaultMiddleItem;
;727:	menulist_s 			respawnTime;
;728:
;729:	menutext_s			player0;
;730:	menulist_s			playerType[PLAYER_SLOTS];
;731:	menutext_s			playerName[PLAYER_SLOTS];
;732:	menulist_s			playerTeam[PLAYER_SLOTS];
;733:
;734:	menubitmap_s		go;
;735:	menubitmap_s		next;
;736:	menubitmap_s		back;
;737:
;738:	qboolean			multiplayer;
;739:	int					gametype;
;740:	char				mapnamebuffer[32];
;741:	char				playerNameBuffers[PLAYER_SLOTS][16];
;742:
;743:	qboolean			newBot;
;744:	int					newBotIndex;
;745:	char				newBotName[16];
;746:	
;747:	menulist_s		punkbuster;
;748:} serveroptions_t;
;749:
;750:static serveroptions_t s_serveroptions;
;751:
;752:static const char *dedicated_list[] = {
;753:	"No",
;754:	"LAN",
;755:	"Internet",
;756:	0
;757:};
;758:
;759:static const char *playerType_list[] = {
;760:	"Open",
;761:	"Bot",
;762:	"----",
;763:	0
;764:};
;765:
;766:static const char *playerTeam_list[] = {
;767:	"Blue",
;768:	"Red",
;769:	0
;770:};
;771:
;772:static const char *botSkill_list[] = {
;773:	"I Can Win",
;774:	"Bring It On",
;775:	"Hurt Me Plenty",
;776:	"Hardcore",
;777:	"Nightmare!",
;778:	0
;779:};
;780:
;781:
;782:static const char *assaultMiddleItem_list[] = {
;783:	"All",
;784:	"Heavy Armor",
;785:	"Armor",
;786:	"Mega Health",
;787:	"Medkit",
;788:	"Haste",
;789:	"BFG",
;790:	"Railgun",
;791:	"Shotgun",
;792:	"Rocket Launcher",
;793:	"Grenade Launcher",
;794:	"Lightning Gun",
;795:	"Personal Teleporter",
;796:	"Plasma Gun",
;797:	0
;798:};
;799:
;800:static const char *respawnTime_list[] = {
;801:	"Default",
;802:	"2 seconds",
;803:	"3 seconds",
;804:	"5 seconds",
;805:	"7 seconds",
;806:	"10 seconds",
;807:	"15 seconds",
;808:	"20 seconds",
;809:	0
;810:};
;811:
;812:static int respawnTime_values[] = {
;813:	0,
;814:	2,
;815:	3,
;816:	5,
;817:	7,
;818:	10,
;819:	15,
;820:	20
;821:};
;822:
;823:/*
;824:=================
;825:BotAlreadySelected
;826:=================
;827:*/
;828:static qboolean BotAlreadySelected( const char *checkName ) {
line 831
;829:	int		n;
;830:
;831:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $572
line 832
;832:		if( s_serveroptions.playerType[n].curvalue != 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $576
line 833
;833:			continue;
ADDRGP4 $573
JUMPV
LABELV $576
line 835
;834:		}
;835:		if( (s_serveroptions.gametype >= GT_TEAM) &&
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $580
ADDRLP4 4
CNSTI4 96
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDRGP4 s_serveroptions+7024
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
INDIRI4
EQI4 $580
line 836
;836:			(s_serveroptions.playerTeam[n].curvalue != s_serveroptions.playerTeam[s_serveroptions.newBotIndex].curvalue ) ) {
line 837
;837:			continue;
ADDRGP4 $573
JUMPV
LABELV $580
line 839
;838:		}
;839:		if( Q_stricmp( checkName, s_serveroptions.playerNameBuffers[n] ) == 0 ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $588
line 840
;840:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $571
JUMPV
LABELV $588
line 842
;841:		}
;842:	}
LABELV $573
line 831
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $572
line 844
;843:
;844:	return qfalse;
CNSTI4 0
RETI4
LABELV $571
endproc BotAlreadySelected 12 8
proc ServerOptions_Start 192 24
line 853
;845:}
;846:
;847:
;848:/*
;849:=================
;850:ServerOptions_Start
;851:=================
;852:*/
;853:static void ServerOptions_Start( void ) {
line 866
;854:	int		timelimit;
;855:	int		fraglimit;
;856:	int		maxclients;
;857:	int		additionalSlots;
;858:	int		dedicated;
;859:	int		friendlyfire;
;860:	int		flaglimit;
;861:	int		pure;
;862:	int		skill;
;863:	int		n;
;864:	char		buf[64];
;865:	
;866:	trap_Cvar_SetValue(
ADDRGP4 $592
ARGP4
ADDRGP4 s_serveroptions+3188+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 respawnTime_values
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 873
;867:		"g_respawnTime",
;868:		respawnTime_values[
;869:			s_serveroptions.respawnTime.curvalue
;870:		]
;871:	);
;872:	
;873:	trap_Cmd_ExecuteText(
ADDRGP4 $595
ARGP4
ADDRGP4 s_serveroptions+3188+64
INDIRI4
ARGI4
ADDRLP4 104
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 104
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 881
;874:		EXEC_APPEND,
;875:		va(
;876:			"seta ui_respawnTime \"%i\"\n",
;877:			s_serveroptions.respawnTime.curvalue
;878:		)
;879:	);
;880:	
;881:	trap_Cvar_SetValue(
ADDRGP4 $598
ARGP4
ADDRGP4 s_serveroptions+3092+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 886
;882:		"g_assaultMiddleItem",
;883:		s_serveroptions.assaultMiddleItem.curvalue
;884:	);
;885:
;886:	trap_Cmd_ExecuteText(
ADDRGP4 $601
ARGP4
ADDRGP4 s_serveroptions+3092+64
INDIRI4
ARGI4
ADDRLP4 108
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 108
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 894
;887:		EXEC_APPEND,
;888:		va(
;889:			"seta ui_assaultMiddleItem \"%i\"\n",
;890:			s_serveroptions.assaultMiddleItem.curvalue
;891:		)
;892:	);
;893:
;894:	timelimit =
ADDRGP4 s_serveroptions+632+60+12
ARGP4
ADDRLP4 112
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 84
ADDRLP4 112
INDIRI4
ASGNI4
line 897
;895:		atoi( s_serveroptions.timelimit.field.buffer );
;896:
;897:	fraglimit =
ADDRGP4 s_serveroptions+964+60+12
ARGP4
ADDRLP4 116
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 88
ADDRLP4 116
INDIRI4
ASGNI4
line 900
;898:		atoi( s_serveroptions.fraglimit.field.buffer );
;899:
;900:	flaglimit =
ADDRGP4 s_serveroptions+1296+60+12
ARGP4
ADDRLP4 120
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 96
ADDRLP4 120
INDIRI4
ASGNI4
line 903
;901:		atoi( s_serveroptions.flaglimit.field.buffer );
;902:
;903:	dedicated =
ADDRLP4 80
ADDRGP4 s_serveroptions+536+64
INDIRI4
ASGNI4
line 906
;904:		s_serveroptions.dedicated.curvalue;
;905:
;906:	friendlyfire =
ADDRLP4 92
ADDRGP4 s_serveroptions+1628+60
INDIRI4
ASGNI4
line 909
;907:		s_serveroptions.friendlyfire.curvalue;
;908:
;909:	pure =
ADDRLP4 100
ADDRGP4 s_serveroptions+2024+60
INDIRI4
ASGNI4
line 912
;910:		s_serveroptions.pure.curvalue;
;911:
;912:	skill =
ADDRLP4 72
ADDRGP4 s_serveroptions+2088+64
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 918
;913:		s_serveroptions.botSkill.curvalue + 1;
;914:
;915:	/*
;916:	 * Count all visible player slots which are not closed.
;917:	 */
;918:	for( n = 0, maxclients = 0;
ADDRLP4 124
CNSTI4 0
ASGNI4
ADDRLP4 0
ADDRLP4 124
INDIRI4
ASGNI4
ADDRLP4 68
ADDRLP4 124
INDIRI4
ASGNI4
ADDRGP4 $624
JUMPV
LABELV $621
line 920
;919:		n < PLAYER_SLOTS;
;920:		n++ ) {
line 921
;921:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $625
line 922
;922:			== 2 ) {
line 923
;923:			continue;
ADDRGP4 $622
JUMPV
LABELV $625
line 926
;924:		}
;925:
;926:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $629
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $629
line 929
;927:			== 1 &&
;928:			s_serveroptions.playerNameBuffers[n][0]
;929:			== 0 ) {
line 930
;930:			continue;
ADDRGP4 $622
JUMPV
LABELV $629
line 933
;931:		}
;932:
;933:		maxclients++;
ADDRLP4 68
ADDRLP4 68
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 934
;934:	}
LABELV $622
line 920
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $624
line 919
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $621
line 939
;935:
;936:	/*
;937:	 * Add extra free slots.
;938:	 */
;939:	additionalSlots = atoi(
ADDRGP4 s_serveroptions+2184+60+12
ARGP4
ADDRLP4 128
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 76
ADDRLP4 128
INDIRI4
ASGNI4
line 943
;940:		s_serveroptions.additionalSlots.field.buffer
;941:	);
;942:
;943:	additionalSlots = (int)Com_Clamp(
CNSTF4 0
ARGF4
CNSTI4 64
ADDRLP4 68
INDIRI4
SUBI4
CVIF4 4
ARGF4
ADDRLP4 76
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 132
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRLP4 76
ADDRLP4 132
INDIRF4
CVFI4 4
ASGNI4
line 949
;944:		0,
;945:		MAX_CLIENTS - maxclients,
;946:		additionalSlots
;947:	);
;948:
;949:	trap_Cvar_SetValue(
ADDRGP4 $637
ARGP4
ADDRLP4 76
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 954
;950:		"ui_additionalSlots",
;951:		additionalSlots
;952:	);
;953:
;954:	maxclients += additionalSlots;
ADDRLP4 68
ADDRLP4 68
INDIRI4
ADDRLP4 76
INDIRI4
ADDI4
ASGNI4
line 959
;955:
;956:	/*
;957:	 * Powerups.
;958:	 */
;959:	trap_Cvar_SetValue(
ADDRGP4 $638
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 964
;960:		"ui_noPowerups",
;961:		s_serveroptions.noPowerups.curvalue
;962:	);
;963:
;964:	trap_Cvar_SetValue(
ADDRGP4 $641
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 972
;965:		"g_noPowerups",
;966:		s_serveroptions.noPowerups.curvalue
;967:	);
;968:
;969:	/*
;970:	 * Mega Health and Medkit share one menu option.
;971:	 */
;972:	trap_Cvar_SetValue(
ADDRGP4 $644
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 977
;973:		"ui_noMegaHealth",
;974:		s_serveroptions.noMegaHealth.curvalue
;975:	);
;976:
;977:	trap_Cvar_SetValue(
ADDRGP4 $647
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 982
;978:		"g_noMegaHealth",
;979:		s_serveroptions.noMegaHealth.curvalue
;980:	);
;981:
;982:	trap_Cvar_SetValue(
ADDRGP4 $650
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 990
;983:		"g_noMedkit",
;984:		s_serveroptions.noMegaHealth.curvalue
;985:	);
;986:
;987:	/*
;988:	 * Personal Teleporter.
;989:	 */
;990:	trap_Cvar_SetValue(
ADDRGP4 $653
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 995
;991:		"ui_noPersonalTeleporter",
;992:		s_serveroptions.noPersonalTeleporter.curvalue
;993:	);
;994:
;995:	trap_Cvar_SetValue(
ADDRGP4 $656
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1000
;996:		"g_noPersonalTeleporter",
;997:		s_serveroptions.noPersonalTeleporter.curvalue
;998:	);
;999:
;1000:	trap_Cmd_ExecuteText(
ADDRGP4 $659
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
ARGI4
ADDRLP4 136
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 136
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1010
;1001:		EXEC_APPEND,
;1002:		va(
;1003:			"seta ui_noMegaHealth \"%i\"\n"
;1004:			"seta ui_noPersonalTeleporter \"%i\"\n",
;1005:			s_serveroptions.noMegaHealth.curvalue,
;1006:			s_serveroptions.noPersonalTeleporter.curvalue
;1007:		)
;1008:	);
;1009:
;1010:	trap_Cmd_ExecuteText(
ADDRGP4 $664
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
ARGI4
ADDRLP4 140
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 140
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1021
;1011:		EXEC_APPEND,
;1012:		va(
;1013:			"seta ui_noPowerups \"%i\"\n",
;1014:			s_serveroptions.noPowerups.curvalue
;1015:		)
;1016:	);
;1017:
;1018:	/*
;1019:	 * Store limits for the selected game type.
;1020:	 */
;1021:	switch( s_serveroptions.gametype ) {
ADDRLP4 144
ADDRGP4 s_serveroptions+6792
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $667
ADDRLP4 144
INDIRI4
CNSTI4 4
GTI4 $667
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $684
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $684
address $670
address $673
address $667
address $676
address $680
code
LABELV $670
LABELV $667
line 1024
;1022:	case GT_FFA:
;1023:	default:
;1024:		trap_Cvar_SetValue(
ADDRGP4 $671
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1029
;1025:			"ui_ffa_fraglimit",
;1026:			fraglimit
;1027:		);
;1028:
;1029:		trap_Cvar_SetValue(
ADDRGP4 $672
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1033
;1030:			"ui_ffa_timelimit",
;1031:			timelimit
;1032:		);
;1033:		break;
ADDRGP4 $668
JUMPV
LABELV $673
line 1036
;1034:
;1035:	case GT_TOURNAMENT:
;1036:		trap_Cvar_SetValue(
ADDRGP4 $674
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1041
;1037:			"ui_tourney_fraglimit",
;1038:			fraglimit
;1039:		);
;1040:
;1041:		trap_Cvar_SetValue(
ADDRGP4 $675
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1045
;1042:			"ui_tourney_timelimit",
;1043:			timelimit
;1044:		);
;1045:		break;
ADDRGP4 $668
JUMPV
LABELV $676
line 1048
;1046:
;1047:	case GT_TEAM:
;1048:		trap_Cvar_SetValue(
ADDRGP4 $677
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1053
;1049:			"ui_team_fraglimit",
;1050:			fraglimit
;1051:		);
;1052:
;1053:		trap_Cvar_SetValue(
ADDRGP4 $678
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1058
;1054:			"ui_team_timelimit",
;1055:			timelimit
;1056:		);
;1057:
;1058:		trap_Cvar_SetValue(
ADDRGP4 $679
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1062
;1059:			"ui_team_friendly",
;1060:			friendlyfire
;1061:		);
;1062:		break;
ADDRGP4 $668
JUMPV
LABELV $680
line 1065
;1063:
;1064:	case GT_CTF:
;1065:		trap_Cvar_SetValue(
ADDRGP4 $681
ARGP4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1070
;1066:			"ui_ctf_capturelimit",
;1067:			flaglimit
;1068:		);
;1069:
;1070:		trap_Cvar_SetValue(
ADDRGP4 $682
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1075
;1071:			"ui_ctf_timelimit",
;1072:			timelimit
;1073:		);
;1074:
;1075:		trap_Cvar_SetValue(
ADDRGP4 $683
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1079
;1076:			"ui_ctf_friendly",
;1077:			friendlyfire
;1078:		);
;1079:		break;
LABELV $668
line 1085
;1080:	}
;1081:
;1082:	/*
;1083:	 * General server settings.
;1084:	 */
;1085:	trap_Cvar_SetValue(
CNSTF4 1065353216
ARGF4
CNSTF4 1115684864
ARGF4
ADDRLP4 68
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 148
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $685
ARGP4
ADDRLP4 148
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1094
;1086:		"sv_maxclients",
;1087:		Com_Clamp(
;1088:			1,
;1089:			MAX_CLIENTS,
;1090:			maxclients
;1091:		)
;1092:	);
;1093:
;1094:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1073741824
ARGF4
ADDRLP4 80
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 152
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $686
ARGP4
ADDRLP4 152
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1103
;1095:		"dedicated",
;1096:		Com_Clamp(
;1097:			0,
;1098:			2,
;1099:			dedicated
;1100:		)
;1101:	);
;1102:
;1103:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 156
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $687
ARGP4
ADDRLP4 156
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1112
;1104:		"timelimit",
;1105:		Com_Clamp(
;1106:			0,
;1107:			999,
;1108:			timelimit
;1109:		)
;1110:	);
;1111:
;1112:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 160
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $688
ARGP4
ADDRLP4 160
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1121
;1113:		"fraglimit",
;1114:		Com_Clamp(
;1115:			0,
;1116:			999,
;1117:			fraglimit
;1118:		)
;1119:	);
;1120:
;1121:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1120403456
ARGF4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 164
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $689
ARGP4
ADDRLP4 164
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1130
;1122:		"capturelimit",
;1123:		Com_Clamp(
;1124:			0,
;1125:			100,
;1126:			flaglimit
;1127:		)
;1128:	);
;1129:
;1130:	trap_Cvar_SetValue(
ADDRGP4 $690
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1135
;1131:		"g_friendlyfire",
;1132:		friendlyfire
;1133:	);
;1134:
;1135:	trap_Cvar_SetValue(
ADDRGP4 $691
ARGP4
ADDRLP4 100
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1140
;1136:		"sv_pure",
;1137:		pure
;1138:	);
;1139:
;1140:	trap_Cvar_Set(
ADDRGP4 $692
ARGP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1145
;1141:		"sv_hostname",
;1142:		s_serveroptions.hostname.field.buffer
;1143:	);
;1144:
;1145:	trap_Cvar_SetValue(
ADDRGP4 $696
ARGP4
ADDRGP4 s_serveroptions+7044+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1153
;1146:		"sv_punkbuster",
;1147:		s_serveroptions.punkbuster.curvalue
;1148:	);
;1149:
;1150:	/*
;1151:	 * Blaster Mode.
;1152:	 */
;1153:	trap_Cvar_SetValue(
ADDRGP4 $699
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1158
;1154:		"ui_enableBlaster",
;1155:		s_serveroptions.enableBlaster.curvalue
;1156:	);
;1157:
;1158:	trap_Cvar_SetValue(
ADDRGP4 $702
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1163
;1159:		"g_blasterMode",
;1160:		s_serveroptions.enableBlaster.curvalue
;1161:	);
;1162:
;1163:	trap_Cmd_ExecuteText(
ADDRGP4 $705
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
ARGI4
ADDRLP4 168
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 168
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1174
;1164:		EXEC_APPEND,
;1165:		va(
;1166:			"seta ui_enableBlaster \"%i\"\n",
;1167:			s_serveroptions.enableBlaster.curvalue
;1168:		)
;1169:	);
;1170:
;1171:	/*
;1172:	 * Weapon pickup restrictions.
;1173:	 */
;1174:	trap_Cvar_SetValue(
ADDRGP4 $708
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1179
;1175:		"g_noPlasmaBFG",
;1176:		s_serveroptions.noPlasmaBFG.curvalue
;1177:	);
;1178:
;1179:	trap_Cvar_SetValue(
ADDRGP4 $711
ARGP4
ADDRGP4 s_serveroptions+2900+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1184
;1180:		"g_noGrenadeRocket",
;1181:		s_serveroptions.noGrenadeRocket.curvalue
;1182:	);
;1183:	
;1184:	trap_Cvar_SetValue(
ADDRGP4 $714
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1189
;1185:		"ui_noRailgun",
;1186:		s_serveroptions.noRailgun.curvalue
;1187:	);
;1188:
;1189:	trap_Cvar_SetValue(
ADDRGP4 $717
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1194
;1190:		"g_noRailgun",
;1191:		s_serveroptions.noRailgun.curvalue
;1192:	);
;1193:
;1194:	trap_Cmd_ExecuteText(
ADDRGP4 $720
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
ARGI4
ADDRLP4 172
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 172
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1202
;1195:		EXEC_APPEND,
;1196:		va(
;1197:			"seta ui_noRailgun \"%i\"\n",
;1198:			s_serveroptions.noRailgun.curvalue
;1199:		)
;1200:	);
;1201:
;1202:	trap_Cmd_ExecuteText(
ADDRGP4 $723
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2900+60
INDIRI4
ARGI4
ADDRLP4 176
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 176
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1215
;1203:		EXEC_APPEND,
;1204:		va(
;1205:			"seta ui_noPlasmaBFG \"%i\"\n"
;1206:			"seta ui_noGrenadeRocket \"%i\"\n",
;1207:			s_serveroptions.noPlasmaBFG.curvalue,
;1208:			s_serveroptions.noGrenadeRocket.curvalue
;1209:		)
;1210:	);
;1211:
;1212:	/*
;1213:	 * Health and armor restrictions.
;1214:	 */
;1215:	trap_Cvar_SetValue(
ADDRGP4 $728
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1220
;1216:		"g_noHealth",
;1217:		s_serveroptions.noHealth.curvalue
;1218:	);
;1219:
;1220:	trap_Cvar_SetValue(
ADDRGP4 $731
ARGP4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1225
;1221:		"g_noArmor",
;1222:		s_serveroptions.noArmor.curvalue
;1223:	);
;1224:
;1225:	trap_Cmd_ExecuteText(
ADDRGP4 $734
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
ARGI4
ADDRLP4 180
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 180
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1239
;1226:		EXEC_APPEND,
;1227:		va(
;1228:			"seta ui_noHealth \"%i\"\n"
;1229:			"seta ui_noArmor \"%i\"\n",
;1230:			s_serveroptions.noHealth.curvalue,
;1231:			s_serveroptions.noArmor.curvalue
;1232:		)
;1233:	);
;1234:
;1235:	/*
;1236:	 * Disable any previous map rotation. After the match,
;1237:	 * Quake III will restart the current map.
;1238:	 */
;1239:	trap_Cvar_Set(
ADDRGP4 $739
ARGP4
ADDRGP4 $740
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1247
;1240:		"nextmap",
;1241:		"map_restart 0"
;1242:	);
;1243:
;1244:	/*
;1245:	 * Start selected map.
;1246:	 */
;1247:	trap_Cmd_ExecuteText(
ADDRGP4 $741
ARGP4
ADDRGP4 s_startserver+1940
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRLP4 184
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 184
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1260
;1248:		EXEC_APPEND,
;1249:		va(
;1250:			"wait; wait; map %s\n",
;1251:			s_startserver.maplist[
;1252:				s_startserver.currentmap
;1253:			]
;1254:		)
;1255:	);
;1256:
;1257:	/*
;1258:	 * Add selected bots after loading the map.
;1259:	 */
;1260:	trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRGP4 $744
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1265
;1261:		EXEC_APPEND,
;1262:		"wait 3\n"
;1263:	);
;1264:
;1265:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $745
line 1266
;1266:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $749
line 1267
;1267:			!= 1 ) {
line 1268
;1268:			continue;
ADDRGP4 $746
JUMPV
LABELV $749
line 1271
;1269:		}
;1270:
;1271:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $753
line 1272
;1272:			== 0 ) {
line 1273
;1273:			continue;
ADDRGP4 $746
JUMPV
LABELV $753
line 1276
;1274:		}
;1275:
;1276:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $756
line 1277
;1277:			== '-' ) {
line 1278
;1278:			continue;
ADDRGP4 $746
JUMPV
LABELV $756
line 1281
;1279:		}
;1280:
;1281:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $759
line 1282
;1282:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $762
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 playerTeam_list
ADDP4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 1293
;1283:				buf,
;1284:				sizeof(buf),
;1285:				"addbot %s %i %s\n",
;1286:				s_serveroptions.playerNameBuffers[n],
;1287:				skill,
;1288:				playerTeam_list[
;1289:					s_serveroptions.playerTeam[n]
;1290:						.curvalue
;1291:				]
;1292:			);
;1293:		}
ADDRGP4 $760
JUMPV
LABELV $759
line 1294
;1294:		else {
line 1295
;1295:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $766
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1302
;1296:				buf,
;1297:				sizeof(buf),
;1298:				"addbot %s %i\n",
;1299:				s_serveroptions.playerNameBuffers[n],
;1300:				skill
;1301:			);
;1302:		}
LABELV $760
line 1304
;1303:
;1304:		trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1308
;1305:			EXEC_APPEND,
;1306:			buf
;1307:		);
;1308:	}
LABELV $746
line 1265
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $745
line 1313
;1309:
;1310:	/*
;1311:	 * Place the local player on the selected team.
;1312:	 */
;1313:	if( dedicated == 0 &&
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $768
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $768
line 1314
;1314:		s_serveroptions.gametype >= GT_TEAM ) {
line 1315
;1315:		trap_Cmd_ExecuteText(
ADDRGP4 $771
ARGP4
ADDRGP4 s_serveroptions+5372+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 playerTeam_list
ADDP4
INDIRP4
ARGP4
ADDRLP4 188
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 188
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1325
;1316:			EXEC_APPEND,
;1317:			va(
;1318:				"wait 5; team %s\n",
;1319:				playerTeam_list[
;1320:					s_serveroptions.playerTeam[0]
;1321:						.curvalue
;1322:				]
;1323:			)
;1324:		);
;1325:	}
LABELV $768
line 1326
;1326:}
LABELV $591
endproc ServerOptions_Start 192 24
proc ServerOptions_InitPlayerItems 12 12
line 1334
;1327:
;1328:
;1329:/*
;1330:=================
;1331:ServerOptions_InitPlayerItems
;1332:=================
;1333:*/
;1334:static void ServerOptions_InitPlayerItems( void ) {
line 1339
;1335:	int		n;
;1336:	int		v;
;1337:
;1338:	// init types
;1339:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $775
line 1340
;1340:		v = 0;	// open
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1341
;1341:	}
ADDRGP4 $776
JUMPV
LABELV $775
line 1342
;1342:	else {
line 1343
;1343:		v = 1;	// bot
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1344
;1344:	}
LABELV $776
line 1346
;1345:	
;1346:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $778
line 1347
;1347:		s_serveroptions.playerType[n].curvalue = v;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1348
;1348:	}
LABELV $779
line 1346
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $778
line 1350
;1349:
;1350:	if( s_serveroptions.multiplayer && (s_serveroptions.gametype < GT_TEAM) ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $784
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
GEI4 $784
line 1351
;1351:		for( n = 8; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 8
ASGNI4
LABELV $788
line 1352
;1352:			s_serveroptions.playerType[n].curvalue = 2;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 2
ASGNI4
line 1353
;1353:		}
LABELV $789
line 1351
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $788
line 1354
;1354:	}
LABELV $784
line 1357
;1355:
;1356:	// if not a dedicated server, first slot is reserved for the human on the server
;1357:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $794
line 1359
;1358:		// human
;1359:		s_serveroptions.playerType[0].generic.flags |= QMF_INACTIVE;
ADDRLP4 8
ADDRGP4 s_serveroptions+3356+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 1360
;1360:		s_serveroptions.playerType[0].curvalue = 0;
ADDRGP4 s_serveroptions+3356+64
CNSTI4 0
ASGNI4
line 1361
;1361:		trap_Cvar_VariableStringBuffer( "name", s_serveroptions.playerNameBuffers[0], sizeof(s_serveroptions.playerNameBuffers[0]) );
ADDRGP4 $802
ARGP4
ADDRGP4 s_serveroptions+6828
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 1362
;1362:		Q_CleanStr( s_serveroptions.playerNameBuffers[0] );
ADDRGP4 s_serveroptions+6828
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1363
;1363:	}
LABELV $794
line 1366
;1364:
;1365:	// init teams
;1366:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $806
line 1367
;1367:		for( n = 0; n < (PLAYER_SLOTS / 2); n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $809
line 1368
;1368:			s_serveroptions.playerTeam[n].curvalue = 0;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
CNSTI4 0
ASGNI4
line 1369
;1369:		}
LABELV $810
line 1367
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 6
LTI4 $809
line 1370
;1370:		for( ; n < PLAYER_SLOTS; n++ ) {
ADDRGP4 $818
JUMPV
LABELV $815
line 1371
;1371:			s_serveroptions.playerTeam[n].curvalue = 1;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
CNSTI4 1
ASGNI4
line 1372
;1372:		}
LABELV $816
line 1370
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $818
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $815
line 1373
;1373:	}
ADDRGP4 $807
JUMPV
LABELV $806
line 1374
;1374:	else {
line 1375
;1375:		for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $821
line 1376
;1376:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 20480
BORU4
ASGNU4
line 1377
;1377:		}
LABELV $822
line 1375
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $821
line 1378
;1378:	}
LABELV $807
line 1379
;1379:}
LABELV $774
endproc ServerOptions_InitPlayerItems 12 12
proc ServerOptions_SetPlayerItems 12 0
line 1387
;1380:
;1381:
;1382:/*
;1383:=================
;1384:ServerOptions_SetPlayerItems
;1385:=================
;1386:*/
;1387:static void ServerOptions_SetPlayerItems( void ) {
line 1399
;1388:	int		start;
;1389:	int		n;
;1390:
;1391:	// types
;1392://	for( n = 0; n < PLAYER_SLOTS; n++ ) {
;1393://		if( (!s_serveroptions.multiplayer) && (n > 0) && (s_serveroptions.playerType[n].curvalue == 0) ) {
;1394://			s_serveroptions.playerType[n].curvalue = 1;
;1395://		}
;1396://	}
;1397:
;1398:	// names
;1399:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $828
line 1400
;1400:		s_serveroptions.player0.string = "Human";
ADDRGP4 s_serveroptions+3284+60
ADDRGP4 $834
ASGNP4
line 1401
;1401:		s_serveroptions.playerName[0].generic.flags &= ~QMF_HIDDEN;
ADDRLP4 8
ADDRGP4 s_serveroptions+4508+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294963199
BANDU4
ASGNU4
line 1403
;1402:
;1403:		start = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1404
;1404:	}
ADDRGP4 $829
JUMPV
LABELV $828
line 1405
;1405:	else {
line 1406
;1406:		s_serveroptions.player0.string = "Open";
ADDRGP4 s_serveroptions+3284+60
ADDRGP4 $539
ASGNP4
line 1407
;1407:		start = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1408
;1408:	}
LABELV $829
line 1409
;1409:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $842
JUMPV
LABELV $839
line 1410
;1410:		if( s_serveroptions.playerType[n].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $843
line 1411
;1411:			s_serveroptions.playerName[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294946815
BANDU4
ASGNU4
line 1412
;1412:		}
ADDRGP4 $844
JUMPV
LABELV $843
line 1413
;1413:		else {
line 1414
;1414:			s_serveroptions.playerName[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 20480
BORU4
ASGNU4
line 1415
;1415:		}
LABELV $844
line 1416
;1416:	}
LABELV $840
line 1409
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $842
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $839
line 1419
;1417:
;1418:	// teams
;1419:	if( s_serveroptions.gametype < GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
GEI4 $851
line 1420
;1420:		return;
ADDRGP4 $827
JUMPV
LABELV $851
line 1422
;1421:	}
;1422:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $857
JUMPV
LABELV $854
line 1423
;1423:		if( s_serveroptions.playerType[n].curvalue == 2 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $858
line 1424
;1424:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 20480
BORU4
ASGNU4
line 1425
;1425:		}
ADDRGP4 $859
JUMPV
LABELV $858
line 1426
;1426:		else {
line 1427
;1427:			s_serveroptions.playerTeam[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294946815
BANDU4
ASGNU4
line 1428
;1428:		}
LABELV $859
line 1429
;1429:	}
LABELV $855
line 1422
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $857
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $854
line 1430
;1430:}
LABELV $827
endproc ServerOptions_SetPlayerItems 12 0
proc ServerOptions_Event 8 0
line 1438
;1431:
;1432:
;1433:/*
;1434:=================
;1435:ServerOptions_Event
;1436:=================
;1437:*/
;1438:static void ServerOptions_Event( void* ptr, int event ) {
line 1439
;1439:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 18
LTI4 $867
ADDRLP4 0
INDIRI4
CNSTI4 24
GTI4 $867
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $883-72
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $883
address $877
address $867
address $870
address $873
address $873
address $874
address $880
code
LABELV $870
line 1445
;1440:	
;1441:	//if( event != QM_ACTIVATED && event != QM_LOSTFOCUS) {
;1442:	//	return;
;1443:	//}
;1444:	case ID_PLAYER_TYPE:
;1445:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $871
line 1446
;1446:			break;
ADDRGP4 $868
JUMPV
LABELV $871
line 1448
;1447:		}
;1448:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1449
;1449:		break;
ADDRGP4 $868
JUMPV
LABELV $873
line 1453
;1450:
;1451:	case ID_MAXCLIENTS:
;1452:	case ID_DEDICATED:
;1453:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1454
;1454:		break;
ADDRGP4 $868
JUMPV
LABELV $874
line 1456
;1455:	case ID_GO:
;1456:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $875
line 1457
;1457:			break;
ADDRGP4 $868
JUMPV
LABELV $875
line 1459
;1458:		}
;1459:		ServerOptions_Start();
ADDRGP4 ServerOptions_Start
CALLV
pop
line 1460
;1460:		break;
ADDRGP4 $868
JUMPV
LABELV $877
line 1463
;1461:
;1462:	case ID_STARTSERVERNEXT:
;1463:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $868
line 1464
;1464:			break;
ADDRGP4 $868
JUMPV
line 1466
;1465:		}
;1466:		break;
LABELV $880
line 1468
;1467:	case ID_BACK:
;1468:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $881
line 1469
;1469:			break;
ADDRGP4 $868
JUMPV
LABELV $881
line 1471
;1470:		}
;1471:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 1472
;1472:		break;
LABELV $867
LABELV $868
line 1474
;1473:	}
;1474:}
LABELV $866
endproc ServerOptions_Event 8 0
proc ServerOptions_PlayerNameEvent 4 4
line 1477
;1475:
;1476:
;1477:static void ServerOptions_PlayerNameEvent( void* ptr, int event ) {
line 1480
;1478:	int		n;
;1479:
;1480:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $886
line 1481
;1481:		return;
ADDRGP4 $885
JUMPV
LABELV $886
line 1483
;1482:	}
;1483:	n = ((menutext_s*)ptr)->generic.id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1484
;1484:	s_serveroptions.newBotIndex = n;
ADDRGP4 s_serveroptions+7024
ADDRLP4 0
INDIRI4
ASGNI4
line 1485
;1485:	UI_BotSelectMenu( s_serveroptions.playerNameBuffers[n] );
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRGP4 UI_BotSelectMenu
CALLV
pop
line 1486
;1486:}
LABELV $885
endproc ServerOptions_PlayerNameEvent 4 4
proc ServerOptions_StatusBar 4 20
line 1494
;1487:
;1488:
;1489:/*
;1490:=================
;1491:ServerOptions_StatusBar
;1492:=================
;1493:*/
;1494:static void ServerOptions_StatusBar( void* ptr ) {
line 1495
;1495:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $891
JUMPV
LABELV $891
line 1497
;1496:	default:
;1497:		UI_DrawString( 320, 440, "0 = NO LIMIT", UI_CENTER|UI_SMALLFONT, colorWhite );
CNSTI4 320
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $894
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 colorWhite
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1498
;1498:		break;
LABELV $892
line 1500
;1499:	}
;1500:}
LABELV $890
endproc ServerOptions_StatusBar 4 20
proc ServerOptions_LevelshotDraw 28 20
line 1508
;1501:
;1502:
;1503:/*
;1504:===============
;1505:ServerOptions_LevelshotDraw
;1506:===============
;1507:*/
;1508:static void ServerOptions_LevelshotDraw( void *self ) {
line 1514
;1509:	menubitmap_s	*b;
;1510:	int				x;
;1511:	int				y;
;1512:
;1513:	// strange place for this, but it works
;1514:	if( s_serveroptions.newBot ) {
ADDRGP4 s_serveroptions+7020
INDIRI4
CNSTI4 0
EQI4 $896
line 1515
;1515:		Q_strncpyz( s_serveroptions.playerNameBuffers[s_serveroptions.newBotIndex], s_serveroptions.newBotName, 16 );
ADDRGP4 s_serveroptions+7024
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRGP4 s_serveroptions+7028
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1516
;1516:		s_serveroptions.newBot = qfalse;
ADDRGP4 s_serveroptions+7020
CNSTI4 0
ASGNI4
line 1517
;1517:	}
LABELV $896
line 1519
;1518:
;1519:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1521
;1520:
;1521:	Bitmap_Draw( b );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Bitmap_Draw
CALLV
pop
line 1523
;1522:
;1523:	x = b->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1524
;1524:	y = b->generic.y + b->height;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ADDI4
ASGNI4
line 1525
;1525:	UI_FillRect( x, y, b->width, 40, colorBlack );
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
CVIF4 4
ARGF4
CNSTF4 1109393408
ARGF4
ADDRGP4 colorBlack
ARGP4
ADDRGP4 UI_FillRect
CALLV
pop
line 1527
;1526:
;1527:	x += b->width / 2;
ADDRLP4 8
ADDRLP4 8
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
CNSTI4 2
DIVI4
ADDI4
ASGNI4
line 1528
;1528:	y += 4;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 1529
;1529:	UI_DrawString( x, y, s_serveroptions.mapnamebuffer, UI_CENTER|UI_SMALLFONT, color_orange );
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+6796
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1531
;1530:
;1531:	y += SMALLCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1532
;1532:	if( trap_Cvar_VariableValue("g_assaultMode") != 0 ) {
ADDRGP4 $242
ARGP4
ADDRLP4 16
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 0
EQF4 $904
line 1533
;1533:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $74
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1540
;1534:			x,
;1535:			y,
;1536:			"Base Assault",
;1537:			UI_CENTER | UI_SMALLFONT,
;1538:			color_orange
;1539:		);
;1540:	}
ADDRGP4 $905
JUMPV
LABELV $904
line 1541
;1541:	else if( trap_Cvar_VariableValue("g_autoCTF") != 0 ) {
ADDRGP4 $248
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $906
line 1542
;1542:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $75
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1549
;1543:			x,
;1544:			y,
;1545:			"CTF on TDM Maps",
;1546:			UI_CENTER | UI_SMALLFONT,
;1547:			color_orange
;1548:		);
;1549:	}
ADDRGP4 $907
JUMPV
LABELV $906
line 1550
;1550:	else {
line 1551
;1551:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 24
CNSTI4 2
ASGNI4
ADDRGP4 s_serveroptions+6792
INDIRI4
ADDRLP4 24
INDIRI4
LSHI4
ADDRGP4 gametype_remap2
ADDP4
INDIRI4
ADDRLP4 24
INDIRI4
LSHI4
ADDRGP4 gametype_items
ADDP4
INDIRP4
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1562
;1552:			x,
;1553:			y,
;1554:			gametype_items[
;1555:				gametype_remap2[
;1556:					s_serveroptions.gametype
;1557:				]
;1558:			],
;1559:			UI_CENTER | UI_SMALLFONT,
;1560:			color_orange
;1561:		);
;1562:	}
LABELV $907
LABELV $905
line 1563
;1563:}
LABELV $895
endproc ServerOptions_LevelshotDraw 28 20
proc ServerOptions_InitBotNames 1072 12
line 1566
;1564:
;1565:
;1566:static void ServerOptions_InitBotNames( void ) {
line 1575
;1567:	int			count;
;1568:	int			n;
;1569:	const char	*arenaInfo;
;1570:	const char	*botInfo;
;1571:	char		*p;
;1572:	char		*bot;
;1573:	char		bots[MAX_INFO_STRING];
;1574:
;1575:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $910
line 1576
;1576:		Q_strncpyz( s_serveroptions.playerNameBuffers[1], "grunt", 16 );
ADDRGP4 s_serveroptions+6828+16
ARGP4
ADDRGP4 $915
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1577
;1577:		Q_strncpyz( s_serveroptions.playerNameBuffers[2], "major", 16 );
ADDRGP4 s_serveroptions+6828+32
ARGP4
ADDRGP4 $918
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1578
;1578:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
NEI4 $919
line 1579
;1579:			Q_strncpyz( s_serveroptions.playerNameBuffers[3], "visor", 16 );
ADDRGP4 s_serveroptions+6828+48
ARGP4
ADDRGP4 $924
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1580
;1580:		}
ADDRGP4 $920
JUMPV
LABELV $919
line 1581
;1581:		else {
line 1582
;1582:			s_serveroptions.playerType[3].curvalue = 2;
ADDRGP4 s_serveroptions+3356+288+64
CNSTI4 2
ASGNI4
line 1583
;1583:		}
LABELV $920
line 1584
;1584:		s_serveroptions.playerType[4].curvalue = 2;
ADDRGP4 s_serveroptions+3356+384+64
CNSTI4 2
ASGNI4
line 1585
;1585:		s_serveroptions.playerType[5].curvalue = 2;
ADDRGP4 s_serveroptions+3356+480+64
CNSTI4 2
ASGNI4
line 1587
;1586:
;1587:		Q_strncpyz( s_serveroptions.playerNameBuffers[6], "sarge", 16 );
ADDRGP4 s_serveroptions+6828+96
ARGP4
ADDRGP4 $936
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1588
;1588:		Q_strncpyz( s_serveroptions.playerNameBuffers[7], "grunt", 16 );
ADDRGP4 s_serveroptions+6828+112
ARGP4
ADDRGP4 $915
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1589
;1589:		Q_strncpyz( s_serveroptions.playerNameBuffers[8], "major", 16 );
ADDRGP4 s_serveroptions+6828+128
ARGP4
ADDRGP4 $918
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1590
;1590:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
NEI4 $941
line 1591
;1591:			Q_strncpyz( s_serveroptions.playerNameBuffers[9], "visor", 16 );
ADDRGP4 s_serveroptions+6828+144
ARGP4
ADDRGP4 $924
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1592
;1592:		}
ADDRGP4 $942
JUMPV
LABELV $941
line 1593
;1593:		else {
line 1594
;1594:			s_serveroptions.playerType[9].curvalue = 2;
ADDRGP4 s_serveroptions+3356+864+64
CNSTI4 2
ASGNI4
line 1595
;1595:		}
LABELV $942
line 1596
;1596:		s_serveroptions.playerType[10].curvalue = 2;
ADDRGP4 s_serveroptions+3356+960+64
CNSTI4 2
ASGNI4
line 1597
;1597:		s_serveroptions.playerType[11].curvalue = 2;
ADDRGP4 s_serveroptions+3356+1056+64
CNSTI4 2
ASGNI4
line 1599
;1598:
;1599:		return;
ADDRGP4 $909
JUMPV
LABELV $910
line 1602
;1600:	}
;1601:
;1602:	count = 1;	// skip the first slot, reserved for a human
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1605
;1603:
;1604:	// get info for this map
;1605:	arenaInfo = UI_GetArenaInfoByMap( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6796
ARGP4
ADDRLP4 1048
ADDRGP4 UI_GetArenaInfoByMap
CALLP4
ASGNP4
ADDRLP4 1044
ADDRLP4 1048
INDIRP4
ASGNP4
line 1608
;1606:
;1607:	// get the bot info - we'll seed with them if any are listed
;1608:	Q_strncpyz( bots, Info_ValueForKey( arenaInfo, "bots" ), sizeof(bots) );
ADDRLP4 1044
INDIRP4
ARGP4
ADDRGP4 $956
ARGP4
ADDRLP4 1052
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ARGP4
ADDRLP4 1052
INDIRP4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1609
;1609:	p = &bots[0];
ADDRLP4 0
ADDRLP4 20
ASGNP4
ADDRGP4 $958
JUMPV
line 1610
;1610:	while( *p && count < PLAYER_SLOTS ) {
LABELV $960
line 1612
;1611:		//skip spaces
;1612:		while( *p && *p == ' ' ) {
line 1613
;1613:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1614
;1614:		}
LABELV $961
line 1612
ADDRLP4 1056
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1056
INDIRI4
CNSTI4 0
EQI4 $963
ADDRLP4 1056
INDIRI4
CNSTI4 32
EQI4 $960
LABELV $963
line 1615
;1615:		if( !p ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $964
line 1616
;1616:			break;
ADDRGP4 $959
JUMPV
LABELV $964
line 1620
;1617:		}
;1618:
;1619:		// mark start of bot name
;1620:		bot = p;
ADDRLP4 8
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $967
JUMPV
LABELV $966
line 1623
;1621:
;1622:		// skip until space of null
;1623:		while( *p && *p != ' ' ) {
line 1624
;1624:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1625
;1625:		}
LABELV $967
line 1623
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $969
ADDRLP4 1060
INDIRI4
CNSTI4 32
NEI4 $966
LABELV $969
line 1626
;1626:		if( *p ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $970
line 1627
;1627:			*p++ = 0;
ADDRLP4 1064
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 1064
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 1064
INDIRP4
CNSTI1 0
ASGNI1
line 1628
;1628:		}
LABELV $970
line 1630
;1629:
;1630:		botInfo = UI_GetBotInfoByName( bot );
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 1064
ADDRGP4 UI_GetBotInfoByName
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 1064
INDIRP4
ASGNP4
line 1631
;1631:		bot = Info_ValueForKey( botInfo, "name" );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 $802
ARGP4
ADDRLP4 1068
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1068
INDIRP4
ASGNP4
line 1633
;1632:
;1633:		Q_strncpyz( s_serveroptions.playerNameBuffers[count], bot, sizeof(s_serveroptions.playerNameBuffers[count]) );
ADDRLP4 4
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1634
;1634:		count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1635
;1635:	}
LABELV $958
line 1610
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $974
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $961
LABELV $974
LABELV $959
line 1638
;1636:
;1637:	// set the rest of the bot slots to "---"
;1638:	for( n = count; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $978
JUMPV
LABELV $975
line 1639
;1639:		strcpy( s_serveroptions.playerNameBuffers[n], "--------" );
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRGP4 $980
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1640
;1640:	}
LABELV $976
line 1638
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $978
ADDRLP4 12
INDIRI4
CNSTI4 12
LTI4 $975
line 1643
;1641:
;1642:	// pad up to #8 as open slots
;1643:	for( ;count < 8; count++ ) {
ADDRGP4 $984
JUMPV
LABELV $981
line 1644
;1644:		s_serveroptions.playerType[count].curvalue = 0;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 0
ASGNI4
line 1645
;1645:	}
LABELV $982
line 1643
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $984
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $981
line 1648
;1646:
;1647:	// close off the rest by default
;1648:	for( ;count < PLAYER_SLOTS; count++ ) {
ADDRGP4 $990
JUMPV
LABELV $987
line 1649
;1649:		if( s_serveroptions.playerType[count].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $991
line 1650
;1650:			s_serveroptions.playerType[count].curvalue = 2;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 2
ASGNI4
line 1651
;1651:		}
LABELV $991
line 1652
;1652:	}
LABELV $988
line 1648
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $990
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $987
line 1653
;1653:}
LABELV $909
endproc ServerOptions_InitBotNames 1072 12
bss
align 1
LABELV $998
skip 64
code
proc ServerOptions_SetMenuItems 180 16
line 1661
;1654:
;1655:
;1656:/*
;1657:=================
;1658:ServerOptions_SetMenuItems
;1659:=================
;1660:*/
;1661:static void ServerOptions_SetMenuItems( void ) {
line 1664
;1662:	static char picname[64];
;1663:	
;1664:	s_serveroptions.respawnTime.curvalue =
ADDRGP4 $1001
ARGP4
ADDRLP4 0
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1088421888
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+3188+64
ADDRLP4 4
INDIRF4
CVFI4 4
ASGNI4
line 1673
;1665:	(int)Com_Clamp(
;1666:		0,
;1667:		7,
;1668:		trap_Cvar_VariableValue(
;1669:			"ui_respawnTime"
;1670:		)
;1671:	);
;1672:	
;1673:	s_serveroptions.assaultMiddleItem.curvalue =
ADDRGP4 $1004
ARGP4
ADDRLP4 8
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1095761920
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+3092+64
ADDRLP4 12
INDIRF4
CVFI4 4
ASGNI4
line 1682
;1674:	(int)Com_Clamp(
;1675:		0,
;1676:		13,
;1677:		trap_Cvar_VariableValue(
;1678:			"ui_assaultMiddleItem"
;1679:		)
;1680:	);
;1681:
;1682:	s_serveroptions.noHealth.curvalue =
ADDRGP4 $1007
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $1009
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $1010
JUMPV
LABELV $1009
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1010
ADDRGP4 s_serveroptions+2580+60
ADDRLP4 16
INDIRI4
ASGNI4
line 1685
;1683:			trap_Cvar_VariableValue( "ui_noHealth" ) != 0;
;1684:
;1685:	s_serveroptions.noArmor.curvalue =
ADDRGP4 $1013
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 0
EQF4 $1015
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1016
JUMPV
LABELV $1015
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1016
ADDRGP4 s_serveroptions+2644+60
ADDRLP4 24
INDIRI4
ASGNI4
line 1688
;1686:		trap_Cvar_VariableValue( "ui_noArmor" ) != 0;
;1687:
;1688:	s_serveroptions.noPlasmaBFG.curvalue =
ADDRGP4 $1019
ARGP4
ADDRLP4 36
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
EQF4 $1021
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRGP4 $1022
JUMPV
LABELV $1021
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $1022
ADDRGP4 s_serveroptions+2836+60
ADDRLP4 32
INDIRI4
ASGNI4
line 1691
;1689:		trap_Cvar_VariableValue( "ui_noPlasmaBFG" ) != 0;
;1690:
;1691:	s_serveroptions.noGrenadeRocket.curvalue =
ADDRGP4 $1025
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 44
INDIRF4
CNSTF4 0
EQF4 $1027
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $1028
JUMPV
LABELV $1027
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $1028
ADDRGP4 s_serveroptions+2900+60
ADDRLP4 40
INDIRI4
ASGNI4
line 1694
;1692:		trap_Cvar_VariableValue( "ui_noGrenadeRocket" ) != 0;
;1693:		
;1694:	s_serveroptions.noRailgun.curvalue =
ADDRGP4 $714
ARGP4
ADDRLP4 52
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 0
EQF4 $1032
ADDRLP4 48
CNSTI4 1
ASGNI4
ADDRGP4 $1033
JUMPV
LABELV $1032
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $1033
ADDRGP4 s_serveroptions+2964+60
ADDRLP4 48
INDIRI4
ASGNI4
line 1697
;1695:		trap_Cvar_VariableValue( "ui_noRailgun" ) != 0;
;1696:		
;1697:	s_serveroptions.enableBlaster.curvalue =
ADDRGP4 $699
ARGP4
ADDRLP4 60
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 60
INDIRF4
CNSTF4 0
EQF4 $1037
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $1038
JUMPV
LABELV $1037
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $1038
ADDRGP4 s_serveroptions+3028+60
ADDRLP4 56
INDIRI4
ASGNI4
line 1700
;1698:		trap_Cvar_VariableValue( "ui_enableBlaster" ) != 0;
;1699:		
;1700:	s_serveroptions.noMegaHealth.curvalue =
ADDRGP4 $644
ARGP4
ADDRLP4 68
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
EQF4 $1042
ADDRLP4 64
CNSTI4 1
ASGNI4
ADDRGP4 $1043
JUMPV
LABELV $1042
ADDRLP4 64
CNSTI4 0
ASGNI4
LABELV $1043
ADDRGP4 s_serveroptions+2708+60
ADDRLP4 64
INDIRI4
ASGNI4
line 1703
;1701:		trap_Cvar_VariableValue( "ui_noMegaHealth" ) != 0;
;1702:
;1703:	s_serveroptions.noPersonalTeleporter.curvalue =
ADDRGP4 $653
ARGP4
ADDRLP4 76
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 76
INDIRF4
CNSTF4 0
EQF4 $1047
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRGP4 $1048
JUMPV
LABELV $1047
ADDRLP4 72
CNSTI4 0
ASGNI4
LABELV $1048
ADDRGP4 s_serveroptions+2772+60
ADDRLP4 72
INDIRI4
ASGNI4
line 1708
;1704:			trap_Cvar_VariableValue(
;1705:				"ui_noPersonalTeleporter"
;1706:			) != 0;
;1707:		
;1708:	s_serveroptions.noPowerups.curvalue =
ADDRGP4 $638
ARGP4
ADDRLP4 84
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 84
INDIRF4
CNSTF4 0
EQF4 $1052
ADDRLP4 80
CNSTI4 1
ASGNI4
ADDRGP4 $1053
JUMPV
LABELV $1052
ADDRLP4 80
CNSTI4 0
ASGNI4
LABELV $1053
ADDRGP4 s_serveroptions+2516+60
ADDRLP4 80
INDIRI4
ASGNI4
line 1711
;1709:		trap_Cvar_VariableValue( "ui_noPowerups" ) != 0;
;1710:
;1711:	Com_sprintf(
ADDRGP4 $637
ARGP4
ADDRLP4 88
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1115422720
ARGF4
ADDRLP4 88
INDIRF4
ARGF4
ADDRLP4 92
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+2184+60+12
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 92
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1722
;1712:			s_serveroptions.additionalSlots.field.buffer,
;1713:			sizeof( s_serveroptions.additionalSlots.field.buffer ),
;1714:			"%i",
;1715:			(int)Com_Clamp(
;1716:				0,
;1717:				MAX_CLIENTS - 1,
;1718:				trap_Cvar_VariableValue( "ui_additionalSlots" )
;1719:			)
;1720:		);
;1721:
;1722:	switch( s_serveroptions.gametype ) {
ADDRLP4 96
ADDRGP4 s_serveroptions+6792
INDIRI4
ASGNI4
ADDRLP4 96
INDIRI4
CNSTI4 0
LTI4 $1061
ADDRLP4 96
INDIRI4
CNSTI4 4
GTI4 $1061
ADDRLP4 96
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $1096
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $1096
address $1064
address $1071
address $1061
address $1078
address $1087
code
LABELV $1064
LABELV $1061
line 1725
;1723:	case GT_FFA:
;1724:	default:
;1725:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_fraglimit" ) ) );
ADDRGP4 $671
ARGP4
ADDRLP4 100
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 100
INDIRF4
ARGF4
ADDRLP4 104
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 104
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1726
;1726:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_timelimit" ) ) );
ADDRGP4 $672
ARGP4
ADDRLP4 108
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 108
INDIRF4
ARGF4
ADDRLP4 112
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 112
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1727
;1727:		break;
ADDRGP4 $1062
JUMPV
LABELV $1071
line 1730
;1728:
;1729:	case GT_TOURNAMENT:
;1730:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_fraglimit" ) ) );
ADDRGP4 $674
ARGP4
ADDRLP4 116
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 116
INDIRF4
ARGF4
ADDRLP4 120
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 120
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1731
;1731:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_timelimit" ) ) );
ADDRGP4 $675
ARGP4
ADDRLP4 124
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 124
INDIRF4
ARGF4
ADDRLP4 128
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 128
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1732
;1732:		break;
ADDRGP4 $1062
JUMPV
LABELV $1078
line 1735
;1733:
;1734:	case GT_TEAM:
;1735:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_fraglimit" ) ) );
ADDRGP4 $677
ARGP4
ADDRLP4 132
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 132
INDIRF4
ARGF4
ADDRLP4 136
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 136
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1736
;1736:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_timelimit" ) ) );
ADDRGP4 $678
ARGP4
ADDRLP4 140
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 140
INDIRF4
ARGF4
ADDRLP4 144
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 144
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1737
;1737:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_team_friendly" ) );
ADDRGP4 $679
ARGP4
ADDRLP4 148
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 148
INDIRF4
ARGF4
ADDRLP4 152
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1628+60
ADDRLP4 152
INDIRF4
CVFI4 4
ASGNI4
line 1738
;1738:		break;
ADDRGP4 $1062
JUMPV
LABELV $1087
line 1741
;1739:
;1740:	case GT_CTF:
;1741:		Com_sprintf( s_serveroptions.flaglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 100, trap_Cvar_VariableValue( "ui_ctf_capturelimit" ) ) );
ADDRGP4 $681
ARGP4
ADDRLP4 156
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1120403456
ARGF4
ADDRLP4 156
INDIRF4
ARGF4
ADDRLP4 160
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1296+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 160
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1742
;1742:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ctf_timelimit" ) ) );
ADDRGP4 $682
ARGP4
ADDRLP4 164
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 164
INDIRF4
ARGF4
ADDRLP4 168
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1060
ARGP4
ADDRLP4 168
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1743
;1743:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_ctf_friendly" ) );
ADDRGP4 $683
ARGP4
ADDRLP4 172
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 172
INDIRF4
ARGF4
ADDRLP4 176
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1628+60
ADDRLP4 176
INDIRF4
CVFI4 4
ASGNI4
line 1744
;1744:		break;
LABELV $1062
line 1747
;1745:	}
;1746:
;1747:	Q_strncpyz( s_serveroptions.hostname.field.buffer, UI_Cvar_VariableString( "sv_hostname" ), sizeof( s_serveroptions.hostname.field.buffer ) );
ADDRGP4 $692
ARGP4
ADDRLP4 100
ADDRGP4 UI_Cvar_VariableString
CALLP4
ASGNP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRLP4 100
INDIRP4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1748
;1748:	s_serveroptions.pure.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_pure" ) );
ADDRGP4 $691
ARGP4
ADDRLP4 104
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 104
INDIRF4
ARGF4
ADDRLP4 108
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+2024+60
ADDRLP4 108
INDIRF4
CVFI4 4
ASGNI4
line 1751
;1749:
;1750:	// set the map pic
;1751:	Com_sprintf( picname, 64, "levelshots/%s", s_startserver.maplist[s_startserver.currentmap] );
ADDRGP4 $998
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $109
ARGP4
ADDRGP4 s_startserver+1940
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 1752
;1752:	s_serveroptions.mappic.generic.name = picname;
ADDRGP4 s_serveroptions+360+4
ADDRGP4 $998
ASGNP4
line 1755
;1753:
;1754:	// set the map name
;1755:	strcpy( s_serveroptions.mapnamebuffer, s_startserver.mapname.string );
ADDRGP4 s_serveroptions+6796
ARGP4
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1756
;1756:	Q_strupr( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6796
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 1759
;1757:
;1758:	// get the player selections initialized
;1759:	ServerOptions_InitPlayerItems();
ADDRGP4 ServerOptions_InitPlayerItems
CALLV
pop
line 1760
;1760:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1763
;1761:
;1762:	// seed bot names
;1763:	ServerOptions_InitBotNames();
ADDRGP4 ServerOptions_InitBotNames
CALLV
pop
line 1764
;1764:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1765
;1765:}
LABELV $997
endproc ServerOptions_SetMenuItems 180 16
proc PlayerName_Draw 48 20
line 1772
;1766:
;1767:/*
;1768:=================
;1769:PlayerName_Draw
;1770:=================
;1771:*/
;1772:static void PlayerName_Draw( void *item ) {
line 1779
;1773:	menutext_s	*s;
;1774:	float		*color;
;1775:	int			x, y;
;1776:	int			style;
;1777:	qboolean	focus;
;1778:
;1779:	s = (menutext_s *)item;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1781
;1780:
;1781:	x = s->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1782
;1782:	y =	s->generic.y;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 1784
;1783:
;1784:	style = UI_SMALLFONT;
ADDRLP4 16
CNSTI4 16
ASGNI4
line 1785
;1785:	focus = (s->generic.parent->cursor == s->generic.menuPosition);
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
NEI4 $1115
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1116
JUMPV
LABELV $1115
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1116
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 1787
;1786:
;1787:	if ( s->generic.flags & QMF_GRAYED )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $1117
line 1788
;1788:		color = text_color_disabled;
ADDRLP4 4
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $1118
JUMPV
LABELV $1117
line 1789
;1789:	else if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1119
line 1790
;1790:	{
line 1791
;1791:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1792
;1792:		style |= UI_PULSE;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 1793
;1793:	}
ADDRGP4 $1120
JUMPV
LABELV $1119
line 1794
;1794:	else if ( s->generic.flags & QMF_BLINK )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $1121
line 1795
;1795:	{
line 1796
;1796:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1797
;1797:		style |= UI_BLINK;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1798
;1798:	}
ADDRGP4 $1122
JUMPV
LABELV $1121
line 1800
;1799:	else
;1800:		color = text_color_normal;
ADDRLP4 4
ADDRGP4 text_color_normal
ASGNP4
LABELV $1122
LABELV $1120
LABELV $1118
line 1802
;1801:
;1802:	if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1123
line 1803
;1803:	{
line 1805
;1804:		// draw cursor
;1805:		UI_FillRect( s->generic.left, s->generic.top, s->generic.right-s->generic.left+1, s->generic.bottom-s->generic.top+1, listbar_color ); 
ADDRLP4 36
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ASGNI4
ADDRLP4 36
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
ASGNI4
ADDRLP4 40
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 44
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
SUBI4
ADDRLP4 44
INDIRI4
ADDI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 40
INDIRI4
SUBI4
ADDRLP4 44
INDIRI4
ADDI4
CVIF4 4
ARGF4
ADDRGP4 listbar_color
ARGP4
ADDRGP4 UI_FillRect
CALLV
pop
line 1806
;1806:		UI_DrawChar( x, y, 13, UI_CENTER|UI_BLINK|UI_SMALLFONT, color);
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTI4 13
ARGI4
CNSTI4 4113
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 UI_DrawChar
CALLV
pop
line 1807
;1807:	}
LABELV $1123
line 1809
;1808:
;1809:	UI_DrawString( x - SMALLCHAR_WIDTH, y, s->generic.name, style|UI_RIGHT, color );
ADDRLP4 8
INDIRI4
CNSTI4 8
SUBI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
ADDRLP4 16
INDIRI4
CNSTI4 2
BORI4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1810
;1810:	UI_DrawString( x + SMALLCHAR_WIDTH, y, s->string, style|UI_LEFT, color );
ADDRLP4 8
INDIRI4
CNSTI4 8
ADDI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRP4
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1811
;1811:}
LABELV $1113
endproc PlayerName_Draw 48 20
proc ServerOptions_MenuInit 52 12
line 1821
;1812:
;1813:
;1814:/*
;1815:=================
;1816:ServerOptions_MenuInit
;1817:=================
;1818:*/
;1819:#define OPTIONS_X	456
;1820:
;1821:static void ServerOptions_MenuInit( qboolean multiplayer ) {
line 1825
;1822:	int		y;
;1823:	int		n;
;1824:
;1825:	memset( &s_serveroptions, 0 ,sizeof(serveroptions_t) );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 0
ARGI4
CNSTI4 7140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1826
;1826:	s_serveroptions.multiplayer = multiplayer;
ADDRGP4 s_serveroptions+6788
ADDRFP4 0
INDIRI4
ASGNI4
line 1827
;1827:	s_serveroptions.gametype = (int)Com_Clamp( 0, 5, trap_Cvar_VariableValue( "g_gameType" ) );
ADDRGP4 $224
ARGP4
ADDRLP4 8
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1084227584
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+6792
ADDRLP4 12
INDIRF4
CVFI4 4
ASGNI4
line 1828
;1828:	s_serveroptions.punkbuster.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_punkbuster" ) );
ADDRGP4 $696
ARGP4
ADDRLP4 16
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 20
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+7044+64
ADDRLP4 20
INDIRF4
CVFI4 4
ASGNI4
line 1830
;1829:
;1830:	ServerOptions_Cache();
ADDRGP4 ServerOptions_Cache
CALLV
pop
line 1832
;1831:
;1832:	s_serveroptions.menu.wrapAround = qtrue;
ADDRGP4 s_serveroptions+276
CNSTI4 1
ASGNI4
line 1833
;1833:	s_serveroptions.menu.fullscreen = qtrue;
ADDRGP4 s_serveroptions+280
CNSTI4 1
ASGNI4
line 1835
;1834:
;1835:	s_serveroptions.banner.generic.type			= MTYPE_BTEXT;
ADDRGP4 s_serveroptions+288
CNSTI4 10
ASGNI4
line 1836
;1836:	s_serveroptions.banner.generic.x			= 320;
ADDRGP4 s_serveroptions+288+12
CNSTI4 320
ASGNI4
line 1837
;1837:	s_serveroptions.banner.generic.y			= 16;
ADDRGP4 s_serveroptions+288+16
CNSTI4 16
ASGNI4
line 1838
;1838:	s_serveroptions.banner.string  				= "GAME SERVER";
ADDRGP4 s_serveroptions+288+60
ADDRGP4 $284
ASGNP4
line 1839
;1839:	s_serveroptions.banner.color  				= color_white;
ADDRGP4 s_serveroptions+288+68
ADDRGP4 color_white
ASGNP4
line 1840
;1840:	s_serveroptions.banner.style  				= UI_CENTER;
ADDRGP4 s_serveroptions+288+64
CNSTI4 1
ASGNI4
line 1842
;1841:
;1842:	s_serveroptions.mappic.generic.type			= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+360
CNSTI4 6
ASGNI4
line 1843
;1843:	s_serveroptions.mappic.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_serveroptions+360+44
CNSTU4 16388
ASGNU4
line 1844
;1844:	s_serveroptions.mappic.generic.x			= 352;
ADDRGP4 s_serveroptions+360+12
CNSTI4 352
ASGNI4
line 1845
;1845:	s_serveroptions.mappic.generic.y			= 80;
ADDRGP4 s_serveroptions+360+16
CNSTI4 80
ASGNI4
line 1846
;1846:	s_serveroptions.mappic.width				= 160;
ADDRGP4 s_serveroptions+360+76
CNSTI4 160
ASGNI4
line 1847
;1847:	s_serveroptions.mappic.height				= 120;
ADDRGP4 s_serveroptions+360+80
CNSTI4 120
ASGNI4
line 1848
;1848:	s_serveroptions.mappic.errorpic				= GAMESERVER_UNKNOWNMAP;
ADDRGP4 s_serveroptions+360+64
ADDRGP4 $355
ASGNP4
line 1849
;1849:	s_serveroptions.mappic.generic.ownerdraw	= ServerOptions_LevelshotDraw;
ADDRGP4 s_serveroptions+360+56
ADDRGP4 ServerOptions_LevelshotDraw
ASGNP4
line 1851
;1850:
;1851:	s_serveroptions.picframe.generic.type		= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+448
CNSTI4 6
ASGNI4
line 1852
;1852:	s_serveroptions.picframe.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE|QMF_HIGHLIGHT;
ADDRGP4 s_serveroptions+448+44
CNSTU4 16452
ASGNU4
line 1853
;1853:	s_serveroptions.picframe.generic.x			= 352 - 38;
ADDRGP4 s_serveroptions+448+12
CNSTI4 314
ASGNI4
line 1854
;1854:	s_serveroptions.picframe.generic.y			= 80 - 40;
ADDRGP4 s_serveroptions+448+16
CNSTI4 40
ASGNI4
line 1855
;1855:	s_serveroptions.picframe.width  			= 320;
ADDRGP4 s_serveroptions+448+76
CNSTI4 320
ASGNI4
line 1856
;1856:	s_serveroptions.picframe.height  			= 320;
ADDRGP4 s_serveroptions+448+80
CNSTI4 320
ASGNI4
line 1857
;1857:	s_serveroptions.picframe.focuspic			= GAMESERVER_SELECT;
ADDRGP4 s_serveroptions+448+60
ADDRGP4 $383
ASGNP4
line 1859
;1858:	
;1859:	s_serveroptions.respawnTime.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3188
CNSTI4 3
ASGNI4
line 1860
;1860:	s_serveroptions.respawnTime.generic.name ="Respawn Time:";
ADDRGP4 s_serveroptions+3188+4
ADDRGP4 $1174
ASGNP4
line 1861
;1861:	s_serveroptions.respawnTime.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3188+44
CNSTU4 258
ASGNU4
line 1862
;1862:	s_serveroptions.respawnTime.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3188+12
CNSTI4 456
ASGNI4
line 1863
;1863:	s_serveroptions.respawnTime.generic.y = 252;
ADDRGP4 s_serveroptions+3188+16
CNSTI4 252
ASGNI4
line 1864
;1864:	s_serveroptions.respawnTime.itemnames = respawnTime_list;
ADDRGP4 s_serveroptions+3188+76
ADDRGP4 respawnTime_list
ASGNP4
line 1866
;1865:	
;1866:	s_serveroptions.assaultMiddleItem.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3092
CNSTI4 3
ASGNI4
line 1867
;1867:	s_serveroptions.assaultMiddleItem.generic.name = "Point B(Base Assault):";
ADDRGP4 s_serveroptions+3092+4
ADDRGP4 $1186
ASGNP4
line 1868
;1868:	s_serveroptions.assaultMiddleItem.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3092+44
CNSTU4 258
ASGNU4
line 1869
;1869:	s_serveroptions.assaultMiddleItem.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3092+12
CNSTI4 456
ASGNI4
line 1870
;1870:	s_serveroptions.assaultMiddleItem.generic.y = 268;
ADDRGP4 s_serveroptions+3092+16
CNSTI4 268
ASGNI4
line 1871
;1871:	s_serveroptions.assaultMiddleItem.itemnames = assaultMiddleItem_list;
ADDRGP4 s_serveroptions+3092+76
ADDRGP4 assaultMiddleItem_list
ASGNP4
line 1873
;1872:	
;1873:	y = 282;
ADDRLP4 4
CNSTI4 282
ASGNI4
line 1875
;1874:	
;1875:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 4
EQI4 $1195
line 1876
;1876:		s_serveroptions.fraglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+964
CNSTI4 4
ASGNI4
line 1877
;1877:		s_serveroptions.fraglimit.generic.name       = "Frag Limit:";
ADDRGP4 s_serveroptions+964+4
ADDRGP4 $1201
ASGNP4
line 1878
;1878:		s_serveroptions.fraglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+964+44
CNSTU4 290
ASGNU4
line 1879
;1879:		s_serveroptions.fraglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+964+12
CNSTI4 456
ASGNI4
line 1880
;1880:		s_serveroptions.fraglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1881
;1881:		s_serveroptions.fraglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+964+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1882
;1882:		s_serveroptions.fraglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+964+60+8
CNSTI4 3
ASGNI4
line 1883
;1883:		s_serveroptions.fraglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+964+60+268
CNSTI4 3
ASGNI4
line 1884
;1884:	}
ADDRGP4 $1196
JUMPV
LABELV $1195
line 1885
;1885:	else {
line 1886
;1886:		s_serveroptions.flaglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1296
CNSTI4 4
ASGNI4
line 1887
;1887:		s_serveroptions.flaglimit.generic.name       = "Capture Limit:";
ADDRGP4 s_serveroptions+1296+4
ADDRGP4 $1219
ASGNP4
line 1888
;1888:		s_serveroptions.flaglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1296+44
CNSTU4 290
ASGNU4
line 1889
;1889:		s_serveroptions.flaglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+1296+12
CNSTI4 456
ASGNI4
line 1890
;1890:		s_serveroptions.flaglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+1296+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1891
;1891:		s_serveroptions.flaglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+1296+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1892
;1892:		s_serveroptions.flaglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+1296+60+8
CNSTI4 3
ASGNI4
line 1893
;1893:		s_serveroptions.flaglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+1296+60+268
CNSTI4 3
ASGNI4
line 1894
;1894:	}
LABELV $1196
line 1896
;1895:
;1896:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1897
;1897:	s_serveroptions.timelimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+632
CNSTI4 4
ASGNI4
line 1898
;1898:	s_serveroptions.timelimit.generic.name       = "Time Limit:";
ADDRGP4 s_serveroptions+632+4
ADDRGP4 $1237
ASGNP4
line 1899
;1899:	s_serveroptions.timelimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+632+44
CNSTU4 290
ASGNU4
line 1900
;1900:	s_serveroptions.timelimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+632+12
CNSTI4 456
ASGNI4
line 1901
;1901:	s_serveroptions.timelimit.generic.y	         = y;
ADDRGP4 s_serveroptions+632+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1902
;1902:	s_serveroptions.timelimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+632+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1903
;1903:	s_serveroptions.timelimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+632+60+8
CNSTI4 3
ASGNI4
line 1904
;1904:	s_serveroptions.timelimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+632+60+268
CNSTI4 3
ASGNI4
line 1906
;1905:
;1906:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1252
line 1907
;1907:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1908
;1908:		s_serveroptions.friendlyfire.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+1628
CNSTI4 5
ASGNI4
line 1909
;1909:		s_serveroptions.friendlyfire.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1628+44
CNSTU4 258
ASGNU4
line 1910
;1910:		s_serveroptions.friendlyfire.generic.x	      = OPTIONS_X;
ADDRGP4 s_serveroptions+1628+12
CNSTI4 456
ASGNI4
line 1911
;1911:		s_serveroptions.friendlyfire.generic.y	      = y;
ADDRGP4 s_serveroptions+1628+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1912
;1912:		s_serveroptions.friendlyfire.generic.name	  = "Friendly Fire:";
ADDRGP4 s_serveroptions+1628+4
ADDRGP4 $1264
ASGNP4
line 1913
;1913:	}
LABELV $1252
line 1915
;1914:
;1915:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1916
;1916:	s_serveroptions.pure.generic.type			= MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2024
CNSTI4 5
ASGNI4
line 1917
;1917:	s_serveroptions.pure.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2024+44
CNSTU4 258
ASGNU4
line 1918
;1918:	s_serveroptions.pure.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+2024+12
CNSTI4 456
ASGNI4
line 1919
;1919:	s_serveroptions.pure.generic.y				= y;
ADDRGP4 s_serveroptions+2024+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1920
;1920:	s_serveroptions.pure.generic.name			= "Pure Server:";
ADDRGP4 s_serveroptions+2024+4
ADDRGP4 $1274
ASGNP4
line 1922
;1921:
;1922:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1275
line 1923
;1923:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1924
;1924:		s_serveroptions.dedicated.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+536
CNSTI4 3
ASGNI4
line 1925
;1925:		s_serveroptions.dedicated.generic.id		= ID_DEDICATED;
ADDRGP4 s_serveroptions+536+8
CNSTI4 22
ASGNI4
line 1926
;1926:		s_serveroptions.dedicated.generic.flags		= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+536+44
CNSTU4 258
ASGNU4
line 1927
;1927:		s_serveroptions.dedicated.generic.callback	= ServerOptions_Event;
ADDRGP4 s_serveroptions+536+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 1928
;1928:		s_serveroptions.dedicated.generic.x			= OPTIONS_X;
ADDRGP4 s_serveroptions+536+12
CNSTI4 456
ASGNI4
line 1929
;1929:		s_serveroptions.dedicated.generic.y			= y;
ADDRGP4 s_serveroptions+536+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1930
;1930:		s_serveroptions.dedicated.generic.name		= "Dedicated:";
ADDRGP4 s_serveroptions+536+4
ADDRGP4 $1291
ASGNP4
line 1931
;1931:		s_serveroptions.dedicated.itemnames			= dedicated_list;
ADDRGP4 s_serveroptions+536+76
ADDRGP4 dedicated_list
ASGNP4
line 1932
;1932:	}
LABELV $1275
line 1934
;1933:
;1934:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1294
line 1935
;1935:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1936
;1936:		s_serveroptions.hostname.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1692
CNSTI4 4
ASGNI4
line 1937
;1937:		s_serveroptions.hostname.generic.name       = "Hostname:";
ADDRGP4 s_serveroptions+1692+4
ADDRGP4 $1300
ASGNP4
line 1938
;1938:		s_serveroptions.hostname.generic.flags      = QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1692+44
CNSTU4 2
ASGNU4
line 1939
;1939:		s_serveroptions.hostname.generic.x          = OPTIONS_X;
ADDRGP4 s_serveroptions+1692+12
CNSTI4 456
ASGNI4
line 1940
;1940:		s_serveroptions.hostname.generic.y	        = y;
ADDRGP4 s_serveroptions+1692+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1941
;1941:		s_serveroptions.hostname.field.widthInChars = 18;
ADDRGP4 s_serveroptions+1692+60+8
CNSTI4 18
ASGNI4
line 1942
;1942:		s_serveroptions.hostname.field.maxchars     = 64;
ADDRGP4 s_serveroptions+1692+60+268
CNSTI4 64
ASGNI4
line 1943
;1943:	}
LABELV $1294
line 1945
;1944:
;1945:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1946
;1946:	s_serveroptions.punkbuster.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+7044
CNSTI4 3
ASGNI4
line 1947
;1947:	s_serveroptions.punkbuster.generic.name			= "Punkbuster:";
ADDRGP4 s_serveroptions+7044+4
ADDRGP4 $1316
ASGNP4
line 1948
;1948:	s_serveroptions.punkbuster.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+7044+44
CNSTU4 258
ASGNU4
line 1949
;1949:	s_serveroptions.punkbuster.generic.id			= 0;
ADDRGP4 s_serveroptions+7044+8
CNSTI4 0
ASGNI4
line 1950
;1950:	s_serveroptions.punkbuster.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+7044+12
CNSTI4 456
ASGNI4
line 1951
;1951:	s_serveroptions.punkbuster.generic.y				= y;
ADDRGP4 s_serveroptions+7044+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1952
;1952:	s_serveroptions.punkbuster.itemnames				= punkbuster_items;
ADDRGP4 s_serveroptions+7044+76
ADDRGP4 punkbuster_items
ASGNP4
line 1954
;1953:	
;1954:	y = 90;
ADDRLP4 4
CNSTI4 90
ASGNI4
line 1955
;1955:	s_serveroptions.botSkill.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+2088
CNSTI4 3
ASGNI4
line 1956
;1956:	s_serveroptions.botSkill.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2088+44
CNSTU4 258
ASGNU4
line 1957
;1957:	s_serveroptions.botSkill.generic.name			= "Bot Skill:  ";
ADDRGP4 s_serveroptions+2088+4
ADDRGP4 $1332
ASGNP4
line 1958
;1958:	s_serveroptions.botSkill.generic.x				= 32 + (strlen(s_serveroptions.botSkill.generic.name) + 2 ) * SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+2088+4
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRGP4 s_serveroptions+2088+12
ADDRLP4 24
INDIRI4
CNSTI4 3
LSHI4
CNSTI4 16
ADDI4
CNSTI4 32
ADDI4
ASGNI4
line 1959
;1959:	s_serveroptions.botSkill.generic.y				= y;
ADDRGP4 s_serveroptions+2088+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1960
;1960:	s_serveroptions.botSkill.itemnames				= botSkill_list;
ADDRGP4 s_serveroptions+2088+76
ADDRGP4 botSkill_list
ASGNP4
line 1961
;1961:	s_serveroptions.botSkill.curvalue				= 1;
ADDRGP4 s_serveroptions+2088+64
CNSTI4 1
ASGNI4
line 1963
;1962:
;1963:	y += ( 2 * SMALLCHAR_HEIGHT );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 1964
;1964:	s_serveroptions.player0.generic.type			= MTYPE_TEXT;
ADDRGP4 s_serveroptions+3284
CNSTI4 7
ASGNI4
line 1965
;1965:	s_serveroptions.player0.generic.flags			= QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3284+44
CNSTU4 2
ASGNU4
line 1966
;1966:	s_serveroptions.player0.generic.x				= 32 + SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+3284+12
CNSTI4 40
ASGNI4
line 1967
;1967:	s_serveroptions.player0.generic.y				= y;
ADDRGP4 s_serveroptions+3284+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1968
;1968:	s_serveroptions.player0.color					= color_orange;
ADDRGP4 s_serveroptions+3284+68
ADDRGP4 color_orange
ASGNP4
line 1969
;1969:	s_serveroptions.player0.style					= UI_LEFT|UI_SMALLFONT;
ADDRGP4 s_serveroptions+3284+64
CNSTI4 16
ASGNI4
line 1971
;1970:
;1971:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1354
line 1972
;1972:		s_serveroptions.playerType[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356
ADDP4
CNSTI4 3
ASGNI4
line 1973
;1973:		s_serveroptions.playerType[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+44
ADDP4
CNSTU4 2
ASGNU4
line 1974
;1974:		s_serveroptions.playerType[n].generic.id		= ID_PLAYER_TYPE;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+8
ADDP4
CNSTI4 20
ASGNI4
line 1975
;1975:		s_serveroptions.playerType[n].generic.callback	= ServerOptions_Event;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+48
ADDP4
ADDRGP4 ServerOptions_Event
ASGNP4
line 1976
;1976:		s_serveroptions.playerType[n].generic.x			= 32;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+12
ADDP4
CNSTI4 32
ASGNI4
line 1977
;1977:		s_serveroptions.playerType[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1978
;1978:		s_serveroptions.playerType[n].itemnames			= playerType_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+76
ADDP4
ADDRGP4 playerType_list
ASGNP4
line 1980
;1979:
;1980:		s_serveroptions.playerName[n].generic.type		= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508
ADDP4
CNSTI4 7
ASGNI4
line 1981
;1981:		s_serveroptions.playerName[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+44
ADDP4
CNSTU4 2
ASGNU4
line 1982
;1982:		s_serveroptions.playerName[n].generic.x			= 96;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
CNSTI4 96
ASGNI4
line 1983
;1983:		s_serveroptions.playerName[n].generic.y			= y;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1984
;1984:		s_serveroptions.playerName[n].generic.callback	= ServerOptions_PlayerNameEvent;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+48
ADDP4
ADDRGP4 ServerOptions_PlayerNameEvent
ASGNP4
line 1985
;1985:		s_serveroptions.playerName[n].generic.id		= n;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1986
;1986:		s_serveroptions.playerName[n].generic.ownerdraw	= PlayerName_Draw;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+56
ADDP4
ADDRGP4 PlayerName_Draw
ASGNP4
line 1987
;1987:		s_serveroptions.playerName[n].color				= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 1988
;1988:		s_serveroptions.playerName[n].style				= UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+64
ADDP4
CNSTI4 16
ASGNI4
line 1989
;1989:		s_serveroptions.playerName[n].string			= s_serveroptions.playerNameBuffers[n];
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+60
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ASGNP4
line 1990
;1990:		s_serveroptions.playerName[n].generic.top		= s_serveroptions.playerName[n].generic.y;
ADDRLP4 36
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4508+24
ADDP4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
INDIRI4
ASGNI4
line 1991
;1991:		s_serveroptions.playerName[n].generic.bottom	= s_serveroptions.playerName[n].generic.y + SMALLCHAR_HEIGHT;
ADDRLP4 40
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4508+32
ADDP4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1992
;1992:		s_serveroptions.playerName[n].generic.left		= s_serveroptions.playerName[n].generic.x - SMALLCHAR_HEIGHT/ 2;
ADDRLP4 44
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4508+20
ADDP4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
INDIRI4
CNSTI4 8
SUBI4
ASGNI4
line 1993
;1993:		s_serveroptions.playerName[n].generic.right		= s_serveroptions.playerName[n].generic.x + 16 * SMALLCHAR_WIDTH;
ADDRLP4 48
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 48
INDIRI4
ADDRGP4 s_serveroptions+4508+28
ADDP4
ADDRLP4 48
INDIRI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
INDIRI4
CNSTI4 128
ADDI4
ASGNI4
line 1995
;1994:
;1995:		s_serveroptions.playerTeam[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372
ADDP4
CNSTI4 3
ASGNI4
line 1996
;1996:		s_serveroptions.playerTeam[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+44
ADDP4
CNSTU4 2
ASGNU4
line 1997
;1997:		s_serveroptions.playerTeam[n].generic.x			= 240;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+12
ADDP4
CNSTI4 240
ASGNI4
line 1998
;1998:		s_serveroptions.playerTeam[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1999
;1999:		s_serveroptions.playerTeam[n].itemnames			= playerTeam_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+76
ADDP4
ADDRGP4 playerTeam_list
ASGNP4
line 2001
;2000:
;2001:		y += ( SMALLCHAR_HEIGHT + 4 );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
line 2002
;2002:	}
LABELV $1355
line 1971
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1354
line 2004
;2003:
;2004:	s_serveroptions.additionalSlots.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+2184
CNSTI4 4
ASGNI4
line 2005
;2005:	s_serveroptions.additionalSlots.generic.name       = "Additional Slots:";
ADDRGP4 s_serveroptions+2184+4
ADDRGP4 $1419
ASGNP4
line 2006
;2006:	s_serveroptions.additionalSlots.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2184+44
CNSTU4 290
ASGNU4
line 2007
;2007:	s_serveroptions.additionalSlots.generic.id         = ID_MAXCLIENTS;
ADDRGP4 s_serveroptions+2184+8
CNSTI4 21
ASGNI4
line 2008
;2008:	s_serveroptions.additionalSlots.generic.x          = 240;
ADDRGP4 s_serveroptions+2184+12
CNSTI4 240
ASGNI4
line 2009
;2009:	s_serveroptions.additionalSlots.generic.y          = y;
ADDRGP4 s_serveroptions+2184+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2010
;2010:	s_serveroptions.additionalSlots.field.widthInChars = 2;
ADDRGP4 s_serveroptions+2184+60+8
CNSTI4 2
ASGNI4
line 2011
;2011:	s_serveroptions.additionalSlots.field.maxchars     = 2;
ADDRGP4 s_serveroptions+2184+60+268
CNSTI4 2
ASGNI4
line 2013
;2012:	
;2013:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2014
;2014:	s_serveroptions.noPowerups.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2516
CNSTI4 5
ASGNI4
line 2015
;2015:	s_serveroptions.noPowerups.generic.name     = "No Powerups:";
ADDRGP4 s_serveroptions+2516+4
ADDRGP4 $1437
ASGNP4
line 2016
;2016:	s_serveroptions.noPowerups.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2516+44
CNSTU4 258
ASGNU4
line 2017
;2017:	s_serveroptions.noPowerups.generic.x        = 240;
ADDRGP4 s_serveroptions+2516+12
CNSTI4 240
ASGNI4
line 2018
;2018:	s_serveroptions.noPowerups.generic.y        = y;
ADDRGP4 s_serveroptions+2516+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2020
;2019:	
;2020:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2021
;2021:	s_serveroptions.noHealth.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2580
CNSTI4 5
ASGNI4
line 2022
;2022:	s_serveroptions.noHealth.generic.name = "No Health:";
ADDRGP4 s_serveroptions+2580+4
ADDRGP4 $1447
ASGNP4
line 2023
;2023:	s_serveroptions.noHealth.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2580+44
CNSTU4 258
ASGNU4
line 2024
;2024:	s_serveroptions.noHealth.generic.x = 240;
ADDRGP4 s_serveroptions+2580+12
CNSTI4 240
ASGNI4
line 2025
;2025:	s_serveroptions.noHealth.generic.y = y;
ADDRGP4 s_serveroptions+2580+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2027
;2026:
;2027:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2028
;2028:	s_serveroptions.noArmor.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2644
CNSTI4 5
ASGNI4
line 2029
;2029:	s_serveroptions.noArmor.generic.name = "No Armor:";
ADDRGP4 s_serveroptions+2644+4
ADDRGP4 $1457
ASGNP4
line 2030
;2030:	s_serveroptions.noArmor.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2644+44
CNSTU4 258
ASGNU4
line 2031
;2031:	s_serveroptions.noArmor.generic.x = 240;
ADDRGP4 s_serveroptions+2644+12
CNSTI4 240
ASGNI4
line 2032
;2032:	s_serveroptions.noArmor.generic.y = y;
ADDRGP4 s_serveroptions+2644+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2034
;2033:	
;2034:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2036
;2035:
;2036:	s_serveroptions.noMegaHealth.generic.type  = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2708
CNSTI4 5
ASGNI4
line 2037
;2037:	s_serveroptions.noMegaHealth.generic.name  = "No Mega / Medkit:";
ADDRGP4 s_serveroptions+2708+4
ADDRGP4 $1467
ASGNP4
line 2038
;2038:	s_serveroptions.noMegaHealth.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2708+44
CNSTU4 258
ASGNU4
line 2039
;2039:	s_serveroptions.noMegaHealth.generic.x     = 240;
ADDRGP4 s_serveroptions+2708+12
CNSTI4 240
ASGNI4
line 2040
;2040:	s_serveroptions.noMegaHealth.generic.y     = y;
ADDRGP4 s_serveroptions+2708+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2042
;2041:
;2042:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2043
;2043:	s_serveroptions.noPersonalTeleporter.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2772
CNSTI4 5
ASGNI4
line 2044
;2044:	s_serveroptions.noPersonalTeleporter.generic.name = "No Personal TP:";
ADDRGP4 s_serveroptions+2772+4
ADDRGP4 $1477
ASGNP4
line 2045
;2045:	s_serveroptions.noPersonalTeleporter.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2772+44
CNSTU4 258
ASGNU4
line 2046
;2046:	s_serveroptions.noPersonalTeleporter.generic.x = 240;
ADDRGP4 s_serveroptions+2772+12
CNSTI4 240
ASGNI4
line 2047
;2047:	s_serveroptions.noPersonalTeleporter.generic.y = y;
ADDRGP4 s_serveroptions+2772+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2049
;2048:	
;2049:	y=368;
ADDRLP4 4
CNSTI4 368
ASGNI4
line 2050
;2050:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2051
;2051:	s_serveroptions.noPlasmaBFG.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2836
CNSTI4 5
ASGNI4
line 2052
;2052:	s_serveroptions.noPlasmaBFG.generic.name = "No Energy Guns:";
ADDRGP4 s_serveroptions+2836+4
ADDRGP4 $1487
ASGNP4
line 2053
;2053:	s_serveroptions.noPlasmaBFG.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2836+44
CNSTU4 258
ASGNU4
line 2054
;2054:	s_serveroptions.noPlasmaBFG.generic.x = 440;
ADDRGP4 s_serveroptions+2836+12
CNSTI4 440
ASGNI4
line 2055
;2055:	s_serveroptions.noPlasmaBFG.generic.y = y;
ADDRGP4 s_serveroptions+2836+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2057
;2056:
;2057:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2058
;2058:	s_serveroptions.noGrenadeRocket.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2900
CNSTI4 5
ASGNI4
line 2059
;2059:	s_serveroptions.noGrenadeRocket.generic.name = "No Explosives:";
ADDRGP4 s_serveroptions+2900+4
ADDRGP4 $1497
ASGNP4
line 2060
;2060:	s_serveroptions.noGrenadeRocket.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2900+44
CNSTU4 258
ASGNU4
line 2061
;2061:	s_serveroptions.noGrenadeRocket.generic.x = 440;
ADDRGP4 s_serveroptions+2900+12
CNSTI4 440
ASGNI4
line 2062
;2062:	s_serveroptions.noGrenadeRocket.generic.y = y;
ADDRGP4 s_serveroptions+2900+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2064
;2063:	
;2064:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2065
;2065:	s_serveroptions.noRailgun.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2964
CNSTI4 5
ASGNI4
line 2066
;2066:	s_serveroptions.noRailgun.generic.name = "No Railgun:";
ADDRGP4 s_serveroptions+2964+4
ADDRGP4 $1507
ASGNP4
line 2067
;2067:	s_serveroptions.noRailgun.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2964+44
CNSTU4 258
ASGNU4
line 2068
;2068:	s_serveroptions.noRailgun.generic.x = 440;
ADDRGP4 s_serveroptions+2964+12
CNSTI4 440
ASGNI4
line 2069
;2069:	s_serveroptions.noRailgun.generic.y = y;
ADDRGP4 s_serveroptions+2964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2071
;2070:	
;2071:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2072
;2072:	s_serveroptions.enableBlaster.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+3028
CNSTI4 5
ASGNI4
line 2073
;2073:	s_serveroptions.enableBlaster.generic.name = "Enable Blaster:";
ADDRGP4 s_serveroptions+3028+4
ADDRGP4 $1517
ASGNP4
line 2074
;2074:	s_serveroptions.enableBlaster.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3028+44
CNSTU4 258
ASGNU4
line 2075
;2075:	s_serveroptions.enableBlaster.generic.x = 440;
ADDRGP4 s_serveroptions+3028+12
CNSTI4 440
ASGNI4
line 2076
;2076:	s_serveroptions.enableBlaster.generic.y = y;
ADDRGP4 s_serveroptions+3028+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2078
;2077:
;2078:	s_serveroptions.back.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6700
CNSTI4 6
ASGNI4
line 2079
;2079:	s_serveroptions.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_serveroptions+6700+4
ADDRGP4 $450
ASGNP4
line 2080
;2080:	s_serveroptions.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6700+44
CNSTU4 260
ASGNU4
line 2081
;2081:	s_serveroptions.back.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6700+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2082
;2082:	s_serveroptions.back.generic.id	      = ID_BACK;
ADDRGP4 s_serveroptions+6700+8
CNSTI4 24
ASGNI4
line 2083
;2083:	s_serveroptions.back.generic.x		  = 0;
ADDRGP4 s_serveroptions+6700+12
CNSTI4 0
ASGNI4
line 2084
;2084:	s_serveroptions.back.generic.y		  = 480-64;
ADDRGP4 s_serveroptions+6700+16
CNSTI4 416
ASGNI4
line 2085
;2085:	s_serveroptions.back.width  		  = 128;
ADDRGP4 s_serveroptions+6700+76
CNSTI4 128
ASGNI4
line 2086
;2086:	s_serveroptions.back.height  		  = 64;
ADDRGP4 s_serveroptions+6700+80
CNSTI4 64
ASGNI4
line 2087
;2087:	s_serveroptions.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_serveroptions+6700+60
ADDRGP4 $467
ASGNP4
line 2089
;2088:
;2089:	s_serveroptions.next.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6612
CNSTI4 6
ASGNI4
line 2090
;2090:	s_serveroptions.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_serveroptions+6612+4
ADDRGP4 $471
ASGNP4
line 2091
;2091:	s_serveroptions.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_INACTIVE|QMF_GRAYED|QMF_HIDDEN;
ADDRGP4 s_serveroptions+6612+44
CNSTU4 28944
ASGNU4
line 2092
;2092:	s_serveroptions.next.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6612+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2093
;2093:	s_serveroptions.next.generic.id	      = ID_STARTSERVERNEXT;
ADDRGP4 s_serveroptions+6612+8
CNSTI4 18
ASGNI4
line 2094
;2094:	s_serveroptions.next.generic.x		  = 640;
ADDRGP4 s_serveroptions+6612+12
CNSTI4 640
ASGNI4
line 2095
;2095:	s_serveroptions.next.generic.y		  = 480-64-72;
ADDRGP4 s_serveroptions+6612+16
CNSTI4 344
ASGNI4
line 2096
;2096:	s_serveroptions.next.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+6612+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 2097
;2097:	s_serveroptions.next.width  		  = 128;
ADDRGP4 s_serveroptions+6612+76
CNSTI4 128
ASGNI4
line 2098
;2098:	s_serveroptions.next.height  		  = 64;
ADDRGP4 s_serveroptions+6612+80
CNSTI4 64
ASGNI4
line 2099
;2099:	s_serveroptions.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_serveroptions+6612+60
ADDRGP4 $488
ASGNP4
line 2101
;2100:
;2101:	s_serveroptions.go.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6524
CNSTI4 6
ASGNI4
line 2102
;2102:	s_serveroptions.go.generic.name     = GAMESERVER_FIGHT0;
ADDRGP4 s_serveroptions+6524+4
ADDRGP4 $1567
ASGNP4
line 2103
;2103:	s_serveroptions.go.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6524+44
CNSTU4 272
ASGNU4
line 2104
;2104:	s_serveroptions.go.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6524+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2105
;2105:	s_serveroptions.go.generic.id	    = ID_GO;
ADDRGP4 s_serveroptions+6524+8
CNSTI4 23
ASGNI4
line 2106
;2106:	s_serveroptions.go.generic.x		= 640;
ADDRGP4 s_serveroptions+6524+12
CNSTI4 640
ASGNI4
line 2107
;2107:	s_serveroptions.go.generic.y		= 480-64;
ADDRGP4 s_serveroptions+6524+16
CNSTI4 416
ASGNI4
line 2108
;2108:	s_serveroptions.go.width  		    = 128;
ADDRGP4 s_serveroptions+6524+76
CNSTI4 128
ASGNI4
line 2109
;2109:	s_serveroptions.go.height  		    = 64;
ADDRGP4 s_serveroptions+6524+80
CNSTI4 64
ASGNI4
line 2110
;2110:	s_serveroptions.go.focuspic         = GAMESERVER_FIGHT1;
ADDRGP4 s_serveroptions+6524+60
ADDRGP4 $1584
ASGNP4
line 2112
;2111:
;2112:	Menu_AddItem( &s_serveroptions.menu,&s_serveroptions.respawnTime );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3188
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2113
;2113:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.banner );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2114
;2114:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noMegaHealth );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2708
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2115
;2115:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noPersonalTeleporter );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2772
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2116
;2116:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.enableBlaster);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3028
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2117
;2117:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.mappic );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2118
;2118:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.picframe );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2120
;2119:
;2120:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.botSkill );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2088
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2121
;2121:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.player0 );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3284
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2122
;2122:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1594
line 2123
;2123:		if( n != 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1598
line 2124
;2124:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerType[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2125
;2125:		}
LABELV $1598
line 2126
;2126:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerName[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2127
;2127:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1602
line 2128
;2128:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerTeam[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2129
;2129:		}
LABELV $1602
line 2130
;2130:	}
LABELV $1595
line 2122
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1594
line 2132
;2131:
;2132:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.additionalSlots );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2184
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2133
;2133:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPowerups);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2134
;2134:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noHealth);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2580
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2135
;2135:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noArmor);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2644
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2136
;2136:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPlasmaBFG);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2836
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2137
;2137:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noGrenadeRocket);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2900
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2138
;2138:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noRailgun);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2140
;2139:	
;2140:	if( trap_Cvar_VariableValue("g_assaultMode") == 1 ) {
ADDRGP4 $242
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 1065353216
NEF4 $1613
line 2141
;2141:		Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.assaultMiddleItem
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3092
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2143
;2142:		);
;2143:	}
LABELV $1613
line 2145
;2144:		
;2145:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 4
EQI4 $1616
line 2146
;2146:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.fraglimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2147
;2147:	}
ADDRGP4 $1617
JUMPV
LABELV $1616
line 2148
;2148:	else {
line 2149
;2149:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.flaglimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1296
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2150
;2150:	}
LABELV $1617
line 2151
;2151:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.timelimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+632
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2152
;2152:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1622
line 2153
;2153:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.friendlyfire );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1628
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2154
;2154:	}
LABELV $1622
line 2155
;2155:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.pure );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2024
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2156
;2156:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1627
line 2157
;2157:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.dedicated );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2158
;2158:	}
LABELV $1627
line 2159
;2159:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1631
line 2160
;2160:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.hostname );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1692
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2161
;2161:	}
LABELV $1631
line 2163
;2162:
;2163:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.back );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6700
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2164
;2164:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.next );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6612
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2165
;2165:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.go );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6524
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2167
;2166:
;2167:	Menu_AddItem( &s_serveroptions.menu, (void*) &s_serveroptions.punkbuster );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+7044
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2170
;2168:	
;2169:	
;2170:	ServerOptions_SetMenuItems();
ADDRGP4 ServerOptions_SetMenuItems
CALLV
pop
line 2171
;2171:}
LABELV $1125
endproc ServerOptions_MenuInit 52 12
export ServerOptions_Cache
proc ServerOptions_Cache 0 4
line 2178
;2172:
;2173:/*
;2174:=================
;2175:ServerOptions_Cache
;2176:=================
;2177:*/
;2178:void ServerOptions_Cache( void ) {
line 2179
;2179:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );
ADDRGP4 $450
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2180
;2180:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );
ADDRGP4 $467
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2181
;2181:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT0 );
ADDRGP4 $1567
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2182
;2182:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT1 );
ADDRGP4 $1584
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2183
;2183:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );
ADDRGP4 $383
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2184
;2184:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $355
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2185
;2185:}
LABELV $1639
endproc ServerOptions_Cache 0 4
proc UI_ServerOptionsMenu 0 4
line 2193
;2186:
;2187:
;2188:/*
;2189:=================
;2190:UI_ServerOptionsMenu
;2191:=================
;2192:*/
;2193:static void UI_ServerOptionsMenu( qboolean multiplayer ) {
line 2194
;2194:	ServerOptions_MenuInit( multiplayer );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 ServerOptions_MenuInit
CALLV
pop
line 2195
;2195:	UI_PushMenu( &s_serveroptions.menu );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2196
;2196:}
LABELV $1640
endproc UI_ServerOptionsMenu 0 4
proc UI_BotSelectMenu_SortCompare 44 8
line 2257
;2197:
;2198:
;2199:
;2200:/*
;2201:=============================================================================
;2202:
;2203:BOT SELECT MENU *****
;2204:
;2205:=============================================================================
;2206:*/
;2207:
;2208:
;2209:#define BOTSELECT_BACK0			"menu/art/back_0"
;2210:#define BOTSELECT_BACK1			"menu/art/back_1"
;2211:#define BOTSELECT_ACCEPT0		"menu/art/accept_0"
;2212:#define BOTSELECT_ACCEPT1		"menu/art/accept_1"
;2213:#define BOTSELECT_SELECT		"menu/art/opponents_select"
;2214:#define BOTSELECT_SELECTED		"menu/art/opponents_selected"
;2215:#define BOTSELECT_ARROWS		"menu/art/gs_arrows_0"
;2216:#define BOTSELECT_ARROWSL		"menu/art/gs_arrows_l"
;2217:#define BOTSELECT_ARROWSR		"menu/art/gs_arrows_r"
;2218:
;2219:#define PLAYERGRID_COLS			4
;2220:#define PLAYERGRID_ROWS			4
;2221:#define MAX_MODELSPERPAGE		(PLAYERGRID_ROWS * PLAYERGRID_COLS)
;2222:
;2223:
;2224:typedef struct {
;2225:	menuframework_s	menu;
;2226:
;2227:	menutext_s		banner;
;2228:
;2229:	menubitmap_s	pics[MAX_MODELSPERPAGE];
;2230:	menubitmap_s	picbuttons[MAX_MODELSPERPAGE];
;2231:	menutext_s		picnames[MAX_MODELSPERPAGE];
;2232:
;2233:	menubitmap_s	arrows;
;2234:	menubitmap_s	left;
;2235:	menubitmap_s	right;
;2236:
;2237:	menubitmap_s	go;
;2238:	menubitmap_s	back;
;2239:
;2240:	int				numBots;
;2241:	int				modelpage;
;2242:	int				numpages;
;2243:	int				selectedmodel;
;2244:	int				sortedBotNums[MAX_BOTS];
;2245:	char			boticons[MAX_MODELSPERPAGE][MAX_QPATH];
;2246:	char			botnames[MAX_MODELSPERPAGE][16];
;2247:} botSelectInfo_t;
;2248:
;2249:static botSelectInfo_t	botSelectInfo;
;2250:
;2251:
;2252:/*
;2253:=================
;2254:UI_BotSelectMenu_SortCompare
;2255:=================
;2256:*/
;2257:static int QDECL UI_BotSelectMenu_SortCompare( const void *arg1, const void *arg2 ) {
line 2262
;2258:	int			num1, num2;
;2259:	const char	*info1, *info2;
;2260:	const char	*name1, *name2;
;2261:
;2262:	num1 = *(int *)arg1;
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 2263
;2263:	num2 = *(int *)arg2;
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
line 2265
;2264:
;2265:	info1 = UI_GetBotInfoByNumber( num1 );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 UI_GetBotInfoByNumber
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 24
INDIRP4
ASGNP4
line 2266
;2266:	info2 = UI_GetBotInfoByNumber( num2 );
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 28
ADDRGP4 UI_GetBotInfoByNumber
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 28
INDIRP4
ASGNP4
line 2268
;2267:
;2268:	name1 = Info_ValueForKey( info1, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $802
ARGP4
ADDRLP4 32
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 2269
;2269:	name2 = Info_ValueForKey( info2, "name" );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 $802
ARGP4
ADDRLP4 36
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 36
INDIRP4
ASGNP4
line 2271
;2270:
;2271:	return Q_stricmp( name1, name2 );
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 40
INDIRI4
RETI4
LABELV $1642
endproc UI_BotSelectMenu_SortCompare 44 8
proc UI_BotSelectMenu_BuildList 12 16
line 2280
;2272:}
;2273:
;2274:
;2275:/*
;2276:=================
;2277:UI_BotSelectMenu_BuildList
;2278:=================
;2279:*/
;2280:static void UI_BotSelectMenu_BuildList( void ) {
line 2283
;2281:	int		n;
;2282:
;2283:	botSelectInfo.modelpage = 0;
ADDRGP4 botSelectInfo+4772
CNSTI4 0
ASGNI4
line 2284
;2284:	botSelectInfo.numBots = UI_GetNumBots();
ADDRLP4 4
ADDRGP4 UI_GetNumBots
CALLI4
ASGNI4
ADDRGP4 botSelectInfo+4768
ADDRLP4 4
INDIRI4
ASGNI4
line 2285
;2285:	botSelectInfo.numpages = botSelectInfo.numBots / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4776
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2286
;2286:	if( botSelectInfo.numBots % MAX_MODELSPERPAGE ) {
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
MODI4
CNSTI4 0
EQI4 $1648
line 2287
;2287:		botSelectInfo.numpages++;
ADDRLP4 8
ADDRGP4 botSelectInfo+4776
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 2288
;2288:	}
LABELV $1648
line 2291
;2289:
;2290:	// initialize the array
;2291:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1655
JUMPV
LABELV $1652
line 2292
;2292:		botSelectInfo.sortedBotNums[n] = n;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2293
;2293:	}
LABELV $1653
line 2291
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1655
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1652
line 2296
;2294:
;2295:	// now sort it
;2296:	qsort( botSelectInfo.sortedBotNums, botSelectInfo.numBots, sizeof(botSelectInfo.sortedBotNums[0]), UI_BotSelectMenu_SortCompare );
ADDRGP4 botSelectInfo+4784
ARGP4
ADDRGP4 botSelectInfo+4768
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRGP4 UI_BotSelectMenu_SortCompare
ARGP4
ADDRGP4 qsort
CALLV
pop
line 2297
;2297:}
LABELV $1643
endproc UI_BotSelectMenu_BuildList 12 16
proc ServerPlayerIcon 80 20
line 2305
;2298:
;2299:
;2300:/*
;2301:=================
;2302:ServerPlayerIcon
;2303:=================
;2304:*/
;2305:static void ServerPlayerIcon( const char *modelAndSkin, char *iconName, int iconNameMaxSize ) {
line 2309
;2306:	char	*skin;
;2307:	char	model[MAX_QPATH];
;2308:
;2309:	Q_strncpyz( model, modelAndSkin, sizeof(model));
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 2310
;2310:	skin = Q_strrchr( model, '/' );
ADDRLP4 4
ARGP4
CNSTI4 47
ARGI4
ADDRLP4 68
ADDRGP4 Q_strrchr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 68
INDIRP4
ASGNP4
line 2311
;2311:	if ( skin ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1662
line 2312
;2312:		*skin++ = '\0';
ADDRLP4 72
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 72
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 72
INDIRP4
CNSTI1 0
ASGNI1
line 2313
;2313:	}
ADDRGP4 $1663
JUMPV
LABELV $1662
line 2314
;2314:	else {
line 2315
;2315:		skin = "default";
ADDRLP4 0
ADDRGP4 $1664
ASGNP4
line 2316
;2316:	}
LABELV $1663
line 2318
;2317:
;2318:	Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_%s.tga", model, skin );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1665
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2320
;2319:
;2320:	if( !trap_R_RegisterShaderNoMip( iconName ) && Q_stricmp( skin, "default" ) != 0 ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 72
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
NEI4 $1666
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $1664
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $1666
line 2321
;2321:		Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_default.tga", model );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1668
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2322
;2322:	}
LABELV $1666
line 2323
;2323:}
LABELV $1661
endproc ServerPlayerIcon 80 20
proc UI_BotSelectMenu_UpdateGrid 36 12
line 2331
;2324:
;2325:
;2326:/*
;2327:=================
;2328:UI_BotSelectMenu_UpdateGrid
;2329:=================
;2330:*/
;2331:static void UI_BotSelectMenu_UpdateGrid( void ) {
line 2336
;2332:	const char	*info;
;2333:	int			i;
;2334:    int			j;
;2335:
;2336:	j = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRLP4 4
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2337
;2337:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++, j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1671
line 2338
;2338:		if( j < botSelectInfo.numBots ) { 
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
GEI4 $1675
line 2339
;2339:			info = UI_GetBotInfoByNumber( botSelectInfo.sortedBotNums[j] );
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 UI_GetBotInfoByNumber
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 12
INDIRP4
ASGNP4
line 2340
;2340:			ServerPlayerIcon( Info_ValueForKey( info, "model" ), botSelectInfo.boticons[i], MAX_QPATH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $1679
ARGP4
ADDRLP4 16
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 botSelectInfo+8880
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 ServerPlayerIcon
CALLV
pop
line 2341
;2341:			Q_strncpyz( botSelectInfo.botnames[i], Info_ValueForKey( info, "name" ), 16 );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $802
ARGP4
ADDRLP4 20
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
ARGP4
ADDRLP4 20
INDIRP4
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 2342
;2342:			Q_CleanStr( botSelectInfo.botnames[i] );
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 2343
;2343: 			botSelectInfo.pics[i].generic.name = botSelectInfo.boticons[i];
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 botSelectInfo+8880
ADDP4
ASGNP4
line 2344
;2344:			if( BotAlreadySelected( botSelectInfo.botnames[i] ) ) {
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
ARGP4
ADDRLP4 28
ADDRGP4 BotAlreadySelected
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
EQI4 $1686
line 2345
;2345:				botSelectInfo.picnames[i].color = color_red;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_red
ASGNP4
line 2346
;2346:			}
ADDRGP4 $1687
JUMPV
LABELV $1686
line 2347
;2347:			else {
line 2348
;2348:				botSelectInfo.picnames[i].color = color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2349
;2349:			}
LABELV $1687
line 2350
;2350:			botSelectInfo.picbuttons[i].generic.flags &= ~QMF_INACTIVE;
ADDRLP4 32
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
ASGNP4
ADDRLP4 32
INDIRP4
ADDRLP4 32
INDIRP4
INDIRU4
CNSTU4 4294950911
BANDU4
ASGNU4
line 2351
;2351:		}
ADDRGP4 $1676
JUMPV
LABELV $1675
line 2352
;2352:		else {
line 2354
;2353:			// dead slot
;2354: 			botSelectInfo.pics[i].generic.name         = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
CNSTP4 0
ASGNP4
line 2355
;2355:			botSelectInfo.picbuttons[i].generic.flags |= QMF_INACTIVE;
ADDRLP4 12
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 2356
;2356:			botSelectInfo.botnames[i][0] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
CNSTI1 0
ASGNI1
line 2357
;2357:		}
LABELV $1676
line 2359
;2358:
;2359: 		botSelectInfo.pics[i].generic.flags       &= ~QMF_HIGHLIGHT;
ADDRLP4 12
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRU4
CNSTU4 4294967231
BANDU4
ASGNU4
line 2360
;2360: 		botSelectInfo.pics[i].shader               = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+68
ADDP4
CNSTI4 0
ASGNI4
line 2361
;2361: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
ADDRLP4 16
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRU4
CNSTU4 256
BORU4
ASGNU4
line 2362
;2362:	}
LABELV $1672
line 2337
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
ASGNI4
ADDRLP4 4
ADDRLP4 4
INDIRI4
ADDRLP4 12
INDIRI4
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $1671
line 2365
;2363:
;2364:	// set selected model
;2365:	i = botSelectInfo.selectedmodel % MAX_MODELSPERPAGE;
ADDRLP4 0
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
MODI4
ASGNI4
line 2366
;2366:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
ADDRLP4 16
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRU4
CNSTU4 64
BORU4
ASGNU4
line 2367
;2367:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
ADDRLP4 20
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRU4
CNSTU4 4294967039
BANDU4
ASGNU4
line 2369
;2368:
;2369:	if( botSelectInfo.numpages > 1 ) {
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
LEI4 $1711
line 2370
;2370:		if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1714
line 2371
;2371:			botSelectInfo.left.generic.flags &= ~QMF_INACTIVE;
ADDRLP4 24
ADDRGP4 botSelectInfo+4416+44
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRU4
CNSTU4 4294950911
BANDU4
ASGNU4
line 2372
;2372:		}
ADDRGP4 $1715
JUMPV
LABELV $1714
line 2373
;2373:		else {
line 2374
;2374:			botSelectInfo.left.generic.flags |= QMF_INACTIVE;
ADDRLP4 24
ADDRGP4 botSelectInfo+4416+44
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 2375
;2375:		}
LABELV $1715
line 2377
;2376:
;2377:		if( botSelectInfo.modelpage < (botSelectInfo.numpages - 1) ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1721
line 2378
;2378:			botSelectInfo.right.generic.flags &= ~QMF_INACTIVE;
ADDRLP4 24
ADDRGP4 botSelectInfo+4504+44
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRU4
CNSTU4 4294950911
BANDU4
ASGNU4
line 2379
;2379:		}
ADDRGP4 $1712
JUMPV
LABELV $1721
line 2380
;2380:		else {
line 2381
;2381:			botSelectInfo.right.generic.flags |= QMF_INACTIVE;
ADDRLP4 24
ADDRGP4 botSelectInfo+4504+44
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 2382
;2382:		}
line 2383
;2383:	}
ADDRGP4 $1712
JUMPV
LABELV $1711
line 2384
;2384:	else {
line 2386
;2385:		// hide left/right markers
;2386:		botSelectInfo.left.generic.flags |= QMF_INACTIVE;
ADDRLP4 24
ADDRGP4 botSelectInfo+4416+44
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 2387
;2387:		botSelectInfo.right.generic.flags |= QMF_INACTIVE;
ADDRLP4 28
ADDRGP4 botSelectInfo+4504+44
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 2388
;2388:	}
LABELV $1712
line 2389
;2389:}
LABELV $1669
endproc UI_BotSelectMenu_UpdateGrid 36 12
proc UI_BotSelectMenu_Default 28 8
line 2397
;2390:
;2391:
;2392:/*
;2393:=================
;2394:UI_BotSelectMenu_Default
;2395:=================
;2396:*/
;2397:static void UI_BotSelectMenu_Default( char *bot ) {
line 2403
;2398:	const char	*botInfo;
;2399:	const char	*test;
;2400:	int			n;
;2401:	int			i;
;2402:
;2403:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1737
JUMPV
LABELV $1734
line 2404
;2404:		botInfo = UI_GetBotInfoByNumber( n );
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 UI_GetBotInfoByNumber
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 16
INDIRP4
ASGNP4
line 2405
;2405:		test = Info_ValueForKey( botInfo, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $802
ARGP4
ADDRLP4 20
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
line 2406
;2406:		if( Q_stricmp( bot, test ) == 0 ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $1739
line 2407
;2407:			break;
ADDRGP4 $1736
JUMPV
LABELV $1739
line 2409
;2408:		}
;2409:	}
LABELV $1735
line 2403
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1737
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1734
LABELV $1736
line 2410
;2410:	if( n == botSelectInfo.numBots ) {
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1741
line 2411
;2411:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2412
;2412:		return;
ADDRGP4 $1733
JUMPV
LABELV $1741
line 2415
;2413:	}
;2414:
;2415:	for( i = 0; i < botSelectInfo.numBots; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1748
JUMPV
LABELV $1745
line 2416
;2416:		if( botSelectInfo.sortedBotNums[i] == n ) {
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1750
line 2417
;2417:			break;
ADDRGP4 $1747
JUMPV
LABELV $1750
line 2419
;2418:		}
;2419:	}
LABELV $1746
line 2415
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1748
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1745
LABELV $1747
line 2420
;2420:	if( i == botSelectInfo.numBots ) {
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1753
line 2421
;2421:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2422
;2422:		return;
ADDRGP4 $1733
JUMPV
LABELV $1753
line 2425
;2423:	}
;2424:
;2425:	botSelectInfo.selectedmodel = i;
ADDRGP4 botSelectInfo+4780
ADDRLP4 4
INDIRI4
ASGNI4
line 2426
;2426:}
LABELV $1733
endproc UI_BotSelectMenu_Default 28 8
proc UI_BotSelectMenu_LeftEvent 4 0
line 2434
;2427:
;2428:
;2429:/*
;2430:=================
;2431:UI_BotSelectMenu_LeftEvent
;2432:=================
;2433:*/
;2434:static void UI_BotSelectMenu_LeftEvent( void* ptr, int event ) {
line 2435
;2435:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1759
line 2436
;2436:		return;
ADDRGP4 $1758
JUMPV
LABELV $1759
line 2438
;2437:	}
;2438:	if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1761
line 2439
;2439:		botSelectInfo.modelpage--;
ADDRLP4 0
ADDRGP4 botSelectInfo+4772
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 2440
;2440:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2441
;2441:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2442
;2442:	}
LABELV $1761
line 2443
;2443:}
LABELV $1758
endproc UI_BotSelectMenu_LeftEvent 4 0
proc UI_BotSelectMenu_RightEvent 4 0
line 2451
;2444:
;2445:
;2446:/*
;2447:=================
;2448:UI_BotSelectMenu_RightEvent
;2449:=================
;2450:*/
;2451:static void UI_BotSelectMenu_RightEvent( void* ptr, int event ) {
line 2452
;2452:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1768
line 2453
;2453:		return;
ADDRGP4 $1767
JUMPV
LABELV $1768
line 2455
;2454:	}
;2455:	if( botSelectInfo.modelpage < botSelectInfo.numpages - 1 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1770
line 2456
;2456:		botSelectInfo.modelpage++;
ADDRLP4 0
ADDRGP4 botSelectInfo+4772
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 2457
;2457:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2458
;2458:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2459
;2459:	}
LABELV $1770
line 2460
;2460:}
LABELV $1767
endproc UI_BotSelectMenu_RightEvent 4 0
proc UI_BotSelectMenu_BotEvent 12 0
line 2468
;2461:
;2462:
;2463:/*
;2464:=================
;2465:UI_BotSelectMenu_BotEvent
;2466:=================
;2467:*/
;2468:static void UI_BotSelectMenu_BotEvent( void* ptr, int event ) {
line 2471
;2469:	int		i;
;2470:
;2471:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1778
line 2472
;2472:		return;
ADDRGP4 $1777
JUMPV
LABELV $1778
line 2475
;2473:	}
;2474:
;2475:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1780
line 2476
;2476: 		botSelectInfo.pics[i].generic.flags &= ~QMF_HIGHLIGHT;
ADDRLP4 4
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRU4
CNSTU4 4294967231
BANDU4
ASGNU4
line 2477
;2477: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
ADDRLP4 8
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 256
BORU4
ASGNU4
line 2478
;2478:	}
LABELV $1781
line 2475
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $1780
line 2481
;2479:
;2480:	// set selected
;2481:	i = ((menucommon_s*)ptr)->id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 2482
;2482:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
ADDRLP4 4
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRU4
CNSTU4 64
BORU4
ASGNU4
line 2483
;2483:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
ADDRLP4 8
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294967039
BANDU4
ASGNU4
line 2484
;2484:	botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE + i;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ADDRLP4 0
INDIRI4
ADDI4
ASGNI4
line 2485
;2485:}
LABELV $1777
endproc UI_BotSelectMenu_BotEvent 12 0
proc UI_BotSelectMenu_BackEvent 0 0
line 2493
;2486:
;2487:
;2488:/*
;2489:=================
;2490:UI_BotSelectMenu_BackEvent
;2491:=================
;2492:*/
;2493:static void UI_BotSelectMenu_BackEvent( void* ptr, int event ) {
line 2494
;2494:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1795
line 2495
;2495:		return;
ADDRGP4 $1794
JUMPV
LABELV $1795
line 2497
;2496:	}
;2497:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2498
;2498:}
LABELV $1794
endproc UI_BotSelectMenu_BackEvent 0 0
proc UI_BotSelectMenu_SelectEvent 4 12
line 2506
;2499:
;2500:
;2501:/*
;2502:=================
;2503:UI_BotSelectMenu_SelectEvent
;2504:=================
;2505:*/
;2506:static void UI_BotSelectMenu_SelectEvent( void* ptr, int event ) {
line 2507
;2507:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1798
line 2508
;2508:		return;
ADDRGP4 $1797
JUMPV
LABELV $1798
line 2510
;2509:	}
;2510:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2512
;2511:
;2512:	s_serveroptions.newBot = qtrue;
ADDRGP4 s_serveroptions+7020
CNSTI4 1
ASGNI4
line 2513
;2513:	Q_strncpyz( s_serveroptions.newBotName, botSelectInfo.botnames[botSelectInfo.selectedmodel % MAX_MODELSPERPAGE], 16 );
ADDRGP4 s_serveroptions+7028
ARGP4
ADDRLP4 0
CNSTI4 16
ASGNI4
ADDRGP4 botSelectInfo+4780
INDIRI4
ADDRLP4 0
INDIRI4
MODI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 2514
;2514:}
LABELV $1797
endproc UI_BotSelectMenu_SelectEvent 4 12
export UI_BotSelectMenu_Cache
proc UI_BotSelectMenu_Cache 0 4
line 2522
;2515:
;2516:
;2517:/*
;2518:=================
;2519:UI_BotSelectMenu_Cache
;2520:=================
;2521:*/
;2522:void UI_BotSelectMenu_Cache( void ) {
line 2523
;2523:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK0 );
ADDRGP4 $450
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2524
;2524:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK1 );
ADDRGP4 $467
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2525
;2525:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT0 );
ADDRGP4 $1805
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2526
;2526:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT1 );
ADDRGP4 $1806
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2527
;2527:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECT );
ADDRGP4 $1807
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2528
;2528:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECTED );
ADDRGP4 $1808
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2529
;2529:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWS );
ADDRGP4 $387
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2530
;2530:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSL );
ADDRGP4 $415
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2531
;2531:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSR );
ADDRGP4 $433
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2532
;2532:}
LABELV $1804
endproc UI_BotSelectMenu_Cache 0 4
proc UI_BotSelectMenu_Init 36 12
line 2535
;2533:
;2534:
;2535:static void UI_BotSelectMenu_Init( char *bot ) {
line 2539
;2536:	int		i, j, k;
;2537:	int		x, y;
;2538:
;2539:	memset( &botSelectInfo, 0 ,sizeof(botSelectInfo) );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 0
ARGI4
CNSTI4 10160
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2540
;2540:	botSelectInfo.menu.wrapAround = qtrue;
ADDRGP4 botSelectInfo+276
CNSTI4 1
ASGNI4
line 2541
;2541:	botSelectInfo.menu.fullscreen = qtrue;
ADDRGP4 botSelectInfo+280
CNSTI4 1
ASGNI4
line 2543
;2542:
;2543:	UI_BotSelectMenu_Cache();
ADDRGP4 UI_BotSelectMenu_Cache
CALLV
pop
line 2545
;2544:
;2545:	botSelectInfo.banner.generic.type	= MTYPE_BTEXT;
ADDRGP4 botSelectInfo+288
CNSTI4 10
ASGNI4
line 2546
;2546:	botSelectInfo.banner.generic.x		= 320;
ADDRGP4 botSelectInfo+288+12
CNSTI4 320
ASGNI4
line 2547
;2547:	botSelectInfo.banner.generic.y		= 16;
ADDRGP4 botSelectInfo+288+16
CNSTI4 16
ASGNI4
line 2548
;2548:	botSelectInfo.banner.string			= "SELECT BOT";
ADDRGP4 botSelectInfo+288+60
ADDRGP4 $1819
ASGNP4
line 2549
;2549:	botSelectInfo.banner.color			= color_white;
ADDRGP4 botSelectInfo+288+68
ADDRGP4 color_white
ASGNP4
line 2550
;2550:	botSelectInfo.banner.style			= UI_CENTER;
ADDRGP4 botSelectInfo+288+64
CNSTI4 1
ASGNI4
line 2552
;2551:
;2552:	y =	80;
ADDRLP4 8
CNSTI4 80
ASGNI4
line 2553
;2553:	for( i = 0, k = 0; i < PLAYERGRID_ROWS; i++) {
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 20
INDIRI4
ASGNI4
ADDRGP4 $1827
JUMPV
LABELV $1824
line 2554
;2554:		x =	180;
ADDRLP4 4
CNSTI4 180
ASGNI4
line 2555
;2555:		for( j = 0; j < PLAYERGRID_COLS; j++, k++ ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $1828
line 2556
;2556:			botSelectInfo.pics[k].generic.type				= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360
ADDP4
CNSTI4 6
ASGNI4
line 2557
;2557:			botSelectInfo.pics[k].generic.flags				= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
CNSTU4 16388
ASGNU4
line 2558
;2558:			botSelectInfo.pics[k].generic.x					= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2559
;2559:			botSelectInfo.pics[k].generic.y					= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2560
;2560: 			botSelectInfo.pics[k].generic.name				= botSelectInfo.boticons[k];
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 botSelectInfo+8880
ADDP4
ASGNP4
line 2561
;2561:			botSelectInfo.pics[k].width						= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+76
ADDP4
CNSTI4 64
ASGNI4
line 2562
;2562:			botSelectInfo.pics[k].height					= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+80
ADDP4
CNSTI4 64
ASGNI4
line 2563
;2563:			botSelectInfo.pics[k].focuspic					= BOTSELECT_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+60
ADDP4
ADDRGP4 $1808
ASGNP4
line 2564
;2564:			botSelectInfo.pics[k].focuscolor				= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2566
;2565:
;2566:			botSelectInfo.picbuttons[k].generic.type		= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768
ADDP4
CNSTI4 6
ASGNI4
line 2567
;2567:			botSelectInfo.picbuttons[k].generic.flags		= QMF_LEFT_JUSTIFY|QMF_NODEFAULTINIT|QMF_PULSEIFFOCUS;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
CNSTU4 33028
ASGNU4
line 2568
;2568:			botSelectInfo.picbuttons[k].generic.callback	= UI_BotSelectMenu_BotEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+48
ADDP4
ADDRGP4 UI_BotSelectMenu_BotEvent
ASGNP4
line 2569
;2569:			botSelectInfo.picbuttons[k].generic.id			= k;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2570
;2570:			botSelectInfo.picbuttons[k].generic.x			= x - 16;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+12
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 16
SUBI4
ASGNI4
line 2571
;2571:			botSelectInfo.picbuttons[k].generic.y			= y - 16;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+16
ADDP4
ADDRLP4 8
INDIRI4
CNSTI4 16
SUBI4
ASGNI4
line 2572
;2572:			botSelectInfo.picbuttons[k].generic.left		= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2573
;2573:			botSelectInfo.picbuttons[k].generic.top			= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2574
;2574:			botSelectInfo.picbuttons[k].generic.right		= x + 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+28
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 64
ADDI4
ASGNI4
line 2575
;2575:			botSelectInfo.picbuttons[k].generic.bottom		= y + 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+32
ADDP4
ADDRLP4 8
INDIRI4
CNSTI4 64
ADDI4
ASGNI4
line 2576
;2576:			botSelectInfo.picbuttons[k].width				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+76
ADDP4
CNSTI4 128
ASGNI4
line 2577
;2577:			botSelectInfo.picbuttons[k].height				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+80
ADDP4
CNSTI4 128
ASGNI4
line 2578
;2578:			botSelectInfo.picbuttons[k].focuspic			= BOTSELECT_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+60
ADDP4
ADDRGP4 $1807
ASGNP4
line 2579
;2579:			botSelectInfo.picbuttons[k].focuscolor			= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2581
;2580:
;2581:			botSelectInfo.picnames[k].generic.type			= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176
ADDP4
CNSTI4 7
ASGNI4
line 2582
;2582:			botSelectInfo.picnames[k].generic.flags			= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+44
ADDP4
CNSTU4 2
ASGNU4
line 2583
;2583:			botSelectInfo.picnames[k].generic.x				= x + 32;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+12
ADDP4
ADDRLP4 4
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 2584
;2584:			botSelectInfo.picnames[k].generic.y				= y + 64;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+16
ADDP4
ADDRLP4 8
INDIRI4
CNSTI4 64
ADDI4
ASGNI4
line 2585
;2585:			botSelectInfo.picnames[k].string				= botSelectInfo.botnames[k];
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+60
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
ASGNP4
line 2586
;2586:			botSelectInfo.picnames[k].color					= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2587
;2587:			botSelectInfo.picnames[k].style					= UI_CENTER|UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+64
ADDP4
CNSTI4 17
ASGNI4
line 2589
;2588:
;2589:			x += (64 + 6);
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 70
ADDI4
ASGNI4
line 2590
;2590:		}
LABELV $1829
line 2555
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRLP4 12
ADDRLP4 12
INDIRI4
ADDRLP4 24
INDIRI4
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
ADDI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 4
LTI4 $1828
line 2591
;2591:		y += (64 + SMALLCHAR_HEIGHT + 6);
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 86
ADDI4
ASGNI4
line 2592
;2592:	}
LABELV $1825
line 2553
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1827
ADDRLP4 16
INDIRI4
CNSTI4 4
LTI4 $1824
line 2594
;2593:
;2594:	botSelectInfo.arrows.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4328
CNSTI4 6
ASGNI4
line 2595
;2595:	botSelectInfo.arrows.generic.name		= BOTSELECT_ARROWS;
ADDRGP4 botSelectInfo+4328+4
ADDRGP4 $387
ASGNP4
line 2596
;2596:	botSelectInfo.arrows.generic.flags		= QMF_INACTIVE;
ADDRGP4 botSelectInfo+4328+44
CNSTU4 16384
ASGNU4
line 2597
;2597:	botSelectInfo.arrows.generic.x			= 260;
ADDRGP4 botSelectInfo+4328+12
CNSTI4 260
ASGNI4
line 2598
;2598:	botSelectInfo.arrows.generic.y			= 440;
ADDRGP4 botSelectInfo+4328+16
CNSTI4 440
ASGNI4
line 2599
;2599:	botSelectInfo.arrows.width				= 128;
ADDRGP4 botSelectInfo+4328+76
CNSTI4 128
ASGNI4
line 2600
;2600:	botSelectInfo.arrows.height				= 32;
ADDRGP4 botSelectInfo+4328+80
CNSTI4 32
ASGNI4
line 2602
;2601:
;2602:	botSelectInfo.left.generic.type			= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4416
CNSTI4 6
ASGNI4
line 2603
;2603:	botSelectInfo.left.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4416+44
CNSTU4 260
ASGNU4
line 2604
;2604:	botSelectInfo.left.generic.callback		= UI_BotSelectMenu_LeftEvent;
ADDRGP4 botSelectInfo+4416+48
ADDRGP4 UI_BotSelectMenu_LeftEvent
ASGNP4
line 2605
;2605:	botSelectInfo.left.generic.x			= 260;
ADDRGP4 botSelectInfo+4416+12
CNSTI4 260
ASGNI4
line 2606
;2606:	botSelectInfo.left.generic.y			= 440;
ADDRGP4 botSelectInfo+4416+16
CNSTI4 440
ASGNI4
line 2607
;2607:	botSelectInfo.left.width  				= 64;
ADDRGP4 botSelectInfo+4416+76
CNSTI4 64
ASGNI4
line 2608
;2608:	botSelectInfo.left.height  				= 32;
ADDRGP4 botSelectInfo+4416+80
CNSTI4 32
ASGNI4
line 2609
;2609:	botSelectInfo.left.focuspic				= BOTSELECT_ARROWSL;
ADDRGP4 botSelectInfo+4416+60
ADDRGP4 $415
ASGNP4
line 2611
;2610:
;2611:	botSelectInfo.right.generic.type	    = MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4504
CNSTI4 6
ASGNI4
line 2612
;2612:	botSelectInfo.right.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4504+44
CNSTU4 260
ASGNU4
line 2613
;2613:	botSelectInfo.right.generic.callback	= UI_BotSelectMenu_RightEvent;
ADDRGP4 botSelectInfo+4504+48
ADDRGP4 UI_BotSelectMenu_RightEvent
ASGNP4
line 2614
;2614:	botSelectInfo.right.generic.x			= 321;
ADDRGP4 botSelectInfo+4504+12
CNSTI4 321
ASGNI4
line 2615
;2615:	botSelectInfo.right.generic.y			= 440;
ADDRGP4 botSelectInfo+4504+16
CNSTI4 440
ASGNI4
line 2616
;2616:	botSelectInfo.right.width  				= 64;
ADDRGP4 botSelectInfo+4504+76
CNSTI4 64
ASGNI4
line 2617
;2617:	botSelectInfo.right.height  		    = 32;
ADDRGP4 botSelectInfo+4504+80
CNSTI4 32
ASGNI4
line 2618
;2618:	botSelectInfo.right.focuspic			= BOTSELECT_ARROWSR;
ADDRGP4 botSelectInfo+4504+60
ADDRGP4 $433
ASGNP4
line 2620
;2619:
;2620:	botSelectInfo.back.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4680
CNSTI4 6
ASGNI4
line 2621
;2621:	botSelectInfo.back.generic.name		= BOTSELECT_BACK0;
ADDRGP4 botSelectInfo+4680+4
ADDRGP4 $450
ASGNP4
line 2622
;2622:	botSelectInfo.back.generic.flags	= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4680+44
CNSTU4 260
ASGNU4
line 2623
;2623:	botSelectInfo.back.generic.callback	= UI_BotSelectMenu_BackEvent;
ADDRGP4 botSelectInfo+4680+48
ADDRGP4 UI_BotSelectMenu_BackEvent
ASGNP4
line 2624
;2624:	botSelectInfo.back.generic.x		= 0;
ADDRGP4 botSelectInfo+4680+12
CNSTI4 0
ASGNI4
line 2625
;2625:	botSelectInfo.back.generic.y		= 480-64;
ADDRGP4 botSelectInfo+4680+16
CNSTI4 416
ASGNI4
line 2626
;2626:	botSelectInfo.back.width			= 128;
ADDRGP4 botSelectInfo+4680+76
CNSTI4 128
ASGNI4
line 2627
;2627:	botSelectInfo.back.height			= 64;
ADDRGP4 botSelectInfo+4680+80
CNSTI4 64
ASGNI4
line 2628
;2628:	botSelectInfo.back.focuspic			= BOTSELECT_BACK1;
ADDRGP4 botSelectInfo+4680+60
ADDRGP4 $467
ASGNP4
line 2630
;2629:
;2630:	botSelectInfo.go.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4592
CNSTI4 6
ASGNI4
line 2631
;2631:	botSelectInfo.go.generic.name		= BOTSELECT_ACCEPT0;
ADDRGP4 botSelectInfo+4592+4
ADDRGP4 $1805
ASGNP4
line 2632
;2632:	botSelectInfo.go.generic.flags		= QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4592+44
CNSTU4 272
ASGNU4
line 2633
;2633:	botSelectInfo.go.generic.callback	= UI_BotSelectMenu_SelectEvent;
ADDRGP4 botSelectInfo+4592+48
ADDRGP4 UI_BotSelectMenu_SelectEvent
ASGNP4
line 2634
;2634:	botSelectInfo.go.generic.x			= 640;
ADDRGP4 botSelectInfo+4592+12
CNSTI4 640
ASGNI4
line 2635
;2635:	botSelectInfo.go.generic.y			= 480-64;
ADDRGP4 botSelectInfo+4592+16
CNSTI4 416
ASGNI4
line 2636
;2636:	botSelectInfo.go.width				= 128;
ADDRGP4 botSelectInfo+4592+76
CNSTI4 128
ASGNI4
line 2637
;2637:	botSelectInfo.go.height				= 64;
ADDRGP4 botSelectInfo+4592+80
CNSTI4 64
ASGNI4
line 2638
;2638:	botSelectInfo.go.focuspic			= BOTSELECT_ACCEPT1;
ADDRGP4 botSelectInfo+4592+60
ADDRGP4 $1806
ASGNP4
line 2640
;2639:
;2640:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.banner );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2641
;2641:	for( i = 0; i < MAX_MODELSPERPAGE; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1969
line 2642
;2642:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.pics[i] );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 88
ADDRLP4 16
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2643
;2643:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picbuttons[i] );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 88
ADDRLP4 16
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2644
;2644:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picnames[i] );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 72
ADDRLP4 16
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2645
;2645:	}
LABELV $1970
line 2641
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 16
LTI4 $1969
line 2646
;2646:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.arrows );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4328
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2647
;2647:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.left );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4416
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2648
;2648:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.right );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4504
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2649
;2649:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.back );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4680
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2650
;2650:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.go );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4592
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2652
;2651:
;2652:	UI_BotSelectMenu_BuildList();
ADDRGP4 UI_BotSelectMenu_BuildList
CALLV
pop
line 2653
;2653:	UI_BotSelectMenu_Default( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Default
CALLV
pop
line 2654
;2654:	botSelectInfo.modelpage = botSelectInfo.selectedmodel / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4772
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2655
;2655:	UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2656
;2656:}
LABELV $1809
endproc UI_BotSelectMenu_Init 36 12
export UI_BotSelectMenu
proc UI_BotSelectMenu 0 4
line 2664
;2657:
;2658:
;2659:/*
;2660:=================
;2661:UI_BotSelectMenu
;2662:=================
;2663:*/
;2664:void UI_BotSelectMenu( char *bot ) {
line 2665
;2665:	UI_BotSelectMenu_Init( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Init
CALLV
pop
line 2666
;2666:	UI_PushMenu( &botSelectInfo.menu );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2667
;2667:}
LABELV $1983
endproc UI_BotSelectMenu 0 4
bss
align 4
LABELV botSelectInfo
skip 10160
align 4
LABELV s_serveroptions
skip 7140
import punkbuster_items
align 4
LABELV s_startserver
skip 3236
import UI_RankStatusMenu
import RankStatus_Cache
import UI_SignupMenu
import Signup_Cache
import UI_LoginMenu
import Login_Cache
import UI_RankingsMenu
import Rankings_Cache
import Rankings_DrawPassword
import Rankings_DrawName
import Rankings_DrawText
import UI_InitGameinfo
import UI_SPUnlockMedals_f
import UI_SPUnlock_f
import UI_GetAwardLevel
import UI_LogAwardData
import UI_NewGame
import UI_GetCurrentGame
import UI_CanShowTierVideo
import UI_ShowTierVideo
import UI_TierCompleted
import UI_SetBestScore
import UI_GetBestScore
import UI_GetNumBots
import UI_GetBotInfoByName
import UI_GetBotInfoByNumber
import UI_GetNumSPTiers
import UI_GetNumSPArenas
import UI_GetNumArenas
import UI_GetSpecialArenaInfo
import UI_GetArenaInfoByMap
import UI_GetArenaInfoByNumber
import UI_NetworkOptionsMenu
import UI_NetworkOptionsMenu_Cache
import UI_SoundOptionsMenu
import UI_SoundOptionsMenu_Cache
import UI_DisplayOptionsMenu
import UI_DisplayOptionsMenu_Cache
import UI_SaveConfigMenu
import UI_SaveConfigMenu_Cache
import UI_LoadConfigMenu
import UI_LoadConfig_Cache
import UI_TeamOrdersMenu_Cache
import UI_TeamOrdersMenu_f
import UI_TeamOrdersMenu
import UI_RemoveBotsMenu
import UI_RemoveBots_Cache
import UI_AddBotsMenu
import UI_AddBots_Cache
import trap_SetPbClStatus
import trap_VerifyCDKey
import trap_SetCDKey
import trap_GetCDKey
import trap_MemoryRemaining
import trap_LAN_GetPingInfo
import trap_LAN_GetPing
import trap_LAN_ClearPing
import trap_LAN_ServerStatus
import trap_LAN_GetPingQueueCount
import trap_LAN_GetServerInfo
import trap_LAN_GetServerAddressString
import trap_LAN_GetServerCount
import trap_GetConfigString
import trap_GetGlconfig
import trap_GetClientState
import trap_GetClipboardData
import trap_Key_SetCatcher
import trap_Key_GetCatcher
import trap_Key_ClearStates
import trap_Key_SetOverstrikeMode
import trap_Key_GetOverstrikeMode
import trap_Key_IsDown
import trap_Key_SetBinding
import trap_Key_GetBindingBuf
import trap_Key_KeynumToStringBuf
import trap_S_RegisterSound
import trap_S_StartLocalSound
import trap_CM_LerpTag
import trap_UpdateScreen
import trap_R_DrawStretchPic
import trap_R_SetColor
import trap_R_RenderScene
import trap_R_AddLightToScene
import trap_R_AddPolyToScene
import trap_R_AddRefEntityToScene
import trap_R_ClearScene
import trap_R_RegisterShaderNoMip
import trap_R_RegisterSkin
import trap_R_RegisterModel
import trap_FS_Seek
import trap_FS_GetFileList
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Cmd_ExecuteText
import trap_Argv
import trap_Argc
import trap_Cvar_InfoStringBuffer
import trap_Cvar_Create
import trap_Cvar_Reset
import trap_Cvar_SetValue
import trap_Cvar_VariableStringBuffer
import trap_Cvar_VariableValue
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_Milliseconds
import trap_Error
import trap_Print
import UI_SPSkillMenu_Cache
import UI_SPSkillMenu
import UI_SPPostgameMenu_f
import UI_SPPostgameMenu_Cache
import UI_SPArena_Start
import UI_SPLevelMenu_ReInit
import UI_SPLevelMenu_f
import UI_SPLevelMenu
import UI_SPLevelMenu_Cache
import uis
import m_entersound
import UI_StartDemoLoop
import UI_Cvar_VariableString
import UI_Argv
import UI_ForceMenuOff
import UI_PopMenu
import UI_PushMenu
import UI_SetActiveMenu
import UI_IsFullscreen
import UI_DrawTextBox
import UI_AdjustFrom640
import UI_CursorInRect
import UI_DrawChar
import UI_DrawString
import UI_ProportionalStringWidth
import UI_DrawProportionalString_AutoWrapped
import UI_DrawProportionalString
import UI_ProportionalSizeScale
import UI_DrawBannerString
import UI_LerpColor
import UI_SetColor
import UI_UpdateScreen
import UI_DrawRect
import UI_FillRect
import UI_DrawHandlePic
import UI_DrawNamedPic
import UI_ClampCvar
import UI_ConsoleCommand
import UI_Refresh
import UI_MouseEvent
import UI_KeyEvent
import UI_Shutdown
import UI_Init
import UI_RegisterClientModelname
import UI_PlayerInfo_SetInfo
import UI_PlayerInfo_SetModel
import UI_DrawPlayer
import DriverInfo_Cache
import GraphicsOptions_Cache
import UI_GraphicsOptionsMenu
import ServerInfo_Cache
import UI_ServerInfoMenu
import ArenaServers_Cache
import UI_ArenaServersMenu
import SpecifyServer_Cache
import UI_SpecifyServerMenu
import SpecifyLeague_Cache
import UI_SpecifyLeagueMenu
import Preferences_Cache
import UI_PreferencesMenu
import PlayerSettings_Cache
import UI_PlayerSettingsMenu
import PlayerModel_Cache
import UI_PlayerModelMenu
import UI_CDKeyMenu_f
import UI_CDKeyMenu_Cache
import UI_CDKeyMenu
import UI_ModsMenu_Cache
import UI_ModsMenu
import UI_CinematicsMenu_Cache
import UI_CinematicsMenu_f
import UI_CinematicsMenu
import Demos_Cache
import UI_DemosMenu
import Controls_Cache
import UI_ControlsMenu
import UI_DrawConnectScreen
import TeamMain_Cache
import UI_TeamMainMenu
import UI_SetupMenu
import UI_SetupMenu_Cache
import UI_Message
import UI_ConfirmMenu_Style
import UI_ConfirmMenu
import ConfirmMenu_Cache
import UI_InGameMenu
import InGame_Cache
import UI_CreditMenu
import UI_UpdateCvars
import UI_RegisterCvars
import UI_MainMenu
import MainMenu_Cache
import MenuField_Key
import MenuField_Draw
import MenuField_Init
import MField_Draw
import MField_CharEvent
import MField_KeyDownEvent
import MField_Clear
import ui_medalSounds
import ui_medalPicNames
import ui_medalNames
import text_color_highlight
import text_color_normal
import text_color_disabled
import listbar_color
import list_color
import name_color
import color_dim
import color_red
import color_orange
import color_blue
import color_yellow
import color_white
import color_black
import menu_dim_color
import menu_black_color
import menu_red_color
import menu_highlight_color
import menu_dark_color
import menu_grayed_color
import menu_text_color
import weaponChangeSound
import menu_null_sound
import menu_buzz_sound
import menu_out_sound
import menu_move_sound
import menu_in_sound
import ScrollList_Key
import ScrollList_Draw
import Bitmap_Draw
import Bitmap_Init
import Menu_DefaultKey
import Menu_SetCursorToItem
import Menu_SetCursor
import Menu_ActivateItem
import Menu_ItemAtCursor
import Menu_Draw
import Menu_AdjustCursor
import Menu_AddItem
import Menu_Focus
import Menu_Cache
import ui_cdkeychecked
import ui_cdkey
import ui_server16
import ui_server15
import ui_server14
import ui_server13
import ui_server12
import ui_server11
import ui_server10
import ui_server9
import ui_server8
import ui_server7
import ui_server6
import ui_server5
import ui_server4
import ui_server3
import ui_server2
import ui_server1
import ui_marks
import ui_drawCrosshairNames
import ui_drawCrosshair
import ui_brassTime
import ui_browserShowEmpty
import ui_browserShowFull
import ui_browserSortKey
import ui_browserGameType
import ui_browserMaster
import ui_spSelection
import ui_spSkill
import ui_spVideos
import ui_spAwards
import ui_spScores5
import ui_spScores4
import ui_spScores3
import ui_spScores2
import ui_spScores1
import ui_botsFile
import ui_arenasFile
import ui_ctf_friendly
import ui_ctf_timelimit
import ui_ctf_capturelimit
import ui_team_friendly
import ui_team_timelimit
import ui_team_fraglimit
import ui_tourney_timelimit
import ui_tourney_fraglimit
import ui_ffa_timelimit
import ui_ffa_fraglimit
import BG_PlayerTouchesItem
import BG_PlayerStateToEntityStateExtraPolate
import BG_PlayerStateToEntityState
import BG_TouchJumpPad
import BG_AddPredictableEventToPlayerstate
import BG_EvaluateTrajectoryDelta
import BG_EvaluateTrajectory
import BG_CanItemBeGrabbed
import BG_FindItemForHoldable
import BG_FindItemForPowerup
import BG_FindItemForWeapon
import BG_FindItem
import bg_numItems
import bg_itemlist
import Pmove
import PM_UpdateViewAngles
import Com_Printf
import Com_Error
import Info_NextPair
import Info_Validate
import Info_SetValueForKey_Big
import Info_SetValueForKey
import Info_RemoveKey_big
import Info_RemoveKey
import Info_ValueForKey
import va
import Q_CleanStr
import Q_PrintStrlen
import Q_strcat
import Q_strncpyz
import Q_strrchr
import Q_strupr
import Q_strlwr
import Q_stricmpn
import Q_strncmp
import Q_stricmp
import Q_isalpha
import Q_isupper
import Q_islower
import Q_isprint
import Com_sprintf
import Parse3DMatrix
import Parse2DMatrix
import Parse1DMatrix
import SkipRestOfLine
import SkipBracedSection
import COM_MatchToken
import COM_ParseWarning
import COM_ParseError
import COM_Compress
import COM_ParseExt
import COM_Parse
import COM_GetCurrentParseLine
import COM_BeginParseSession
import COM_DefaultExtension
import COM_StripExtension
import COM_SkipPath
import Com_Clamp
import PerpendicularVector
import AngleVectors
import MatrixMultiply
import MakeNormalVectors
import RotateAroundDirection
import RotatePointAroundVector
import ProjectPointOnPlane
import PlaneFromPoints
import AngleDelta
import AngleNormalize180
import AngleNormalize360
import AnglesSubtract
import AngleSubtract
import LerpAngle
import AngleMod
import BoxOnPlaneSide
import SetPlaneSignbits
import AxisCopy
import AxisClear
import AnglesToAxis
import vectoangles
import Q_crandom
import Q_random
import Q_rand
import Q_acos
import Q_log2
import VectorRotate
import Vector4Scale
import VectorNormalize2
import VectorNormalize
import CrossProduct
import VectorInverse
import VectorNormalizeFast
import DistanceSquared
import Distance
import VectorLengthSquared
import VectorLength
import VectorCompare
import AddPointToBounds
import ClearBounds
import RadiusFromBounds
import NormalizeColor
import ColorBytes4
import ColorBytes3
import _VectorMA
import _VectorScale
import _VectorCopy
import _VectorAdd
import _VectorSubtract
import _DotProduct
import ByteToDir
import DirToByte
import ClampShort
import ClampChar
import Q_rsqrt
import Q_fabs
import axisDefault
import vec3_origin
import g_color_table
import colorDkGrey
import colorMdGrey
import colorLtGrey
import colorWhite
import colorCyan
import colorMagenta
import colorYellow
import colorBlue
import colorGreen
import colorRed
import colorBlack
import bytedirs
import Com_Memcpy
import Com_Memset
import Hunk_Alloc
import FloatSwap
import LongSwap
import ShortSwap
import acos
import fabs
import abs
import tan
import atan2
import cos
import sin
import sqrt
import floor
import ceil
import memcpy
import memset
import memmove
import sscanf
import vsprintf
import _atoi
import atoi
import _atof
import atof
import toupper
import tolower
import strncpy
import strstr
import strchr
import strcmp
import strcpy
import strcat
import strlen
import rand
import srand
import qsort
lit
align 1
LABELV $1819
byte 1 83
byte 1 69
byte 1 76
byte 1 69
byte 1 67
byte 1 84
byte 1 32
byte 1 66
byte 1 79
byte 1 84
byte 1 0
align 1
LABELV $1808
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 111
byte 1 112
byte 1 112
byte 1 111
byte 1 110
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 95
byte 1 115
byte 1 101
byte 1 108
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $1807
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 111
byte 1 112
byte 1 112
byte 1 111
byte 1 110
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 95
byte 1 115
byte 1 101
byte 1 108
byte 1 101
byte 1 99
byte 1 116
byte 1 0
align 1
LABELV $1806
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 97
byte 1 99
byte 1 99
byte 1 101
byte 1 112
byte 1 116
byte 1 95
byte 1 49
byte 1 0
align 1
LABELV $1805
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 97
byte 1 99
byte 1 99
byte 1 101
byte 1 112
byte 1 116
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $1679
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $1668
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 95
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $1665
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 95
byte 1 37
byte 1 115
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $1664
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $1584
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 95
byte 1 49
byte 1 0
align 1
LABELV $1567
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $1517
byte 1 69
byte 1 110
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 66
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 58
byte 1 0
align 1
LABELV $1507
byte 1 78
byte 1 111
byte 1 32
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 58
byte 1 0
align 1
LABELV $1497
byte 1 78
byte 1 111
byte 1 32
byte 1 69
byte 1 120
byte 1 112
byte 1 108
byte 1 111
byte 1 115
byte 1 105
byte 1 118
byte 1 101
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $1487
byte 1 78
byte 1 111
byte 1 32
byte 1 69
byte 1 110
byte 1 101
byte 1 114
byte 1 103
byte 1 121
byte 1 32
byte 1 71
byte 1 117
byte 1 110
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $1477
byte 1 78
byte 1 111
byte 1 32
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 32
byte 1 84
byte 1 80
byte 1 58
byte 1 0
align 1
LABELV $1467
byte 1 78
byte 1 111
byte 1 32
byte 1 77
byte 1 101
byte 1 103
byte 1 97
byte 1 32
byte 1 47
byte 1 32
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $1457
byte 1 78
byte 1 111
byte 1 32
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 58
byte 1 0
align 1
LABELV $1447
byte 1 78
byte 1 111
byte 1 32
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 58
byte 1 0
align 1
LABELV $1437
byte 1 78
byte 1 111
byte 1 32
byte 1 80
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $1419
byte 1 65
byte 1 100
byte 1 100
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 32
byte 1 83
byte 1 108
byte 1 111
byte 1 116
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $1332
byte 1 66
byte 1 111
byte 1 116
byte 1 32
byte 1 83
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 58
byte 1 32
byte 1 32
byte 1 0
align 1
LABELV $1316
byte 1 80
byte 1 117
byte 1 110
byte 1 107
byte 1 98
byte 1 117
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 58
byte 1 0
align 1
LABELV $1300
byte 1 72
byte 1 111
byte 1 115
byte 1 116
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $1291
byte 1 68
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 97
byte 1 116
byte 1 101
byte 1 100
byte 1 58
byte 1 0
align 1
LABELV $1274
byte 1 80
byte 1 117
byte 1 114
byte 1 101
byte 1 32
byte 1 83
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 58
byte 1 0
align 1
LABELV $1264
byte 1 70
byte 1 114
byte 1 105
byte 1 101
byte 1 110
byte 1 100
byte 1 108
byte 1 121
byte 1 32
byte 1 70
byte 1 105
byte 1 114
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $1237
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 76
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $1219
byte 1 67
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 32
byte 1 76
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $1201
byte 1 70
byte 1 114
byte 1 97
byte 1 103
byte 1 32
byte 1 76
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $1186
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 66
byte 1 40
byte 1 66
byte 1 97
byte 1 115
byte 1 101
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 41
byte 1 58
byte 1 0
align 1
LABELV $1174
byte 1 82
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 32
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $1060
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1025
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 71
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $1019
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $1013
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $1007
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $1004
byte 1 117
byte 1 105
byte 1 95
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 77
byte 1 105
byte 1 100
byte 1 100
byte 1 108
byte 1 101
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 0
align 1
LABELV $1001
byte 1 117
byte 1 105
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $980
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 0
align 1
LABELV $956
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $936
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $924
byte 1 118
byte 1 105
byte 1 115
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $918
byte 1 109
byte 1 97
byte 1 106
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $915
byte 1 103
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $894
byte 1 48
byte 1 32
byte 1 61
byte 1 32
byte 1 78
byte 1 79
byte 1 32
byte 1 76
byte 1 73
byte 1 77
byte 1 73
byte 1 84
byte 1 0
align 1
LABELV $834
byte 1 72
byte 1 117
byte 1 109
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $802
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $771
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 32
byte 1 53
byte 1 59
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $766
byte 1 97
byte 1 100
byte 1 100
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 37
byte 1 105
byte 1 10
byte 1 0
align 1
LABELV $762
byte 1 97
byte 1 100
byte 1 100
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $744
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 32
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $741
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 59
byte 1 32
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 59
byte 1 32
byte 1 109
byte 1 97
byte 1 112
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $740
byte 1 109
byte 1 97
byte 1 112
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 32
byte 1 48
byte 1 0
align 1
LABELV $739
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $734
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $731
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $728
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $723
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 66
byte 1 70
byte 1 71
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 71
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $720
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $717
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $714
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $711
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 71
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $708
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $705
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 101
byte 1 110
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 66
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $702
byte 1 103
byte 1 95
byte 1 98
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $699
byte 1 117
byte 1 105
byte 1 95
byte 1 101
byte 1 110
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 66
byte 1 108
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $696
byte 1 115
byte 1 118
byte 1 95
byte 1 112
byte 1 117
byte 1 110
byte 1 107
byte 1 98
byte 1 117
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $692
byte 1 115
byte 1 118
byte 1 95
byte 1 104
byte 1 111
byte 1 115
byte 1 116
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $691
byte 1 115
byte 1 118
byte 1 95
byte 1 112
byte 1 117
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $690
byte 1 103
byte 1 95
byte 1 102
byte 1 114
byte 1 105
byte 1 101
byte 1 110
byte 1 100
byte 1 108
byte 1 121
byte 1 102
byte 1 105
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $689
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $688
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $687
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $686
byte 1 100
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 97
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $685
byte 1 115
byte 1 118
byte 1 95
byte 1 109
byte 1 97
byte 1 120
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $683
byte 1 117
byte 1 105
byte 1 95
byte 1 99
byte 1 116
byte 1 102
byte 1 95
byte 1 102
byte 1 114
byte 1 105
byte 1 101
byte 1 110
byte 1 100
byte 1 108
byte 1 121
byte 1 0
align 1
LABELV $682
byte 1 117
byte 1 105
byte 1 95
byte 1 99
byte 1 116
byte 1 102
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $681
byte 1 117
byte 1 105
byte 1 95
byte 1 99
byte 1 116
byte 1 102
byte 1 95
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $679
byte 1 117
byte 1 105
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 102
byte 1 114
byte 1 105
byte 1 101
byte 1 110
byte 1 100
byte 1 108
byte 1 121
byte 1 0
align 1
LABELV $678
byte 1 117
byte 1 105
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $677
byte 1 117
byte 1 105
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $675
byte 1 117
byte 1 105
byte 1 95
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $674
byte 1 117
byte 1 105
byte 1 95
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 95
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $672
byte 1 117
byte 1 105
byte 1 95
byte 1 102
byte 1 102
byte 1 97
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $671
byte 1 117
byte 1 105
byte 1 95
byte 1 102
byte 1 102
byte 1 97
byte 1 95
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 108
byte 1 105
byte 1 109
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $664
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $659
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 77
byte 1 101
byte 1 103
byte 1 97
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 84
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $656
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 84
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $653
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 84
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $650
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $647
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 77
byte 1 101
byte 1 103
byte 1 97
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $644
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 77
byte 1 101
byte 1 103
byte 1 97
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $641
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $638
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $637
byte 1 117
byte 1 105
byte 1 95
byte 1 97
byte 1 100
byte 1 100
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 83
byte 1 108
byte 1 111
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $601
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 77
byte 1 105
byte 1 100
byte 1 100
byte 1 108
byte 1 101
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $598
byte 1 103
byte 1 95
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 77
byte 1 105
byte 1 100
byte 1 100
byte 1 108
byte 1 101
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 0
align 1
LABELV $595
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 117
byte 1 105
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $592
byte 1 103
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $570
byte 1 50
byte 1 48
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $569
byte 1 49
byte 1 53
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $568
byte 1 49
byte 1 48
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $567
byte 1 55
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $566
byte 1 53
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $565
byte 1 51
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $564
byte 1 50
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $563
byte 1 68
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $562
byte 1 80
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 32
byte 1 71
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $561
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 97
byte 1 108
byte 1 32
byte 1 84
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $560
byte 1 76
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 71
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $559
byte 1 71
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 32
byte 1 76
byte 1 97
byte 1 117
byte 1 110
byte 1 99
byte 1 104
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $558
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 32
byte 1 76
byte 1 97
byte 1 117
byte 1 110
byte 1 99
byte 1 104
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $557
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $556
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $555
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $554
byte 1 72
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $553
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $552
byte 1 77
byte 1 101
byte 1 103
byte 1 97
byte 1 32
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $551
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $550
byte 1 72
byte 1 101
byte 1 97
byte 1 118
byte 1 121
byte 1 32
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $549
byte 1 65
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $548
byte 1 78
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 109
byte 1 97
byte 1 114
byte 1 101
byte 1 33
byte 1 0
align 1
LABELV $547
byte 1 72
byte 1 97
byte 1 114
byte 1 100
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $546
byte 1 72
byte 1 117
byte 1 114
byte 1 116
byte 1 32
byte 1 77
byte 1 101
byte 1 32
byte 1 80
byte 1 108
byte 1 101
byte 1 110
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $545
byte 1 66
byte 1 114
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 73
byte 1 116
byte 1 32
byte 1 79
byte 1 110
byte 1 0
align 1
LABELV $544
byte 1 73
byte 1 32
byte 1 67
byte 1 97
byte 1 110
byte 1 32
byte 1 87
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $543
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $542
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $541
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 0
align 1
LABELV $540
byte 1 66
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $539
byte 1 79
byte 1 112
byte 1 101
byte 1 110
byte 1 0
align 1
LABELV $538
byte 1 73
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 110
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $537
byte 1 76
byte 1 65
byte 1 78
byte 1 0
align 1
LABELV $536
byte 1 78
byte 1 111
byte 1 0
align 1
LABELV $518
byte 1 99
byte 1 111
byte 1 109
byte 1 95
byte 1 98
byte 1 117
byte 1 105
byte 1 108
byte 1 100
byte 1 115
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 0
align 1
LABELV $488
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 95
byte 1 49
byte 1 0
align 1
LABELV $471
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $467
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 95
byte 1 49
byte 1 0
align 1
LABELV $450
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $433
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 103
byte 1 115
byte 1 95
byte 1 97
byte 1 114
byte 1 114
byte 1 111
byte 1 119
byte 1 115
byte 1 95
byte 1 114
byte 1 0
align 1
LABELV $415
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 103
byte 1 115
byte 1 95
byte 1 97
byte 1 114
byte 1 114
byte 1 111
byte 1 119
byte 1 115
byte 1 95
byte 1 108
byte 1 0
align 1
LABELV $387
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 103
byte 1 115
byte 1 95
byte 1 97
byte 1 114
byte 1 114
byte 1 111
byte 1 119
byte 1 115
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $383
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 109
byte 1 97
byte 1 112
byte 1 115
byte 1 95
byte 1 115
byte 1 101
byte 1 108
byte 1 101
byte 1 99
byte 1 116
byte 1 0
align 1
LABELV $355
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $352
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 109
byte 1 97
byte 1 112
byte 1 115
byte 1 95
byte 1 115
byte 1 101
byte 1 108
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $320
byte 1 71
byte 1 97
byte 1 109
byte 1 101
byte 1 32
byte 1 84
byte 1 121
byte 1 112
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $306
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 49
byte 1 95
byte 1 114
byte 1 0
align 1
LABELV $292
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 50
byte 1 95
byte 1 108
byte 1 0
align 1
LABELV $284
byte 1 71
byte 1 65
byte 1 77
byte 1 69
byte 1 32
byte 1 83
byte 1 69
byte 1 82
byte 1 86
byte 1 69
byte 1 82
byte 1 0
align 1
LABELV $248
byte 1 103
byte 1 95
byte 1 97
byte 1 117
byte 1 116
byte 1 111
byte 1 67
byte 1 84
byte 1 70
byte 1 0
align 1
LABELV $242
byte 1 103
byte 1 95
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $233
byte 1 103
byte 1 95
byte 1 111
byte 1 110
byte 1 101
byte 1 76
byte 1 105
byte 1 102
byte 1 101
byte 1 84
byte 1 68
byte 1 77
byte 1 0
align 1
LABELV $227
byte 1 103
byte 1 95
byte 1 98
byte 1 97
byte 1 115
byte 1 101
byte 1 84
byte 1 68
byte 1 77
byte 1 0
align 1
LABELV $224
byte 1 103
byte 1 95
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 84
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $196
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $191
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $142
byte 1 78
byte 1 79
byte 1 32
byte 1 77
byte 1 65
byte 1 80
byte 1 83
byte 1 32
byte 1 70
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 0
align 1
LABELV $109
byte 1 108
byte 1 101
byte 1 118
byte 1 101
byte 1 108
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $98
byte 1 99
byte 1 116
byte 1 102
byte 1 0
align 1
LABELV $95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $92
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $89
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 0
align 1
LABELV $86
byte 1 102
byte 1 102
byte 1 97
byte 1 0
align 1
LABELV $77
byte 1 67
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $76
byte 1 84
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $75
byte 1 67
byte 1 84
byte 1 70
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 84
byte 1 68
byte 1 77
byte 1 32
byte 1 77
byte 1 97
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $74
byte 1 66
byte 1 97
byte 1 115
byte 1 101
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $73
byte 1 79
byte 1 110
byte 1 101
byte 1 32
byte 1 76
byte 1 105
byte 1 102
byte 1 101
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 67
byte 1 84
byte 1 70
byte 1 0
align 1
LABELV $72
byte 1 84
byte 1 68
byte 1 77
byte 1 32
byte 1 79
byte 1 110
byte 1 101
byte 1 32
byte 1 76
byte 1 105
byte 1 102
byte 1 101
byte 1 0
align 1
LABELV $71
byte 1 66
byte 1 97
byte 1 115
byte 1 101
byte 1 32
byte 1 84
byte 1 68
byte 1 77
byte 1 0
align 1
LABELV $70
byte 1 84
byte 1 68
byte 1 77
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 67
byte 1 84
byte 1 70
byte 1 32
byte 1 77
byte 1 97
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $69
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 68
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 109
byte 1 97
byte 1 116
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $68
byte 1 70
byte 1 114
byte 1 101
byte 1 101
byte 1 32
byte 1 70
byte 1 111
byte 1 114
byte 1 32
byte 1 65
byte 1 108
byte 1 108
byte 1 0
