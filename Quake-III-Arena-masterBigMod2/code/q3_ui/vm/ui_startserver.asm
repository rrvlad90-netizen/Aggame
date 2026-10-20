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
byte 4 0
align 4
LABELV gametype_remap
byte 4 0
byte 4 3
byte 4 3
byte 4 3
byte 4 3
byte 4 3
byte 4 1
byte 4 4
align 4
LABELV gametype_remap2
byte 4 0
byte 4 6
byte 4 0
byte 4 1
byte 4 7
code
proc GametypeBits 36 8
file "../ui_startserver.c"
line 138
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
;103:	"Tournament",
;104:	"Capture the Flag",
;105:	0
;106:};
;107:
;108:static int gametype_remap[] = {
;109:	GT_FFA,
;110:	GT_TEAM,
;111:	GT_TEAM,
;112:	GT_TEAM,
;113:	GT_TEAM,
;114:	GT_TEAM,
;115:	GT_TOURNAMENT,
;116:	GT_CTF
;117:};
;118:
;119:static int gametype_remap2[] = {
;120:	0,
;121:	6,
;122:	0,
;123:	1,
;124:	7
;125:};
;126:
;127:// use ui_servers2.c definition
;128:extern const char* punkbuster_items[];
;129:
;130:static void UI_ServerOptionsMenu( qboolean multiplayer );
;131:
;132:
;133:/*
;134:=================
;135:GametypeBits
;136:=================
;137:*/
;138:static int GametypeBits( char *string ) {
line 143
;139:	int		bits;
;140:	char	*p;
;141:	char	*token;
;142:
;143:	bits = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 144
;144:	p = string;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $78
JUMPV
LABELV $77
line 145
;145:	while( 1 ) {
line 146
;146:		token = COM_ParseExt( &p, qfalse );
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
line 147
;147:		if( token[0] == 0 ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $80
line 148
;148:			break;
ADDRGP4 $79
JUMPV
LABELV $80
line 151
;149:		}
;150:
;151:		if( Q_stricmp( token, "ffa" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $84
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $82
line 152
;152:			bits |= 1 << GT_FFA;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 153
;153:			continue;
ADDRGP4 $78
JUMPV
LABELV $82
line 156
;154:		}
;155:
;156:		if( Q_stricmp( token, "tourney" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $87
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $85
line 157
;157:			bits |= 1 << GT_TOURNAMENT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
line 158
;158:			continue;
ADDRGP4 $78
JUMPV
LABELV $85
line 161
;159:		}
;160:
;161:		if( Q_stricmp( token, "single" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $90
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $88
line 162
;162:			bits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 163
;163:			continue;
ADDRGP4 $78
JUMPV
LABELV $88
line 166
;164:		}
;165:
;166:		if( Q_stricmp( token, "team" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $93
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $91
line 167
;167:			bits |= 1 << GT_TEAM;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
line 168
;168:			continue;
ADDRGP4 $78
JUMPV
LABELV $91
line 171
;169:		}
;170:
;171:		if( Q_stricmp( token, "ctf" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $96
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $94
line 172
;172:			bits |= 1 << GT_CTF;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 173
;173:			continue;
LABELV $94
line 175
;174:		}
;175:	}
LABELV $78
line 145
ADDRGP4 $77
JUMPV
LABELV $79
line 177
;176:
;177:	return bits;
ADDRLP4 4
INDIRI4
RETI4
LABELV $76
endproc GametypeBits 36 8
bss
align 1
LABELV $98
skip 256
code
proc StartServer_Update 28 16
line 186
;178:}
;179:
;180:
;181:/*
;182:=================
;183:StartServer_Update
;184:=================
;185:*/
;186:static void StartServer_Update( void ) {
line 191
;187:	int				i;
;188:	int				top;
;189:	static	char	picname[MAX_MAPSPERPAGE][64];
;190:
;191:	top = s_startserver.page*MAX_MAPSPERPAGE;
ADDRLP4 4
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
line 193
;192:
;193:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $100
line 194
;194:	{
line 195
;195:		if (top+i >= s_startserver.nummaps)
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
ADDI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $104
line 196
;196:			break;
ADDRGP4 $122
JUMPV
LABELV $104
line 198
;197:
;198:		Com_sprintf( picname[i], sizeof(picname[i]), "levelshots/%s", s_startserver.maplist[top+i] );
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 $98
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $107
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
line 200
;199:
;200:		s_startserver.mappics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 201
;201:		s_startserver.mappics[i].generic.name   = picname[i];
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
ADDRGP4 $98
ADDP4
ASGNP4
line 202
;202:		s_startserver.mappics[i].shader         = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+68
ADDP4
CNSTI4 0
ASGNI4
line 205
;203:
;204:		// reset
;205:		s_startserver.mapbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 206
;206:		s_startserver.mapbuttons[i].generic.flags &= ~QMF_INACTIVE;
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
line 207
;207:	}
LABELV $101
line 193
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $100
line 209
;208:
;209:	for (; i<MAX_MAPSPERPAGE; i++)
ADDRGP4 $122
JUMPV
LABELV $119
line 210
;210:	{
line 211
;211:		s_startserver.mappics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 212
;212:		s_startserver.mappics[i].generic.name   = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+4
ADDP4
CNSTP4 0
ASGNP4
line 213
;213:		s_startserver.mappics[i].shader         = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+68
ADDP4
CNSTI4 0
ASGNI4
line 216
;214:
;215:		// disable
;216:		s_startserver.mapbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 217
;217:		s_startserver.mapbuttons[i].generic.flags |= QMF_INACTIVE;
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
line 218
;218:	}
LABELV $120
line 209
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $122
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $119
line 222
;219:
;220:
;221:	// no servers to start
;222:	if( !s_startserver.nummaps ) {
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 0
NEI4 $133
line 223
;223:		s_startserver.next.generic.flags |= QMF_INACTIVE;
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
line 226
;224:
;225:		// set the map name
;226:		strcpy( s_startserver.mapname.string, "NO MAPS FOUND" );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 $140
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 227
;227:	}
ADDRGP4 $134
JUMPV
LABELV $133
line 228
;228:	else {
line 230
;229:		// set the highlight
;230:		s_startserver.next.generic.flags &= ~QMF_INACTIVE;
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
line 231
;231:		i = s_startserver.currentmap - top;
ADDRLP4 0
ADDRGP4 s_startserver+1940
INDIRI4
ADDRLP4 4
INDIRI4
SUBI4
ASGNI4
line 232
;232:		if ( i >=0 && i < MAX_MAPSPERPAGE ) 
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $144
ADDRLP4 0
INDIRI4
CNSTI4 4
GEI4 $144
line 233
;233:		{
line 234
;234:			s_startserver.mappics[i].generic.flags    |= QMF_HIGHLIGHT;
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
line 235
;235:			s_startserver.mapbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 236
;236:		}
LABELV $144
line 239
;237:
;238:		// set the map name
;239:		strcpy( s_startserver.mapname.string, s_startserver.maplist[s_startserver.currentmap] );
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
line 240
;240:	}
LABELV $134
line 242
;241:	
;242:	Q_strupr( s_startserver.mapname.string );
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 243
;243:}
LABELV $97
endproc StartServer_Update 28 16
proc StartServer_MapEvent 0 0
line 251
;244:
;245:
;246:/*
;247:=================
;248:StartServer_MapEvent
;249:=================
;250:*/
;251:static void StartServer_MapEvent( void* ptr, int event ) {
line 252
;252:	if( event != QM_ACTIVATED) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $157
line 253
;253:		return;
ADDRGP4 $156
JUMPV
LABELV $157
line 256
;254:	}
;255:
;256:	s_startserver.currentmap = (s_startserver.page*MAX_MAPSPERPAGE) + (((menucommon_s*)ptr)->id - ID_PICTURES);
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
line 257
;257:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 258
;258:}
LABELV $156
endproc StartServer_MapEvent 0 0
proc StartServer_GametypeEvent 44 12
line 266
;259:
;260:
;261:/*
;262:=================
;263:StartServer_GametypeEvent
;264:=================
;265:*/
;266:static void StartServer_GametypeEvent( void* ptr, int event ) {
line 273
;267:	int			i;
;268:	int			count;
;269:	int			gamebits;
;270:	int			matchbits;
;271:	const char	*info;
;272:
;273:	if( event != QM_ACTIVATED) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $162
line 274
;274:		return;
ADDRGP4 $161
JUMPV
LABELV $162
line 277
;275:	}
;276:
;277:	count = UI_GetNumArenas();
ADDRLP4 20
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
line 278
;278:	s_startserver.nummaps = 0;
ADDRGP4 s_startserver+1944
CNSTI4 0
ASGNI4
line 279
;279:	if( s_startserver.gametype.curvalue == 2 ||
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
EQI4 $171
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
NEI4 $165
LABELV $171
line 280
;280:	s_startserver.gametype.curvalue == 5 ) {
line 284
;281:			/*
;282:			 * TDM on CTF Maps shows CTF maps but launches GT_TEAM.
;283:			 */
;284:			matchbits = 1 << GT_CTF;
ADDRLP4 12
CNSTI4 16
ASGNI4
line 285
;285:		}
ADDRGP4 $166
JUMPV
LABELV $165
line 286
;286:		else {
line 287
;287:			matchbits =
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
line 290
;288:				1 << gametype_remap[s_startserver.gametype.curvalue];
;289:
;290:			if( gametype_remap[s_startserver.gametype.curvalue] ==
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
CNSTI4 0
NEI4 $174
line 291
;291:				GT_FFA ) {
line 292
;292:				matchbits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 293
;293:			}
LABELV $174
line 294
;294:		}
LABELV $166
line 295
;295:	for( i = 0; i < count; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $181
JUMPV
LABELV $178
line 296
;296:		info = UI_GetArenaInfoByNumber( i );
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
line 298
;297:
;298:		gamebits = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $182
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
line 299
;299:		if( !( gamebits & matchbits ) ) {
ADDRLP4 4
INDIRI4
ADDRLP4 12
INDIRI4
BANDI4
CNSTI4 0
NEI4 $183
line 300
;300:			continue;
ADDRGP4 $179
JUMPV
LABELV $183
line 303
;301:		}
;302:
;303:		Q_strncpyz( s_startserver.maplist[s_startserver.nummaps], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $187
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
line 304
;304:		Q_strupr( s_startserver.maplist[s_startserver.nummaps] );
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
line 305
;305:		s_startserver.mapGamebits[s_startserver.nummaps] = gamebits;
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_startserver+2980
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 306
;306:		s_startserver.nummaps++;
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
line 307
;307:	}
LABELV $179
line 295
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $181
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $178
line 308
;308:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
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
line 309
;309:	s_startserver.page = 0;
ADDRGP4 s_startserver+1948
CNSTI4 0
ASGNI4
line 310
;310:	s_startserver.currentmap = 0;
ADDRGP4 s_startserver+1940
CNSTI4 0
ASGNI4
line 312
;311:
;312:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 313
;313:}
LABELV $161
endproc StartServer_GametypeEvent 44 12
proc StartServer_MenuEvent 16 8
line 321
;314:
;315:
;316:/*
;317:=================
;318:StartServer_MenuEvent
;319:=================
;320:*/
;321:static void StartServer_MenuEvent( void* ptr, int event ) {
line 322
;322:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $198
line 323
;323:		return;
ADDRGP4 $197
JUMPV
LABELV $198
line 326
;324:	}
;325:
;326:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $200
ADDRLP4 0
INDIRI4
CNSTI4 18
GTI4 $200
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $235-60
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $235
address $203
address $208
address $234
address $214
code
LABELV $203
line 328
;327:	case ID_PREVPAGE:
;328:		if( s_startserver.page > 0 ) {
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 0
LEI4 $201
line 329
;329:			s_startserver.page--;
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
line 330
;330:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 331
;331:		}
line 332
;332:		break;
ADDRGP4 $201
JUMPV
LABELV $208
line 335
;333:
;334:	case ID_NEXTPAGE:
;335:		if( s_startserver.page < s_startserver.maxpages - 1 ) {
ADDRGP4 s_startserver+1948
INDIRI4
ADDRGP4 s_startserver+1952
INDIRI4
CNSTI4 1
SUBI4
GEI4 $201
line 336
;336:			s_startserver.page++;
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
line 337
;337:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 338
;338:		}
line 339
;339:		break;
ADDRGP4 $201
JUMPV
LABELV $214
line 342
;340:
;341:	case ID_STARTSERVERNEXT:
;342:		trap_Cvar_SetValue(
ADDRGP4 $215
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
line 349
;343:			"g_gameType",
;344:			gametype_remap[
;345:				s_startserver.gametype.curvalue
;346:			]
;347:		);
;348:
;349:		trap_Cvar_SetValue(
ADDRGP4 $218
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 3
NEI4 $222
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $223
JUMPV
LABELV $222
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $223
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 354
;350:			"g_baseTDM",
;351:			s_startserver.gametype.curvalue == 3
;352:		);
;353:
;354:		trap_Cvar_SetValue(
ADDRGP4 $224
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 4
EQI4 $232
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
NEI4 $230
LABELV $232
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRGP4 $231
JUMPV
LABELV $230
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $231
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 360
;355:			"g_oneLifeTDM",
;356:			s_startserver.gametype.curvalue == 4 ||
;357:			s_startserver.gametype.curvalue == 5
;358:		);
;359:
;360:		UI_ServerOptionsMenu(
ADDRGP4 s_startserver+1936
INDIRI4
ARGI4
ADDRGP4 UI_ServerOptionsMenu
CALLV
pop
line 363
;361:			s_startserver.multiplayer
;362:		);
;363:		break;
ADDRGP4 $201
JUMPV
LABELV $234
line 366
;364:
;365:	case ID_STARTSERVERBACK:
;366:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 367
;367:		break;
LABELV $200
LABELV $201
line 369
;368:	}
;369:}
LABELV $197
endproc StartServer_MenuEvent 16 8
proc StartServer_LevelshotDraw 48 20
line 377
;370:
;371:
;372:/*
;373:===============
;374:StartServer_LevelshotDraw
;375:===============
;376:*/
;377:static void StartServer_LevelshotDraw( void *self ) {
line 385
;378:	menubitmap_s	*b;
;379:	int				x;
;380:	int				y;
;381:	int				w;
;382:	int				h;
;383:	int				n;
;384:
;385:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 387
;386:
;387:	if( !b->generic.name ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $238
line 388
;388:		return;
ADDRGP4 $237
JUMPV
LABELV $238
line 391
;389:	}
;390:
;391:	if( b->generic.name && !b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $240
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $240
line 392
;392:		b->shader = trap_R_RegisterShaderNoMip( b->generic.name );
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
line 393
;393:		if( !b->shader && b->errorpic ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $242
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $242
line 394
;394:			b->shader = trap_R_RegisterShaderNoMip( b->errorpic );
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
line 395
;395:		}
LABELV $242
line 396
;396:	}
LABELV $240
line 398
;397:
;398:	if( b->focuspic && !b->focusshader ) {
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $244
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
NEI4 $244
line 399
;399:		b->focusshader = trap_R_RegisterShaderNoMip( b->focuspic );
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
line 400
;400:	}
LABELV $244
line 402
;401:
;402:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 403
;403:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 404
;404:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 405
;405:	h =	b->height;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 406
;406:	if( b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $246
line 407
;407:		UI_DrawHandlePic( x, y, w, h, b->shader );
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
line 408
;408:	}
LABELV $246
line 410
;409:
;410:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 411
;411:	y = b->generic.y + b->height;
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
line 412
;412:	UI_FillRect( x, y, b->width, 28, colorBlack );
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
line 414
;413:
;414:	x += b->width / 2;
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
line 415
;415:	y += 4;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 416
;416:	n = s_startserver.page * MAX_MAPSPERPAGE + b->generic.id - ID_PICTURES;
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
line 417
;417:	UI_DrawString( x, y, s_startserver.maplist[n], UI_CENTER|UI_SMALLFONT, color_orange );
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
line 419
;418:
;419:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 420
;420:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 421
;421:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 422
;422:	h =	b->height + 28;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
line 423
;423:	if( b->generic.flags & QMF_HIGHLIGHT ) {	
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 64
BANDU4
CNSTU4 0
EQU4 $250
line 424
;424:		UI_DrawHandlePic( x, y, w, h, b->focusshader );
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
line 425
;425:	}
LABELV $250
line 426
;426:}
LABELV $237
endproc StartServer_LevelshotDraw 48 20
bss
align 1
LABELV $253
skip 64
code
proc StartServer_MenuInit 20 12
line 434
;427:
;428:
;429:/*
;430:=================
;431:StartServer_MenuInit
;432:=================
;433:*/
;434:static void StartServer_MenuInit( void ) {
line 441
;435:	int	i;
;436:	int	x;
;437:	int	y;
;438:	static char mapnamebuffer[64];
;439:
;440:	// zero set all our globals
;441:	memset( &s_startserver, 0 ,sizeof(startserver_t) );
ADDRGP4 s_startserver
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3236
ARGI4
ADDRGP4 memset
CALLP4
pop
line 443
;442:
;443:	StartServer_Cache();
ADDRGP4 StartServer_Cache
CALLV
pop
line 445
;444:
;445:	s_startserver.menu.wrapAround = qtrue;
ADDRGP4 s_startserver+276
CNSTI4 1
ASGNI4
line 446
;446:	s_startserver.menu.fullscreen = qtrue;
ADDRGP4 s_startserver+280
CNSTI4 1
ASGNI4
line 448
;447:
;448:	s_startserver.banner.generic.type  = MTYPE_BTEXT;
ADDRGP4 s_startserver+288
CNSTI4 10
ASGNI4
line 449
;449:	s_startserver.banner.generic.x	   = 320;
ADDRGP4 s_startserver+288+12
CNSTI4 320
ASGNI4
line 450
;450:	s_startserver.banner.generic.y	   = 16;
ADDRGP4 s_startserver+288+16
CNSTI4 16
ASGNI4
line 451
;451:	s_startserver.banner.string        = "GAME SERVER";
ADDRGP4 s_startserver+288+60
ADDRGP4 $263
ASGNP4
line 452
;452:	s_startserver.banner.color         = color_white;
ADDRGP4 s_startserver+288+68
ADDRGP4 color_white
ASGNP4
line 453
;453:	s_startserver.banner.style         = UI_CENTER;
ADDRGP4 s_startserver+288+64
CNSTI4 1
ASGNI4
line 455
;454:
;455:	s_startserver.framel.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+360
CNSTI4 6
ASGNI4
line 456
;456:	s_startserver.framel.generic.name  = GAMESERVER_FRAMEL;
ADDRGP4 s_startserver+360+4
ADDRGP4 $271
ASGNP4
line 457
;457:	s_startserver.framel.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+360+44
CNSTU4 16384
ASGNU4
line 458
;458:	s_startserver.framel.generic.x	   = 0;  
ADDRGP4 s_startserver+360+12
CNSTI4 0
ASGNI4
line 459
;459:	s_startserver.framel.generic.y	   = 78;
ADDRGP4 s_startserver+360+16
CNSTI4 78
ASGNI4
line 460
;460:	s_startserver.framel.width  	   = 256;
ADDRGP4 s_startserver+360+76
CNSTI4 256
ASGNI4
line 461
;461:	s_startserver.framel.height  	   = 329;
ADDRGP4 s_startserver+360+80
CNSTI4 329
ASGNI4
line 463
;462:
;463:	s_startserver.framer.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+448
CNSTI4 6
ASGNI4
line 464
;464:	s_startserver.framer.generic.name  = GAMESERVER_FRAMER;
ADDRGP4 s_startserver+448+4
ADDRGP4 $285
ASGNP4
line 465
;465:	s_startserver.framer.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+448+44
CNSTU4 16384
ASGNU4
line 466
;466:	s_startserver.framer.generic.x	   = 376;
ADDRGP4 s_startserver+448+12
CNSTI4 376
ASGNI4
line 467
;467:	s_startserver.framer.generic.y	   = 76;
ADDRGP4 s_startserver+448+16
CNSTI4 76
ASGNI4
line 468
;468:	s_startserver.framer.width  	   = 256;
ADDRGP4 s_startserver+448+76
CNSTI4 256
ASGNI4
line 469
;469:	s_startserver.framer.height  	   = 334;
ADDRGP4 s_startserver+448+80
CNSTI4 334
ASGNI4
line 471
;470:
;471:	s_startserver.gametype.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_startserver+536
CNSTI4 3
ASGNI4
line 472
;472:	s_startserver.gametype.generic.name		= "Game Type:";
ADDRGP4 s_startserver+536+4
ADDRGP4 $299
ASGNP4
line 473
;473:	s_startserver.gametype.generic.flags	= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_startserver+536+44
CNSTU4 258
ASGNU4
line 474
;474:	s_startserver.gametype.generic.callback	= StartServer_GametypeEvent;
ADDRGP4 s_startserver+536+48
ADDRGP4 StartServer_GametypeEvent
ASGNP4
line 475
;475:	s_startserver.gametype.generic.id		= ID_GAMETYPE;
ADDRGP4 s_startserver+536+8
CNSTI4 10
ASGNI4
line 476
;476:	s_startserver.gametype.generic.x		= 320 - 24;
ADDRGP4 s_startserver+536+12
CNSTI4 296
ASGNI4
line 477
;477:	s_startserver.gametype.generic.y		= 368;
ADDRGP4 s_startserver+536+16
CNSTI4 368
ASGNI4
line 478
;478:	s_startserver.gametype.itemnames		= gametype_items;
ADDRGP4 s_startserver+536+76
ADDRGP4 gametype_items
ASGNP4
line 480
;479:
;480:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $312
line 481
;481:	{
line 482
;482:		x =	(i % MAX_MAPCOLS) * (128+8) + 188;
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
line 483
;483:		y = (i / MAX_MAPROWS) * (128+8) + 96;
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
line 485
;484:
;485:		s_startserver.mappics[i].generic.type   = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632
ADDP4
CNSTI4 6
ASGNI4
line 486
;486:		s_startserver.mappics[i].generic.flags  = QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
CNSTU4 16388
ASGNU4
line 487
;487:		s_startserver.mappics[i].generic.x	    = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 488
;488:		s_startserver.mappics[i].generic.y	    = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 489
;489:		s_startserver.mappics[i].generic.id		= ID_PICTURES+i;
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
line 490
;490:		s_startserver.mappics[i].width  		= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+76
ADDP4
CNSTI4 128
ASGNI4
line 491
;491:		s_startserver.mappics[i].height  	    = 96;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+80
ADDP4
CNSTI4 96
ASGNI4
line 492
;492:		s_startserver.mappics[i].focuspic       = GAMESERVER_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+60
ADDP4
ADDRGP4 $331
ASGNP4
line 493
;493:		s_startserver.mappics[i].errorpic       = GAMESERVER_UNKNOWNMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+64
ADDP4
ADDRGP4 $334
ASGNP4
line 494
;494:		s_startserver.mappics[i].generic.ownerdraw = StartServer_LevelshotDraw;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+56
ADDP4
ADDRGP4 StartServer_LevelshotDraw
ASGNP4
line 496
;495:
;496:		s_startserver.mapbuttons[i].generic.type     = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984
ADDP4
CNSTI4 6
ASGNI4
line 497
;497:		s_startserver.mapbuttons[i].generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_NODEFAULTINIT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
CNSTU4 33028
ASGNU4
line 498
;498:		s_startserver.mapbuttons[i].generic.id       = ID_PICTURES+i;
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
line 499
;499:		s_startserver.mapbuttons[i].generic.callback = StartServer_MapEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+48
ADDP4
ADDRGP4 StartServer_MapEvent
ASGNP4
line 500
;500:		s_startserver.mapbuttons[i].generic.x	     = x - 30;
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
line 501
;501:		s_startserver.mapbuttons[i].generic.y	     = y - 32;
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
line 502
;502:		s_startserver.mapbuttons[i].width  		     = 256;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+76
ADDP4
CNSTI4 256
ASGNI4
line 503
;503:		s_startserver.mapbuttons[i].height  	     = 248;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+80
ADDP4
CNSTI4 248
ASGNI4
line 504
;504:		s_startserver.mapbuttons[i].generic.left     = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 505
;505:		s_startserver.mapbuttons[i].generic.top  	 = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 506
;506:		s_startserver.mapbuttons[i].generic.right    = x + 128;
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
line 507
;507:		s_startserver.mapbuttons[i].generic.bottom   = y + 128;
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
line 508
;508:		s_startserver.mapbuttons[i].focuspic         = GAMESERVER_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+60
ADDP4
ADDRGP4 $362
ASGNP4
line 509
;509:	}
LABELV $313
line 480
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $312
line 511
;510:
;511:	s_startserver.arrows.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+1336
CNSTI4 6
ASGNI4
line 512
;512:	s_startserver.arrows.generic.name  = GAMESERVER_ARROWS;
ADDRGP4 s_startserver+1336+4
ADDRGP4 $366
ASGNP4
line 513
;513:	s_startserver.arrows.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+1336+44
CNSTU4 16384
ASGNU4
line 514
;514:	s_startserver.arrows.generic.x	   = 260;
ADDRGP4 s_startserver+1336+12
CNSTI4 260
ASGNI4
line 515
;515:	s_startserver.arrows.generic.y	   = 400;
ADDRGP4 s_startserver+1336+16
CNSTI4 400
ASGNI4
line 516
;516:	s_startserver.arrows.width  	   = 128;
ADDRGP4 s_startserver+1336+76
CNSTI4 128
ASGNI4
line 517
;517:	s_startserver.arrows.height  	   = 32;
ADDRGP4 s_startserver+1336+80
CNSTI4 32
ASGNI4
line 519
;518:
;519:	s_startserver.prevpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1424
CNSTI4 6
ASGNI4
line 520
;520:	s_startserver.prevpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1424+44
CNSTU4 260
ASGNU4
line 521
;521:	s_startserver.prevpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1424+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 522
;522:	s_startserver.prevpage.generic.id	    = ID_PREVPAGE;
ADDRGP4 s_startserver+1424+8
CNSTI4 15
ASGNI4
line 523
;523:	s_startserver.prevpage.generic.x		= 260;
ADDRGP4 s_startserver+1424+12
CNSTI4 260
ASGNI4
line 524
;524:	s_startserver.prevpage.generic.y		= 400;
ADDRGP4 s_startserver+1424+16
CNSTI4 400
ASGNI4
line 525
;525:	s_startserver.prevpage.width  		    = 64;
ADDRGP4 s_startserver+1424+76
CNSTI4 64
ASGNI4
line 526
;526:	s_startserver.prevpage.height  		    = 32;
ADDRGP4 s_startserver+1424+80
CNSTI4 32
ASGNI4
line 527
;527:	s_startserver.prevpage.focuspic         = GAMESERVER_ARROWSL;
ADDRGP4 s_startserver+1424+60
ADDRGP4 $394
ASGNP4
line 529
;528:
;529:	s_startserver.nextpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1512
CNSTI4 6
ASGNI4
line 530
;530:	s_startserver.nextpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1512+44
CNSTU4 260
ASGNU4
line 531
;531:	s_startserver.nextpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1512+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 532
;532:	s_startserver.nextpage.generic.id	    = ID_NEXTPAGE;
ADDRGP4 s_startserver+1512+8
CNSTI4 16
ASGNI4
line 533
;533:	s_startserver.nextpage.generic.x		= 321;
ADDRGP4 s_startserver+1512+12
CNSTI4 321
ASGNI4
line 534
;534:	s_startserver.nextpage.generic.y		= 400;
ADDRGP4 s_startserver+1512+16
CNSTI4 400
ASGNI4
line 535
;535:	s_startserver.nextpage.width  		    = 64;
ADDRGP4 s_startserver+1512+76
CNSTI4 64
ASGNI4
line 536
;536:	s_startserver.nextpage.height  		    = 32;
ADDRGP4 s_startserver+1512+80
CNSTI4 32
ASGNI4
line 537
;537:	s_startserver.nextpage.focuspic         = GAMESERVER_ARROWSR;
ADDRGP4 s_startserver+1512+60
ADDRGP4 $412
ASGNP4
line 539
;538:
;539:	s_startserver.mapname.generic.type  = MTYPE_PTEXT;
ADDRGP4 s_startserver+1776
CNSTI4 9
ASGNI4
line 540
;540:	s_startserver.mapname.generic.flags = QMF_CENTER_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_startserver+1776+44
CNSTU4 16392
ASGNU4
line 541
;541:	s_startserver.mapname.generic.x	    = 320;
ADDRGP4 s_startserver+1776+12
CNSTI4 320
ASGNI4
line 542
;542:	s_startserver.mapname.generic.y	    = 440;
ADDRGP4 s_startserver+1776+16
CNSTI4 440
ASGNI4
line 543
;543:	s_startserver.mapname.string        = mapnamebuffer;
ADDRGP4 s_startserver+1776+60
ADDRGP4 $253
ASGNP4
line 544
;544:	s_startserver.mapname.style         = UI_CENTER|UI_BIGFONT;
ADDRGP4 s_startserver+1776+64
CNSTI4 33
ASGNI4
line 545
;545:	s_startserver.mapname.color         = text_color_normal;
ADDRGP4 s_startserver+1776+68
ADDRGP4 text_color_normal
ASGNP4
line 547
;546:
;547:	s_startserver.back.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1600
CNSTI4 6
ASGNI4
line 548
;548:	s_startserver.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_startserver+1600+4
ADDRGP4 $429
ASGNP4
line 549
;549:	s_startserver.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1600+44
CNSTU4 260
ASGNU4
line 550
;550:	s_startserver.back.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1600+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 551
;551:	s_startserver.back.generic.id	    = ID_STARTSERVERBACK;
ADDRGP4 s_startserver+1600+8
CNSTI4 17
ASGNI4
line 552
;552:	s_startserver.back.generic.x		= 0;
ADDRGP4 s_startserver+1600+12
CNSTI4 0
ASGNI4
line 553
;553:	s_startserver.back.generic.y		= 480-64;
ADDRGP4 s_startserver+1600+16
CNSTI4 416
ASGNI4
line 554
;554:	s_startserver.back.width  		    = 128;
ADDRGP4 s_startserver+1600+76
CNSTI4 128
ASGNI4
line 555
;555:	s_startserver.back.height  		    = 64;
ADDRGP4 s_startserver+1600+80
CNSTI4 64
ASGNI4
line 556
;556:	s_startserver.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_startserver+1600+60
ADDRGP4 $446
ASGNP4
line 558
;557:
;558:	s_startserver.next.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1688
CNSTI4 6
ASGNI4
line 559
;559:	s_startserver.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_startserver+1688+4
ADDRGP4 $450
ASGNP4
line 560
;560:	s_startserver.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1688+44
CNSTU4 272
ASGNU4
line 561
;561:	s_startserver.next.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1688+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 562
;562:	s_startserver.next.generic.id	    = ID_STARTSERVERNEXT;
ADDRGP4 s_startserver+1688+8
CNSTI4 18
ASGNI4
line 563
;563:	s_startserver.next.generic.x		= 640;
ADDRGP4 s_startserver+1688+12
CNSTI4 640
ASGNI4
line 564
;564:	s_startserver.next.generic.y		= 480-64;
ADDRGP4 s_startserver+1688+16
CNSTI4 416
ASGNI4
line 565
;565:	s_startserver.next.width  		    = 128;
ADDRGP4 s_startserver+1688+76
CNSTI4 128
ASGNI4
line 566
;566:	s_startserver.next.height  		    = 64;
ADDRGP4 s_startserver+1688+80
CNSTI4 64
ASGNI4
line 567
;567:	s_startserver.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_startserver+1688+60
ADDRGP4 $467
ASGNP4
line 569
;568:
;569:	s_startserver.item_null.generic.type	= MTYPE_BITMAP;
ADDRGP4 s_startserver+1848
CNSTI4 6
ASGNI4
line 570
;570:	s_startserver.item_null.generic.flags	= QMF_LEFT_JUSTIFY|QMF_MOUSEONLY|QMF_SILENT;
ADDRGP4 s_startserver+1848+44
CNSTU4 1050628
ASGNU4
line 571
;571:	s_startserver.item_null.generic.x		= 0;
ADDRGP4 s_startserver+1848+12
CNSTI4 0
ASGNI4
line 572
;572:	s_startserver.item_null.generic.y		= 0;
ADDRGP4 s_startserver+1848+16
CNSTI4 0
ASGNI4
line 573
;573:	s_startserver.item_null.width			= 640;
ADDRGP4 s_startserver+1848+76
CNSTI4 640
ASGNI4
line 574
;574:	s_startserver.item_null.height			= 480;
ADDRGP4 s_startserver+1848+80
CNSTI4 480
ASGNI4
line 576
;575:
;576:	Menu_AddItem( &s_startserver.menu, &s_startserver.banner );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 577
;577:	Menu_AddItem( &s_startserver.menu, &s_startserver.framel );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 578
;578:	Menu_AddItem( &s_startserver.menu, &s_startserver.framer );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 580
;579:
;580:	Menu_AddItem( &s_startserver.menu, &s_startserver.gametype );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 581
;581:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $483
line 582
;582:	{
line 583
;583:		Menu_AddItem( &s_startserver.menu, &s_startserver.mappics[i] );
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
line 584
;584:		Menu_AddItem( &s_startserver.menu, &s_startserver.mapbuttons[i] );
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
line 585
;585:	}
LABELV $484
line 581
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $483
line 587
;586:
;587:	Menu_AddItem( &s_startserver.menu, &s_startserver.arrows );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1336
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 588
;588:	Menu_AddItem( &s_startserver.menu, &s_startserver.prevpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1424
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 589
;589:	Menu_AddItem( &s_startserver.menu, &s_startserver.nextpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1512
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 590
;590:	Menu_AddItem( &s_startserver.menu, &s_startserver.back );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1600
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 591
;591:	Menu_AddItem( &s_startserver.menu, &s_startserver.next );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1688
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 592
;592:	Menu_AddItem( &s_startserver.menu, &s_startserver.mapname );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1776
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 593
;593:	Menu_AddItem( &s_startserver.menu, &s_startserver.item_null );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1848
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 595
;594:
;595:	StartServer_GametypeEvent( NULL, QM_ACTIVATED );
CNSTP4 0
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 StartServer_GametypeEvent
CALLV
pop
line 596
;596:}
LABELV $252
endproc StartServer_MenuInit 20 12
export StartServer_Cache
proc StartServer_Cache 100 16
line 605
;597:
;598:
;599:/*
;600:=================
;601:StartServer_Cache
;602:=================
;603:*/
;604:void StartServer_Cache( void )
;605:{
line 611
;606:	int				i;
;607:	const char		*info;
;608:	qboolean		precache;
;609:	char			picname[64];
;610:
;611:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );	
ADDRGP4 $429
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 612
;612:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );	
ADDRGP4 $446
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 613
;613:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT0 );	
ADDRGP4 $450
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 614
;614:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT1 );	
ADDRGP4 $467
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 615
;615:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMEL );	
ADDRGP4 $271
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 616
;616:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMER );	
ADDRGP4 $285
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 617
;617:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );	
ADDRGP4 $362
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 618
;618:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECTED );	
ADDRGP4 $331
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 619
;619:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $334
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 620
;620:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWS );
ADDRGP4 $366
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 621
;621:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSL );
ADDRGP4 $394
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 622
;622:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSR );
ADDRGP4 $412
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 624
;623:
;624:	precache = trap_Cvar_VariableValue("com_buildscript");
ADDRGP4 $497
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
line 626
;625:
;626:	s_startserver.nummaps = UI_GetNumArenas();
ADDRLP4 80
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRGP4 s_startserver+1944
ADDRLP4 80
INDIRI4
ASGNI4
line 628
;627:
;628:	for( i = 0; i < s_startserver.nummaps; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $502
JUMPV
LABELV $499
line 629
;629:		info = UI_GetArenaInfoByNumber( i );
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
line 631
;630:
;631:		Q_strncpyz( s_startserver.maplist[i], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $187
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
line 632
;632:		Q_strupr( s_startserver.maplist[i] );
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
line 633
;633:		s_startserver.mapGamebits[i] = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $182
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
line 635
;634:
;635:		if( precache ) {
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $507
line 636
;636:			Com_sprintf( picname, sizeof(picname), "levelshots/%s", s_startserver.maplist[i] );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $107
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
line 637
;637:			trap_R_RegisterShaderNoMip(picname);
ADDRLP4 8
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 638
;638:		}
LABELV $507
line 639
;639:	}
LABELV $500
line 628
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $502
ADDRLP4 0
INDIRI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $499
line 641
;640:
;641:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
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
line 642
;642:}
LABELV $496
endproc StartServer_Cache 100 16
export UI_StartServerMenu
proc UI_StartServerMenu 0 4
line 650
;643:
;644:
;645:/*
;646:=================
;647:UI_StartServerMenu
;648:=================
;649:*/
;650:void UI_StartServerMenu( qboolean multiplayer ) {
line 651
;651:	StartServer_MenuInit();
ADDRGP4 StartServer_MenuInit
CALLV
pop
line 652
;652:	s_startserver.multiplayer = multiplayer;
ADDRGP4 s_startserver+1936
ADDRFP4 0
INDIRI4
ASGNI4
line 653
;653:	UI_PushMenu( &s_startserver.menu );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 654
;654:}
LABELV $512
endproc UI_StartServerMenu 0 4
data
align 4
LABELV dedicated_list
address $515
address $516
address $517
byte 4 0
align 4
LABELV playerType_list
address $518
address $519
address $520
byte 4 0
align 4
LABELV playerTeam_list
address $521
address $522
byte 4 0
align 4
LABELV botSkill_list
address $523
address $524
address $525
address $526
address $527
byte 4 0
code
proc BotAlreadySelected 12 8
line 760
;655:
;656:
;657:
;658:/*
;659:=============================================================================
;660:
;661:SERVER OPTIONS MENU *****
;662:
;663:=============================================================================
;664:*/
;665:
;666:#define ID_PLAYER_TYPE			20
;667:#define ID_MAXCLIENTS			21
;668:#define ID_DEDICATED			22
;669:#define ID_GO					23
;670:#define ID_BACK					24
;671:
;672:#define PLAYER_SLOTS			12
;673:
;674:
;675:typedef struct {
;676:	menuframework_s		menu;
;677:
;678:	menutext_s			banner;
;679:
;680:	menubitmap_s		mappic;
;681:	menubitmap_s		picframe;
;682:
;683:	menulist_s			dedicated;
;684:	menufield_s			timelimit;
;685:	menufield_s			fraglimit;
;686:	menufield_s			flaglimit;
;687:	menuradiobutton_s	friendlyfire;
;688:	menufield_s			hostname;
;689:	menuradiobutton_s	pure;
;690:	menulist_s			botSkill;
;691:	menufield_s			additionalSlots;
;692:	menuradiobutton_s	noPowerups;
;693:	menuradiobutton_s	noHealth;
;694:	menuradiobutton_s	noArmor;
;695:	menuradiobutton_s	noMegaHealth;
;696:	menuradiobutton_s	noPersonalTeleporter;
;697:	menuradiobutton_s	noPlasmaBFG;
;698:	menuradiobutton_s	noGrenadeRocket;
;699:	menuradiobutton_s 	noRailgun;
;700:	menuradiobutton_s	enableBlaster;
;701:
;702:	menutext_s			player0;
;703:	menulist_s			playerType[PLAYER_SLOTS];
;704:	menutext_s			playerName[PLAYER_SLOTS];
;705:	menulist_s			playerTeam[PLAYER_SLOTS];
;706:
;707:	menubitmap_s		go;
;708:	menubitmap_s		next;
;709:	menubitmap_s		back;
;710:
;711:	qboolean			multiplayer;
;712:	int					gametype;
;713:	char				mapnamebuffer[32];
;714:	char				playerNameBuffers[PLAYER_SLOTS][16];
;715:
;716:	qboolean			newBot;
;717:	int					newBotIndex;
;718:	char				newBotName[16];
;719:	
;720:	menulist_s		punkbuster;
;721:} serveroptions_t;
;722:
;723:static serveroptions_t s_serveroptions;
;724:
;725:static const char *dedicated_list[] = {
;726:	"No",
;727:	"LAN",
;728:	"Internet",
;729:	0
;730:};
;731:
;732:static const char *playerType_list[] = {
;733:	"Open",
;734:	"Bot",
;735:	"----",
;736:	0
;737:};
;738:
;739:static const char *playerTeam_list[] = {
;740:	"Blue",
;741:	"Red",
;742:	0
;743:};
;744:
;745:static const char *botSkill_list[] = {
;746:	"I Can Win",
;747:	"Bring It On",
;748:	"Hurt Me Plenty",
;749:	"Hardcore",
;750:	"Nightmare!",
;751:	0
;752:};
;753:
;754:
;755:/*
;756:=================
;757:BotAlreadySelected
;758:=================
;759:*/
;760:static qboolean BotAlreadySelected( const char *checkName ) {
line 763
;761:	int		n;
;762:
;763:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $529
line 764
;764:		if( s_serveroptions.playerType[n].curvalue != 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $533
line 765
;765:			continue;
ADDRGP4 $530
JUMPV
LABELV $533
line 767
;766:		}
;767:		if( (s_serveroptions.gametype >= GT_TEAM) &&
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $537
ADDRLP4 4
CNSTI4 96
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+64
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDRGP4 s_serveroptions+6832
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+64
ADDP4
INDIRI4
EQI4 $537
line 768
;768:			(s_serveroptions.playerTeam[n].curvalue != s_serveroptions.playerTeam[s_serveroptions.newBotIndex].curvalue ) ) {
line 769
;769:			continue;
ADDRGP4 $530
JUMPV
LABELV $537
line 771
;770:		}
;771:		if( Q_stricmp( checkName, s_serveroptions.playerNameBuffers[n] ) == 0 ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $545
line 772
;772:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $528
JUMPV
LABELV $545
line 774
;773:		}
;774:	}
LABELV $530
line 763
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $529
line 776
;775:
;776:	return qfalse;
CNSTI4 0
RETI4
LABELV $528
endproc BotAlreadySelected 12 8
proc ServerOptions_Start 184 24
line 785
;777:}
;778:
;779:
;780:/*
;781:=================
;782:ServerOptions_Start
;783:=================
;784:*/
;785:static void ServerOptions_Start( void ) {
line 798
;786:	int		timelimit;
;787:	int		fraglimit;
;788:	int		maxclients;
;789:	int		additionalSlots;
;790:	int		dedicated;
;791:	int		friendlyfire;
;792:	int		flaglimit;
;793:	int		pure;
;794:	int		skill;
;795:	int		n;
;796:	char		buf[64];
;797:
;798:	timelimit =
ADDRGP4 s_serveroptions+632+60+12
ARGP4
ADDRLP4 104
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 84
ADDRLP4 104
INDIRI4
ASGNI4
line 801
;799:		atoi( s_serveroptions.timelimit.field.buffer );
;800:
;801:	fraglimit =
ADDRGP4 s_serveroptions+964+60+12
ARGP4
ADDRLP4 108
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 88
ADDRLP4 108
INDIRI4
ASGNI4
line 804
;802:		atoi( s_serveroptions.fraglimit.field.buffer );
;803:
;804:	flaglimit =
ADDRGP4 s_serveroptions+1296+60+12
ARGP4
ADDRLP4 112
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 96
ADDRLP4 112
INDIRI4
ASGNI4
line 807
;805:		atoi( s_serveroptions.flaglimit.field.buffer );
;806:
;807:	dedicated =
ADDRLP4 80
ADDRGP4 s_serveroptions+536+64
INDIRI4
ASGNI4
line 810
;808:		s_serveroptions.dedicated.curvalue;
;809:
;810:	friendlyfire =
ADDRLP4 92
ADDRGP4 s_serveroptions+1628+60
INDIRI4
ASGNI4
line 813
;811:		s_serveroptions.friendlyfire.curvalue;
;812:
;813:	pure =
ADDRLP4 100
ADDRGP4 s_serveroptions+2024+60
INDIRI4
ASGNI4
line 816
;814:		s_serveroptions.pure.curvalue;
;815:
;816:	skill =
ADDRLP4 72
ADDRGP4 s_serveroptions+2088+64
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 822
;817:		s_serveroptions.botSkill.curvalue + 1;
;818:
;819:	/*
;820:	 * Count all visible player slots which are not closed.
;821:	 */
;822:	for( n = 0, maxclients = 0;
ADDRLP4 116
CNSTI4 0
ASGNI4
ADDRLP4 0
ADDRLP4 116
INDIRI4
ASGNI4
ADDRLP4 68
ADDRLP4 116
INDIRI4
ASGNI4
ADDRGP4 $569
JUMPV
LABELV $566
line 824
;823:		n < PLAYER_SLOTS;
;824:		n++ ) {
line 825
;825:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $570
line 826
;826:			== 2 ) {
line 827
;827:			continue;
ADDRGP4 $567
JUMPV
LABELV $570
line 830
;828:		}
;829:
;830:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $574
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $574
line 833
;831:			== 1 &&
;832:			s_serveroptions.playerNameBuffers[n][0]
;833:			== 0 ) {
line 834
;834:			continue;
ADDRGP4 $567
JUMPV
LABELV $574
line 837
;835:		}
;836:
;837:		maxclients++;
ADDRLP4 68
ADDRLP4 68
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 838
;838:	}
LABELV $567
line 824
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $569
line 823
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $566
line 843
;839:
;840:	/*
;841:	 * Add extra free slots.
;842:	 */
;843:	additionalSlots = atoi(
ADDRGP4 s_serveroptions+2184+60+12
ARGP4
ADDRLP4 120
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 76
ADDRLP4 120
INDIRI4
ASGNI4
line 847
;844:		s_serveroptions.additionalSlots.field.buffer
;845:	);
;846:
;847:	additionalSlots = (int)Com_Clamp(
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
ADDRLP4 124
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRLP4 76
ADDRLP4 124
INDIRF4
CVFI4 4
ASGNI4
line 853
;848:		0,
;849:		MAX_CLIENTS - maxclients,
;850:		additionalSlots
;851:	);
;852:
;853:	trap_Cvar_SetValue(
ADDRGP4 $582
ARGP4
ADDRLP4 76
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 858
;854:		"ui_additionalSlots",
;855:		additionalSlots
;856:	);
;857:
;858:	maxclients += additionalSlots;
ADDRLP4 68
ADDRLP4 68
INDIRI4
ADDRLP4 76
INDIRI4
ADDI4
ASGNI4
line 863
;859:
;860:	/*
;861:	 * Powerups.
;862:	 */
;863:	trap_Cvar_SetValue(
ADDRGP4 $583
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 868
;864:		"ui_noPowerups",
;865:		s_serveroptions.noPowerups.curvalue
;866:	);
;867:
;868:	trap_Cvar_SetValue(
ADDRGP4 $586
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 876
;869:		"g_noPowerups",
;870:		s_serveroptions.noPowerups.curvalue
;871:	);
;872:
;873:	/*
;874:	 * Mega Health and Medkit share one menu option.
;875:	 */
;876:	trap_Cvar_SetValue(
ADDRGP4 $589
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 881
;877:		"ui_noMegaHealth",
;878:		s_serveroptions.noMegaHealth.curvalue
;879:	);
;880:
;881:	trap_Cvar_SetValue(
ADDRGP4 $592
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 886
;882:		"g_noMegaHealth",
;883:		s_serveroptions.noMegaHealth.curvalue
;884:	);
;885:
;886:	trap_Cvar_SetValue(
ADDRGP4 $595
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 894
;887:		"g_noMedkit",
;888:		s_serveroptions.noMegaHealth.curvalue
;889:	);
;890:
;891:	/*
;892:	 * Personal Teleporter.
;893:	 */
;894:	trap_Cvar_SetValue(
ADDRGP4 $598
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 899
;895:		"ui_noPersonalTeleporter",
;896:		s_serveroptions.noPersonalTeleporter.curvalue
;897:	);
;898:
;899:	trap_Cvar_SetValue(
ADDRGP4 $601
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 904
;900:		"g_noPersonalTeleporter",
;901:		s_serveroptions.noPersonalTeleporter.curvalue
;902:	);
;903:
;904:	trap_Cmd_ExecuteText(
ADDRGP4 $604
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
ARGI4
ADDRLP4 128
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 128
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 914
;905:		EXEC_APPEND,
;906:		va(
;907:			"seta ui_noMegaHealth \"%i\"\n"
;908:			"seta ui_noPersonalTeleporter \"%i\"\n",
;909:			s_serveroptions.noMegaHealth.curvalue,
;910:			s_serveroptions.noPersonalTeleporter.curvalue
;911:		)
;912:	);
;913:
;914:	trap_Cmd_ExecuteText(
ADDRGP4 $609
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
ARGI4
ADDRLP4 132
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 132
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 925
;915:		EXEC_APPEND,
;916:		va(
;917:			"seta ui_noPowerups \"%i\"\n",
;918:			s_serveroptions.noPowerups.curvalue
;919:		)
;920:	);
;921:
;922:	/*
;923:	 * Store limits for the selected game type.
;924:	 */
;925:	switch( s_serveroptions.gametype ) {
ADDRLP4 136
ADDRGP4 s_serveroptions+6600
INDIRI4
ASGNI4
ADDRLP4 136
INDIRI4
CNSTI4 0
LTI4 $612
ADDRLP4 136
INDIRI4
CNSTI4 4
GTI4 $612
ADDRLP4 136
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $629
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $629
address $615
address $618
address $612
address $621
address $625
code
LABELV $615
LABELV $612
line 928
;926:	case GT_FFA:
;927:	default:
;928:		trap_Cvar_SetValue(
ADDRGP4 $616
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 933
;929:			"ui_ffa_fraglimit",
;930:			fraglimit
;931:		);
;932:
;933:		trap_Cvar_SetValue(
ADDRGP4 $617
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 937
;934:			"ui_ffa_timelimit",
;935:			timelimit
;936:		);
;937:		break;
ADDRGP4 $613
JUMPV
LABELV $618
line 940
;938:
;939:	case GT_TOURNAMENT:
;940:		trap_Cvar_SetValue(
ADDRGP4 $619
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 945
;941:			"ui_tourney_fraglimit",
;942:			fraglimit
;943:		);
;944:
;945:		trap_Cvar_SetValue(
ADDRGP4 $620
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 949
;946:			"ui_tourney_timelimit",
;947:			timelimit
;948:		);
;949:		break;
ADDRGP4 $613
JUMPV
LABELV $621
line 952
;950:
;951:	case GT_TEAM:
;952:		trap_Cvar_SetValue(
ADDRGP4 $622
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 957
;953:			"ui_team_fraglimit",
;954:			fraglimit
;955:		);
;956:
;957:		trap_Cvar_SetValue(
ADDRGP4 $623
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 962
;958:			"ui_team_timelimit",
;959:			timelimit
;960:		);
;961:
;962:		trap_Cvar_SetValue(
ADDRGP4 $624
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 966
;963:			"ui_team_friendly",
;964:			friendlyfire
;965:		);
;966:		break;
ADDRGP4 $613
JUMPV
LABELV $625
line 969
;967:
;968:	case GT_CTF:
;969:		trap_Cvar_SetValue(
ADDRGP4 $626
ARGP4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 974
;970:			"ui_ctf_capturelimit",
;971:			flaglimit
;972:		);
;973:
;974:		trap_Cvar_SetValue(
ADDRGP4 $627
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 979
;975:			"ui_ctf_timelimit",
;976:			timelimit
;977:		);
;978:
;979:		trap_Cvar_SetValue(
ADDRGP4 $628
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 983
;980:			"ui_ctf_friendly",
;981:			friendlyfire
;982:		);
;983:		break;
LABELV $613
line 989
;984:	}
;985:
;986:	/*
;987:	 * General server settings.
;988:	 */
;989:	trap_Cvar_SetValue(
CNSTF4 1065353216
ARGF4
CNSTF4 1115684864
ARGF4
ADDRLP4 68
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 140
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $630
ARGP4
ADDRLP4 140
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 998
;990:		"sv_maxclients",
;991:		Com_Clamp(
;992:			1,
;993:			MAX_CLIENTS,
;994:			maxclients
;995:		)
;996:	);
;997:
;998:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1073741824
ARGF4
ADDRLP4 80
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 144
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $631
ARGP4
ADDRLP4 144
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1007
;999:		"dedicated",
;1000:		Com_Clamp(
;1001:			0,
;1002:			2,
;1003:			dedicated
;1004:		)
;1005:	);
;1006:
;1007:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 148
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $632
ARGP4
ADDRLP4 148
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1016
;1008:		"timelimit",
;1009:		Com_Clamp(
;1010:			0,
;1011:			999,
;1012:			timelimit
;1013:		)
;1014:	);
;1015:
;1016:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 152
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $633
ARGP4
ADDRLP4 152
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1025
;1017:		"fraglimit",
;1018:		Com_Clamp(
;1019:			0,
;1020:			999,
;1021:			fraglimit
;1022:		)
;1023:	);
;1024:
;1025:	trap_Cvar_SetValue(
CNSTF4 0
ARGF4
CNSTF4 1120403456
ARGF4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 156
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 $634
ARGP4
ADDRLP4 156
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1034
;1026:		"capturelimit",
;1027:		Com_Clamp(
;1028:			0,
;1029:			100,
;1030:			flaglimit
;1031:		)
;1032:	);
;1033:
;1034:	trap_Cvar_SetValue(
ADDRGP4 $635
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1039
;1035:		"g_friendlyfire",
;1036:		friendlyfire
;1037:	);
;1038:
;1039:	trap_Cvar_SetValue(
ADDRGP4 $636
ARGP4
ADDRLP4 100
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1044
;1040:		"sv_pure",
;1041:		pure
;1042:	);
;1043:
;1044:	trap_Cvar_Set(
ADDRGP4 $637
ARGP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1049
;1045:		"sv_hostname",
;1046:		s_serveroptions.hostname.field.buffer
;1047:	);
;1048:
;1049:	trap_Cvar_SetValue(
ADDRGP4 $641
ARGP4
ADDRGP4 s_serveroptions+6852+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1057
;1050:		"sv_punkbuster",
;1051:		s_serveroptions.punkbuster.curvalue
;1052:	);
;1053:
;1054:	/*
;1055:	 * Blaster Mode.
;1056:	 */
;1057:	trap_Cvar_SetValue(
ADDRGP4 $644
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1062
;1058:		"ui_enableBlaster",
;1059:		s_serveroptions.enableBlaster.curvalue
;1060:	);
;1061:
;1062:	trap_Cvar_SetValue(
ADDRGP4 $647
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1067
;1063:		"g_blasterMode",
;1064:		s_serveroptions.enableBlaster.curvalue
;1065:	);
;1066:
;1067:	trap_Cmd_ExecuteText(
ADDRGP4 $650
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
ARGI4
ADDRLP4 160
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 160
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1078
;1068:		EXEC_APPEND,
;1069:		va(
;1070:			"seta ui_enableBlaster \"%i\"\n",
;1071:			s_serveroptions.enableBlaster.curvalue
;1072:		)
;1073:	);
;1074:
;1075:	/*
;1076:	 * Weapon pickup restrictions.
;1077:	 */
;1078:	trap_Cvar_SetValue(
ADDRGP4 $653
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1083
;1079:		"g_noPlasmaBFG",
;1080:		s_serveroptions.noPlasmaBFG.curvalue
;1081:	);
;1082:
;1083:	trap_Cvar_SetValue(
ADDRGP4 $656
ARGP4
ADDRGP4 s_serveroptions+2900+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1088
;1084:		"g_noGrenadeRocket",
;1085:		s_serveroptions.noGrenadeRocket.curvalue
;1086:	);
;1087:	
;1088:	trap_Cvar_SetValue(
ADDRGP4 $659
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1093
;1089:		"ui_noRailgun",
;1090:		s_serveroptions.noRailgun.curvalue
;1091:	);
;1092:
;1093:	trap_Cvar_SetValue(
ADDRGP4 $662
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1098
;1094:		"g_noRailgun",
;1095:		s_serveroptions.noRailgun.curvalue
;1096:	);
;1097:
;1098:	trap_Cmd_ExecuteText(
ADDRGP4 $665
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
ARGI4
ADDRLP4 164
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 164
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1106
;1099:		EXEC_APPEND,
;1100:		va(
;1101:			"seta ui_noRailgun \"%i\"\n",
;1102:			s_serveroptions.noRailgun.curvalue
;1103:		)
;1104:	);
;1105:
;1106:	trap_Cmd_ExecuteText(
ADDRGP4 $668
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2900+60
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
line 1119
;1107:		EXEC_APPEND,
;1108:		va(
;1109:			"seta ui_noPlasmaBFG \"%i\"\n"
;1110:			"seta ui_noGrenadeRocket \"%i\"\n",
;1111:			s_serveroptions.noPlasmaBFG.curvalue,
;1112:			s_serveroptions.noGrenadeRocket.curvalue
;1113:		)
;1114:	);
;1115:
;1116:	/*
;1117:	 * Health and armor restrictions.
;1118:	 */
;1119:	trap_Cvar_SetValue(
ADDRGP4 $673
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1124
;1120:		"g_noHealth",
;1121:		s_serveroptions.noHealth.curvalue
;1122:	);
;1123:
;1124:	trap_Cvar_SetValue(
ADDRGP4 $676
ARGP4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1129
;1125:		"g_noArmor",
;1126:		s_serveroptions.noArmor.curvalue
;1127:	);
;1128:
;1129:	trap_Cmd_ExecuteText(
ADDRGP4 $679
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+2644+60
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
line 1143
;1130:		EXEC_APPEND,
;1131:		va(
;1132:			"seta ui_noHealth \"%i\"\n"
;1133:			"seta ui_noArmor \"%i\"\n",
;1134:			s_serveroptions.noHealth.curvalue,
;1135:			s_serveroptions.noArmor.curvalue
;1136:		)
;1137:	);
;1138:
;1139:	/*
;1140:	 * Disable any previous map rotation. After the match,
;1141:	 * Quake III will restart the current map.
;1142:	 */
;1143:	trap_Cvar_Set(
ADDRGP4 $684
ARGP4
ADDRGP4 $685
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1151
;1144:		"nextmap",
;1145:		"map_restart 0"
;1146:	);
;1147:
;1148:	/*
;1149:	 * Start selected map.
;1150:	 */
;1151:	trap_Cmd_ExecuteText(
ADDRGP4 $686
ARGP4
ADDRGP4 s_startserver+1940
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_startserver+1956
ADDP4
ARGP4
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
line 1164
;1152:		EXEC_APPEND,
;1153:		va(
;1154:			"wait; wait; map %s\n",
;1155:			s_startserver.maplist[
;1156:				s_startserver.currentmap
;1157:			]
;1158:		)
;1159:	);
;1160:
;1161:	/*
;1162:	 * Add selected bots after loading the map.
;1163:	 */
;1164:	trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRGP4 $689
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1169
;1165:		EXEC_APPEND,
;1166:		"wait 3\n"
;1167:	);
;1168:
;1169:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $690
line 1170
;1170:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $694
line 1171
;1171:			!= 1 ) {
line 1172
;1172:			continue;
ADDRGP4 $691
JUMPV
LABELV $694
line 1175
;1173:		}
;1174:
;1175:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $698
line 1176
;1176:			== 0 ) {
line 1177
;1177:			continue;
ADDRGP4 $691
JUMPV
LABELV $698
line 1180
;1178:		}
;1179:
;1180:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $701
line 1181
;1181:			== '-' ) {
line 1182
;1182:			continue;
ADDRGP4 $691
JUMPV
LABELV $701
line 1185
;1183:		}
;1184:
;1185:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $704
line 1186
;1186:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $707
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+64
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
line 1197
;1187:				buf,
;1188:				sizeof(buf),
;1189:				"addbot %s %i %s\n",
;1190:				s_serveroptions.playerNameBuffers[n],
;1191:				skill,
;1192:				playerTeam_list[
;1193:					s_serveroptions.playerTeam[n]
;1194:						.curvalue
;1195:				]
;1196:			);
;1197:		}
ADDRGP4 $705
JUMPV
LABELV $704
line 1198
;1198:		else {
line 1199
;1199:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $711
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ARGP4
ADDRLP4 72
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1206
;1200:				buf,
;1201:				sizeof(buf),
;1202:				"addbot %s %i\n",
;1203:				s_serveroptions.playerNameBuffers[n],
;1204:				skill
;1205:			);
;1206:		}
LABELV $705
line 1208
;1207:
;1208:		trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1212
;1209:			EXEC_APPEND,
;1210:			buf
;1211:		);
;1212:	}
LABELV $691
line 1169
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $690
line 1217
;1213:
;1214:	/*
;1215:	 * Place the local player on the selected team.
;1216:	 */
;1217:	if( dedicated == 0 &&
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $713
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $713
line 1218
;1218:		s_serveroptions.gametype >= GT_TEAM ) {
line 1219
;1219:		trap_Cmd_ExecuteText(
ADDRGP4 $716
ARGP4
ADDRGP4 s_serveroptions+5180+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 playerTeam_list
ADDP4
INDIRP4
ARGP4
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
line 1229
;1220:			EXEC_APPEND,
;1221:			va(
;1222:				"wait 5; team %s\n",
;1223:				playerTeam_list[
;1224:					s_serveroptions.playerTeam[0]
;1225:						.curvalue
;1226:				]
;1227:			)
;1228:		);
;1229:	}
LABELV $713
line 1230
;1230:}
LABELV $548
endproc ServerOptions_Start 184 24
proc ServerOptions_InitPlayerItems 12 12
line 1238
;1231:
;1232:
;1233:/*
;1234:=================
;1235:ServerOptions_InitPlayerItems
;1236:=================
;1237:*/
;1238:static void ServerOptions_InitPlayerItems( void ) {
line 1243
;1239:	int		n;
;1240:	int		v;
;1241:
;1242:	// init types
;1243:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6596
INDIRI4
CNSTI4 0
EQI4 $720
line 1244
;1244:		v = 0;	// open
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1245
;1245:	}
ADDRGP4 $721
JUMPV
LABELV $720
line 1246
;1246:	else {
line 1247
;1247:		v = 1;	// bot
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1248
;1248:	}
LABELV $721
line 1250
;1249:	
;1250:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $723
line 1251
;1251:		s_serveroptions.playerType[n].curvalue = v;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1252
;1252:	}
LABELV $724
line 1250
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $723
line 1254
;1253:
;1254:	if( s_serveroptions.multiplayer && (s_serveroptions.gametype < GT_TEAM) ) {
ADDRGP4 s_serveroptions+6596
INDIRI4
CNSTI4 0
EQI4 $729
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
GEI4 $729
line 1255
;1255:		for( n = 8; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 8
ASGNI4
LABELV $733
line 1256
;1256:			s_serveroptions.playerType[n].curvalue = 2;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
CNSTI4 2
ASGNI4
line 1257
;1257:		}
LABELV $734
line 1255
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $733
line 1258
;1258:	}
LABELV $729
line 1261
;1259:
;1260:	// if not a dedicated server, first slot is reserved for the human on the server
;1261:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $739
line 1263
;1262:		// human
;1263:		s_serveroptions.playerType[0].generic.flags |= QMF_INACTIVE;
ADDRLP4 8
ADDRGP4 s_serveroptions+3164+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 16384
BORU4
ASGNU4
line 1264
;1264:		s_serveroptions.playerType[0].curvalue = 0;
ADDRGP4 s_serveroptions+3164+64
CNSTI4 0
ASGNI4
line 1265
;1265:		trap_Cvar_VariableStringBuffer( "name", s_serveroptions.playerNameBuffers[0], sizeof(s_serveroptions.playerNameBuffers[0]) );
ADDRGP4 $747
ARGP4
ADDRGP4 s_serveroptions+6636
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 1266
;1266:		Q_CleanStr( s_serveroptions.playerNameBuffers[0] );
ADDRGP4 s_serveroptions+6636
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1267
;1267:	}
LABELV $739
line 1270
;1268:
;1269:	// init teams
;1270:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $751
line 1271
;1271:		for( n = 0; n < (PLAYER_SLOTS / 2); n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $754
line 1272
;1272:			s_serveroptions.playerTeam[n].curvalue = 0;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+64
ADDP4
CNSTI4 0
ASGNI4
line 1273
;1273:		}
LABELV $755
line 1271
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 6
LTI4 $754
line 1274
;1274:		for( ; n < PLAYER_SLOTS; n++ ) {
ADDRGP4 $763
JUMPV
LABELV $760
line 1275
;1275:			s_serveroptions.playerTeam[n].curvalue = 1;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+64
ADDP4
CNSTI4 1
ASGNI4
line 1276
;1276:		}
LABELV $761
line 1274
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $763
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $760
line 1277
;1277:	}
ADDRGP4 $752
JUMPV
LABELV $751
line 1278
;1278:	else {
line 1279
;1279:		for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $766
line 1280
;1280:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+44
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
line 1281
;1281:		}
LABELV $767
line 1279
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $766
line 1282
;1282:	}
LABELV $752
line 1283
;1283:}
LABELV $719
endproc ServerOptions_InitPlayerItems 12 12
proc ServerOptions_SetPlayerItems 12 0
line 1291
;1284:
;1285:
;1286:/*
;1287:=================
;1288:ServerOptions_SetPlayerItems
;1289:=================
;1290:*/
;1291:static void ServerOptions_SetPlayerItems( void ) {
line 1303
;1292:	int		start;
;1293:	int		n;
;1294:
;1295:	// types
;1296://	for( n = 0; n < PLAYER_SLOTS; n++ ) {
;1297://		if( (!s_serveroptions.multiplayer) && (n > 0) && (s_serveroptions.playerType[n].curvalue == 0) ) {
;1298://			s_serveroptions.playerType[n].curvalue = 1;
;1299://		}
;1300://	}
;1301:
;1302:	// names
;1303:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $773
line 1304
;1304:		s_serveroptions.player0.string = "Human";
ADDRGP4 s_serveroptions+3092+60
ADDRGP4 $779
ASGNP4
line 1305
;1305:		s_serveroptions.playerName[0].generic.flags &= ~QMF_HIDDEN;
ADDRLP4 8
ADDRGP4 s_serveroptions+4316+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 4294963199
BANDU4
ASGNU4
line 1307
;1306:
;1307:		start = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1308
;1308:	}
ADDRGP4 $774
JUMPV
LABELV $773
line 1309
;1309:	else {
line 1310
;1310:		s_serveroptions.player0.string = "Open";
ADDRGP4 s_serveroptions+3092+60
ADDRGP4 $518
ASGNP4
line 1311
;1311:		start = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1312
;1312:	}
LABELV $774
line 1313
;1313:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $787
JUMPV
LABELV $784
line 1314
;1314:		if( s_serveroptions.playerType[n].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $788
line 1315
;1315:			s_serveroptions.playerName[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+44
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
line 1316
;1316:		}
ADDRGP4 $789
JUMPV
LABELV $788
line 1317
;1317:		else {
line 1318
;1318:			s_serveroptions.playerName[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+44
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
line 1319
;1319:		}
LABELV $789
line 1320
;1320:	}
LABELV $785
line 1313
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $787
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $784
line 1323
;1321:
;1322:	// teams
;1323:	if( s_serveroptions.gametype < GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
GEI4 $796
line 1324
;1324:		return;
ADDRGP4 $772
JUMPV
LABELV $796
line 1326
;1325:	}
;1326:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $802
JUMPV
LABELV $799
line 1327
;1327:		if( s_serveroptions.playerType[n].curvalue == 2 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $803
line 1328
;1328:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+44
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
line 1329
;1329:		}
ADDRGP4 $804
JUMPV
LABELV $803
line 1330
;1330:		else {
line 1331
;1331:			s_serveroptions.playerTeam[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
ADDRLP4 8
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+44
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
line 1332
;1332:		}
LABELV $804
line 1333
;1333:	}
LABELV $800
line 1326
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $802
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $799
line 1334
;1334:}
LABELV $772
endproc ServerOptions_SetPlayerItems 12 0
proc ServerOptions_Event 8 0
line 1342
;1335:
;1336:
;1337:/*
;1338:=================
;1339:ServerOptions_Event
;1340:=================
;1341:*/
;1342:static void ServerOptions_Event( void* ptr, int event ) {
line 1343
;1343:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $812
ADDRLP4 0
INDIRI4
CNSTI4 24
GTI4 $812
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $828-72
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $828
address $822
address $812
address $815
address $818
address $818
address $819
address $825
code
LABELV $815
line 1349
;1344:	
;1345:	//if( event != QM_ACTIVATED && event != QM_LOSTFOCUS) {
;1346:	//	return;
;1347:	//}
;1348:	case ID_PLAYER_TYPE:
;1349:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $816
line 1350
;1350:			break;
ADDRGP4 $813
JUMPV
LABELV $816
line 1352
;1351:		}
;1352:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1353
;1353:		break;
ADDRGP4 $813
JUMPV
LABELV $818
line 1357
;1354:
;1355:	case ID_MAXCLIENTS:
;1356:	case ID_DEDICATED:
;1357:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1358
;1358:		break;
ADDRGP4 $813
JUMPV
LABELV $819
line 1360
;1359:	case ID_GO:
;1360:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $820
line 1361
;1361:			break;
ADDRGP4 $813
JUMPV
LABELV $820
line 1363
;1362:		}
;1363:		ServerOptions_Start();
ADDRGP4 ServerOptions_Start
CALLV
pop
line 1364
;1364:		break;
ADDRGP4 $813
JUMPV
LABELV $822
line 1367
;1365:
;1366:	case ID_STARTSERVERNEXT:
;1367:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $813
line 1368
;1368:			break;
ADDRGP4 $813
JUMPV
line 1370
;1369:		}
;1370:		break;
LABELV $825
line 1372
;1371:	case ID_BACK:
;1372:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $826
line 1373
;1373:			break;
ADDRGP4 $813
JUMPV
LABELV $826
line 1375
;1374:		}
;1375:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 1376
;1376:		break;
LABELV $812
LABELV $813
line 1378
;1377:	}
;1378:}
LABELV $811
endproc ServerOptions_Event 8 0
proc ServerOptions_PlayerNameEvent 4 4
line 1381
;1379:
;1380:
;1381:static void ServerOptions_PlayerNameEvent( void* ptr, int event ) {
line 1384
;1382:	int		n;
;1383:
;1384:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $831
line 1385
;1385:		return;
ADDRGP4 $830
JUMPV
LABELV $831
line 1387
;1386:	}
;1387:	n = ((menutext_s*)ptr)->generic.id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1388
;1388:	s_serveroptions.newBotIndex = n;
ADDRGP4 s_serveroptions+6832
ADDRLP4 0
INDIRI4
ASGNI4
line 1389
;1389:	UI_BotSelectMenu( s_serveroptions.playerNameBuffers[n] );
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ARGP4
ADDRGP4 UI_BotSelectMenu
CALLV
pop
line 1390
;1390:}
LABELV $830
endproc ServerOptions_PlayerNameEvent 4 4
proc ServerOptions_StatusBar 4 20
line 1398
;1391:
;1392:
;1393:/*
;1394:=================
;1395:ServerOptions_StatusBar
;1396:=================
;1397:*/
;1398:static void ServerOptions_StatusBar( void* ptr ) {
line 1399
;1399:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $836
JUMPV
LABELV $836
line 1401
;1400:	default:
;1401:		UI_DrawString( 320, 440, "0 = NO LIMIT", UI_CENTER|UI_SMALLFONT, colorWhite );
CNSTI4 320
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $839
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 colorWhite
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1402
;1402:		break;
LABELV $837
line 1404
;1403:	}
;1404:}
LABELV $835
endproc ServerOptions_StatusBar 4 20
proc ServerOptions_LevelshotDraw 20 20
line 1412
;1405:
;1406:
;1407:/*
;1408:===============
;1409:ServerOptions_LevelshotDraw
;1410:===============
;1411:*/
;1412:static void ServerOptions_LevelshotDraw( void *self ) {
line 1418
;1413:	menubitmap_s	*b;
;1414:	int				x;
;1415:	int				y;
;1416:
;1417:	// strange place for this, but it works
;1418:	if( s_serveroptions.newBot ) {
ADDRGP4 s_serveroptions+6828
INDIRI4
CNSTI4 0
EQI4 $841
line 1419
;1419:		Q_strncpyz( s_serveroptions.playerNameBuffers[s_serveroptions.newBotIndex], s_serveroptions.newBotName, 16 );
ADDRGP4 s_serveroptions+6832
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ARGP4
ADDRGP4 s_serveroptions+6836
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1420
;1420:		s_serveroptions.newBot = qfalse;
ADDRGP4 s_serveroptions+6828
CNSTI4 0
ASGNI4
line 1421
;1421:	}
LABELV $841
line 1423
;1422:
;1423:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1425
;1424:
;1425:	Bitmap_Draw( b );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Bitmap_Draw
CALLV
pop
line 1427
;1426:
;1427:	x = b->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1428
;1428:	y = b->generic.y + b->height;
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
line 1429
;1429:	UI_FillRect( x, y, b->width, 40, colorBlack );
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
line 1431
;1430:
;1431:	x += b->width / 2;
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
line 1432
;1432:	y += 4;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 1433
;1433:	UI_DrawString( x, y, s_serveroptions.mapnamebuffer, UI_CENTER|UI_SMALLFONT, color_orange );
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 s_serveroptions+6604
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1435
;1434:
;1435:	y += SMALLCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1436
;1436:	UI_DrawString( x, y, gametype_items[gametype_remap2[s_serveroptions.gametype]], UI_CENTER|UI_SMALLFONT, color_orange );
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 16
CNSTI4 2
ASGNI4
ADDRGP4 s_serveroptions+6600
INDIRI4
ADDRLP4 16
INDIRI4
LSHI4
ADDRGP4 gametype_remap2
ADDP4
INDIRI4
ADDRLP4 16
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
line 1437
;1437:}
LABELV $840
endproc ServerOptions_LevelshotDraw 20 20
proc ServerOptions_InitBotNames 1072 12
line 1440
;1438:
;1439:
;1440:static void ServerOptions_InitBotNames( void ) {
line 1449
;1441:	int			count;
;1442:	int			n;
;1443:	const char	*arenaInfo;
;1444:	const char	*botInfo;
;1445:	char		*p;
;1446:	char		*bot;
;1447:	char		bots[MAX_INFO_STRING];
;1448:
;1449:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $851
line 1450
;1450:		Q_strncpyz( s_serveroptions.playerNameBuffers[1], "grunt", 16 );
ADDRGP4 s_serveroptions+6636+16
ARGP4
ADDRGP4 $856
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1451
;1451:		Q_strncpyz( s_serveroptions.playerNameBuffers[2], "major", 16 );
ADDRGP4 s_serveroptions+6636+32
ARGP4
ADDRGP4 $859
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1452
;1452:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
NEI4 $860
line 1453
;1453:			Q_strncpyz( s_serveroptions.playerNameBuffers[3], "visor", 16 );
ADDRGP4 s_serveroptions+6636+48
ARGP4
ADDRGP4 $865
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1454
;1454:		}
ADDRGP4 $861
JUMPV
LABELV $860
line 1455
;1455:		else {
line 1456
;1456:			s_serveroptions.playerType[3].curvalue = 2;
ADDRGP4 s_serveroptions+3164+288+64
CNSTI4 2
ASGNI4
line 1457
;1457:		}
LABELV $861
line 1458
;1458:		s_serveroptions.playerType[4].curvalue = 2;
ADDRGP4 s_serveroptions+3164+384+64
CNSTI4 2
ASGNI4
line 1459
;1459:		s_serveroptions.playerType[5].curvalue = 2;
ADDRGP4 s_serveroptions+3164+480+64
CNSTI4 2
ASGNI4
line 1461
;1460:
;1461:		Q_strncpyz( s_serveroptions.playerNameBuffers[6], "sarge", 16 );
ADDRGP4 s_serveroptions+6636+96
ARGP4
ADDRGP4 $877
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1462
;1462:		Q_strncpyz( s_serveroptions.playerNameBuffers[7], "grunt", 16 );
ADDRGP4 s_serveroptions+6636+112
ARGP4
ADDRGP4 $856
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1463
;1463:		Q_strncpyz( s_serveroptions.playerNameBuffers[8], "major", 16 );
ADDRGP4 s_serveroptions+6636+128
ARGP4
ADDRGP4 $859
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1464
;1464:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
NEI4 $882
line 1465
;1465:			Q_strncpyz( s_serveroptions.playerNameBuffers[9], "visor", 16 );
ADDRGP4 s_serveroptions+6636+144
ARGP4
ADDRGP4 $865
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1466
;1466:		}
ADDRGP4 $883
JUMPV
LABELV $882
line 1467
;1467:		else {
line 1468
;1468:			s_serveroptions.playerType[9].curvalue = 2;
ADDRGP4 s_serveroptions+3164+864+64
CNSTI4 2
ASGNI4
line 1469
;1469:		}
LABELV $883
line 1470
;1470:		s_serveroptions.playerType[10].curvalue = 2;
ADDRGP4 s_serveroptions+3164+960+64
CNSTI4 2
ASGNI4
line 1471
;1471:		s_serveroptions.playerType[11].curvalue = 2;
ADDRGP4 s_serveroptions+3164+1056+64
CNSTI4 2
ASGNI4
line 1473
;1472:
;1473:		return;
ADDRGP4 $850
JUMPV
LABELV $851
line 1476
;1474:	}
;1475:
;1476:	count = 1;	// skip the first slot, reserved for a human
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1479
;1477:
;1478:	// get info for this map
;1479:	arenaInfo = UI_GetArenaInfoByMap( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6604
ARGP4
ADDRLP4 1048
ADDRGP4 UI_GetArenaInfoByMap
CALLP4
ASGNP4
ADDRLP4 1044
ADDRLP4 1048
INDIRP4
ASGNP4
line 1482
;1480:
;1481:	// get the bot info - we'll seed with them if any are listed
;1482:	Q_strncpyz( bots, Info_ValueForKey( arenaInfo, "bots" ), sizeof(bots) );
ADDRLP4 1044
INDIRP4
ARGP4
ADDRGP4 $897
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
line 1483
;1483:	p = &bots[0];
ADDRLP4 0
ADDRLP4 20
ASGNP4
ADDRGP4 $899
JUMPV
line 1484
;1484:	while( *p && count < PLAYER_SLOTS ) {
LABELV $901
line 1486
;1485:		//skip spaces
;1486:		while( *p && *p == ' ' ) {
line 1487
;1487:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1488
;1488:		}
LABELV $902
line 1486
ADDRLP4 1056
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1056
INDIRI4
CNSTI4 0
EQI4 $904
ADDRLP4 1056
INDIRI4
CNSTI4 32
EQI4 $901
LABELV $904
line 1489
;1489:		if( !p ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $905
line 1490
;1490:			break;
ADDRGP4 $900
JUMPV
LABELV $905
line 1494
;1491:		}
;1492:
;1493:		// mark start of bot name
;1494:		bot = p;
ADDRLP4 8
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $908
JUMPV
LABELV $907
line 1497
;1495:
;1496:		// skip until space of null
;1497:		while( *p && *p != ' ' ) {
line 1498
;1498:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1499
;1499:		}
LABELV $908
line 1497
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $910
ADDRLP4 1060
INDIRI4
CNSTI4 32
NEI4 $907
LABELV $910
line 1500
;1500:		if( *p ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $911
line 1501
;1501:			*p++ = 0;
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
line 1502
;1502:		}
LABELV $911
line 1504
;1503:
;1504:		botInfo = UI_GetBotInfoByName( bot );
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
line 1505
;1505:		bot = Info_ValueForKey( botInfo, "name" );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 $747
ARGP4
ADDRLP4 1068
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1068
INDIRP4
ASGNP4
line 1507
;1506:
;1507:		Q_strncpyz( s_serveroptions.playerNameBuffers[count], bot, sizeof(s_serveroptions.playerNameBuffers[count]) );
ADDRLP4 4
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
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
line 1508
;1508:		count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1509
;1509:	}
LABELV $899
line 1484
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $915
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $902
LABELV $915
LABELV $900
line 1512
;1510:
;1511:	// set the rest of the bot slots to "---"
;1512:	for( n = count; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $919
JUMPV
LABELV $916
line 1513
;1513:		strcpy( s_serveroptions.playerNameBuffers[n], "--------" );
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ARGP4
ADDRGP4 $921
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1514
;1514:	}
LABELV $917
line 1512
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $919
ADDRLP4 12
INDIRI4
CNSTI4 12
LTI4 $916
line 1517
;1515:
;1516:	// pad up to #8 as open slots
;1517:	for( ;count < 8; count++ ) {
ADDRGP4 $925
JUMPV
LABELV $922
line 1518
;1518:		s_serveroptions.playerType[count].curvalue = 0;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
CNSTI4 0
ASGNI4
line 1519
;1519:	}
LABELV $923
line 1517
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $925
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $922
line 1522
;1520:
;1521:	// close off the rest by default
;1522:	for( ;count < PLAYER_SLOTS; count++ ) {
ADDRGP4 $931
JUMPV
LABELV $928
line 1523
;1523:		if( s_serveroptions.playerType[count].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $932
line 1524
;1524:			s_serveroptions.playerType[count].curvalue = 2;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+64
ADDP4
CNSTI4 2
ASGNI4
line 1525
;1525:		}
LABELV $932
line 1526
;1526:	}
LABELV $929
line 1522
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $931
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $928
line 1527
;1527:}
LABELV $850
endproc ServerOptions_InitBotNames 1072 12
bss
align 1
LABELV $939
skip 64
code
proc ServerOptions_SetMenuItems 164 16
line 1535
;1528:
;1529:
;1530:/*
;1531:=================
;1532:ServerOptions_SetMenuItems
;1533:=================
;1534:*/
;1535:static void ServerOptions_SetMenuItems( void ) {
line 1538
;1536:	static char picname[64];
;1537:
;1538:	s_serveroptions.noHealth.curvalue =
ADDRGP4 $942
ARGP4
ADDRLP4 4
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 4
INDIRF4
CNSTF4 0
EQF4 $944
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $945
JUMPV
LABELV $944
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $945
ADDRGP4 s_serveroptions+2580+60
ADDRLP4 0
INDIRI4
ASGNI4
line 1541
;1539:			trap_Cvar_VariableValue( "ui_noHealth" ) != 0;
;1540:
;1541:	s_serveroptions.noArmor.curvalue =
ADDRGP4 $948
ARGP4
ADDRLP4 12
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 12
INDIRF4
CNSTF4 0
EQF4 $950
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $951
JUMPV
LABELV $950
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $951
ADDRGP4 s_serveroptions+2644+60
ADDRLP4 8
INDIRI4
ASGNI4
line 1544
;1542:		trap_Cvar_VariableValue( "ui_noArmor" ) != 0;
;1543:
;1544:	s_serveroptions.noPlasmaBFG.curvalue =
ADDRGP4 $954
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $956
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $957
JUMPV
LABELV $956
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $957
ADDRGP4 s_serveroptions+2836+60
ADDRLP4 16
INDIRI4
ASGNI4
line 1547
;1545:		trap_Cvar_VariableValue( "ui_noPlasmaBFG" ) != 0;
;1546:
;1547:	s_serveroptions.noGrenadeRocket.curvalue =
ADDRGP4 $960
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 0
EQF4 $962
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $963
JUMPV
LABELV $962
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $963
ADDRGP4 s_serveroptions+2900+60
ADDRLP4 24
INDIRI4
ASGNI4
line 1550
;1548:		trap_Cvar_VariableValue( "ui_noGrenadeRocket" ) != 0;
;1549:		
;1550:	s_serveroptions.noRailgun.curvalue =
ADDRGP4 $659
ARGP4
ADDRLP4 36
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
EQF4 $967
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRGP4 $968
JUMPV
LABELV $967
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $968
ADDRGP4 s_serveroptions+2964+60
ADDRLP4 32
INDIRI4
ASGNI4
line 1553
;1551:		trap_Cvar_VariableValue( "ui_noRailgun" ) != 0;
;1552:		
;1553:	s_serveroptions.enableBlaster.curvalue =
ADDRGP4 $644
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 44
INDIRF4
CNSTF4 0
EQF4 $972
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $973
JUMPV
LABELV $972
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $973
ADDRGP4 s_serveroptions+3028+60
ADDRLP4 40
INDIRI4
ASGNI4
line 1556
;1554:		trap_Cvar_VariableValue( "ui_enableBlaster" ) != 0;
;1555:		
;1556:	s_serveroptions.noMegaHealth.curvalue =
ADDRGP4 $589
ARGP4
ADDRLP4 52
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 0
EQF4 $977
ADDRLP4 48
CNSTI4 1
ASGNI4
ADDRGP4 $978
JUMPV
LABELV $977
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $978
ADDRGP4 s_serveroptions+2708+60
ADDRLP4 48
INDIRI4
ASGNI4
line 1559
;1557:		trap_Cvar_VariableValue( "ui_noMegaHealth" ) != 0;
;1558:
;1559:	s_serveroptions.noPersonalTeleporter.curvalue =
ADDRGP4 $598
ARGP4
ADDRLP4 60
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 60
INDIRF4
CNSTF4 0
EQF4 $982
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $983
JUMPV
LABELV $982
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $983
ADDRGP4 s_serveroptions+2772+60
ADDRLP4 56
INDIRI4
ASGNI4
line 1564
;1560:			trap_Cvar_VariableValue(
;1561:				"ui_noPersonalTeleporter"
;1562:			) != 0;
;1563:		
;1564:	s_serveroptions.noPowerups.curvalue =
ADDRGP4 $583
ARGP4
ADDRLP4 68
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
EQF4 $987
ADDRLP4 64
CNSTI4 1
ASGNI4
ADDRGP4 $988
JUMPV
LABELV $987
ADDRLP4 64
CNSTI4 0
ASGNI4
LABELV $988
ADDRGP4 s_serveroptions+2516+60
ADDRLP4 64
INDIRI4
ASGNI4
line 1567
;1565:		trap_Cvar_VariableValue( "ui_noPowerups" ) != 0;
;1566:
;1567:	Com_sprintf(
ADDRGP4 $582
ARGP4
ADDRLP4 72
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1115422720
ARGF4
ADDRLP4 72
INDIRF4
ARGF4
ADDRLP4 76
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+2184+60+12
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 $995
ARGP4
ADDRLP4 76
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1578
;1568:			s_serveroptions.additionalSlots.field.buffer,
;1569:			sizeof( s_serveroptions.additionalSlots.field.buffer ),
;1570:			"%i",
;1571:			(int)Com_Clamp(
;1572:				0,
;1573:				MAX_CLIENTS - 1,
;1574:				trap_Cvar_VariableValue( "ui_additionalSlots" )
;1575:			)
;1576:		);
;1577:
;1578:	switch( s_serveroptions.gametype ) {
ADDRLP4 80
ADDRGP4 s_serveroptions+6600
INDIRI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
LTI4 $996
ADDRLP4 80
INDIRI4
CNSTI4 4
GTI4 $996
ADDRLP4 80
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $1031
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $1031
address $999
address $1006
address $996
address $1013
address $1022
code
LABELV $999
LABELV $996
line 1581
;1579:	case GT_FFA:
;1580:	default:
;1581:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_fraglimit" ) ) );
ADDRGP4 $616
ARGP4
ADDRLP4 84
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 84
INDIRF4
ARGF4
ADDRLP4 88
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+964+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $995
ARGP4
ADDRLP4 88
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1582
;1582:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_timelimit" ) ) );
ADDRGP4 $617
ARGP4
ADDRLP4 92
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1148829696
ARGF4
ADDRLP4 92
INDIRF4
ARGF4
ADDRLP4 96
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+632+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $995
ARGP4
ADDRLP4 96
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1583
;1583:		break;
ADDRGP4 $997
JUMPV
LABELV $1006
line 1586
;1584:
;1585:	case GT_TOURNAMENT:
;1586:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_fraglimit" ) ) );
ADDRGP4 $619
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
ADDRGP4 $995
ARGP4
ADDRLP4 104
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1587
;1587:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_timelimit" ) ) );
ADDRGP4 $620
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
ADDRGP4 $995
ARGP4
ADDRLP4 112
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1588
;1588:		break;
ADDRGP4 $997
JUMPV
LABELV $1013
line 1591
;1589:
;1590:	case GT_TEAM:
;1591:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_fraglimit" ) ) );
ADDRGP4 $622
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
ADDRGP4 $995
ARGP4
ADDRLP4 120
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1592
;1592:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_timelimit" ) ) );
ADDRGP4 $623
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
ADDRGP4 $995
ARGP4
ADDRLP4 128
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1593
;1593:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_team_friendly" ) );
ADDRGP4 $624
ARGP4
ADDRLP4 132
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 132
INDIRF4
ARGF4
ADDRLP4 136
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1628+60
ADDRLP4 136
INDIRF4
CVFI4 4
ASGNI4
line 1594
;1594:		break;
ADDRGP4 $997
JUMPV
LABELV $1022
line 1597
;1595:
;1596:	case GT_CTF:
;1597:		Com_sprintf( s_serveroptions.flaglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 100, trap_Cvar_VariableValue( "ui_ctf_capturelimit" ) ) );
ADDRGP4 $626
ARGP4
ADDRLP4 140
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1120403456
ARGF4
ADDRLP4 140
INDIRF4
ARGF4
ADDRLP4 144
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+1296+60+12
ARGP4
CNSTI4 4
ARGI4
ADDRGP4 $995
ARGP4
ADDRLP4 144
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1598
;1598:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ctf_timelimit" ) ) );
ADDRGP4 $627
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
ADDRGP4 $995
ARGP4
ADDRLP4 152
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1599
;1599:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_ctf_friendly" ) );
ADDRGP4 $628
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
line 1600
;1600:		break;
LABELV $997
line 1603
;1601:	}
;1602:
;1603:	Q_strncpyz( s_serveroptions.hostname.field.buffer, UI_Cvar_VariableString( "sv_hostname" ), sizeof( s_serveroptions.hostname.field.buffer ) );
ADDRGP4 $637
ARGP4
ADDRLP4 84
ADDRGP4 UI_Cvar_VariableString
CALLP4
ASGNP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRLP4 84
INDIRP4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1604
;1604:	s_serveroptions.pure.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_pure" ) );
ADDRGP4 $636
ARGP4
ADDRLP4 88
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 88
INDIRF4
ARGF4
ADDRLP4 92
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_serveroptions+2024+60
ADDRLP4 92
INDIRF4
CVFI4 4
ASGNI4
line 1607
;1605:
;1606:	// set the map pic
;1607:	Com_sprintf( picname, 64, "levelshots/%s", s_startserver.maplist[s_startserver.currentmap] );
ADDRGP4 $939
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $107
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
line 1608
;1608:	s_serveroptions.mappic.generic.name = picname;
ADDRGP4 s_serveroptions+360+4
ADDRGP4 $939
ASGNP4
line 1611
;1609:
;1610:	// set the map name
;1611:	strcpy( s_serveroptions.mapnamebuffer, s_startserver.mapname.string );
ADDRGP4 s_serveroptions+6604
ARGP4
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1612
;1612:	Q_strupr( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6604
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 1615
;1613:
;1614:	// get the player selections initialized
;1615:	ServerOptions_InitPlayerItems();
ADDRGP4 ServerOptions_InitPlayerItems
CALLV
pop
line 1616
;1616:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1619
;1617:
;1618:	// seed bot names
;1619:	ServerOptions_InitBotNames();
ADDRGP4 ServerOptions_InitBotNames
CALLV
pop
line 1620
;1620:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1621
;1621:}
LABELV $938
endproc ServerOptions_SetMenuItems 164 16
proc PlayerName_Draw 48 20
line 1628
;1622:
;1623:/*
;1624:=================
;1625:PlayerName_Draw
;1626:=================
;1627:*/
;1628:static void PlayerName_Draw( void *item ) {
line 1635
;1629:	menutext_s	*s;
;1630:	float		*color;
;1631:	int			x, y;
;1632:	int			style;
;1633:	qboolean	focus;
;1634:
;1635:	s = (menutext_s *)item;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1637
;1636:
;1637:	x = s->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1638
;1638:	y =	s->generic.y;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 1640
;1639:
;1640:	style = UI_SMALLFONT;
ADDRLP4 16
CNSTI4 16
ASGNI4
line 1641
;1641:	focus = (s->generic.parent->cursor == s->generic.menuPosition);
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
NEI4 $1050
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1051
JUMPV
LABELV $1050
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1051
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 1643
;1642:
;1643:	if ( s->generic.flags & QMF_GRAYED )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $1052
line 1644
;1644:		color = text_color_disabled;
ADDRLP4 4
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $1053
JUMPV
LABELV $1052
line 1645
;1645:	else if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1054
line 1646
;1646:	{
line 1647
;1647:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1648
;1648:		style |= UI_PULSE;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 1649
;1649:	}
ADDRGP4 $1055
JUMPV
LABELV $1054
line 1650
;1650:	else if ( s->generic.flags & QMF_BLINK )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $1056
line 1651
;1651:	{
line 1652
;1652:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1653
;1653:		style |= UI_BLINK;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1654
;1654:	}
ADDRGP4 $1057
JUMPV
LABELV $1056
line 1656
;1655:	else
;1656:		color = text_color_normal;
ADDRLP4 4
ADDRGP4 text_color_normal
ASGNP4
LABELV $1057
LABELV $1055
LABELV $1053
line 1658
;1657:
;1658:	if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1058
line 1659
;1659:	{
line 1661
;1660:		// draw cursor
;1661:		UI_FillRect( s->generic.left, s->generic.top, s->generic.right-s->generic.left+1, s->generic.bottom-s->generic.top+1, listbar_color ); 
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
line 1662
;1662:		UI_DrawChar( x, y, 13, UI_CENTER|UI_BLINK|UI_SMALLFONT, color);
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
line 1663
;1663:	}
LABELV $1058
line 1665
;1664:
;1665:	UI_DrawString( x - SMALLCHAR_WIDTH, y, s->generic.name, style|UI_RIGHT, color );
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
line 1666
;1666:	UI_DrawString( x + SMALLCHAR_WIDTH, y, s->string, style|UI_LEFT, color );
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
line 1667
;1667:}
LABELV $1048
endproc PlayerName_Draw 48 20
proc ServerOptions_MenuInit 52 12
line 1677
;1668:
;1669:
;1670:/*
;1671:=================
;1672:ServerOptions_MenuInit
;1673:=================
;1674:*/
;1675:#define OPTIONS_X	456
;1676:
;1677:static void ServerOptions_MenuInit( qboolean multiplayer ) {
line 1681
;1678:	int		y;
;1679:	int		n;
;1680:
;1681:	memset( &s_serveroptions, 0 ,sizeof(serveroptions_t) );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 0
ARGI4
CNSTI4 6948
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1682
;1682:	s_serveroptions.multiplayer = multiplayer;
ADDRGP4 s_serveroptions+6596
ADDRFP4 0
INDIRI4
ASGNI4
line 1683
;1683:	s_serveroptions.gametype = (int)Com_Clamp( 0, 5, trap_Cvar_VariableValue( "g_gameType" ) );
ADDRGP4 $215
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
ADDRGP4 s_serveroptions+6600
ADDRLP4 12
INDIRF4
CVFI4 4
ASGNI4
line 1684
;1684:	s_serveroptions.punkbuster.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_punkbuster" ) );
ADDRGP4 $641
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
ADDRGP4 s_serveroptions+6852+64
ADDRLP4 20
INDIRF4
CVFI4 4
ASGNI4
line 1686
;1685:
;1686:	ServerOptions_Cache();
ADDRGP4 ServerOptions_Cache
CALLV
pop
line 1688
;1687:
;1688:	s_serveroptions.menu.wrapAround = qtrue;
ADDRGP4 s_serveroptions+276
CNSTI4 1
ASGNI4
line 1689
;1689:	s_serveroptions.menu.fullscreen = qtrue;
ADDRGP4 s_serveroptions+280
CNSTI4 1
ASGNI4
line 1691
;1690:
;1691:	s_serveroptions.banner.generic.type			= MTYPE_BTEXT;
ADDRGP4 s_serveroptions+288
CNSTI4 10
ASGNI4
line 1692
;1692:	s_serveroptions.banner.generic.x			= 320;
ADDRGP4 s_serveroptions+288+12
CNSTI4 320
ASGNI4
line 1693
;1693:	s_serveroptions.banner.generic.y			= 16;
ADDRGP4 s_serveroptions+288+16
CNSTI4 16
ASGNI4
line 1694
;1694:	s_serveroptions.banner.string  				= "GAME SERVER";
ADDRGP4 s_serveroptions+288+60
ADDRGP4 $263
ASGNP4
line 1695
;1695:	s_serveroptions.banner.color  				= color_white;
ADDRGP4 s_serveroptions+288+68
ADDRGP4 color_white
ASGNP4
line 1696
;1696:	s_serveroptions.banner.style  				= UI_CENTER;
ADDRGP4 s_serveroptions+288+64
CNSTI4 1
ASGNI4
line 1698
;1697:
;1698:	s_serveroptions.mappic.generic.type			= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+360
CNSTI4 6
ASGNI4
line 1699
;1699:	s_serveroptions.mappic.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_serveroptions+360+44
CNSTU4 16388
ASGNU4
line 1700
;1700:	s_serveroptions.mappic.generic.x			= 352;
ADDRGP4 s_serveroptions+360+12
CNSTI4 352
ASGNI4
line 1701
;1701:	s_serveroptions.mappic.generic.y			= 80;
ADDRGP4 s_serveroptions+360+16
CNSTI4 80
ASGNI4
line 1702
;1702:	s_serveroptions.mappic.width				= 160;
ADDRGP4 s_serveroptions+360+76
CNSTI4 160
ASGNI4
line 1703
;1703:	s_serveroptions.mappic.height				= 120;
ADDRGP4 s_serveroptions+360+80
CNSTI4 120
ASGNI4
line 1704
;1704:	s_serveroptions.mappic.errorpic				= GAMESERVER_UNKNOWNMAP;
ADDRGP4 s_serveroptions+360+64
ADDRGP4 $334
ASGNP4
line 1705
;1705:	s_serveroptions.mappic.generic.ownerdraw	= ServerOptions_LevelshotDraw;
ADDRGP4 s_serveroptions+360+56
ADDRGP4 ServerOptions_LevelshotDraw
ASGNP4
line 1707
;1706:
;1707:	s_serveroptions.picframe.generic.type		= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+448
CNSTI4 6
ASGNI4
line 1708
;1708:	s_serveroptions.picframe.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE|QMF_HIGHLIGHT;
ADDRGP4 s_serveroptions+448+44
CNSTU4 16452
ASGNU4
line 1709
;1709:	s_serveroptions.picframe.generic.x			= 352 - 38;
ADDRGP4 s_serveroptions+448+12
CNSTI4 314
ASGNI4
line 1710
;1710:	s_serveroptions.picframe.generic.y			= 80 - 40;
ADDRGP4 s_serveroptions+448+16
CNSTI4 40
ASGNI4
line 1711
;1711:	s_serveroptions.picframe.width  			= 320;
ADDRGP4 s_serveroptions+448+76
CNSTI4 320
ASGNI4
line 1712
;1712:	s_serveroptions.picframe.height  			= 320;
ADDRGP4 s_serveroptions+448+80
CNSTI4 320
ASGNI4
line 1713
;1713:	s_serveroptions.picframe.focuspic			= GAMESERVER_SELECT;
ADDRGP4 s_serveroptions+448+60
ADDRGP4 $362
ASGNP4
line 1715
;1714:
;1715:	y = 282;
ADDRLP4 4
CNSTI4 282
ASGNI4
line 1716
;1716:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 4
EQI4 $1106
line 1717
;1717:		s_serveroptions.fraglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+964
CNSTI4 4
ASGNI4
line 1718
;1718:		s_serveroptions.fraglimit.generic.name       = "Frag Limit:";
ADDRGP4 s_serveroptions+964+4
ADDRGP4 $1112
ASGNP4
line 1719
;1719:		s_serveroptions.fraglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+964+44
CNSTU4 290
ASGNU4
line 1720
;1720:		s_serveroptions.fraglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+964+12
CNSTI4 456
ASGNI4
line 1721
;1721:		s_serveroptions.fraglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1722
;1722:		s_serveroptions.fraglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+964+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1723
;1723:		s_serveroptions.fraglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+964+60+8
CNSTI4 3
ASGNI4
line 1724
;1724:		s_serveroptions.fraglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+964+60+268
CNSTI4 3
ASGNI4
line 1725
;1725:	}
ADDRGP4 $1107
JUMPV
LABELV $1106
line 1726
;1726:	else {
line 1727
;1727:		s_serveroptions.flaglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1296
CNSTI4 4
ASGNI4
line 1728
;1728:		s_serveroptions.flaglimit.generic.name       = "Capture Limit:";
ADDRGP4 s_serveroptions+1296+4
ADDRGP4 $1130
ASGNP4
line 1729
;1729:		s_serveroptions.flaglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1296+44
CNSTU4 290
ASGNU4
line 1730
;1730:		s_serveroptions.flaglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+1296+12
CNSTI4 456
ASGNI4
line 1731
;1731:		s_serveroptions.flaglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+1296+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1732
;1732:		s_serveroptions.flaglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+1296+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1733
;1733:		s_serveroptions.flaglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+1296+60+8
CNSTI4 3
ASGNI4
line 1734
;1734:		s_serveroptions.flaglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+1296+60+268
CNSTI4 3
ASGNI4
line 1735
;1735:	}
LABELV $1107
line 1737
;1736:
;1737:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1738
;1738:	s_serveroptions.timelimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+632
CNSTI4 4
ASGNI4
line 1739
;1739:	s_serveroptions.timelimit.generic.name       = "Time Limit:";
ADDRGP4 s_serveroptions+632+4
ADDRGP4 $1148
ASGNP4
line 1740
;1740:	s_serveroptions.timelimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+632+44
CNSTU4 290
ASGNU4
line 1741
;1741:	s_serveroptions.timelimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+632+12
CNSTI4 456
ASGNI4
line 1742
;1742:	s_serveroptions.timelimit.generic.y	         = y;
ADDRGP4 s_serveroptions+632+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1743
;1743:	s_serveroptions.timelimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+632+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1744
;1744:	s_serveroptions.timelimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+632+60+8
CNSTI4 3
ASGNI4
line 1745
;1745:	s_serveroptions.timelimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+632+60+268
CNSTI4 3
ASGNI4
line 1747
;1746:
;1747:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $1163
line 1748
;1748:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1749
;1749:		s_serveroptions.friendlyfire.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+1628
CNSTI4 5
ASGNI4
line 1750
;1750:		s_serveroptions.friendlyfire.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1628+44
CNSTU4 258
ASGNU4
line 1751
;1751:		s_serveroptions.friendlyfire.generic.x	      = OPTIONS_X;
ADDRGP4 s_serveroptions+1628+12
CNSTI4 456
ASGNI4
line 1752
;1752:		s_serveroptions.friendlyfire.generic.y	      = y;
ADDRGP4 s_serveroptions+1628+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1753
;1753:		s_serveroptions.friendlyfire.generic.name	  = "Friendly Fire:";
ADDRGP4 s_serveroptions+1628+4
ADDRGP4 $1175
ASGNP4
line 1754
;1754:	}
LABELV $1163
line 1756
;1755:
;1756:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1757
;1757:	s_serveroptions.pure.generic.type			= MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2024
CNSTI4 5
ASGNI4
line 1758
;1758:	s_serveroptions.pure.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2024+44
CNSTU4 258
ASGNU4
line 1759
;1759:	s_serveroptions.pure.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+2024+12
CNSTI4 456
ASGNI4
line 1760
;1760:	s_serveroptions.pure.generic.y				= y;
ADDRGP4 s_serveroptions+2024+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1761
;1761:	s_serveroptions.pure.generic.name			= "Pure Server:";
ADDRGP4 s_serveroptions+2024+4
ADDRGP4 $1185
ASGNP4
line 1763
;1762:
;1763:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6596
INDIRI4
CNSTI4 0
EQI4 $1186
line 1764
;1764:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1765
;1765:		s_serveroptions.dedicated.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+536
CNSTI4 3
ASGNI4
line 1766
;1766:		s_serveroptions.dedicated.generic.id		= ID_DEDICATED;
ADDRGP4 s_serveroptions+536+8
CNSTI4 22
ASGNI4
line 1767
;1767:		s_serveroptions.dedicated.generic.flags		= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+536+44
CNSTU4 258
ASGNU4
line 1768
;1768:		s_serveroptions.dedicated.generic.callback	= ServerOptions_Event;
ADDRGP4 s_serveroptions+536+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 1769
;1769:		s_serveroptions.dedicated.generic.x			= OPTIONS_X;
ADDRGP4 s_serveroptions+536+12
CNSTI4 456
ASGNI4
line 1770
;1770:		s_serveroptions.dedicated.generic.y			= y;
ADDRGP4 s_serveroptions+536+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1771
;1771:		s_serveroptions.dedicated.generic.name		= "Dedicated:";
ADDRGP4 s_serveroptions+536+4
ADDRGP4 $1202
ASGNP4
line 1772
;1772:		s_serveroptions.dedicated.itemnames			= dedicated_list;
ADDRGP4 s_serveroptions+536+76
ADDRGP4 dedicated_list
ASGNP4
line 1773
;1773:	}
LABELV $1186
line 1775
;1774:
;1775:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6596
INDIRI4
CNSTI4 0
EQI4 $1205
line 1776
;1776:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1777
;1777:		s_serveroptions.hostname.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1692
CNSTI4 4
ASGNI4
line 1778
;1778:		s_serveroptions.hostname.generic.name       = "Hostname:";
ADDRGP4 s_serveroptions+1692+4
ADDRGP4 $1211
ASGNP4
line 1779
;1779:		s_serveroptions.hostname.generic.flags      = QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1692+44
CNSTU4 2
ASGNU4
line 1780
;1780:		s_serveroptions.hostname.generic.x          = OPTIONS_X;
ADDRGP4 s_serveroptions+1692+12
CNSTI4 456
ASGNI4
line 1781
;1781:		s_serveroptions.hostname.generic.y	        = y;
ADDRGP4 s_serveroptions+1692+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1782
;1782:		s_serveroptions.hostname.field.widthInChars = 18;
ADDRGP4 s_serveroptions+1692+60+8
CNSTI4 18
ASGNI4
line 1783
;1783:		s_serveroptions.hostname.field.maxchars     = 64;
ADDRGP4 s_serveroptions+1692+60+268
CNSTI4 64
ASGNI4
line 1784
;1784:	}
LABELV $1205
line 1786
;1785:
;1786:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1787
;1787:	s_serveroptions.punkbuster.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+6852
CNSTI4 3
ASGNI4
line 1788
;1788:	s_serveroptions.punkbuster.generic.name			= "Punkbuster:";
ADDRGP4 s_serveroptions+6852+4
ADDRGP4 $1227
ASGNP4
line 1789
;1789:	s_serveroptions.punkbuster.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+6852+44
CNSTU4 258
ASGNU4
line 1790
;1790:	s_serveroptions.punkbuster.generic.id			= 0;
ADDRGP4 s_serveroptions+6852+8
CNSTI4 0
ASGNI4
line 1791
;1791:	s_serveroptions.punkbuster.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+6852+12
CNSTI4 456
ASGNI4
line 1792
;1792:	s_serveroptions.punkbuster.generic.y				= y;
ADDRGP4 s_serveroptions+6852+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1793
;1793:	s_serveroptions.punkbuster.itemnames				= punkbuster_items;
ADDRGP4 s_serveroptions+6852+76
ADDRGP4 punkbuster_items
ASGNP4
line 1795
;1794:	
;1795:	y = 90;
ADDRLP4 4
CNSTI4 90
ASGNI4
line 1796
;1796:	s_serveroptions.botSkill.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+2088
CNSTI4 3
ASGNI4
line 1797
;1797:	s_serveroptions.botSkill.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2088+44
CNSTU4 258
ASGNU4
line 1798
;1798:	s_serveroptions.botSkill.generic.name			= "Bot Skill:  ";
ADDRGP4 s_serveroptions+2088+4
ADDRGP4 $1243
ASGNP4
line 1799
;1799:	s_serveroptions.botSkill.generic.x				= 32 + (strlen(s_serveroptions.botSkill.generic.name) + 2 ) * SMALLCHAR_WIDTH;
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
line 1800
;1800:	s_serveroptions.botSkill.generic.y				= y;
ADDRGP4 s_serveroptions+2088+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1801
;1801:	s_serveroptions.botSkill.itemnames				= botSkill_list;
ADDRGP4 s_serveroptions+2088+76
ADDRGP4 botSkill_list
ASGNP4
line 1802
;1802:	s_serveroptions.botSkill.curvalue				= 1;
ADDRGP4 s_serveroptions+2088+64
CNSTI4 1
ASGNI4
line 1804
;1803:
;1804:	y += ( 2 * SMALLCHAR_HEIGHT );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 1805
;1805:	s_serveroptions.player0.generic.type			= MTYPE_TEXT;
ADDRGP4 s_serveroptions+3092
CNSTI4 7
ASGNI4
line 1806
;1806:	s_serveroptions.player0.generic.flags			= QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3092+44
CNSTU4 2
ASGNU4
line 1807
;1807:	s_serveroptions.player0.generic.x				= 32 + SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+3092+12
CNSTI4 40
ASGNI4
line 1808
;1808:	s_serveroptions.player0.generic.y				= y;
ADDRGP4 s_serveroptions+3092+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1809
;1809:	s_serveroptions.player0.color					= color_orange;
ADDRGP4 s_serveroptions+3092+68
ADDRGP4 color_orange
ASGNP4
line 1810
;1810:	s_serveroptions.player0.style					= UI_LEFT|UI_SMALLFONT;
ADDRGP4 s_serveroptions+3092+64
CNSTI4 16
ASGNI4
line 1812
;1811:
;1812:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1265
line 1813
;1813:		s_serveroptions.playerType[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164
ADDP4
CNSTI4 3
ASGNI4
line 1814
;1814:		s_serveroptions.playerType[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+44
ADDP4
CNSTU4 2
ASGNU4
line 1815
;1815:		s_serveroptions.playerType[n].generic.id		= ID_PLAYER_TYPE;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+8
ADDP4
CNSTI4 20
ASGNI4
line 1816
;1816:		s_serveroptions.playerType[n].generic.callback	= ServerOptions_Event;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+48
ADDP4
ADDRGP4 ServerOptions_Event
ASGNP4
line 1817
;1817:		s_serveroptions.playerType[n].generic.x			= 32;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+12
ADDP4
CNSTI4 32
ASGNI4
line 1818
;1818:		s_serveroptions.playerType[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1819
;1819:		s_serveroptions.playerType[n].itemnames			= playerType_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164+76
ADDP4
ADDRGP4 playerType_list
ASGNP4
line 1821
;1820:
;1821:		s_serveroptions.playerName[n].generic.type		= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316
ADDP4
CNSTI4 7
ASGNI4
line 1822
;1822:		s_serveroptions.playerName[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+44
ADDP4
CNSTU4 2
ASGNU4
line 1823
;1823:		s_serveroptions.playerName[n].generic.x			= 96;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+12
ADDP4
CNSTI4 96
ASGNI4
line 1824
;1824:		s_serveroptions.playerName[n].generic.y			= y;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1825
;1825:		s_serveroptions.playerName[n].generic.callback	= ServerOptions_PlayerNameEvent;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+48
ADDP4
ADDRGP4 ServerOptions_PlayerNameEvent
ASGNP4
line 1826
;1826:		s_serveroptions.playerName[n].generic.id		= n;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1827
;1827:		s_serveroptions.playerName[n].generic.ownerdraw	= PlayerName_Draw;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+56
ADDP4
ADDRGP4 PlayerName_Draw
ASGNP4
line 1828
;1828:		s_serveroptions.playerName[n].color				= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 1829
;1829:		s_serveroptions.playerName[n].style				= UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+64
ADDP4
CNSTI4 16
ASGNI4
line 1830
;1830:		s_serveroptions.playerName[n].string			= s_serveroptions.playerNameBuffers[n];
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316+60
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6636
ADDP4
ASGNP4
line 1831
;1831:		s_serveroptions.playerName[n].generic.top		= s_serveroptions.playerName[n].generic.y;
ADDRLP4 36
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4316+24
ADDP4
ADDRLP4 36
INDIRI4
ADDRGP4 s_serveroptions+4316+16
ADDP4
INDIRI4
ASGNI4
line 1832
;1832:		s_serveroptions.playerName[n].generic.bottom	= s_serveroptions.playerName[n].generic.y + SMALLCHAR_HEIGHT;
ADDRLP4 40
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4316+32
ADDP4
ADDRLP4 40
INDIRI4
ADDRGP4 s_serveroptions+4316+16
ADDP4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1833
;1833:		s_serveroptions.playerName[n].generic.left		= s_serveroptions.playerName[n].generic.x - SMALLCHAR_HEIGHT/ 2;
ADDRLP4 44
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4316+20
ADDP4
ADDRLP4 44
INDIRI4
ADDRGP4 s_serveroptions+4316+12
ADDP4
INDIRI4
CNSTI4 8
SUBI4
ASGNI4
line 1834
;1834:		s_serveroptions.playerName[n].generic.right		= s_serveroptions.playerName[n].generic.x + 16 * SMALLCHAR_WIDTH;
ADDRLP4 48
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 48
INDIRI4
ADDRGP4 s_serveroptions+4316+28
ADDP4
ADDRLP4 48
INDIRI4
ADDRGP4 s_serveroptions+4316+12
ADDP4
INDIRI4
CNSTI4 128
ADDI4
ASGNI4
line 1836
;1835:
;1836:		s_serveroptions.playerTeam[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180
ADDP4
CNSTI4 3
ASGNI4
line 1837
;1837:		s_serveroptions.playerTeam[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+44
ADDP4
CNSTU4 2
ASGNU4
line 1838
;1838:		s_serveroptions.playerTeam[n].generic.x			= 240;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+12
ADDP4
CNSTI4 240
ASGNI4
line 1839
;1839:		s_serveroptions.playerTeam[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1840
;1840:		s_serveroptions.playerTeam[n].itemnames			= playerTeam_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180+76
ADDP4
ADDRGP4 playerTeam_list
ASGNP4
line 1842
;1841:
;1842:		y += ( SMALLCHAR_HEIGHT + 4 );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
line 1843
;1843:	}
LABELV $1266
line 1812
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1265
line 1845
;1844:
;1845:	s_serveroptions.additionalSlots.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+2184
CNSTI4 4
ASGNI4
line 1846
;1846:	s_serveroptions.additionalSlots.generic.name       = "Additional Slots:";
ADDRGP4 s_serveroptions+2184+4
ADDRGP4 $1330
ASGNP4
line 1847
;1847:	s_serveroptions.additionalSlots.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2184+44
CNSTU4 290
ASGNU4
line 1848
;1848:	s_serveroptions.additionalSlots.generic.id         = ID_MAXCLIENTS;
ADDRGP4 s_serveroptions+2184+8
CNSTI4 21
ASGNI4
line 1849
;1849:	s_serveroptions.additionalSlots.generic.x          = 240;
ADDRGP4 s_serveroptions+2184+12
CNSTI4 240
ASGNI4
line 1850
;1850:	s_serveroptions.additionalSlots.generic.y          = y;
ADDRGP4 s_serveroptions+2184+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1851
;1851:	s_serveroptions.additionalSlots.field.widthInChars = 2;
ADDRGP4 s_serveroptions+2184+60+8
CNSTI4 2
ASGNI4
line 1852
;1852:	s_serveroptions.additionalSlots.field.maxchars     = 2;
ADDRGP4 s_serveroptions+2184+60+268
CNSTI4 2
ASGNI4
line 1854
;1853:	
;1854:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1855
;1855:	s_serveroptions.noPowerups.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2516
CNSTI4 5
ASGNI4
line 1856
;1856:	s_serveroptions.noPowerups.generic.name     = "No Powerups:";
ADDRGP4 s_serveroptions+2516+4
ADDRGP4 $1348
ASGNP4
line 1857
;1857:	s_serveroptions.noPowerups.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2516+44
CNSTU4 258
ASGNU4
line 1858
;1858:	s_serveroptions.noPowerups.generic.x        = 240;
ADDRGP4 s_serveroptions+2516+12
CNSTI4 240
ASGNI4
line 1859
;1859:	s_serveroptions.noPowerups.generic.y        = y;
ADDRGP4 s_serveroptions+2516+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1861
;1860:	
;1861:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1862
;1862:	s_serveroptions.noHealth.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2580
CNSTI4 5
ASGNI4
line 1863
;1863:	s_serveroptions.noHealth.generic.name = "No Health:";
ADDRGP4 s_serveroptions+2580+4
ADDRGP4 $1358
ASGNP4
line 1864
;1864:	s_serveroptions.noHealth.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2580+44
CNSTU4 258
ASGNU4
line 1865
;1865:	s_serveroptions.noHealth.generic.x = 240;
ADDRGP4 s_serveroptions+2580+12
CNSTI4 240
ASGNI4
line 1866
;1866:	s_serveroptions.noHealth.generic.y = y;
ADDRGP4 s_serveroptions+2580+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1868
;1867:
;1868:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1869
;1869:	s_serveroptions.noArmor.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2644
CNSTI4 5
ASGNI4
line 1870
;1870:	s_serveroptions.noArmor.generic.name = "No Armor:";
ADDRGP4 s_serveroptions+2644+4
ADDRGP4 $1368
ASGNP4
line 1871
;1871:	s_serveroptions.noArmor.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2644+44
CNSTU4 258
ASGNU4
line 1872
;1872:	s_serveroptions.noArmor.generic.x = 240;
ADDRGP4 s_serveroptions+2644+12
CNSTI4 240
ASGNI4
line 1873
;1873:	s_serveroptions.noArmor.generic.y = y;
ADDRGP4 s_serveroptions+2644+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1875
;1874:	
;1875:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1877
;1876:
;1877:	s_serveroptions.noMegaHealth.generic.type  = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2708
CNSTI4 5
ASGNI4
line 1878
;1878:	s_serveroptions.noMegaHealth.generic.name  = "No Mega / Medkit:";
ADDRGP4 s_serveroptions+2708+4
ADDRGP4 $1378
ASGNP4
line 1879
;1879:	s_serveroptions.noMegaHealth.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2708+44
CNSTU4 258
ASGNU4
line 1880
;1880:	s_serveroptions.noMegaHealth.generic.x     = 240;
ADDRGP4 s_serveroptions+2708+12
CNSTI4 240
ASGNI4
line 1881
;1881:	s_serveroptions.noMegaHealth.generic.y     = y;
ADDRGP4 s_serveroptions+2708+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1883
;1882:
;1883:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1884
;1884:	s_serveroptions.noPersonalTeleporter.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2772
CNSTI4 5
ASGNI4
line 1885
;1885:	s_serveroptions.noPersonalTeleporter.generic.name = "No Personal TP:";
ADDRGP4 s_serveroptions+2772+4
ADDRGP4 $1388
ASGNP4
line 1886
;1886:	s_serveroptions.noPersonalTeleporter.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2772+44
CNSTU4 258
ASGNU4
line 1887
;1887:	s_serveroptions.noPersonalTeleporter.generic.x = 240;
ADDRGP4 s_serveroptions+2772+12
CNSTI4 240
ASGNI4
line 1888
;1888:	s_serveroptions.noPersonalTeleporter.generic.y = y;
ADDRGP4 s_serveroptions+2772+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1890
;1889:	
;1890:	y=350;
ADDRLP4 4
CNSTI4 350
ASGNI4
line 1891
;1891:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1892
;1892:	s_serveroptions.noPlasmaBFG.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2836
CNSTI4 5
ASGNI4
line 1893
;1893:	s_serveroptions.noPlasmaBFG.generic.name = "No Energy Guns:";
ADDRGP4 s_serveroptions+2836+4
ADDRGP4 $1398
ASGNP4
line 1894
;1894:	s_serveroptions.noPlasmaBFG.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2836+44
CNSTU4 258
ASGNU4
line 1895
;1895:	s_serveroptions.noPlasmaBFG.generic.x = 440;
ADDRGP4 s_serveroptions+2836+12
CNSTI4 440
ASGNI4
line 1896
;1896:	s_serveroptions.noPlasmaBFG.generic.y = y;
ADDRGP4 s_serveroptions+2836+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1898
;1897:
;1898:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1899
;1899:	s_serveroptions.noGrenadeRocket.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2900
CNSTI4 5
ASGNI4
line 1900
;1900:	s_serveroptions.noGrenadeRocket.generic.name = "No Explosives:";
ADDRGP4 s_serveroptions+2900+4
ADDRGP4 $1408
ASGNP4
line 1901
;1901:	s_serveroptions.noGrenadeRocket.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2900+44
CNSTU4 258
ASGNU4
line 1902
;1902:	s_serveroptions.noGrenadeRocket.generic.x = 440;
ADDRGP4 s_serveroptions+2900+12
CNSTI4 440
ASGNI4
line 1903
;1903:	s_serveroptions.noGrenadeRocket.generic.y = y;
ADDRGP4 s_serveroptions+2900+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1905
;1904:	
;1905:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1906
;1906:	s_serveroptions.noRailgun.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2964
CNSTI4 5
ASGNI4
line 1907
;1907:	s_serveroptions.noRailgun.generic.name = "No Railgun:";
ADDRGP4 s_serveroptions+2964+4
ADDRGP4 $1418
ASGNP4
line 1908
;1908:	s_serveroptions.noRailgun.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2964+44
CNSTU4 258
ASGNU4
line 1909
;1909:	s_serveroptions.noRailgun.generic.x = 440;
ADDRGP4 s_serveroptions+2964+12
CNSTI4 440
ASGNI4
line 1910
;1910:	s_serveroptions.noRailgun.generic.y = y;
ADDRGP4 s_serveroptions+2964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1912
;1911:	
;1912:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1913
;1913:	s_serveroptions.enableBlaster.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+3028
CNSTI4 5
ASGNI4
line 1914
;1914:	s_serveroptions.enableBlaster.generic.name = "Enable Blaster:";
ADDRGP4 s_serveroptions+3028+4
ADDRGP4 $1428
ASGNP4
line 1915
;1915:	s_serveroptions.enableBlaster.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3028+44
CNSTU4 258
ASGNU4
line 1916
;1916:	s_serveroptions.enableBlaster.generic.x = 440;
ADDRGP4 s_serveroptions+3028+12
CNSTI4 440
ASGNI4
line 1917
;1917:	s_serveroptions.enableBlaster.generic.y = y;
ADDRGP4 s_serveroptions+3028+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1919
;1918:
;1919:	s_serveroptions.back.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6508
CNSTI4 6
ASGNI4
line 1920
;1920:	s_serveroptions.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_serveroptions+6508+4
ADDRGP4 $429
ASGNP4
line 1921
;1921:	s_serveroptions.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6508+44
CNSTU4 260
ASGNU4
line 1922
;1922:	s_serveroptions.back.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6508+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 1923
;1923:	s_serveroptions.back.generic.id	      = ID_BACK;
ADDRGP4 s_serveroptions+6508+8
CNSTI4 24
ASGNI4
line 1924
;1924:	s_serveroptions.back.generic.x		  = 0;
ADDRGP4 s_serveroptions+6508+12
CNSTI4 0
ASGNI4
line 1925
;1925:	s_serveroptions.back.generic.y		  = 480-64;
ADDRGP4 s_serveroptions+6508+16
CNSTI4 416
ASGNI4
line 1926
;1926:	s_serveroptions.back.width  		  = 128;
ADDRGP4 s_serveroptions+6508+76
CNSTI4 128
ASGNI4
line 1927
;1927:	s_serveroptions.back.height  		  = 64;
ADDRGP4 s_serveroptions+6508+80
CNSTI4 64
ASGNI4
line 1928
;1928:	s_serveroptions.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_serveroptions+6508+60
ADDRGP4 $446
ASGNP4
line 1930
;1929:
;1930:	s_serveroptions.next.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6420
CNSTI4 6
ASGNI4
line 1931
;1931:	s_serveroptions.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_serveroptions+6420+4
ADDRGP4 $450
ASGNP4
line 1932
;1932:	s_serveroptions.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_INACTIVE|QMF_GRAYED|QMF_HIDDEN;
ADDRGP4 s_serveroptions+6420+44
CNSTU4 28944
ASGNU4
line 1933
;1933:	s_serveroptions.next.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6420+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 1934
;1934:	s_serveroptions.next.generic.id	      = ID_STARTSERVERNEXT;
ADDRGP4 s_serveroptions+6420+8
CNSTI4 18
ASGNI4
line 1935
;1935:	s_serveroptions.next.generic.x		  = 640;
ADDRGP4 s_serveroptions+6420+12
CNSTI4 640
ASGNI4
line 1936
;1936:	s_serveroptions.next.generic.y		  = 480-64-72;
ADDRGP4 s_serveroptions+6420+16
CNSTI4 344
ASGNI4
line 1937
;1937:	s_serveroptions.next.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+6420+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1938
;1938:	s_serveroptions.next.width  		  = 128;
ADDRGP4 s_serveroptions+6420+76
CNSTI4 128
ASGNI4
line 1939
;1939:	s_serveroptions.next.height  		  = 64;
ADDRGP4 s_serveroptions+6420+80
CNSTI4 64
ASGNI4
line 1940
;1940:	s_serveroptions.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_serveroptions+6420+60
ADDRGP4 $467
ASGNP4
line 1942
;1941:
;1942:	s_serveroptions.go.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6332
CNSTI4 6
ASGNI4
line 1943
;1943:	s_serveroptions.go.generic.name     = GAMESERVER_FIGHT0;
ADDRGP4 s_serveroptions+6332+4
ADDRGP4 $1478
ASGNP4
line 1944
;1944:	s_serveroptions.go.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6332+44
CNSTU4 272
ASGNU4
line 1945
;1945:	s_serveroptions.go.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6332+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 1946
;1946:	s_serveroptions.go.generic.id	    = ID_GO;
ADDRGP4 s_serveroptions+6332+8
CNSTI4 23
ASGNI4
line 1947
;1947:	s_serveroptions.go.generic.x		= 640;
ADDRGP4 s_serveroptions+6332+12
CNSTI4 640
ASGNI4
line 1948
;1948:	s_serveroptions.go.generic.y		= 480-64;
ADDRGP4 s_serveroptions+6332+16
CNSTI4 416
ASGNI4
line 1949
;1949:	s_serveroptions.go.width  		    = 128;
ADDRGP4 s_serveroptions+6332+76
CNSTI4 128
ASGNI4
line 1950
;1950:	s_serveroptions.go.height  		    = 64;
ADDRGP4 s_serveroptions+6332+80
CNSTI4 64
ASGNI4
line 1951
;1951:	s_serveroptions.go.focuspic         = GAMESERVER_FIGHT1;
ADDRGP4 s_serveroptions+6332+60
ADDRGP4 $1495
ASGNP4
line 1953
;1952:
;1953:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.banner );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1954
;1954:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noMegaHealth );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2708
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1955
;1955:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPersonalTeleporter);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2772
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1956
;1956:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.enableBlaster);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3028
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1957
;1957:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.mappic );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1958
;1958:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.picframe );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1960
;1959:
;1960:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.botSkill );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2088
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1961
;1961:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.player0 );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3092
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1962
;1962:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1504
line 1963
;1963:		if( n != 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1508
line 1964
;1964:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerType[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3164
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1965
;1965:		}
LABELV $1508
line 1966
;1966:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerName[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4316
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1967
;1967:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $1512
line 1968
;1968:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerTeam[n] );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5180
ADDP4
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1969
;1969:		}
LABELV $1512
line 1970
;1970:	}
LABELV $1505
line 1962
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1504
line 1972
;1971:
;1972:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.additionalSlots );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2184
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1973
;1973:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPowerups);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1974
;1974:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noHealth);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2580
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1975
;1975:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noArmor);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2644
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1976
;1976:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPlasmaBFG);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2836
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1977
;1977:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noGrenadeRocket);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2900
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1978
;1978:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noRailgun);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1980
;1979:	
;1980:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 4
EQI4 $1523
line 1981
;1981:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.fraglimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1982
;1982:	}
ADDRGP4 $1524
JUMPV
LABELV $1523
line 1983
;1983:	else {
line 1984
;1984:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.flaglimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1296
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1985
;1985:	}
LABELV $1524
line 1986
;1986:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.timelimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+632
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1987
;1987:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6600
INDIRI4
CNSTI4 3
LTI4 $1529
line 1988
;1988:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.friendlyfire );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1628
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1989
;1989:	}
LABELV $1529
line 1990
;1990:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.pure );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2024
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1991
;1991:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6596
INDIRI4
CNSTI4 0
EQI4 $1534
line 1992
;1992:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.dedicated );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1993
;1993:	}
LABELV $1534
line 1994
;1994:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6596
INDIRI4
CNSTI4 0
EQI4 $1538
line 1995
;1995:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.hostname );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1692
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1996
;1996:	}
LABELV $1538
line 1998
;1997:
;1998:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.back );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6508
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 1999
;1999:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.next );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6420
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2000
;2000:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.go );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6332
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2002
;2001:
;2002:	Menu_AddItem( &s_serveroptions.menu, (void*) &s_serveroptions.punkbuster );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6852
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2005
;2003:	
;2004:	
;2005:	ServerOptions_SetMenuItems();
ADDRGP4 ServerOptions_SetMenuItems
CALLV
pop
line 2006
;2006:}
LABELV $1060
endproc ServerOptions_MenuInit 52 12
export ServerOptions_Cache
proc ServerOptions_Cache 0 4
line 2013
;2007:
;2008:/*
;2009:=================
;2010:ServerOptions_Cache
;2011:=================
;2012:*/
;2013:void ServerOptions_Cache( void ) {
line 2014
;2014:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );
ADDRGP4 $429
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2015
;2015:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );
ADDRGP4 $446
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2016
;2016:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT0 );
ADDRGP4 $1478
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2017
;2017:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT1 );
ADDRGP4 $1495
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2018
;2018:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );
ADDRGP4 $362
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2019
;2019:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $334
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2020
;2020:}
LABELV $1546
endproc ServerOptions_Cache 0 4
proc UI_ServerOptionsMenu 0 4
line 2028
;2021:
;2022:
;2023:/*
;2024:=================
;2025:UI_ServerOptionsMenu
;2026:=================
;2027:*/
;2028:static void UI_ServerOptionsMenu( qboolean multiplayer ) {
line 2029
;2029:	ServerOptions_MenuInit( multiplayer );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 ServerOptions_MenuInit
CALLV
pop
line 2030
;2030:	UI_PushMenu( &s_serveroptions.menu );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2031
;2031:}
LABELV $1547
endproc UI_ServerOptionsMenu 0 4
proc UI_BotSelectMenu_SortCompare 44 8
line 2092
;2032:
;2033:
;2034:
;2035:/*
;2036:=============================================================================
;2037:
;2038:BOT SELECT MENU *****
;2039:
;2040:=============================================================================
;2041:*/
;2042:
;2043:
;2044:#define BOTSELECT_BACK0			"menu/art/back_0"
;2045:#define BOTSELECT_BACK1			"menu/art/back_1"
;2046:#define BOTSELECT_ACCEPT0		"menu/art/accept_0"
;2047:#define BOTSELECT_ACCEPT1		"menu/art/accept_1"
;2048:#define BOTSELECT_SELECT		"menu/art/opponents_select"
;2049:#define BOTSELECT_SELECTED		"menu/art/opponents_selected"
;2050:#define BOTSELECT_ARROWS		"menu/art/gs_arrows_0"
;2051:#define BOTSELECT_ARROWSL		"menu/art/gs_arrows_l"
;2052:#define BOTSELECT_ARROWSR		"menu/art/gs_arrows_r"
;2053:
;2054:#define PLAYERGRID_COLS			4
;2055:#define PLAYERGRID_ROWS			4
;2056:#define MAX_MODELSPERPAGE		(PLAYERGRID_ROWS * PLAYERGRID_COLS)
;2057:
;2058:
;2059:typedef struct {
;2060:	menuframework_s	menu;
;2061:
;2062:	menutext_s		banner;
;2063:
;2064:	menubitmap_s	pics[MAX_MODELSPERPAGE];
;2065:	menubitmap_s	picbuttons[MAX_MODELSPERPAGE];
;2066:	menutext_s		picnames[MAX_MODELSPERPAGE];
;2067:
;2068:	menubitmap_s	arrows;
;2069:	menubitmap_s	left;
;2070:	menubitmap_s	right;
;2071:
;2072:	menubitmap_s	go;
;2073:	menubitmap_s	back;
;2074:
;2075:	int				numBots;
;2076:	int				modelpage;
;2077:	int				numpages;
;2078:	int				selectedmodel;
;2079:	int				sortedBotNums[MAX_BOTS];
;2080:	char			boticons[MAX_MODELSPERPAGE][MAX_QPATH];
;2081:	char			botnames[MAX_MODELSPERPAGE][16];
;2082:} botSelectInfo_t;
;2083:
;2084:static botSelectInfo_t	botSelectInfo;
;2085:
;2086:
;2087:/*
;2088:=================
;2089:UI_BotSelectMenu_SortCompare
;2090:=================
;2091:*/
;2092:static int QDECL UI_BotSelectMenu_SortCompare( const void *arg1, const void *arg2 ) {
line 2097
;2093:	int			num1, num2;
;2094:	const char	*info1, *info2;
;2095:	const char	*name1, *name2;
;2096:
;2097:	num1 = *(int *)arg1;
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 2098
;2098:	num2 = *(int *)arg2;
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
line 2100
;2099:
;2100:	info1 = UI_GetBotInfoByNumber( num1 );
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
line 2101
;2101:	info2 = UI_GetBotInfoByNumber( num2 );
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
line 2103
;2102:
;2103:	name1 = Info_ValueForKey( info1, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $747
ARGP4
ADDRLP4 32
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 2104
;2104:	name2 = Info_ValueForKey( info2, "name" );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 $747
ARGP4
ADDRLP4 36
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 36
INDIRP4
ASGNP4
line 2106
;2105:
;2106:	return Q_stricmp( name1, name2 );
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
LABELV $1549
endproc UI_BotSelectMenu_SortCompare 44 8
proc UI_BotSelectMenu_BuildList 12 16
line 2115
;2107:}
;2108:
;2109:
;2110:/*
;2111:=================
;2112:UI_BotSelectMenu_BuildList
;2113:=================
;2114:*/
;2115:static void UI_BotSelectMenu_BuildList( void ) {
line 2118
;2116:	int		n;
;2117:
;2118:	botSelectInfo.modelpage = 0;
ADDRGP4 botSelectInfo+4772
CNSTI4 0
ASGNI4
line 2119
;2119:	botSelectInfo.numBots = UI_GetNumBots();
ADDRLP4 4
ADDRGP4 UI_GetNumBots
CALLI4
ASGNI4
ADDRGP4 botSelectInfo+4768
ADDRLP4 4
INDIRI4
ASGNI4
line 2120
;2120:	botSelectInfo.numpages = botSelectInfo.numBots / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4776
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2121
;2121:	if( botSelectInfo.numBots % MAX_MODELSPERPAGE ) {
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
MODI4
CNSTI4 0
EQI4 $1555
line 2122
;2122:		botSelectInfo.numpages++;
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
line 2123
;2123:	}
LABELV $1555
line 2126
;2124:
;2125:	// initialize the array
;2126:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1562
JUMPV
LABELV $1559
line 2127
;2127:		botSelectInfo.sortedBotNums[n] = n;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2128
;2128:	}
LABELV $1560
line 2126
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1562
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1559
line 2131
;2129:
;2130:	// now sort it
;2131:	qsort( botSelectInfo.sortedBotNums, botSelectInfo.numBots, sizeof(botSelectInfo.sortedBotNums[0]), UI_BotSelectMenu_SortCompare );
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
line 2132
;2132:}
LABELV $1550
endproc UI_BotSelectMenu_BuildList 12 16
proc ServerPlayerIcon 80 20
line 2140
;2133:
;2134:
;2135:/*
;2136:=================
;2137:ServerPlayerIcon
;2138:=================
;2139:*/
;2140:static void ServerPlayerIcon( const char *modelAndSkin, char *iconName, int iconNameMaxSize ) {
line 2144
;2141:	char	*skin;
;2142:	char	model[MAX_QPATH];
;2143:
;2144:	Q_strncpyz( model, modelAndSkin, sizeof(model));
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
line 2145
;2145:	skin = Q_strrchr( model, '/' );
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
line 2146
;2146:	if ( skin ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1569
line 2147
;2147:		*skin++ = '\0';
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
line 2148
;2148:	}
ADDRGP4 $1570
JUMPV
LABELV $1569
line 2149
;2149:	else {
line 2150
;2150:		skin = "default";
ADDRLP4 0
ADDRGP4 $1571
ASGNP4
line 2151
;2151:	}
LABELV $1570
line 2153
;2152:
;2153:	Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_%s.tga", model, skin );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1572
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2155
;2154:
;2155:	if( !trap_R_RegisterShaderNoMip( iconName ) && Q_stricmp( skin, "default" ) != 0 ) {
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
NEI4 $1573
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $1571
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $1573
line 2156
;2156:		Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_default.tga", model );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1575
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2157
;2157:	}
LABELV $1573
line 2158
;2158:}
LABELV $1568
endproc ServerPlayerIcon 80 20
proc UI_BotSelectMenu_UpdateGrid 36 12
line 2166
;2159:
;2160:
;2161:/*
;2162:=================
;2163:UI_BotSelectMenu_UpdateGrid
;2164:=================
;2165:*/
;2166:static void UI_BotSelectMenu_UpdateGrid( void ) {
line 2171
;2167:	const char	*info;
;2168:	int			i;
;2169:    int			j;
;2170:
;2171:	j = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRLP4 4
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2172
;2172:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++, j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1578
line 2173
;2173:		if( j < botSelectInfo.numBots ) { 
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
GEI4 $1582
line 2174
;2174:			info = UI_GetBotInfoByNumber( botSelectInfo.sortedBotNums[j] );
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
line 2175
;2175:			ServerPlayerIcon( Info_ValueForKey( info, "model" ), botSelectInfo.boticons[i], MAX_QPATH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $1586
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
line 2176
;2176:			Q_strncpyz( botSelectInfo.botnames[i], Info_ValueForKey( info, "name" ), 16 );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $747
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
line 2177
;2177:			Q_CleanStr( botSelectInfo.botnames[i] );
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
line 2178
;2178: 			botSelectInfo.pics[i].generic.name = botSelectInfo.boticons[i];
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
line 2179
;2179:			if( BotAlreadySelected( botSelectInfo.botnames[i] ) ) {
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
EQI4 $1593
line 2180
;2180:				botSelectInfo.picnames[i].color = color_red;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_red
ASGNP4
line 2181
;2181:			}
ADDRGP4 $1594
JUMPV
LABELV $1593
line 2182
;2182:			else {
line 2183
;2183:				botSelectInfo.picnames[i].color = color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2184
;2184:			}
LABELV $1594
line 2185
;2185:			botSelectInfo.picbuttons[i].generic.flags &= ~QMF_INACTIVE;
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
line 2186
;2186:		}
ADDRGP4 $1583
JUMPV
LABELV $1582
line 2187
;2187:		else {
line 2189
;2188:			// dead slot
;2189: 			botSelectInfo.pics[i].generic.name         = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
CNSTP4 0
ASGNP4
line 2190
;2190:			botSelectInfo.picbuttons[i].generic.flags |= QMF_INACTIVE;
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
line 2191
;2191:			botSelectInfo.botnames[i][0] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
CNSTI1 0
ASGNI1
line 2192
;2192:		}
LABELV $1583
line 2194
;2193:
;2194: 		botSelectInfo.pics[i].generic.flags       &= ~QMF_HIGHLIGHT;
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
line 2195
;2195: 		botSelectInfo.pics[i].shader               = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+68
ADDP4
CNSTI4 0
ASGNI4
line 2196
;2196: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2197
;2197:	}
LABELV $1579
line 2172
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
LTI4 $1578
line 2200
;2198:
;2199:	// set selected model
;2200:	i = botSelectInfo.selectedmodel % MAX_MODELSPERPAGE;
ADDRLP4 0
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
MODI4
ASGNI4
line 2201
;2201:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2202
;2202:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2204
;2203:
;2204:	if( botSelectInfo.numpages > 1 ) {
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
LEI4 $1618
line 2205
;2205:		if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1621
line 2206
;2206:			botSelectInfo.left.generic.flags &= ~QMF_INACTIVE;
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
line 2207
;2207:		}
ADDRGP4 $1622
JUMPV
LABELV $1621
line 2208
;2208:		else {
line 2209
;2209:			botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2210
;2210:		}
LABELV $1622
line 2212
;2211:
;2212:		if( botSelectInfo.modelpage < (botSelectInfo.numpages - 1) ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1628
line 2213
;2213:			botSelectInfo.right.generic.flags &= ~QMF_INACTIVE;
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
line 2214
;2214:		}
ADDRGP4 $1619
JUMPV
LABELV $1628
line 2215
;2215:		else {
line 2216
;2216:			botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2217
;2217:		}
line 2218
;2218:	}
ADDRGP4 $1619
JUMPV
LABELV $1618
line 2219
;2219:	else {
line 2221
;2220:		// hide left/right markers
;2221:		botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2222
;2222:		botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2223
;2223:	}
LABELV $1619
line 2224
;2224:}
LABELV $1576
endproc UI_BotSelectMenu_UpdateGrid 36 12
proc UI_BotSelectMenu_Default 28 8
line 2232
;2225:
;2226:
;2227:/*
;2228:=================
;2229:UI_BotSelectMenu_Default
;2230:=================
;2231:*/
;2232:static void UI_BotSelectMenu_Default( char *bot ) {
line 2238
;2233:	const char	*botInfo;
;2234:	const char	*test;
;2235:	int			n;
;2236:	int			i;
;2237:
;2238:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1644
JUMPV
LABELV $1641
line 2239
;2239:		botInfo = UI_GetBotInfoByNumber( n );
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
line 2240
;2240:		test = Info_ValueForKey( botInfo, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $747
ARGP4
ADDRLP4 20
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
line 2241
;2241:		if( Q_stricmp( bot, test ) == 0 ) {
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
NEI4 $1646
line 2242
;2242:			break;
ADDRGP4 $1643
JUMPV
LABELV $1646
line 2244
;2243:		}
;2244:	}
LABELV $1642
line 2238
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1644
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1641
LABELV $1643
line 2245
;2245:	if( n == botSelectInfo.numBots ) {
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1648
line 2246
;2246:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2247
;2247:		return;
ADDRGP4 $1640
JUMPV
LABELV $1648
line 2250
;2248:	}
;2249:
;2250:	for( i = 0; i < botSelectInfo.numBots; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1655
JUMPV
LABELV $1652
line 2251
;2251:		if( botSelectInfo.sortedBotNums[i] == n ) {
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1657
line 2252
;2252:			break;
ADDRGP4 $1654
JUMPV
LABELV $1657
line 2254
;2253:		}
;2254:	}
LABELV $1653
line 2250
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1655
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1652
LABELV $1654
line 2255
;2255:	if( i == botSelectInfo.numBots ) {
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1660
line 2256
;2256:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2257
;2257:		return;
ADDRGP4 $1640
JUMPV
LABELV $1660
line 2260
;2258:	}
;2259:
;2260:	botSelectInfo.selectedmodel = i;
ADDRGP4 botSelectInfo+4780
ADDRLP4 4
INDIRI4
ASGNI4
line 2261
;2261:}
LABELV $1640
endproc UI_BotSelectMenu_Default 28 8
proc UI_BotSelectMenu_LeftEvent 4 0
line 2269
;2262:
;2263:
;2264:/*
;2265:=================
;2266:UI_BotSelectMenu_LeftEvent
;2267:=================
;2268:*/
;2269:static void UI_BotSelectMenu_LeftEvent( void* ptr, int event ) {
line 2270
;2270:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1666
line 2271
;2271:		return;
ADDRGP4 $1665
JUMPV
LABELV $1666
line 2273
;2272:	}
;2273:	if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1668
line 2274
;2274:		botSelectInfo.modelpage--;
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
line 2275
;2275:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2276
;2276:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2277
;2277:	}
LABELV $1668
line 2278
;2278:}
LABELV $1665
endproc UI_BotSelectMenu_LeftEvent 4 0
proc UI_BotSelectMenu_RightEvent 4 0
line 2286
;2279:
;2280:
;2281:/*
;2282:=================
;2283:UI_BotSelectMenu_RightEvent
;2284:=================
;2285:*/
;2286:static void UI_BotSelectMenu_RightEvent( void* ptr, int event ) {
line 2287
;2287:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1675
line 2288
;2288:		return;
ADDRGP4 $1674
JUMPV
LABELV $1675
line 2290
;2289:	}
;2290:	if( botSelectInfo.modelpage < botSelectInfo.numpages - 1 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1677
line 2291
;2291:		botSelectInfo.modelpage++;
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
line 2292
;2292:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2293
;2293:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2294
;2294:	}
LABELV $1677
line 2295
;2295:}
LABELV $1674
endproc UI_BotSelectMenu_RightEvent 4 0
proc UI_BotSelectMenu_BotEvent 12 0
line 2303
;2296:
;2297:
;2298:/*
;2299:=================
;2300:UI_BotSelectMenu_BotEvent
;2301:=================
;2302:*/
;2303:static void UI_BotSelectMenu_BotEvent( void* ptr, int event ) {
line 2306
;2304:	int		i;
;2305:
;2306:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1685
line 2307
;2307:		return;
ADDRGP4 $1684
JUMPV
LABELV $1685
line 2310
;2308:	}
;2309:
;2310:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1687
line 2311
;2311: 		botSelectInfo.pics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 2312
;2312: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2313
;2313:	}
LABELV $1688
line 2310
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $1687
line 2316
;2314:
;2315:	// set selected
;2316:	i = ((menucommon_s*)ptr)->id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 2317
;2317:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2318
;2318:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2319
;2319:	botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE + i;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ADDRLP4 0
INDIRI4
ADDI4
ASGNI4
line 2320
;2320:}
LABELV $1684
endproc UI_BotSelectMenu_BotEvent 12 0
proc UI_BotSelectMenu_BackEvent 0 0
line 2328
;2321:
;2322:
;2323:/*
;2324:=================
;2325:UI_BotSelectMenu_BackEvent
;2326:=================
;2327:*/
;2328:static void UI_BotSelectMenu_BackEvent( void* ptr, int event ) {
line 2329
;2329:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1702
line 2330
;2330:		return;
ADDRGP4 $1701
JUMPV
LABELV $1702
line 2332
;2331:	}
;2332:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2333
;2333:}
LABELV $1701
endproc UI_BotSelectMenu_BackEvent 0 0
proc UI_BotSelectMenu_SelectEvent 4 12
line 2341
;2334:
;2335:
;2336:/*
;2337:=================
;2338:UI_BotSelectMenu_SelectEvent
;2339:=================
;2340:*/
;2341:static void UI_BotSelectMenu_SelectEvent( void* ptr, int event ) {
line 2342
;2342:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1705
line 2343
;2343:		return;
ADDRGP4 $1704
JUMPV
LABELV $1705
line 2345
;2344:	}
;2345:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2347
;2346:
;2347:	s_serveroptions.newBot = qtrue;
ADDRGP4 s_serveroptions+6828
CNSTI4 1
ASGNI4
line 2348
;2348:	Q_strncpyz( s_serveroptions.newBotName, botSelectInfo.botnames[botSelectInfo.selectedmodel % MAX_MODELSPERPAGE], 16 );
ADDRGP4 s_serveroptions+6836
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
line 2349
;2349:}
LABELV $1704
endproc UI_BotSelectMenu_SelectEvent 4 12
export UI_BotSelectMenu_Cache
proc UI_BotSelectMenu_Cache 0 4
line 2357
;2350:
;2351:
;2352:/*
;2353:=================
;2354:UI_BotSelectMenu_Cache
;2355:=================
;2356:*/
;2357:void UI_BotSelectMenu_Cache( void ) {
line 2358
;2358:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK0 );
ADDRGP4 $429
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2359
;2359:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK1 );
ADDRGP4 $446
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2360
;2360:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT0 );
ADDRGP4 $1712
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2361
;2361:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT1 );
ADDRGP4 $1713
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2362
;2362:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECT );
ADDRGP4 $1714
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2363
;2363:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECTED );
ADDRGP4 $1715
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2364
;2364:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWS );
ADDRGP4 $366
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2365
;2365:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSL );
ADDRGP4 $394
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2366
;2366:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSR );
ADDRGP4 $412
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2367
;2367:}
LABELV $1711
endproc UI_BotSelectMenu_Cache 0 4
proc UI_BotSelectMenu_Init 36 12
line 2370
;2368:
;2369:
;2370:static void UI_BotSelectMenu_Init( char *bot ) {
line 2374
;2371:	int		i, j, k;
;2372:	int		x, y;
;2373:
;2374:	memset( &botSelectInfo, 0 ,sizeof(botSelectInfo) );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 0
ARGI4
CNSTI4 10160
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2375
;2375:	botSelectInfo.menu.wrapAround = qtrue;
ADDRGP4 botSelectInfo+276
CNSTI4 1
ASGNI4
line 2376
;2376:	botSelectInfo.menu.fullscreen = qtrue;
ADDRGP4 botSelectInfo+280
CNSTI4 1
ASGNI4
line 2378
;2377:
;2378:	UI_BotSelectMenu_Cache();
ADDRGP4 UI_BotSelectMenu_Cache
CALLV
pop
line 2380
;2379:
;2380:	botSelectInfo.banner.generic.type	= MTYPE_BTEXT;
ADDRGP4 botSelectInfo+288
CNSTI4 10
ASGNI4
line 2381
;2381:	botSelectInfo.banner.generic.x		= 320;
ADDRGP4 botSelectInfo+288+12
CNSTI4 320
ASGNI4
line 2382
;2382:	botSelectInfo.banner.generic.y		= 16;
ADDRGP4 botSelectInfo+288+16
CNSTI4 16
ASGNI4
line 2383
;2383:	botSelectInfo.banner.string			= "SELECT BOT";
ADDRGP4 botSelectInfo+288+60
ADDRGP4 $1726
ASGNP4
line 2384
;2384:	botSelectInfo.banner.color			= color_white;
ADDRGP4 botSelectInfo+288+68
ADDRGP4 color_white
ASGNP4
line 2385
;2385:	botSelectInfo.banner.style			= UI_CENTER;
ADDRGP4 botSelectInfo+288+64
CNSTI4 1
ASGNI4
line 2387
;2386:
;2387:	y =	80;
ADDRLP4 8
CNSTI4 80
ASGNI4
line 2388
;2388:	for( i = 0, k = 0; i < PLAYERGRID_ROWS; i++) {
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
ADDRGP4 $1734
JUMPV
LABELV $1731
line 2389
;2389:		x =	180;
ADDRLP4 4
CNSTI4 180
ASGNI4
line 2390
;2390:		for( j = 0; j < PLAYERGRID_COLS; j++, k++ ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $1735
line 2391
;2391:			botSelectInfo.pics[k].generic.type				= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360
ADDP4
CNSTI4 6
ASGNI4
line 2392
;2392:			botSelectInfo.pics[k].generic.flags				= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
CNSTU4 16388
ASGNU4
line 2393
;2393:			botSelectInfo.pics[k].generic.x					= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2394
;2394:			botSelectInfo.pics[k].generic.y					= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2395
;2395: 			botSelectInfo.pics[k].generic.name				= botSelectInfo.boticons[k];
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
line 2396
;2396:			botSelectInfo.pics[k].width						= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+76
ADDP4
CNSTI4 64
ASGNI4
line 2397
;2397:			botSelectInfo.pics[k].height					= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+80
ADDP4
CNSTI4 64
ASGNI4
line 2398
;2398:			botSelectInfo.pics[k].focuspic					= BOTSELECT_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+60
ADDP4
ADDRGP4 $1715
ASGNP4
line 2399
;2399:			botSelectInfo.pics[k].focuscolor				= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2401
;2400:
;2401:			botSelectInfo.picbuttons[k].generic.type		= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768
ADDP4
CNSTI4 6
ASGNI4
line 2402
;2402:			botSelectInfo.picbuttons[k].generic.flags		= QMF_LEFT_JUSTIFY|QMF_NODEFAULTINIT|QMF_PULSEIFFOCUS;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
CNSTU4 33028
ASGNU4
line 2403
;2403:			botSelectInfo.picbuttons[k].generic.callback	= UI_BotSelectMenu_BotEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+48
ADDP4
ADDRGP4 UI_BotSelectMenu_BotEvent
ASGNP4
line 2404
;2404:			botSelectInfo.picbuttons[k].generic.id			= k;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2405
;2405:			botSelectInfo.picbuttons[k].generic.x			= x - 16;
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
line 2406
;2406:			botSelectInfo.picbuttons[k].generic.y			= y - 16;
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
line 2407
;2407:			botSelectInfo.picbuttons[k].generic.left		= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2408
;2408:			botSelectInfo.picbuttons[k].generic.top			= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2409
;2409:			botSelectInfo.picbuttons[k].generic.right		= x + 64;
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
line 2410
;2410:			botSelectInfo.picbuttons[k].generic.bottom		= y + 64;
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
line 2411
;2411:			botSelectInfo.picbuttons[k].width				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+76
ADDP4
CNSTI4 128
ASGNI4
line 2412
;2412:			botSelectInfo.picbuttons[k].height				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+80
ADDP4
CNSTI4 128
ASGNI4
line 2413
;2413:			botSelectInfo.picbuttons[k].focuspic			= BOTSELECT_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+60
ADDP4
ADDRGP4 $1714
ASGNP4
line 2414
;2414:			botSelectInfo.picbuttons[k].focuscolor			= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2416
;2415:
;2416:			botSelectInfo.picnames[k].generic.type			= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176
ADDP4
CNSTI4 7
ASGNI4
line 2417
;2417:			botSelectInfo.picnames[k].generic.flags			= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+44
ADDP4
CNSTU4 2
ASGNU4
line 2418
;2418:			botSelectInfo.picnames[k].generic.x				= x + 32;
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
line 2419
;2419:			botSelectInfo.picnames[k].generic.y				= y + 64;
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
line 2420
;2420:			botSelectInfo.picnames[k].string				= botSelectInfo.botnames[k];
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
line 2421
;2421:			botSelectInfo.picnames[k].color					= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2422
;2422:			botSelectInfo.picnames[k].style					= UI_CENTER|UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+64
ADDP4
CNSTI4 17
ASGNI4
line 2424
;2423:
;2424:			x += (64 + 6);
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 70
ADDI4
ASGNI4
line 2425
;2425:		}
LABELV $1736
line 2390
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
LTI4 $1735
line 2426
;2426:		y += (64 + SMALLCHAR_HEIGHT + 6);
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 86
ADDI4
ASGNI4
line 2427
;2427:	}
LABELV $1732
line 2388
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1734
ADDRLP4 16
INDIRI4
CNSTI4 4
LTI4 $1731
line 2429
;2428:
;2429:	botSelectInfo.arrows.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4328
CNSTI4 6
ASGNI4
line 2430
;2430:	botSelectInfo.arrows.generic.name		= BOTSELECT_ARROWS;
ADDRGP4 botSelectInfo+4328+4
ADDRGP4 $366
ASGNP4
line 2431
;2431:	botSelectInfo.arrows.generic.flags		= QMF_INACTIVE;
ADDRGP4 botSelectInfo+4328+44
CNSTU4 16384
ASGNU4
line 2432
;2432:	botSelectInfo.arrows.generic.x			= 260;
ADDRGP4 botSelectInfo+4328+12
CNSTI4 260
ASGNI4
line 2433
;2433:	botSelectInfo.arrows.generic.y			= 440;
ADDRGP4 botSelectInfo+4328+16
CNSTI4 440
ASGNI4
line 2434
;2434:	botSelectInfo.arrows.width				= 128;
ADDRGP4 botSelectInfo+4328+76
CNSTI4 128
ASGNI4
line 2435
;2435:	botSelectInfo.arrows.height				= 32;
ADDRGP4 botSelectInfo+4328+80
CNSTI4 32
ASGNI4
line 2437
;2436:
;2437:	botSelectInfo.left.generic.type			= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4416
CNSTI4 6
ASGNI4
line 2438
;2438:	botSelectInfo.left.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4416+44
CNSTU4 260
ASGNU4
line 2439
;2439:	botSelectInfo.left.generic.callback		= UI_BotSelectMenu_LeftEvent;
ADDRGP4 botSelectInfo+4416+48
ADDRGP4 UI_BotSelectMenu_LeftEvent
ASGNP4
line 2440
;2440:	botSelectInfo.left.generic.x			= 260;
ADDRGP4 botSelectInfo+4416+12
CNSTI4 260
ASGNI4
line 2441
;2441:	botSelectInfo.left.generic.y			= 440;
ADDRGP4 botSelectInfo+4416+16
CNSTI4 440
ASGNI4
line 2442
;2442:	botSelectInfo.left.width  				= 64;
ADDRGP4 botSelectInfo+4416+76
CNSTI4 64
ASGNI4
line 2443
;2443:	botSelectInfo.left.height  				= 32;
ADDRGP4 botSelectInfo+4416+80
CNSTI4 32
ASGNI4
line 2444
;2444:	botSelectInfo.left.focuspic				= BOTSELECT_ARROWSL;
ADDRGP4 botSelectInfo+4416+60
ADDRGP4 $394
ASGNP4
line 2446
;2445:
;2446:	botSelectInfo.right.generic.type	    = MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4504
CNSTI4 6
ASGNI4
line 2447
;2447:	botSelectInfo.right.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4504+44
CNSTU4 260
ASGNU4
line 2448
;2448:	botSelectInfo.right.generic.callback	= UI_BotSelectMenu_RightEvent;
ADDRGP4 botSelectInfo+4504+48
ADDRGP4 UI_BotSelectMenu_RightEvent
ASGNP4
line 2449
;2449:	botSelectInfo.right.generic.x			= 321;
ADDRGP4 botSelectInfo+4504+12
CNSTI4 321
ASGNI4
line 2450
;2450:	botSelectInfo.right.generic.y			= 440;
ADDRGP4 botSelectInfo+4504+16
CNSTI4 440
ASGNI4
line 2451
;2451:	botSelectInfo.right.width  				= 64;
ADDRGP4 botSelectInfo+4504+76
CNSTI4 64
ASGNI4
line 2452
;2452:	botSelectInfo.right.height  		    = 32;
ADDRGP4 botSelectInfo+4504+80
CNSTI4 32
ASGNI4
line 2453
;2453:	botSelectInfo.right.focuspic			= BOTSELECT_ARROWSR;
ADDRGP4 botSelectInfo+4504+60
ADDRGP4 $412
ASGNP4
line 2455
;2454:
;2455:	botSelectInfo.back.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4680
CNSTI4 6
ASGNI4
line 2456
;2456:	botSelectInfo.back.generic.name		= BOTSELECT_BACK0;
ADDRGP4 botSelectInfo+4680+4
ADDRGP4 $429
ASGNP4
line 2457
;2457:	botSelectInfo.back.generic.flags	= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4680+44
CNSTU4 260
ASGNU4
line 2458
;2458:	botSelectInfo.back.generic.callback	= UI_BotSelectMenu_BackEvent;
ADDRGP4 botSelectInfo+4680+48
ADDRGP4 UI_BotSelectMenu_BackEvent
ASGNP4
line 2459
;2459:	botSelectInfo.back.generic.x		= 0;
ADDRGP4 botSelectInfo+4680+12
CNSTI4 0
ASGNI4
line 2460
;2460:	botSelectInfo.back.generic.y		= 480-64;
ADDRGP4 botSelectInfo+4680+16
CNSTI4 416
ASGNI4
line 2461
;2461:	botSelectInfo.back.width			= 128;
ADDRGP4 botSelectInfo+4680+76
CNSTI4 128
ASGNI4
line 2462
;2462:	botSelectInfo.back.height			= 64;
ADDRGP4 botSelectInfo+4680+80
CNSTI4 64
ASGNI4
line 2463
;2463:	botSelectInfo.back.focuspic			= BOTSELECT_BACK1;
ADDRGP4 botSelectInfo+4680+60
ADDRGP4 $446
ASGNP4
line 2465
;2464:
;2465:	botSelectInfo.go.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4592
CNSTI4 6
ASGNI4
line 2466
;2466:	botSelectInfo.go.generic.name		= BOTSELECT_ACCEPT0;
ADDRGP4 botSelectInfo+4592+4
ADDRGP4 $1712
ASGNP4
line 2467
;2467:	botSelectInfo.go.generic.flags		= QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4592+44
CNSTU4 272
ASGNU4
line 2468
;2468:	botSelectInfo.go.generic.callback	= UI_BotSelectMenu_SelectEvent;
ADDRGP4 botSelectInfo+4592+48
ADDRGP4 UI_BotSelectMenu_SelectEvent
ASGNP4
line 2469
;2469:	botSelectInfo.go.generic.x			= 640;
ADDRGP4 botSelectInfo+4592+12
CNSTI4 640
ASGNI4
line 2470
;2470:	botSelectInfo.go.generic.y			= 480-64;
ADDRGP4 botSelectInfo+4592+16
CNSTI4 416
ASGNI4
line 2471
;2471:	botSelectInfo.go.width				= 128;
ADDRGP4 botSelectInfo+4592+76
CNSTI4 128
ASGNI4
line 2472
;2472:	botSelectInfo.go.height				= 64;
ADDRGP4 botSelectInfo+4592+80
CNSTI4 64
ASGNI4
line 2473
;2473:	botSelectInfo.go.focuspic			= BOTSELECT_ACCEPT1;
ADDRGP4 botSelectInfo+4592+60
ADDRGP4 $1713
ASGNP4
line 2475
;2474:
;2475:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.banner );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2476
;2476:	for( i = 0; i < MAX_MODELSPERPAGE; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1876
line 2477
;2477:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.pics[i] );
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
line 2478
;2478:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picbuttons[i] );
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
line 2479
;2479:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picnames[i] );
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
line 2480
;2480:	}
LABELV $1877
line 2476
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 16
LTI4 $1876
line 2481
;2481:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.arrows );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4328
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2482
;2482:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.left );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4416
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2483
;2483:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.right );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4504
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2484
;2484:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.back );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4680
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2485
;2485:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.go );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4592
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2487
;2486:
;2487:	UI_BotSelectMenu_BuildList();
ADDRGP4 UI_BotSelectMenu_BuildList
CALLV
pop
line 2488
;2488:	UI_BotSelectMenu_Default( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Default
CALLV
pop
line 2489
;2489:	botSelectInfo.modelpage = botSelectInfo.selectedmodel / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4772
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2490
;2490:	UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2491
;2491:}
LABELV $1716
endproc UI_BotSelectMenu_Init 36 12
export UI_BotSelectMenu
proc UI_BotSelectMenu 0 4
line 2499
;2492:
;2493:
;2494:/*
;2495:=================
;2496:UI_BotSelectMenu
;2497:=================
;2498:*/
;2499:void UI_BotSelectMenu( char *bot ) {
line 2500
;2500:	UI_BotSelectMenu_Init( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Init
CALLV
pop
line 2501
;2501:	UI_PushMenu( &botSelectInfo.menu );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2502
;2502:}
LABELV $1890
endproc UI_BotSelectMenu 0 4
bss
align 4
LABELV botSelectInfo
skip 10160
align 4
LABELV s_serveroptions
skip 6948
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
LABELV $1726
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
LABELV $1715
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
LABELV $1714
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
LABELV $1713
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
LABELV $1712
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
LABELV $1586
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $1575
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
LABELV $1572
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
LABELV $1571
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $1495
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
LABELV $1478
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
LABELV $1428
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
LABELV $1418
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
LABELV $1408
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
LABELV $1398
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
LABELV $1388
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
LABELV $1378
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
LABELV $1368
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
LABELV $1358
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
LABELV $1348
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
LABELV $1330
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
LABELV $1243
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
LABELV $1227
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
LABELV $1211
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
LABELV $1202
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
LABELV $1185
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
LABELV $1175
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
LABELV $1148
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
LABELV $1130
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
LABELV $1112
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
LABELV $995
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $960
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
LABELV $954
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
LABELV $948
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
LABELV $942
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
LABELV $921
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
LABELV $897
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $877
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $865
byte 1 118
byte 1 105
byte 1 115
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $859
byte 1 109
byte 1 97
byte 1 106
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $856
byte 1 103
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $839
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
LABELV $779
byte 1 72
byte 1 117
byte 1 109
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $747
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $716
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
LABELV $711
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
LABELV $707
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
LABELV $689
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 32
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $686
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
LABELV $685
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
LABELV $684
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 109
byte 1 97
byte 1 112
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
LABELV $676
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
LABELV $673
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
LABELV $668
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
LABELV $665
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
LABELV $662
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
LABELV $659
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
LABELV $656
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
LABELV $653
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
LABELV $650
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
LABELV $647
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
LABELV $644
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
LABELV $641
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
LABELV $637
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
LABELV $636
byte 1 115
byte 1 118
byte 1 95
byte 1 112
byte 1 117
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $635
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
LABELV $634
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
LABELV $633
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
LABELV $632
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
LABELV $631
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
LABELV $630
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
LABELV $628
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
LABELV $627
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
LABELV $626
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
LABELV $624
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
LABELV $623
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
LABELV $622
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
LABELV $620
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
LABELV $619
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
LABELV $617
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
LABELV $616
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
LABELV $609
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
LABELV $604
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
LABELV $601
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
LABELV $598
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
LABELV $595
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
LABELV $592
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
LABELV $589
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
LABELV $586
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
LABELV $583
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
LABELV $582
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
LABELV $527
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
LABELV $526
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
LABELV $525
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
LABELV $524
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
LABELV $523
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
LABELV $522
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $521
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $520
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 0
align 1
LABELV $519
byte 1 66
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $518
byte 1 79
byte 1 112
byte 1 101
byte 1 110
byte 1 0
align 1
LABELV $517
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
LABELV $516
byte 1 76
byte 1 65
byte 1 78
byte 1 0
align 1
LABELV $515
byte 1 78
byte 1 111
byte 1 0
align 1
LABELV $497
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
byte 1 110
byte 1 101
byte 1 120
byte 1 116
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
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $446
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
LABELV $429
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
LABELV $412
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
LABELV $394
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
LABELV $366
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
LABELV $362
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
LABELV $334
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
LABELV $331
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
LABELV $299
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
LABELV $285
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
LABELV $271
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
LABELV $263
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
LABELV $224
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
LABELV $218
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
LABELV $215
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
LABELV $187
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $182
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $140
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
LABELV $107
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
LABELV $96
byte 1 99
byte 1 116
byte 1 102
byte 1 0
align 1
LABELV $93
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $90
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $87
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 0
align 1
LABELV $84
byte 1 102
byte 1 102
byte 1 97
byte 1 0
align 1
LABELV $75
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
LABELV $74
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
