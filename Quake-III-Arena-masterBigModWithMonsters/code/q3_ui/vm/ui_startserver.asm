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
byte 4 0
align 4
LABELV respawnTime_list
address $581
address $582
address $583
address $584
address $585
address $586
address $587
address $588
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
line 878
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
;772:	menuradiobutton_s	noGrenadeRocket;
;773:	menuradiobutton_s 	noRailgun;
;774:	menuradiobutton_s	enableBlaster;
;775:	menulist_s 			assaultMiddleItem;
;776:	menulist_s 			respawnTime;
;777:
;778:	menutext_s			player0;
;779:	menulist_s			playerType[PLAYER_SLOTS];
;780:	menutext_s			playerName[PLAYER_SLOTS];
;781:	menulist_s			playerTeam[PLAYER_SLOTS];
;782:
;783:	menubitmap_s		go;
;784:	menubitmap_s		next;
;785:	menubitmap_s		back;
;786:
;787:	qboolean			multiplayer;
;788:	int					gametype;
;789:	int					gameMode;
;790:	char				mapnamebuffer[32];
;791:	char				playerNameBuffers[PLAYER_SLOTS][16];
;792:
;793:	qboolean			newBot;
;794:	int					newBotIndex;
;795:	char				newBotName[16];
;796:	
;797:	menulist_s		punkbuster;
;798:} serveroptions_t;
;799:
;800:static serveroptions_t s_serveroptions;
;801:
;802:static const char *dedicated_list[] = {
;803:	"No",
;804:	"LAN",
;805:	"Internet",
;806:	0
;807:};
;808:
;809:static const char *playerType_list[] = {
;810:	"Open",
;811:	"Bot",
;812:	"----",
;813:	0
;814:};
;815:
;816:static const char *playerTeam_list[] = {
;817:	"Blue",
;818:	"Red",
;819:	0
;820:};
;821:
;822:static const char *botSkill_list[] = {
;823:	"I Can Win",
;824:	"Bring It On",
;825:	"Hurt Me Plenty",
;826:	"Hardcore",
;827:	"Nightmare!",
;828:	0
;829:};
;830:
;831:
;832:static const char *assaultMiddleItem_list[] = {
;833:	"All",
;834:	"Heavy Armor",
;835:	"Armor",
;836:	"Mega Health",
;837:	"Medkit",
;838:	"Haste",
;839:	"BFG",
;840:	"Railgun",
;841:	"Shotgun",
;842:	"Rocket Launcher",
;843:	"Grenade Launcher",
;844:	"Lightning Gun",
;845:	"Personal Teleporter",
;846:	"Plasma Gun",
;847:	0
;848:};
;849:
;850:static const char *respawnTime_list[] = {
;851:	"Default",
;852:	"2 seconds",
;853:	"3 seconds",
;854:	"5 seconds",
;855:	"7 seconds",
;856:	"10 seconds",
;857:	"15 seconds",
;858:	"20 seconds",
;859:	0
;860:};
;861:
;862:static int respawnTime_values[] = {
;863:	0,
;864:	2,
;865:	3,
;866:	5,
;867:	7,
;868:	10,
;869:	15,
;870:	20
;871:};
;872:
;873:/*
;874:=================
;875:BotAlreadySelected
;876:=================
;877:*/
;878:static qboolean BotAlreadySelected( const char *checkName ) {
line 881
;879:	int		n;
;880:
;881:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $590
line 882
;882:		if( s_serveroptions.playerType[n].curvalue != 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $594
line 883
;883:			continue;
ADDRGP4 $591
JUMPV
LABELV $594
line 885
;884:		}
;885:		if( (s_serveroptions.gametype >= GT_TEAM) &&
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $598
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
ADDRGP4 s_serveroptions+7028
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
INDIRI4
EQI4 $598
line 886
;886:			(s_serveroptions.playerTeam[n].curvalue != s_serveroptions.playerTeam[s_serveroptions.newBotIndex].curvalue ) ) {
line 887
;887:			continue;
ADDRGP4 $591
JUMPV
LABELV $598
line 889
;888:		}
;889:		if( Q_stricmp( checkName, s_serveroptions.playerNameBuffers[n] ) == 0 ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $606
line 890
;890:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $589
JUMPV
LABELV $606
line 892
;891:		}
;892:	}
LABELV $591
line 881
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $590
line 894
;893:
;894:	return qfalse;
CNSTI4 0
RETI4
LABELV $589
endproc BotAlreadySelected 12 8
proc ServerOptions_Start 192 24
line 903
;895:}
;896:
;897:
;898:/*
;899:=================
;900:ServerOptions_Start
;901:=================
;902:*/
;903:static void ServerOptions_Start( void ) {
line 916
;904:	int		timelimit;
;905:	int		fraglimit;
;906:	int		maxclients;
;907:	int		additionalSlots;
;908:	int		dedicated;
;909:	int		friendlyfire;
;910:	int		flaglimit;
;911:	int		pure;
;912:	int		skill;
;913:	int		n;
;914:	char		buf[64];
;915:	
;916:	if( s_serveroptions.gameMode ==
ADDRGP4 s_serveroptions+6796
INDIRI4
CNSTI4 12
NEI4 $610
line 917
;917:		UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
line 918
;918:		trap_Cvar_SetValue(
ADDRGP4 $613
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 922
;919:			"fraglimit",
;920:			0
;921:		);
;922:	}
ADDRGP4 $611
JUMPV
LABELV $610
line 923
;923:	else {
line 924
;924:		trap_Cvar_SetValue(
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
ADDRGP4 $613
ARGP4
ADDRLP4 104
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 932
;925:			"fraglimit",
;926:			Com_Clamp(
;927:				0,
;928:				999,
;929:				fraglimit
;930:			)
;931:		);
;932:	}
LABELV $611
line 934
;933:	
;934:	trap_Cmd_ExecuteText(
ADDRGP4 $614
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
line 942
;935:		EXEC_APPEND,
;936:		va(
;937:			"seta ui_respawnTime \"%i\"\n",
;938:			s_serveroptions.respawnTime.curvalue
;939:		)
;940:	);
;941:	
;942:	trap_Cvar_SetValue(
ADDRGP4 $617
ARGP4
ADDRGP4 s_serveroptions+3092+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 947
;943:		"g_assaultMiddleItem",
;944:		s_serveroptions.assaultMiddleItem.curvalue
;945:	);
;946:
;947:	trap_Cmd_ExecuteText(
ADDRGP4 $620
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
line 955
;948:		EXEC_APPEND,
;949:		va(
;950:			"seta ui_assaultMiddleItem \"%i\"\n",
;951:			s_serveroptions.assaultMiddleItem.curvalue
;952:		)
;953:	);
;954:
;955:	timelimit =
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
line 958
;956:		atoi( s_serveroptions.timelimit.field.buffer );
;957:
;958:	fraglimit =
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
line 961
;959:		atoi( s_serveroptions.fraglimit.field.buffer );
;960:
;961:	flaglimit =
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
line 964
;962:		atoi( s_serveroptions.flaglimit.field.buffer );
;963:
;964:	dedicated =
ADDRLP4 80
ADDRGP4 s_serveroptions+536+64
INDIRI4
ASGNI4
line 967
;965:		s_serveroptions.dedicated.curvalue;
;966:
;967:	friendlyfire =
ADDRLP4 92
ADDRGP4 s_serveroptions+1628+60
INDIRI4
ASGNI4
line 970
;968:		s_serveroptions.friendlyfire.curvalue;
;969:
;970:	pure =
ADDRLP4 100
ADDRGP4 s_serveroptions+2024+60
INDIRI4
ASGNI4
line 973
;971:		s_serveroptions.pure.curvalue;
;972:
;973:	skill =
ADDRLP4 72
ADDRGP4 s_serveroptions+2088+64
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 979
;974:		s_serveroptions.botSkill.curvalue + 1;
;975:
;976:	/*
;977:	 * Count all visible player slots which are not closed.
;978:	 */
;979:	for( n = 0, maxclients = 0;
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
ADDRGP4 $643
JUMPV
LABELV $640
line 981
;980:		n < PLAYER_SLOTS;
;981:		n++ ) {
line 982
;982:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $644
line 983
;983:			== 2 ) {
line 984
;984:			continue;
ADDRGP4 $641
JUMPV
LABELV $644
line 987
;985:		}
;986:
;987:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $648
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $648
line 990
;988:			== 1 &&
;989:			s_serveroptions.playerNameBuffers[n][0]
;990:			== 0 ) {
line 991
;991:			continue;
ADDRGP4 $641
JUMPV
LABELV $648
line 994
;992:		}
;993:
;994:		maxclients++;
ADDRLP4 68
ADDRLP4 68
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 995
;995:	}
LABELV $641
line 981
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $643
line 980
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $640
line 1000
;996:
;997:	/*
;998:	 * Add extra free slots.
;999:	 */
;1000:	additionalSlots = atoi(
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
line 1004
;1001:		s_serveroptions.additionalSlots.field.buffer
;1002:	);
;1003:
;1004:	additionalSlots = (int)Com_Clamp(
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
line 1010
;1005:		0,
;1006:		MAX_CLIENTS - maxclients,
;1007:		additionalSlots
;1008:	);
;1009:
;1010:	trap_Cvar_SetValue(
ADDRGP4 $656
ARGP4
ADDRLP4 76
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1015
;1011:		"ui_additionalSlots",
;1012:		additionalSlots
;1013:	);
;1014:
;1015:	maxclients += additionalSlots;
ADDRLP4 68
ADDRLP4 68
INDIRI4
ADDRLP4 76
INDIRI4
ADDI4
ASGNI4
line 1020
;1016:
;1017:	/*
;1018:	 * Powerups.
;1019:	 */
;1020:	trap_Cvar_SetValue(
ADDRGP4 $657
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1025
;1021:		"ui_noPowerups",
;1022:		s_serveroptions.noPowerups.curvalue
;1023:	);
;1024:
;1025:	trap_Cvar_SetValue(
ADDRGP4 $660
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1033
;1026:		"g_noPowerups",
;1027:		s_serveroptions.noPowerups.curvalue
;1028:	);
;1029:
;1030:	/*
;1031:	 * Mega Health and Medkit share one menu option.
;1032:	 */
;1033:	trap_Cvar_SetValue(
ADDRGP4 $663
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1038
;1034:		"ui_noMegaHealth",
;1035:		s_serveroptions.noMegaHealth.curvalue
;1036:	);
;1037:
;1038:	trap_Cvar_SetValue(
ADDRGP4 $666
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1043
;1039:		"g_noMegaHealth",
;1040:		s_serveroptions.noMegaHealth.curvalue
;1041:	);
;1042:
;1043:	trap_Cvar_SetValue(
ADDRGP4 $669
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1051
;1044:		"g_noMedkit",
;1045:		s_serveroptions.noMegaHealth.curvalue
;1046:	);
;1047:
;1048:	/*
;1049:	 * Personal Teleporter.
;1050:	 */
;1051:	trap_Cvar_SetValue(
ADDRGP4 $672
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1056
;1052:		"ui_noPersonalTeleporter",
;1053:		s_serveroptions.noPersonalTeleporter.curvalue
;1054:	);
;1055:
;1056:	trap_Cvar_SetValue(
ADDRGP4 $675
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1061
;1057:		"g_noPersonalTeleporter",
;1058:		s_serveroptions.noPersonalTeleporter.curvalue
;1059:	);
;1060:
;1061:	trap_Cmd_ExecuteText(
ADDRGP4 $678
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
line 1071
;1062:		EXEC_APPEND,
;1063:		va(
;1064:			"seta ui_noMegaHealth \"%i\"\n"
;1065:			"seta ui_noPersonalTeleporter \"%i\"\n",
;1066:			s_serveroptions.noMegaHealth.curvalue,
;1067:			s_serveroptions.noPersonalTeleporter.curvalue
;1068:		)
;1069:	);
;1070:
;1071:	trap_Cmd_ExecuteText(
ADDRGP4 $683
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
line 1082
;1072:		EXEC_APPEND,
;1073:		va(
;1074:			"seta ui_noPowerups \"%i\"\n",
;1075:			s_serveroptions.noPowerups.curvalue
;1076:		)
;1077:	);
;1078:
;1079:	/*
;1080:	 * Store limits for the selected game type.
;1081:	 */
;1082:	switch( s_serveroptions.gametype ) {
ADDRLP4 144
ADDRGP4 s_serveroptions+6792
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $686
ADDRLP4 144
INDIRI4
CNSTI4 4
GTI4 $686
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $703
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $703
address $689
address $692
address $686
address $695
address $699
code
LABELV $689
LABELV $686
line 1085
;1083:	case GT_FFA:
;1084:	default:
;1085:		trap_Cvar_SetValue(
ADDRGP4 $690
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1090
;1086:			"ui_ffa_fraglimit",
;1087:			fraglimit
;1088:		);
;1089:
;1090:		trap_Cvar_SetValue(
ADDRGP4 $691
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1094
;1091:			"ui_ffa_timelimit",
;1092:			timelimit
;1093:		);
;1094:		break;
ADDRGP4 $687
JUMPV
LABELV $692
line 1097
;1095:
;1096:	case GT_TOURNAMENT:
;1097:		trap_Cvar_SetValue(
ADDRGP4 $693
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1102
;1098:			"ui_tourney_fraglimit",
;1099:			fraglimit
;1100:		);
;1101:
;1102:		trap_Cvar_SetValue(
ADDRGP4 $694
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1106
;1103:			"ui_tourney_timelimit",
;1104:			timelimit
;1105:		);
;1106:		break;
ADDRGP4 $687
JUMPV
LABELV $695
line 1109
;1107:
;1108:	case GT_TEAM:
;1109:		trap_Cvar_SetValue(
ADDRGP4 $696
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1114
;1110:			"ui_team_fraglimit",
;1111:			fraglimit
;1112:		);
;1113:
;1114:		trap_Cvar_SetValue(
ADDRGP4 $697
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1119
;1115:			"ui_team_timelimit",
;1116:			timelimit
;1117:		);
;1118:
;1119:		trap_Cvar_SetValue(
ADDRGP4 $698
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1123
;1120:			"ui_team_friendly",
;1121:			friendlyfire
;1122:		);
;1123:		break;
ADDRGP4 $687
JUMPV
LABELV $699
line 1126
;1124:
;1125:	case GT_CTF:
;1126:		trap_Cvar_SetValue(
ADDRGP4 $700
ARGP4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1131
;1127:			"ui_ctf_capturelimit",
;1128:			flaglimit
;1129:		);
;1130:
;1131:		trap_Cvar_SetValue(
ADDRGP4 $701
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1136
;1132:			"ui_ctf_timelimit",
;1133:			timelimit
;1134:		);
;1135:
;1136:		trap_Cvar_SetValue(
ADDRGP4 $702
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1140
;1137:			"ui_ctf_friendly",
;1138:			friendlyfire
;1139:		);
;1140:		break;
LABELV $687
line 1146
;1141:	}
;1142:
;1143:	/*
;1144:	 * General server settings.
;1145:	 */
;1146:	trap_Cvar_SetValue(
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
ADDRGP4 $704
ARGP4
ADDRLP4 148
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1155
;1147:		"sv_maxclients",
;1148:		Com_Clamp(
;1149:			1,
;1150:			MAX_CLIENTS,
;1151:			maxclients
;1152:		)
;1153:	);
;1154:
;1155:	trap_Cvar_SetValue(
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
ADDRGP4 $705
ARGP4
ADDRLP4 152
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1164
;1156:		"dedicated",
;1157:		Com_Clamp(
;1158:			0,
;1159:			2,
;1160:			dedicated
;1161:		)
;1162:	);
;1163:
;1164:	trap_Cvar_SetValue(
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
ADDRGP4 $706
ARGP4
ADDRLP4 156
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1173
;1165:		"timelimit",
;1166:		Com_Clamp(
;1167:			0,
;1168:			999,
;1169:			timelimit
;1170:		)
;1171:	);
;1172:
;1173:	trap_Cvar_SetValue(
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
ADDRGP4 $613
ARGP4
ADDRLP4 160
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1182
;1174:		"fraglimit",
;1175:		Com_Clamp(
;1176:			0,
;1177:			999,
;1178:			fraglimit
;1179:		)
;1180:	);
;1181:
;1182:	trap_Cvar_SetValue(
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
ADDRGP4 $707
ARGP4
ADDRLP4 164
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1191
;1183:		"capturelimit",
;1184:		Com_Clamp(
;1185:			0,
;1186:			100,
;1187:			flaglimit
;1188:		)
;1189:	);
;1190:
;1191:	trap_Cvar_SetValue(
ADDRGP4 $708
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1196
;1192:		"g_friendlyfire",
;1193:		friendlyfire
;1194:	);
;1195:
;1196:	trap_Cvar_SetValue(
ADDRGP4 $709
ARGP4
ADDRLP4 100
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1201
;1197:		"sv_pure",
;1198:		pure
;1199:	);
;1200:
;1201:	trap_Cvar_Set(
ADDRGP4 $710
ARGP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1206
;1202:		"sv_hostname",
;1203:		s_serveroptions.hostname.field.buffer
;1204:	);
;1205:
;1206:	trap_Cvar_SetValue(
ADDRGP4 $714
ARGP4
ADDRGP4 s_serveroptions+7048+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1214
;1207:		"sv_punkbuster",
;1208:		s_serveroptions.punkbuster.curvalue
;1209:	);
;1210:
;1211:	/*
;1212:	 * Blaster Mode.
;1213:	 */
;1214:	trap_Cvar_SetValue(
ADDRGP4 $717
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1219
;1215:		"ui_enableBlaster",
;1216:		s_serveroptions.enableBlaster.curvalue
;1217:	);
;1218:
;1219:	trap_Cvar_SetValue(
ADDRGP4 $720
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1224
;1220:		"g_blasterMode",
;1221:		s_serveroptions.enableBlaster.curvalue
;1222:	);
;1223:
;1224:	trap_Cmd_ExecuteText(
ADDRGP4 $723
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
line 1235
;1225:		EXEC_APPEND,
;1226:		va(
;1227:			"seta ui_enableBlaster \"%i\"\n",
;1228:			s_serveroptions.enableBlaster.curvalue
;1229:		)
;1230:	);
;1231:
;1232:	/*
;1233:	 * Weapon pickup restrictions.
;1234:	 */
;1235:	trap_Cvar_SetValue(
ADDRGP4 $726
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1240
;1236:		"g_noPlasmaBFG",
;1237:		s_serveroptions.noPlasmaBFG.curvalue
;1238:	);
;1239:
;1240:	trap_Cvar_SetValue(
ADDRGP4 $729
ARGP4
ADDRGP4 s_serveroptions+2900+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1245
;1241:		"g_noGrenadeRocket",
;1242:		s_serveroptions.noGrenadeRocket.curvalue
;1243:	);
;1244:	
;1245:	trap_Cvar_SetValue(
ADDRGP4 $732
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1250
;1246:		"ui_noRailgun",
;1247:		s_serveroptions.noRailgun.curvalue
;1248:	);
;1249:
;1250:	trap_Cvar_SetValue(
ADDRGP4 $735
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1255
;1251:		"g_noRailgun",
;1252:		s_serveroptions.noRailgun.curvalue
;1253:	);
;1254:
;1255:	trap_Cmd_ExecuteText(
ADDRGP4 $738
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
line 1263
;1256:		EXEC_APPEND,
;1257:		va(
;1258:			"seta ui_noRailgun \"%i\"\n",
;1259:			s_serveroptions.noRailgun.curvalue
;1260:		)
;1261:	);
;1262:
;1263:	trap_Cmd_ExecuteText(
ADDRGP4 $741
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
line 1276
;1264:		EXEC_APPEND,
;1265:		va(
;1266:			"seta ui_noPlasmaBFG \"%i\"\n"
;1267:			"seta ui_noGrenadeRocket \"%i\"\n",
;1268:			s_serveroptions.noPlasmaBFG.curvalue,
;1269:			s_serveroptions.noGrenadeRocket.curvalue
;1270:		)
;1271:	);
;1272:
;1273:	/*
;1274:	 * Health and armor restrictions.
;1275:	 */
;1276:	trap_Cvar_SetValue(
ADDRGP4 $746
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1281
;1277:		"g_noHealth",
;1278:		s_serveroptions.noHealth.curvalue
;1279:	);
;1280:
;1281:	trap_Cvar_SetValue(
ADDRGP4 $749
ARGP4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1286
;1282:		"g_noArmor",
;1283:		s_serveroptions.noArmor.curvalue
;1284:	);
;1285:
;1286:	trap_Cmd_ExecuteText(
ADDRGP4 $752
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
line 1300
;1287:		EXEC_APPEND,
;1288:		va(
;1289:			"seta ui_noHealth \"%i\"\n"
;1290:			"seta ui_noArmor \"%i\"\n",
;1291:			s_serveroptions.noHealth.curvalue,
;1292:			s_serveroptions.noArmor.curvalue
;1293:		)
;1294:	);
;1295:
;1296:	/*
;1297:	 * Disable any previous map rotation. After the match,
;1298:	 * Quake III will restart the current map.
;1299:	 */
;1300:	trap_Cvar_Set(
ADDRGP4 $757
ARGP4
ADDRGP4 $758
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1308
;1301:		"nextmap",
;1302:		"map_restart 0"
;1303:	);
;1304:
;1305:	/*
;1306:	 * Start selected map.
;1307:	 */
;1308:	trap_Cmd_ExecuteText(
ADDRGP4 $759
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
line 1321
;1309:		EXEC_APPEND,
;1310:		va(
;1311:			"wait; wait; map %s\n",
;1312:			s_startserver.maplist[
;1313:				s_startserver.currentmap
;1314:			]
;1315:		)
;1316:	);
;1317:
;1318:	/*
;1319:	 * Add selected bots after loading the map.
;1320:	 */
;1321:	trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRGP4 $762
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1326
;1322:		EXEC_APPEND,
;1323:		"wait 3\n"
;1324:	);
;1325:
;1326:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $763
line 1327
;1327:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $767
line 1328
;1328:			!= 1 ) {
line 1329
;1329:			continue;
ADDRGP4 $764
JUMPV
LABELV $767
line 1332
;1330:		}
;1331:
;1332:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $771
line 1333
;1333:			== 0 ) {
line 1334
;1334:			continue;
ADDRGP4 $764
JUMPV
LABELV $771
line 1337
;1335:		}
;1336:
;1337:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $774
line 1338
;1338:			== '-' ) {
line 1339
;1339:			continue;
ADDRGP4 $764
JUMPV
LABELV $774
line 1342
;1340:		}
;1341:
;1342:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $777
line 1343
;1343:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $780
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
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
line 1354
;1344:				buf,
;1345:				sizeof(buf),
;1346:				"addbot %s %i %s\n",
;1347:				s_serveroptions.playerNameBuffers[n],
;1348:				skill,
;1349:				playerTeam_list[
;1350:					s_serveroptions.playerTeam[n]
;1351:						.curvalue
;1352:				]
;1353:			);
;1354:		}
ADDRGP4 $778
JUMPV
LABELV $777
line 1355
;1355:		else {
line 1356
;1356:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $784
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1363
;1357:				buf,
;1358:				sizeof(buf),
;1359:				"addbot %s %i\n",
;1360:				s_serveroptions.playerNameBuffers[n],
;1361:				skill
;1362:			);
;1363:		}
LABELV $778
line 1365
;1364:
;1365:		trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1369
;1366:			EXEC_APPEND,
;1367:			buf
;1368:		);
;1369:	}
LABELV $764
line 1326
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $763
line 1374
;1370:
;1371:	/*
;1372:	 * Place the local player on the selected team.
;1373:	 */
;1374:	if( dedicated == 0 &&
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $786
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $786
line 1375
;1375:		s_serveroptions.gametype >= GT_TEAM ) {
line 1376
;1376:		trap_Cmd_ExecuteText(
ADDRGP4 $789
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
line 1386
;1377:			EXEC_APPEND,
;1378:			va(
;1379:				"wait 5; team %s\n",
;1380:				playerTeam_list[
;1381:					s_serveroptions.playerTeam[0]
;1382:						.curvalue
;1383:				]
;1384:			)
;1385:		);
;1386:	}
LABELV $786
line 1387
;1387:}
LABELV $609
endproc ServerOptions_Start 192 24
proc ServerOptions_InitPlayerItems 12 12
line 1395
;1388:
;1389:
;1390:/*
;1391:=================
;1392:ServerOptions_InitPlayerItems
;1393:=================
;1394:*/
;1395:static void ServerOptions_InitPlayerItems( void ) {
line 1400
;1396:	int		n;
;1397:	int		v;
;1398:
;1399:	// init types
;1400:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $793
line 1401
;1401:		v = 0;	// open
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1402
;1402:	}
ADDRGP4 $794
JUMPV
LABELV $793
line 1403
;1403:	else {
line 1404
;1404:		v = 1;	// bot
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1405
;1405:	}
LABELV $794
line 1407
;1406:	
;1407:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $796
line 1408
;1408:		s_serveroptions.playerType[n].curvalue = v;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1409
;1409:	}
LABELV $797
line 1407
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $796
line 1411
;1410:
;1411:	if( s_serveroptions.multiplayer && (s_serveroptions.gametype < GT_TEAM) ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $802
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
GEI4 $802
line 1412
;1412:		for( n = 8; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 8
ASGNI4
LABELV $806
line 1413
;1413:			s_serveroptions.playerType[n].curvalue = 2;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 2
ASGNI4
line 1414
;1414:		}
LABELV $807
line 1412
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $806
line 1415
;1415:	}
LABELV $802
line 1418
;1416:
;1417:	// if not a dedicated server, first slot is reserved for the human on the server
;1418:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $812
line 1420
;1419:		// human
;1420:		s_serveroptions.playerType[0].generic.flags |= QMF_INACTIVE;
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
line 1421
;1421:		s_serveroptions.playerType[0].curvalue = 0;
ADDRGP4 s_serveroptions+3356+64
CNSTI4 0
ASGNI4
line 1422
;1422:		trap_Cvar_VariableStringBuffer( "name", s_serveroptions.playerNameBuffers[0], sizeof(s_serveroptions.playerNameBuffers[0]) );
ADDRGP4 $820
ARGP4
ADDRGP4 s_serveroptions+6832
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 1423
;1423:		Q_CleanStr( s_serveroptions.playerNameBuffers[0] );
ADDRGP4 s_serveroptions+6832
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1424
;1424:	}
LABELV $812
line 1427
;1425:
;1426:	// init teams
;1427:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $824
line 1428
;1428:		for( n = 0; n < (PLAYER_SLOTS / 2); n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $827
line 1429
;1429:			s_serveroptions.playerTeam[n].curvalue = 0;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
CNSTI4 0
ASGNI4
line 1430
;1430:		}
LABELV $828
line 1428
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 6
LTI4 $827
line 1431
;1431:		for( ; n < PLAYER_SLOTS; n++ ) {
ADDRGP4 $836
JUMPV
LABELV $833
line 1432
;1432:			s_serveroptions.playerTeam[n].curvalue = 1;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
CNSTI4 1
ASGNI4
line 1433
;1433:		}
LABELV $834
line 1431
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $836
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $833
line 1434
;1434:	}
ADDRGP4 $825
JUMPV
LABELV $824
line 1435
;1435:	else {
line 1436
;1436:		for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $839
line 1437
;1437:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
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
line 1438
;1438:		}
LABELV $840
line 1436
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $839
line 1439
;1439:	}
LABELV $825
line 1440
;1440:}
LABELV $792
endproc ServerOptions_InitPlayerItems 12 12
proc ServerOptions_SetPlayerItems 12 0
line 1448
;1441:
;1442:
;1443:/*
;1444:=================
;1445:ServerOptions_SetPlayerItems
;1446:=================
;1447:*/
;1448:static void ServerOptions_SetPlayerItems( void ) {
line 1460
;1449:	int		start;
;1450:	int		n;
;1451:
;1452:	// types
;1453://	for( n = 0; n < PLAYER_SLOTS; n++ ) {
;1454://		if( (!s_serveroptions.multiplayer) && (n > 0) && (s_serveroptions.playerType[n].curvalue == 0) ) {
;1455://			s_serveroptions.playerType[n].curvalue = 1;
;1456://		}
;1457://	}
;1458:
;1459:	// names
;1460:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $846
line 1461
;1461:		s_serveroptions.player0.string = "Human";
ADDRGP4 s_serveroptions+3284+60
ADDRGP4 $852
ASGNP4
line 1462
;1462:		s_serveroptions.playerName[0].generic.flags &= ~QMF_HIDDEN;
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
line 1464
;1463:
;1464:		start = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1465
;1465:	}
ADDRGP4 $847
JUMPV
LABELV $846
line 1466
;1466:	else {
line 1467
;1467:		s_serveroptions.player0.string = "Open";
ADDRGP4 s_serveroptions+3284+60
ADDRGP4 $557
ASGNP4
line 1468
;1468:		start = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1469
;1469:	}
LABELV $847
line 1470
;1470:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $860
JUMPV
LABELV $857
line 1471
;1471:		if( s_serveroptions.playerType[n].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $861
line 1472
;1472:			s_serveroptions.playerName[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
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
line 1473
;1473:		}
ADDRGP4 $862
JUMPV
LABELV $861
line 1474
;1474:		else {
line 1475
;1475:			s_serveroptions.playerName[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
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
line 1476
;1476:		}
LABELV $862
line 1477
;1477:	}
LABELV $858
line 1470
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $860
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $857
line 1480
;1478:
;1479:	// teams
;1480:	if( s_serveroptions.gametype < GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
GEI4 $869
line 1481
;1481:		return;
ADDRGP4 $845
JUMPV
LABELV $869
line 1483
;1482:	}
;1483:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $875
JUMPV
LABELV $872
line 1484
;1484:		if( s_serveroptions.playerType[n].curvalue == 2 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $876
line 1485
;1485:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
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
line 1486
;1486:		}
ADDRGP4 $877
JUMPV
LABELV $876
line 1487
;1487:		else {
line 1488
;1488:			s_serveroptions.playerTeam[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
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
line 1489
;1489:		}
LABELV $877
line 1490
;1490:	}
LABELV $873
line 1483
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $875
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $872
line 1491
;1491:}
LABELV $845
endproc ServerOptions_SetPlayerItems 12 0
proc ServerOptions_Event 8 0
line 1499
;1492:
;1493:
;1494:/*
;1495:=================
;1496:ServerOptions_Event
;1497:=================
;1498:*/
;1499:static void ServerOptions_Event( void* ptr, int event ) {
line 1500
;1500:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $885
ADDRLP4 0
INDIRI4
CNSTI4 24
GTI4 $885
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $901-72
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $901
address $895
address $885
address $888
address $891
address $891
address $892
address $898
code
LABELV $888
line 1506
;1501:	
;1502:	//if( event != QM_ACTIVATED && event != QM_LOSTFOCUS) {
;1503:	//	return;
;1504:	//}
;1505:	case ID_PLAYER_TYPE:
;1506:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $889
line 1507
;1507:			break;
ADDRGP4 $886
JUMPV
LABELV $889
line 1509
;1508:		}
;1509:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1510
;1510:		break;
ADDRGP4 $886
JUMPV
LABELV $891
line 1514
;1511:
;1512:	case ID_MAXCLIENTS:
;1513:	case ID_DEDICATED:
;1514:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1515
;1515:		break;
ADDRGP4 $886
JUMPV
LABELV $892
line 1517
;1516:	case ID_GO:
;1517:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $893
line 1518
;1518:			break;
ADDRGP4 $886
JUMPV
LABELV $893
line 1520
;1519:		}
;1520:		ServerOptions_Start();
ADDRGP4 ServerOptions_Start
CALLV
pop
line 1521
;1521:		break;
ADDRGP4 $886
JUMPV
LABELV $895
line 1524
;1522:
;1523:	case ID_STARTSERVERNEXT:
;1524:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $886
line 1525
;1525:			break;
ADDRGP4 $886
JUMPV
line 1527
;1526:		}
;1527:		break;
LABELV $898
line 1529
;1528:	case ID_BACK:
;1529:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $899
line 1530
;1530:			break;
ADDRGP4 $886
JUMPV
LABELV $899
line 1532
;1531:		}
;1532:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 1533
;1533:		break;
LABELV $885
LABELV $886
line 1535
;1534:	}
;1535:}
LABELV $884
endproc ServerOptions_Event 8 0
proc ServerOptions_PlayerNameEvent 4 4
line 1538
;1536:
;1537:
;1538:static void ServerOptions_PlayerNameEvent( void* ptr, int event ) {
line 1541
;1539:	int		n;
;1540:
;1541:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $904
line 1542
;1542:		return;
ADDRGP4 $903
JUMPV
LABELV $904
line 1544
;1543:	}
;1544:	n = ((menutext_s*)ptr)->generic.id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1545
;1545:	s_serveroptions.newBotIndex = n;
ADDRGP4 s_serveroptions+7028
ADDRLP4 0
INDIRI4
ASGNI4
line 1546
;1546:	UI_BotSelectMenu( s_serveroptions.playerNameBuffers[n] );
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
ARGP4
ADDRGP4 UI_BotSelectMenu
CALLV
pop
line 1547
;1547:}
LABELV $903
endproc ServerOptions_PlayerNameEvent 4 4
proc ServerOptions_StatusBar 4 20
line 1555
;1548:
;1549:
;1550:/*
;1551:=================
;1552:ServerOptions_StatusBar
;1553:=================
;1554:*/
;1555:static void ServerOptions_StatusBar( void* ptr ) {
line 1556
;1556:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $909
JUMPV
LABELV $909
line 1558
;1557:	default:
;1558:		UI_DrawString( 320, 440, "0 = NO LIMIT", UI_CENTER|UI_SMALLFONT, colorWhite );
CNSTI4 320
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $912
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 colorWhite
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1559
;1559:		break;
LABELV $910
line 1561
;1560:	}
;1561:}
LABELV $908
endproc ServerOptions_StatusBar 4 20
proc ServerOptions_LevelshotDraw 24 20
line 1569
;1562:
;1563:
;1564:/*
;1565:===============
;1566:ServerOptions_LevelshotDraw
;1567:===============
;1568:*/
;1569:static void ServerOptions_LevelshotDraw( void *self ) {
line 1575
;1570:	menubitmap_s	*b;
;1571:	int				x;
;1572:	int				y;
;1573:
;1574:	// strange place for this, but it works
;1575:	if( s_serveroptions.newBot ) {
ADDRGP4 s_serveroptions+7024
INDIRI4
CNSTI4 0
EQI4 $914
line 1576
;1576:		Q_strncpyz( s_serveroptions.playerNameBuffers[s_serveroptions.newBotIndex], s_serveroptions.newBotName, 16 );
ADDRGP4 s_serveroptions+7028
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
ARGP4
ADDRGP4 s_serveroptions+7032
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1577
;1577:		s_serveroptions.newBot = qfalse;
ADDRGP4 s_serveroptions+7024
CNSTI4 0
ASGNI4
line 1578
;1578:	}
LABELV $914
line 1580
;1579:
;1580:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1582
;1581:
;1582:	Bitmap_Draw( b );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Bitmap_Draw
CALLV
pop
line 1584
;1583:
;1584:	x = b->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1585
;1585:	y = b->generic.y + b->height;
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
line 1586
;1586:	UI_FillRect( x, y, b->width, 40, colorBlack );
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
line 1588
;1587:
;1588:	x += b->width / 2;
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
line 1589
;1589:	y += 4;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 1590
;1590:	UI_DrawString( x, y, s_serveroptions.mapnamebuffer, UI_CENTER|UI_SMALLFONT, color_orange );
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+6800
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1592
;1591:
;1592:	y += SMALLCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1593
;1593:	if( trap_Cvar_VariableValue("g_assaultMode") != 0 ) {
ADDRGP4 $261
ARGP4
ADDRLP4 16
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 0
EQF4 $922
line 1594
;1594:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $924
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1601
;1595:			x,
;1596:			y,
;1597:			"Base Assault",
;1598:			UI_CENTER | UI_SMALLFONT,
;1599:			color_orange
;1600:		);
;1601:	}
ADDRGP4 $923
JUMPV
LABELV $922
line 1602
;1602:	else if( trap_Cvar_VariableValue("g_autoCTF") != 0 ) {
ADDRGP4 $266
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $925
line 1603
;1603:		UI_DrawString(
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
line 1610
;1604:			x,
;1605:			y,
;1606:			"CTF on TDM Maps",
;1607:			UI_CENTER | UI_SMALLFONT,
;1608:			color_orange
;1609:		);
;1610:	}
ADDRGP4 $926
JUMPV
LABELV $925
line 1611
;1611:	else {
line 1612
;1612:		UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+6796
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
line 1621
;1613:			x,
;1614:			y,
;1615:			gametype_items[
;1616:				s_serveroptions.gameMode
;1617:			],
;1618:			UI_CENTER | UI_SMALLFONT,
;1619:			color_orange
;1620:		);
;1621:	}
LABELV $926
LABELV $923
line 1622
;1622:}
LABELV $913
endproc ServerOptions_LevelshotDraw 24 20
proc ServerOptions_InitBotNames 1072 12
line 1625
;1623:
;1624:
;1625:static void ServerOptions_InitBotNames( void ) {
line 1634
;1626:	int			count;
;1627:	int			n;
;1628:	const char	*arenaInfo;
;1629:	const char	*botInfo;
;1630:	char		*p;
;1631:	char		*bot;
;1632:	char		bots[MAX_INFO_STRING];
;1633:
;1634:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $929
line 1635
;1635:		Q_strncpyz( s_serveroptions.playerNameBuffers[1], "grunt", 16 );
ADDRGP4 s_serveroptions+6832+16
ARGP4
ADDRGP4 $934
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1636
;1636:		Q_strncpyz( s_serveroptions.playerNameBuffers[2], "major", 16 );
ADDRGP4 s_serveroptions+6832+32
ARGP4
ADDRGP4 $937
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1637
;1637:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
NEI4 $938
line 1638
;1638:			Q_strncpyz( s_serveroptions.playerNameBuffers[3], "visor", 16 );
ADDRGP4 s_serveroptions+6832+48
ARGP4
ADDRGP4 $943
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1639
;1639:		}
ADDRGP4 $939
JUMPV
LABELV $938
line 1640
;1640:		else {
line 1641
;1641:			s_serveroptions.playerType[3].curvalue = 2;
ADDRGP4 s_serveroptions+3356+288+64
CNSTI4 2
ASGNI4
line 1642
;1642:		}
LABELV $939
line 1643
;1643:		s_serveroptions.playerType[4].curvalue = 2;
ADDRGP4 s_serveroptions+3356+384+64
CNSTI4 2
ASGNI4
line 1644
;1644:		s_serveroptions.playerType[5].curvalue = 2;
ADDRGP4 s_serveroptions+3356+480+64
CNSTI4 2
ASGNI4
line 1646
;1645:
;1646:		Q_strncpyz( s_serveroptions.playerNameBuffers[6], "sarge", 16 );
ADDRGP4 s_serveroptions+6832+96
ARGP4
ADDRGP4 $955
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1647
;1647:		Q_strncpyz( s_serveroptions.playerNameBuffers[7], "grunt", 16 );
ADDRGP4 s_serveroptions+6832+112
ARGP4
ADDRGP4 $934
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1648
;1648:		Q_strncpyz( s_serveroptions.playerNameBuffers[8], "major", 16 );
ADDRGP4 s_serveroptions+6832+128
ARGP4
ADDRGP4 $937
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1649
;1649:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
NEI4 $960
line 1650
;1650:			Q_strncpyz( s_serveroptions.playerNameBuffers[9], "visor", 16 );
ADDRGP4 s_serveroptions+6832+144
ARGP4
ADDRGP4 $943
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1651
;1651:		}
ADDRGP4 $961
JUMPV
LABELV $960
line 1652
;1652:		else {
line 1653
;1653:			s_serveroptions.playerType[9].curvalue = 2;
ADDRGP4 s_serveroptions+3356+864+64
CNSTI4 2
ASGNI4
line 1654
;1654:		}
LABELV $961
line 1655
;1655:		s_serveroptions.playerType[10].curvalue = 2;
ADDRGP4 s_serveroptions+3356+960+64
CNSTI4 2
ASGNI4
line 1656
;1656:		s_serveroptions.playerType[11].curvalue = 2;
ADDRGP4 s_serveroptions+3356+1056+64
CNSTI4 2
ASGNI4
line 1658
;1657:
;1658:		return;
ADDRGP4 $928
JUMPV
LABELV $929
line 1661
;1659:	}
;1660:
;1661:	count = 1;	// skip the first slot, reserved for a human
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1664
;1662:
;1663:	// get info for this map
;1664:	arenaInfo = UI_GetArenaInfoByMap( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6800
ARGP4
ADDRLP4 1048
ADDRGP4 UI_GetArenaInfoByMap
CALLP4
ASGNP4
ADDRLP4 1044
ADDRLP4 1048
INDIRP4
ASGNP4
line 1667
;1665:
;1666:	// get the bot info - we'll seed with them if any are listed
;1667:	Q_strncpyz( bots, Info_ValueForKey( arenaInfo, "bots" ), sizeof(bots) );
ADDRLP4 1044
INDIRP4
ARGP4
ADDRGP4 $975
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
line 1668
;1668:	p = &bots[0];
ADDRLP4 0
ADDRLP4 20
ASGNP4
ADDRGP4 $977
JUMPV
line 1669
;1669:	while( *p && count < PLAYER_SLOTS ) {
LABELV $979
line 1671
;1670:		//skip spaces
;1671:		while( *p && *p == ' ' ) {
line 1672
;1672:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1673
;1673:		}
LABELV $980
line 1671
ADDRLP4 1056
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1056
INDIRI4
CNSTI4 0
EQI4 $982
ADDRLP4 1056
INDIRI4
CNSTI4 32
EQI4 $979
LABELV $982
line 1674
;1674:		if( !p ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $983
line 1675
;1675:			break;
ADDRGP4 $978
JUMPV
LABELV $983
line 1679
;1676:		}
;1677:
;1678:		// mark start of bot name
;1679:		bot = p;
ADDRLP4 8
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $986
JUMPV
LABELV $985
line 1682
;1680:
;1681:		// skip until space of null
;1682:		while( *p && *p != ' ' ) {
line 1683
;1683:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1684
;1684:		}
LABELV $986
line 1682
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $988
ADDRLP4 1060
INDIRI4
CNSTI4 32
NEI4 $985
LABELV $988
line 1685
;1685:		if( *p ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $989
line 1686
;1686:			*p++ = 0;
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
line 1687
;1687:		}
LABELV $989
line 1689
;1688:
;1689:		botInfo = UI_GetBotInfoByName( bot );
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
line 1690
;1690:		bot = Info_ValueForKey( botInfo, "name" );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 $820
ARGP4
ADDRLP4 1068
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1068
INDIRP4
ASGNP4
line 1692
;1691:
;1692:		Q_strncpyz( s_serveroptions.playerNameBuffers[count], bot, sizeof(s_serveroptions.playerNameBuffers[count]) );
ADDRLP4 4
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
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
line 1693
;1693:		count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1694
;1694:	}
LABELV $977
line 1669
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $993
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $980
LABELV $993
LABELV $978
line 1697
;1695:
;1696:	// set the rest of the bot slots to "---"
;1697:	for( n = count; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $997
JUMPV
LABELV $994
line 1698
;1698:		strcpy( s_serveroptions.playerNameBuffers[n], "--------" );
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6832
ADDP4
ARGP4
ADDRGP4 $999
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1699
;1699:	}
LABELV $995
line 1697
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $997
ADDRLP4 12
INDIRI4
CNSTI4 12
LTI4 $994
line 1702
;1700:
;1701:	// pad up to #8 as open slots
;1702:	for( ;count < 8; count++ ) {
ADDRGP4 $1003
JUMPV
LABELV $1000
line 1703
;1703:		s_serveroptions.playerType[count].curvalue = 0;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 0
ASGNI4
line 1704
;1704:	}
LABELV $1001
line 1702
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1003
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $1000
line 1707
;1705:
;1706:	// close off the rest by default
;1707:	for( ;count < PLAYER_SLOTS; count++ ) {
ADDRGP4 $1009
JUMPV
LABELV $1006
line 1708
;1708:		if( s_serveroptions.playerType[count].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $1010
line 1709
;1709:			s_serveroptions.playerType[count].curvalue = 2;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 2
ASGNI4
line 1710
;1710:		}
LABELV $1010
line 1711
;1711:	}
LABELV $1007
line 1707
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1009
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $1006
line 1712
;1712:}
LABELV $928
endproc ServerOptions_InitBotNames 1072 12
bss
align 1
LABELV $1017
skip 64
code
proc ServerOptions_SetMenuItems 180 16
line 1720
;1713:
;1714:
;1715:/*
;1716:=================
;1717:ServerOptions_SetMenuItems
;1718:=================
;1719:*/
;1720:static void ServerOptions_SetMenuItems( void ) {
line 1723
;1721:	static char picname[64];
;1722:	
;1723:	s_serveroptions.respawnTime.curvalue =
ADDRGP4 $1020
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
line 1732
;1724:	(int)Com_Clamp(
;1725:		0,
;1726:		7,
;1727:		trap_Cvar_VariableValue(
;1728:			"ui_respawnTime"
;1729:		)
;1730:	);
;1731:	
;1732:	s_serveroptions.assaultMiddleItem.curvalue =
ADDRGP4 $1023
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
line 1741
;1733:	(int)Com_Clamp(
;1734:		0,
;1735:		13,
;1736:		trap_Cvar_VariableValue(
;1737:			"ui_assaultMiddleItem"
;1738:		)
;1739:	);
;1740:
;1741:	s_serveroptions.noHealth.curvalue =
ADDRGP4 $1026
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $1028
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $1029
JUMPV
LABELV $1028
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1029
ADDRGP4 s_serveroptions+2580+60
ADDRLP4 16
INDIRI4
ASGNI4
line 1744
;1742:			trap_Cvar_VariableValue( "ui_noHealth" ) != 0;
;1743:
;1744:	s_serveroptions.noArmor.curvalue =
ADDRGP4 $1032
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 0
EQF4 $1034
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1035
JUMPV
LABELV $1034
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1035
ADDRGP4 s_serveroptions+2644+60
ADDRLP4 24
INDIRI4
ASGNI4
line 1747
;1745:		trap_Cvar_VariableValue( "ui_noArmor" ) != 0;
;1746:
;1747:	s_serveroptions.noPlasmaBFG.curvalue =
ADDRGP4 $1038
ARGP4
ADDRLP4 36
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
EQF4 $1040
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRGP4 $1041
JUMPV
LABELV $1040
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $1041
ADDRGP4 s_serveroptions+2836+60
ADDRLP4 32
INDIRI4
ASGNI4
line 1750
;1748:		trap_Cvar_VariableValue( "ui_noPlasmaBFG" ) != 0;
;1749:
;1750:	s_serveroptions.noGrenadeRocket.curvalue =
ADDRGP4 $1044
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 44
INDIRF4
CNSTF4 0
EQF4 $1046
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $1047
JUMPV
LABELV $1046
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $1047
ADDRGP4 s_serveroptions+2900+60
ADDRLP4 40
INDIRI4
ASGNI4
line 1753
;1751:		trap_Cvar_VariableValue( "ui_noGrenadeRocket" ) != 0;
;1752:		
;1753:	s_serveroptions.noRailgun.curvalue =
ADDRGP4 $732
ARGP4
ADDRLP4 52
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 0
EQF4 $1051
ADDRLP4 48
CNSTI4 1
ASGNI4
ADDRGP4 $1052
JUMPV
LABELV $1051
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $1052
ADDRGP4 s_serveroptions+2964+60
ADDRLP4 48
INDIRI4
ASGNI4
line 1756
;1754:		trap_Cvar_VariableValue( "ui_noRailgun" ) != 0;
;1755:		
;1756:	s_serveroptions.enableBlaster.curvalue =
ADDRGP4 $717
ARGP4
ADDRLP4 60
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 60
INDIRF4
CNSTF4 0
EQF4 $1056
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $1057
JUMPV
LABELV $1056
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $1057
ADDRGP4 s_serveroptions+3028+60
ADDRLP4 56
INDIRI4
ASGNI4
line 1759
;1757:		trap_Cvar_VariableValue( "ui_enableBlaster" ) != 0;
;1758:		
;1759:	s_serveroptions.noMegaHealth.curvalue =
ADDRGP4 $663
ARGP4
ADDRLP4 68
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
EQF4 $1061
ADDRLP4 64
CNSTI4 1
ASGNI4
ADDRGP4 $1062
JUMPV
LABELV $1061
ADDRLP4 64
CNSTI4 0
ASGNI4
LABELV $1062
ADDRGP4 s_serveroptions+2708+60
ADDRLP4 64
INDIRI4
ASGNI4
line 1762
;1760:		trap_Cvar_VariableValue( "ui_noMegaHealth" ) != 0;
;1761:
;1762:	s_serveroptions.noPersonalTeleporter.curvalue =
ADDRGP4 $672
ARGP4
ADDRLP4 76
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 76
INDIRF4
CNSTF4 0
EQF4 $1066
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRGP4 $1067
JUMPV
LABELV $1066
ADDRLP4 72
CNSTI4 0
ASGNI4
LABELV $1067
ADDRGP4 s_serveroptions+2772+60
ADDRLP4 72
INDIRI4
ASGNI4
line 1767
;1763:			trap_Cvar_VariableValue(
;1764:				"ui_noPersonalTeleporter"
;1765:			) != 0;
;1766:		
;1767:	s_serveroptions.noPowerups.curvalue =
ADDRGP4 $657
ARGP4
ADDRLP4 84
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 84
INDIRF4
CNSTF4 0
EQF4 $1071
ADDRLP4 80
CNSTI4 1
ASGNI4
ADDRGP4 $1072
JUMPV
LABELV $1071
ADDRLP4 80
CNSTI4 0
ASGNI4
LABELV $1072
ADDRGP4 s_serveroptions+2516+60
ADDRLP4 80
INDIRI4
ASGNI4
line 1770
;1768:		trap_Cvar_VariableValue( "ui_noPowerups" ) != 0;
;1769:
;1770:	Com_sprintf(
ADDRGP4 $656
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
ADDRGP4 $1079
ARGP4
ADDRLP4 92
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1781
;1771:			s_serveroptions.additionalSlots.field.buffer,
;1772:			sizeof( s_serveroptions.additionalSlots.field.buffer ),
;1773:			"%i",
;1774:			(int)Com_Clamp(
;1775:				0,
;1776:				MAX_CLIENTS - 1,
;1777:				trap_Cvar_VariableValue( "ui_additionalSlots" )
;1778:			)
;1779:		);
;1780:
;1781:	switch( s_serveroptions.gametype ) {
ADDRLP4 96
ADDRGP4 s_serveroptions+6792
INDIRI4
ASGNI4
ADDRLP4 96
INDIRI4
CNSTI4 0
LTI4 $1080
ADDRLP4 96
INDIRI4
CNSTI4 4
GTI4 $1080
ADDRLP4 96
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $1115
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $1115
address $1083
address $1090
address $1080
address $1097
address $1106
code
LABELV $1083
LABELV $1080
line 1784
;1782:	case GT_FFA:
;1783:	default:
;1784:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_fraglimit" ) ) );
ADDRGP4 $690
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
ADDRGP4 $1079
ARGP4
ADDRLP4 104
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1785
;1785:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_timelimit" ) ) );
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
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1079
ARGP4
ADDRLP4 112
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1786
;1786:		break;
ADDRGP4 $1081
JUMPV
LABELV $1090
line 1789
;1787:
;1788:	case GT_TOURNAMENT:
;1789:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_fraglimit" ) ) );
ADDRGP4 $693
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
ADDRGP4 $1079
ARGP4
ADDRLP4 120
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1790
;1790:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_timelimit" ) ) );
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
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1079
ARGP4
ADDRLP4 128
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1791
;1791:		break;
ADDRGP4 $1081
JUMPV
LABELV $1097
line 1794
;1792:
;1793:	case GT_TEAM:
;1794:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_fraglimit" ) ) );
ADDRGP4 $696
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
ADDRGP4 $1079
ARGP4
ADDRLP4 136
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1795
;1795:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_timelimit" ) ) );
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
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $1079
ARGP4
ADDRLP4 144
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1796
;1796:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_team_friendly" ) );
ADDRGP4 $698
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
line 1797
;1797:		break;
ADDRGP4 $1081
JUMPV
LABELV $1106
line 1800
;1798:
;1799:	case GT_CTF:
;1800:		Com_sprintf( s_serveroptions.flaglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 100, trap_Cvar_VariableValue( "ui_ctf_capturelimit" ) ) );
ADDRGP4 $700
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
ADDRGP4 $1079
ARGP4
ADDRLP4 160
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1801
;1801:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ctf_timelimit" ) ) );
ADDRGP4 $701
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
ADDRGP4 $1079
ARGP4
ADDRLP4 168
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1802
;1802:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_ctf_friendly" ) );
ADDRGP4 $702
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
line 1803
;1803:		break;
LABELV $1081
line 1806
;1804:	}
;1805:
;1806:	Q_strncpyz( s_serveroptions.hostname.field.buffer, UI_Cvar_VariableString( "sv_hostname" ), sizeof( s_serveroptions.hostname.field.buffer ) );
ADDRGP4 $710
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
line 1807
;1807:	s_serveroptions.pure.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_pure" ) );
ADDRGP4 $709
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
line 1810
;1808:
;1809:	// set the map pic
;1810:	Com_sprintf( picname, 64, "levelshots/%s", s_startserver.maplist[s_startserver.currentmap] );
ADDRGP4 $1017
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
line 1811
;1811:	s_serveroptions.mappic.generic.name = picname;
ADDRGP4 s_serveroptions+360+4
ADDRGP4 $1017
ASGNP4
line 1814
;1812:
;1813:	// set the map name
;1814:	strcpy( s_serveroptions.mapnamebuffer, s_startserver.mapname.string );
ADDRGP4 s_serveroptions+6800
ARGP4
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1815
;1815:	Q_strupr( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6800
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 1818
;1816:
;1817:	// get the player selections initialized
;1818:	ServerOptions_InitPlayerItems();
ADDRGP4 ServerOptions_InitPlayerItems
CALLV
pop
line 1819
;1819:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1822
;1820:
;1821:	// seed bot names
;1822:	ServerOptions_InitBotNames();
ADDRGP4 ServerOptions_InitBotNames
CALLV
pop
line 1823
;1823:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1824
;1824:}
LABELV $1016
endproc ServerOptions_SetMenuItems 180 16
proc PlayerName_Draw 48 20
line 1831
;1825:
;1826:/*
;1827:=================
;1828:PlayerName_Draw
;1829:=================
;1830:*/
;1831:static void PlayerName_Draw( void *item ) {
line 1838
;1832:	menutext_s	*s;
;1833:	float		*color;
;1834:	int			x, y;
;1835:	int			style;
;1836:	qboolean	focus;
;1837:
;1838:	s = (menutext_s *)item;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1840
;1839:
;1840:	x = s->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1841
;1841:	y =	s->generic.y;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 1843
;1842:
;1843:	style = UI_SMALLFONT;
ADDRLP4 16
CNSTI4 16
ASGNI4
line 1844
;1844:	focus = (s->generic.parent->cursor == s->generic.menuPosition);
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
NEI4 $1134
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1135
JUMPV
LABELV $1134
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1135
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 1846
;1845:
;1846:	if ( s->generic.flags & QMF_GRAYED )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $1136
line 1847
;1847:		color = text_color_disabled;
ADDRLP4 4
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $1137
JUMPV
LABELV $1136
line 1848
;1848:	else if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1138
line 1849
;1849:	{
line 1850
;1850:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1851
;1851:		style |= UI_PULSE;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 1852
;1852:	}
ADDRGP4 $1139
JUMPV
LABELV $1138
line 1853
;1853:	else if ( s->generic.flags & QMF_BLINK )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $1140
line 1854
;1854:	{
line 1855
;1855:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1856
;1856:		style |= UI_BLINK;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1857
;1857:	}
ADDRGP4 $1141
JUMPV
LABELV $1140
line 1859
;1858:	else
;1859:		color = text_color_normal;
ADDRLP4 4
ADDRGP4 text_color_normal
ASGNP4
LABELV $1141
LABELV $1139
LABELV $1137
line 1861
;1860:
;1861:	if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1142
line 1862
;1862:	{
line 1864
;1863:		// draw cursor
;1864:		UI_FillRect( s->generic.left, s->generic.top, s->generic.right-s->generic.left+1, s->generic.bottom-s->generic.top+1, listbar_color ); 
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
line 1865
;1865:		UI_DrawChar( x, y, 13, UI_CENTER|UI_BLINK|UI_SMALLFONT, color);
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
line 1866
;1866:	}
LABELV $1142
line 1868
;1867:
;1868:	UI_DrawString( x - SMALLCHAR_WIDTH, y, s->generic.name, style|UI_RIGHT, color );
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
line 1869
;1869:	UI_DrawString( x + SMALLCHAR_WIDTH, y, s->string, style|UI_LEFT, color );
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
line 1870
;1870:}
LABELV $1132
endproc PlayerName_Draw 48 20
proc ServerOptions_MenuInit 48 12
line 1880
;1871:
;1872:
;1873:/*
;1874:=================
;1875:ServerOptions_MenuInit
;1876:=================
;1877:*/
;1878:#define OPTIONS_X	456
;1879:
;1880:static void ServerOptions_MenuInit( qboolean multiplayer ) {
line 1884
;1881:	int		y;
;1882:	int		n;
;1883:
;1884:	memset( &s_serveroptions, 0 ,sizeof(serveroptions_t) );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 0
ARGI4
CNSTI4 7144
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1885
;1885:	s_serveroptions.multiplayer = multiplayer;
ADDRGP4 s_serveroptions+6788
ADDRFP4 0
INDIRI4
ASGNI4
line 1887
;1886:
;1887:	s_serveroptions.gameMode =
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
ADDRGP4 s_serveroptions+6796
ADDRLP4 8
INDIRF4
CVFI4 4
ASGNI4
line 1894
;1888:		(int)Com_Clamp(
;1889:			0,
;1890:			UI_MODE_COUNT - 1,
;1891:			s_startserver.gametype.curvalue
;1892:		);
;1893:
;1894:	s_serveroptions.gametype =
ADDRGP4 s_serveroptions+6792
ADDRGP4 s_serveroptions+6796
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
ASGNI4
line 1899
;1895:		gametype_remap[
;1896:			s_serveroptions.gameMode
;1897:		];
;1898:
;1899:	s_serveroptions.punkbuster.curvalue =
ADDRGP4 $714
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
ADDRGP4 s_serveroptions+7048+64
ADDRLP4 16
INDIRF4
CVFI4 4
ASGNI4
line 1908
;1900:		Com_Clamp(
;1901:			0,
;1902:			1,
;1903:			trap_Cvar_VariableValue(
;1904:				"sv_punkbuster"
;1905:			)
;1906:		);
;1907:
;1908:	ServerOptions_Cache();
ADDRGP4 ServerOptions_Cache
CALLV
pop
line 1910
;1909:
;1910:	s_serveroptions.menu.wrapAround = qtrue;
ADDRGP4 s_serveroptions+276
CNSTI4 1
ASGNI4
line 1911
;1911:	s_serveroptions.menu.fullscreen = qtrue;
ADDRGP4 s_serveroptions+280
CNSTI4 1
ASGNI4
line 1913
;1912:
;1913:	s_serveroptions.banner.generic.type			= MTYPE_BTEXT;
ADDRGP4 s_serveroptions+288
CNSTI4 10
ASGNI4
line 1914
;1914:	s_serveroptions.banner.generic.x			= 320;
ADDRGP4 s_serveroptions+288+12
CNSTI4 320
ASGNI4
line 1915
;1915:	s_serveroptions.banner.generic.y			= 16;
ADDRGP4 s_serveroptions+288+16
CNSTI4 16
ASGNI4
line 1916
;1916:	s_serveroptions.banner.string  				= "GAME SERVER";
ADDRGP4 s_serveroptions+288+60
ADDRGP4 $302
ASGNP4
line 1917
;1917:	s_serveroptions.banner.color  				= color_white;
ADDRGP4 s_serveroptions+288+68
ADDRGP4 color_white
ASGNP4
line 1918
;1918:	s_serveroptions.banner.style  				= UI_CENTER;
ADDRGP4 s_serveroptions+288+64
CNSTI4 1
ASGNI4
line 1920
;1919:
;1920:	s_serveroptions.mappic.generic.type			= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+360
CNSTI4 6
ASGNI4
line 1921
;1921:	s_serveroptions.mappic.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_serveroptions+360+44
CNSTU4 16388
ASGNU4
line 1922
;1922:	s_serveroptions.mappic.generic.x			= 352;
ADDRGP4 s_serveroptions+360+12
CNSTI4 352
ASGNI4
line 1923
;1923:	s_serveroptions.mappic.generic.y			= 80;
ADDRGP4 s_serveroptions+360+16
CNSTI4 80
ASGNI4
line 1924
;1924:	s_serveroptions.mappic.width				= 160;
ADDRGP4 s_serveroptions+360+76
CNSTI4 160
ASGNI4
line 1925
;1925:	s_serveroptions.mappic.height				= 120;
ADDRGP4 s_serveroptions+360+80
CNSTI4 120
ASGNI4
line 1926
;1926:	s_serveroptions.mappic.errorpic				= GAMESERVER_UNKNOWNMAP;
ADDRGP4 s_serveroptions+360+64
ADDRGP4 $373
ASGNP4
line 1927
;1927:	s_serveroptions.mappic.generic.ownerdraw	= ServerOptions_LevelshotDraw;
ADDRGP4 s_serveroptions+360+56
ADDRGP4 ServerOptions_LevelshotDraw
ASGNP4
line 1929
;1928:
;1929:	s_serveroptions.picframe.generic.type		= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+448
CNSTI4 6
ASGNI4
line 1930
;1930:	s_serveroptions.picframe.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE|QMF_HIGHLIGHT;
ADDRGP4 s_serveroptions+448+44
CNSTU4 16452
ASGNU4
line 1931
;1931:	s_serveroptions.picframe.generic.x			= 352 - 38;
ADDRGP4 s_serveroptions+448+12
CNSTI4 314
ASGNI4
line 1932
;1932:	s_serveroptions.picframe.generic.y			= 80 - 40;
ADDRGP4 s_serveroptions+448+16
CNSTI4 40
ASGNI4
line 1933
;1933:	s_serveroptions.picframe.width  			= 320;
ADDRGP4 s_serveroptions+448+76
CNSTI4 320
ASGNI4
line 1934
;1934:	s_serveroptions.picframe.height  			= 320;
ADDRGP4 s_serveroptions+448+80
CNSTI4 320
ASGNI4
line 1935
;1935:	s_serveroptions.picframe.focuspic			= GAMESERVER_SELECT;
ADDRGP4 s_serveroptions+448+60
ADDRGP4 $401
ASGNP4
line 1937
;1936:	
;1937:	s_serveroptions.respawnTime.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3188
CNSTI4 3
ASGNI4
line 1938
;1938:	s_serveroptions.respawnTime.generic.name ="Respawn Time:";
ADDRGP4 s_serveroptions+3188+4
ADDRGP4 $1197
ASGNP4
line 1939
;1939:	s_serveroptions.respawnTime.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3188+44
CNSTU4 258
ASGNU4
line 1940
;1940:	s_serveroptions.respawnTime.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3188+12
CNSTI4 456
ASGNI4
line 1941
;1941:	s_serveroptions.respawnTime.generic.y = 252;
ADDRGP4 s_serveroptions+3188+16
CNSTI4 252
ASGNI4
line 1942
;1942:	s_serveroptions.respawnTime.itemnames = respawnTime_list;
ADDRGP4 s_serveroptions+3188+76
ADDRGP4 respawnTime_list
ASGNP4
line 1944
;1943:	
;1944:	s_serveroptions.assaultMiddleItem.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3092
CNSTI4 3
ASGNI4
line 1945
;1945:	s_serveroptions.assaultMiddleItem.generic.name = "Point B(Base Assault):";
ADDRGP4 s_serveroptions+3092+4
ADDRGP4 $1209
ASGNP4
line 1946
;1946:	s_serveroptions.assaultMiddleItem.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3092+44
CNSTU4 258
ASGNU4
line 1947
;1947:	s_serveroptions.assaultMiddleItem.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3092+12
CNSTI4 456
ASGNI4
line 1948
;1948:	s_serveroptions.assaultMiddleItem.generic.y = 268;
ADDRGP4 s_serveroptions+3092+16
CNSTI4 268
ASGNI4
line 1949
;1949:	s_serveroptions.assaultMiddleItem.itemnames = assaultMiddleItem_list;
ADDRGP4 s_serveroptions+3092+76
ADDRGP4 assaultMiddleItem_list
ASGNP4
line 1951
;1950:	
;1951:	y = 282;
ADDRLP4 4
CNSTI4 282
ASGNI4
line 1953
;1952:	
;1953:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 4
EQI4 $1218
line 1954
;1954:		s_serveroptions.fraglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+964
CNSTI4 4
ASGNI4
line 1955
;1955:		s_serveroptions.fraglimit.generic.name       = "Frag Limit:";
ADDRGP4 s_serveroptions+964+4
ADDRGP4 $1224
ASGNP4
line 1956
;1956:		s_serveroptions.fraglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+964+44
CNSTU4 290
ASGNU4
line 1957
;1957:		s_serveroptions.fraglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+964+12
CNSTI4 456
ASGNI4
line 1958
;1958:		s_serveroptions.fraglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1959
;1959:		s_serveroptions.fraglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+964+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1960
;1960:		s_serveroptions.fraglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+964+60+8
CNSTI4 3
ASGNI4
line 1961
;1961:		s_serveroptions.fraglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+964+60+268
CNSTI4 3
ASGNI4
line 1962
;1962:	}
ADDRGP4 $1219
JUMPV
LABELV $1218
line 1963
;1963:	else {
line 1964
;1964:		s_serveroptions.flaglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1296
CNSTI4 4
ASGNI4
line 1965
;1965:		s_serveroptions.flaglimit.generic.name       = "Capture Limit:";
ADDRGP4 s_serveroptions+1296+4
ADDRGP4 $1242
ASGNP4
line 1966
;1966:		s_serveroptions.flaglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1296+44
CNSTU4 290
ASGNU4
line 1967
;1967:		s_serveroptions.flaglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+1296+12
CNSTI4 456
ASGNI4
line 1968
;1968:		s_serveroptions.flaglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+1296+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1969
;1969:		s_serveroptions.flaglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+1296+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1970
;1970:		s_serveroptions.flaglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+1296+60+8
CNSTI4 3
ASGNI4
line 1971
;1971:		s_serveroptions.flaglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+1296+60+268
CNSTI4 3
ASGNI4
line 1972
;1972:	}
LABELV $1219
line 1974
;1973:
;1974:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1975
;1975:	s_serveroptions.timelimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+632
CNSTI4 4
ASGNI4
line 1976
;1976:	s_serveroptions.timelimit.generic.name       = "Time Limit:";
ADDRGP4 s_serveroptions+632+4
ADDRGP4 $1260
ASGNP4
line 1977
;1977:	s_serveroptions.timelimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+632+44
CNSTU4 290
ASGNU4
line 1978
;1978:	s_serveroptions.timelimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+632+12
CNSTI4 456
ASGNI4
line 1979
;1979:	s_serveroptions.timelimit.generic.y	         = y;
ADDRGP4 s_serveroptions+632+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1980
;1980:	s_serveroptions.timelimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+632+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1981
;1981:	s_serveroptions.timelimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+632+60+8
CNSTI4 3
ASGNI4
line 1982
;1982:	s_serveroptions.timelimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+632+60+268
CNSTI4 3
ASGNI4
line 1984
;1983:
;1984:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1275
line 1985
;1985:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1986
;1986:		s_serveroptions.friendlyfire.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+1628
CNSTI4 5
ASGNI4
line 1987
;1987:		s_serveroptions.friendlyfire.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1628+44
CNSTU4 258
ASGNU4
line 1988
;1988:		s_serveroptions.friendlyfire.generic.x	      = OPTIONS_X;
ADDRGP4 s_serveroptions+1628+12
CNSTI4 456
ASGNI4
line 1989
;1989:		s_serveroptions.friendlyfire.generic.y	      = y;
ADDRGP4 s_serveroptions+1628+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1990
;1990:		s_serveroptions.friendlyfire.generic.name	  = "Friendly Fire:";
ADDRGP4 s_serveroptions+1628+4
ADDRGP4 $1287
ASGNP4
line 1991
;1991:	}
LABELV $1275
line 1993
;1992:
;1993:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1994
;1994:	s_serveroptions.pure.generic.type			= MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2024
CNSTI4 5
ASGNI4
line 1995
;1995:	s_serveroptions.pure.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2024+44
CNSTU4 258
ASGNU4
line 1996
;1996:	s_serveroptions.pure.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+2024+12
CNSTI4 456
ASGNI4
line 1997
;1997:	s_serveroptions.pure.generic.y				= y;
ADDRGP4 s_serveroptions+2024+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1998
;1998:	s_serveroptions.pure.generic.name			= "Pure Server:";
ADDRGP4 s_serveroptions+2024+4
ADDRGP4 $1297
ASGNP4
line 2000
;1999:
;2000:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1298
line 2001
;2001:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2002
;2002:		s_serveroptions.dedicated.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+536
CNSTI4 3
ASGNI4
line 2003
;2003:		s_serveroptions.dedicated.generic.id		= ID_DEDICATED;
ADDRGP4 s_serveroptions+536+8
CNSTI4 22
ASGNI4
line 2004
;2004:		s_serveroptions.dedicated.generic.flags		= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+536+44
CNSTU4 258
ASGNU4
line 2005
;2005:		s_serveroptions.dedicated.generic.callback	= ServerOptions_Event;
ADDRGP4 s_serveroptions+536+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2006
;2006:		s_serveroptions.dedicated.generic.x			= OPTIONS_X;
ADDRGP4 s_serveroptions+536+12
CNSTI4 456
ASGNI4
line 2007
;2007:		s_serveroptions.dedicated.generic.y			= y;
ADDRGP4 s_serveroptions+536+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2008
;2008:		s_serveroptions.dedicated.generic.name		= "Dedicated:";
ADDRGP4 s_serveroptions+536+4
ADDRGP4 $1314
ASGNP4
line 2009
;2009:		s_serveroptions.dedicated.itemnames			= dedicated_list;
ADDRGP4 s_serveroptions+536+76
ADDRGP4 dedicated_list
ASGNP4
line 2010
;2010:	}
LABELV $1298
line 2012
;2011:
;2012:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1317
line 2013
;2013:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2014
;2014:		s_serveroptions.hostname.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1692
CNSTI4 4
ASGNI4
line 2015
;2015:		s_serveroptions.hostname.generic.name       = "Hostname:";
ADDRGP4 s_serveroptions+1692+4
ADDRGP4 $1323
ASGNP4
line 2016
;2016:		s_serveroptions.hostname.generic.flags      = QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1692+44
CNSTU4 2
ASGNU4
line 2017
;2017:		s_serveroptions.hostname.generic.x          = OPTIONS_X;
ADDRGP4 s_serveroptions+1692+12
CNSTI4 456
ASGNI4
line 2018
;2018:		s_serveroptions.hostname.generic.y	        = y;
ADDRGP4 s_serveroptions+1692+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2019
;2019:		s_serveroptions.hostname.field.widthInChars = 18;
ADDRGP4 s_serveroptions+1692+60+8
CNSTI4 18
ASGNI4
line 2020
;2020:		s_serveroptions.hostname.field.maxchars     = 64;
ADDRGP4 s_serveroptions+1692+60+268
CNSTI4 64
ASGNI4
line 2021
;2021:	}
LABELV $1317
line 2023
;2022:
;2023:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 2024
;2024:	s_serveroptions.punkbuster.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+7048
CNSTI4 3
ASGNI4
line 2025
;2025:	s_serveroptions.punkbuster.generic.name			= "Punkbuster:";
ADDRGP4 s_serveroptions+7048+4
ADDRGP4 $1339
ASGNP4
line 2026
;2026:	s_serveroptions.punkbuster.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+7048+44
CNSTU4 258
ASGNU4
line 2027
;2027:	s_serveroptions.punkbuster.generic.id			= 0;
ADDRGP4 s_serveroptions+7048+8
CNSTI4 0
ASGNI4
line 2028
;2028:	s_serveroptions.punkbuster.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+7048+12
CNSTI4 456
ASGNI4
line 2029
;2029:	s_serveroptions.punkbuster.generic.y				= y;
ADDRGP4 s_serveroptions+7048+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2030
;2030:	s_serveroptions.punkbuster.itemnames				= punkbuster_items;
ADDRGP4 s_serveroptions+7048+76
ADDRGP4 punkbuster_items
ASGNP4
line 2032
;2031:	
;2032:	y = 90;
ADDRLP4 4
CNSTI4 90
ASGNI4
line 2033
;2033:	s_serveroptions.botSkill.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+2088
CNSTI4 3
ASGNI4
line 2034
;2034:	s_serveroptions.botSkill.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2088+44
CNSTU4 258
ASGNU4
line 2035
;2035:	s_serveroptions.botSkill.generic.name			= "Bot Skill:  ";
ADDRGP4 s_serveroptions+2088+4
ADDRGP4 $1355
ASGNP4
line 2036
;2036:	s_serveroptions.botSkill.generic.x				= 32 + (strlen(s_serveroptions.botSkill.generic.name) + 2 ) * SMALLCHAR_WIDTH;
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
line 2037
;2037:	s_serveroptions.botSkill.generic.y				= y;
ADDRGP4 s_serveroptions+2088+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2038
;2038:	s_serveroptions.botSkill.itemnames				= botSkill_list;
ADDRGP4 s_serveroptions+2088+76
ADDRGP4 botSkill_list
ASGNP4
line 2039
;2039:	s_serveroptions.botSkill.curvalue				= 1;
ADDRGP4 s_serveroptions+2088+64
CNSTI4 1
ASGNI4
line 2041
;2040:
;2041:	y += ( 2 * SMALLCHAR_HEIGHT );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 2042
;2042:	s_serveroptions.player0.generic.type			= MTYPE_TEXT;
ADDRGP4 s_serveroptions+3284
CNSTI4 7
ASGNI4
line 2043
;2043:	s_serveroptions.player0.generic.flags			= QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3284+44
CNSTU4 2
ASGNU4
line 2044
;2044:	s_serveroptions.player0.generic.x				= 32 + SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+3284+12
CNSTI4 40
ASGNI4
line 2045
;2045:	s_serveroptions.player0.generic.y				= y;
ADDRGP4 s_serveroptions+3284+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2046
;2046:	s_serveroptions.player0.color					= color_orange;
ADDRGP4 s_serveroptions+3284+68
ADDRGP4 color_orange
ASGNP4
line 2047
;2047:	s_serveroptions.player0.style					= UI_LEFT|UI_SMALLFONT;
ADDRGP4 s_serveroptions+3284+64
CNSTI4 16
ASGNI4
line 2049
;2048:
;2049:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1377
line 2050
;2050:		s_serveroptions.playerType[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356
ADDP4
CNSTI4 3
ASGNI4
line 2051
;2051:		s_serveroptions.playerType[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+44
ADDP4
CNSTU4 2
ASGNU4
line 2052
;2052:		s_serveroptions.playerType[n].generic.id		= ID_PLAYER_TYPE;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+8
ADDP4
CNSTI4 20
ASGNI4
line 2053
;2053:		s_serveroptions.playerType[n].generic.callback	= ServerOptions_Event;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+48
ADDP4
ADDRGP4 ServerOptions_Event
ASGNP4
line 2054
;2054:		s_serveroptions.playerType[n].generic.x			= 32;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+12
ADDP4
CNSTI4 32
ASGNI4
line 2055
;2055:		s_serveroptions.playerType[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2056
;2056:		s_serveroptions.playerType[n].itemnames			= playerType_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+76
ADDP4
ADDRGP4 playerType_list
ASGNP4
line 2058
;2057:
;2058:		s_serveroptions.playerName[n].generic.type		= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508
ADDP4
CNSTI4 7
ASGNI4
line 2059
;2059:		s_serveroptions.playerName[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+44
ADDP4
CNSTU4 2
ASGNU4
line 2060
;2060:		s_serveroptions.playerName[n].generic.x			= 96;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
CNSTI4 96
ASGNI4
line 2061
;2061:		s_serveroptions.playerName[n].generic.y			= y;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2062
;2062:		s_serveroptions.playerName[n].generic.callback	= ServerOptions_PlayerNameEvent;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+48
ADDP4
ADDRGP4 ServerOptions_PlayerNameEvent
ASGNP4
line 2063
;2063:		s_serveroptions.playerName[n].generic.id		= n;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2064
;2064:		s_serveroptions.playerName[n].generic.ownerdraw	= PlayerName_Draw;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+56
ADDP4
ADDRGP4 PlayerName_Draw
ASGNP4
line 2065
;2065:		s_serveroptions.playerName[n].color				= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2066
;2066:		s_serveroptions.playerName[n].style				= UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+64
ADDP4
CNSTI4 16
ASGNI4
line 2067
;2067:		s_serveroptions.playerName[n].string			= s_serveroptions.playerNameBuffers[n];
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
ADDRGP4 s_serveroptions+6832
ADDP4
ASGNP4
line 2068
;2068:		s_serveroptions.playerName[n].generic.top		= s_serveroptions.playerName[n].generic.y;
ADDRLP4 32
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 32
INDIRI4
ADDRGP4 s_serveroptions+4508+24
ADDP4
ADDRLP4 32
INDIRI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
INDIRI4
ASGNI4
line 2069
;2069:		s_serveroptions.playerName[n].generic.bottom	= s_serveroptions.playerName[n].generic.y + SMALLCHAR_HEIGHT;
ADDRLP4 36
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4508+32
ADDP4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 2070
;2070:		s_serveroptions.playerName[n].generic.left		= s_serveroptions.playerName[n].generic.x - SMALLCHAR_HEIGHT/ 2;
ADDRLP4 40
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4508+20
ADDP4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
INDIRI4
CNSTI4 8
SUBI4
ASGNI4
line 2071
;2071:		s_serveroptions.playerName[n].generic.right		= s_serveroptions.playerName[n].generic.x + 16 * SMALLCHAR_WIDTH;
ADDRLP4 44
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4508+28
ADDP4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
INDIRI4
CNSTI4 128
ADDI4
ASGNI4
line 2073
;2072:
;2073:		s_serveroptions.playerTeam[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372
ADDP4
CNSTI4 3
ASGNI4
line 2074
;2074:		s_serveroptions.playerTeam[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+44
ADDP4
CNSTU4 2
ASGNU4
line 2075
;2075:		s_serveroptions.playerTeam[n].generic.x			= 240;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+12
ADDP4
CNSTI4 240
ASGNI4
line 2076
;2076:		s_serveroptions.playerTeam[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2077
;2077:		s_serveroptions.playerTeam[n].itemnames			= playerTeam_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+76
ADDP4
ADDRGP4 playerTeam_list
ASGNP4
line 2079
;2078:
;2079:		y += ( SMALLCHAR_HEIGHT + 4 );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
line 2080
;2080:	}
LABELV $1378
line 2049
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1377
line 2082
;2081:
;2082:	s_serveroptions.additionalSlots.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+2184
CNSTI4 4
ASGNI4
line 2083
;2083:	s_serveroptions.additionalSlots.generic.name       = "Additional Slots:";
ADDRGP4 s_serveroptions+2184+4
ADDRGP4 $1442
ASGNP4
line 2084
;2084:	s_serveroptions.additionalSlots.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2184+44
CNSTU4 290
ASGNU4
line 2085
;2085:	s_serveroptions.additionalSlots.generic.id         = ID_MAXCLIENTS;
ADDRGP4 s_serveroptions+2184+8
CNSTI4 21
ASGNI4
line 2086
;2086:	s_serveroptions.additionalSlots.generic.x          = 240;
ADDRGP4 s_serveroptions+2184+12
CNSTI4 240
ASGNI4
line 2087
;2087:	s_serveroptions.additionalSlots.generic.y          = y;
ADDRGP4 s_serveroptions+2184+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2088
;2088:	s_serveroptions.additionalSlots.field.widthInChars = 2;
ADDRGP4 s_serveroptions+2184+60+8
CNSTI4 2
ASGNI4
line 2089
;2089:	s_serveroptions.additionalSlots.field.maxchars     = 2;
ADDRGP4 s_serveroptions+2184+60+268
CNSTI4 2
ASGNI4
line 2091
;2090:	
;2091:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2092
;2092:	s_serveroptions.noPowerups.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2516
CNSTI4 5
ASGNI4
line 2093
;2093:	s_serveroptions.noPowerups.generic.name     = "No Powerups:";
ADDRGP4 s_serveroptions+2516+4
ADDRGP4 $1460
ASGNP4
line 2094
;2094:	s_serveroptions.noPowerups.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2516+44
CNSTU4 258
ASGNU4
line 2095
;2095:	s_serveroptions.noPowerups.generic.x        = 240;
ADDRGP4 s_serveroptions+2516+12
CNSTI4 240
ASGNI4
line 2096
;2096:	s_serveroptions.noPowerups.generic.y        = y;
ADDRGP4 s_serveroptions+2516+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2098
;2097:	
;2098:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2099
;2099:	s_serveroptions.noHealth.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2580
CNSTI4 5
ASGNI4
line 2100
;2100:	s_serveroptions.noHealth.generic.name = "No Health:";
ADDRGP4 s_serveroptions+2580+4
ADDRGP4 $1470
ASGNP4
line 2101
;2101:	s_serveroptions.noHealth.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2580+44
CNSTU4 258
ASGNU4
line 2102
;2102:	s_serveroptions.noHealth.generic.x = 240;
ADDRGP4 s_serveroptions+2580+12
CNSTI4 240
ASGNI4
line 2103
;2103:	s_serveroptions.noHealth.generic.y = y;
ADDRGP4 s_serveroptions+2580+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2105
;2104:
;2105:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2106
;2106:	s_serveroptions.noArmor.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2644
CNSTI4 5
ASGNI4
line 2107
;2107:	s_serveroptions.noArmor.generic.name = "No Armor:";
ADDRGP4 s_serveroptions+2644+4
ADDRGP4 $1480
ASGNP4
line 2108
;2108:	s_serveroptions.noArmor.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2644+44
CNSTU4 258
ASGNU4
line 2109
;2109:	s_serveroptions.noArmor.generic.x = 240;
ADDRGP4 s_serveroptions+2644+12
CNSTI4 240
ASGNI4
line 2110
;2110:	s_serveroptions.noArmor.generic.y = y;
ADDRGP4 s_serveroptions+2644+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2112
;2111:	
;2112:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2114
;2113:
;2114:	s_serveroptions.noMegaHealth.generic.type  = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2708
CNSTI4 5
ASGNI4
line 2115
;2115:	s_serveroptions.noMegaHealth.generic.name  = "No Mega / Medkit:";
ADDRGP4 s_serveroptions+2708+4
ADDRGP4 $1490
ASGNP4
line 2116
;2116:	s_serveroptions.noMegaHealth.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2708+44
CNSTU4 258
ASGNU4
line 2117
;2117:	s_serveroptions.noMegaHealth.generic.x     = 240;
ADDRGP4 s_serveroptions+2708+12
CNSTI4 240
ASGNI4
line 2118
;2118:	s_serveroptions.noMegaHealth.generic.y     = y;
ADDRGP4 s_serveroptions+2708+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2120
;2119:
;2120:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2121
;2121:	s_serveroptions.noPersonalTeleporter.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2772
CNSTI4 5
ASGNI4
line 2122
;2122:	s_serveroptions.noPersonalTeleporter.generic.name = "No Personal TP:";
ADDRGP4 s_serveroptions+2772+4
ADDRGP4 $1500
ASGNP4
line 2123
;2123:	s_serveroptions.noPersonalTeleporter.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2772+44
CNSTU4 258
ASGNU4
line 2124
;2124:	s_serveroptions.noPersonalTeleporter.generic.x = 240;
ADDRGP4 s_serveroptions+2772+12
CNSTI4 240
ASGNI4
line 2125
;2125:	s_serveroptions.noPersonalTeleporter.generic.y = y;
ADDRGP4 s_serveroptions+2772+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2127
;2126:	
;2127:	y=368;
ADDRLP4 4
CNSTI4 368
ASGNI4
line 2128
;2128:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2129
;2129:	s_serveroptions.noPlasmaBFG.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2836
CNSTI4 5
ASGNI4
line 2130
;2130:	s_serveroptions.noPlasmaBFG.generic.name = "No Energy Guns:";
ADDRGP4 s_serveroptions+2836+4
ADDRGP4 $1510
ASGNP4
line 2131
;2131:	s_serveroptions.noPlasmaBFG.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2836+44
CNSTU4 258
ASGNU4
line 2132
;2132:	s_serveroptions.noPlasmaBFG.generic.x = 440;
ADDRGP4 s_serveroptions+2836+12
CNSTI4 440
ASGNI4
line 2133
;2133:	s_serveroptions.noPlasmaBFG.generic.y = y;
ADDRGP4 s_serveroptions+2836+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2135
;2134:
;2135:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2136
;2136:	s_serveroptions.noGrenadeRocket.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2900
CNSTI4 5
ASGNI4
line 2137
;2137:	s_serveroptions.noGrenadeRocket.generic.name = "No Explosives:";
ADDRGP4 s_serveroptions+2900+4
ADDRGP4 $1520
ASGNP4
line 2138
;2138:	s_serveroptions.noGrenadeRocket.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2900+44
CNSTU4 258
ASGNU4
line 2139
;2139:	s_serveroptions.noGrenadeRocket.generic.x = 440;
ADDRGP4 s_serveroptions+2900+12
CNSTI4 440
ASGNI4
line 2140
;2140:	s_serveroptions.noGrenadeRocket.generic.y = y;
ADDRGP4 s_serveroptions+2900+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2142
;2141:	
;2142:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2143
;2143:	s_serveroptions.noRailgun.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2964
CNSTI4 5
ASGNI4
line 2144
;2144:	s_serveroptions.noRailgun.generic.name = "No Railgun:";
ADDRGP4 s_serveroptions+2964+4
ADDRGP4 $1530
ASGNP4
line 2145
;2145:	s_serveroptions.noRailgun.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2964+44
CNSTU4 258
ASGNU4
line 2146
;2146:	s_serveroptions.noRailgun.generic.x = 440;
ADDRGP4 s_serveroptions+2964+12
CNSTI4 440
ASGNI4
line 2147
;2147:	s_serveroptions.noRailgun.generic.y = y;
ADDRGP4 s_serveroptions+2964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2149
;2148:	
;2149:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2150
;2150:	s_serveroptions.enableBlaster.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+3028
CNSTI4 5
ASGNI4
line 2151
;2151:	s_serveroptions.enableBlaster.generic.name = "Enable Blaster:";
ADDRGP4 s_serveroptions+3028+4
ADDRGP4 $1540
ASGNP4
line 2152
;2152:	s_serveroptions.enableBlaster.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3028+44
CNSTU4 258
ASGNU4
line 2153
;2153:	s_serveroptions.enableBlaster.generic.x = 440;
ADDRGP4 s_serveroptions+3028+12
CNSTI4 440
ASGNI4
line 2154
;2154:	s_serveroptions.enableBlaster.generic.y = y;
ADDRGP4 s_serveroptions+3028+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2156
;2155:
;2156:	s_serveroptions.back.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6700
CNSTI4 6
ASGNI4
line 2157
;2157:	s_serveroptions.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_serveroptions+6700+4
ADDRGP4 $468
ASGNP4
line 2158
;2158:	s_serveroptions.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6700+44
CNSTU4 260
ASGNU4
line 2159
;2159:	s_serveroptions.back.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6700+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2160
;2160:	s_serveroptions.back.generic.id	      = ID_BACK;
ADDRGP4 s_serveroptions+6700+8
CNSTI4 24
ASGNI4
line 2161
;2161:	s_serveroptions.back.generic.x		  = 0;
ADDRGP4 s_serveroptions+6700+12
CNSTI4 0
ASGNI4
line 2162
;2162:	s_serveroptions.back.generic.y		  = 480-64;
ADDRGP4 s_serveroptions+6700+16
CNSTI4 416
ASGNI4
line 2163
;2163:	s_serveroptions.back.width  		  = 128;
ADDRGP4 s_serveroptions+6700+76
CNSTI4 128
ASGNI4
line 2164
;2164:	s_serveroptions.back.height  		  = 64;
ADDRGP4 s_serveroptions+6700+80
CNSTI4 64
ASGNI4
line 2165
;2165:	s_serveroptions.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_serveroptions+6700+60
ADDRGP4 $485
ASGNP4
line 2167
;2166:
;2167:	s_serveroptions.next.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6612
CNSTI4 6
ASGNI4
line 2168
;2168:	s_serveroptions.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_serveroptions+6612+4
ADDRGP4 $489
ASGNP4
line 2169
;2169:	s_serveroptions.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_INACTIVE|QMF_GRAYED|QMF_HIDDEN;
ADDRGP4 s_serveroptions+6612+44
CNSTU4 28944
ASGNU4
line 2170
;2170:	s_serveroptions.next.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6612+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2171
;2171:	s_serveroptions.next.generic.id	      = ID_STARTSERVERNEXT;
ADDRGP4 s_serveroptions+6612+8
CNSTI4 18
ASGNI4
line 2172
;2172:	s_serveroptions.next.generic.x		  = 640;
ADDRGP4 s_serveroptions+6612+12
CNSTI4 640
ASGNI4
line 2173
;2173:	s_serveroptions.next.generic.y		  = 480-64-72;
ADDRGP4 s_serveroptions+6612+16
CNSTI4 344
ASGNI4
line 2174
;2174:	s_serveroptions.next.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+6612+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 2175
;2175:	s_serveroptions.next.width  		  = 128;
ADDRGP4 s_serveroptions+6612+76
CNSTI4 128
ASGNI4
line 2176
;2176:	s_serveroptions.next.height  		  = 64;
ADDRGP4 s_serveroptions+6612+80
CNSTI4 64
ASGNI4
line 2177
;2177:	s_serveroptions.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_serveroptions+6612+60
ADDRGP4 $506
ASGNP4
line 2179
;2178:
;2179:	s_serveroptions.go.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6524
CNSTI4 6
ASGNI4
line 2180
;2180:	s_serveroptions.go.generic.name     = GAMESERVER_FIGHT0;
ADDRGP4 s_serveroptions+6524+4
ADDRGP4 $1590
ASGNP4
line 2181
;2181:	s_serveroptions.go.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6524+44
CNSTU4 272
ASGNU4
line 2182
;2182:	s_serveroptions.go.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6524+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2183
;2183:	s_serveroptions.go.generic.id	    = ID_GO;
ADDRGP4 s_serveroptions+6524+8
CNSTI4 23
ASGNI4
line 2184
;2184:	s_serveroptions.go.generic.x		= 640;
ADDRGP4 s_serveroptions+6524+12
CNSTI4 640
ASGNI4
line 2185
;2185:	s_serveroptions.go.generic.y		= 480-64;
ADDRGP4 s_serveroptions+6524+16
CNSTI4 416
ASGNI4
line 2186
;2186:	s_serveroptions.go.width  		    = 128;
ADDRGP4 s_serveroptions+6524+76
CNSTI4 128
ASGNI4
line 2187
;2187:	s_serveroptions.go.height  		    = 64;
ADDRGP4 s_serveroptions+6524+80
CNSTI4 64
ASGNI4
line 2188
;2188:	s_serveroptions.go.focuspic         = GAMESERVER_FIGHT1;
ADDRGP4 s_serveroptions+6524+60
ADDRGP4 $1607
ASGNP4
line 2190
;2189:
;2190:	if( s_serveroptions.gameMode != UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
ADDRGP4 s_serveroptions+6796
INDIRI4
CNSTI4 12
EQI4 $1608
line 2191
;2191:	Menu_AddItem(&s_serveroptions.menu,&s_serveroptions.respawnTime); }
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3188
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
LABELV $1608
line 2192
;2192:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.banner );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2193
;2193:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noMegaHealth );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2708
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2194
;2194:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noPersonalTeleporter );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2772
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2195
;2195:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.enableBlaster);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3028
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2196
;2196:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.mappic );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2197
;2197:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.picframe );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2199
;2198:
;2199:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.botSkill );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2088
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2200
;2200:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.player0 );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3284
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2201
;2201:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1620
line 2202
;2202:		if( n != 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1624
line 2203
;2203:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerType[n] );
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
line 2204
;2204:		}
LABELV $1624
line 2205
;2205:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerName[n] );
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
line 2206
;2206:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1628
line 2207
;2207:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerTeam[n] );
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
line 2208
;2208:		}
LABELV $1628
line 2209
;2209:	}
LABELV $1621
line 2201
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1620
line 2211
;2210:
;2211:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.additionalSlots );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2184
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2212
;2212:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPowerups);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2213
;2213:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noHealth);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2580
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2214
;2214:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noArmor);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2644
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2215
;2215:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPlasmaBFG);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2836
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2216
;2216:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noGrenadeRocket);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2900
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2217
;2217:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noRailgun);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2219
;2218:	
;2219:	if( trap_Cvar_VariableValue("g_assaultMode") == 1 ) {
ADDRGP4 $261
ARGP4
ADDRLP4 24
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 24
INDIRF4
CNSTF4 1065353216
NEF4 $1639
line 2220
;2220:		Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.assaultMiddleItem
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3092
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2222
;2221:		);
;2222:	}
LABELV $1639
line 2224
;2223:		
;2224:	if( s_serveroptions.gametype == GT_CTF ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 4
NEI4 $1642
line 2225
;2225:		Menu_AddItem(
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1296
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2229
;2226:			&s_serveroptions.menu,
;2227:			&s_serveroptions.flaglimit
;2228:		);
;2229:	}
ADDRGP4 $1643
JUMPV
LABELV $1642
line 2230
;2230:	else if( s_serveroptions.gameMode !=
ADDRGP4 s_serveroptions+6796
INDIRI4
CNSTI4 12
EQI4 $1646
line 2231
;2231:		UI_MODE_MONSTER_HUNT_ONE_LIFE ) {
line 2232
;2232:		Menu_AddItem(
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2236
;2233:			&s_serveroptions.menu,
;2234:			&s_serveroptions.fraglimit
;2235:		);
;2236:	}
LABELV $1646
LABELV $1643
line 2237
;2237:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.timelimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+632
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2238
;2238:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1651
line 2239
;2239:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.friendlyfire );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1628
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2240
;2240:	}
LABELV $1651
line 2241
;2241:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.pure );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2024
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2242
;2242:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1656
line 2243
;2243:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.dedicated );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2244
;2244:	}
LABELV $1656
line 2245
;2245:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1660
line 2246
;2246:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.hostname );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1692
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2247
;2247:	}
LABELV $1660
line 2249
;2248:
;2249:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.back );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6700
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2250
;2250:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.next );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6612
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2251
;2251:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.go );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6524
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2253
;2252:
;2253:	Menu_AddItem( &s_serveroptions.menu, (void*) &s_serveroptions.punkbuster );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+7048
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2256
;2254:	
;2255:	
;2256:	ServerOptions_SetMenuItems();
ADDRGP4 ServerOptions_SetMenuItems
CALLV
pop
line 2257
;2257:}
LABELV $1144
endproc ServerOptions_MenuInit 48 12
export ServerOptions_Cache
proc ServerOptions_Cache 0 4
line 2264
;2258:
;2259:/*
;2260:=================
;2261:ServerOptions_Cache
;2262:=================
;2263:*/
;2264:void ServerOptions_Cache( void ) {
line 2265
;2265:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );
ADDRGP4 $468
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2266
;2266:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );
ADDRGP4 $485
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2267
;2267:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT0 );
ADDRGP4 $1590
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2268
;2268:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT1 );
ADDRGP4 $1607
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2269
;2269:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );
ADDRGP4 $401
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2270
;2270:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $373
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2271
;2271:}
LABELV $1668
endproc ServerOptions_Cache 0 4
proc UI_ServerOptionsMenu 0 4
line 2279
;2272:
;2273:
;2274:/*
;2275:=================
;2276:UI_ServerOptionsMenu
;2277:=================
;2278:*/
;2279:static void UI_ServerOptionsMenu( qboolean multiplayer ) {
line 2280
;2280:	ServerOptions_MenuInit( multiplayer );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 ServerOptions_MenuInit
CALLV
pop
line 2281
;2281:	UI_PushMenu( &s_serveroptions.menu );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2282
;2282:}
LABELV $1669
endproc UI_ServerOptionsMenu 0 4
proc UI_BotSelectMenu_SortCompare 44 8
line 2343
;2283:
;2284:
;2285:
;2286:/*
;2287:=============================================================================
;2288:
;2289:BOT SELECT MENU *****
;2290:
;2291:=============================================================================
;2292:*/
;2293:
;2294:
;2295:#define BOTSELECT_BACK0			"menu/art/back_0"
;2296:#define BOTSELECT_BACK1			"menu/art/back_1"
;2297:#define BOTSELECT_ACCEPT0		"menu/art/accept_0"
;2298:#define BOTSELECT_ACCEPT1		"menu/art/accept_1"
;2299:#define BOTSELECT_SELECT		"menu/art/opponents_select"
;2300:#define BOTSELECT_SELECTED		"menu/art/opponents_selected"
;2301:#define BOTSELECT_ARROWS		"menu/art/gs_arrows_0"
;2302:#define BOTSELECT_ARROWSL		"menu/art/gs_arrows_l"
;2303:#define BOTSELECT_ARROWSR		"menu/art/gs_arrows_r"
;2304:
;2305:#define PLAYERGRID_COLS			4
;2306:#define PLAYERGRID_ROWS			4
;2307:#define MAX_MODELSPERPAGE		(PLAYERGRID_ROWS * PLAYERGRID_COLS)
;2308:
;2309:
;2310:typedef struct {
;2311:	menuframework_s	menu;
;2312:
;2313:	menutext_s		banner;
;2314:
;2315:	menubitmap_s	pics[MAX_MODELSPERPAGE];
;2316:	menubitmap_s	picbuttons[MAX_MODELSPERPAGE];
;2317:	menutext_s		picnames[MAX_MODELSPERPAGE];
;2318:
;2319:	menubitmap_s	arrows;
;2320:	menubitmap_s	left;
;2321:	menubitmap_s	right;
;2322:
;2323:	menubitmap_s	go;
;2324:	menubitmap_s	back;
;2325:
;2326:	int				numBots;
;2327:	int				modelpage;
;2328:	int				numpages;
;2329:	int				selectedmodel;
;2330:	int				sortedBotNums[MAX_BOTS];
;2331:	char			boticons[MAX_MODELSPERPAGE][MAX_QPATH];
;2332:	char			botnames[MAX_MODELSPERPAGE][16];
;2333:} botSelectInfo_t;
;2334:
;2335:static botSelectInfo_t	botSelectInfo;
;2336:
;2337:
;2338:/*
;2339:=================
;2340:UI_BotSelectMenu_SortCompare
;2341:=================
;2342:*/
;2343:static int QDECL UI_BotSelectMenu_SortCompare( const void *arg1, const void *arg2 ) {
line 2348
;2344:	int			num1, num2;
;2345:	const char	*info1, *info2;
;2346:	const char	*name1, *name2;
;2347:
;2348:	num1 = *(int *)arg1;
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 2349
;2349:	num2 = *(int *)arg2;
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
line 2351
;2350:
;2351:	info1 = UI_GetBotInfoByNumber( num1 );
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
line 2352
;2352:	info2 = UI_GetBotInfoByNumber( num2 );
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
line 2354
;2353:
;2354:	name1 = Info_ValueForKey( info1, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $820
ARGP4
ADDRLP4 32
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 2355
;2355:	name2 = Info_ValueForKey( info2, "name" );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 $820
ARGP4
ADDRLP4 36
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 36
INDIRP4
ASGNP4
line 2357
;2356:
;2357:	return Q_stricmp( name1, name2 );
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
LABELV $1671
endproc UI_BotSelectMenu_SortCompare 44 8
proc UI_BotSelectMenu_BuildList 12 16
line 2366
;2358:}
;2359:
;2360:
;2361:/*
;2362:=================
;2363:UI_BotSelectMenu_BuildList
;2364:=================
;2365:*/
;2366:static void UI_BotSelectMenu_BuildList( void ) {
line 2369
;2367:	int		n;
;2368:
;2369:	botSelectInfo.modelpage = 0;
ADDRGP4 botSelectInfo+4772
CNSTI4 0
ASGNI4
line 2370
;2370:	botSelectInfo.numBots = UI_GetNumBots();
ADDRLP4 4
ADDRGP4 UI_GetNumBots
CALLI4
ASGNI4
ADDRGP4 botSelectInfo+4768
ADDRLP4 4
INDIRI4
ASGNI4
line 2371
;2371:	botSelectInfo.numpages = botSelectInfo.numBots / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4776
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2372
;2372:	if( botSelectInfo.numBots % MAX_MODELSPERPAGE ) {
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
MODI4
CNSTI4 0
EQI4 $1677
line 2373
;2373:		botSelectInfo.numpages++;
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
line 2374
;2374:	}
LABELV $1677
line 2377
;2375:
;2376:	// initialize the array
;2377:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1684
JUMPV
LABELV $1681
line 2378
;2378:		botSelectInfo.sortedBotNums[n] = n;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2379
;2379:	}
LABELV $1682
line 2377
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1684
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1681
line 2382
;2380:
;2381:	// now sort it
;2382:	qsort( botSelectInfo.sortedBotNums, botSelectInfo.numBots, sizeof(botSelectInfo.sortedBotNums[0]), UI_BotSelectMenu_SortCompare );
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
line 2383
;2383:}
LABELV $1672
endproc UI_BotSelectMenu_BuildList 12 16
proc ServerPlayerIcon 80 20
line 2391
;2384:
;2385:
;2386:/*
;2387:=================
;2388:ServerPlayerIcon
;2389:=================
;2390:*/
;2391:static void ServerPlayerIcon( const char *modelAndSkin, char *iconName, int iconNameMaxSize ) {
line 2395
;2392:	char	*skin;
;2393:	char	model[MAX_QPATH];
;2394:
;2395:	Q_strncpyz( model, modelAndSkin, sizeof(model));
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
line 2396
;2396:	skin = Q_strrchr( model, '/' );
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
line 2397
;2397:	if ( skin ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1691
line 2398
;2398:		*skin++ = '\0';
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
line 2399
;2399:	}
ADDRGP4 $1692
JUMPV
LABELV $1691
line 2400
;2400:	else {
line 2401
;2401:		skin = "default";
ADDRLP4 0
ADDRGP4 $1693
ASGNP4
line 2402
;2402:	}
LABELV $1692
line 2404
;2403:
;2404:	Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_%s.tga", model, skin );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1694
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2406
;2405:
;2406:	if( !trap_R_RegisterShaderNoMip( iconName ) && Q_stricmp( skin, "default" ) != 0 ) {
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
NEI4 $1695
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $1693
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $1695
line 2407
;2407:		Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_default.tga", model );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1697
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2408
;2408:	}
LABELV $1695
line 2409
;2409:}
LABELV $1690
endproc ServerPlayerIcon 80 20
proc UI_BotSelectMenu_UpdateGrid 36 12
line 2417
;2410:
;2411:
;2412:/*
;2413:=================
;2414:UI_BotSelectMenu_UpdateGrid
;2415:=================
;2416:*/
;2417:static void UI_BotSelectMenu_UpdateGrid( void ) {
line 2422
;2418:	const char	*info;
;2419:	int			i;
;2420:    int			j;
;2421:
;2422:	j = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRLP4 4
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2423
;2423:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++, j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1700
line 2424
;2424:		if( j < botSelectInfo.numBots ) { 
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
GEI4 $1704
line 2425
;2425:			info = UI_GetBotInfoByNumber( botSelectInfo.sortedBotNums[j] );
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
line 2426
;2426:			ServerPlayerIcon( Info_ValueForKey( info, "model" ), botSelectInfo.boticons[i], MAX_QPATH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $1708
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
line 2427
;2427:			Q_strncpyz( botSelectInfo.botnames[i], Info_ValueForKey( info, "name" ), 16 );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $820
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
line 2428
;2428:			Q_CleanStr( botSelectInfo.botnames[i] );
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
line 2429
;2429: 			botSelectInfo.pics[i].generic.name = botSelectInfo.boticons[i];
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
line 2430
;2430:			if( BotAlreadySelected( botSelectInfo.botnames[i] ) ) {
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
EQI4 $1715
line 2431
;2431:				botSelectInfo.picnames[i].color = color_red;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_red
ASGNP4
line 2432
;2432:			}
ADDRGP4 $1716
JUMPV
LABELV $1715
line 2433
;2433:			else {
line 2434
;2434:				botSelectInfo.picnames[i].color = color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2435
;2435:			}
LABELV $1716
line 2436
;2436:			botSelectInfo.picbuttons[i].generic.flags &= ~QMF_INACTIVE;
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
line 2437
;2437:		}
ADDRGP4 $1705
JUMPV
LABELV $1704
line 2438
;2438:		else {
line 2440
;2439:			// dead slot
;2440: 			botSelectInfo.pics[i].generic.name         = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
CNSTP4 0
ASGNP4
line 2441
;2441:			botSelectInfo.picbuttons[i].generic.flags |= QMF_INACTIVE;
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
line 2442
;2442:			botSelectInfo.botnames[i][0] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
CNSTI1 0
ASGNI1
line 2443
;2443:		}
LABELV $1705
line 2445
;2444:
;2445: 		botSelectInfo.pics[i].generic.flags       &= ~QMF_HIGHLIGHT;
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
line 2446
;2446: 		botSelectInfo.pics[i].shader               = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+68
ADDP4
CNSTI4 0
ASGNI4
line 2447
;2447: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2448
;2448:	}
LABELV $1701
line 2423
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
LTI4 $1700
line 2451
;2449:
;2450:	// set selected model
;2451:	i = botSelectInfo.selectedmodel % MAX_MODELSPERPAGE;
ADDRLP4 0
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
MODI4
ASGNI4
line 2452
;2452:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2453
;2453:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2455
;2454:
;2455:	if( botSelectInfo.numpages > 1 ) {
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
LEI4 $1740
line 2456
;2456:		if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1743
line 2457
;2457:			botSelectInfo.left.generic.flags &= ~QMF_INACTIVE;
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
line 2458
;2458:		}
ADDRGP4 $1744
JUMPV
LABELV $1743
line 2459
;2459:		else {
line 2460
;2460:			botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2461
;2461:		}
LABELV $1744
line 2463
;2462:
;2463:		if( botSelectInfo.modelpage < (botSelectInfo.numpages - 1) ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1750
line 2464
;2464:			botSelectInfo.right.generic.flags &= ~QMF_INACTIVE;
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
line 2465
;2465:		}
ADDRGP4 $1741
JUMPV
LABELV $1750
line 2466
;2466:		else {
line 2467
;2467:			botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2468
;2468:		}
line 2469
;2469:	}
ADDRGP4 $1741
JUMPV
LABELV $1740
line 2470
;2470:	else {
line 2472
;2471:		// hide left/right markers
;2472:		botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2473
;2473:		botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2474
;2474:	}
LABELV $1741
line 2475
;2475:}
LABELV $1698
endproc UI_BotSelectMenu_UpdateGrid 36 12
proc UI_BotSelectMenu_Default 28 8
line 2483
;2476:
;2477:
;2478:/*
;2479:=================
;2480:UI_BotSelectMenu_Default
;2481:=================
;2482:*/
;2483:static void UI_BotSelectMenu_Default( char *bot ) {
line 2489
;2484:	const char	*botInfo;
;2485:	const char	*test;
;2486:	int			n;
;2487:	int			i;
;2488:
;2489:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1766
JUMPV
LABELV $1763
line 2490
;2490:		botInfo = UI_GetBotInfoByNumber( n );
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
line 2491
;2491:		test = Info_ValueForKey( botInfo, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $820
ARGP4
ADDRLP4 20
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
line 2492
;2492:		if( Q_stricmp( bot, test ) == 0 ) {
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
NEI4 $1768
line 2493
;2493:			break;
ADDRGP4 $1765
JUMPV
LABELV $1768
line 2495
;2494:		}
;2495:	}
LABELV $1764
line 2489
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1766
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1763
LABELV $1765
line 2496
;2496:	if( n == botSelectInfo.numBots ) {
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1770
line 2497
;2497:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2498
;2498:		return;
ADDRGP4 $1762
JUMPV
LABELV $1770
line 2501
;2499:	}
;2500:
;2501:	for( i = 0; i < botSelectInfo.numBots; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1777
JUMPV
LABELV $1774
line 2502
;2502:		if( botSelectInfo.sortedBotNums[i] == n ) {
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1779
line 2503
;2503:			break;
ADDRGP4 $1776
JUMPV
LABELV $1779
line 2505
;2504:		}
;2505:	}
LABELV $1775
line 2501
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1777
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1774
LABELV $1776
line 2506
;2506:	if( i == botSelectInfo.numBots ) {
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1782
line 2507
;2507:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2508
;2508:		return;
ADDRGP4 $1762
JUMPV
LABELV $1782
line 2511
;2509:	}
;2510:
;2511:	botSelectInfo.selectedmodel = i;
ADDRGP4 botSelectInfo+4780
ADDRLP4 4
INDIRI4
ASGNI4
line 2512
;2512:}
LABELV $1762
endproc UI_BotSelectMenu_Default 28 8
proc UI_BotSelectMenu_LeftEvent 4 0
line 2520
;2513:
;2514:
;2515:/*
;2516:=================
;2517:UI_BotSelectMenu_LeftEvent
;2518:=================
;2519:*/
;2520:static void UI_BotSelectMenu_LeftEvent( void* ptr, int event ) {
line 2521
;2521:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1788
line 2522
;2522:		return;
ADDRGP4 $1787
JUMPV
LABELV $1788
line 2524
;2523:	}
;2524:	if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1790
line 2525
;2525:		botSelectInfo.modelpage--;
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
line 2526
;2526:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2527
;2527:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2528
;2528:	}
LABELV $1790
line 2529
;2529:}
LABELV $1787
endproc UI_BotSelectMenu_LeftEvent 4 0
proc UI_BotSelectMenu_RightEvent 4 0
line 2537
;2530:
;2531:
;2532:/*
;2533:=================
;2534:UI_BotSelectMenu_RightEvent
;2535:=================
;2536:*/
;2537:static void UI_BotSelectMenu_RightEvent( void* ptr, int event ) {
line 2538
;2538:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1797
line 2539
;2539:		return;
ADDRGP4 $1796
JUMPV
LABELV $1797
line 2541
;2540:	}
;2541:	if( botSelectInfo.modelpage < botSelectInfo.numpages - 1 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1799
line 2542
;2542:		botSelectInfo.modelpage++;
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
line 2543
;2543:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2544
;2544:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2545
;2545:	}
LABELV $1799
line 2546
;2546:}
LABELV $1796
endproc UI_BotSelectMenu_RightEvent 4 0
proc UI_BotSelectMenu_BotEvent 12 0
line 2554
;2547:
;2548:
;2549:/*
;2550:=================
;2551:UI_BotSelectMenu_BotEvent
;2552:=================
;2553:*/
;2554:static void UI_BotSelectMenu_BotEvent( void* ptr, int event ) {
line 2557
;2555:	int		i;
;2556:
;2557:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1807
line 2558
;2558:		return;
ADDRGP4 $1806
JUMPV
LABELV $1807
line 2561
;2559:	}
;2560:
;2561:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1809
line 2562
;2562: 		botSelectInfo.pics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 2563
;2563: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2564
;2564:	}
LABELV $1810
line 2561
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $1809
line 2567
;2565:
;2566:	// set selected
;2567:	i = ((menucommon_s*)ptr)->id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 2568
;2568:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2569
;2569:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2570
;2570:	botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE + i;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ADDRLP4 0
INDIRI4
ADDI4
ASGNI4
line 2571
;2571:}
LABELV $1806
endproc UI_BotSelectMenu_BotEvent 12 0
proc UI_BotSelectMenu_BackEvent 0 0
line 2579
;2572:
;2573:
;2574:/*
;2575:=================
;2576:UI_BotSelectMenu_BackEvent
;2577:=================
;2578:*/
;2579:static void UI_BotSelectMenu_BackEvent( void* ptr, int event ) {
line 2580
;2580:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1824
line 2581
;2581:		return;
ADDRGP4 $1823
JUMPV
LABELV $1824
line 2583
;2582:	}
;2583:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2584
;2584:}
LABELV $1823
endproc UI_BotSelectMenu_BackEvent 0 0
proc UI_BotSelectMenu_SelectEvent 4 12
line 2592
;2585:
;2586:
;2587:/*
;2588:=================
;2589:UI_BotSelectMenu_SelectEvent
;2590:=================
;2591:*/
;2592:static void UI_BotSelectMenu_SelectEvent( void* ptr, int event ) {
line 2593
;2593:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1827
line 2594
;2594:		return;
ADDRGP4 $1826
JUMPV
LABELV $1827
line 2596
;2595:	}
;2596:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2598
;2597:
;2598:	s_serveroptions.newBot = qtrue;
ADDRGP4 s_serveroptions+7024
CNSTI4 1
ASGNI4
line 2599
;2599:	Q_strncpyz( s_serveroptions.newBotName, botSelectInfo.botnames[botSelectInfo.selectedmodel % MAX_MODELSPERPAGE], 16 );
ADDRGP4 s_serveroptions+7032
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
line 2600
;2600:}
LABELV $1826
endproc UI_BotSelectMenu_SelectEvent 4 12
export UI_BotSelectMenu_Cache
proc UI_BotSelectMenu_Cache 0 4
line 2608
;2601:
;2602:
;2603:/*
;2604:=================
;2605:UI_BotSelectMenu_Cache
;2606:=================
;2607:*/
;2608:void UI_BotSelectMenu_Cache( void ) {
line 2609
;2609:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK0 );
ADDRGP4 $468
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2610
;2610:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK1 );
ADDRGP4 $485
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2611
;2611:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT0 );
ADDRGP4 $1834
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2612
;2612:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT1 );
ADDRGP4 $1835
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2613
;2613:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECT );
ADDRGP4 $1836
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2614
;2614:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECTED );
ADDRGP4 $1837
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2615
;2615:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWS );
ADDRGP4 $405
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2616
;2616:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSL );
ADDRGP4 $433
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2617
;2617:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSR );
ADDRGP4 $451
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2618
;2618:}
LABELV $1833
endproc UI_BotSelectMenu_Cache 0 4
proc UI_BotSelectMenu_Init 36 12
line 2621
;2619:
;2620:
;2621:static void UI_BotSelectMenu_Init( char *bot ) {
line 2625
;2622:	int		i, j, k;
;2623:	int		x, y;
;2624:
;2625:	memset( &botSelectInfo, 0 ,sizeof(botSelectInfo) );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 0
ARGI4
CNSTI4 10160
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2626
;2626:	botSelectInfo.menu.wrapAround = qtrue;
ADDRGP4 botSelectInfo+276
CNSTI4 1
ASGNI4
line 2627
;2627:	botSelectInfo.menu.fullscreen = qtrue;
ADDRGP4 botSelectInfo+280
CNSTI4 1
ASGNI4
line 2629
;2628:
;2629:	UI_BotSelectMenu_Cache();
ADDRGP4 UI_BotSelectMenu_Cache
CALLV
pop
line 2631
;2630:
;2631:	botSelectInfo.banner.generic.type	= MTYPE_BTEXT;
ADDRGP4 botSelectInfo+288
CNSTI4 10
ASGNI4
line 2632
;2632:	botSelectInfo.banner.generic.x		= 320;
ADDRGP4 botSelectInfo+288+12
CNSTI4 320
ASGNI4
line 2633
;2633:	botSelectInfo.banner.generic.y		= 16;
ADDRGP4 botSelectInfo+288+16
CNSTI4 16
ASGNI4
line 2634
;2634:	botSelectInfo.banner.string			= "SELECT BOT";
ADDRGP4 botSelectInfo+288+60
ADDRGP4 $1848
ASGNP4
line 2635
;2635:	botSelectInfo.banner.color			= color_white;
ADDRGP4 botSelectInfo+288+68
ADDRGP4 color_white
ASGNP4
line 2636
;2636:	botSelectInfo.banner.style			= UI_CENTER;
ADDRGP4 botSelectInfo+288+64
CNSTI4 1
ASGNI4
line 2638
;2637:
;2638:	y =	80;
ADDRLP4 8
CNSTI4 80
ASGNI4
line 2639
;2639:	for( i = 0, k = 0; i < PLAYERGRID_ROWS; i++) {
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
ADDRGP4 $1856
JUMPV
LABELV $1853
line 2640
;2640:		x =	180;
ADDRLP4 4
CNSTI4 180
ASGNI4
line 2641
;2641:		for( j = 0; j < PLAYERGRID_COLS; j++, k++ ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $1857
line 2642
;2642:			botSelectInfo.pics[k].generic.type				= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360
ADDP4
CNSTI4 6
ASGNI4
line 2643
;2643:			botSelectInfo.pics[k].generic.flags				= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
CNSTU4 16388
ASGNU4
line 2644
;2644:			botSelectInfo.pics[k].generic.x					= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2645
;2645:			botSelectInfo.pics[k].generic.y					= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2646
;2646: 			botSelectInfo.pics[k].generic.name				= botSelectInfo.boticons[k];
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
line 2647
;2647:			botSelectInfo.pics[k].width						= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+76
ADDP4
CNSTI4 64
ASGNI4
line 2648
;2648:			botSelectInfo.pics[k].height					= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+80
ADDP4
CNSTI4 64
ASGNI4
line 2649
;2649:			botSelectInfo.pics[k].focuspic					= BOTSELECT_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+60
ADDP4
ADDRGP4 $1837
ASGNP4
line 2650
;2650:			botSelectInfo.pics[k].focuscolor				= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2652
;2651:
;2652:			botSelectInfo.picbuttons[k].generic.type		= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768
ADDP4
CNSTI4 6
ASGNI4
line 2653
;2653:			botSelectInfo.picbuttons[k].generic.flags		= QMF_LEFT_JUSTIFY|QMF_NODEFAULTINIT|QMF_PULSEIFFOCUS;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
CNSTU4 33028
ASGNU4
line 2654
;2654:			botSelectInfo.picbuttons[k].generic.callback	= UI_BotSelectMenu_BotEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+48
ADDP4
ADDRGP4 UI_BotSelectMenu_BotEvent
ASGNP4
line 2655
;2655:			botSelectInfo.picbuttons[k].generic.id			= k;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2656
;2656:			botSelectInfo.picbuttons[k].generic.x			= x - 16;
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
line 2657
;2657:			botSelectInfo.picbuttons[k].generic.y			= y - 16;
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
line 2658
;2658:			botSelectInfo.picbuttons[k].generic.left		= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2659
;2659:			botSelectInfo.picbuttons[k].generic.top			= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2660
;2660:			botSelectInfo.picbuttons[k].generic.right		= x + 64;
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
line 2661
;2661:			botSelectInfo.picbuttons[k].generic.bottom		= y + 64;
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
line 2662
;2662:			botSelectInfo.picbuttons[k].width				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+76
ADDP4
CNSTI4 128
ASGNI4
line 2663
;2663:			botSelectInfo.picbuttons[k].height				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+80
ADDP4
CNSTI4 128
ASGNI4
line 2664
;2664:			botSelectInfo.picbuttons[k].focuspic			= BOTSELECT_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+60
ADDP4
ADDRGP4 $1836
ASGNP4
line 2665
;2665:			botSelectInfo.picbuttons[k].focuscolor			= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2667
;2666:
;2667:			botSelectInfo.picnames[k].generic.type			= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176
ADDP4
CNSTI4 7
ASGNI4
line 2668
;2668:			botSelectInfo.picnames[k].generic.flags			= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+44
ADDP4
CNSTU4 2
ASGNU4
line 2669
;2669:			botSelectInfo.picnames[k].generic.x				= x + 32;
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
line 2670
;2670:			botSelectInfo.picnames[k].generic.y				= y + 64;
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
line 2671
;2671:			botSelectInfo.picnames[k].string				= botSelectInfo.botnames[k];
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
line 2672
;2672:			botSelectInfo.picnames[k].color					= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2673
;2673:			botSelectInfo.picnames[k].style					= UI_CENTER|UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+64
ADDP4
CNSTI4 17
ASGNI4
line 2675
;2674:
;2675:			x += (64 + 6);
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 70
ADDI4
ASGNI4
line 2676
;2676:		}
LABELV $1858
line 2641
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
LTI4 $1857
line 2677
;2677:		y += (64 + SMALLCHAR_HEIGHT + 6);
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 86
ADDI4
ASGNI4
line 2678
;2678:	}
LABELV $1854
line 2639
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1856
ADDRLP4 16
INDIRI4
CNSTI4 4
LTI4 $1853
line 2680
;2679:
;2680:	botSelectInfo.arrows.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4328
CNSTI4 6
ASGNI4
line 2681
;2681:	botSelectInfo.arrows.generic.name		= BOTSELECT_ARROWS;
ADDRGP4 botSelectInfo+4328+4
ADDRGP4 $405
ASGNP4
line 2682
;2682:	botSelectInfo.arrows.generic.flags		= QMF_INACTIVE;
ADDRGP4 botSelectInfo+4328+44
CNSTU4 16384
ASGNU4
line 2683
;2683:	botSelectInfo.arrows.generic.x			= 260;
ADDRGP4 botSelectInfo+4328+12
CNSTI4 260
ASGNI4
line 2684
;2684:	botSelectInfo.arrows.generic.y			= 440;
ADDRGP4 botSelectInfo+4328+16
CNSTI4 440
ASGNI4
line 2685
;2685:	botSelectInfo.arrows.width				= 128;
ADDRGP4 botSelectInfo+4328+76
CNSTI4 128
ASGNI4
line 2686
;2686:	botSelectInfo.arrows.height				= 32;
ADDRGP4 botSelectInfo+4328+80
CNSTI4 32
ASGNI4
line 2688
;2687:
;2688:	botSelectInfo.left.generic.type			= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4416
CNSTI4 6
ASGNI4
line 2689
;2689:	botSelectInfo.left.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4416+44
CNSTU4 260
ASGNU4
line 2690
;2690:	botSelectInfo.left.generic.callback		= UI_BotSelectMenu_LeftEvent;
ADDRGP4 botSelectInfo+4416+48
ADDRGP4 UI_BotSelectMenu_LeftEvent
ASGNP4
line 2691
;2691:	botSelectInfo.left.generic.x			= 260;
ADDRGP4 botSelectInfo+4416+12
CNSTI4 260
ASGNI4
line 2692
;2692:	botSelectInfo.left.generic.y			= 440;
ADDRGP4 botSelectInfo+4416+16
CNSTI4 440
ASGNI4
line 2693
;2693:	botSelectInfo.left.width  				= 64;
ADDRGP4 botSelectInfo+4416+76
CNSTI4 64
ASGNI4
line 2694
;2694:	botSelectInfo.left.height  				= 32;
ADDRGP4 botSelectInfo+4416+80
CNSTI4 32
ASGNI4
line 2695
;2695:	botSelectInfo.left.focuspic				= BOTSELECT_ARROWSL;
ADDRGP4 botSelectInfo+4416+60
ADDRGP4 $433
ASGNP4
line 2697
;2696:
;2697:	botSelectInfo.right.generic.type	    = MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4504
CNSTI4 6
ASGNI4
line 2698
;2698:	botSelectInfo.right.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4504+44
CNSTU4 260
ASGNU4
line 2699
;2699:	botSelectInfo.right.generic.callback	= UI_BotSelectMenu_RightEvent;
ADDRGP4 botSelectInfo+4504+48
ADDRGP4 UI_BotSelectMenu_RightEvent
ASGNP4
line 2700
;2700:	botSelectInfo.right.generic.x			= 321;
ADDRGP4 botSelectInfo+4504+12
CNSTI4 321
ASGNI4
line 2701
;2701:	botSelectInfo.right.generic.y			= 440;
ADDRGP4 botSelectInfo+4504+16
CNSTI4 440
ASGNI4
line 2702
;2702:	botSelectInfo.right.width  				= 64;
ADDRGP4 botSelectInfo+4504+76
CNSTI4 64
ASGNI4
line 2703
;2703:	botSelectInfo.right.height  		    = 32;
ADDRGP4 botSelectInfo+4504+80
CNSTI4 32
ASGNI4
line 2704
;2704:	botSelectInfo.right.focuspic			= BOTSELECT_ARROWSR;
ADDRGP4 botSelectInfo+4504+60
ADDRGP4 $451
ASGNP4
line 2706
;2705:
;2706:	botSelectInfo.back.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4680
CNSTI4 6
ASGNI4
line 2707
;2707:	botSelectInfo.back.generic.name		= BOTSELECT_BACK0;
ADDRGP4 botSelectInfo+4680+4
ADDRGP4 $468
ASGNP4
line 2708
;2708:	botSelectInfo.back.generic.flags	= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4680+44
CNSTU4 260
ASGNU4
line 2709
;2709:	botSelectInfo.back.generic.callback	= UI_BotSelectMenu_BackEvent;
ADDRGP4 botSelectInfo+4680+48
ADDRGP4 UI_BotSelectMenu_BackEvent
ASGNP4
line 2710
;2710:	botSelectInfo.back.generic.x		= 0;
ADDRGP4 botSelectInfo+4680+12
CNSTI4 0
ASGNI4
line 2711
;2711:	botSelectInfo.back.generic.y		= 480-64;
ADDRGP4 botSelectInfo+4680+16
CNSTI4 416
ASGNI4
line 2712
;2712:	botSelectInfo.back.width			= 128;
ADDRGP4 botSelectInfo+4680+76
CNSTI4 128
ASGNI4
line 2713
;2713:	botSelectInfo.back.height			= 64;
ADDRGP4 botSelectInfo+4680+80
CNSTI4 64
ASGNI4
line 2714
;2714:	botSelectInfo.back.focuspic			= BOTSELECT_BACK1;
ADDRGP4 botSelectInfo+4680+60
ADDRGP4 $485
ASGNP4
line 2716
;2715:
;2716:	botSelectInfo.go.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4592
CNSTI4 6
ASGNI4
line 2717
;2717:	botSelectInfo.go.generic.name		= BOTSELECT_ACCEPT0;
ADDRGP4 botSelectInfo+4592+4
ADDRGP4 $1834
ASGNP4
line 2718
;2718:	botSelectInfo.go.generic.flags		= QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4592+44
CNSTU4 272
ASGNU4
line 2719
;2719:	botSelectInfo.go.generic.callback	= UI_BotSelectMenu_SelectEvent;
ADDRGP4 botSelectInfo+4592+48
ADDRGP4 UI_BotSelectMenu_SelectEvent
ASGNP4
line 2720
;2720:	botSelectInfo.go.generic.x			= 640;
ADDRGP4 botSelectInfo+4592+12
CNSTI4 640
ASGNI4
line 2721
;2721:	botSelectInfo.go.generic.y			= 480-64;
ADDRGP4 botSelectInfo+4592+16
CNSTI4 416
ASGNI4
line 2722
;2722:	botSelectInfo.go.width				= 128;
ADDRGP4 botSelectInfo+4592+76
CNSTI4 128
ASGNI4
line 2723
;2723:	botSelectInfo.go.height				= 64;
ADDRGP4 botSelectInfo+4592+80
CNSTI4 64
ASGNI4
line 2724
;2724:	botSelectInfo.go.focuspic			= BOTSELECT_ACCEPT1;
ADDRGP4 botSelectInfo+4592+60
ADDRGP4 $1835
ASGNP4
line 2726
;2725:
;2726:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.banner );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2727
;2727:	for( i = 0; i < MAX_MODELSPERPAGE; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1998
line 2728
;2728:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.pics[i] );
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
line 2729
;2729:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picbuttons[i] );
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
line 2730
;2730:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picnames[i] );
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
line 2731
;2731:	}
LABELV $1999
line 2727
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 16
LTI4 $1998
line 2732
;2732:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.arrows );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4328
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2733
;2733:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.left );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4416
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2734
;2734:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.right );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4504
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2735
;2735:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.back );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4680
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2736
;2736:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.go );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4592
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2738
;2737:
;2738:	UI_BotSelectMenu_BuildList();
ADDRGP4 UI_BotSelectMenu_BuildList
CALLV
pop
line 2739
;2739:	UI_BotSelectMenu_Default( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Default
CALLV
pop
line 2740
;2740:	botSelectInfo.modelpage = botSelectInfo.selectedmodel / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4772
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2741
;2741:	UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2742
;2742:}
LABELV $1838
endproc UI_BotSelectMenu_Init 36 12
export UI_BotSelectMenu
proc UI_BotSelectMenu 0 4
line 2750
;2743:
;2744:
;2745:/*
;2746:=================
;2747:UI_BotSelectMenu
;2748:=================
;2749:*/
;2750:void UI_BotSelectMenu( char *bot ) {
line 2751
;2751:	UI_BotSelectMenu_Init( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Init
CALLV
pop
line 2752
;2752:	UI_PushMenu( &botSelectInfo.menu );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2753
;2753:}
LABELV $2012
endproc UI_BotSelectMenu 0 4
bss
align 4
LABELV botSelectInfo
skip 10160
align 4
LABELV s_serveroptions
skip 7144
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
LABELV $1848
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
LABELV $1837
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
LABELV $1836
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
LABELV $1835
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
LABELV $1834
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
LABELV $1708
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $1697
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
LABELV $1694
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
LABELV $1693
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $1607
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
LABELV $1590
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
LABELV $1540
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
LABELV $1530
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
LABELV $1520
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
LABELV $1510
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
LABELV $1500
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
LABELV $1490
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
LABELV $1480
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
LABELV $1470
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
LABELV $1460
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
LABELV $1442
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
LABELV $1355
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
LABELV $1339
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
LABELV $1323
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
LABELV $1314
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
LABELV $1297
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
LABELV $1287
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
LABELV $1260
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
LABELV $1242
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
LABELV $1224
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
LABELV $1209
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
LABELV $1197
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
LABELV $1079
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1044
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
LABELV $1038
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
LABELV $1032
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
LABELV $1026
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
LABELV $1023
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
LABELV $1020
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
LABELV $999
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
LABELV $975
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $955
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $943
byte 1 118
byte 1 105
byte 1 115
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $937
byte 1 109
byte 1 97
byte 1 106
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $934
byte 1 103
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $924
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
LABELV $912
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
LABELV $852
byte 1 72
byte 1 117
byte 1 109
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $820
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $789
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
LABELV $784
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
LABELV $780
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
LABELV $762
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 32
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $759
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
LABELV $758
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
LABELV $757
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $752
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
LABELV $749
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
LABELV $746
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
LABELV $741
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
LABELV $738
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
LABELV $735
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
LABELV $732
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
LABELV $729
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
LABELV $726
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
LABELV $723
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
LABELV $720
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
LABELV $717
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
LABELV $714
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
LABELV $710
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
LABELV $709
byte 1 115
byte 1 118
byte 1 95
byte 1 112
byte 1 117
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $708
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
LABELV $707
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
LABELV $706
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
LABELV $705
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
LABELV $704
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
LABELV $702
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
LABELV $701
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
LABELV $700
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
LABELV $698
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
LABELV $697
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
LABELV $696
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
LABELV $693
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
LABELV $691
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
LABELV $690
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
LABELV $683
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
LABELV $678
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
LABELV $675
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
LABELV $672
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
LABELV $669
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
LABELV $666
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
LABELV $663
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
LABELV $660
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
LABELV $657
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
LABELV $656
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
LABELV $620
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
LABELV $617
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
LABELV $614
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
LABELV $613
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
LABELV $588
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
LABELV $587
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
LABELV $586
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
LABELV $585
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
LABELV $584
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
LABELV $583
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
LABELV $582
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
LABELV $581
byte 1 68
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
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
