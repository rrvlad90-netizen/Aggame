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
address $78
address $79
address $80
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
byte 4 3
byte 4 4
byte 4 1
byte 4 4
byte 4 0
byte 4 0
align 4
LABELV gametype_remap2
byte 4 0
byte 4 9
byte 4 0
byte 4 1
byte 4 10
code
proc GametypeBits 36 8
file "../ui_startserver.c"
line 151
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
;65:#define UI_MODE_MONSTER_HUNT		11
;66:#define UI_MODE_MONSTER_HUNT_ONE_LIFE	12
;67:#define UI_MODE_COUNT			13
;68:
;69:typedef struct {
;70:	menuframework_s	menu;
;71:
;72:	menutext_s		banner;
;73:	menubitmap_s	framel;
;74:	menubitmap_s	framer;
;75:
;76:	menulist_s		gametype;
;77:	menubitmap_s	mappics[MAX_MAPSPERPAGE];
;78:	menubitmap_s	mapbuttons[MAX_MAPSPERPAGE];
;79:	menubitmap_s	arrows;
;80:	menubitmap_s	prevpage;
;81:	menubitmap_s	nextpage;
;82:	menubitmap_s	back;
;83:	menubitmap_s	next;
;84:
;85:	menutext_s		mapname;
;86:	menubitmap_s	item_null;
;87:
;88:	qboolean		multiplayer;
;89:	int				currentmap;
;90:	int				nummaps;
;91:	int				page;
;92:	int				maxpages;
;93:	char			maplist[MAX_SERVERMAPS][MAX_NAMELENGTH];
;94:	int				mapGamebits[MAX_SERVERMAPS];
;95:} startserver_t;
;96:
;97:static startserver_t s_startserver;
;98:
;99:static const char *gametype_items[] = {
;100:	"Free For All",
;101:	"Team Deathmatch",
;102:	"TDM on CTF Maps",
;103:	"Base TDM",
;104:	"TDM One Life",
;105:	"One Life on CTF",
;106:	"Base Assault on CTF",
;107:	"Base Assault on TDM",
;108:	"CTF on TDM Maps",
;109:	"Tournament",
;110:	"Capture the Flag",
;111:	"Monster Hunt",
;112:	"Monster Hunt One Life",
;113:	0
;114:};
;115:
;116:static int gametype_remap[] = {
;117:	GT_FFA,
;118:	GT_TEAM,
;119:	GT_TEAM,
;120:	GT_TEAM,
;121:	GT_TEAM,
;122:	GT_TEAM,
;123:	GT_TEAM,
;124:	GT_TEAM,
;125:	GT_CTF,
;126:	GT_TOURNAMENT,
;127:	GT_CTF,
;128:	GT_FFA,
;129:	GT_FFA
;130:};
;131:
;132:static int gametype_remap2[] = {
;133:	0,
;134:	9,
;135:	0,
;136:	1,
;137:	10
;138:};
;139:
;140:// use ui_servers2.c definition
;141:extern const char* punkbuster_items[];
;142:
;143:static void UI_ServerOptionsMenu( qboolean multiplayer );
;144:
;145:
;146:/*
;147:=================
;148:GametypeBits
;149:=================
;150:*/
;151:static int GametypeBits( char *string ) {
line 156
;152:	int		bits;
;153:	char	*p;
;154:	char	*token;
;155:
;156:	bits = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 157
;157:	p = string;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $83
JUMPV
LABELV $82
line 158
;158:	while( 1 ) {
line 159
;159:		token = COM_ParseExt( &p, qfalse );
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
line 160
;160:		if( token[0] == 0 ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $85
line 161
;161:			break;
ADDRGP4 $84
JUMPV
LABELV $85
line 164
;162:		}
;163:
;164:		if( Q_stricmp( token, "ffa" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $89
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $87
line 165
;165:			bits |= 1 << GT_FFA;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 166
;166:			continue;
ADDRGP4 $83
JUMPV
LABELV $87
line 169
;167:		}
;168:
;169:		if( Q_stricmp( token, "tourney" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $92
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $90
line 170
;170:			bits |= 1 << GT_TOURNAMENT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
line 171
;171:			continue;
ADDRGP4 $83
JUMPV
LABELV $90
line 174
;172:		}
;173:
;174:		if( Q_stricmp( token, "single" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $95
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $93
line 175
;175:			bits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 176
;176:			continue;
ADDRGP4 $83
JUMPV
LABELV $93
line 179
;177:		}
;178:
;179:		if( Q_stricmp( token, "team" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $98
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $96
line 180
;180:			bits |= 1 << GT_TEAM;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
line 181
;181:			continue;
ADDRGP4 $83
JUMPV
LABELV $96
line 184
;182:		}
;183:
;184:		if( Q_stricmp( token, "ctf" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $101
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $99
line 185
;185:			bits |= 1 << GT_CTF;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 186
;186:			continue;
LABELV $99
line 188
;187:		}
;188:	}
LABELV $83
line 158
ADDRGP4 $82
JUMPV
LABELV $84
line 190
;189:
;190:	return bits;
ADDRLP4 4
INDIRI4
RETI4
LABELV $81
endproc GametypeBits 36 8
bss
align 1
LABELV $103
skip 256
code
proc StartServer_Update 28 16
line 199
;191:}
;192:
;193:
;194:/*
;195:=================
;196:StartServer_Update
;197:=================
;198:*/
;199:static void StartServer_Update( void ) {
line 204
;200:	int				i;
;201:	int				top;
;202:	static	char	picname[MAX_MAPSPERPAGE][64];
;203:
;204:	top = s_startserver.page*MAX_MAPSPERPAGE;
ADDRLP4 4
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
line 206
;205:
;206:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $105
line 207
;207:	{
line 208
;208:		if (top+i >= s_startserver.nummaps)
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
ADDI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $109
line 209
;209:			break;
ADDRGP4 $127
JUMPV
LABELV $109
line 211
;210:
;211:		Com_sprintf( picname[i], sizeof(picname[i]), "levelshots/%s", s_startserver.maplist[top+i] );
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 $103
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $112
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
line 213
;212:
;213:		s_startserver.mappics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 214
;214:		s_startserver.mappics[i].generic.name   = picname[i];
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
ADDRGP4 $103
ADDP4
ASGNP4
line 215
;215:		s_startserver.mappics[i].shader         = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+68
ADDP4
CNSTI4 0
ASGNI4
line 218
;216:
;217:		// reset
;218:		s_startserver.mapbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 219
;219:		s_startserver.mapbuttons[i].generic.flags &= ~QMF_INACTIVE;
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
line 220
;220:	}
LABELV $106
line 206
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $105
line 222
;221:
;222:	for (; i<MAX_MAPSPERPAGE; i++)
ADDRGP4 $127
JUMPV
LABELV $124
line 223
;223:	{
line 224
;224:		s_startserver.mappics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 225
;225:		s_startserver.mappics[i].generic.name   = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+4
ADDP4
CNSTP4 0
ASGNP4
line 226
;226:		s_startserver.mappics[i].shader         = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+68
ADDP4
CNSTI4 0
ASGNI4
line 229
;227:
;228:		// disable
;229:		s_startserver.mapbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 230
;230:		s_startserver.mapbuttons[i].generic.flags |= QMF_INACTIVE;
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
line 231
;231:	}
LABELV $125
line 222
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $127
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $124
line 235
;232:
;233:
;234:	// no servers to start
;235:	if( !s_startserver.nummaps ) {
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 0
NEI4 $138
line 236
;236:		s_startserver.next.generic.flags |= QMF_INACTIVE;
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
line 239
;237:
;238:		// set the map name
;239:		strcpy( s_startserver.mapname.string, "NO MAPS FOUND" );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 $145
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 240
;240:	}
ADDRGP4 $139
JUMPV
LABELV $138
line 241
;241:	else {
line 243
;242:		// set the highlight
;243:		s_startserver.next.generic.flags &= ~QMF_INACTIVE;
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
line 244
;244:		i = s_startserver.currentmap - top;
ADDRLP4 0
ADDRGP4 s_startserver+1940
INDIRI4
ADDRLP4 4
INDIRI4
SUBI4
ASGNI4
line 245
;245:		if ( i >=0 && i < MAX_MAPSPERPAGE ) 
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $149
ADDRLP4 0
INDIRI4
CNSTI4 4
GEI4 $149
line 246
;246:		{
line 247
;247:			s_startserver.mappics[i].generic.flags    |= QMF_HIGHLIGHT;
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
line 248
;248:			s_startserver.mapbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 249
;249:		}
LABELV $149
line 252
;250:
;251:		// set the map name
;252:		strcpy( s_startserver.mapname.string, s_startserver.maplist[s_startserver.currentmap] );
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
line 253
;253:	}
LABELV $139
line 255
;254:	
;255:	Q_strupr( s_startserver.mapname.string );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 256
;256:}
LABELV $102
endproc StartServer_Update 28 16
proc StartServer_MapEvent 0 0
line 264
;257:
;258:
;259:/*
;260:=================
;261:StartServer_MapEvent
;262:=================
;263:*/
;264:static void StartServer_MapEvent( void* ptr, int event ) {
line 265
;265:	if( event != QM_ACTIVATED) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $162
line 266
;266:		return;
ADDRGP4 $161
JUMPV
LABELV $162
line 269
;267:	}
;268:
;269:	s_startserver.currentmap = (s_startserver.page*MAX_MAPSPERPAGE) + (((menucommon_s*)ptr)->id - ID_PICTURES);
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
line 270
;270:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 271
;271:}
LABELV $161
endproc StartServer_MapEvent 0 0
proc StartServer_GametypeEvent 44 12
line 279
;272:
;273:
;274:/*
;275:=================
;276:StartServer_GametypeEvent
;277:=================
;278:*/
;279:static void StartServer_GametypeEvent( void* ptr, int event ) {
line 286
;280:	int			i;
;281:	int			count;
;282:	int			gamebits;
;283:	int			matchbits;
;284:	const char	*info;
;285:
;286:	if( event != QM_ACTIVATED) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $167
line 287
;287:		return;
ADDRGP4 $166
JUMPV
LABELV $167
line 290
;288:	}
;289:
;290:	count = UI_GetNumArenas();
ADDRLP4 20
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
line 291
;291:	s_startserver.nummaps = 0;
ADDRGP4 s_startserver+1944
CNSTI4 0
ASGNI4
line 292
;292:	if( s_startserver.gametype.curvalue == 8 ) {
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 8
NEI4 $170
line 297
;293:		/*
;294:		 * CTF on TDM Maps launches GT_CTF,
;295:		 * but displays ordinary team maps.
;296:		 */
;297:		matchbits = 1 << GT_TEAM;
ADDRLP4 12
CNSTI4 8
ASGNI4
line 298
;298:	}
ADDRGP4 $171
JUMPV
LABELV $170
line 299
;299:	else if( s_startserver.gametype.curvalue == 2 ||
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
EQI4 $183
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
EQI4 $183
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 6
NEI4 $174
LABELV $183
line 301
;300:		s_startserver.gametype.curvalue == 5 ||
;301:		s_startserver.gametype.curvalue == 6 ) {
line 305
;302:		/*
;303:		 * These modes use CTF maps but launch GT_TEAM.
;304:		 */
;305:		matchbits = 1 << GT_CTF;
ADDRLP4 12
CNSTI4 16
ASGNI4
line 306
;306:	}
ADDRGP4 $175
JUMPV
LABELV $174
line 307
;307:	else {
line 308
;308:		matchbits =
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
line 313
;309:			1 << gametype_remap[
;310:				s_startserver.gametype.curvalue
;311:			];
;312:
;313:		if( gametype_remap[
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
CNSTI4 0
NEI4 $186
line 315
;314:			s_startserver.gametype.curvalue
;315:		] == GT_FFA ) {
line 316
;316:			matchbits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 317
;317:		}
LABELV $186
line 318
;318:	}
LABELV $175
LABELV $171
line 319
;319:	for( i = 0; i < count; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $193
JUMPV
LABELV $190
line 320
;320:		info = UI_GetArenaInfoByNumber( i );
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
line 322
;321:
;322:		gamebits = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $194
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
line 323
;323:		if( !( gamebits & matchbits ) ) {
ADDRLP4 4
INDIRI4
ADDRLP4 12
INDIRI4
BANDI4
CNSTI4 0
NEI4 $195
line 324
;324:			continue;
ADDRGP4 $191
JUMPV
LABELV $195
line 327
;325:		}
;326:
;327:		Q_strncpyz( s_startserver.maplist[s_startserver.nummaps], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $199
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
line 328
;328:		Q_strupr( s_startserver.maplist[s_startserver.nummaps] );
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
line 329
;329:		s_startserver.mapGamebits[s_startserver.nummaps] = gamebits;
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_startserver+2980
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 330
;330:		s_startserver.nummaps++;
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
line 331
;331:	}
LABELV $191
line 319
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $193
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $190
line 332
;332:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
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
line 333
;333:	s_startserver.page = 0;
ADDRGP4 s_startserver+1948
CNSTI4 0
ASGNI4
line 334
;334:	s_startserver.currentmap = 0;
ADDRGP4 s_startserver+1940
CNSTI4 0
ASGNI4
line 336
;335:
;336:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 337
;337:}
LABELV $166
endproc StartServer_GametypeEvent 44 12
proc StartServer_MenuEvent 20 8
line 345
;338:
;339:
;340:/*
;341:=================
;342:StartServer_MenuEvent
;343:=================
;344:*/
;345:static void StartServer_MenuEvent( void* ptr, int event ) {
line 346
;346:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $210
line 347
;347:		return;
ADDRGP4 $209
JUMPV
LABELV $210
line 350
;348:	}
;349:
;350:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $212
ADDRLP4 0
INDIRI4
CNSTI4 18
GTI4 $212
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $274-60
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $274
address $215
address $220
address $273
address $226
code
LABELV $215
line 352
;351:	case ID_PREVPAGE:
;352:		if( s_startserver.page > 0 ) {
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 0
LEI4 $213
line 353
;353:			s_startserver.page--;
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
line 354
;354:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 355
;355:		}
line 356
;356:		break;
ADDRGP4 $213
JUMPV
LABELV $220
line 359
;357:
;358:	case ID_NEXTPAGE:
;359:		if( s_startserver.page < s_startserver.maxpages - 1 ) {
ADDRGP4 s_startserver+1948
INDIRI4
ADDRGP4 s_startserver+1952
INDIRI4
CNSTI4 1
SUBI4
GEI4 $213
line 360
;360:			s_startserver.page++;
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
line 361
;361:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 362
;362:		}
line 363
;363:		break;
ADDRGP4 $213
JUMPV
LABELV $226
line 366
;364:
;365:	case ID_STARTSERVERNEXT:
;366:		trap_Cvar_SetValue(
ADDRGP4 $227
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
line 373
;367:			"g_gameType",
;368:			gametype_remap[
;369:				s_startserver.gametype.curvalue
;370:			]
;371:		);
;372:		
;373:		if( s_startserver.gametype.curvalue ==
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 11
NEI4 $230
line 374
;374:			UI_MODE_MONSTER_HUNT ) {
line 375
;375:			trap_Cvar_SetValue(
ADDRGP4 $234
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 379
;376:				"g_monsterHunt",
;377:				1
;378:			);
;379:		}
ADDRGP4 $231
JUMPV
LABELV $230
line 380
;380:		else if( s_startserver.gametype.curvalue ==
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 12
NEI4 $235
line 381
;381:			UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
line 382
;382:			trap_Cvar_SetValue(
ADDRGP4 $234
ARGP4
CNSTF4 1073741824
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 386
;383:				"g_monsterHunt",
;384:				2
;385:			);
;386:		}
ADDRGP4 $236
JUMPV
LABELV $235
line 387
;387:		else {
line 392
;388:			/*
;389:			 * Selecting any standard mode must restore
;390:			 * the original player-versus-player AI.
;391:			 */
;392:			trap_Cvar_SetValue(
ADDRGP4 $234
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 396
;393:				"g_monsterHunt",
;394:				0
;395:			);
;396:		}
LABELV $236
LABELV $231
line 398
;397:
;398:		trap_Cvar_SetValue(
ADDRGP4 $239
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 3
EQI4 $247
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 7
NEI4 $245
LABELV $247
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $246
JUMPV
LABELV $245
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $246
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 404
;399:			"g_baseTDM",
;400:			s_startserver.gametype.curvalue == 3 ||
;401:			s_startserver.gametype.curvalue == 7
;402:		);
;403:
;404:		trap_Cvar_SetValue(
ADDRGP4 $248
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 4
EQI4 $256
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
NEI4 $254
LABELV $256
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRGP4 $255
JUMPV
LABELV $254
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $255
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 410
;405:			"g_oneLifeTDM",
;406:			s_startserver.gametype.curvalue == 4 ||
;407:			s_startserver.gametype.curvalue == 5
;408:		);
;409:
;410:		if( s_startserver.gametype.curvalue == 6 ) {
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 6
NEI4 $257
line 411
;411:			trap_Cvar_SetValue(
ADDRGP4 $261
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 415
;412:				"g_assaultMode",
;413:				1
;414:			);
;415:		}
ADDRGP4 $258
JUMPV
LABELV $257
line 416
;416:		else if( s_startserver.gametype.curvalue == 7 ) {
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 7
NEI4 $262
line 417
;417:			trap_Cvar_SetValue(
ADDRGP4 $261
ARGP4
CNSTF4 1077936128
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 421
;418:				"g_assaultMode",
;419:				3
;420:			);
;421:		}
ADDRGP4 $263
JUMPV
LABELV $262
line 422
;422:		else {
line 423
;423:			trap_Cvar_SetValue(
ADDRGP4 $261
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 427
;424:				"g_assaultMode",
;425:				0
;426:			);
;427:		}
LABELV $263
LABELV $258
line 429
;428:
;429:		trap_Cvar_SetValue(
ADDRGP4 $266
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 8
NEI4 $270
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $271
JUMPV
LABELV $270
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $271
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 434
;430:			"g_autoCTF",
;431:			s_startserver.gametype.curvalue == 8
;432:		);
;433:
;434:		UI_ServerOptionsMenu(
ADDRGP4 s_startserver+1936
INDIRI4
ARGI4
ADDRGP4 UI_ServerOptionsMenu
CALLV
pop
line 437
;435:			s_startserver.multiplayer
;436:		);
;437:		break;
ADDRGP4 $213
JUMPV
LABELV $273
line 440
;438:
;439:	case ID_STARTSERVERBACK:
;440:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 441
;441:		break;
LABELV $212
LABELV $213
line 443
;442:	}
;443:}
LABELV $209
endproc StartServer_MenuEvent 20 8
proc StartServer_LevelshotDraw 48 20
line 451
;444:
;445:
;446:/*
;447:===============
;448:StartServer_LevelshotDraw
;449:===============
;450:*/
;451:static void StartServer_LevelshotDraw( void *self ) {
line 459
;452:	menubitmap_s	*b;
;453:	int				x;
;454:	int				y;
;455:	int				w;
;456:	int				h;
;457:	int				n;
;458:
;459:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 461
;460:
;461:	if( !b->generic.name ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $277
line 462
;462:		return;
ADDRGP4 $276
JUMPV
LABELV $277
line 465
;463:	}
;464:
;465:	if( b->generic.name && !b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $279
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $279
line 466
;466:		b->shader = trap_R_RegisterShaderNoMip( b->generic.name );
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
line 467
;467:		if( !b->shader && b->errorpic ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $281
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $281
line 468
;468:			b->shader = trap_R_RegisterShaderNoMip( b->errorpic );
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
line 469
;469:		}
LABELV $281
line 470
;470:	}
LABELV $279
line 472
;471:
;472:	if( b->focuspic && !b->focusshader ) {
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $283
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
NEI4 $283
line 473
;473:		b->focusshader = trap_R_RegisterShaderNoMip( b->focuspic );
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
line 474
;474:	}
LABELV $283
line 476
;475:
;476:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 477
;477:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 478
;478:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 479
;479:	h =	b->height;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 480
;480:	if( b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $285
line 481
;481:		UI_DrawHandlePic( x, y, w, h, b->shader );
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
line 482
;482:	}
LABELV $285
line 484
;483:
;484:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 485
;485:	y = b->generic.y + b->height;
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
line 486
;486:	UI_FillRect( x, y, b->width, 28, colorBlack );
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
line 488
;487:
;488:	x += b->width / 2;
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
line 489
;489:	y += 4;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 490
;490:	n = s_startserver.page * MAX_MAPSPERPAGE + b->generic.id - ID_PICTURES;
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
line 491
;491:	UI_DrawString( x, y, s_startserver.maplist[n], UI_CENTER|UI_SMALLFONT, color_orange );
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
line 493
;492:
;493:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 494
;494:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 495
;495:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 496
;496:	h =	b->height + 28;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
line 497
;497:	if( b->generic.flags & QMF_HIGHLIGHT ) {	
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 64
BANDU4
CNSTU4 0
EQU4 $289
line 498
;498:		UI_DrawHandlePic( x, y, w, h, b->focusshader );
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
line 499
;499:	}
LABELV $289
line 500
;500:}
LABELV $276
endproc StartServer_LevelshotDraw 48 20
bss
align 1
LABELV $292
skip 64
code
proc StartServer_MenuInit 20 12
line 508
;501:
;502:
;503:/*
;504:=================
;505:StartServer_MenuInit
;506:=================
;507:*/
;508:static void StartServer_MenuInit( void ) {
line 515
;509:	int	i;
;510:	int	x;
;511:	int	y;
;512:	static char mapnamebuffer[64];
;513:
;514:	// zero set all our globals
;515:	memset( &s_startserver, 0 ,sizeof(startserver_t) );
ADDRGP4 s_startserver
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3236
ARGI4
ADDRGP4 memset
CALLP4
pop
line 517
;516:
;517:	StartServer_Cache();
ADDRGP4 StartServer_Cache
CALLV
pop
line 519
;518:
;519:	s_startserver.menu.wrapAround = qtrue;
ADDRGP4 s_startserver+276
CNSTI4 1
ASGNI4
line 520
;520:	s_startserver.menu.fullscreen = qtrue;
ADDRGP4 s_startserver+280
CNSTI4 1
ASGNI4
line 522
;521:
;522:	s_startserver.banner.generic.type  = MTYPE_BTEXT;
ADDRGP4 s_startserver+288
CNSTI4 10
ASGNI4
line 523
;523:	s_startserver.banner.generic.x	   = 320;
ADDRGP4 s_startserver+288+12
CNSTI4 320
ASGNI4
line 524
;524:	s_startserver.banner.generic.y	   = 16;
ADDRGP4 s_startserver+288+16
CNSTI4 16
ASGNI4
line 525
;525:	s_startserver.banner.string        = "GAME SERVER";
ADDRGP4 s_startserver+288+60
ADDRGP4 $302
ASGNP4
line 526
;526:	s_startserver.banner.color         = color_white;
ADDRGP4 s_startserver+288+68
ADDRGP4 color_white
ASGNP4
line 527
;527:	s_startserver.banner.style         = UI_CENTER;
ADDRGP4 s_startserver+288+64
CNSTI4 1
ASGNI4
line 529
;528:
;529:	s_startserver.framel.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+360
CNSTI4 6
ASGNI4
line 530
;530:	s_startserver.framel.generic.name  = GAMESERVER_FRAMEL;
ADDRGP4 s_startserver+360+4
ADDRGP4 $310
ASGNP4
line 531
;531:	s_startserver.framel.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+360+44
CNSTU4 16384
ASGNU4
line 532
;532:	s_startserver.framel.generic.x	   = 0;  
ADDRGP4 s_startserver+360+12
CNSTI4 0
ASGNI4
line 533
;533:	s_startserver.framel.generic.y	   = 78;
ADDRGP4 s_startserver+360+16
CNSTI4 78
ASGNI4
line 534
;534:	s_startserver.framel.width  	   = 256;
ADDRGP4 s_startserver+360+76
CNSTI4 256
ASGNI4
line 535
;535:	s_startserver.framel.height  	   = 329;
ADDRGP4 s_startserver+360+80
CNSTI4 329
ASGNI4
line 537
;536:
;537:	s_startserver.framer.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+448
CNSTI4 6
ASGNI4
line 538
;538:	s_startserver.framer.generic.name  = GAMESERVER_FRAMER;
ADDRGP4 s_startserver+448+4
ADDRGP4 $324
ASGNP4
line 539
;539:	s_startserver.framer.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+448+44
CNSTU4 16384
ASGNU4
line 540
;540:	s_startserver.framer.generic.x	   = 376;
ADDRGP4 s_startserver+448+12
CNSTI4 376
ASGNI4
line 541
;541:	s_startserver.framer.generic.y	   = 76;
ADDRGP4 s_startserver+448+16
CNSTI4 76
ASGNI4
line 542
;542:	s_startserver.framer.width  	   = 256;
ADDRGP4 s_startserver+448+76
CNSTI4 256
ASGNI4
line 543
;543:	s_startserver.framer.height  	   = 334;
ADDRGP4 s_startserver+448+80
CNSTI4 334
ASGNI4
line 545
;544:
;545:	s_startserver.gametype.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_startserver+536
CNSTI4 3
ASGNI4
line 546
;546:	s_startserver.gametype.generic.name		= "Game Type:";
ADDRGP4 s_startserver+536+4
ADDRGP4 $338
ASGNP4
line 547
;547:	s_startserver.gametype.generic.flags	= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_startserver+536+44
CNSTU4 258
ASGNU4
line 548
;548:	s_startserver.gametype.generic.callback	= StartServer_GametypeEvent;
ADDRGP4 s_startserver+536+48
ADDRGP4 StartServer_GametypeEvent
ASGNP4
line 549
;549:	s_startserver.gametype.generic.id		= ID_GAMETYPE;
ADDRGP4 s_startserver+536+8
CNSTI4 10
ASGNI4
line 550
;550:	s_startserver.gametype.generic.x		= 320 - 24;
ADDRGP4 s_startserver+536+12
CNSTI4 296
ASGNI4
line 551
;551:	s_startserver.gametype.generic.y		= 368;
ADDRGP4 s_startserver+536+16
CNSTI4 368
ASGNI4
line 552
;552:	s_startserver.gametype.itemnames		= gametype_items;
ADDRGP4 s_startserver+536+76
ADDRGP4 gametype_items
ASGNP4
line 554
;553:
;554:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $351
line 555
;555:	{
line 556
;556:		x =	(i % MAX_MAPCOLS) * (128+8) + 188;
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
line 557
;557:		y = (i / MAX_MAPROWS) * (128+8) + 96;
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
line 559
;558:
;559:		s_startserver.mappics[i].generic.type   = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632
ADDP4
CNSTI4 6
ASGNI4
line 560
;560:		s_startserver.mappics[i].generic.flags  = QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
CNSTU4 16388
ASGNU4
line 561
;561:		s_startserver.mappics[i].generic.x	    = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 562
;562:		s_startserver.mappics[i].generic.y	    = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 563
;563:		s_startserver.mappics[i].generic.id		= ID_PICTURES+i;
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
line 564
;564:		s_startserver.mappics[i].width  		= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+76
ADDP4
CNSTI4 128
ASGNI4
line 565
;565:		s_startserver.mappics[i].height  	    = 96;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+80
ADDP4
CNSTI4 96
ASGNI4
line 566
;566:		s_startserver.mappics[i].focuspic       = GAMESERVER_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+60
ADDP4
ADDRGP4 $370
ASGNP4
line 567
;567:		s_startserver.mappics[i].errorpic       = GAMESERVER_UNKNOWNMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+64
ADDP4
ADDRGP4 $373
ASGNP4
line 568
;568:		s_startserver.mappics[i].generic.ownerdraw = StartServer_LevelshotDraw;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+56
ADDP4
ADDRGP4 StartServer_LevelshotDraw
ASGNP4
line 570
;569:
;570:		s_startserver.mapbuttons[i].generic.type     = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984
ADDP4
CNSTI4 6
ASGNI4
line 571
;571:		s_startserver.mapbuttons[i].generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_NODEFAULTINIT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
CNSTU4 33028
ASGNU4
line 572
;572:		s_startserver.mapbuttons[i].generic.id       = ID_PICTURES+i;
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
line 573
;573:		s_startserver.mapbuttons[i].generic.callback = StartServer_MapEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+48
ADDP4
ADDRGP4 StartServer_MapEvent
ASGNP4
line 574
;574:		s_startserver.mapbuttons[i].generic.x	     = x - 30;
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
line 575
;575:		s_startserver.mapbuttons[i].generic.y	     = y - 32;
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
line 576
;576:		s_startserver.mapbuttons[i].width  		     = 256;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+76
ADDP4
CNSTI4 256
ASGNI4
line 577
;577:		s_startserver.mapbuttons[i].height  	     = 248;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+80
ADDP4
CNSTI4 248
ASGNI4
line 578
;578:		s_startserver.mapbuttons[i].generic.left     = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 579
;579:		s_startserver.mapbuttons[i].generic.top  	 = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 580
;580:		s_startserver.mapbuttons[i].generic.right    = x + 128;
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
line 581
;581:		s_startserver.mapbuttons[i].generic.bottom   = y + 128;
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
line 582
;582:		s_startserver.mapbuttons[i].focuspic         = GAMESERVER_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+60
ADDP4
ADDRGP4 $401
ASGNP4
line 583
;583:	}
LABELV $352
line 554
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $351
line 585
;584:
;585:	s_startserver.arrows.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+1336
CNSTI4 6
ASGNI4
line 586
;586:	s_startserver.arrows.generic.name  = GAMESERVER_ARROWS;
ADDRGP4 s_startserver+1336+4
ADDRGP4 $405
ASGNP4
line 587
;587:	s_startserver.arrows.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+1336+44
CNSTU4 16384
ASGNU4
line 588
;588:	s_startserver.arrows.generic.x	   = 260;
ADDRGP4 s_startserver+1336+12
CNSTI4 260
ASGNI4
line 589
;589:	s_startserver.arrows.generic.y	   = 400;
ADDRGP4 s_startserver+1336+16
CNSTI4 400
ASGNI4
line 590
;590:	s_startserver.arrows.width  	   = 128;
ADDRGP4 s_startserver+1336+76
CNSTI4 128
ASGNI4
line 591
;591:	s_startserver.arrows.height  	   = 32;
ADDRGP4 s_startserver+1336+80
CNSTI4 32
ASGNI4
line 593
;592:
;593:	s_startserver.prevpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1424
CNSTI4 6
ASGNI4
line 594
;594:	s_startserver.prevpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1424+44
CNSTU4 260
ASGNU4
line 595
;595:	s_startserver.prevpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1424+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 596
;596:	s_startserver.prevpage.generic.id	    = ID_PREVPAGE;
ADDRGP4 s_startserver+1424+8
CNSTI4 15
ASGNI4
line 597
;597:	s_startserver.prevpage.generic.x		= 260;
ADDRGP4 s_startserver+1424+12
CNSTI4 260
ASGNI4
line 598
;598:	s_startserver.prevpage.generic.y		= 400;
ADDRGP4 s_startserver+1424+16
CNSTI4 400
ASGNI4
line 599
;599:	s_startserver.prevpage.width  		    = 64;
ADDRGP4 s_startserver+1424+76
CNSTI4 64
ASGNI4
line 600
;600:	s_startserver.prevpage.height  		    = 32;
ADDRGP4 s_startserver+1424+80
CNSTI4 32
ASGNI4
line 601
;601:	s_startserver.prevpage.focuspic         = GAMESERVER_ARROWSL;
ADDRGP4 s_startserver+1424+60
ADDRGP4 $433
ASGNP4
line 603
;602:
;603:	s_startserver.nextpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1512
CNSTI4 6
ASGNI4
line 604
;604:	s_startserver.nextpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1512+44
CNSTU4 260
ASGNU4
line 605
;605:	s_startserver.nextpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1512+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 606
;606:	s_startserver.nextpage.generic.id	    = ID_NEXTPAGE;
ADDRGP4 s_startserver+1512+8
CNSTI4 16
ASGNI4
line 607
;607:	s_startserver.nextpage.generic.x		= 321;
ADDRGP4 s_startserver+1512+12
CNSTI4 321
ASGNI4
line 608
;608:	s_startserver.nextpage.generic.y		= 400;
ADDRGP4 s_startserver+1512+16
CNSTI4 400
ASGNI4
line 609
;609:	s_startserver.nextpage.width  		    = 64;
ADDRGP4 s_startserver+1512+76
CNSTI4 64
ASGNI4
line 610
;610:	s_startserver.nextpage.height  		    = 32;
ADDRGP4 s_startserver+1512+80
CNSTI4 32
ASGNI4
line 611
;611:	s_startserver.nextpage.focuspic         = GAMESERVER_ARROWSR;
ADDRGP4 s_startserver+1512+60
ADDRGP4 $451
ASGNP4
line 613
;612:
;613:	s_startserver.mapname.generic.type  = MTYPE_PTEXT;
ADDRGP4 s_startserver+1776
CNSTI4 9
ASGNI4
line 614
;614:	s_startserver.mapname.generic.flags = QMF_CENTER_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_startserver+1776+44
CNSTU4 16392
ASGNU4
line 615
;615:	s_startserver.mapname.generic.x	    = 320;
ADDRGP4 s_startserver+1776+12
CNSTI4 320
ASGNI4
line 616
;616:	s_startserver.mapname.generic.y	    = 440;
ADDRGP4 s_startserver+1776+16
CNSTI4 440
ASGNI4
line 617
;617:	s_startserver.mapname.string        = mapnamebuffer;
ADDRGP4 s_startserver+1776+60
ADDRGP4 $292
ASGNP4
line 618
;618:	s_startserver.mapname.style         = UI_CENTER|UI_BIGFONT;
ADDRGP4 s_startserver+1776+64
CNSTI4 33
ASGNI4
line 619
;619:	s_startserver.mapname.color         = text_color_normal;
ADDRGP4 s_startserver+1776+68
ADDRGP4 text_color_normal
ASGNP4
line 621
;620:
;621:	s_startserver.back.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1600
CNSTI4 6
ASGNI4
line 622
;622:	s_startserver.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_startserver+1600+4
ADDRGP4 $468
ASGNP4
line 623
;623:	s_startserver.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1600+44
CNSTU4 260
ASGNU4
line 624
;624:	s_startserver.back.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1600+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 625
;625:	s_startserver.back.generic.id	    = ID_STARTSERVERBACK;
ADDRGP4 s_startserver+1600+8
CNSTI4 17
ASGNI4
line 626
;626:	s_startserver.back.generic.x		= 0;
ADDRGP4 s_startserver+1600+12
CNSTI4 0
ASGNI4
line 627
;627:	s_startserver.back.generic.y		= 480-64;
ADDRGP4 s_startserver+1600+16
CNSTI4 416
ASGNI4
line 628
;628:	s_startserver.back.width  		    = 128;
ADDRGP4 s_startserver+1600+76
CNSTI4 128
ASGNI4
line 629
;629:	s_startserver.back.height  		    = 64;
ADDRGP4 s_startserver+1600+80
CNSTI4 64
ASGNI4
line 630
;630:	s_startserver.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_startserver+1600+60
ADDRGP4 $485
ASGNP4
line 632
;631:
;632:	s_startserver.next.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1688
CNSTI4 6
ASGNI4
line 633
;633:	s_startserver.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_startserver+1688+4
ADDRGP4 $489
ASGNP4
line 634
;634:	s_startserver.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1688+44
CNSTU4 272
ASGNU4
line 635
;635:	s_startserver.next.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1688+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 636
;636:	s_startserver.next.generic.id	    = ID_STARTSERVERNEXT;
ADDRGP4 s_startserver+1688+8
CNSTI4 18
ASGNI4
line 637
;637:	s_startserver.next.generic.x		= 640;
ADDRGP4 s_startserver+1688+12
CNSTI4 640
ASGNI4
line 638
;638:	s_startserver.next.generic.y		= 480-64;
ADDRGP4 s_startserver+1688+16
CNSTI4 416
ASGNI4
line 639
;639:	s_startserver.next.width  		    = 128;
ADDRGP4 s_startserver+1688+76
CNSTI4 128
ASGNI4
line 640
;640:	s_startserver.next.height  		    = 64;
ADDRGP4 s_startserver+1688+80
CNSTI4 64
ASGNI4
line 641
;641:	s_startserver.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_startserver+1688+60
ADDRGP4 $506
ASGNP4
line 643
;642:
;643:	s_startserver.item_null.generic.type	= MTYPE_BITMAP;
ADDRGP4 s_startserver+1848
CNSTI4 6
ASGNI4
line 644
;644:	s_startserver.item_null.generic.flags	= QMF_LEFT_JUSTIFY|QMF_MOUSEONLY|QMF_SILENT;
ADDRGP4 s_startserver+1848+44
CNSTU4 1050628
ASGNU4
line 645
;645:	s_startserver.item_null.generic.x		= 0;
ADDRGP4 s_startserver+1848+12
CNSTI4 0
ASGNI4
line 646
;646:	s_startserver.item_null.generic.y		= 0;
ADDRGP4 s_startserver+1848+16
CNSTI4 0
ASGNI4
line 647
;647:	s_startserver.item_null.width			= 640;
ADDRGP4 s_startserver+1848+76
CNSTI4 640
ASGNI4
line 648
;648:	s_startserver.item_null.height			= 480;
ADDRGP4 s_startserver+1848+80
CNSTI4 480
ASGNI4
line 650
;649:
;650:	Menu_AddItem( &s_startserver.menu, &s_startserver.banner );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 651
;651:	Menu_AddItem( &s_startserver.menu, &s_startserver.framel );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 652
;652:	Menu_AddItem( &s_startserver.menu, &s_startserver.framer );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 654
;653:
;654:	Menu_AddItem( &s_startserver.menu, &s_startserver.gametype );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 655
;655:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $522
line 656
;656:	{
line 657
;657:		Menu_AddItem( &s_startserver.menu, &s_startserver.mappics[i] );
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
line 658
;658:		Menu_AddItem( &s_startserver.menu, &s_startserver.mapbuttons[i] );
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
line 659
;659:	}
LABELV $523
line 655
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $522
line 661
;660:
;661:	Menu_AddItem( &s_startserver.menu, &s_startserver.arrows );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1336
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 662
;662:	Menu_AddItem( &s_startserver.menu, &s_startserver.prevpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1424
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 663
;663:	Menu_AddItem( &s_startserver.menu, &s_startserver.nextpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1512
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 664
;664:	Menu_AddItem( &s_startserver.menu, &s_startserver.back );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1600
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 665
;665:	Menu_AddItem( &s_startserver.menu, &s_startserver.next );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1688
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 666
;666:	Menu_AddItem( &s_startserver.menu, &s_startserver.mapname );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1776
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 667
;667:	Menu_AddItem( &s_startserver.menu, &s_startserver.item_null );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1848
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 669
;668:
;669:	StartServer_GametypeEvent( NULL, QM_ACTIVATED );
CNSTP4 0
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 StartServer_GametypeEvent
CALLV
pop
line 670
;670:}
LABELV $291
endproc StartServer_MenuInit 20 12
export StartServer_Cache
proc StartServer_Cache 100 16
line 679
;671:
;672:
;673:/*
;674:=================
;675:StartServer_Cache
;676:=================
;677:*/
;678:void StartServer_Cache( void )
;679:{
line 685
;680:	int				i;
;681:	const char		*info;
;682:	qboolean		precache;
;683:	char			picname[64];
;684:
;685:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );	
ADDRGP4 $468
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 686
;686:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );	
ADDRGP4 $485
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 687
;687:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT0 );	
ADDRGP4 $489
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 688
;688:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT1 );	
ADDRGP4 $506
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 689
;689:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMEL );	
ADDRGP4 $310
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 690
;690:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMER );	
ADDRGP4 $324
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 691
;691:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );	
ADDRGP4 $401
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 692
;692:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECTED );	
ADDRGP4 $370
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 693
;693:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $373
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 694
;694:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWS );
ADDRGP4 $405
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 695
;695:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSL );
ADDRGP4 $433
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 696
;696:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSR );
ADDRGP4 $451
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 698
;697:
;698:	precache = trap_Cvar_VariableValue("com_buildscript");
ADDRGP4 $536
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
line 700
;699:
;700:	s_startserver.nummaps = UI_GetNumArenas();
ADDRLP4 80
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRGP4 s_startserver+1944
ADDRLP4 80
INDIRI4
ASGNI4
line 702
;701:
;702:	for( i = 0; i < s_startserver.nummaps; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $541
JUMPV
LABELV $538
line 703
;703:		info = UI_GetArenaInfoByNumber( i );
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
line 705
;704:
;705:		Q_strncpyz( s_startserver.maplist[i], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $199
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
line 706
;706:		Q_strupr( s_startserver.maplist[i] );
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
line 707
;707:		s_startserver.mapGamebits[i] = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $194
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
line 709
;708:
;709:		if( precache ) {
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $546
line 710
;710:			Com_sprintf( picname, sizeof(picname), "levelshots/%s", s_startserver.maplist[i] );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $112
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
line 711
;711:			trap_R_RegisterShaderNoMip(picname);
ADDRLP4 8
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 712
;712:		}
LABELV $546
line 713
;713:	}
LABELV $539
line 702
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $541
ADDRLP4 0
INDIRI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $538
line 715
;714:
;715:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
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
line 716
;716:}
LABELV $535
endproc StartServer_Cache 100 16
export UI_StartServerMenu
proc UI_StartServerMenu 0 4
line 724
;717:
;718:
;719:/*
;720:=================
;721:UI_StartServerMenu
;722:=================
;723:*/
;724:void UI_StartServerMenu( qboolean multiplayer ) {
line 725
;725:	StartServer_MenuInit();
ADDRGP4 StartServer_MenuInit
CALLV
pop
line 726
;726:	s_startserver.multiplayer = multiplayer;
ADDRGP4 s_startserver+1936
ADDRFP4 0
INDIRI4
ASGNI4
line 727
;727:	UI_PushMenu( &s_startserver.menu );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 728
;728:}
LABELV $551
endproc UI_StartServerMenu 0 4
data
align 4
LABELV dedicated_list
address $554
address $555
address $556
byte 4 0
align 4
LABELV playerType_list
address $557
address $558
address $559
byte 4 0
align 4
LABELV playerTeam_list
address $560
address $561
byte 4 0
align 4
LABELV botSkill_list
address $562
address $563
address $564
address $565
address $566
byte 4 0
align 4
LABELV assaultMiddleItem_list
address $567
address $568
address $569
address $570
address $571
address $572
address $573
address $574
address $575
address $576
address $577
address $578
address $579
address $580
address $581
byte 4 0
align 4
LABELV respawnTime_list
address $582
address $583
address $584
address $585
address $586
address $587
address $588
address $589
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
line 880
;729:
;730:
;731:
;732:/*
;733:=============================================================================
;734:
;735:SERVER OPTIONS MENU *****
;736:
;737:=============================================================================
;738:*/
;739:
;740:#define ID_PLAYER_TYPE			20
;741:#define ID_MAXCLIENTS			21
;742:#define ID_DEDICATED			22
;743:#define ID_GO					23
;744:#define ID_BACK					24
;745:
;746:#define PLAYER_SLOTS			12
;747:
;748:
;749:typedef struct {
;750:	menuframework_s		menu;
;751:
;752:	menutext_s			banner;
;753:
;754:	menubitmap_s		mappic;
;755:	menubitmap_s		picframe;
;756:
;757:	menulist_s			dedicated;
;758:	menufield_s			timelimit;
;759:	menufield_s			fraglimit;
;760:	menufield_s			flaglimit;
;761:	menuradiobutton_s	friendlyfire;
;762:	menufield_s			hostname;
;763:	menuradiobutton_s	pure;
;764:	menulist_s			botSkill;
;765:	menufield_s			additionalSlots;
;766:	menuradiobutton_s	noPowerups;
;767:	menuradiobutton_s	noHealth;
;768:	menuradiobutton_s	noArmor;
;769:	menuradiobutton_s	noMegaHealth;
;770:	menuradiobutton_s	noPersonalTeleporter;
;771:	menuradiobutton_s	noPlasmaBFG;
;772:	menuradiobutton_s	noLightning;
;773:	menuradiobutton_s	noGrenadeRocket;
;774:	menuradiobutton_s 	noRailgun;
;775:	menuradiobutton_s	enableBlaster;
;776:	menulist_s 			assaultMiddleItem;
;777:	menulist_s 			respawnTime;
;778:
;779:	menutext_s			player0;
;780:	menulist_s			playerType[PLAYER_SLOTS];
;781:	menutext_s			playerName[PLAYER_SLOTS];
;782:	menulist_s			playerTeam[PLAYER_SLOTS];
;783:
;784:	menubitmap_s		go;
;785:	menubitmap_s		next;
;786:	menubitmap_s		back;
;787:
;788:	qboolean			multiplayer;
;789:	int					gametype;
;790:	int					gameMode;
;791:	char				mapnamebuffer[32];
;792:	char				playerNameBuffers[PLAYER_SLOTS][16];
;793:
;794:	qboolean			newBot;
;795:	int					newBotIndex;
;796:	char				newBotName[16];
;797:	
;798:	menulist_s		punkbuster;
;799:} serveroptions_t;
;800:
;801:static serveroptions_t s_serveroptions;
;802:
;803:static const char *dedicated_list[] = {
;804:	"No",
;805:	"LAN",
;806:	"Internet",
;807:	0
;808:};
;809:
;810:static const char *playerType_list[] = {
;811:	"Open",
;812:	"Bot",
;813:	"----",
;814:	0
;815:};
;816:
;817:static const char *playerTeam_list[] = {
;818:	"Blue",
;819:	"Red",
;820:	0
;821:};
;822:
;823:static const char *botSkill_list[] = {
;824:	"I Can Win",
;825:	"Bring It On",
;826:	"Hurt Me Plenty",
;827:	"Hardcore",
;828:	"Nightmare!",
;829:	0
;830:};
;831:
;832:
;833:static const char *assaultMiddleItem_list[] = {
;834:	"All",
;835:	"Heavy Armor",
;836:	"Armor",
;837:	"Mega Health",
;838:	"Medkit",
;839:	"Haste",
;840:	"BFG",
;841:	"Railgun",
;842:	"Shotgun",
;843:	"Rocket Launcher",
;844:	"Grenade Launcher",
;845:	"Lightning Gun",
;846:	"Personal Teleporter",
;847:	"Plasma Gun",
;848:	"Middle Point",
;849:	0
;850:};
;851:
;852:static const char *respawnTime_list[] = {
;853:	"Default",
;854:	"2 seconds",
;855:	"3 seconds",
;856:	"5 seconds",
;857:	"7 seconds",
;858:	"10 seconds",
;859:	"15 seconds",
;860:	"20 seconds",
;861:	0
;862:};
;863:
;864:static int respawnTime_values[] = {
;865:	0,
;866:	2,
;867:	3,
;868:	5,
;869:	7,
;870:	10,
;871:	15,
;872:	20
;873:};
;874:
;875:/*
;876:=================
;877:BotAlreadySelected
;878:=================
;879:*/
;880:static qboolean BotAlreadySelected( const char *checkName ) {
line 883
;881:	int		n;
;882:
;883:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $591
line 884
;884:		if( s_serveroptions.playerType[n].curvalue != 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $595
line 885
;885:			continue;
ADDRGP4 $592
JUMPV
LABELV $595
line 887
;886:		}
;887:		if( (s_serveroptions.gametype >= GT_TEAM) &&
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $599
ADDRLP4 4
CNSTI4 96
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+64
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDRGP4 s_serveroptions+7092
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+64
ADDP4
INDIRI4
EQI4 $599
line 888
;888:			(s_serveroptions.playerTeam[n].curvalue != s_serveroptions.playerTeam[s_serveroptions.newBotIndex].curvalue ) ) {
line 889
;889:			continue;
ADDRGP4 $592
JUMPV
LABELV $599
line 891
;890:		}
;891:		if( Q_stricmp( checkName, s_serveroptions.playerNameBuffers[n] ) == 0 ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $607
line 892
;892:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $590
JUMPV
LABELV $607
line 894
;893:		}
;894:	}
LABELV $592
line 883
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $591
line 896
;895:
;896:	return qfalse;
CNSTI4 0
RETI4
LABELV $590
endproc BotAlreadySelected 12 8
proc ServerOptions_Start 196 24
line 905
;897:}
;898:
;899:
;900:/*
;901:=================
;902:ServerOptions_Start
;903:=================
;904:*/
;905:static void ServerOptions_Start( void ) {
line 918
;906:	int		timelimit;
;907:	int		fraglimit;
;908:	int		maxclients;
;909:	int		additionalSlots;
;910:	int		dedicated;
;911:	int		friendlyfire;
;912:	int		flaglimit;
;913:	int		pure;
;914:	int		skill;
;915:	int		n;
;916:	char		buf[64];
;917:	
;918:	if( s_serveroptions.gameMode ==
ADDRGP4 s_serveroptions+6860
INDIRI4
CNSTI4 12
NEI4 $611
line 919
;919:		UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
line 920
;920:		trap_Cvar_SetValue(
ADDRGP4 $614
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 924
;921:			"fraglimit",
;922:			0
;923:		);
;924:	}
ADDRGP4 $612
JUMPV
LABELV $611
line 925
;925:	else {
line 926
;926:		trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 104
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $614
ARGP4
ADDRLP4 104
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 934
;927:			"fraglimit",
;928:			Com_Clamp(
;929:				0,
;930:				999,
;931:				fraglimit
;932:			)
;933:		);
;934:	}
LABELV $612
line 936
;935:	
;936:	trap_Cmd_ExecuteText(
ADDRGP4 $615
ARGP4
ADDRGP4 s_serveroptions+3252+64
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
line 944
;937:		EXEC_APPEND,
;938:		va(
;939:			"seta ui_respawnTime \"%i\"\n",
;940:			s_serveroptions.respawnTime.curvalue
;941:		)
;942:	);
;943:	
;944:	trap_Cvar_SetValue(
ADDRGP4 $618
ARGP4
ADDRGP4 s_serveroptions+3156+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 949
;945:		"g_assaultMiddleItem",
;946:		s_serveroptions.assaultMiddleItem.curvalue
;947:	);
;948:
;949:	trap_Cmd_ExecuteText(
ADDRGP4 $621
ARGP4
ADDRGP4 s_serveroptions+3156+64
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
line 957
;950:		EXEC_APPEND,
;951:		va(
;952:			"seta ui_assaultMiddleItem \"%i\"\n",
;953:			s_serveroptions.assaultMiddleItem.curvalue
;954:		)
;955:	);
;956:
;957:	timelimit =
ADDRGP4 s_serveroptions+632+60+12
ARGP4
ADDRLP4 112
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 88
ADDRLP4 112
INDIRI4
ASGNI4
line 960
;958:		atoi( s_serveroptions.timelimit.field.buffer );
;959:
;960:	fraglimit =
ADDRGP4 s_serveroptions+964+60+12
ARGP4
ADDRLP4 116
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 84
ADDRLP4 116
INDIRI4
ASGNI4
line 963
;961:		atoi( s_serveroptions.fraglimit.field.buffer );
;962:
;963:	flaglimit =
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
line 966
;964:		atoi( s_serveroptions.flaglimit.field.buffer );
;965:
;966:	dedicated =
ADDRLP4 80
ADDRGP4 s_serveroptions+536+64
INDIRI4
ASGNI4
line 969
;967:		s_serveroptions.dedicated.curvalue;
;968:
;969:	friendlyfire =
ADDRLP4 92
ADDRGP4 s_serveroptions+1628+60
INDIRI4
ASGNI4
line 972
;970:		s_serveroptions.friendlyfire.curvalue;
;971:
;972:	pure =
ADDRLP4 100
ADDRGP4 s_serveroptions+2024+60
INDIRI4
ASGNI4
line 975
;973:		s_serveroptions.pure.curvalue;
;974:
;975:	skill =
ADDRLP4 72
ADDRGP4 s_serveroptions+2088+64
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 981
;976:		s_serveroptions.botSkill.curvalue + 1;
;977:
;978:	/*
;979:	 * Count all visible player slots which are not closed.
;980:	 */
;981:	for( n = 0, maxclients = 0;
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
ADDRGP4 $644
JUMPV
LABELV $641
line 983
;982:		n < PLAYER_SLOTS;
;983:		n++ ) {
line 984
;984:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $645
line 985
;985:			== 2 ) {
line 986
;986:			continue;
ADDRGP4 $642
JUMPV
LABELV $645
line 989
;987:		}
;988:
;989:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $649
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $649
line 992
;990:			== 1 &&
;991:			s_serveroptions.playerNameBuffers[n][0]
;992:			== 0 ) {
line 993
;993:			continue;
ADDRGP4 $642
JUMPV
LABELV $649
line 996
;994:		}
;995:
;996:		maxclients++;
ADDRLP4 68
ADDRLP4 68
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 997
;997:	}
LABELV $642
line 983
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $644
line 982
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $641
line 1002
;998:
;999:	/*
;1000:	 * Add extra free slots.
;1001:	 */
;1002:	additionalSlots = atoi(
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
line 1006
;1003:		s_serveroptions.additionalSlots.field.buffer
;1004:	);
;1005:
;1006:	additionalSlots = (int)Com_Clamp(
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
line 1012
;1007:		0,
;1008:		MAX_CLIENTS - maxclients,
;1009:		additionalSlots
;1010:	);
;1011:
;1012:	trap_Cvar_SetValue(
ADDRGP4 $657
ARGP4
ADDRLP4 76
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1017
;1013:		"ui_additionalSlots",
;1014:		additionalSlots
;1015:	);
;1016:
;1017:	maxclients += additionalSlots;
ADDRLP4 68
ADDRLP4 68
INDIRI4
ADDRLP4 76
INDIRI4
ADDI4
ASGNI4
line 1022
;1018:
;1019:	/*
;1020:	 * Powerups.
;1021:	 */
;1022:	trap_Cvar_SetValue(
ADDRGP4 $658
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1027
;1023:		"ui_noPowerups",
;1024:		s_serveroptions.noPowerups.curvalue
;1025:	);
;1026:
;1027:	trap_Cvar_SetValue(
ADDRGP4 $661
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1035
;1028:		"g_noPowerups",
;1029:		s_serveroptions.noPowerups.curvalue
;1030:	);
;1031:
;1032:	/*
;1033:	 * Mega Health and Medkit share one menu option.
;1034:	 */
;1035:	trap_Cvar_SetValue(
ADDRGP4 $664
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1040
;1036:		"ui_noMegaHealth",
;1037:		s_serveroptions.noMegaHealth.curvalue
;1038:	);
;1039:
;1040:	trap_Cvar_SetValue(
ADDRGP4 $667
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1045
;1041:		"g_noMegaHealth",
;1042:		s_serveroptions.noMegaHealth.curvalue
;1043:	);
;1044:
;1045:	trap_Cvar_SetValue(
ADDRGP4 $670
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1053
;1046:		"g_noMedkit",
;1047:		s_serveroptions.noMegaHealth.curvalue
;1048:	);
;1049:
;1050:	/*
;1051:	 * Personal Teleporter.
;1052:	 */
;1053:	trap_Cvar_SetValue(
ADDRGP4 $673
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1058
;1054:		"ui_noPersonalTeleporter",
;1055:		s_serveroptions.noPersonalTeleporter.curvalue
;1056:	);
;1057:
;1058:	trap_Cvar_SetValue(
ADDRGP4 $676
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1063
;1059:		"g_noPersonalTeleporter",
;1060:		s_serveroptions.noPersonalTeleporter.curvalue
;1061:	);
;1062:
;1063:	trap_Cmd_ExecuteText(
ADDRGP4 $679
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
line 1073
;1064:		EXEC_APPEND,
;1065:		va(
;1066:			"seta ui_noMegaHealth \"%i\"\n"
;1067:			"seta ui_noPersonalTeleporter \"%i\"\n",
;1068:			s_serveroptions.noMegaHealth.curvalue,
;1069:			s_serveroptions.noPersonalTeleporter.curvalue
;1070:		)
;1071:	);
;1072:
;1073:	trap_Cmd_ExecuteText(
ADDRGP4 $684
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
line 1084
;1074:		EXEC_APPEND,
;1075:		va(
;1076:			"seta ui_noPowerups \"%i\"\n",
;1077:			s_serveroptions.noPowerups.curvalue
;1078:		)
;1079:	);
;1080:
;1081:	/*
;1082:	 * Store limits for the selected game type.
;1083:	 */
;1084:	switch( s_serveroptions.gametype ) {
ADDRLP4 144
ADDRGP4 s_serveroptions+6856
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $687
ADDRLP4 144
INDIRI4
CNSTI4 4
GTI4 $687
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $704
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $704
address $690
address $693
address $687
address $696
address $700
code
LABELV $690
LABELV $687
line 1087
;1085:	case GT_FFA:
;1086:	default:
;1087:		trap_Cvar_SetValue(
ADDRGP4 $691
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1092
;1088:			"ui_ffa_fraglimit",
;1089:			fraglimit
;1090:		);
;1091:
;1092:		trap_Cvar_SetValue(
ADDRGP4 $692
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1096
;1093:			"ui_ffa_timelimit",
;1094:			timelimit
;1095:		);
;1096:		break;
ADDRGP4 $688
JUMPV
LABELV $693
line 1099
;1097:
;1098:	case GT_TOURNAMENT:
;1099:		trap_Cvar_SetValue(
ADDRGP4 $694
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1104
;1100:			"ui_tourney_fraglimit",
;1101:			fraglimit
;1102:		);
;1103:
;1104:		trap_Cvar_SetValue(
ADDRGP4 $695
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1108
;1105:			"ui_tourney_timelimit",
;1106:			timelimit
;1107:		);
;1108:		break;
ADDRGP4 $688
JUMPV
LABELV $696
line 1111
;1109:
;1110:	case GT_TEAM:
;1111:		trap_Cvar_SetValue(
ADDRGP4 $697
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1116
;1112:			"ui_team_fraglimit",
;1113:			fraglimit
;1114:		);
;1115:
;1116:		trap_Cvar_SetValue(
ADDRGP4 $698
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1121
;1117:			"ui_team_timelimit",
;1118:			timelimit
;1119:		);
;1120:
;1121:		trap_Cvar_SetValue(
ADDRGP4 $699
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1125
;1122:			"ui_team_friendly",
;1123:			friendlyfire
;1124:		);
;1125:		break;
ADDRGP4 $688
JUMPV
LABELV $700
line 1128
;1126:
;1127:	case GT_CTF:
;1128:		trap_Cvar_SetValue(
ADDRGP4 $701
ARGP4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1133
;1129:			"ui_ctf_capturelimit",
;1130:			flaglimit
;1131:		);
;1132:
;1133:		trap_Cvar_SetValue(
ADDRGP4 $702
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1138
;1134:			"ui_ctf_timelimit",
;1135:			timelimit
;1136:		);
;1137:
;1138:		trap_Cvar_SetValue(
ADDRGP4 $703
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1142
;1139:			"ui_ctf_friendly",
;1140:			friendlyfire
;1141:		);
;1142:		break;
LABELV $688
line 1148
;1143:	}
;1144:
;1145:	/*
;1146:	 * General server settings.
;1147:	 */
;1148:	trap_Cvar_SetValue(
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
ADDRGP4 $705
ARGP4
ADDRLP4 148
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1157
;1149:		"sv_maxclients",
;1150:		Com_Clamp(
;1151:			1,
;1152:			MAX_CLIENTS,
;1153:			maxclients
;1154:		)
;1155:	);
;1156:
;1157:	trap_Cvar_SetValue(
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
ADDRGP4 $706
ARGP4
ADDRLP4 152
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1166
;1158:		"dedicated",
;1159:		Com_Clamp(
;1160:			0,
;1161:			2,
;1162:			dedicated
;1163:		)
;1164:	);
;1165:
;1166:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 156
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $707
ARGP4
ADDRLP4 156
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1175
;1167:		"timelimit",
;1168:		Com_Clamp(
;1169:			0,
;1170:			999,
;1171:			timelimit
;1172:		)
;1173:	);
;1174:
;1175:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 160
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $614
ARGP4
ADDRLP4 160
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1184
;1176:		"fraglimit",
;1177:		Com_Clamp(
;1178:			0,
;1179:			999,
;1180:			fraglimit
;1181:		)
;1182:	);
;1183:
;1184:	trap_Cvar_SetValue(
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
ADDRGP4 $708
ARGP4
ADDRLP4 164
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1193
;1185:		"capturelimit",
;1186:		Com_Clamp(
;1187:			0,
;1188:			100,
;1189:			flaglimit
;1190:		)
;1191:	);
;1192:
;1193:	trap_Cvar_SetValue(
ADDRGP4 $709
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1198
;1194:		"g_friendlyfire",
;1195:		friendlyfire
;1196:	);
;1197:
;1198:	trap_Cvar_SetValue(
ADDRGP4 $710
ARGP4
ADDRLP4 100
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1203
;1199:		"sv_pure",
;1200:		pure
;1201:	);
;1202:
;1203:	trap_Cvar_Set(
ADDRGP4 $711
ARGP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1208
;1204:		"sv_hostname",
;1205:		s_serveroptions.hostname.field.buffer
;1206:	);
;1207:
;1208:	trap_Cvar_SetValue(
ADDRGP4 $715
ARGP4
ADDRGP4 s_serveroptions+7112+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1216
;1209:		"sv_punkbuster",
;1210:		s_serveroptions.punkbuster.curvalue
;1211:	);
;1212:
;1213:	/*
;1214:	 * Blaster Mode.
;1215:	 */
;1216:	trap_Cvar_SetValue(
ADDRGP4 $718
ARGP4
ADDRGP4 s_serveroptions+3092+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1221
;1217:		"ui_enableBlaster",
;1218:		s_serveroptions.enableBlaster.curvalue
;1219:	);
;1220:
;1221:	trap_Cvar_SetValue(
ADDRGP4 $721
ARGP4
ADDRGP4 s_serveroptions+3092+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1226
;1222:		"g_blasterMode",
;1223:		s_serveroptions.enableBlaster.curvalue
;1224:	);
;1225:
;1226:	trap_Cmd_ExecuteText(
ADDRGP4 $724
ARGP4
ADDRGP4 s_serveroptions+3092+60
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
line 1237
;1227:		EXEC_APPEND,
;1228:		va(
;1229:			"seta ui_enableBlaster \"%i\"\n",
;1230:			s_serveroptions.enableBlaster.curvalue
;1231:		)
;1232:	);
;1233:
;1234:	/*
;1235:	 * Weapon pickup restrictions.
;1236:	 */
;1237:	trap_Cvar_SetValue(
ADDRGP4 $727
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1242
;1238:		"g_noPlasmaBFG",
;1239:		s_serveroptions.noPlasmaBFG.curvalue
;1240:	);
;1241:	
;1242:	trap_Cvar_SetValue(
ADDRGP4 $730
ARGP4
ADDRGP4 s_serveroptions+2900+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1247
;1243:		"g_noLightning",
;1244:		s_serveroptions.noLightning.curvalue
;1245:	);
;1246:
;1247:	trap_Cmd_ExecuteText(
ADDRGP4 $733
ARGP4
ADDRGP4 s_serveroptions+2900+60
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
line 1255
;1248:		EXEC_APPEND,
;1249:		va(
;1250:			"seta ui_noLightning \"%i\"\n",
;1251:			s_serveroptions.noLightning.curvalue
;1252:		)
;1253:	);
;1254:
;1255:	trap_Cvar_SetValue(
ADDRGP4 $736
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1260
;1256:		"g_noGrenadeRocket",
;1257:		s_serveroptions.noGrenadeRocket.curvalue
;1258:	);
;1259:	
;1260:	trap_Cvar_SetValue(
ADDRGP4 $739
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1265
;1261:		"ui_noRailgun",
;1262:		s_serveroptions.noRailgun.curvalue
;1263:	);
;1264:
;1265:	trap_Cvar_SetValue(
ADDRGP4 $742
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1270
;1266:		"g_noRailgun",
;1267:		s_serveroptions.noRailgun.curvalue
;1268:	);
;1269:
;1270:	trap_Cmd_ExecuteText(
ADDRGP4 $745
ARGP4
ADDRGP4 s_serveroptions+3028+60
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
line 1278
;1271:		EXEC_APPEND,
;1272:		va(
;1273:			"seta ui_noRailgun \"%i\"\n",
;1274:			s_serveroptions.noRailgun.curvalue
;1275:		)
;1276:	);
;1277:
;1278:	trap_Cmd_ExecuteText(
ADDRGP4 $748
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2964+60
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
line 1291
;1279:		EXEC_APPEND,
;1280:		va(
;1281:			"seta ui_noPlasmaBFG \"%i\"\n"
;1282:			"seta ui_noGrenadeRocket \"%i\"\n",
;1283:			s_serveroptions.noPlasmaBFG.curvalue,
;1284:			s_serveroptions.noGrenadeRocket.curvalue
;1285:		)
;1286:	);
;1287:
;1288:	/*
;1289:	 * Health and armor restrictions.
;1290:	 */
;1291:	trap_Cvar_SetValue(
ADDRGP4 $753
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1296
;1292:		"g_noHealth",
;1293:		s_serveroptions.noHealth.curvalue
;1294:	);
;1295:
;1296:	trap_Cvar_SetValue(
ADDRGP4 $756
ARGP4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1301
;1297:		"g_noArmor",
;1298:		s_serveroptions.noArmor.curvalue
;1299:	);
;1300:
;1301:	trap_Cmd_ExecuteText(
ADDRGP4 $759
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
ARGI4
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
line 1315
;1302:		EXEC_APPEND,
;1303:		va(
;1304:			"seta ui_noHealth \"%i\"\n"
;1305:			"seta ui_noArmor \"%i\"\n",
;1306:			s_serveroptions.noHealth.curvalue,
;1307:			s_serveroptions.noArmor.curvalue
;1308:		)
;1309:	);
;1310:
;1311:	/*
;1312:	 * Disable any previous map rotation. After the match,
;1313:	 * Quake III will restart the current map.
;1314:	 */
;1315:	trap_Cvar_Set(
ADDRGP4 $764
ARGP4
ADDRGP4 $765
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1323
;1316:		"nextmap",
;1317:		"map_restart 0"
;1318:	);
;1319:
;1320:	/*
;1321:	 * Start selected map.
;1322:	 */
;1323:	trap_Cmd_ExecuteText(
ADDRGP4 $766
ARGP4
ADDRGP4 s_startserver+1940
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
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
line 1336
;1324:		EXEC_APPEND,
;1325:		va(
;1326:			"wait; wait; map %s\n",
;1327:			s_startserver.maplist[
;1328:				s_startserver.currentmap
;1329:			]
;1330:		)
;1331:	);
;1332:
;1333:	/*
;1334:	 * Add selected bots after loading the map.
;1335:	 */
;1336:	trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRGP4 $769
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1341
;1337:		EXEC_APPEND,
;1338:		"wait 3\n"
;1339:	);
;1340:
;1341:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $770
line 1342
;1342:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $774
line 1343
;1343:			!= 1 ) {
line 1344
;1344:			continue;
ADDRGP4 $771
JUMPV
LABELV $774
line 1347
;1345:		}
;1346:
;1347:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $778
line 1348
;1348:			== 0 ) {
line 1349
;1349:			continue;
ADDRGP4 $771
JUMPV
LABELV $778
line 1352
;1350:		}
;1351:
;1352:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $781
line 1353
;1353:			== '-' ) {
line 1354
;1354:			continue;
ADDRGP4 $771
JUMPV
LABELV $781
line 1357
;1355:		}
;1356:
;1357:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $784
line 1358
;1358:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $787
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+64
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
line 1369
;1359:				buf,
;1360:				sizeof(buf),
;1361:				"addbot %s %i %s\n",
;1362:				s_serveroptions.playerNameBuffers[n],
;1363:				skill,
;1364:				playerTeam_list[
;1365:					s_serveroptions.playerTeam[n]
;1366:						.curvalue
;1367:				]
;1368:			);
;1369:		}
ADDRGP4 $785
JUMPV
LABELV $784
line 1370
;1370:		else {
line 1371
;1371:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $791
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1378
;1372:				buf,
;1373:				sizeof(buf),
;1374:				"addbot %s %i\n",
;1375:				s_serveroptions.playerNameBuffers[n],
;1376:				skill
;1377:			);
;1378:		}
LABELV $785
line 1380
;1379:
;1380:		trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1384
;1381:			EXEC_APPEND,
;1382:			buf
;1383:		);
;1384:	}
LABELV $771
line 1341
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $770
line 1389
;1385:
;1386:	/*
;1387:	 * Place the local player on the selected team.
;1388:	 */
;1389:	if( dedicated == 0 &&
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $793
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $793
line 1390
;1390:		s_serveroptions.gametype >= GT_TEAM ) {
line 1391
;1391:		trap_Cmd_ExecuteText(
ADDRGP4 $796
ARGP4
ADDRGP4 s_serveroptions+5436+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 playerTeam_list
ADDP4
INDIRP4
ARGP4
ADDRLP4 192
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 192
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1401
;1392:			EXEC_APPEND,
;1393:			va(
;1394:				"wait 5; team %s\n",
;1395:				playerTeam_list[
;1396:					s_serveroptions.playerTeam[0]
;1397:						.curvalue
;1398:				]
;1399:			)
;1400:		);
;1401:	}
LABELV $793
line 1402
;1402:}
LABELV $610
endproc ServerOptions_Start 196 24
proc ServerOptions_InitPlayerItems 12 12
line 1410
;1403:
;1404:
;1405:/*
;1406:=================
;1407:ServerOptions_InitPlayerItems
;1408:=================
;1409:*/
;1410:static void ServerOptions_InitPlayerItems( void ) {
line 1415
;1411:	int		n;
;1412:	int		v;
;1413:
;1414:	// init types
;1415:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6852
INDIRI4
CNSTI4 0
EQI4 $800
line 1416
;1416:		v = 0;	// open
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1417
;1417:	}
ADDRGP4 $801
JUMPV
LABELV $800
line 1418
;1418:	else {
line 1419
;1419:		v = 1;	// bot
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1420
;1420:	}
LABELV $801
line 1422
;1421:	
;1422:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $803
line 1423
;1423:		s_serveroptions.playerType[n].curvalue = v;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1424
;1424:	}
LABELV $804
line 1422
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $803
line 1426
;1425:
;1426:	if( s_serveroptions.multiplayer && (s_serveroptions.gametype < GT_TEAM) ) {
ADDRGP4 s_serveroptions+6852
INDIRI4
CNSTI4 0
EQI4 $809
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
GEI4 $809
line 1427
;1427:		for( n = 8; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 8
ASGNI4
LABELV $813
line 1428
;1428:			s_serveroptions.playerType[n].curvalue = 2;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
CNSTI4 2
ASGNI4
line 1429
;1429:		}
LABELV $814
line 1427
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $813
line 1430
;1430:	}
LABELV $809
line 1433
;1431:
;1432:	// if not a dedicated server, first slot is reserved for the human on the server
;1433:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $819
line 1435
;1434:		// human
;1435:		s_serveroptions.playerType[0].generic.flags |= QMF_INACTIVE;
ADDRLP4 8
ADDRGP4 s_serveroptions+3420+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 1436
;1436:		s_serveroptions.playerType[0].curvalue = 0;
ADDRGP4 s_serveroptions+3420+64
CNSTI4 0
ASGNI4
line 1437
;1437:		trap_Cvar_VariableStringBuffer( "name", s_serveroptions.playerNameBuffers[0], sizeof(s_serveroptions.playerNameBuffers[0]) );
ADDRGP4 $827
ARGP4
ADDRGP4 s_serveroptions+6896
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 1438
;1438:		Q_CleanStr( s_serveroptions.playerNameBuffers[0] );
ADDRGP4 s_serveroptions+6896
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1439
;1439:	}
LABELV $819
line 1442
;1440:
;1441:	// init teams
;1442:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $831
line 1443
;1443:		for( n = 0; n < (PLAYER_SLOTS / 2); n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $834
line 1444
;1444:			s_serveroptions.playerTeam[n].curvalue = 0;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+64
ADDP4
CNSTI4 0
ASGNI4
line 1445
;1445:		}
LABELV $835
line 1443
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 6
LTI4 $834
line 1446
;1446:		for( ; n < PLAYER_SLOTS; n++ ) {
ADDRGP4 $843
JUMPV
LABELV $840
line 1447
;1447:			s_serveroptions.playerTeam[n].curvalue = 1;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+64
ADDP4
CNSTI4 1
ASGNI4
line 1448
;1448:		}
LABELV $841
line 1446
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $843
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $840
line 1449
;1449:	}
ADDRGP4 $832
JUMPV
LABELV $831
line 1450
;1450:	else {
line 1451
;1451:		for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $846
line 1452
;1452:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+44
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
line 1453
;1453:		}
LABELV $847
line 1451
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $846
line 1454
;1454:	}
LABELV $832
line 1455
;1455:}
LABELV $799
endproc ServerOptions_InitPlayerItems 12 12
proc ServerOptions_SetPlayerItems 12 0
line 1463
;1456:
;1457:
;1458:/*
;1459:=================
;1460:ServerOptions_SetPlayerItems
;1461:=================
;1462:*/
;1463:static void ServerOptions_SetPlayerItems( void ) {
line 1475
;1464:	int		start;
;1465:	int		n;
;1466:
;1467:	// types
;1468://	for( n = 0; n < PLAYER_SLOTS; n++ ) {
;1469://		if( (!s_serveroptions.multiplayer) && (n > 0) && (s_serveroptions.playerType[n].curvalue == 0) ) {
;1470://			s_serveroptions.playerType[n].curvalue = 1;
;1471://		}
;1472://	}
;1473:
;1474:	// names
;1475:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $853
line 1476
;1476:		s_serveroptions.player0.string = "Human";
ADDRGP4 s_serveroptions+3348+60
ADDRGP4 $859
ASGNP4
line 1477
;1477:		s_serveroptions.playerName[0].generic.flags &= ~QMF_HIDDEN;
ADDRLP4 8
ADDRGP4 s_serveroptions+4572+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294963199
BANDU4
ASGNU4
line 1479
;1478:
;1479:		start = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1480
;1480:	}
ADDRGP4 $854
JUMPV
LABELV $853
line 1481
;1481:	else {
line 1482
;1482:		s_serveroptions.player0.string = "Open";
ADDRGP4 s_serveroptions+3348+60
ADDRGP4 $557
ASGNP4
line 1483
;1483:		start = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1484
;1484:	}
LABELV $854
line 1485
;1485:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $867
JUMPV
LABELV $864
line 1486
;1486:		if( s_serveroptions.playerType[n].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $868
line 1487
;1487:			s_serveroptions.playerName[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+44
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
line 1488
;1488:		}
ADDRGP4 $869
JUMPV
LABELV $868
line 1489
;1489:		else {
line 1490
;1490:			s_serveroptions.playerName[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+44
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
line 1491
;1491:		}
LABELV $869
line 1492
;1492:	}
LABELV $865
line 1485
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $867
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $864
line 1495
;1493:
;1494:	// teams
;1495:	if( s_serveroptions.gametype < GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
GEI4 $876
line 1496
;1496:		return;
ADDRGP4 $852
JUMPV
LABELV $876
line 1498
;1497:	}
;1498:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $882
JUMPV
LABELV $879
line 1499
;1499:		if( s_serveroptions.playerType[n].curvalue == 2 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $883
line 1500
;1500:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+44
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
line 1501
;1501:		}
ADDRGP4 $884
JUMPV
LABELV $883
line 1502
;1502:		else {
line 1503
;1503:			s_serveroptions.playerTeam[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+44
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
line 1504
;1504:		}
LABELV $884
line 1505
;1505:	}
LABELV $880
line 1498
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $882
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $879
line 1506
;1506:}
LABELV $852
endproc ServerOptions_SetPlayerItems 12 0
proc ServerOptions_Event 8 0
line 1514
;1507:
;1508:
;1509:/*
;1510:=================
;1511:ServerOptions_Event
;1512:=================
;1513:*/
;1514:static void ServerOptions_Event( void* ptr, int event ) {
line 1515
;1515:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $892
ADDRLP4 0
INDIRI4
CNSTI4 24
GTI4 $892
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $908-72
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $908
address $902
address $892
address $895
address $898
address $898
address $899
address $905
code
LABELV $895
line 1521
;1516:	
;1517:	//if( event != QM_ACTIVATED && event != QM_LOSTFOCUS) {
;1518:	//	return;
;1519:	//}
;1520:	case ID_PLAYER_TYPE:
;1521:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $896
line 1522
;1522:			break;
ADDRGP4 $893
JUMPV
LABELV $896
line 1524
;1523:		}
;1524:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1525
;1525:		break;
ADDRGP4 $893
JUMPV
LABELV $898
line 1529
;1526:
;1527:	case ID_MAXCLIENTS:
;1528:	case ID_DEDICATED:
;1529:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1530
;1530:		break;
ADDRGP4 $893
JUMPV
LABELV $899
line 1532
;1531:	case ID_GO:
;1532:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $900
line 1533
;1533:			break;
ADDRGP4 $893
JUMPV
LABELV $900
line 1535
;1534:		}
;1535:		ServerOptions_Start();
ADDRGP4 ServerOptions_Start
CALLV
pop
line 1536
;1536:		break;
ADDRGP4 $893
JUMPV
LABELV $902
line 1539
;1537:
;1538:	case ID_STARTSERVERNEXT:
;1539:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $893
line 1540
;1540:			break;
ADDRGP4 $893
JUMPV
line 1542
;1541:		}
;1542:		break;
LABELV $905
line 1544
;1543:	case ID_BACK:
;1544:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $906
line 1545
;1545:			break;
ADDRGP4 $893
JUMPV
LABELV $906
line 1547
;1546:		}
;1547:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 1548
;1548:		break;
LABELV $892
LABELV $893
line 1550
;1549:	}
;1550:}
LABELV $891
endproc ServerOptions_Event 8 0
proc ServerOptions_PlayerNameEvent 4 4
line 1553
;1551:
;1552:
;1553:static void ServerOptions_PlayerNameEvent( void* ptr, int event ) {
line 1556
;1554:	int		n;
;1555:
;1556:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $911
line 1557
;1557:		return;
ADDRGP4 $910
JUMPV
LABELV $911
line 1559
;1558:	}
;1559:	n = ((menutext_s*)ptr)->generic.id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1560
;1560:	s_serveroptions.newBotIndex = n;
ADDRGP4 s_serveroptions+7092
ADDRLP4 0
INDIRI4
ASGNI4
line 1561
;1561:	UI_BotSelectMenu( s_serveroptions.playerNameBuffers[n] );
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ARGP4
ADDRGP4 UI_BotSelectMenu
CALLV
pop
line 1562
;1562:}
LABELV $910
endproc ServerOptions_PlayerNameEvent 4 4
proc ServerOptions_StatusBar 4 20
line 1570
;1563:
;1564:
;1565:/*
;1566:=================
;1567:ServerOptions_StatusBar
;1568:=================
;1569:*/
;1570:static void ServerOptions_StatusBar( void* ptr ) {
line 1571
;1571:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $916
JUMPV
LABELV $916
line 1573
;1572:	default:
;1573:		UI_DrawString( 320, 440, "0 = NO LIMIT", UI_CENTER|UI_SMALLFONT, colorWhite );
CNSTI4 320
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $919
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 colorWhite
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1574
;1574:		break;
LABELV $917
line 1576
;1575:	}
;1576:}
LABELV $915
endproc ServerOptions_StatusBar 4 20
proc ServerOptions_LevelshotDraw 24 20
line 1584
;1577:
;1578:
;1579:/*
;1580:===============
;1581:ServerOptions_LevelshotDraw
;1582:===============
;1583:*/
;1584:static void ServerOptions_LevelshotDraw( void *self ) {
line 1590
;1585:	menubitmap_s	*b;
;1586:	int				x;
;1587:	int				y;
;1588:
;1589:	// strange place for this, but it works
;1590:	if( s_serveroptions.newBot ) {
ADDRGP4 s_serveroptions+7088
INDIRI4
CNSTI4 0
EQI4 $921
line 1591
;1591:		Q_strncpyz( s_serveroptions.playerNameBuffers[s_serveroptions.newBotIndex], s_serveroptions.newBotName, 16 );
ADDRGP4 s_serveroptions+7092
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ARGP4
ADDRGP4 s_serveroptions+7096
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1592
;1592:		s_serveroptions.newBot = qfalse;
ADDRGP4 s_serveroptions+7088
CNSTI4 0
ASGNI4
line 1593
;1593:	}
LABELV $921
line 1595
;1594:
;1595:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1597
;1596:
;1597:	Bitmap_Draw( b );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Bitmap_Draw
CALLV
pop
line 1599
;1598:
;1599:	x = b->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1600
;1600:	y = b->generic.y + b->height;
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
line 1601
;1601:	UI_FillRect( x, y, b->width, 40, colorBlack );
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
line 1603
;1602:
;1603:	x += b->width / 2;
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
line 1604
;1604:	y += 4;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 1605
;1605:	UI_DrawString( x, y, s_serveroptions.mapnamebuffer, UI_CENTER|UI_SMALLFONT, color_orange );
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+6864
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1607
;1606:
;1607:	y += SMALLCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1608
;1608:	if( trap_Cvar_VariableValue("g_assaultMode") != 0 ) {
ADDRGP4 $261
ARGP4
ADDRLP4 16
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 0
EQF4 $929
line 1609
;1609:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $931
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1616
;1610:			x,
;1611:			y,
;1612:			"Base Assault",
;1613:			UI_CENTER | UI_SMALLFONT,
;1614:			color_orange
;1615:		);
;1616:	}
ADDRGP4 $930
JUMPV
LABELV $929
line 1617
;1617:	else if( trap_Cvar_VariableValue("g_autoCTF") != 0 ) {
ADDRGP4 $266
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $932
line 1618
;1618:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $76
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1625
;1619:			x,
;1620:			y,
;1621:			"CTF on TDM Maps",
;1622:			UI_CENTER | UI_SMALLFONT,
;1623:			color_orange
;1624:		);
;1625:	}
ADDRGP4 $933
JUMPV
LABELV $932
line 1626
;1626:	else {
line 1627
;1627:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+6860
INDIRI4
CNSTI4 2
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
line 1636
;1628:			x,
;1629:			y,
;1630:			gametype_items[
;1631:				s_serveroptions.gameMode
;1632:			],
;1633:			UI_CENTER | UI_SMALLFONT,
;1634:			color_orange
;1635:		);
;1636:	}
LABELV $933
LABELV $930
line 1637
;1637:}
LABELV $920
endproc ServerOptions_LevelshotDraw 24 20
proc ServerOptions_InitBotNames 1072 12
line 1640
;1638:
;1639:
;1640:static void ServerOptions_InitBotNames( void ) {
line 1649
;1641:	int			count;
;1642:	int			n;
;1643:	const char	*arenaInfo;
;1644:	const char	*botInfo;
;1645:	char		*p;
;1646:	char		*bot;
;1647:	char		bots[MAX_INFO_STRING];
;1648:
;1649:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $936
line 1650
;1650:		Q_strncpyz( s_serveroptions.playerNameBuffers[1], "grunt", 16 );
ADDRGP4 s_serveroptions+6896+16
ARGP4
ADDRGP4 $941
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1651
;1651:		Q_strncpyz( s_serveroptions.playerNameBuffers[2], "major", 16 );
ADDRGP4 s_serveroptions+6896+32
ARGP4
ADDRGP4 $944
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1652
;1652:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
NEI4 $945
line 1653
;1653:			Q_strncpyz( s_serveroptions.playerNameBuffers[3], "visor", 16 );
ADDRGP4 s_serveroptions+6896+48
ARGP4
ADDRGP4 $950
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1654
;1654:		}
ADDRGP4 $946
JUMPV
LABELV $945
line 1655
;1655:		else {
line 1656
;1656:			s_serveroptions.playerType[3].curvalue = 2;
ADDRGP4 s_serveroptions+3420+288+64
CNSTI4 2
ASGNI4
line 1657
;1657:		}
LABELV $946
line 1658
;1658:		s_serveroptions.playerType[4].curvalue = 2;
ADDRGP4 s_serveroptions+3420+384+64
CNSTI4 2
ASGNI4
line 1659
;1659:		s_serveroptions.playerType[5].curvalue = 2;
ADDRGP4 s_serveroptions+3420+480+64
CNSTI4 2
ASGNI4
line 1661
;1660:
;1661:		Q_strncpyz( s_serveroptions.playerNameBuffers[6], "sarge", 16 );
ADDRGP4 s_serveroptions+6896+96
ARGP4
ADDRGP4 $962
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1662
;1662:		Q_strncpyz( s_serveroptions.playerNameBuffers[7], "grunt", 16 );
ADDRGP4 s_serveroptions+6896+112
ARGP4
ADDRGP4 $941
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1663
;1663:		Q_strncpyz( s_serveroptions.playerNameBuffers[8], "major", 16 );
ADDRGP4 s_serveroptions+6896+128
ARGP4
ADDRGP4 $944
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1664
;1664:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
NEI4 $967
line 1665
;1665:			Q_strncpyz( s_serveroptions.playerNameBuffers[9], "visor", 16 );
ADDRGP4 s_serveroptions+6896+144
ARGP4
ADDRGP4 $950
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1666
;1666:		}
ADDRGP4 $968
JUMPV
LABELV $967
line 1667
;1667:		else {
line 1668
;1668:			s_serveroptions.playerType[9].curvalue = 2;
ADDRGP4 s_serveroptions+3420+864+64
CNSTI4 2
ASGNI4
line 1669
;1669:		}
LABELV $968
line 1670
;1670:		s_serveroptions.playerType[10].curvalue = 2;
ADDRGP4 s_serveroptions+3420+960+64
CNSTI4 2
ASGNI4
line 1671
;1671:		s_serveroptions.playerType[11].curvalue = 2;
ADDRGP4 s_serveroptions+3420+1056+64
CNSTI4 2
ASGNI4
line 1673
;1672:
;1673:		return;
ADDRGP4 $935
JUMPV
LABELV $936
line 1676
;1674:	}
;1675:
;1676:	count = 1;	// skip the first slot, reserved for a human
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1679
;1677:
;1678:	// get info for this map
;1679:	arenaInfo = UI_GetArenaInfoByMap( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6864
ARGP4
ADDRLP4 1048
ADDRGP4 UI_GetArenaInfoByMap
CALLP4
ASGNP4
ADDRLP4 1044
ADDRLP4 1048
INDIRP4
ASGNP4
line 1682
;1680:
;1681:	// get the bot info - we'll seed with them if any are listed
;1682:	Q_strncpyz( bots, Info_ValueForKey( arenaInfo, "bots" ), sizeof(bots) );
ADDRLP4 1044
INDIRP4
ARGP4
ADDRGP4 $982
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
line 1683
;1683:	p = &bots[0];
ADDRLP4 0
ADDRLP4 20
ASGNP4
ADDRGP4 $984
JUMPV
line 1684
;1684:	while( *p && count < PLAYER_SLOTS ) {
LABELV $986
line 1686
;1685:		//skip spaces
;1686:		while( *p && *p == ' ' ) {
line 1687
;1687:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1688
;1688:		}
LABELV $987
line 1686
ADDRLP4 1056
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1056
INDIRI4
CNSTI4 0
EQI4 $989
ADDRLP4 1056
INDIRI4
CNSTI4 32
EQI4 $986
LABELV $989
line 1689
;1689:		if( !p ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $990
line 1690
;1690:			break;
ADDRGP4 $985
JUMPV
LABELV $990
line 1694
;1691:		}
;1692:
;1693:		// mark start of bot name
;1694:		bot = p;
ADDRLP4 8
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $993
JUMPV
LABELV $992
line 1697
;1695:
;1696:		// skip until space of null
;1697:		while( *p && *p != ' ' ) {
line 1698
;1698:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1699
;1699:		}
LABELV $993
line 1697
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $995
ADDRLP4 1060
INDIRI4
CNSTI4 32
NEI4 $992
LABELV $995
line 1700
;1700:		if( *p ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $996
line 1701
;1701:			*p++ = 0;
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
line 1702
;1702:		}
LABELV $996
line 1704
;1703:
;1704:		botInfo = UI_GetBotInfoByName( bot );
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
line 1705
;1705:		bot = Info_ValueForKey( botInfo, "name" );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 $827
ARGP4
ADDRLP4 1068
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1068
INDIRP4
ASGNP4
line 1707
;1706:
;1707:		Q_strncpyz( s_serveroptions.playerNameBuffers[count], bot, sizeof(s_serveroptions.playerNameBuffers[count]) );
ADDRLP4 4
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
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
line 1708
;1708:		count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1709
;1709:	}
LABELV $984
line 1684
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $1000
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $987
LABELV $1000
LABELV $985
line 1712
;1710:
;1711:	// set the rest of the bot slots to "---"
;1712:	for( n = count; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $1004
JUMPV
LABELV $1001
line 1713
;1713:		strcpy( s_serveroptions.playerNameBuffers[n], "--------" );
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ARGP4
ADDRGP4 $1006
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1714
;1714:	}
LABELV $1002
line 1712
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1004
ADDRLP4 12
INDIRI4
CNSTI4 12
LTI4 $1001
line 1717
;1715:
;1716:	// pad up to #8 as open slots
;1717:	for( ;count < 8; count++ ) {
ADDRGP4 $1010
JUMPV
LABELV $1007
line 1718
;1718:		s_serveroptions.playerType[count].curvalue = 0;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
CNSTI4 0
ASGNI4
line 1719
;1719:	}
LABELV $1008
line 1717
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1010
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $1007
line 1722
;1720:
;1721:	// close off the rest by default
;1722:	for( ;count < PLAYER_SLOTS; count++ ) {
ADDRGP4 $1016
JUMPV
LABELV $1013
line 1723
;1723:		if( s_serveroptions.playerType[count].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $1017
line 1724
;1724:			s_serveroptions.playerType[count].curvalue = 2;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+64
ADDP4
CNSTI4 2
ASGNI4
line 1725
;1725:		}
LABELV $1017
line 1726
;1726:	}
LABELV $1014
line 1722
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1016
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $1013
line 1727
;1727:}
LABELV $935
endproc ServerOptions_InitBotNames 1072 12
bss
align 1
LABELV $1024
skip 64
code
proc ServerOptions_SetMenuItems 188 16
line 1735
;1728:
;1729:
;1730:/*
;1731:=================
;1732:ServerOptions_SetMenuItems
;1733:=================
;1734:*/
;1735:static void ServerOptions_SetMenuItems( void ) {
line 1738
;1736:	static char picname[64];
;1737:	
;1738:	s_serveroptions.respawnTime.curvalue =
ADDRGP4 $1027
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
ADDRGP4 s_serveroptions+3252+64
ADDRLP4 4
INDIRF4
CVFI4 4
ASGNI4
line 1747
;1739:	(int)Com_Clamp(
;1740:		0,
;1741:		7,
;1742:		trap_Cvar_VariableValue(
;1743:			"ui_respawnTime"
;1744:		)
;1745:	);
;1746:	
;1747:	s_serveroptions.assaultMiddleItem.curvalue =
ADDRGP4 $1030
ARGP4
ADDRLP4 8
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1096810496
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+3156+64
ADDRLP4 12
INDIRF4
CVFI4 4
ASGNI4
line 1756
;1748:		(int)Com_Clamp(
;1749:			0,
;1750:			14,
;1751:			trap_Cvar_VariableValue(
;1752:				"ui_assaultMiddleItem"
;1753:			)
;1754:		);
;1755:
;1756:	s_serveroptions.noHealth.curvalue =
ADDRGP4 $1033
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $1035
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $1036
JUMPV
LABELV $1035
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1036
ADDRGP4 s_serveroptions+2580+60
ADDRLP4 16
INDIRI4
ASGNI4
line 1759
;1757:			trap_Cvar_VariableValue( "ui_noHealth" ) != 0;
;1758:
;1759:	s_serveroptions.noArmor.curvalue =
ADDRGP4 $1039
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 0
EQF4 $1041
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1042
JUMPV
LABELV $1041
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1042
ADDRGP4 s_serveroptions+2644+60
ADDRLP4 24
INDIRI4
ASGNI4
line 1762
;1760:		trap_Cvar_VariableValue( "ui_noArmor" ) != 0;
;1761:
;1762:	s_serveroptions.noPlasmaBFG.curvalue =
ADDRGP4 $1045
ARGP4
ADDRLP4 36
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
EQF4 $1047
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRGP4 $1048
JUMPV
LABELV $1047
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $1048
ADDRGP4 s_serveroptions+2836+60
ADDRLP4 32
INDIRI4
ASGNI4
line 1765
;1763:		trap_Cvar_VariableValue( "ui_noPlasmaBFG" ) != 0;
;1764:		
;1765:	s_serveroptions.noLightning.curvalue =
ADDRGP4 $1051
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 44
INDIRF4
CNSTF4 0
EQF4 $1053
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $1054
JUMPV
LABELV $1053
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $1054
ADDRGP4 s_serveroptions+2900+60
ADDRLP4 40
INDIRI4
ASGNI4
line 1770
;1766:		trap_Cvar_VariableValue(
;1767:			"ui_noLightning"
;1768:		) != 0;	
;1769:
;1770:	s_serveroptions.noGrenadeRocket.curvalue =
ADDRGP4 $1057
ARGP4
ADDRLP4 52
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 0
EQF4 $1059
ADDRLP4 48
CNSTI4 1
ASGNI4
ADDRGP4 $1060
JUMPV
LABELV $1059
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $1060
ADDRGP4 s_serveroptions+2964+60
ADDRLP4 48
INDIRI4
ASGNI4
line 1773
;1771:		trap_Cvar_VariableValue( "ui_noGrenadeRocket" ) != 0;
;1772:		
;1773:	s_serveroptions.noRailgun.curvalue =
ADDRGP4 $739
ARGP4
ADDRLP4 60
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 60
INDIRF4
CNSTF4 0
EQF4 $1064
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $1065
JUMPV
LABELV $1064
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $1065
ADDRGP4 s_serveroptions+3028+60
ADDRLP4 56
INDIRI4
ASGNI4
line 1776
;1774:		trap_Cvar_VariableValue( "ui_noRailgun" ) != 0;
;1775:		
;1776:	s_serveroptions.enableBlaster.curvalue =
ADDRGP4 $718
ARGP4
ADDRLP4 68
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
EQF4 $1069
ADDRLP4 64
CNSTI4 1
ASGNI4
ADDRGP4 $1070
JUMPV
LABELV $1069
ADDRLP4 64
CNSTI4 0
ASGNI4
LABELV $1070
ADDRGP4 s_serveroptions+3092+60
ADDRLP4 64
INDIRI4
ASGNI4
line 1779
;1777:		trap_Cvar_VariableValue( "ui_enableBlaster" ) != 0;
;1778:		
;1779:	s_serveroptions.noMegaHealth.curvalue =
ADDRGP4 $664
ARGP4
ADDRLP4 76
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 76
INDIRF4
CNSTF4 0
EQF4 $1074
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRGP4 $1075
JUMPV
LABELV $1074
ADDRLP4 72
CNSTI4 0
ASGNI4
LABELV $1075
ADDRGP4 s_serveroptions+2708+60
ADDRLP4 72
INDIRI4
ASGNI4
line 1782
;1780:		trap_Cvar_VariableValue( "ui_noMegaHealth" ) != 0;
;1781:
;1782:	s_serveroptions.noPersonalTeleporter.curvalue =
ADDRGP4 $673
ARGP4
ADDRLP4 84
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 84
INDIRF4
CNSTF4 0
EQF4 $1079
ADDRLP4 80
CNSTI4 1
ASGNI4
ADDRGP4 $1080
JUMPV
LABELV $1079
ADDRLP4 80
CNSTI4 0
ASGNI4
LABELV $1080
ADDRGP4 s_serveroptions+2772+60
ADDRLP4 80
INDIRI4
ASGNI4
line 1787
;1783:			trap_Cvar_VariableValue(
;1784:				"ui_noPersonalTeleporter"
;1785:			) != 0;
;1786:		
;1787:	s_serveroptions.noPowerups.curvalue =
ADDRGP4 $658
ARGP4
ADDRLP4 92
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 92
INDIRF4
CNSTF4 0
EQF4 $1084
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $1085
JUMPV
LABELV $1084
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $1085
ADDRGP4 s_serveroptions+2516+60
ADDRLP4 88
INDIRI4
ASGNI4
line 1790
;1788:		trap_Cvar_VariableValue( "ui_noPowerups" ) != 0;
;1789:
;1790:	Com_sprintf(
ADDRGP4 $657
ARGP4
ADDRLP4 96
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1115422720
ARGF4
ADDRLP4 96
INDIRF4
ARGF4
ADDRLP4 100
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+2184+60+12
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 100
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1801
;1791:			s_serveroptions.additionalSlots.field.buffer,
;1792:			sizeof( s_serveroptions.additionalSlots.field.buffer ),
;1793:			"%i",
;1794:			(int)Com_Clamp(
;1795:				0,
;1796:				MAX_CLIENTS - 1,
;1797:				trap_Cvar_VariableValue( "ui_additionalSlots" )
;1798:			)
;1799:		);
;1800:
;1801:	switch( s_serveroptions.gametype ) {
ADDRLP4 104
ADDRGP4 s_serveroptions+6856
INDIRI4
ASGNI4
ADDRLP4 104
INDIRI4
CNSTI4 0
LTI4 $1093
ADDRLP4 104
INDIRI4
CNSTI4 4
GTI4 $1093
ADDRLP4 104
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $1128
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $1128
address $1096
address $1103
address $1093
address $1110
address $1119
code
LABELV $1096
LABELV $1093
line 1804
;1802:	case GT_FFA:
;1803:	default:
;1804:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_fraglimit" ) ) );
ADDRGP4 $691
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
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 112
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1805
;1805:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_timelimit" ) ) );
ADDRGP4 $692
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
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 120
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1806
;1806:		break;
ADDRGP4 $1094
JUMPV
LABELV $1103
line 1809
;1807:
;1808:	case GT_TOURNAMENT:
;1809:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_fraglimit" ) ) );
ADDRGP4 $694
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
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 128
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1810
;1810:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_timelimit" ) ) );
ADDRGP4 $695
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
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 136
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1811
;1811:		break;
ADDRGP4 $1094
JUMPV
LABELV $1110
line 1814
;1812:
;1813:	case GT_TEAM:
;1814:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_fraglimit" ) ) );
ADDRGP4 $697
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
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 144
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1815
;1815:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_timelimit" ) ) );
ADDRGP4 $698
ARGP4
ADDRLP4 148
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 148
INDIRF4
ARGF4
ADDRLP4 152
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 152
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1816
;1816:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_team_friendly" ) );
ADDRGP4 $699
ARGP4
ADDRLP4 156
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 156
INDIRF4
ARGF4
ADDRLP4 160
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1628+60
ADDRLP4 160
INDIRF4
CVFI4 4
ASGNI4
line 1817
;1817:		break;
ADDRGP4 $1094
JUMPV
LABELV $1119
line 1820
;1818:
;1819:	case GT_CTF:
;1820:		Com_sprintf( s_serveroptions.flaglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 100, trap_Cvar_VariableValue( "ui_ctf_capturelimit" ) ) );
ADDRGP4 $701
ARGP4
ADDRLP4 164
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1120403456
ARGF4
ADDRLP4 164
INDIRF4
ARGF4
ADDRLP4 168
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1296+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 168
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1821
;1821:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ctf_timelimit" ) ) );
ADDRGP4 $702
ARGP4
ADDRLP4 172
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 172
INDIRF4
ARGF4
ADDRLP4 176
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1092
ARGP4
ADDRLP4 176
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1822
;1822:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_ctf_friendly" ) );
ADDRGP4 $703
ARGP4
ADDRLP4 180
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 180
INDIRF4
ARGF4
ADDRLP4 184
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1628+60
ADDRLP4 184
INDIRF4
CVFI4 4
ASGNI4
line 1823
;1823:		break;
LABELV $1094
line 1826
;1824:	}
;1825:
;1826:	Q_strncpyz( s_serveroptions.hostname.field.buffer, UI_Cvar_VariableString( "sv_hostname" ), sizeof( s_serveroptions.hostname.field.buffer ) );
ADDRGP4 $711
ARGP4
ADDRLP4 108
ADDRGP4 UI_Cvar_VariableString
CALLP4
ASGNP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRLP4 108
INDIRP4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1827
;1827:	s_serveroptions.pure.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_pure" ) );
ADDRGP4 $710
ARGP4
ADDRLP4 112
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 112
INDIRF4
ARGF4
ADDRLP4 116
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+2024+60
ADDRLP4 116
INDIRF4
CVFI4 4
ASGNI4
line 1830
;1828:
;1829:	// set the map pic
;1830:	Com_sprintf( picname, 64, "levelshots/%s", s_startserver.maplist[s_startserver.currentmap] );
ADDRGP4 $1024
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $112
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
line 1831
;1831:	s_serveroptions.mappic.generic.name = picname;
ADDRGP4 s_serveroptions+360+4
ADDRGP4 $1024
ASGNP4
line 1834
;1832:
;1833:	// set the map name
;1834:	strcpy( s_serveroptions.mapnamebuffer, s_startserver.mapname.string );
ADDRGP4 s_serveroptions+6864
ARGP4
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1835
;1835:	Q_strupr( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6864
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 1838
;1836:
;1837:	// get the player selections initialized
;1838:	ServerOptions_InitPlayerItems();
ADDRGP4 ServerOptions_InitPlayerItems
CALLV
pop
line 1839
;1839:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1842
;1840:
;1841:	// seed bot names
;1842:	ServerOptions_InitBotNames();
ADDRGP4 ServerOptions_InitBotNames
CALLV
pop
line 1843
;1843:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1844
;1844:}
LABELV $1023
endproc ServerOptions_SetMenuItems 188 16
proc PlayerName_Draw 48 20
line 1851
;1845:
;1846:/*
;1847:=================
;1848:PlayerName_Draw
;1849:=================
;1850:*/
;1851:static void PlayerName_Draw( void *item ) {
line 1858
;1852:	menutext_s	*s;
;1853:	float		*color;
;1854:	int			x, y;
;1855:	int			style;
;1856:	qboolean	focus;
;1857:
;1858:	s = (menutext_s *)item;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1860
;1859:
;1860:	x = s->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1861
;1861:	y =	s->generic.y;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 1863
;1862:
;1863:	style = UI_SMALLFONT;
ADDRLP4 16
CNSTI4 16
ASGNI4
line 1864
;1864:	focus = (s->generic.parent->cursor == s->generic.menuPosition);
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
NEI4 $1147
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1148
JUMPV
LABELV $1147
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1148
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 1866
;1865:
;1866:	if ( s->generic.flags & QMF_GRAYED )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $1149
line 1867
;1867:		color = text_color_disabled;
ADDRLP4 4
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $1150
JUMPV
LABELV $1149
line 1868
;1868:	else if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1151
line 1869
;1869:	{
line 1870
;1870:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1871
;1871:		style |= UI_PULSE;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 1872
;1872:	}
ADDRGP4 $1152
JUMPV
LABELV $1151
line 1873
;1873:	else if ( s->generic.flags & QMF_BLINK )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $1153
line 1874
;1874:	{
line 1875
;1875:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1876
;1876:		style |= UI_BLINK;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1877
;1877:	}
ADDRGP4 $1154
JUMPV
LABELV $1153
line 1879
;1878:	else
;1879:		color = text_color_normal;
ADDRLP4 4
ADDRGP4 text_color_normal
ASGNP4
LABELV $1154
LABELV $1152
LABELV $1150
line 1881
;1880:
;1881:	if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1155
line 1882
;1882:	{
line 1884
;1883:		// draw cursor
;1884:		UI_FillRect( s->generic.left, s->generic.top, s->generic.right-s->generic.left+1, s->generic.bottom-s->generic.top+1, listbar_color ); 
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
line 1885
;1885:		UI_DrawChar( x, y, 13, UI_CENTER|UI_BLINK|UI_SMALLFONT, color);
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
line 1886
;1886:	}
LABELV $1155
line 1888
;1887:
;1888:	UI_DrawString( x - SMALLCHAR_WIDTH, y, s->generic.name, style|UI_RIGHT, color );
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
line 1889
;1889:	UI_DrawString( x + SMALLCHAR_WIDTH, y, s->string, style|UI_LEFT, color );
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
line 1890
;1890:}
LABELV $1145
endproc PlayerName_Draw 48 20
proc ServerOptions_MenuInit 48 12
line 1900
;1891:
;1892:
;1893:/*
;1894:=================
;1895:ServerOptions_MenuInit
;1896:=================
;1897:*/
;1898:#define OPTIONS_X	456
;1899:
;1900:static void ServerOptions_MenuInit( qboolean multiplayer ) {
line 1904
;1901:	int		y;
;1902:	int		n;
;1903:
;1904:	memset( &s_serveroptions, 0 ,sizeof(serveroptions_t) );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 0
ARGI4
CNSTI4 7208
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1905
;1905:	s_serveroptions.multiplayer = multiplayer;
ADDRGP4 s_serveroptions+6852
ADDRFP4 0
INDIRI4
ASGNI4
line 1907
;1906:
;1907:	s_serveroptions.gameMode =
CNSTF4 0
ARGF4
CNSTF4 1094713344
ARGF4
ADDRGP4 s_startserver+536+64
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 8
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+6860
ADDRLP4 8
INDIRF4
CVFI4 4
ASGNI4
line 1914
;1908:		(int)Com_Clamp(
;1909:			0,
;1910:			UI_MODE_COUNT - 1,
;1911:			s_startserver.gametype.curvalue
;1912:		);
;1913:
;1914:	s_serveroptions.gametype =
ADDRGP4 s_serveroptions+6856
ADDRGP4 s_serveroptions+6860
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
ASGNI4
line 1919
;1915:		gametype_remap[
;1916:			s_serveroptions.gameMode
;1917:		];
;1918:
;1919:	s_serveroptions.punkbuster.curvalue =
ADDRGP4 $715
ARGP4
ADDRLP4 12
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 16
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+7112+64
ADDRLP4 16
INDIRF4
CVFI4 4
ASGNI4
line 1928
;1920:		Com_Clamp(
;1921:			0,
;1922:			1,
;1923:			trap_Cvar_VariableValue(
;1924:				"sv_punkbuster"
;1925:			)
;1926:		);
;1927:
;1928:	ServerOptions_Cache();
ADDRGP4 ServerOptions_Cache
CALLV
pop
line 1930
;1929:
;1930:	s_serveroptions.menu.wrapAround = qtrue;
ADDRGP4 s_serveroptions+276
CNSTI4 1
ASGNI4
line 1931
;1931:	s_serveroptions.menu.fullscreen = qtrue;
ADDRGP4 s_serveroptions+280
CNSTI4 1
ASGNI4
line 1933
;1932:
;1933:	s_serveroptions.banner.generic.type			= MTYPE_BTEXT;
ADDRGP4 s_serveroptions+288
CNSTI4 10
ASGNI4
line 1934
;1934:	s_serveroptions.banner.generic.x			= 320;
ADDRGP4 s_serveroptions+288+12
CNSTI4 320
ASGNI4
line 1935
;1935:	s_serveroptions.banner.generic.y			= 16;
ADDRGP4 s_serveroptions+288+16
CNSTI4 16
ASGNI4
line 1936
;1936:	s_serveroptions.banner.string  				= "GAME SERVER";
ADDRGP4 s_serveroptions+288+60
ADDRGP4 $302
ASGNP4
line 1937
;1937:	s_serveroptions.banner.color  				= color_white;
ADDRGP4 s_serveroptions+288+68
ADDRGP4 color_white
ASGNP4
line 1938
;1938:	s_serveroptions.banner.style  				= UI_CENTER;
ADDRGP4 s_serveroptions+288+64
CNSTI4 1
ASGNI4
line 1940
;1939:
;1940:	s_serveroptions.mappic.generic.type			= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+360
CNSTI4 6
ASGNI4
line 1941
;1941:	s_serveroptions.mappic.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_serveroptions+360+44
CNSTU4 16388
ASGNU4
line 1942
;1942:	s_serveroptions.mappic.generic.x			= 352;
ADDRGP4 s_serveroptions+360+12
CNSTI4 352
ASGNI4
line 1943
;1943:	s_serveroptions.mappic.generic.y			= 80;
ADDRGP4 s_serveroptions+360+16
CNSTI4 80
ASGNI4
line 1944
;1944:	s_serveroptions.mappic.width				= 160;
ADDRGP4 s_serveroptions+360+76
CNSTI4 160
ASGNI4
line 1945
;1945:	s_serveroptions.mappic.height				= 120;
ADDRGP4 s_serveroptions+360+80
CNSTI4 120
ASGNI4
line 1946
;1946:	s_serveroptions.mappic.errorpic				= GAMESERVER_UNKNOWNMAP;
ADDRGP4 s_serveroptions+360+64
ADDRGP4 $373
ASGNP4
line 1947
;1947:	s_serveroptions.mappic.generic.ownerdraw	= ServerOptions_LevelshotDraw;
ADDRGP4 s_serveroptions+360+56
ADDRGP4 ServerOptions_LevelshotDraw
ASGNP4
line 1949
;1948:
;1949:	s_serveroptions.picframe.generic.type		= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+448
CNSTI4 6
ASGNI4
line 1950
;1950:	s_serveroptions.picframe.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE|QMF_HIGHLIGHT;
ADDRGP4 s_serveroptions+448+44
CNSTU4 16452
ASGNU4
line 1951
;1951:	s_serveroptions.picframe.generic.x			= 352 - 38;
ADDRGP4 s_serveroptions+448+12
CNSTI4 314
ASGNI4
line 1952
;1952:	s_serveroptions.picframe.generic.y			= 80 - 40;
ADDRGP4 s_serveroptions+448+16
CNSTI4 40
ASGNI4
line 1953
;1953:	s_serveroptions.picframe.width  			= 320;
ADDRGP4 s_serveroptions+448+76
CNSTI4 320
ASGNI4
line 1954
;1954:	s_serveroptions.picframe.height  			= 320;
ADDRGP4 s_serveroptions+448+80
CNSTI4 320
ASGNI4
line 1955
;1955:	s_serveroptions.picframe.focuspic			= GAMESERVER_SELECT;
ADDRGP4 s_serveroptions+448+60
ADDRGP4 $401
ASGNP4
line 1957
;1956:	
;1957:	s_serveroptions.respawnTime.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3252
CNSTI4 3
ASGNI4
line 1958
;1958:	s_serveroptions.respawnTime.generic.name ="Respawn Time:";
ADDRGP4 s_serveroptions+3252+4
ADDRGP4 $1210
ASGNP4
line 1959
;1959:	s_serveroptions.respawnTime.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3252+44
CNSTU4 258
ASGNU4
line 1960
;1960:	s_serveroptions.respawnTime.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3252+12
CNSTI4 456
ASGNI4
line 1961
;1961:	s_serveroptions.respawnTime.generic.y = 252;
ADDRGP4 s_serveroptions+3252+16
CNSTI4 252
ASGNI4
line 1962
;1962:	s_serveroptions.respawnTime.itemnames = respawnTime_list;
ADDRGP4 s_serveroptions+3252+76
ADDRGP4 respawnTime_list
ASGNP4
line 1964
;1963:	
;1964:	s_serveroptions.assaultMiddleItem.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3156
CNSTI4 3
ASGNI4
line 1965
;1965:	s_serveroptions.assaultMiddleItem.generic.name = "Point B(Base Assault):";
ADDRGP4 s_serveroptions+3156+4
ADDRGP4 $1222
ASGNP4
line 1966
;1966:	s_serveroptions.assaultMiddleItem.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3156+44
CNSTU4 258
ASGNU4
line 1967
;1967:	s_serveroptions.assaultMiddleItem.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3156+12
CNSTI4 456
ASGNI4
line 1968
;1968:	s_serveroptions.assaultMiddleItem.generic.y = 268;
ADDRGP4 s_serveroptions+3156+16
CNSTI4 268
ASGNI4
line 1969
;1969:	s_serveroptions.assaultMiddleItem.itemnames = assaultMiddleItem_list;
ADDRGP4 s_serveroptions+3156+76
ADDRGP4 assaultMiddleItem_list
ASGNP4
line 1971
;1970:	
;1971:	y = 282;
ADDRLP4 4
CNSTI4 282
ASGNI4
line 1973
;1972:	
;1973:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 4
EQI4 $1231
line 1974
;1974:		s_serveroptions.fraglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+964
CNSTI4 4
ASGNI4
line 1975
;1975:		s_serveroptions.fraglimit.generic.name       = "Frag Limit:";
ADDRGP4 s_serveroptions+964+4
ADDRGP4 $1237
ASGNP4
line 1976
;1976:		s_serveroptions.fraglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+964+44
CNSTU4 290
ASGNU4
line 1977
;1977:		s_serveroptions.fraglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+964+12
CNSTI4 456
ASGNI4
line 1978
;1978:		s_serveroptions.fraglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1979
;1979:		s_serveroptions.fraglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+964+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1980
;1980:		s_serveroptions.fraglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+964+60+8
CNSTI4 3
ASGNI4
line 1981
;1981:		s_serveroptions.fraglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+964+60+268
CNSTI4 3
ASGNI4
line 1982
;1982:	}
ADDRGP4 $1232
JUMPV
LABELV $1231
line 1983
;1983:	else {
line 1984
;1984:		s_serveroptions.flaglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1296
CNSTI4 4
ASGNI4
line 1985
;1985:		s_serveroptions.flaglimit.generic.name       = "Capture Limit:";
ADDRGP4 s_serveroptions+1296+4
ADDRGP4 $1255
ASGNP4
line 1986
;1986:		s_serveroptions.flaglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1296+44
CNSTU4 290
ASGNU4
line 1987
;1987:		s_serveroptions.flaglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+1296+12
CNSTI4 456
ASGNI4
line 1988
;1988:		s_serveroptions.flaglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+1296+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1989
;1989:		s_serveroptions.flaglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+1296+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1990
;1990:		s_serveroptions.flaglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+1296+60+8
CNSTI4 3
ASGNI4
line 1991
;1991:		s_serveroptions.flaglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+1296+60+268
CNSTI4 3
ASGNI4
line 1992
;1992:	}
LABELV $1232
line 1994
;1993:
;1994:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1995
;1995:	s_serveroptions.timelimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+632
CNSTI4 4
ASGNI4
line 1996
;1996:	s_serveroptions.timelimit.generic.name       = "Time Limit:";
ADDRGP4 s_serveroptions+632+4
ADDRGP4 $1273
ASGNP4
line 1997
;1997:	s_serveroptions.timelimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+632+44
CNSTU4 290
ASGNU4
line 1998
;1998:	s_serveroptions.timelimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+632+12
CNSTI4 456
ASGNI4
line 1999
;1999:	s_serveroptions.timelimit.generic.y	         = y;
ADDRGP4 s_serveroptions+632+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2000
;2000:	s_serveroptions.timelimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+632+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 2001
;2001:	s_serveroptions.timelimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+632+60+8
CNSTI4 3
ASGNI4
line 2002
;2002:	s_serveroptions.timelimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+632+60+268
CNSTI4 3
ASGNI4
line 2004
;2003:
;2004:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $1288
line 2005
;2005:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2006
;2006:		s_serveroptions.friendlyfire.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+1628
CNSTI4 5
ASGNI4
line 2007
;2007:		s_serveroptions.friendlyfire.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1628+44
CNSTU4 258
ASGNU4
line 2008
;2008:		s_serveroptions.friendlyfire.generic.x	      = OPTIONS_X;
ADDRGP4 s_serveroptions+1628+12
CNSTI4 456
ASGNI4
line 2009
;2009:		s_serveroptions.friendlyfire.generic.y	      = y;
ADDRGP4 s_serveroptions+1628+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2010
;2010:		s_serveroptions.friendlyfire.generic.name	  = "Friendly Fire:";
ADDRGP4 s_serveroptions+1628+4
ADDRGP4 $1300
ASGNP4
line 2011
;2011:	}
LABELV $1288
line 2013
;2012:
;2013:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2014
;2014:	s_serveroptions.pure.generic.type			= MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2024
CNSTI4 5
ASGNI4
line 2015
;2015:	s_serveroptions.pure.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2024+44
CNSTU4 258
ASGNU4
line 2016
;2016:	s_serveroptions.pure.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+2024+12
CNSTI4 456
ASGNI4
line 2017
;2017:	s_serveroptions.pure.generic.y				= y;
ADDRGP4 s_serveroptions+2024+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2018
;2018:	s_serveroptions.pure.generic.name			= "Pure Server:";
ADDRGP4 s_serveroptions+2024+4
ADDRGP4 $1310
ASGNP4
line 2020
;2019:
;2020:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6852
INDIRI4
CNSTI4 0
EQI4 $1311
line 2021
;2021:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2022
;2022:		s_serveroptions.dedicated.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+536
CNSTI4 3
ASGNI4
line 2023
;2023:		s_serveroptions.dedicated.generic.id		= ID_DEDICATED;
ADDRGP4 s_serveroptions+536+8
CNSTI4 22
ASGNI4
line 2024
;2024:		s_serveroptions.dedicated.generic.flags		= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+536+44
CNSTU4 258
ASGNU4
line 2025
;2025:		s_serveroptions.dedicated.generic.callback	= ServerOptions_Event;
ADDRGP4 s_serveroptions+536+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2026
;2026:		s_serveroptions.dedicated.generic.x			= OPTIONS_X;
ADDRGP4 s_serveroptions+536+12
CNSTI4 456
ASGNI4
line 2027
;2027:		s_serveroptions.dedicated.generic.y			= y;
ADDRGP4 s_serveroptions+536+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2028
;2028:		s_serveroptions.dedicated.generic.name		= "Dedicated:";
ADDRGP4 s_serveroptions+536+4
ADDRGP4 $1327
ASGNP4
line 2029
;2029:		s_serveroptions.dedicated.itemnames			= dedicated_list;
ADDRGP4 s_serveroptions+536+76
ADDRGP4 dedicated_list
ASGNP4
line 2030
;2030:	}
LABELV $1311
line 2032
;2031:
;2032:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6852
INDIRI4
CNSTI4 0
EQI4 $1330
line 2033
;2033:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2034
;2034:		s_serveroptions.hostname.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1692
CNSTI4 4
ASGNI4
line 2035
;2035:		s_serveroptions.hostname.generic.name       = "Hostname:";
ADDRGP4 s_serveroptions+1692+4
ADDRGP4 $1336
ASGNP4
line 2036
;2036:		s_serveroptions.hostname.generic.flags      = QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1692+44
CNSTU4 2
ASGNU4
line 2037
;2037:		s_serveroptions.hostname.generic.x          = OPTIONS_X;
ADDRGP4 s_serveroptions+1692+12
CNSTI4 456
ASGNI4
line 2038
;2038:		s_serveroptions.hostname.generic.y	        = y;
ADDRGP4 s_serveroptions+1692+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2039
;2039:		s_serveroptions.hostname.field.widthInChars = 18;
ADDRGP4 s_serveroptions+1692+60+8
CNSTI4 18
ASGNI4
line 2040
;2040:		s_serveroptions.hostname.field.maxchars     = 64;
ADDRGP4 s_serveroptions+1692+60+268
CNSTI4 64
ASGNI4
line 2041
;2041:	}
LABELV $1330
line 2043
;2042:
;2043:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2044
;2044:	s_serveroptions.punkbuster.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+7112
CNSTI4 3
ASGNI4
line 2045
;2045:	s_serveroptions.punkbuster.generic.name			= "Punkbuster:";
ADDRGP4 s_serveroptions+7112+4
ADDRGP4 $1352
ASGNP4
line 2046
;2046:	s_serveroptions.punkbuster.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+7112+44
CNSTU4 258
ASGNU4
line 2047
;2047:	s_serveroptions.punkbuster.generic.id			= 0;
ADDRGP4 s_serveroptions+7112+8
CNSTI4 0
ASGNI4
line 2048
;2048:	s_serveroptions.punkbuster.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+7112+12
CNSTI4 456
ASGNI4
line 2049
;2049:	s_serveroptions.punkbuster.generic.y				= y;
ADDRGP4 s_serveroptions+7112+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2050
;2050:	s_serveroptions.punkbuster.itemnames				= punkbuster_items;
ADDRGP4 s_serveroptions+7112+76
ADDRGP4 punkbuster_items
ASGNP4
line 2052
;2051:	
;2052:	y = 90;
ADDRLP4 4
CNSTI4 90
ASGNI4
line 2053
;2053:	s_serveroptions.botSkill.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+2088
CNSTI4 3
ASGNI4
line 2054
;2054:	s_serveroptions.botSkill.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2088+44
CNSTU4 258
ASGNU4
line 2055
;2055:	s_serveroptions.botSkill.generic.name			= "Bot Skill:  ";
ADDRGP4 s_serveroptions+2088+4
ADDRGP4 $1368
ASGNP4
line 2056
;2056:	s_serveroptions.botSkill.generic.x				= 32 + (strlen(s_serveroptions.botSkill.generic.name) + 2 ) * SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+2088+4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRGP4 s_serveroptions+2088+12
ADDRLP4 20
INDIRI4
CNSTI4 3
LSHI4
CNSTI4 16
ADDI4
CNSTI4 32
ADDI4
ASGNI4
line 2057
;2057:	s_serveroptions.botSkill.generic.y				= y;
ADDRGP4 s_serveroptions+2088+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2058
;2058:	s_serveroptions.botSkill.itemnames				= botSkill_list;
ADDRGP4 s_serveroptions+2088+76
ADDRGP4 botSkill_list
ASGNP4
line 2059
;2059:	s_serveroptions.botSkill.curvalue				= 1;
ADDRGP4 s_serveroptions+2088+64
CNSTI4 1
ASGNI4
line 2061
;2060:
;2061:	y += ( 2 * SMALLCHAR_HEIGHT );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 2062
;2062:	s_serveroptions.player0.generic.type			= MTYPE_TEXT;
ADDRGP4 s_serveroptions+3348
CNSTI4 7
ASGNI4
line 2063
;2063:	s_serveroptions.player0.generic.flags			= QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3348+44
CNSTU4 2
ASGNU4
line 2064
;2064:	s_serveroptions.player0.generic.x				= 32 + SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+3348+12
CNSTI4 40
ASGNI4
line 2065
;2065:	s_serveroptions.player0.generic.y				= y;
ADDRGP4 s_serveroptions+3348+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2066
;2066:	s_serveroptions.player0.color					= color_orange;
ADDRGP4 s_serveroptions+3348+68
ADDRGP4 color_orange
ASGNP4
line 2067
;2067:	s_serveroptions.player0.style					= UI_LEFT|UI_SMALLFONT;
ADDRGP4 s_serveroptions+3348+64
CNSTI4 16
ASGNI4
line 2069
;2068:
;2069:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1390
line 2070
;2070:		s_serveroptions.playerType[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420
ADDP4
CNSTI4 3
ASGNI4
line 2071
;2071:		s_serveroptions.playerType[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+44
ADDP4
CNSTU4 2
ASGNU4
line 2072
;2072:		s_serveroptions.playerType[n].generic.id		= ID_PLAYER_TYPE;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+8
ADDP4
CNSTI4 20
ASGNI4
line 2073
;2073:		s_serveroptions.playerType[n].generic.callback	= ServerOptions_Event;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+48
ADDP4
ADDRGP4 ServerOptions_Event
ASGNP4
line 2074
;2074:		s_serveroptions.playerType[n].generic.x			= 32;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+12
ADDP4
CNSTI4 32
ASGNI4
line 2075
;2075:		s_serveroptions.playerType[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2076
;2076:		s_serveroptions.playerType[n].itemnames			= playerType_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420+76
ADDP4
ADDRGP4 playerType_list
ASGNP4
line 2078
;2077:
;2078:		s_serveroptions.playerName[n].generic.type		= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572
ADDP4
CNSTI4 7
ASGNI4
line 2079
;2079:		s_serveroptions.playerName[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+44
ADDP4
CNSTU4 2
ASGNU4
line 2080
;2080:		s_serveroptions.playerName[n].generic.x			= 96;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+12
ADDP4
CNSTI4 96
ASGNI4
line 2081
;2081:		s_serveroptions.playerName[n].generic.y			= y;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2082
;2082:		s_serveroptions.playerName[n].generic.callback	= ServerOptions_PlayerNameEvent;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+48
ADDP4
ADDRGP4 ServerOptions_PlayerNameEvent
ASGNP4
line 2083
;2083:		s_serveroptions.playerName[n].generic.id		= n;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2084
;2084:		s_serveroptions.playerName[n].generic.ownerdraw	= PlayerName_Draw;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+56
ADDP4
ADDRGP4 PlayerName_Draw
ASGNP4
line 2085
;2085:		s_serveroptions.playerName[n].color				= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2086
;2086:		s_serveroptions.playerName[n].style				= UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+64
ADDP4
CNSTI4 16
ASGNI4
line 2087
;2087:		s_serveroptions.playerName[n].string			= s_serveroptions.playerNameBuffers[n];
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572+60
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6896
ADDP4
ASGNP4
line 2088
;2088:		s_serveroptions.playerName[n].generic.top		= s_serveroptions.playerName[n].generic.y;
ADDRLP4 32
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 32
INDIRI4
ADDRGP4 s_serveroptions+4572+24
ADDP4
ADDRLP4 32
INDIRI4
ADDRGP4 s_serveroptions+4572+16
ADDP4
INDIRI4
ASGNI4
line 2089
;2089:		s_serveroptions.playerName[n].generic.bottom	= s_serveroptions.playerName[n].generic.y + SMALLCHAR_HEIGHT;
ADDRLP4 36
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4572+32
ADDP4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4572+16
ADDP4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 2090
;2090:		s_serveroptions.playerName[n].generic.left		= s_serveroptions.playerName[n].generic.x - SMALLCHAR_HEIGHT/ 2;
ADDRLP4 40
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4572+20
ADDP4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4572+12
ADDP4
INDIRI4
CNSTI4 8
SUBI4
ASGNI4
line 2091
;2091:		s_serveroptions.playerName[n].generic.right		= s_serveroptions.playerName[n].generic.x + 16 * SMALLCHAR_WIDTH;
ADDRLP4 44
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4572+28
ADDP4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4572+12
ADDP4
INDIRI4
CNSTI4 128
ADDI4
ASGNI4
line 2093
;2092:
;2093:		s_serveroptions.playerTeam[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436
ADDP4
CNSTI4 3
ASGNI4
line 2094
;2094:		s_serveroptions.playerTeam[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+44
ADDP4
CNSTU4 2
ASGNU4
line 2095
;2095:		s_serveroptions.playerTeam[n].generic.x			= 240;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+12
ADDP4
CNSTI4 240
ASGNI4
line 2096
;2096:		s_serveroptions.playerTeam[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2097
;2097:		s_serveroptions.playerTeam[n].itemnames			= playerTeam_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436+76
ADDP4
ADDRGP4 playerTeam_list
ASGNP4
line 2099
;2098:
;2099:		y += ( SMALLCHAR_HEIGHT + 4 );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
line 2100
;2100:	}
LABELV $1391
line 2069
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1390
line 2102
;2101:
;2102:	s_serveroptions.additionalSlots.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+2184
CNSTI4 4
ASGNI4
line 2103
;2103:	s_serveroptions.additionalSlots.generic.name       = "Additional Slots:";
ADDRGP4 s_serveroptions+2184+4
ADDRGP4 $1455
ASGNP4
line 2104
;2104:	s_serveroptions.additionalSlots.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2184+44
CNSTU4 290
ASGNU4
line 2105
;2105:	s_serveroptions.additionalSlots.generic.id         = ID_MAXCLIENTS;
ADDRGP4 s_serveroptions+2184+8
CNSTI4 21
ASGNI4
line 2106
;2106:	s_serveroptions.additionalSlots.generic.x          = 240;
ADDRGP4 s_serveroptions+2184+12
CNSTI4 240
ASGNI4
line 2107
;2107:	s_serveroptions.additionalSlots.generic.y          = y;
ADDRGP4 s_serveroptions+2184+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2108
;2108:	s_serveroptions.additionalSlots.field.widthInChars = 2;
ADDRGP4 s_serveroptions+2184+60+8
CNSTI4 2
ASGNI4
line 2109
;2109:	s_serveroptions.additionalSlots.field.maxchars     = 2;
ADDRGP4 s_serveroptions+2184+60+268
CNSTI4 2
ASGNI4
line 2111
;2110:	
;2111:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2112
;2112:	s_serveroptions.noPowerups.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2516
CNSTI4 5
ASGNI4
line 2113
;2113:	s_serveroptions.noPowerups.generic.name     = "No Powerups:";
ADDRGP4 s_serveroptions+2516+4
ADDRGP4 $1473
ASGNP4
line 2114
;2114:	s_serveroptions.noPowerups.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2516+44
CNSTU4 258
ASGNU4
line 2115
;2115:	s_serveroptions.noPowerups.generic.x        = 240;
ADDRGP4 s_serveroptions+2516+12
CNSTI4 240
ASGNI4
line 2116
;2116:	s_serveroptions.noPowerups.generic.y        = y;
ADDRGP4 s_serveroptions+2516+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2118
;2117:	
;2118:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2119
;2119:	s_serveroptions.noHealth.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2580
CNSTI4 5
ASGNI4
line 2120
;2120:	s_serveroptions.noHealth.generic.name = "No Health:";
ADDRGP4 s_serveroptions+2580+4
ADDRGP4 $1483
ASGNP4
line 2121
;2121:	s_serveroptions.noHealth.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2580+44
CNSTU4 258
ASGNU4
line 2122
;2122:	s_serveroptions.noHealth.generic.x = 240;
ADDRGP4 s_serveroptions+2580+12
CNSTI4 240
ASGNI4
line 2123
;2123:	s_serveroptions.noHealth.generic.y = y;
ADDRGP4 s_serveroptions+2580+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2125
;2124:
;2125:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2126
;2126:	s_serveroptions.noArmor.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2644
CNSTI4 5
ASGNI4
line 2127
;2127:	s_serveroptions.noArmor.generic.name = "No Armor:";
ADDRGP4 s_serveroptions+2644+4
ADDRGP4 $1493
ASGNP4
line 2128
;2128:	s_serveroptions.noArmor.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2644+44
CNSTU4 258
ASGNU4
line 2129
;2129:	s_serveroptions.noArmor.generic.x = 240;
ADDRGP4 s_serveroptions+2644+12
CNSTI4 240
ASGNI4
line 2130
;2130:	s_serveroptions.noArmor.generic.y = y;
ADDRGP4 s_serveroptions+2644+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2132
;2131:	
;2132:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2134
;2133:
;2134:	s_serveroptions.noMegaHealth.generic.type  = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2708
CNSTI4 5
ASGNI4
line 2135
;2135:	s_serveroptions.noMegaHealth.generic.name  = "No Mega / Medkit:";
ADDRGP4 s_serveroptions+2708+4
ADDRGP4 $1503
ASGNP4
line 2136
;2136:	s_serveroptions.noMegaHealth.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2708+44
CNSTU4 258
ASGNU4
line 2137
;2137:	s_serveroptions.noMegaHealth.generic.x     = 240;
ADDRGP4 s_serveroptions+2708+12
CNSTI4 240
ASGNI4
line 2138
;2138:	s_serveroptions.noMegaHealth.generic.y     = y;
ADDRGP4 s_serveroptions+2708+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2140
;2139:
;2140:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2141
;2141:	s_serveroptions.noPersonalTeleporter.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2772
CNSTI4 5
ASGNI4
line 2142
;2142:	s_serveroptions.noPersonalTeleporter.generic.name = "No Personal TP:";
ADDRGP4 s_serveroptions+2772+4
ADDRGP4 $1513
ASGNP4
line 2143
;2143:	s_serveroptions.noPersonalTeleporter.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2772+44
CNSTU4 258
ASGNU4
line 2144
;2144:	s_serveroptions.noPersonalTeleporter.generic.x = 240;
ADDRGP4 s_serveroptions+2772+12
CNSTI4 240
ASGNI4
line 2145
;2145:	s_serveroptions.noPersonalTeleporter.generic.y = y;
ADDRGP4 s_serveroptions+2772+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2147
;2146:	
;2147:	y=350;
ADDRLP4 4
CNSTI4 350
ASGNI4
line 2148
;2148:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2149
;2149:	s_serveroptions.noPlasmaBFG.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2836
CNSTI4 5
ASGNI4
line 2150
;2150:	s_serveroptions.noPlasmaBFG.generic.name = "No Plasma / BFG:";
ADDRGP4 s_serveroptions+2836+4
ADDRGP4 $1523
ASGNP4
line 2151
;2151:	s_serveroptions.noPlasmaBFG.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2836+44
CNSTU4 258
ASGNU4
line 2152
;2152:	s_serveroptions.noPlasmaBFG.generic.x = 440;
ADDRGP4 s_serveroptions+2836+12
CNSTI4 440
ASGNI4
line 2153
;2153:	s_serveroptions.noPlasmaBFG.generic.y = y;
ADDRGP4 s_serveroptions+2836+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2155
;2154:	
;2155:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2156
;2156:	s_serveroptions.noLightning.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2900
CNSTI4 5
ASGNI4
line 2157
;2157:	s_serveroptions.noLightning.generic.name = "No Lightning:";
ADDRGP4 s_serveroptions+2900+4
ADDRGP4 $1533
ASGNP4
line 2158
;2158:	s_serveroptions.noLightning.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2900+44
CNSTU4 258
ASGNU4
line 2159
;2159:	s_serveroptions.noLightning.generic.x = 440;
ADDRGP4 s_serveroptions+2900+12
CNSTI4 440
ASGNI4
line 2160
;2160:	s_serveroptions.noLightning.generic.y = y;
ADDRGP4 s_serveroptions+2900+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2162
;2161:
;2162:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2163
;2163:	s_serveroptions.noGrenadeRocket.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2964
CNSTI4 5
ASGNI4
line 2164
;2164:	s_serveroptions.noGrenadeRocket.generic.name = "No Explosives:";
ADDRGP4 s_serveroptions+2964+4
ADDRGP4 $1543
ASGNP4
line 2165
;2165:	s_serveroptions.noGrenadeRocket.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2964+44
CNSTU4 258
ASGNU4
line 2166
;2166:	s_serveroptions.noGrenadeRocket.generic.x = 440;
ADDRGP4 s_serveroptions+2964+12
CNSTI4 440
ASGNI4
line 2167
;2167:	s_serveroptions.noGrenadeRocket.generic.y = y;
ADDRGP4 s_serveroptions+2964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2169
;2168:	
;2169:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2170
;2170:	s_serveroptions.noRailgun.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+3028
CNSTI4 5
ASGNI4
line 2171
;2171:	s_serveroptions.noRailgun.generic.name = "No Railgun:";
ADDRGP4 s_serveroptions+3028+4
ADDRGP4 $1553
ASGNP4
line 2172
;2172:	s_serveroptions.noRailgun.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3028+44
CNSTU4 258
ASGNU4
line 2173
;2173:	s_serveroptions.noRailgun.generic.x = 440;
ADDRGP4 s_serveroptions+3028+12
CNSTI4 440
ASGNI4
line 2174
;2174:	s_serveroptions.noRailgun.generic.y = y;
ADDRGP4 s_serveroptions+3028+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2176
;2175:	
;2176:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2177
;2177:	s_serveroptions.enableBlaster.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+3092
CNSTI4 5
ASGNI4
line 2178
;2178:	s_serveroptions.enableBlaster.generic.name = "Enable Blaster:";
ADDRGP4 s_serveroptions+3092+4
ADDRGP4 $1563
ASGNP4
line 2179
;2179:	s_serveroptions.enableBlaster.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3092+44
CNSTU4 258
ASGNU4
line 2180
;2180:	s_serveroptions.enableBlaster.generic.x = 440;
ADDRGP4 s_serveroptions+3092+12
CNSTI4 440
ASGNI4
line 2181
;2181:	s_serveroptions.enableBlaster.generic.y = y;
ADDRGP4 s_serveroptions+3092+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2183
;2182:
;2183:	s_serveroptions.back.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6764
CNSTI4 6
ASGNI4
line 2184
;2184:	s_serveroptions.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_serveroptions+6764+4
ADDRGP4 $468
ASGNP4
line 2185
;2185:	s_serveroptions.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6764+44
CNSTU4 260
ASGNU4
line 2186
;2186:	s_serveroptions.back.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6764+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2187
;2187:	s_serveroptions.back.generic.id	      = ID_BACK;
ADDRGP4 s_serveroptions+6764+8
CNSTI4 24
ASGNI4
line 2188
;2188:	s_serveroptions.back.generic.x		  = 0;
ADDRGP4 s_serveroptions+6764+12
CNSTI4 0
ASGNI4
line 2189
;2189:	s_serveroptions.back.generic.y		  = 480-64;
ADDRGP4 s_serveroptions+6764+16
CNSTI4 416
ASGNI4
line 2190
;2190:	s_serveroptions.back.width  		  = 128;
ADDRGP4 s_serveroptions+6764+76
CNSTI4 128
ASGNI4
line 2191
;2191:	s_serveroptions.back.height  		  = 64;
ADDRGP4 s_serveroptions+6764+80
CNSTI4 64
ASGNI4
line 2192
;2192:	s_serveroptions.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_serveroptions+6764+60
ADDRGP4 $485
ASGNP4
line 2194
;2193:
;2194:	s_serveroptions.next.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6676
CNSTI4 6
ASGNI4
line 2195
;2195:	s_serveroptions.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_serveroptions+6676+4
ADDRGP4 $489
ASGNP4
line 2196
;2196:	s_serveroptions.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_INACTIVE|QMF_GRAYED|QMF_HIDDEN;
ADDRGP4 s_serveroptions+6676+44
CNSTU4 28944
ASGNU4
line 2197
;2197:	s_serveroptions.next.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6676+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2198
;2198:	s_serveroptions.next.generic.id	      = ID_STARTSERVERNEXT;
ADDRGP4 s_serveroptions+6676+8
CNSTI4 18
ASGNI4
line 2199
;2199:	s_serveroptions.next.generic.x		  = 640;
ADDRGP4 s_serveroptions+6676+12
CNSTI4 640
ASGNI4
line 2200
;2200:	s_serveroptions.next.generic.y		  = 480-64-72;
ADDRGP4 s_serveroptions+6676+16
CNSTI4 344
ASGNI4
line 2201
;2201:	s_serveroptions.next.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+6676+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 2202
;2202:	s_serveroptions.next.width  		  = 128;
ADDRGP4 s_serveroptions+6676+76
CNSTI4 128
ASGNI4
line 2203
;2203:	s_serveroptions.next.height  		  = 64;
ADDRGP4 s_serveroptions+6676+80
CNSTI4 64
ASGNI4
line 2204
;2204:	s_serveroptions.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_serveroptions+6676+60
ADDRGP4 $506
ASGNP4
line 2206
;2205:
;2206:	s_serveroptions.go.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6588
CNSTI4 6
ASGNI4
line 2207
;2207:	s_serveroptions.go.generic.name     = GAMESERVER_FIGHT0;
ADDRGP4 s_serveroptions+6588+4
ADDRGP4 $1613
ASGNP4
line 2208
;2208:	s_serveroptions.go.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6588+44
CNSTU4 272
ASGNU4
line 2209
;2209:	s_serveroptions.go.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6588+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2210
;2210:	s_serveroptions.go.generic.id	    = ID_GO;
ADDRGP4 s_serveroptions+6588+8
CNSTI4 23
ASGNI4
line 2211
;2211:	s_serveroptions.go.generic.x		= 640;
ADDRGP4 s_serveroptions+6588+12
CNSTI4 640
ASGNI4
line 2212
;2212:	s_serveroptions.go.generic.y		= 480-64;
ADDRGP4 s_serveroptions+6588+16
CNSTI4 416
ASGNI4
line 2213
;2213:	s_serveroptions.go.width  		    = 128;
ADDRGP4 s_serveroptions+6588+76
CNSTI4 128
ASGNI4
line 2214
;2214:	s_serveroptions.go.height  		    = 64;
ADDRGP4 s_serveroptions+6588+80
CNSTI4 64
ASGNI4
line 2215
;2215:	s_serveroptions.go.focuspic         = GAMESERVER_FIGHT1;
ADDRGP4 s_serveroptions+6588+60
ADDRGP4 $1630
ASGNP4
line 2217
;2216:
;2217:	if( s_serveroptions.gameMode != UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
ADDRGP4 s_serveroptions+6860
INDIRI4
CNSTI4 12
EQI4 $1631
line 2218
;2218:	Menu_AddItem(&s_serveroptions.menu,&s_serveroptions.respawnTime); }
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3252
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
LABELV $1631
line 2219
;2219:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.banner );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2220
;2220:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noMegaHealth );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2708
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2221
;2221:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noPersonalTeleporter );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2772
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2222
;2222:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.enableBlaster);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3092
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2223
;2223:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.mappic );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2224
;2224:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.picframe );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2226
;2225:
;2226:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.botSkill );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2088
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2227
;2227:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.player0 );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3348
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2228
;2228:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1643
line 2229
;2229:		if( n != 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1647
line 2230
;2230:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerType[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3420
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2231
;2231:		}
LABELV $1647
line 2232
;2232:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerName[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4572
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2233
;2233:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $1651
line 2234
;2234:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerTeam[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5436
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2235
;2235:		}
LABELV $1651
line 2236
;2236:	}
LABELV $1644
line 2228
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1643
line 2238
;2237:
;2238:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.additionalSlots );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2184
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2239
;2239:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPowerups);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2240
;2240:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noHealth);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2580
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2241
;2241:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noArmor);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2644
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2242
;2242:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPlasmaBFG);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2836
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2243
;2243:	Menu_AddItem(&s_serveroptions.menu,&s_serveroptions.noLightning);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2900
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2244
;2244:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noGrenadeRocket);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2245
;2245:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noRailgun);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3028
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2247
;2246:	
;2247:	if( trap_Cvar_VariableValue("g_assaultMode") == 1 ||
ADDRGP4 $261
ARGP4
ADDRLP4 24
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 24
INDIRF4
CNSTF4 1065353216
EQF4 $1665
ADDRGP4 $261
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 1077936128
NEF4 $1663
LABELV $1665
line 2248
;2248:		trap_Cvar_VariableValue("g_assaultMode") == 3 ) {
line 2249
;2249:		Menu_AddItem(
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3156
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2253
;2250:			&s_serveroptions.menu,
;2251:			&s_serveroptions.assaultMiddleItem
;2252:		);
;2253:	}
LABELV $1663
line 2255
;2254:		
;2255:	if( s_serveroptions.gametype == GT_CTF ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 4
NEI4 $1667
line 2256
;2256:		Menu_AddItem(
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1296
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2260
;2257:			&s_serveroptions.menu,
;2258:			&s_serveroptions.flaglimit
;2259:		);
;2260:	}
ADDRGP4 $1668
JUMPV
LABELV $1667
line 2261
;2261:	else if( s_serveroptions.gameMode !=
ADDRGP4 s_serveroptions+6860
INDIRI4
CNSTI4 12
EQI4 $1671
line 2262
;2262:		UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
line 2263
;2263:		Menu_AddItem(
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2267
;2264:			&s_serveroptions.menu,
;2265:			&s_serveroptions.fraglimit
;2266:		);
;2267:	}
LABELV $1671
LABELV $1668
line 2268
;2268:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.timelimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+632
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2269
;2269:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6856
INDIRI4
CNSTI4 3
LTI4 $1676
line 2270
;2270:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.friendlyfire );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1628
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2271
;2271:	}
LABELV $1676
line 2272
;2272:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.pure );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2024
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2273
;2273:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6852
INDIRI4
CNSTI4 0
EQI4 $1681
line 2274
;2274:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.dedicated );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2275
;2275:	}
LABELV $1681
line 2276
;2276:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6852
INDIRI4
CNSTI4 0
EQI4 $1685
line 2277
;2277:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.hostname );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1692
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2278
;2278:	}
LABELV $1685
line 2280
;2279:
;2280:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.back );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6764
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2281
;2281:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.next );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6676
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2282
;2282:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.go );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6588
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2284
;2283:
;2284:	Menu_AddItem( &s_serveroptions.menu, (void*) &s_serveroptions.punkbuster );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+7112
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2287
;2285:	
;2286:	
;2287:	ServerOptions_SetMenuItems();
ADDRGP4 ServerOptions_SetMenuItems
CALLV
pop
line 2288
;2288:}
LABELV $1157
endproc ServerOptions_MenuInit 48 12
export ServerOptions_Cache
proc ServerOptions_Cache 0 4
line 2295
;2289:
;2290:/*
;2291:=================
;2292:ServerOptions_Cache
;2293:=================
;2294:*/
;2295:void ServerOptions_Cache( void ) {
line 2296
;2296:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );
ADDRGP4 $468
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2297
;2297:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );
ADDRGP4 $485
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2298
;2298:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT0 );
ADDRGP4 $1613
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2299
;2299:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT1 );
ADDRGP4 $1630
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2300
;2300:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );
ADDRGP4 $401
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2301
;2301:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $373
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2302
;2302:}
LABELV $1693
endproc ServerOptions_Cache 0 4
proc UI_ServerOptionsMenu 0 4
line 2310
;2303:
;2304:
;2305:/*
;2306:=================
;2307:UI_ServerOptionsMenu
;2308:=================
;2309:*/
;2310:static void UI_ServerOptionsMenu( qboolean multiplayer ) {
line 2311
;2311:	ServerOptions_MenuInit( multiplayer );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 ServerOptions_MenuInit
CALLV
pop
line 2312
;2312:	UI_PushMenu( &s_serveroptions.menu );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2313
;2313:}
LABELV $1694
endproc UI_ServerOptionsMenu 0 4
proc UI_BotSelectMenu_SortCompare 44 8
line 2374
;2314:
;2315:
;2316:
;2317:/*
;2318:=============================================================================
;2319:
;2320:BOT SELECT MENU *****
;2321:
;2322:=============================================================================
;2323:*/
;2324:
;2325:
;2326:#define BOTSELECT_BACK0			"menu/art/back_0"
;2327:#define BOTSELECT_BACK1			"menu/art/back_1"
;2328:#define BOTSELECT_ACCEPT0		"menu/art/accept_0"
;2329:#define BOTSELECT_ACCEPT1		"menu/art/accept_1"
;2330:#define BOTSELECT_SELECT		"menu/art/opponents_select"
;2331:#define BOTSELECT_SELECTED		"menu/art/opponents_selected"
;2332:#define BOTSELECT_ARROWS		"menu/art/gs_arrows_0"
;2333:#define BOTSELECT_ARROWSL		"menu/art/gs_arrows_l"
;2334:#define BOTSELECT_ARROWSR		"menu/art/gs_arrows_r"
;2335:
;2336:#define PLAYERGRID_COLS			4
;2337:#define PLAYERGRID_ROWS			4
;2338:#define MAX_MODELSPERPAGE		(PLAYERGRID_ROWS * PLAYERGRID_COLS)
;2339:
;2340:
;2341:typedef struct {
;2342:	menuframework_s	menu;
;2343:
;2344:	menutext_s		banner;
;2345:
;2346:	menubitmap_s	pics[MAX_MODELSPERPAGE];
;2347:	menubitmap_s	picbuttons[MAX_MODELSPERPAGE];
;2348:	menutext_s		picnames[MAX_MODELSPERPAGE];
;2349:
;2350:	menubitmap_s	arrows;
;2351:	menubitmap_s	left;
;2352:	menubitmap_s	right;
;2353:
;2354:	menubitmap_s	go;
;2355:	menubitmap_s	back;
;2356:
;2357:	int				numBots;
;2358:	int				modelpage;
;2359:	int				numpages;
;2360:	int				selectedmodel;
;2361:	int				sortedBotNums[MAX_BOTS];
;2362:	char			boticons[MAX_MODELSPERPAGE][MAX_QPATH];
;2363:	char			botnames[MAX_MODELSPERPAGE][16];
;2364:} botSelectInfo_t;
;2365:
;2366:static botSelectInfo_t	botSelectInfo;
;2367:
;2368:
;2369:/*
;2370:=================
;2371:UI_BotSelectMenu_SortCompare
;2372:=================
;2373:*/
;2374:static int QDECL UI_BotSelectMenu_SortCompare( const void *arg1, const void *arg2 ) {
line 2379
;2375:	int			num1, num2;
;2376:	const char	*info1, *info2;
;2377:	const char	*name1, *name2;
;2378:
;2379:	num1 = *(int *)arg1;
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 2380
;2380:	num2 = *(int *)arg2;
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
line 2382
;2381:
;2382:	info1 = UI_GetBotInfoByNumber( num1 );
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
line 2383
;2383:	info2 = UI_GetBotInfoByNumber( num2 );
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
line 2385
;2384:
;2385:	name1 = Info_ValueForKey( info1, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $827
ARGP4
ADDRLP4 32
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 2386
;2386:	name2 = Info_ValueForKey( info2, "name" );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 $827
ARGP4
ADDRLP4 36
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 36
INDIRP4
ASGNP4
line 2388
;2387:
;2388:	return Q_stricmp( name1, name2 );
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
LABELV $1696
endproc UI_BotSelectMenu_SortCompare 44 8
proc UI_BotSelectMenu_BuildList 12 16
line 2397
;2389:}
;2390:
;2391:
;2392:/*
;2393:=================
;2394:UI_BotSelectMenu_BuildList
;2395:=================
;2396:*/
;2397:static void UI_BotSelectMenu_BuildList( void ) {
line 2400
;2398:	int		n;
;2399:
;2400:	botSelectInfo.modelpage = 0;
ADDRGP4 botSelectInfo+4772
CNSTI4 0
ASGNI4
line 2401
;2401:	botSelectInfo.numBots = UI_GetNumBots();
ADDRLP4 4
ADDRGP4 UI_GetNumBots
CALLI4
ASGNI4
ADDRGP4 botSelectInfo+4768
ADDRLP4 4
INDIRI4
ASGNI4
line 2402
;2402:	botSelectInfo.numpages = botSelectInfo.numBots / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4776
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2403
;2403:	if( botSelectInfo.numBots % MAX_MODELSPERPAGE ) {
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
MODI4
CNSTI4 0
EQI4 $1702
line 2404
;2404:		botSelectInfo.numpages++;
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
line 2405
;2405:	}
LABELV $1702
line 2408
;2406:
;2407:	// initialize the array
;2408:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1709
JUMPV
LABELV $1706
line 2409
;2409:		botSelectInfo.sortedBotNums[n] = n;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2410
;2410:	}
LABELV $1707
line 2408
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1709
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1706
line 2413
;2411:
;2412:	// now sort it
;2413:	qsort( botSelectInfo.sortedBotNums, botSelectInfo.numBots, sizeof(botSelectInfo.sortedBotNums[0]), UI_BotSelectMenu_SortCompare );
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
line 2414
;2414:}
LABELV $1697
endproc UI_BotSelectMenu_BuildList 12 16
proc ServerPlayerIcon 80 20
line 2422
;2415:
;2416:
;2417:/*
;2418:=================
;2419:ServerPlayerIcon
;2420:=================
;2421:*/
;2422:static void ServerPlayerIcon( const char *modelAndSkin, char *iconName, int iconNameMaxSize ) {
line 2426
;2423:	char	*skin;
;2424:	char	model[MAX_QPATH];
;2425:
;2426:	Q_strncpyz( model, modelAndSkin, sizeof(model));
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
line 2427
;2427:	skin = Q_strrchr( model, '/' );
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
line 2428
;2428:	if ( skin ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1716
line 2429
;2429:		*skin++ = '\0';
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
line 2430
;2430:	}
ADDRGP4 $1717
JUMPV
LABELV $1716
line 2431
;2431:	else {
line 2432
;2432:		skin = "default";
ADDRLP4 0
ADDRGP4 $1718
ASGNP4
line 2433
;2433:	}
LABELV $1717
line 2435
;2434:
;2435:	Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_%s.tga", model, skin );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1719
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2437
;2436:
;2437:	if( !trap_R_RegisterShaderNoMip( iconName ) && Q_stricmp( skin, "default" ) != 0 ) {
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
NEI4 $1720
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $1718
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $1720
line 2438
;2438:		Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_default.tga", model );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1722
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2439
;2439:	}
LABELV $1720
line 2440
;2440:}
LABELV $1715
endproc ServerPlayerIcon 80 20
proc UI_BotSelectMenu_UpdateGrid 36 12
line 2448
;2441:
;2442:
;2443:/*
;2444:=================
;2445:UI_BotSelectMenu_UpdateGrid
;2446:=================
;2447:*/
;2448:static void UI_BotSelectMenu_UpdateGrid( void ) {
line 2453
;2449:	const char	*info;
;2450:	int			i;
;2451:    int			j;
;2452:
;2453:	j = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRLP4 4
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2454
;2454:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++, j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1725
line 2455
;2455:		if( j < botSelectInfo.numBots ) { 
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
GEI4 $1729
line 2456
;2456:			info = UI_GetBotInfoByNumber( botSelectInfo.sortedBotNums[j] );
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
line 2457
;2457:			ServerPlayerIcon( Info_ValueForKey( info, "model" ), botSelectInfo.boticons[i], MAX_QPATH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $1733
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
line 2458
;2458:			Q_strncpyz( botSelectInfo.botnames[i], Info_ValueForKey( info, "name" ), 16 );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $827
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
line 2459
;2459:			Q_CleanStr( botSelectInfo.botnames[i] );
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
line 2460
;2460: 			botSelectInfo.pics[i].generic.name = botSelectInfo.boticons[i];
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
line 2461
;2461:			if( BotAlreadySelected( botSelectInfo.botnames[i] ) ) {
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
EQI4 $1740
line 2462
;2462:				botSelectInfo.picnames[i].color = color_red;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_red
ASGNP4
line 2463
;2463:			}
ADDRGP4 $1741
JUMPV
LABELV $1740
line 2464
;2464:			else {
line 2465
;2465:				botSelectInfo.picnames[i].color = color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2466
;2466:			}
LABELV $1741
line 2467
;2467:			botSelectInfo.picbuttons[i].generic.flags &= ~QMF_INACTIVE;
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
line 2468
;2468:		}
ADDRGP4 $1730
JUMPV
LABELV $1729
line 2469
;2469:		else {
line 2471
;2470:			// dead slot
;2471: 			botSelectInfo.pics[i].generic.name         = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
CNSTP4 0
ASGNP4
line 2472
;2472:			botSelectInfo.picbuttons[i].generic.flags |= QMF_INACTIVE;
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
line 2473
;2473:			botSelectInfo.botnames[i][0] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
CNSTI1 0
ASGNI1
line 2474
;2474:		}
LABELV $1730
line 2476
;2475:
;2476: 		botSelectInfo.pics[i].generic.flags       &= ~QMF_HIGHLIGHT;
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
line 2477
;2477: 		botSelectInfo.pics[i].shader               = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+68
ADDP4
CNSTI4 0
ASGNI4
line 2478
;2478: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2479
;2479:	}
LABELV $1726
line 2454
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
LTI4 $1725
line 2482
;2480:
;2481:	// set selected model
;2482:	i = botSelectInfo.selectedmodel % MAX_MODELSPERPAGE;
ADDRLP4 0
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
MODI4
ASGNI4
line 2483
;2483:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2484
;2484:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2486
;2485:
;2486:	if( botSelectInfo.numpages > 1 ) {
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
LEI4 $1765
line 2487
;2487:		if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1768
line 2488
;2488:			botSelectInfo.left.generic.flags &= ~QMF_INACTIVE;
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
line 2489
;2489:		}
ADDRGP4 $1769
JUMPV
LABELV $1768
line 2490
;2490:		else {
line 2491
;2491:			botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2492
;2492:		}
LABELV $1769
line 2494
;2493:
;2494:		if( botSelectInfo.modelpage < (botSelectInfo.numpages - 1) ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1775
line 2495
;2495:			botSelectInfo.right.generic.flags &= ~QMF_INACTIVE;
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
line 2496
;2496:		}
ADDRGP4 $1766
JUMPV
LABELV $1775
line 2497
;2497:		else {
line 2498
;2498:			botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2499
;2499:		}
line 2500
;2500:	}
ADDRGP4 $1766
JUMPV
LABELV $1765
line 2501
;2501:	else {
line 2503
;2502:		// hide left/right markers
;2503:		botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2504
;2504:		botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2505
;2505:	}
LABELV $1766
line 2506
;2506:}
LABELV $1723
endproc UI_BotSelectMenu_UpdateGrid 36 12
proc UI_BotSelectMenu_Default 28 8
line 2514
;2507:
;2508:
;2509:/*
;2510:=================
;2511:UI_BotSelectMenu_Default
;2512:=================
;2513:*/
;2514:static void UI_BotSelectMenu_Default( char *bot ) {
line 2520
;2515:	const char	*botInfo;
;2516:	const char	*test;
;2517:	int			n;
;2518:	int			i;
;2519:
;2520:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1791
JUMPV
LABELV $1788
line 2521
;2521:		botInfo = UI_GetBotInfoByNumber( n );
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
line 2522
;2522:		test = Info_ValueForKey( botInfo, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $827
ARGP4
ADDRLP4 20
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
line 2523
;2523:		if( Q_stricmp( bot, test ) == 0 ) {
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
NEI4 $1793
line 2524
;2524:			break;
ADDRGP4 $1790
JUMPV
LABELV $1793
line 2526
;2525:		}
;2526:	}
LABELV $1789
line 2520
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1791
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1788
LABELV $1790
line 2527
;2527:	if( n == botSelectInfo.numBots ) {
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1795
line 2528
;2528:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2529
;2529:		return;
ADDRGP4 $1787
JUMPV
LABELV $1795
line 2532
;2530:	}
;2531:
;2532:	for( i = 0; i < botSelectInfo.numBots; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1802
JUMPV
LABELV $1799
line 2533
;2533:		if( botSelectInfo.sortedBotNums[i] == n ) {
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1804
line 2534
;2534:			break;
ADDRGP4 $1801
JUMPV
LABELV $1804
line 2536
;2535:		}
;2536:	}
LABELV $1800
line 2532
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1802
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1799
LABELV $1801
line 2537
;2537:	if( i == botSelectInfo.numBots ) {
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1807
line 2538
;2538:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2539
;2539:		return;
ADDRGP4 $1787
JUMPV
LABELV $1807
line 2542
;2540:	}
;2541:
;2542:	botSelectInfo.selectedmodel = i;
ADDRGP4 botSelectInfo+4780
ADDRLP4 4
INDIRI4
ASGNI4
line 2543
;2543:}
LABELV $1787
endproc UI_BotSelectMenu_Default 28 8
proc UI_BotSelectMenu_LeftEvent 4 0
line 2551
;2544:
;2545:
;2546:/*
;2547:=================
;2548:UI_BotSelectMenu_LeftEvent
;2549:=================
;2550:*/
;2551:static void UI_BotSelectMenu_LeftEvent( void* ptr, int event ) {
line 2552
;2552:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1813
line 2553
;2553:		return;
ADDRGP4 $1812
JUMPV
LABELV $1813
line 2555
;2554:	}
;2555:	if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1815
line 2556
;2556:		botSelectInfo.modelpage--;
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
line 2557
;2557:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2558
;2558:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2559
;2559:	}
LABELV $1815
line 2560
;2560:}
LABELV $1812
endproc UI_BotSelectMenu_LeftEvent 4 0
proc UI_BotSelectMenu_RightEvent 4 0
line 2568
;2561:
;2562:
;2563:/*
;2564:=================
;2565:UI_BotSelectMenu_RightEvent
;2566:=================
;2567:*/
;2568:static void UI_BotSelectMenu_RightEvent( void* ptr, int event ) {
line 2569
;2569:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1822
line 2570
;2570:		return;
ADDRGP4 $1821
JUMPV
LABELV $1822
line 2572
;2571:	}
;2572:	if( botSelectInfo.modelpage < botSelectInfo.numpages - 1 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1824
line 2573
;2573:		botSelectInfo.modelpage++;
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
line 2574
;2574:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2575
;2575:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2576
;2576:	}
LABELV $1824
line 2577
;2577:}
LABELV $1821
endproc UI_BotSelectMenu_RightEvent 4 0
proc UI_BotSelectMenu_BotEvent 12 0
line 2585
;2578:
;2579:
;2580:/*
;2581:=================
;2582:UI_BotSelectMenu_BotEvent
;2583:=================
;2584:*/
;2585:static void UI_BotSelectMenu_BotEvent( void* ptr, int event ) {
line 2588
;2586:	int		i;
;2587:
;2588:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1832
line 2589
;2589:		return;
ADDRGP4 $1831
JUMPV
LABELV $1832
line 2592
;2590:	}
;2591:
;2592:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1834
line 2593
;2593: 		botSelectInfo.pics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 2594
;2594: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2595
;2595:	}
LABELV $1835
line 2592
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $1834
line 2598
;2596:
;2597:	// set selected
;2598:	i = ((menucommon_s*)ptr)->id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 2599
;2599:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2600
;2600:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2601
;2601:	botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE + i;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ADDRLP4 0
INDIRI4
ADDI4
ASGNI4
line 2602
;2602:}
LABELV $1831
endproc UI_BotSelectMenu_BotEvent 12 0
proc UI_BotSelectMenu_BackEvent 0 0
line 2610
;2603:
;2604:
;2605:/*
;2606:=================
;2607:UI_BotSelectMenu_BackEvent
;2608:=================
;2609:*/
;2610:static void UI_BotSelectMenu_BackEvent( void* ptr, int event ) {
line 2611
;2611:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1849
line 2612
;2612:		return;
ADDRGP4 $1848
JUMPV
LABELV $1849
line 2614
;2613:	}
;2614:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2615
;2615:}
LABELV $1848
endproc UI_BotSelectMenu_BackEvent 0 0
proc UI_BotSelectMenu_SelectEvent 4 12
line 2623
;2616:
;2617:
;2618:/*
;2619:=================
;2620:UI_BotSelectMenu_SelectEvent
;2621:=================
;2622:*/
;2623:static void UI_BotSelectMenu_SelectEvent( void* ptr, int event ) {
line 2624
;2624:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1852
line 2625
;2625:		return;
ADDRGP4 $1851
JUMPV
LABELV $1852
line 2627
;2626:	}
;2627:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2629
;2628:
;2629:	s_serveroptions.newBot = qtrue;
ADDRGP4 s_serveroptions+7088
CNSTI4 1
ASGNI4
line 2630
;2630:	Q_strncpyz( s_serveroptions.newBotName, botSelectInfo.botnames[botSelectInfo.selectedmodel % MAX_MODELSPERPAGE], 16 );
ADDRGP4 s_serveroptions+7096
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
line 2631
;2631:}
LABELV $1851
endproc UI_BotSelectMenu_SelectEvent 4 12
export UI_BotSelectMenu_Cache
proc UI_BotSelectMenu_Cache 0 4
line 2639
;2632:
;2633:
;2634:/*
;2635:=================
;2636:UI_BotSelectMenu_Cache
;2637:=================
;2638:*/
;2639:void UI_BotSelectMenu_Cache( void ) {
line 2640
;2640:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK0 );
ADDRGP4 $468
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2641
;2641:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK1 );
ADDRGP4 $485
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2642
;2642:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT0 );
ADDRGP4 $1859
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2643
;2643:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT1 );
ADDRGP4 $1860
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2644
;2644:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECT );
ADDRGP4 $1861
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2645
;2645:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECTED );
ADDRGP4 $1862
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2646
;2646:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWS );
ADDRGP4 $405
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2647
;2647:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSL );
ADDRGP4 $433
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2648
;2648:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSR );
ADDRGP4 $451
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2649
;2649:}
LABELV $1858
endproc UI_BotSelectMenu_Cache 0 4
proc UI_BotSelectMenu_Init 36 12
line 2652
;2650:
;2651:
;2652:static void UI_BotSelectMenu_Init( char *bot ) {
line 2656
;2653:	int		i, j, k;
;2654:	int		x, y;
;2655:
;2656:	memset( &botSelectInfo, 0 ,sizeof(botSelectInfo) );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 0
ARGI4
CNSTI4 10160
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2657
;2657:	botSelectInfo.menu.wrapAround = qtrue;
ADDRGP4 botSelectInfo+276
CNSTI4 1
ASGNI4
line 2658
;2658:	botSelectInfo.menu.fullscreen = qtrue;
ADDRGP4 botSelectInfo+280
CNSTI4 1
ASGNI4
line 2660
;2659:
;2660:	UI_BotSelectMenu_Cache();
ADDRGP4 UI_BotSelectMenu_Cache
CALLV
pop
line 2662
;2661:
;2662:	botSelectInfo.banner.generic.type	= MTYPE_BTEXT;
ADDRGP4 botSelectInfo+288
CNSTI4 10
ASGNI4
line 2663
;2663:	botSelectInfo.banner.generic.x		= 320;
ADDRGP4 botSelectInfo+288+12
CNSTI4 320
ASGNI4
line 2664
;2664:	botSelectInfo.banner.generic.y		= 16;
ADDRGP4 botSelectInfo+288+16
CNSTI4 16
ASGNI4
line 2665
;2665:	botSelectInfo.banner.string			= "SELECT BOT";
ADDRGP4 botSelectInfo+288+60
ADDRGP4 $1873
ASGNP4
line 2666
;2666:	botSelectInfo.banner.color			= color_white;
ADDRGP4 botSelectInfo+288+68
ADDRGP4 color_white
ASGNP4
line 2667
;2667:	botSelectInfo.banner.style			= UI_CENTER;
ADDRGP4 botSelectInfo+288+64
CNSTI4 1
ASGNI4
line 2669
;2668:
;2669:	y =	80;
ADDRLP4 8
CNSTI4 80
ASGNI4
line 2670
;2670:	for( i = 0, k = 0; i < PLAYERGRID_ROWS; i++) {
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
ADDRGP4 $1881
JUMPV
LABELV $1878
line 2671
;2671:		x =	180;
ADDRLP4 4
CNSTI4 180
ASGNI4
line 2672
;2672:		for( j = 0; j < PLAYERGRID_COLS; j++, k++ ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $1882
line 2673
;2673:			botSelectInfo.pics[k].generic.type				= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360
ADDP4
CNSTI4 6
ASGNI4
line 2674
;2674:			botSelectInfo.pics[k].generic.flags				= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
CNSTU4 16388
ASGNU4
line 2675
;2675:			botSelectInfo.pics[k].generic.x					= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2676
;2676:			botSelectInfo.pics[k].generic.y					= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2677
;2677: 			botSelectInfo.pics[k].generic.name				= botSelectInfo.boticons[k];
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
line 2678
;2678:			botSelectInfo.pics[k].width						= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+76
ADDP4
CNSTI4 64
ASGNI4
line 2679
;2679:			botSelectInfo.pics[k].height					= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+80
ADDP4
CNSTI4 64
ASGNI4
line 2680
;2680:			botSelectInfo.pics[k].focuspic					= BOTSELECT_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+60
ADDP4
ADDRGP4 $1862
ASGNP4
line 2681
;2681:			botSelectInfo.pics[k].focuscolor				= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2683
;2682:
;2683:			botSelectInfo.picbuttons[k].generic.type		= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768
ADDP4
CNSTI4 6
ASGNI4
line 2684
;2684:			botSelectInfo.picbuttons[k].generic.flags		= QMF_LEFT_JUSTIFY|QMF_NODEFAULTINIT|QMF_PULSEIFFOCUS;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
CNSTU4 33028
ASGNU4
line 2685
;2685:			botSelectInfo.picbuttons[k].generic.callback	= UI_BotSelectMenu_BotEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+48
ADDP4
ADDRGP4 UI_BotSelectMenu_BotEvent
ASGNP4
line 2686
;2686:			botSelectInfo.picbuttons[k].generic.id			= k;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2687
;2687:			botSelectInfo.picbuttons[k].generic.x			= x - 16;
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
line 2688
;2688:			botSelectInfo.picbuttons[k].generic.y			= y - 16;
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
line 2689
;2689:			botSelectInfo.picbuttons[k].generic.left		= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2690
;2690:			botSelectInfo.picbuttons[k].generic.top			= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2691
;2691:			botSelectInfo.picbuttons[k].generic.right		= x + 64;
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
line 2692
;2692:			botSelectInfo.picbuttons[k].generic.bottom		= y + 64;
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
line 2693
;2693:			botSelectInfo.picbuttons[k].width				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+76
ADDP4
CNSTI4 128
ASGNI4
line 2694
;2694:			botSelectInfo.picbuttons[k].height				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+80
ADDP4
CNSTI4 128
ASGNI4
line 2695
;2695:			botSelectInfo.picbuttons[k].focuspic			= BOTSELECT_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+60
ADDP4
ADDRGP4 $1861
ASGNP4
line 2696
;2696:			botSelectInfo.picbuttons[k].focuscolor			= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2698
;2697:
;2698:			botSelectInfo.picnames[k].generic.type			= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176
ADDP4
CNSTI4 7
ASGNI4
line 2699
;2699:			botSelectInfo.picnames[k].generic.flags			= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+44
ADDP4
CNSTU4 2
ASGNU4
line 2700
;2700:			botSelectInfo.picnames[k].generic.x				= x + 32;
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
line 2701
;2701:			botSelectInfo.picnames[k].generic.y				= y + 64;
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
line 2702
;2702:			botSelectInfo.picnames[k].string				= botSelectInfo.botnames[k];
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
line 2703
;2703:			botSelectInfo.picnames[k].color					= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2704
;2704:			botSelectInfo.picnames[k].style					= UI_CENTER|UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+64
ADDP4
CNSTI4 17
ASGNI4
line 2706
;2705:
;2706:			x += (64 + 6);
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 70
ADDI4
ASGNI4
line 2707
;2707:		}
LABELV $1883
line 2672
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
LTI4 $1882
line 2708
;2708:		y += (64 + SMALLCHAR_HEIGHT + 6);
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 86
ADDI4
ASGNI4
line 2709
;2709:	}
LABELV $1879
line 2670
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1881
ADDRLP4 16
INDIRI4
CNSTI4 4
LTI4 $1878
line 2711
;2710:
;2711:	botSelectInfo.arrows.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4328
CNSTI4 6
ASGNI4
line 2712
;2712:	botSelectInfo.arrows.generic.name		= BOTSELECT_ARROWS;
ADDRGP4 botSelectInfo+4328+4
ADDRGP4 $405
ASGNP4
line 2713
;2713:	botSelectInfo.arrows.generic.flags		= QMF_INACTIVE;
ADDRGP4 botSelectInfo+4328+44
CNSTU4 16384
ASGNU4
line 2714
;2714:	botSelectInfo.arrows.generic.x			= 260;
ADDRGP4 botSelectInfo+4328+12
CNSTI4 260
ASGNI4
line 2715
;2715:	botSelectInfo.arrows.generic.y			= 440;
ADDRGP4 botSelectInfo+4328+16
CNSTI4 440
ASGNI4
line 2716
;2716:	botSelectInfo.arrows.width				= 128;
ADDRGP4 botSelectInfo+4328+76
CNSTI4 128
ASGNI4
line 2717
;2717:	botSelectInfo.arrows.height				= 32;
ADDRGP4 botSelectInfo+4328+80
CNSTI4 32
ASGNI4
line 2719
;2718:
;2719:	botSelectInfo.left.generic.type			= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4416
CNSTI4 6
ASGNI4
line 2720
;2720:	botSelectInfo.left.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4416+44
CNSTU4 260
ASGNU4
line 2721
;2721:	botSelectInfo.left.generic.callback		= UI_BotSelectMenu_LeftEvent;
ADDRGP4 botSelectInfo+4416+48
ADDRGP4 UI_BotSelectMenu_LeftEvent
ASGNP4
line 2722
;2722:	botSelectInfo.left.generic.x			= 260;
ADDRGP4 botSelectInfo+4416+12
CNSTI4 260
ASGNI4
line 2723
;2723:	botSelectInfo.left.generic.y			= 440;
ADDRGP4 botSelectInfo+4416+16
CNSTI4 440
ASGNI4
line 2724
;2724:	botSelectInfo.left.width  				= 64;
ADDRGP4 botSelectInfo+4416+76
CNSTI4 64
ASGNI4
line 2725
;2725:	botSelectInfo.left.height  				= 32;
ADDRGP4 botSelectInfo+4416+80
CNSTI4 32
ASGNI4
line 2726
;2726:	botSelectInfo.left.focuspic				= BOTSELECT_ARROWSL;
ADDRGP4 botSelectInfo+4416+60
ADDRGP4 $433
ASGNP4
line 2728
;2727:
;2728:	botSelectInfo.right.generic.type	    = MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4504
CNSTI4 6
ASGNI4
line 2729
;2729:	botSelectInfo.right.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4504+44
CNSTU4 260
ASGNU4
line 2730
;2730:	botSelectInfo.right.generic.callback	= UI_BotSelectMenu_RightEvent;
ADDRGP4 botSelectInfo+4504+48
ADDRGP4 UI_BotSelectMenu_RightEvent
ASGNP4
line 2731
;2731:	botSelectInfo.right.generic.x			= 321;
ADDRGP4 botSelectInfo+4504+12
CNSTI4 321
ASGNI4
line 2732
;2732:	botSelectInfo.right.generic.y			= 440;
ADDRGP4 botSelectInfo+4504+16
CNSTI4 440
ASGNI4
line 2733
;2733:	botSelectInfo.right.width  				= 64;
ADDRGP4 botSelectInfo+4504+76
CNSTI4 64
ASGNI4
line 2734
;2734:	botSelectInfo.right.height  		    = 32;
ADDRGP4 botSelectInfo+4504+80
CNSTI4 32
ASGNI4
line 2735
;2735:	botSelectInfo.right.focuspic			= BOTSELECT_ARROWSR;
ADDRGP4 botSelectInfo+4504+60
ADDRGP4 $451
ASGNP4
line 2737
;2736:
;2737:	botSelectInfo.back.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4680
CNSTI4 6
ASGNI4
line 2738
;2738:	botSelectInfo.back.generic.name		= BOTSELECT_BACK0;
ADDRGP4 botSelectInfo+4680+4
ADDRGP4 $468
ASGNP4
line 2739
;2739:	botSelectInfo.back.generic.flags	= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4680+44
CNSTU4 260
ASGNU4
line 2740
;2740:	botSelectInfo.back.generic.callback	= UI_BotSelectMenu_BackEvent;
ADDRGP4 botSelectInfo+4680+48
ADDRGP4 UI_BotSelectMenu_BackEvent
ASGNP4
line 2741
;2741:	botSelectInfo.back.generic.x		= 0;
ADDRGP4 botSelectInfo+4680+12
CNSTI4 0
ASGNI4
line 2742
;2742:	botSelectInfo.back.generic.y		= 480-64;
ADDRGP4 botSelectInfo+4680+16
CNSTI4 416
ASGNI4
line 2743
;2743:	botSelectInfo.back.width			= 128;
ADDRGP4 botSelectInfo+4680+76
CNSTI4 128
ASGNI4
line 2744
;2744:	botSelectInfo.back.height			= 64;
ADDRGP4 botSelectInfo+4680+80
CNSTI4 64
ASGNI4
line 2745
;2745:	botSelectInfo.back.focuspic			= BOTSELECT_BACK1;
ADDRGP4 botSelectInfo+4680+60
ADDRGP4 $485
ASGNP4
line 2747
;2746:
;2747:	botSelectInfo.go.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4592
CNSTI4 6
ASGNI4
line 2748
;2748:	botSelectInfo.go.generic.name		= BOTSELECT_ACCEPT0;
ADDRGP4 botSelectInfo+4592+4
ADDRGP4 $1859
ASGNP4
line 2749
;2749:	botSelectInfo.go.generic.flags		= QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4592+44
CNSTU4 272
ASGNU4
line 2750
;2750:	botSelectInfo.go.generic.callback	= UI_BotSelectMenu_SelectEvent;
ADDRGP4 botSelectInfo+4592+48
ADDRGP4 UI_BotSelectMenu_SelectEvent
ASGNP4
line 2751
;2751:	botSelectInfo.go.generic.x			= 640;
ADDRGP4 botSelectInfo+4592+12
CNSTI4 640
ASGNI4
line 2752
;2752:	botSelectInfo.go.generic.y			= 480-64;
ADDRGP4 botSelectInfo+4592+16
CNSTI4 416
ASGNI4
line 2753
;2753:	botSelectInfo.go.width				= 128;
ADDRGP4 botSelectInfo+4592+76
CNSTI4 128
ASGNI4
line 2754
;2754:	botSelectInfo.go.height				= 64;
ADDRGP4 botSelectInfo+4592+80
CNSTI4 64
ASGNI4
line 2755
;2755:	botSelectInfo.go.focuspic			= BOTSELECT_ACCEPT1;
ADDRGP4 botSelectInfo+4592+60
ADDRGP4 $1860
ASGNP4
line 2757
;2756:
;2757:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.banner );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2758
;2758:	for( i = 0; i < MAX_MODELSPERPAGE; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $2023
line 2759
;2759:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.pics[i] );
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
line 2760
;2760:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picbuttons[i] );
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
line 2761
;2761:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picnames[i] );
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
line 2762
;2762:	}
LABELV $2024
line 2758
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 16
LTI4 $2023
line 2763
;2763:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.arrows );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4328
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2764
;2764:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.left );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4416
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2765
;2765:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.right );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4504
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2766
;2766:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.back );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4680
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2767
;2767:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.go );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4592
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2769
;2768:
;2769:	UI_BotSelectMenu_BuildList();
ADDRGP4 UI_BotSelectMenu_BuildList
CALLV
pop
line 2770
;2770:	UI_BotSelectMenu_Default( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Default
CALLV
pop
line 2771
;2771:	botSelectInfo.modelpage = botSelectInfo.selectedmodel / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4772
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2772
;2772:	UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2773
;2773:}
LABELV $1863
endproc UI_BotSelectMenu_Init 36 12
export UI_BotSelectMenu
proc UI_BotSelectMenu 0 4
line 2781
;2774:
;2775:
;2776:/*
;2777:=================
;2778:UI_BotSelectMenu
;2779:=================
;2780:*/
;2781:void UI_BotSelectMenu( char *bot ) {
line 2782
;2782:	UI_BotSelectMenu_Init( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Init
CALLV
pop
line 2783
;2783:	UI_PushMenu( &botSelectInfo.menu );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2784
;2784:}
LABELV $2037
endproc UI_BotSelectMenu 0 4
bss
align 4
LABELV botSelectInfo
skip 10160
align 4
LABELV s_serveroptions
skip 7208
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
LABELV $1873
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
LABELV $1862
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
LABELV $1861
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
LABELV $1860
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
LABELV $1859
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
LABELV $1733
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $1722
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
LABELV $1719
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
LABELV $1718
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $1630
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
LABELV $1613
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
LABELV $1563
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
LABELV $1553
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
LABELV $1543
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
LABELV $1533
byte 1 78
byte 1 111
byte 1 32
byte 1 76
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 58
byte 1 0
align 1
LABELV $1523
byte 1 78
byte 1 111
byte 1 32
byte 1 80
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 32
byte 1 47
byte 1 32
byte 1 66
byte 1 70
byte 1 71
byte 1 58
byte 1 0
align 1
LABELV $1513
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
LABELV $1503
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
LABELV $1493
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
LABELV $1483
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
LABELV $1473
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
LABELV $1455
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
LABELV $1368
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
LABELV $1352
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
LABELV $1336
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
LABELV $1327
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
LABELV $1310
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
LABELV $1300
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
LABELV $1273
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
LABELV $1255
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
LABELV $1237
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
LABELV $1222
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
LABELV $1210
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
LABELV $1092
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1057
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
LABELV $1051
byte 1 117
byte 1 105
byte 1 95
byte 1 110
byte 1 111
byte 1 76
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $1045
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
LABELV $1039
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
LABELV $1033
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
LABELV $1030
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
LABELV $1027
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
LABELV $1006
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
LABELV $982
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $962
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $950
byte 1 118
byte 1 105
byte 1 115
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $944
byte 1 109
byte 1 97
byte 1 106
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $941
byte 1 103
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $931
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
LABELV $919
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
LABELV $859
byte 1 72
byte 1 117
byte 1 109
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $827
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $796
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
LABELV $791
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
LABELV $787
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
LABELV $769
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 32
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $766
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
LABELV $765
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
LABELV $764
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $759
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
LABELV $756
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
LABELV $753
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
LABELV $748
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
LABELV $745
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
LABELV $742
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
LABELV $739
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
LABELV $736
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
LABELV $733
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
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $730
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 76
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $727
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
LABELV $724
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
LABELV $721
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
LABELV $718
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
LABELV $715
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
LABELV $711
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
LABELV $710
byte 1 115
byte 1 118
byte 1 95
byte 1 112
byte 1 117
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $709
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
LABELV $708
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
LABELV $707
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
LABELV $706
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
LABELV $705
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
LABELV $703
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
LABELV $702
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
LABELV $701
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
LABELV $699
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
LABELV $698
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
LABELV $697
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
LABELV $695
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
LABELV $694
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
LABELV $692
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
LABELV $691
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
LABELV $684
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
LABELV $679
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
LABELV $676
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
LABELV $673
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
LABELV $670
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
LABELV $667
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
LABELV $664
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
LABELV $661
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
LABELV $658
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
LABELV $657
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
LABELV $621
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
LABELV $618
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
LABELV $615
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
LABELV $614
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
LABELV $589
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
LABELV $588
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
LABELV $587
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
LABELV $586
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
LABELV $585
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
LABELV $584
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
LABELV $583
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
LABELV $582
byte 1 68
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $581
byte 1 77
byte 1 105
byte 1 100
byte 1 100
byte 1 108
byte 1 101
byte 1 32
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $580
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
LABELV $579
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
LABELV $578
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
LABELV $577
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
LABELV $576
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
LABELV $575
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $574
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $573
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $572
byte 1 72
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $571
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $570
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
LABELV $569
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $568
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
LABELV $567
byte 1 65
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $566
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
LABELV $565
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
LABELV $564
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
LABELV $563
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
LABELV $562
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
LABELV $561
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $560
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $559
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 0
align 1
LABELV $558
byte 1 66
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $557
byte 1 79
byte 1 112
byte 1 101
byte 1 110
byte 1 0
align 1
LABELV $556
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
LABELV $555
byte 1 76
byte 1 65
byte 1 78
byte 1 0
align 1
LABELV $554
byte 1 78
byte 1 111
byte 1 0
align 1
LABELV $536
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
LABELV $506
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
LABELV $489
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
LABELV $485
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
LABELV $468
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
LABELV $451
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
byte 1 108
byte 1 0
align 1
LABELV $405
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
LABELV $401
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
LABELV $373
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
LABELV $370
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
LABELV $338
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
LABELV $324
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
LABELV $310
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
LABELV $302
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
LABELV $266
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
LABELV $261
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
LABELV $248
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
LABELV $239
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
LABELV $234
byte 1 103
byte 1 95
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $227
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
LABELV $199
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $194
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $145
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
LABELV $112
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
LABELV $101
byte 1 99
byte 1 116
byte 1 102
byte 1 0
align 1
LABELV $98
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $95
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $92
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 0
align 1
LABELV $89
byte 1 102
byte 1 102
byte 1 97
byte 1 0
align 1
LABELV $80
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
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
LABELV $79
byte 1 77
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 72
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $78
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
LABELV $77
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
LABELV $76
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
LABELV $75
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
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 84
byte 1 68
byte 1 77
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
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 67
byte 1 84
byte 1 70
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
