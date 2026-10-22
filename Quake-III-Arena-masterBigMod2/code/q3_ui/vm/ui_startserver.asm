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
byte 4 1
byte 4 4
align 4
LABELV gametype_remap2
byte 4 0
byte 4 7
byte 4 0
byte 4 1
byte 4 8
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
;104:	"Tournament",
;105:	"Capture the Flag",
;106:	0
;107:};
;108:
;109:
;110:static int gametype_remap[] = {
;111:	GT_FFA,
;112:	GT_TEAM,
;113:	GT_TEAM,
;114:	GT_TEAM,
;115:	GT_TEAM,
;116:	GT_TEAM,
;117:	GT_TEAM,
;118:	GT_TOURNAMENT,
;119:	GT_CTF
;120:};
;121:
;122:
;123:static int gametype_remap2[] = {
;124:	0,
;125:	7,
;126:	0,
;127:	1,
;128:	8
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
ADDRGP4 $79
JUMPV
LABELV $78
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
NEI4 $81
line 152
;152:			break;
ADDRGP4 $80
JUMPV
LABELV $81
line 155
;153:		}
;154:
;155:		if( Q_stricmp( token, "ffa" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $85
ARGP4
ADDRLP4 16
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $83
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
ADDRGP4 $79
JUMPV
LABELV $83
line 160
;158:		}
;159:
;160:		if( Q_stricmp( token, "tourney" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $88
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $86
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
ADDRGP4 $79
JUMPV
LABELV $86
line 165
;163:		}
;164:
;165:		if( Q_stricmp( token, "single" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $91
ARGP4
ADDRLP4 24
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $89
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
ADDRGP4 $79
JUMPV
LABELV $89
line 170
;168:		}
;169:
;170:		if( Q_stricmp( token, "team" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $94
ARGP4
ADDRLP4 28
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $92
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
ADDRGP4 $79
JUMPV
LABELV $92
line 175
;173:		}
;174:
;175:		if( Q_stricmp( token, "ctf" ) == 0 ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $97
ARGP4
ADDRLP4 32
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
NEI4 $95
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
LABELV $95
line 179
;178:		}
;179:	}
LABELV $79
line 149
ADDRGP4 $78
JUMPV
LABELV $80
line 181
;180:
;181:	return bits;
ADDRLP4 4
INDIRI4
RETI4
LABELV $77
endproc GametypeBits 36 8
bss
align 1
LABELV $99
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
LABELV $101
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
LTI4 $105
line 200
;200:			break;
ADDRGP4 $123
JUMPV
LABELV $105
line 202
;201:
;202:		Com_sprintf( picname[i], sizeof(picname[i]), "levelshots/%s", s_startserver.maplist[top+i] );
ADDRLP4 0
INDIRI4
CNSTI4 6
LSHI4
ADDRGP4 $99
ADDP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $108
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
ADDRGP4 $99
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
LABELV $102
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
LTI4 $101
line 213
;212:
;213:	for (; i<MAX_MAPSPERPAGE; i++)
ADDRGP4 $123
JUMPV
LABELV $120
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
LABELV $121
line 213
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $123
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $120
line 226
;223:
;224:
;225:	// no servers to start
;226:	if( !s_startserver.nummaps ) {
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 0
NEI4 $134
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
ADDRGP4 $141
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 231
;231:	}
ADDRGP4 $135
JUMPV
LABELV $134
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
LTI4 $145
ADDRLP4 0
INDIRI4
CNSTI4 4
GEI4 $145
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
LABELV $145
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
LABELV $135
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
LABELV $98
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
EQI4 $158
line 257
;257:		return;
ADDRGP4 $157
JUMPV
LABELV $158
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
LABELV $157
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
EQI4 $163
line 278
;278:		return;
ADDRGP4 $162
JUMPV
LABELV $163
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
;283:	if( s_startserver.gametype.curvalue == 2 ||
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
EQI4 $175
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
EQI4 $175
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 6
NEI4 $166
LABELV $175
line 285
;284:		s_startserver.gametype.curvalue == 5 ||
;285:		s_startserver.gametype.curvalue == 6 ) {
line 289
;286:			/*
;287:			 * TDM on CTF Maps shows CTF maps but launches GT_TEAM.
;288:			 */
;289:			matchbits = 1 << GT_CTF;
ADDRLP4 12
CNSTI4 16
ASGNI4
line 290
;290:		}
ADDRGP4 $167
JUMPV
LABELV $166
line 291
;291:		else {
line 292
;292:			matchbits =
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
line 295
;293:				1 << gametype_remap[s_startserver.gametype.curvalue];
;294:
;295:			if( gametype_remap[s_startserver.gametype.curvalue] ==
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 gametype_remap
ADDP4
INDIRI4
CNSTI4 0
NEI4 $178
line 296
;296:				GT_FFA ) {
line 297
;297:				matchbits |= 1 << GT_SINGLE_PLAYER;
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 298
;298:			}
LABELV $178
line 299
;299:		}
LABELV $167
line 300
;300:	for( i = 0; i < count; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $185
JUMPV
LABELV $182
line 301
;301:		info = UI_GetArenaInfoByNumber( i );
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
line 303
;302:
;303:		gamebits = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $186
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
line 304
;304:		if( !( gamebits & matchbits ) ) {
ADDRLP4 4
INDIRI4
ADDRLP4 12
INDIRI4
BANDI4
CNSTI4 0
NEI4 $187
line 305
;305:			continue;
ADDRGP4 $183
JUMPV
LABELV $187
line 308
;306:		}
;307:
;308:		Q_strncpyz( s_startserver.maplist[s_startserver.nummaps], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $191
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
line 309
;309:		Q_strupr( s_startserver.maplist[s_startserver.nummaps] );
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
line 310
;310:		s_startserver.mapGamebits[s_startserver.nummaps] = gamebits;
ADDRGP4 s_startserver+1944
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_startserver+2980
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 311
;311:		s_startserver.nummaps++;
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
line 312
;312:	}
LABELV $183
line 300
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $185
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $182
line 313
;313:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
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
line 314
;314:	s_startserver.page = 0;
ADDRGP4 s_startserver+1948
CNSTI4 0
ASGNI4
line 315
;315:	s_startserver.currentmap = 0;
ADDRGP4 s_startserver+1940
CNSTI4 0
ASGNI4
line 317
;316:
;317:	StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 318
;318:}
LABELV $162
endproc StartServer_GametypeEvent 44 12
proc StartServer_MenuEvent 20 8
line 326
;319:
;320:
;321:/*
;322:=================
;323:StartServer_MenuEvent
;324:=================
;325:*/
;326:static void StartServer_MenuEvent( void* ptr, int event ) {
line 327
;327:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $202
line 328
;328:		return;
ADDRGP4 $201
JUMPV
LABELV $202
line 331
;329:	}
;330:
;331:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $204
ADDRLP4 0
INDIRI4
CNSTI4 18
GTI4 $204
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $245-60
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $245
address $207
address $212
address $244
address $218
code
LABELV $207
line 333
;332:	case ID_PREVPAGE:
;333:		if( s_startserver.page > 0 ) {
ADDRGP4 s_startserver+1948
INDIRI4
CNSTI4 0
LEI4 $205
line 334
;334:			s_startserver.page--;
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
line 335
;335:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 336
;336:		}
line 337
;337:		break;
ADDRGP4 $205
JUMPV
LABELV $212
line 340
;338:
;339:	case ID_NEXTPAGE:
;340:		if( s_startserver.page < s_startserver.maxpages - 1 ) {
ADDRGP4 s_startserver+1948
INDIRI4
ADDRGP4 s_startserver+1952
INDIRI4
CNSTI4 1
SUBI4
GEI4 $205
line 341
;341:			s_startserver.page++;
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
line 342
;342:			StartServer_Update();
ADDRGP4 StartServer_Update
CALLV
pop
line 343
;343:		}
line 344
;344:		break;
ADDRGP4 $205
JUMPV
LABELV $218
line 347
;345:
;346:	case ID_STARTSERVERNEXT:
;347:		trap_Cvar_SetValue(
ADDRGP4 $219
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
line 354
;348:			"g_gameType",
;349:			gametype_remap[
;350:				s_startserver.gametype.curvalue
;351:			]
;352:		);
;353:
;354:		trap_Cvar_SetValue(
ADDRGP4 $222
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 3
NEI4 $226
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $227
JUMPV
LABELV $226
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $227
ADDRLP4 8
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 359
;355:			"g_baseTDM",
;356:			s_startserver.gametype.curvalue == 3
;357:		);
;358:
;359:		trap_Cvar_SetValue(
ADDRGP4 $228
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 4
EQI4 $236
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 5
NEI4 $234
LABELV $236
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRGP4 $235
JUMPV
LABELV $234
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $235
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 365
;360:			"g_oneLifeTDM",
;361:			s_startserver.gametype.curvalue == 4 ||
;362:			s_startserver.gametype.curvalue == 5
;363:		);
;364:
;365:		trap_Cvar_SetValue(
ADDRGP4 $237
ARGP4
ADDRGP4 s_startserver+536+64
INDIRI4
CNSTI4 6
NEI4 $241
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $242
JUMPV
LABELV $241
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $242
ADDRLP4 16
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 370
;366:			"g_assaultMode",
;367:			s_startserver.gametype.curvalue == 6
;368:		);
;369:
;370:		UI_ServerOptionsMenu(
ADDRGP4 s_startserver+1936
INDIRI4
ARGI4
ADDRGP4 UI_ServerOptionsMenu
CALLV
pop
line 373
;371:			s_startserver.multiplayer
;372:		);
;373:		break;
ADDRGP4 $205
JUMPV
LABELV $244
line 376
;374:
;375:	case ID_STARTSERVERBACK:
;376:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 377
;377:		break;
LABELV $204
LABELV $205
line 379
;378:	}
;379:}
LABELV $201
endproc StartServer_MenuEvent 20 8
proc StartServer_LevelshotDraw 48 20
line 387
;380:
;381:
;382:/*
;383:===============
;384:StartServer_LevelshotDraw
;385:===============
;386:*/
;387:static void StartServer_LevelshotDraw( void *self ) {
line 395
;388:	menubitmap_s	*b;
;389:	int				x;
;390:	int				y;
;391:	int				w;
;392:	int				h;
;393:	int				n;
;394:
;395:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 397
;396:
;397:	if( !b->generic.name ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $248
line 398
;398:		return;
ADDRGP4 $247
JUMPV
LABELV $248
line 401
;399:	}
;400:
;401:	if( b->generic.name && !b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $250
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $250
line 402
;402:		b->shader = trap_R_RegisterShaderNoMip( b->generic.name );
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
line 403
;403:		if( !b->shader && b->errorpic ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
NEI4 $252
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $252
line 404
;404:			b->shader = trap_R_RegisterShaderNoMip( b->errorpic );
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
line 405
;405:		}
LABELV $252
line 406
;406:	}
LABELV $250
line 408
;407:
;408:	if( b->focuspic && !b->focusshader ) {
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $254
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
NEI4 $254
line 409
;409:		b->focusshader = trap_R_RegisterShaderNoMip( b->focuspic );
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
line 410
;410:	}
LABELV $254
line 412
;411:
;412:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 413
;413:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 414
;414:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 415
;415:	h =	b->height;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
line 416
;416:	if( b->shader ) {
ADDRLP4 0
INDIRP4
CNSTI4 68
ADDP4
INDIRI4
CNSTI4 0
EQI4 $256
line 417
;417:		UI_DrawHandlePic( x, y, w, h, b->shader );
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
line 418
;418:	}
LABELV $256
line 420
;419:
;420:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 421
;421:	y = b->generic.y + b->height;
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
line 422
;422:	UI_FillRect( x, y, b->width, 28, colorBlack );
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
line 424
;423:
;424:	x += b->width / 2;
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
line 425
;425:	y += 4;
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 426
;426:	n = s_startserver.page * MAX_MAPSPERPAGE + b->generic.id - ID_PICTURES;
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
line 427
;427:	UI_DrawString( x, y, s_startserver.maplist[n], UI_CENTER|UI_SMALLFONT, color_orange );
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
line 429
;428:
;429:	x = b->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 430
;430:	y = b->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 431
;431:	w = b->width;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 432
;432:	h =	b->height + 28;
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
line 433
;433:	if( b->generic.flags & QMF_HIGHLIGHT ) {	
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 64
BANDU4
CNSTU4 0
EQU4 $260
line 434
;434:		UI_DrawHandlePic( x, y, w, h, b->focusshader );
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
line 435
;435:	}
LABELV $260
line 436
;436:}
LABELV $247
endproc StartServer_LevelshotDraw 48 20
bss
align 1
LABELV $263
skip 64
code
proc StartServer_MenuInit 20 12
line 444
;437:
;438:
;439:/*
;440:=================
;441:StartServer_MenuInit
;442:=================
;443:*/
;444:static void StartServer_MenuInit( void ) {
line 451
;445:	int	i;
;446:	int	x;
;447:	int	y;
;448:	static char mapnamebuffer[64];
;449:
;450:	// zero set all our globals
;451:	memset( &s_startserver, 0 ,sizeof(startserver_t) );
ADDRGP4 s_startserver
ARGP4
CNSTI4 0
ARGI4
CNSTI4 3236
ARGI4
ADDRGP4 memset
CALLP4
pop
line 453
;452:
;453:	StartServer_Cache();
ADDRGP4 StartServer_Cache
CALLV
pop
line 455
;454:
;455:	s_startserver.menu.wrapAround = qtrue;
ADDRGP4 s_startserver+276
CNSTI4 1
ASGNI4
line 456
;456:	s_startserver.menu.fullscreen = qtrue;
ADDRGP4 s_startserver+280
CNSTI4 1
ASGNI4
line 458
;457:
;458:	s_startserver.banner.generic.type  = MTYPE_BTEXT;
ADDRGP4 s_startserver+288
CNSTI4 10
ASGNI4
line 459
;459:	s_startserver.banner.generic.x	   = 320;
ADDRGP4 s_startserver+288+12
CNSTI4 320
ASGNI4
line 460
;460:	s_startserver.banner.generic.y	   = 16;
ADDRGP4 s_startserver+288+16
CNSTI4 16
ASGNI4
line 461
;461:	s_startserver.banner.string        = "GAME SERVER";
ADDRGP4 s_startserver+288+60
ADDRGP4 $273
ASGNP4
line 462
;462:	s_startserver.banner.color         = color_white;
ADDRGP4 s_startserver+288+68
ADDRGP4 color_white
ASGNP4
line 463
;463:	s_startserver.banner.style         = UI_CENTER;
ADDRGP4 s_startserver+288+64
CNSTI4 1
ASGNI4
line 465
;464:
;465:	s_startserver.framel.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+360
CNSTI4 6
ASGNI4
line 466
;466:	s_startserver.framel.generic.name  = GAMESERVER_FRAMEL;
ADDRGP4 s_startserver+360+4
ADDRGP4 $281
ASGNP4
line 467
;467:	s_startserver.framel.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+360+44
CNSTU4 16384
ASGNU4
line 468
;468:	s_startserver.framel.generic.x	   = 0;  
ADDRGP4 s_startserver+360+12
CNSTI4 0
ASGNI4
line 469
;469:	s_startserver.framel.generic.y	   = 78;
ADDRGP4 s_startserver+360+16
CNSTI4 78
ASGNI4
line 470
;470:	s_startserver.framel.width  	   = 256;
ADDRGP4 s_startserver+360+76
CNSTI4 256
ASGNI4
line 471
;471:	s_startserver.framel.height  	   = 329;
ADDRGP4 s_startserver+360+80
CNSTI4 329
ASGNI4
line 473
;472:
;473:	s_startserver.framer.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+448
CNSTI4 6
ASGNI4
line 474
;474:	s_startserver.framer.generic.name  = GAMESERVER_FRAMER;
ADDRGP4 s_startserver+448+4
ADDRGP4 $295
ASGNP4
line 475
;475:	s_startserver.framer.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+448+44
CNSTU4 16384
ASGNU4
line 476
;476:	s_startserver.framer.generic.x	   = 376;
ADDRGP4 s_startserver+448+12
CNSTI4 376
ASGNI4
line 477
;477:	s_startserver.framer.generic.y	   = 76;
ADDRGP4 s_startserver+448+16
CNSTI4 76
ASGNI4
line 478
;478:	s_startserver.framer.width  	   = 256;
ADDRGP4 s_startserver+448+76
CNSTI4 256
ASGNI4
line 479
;479:	s_startserver.framer.height  	   = 334;
ADDRGP4 s_startserver+448+80
CNSTI4 334
ASGNI4
line 481
;480:
;481:	s_startserver.gametype.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_startserver+536
CNSTI4 3
ASGNI4
line 482
;482:	s_startserver.gametype.generic.name		= "Game Type:";
ADDRGP4 s_startserver+536+4
ADDRGP4 $309
ASGNP4
line 483
;483:	s_startserver.gametype.generic.flags	= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_startserver+536+44
CNSTU4 258
ASGNU4
line 484
;484:	s_startserver.gametype.generic.callback	= StartServer_GametypeEvent;
ADDRGP4 s_startserver+536+48
ADDRGP4 StartServer_GametypeEvent
ASGNP4
line 485
;485:	s_startserver.gametype.generic.id		= ID_GAMETYPE;
ADDRGP4 s_startserver+536+8
CNSTI4 10
ASGNI4
line 486
;486:	s_startserver.gametype.generic.x		= 320 - 24;
ADDRGP4 s_startserver+536+12
CNSTI4 296
ASGNI4
line 487
;487:	s_startserver.gametype.generic.y		= 368;
ADDRGP4 s_startserver+536+16
CNSTI4 368
ASGNI4
line 488
;488:	s_startserver.gametype.itemnames		= gametype_items;
ADDRGP4 s_startserver+536+76
ADDRGP4 gametype_items
ASGNP4
line 490
;489:
;490:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $322
line 491
;491:	{
line 492
;492:		x =	(i % MAX_MAPCOLS) * (128+8) + 188;
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
line 493
;493:		y = (i / MAX_MAPROWS) * (128+8) + 96;
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
line 495
;494:
;495:		s_startserver.mappics[i].generic.type   = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632
ADDP4
CNSTI4 6
ASGNI4
line 496
;496:		s_startserver.mappics[i].generic.flags  = QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+44
ADDP4
CNSTU4 16388
ASGNU4
line 497
;497:		s_startserver.mappics[i].generic.x	    = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 498
;498:		s_startserver.mappics[i].generic.y	    = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 499
;499:		s_startserver.mappics[i].generic.id		= ID_PICTURES+i;
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
line 500
;500:		s_startserver.mappics[i].width  		= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+76
ADDP4
CNSTI4 128
ASGNI4
line 501
;501:		s_startserver.mappics[i].height  	    = 96;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+80
ADDP4
CNSTI4 96
ASGNI4
line 502
;502:		s_startserver.mappics[i].focuspic       = GAMESERVER_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+60
ADDP4
ADDRGP4 $341
ASGNP4
line 503
;503:		s_startserver.mappics[i].errorpic       = GAMESERVER_UNKNOWNMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+64
ADDP4
ADDRGP4 $344
ASGNP4
line 504
;504:		s_startserver.mappics[i].generic.ownerdraw = StartServer_LevelshotDraw;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+632+56
ADDP4
ADDRGP4 StartServer_LevelshotDraw
ASGNP4
line 506
;505:
;506:		s_startserver.mapbuttons[i].generic.type     = MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984
ADDP4
CNSTI4 6
ASGNI4
line 507
;507:		s_startserver.mapbuttons[i].generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_NODEFAULTINIT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+44
ADDP4
CNSTU4 33028
ASGNU4
line 508
;508:		s_startserver.mapbuttons[i].generic.id       = ID_PICTURES+i;
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
line 509
;509:		s_startserver.mapbuttons[i].generic.callback = StartServer_MapEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+48
ADDP4
ADDRGP4 StartServer_MapEvent
ASGNP4
line 510
;510:		s_startserver.mapbuttons[i].generic.x	     = x - 30;
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
line 511
;511:		s_startserver.mapbuttons[i].generic.y	     = y - 32;
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
line 512
;512:		s_startserver.mapbuttons[i].width  		     = 256;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+76
ADDP4
CNSTI4 256
ASGNI4
line 513
;513:		s_startserver.mapbuttons[i].height  	     = 248;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+80
ADDP4
CNSTI4 248
ASGNI4
line 514
;514:		s_startserver.mapbuttons[i].generic.left     = x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 515
;515:		s_startserver.mapbuttons[i].generic.top  	 = y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 516
;516:		s_startserver.mapbuttons[i].generic.right    = x + 128;
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
line 517
;517:		s_startserver.mapbuttons[i].generic.bottom   = y + 128;
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
line 518
;518:		s_startserver.mapbuttons[i].focuspic         = GAMESERVER_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_startserver+984+60
ADDP4
ADDRGP4 $372
ASGNP4
line 519
;519:	}
LABELV $323
line 490
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $322
line 521
;520:
;521:	s_startserver.arrows.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_startserver+1336
CNSTI4 6
ASGNI4
line 522
;522:	s_startserver.arrows.generic.name  = GAMESERVER_ARROWS;
ADDRGP4 s_startserver+1336+4
ADDRGP4 $376
ASGNP4
line 523
;523:	s_startserver.arrows.generic.flags = QMF_INACTIVE;
ADDRGP4 s_startserver+1336+44
CNSTU4 16384
ASGNU4
line 524
;524:	s_startserver.arrows.generic.x	   = 260;
ADDRGP4 s_startserver+1336+12
CNSTI4 260
ASGNI4
line 525
;525:	s_startserver.arrows.generic.y	   = 400;
ADDRGP4 s_startserver+1336+16
CNSTI4 400
ASGNI4
line 526
;526:	s_startserver.arrows.width  	   = 128;
ADDRGP4 s_startserver+1336+76
CNSTI4 128
ASGNI4
line 527
;527:	s_startserver.arrows.height  	   = 32;
ADDRGP4 s_startserver+1336+80
CNSTI4 32
ASGNI4
line 529
;528:
;529:	s_startserver.prevpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1424
CNSTI4 6
ASGNI4
line 530
;530:	s_startserver.prevpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1424+44
CNSTU4 260
ASGNU4
line 531
;531:	s_startserver.prevpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1424+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 532
;532:	s_startserver.prevpage.generic.id	    = ID_PREVPAGE;
ADDRGP4 s_startserver+1424+8
CNSTI4 15
ASGNI4
line 533
;533:	s_startserver.prevpage.generic.x		= 260;
ADDRGP4 s_startserver+1424+12
CNSTI4 260
ASGNI4
line 534
;534:	s_startserver.prevpage.generic.y		= 400;
ADDRGP4 s_startserver+1424+16
CNSTI4 400
ASGNI4
line 535
;535:	s_startserver.prevpage.width  		    = 64;
ADDRGP4 s_startserver+1424+76
CNSTI4 64
ASGNI4
line 536
;536:	s_startserver.prevpage.height  		    = 32;
ADDRGP4 s_startserver+1424+80
CNSTI4 32
ASGNI4
line 537
;537:	s_startserver.prevpage.focuspic         = GAMESERVER_ARROWSL;
ADDRGP4 s_startserver+1424+60
ADDRGP4 $404
ASGNP4
line 539
;538:
;539:	s_startserver.nextpage.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1512
CNSTI4 6
ASGNI4
line 540
;540:	s_startserver.nextpage.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1512+44
CNSTU4 260
ASGNU4
line 541
;541:	s_startserver.nextpage.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1512+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 542
;542:	s_startserver.nextpage.generic.id	    = ID_NEXTPAGE;
ADDRGP4 s_startserver+1512+8
CNSTI4 16
ASGNI4
line 543
;543:	s_startserver.nextpage.generic.x		= 321;
ADDRGP4 s_startserver+1512+12
CNSTI4 321
ASGNI4
line 544
;544:	s_startserver.nextpage.generic.y		= 400;
ADDRGP4 s_startserver+1512+16
CNSTI4 400
ASGNI4
line 545
;545:	s_startserver.nextpage.width  		    = 64;
ADDRGP4 s_startserver+1512+76
CNSTI4 64
ASGNI4
line 546
;546:	s_startserver.nextpage.height  		    = 32;
ADDRGP4 s_startserver+1512+80
CNSTI4 32
ASGNI4
line 547
;547:	s_startserver.nextpage.focuspic         = GAMESERVER_ARROWSR;
ADDRGP4 s_startserver+1512+60
ADDRGP4 $422
ASGNP4
line 549
;548:
;549:	s_startserver.mapname.generic.type  = MTYPE_PTEXT;
ADDRGP4 s_startserver+1776
CNSTI4 9
ASGNI4
line 550
;550:	s_startserver.mapname.generic.flags = QMF_CENTER_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_startserver+1776+44
CNSTU4 16392
ASGNU4
line 551
;551:	s_startserver.mapname.generic.x	    = 320;
ADDRGP4 s_startserver+1776+12
CNSTI4 320
ASGNI4
line 552
;552:	s_startserver.mapname.generic.y	    = 440;
ADDRGP4 s_startserver+1776+16
CNSTI4 440
ASGNI4
line 553
;553:	s_startserver.mapname.string        = mapnamebuffer;
ADDRGP4 s_startserver+1776+60
ADDRGP4 $263
ASGNP4
line 554
;554:	s_startserver.mapname.style         = UI_CENTER|UI_BIGFONT;
ADDRGP4 s_startserver+1776+64
CNSTI4 33
ASGNI4
line 555
;555:	s_startserver.mapname.color         = text_color_normal;
ADDRGP4 s_startserver+1776+68
ADDRGP4 text_color_normal
ASGNP4
line 557
;556:
;557:	s_startserver.back.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1600
CNSTI4 6
ASGNI4
line 558
;558:	s_startserver.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_startserver+1600+4
ADDRGP4 $439
ASGNP4
line 559
;559:	s_startserver.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1600+44
CNSTU4 260
ASGNU4
line 560
;560:	s_startserver.back.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1600+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 561
;561:	s_startserver.back.generic.id	    = ID_STARTSERVERBACK;
ADDRGP4 s_startserver+1600+8
CNSTI4 17
ASGNI4
line 562
;562:	s_startserver.back.generic.x		= 0;
ADDRGP4 s_startserver+1600+12
CNSTI4 0
ASGNI4
line 563
;563:	s_startserver.back.generic.y		= 480-64;
ADDRGP4 s_startserver+1600+16
CNSTI4 416
ASGNI4
line 564
;564:	s_startserver.back.width  		    = 128;
ADDRGP4 s_startserver+1600+76
CNSTI4 128
ASGNI4
line 565
;565:	s_startserver.back.height  		    = 64;
ADDRGP4 s_startserver+1600+80
CNSTI4 64
ASGNI4
line 566
;566:	s_startserver.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_startserver+1600+60
ADDRGP4 $456
ASGNP4
line 568
;567:
;568:	s_startserver.next.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_startserver+1688
CNSTI4 6
ASGNI4
line 569
;569:	s_startserver.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_startserver+1688+4
ADDRGP4 $460
ASGNP4
line 570
;570:	s_startserver.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_startserver+1688+44
CNSTU4 272
ASGNU4
line 571
;571:	s_startserver.next.generic.callback = StartServer_MenuEvent;
ADDRGP4 s_startserver+1688+48
ADDRGP4 StartServer_MenuEvent
ASGNP4
line 572
;572:	s_startserver.next.generic.id	    = ID_STARTSERVERNEXT;
ADDRGP4 s_startserver+1688+8
CNSTI4 18
ASGNI4
line 573
;573:	s_startserver.next.generic.x		= 640;
ADDRGP4 s_startserver+1688+12
CNSTI4 640
ASGNI4
line 574
;574:	s_startserver.next.generic.y		= 480-64;
ADDRGP4 s_startserver+1688+16
CNSTI4 416
ASGNI4
line 575
;575:	s_startserver.next.width  		    = 128;
ADDRGP4 s_startserver+1688+76
CNSTI4 128
ASGNI4
line 576
;576:	s_startserver.next.height  		    = 64;
ADDRGP4 s_startserver+1688+80
CNSTI4 64
ASGNI4
line 577
;577:	s_startserver.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_startserver+1688+60
ADDRGP4 $477
ASGNP4
line 579
;578:
;579:	s_startserver.item_null.generic.type	= MTYPE_BITMAP;
ADDRGP4 s_startserver+1848
CNSTI4 6
ASGNI4
line 580
;580:	s_startserver.item_null.generic.flags	= QMF_LEFT_JUSTIFY|QMF_MOUSEONLY|QMF_SILENT;
ADDRGP4 s_startserver+1848+44
CNSTU4 1050628
ASGNU4
line 581
;581:	s_startserver.item_null.generic.x		= 0;
ADDRGP4 s_startserver+1848+12
CNSTI4 0
ASGNI4
line 582
;582:	s_startserver.item_null.generic.y		= 0;
ADDRGP4 s_startserver+1848+16
CNSTI4 0
ASGNI4
line 583
;583:	s_startserver.item_null.width			= 640;
ADDRGP4 s_startserver+1848+76
CNSTI4 640
ASGNI4
line 584
;584:	s_startserver.item_null.height			= 480;
ADDRGP4 s_startserver+1848+80
CNSTI4 480
ASGNI4
line 586
;585:
;586:	Menu_AddItem( &s_startserver.menu, &s_startserver.banner );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 587
;587:	Menu_AddItem( &s_startserver.menu, &s_startserver.framel );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 588
;588:	Menu_AddItem( &s_startserver.menu, &s_startserver.framer );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 590
;589:
;590:	Menu_AddItem( &s_startserver.menu, &s_startserver.gametype );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 591
;591:	for (i=0; i<MAX_MAPSPERPAGE; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $493
line 592
;592:	{
line 593
;593:		Menu_AddItem( &s_startserver.menu, &s_startserver.mappics[i] );
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
line 594
;594:		Menu_AddItem( &s_startserver.menu, &s_startserver.mapbuttons[i] );
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
line 595
;595:	}
LABELV $494
line 591
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $493
line 597
;596:
;597:	Menu_AddItem( &s_startserver.menu, &s_startserver.arrows );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1336
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 598
;598:	Menu_AddItem( &s_startserver.menu, &s_startserver.prevpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1424
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 599
;599:	Menu_AddItem( &s_startserver.menu, &s_startserver.nextpage );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1512
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 600
;600:	Menu_AddItem( &s_startserver.menu, &s_startserver.back );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1600
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 601
;601:	Menu_AddItem( &s_startserver.menu, &s_startserver.next );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1688
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 602
;602:	Menu_AddItem( &s_startserver.menu, &s_startserver.mapname );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1776
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 603
;603:	Menu_AddItem( &s_startserver.menu, &s_startserver.item_null );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 s_startserver+1848
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 605
;604:
;605:	StartServer_GametypeEvent( NULL, QM_ACTIVATED );
CNSTP4 0
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 StartServer_GametypeEvent
CALLV
pop
line 606
;606:}
LABELV $262
endproc StartServer_MenuInit 20 12
export StartServer_Cache
proc StartServer_Cache 100 16
line 615
;607:
;608:
;609:/*
;610:=================
;611:StartServer_Cache
;612:=================
;613:*/
;614:void StartServer_Cache( void )
;615:{
line 621
;616:	int				i;
;617:	const char		*info;
;618:	qboolean		precache;
;619:	char			picname[64];
;620:
;621:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );	
ADDRGP4 $439
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 622
;622:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );	
ADDRGP4 $456
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 623
;623:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT0 );	
ADDRGP4 $460
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 624
;624:	trap_R_RegisterShaderNoMip( GAMESERVER_NEXT1 );	
ADDRGP4 $477
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 625
;625:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMEL );	
ADDRGP4 $281
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 626
;626:	trap_R_RegisterShaderNoMip( GAMESERVER_FRAMER );	
ADDRGP4 $295
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 627
;627:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );	
ADDRGP4 $372
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 628
;628:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECTED );	
ADDRGP4 $341
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 629
;629:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $344
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 630
;630:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWS );
ADDRGP4 $376
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 631
;631:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSL );
ADDRGP4 $404
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 632
;632:	trap_R_RegisterShaderNoMip( GAMESERVER_ARROWSR );
ADDRGP4 $422
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 634
;633:
;634:	precache = trap_Cvar_VariableValue("com_buildscript");
ADDRGP4 $507
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
line 636
;635:
;636:	s_startserver.nummaps = UI_GetNumArenas();
ADDRLP4 80
ADDRGP4 UI_GetNumArenas
CALLI4
ASGNI4
ADDRGP4 s_startserver+1944
ADDRLP4 80
INDIRI4
ASGNI4
line 638
;637:
;638:	for( i = 0; i < s_startserver.nummaps; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $512
JUMPV
LABELV $509
line 639
;639:		info = UI_GetArenaInfoByNumber( i );
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
line 641
;640:
;641:		Q_strncpyz( s_startserver.maplist[i], Info_ValueForKey( info, "map"), MAX_NAMELENGTH );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $191
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
line 642
;642:		Q_strupr( s_startserver.maplist[i] );
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
line 643
;643:		s_startserver.mapGamebits[i] = GametypeBits( Info_ValueForKey( info, "type") );
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 $186
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
line 645
;644:
;645:		if( precache ) {
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $517
line 646
;646:			Com_sprintf( picname, sizeof(picname), "levelshots/%s", s_startserver.maplist[i] );
ADDRLP4 8
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $108
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
line 647
;647:			trap_R_RegisterShaderNoMip(picname);
ADDRLP4 8
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 648
;648:		}
LABELV $517
line 649
;649:	}
LABELV $510
line 638
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $512
ADDRLP4 0
INDIRI4
ADDRGP4 s_startserver+1944
INDIRI4
LTI4 $509
line 651
;650:
;651:	s_startserver.maxpages = (s_startserver.nummaps + MAX_MAPSPERPAGE-1)/MAX_MAPSPERPAGE;
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
line 652
;652:}
LABELV $506
endproc StartServer_Cache 100 16
export UI_StartServerMenu
proc UI_StartServerMenu 0 4
line 660
;653:
;654:
;655:/*
;656:=================
;657:UI_StartServerMenu
;658:=================
;659:*/
;660:void UI_StartServerMenu( qboolean multiplayer ) {
line 661
;661:	StartServer_MenuInit();
ADDRGP4 StartServer_MenuInit
CALLV
pop
line 662
;662:	s_startserver.multiplayer = multiplayer;
ADDRGP4 s_startserver+1936
ADDRFP4 0
INDIRI4
ASGNI4
line 663
;663:	UI_PushMenu( &s_startserver.menu );
ADDRGP4 s_startserver
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 664
;664:}
LABELV $522
endproc UI_StartServerMenu 0 4
data
align 4
LABELV dedicated_list
address $525
address $526
address $527
byte 4 0
align 4
LABELV playerType_list
address $528
address $529
address $530
byte 4 0
align 4
LABELV playerTeam_list
address $531
address $532
byte 4 0
align 4
LABELV botSkill_list
address $533
address $534
address $535
address $536
address $537
byte 4 0
align 4
LABELV assaultMiddleItem_list
address $538
address $539
address $540
address $541
address $542
address $543
address $544
address $545
address $546
address $547
address $548
address $549
address $550
address $551
byte 4 0
align 4
LABELV respawnTime_list
address $552
address $553
address $554
address $555
address $556
address $557
address $558
address $559
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
line 813
;665:
;666:
;667:
;668:/*
;669:=============================================================================
;670:
;671:SERVER OPTIONS MENU *****
;672:
;673:=============================================================================
;674:*/
;675:
;676:#define ID_PLAYER_TYPE			20
;677:#define ID_MAXCLIENTS			21
;678:#define ID_DEDICATED			22
;679:#define ID_GO					23
;680:#define ID_BACK					24
;681:
;682:#define PLAYER_SLOTS			12
;683:
;684:
;685:typedef struct {
;686:	menuframework_s		menu;
;687:
;688:	menutext_s			banner;
;689:
;690:	menubitmap_s		mappic;
;691:	menubitmap_s		picframe;
;692:
;693:	menulist_s			dedicated;
;694:	menufield_s			timelimit;
;695:	menufield_s			fraglimit;
;696:	menufield_s			flaglimit;
;697:	menuradiobutton_s	friendlyfire;
;698:	menufield_s			hostname;
;699:	menuradiobutton_s	pure;
;700:	menulist_s			botSkill;
;701:	menufield_s			additionalSlots;
;702:	menuradiobutton_s	noPowerups;
;703:	menuradiobutton_s	noHealth;
;704:	menuradiobutton_s	noArmor;
;705:	menuradiobutton_s	noMegaHealth;
;706:	menuradiobutton_s	noPersonalTeleporter;
;707:	menuradiobutton_s	noPlasmaBFG;
;708:	menuradiobutton_s	noGrenadeRocket;
;709:	menuradiobutton_s 	noRailgun;
;710:	menuradiobutton_s	enableBlaster;
;711:	menulist_s 			assaultMiddleItem;
;712:	menulist_s 			respawnTime;
;713:
;714:	menutext_s			player0;
;715:	menulist_s			playerType[PLAYER_SLOTS];
;716:	menutext_s			playerName[PLAYER_SLOTS];
;717:	menulist_s			playerTeam[PLAYER_SLOTS];
;718:
;719:	menubitmap_s		go;
;720:	menubitmap_s		next;
;721:	menubitmap_s		back;
;722:
;723:	qboolean			multiplayer;
;724:	int					gametype;
;725:	char				mapnamebuffer[32];
;726:	char				playerNameBuffers[PLAYER_SLOTS][16];
;727:
;728:	qboolean			newBot;
;729:	int					newBotIndex;
;730:	char				newBotName[16];
;731:	
;732:	menulist_s		punkbuster;
;733:} serveroptions_t;
;734:
;735:static serveroptions_t s_serveroptions;
;736:
;737:static const char *dedicated_list[] = {
;738:	"No",
;739:	"LAN",
;740:	"Internet",
;741:	0
;742:};
;743:
;744:static const char *playerType_list[] = {
;745:	"Open",
;746:	"Bot",
;747:	"----",
;748:	0
;749:};
;750:
;751:static const char *playerTeam_list[] = {
;752:	"Blue",
;753:	"Red",
;754:	0
;755:};
;756:
;757:static const char *botSkill_list[] = {
;758:	"I Can Win",
;759:	"Bring It On",
;760:	"Hurt Me Plenty",
;761:	"Hardcore",
;762:	"Nightmare!",
;763:	0
;764:};
;765:
;766:
;767:static const char *assaultMiddleItem_list[] = {
;768:	"All",
;769:	"Heavy Armor",
;770:	"Armor",
;771:	"Mega Health",
;772:	"Medkit",
;773:	"Haste",
;774:	"BFG",
;775:	"Railgun",
;776:	"Shotgun",
;777:	"Rocket Launcher",
;778:	"Grenade Launcher",
;779:	"Lightning Gun",
;780:	"Personal Teleporter",
;781:	"Plasma Gun",
;782:	0
;783:};
;784:
;785:static const char *respawnTime_list[] = {
;786:	"Default",
;787:	"2 seconds",
;788:	"3 seconds",
;789:	"5 seconds",
;790:	"7 seconds",
;791:	"10 seconds",
;792:	"15 seconds",
;793:	"20 seconds",
;794:	0
;795:};
;796:
;797:static int respawnTime_values[] = {
;798:	0,
;799:	2,
;800:	3,
;801:	5,
;802:	7,
;803:	10,
;804:	15,
;805:	20
;806:};
;807:
;808:/*
;809:=================
;810:BotAlreadySelected
;811:=================
;812:*/
;813:static qboolean BotAlreadySelected( const char *checkName ) {
line 816
;814:	int		n;
;815:
;816:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $561
line 817
;817:		if( s_serveroptions.playerType[n].curvalue != 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $565
line 818
;818:			continue;
ADDRGP4 $562
JUMPV
LABELV $565
line 820
;819:		}
;820:		if( (s_serveroptions.gametype >= GT_TEAM) &&
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $569
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
EQI4 $569
line 821
;821:			(s_serveroptions.playerTeam[n].curvalue != s_serveroptions.playerTeam[s_serveroptions.newBotIndex].curvalue ) ) {
line 822
;822:			continue;
ADDRGP4 $562
JUMPV
LABELV $569
line 824
;823:		}
;824:		if( Q_stricmp( checkName, s_serveroptions.playerNameBuffers[n] ) == 0 ) {
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
NEI4 $577
line 825
;825:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $560
JUMPV
LABELV $577
line 827
;826:		}
;827:	}
LABELV $562
line 816
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $561
line 829
;828:
;829:	return qfalse;
CNSTI4 0
RETI4
LABELV $560
endproc BotAlreadySelected 12 8
proc ServerOptions_Start 192 24
line 838
;830:}
;831:
;832:
;833:/*
;834:=================
;835:ServerOptions_Start
;836:=================
;837:*/
;838:static void ServerOptions_Start( void ) {
line 851
;839:	int		timelimit;
;840:	int		fraglimit;
;841:	int		maxclients;
;842:	int		additionalSlots;
;843:	int		dedicated;
;844:	int		friendlyfire;
;845:	int		flaglimit;
;846:	int		pure;
;847:	int		skill;
;848:	int		n;
;849:	char		buf[64];
;850:	
;851:	trap_Cvar_SetValue(
ADDRGP4 $581
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
line 858
;852:		"g_respawnTime",
;853:		respawnTime_values[
;854:			s_serveroptions.respawnTime.curvalue
;855:		]
;856:	);
;857:	
;858:	trap_Cmd_ExecuteText(
ADDRGP4 $584
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
line 866
;859:		EXEC_APPEND,
;860:		va(
;861:			"seta ui_respawnTime \"%i\"\n",
;862:			s_serveroptions.respawnTime.curvalue
;863:		)
;864:	);
;865:	
;866:	trap_Cvar_SetValue(
ADDRGP4 $587
ARGP4
ADDRGP4 s_serveroptions+3092+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 871
;867:		"g_assaultMiddleItem",
;868:		s_serveroptions.assaultMiddleItem.curvalue
;869:	);
;870:
;871:	trap_Cmd_ExecuteText(
ADDRGP4 $590
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
line 879
;872:		EXEC_APPEND,
;873:		va(
;874:			"seta ui_assaultMiddleItem \"%i\"\n",
;875:			s_serveroptions.assaultMiddleItem.curvalue
;876:		)
;877:	);
;878:
;879:	timelimit =
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
line 882
;880:		atoi( s_serveroptions.timelimit.field.buffer );
;881:
;882:	fraglimit =
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
line 885
;883:		atoi( s_serveroptions.fraglimit.field.buffer );
;884:
;885:	flaglimit =
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
line 888
;886:		atoi( s_serveroptions.flaglimit.field.buffer );
;887:
;888:	dedicated =
ADDRLP4 80
ADDRGP4 s_serveroptions+536+64
INDIRI4
ASGNI4
line 891
;889:		s_serveroptions.dedicated.curvalue;
;890:
;891:	friendlyfire =
ADDRLP4 92
ADDRGP4 s_serveroptions+1628+60
INDIRI4
ASGNI4
line 894
;892:		s_serveroptions.friendlyfire.curvalue;
;893:
;894:	pure =
ADDRLP4 100
ADDRGP4 s_serveroptions+2024+60
INDIRI4
ASGNI4
line 897
;895:		s_serveroptions.pure.curvalue;
;896:
;897:	skill =
ADDRLP4 72
ADDRGP4 s_serveroptions+2088+64
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 903
;898:		s_serveroptions.botSkill.curvalue + 1;
;899:
;900:	/*
;901:	 * Count all visible player slots which are not closed.
;902:	 */
;903:	for( n = 0, maxclients = 0;
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
ADDRGP4 $613
JUMPV
LABELV $610
line 905
;904:		n < PLAYER_SLOTS;
;905:		n++ ) {
line 906
;906:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $614
line 907
;907:			== 2 ) {
line 908
;908:			continue;
ADDRGP4 $611
JUMPV
LABELV $614
line 911
;909:		}
;910:
;911:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $618
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $618
line 914
;912:			== 1 &&
;913:			s_serveroptions.playerNameBuffers[n][0]
;914:			== 0 ) {
line 915
;915:			continue;
ADDRGP4 $611
JUMPV
LABELV $618
line 918
;916:		}
;917:
;918:		maxclients++;
ADDRLP4 68
ADDRLP4 68
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 919
;919:	}
LABELV $611
line 905
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $613
line 904
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $610
line 924
;920:
;921:	/*
;922:	 * Add extra free slots.
;923:	 */
;924:	additionalSlots = atoi(
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
line 928
;925:		s_serveroptions.additionalSlots.field.buffer
;926:	);
;927:
;928:	additionalSlots = (int)Com_Clamp(
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
line 934
;929:		0,
;930:		MAX_CLIENTS - maxclients,
;931:		additionalSlots
;932:	);
;933:
;934:	trap_Cvar_SetValue(
ADDRGP4 $626
ARGP4
ADDRLP4 76
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 939
;935:		"ui_additionalSlots",
;936:		additionalSlots
;937:	);
;938:
;939:	maxclients += additionalSlots;
ADDRLP4 68
ADDRLP4 68
INDIRI4
ADDRLP4 76
INDIRI4
ADDI4
ASGNI4
line 944
;940:
;941:	/*
;942:	 * Powerups.
;943:	 */
;944:	trap_Cvar_SetValue(
ADDRGP4 $627
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 949
;945:		"ui_noPowerups",
;946:		s_serveroptions.noPowerups.curvalue
;947:	);
;948:
;949:	trap_Cvar_SetValue(
ADDRGP4 $630
ARGP4
ADDRGP4 s_serveroptions+2516+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 957
;950:		"g_noPowerups",
;951:		s_serveroptions.noPowerups.curvalue
;952:	);
;953:
;954:	/*
;955:	 * Mega Health and Medkit share one menu option.
;956:	 */
;957:	trap_Cvar_SetValue(
ADDRGP4 $633
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 962
;958:		"ui_noMegaHealth",
;959:		s_serveroptions.noMegaHealth.curvalue
;960:	);
;961:
;962:	trap_Cvar_SetValue(
ADDRGP4 $636
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 967
;963:		"g_noMegaHealth",
;964:		s_serveroptions.noMegaHealth.curvalue
;965:	);
;966:
;967:	trap_Cvar_SetValue(
ADDRGP4 $639
ARGP4
ADDRGP4 s_serveroptions+2708+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 975
;968:		"g_noMedkit",
;969:		s_serveroptions.noMegaHealth.curvalue
;970:	);
;971:
;972:	/*
;973:	 * Personal Teleporter.
;974:	 */
;975:	trap_Cvar_SetValue(
ADDRGP4 $642
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 980
;976:		"ui_noPersonalTeleporter",
;977:		s_serveroptions.noPersonalTeleporter.curvalue
;978:	);
;979:
;980:	trap_Cvar_SetValue(
ADDRGP4 $645
ARGP4
ADDRGP4 s_serveroptions+2772+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 985
;981:		"g_noPersonalTeleporter",
;982:		s_serveroptions.noPersonalTeleporter.curvalue
;983:	);
;984:
;985:	trap_Cmd_ExecuteText(
ADDRGP4 $648
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
line 995
;986:		EXEC_APPEND,
;987:		va(
;988:			"seta ui_noMegaHealth \"%i\"\n"
;989:			"seta ui_noPersonalTeleporter \"%i\"\n",
;990:			s_serveroptions.noMegaHealth.curvalue,
;991:			s_serveroptions.noPersonalTeleporter.curvalue
;992:		)
;993:	);
;994:
;995:	trap_Cmd_ExecuteText(
ADDRGP4 $653
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
line 1006
;996:		EXEC_APPEND,
;997:		va(
;998:			"seta ui_noPowerups \"%i\"\n",
;999:			s_serveroptions.noPowerups.curvalue
;1000:		)
;1001:	);
;1002:
;1003:	/*
;1004:	 * Store limits for the selected game type.
;1005:	 */
;1006:	switch( s_serveroptions.gametype ) {
ADDRLP4 144
ADDRGP4 s_serveroptions+6792
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $656
ADDRLP4 144
INDIRI4
CNSTI4 4
GTI4 $656
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $673
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $673
address $659
address $662
address $656
address $665
address $669
code
LABELV $659
LABELV $656
line 1009
;1007:	case GT_FFA:
;1008:	default:
;1009:		trap_Cvar_SetValue(
ADDRGP4 $660
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1014
;1010:			"ui_ffa_fraglimit",
;1011:			fraglimit
;1012:		);
;1013:
;1014:		trap_Cvar_SetValue(
ADDRGP4 $661
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1018
;1015:			"ui_ffa_timelimit",
;1016:			timelimit
;1017:		);
;1018:		break;
ADDRGP4 $657
JUMPV
LABELV $662
line 1021
;1019:
;1020:	case GT_TOURNAMENT:
;1021:		trap_Cvar_SetValue(
ADDRGP4 $663
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1026
;1022:			"ui_tourney_fraglimit",
;1023:			fraglimit
;1024:		);
;1025:
;1026:		trap_Cvar_SetValue(
ADDRGP4 $664
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1030
;1027:			"ui_tourney_timelimit",
;1028:			timelimit
;1029:		);
;1030:		break;
ADDRGP4 $657
JUMPV
LABELV $665
line 1033
;1031:
;1032:	case GT_TEAM:
;1033:		trap_Cvar_SetValue(
ADDRGP4 $666
ARGP4
ADDRLP4 88
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1038
;1034:			"ui_team_fraglimit",
;1035:			fraglimit
;1036:		);
;1037:
;1038:		trap_Cvar_SetValue(
ADDRGP4 $667
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1043
;1039:			"ui_team_timelimit",
;1040:			timelimit
;1041:		);
;1042:
;1043:		trap_Cvar_SetValue(
ADDRGP4 $668
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1047
;1044:			"ui_team_friendly",
;1045:			friendlyfire
;1046:		);
;1047:		break;
ADDRGP4 $657
JUMPV
LABELV $669
line 1050
;1048:
;1049:	case GT_CTF:
;1050:		trap_Cvar_SetValue(
ADDRGP4 $670
ARGP4
ADDRLP4 96
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1055
;1051:			"ui_ctf_capturelimit",
;1052:			flaglimit
;1053:		);
;1054:
;1055:		trap_Cvar_SetValue(
ADDRGP4 $671
ARGP4
ADDRLP4 84
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1060
;1056:			"ui_ctf_timelimit",
;1057:			timelimit
;1058:		);
;1059:
;1060:		trap_Cvar_SetValue(
ADDRGP4 $672
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1064
;1061:			"ui_ctf_friendly",
;1062:			friendlyfire
;1063:		);
;1064:		break;
LABELV $657
line 1070
;1065:	}
;1066:
;1067:	/*
;1068:	 * General server settings.
;1069:	 */
;1070:	trap_Cvar_SetValue(
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
ADDRGP4 $674
ARGP4
ADDRLP4 148
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1079
;1071:		"sv_maxclients",
;1072:		Com_Clamp(
;1073:			1,
;1074:			MAX_CLIENTS,
;1075:			maxclients
;1076:		)
;1077:	);
;1078:
;1079:	trap_Cvar_SetValue(
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
ADDRGP4 $675
ARGP4
ADDRLP4 152
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1088
;1080:		"dedicated",
;1081:		Com_Clamp(
;1082:			0,
;1083:			2,
;1084:			dedicated
;1085:		)
;1086:	);
;1087:
;1088:	trap_Cvar_SetValue(
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
ADDRGP4 $676
ARGP4
ADDRLP4 156
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1097
;1089:		"timelimit",
;1090:		Com_Clamp(
;1091:			0,
;1092:			999,
;1093:			timelimit
;1094:		)
;1095:	);
;1096:
;1097:	trap_Cvar_SetValue(
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
ADDRGP4 $677
ARGP4
ADDRLP4 160
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1106
;1098:		"fraglimit",
;1099:		Com_Clamp(
;1100:			0,
;1101:			999,
;1102:			fraglimit
;1103:		)
;1104:	);
;1105:
;1106:	trap_Cvar_SetValue(
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
ADDRGP4 $678
ARGP4
ADDRLP4 164
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1115
;1107:		"capturelimit",
;1108:		Com_Clamp(
;1109:			0,
;1110:			100,
;1111:			flaglimit
;1112:		)
;1113:	);
;1114:
;1115:	trap_Cvar_SetValue(
ADDRGP4 $679
ARGP4
ADDRLP4 92
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1120
;1116:		"g_friendlyfire",
;1117:		friendlyfire
;1118:	);
;1119:
;1120:	trap_Cvar_SetValue(
ADDRGP4 $680
ARGP4
ADDRLP4 100
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1125
;1121:		"sv_pure",
;1122:		pure
;1123:	);
;1124:
;1125:	trap_Cvar_Set(
ADDRGP4 $681
ARGP4
ADDRGP4 s_serveroptions+1692+60+12
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1130
;1126:		"sv_hostname",
;1127:		s_serveroptions.hostname.field.buffer
;1128:	);
;1129:
;1130:	trap_Cvar_SetValue(
ADDRGP4 $685
ARGP4
ADDRGP4 s_serveroptions+7044+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1138
;1131:		"sv_punkbuster",
;1132:		s_serveroptions.punkbuster.curvalue
;1133:	);
;1134:
;1135:	/*
;1136:	 * Blaster Mode.
;1137:	 */
;1138:	trap_Cvar_SetValue(
ADDRGP4 $688
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1143
;1139:		"ui_enableBlaster",
;1140:		s_serveroptions.enableBlaster.curvalue
;1141:	);
;1142:
;1143:	trap_Cvar_SetValue(
ADDRGP4 $691
ARGP4
ADDRGP4 s_serveroptions+3028+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1148
;1144:		"g_blasterMode",
;1145:		s_serveroptions.enableBlaster.curvalue
;1146:	);
;1147:
;1148:	trap_Cmd_ExecuteText(
ADDRGP4 $694
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
line 1159
;1149:		EXEC_APPEND,
;1150:		va(
;1151:			"seta ui_enableBlaster \"%i\"\n",
;1152:			s_serveroptions.enableBlaster.curvalue
;1153:		)
;1154:	);
;1155:
;1156:	/*
;1157:	 * Weapon pickup restrictions.
;1158:	 */
;1159:	trap_Cvar_SetValue(
ADDRGP4 $697
ARGP4
ADDRGP4 s_serveroptions+2836+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1164
;1160:		"g_noPlasmaBFG",
;1161:		s_serveroptions.noPlasmaBFG.curvalue
;1162:	);
;1163:
;1164:	trap_Cvar_SetValue(
ADDRGP4 $700
ARGP4
ADDRGP4 s_serveroptions+2900+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1169
;1165:		"g_noGrenadeRocket",
;1166:		s_serveroptions.noGrenadeRocket.curvalue
;1167:	);
;1168:	
;1169:	trap_Cvar_SetValue(
ADDRGP4 $703
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1174
;1170:		"ui_noRailgun",
;1171:		s_serveroptions.noRailgun.curvalue
;1172:	);
;1173:
;1174:	trap_Cvar_SetValue(
ADDRGP4 $706
ARGP4
ADDRGP4 s_serveroptions+2964+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1179
;1175:		"g_noRailgun",
;1176:		s_serveroptions.noRailgun.curvalue
;1177:	);
;1178:
;1179:	trap_Cmd_ExecuteText(
ADDRGP4 $709
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
line 1187
;1180:		EXEC_APPEND,
;1181:		va(
;1182:			"seta ui_noRailgun \"%i\"\n",
;1183:			s_serveroptions.noRailgun.curvalue
;1184:		)
;1185:	);
;1186:
;1187:	trap_Cmd_ExecuteText(
ADDRGP4 $712
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
line 1200
;1188:		EXEC_APPEND,
;1189:		va(
;1190:			"seta ui_noPlasmaBFG \"%i\"\n"
;1191:			"seta ui_noGrenadeRocket \"%i\"\n",
;1192:			s_serveroptions.noPlasmaBFG.curvalue,
;1193:			s_serveroptions.noGrenadeRocket.curvalue
;1194:		)
;1195:	);
;1196:
;1197:	/*
;1198:	 * Health and armor restrictions.
;1199:	 */
;1200:	trap_Cvar_SetValue(
ADDRGP4 $717
ARGP4
ADDRGP4 s_serveroptions+2580+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1205
;1201:		"g_noHealth",
;1202:		s_serveroptions.noHealth.curvalue
;1203:	);
;1204:
;1205:	trap_Cvar_SetValue(
ADDRGP4 $720
ARGP4
ADDRGP4 s_serveroptions+2644+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 1210
;1206:		"g_noArmor",
;1207:		s_serveroptions.noArmor.curvalue
;1208:	);
;1209:
;1210:	trap_Cmd_ExecuteText(
ADDRGP4 $723
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
line 1224
;1211:		EXEC_APPEND,
;1212:		va(
;1213:			"seta ui_noHealth \"%i\"\n"
;1214:			"seta ui_noArmor \"%i\"\n",
;1215:			s_serveroptions.noHealth.curvalue,
;1216:			s_serveroptions.noArmor.curvalue
;1217:		)
;1218:	);
;1219:
;1220:	/*
;1221:	 * Disable any previous map rotation. After the match,
;1222:	 * Quake III will restart the current map.
;1223:	 */
;1224:	trap_Cvar_Set(
ADDRGP4 $728
ARGP4
ADDRGP4 $729
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 1232
;1225:		"nextmap",
;1226:		"map_restart 0"
;1227:	);
;1228:
;1229:	/*
;1230:	 * Start selected map.
;1231:	 */
;1232:	trap_Cmd_ExecuteText(
ADDRGP4 $730
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
line 1245
;1233:		EXEC_APPEND,
;1234:		va(
;1235:			"wait; wait; map %s\n",
;1236:			s_startserver.maplist[
;1237:				s_startserver.currentmap
;1238:			]
;1239:		)
;1240:	);
;1241:
;1242:	/*
;1243:	 * Add selected bots after loading the map.
;1244:	 */
;1245:	trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRGP4 $733
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1250
;1246:		EXEC_APPEND,
;1247:		"wait 3\n"
;1248:	);
;1249:
;1250:	for( n = 1; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $734
line 1251
;1251:		if( s_serveroptions.playerType[n].curvalue
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
EQI4 $738
line 1252
;1252:			!= 1 ) {
line 1253
;1253:			continue;
ADDRGP4 $735
JUMPV
LABELV $738
line 1256
;1254:		}
;1255:
;1256:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $742
line 1257
;1257:			== 0 ) {
line 1258
;1258:			continue;
ADDRGP4 $735
JUMPV
LABELV $742
line 1261
;1259:		}
;1260:
;1261:		if( s_serveroptions.playerNameBuffers[n][0]
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
INDIRI1
CVII4 1
CNSTI4 45
NEI4 $745
line 1262
;1262:			== '-' ) {
line 1263
;1263:			continue;
ADDRGP4 $735
JUMPV
LABELV $745
line 1266
;1264:		}
;1265:
;1266:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $748
line 1267
;1267:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $751
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
line 1278
;1268:				buf,
;1269:				sizeof(buf),
;1270:				"addbot %s %i %s\n",
;1271:				s_serveroptions.playerNameBuffers[n],
;1272:				skill,
;1273:				playerTeam_list[
;1274:					s_serveroptions.playerTeam[n]
;1275:						.curvalue
;1276:				]
;1277:			);
;1278:		}
ADDRGP4 $749
JUMPV
LABELV $748
line 1279
;1279:		else {
line 1280
;1280:			Com_sprintf(
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $755
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
line 1287
;1281:				buf,
;1282:				sizeof(buf),
;1283:				"addbot %s %i\n",
;1284:				s_serveroptions.playerNameBuffers[n],
;1285:				skill
;1286:			);
;1287:		}
LABELV $749
line 1289
;1288:
;1289:		trap_Cmd_ExecuteText(
CNSTI4 2
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 1293
;1290:			EXEC_APPEND,
;1291:			buf
;1292:		);
;1293:	}
LABELV $735
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
LTI4 $734
line 1298
;1294:
;1295:	/*
;1296:	 * Place the local player on the selected team.
;1297:	 */
;1298:	if( dedicated == 0 &&
ADDRLP4 80
INDIRI4
CNSTI4 0
NEI4 $757
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $757
line 1299
;1299:		s_serveroptions.gametype >= GT_TEAM ) {
line 1300
;1300:		trap_Cmd_ExecuteText(
ADDRGP4 $760
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
line 1310
;1301:			EXEC_APPEND,
;1302:			va(
;1303:				"wait 5; team %s\n",
;1304:				playerTeam_list[
;1305:					s_serveroptions.playerTeam[0]
;1306:						.curvalue
;1307:				]
;1308:			)
;1309:		);
;1310:	}
LABELV $757
line 1311
;1311:}
LABELV $580
endproc ServerOptions_Start 192 24
proc ServerOptions_InitPlayerItems 12 12
line 1319
;1312:
;1313:
;1314:/*
;1315:=================
;1316:ServerOptions_InitPlayerItems
;1317:=================
;1318:*/
;1319:static void ServerOptions_InitPlayerItems( void ) {
line 1324
;1320:	int		n;
;1321:	int		v;
;1322:
;1323:	// init types
;1324:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $764
line 1325
;1325:		v = 0;	// open
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1326
;1326:	}
ADDRGP4 $765
JUMPV
LABELV $764
line 1327
;1327:	else {
line 1328
;1328:		v = 1;	// bot
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1329
;1329:	}
LABELV $765
line 1331
;1330:	
;1331:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $767
line 1332
;1332:		s_serveroptions.playerType[n].curvalue = v;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1333
;1333:	}
LABELV $768
line 1331
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $767
line 1335
;1334:
;1335:	if( s_serveroptions.multiplayer && (s_serveroptions.gametype < GT_TEAM) ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $773
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
GEI4 $773
line 1336
;1336:		for( n = 8; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 8
ASGNI4
LABELV $777
line 1337
;1337:			s_serveroptions.playerType[n].curvalue = 2;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 2
ASGNI4
line 1338
;1338:		}
LABELV $778
line 1336
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $777
line 1339
;1339:	}
LABELV $773
line 1342
;1340:
;1341:	// if not a dedicated server, first slot is reserved for the human on the server
;1342:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $783
line 1344
;1343:		// human
;1344:		s_serveroptions.playerType[0].generic.flags |= QMF_INACTIVE;
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
line 1345
;1345:		s_serveroptions.playerType[0].curvalue = 0;
ADDRGP4 s_serveroptions+3356+64
CNSTI4 0
ASGNI4
line 1346
;1346:		trap_Cvar_VariableStringBuffer( "name", s_serveroptions.playerNameBuffers[0], sizeof(s_serveroptions.playerNameBuffers[0]) );
ADDRGP4 $791
ARGP4
ADDRGP4 s_serveroptions+6828
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 1347
;1347:		Q_CleanStr( s_serveroptions.playerNameBuffers[0] );
ADDRGP4 s_serveroptions+6828
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1348
;1348:	}
LABELV $783
line 1351
;1349:
;1350:	// init teams
;1351:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $795
line 1352
;1352:		for( n = 0; n < (PLAYER_SLOTS / 2); n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $798
line 1353
;1353:			s_serveroptions.playerTeam[n].curvalue = 0;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
CNSTI4 0
ASGNI4
line 1354
;1354:		}
LABELV $799
line 1352
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 6
LTI4 $798
line 1355
;1355:		for( ; n < PLAYER_SLOTS; n++ ) {
ADDRGP4 $807
JUMPV
LABELV $804
line 1356
;1356:			s_serveroptions.playerTeam[n].curvalue = 1;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+64
ADDP4
CNSTI4 1
ASGNI4
line 1357
;1357:		}
LABELV $805
line 1355
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $807
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $804
line 1358
;1358:	}
ADDRGP4 $796
JUMPV
LABELV $795
line 1359
;1359:	else {
line 1360
;1360:		for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $810
line 1361
;1361:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
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
line 1362
;1362:		}
LABELV $811
line 1360
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $810
line 1363
;1363:	}
LABELV $796
line 1364
;1364:}
LABELV $763
endproc ServerOptions_InitPlayerItems 12 12
proc ServerOptions_SetPlayerItems 12 0
line 1372
;1365:
;1366:
;1367:/*
;1368:=================
;1369:ServerOptions_SetPlayerItems
;1370:=================
;1371:*/
;1372:static void ServerOptions_SetPlayerItems( void ) {
line 1384
;1373:	int		start;
;1374:	int		n;
;1375:
;1376:	// types
;1377://	for( n = 0; n < PLAYER_SLOTS; n++ ) {
;1378://		if( (!s_serveroptions.multiplayer) && (n > 0) && (s_serveroptions.playerType[n].curvalue == 0) ) {
;1379://			s_serveroptions.playerType[n].curvalue = 1;
;1380://		}
;1381://	}
;1382:
;1383:	// names
;1384:	if( s_serveroptions.dedicated.curvalue == 0 ) {
ADDRGP4 s_serveroptions+536+64
INDIRI4
CNSTI4 0
NEI4 $817
line 1385
;1385:		s_serveroptions.player0.string = "Human";
ADDRGP4 s_serveroptions+3284+60
ADDRGP4 $823
ASGNP4
line 1386
;1386:		s_serveroptions.playerName[0].generic.flags &= ~QMF_HIDDEN;
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
line 1388
;1387:
;1388:		start = 1;
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1389
;1389:	}
ADDRGP4 $818
JUMPV
LABELV $817
line 1390
;1390:	else {
line 1391
;1391:		s_serveroptions.player0.string = "Open";
ADDRGP4 s_serveroptions+3284+60
ADDRGP4 $528
ASGNP4
line 1392
;1392:		start = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 1393
;1393:	}
LABELV $818
line 1394
;1394:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $831
JUMPV
LABELV $828
line 1395
;1395:		if( s_serveroptions.playerType[n].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $832
line 1396
;1396:			s_serveroptions.playerName[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
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
line 1397
;1397:		}
ADDRGP4 $833
JUMPV
LABELV $832
line 1398
;1398:		else {
line 1399
;1399:			s_serveroptions.playerName[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
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
line 1400
;1400:		}
LABELV $833
line 1401
;1401:	}
LABELV $829
line 1394
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $831
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $828
line 1404
;1402:
;1403:	// teams
;1404:	if( s_serveroptions.gametype < GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
GEI4 $840
line 1405
;1405:		return;
ADDRGP4 $816
JUMPV
LABELV $840
line 1407
;1406:	}
;1407:	for( n = start; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $846
JUMPV
LABELV $843
line 1408
;1408:		if( s_serveroptions.playerType[n].curvalue == 2 ) {
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 2
NEI4 $847
line 1409
;1409:			s_serveroptions.playerTeam[n].generic.flags |= (QMF_INACTIVE|QMF_HIDDEN);
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
line 1410
;1410:		}
ADDRGP4 $848
JUMPV
LABELV $847
line 1411
;1411:		else {
line 1412
;1412:			s_serveroptions.playerTeam[n].generic.flags &= ~(QMF_INACTIVE|QMF_HIDDEN);
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
line 1413
;1413:		}
LABELV $848
line 1414
;1414:	}
LABELV $844
line 1407
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $846
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $843
line 1415
;1415:}
LABELV $816
endproc ServerOptions_SetPlayerItems 12 0
proc ServerOptions_Event 8 0
line 1423
;1416:
;1417:
;1418:/*
;1419:=================
;1420:ServerOptions_Event
;1421:=================
;1422:*/
;1423:static void ServerOptions_Event( void* ptr, int event ) {
line 1424
;1424:	switch( ((menucommon_s*)ptr)->id ) {
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
LTI4 $856
ADDRLP4 0
INDIRI4
CNSTI4 24
GTI4 $856
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $872-72
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $872
address $866
address $856
address $859
address $862
address $862
address $863
address $869
code
LABELV $859
line 1430
;1425:	
;1426:	//if( event != QM_ACTIVATED && event != QM_LOSTFOCUS) {
;1427:	//	return;
;1428:	//}
;1429:	case ID_PLAYER_TYPE:
;1430:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $860
line 1431
;1431:			break;
ADDRGP4 $857
JUMPV
LABELV $860
line 1433
;1432:		}
;1433:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1434
;1434:		break;
ADDRGP4 $857
JUMPV
LABELV $862
line 1438
;1435:
;1436:	case ID_MAXCLIENTS:
;1437:	case ID_DEDICATED:
;1438:		ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1439
;1439:		break;
ADDRGP4 $857
JUMPV
LABELV $863
line 1441
;1440:	case ID_GO:
;1441:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $864
line 1442
;1442:			break;
ADDRGP4 $857
JUMPV
LABELV $864
line 1444
;1443:		}
;1444:		ServerOptions_Start();
ADDRGP4 ServerOptions_Start
CALLV
pop
line 1445
;1445:		break;
ADDRGP4 $857
JUMPV
LABELV $866
line 1448
;1446:
;1447:	case ID_STARTSERVERNEXT:
;1448:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $857
line 1449
;1449:			break;
ADDRGP4 $857
JUMPV
line 1451
;1450:		}
;1451:		break;
LABELV $869
line 1453
;1452:	case ID_BACK:
;1453:		if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $870
line 1454
;1454:			break;
ADDRGP4 $857
JUMPV
LABELV $870
line 1456
;1455:		}
;1456:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 1457
;1457:		break;
LABELV $856
LABELV $857
line 1459
;1458:	}
;1459:}
LABELV $855
endproc ServerOptions_Event 8 0
proc ServerOptions_PlayerNameEvent 4 4
line 1462
;1460:
;1461:
;1462:static void ServerOptions_PlayerNameEvent( void* ptr, int event ) {
line 1465
;1463:	int		n;
;1464:
;1465:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $875
line 1466
;1466:		return;
ADDRGP4 $874
JUMPV
LABELV $875
line 1468
;1467:	}
;1468:	n = ((menutext_s*)ptr)->generic.id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1469
;1469:	s_serveroptions.newBotIndex = n;
ADDRGP4 s_serveroptions+7024
ADDRLP4 0
INDIRI4
ASGNI4
line 1470
;1470:	UI_BotSelectMenu( s_serveroptions.playerNameBuffers[n] );
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
line 1471
;1471:}
LABELV $874
endproc ServerOptions_PlayerNameEvent 4 4
proc ServerOptions_StatusBar 4 20
line 1479
;1472:
;1473:
;1474:/*
;1475:=================
;1476:ServerOptions_StatusBar
;1477:=================
;1478:*/
;1479:static void ServerOptions_StatusBar( void* ptr ) {
line 1480
;1480:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $880
JUMPV
LABELV $880
line 1482
;1481:	default:
;1482:		UI_DrawString( 320, 440, "0 = NO LIMIT", UI_CENTER|UI_SMALLFONT, colorWhite );
CNSTI4 320
ARGI4
CNSTI4 440
ARGI4
ADDRGP4 $883
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 colorWhite
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1483
;1483:		break;
LABELV $881
line 1485
;1484:	}
;1485:}
LABELV $879
endproc ServerOptions_StatusBar 4 20
proc ServerOptions_LevelshotDraw 24 20
line 1493
;1486:
;1487:
;1488:/*
;1489:===============
;1490:ServerOptions_LevelshotDraw
;1491:===============
;1492:*/
;1493:static void ServerOptions_LevelshotDraw( void *self ) {
line 1499
;1494:	menubitmap_s	*b;
;1495:	int				x;
;1496:	int				y;
;1497:
;1498:	// strange place for this, but it works
;1499:	if( s_serveroptions.newBot ) {
ADDRGP4 s_serveroptions+7020
INDIRI4
CNSTI4 0
EQI4 $885
line 1500
;1500:		Q_strncpyz( s_serveroptions.playerNameBuffers[s_serveroptions.newBotIndex], s_serveroptions.newBotName, 16 );
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
line 1501
;1501:		s_serveroptions.newBot = qfalse;
ADDRGP4 s_serveroptions+7020
CNSTI4 0
ASGNI4
line 1502
;1502:	}
LABELV $885
line 1504
;1503:
;1504:	b = (menubitmap_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1506
;1505:
;1506:	Bitmap_Draw( b );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Bitmap_Draw
CALLV
pop
line 1508
;1507:
;1508:	x = b->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1509
;1509:	y = b->generic.y + b->height;
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
line 1510
;1510:	UI_FillRect( x, y, b->width, 40, colorBlack );
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
line 1512
;1511:
;1512:	x += b->width / 2;
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
line 1513
;1513:	y += 4;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 4
ADDI4
ASGNI4
line 1514
;1514:	UI_DrawString( x, y, s_serveroptions.mapnamebuffer, UI_CENTER|UI_SMALLFONT, color_orange );
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
line 1516
;1515:
;1516:	y += SMALLCHAR_HEIGHT;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 1517
;1517:	if( trap_Cvar_VariableValue("g_assaultMode") != 0 ) {
ADDRGP4 $237
ARGP4
ADDRLP4 16
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 0
EQF4 $893
line 1518
;1518:	UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $895
ARGP4
CNSTI4 17
ARGI4
ADDRGP4 color_orange
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 1525
;1519:		x,
;1520:		y,
;1521:		"Assault",
;1522:		UI_CENTER | UI_SMALLFONT,
;1523:		color_orange
;1524:	);
;1525:}
ADDRGP4 $894
JUMPV
LABELV $893
line 1526
;1526:else {
line 1527
;1527:	UI_DrawString(
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 20
CNSTI4 2
ASGNI4
ADDRGP4 s_serveroptions+6792
INDIRI4
ADDRLP4 20
INDIRI4
LSHI4
ADDRGP4 gametype_remap2
ADDP4
INDIRI4
ADDRLP4 20
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
line 1536
;1528:		x,
;1529:		y,
;1530:		gametype_items[
;1531:			gametype_remap2[s_serveroptions.gametype]
;1532:		],
;1533:		UI_CENTER | UI_SMALLFONT,
;1534:		color_orange
;1535:	);
;1536:}
LABELV $894
line 1537
;1537:}
LABELV $884
endproc ServerOptions_LevelshotDraw 24 20
proc ServerOptions_InitBotNames 1072 12
line 1540
;1538:
;1539:
;1540:static void ServerOptions_InitBotNames( void ) {
line 1549
;1541:	int			count;
;1542:	int			n;
;1543:	const char	*arenaInfo;
;1544:	const char	*botInfo;
;1545:	char		*p;
;1546:	char		*bot;
;1547:	char		bots[MAX_INFO_STRING];
;1548:
;1549:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $898
line 1550
;1550:		Q_strncpyz( s_serveroptions.playerNameBuffers[1], "grunt", 16 );
ADDRGP4 s_serveroptions+6828+16
ARGP4
ADDRGP4 $903
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1551
;1551:		Q_strncpyz( s_serveroptions.playerNameBuffers[2], "major", 16 );
ADDRGP4 s_serveroptions+6828+32
ARGP4
ADDRGP4 $906
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1552
;1552:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
NEI4 $907
line 1553
;1553:			Q_strncpyz( s_serveroptions.playerNameBuffers[3], "visor", 16 );
ADDRGP4 s_serveroptions+6828+48
ARGP4
ADDRGP4 $912
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1554
;1554:		}
ADDRGP4 $908
JUMPV
LABELV $907
line 1555
;1555:		else {
line 1556
;1556:			s_serveroptions.playerType[3].curvalue = 2;
ADDRGP4 s_serveroptions+3356+288+64
CNSTI4 2
ASGNI4
line 1557
;1557:		}
LABELV $908
line 1558
;1558:		s_serveroptions.playerType[4].curvalue = 2;
ADDRGP4 s_serveroptions+3356+384+64
CNSTI4 2
ASGNI4
line 1559
;1559:		s_serveroptions.playerType[5].curvalue = 2;
ADDRGP4 s_serveroptions+3356+480+64
CNSTI4 2
ASGNI4
line 1561
;1560:
;1561:		Q_strncpyz( s_serveroptions.playerNameBuffers[6], "sarge", 16 );
ADDRGP4 s_serveroptions+6828+96
ARGP4
ADDRGP4 $924
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1562
;1562:		Q_strncpyz( s_serveroptions.playerNameBuffers[7], "grunt", 16 );
ADDRGP4 s_serveroptions+6828+112
ARGP4
ADDRGP4 $903
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1563
;1563:		Q_strncpyz( s_serveroptions.playerNameBuffers[8], "major", 16 );
ADDRGP4 s_serveroptions+6828+128
ARGP4
ADDRGP4 $906
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1564
;1564:		if( s_serveroptions.gametype == GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
NEI4 $929
line 1565
;1565:			Q_strncpyz( s_serveroptions.playerNameBuffers[9], "visor", 16 );
ADDRGP4 s_serveroptions+6828+144
ARGP4
ADDRGP4 $912
ARGP4
CNSTI4 16
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1566
;1566:		}
ADDRGP4 $930
JUMPV
LABELV $929
line 1567
;1567:		else {
line 1568
;1568:			s_serveroptions.playerType[9].curvalue = 2;
ADDRGP4 s_serveroptions+3356+864+64
CNSTI4 2
ASGNI4
line 1569
;1569:		}
LABELV $930
line 1570
;1570:		s_serveroptions.playerType[10].curvalue = 2;
ADDRGP4 s_serveroptions+3356+960+64
CNSTI4 2
ASGNI4
line 1571
;1571:		s_serveroptions.playerType[11].curvalue = 2;
ADDRGP4 s_serveroptions+3356+1056+64
CNSTI4 2
ASGNI4
line 1573
;1572:
;1573:		return;
ADDRGP4 $897
JUMPV
LABELV $898
line 1576
;1574:	}
;1575:
;1576:	count = 1;	// skip the first slot, reserved for a human
ADDRLP4 4
CNSTI4 1
ASGNI4
line 1579
;1577:
;1578:	// get info for this map
;1579:	arenaInfo = UI_GetArenaInfoByMap( s_serveroptions.mapnamebuffer );
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
line 1582
;1580:
;1581:	// get the bot info - we'll seed with them if any are listed
;1582:	Q_strncpyz( bots, Info_ValueForKey( arenaInfo, "bots" ), sizeof(bots) );
ADDRLP4 1044
INDIRP4
ARGP4
ADDRGP4 $944
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
line 1583
;1583:	p = &bots[0];
ADDRLP4 0
ADDRLP4 20
ASGNP4
ADDRGP4 $946
JUMPV
line 1584
;1584:	while( *p && count < PLAYER_SLOTS ) {
LABELV $948
line 1586
;1585:		//skip spaces
;1586:		while( *p && *p == ' ' ) {
line 1587
;1587:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1588
;1588:		}
LABELV $949
line 1586
ADDRLP4 1056
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1056
INDIRI4
CNSTI4 0
EQI4 $951
ADDRLP4 1056
INDIRI4
CNSTI4 32
EQI4 $948
LABELV $951
line 1589
;1589:		if( !p ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $952
line 1590
;1590:			break;
ADDRGP4 $947
JUMPV
LABELV $952
line 1594
;1591:		}
;1592:
;1593:		// mark start of bot name
;1594:		bot = p;
ADDRLP4 8
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $955
JUMPV
LABELV $954
line 1597
;1595:
;1596:		// skip until space of null
;1597:		while( *p && *p != ' ' ) {
line 1598
;1598:			p++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1599
;1599:		}
LABELV $955
line 1597
ADDRLP4 1060
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 1060
INDIRI4
CNSTI4 0
EQI4 $957
ADDRLP4 1060
INDIRI4
CNSTI4 32
NEI4 $954
LABELV $957
line 1600
;1600:		if( *p ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $958
line 1601
;1601:			*p++ = 0;
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
line 1602
;1602:		}
LABELV $958
line 1604
;1603:
;1604:		botInfo = UI_GetBotInfoByName( bot );
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
line 1605
;1605:		bot = Info_ValueForKey( botInfo, "name" );
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 $791
ARGP4
ADDRLP4 1068
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 1068
INDIRP4
ASGNP4
line 1607
;1606:
;1607:		Q_strncpyz( s_serveroptions.playerNameBuffers[count], bot, sizeof(s_serveroptions.playerNameBuffers[count]) );
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
line 1608
;1608:		count++;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 1609
;1609:	}
LABELV $946
line 1584
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $962
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $949
LABELV $962
LABELV $947
line 1612
;1610:
;1611:	// set the rest of the bot slots to "---"
;1612:	for( n = count; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $966
JUMPV
LABELV $963
line 1613
;1613:		strcpy( s_serveroptions.playerNameBuffers[n], "--------" );
ADDRLP4 12
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 s_serveroptions+6828
ADDP4
ARGP4
ADDRGP4 $968
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1614
;1614:	}
LABELV $964
line 1612
ADDRLP4 12
ADDRLP4 12
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $966
ADDRLP4 12
INDIRI4
CNSTI4 12
LTI4 $963
line 1617
;1615:
;1616:	// pad up to #8 as open slots
;1617:	for( ;count < 8; count++ ) {
ADDRGP4 $972
JUMPV
LABELV $969
line 1618
;1618:		s_serveroptions.playerType[count].curvalue = 0;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 0
ASGNI4
line 1619
;1619:	}
LABELV $970
line 1617
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $972
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $969
line 1622
;1620:
;1621:	// close off the rest by default
;1622:	for( ;count < PLAYER_SLOTS; count++ ) {
ADDRGP4 $978
JUMPV
LABELV $975
line 1623
;1623:		if( s_serveroptions.playerType[count].curvalue == 1 ) {
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
INDIRI4
CNSTI4 1
NEI4 $979
line 1624
;1624:			s_serveroptions.playerType[count].curvalue = 2;
CNSTI4 96
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+64
ADDP4
CNSTI4 2
ASGNI4
line 1625
;1625:		}
LABELV $979
line 1626
;1626:	}
LABELV $976
line 1622
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $978
ADDRLP4 4
INDIRI4
CNSTI4 12
LTI4 $975
line 1627
;1627:}
LABELV $897
endproc ServerOptions_InitBotNames 1072 12
bss
align 1
LABELV $986
skip 64
code
proc ServerOptions_SetMenuItems 180 16
line 1635
;1628:
;1629:
;1630:/*
;1631:=================
;1632:ServerOptions_SetMenuItems
;1633:=================
;1634:*/
;1635:static void ServerOptions_SetMenuItems( void ) {
line 1638
;1636:	static char picname[64];
;1637:	
;1638:	s_serveroptions.respawnTime.curvalue =
ADDRGP4 $989
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
line 1647
;1639:	(int)Com_Clamp(
;1640:		0,
;1641:		7,
;1642:		trap_Cvar_VariableValue(
;1643:			"ui_respawnTime"
;1644:		)
;1645:	);
;1646:	
;1647:	s_serveroptions.assaultMiddleItem.curvalue =
ADDRGP4 $992
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
line 1656
;1648:	(int)Com_Clamp(
;1649:		0,
;1650:		13,
;1651:		trap_Cvar_VariableValue(
;1652:			"ui_assaultMiddleItem"
;1653:		)
;1654:	);
;1655:
;1656:	s_serveroptions.noHealth.curvalue =
ADDRGP4 $995
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
CNSTF4 0
EQF4 $997
ADDRLP4 16
CNSTI4 1
ASGNI4
ADDRGP4 $998
JUMPV
LABELV $997
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $998
ADDRGP4 s_serveroptions+2580+60
ADDRLP4 16
INDIRI4
ASGNI4
line 1659
;1657:			trap_Cvar_VariableValue( "ui_noHealth" ) != 0;
;1658:
;1659:	s_serveroptions.noArmor.curvalue =
ADDRGP4 $1001
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 0
EQF4 $1003
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1004
JUMPV
LABELV $1003
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1004
ADDRGP4 s_serveroptions+2644+60
ADDRLP4 24
INDIRI4
ASGNI4
line 1662
;1660:		trap_Cvar_VariableValue( "ui_noArmor" ) != 0;
;1661:
;1662:	s_serveroptions.noPlasmaBFG.curvalue =
ADDRGP4 $1007
ARGP4
ADDRLP4 36
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
EQF4 $1009
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRGP4 $1010
JUMPV
LABELV $1009
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $1010
ADDRGP4 s_serveroptions+2836+60
ADDRLP4 32
INDIRI4
ASGNI4
line 1665
;1663:		trap_Cvar_VariableValue( "ui_noPlasmaBFG" ) != 0;
;1664:
;1665:	s_serveroptions.noGrenadeRocket.curvalue =
ADDRGP4 $1013
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 44
INDIRF4
CNSTF4 0
EQF4 $1015
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $1016
JUMPV
LABELV $1015
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $1016
ADDRGP4 s_serveroptions+2900+60
ADDRLP4 40
INDIRI4
ASGNI4
line 1668
;1666:		trap_Cvar_VariableValue( "ui_noGrenadeRocket" ) != 0;
;1667:		
;1668:	s_serveroptions.noRailgun.curvalue =
ADDRGP4 $703
ARGP4
ADDRLP4 52
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 0
EQF4 $1020
ADDRLP4 48
CNSTI4 1
ASGNI4
ADDRGP4 $1021
JUMPV
LABELV $1020
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $1021
ADDRGP4 s_serveroptions+2964+60
ADDRLP4 48
INDIRI4
ASGNI4
line 1671
;1669:		trap_Cvar_VariableValue( "ui_noRailgun" ) != 0;
;1670:		
;1671:	s_serveroptions.enableBlaster.curvalue =
ADDRGP4 $688
ARGP4
ADDRLP4 60
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 60
INDIRF4
CNSTF4 0
EQF4 $1025
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $1026
JUMPV
LABELV $1025
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $1026
ADDRGP4 s_serveroptions+3028+60
ADDRLP4 56
INDIRI4
ASGNI4
line 1674
;1672:		trap_Cvar_VariableValue( "ui_enableBlaster" ) != 0;
;1673:		
;1674:	s_serveroptions.noMegaHealth.curvalue =
ADDRGP4 $633
ARGP4
ADDRLP4 68
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
EQF4 $1030
ADDRLP4 64
CNSTI4 1
ASGNI4
ADDRGP4 $1031
JUMPV
LABELV $1030
ADDRLP4 64
CNSTI4 0
ASGNI4
LABELV $1031
ADDRGP4 s_serveroptions+2708+60
ADDRLP4 64
INDIRI4
ASGNI4
line 1677
;1675:		trap_Cvar_VariableValue( "ui_noMegaHealth" ) != 0;
;1676:
;1677:	s_serveroptions.noPersonalTeleporter.curvalue =
ADDRGP4 $642
ARGP4
ADDRLP4 76
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 76
INDIRF4
CNSTF4 0
EQF4 $1035
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRGP4 $1036
JUMPV
LABELV $1035
ADDRLP4 72
CNSTI4 0
ASGNI4
LABELV $1036
ADDRGP4 s_serveroptions+2772+60
ADDRLP4 72
INDIRI4
ASGNI4
line 1682
;1678:			trap_Cvar_VariableValue(
;1679:				"ui_noPersonalTeleporter"
;1680:			) != 0;
;1681:		
;1682:	s_serveroptions.noPowerups.curvalue =
ADDRGP4 $627
ARGP4
ADDRLP4 84
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 84
INDIRF4
CNSTF4 0
EQF4 $1040
ADDRLP4 80
CNSTI4 1
ASGNI4
ADDRGP4 $1041
JUMPV
LABELV $1040
ADDRLP4 80
CNSTI4 0
ASGNI4
LABELV $1041
ADDRGP4 s_serveroptions+2516+60
ADDRLP4 80
INDIRI4
ASGNI4
line 1685
;1683:		trap_Cvar_VariableValue( "ui_noPowerups" ) != 0;
;1684:
;1685:	Com_sprintf(
ADDRGP4 $626
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
ADDRGP4 $1048
ARGP4
ADDRLP4 92
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1696
;1686:			s_serveroptions.additionalSlots.field.buffer,
;1687:			sizeof( s_serveroptions.additionalSlots.field.buffer ),
;1688:			"%i",
;1689:			(int)Com_Clamp(
;1690:				0,
;1691:				MAX_CLIENTS - 1,
;1692:				trap_Cvar_VariableValue( "ui_additionalSlots" )
;1693:			)
;1694:		);
;1695:
;1696:	switch( s_serveroptions.gametype ) {
ADDRLP4 96
ADDRGP4 s_serveroptions+6792
INDIRI4
ASGNI4
ADDRLP4 96
INDIRI4
CNSTI4 0
LTI4 $1049
ADDRLP4 96
INDIRI4
CNSTI4 4
GTI4 $1049
ADDRLP4 96
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $1084
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $1084
address $1052
address $1059
address $1049
address $1066
address $1075
code
LABELV $1052
LABELV $1049
line 1699
;1697:	case GT_FFA:
;1698:	default:
;1699:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_fraglimit" ) ) );
ADDRGP4 $660
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
ADDRGP4 $1048
ARGP4
ADDRLP4 104
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1700
;1700:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ffa_timelimit" ) ) );
ADDRGP4 $661
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
ADDRGP4 $1048
ARGP4
ADDRLP4 112
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1701
;1701:		break;
ADDRGP4 $1050
JUMPV
LABELV $1059
line 1704
;1702:
;1703:	case GT_TOURNAMENT:
;1704:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_fraglimit" ) ) );
ADDRGP4 $663
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
ADDRGP4 $1048
ARGP4
ADDRLP4 120
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1705
;1705:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_tourney_timelimit" ) ) );
ADDRGP4 $664
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
ADDRGP4 $1048
ARGP4
ADDRLP4 128
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1706
;1706:		break;
ADDRGP4 $1050
JUMPV
LABELV $1066
line 1709
;1707:
;1708:	case GT_TEAM:
;1709:		Com_sprintf( s_serveroptions.fraglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_fraglimit" ) ) );
ADDRGP4 $666
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
ADDRGP4 $1048
ARGP4
ADDRLP4 136
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1710
;1710:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_team_timelimit" ) ) );
ADDRGP4 $667
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
ADDRGP4 $1048
ARGP4
ADDRLP4 144
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1711
;1711:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_team_friendly" ) );
ADDRGP4 $668
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
line 1712
;1712:		break;
ADDRGP4 $1050
JUMPV
LABELV $1075
line 1715
;1713:
;1714:	case GT_CTF:
;1715:		Com_sprintf( s_serveroptions.flaglimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 100, trap_Cvar_VariableValue( "ui_ctf_capturelimit" ) ) );
ADDRGP4 $670
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
ADDRGP4 $1048
ARGP4
ADDRLP4 160
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1716
;1716:		Com_sprintf( s_serveroptions.timelimit.field.buffer, 4, "%i", (int)Com_Clamp( 0, 999, trap_Cvar_VariableValue( "ui_ctf_timelimit" ) ) );
ADDRGP4 $671
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
ADDRGP4 $1048
ARGP4
ADDRLP4 168
INDIRF4
CVFI4 4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1717
;1717:		s_serveroptions.friendlyfire.curvalue = (int)Com_Clamp( 0, 1, trap_Cvar_VariableValue( "ui_ctf_friendly" ) );
ADDRGP4 $672
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
line 1718
;1718:		break;
LABELV $1050
line 1721
;1719:	}
;1720:
;1721:	Q_strncpyz( s_serveroptions.hostname.field.buffer, UI_Cvar_VariableString( "sv_hostname" ), sizeof( s_serveroptions.hostname.field.buffer ) );
ADDRGP4 $681
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
line 1722
;1722:	s_serveroptions.pure.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_pure" ) );
ADDRGP4 $680
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
line 1725
;1723:
;1724:	// set the map pic
;1725:	Com_sprintf( picname, 64, "levelshots/%s", s_startserver.maplist[s_startserver.currentmap] );
ADDRGP4 $986
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $108
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
line 1726
;1726:	s_serveroptions.mappic.generic.name = picname;
ADDRGP4 s_serveroptions+360+4
ADDRGP4 $986
ASGNP4
line 1729
;1727:
;1728:	// set the map name
;1729:	strcpy( s_serveroptions.mapnamebuffer, s_startserver.mapname.string );
ADDRGP4 s_serveroptions+6796
ARGP4
ADDRGP4 s_startserver+1776+60
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1730
;1730:	Q_strupr( s_serveroptions.mapnamebuffer );
ADDRGP4 s_serveroptions+6796
ARGP4
ADDRGP4 Q_strupr
CALLP4
pop
line 1733
;1731:
;1732:	// get the player selections initialized
;1733:	ServerOptions_InitPlayerItems();
ADDRGP4 ServerOptions_InitPlayerItems
CALLV
pop
line 1734
;1734:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1737
;1735:
;1736:	// seed bot names
;1737:	ServerOptions_InitBotNames();
ADDRGP4 ServerOptions_InitBotNames
CALLV
pop
line 1738
;1738:	ServerOptions_SetPlayerItems();
ADDRGP4 ServerOptions_SetPlayerItems
CALLV
pop
line 1739
;1739:}
LABELV $985
endproc ServerOptions_SetMenuItems 180 16
proc PlayerName_Draw 48 20
line 1746
;1740:
;1741:/*
;1742:=================
;1743:PlayerName_Draw
;1744:=================
;1745:*/
;1746:static void PlayerName_Draw( void *item ) {
line 1753
;1747:	menutext_s	*s;
;1748:	float		*color;
;1749:	int			x, y;
;1750:	int			style;
;1751:	qboolean	focus;
;1752:
;1753:	s = (menutext_s *)item;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 1755
;1754:
;1755:	x = s->generic.x;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1756
;1756:	y =	s->generic.y;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 1758
;1757:
;1758:	style = UI_SMALLFONT;
ADDRLP4 16
CNSTI4 16
ASGNI4
line 1759
;1759:	focus = (s->generic.parent->cursor == s->generic.menuPosition);
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
NEI4 $1103
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $1104
JUMPV
LABELV $1103
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $1104
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 1761
;1760:
;1761:	if ( s->generic.flags & QMF_GRAYED )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $1105
line 1762
;1762:		color = text_color_disabled;
ADDRLP4 4
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $1106
JUMPV
LABELV $1105
line 1763
;1763:	else if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1107
line 1764
;1764:	{
line 1765
;1765:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1766
;1766:		style |= UI_PULSE;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 1767
;1767:	}
ADDRGP4 $1108
JUMPV
LABELV $1107
line 1768
;1768:	else if ( s->generic.flags & QMF_BLINK )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $1109
line 1769
;1769:	{
line 1770
;1770:		color = text_color_highlight;
ADDRLP4 4
ADDRGP4 text_color_highlight
ASGNP4
line 1771
;1771:		style |= UI_BLINK;
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1772
;1772:	}
ADDRGP4 $1110
JUMPV
LABELV $1109
line 1774
;1773:	else
;1774:		color = text_color_normal;
ADDRLP4 4
ADDRGP4 text_color_normal
ASGNP4
LABELV $1110
LABELV $1108
LABELV $1106
line 1776
;1775:
;1776:	if ( focus )
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $1111
line 1777
;1777:	{
line 1779
;1778:		// draw cursor
;1779:		UI_FillRect( s->generic.left, s->generic.top, s->generic.right-s->generic.left+1, s->generic.bottom-s->generic.top+1, listbar_color ); 
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
line 1780
;1780:		UI_DrawChar( x, y, 13, UI_CENTER|UI_BLINK|UI_SMALLFONT, color);
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
line 1781
;1781:	}
LABELV $1111
line 1783
;1782:
;1783:	UI_DrawString( x - SMALLCHAR_WIDTH, y, s->generic.name, style|UI_RIGHT, color );
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
line 1784
;1784:	UI_DrawString( x + SMALLCHAR_WIDTH, y, s->string, style|UI_LEFT, color );
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
line 1785
;1785:}
LABELV $1101
endproc PlayerName_Draw 48 20
proc ServerOptions_MenuInit 52 12
line 1795
;1786:
;1787:
;1788:/*
;1789:=================
;1790:ServerOptions_MenuInit
;1791:=================
;1792:*/
;1793:#define OPTIONS_X	456
;1794:
;1795:static void ServerOptions_MenuInit( qboolean multiplayer ) {
line 1799
;1796:	int		y;
;1797:	int		n;
;1798:
;1799:	memset( &s_serveroptions, 0 ,sizeof(serveroptions_t) );
ADDRGP4 s_serveroptions
ARGP4
CNSTI4 0
ARGI4
CNSTI4 7140
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1800
;1800:	s_serveroptions.multiplayer = multiplayer;
ADDRGP4 s_serveroptions+6788
ADDRFP4 0
INDIRI4
ASGNI4
line 1801
;1801:	s_serveroptions.gametype = (int)Com_Clamp( 0, 5, trap_Cvar_VariableValue( "g_gameType" ) );
ADDRGP4 $219
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
line 1802
;1802:	s_serveroptions.punkbuster.curvalue = Com_Clamp( 0, 1, trap_Cvar_VariableValue( "sv_punkbuster" ) );
ADDRGP4 $685
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
line 1804
;1803:
;1804:	ServerOptions_Cache();
ADDRGP4 ServerOptions_Cache
CALLV
pop
line 1806
;1805:
;1806:	s_serveroptions.menu.wrapAround = qtrue;
ADDRGP4 s_serveroptions+276
CNSTI4 1
ASGNI4
line 1807
;1807:	s_serveroptions.menu.fullscreen = qtrue;
ADDRGP4 s_serveroptions+280
CNSTI4 1
ASGNI4
line 1809
;1808:
;1809:	s_serveroptions.banner.generic.type			= MTYPE_BTEXT;
ADDRGP4 s_serveroptions+288
CNSTI4 10
ASGNI4
line 1810
;1810:	s_serveroptions.banner.generic.x			= 320;
ADDRGP4 s_serveroptions+288+12
CNSTI4 320
ASGNI4
line 1811
;1811:	s_serveroptions.banner.generic.y			= 16;
ADDRGP4 s_serveroptions+288+16
CNSTI4 16
ASGNI4
line 1812
;1812:	s_serveroptions.banner.string  				= "GAME SERVER";
ADDRGP4 s_serveroptions+288+60
ADDRGP4 $273
ASGNP4
line 1813
;1813:	s_serveroptions.banner.color  				= color_white;
ADDRGP4 s_serveroptions+288+68
ADDRGP4 color_white
ASGNP4
line 1814
;1814:	s_serveroptions.banner.style  				= UI_CENTER;
ADDRGP4 s_serveroptions+288+64
CNSTI4 1
ASGNI4
line 1816
;1815:
;1816:	s_serveroptions.mappic.generic.type			= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+360
CNSTI4 6
ASGNI4
line 1817
;1817:	s_serveroptions.mappic.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
ADDRGP4 s_serveroptions+360+44
CNSTU4 16388
ASGNU4
line 1818
;1818:	s_serveroptions.mappic.generic.x			= 352;
ADDRGP4 s_serveroptions+360+12
CNSTI4 352
ASGNI4
line 1819
;1819:	s_serveroptions.mappic.generic.y			= 80;
ADDRGP4 s_serveroptions+360+16
CNSTI4 80
ASGNI4
line 1820
;1820:	s_serveroptions.mappic.width				= 160;
ADDRGP4 s_serveroptions+360+76
CNSTI4 160
ASGNI4
line 1821
;1821:	s_serveroptions.mappic.height				= 120;
ADDRGP4 s_serveroptions+360+80
CNSTI4 120
ASGNI4
line 1822
;1822:	s_serveroptions.mappic.errorpic				= GAMESERVER_UNKNOWNMAP;
ADDRGP4 s_serveroptions+360+64
ADDRGP4 $344
ASGNP4
line 1823
;1823:	s_serveroptions.mappic.generic.ownerdraw	= ServerOptions_LevelshotDraw;
ADDRGP4 s_serveroptions+360+56
ADDRGP4 ServerOptions_LevelshotDraw
ASGNP4
line 1825
;1824:
;1825:	s_serveroptions.picframe.generic.type		= MTYPE_BITMAP;
ADDRGP4 s_serveroptions+448
CNSTI4 6
ASGNI4
line 1826
;1826:	s_serveroptions.picframe.generic.flags		= QMF_LEFT_JUSTIFY|QMF_INACTIVE|QMF_HIGHLIGHT;
ADDRGP4 s_serveroptions+448+44
CNSTU4 16452
ASGNU4
line 1827
;1827:	s_serveroptions.picframe.generic.x			= 352 - 38;
ADDRGP4 s_serveroptions+448+12
CNSTI4 314
ASGNI4
line 1828
;1828:	s_serveroptions.picframe.generic.y			= 80 - 40;
ADDRGP4 s_serveroptions+448+16
CNSTI4 40
ASGNI4
line 1829
;1829:	s_serveroptions.picframe.width  			= 320;
ADDRGP4 s_serveroptions+448+76
CNSTI4 320
ASGNI4
line 1830
;1830:	s_serveroptions.picframe.height  			= 320;
ADDRGP4 s_serveroptions+448+80
CNSTI4 320
ASGNI4
line 1831
;1831:	s_serveroptions.picframe.focuspic			= GAMESERVER_SELECT;
ADDRGP4 s_serveroptions+448+60
ADDRGP4 $372
ASGNP4
line 1833
;1832:	
;1833:	s_serveroptions.respawnTime.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3188
CNSTI4 3
ASGNI4
line 1834
;1834:	s_serveroptions.respawnTime.generic.name ="Respawn Time:";
ADDRGP4 s_serveroptions+3188+4
ADDRGP4 $1162
ASGNP4
line 1835
;1835:	s_serveroptions.respawnTime.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3188+44
CNSTU4 258
ASGNU4
line 1836
;1836:	s_serveroptions.respawnTime.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3188+12
CNSTI4 456
ASGNI4
line 1837
;1837:	s_serveroptions.respawnTime.generic.y = 252;
ADDRGP4 s_serveroptions+3188+16
CNSTI4 252
ASGNI4
line 1838
;1838:	s_serveroptions.respawnTime.itemnames = respawnTime_list;
ADDRGP4 s_serveroptions+3188+76
ADDRGP4 respawnTime_list
ASGNP4
line 1840
;1839:	
;1840:	s_serveroptions.assaultMiddleItem.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+3092
CNSTI4 3
ASGNI4
line 1841
;1841:	s_serveroptions.assaultMiddleItem.generic.name = "Point B(Base Assault):";
ADDRGP4 s_serveroptions+3092+4
ADDRGP4 $1174
ASGNP4
line 1842
;1842:	s_serveroptions.assaultMiddleItem.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3092+44
CNSTU4 258
ASGNU4
line 1843
;1843:	s_serveroptions.assaultMiddleItem.generic.x = OPTIONS_X;
ADDRGP4 s_serveroptions+3092+12
CNSTI4 456
ASGNI4
line 1844
;1844:	s_serveroptions.assaultMiddleItem.generic.y = 268;
ADDRGP4 s_serveroptions+3092+16
CNSTI4 268
ASGNI4
line 1845
;1845:	s_serveroptions.assaultMiddleItem.itemnames = assaultMiddleItem_list;
ADDRGP4 s_serveroptions+3092+76
ADDRGP4 assaultMiddleItem_list
ASGNP4
line 1847
;1846:	
;1847:	y = 282;
ADDRLP4 4
CNSTI4 282
ASGNI4
line 1849
;1848:	
;1849:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 4
EQI4 $1183
line 1850
;1850:		s_serveroptions.fraglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+964
CNSTI4 4
ASGNI4
line 1851
;1851:		s_serveroptions.fraglimit.generic.name       = "Frag Limit:";
ADDRGP4 s_serveroptions+964+4
ADDRGP4 $1189
ASGNP4
line 1852
;1852:		s_serveroptions.fraglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+964+44
CNSTU4 290
ASGNU4
line 1853
;1853:		s_serveroptions.fraglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+964+12
CNSTI4 456
ASGNI4
line 1854
;1854:		s_serveroptions.fraglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1855
;1855:		s_serveroptions.fraglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+964+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1856
;1856:		s_serveroptions.fraglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+964+60+8
CNSTI4 3
ASGNI4
line 1857
;1857:		s_serveroptions.fraglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+964+60+268
CNSTI4 3
ASGNI4
line 1858
;1858:	}
ADDRGP4 $1184
JUMPV
LABELV $1183
line 1859
;1859:	else {
line 1860
;1860:		s_serveroptions.flaglimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1296
CNSTI4 4
ASGNI4
line 1861
;1861:		s_serveroptions.flaglimit.generic.name       = "Capture Limit:";
ADDRGP4 s_serveroptions+1296+4
ADDRGP4 $1207
ASGNP4
line 1862
;1862:		s_serveroptions.flaglimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1296+44
CNSTU4 290
ASGNU4
line 1863
;1863:		s_serveroptions.flaglimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+1296+12
CNSTI4 456
ASGNI4
line 1864
;1864:		s_serveroptions.flaglimit.generic.y	         = y;
ADDRGP4 s_serveroptions+1296+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1865
;1865:		s_serveroptions.flaglimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+1296+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1866
;1866:		s_serveroptions.flaglimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+1296+60+8
CNSTI4 3
ASGNI4
line 1867
;1867:		s_serveroptions.flaglimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+1296+60+268
CNSTI4 3
ASGNI4
line 1868
;1868:	}
LABELV $1184
line 1870
;1869:
;1870:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1871
;1871:	s_serveroptions.timelimit.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+632
CNSTI4 4
ASGNI4
line 1872
;1872:	s_serveroptions.timelimit.generic.name       = "Time Limit:";
ADDRGP4 s_serveroptions+632+4
ADDRGP4 $1225
ASGNP4
line 1873
;1873:	s_serveroptions.timelimit.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+632+44
CNSTU4 290
ASGNU4
line 1874
;1874:	s_serveroptions.timelimit.generic.x	         = OPTIONS_X;
ADDRGP4 s_serveroptions+632+12
CNSTI4 456
ASGNI4
line 1875
;1875:	s_serveroptions.timelimit.generic.y	         = y;
ADDRGP4 s_serveroptions+632+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1876
;1876:	s_serveroptions.timelimit.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+632+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 1877
;1877:	s_serveroptions.timelimit.field.widthInChars = 3;
ADDRGP4 s_serveroptions+632+60+8
CNSTI4 3
ASGNI4
line 1878
;1878:	s_serveroptions.timelimit.field.maxchars     = 3;
ADDRGP4 s_serveroptions+632+60+268
CNSTI4 3
ASGNI4
line 1880
;1879:
;1880:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1240
line 1881
;1881:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1882
;1882:		s_serveroptions.friendlyfire.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+1628
CNSTI4 5
ASGNI4
line 1883
;1883:		s_serveroptions.friendlyfire.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1628+44
CNSTU4 258
ASGNU4
line 1884
;1884:		s_serveroptions.friendlyfire.generic.x	      = OPTIONS_X;
ADDRGP4 s_serveroptions+1628+12
CNSTI4 456
ASGNI4
line 1885
;1885:		s_serveroptions.friendlyfire.generic.y	      = y;
ADDRGP4 s_serveroptions+1628+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1886
;1886:		s_serveroptions.friendlyfire.generic.name	  = "Friendly Fire:";
ADDRGP4 s_serveroptions+1628+4
ADDRGP4 $1252
ASGNP4
line 1887
;1887:	}
LABELV $1240
line 1889
;1888:
;1889:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1890
;1890:	s_serveroptions.pure.generic.type			= MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2024
CNSTI4 5
ASGNI4
line 1891
;1891:	s_serveroptions.pure.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2024+44
CNSTU4 258
ASGNU4
line 1892
;1892:	s_serveroptions.pure.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+2024+12
CNSTI4 456
ASGNI4
line 1893
;1893:	s_serveroptions.pure.generic.y				= y;
ADDRGP4 s_serveroptions+2024+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1894
;1894:	s_serveroptions.pure.generic.name			= "Pure Server:";
ADDRGP4 s_serveroptions+2024+4
ADDRGP4 $1262
ASGNP4
line 1896
;1895:
;1896:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1263
line 1897
;1897:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1898
;1898:		s_serveroptions.dedicated.generic.type		= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+536
CNSTI4 3
ASGNI4
line 1899
;1899:		s_serveroptions.dedicated.generic.id		= ID_DEDICATED;
ADDRGP4 s_serveroptions+536+8
CNSTI4 22
ASGNI4
line 1900
;1900:		s_serveroptions.dedicated.generic.flags		= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+536+44
CNSTU4 258
ASGNU4
line 1901
;1901:		s_serveroptions.dedicated.generic.callback	= ServerOptions_Event;
ADDRGP4 s_serveroptions+536+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 1902
;1902:		s_serveroptions.dedicated.generic.x			= OPTIONS_X;
ADDRGP4 s_serveroptions+536+12
CNSTI4 456
ASGNI4
line 1903
;1903:		s_serveroptions.dedicated.generic.y			= y;
ADDRGP4 s_serveroptions+536+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1904
;1904:		s_serveroptions.dedicated.generic.name		= "Dedicated:";
ADDRGP4 s_serveroptions+536+4
ADDRGP4 $1279
ASGNP4
line 1905
;1905:		s_serveroptions.dedicated.itemnames			= dedicated_list;
ADDRGP4 s_serveroptions+536+76
ADDRGP4 dedicated_list
ASGNP4
line 1906
;1906:	}
LABELV $1263
line 1908
;1907:
;1908:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1282
line 1909
;1909:		y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1910
;1910:		s_serveroptions.hostname.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+1692
CNSTI4 4
ASGNI4
line 1911
;1911:		s_serveroptions.hostname.generic.name       = "Hostname:";
ADDRGP4 s_serveroptions+1692+4
ADDRGP4 $1288
ASGNP4
line 1912
;1912:		s_serveroptions.hostname.generic.flags      = QMF_SMALLFONT;
ADDRGP4 s_serveroptions+1692+44
CNSTU4 2
ASGNU4
line 1913
;1913:		s_serveroptions.hostname.generic.x          = OPTIONS_X;
ADDRGP4 s_serveroptions+1692+12
CNSTI4 456
ASGNI4
line 1914
;1914:		s_serveroptions.hostname.generic.y	        = y;
ADDRGP4 s_serveroptions+1692+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1915
;1915:		s_serveroptions.hostname.field.widthInChars = 18;
ADDRGP4 s_serveroptions+1692+60+8
CNSTI4 18
ASGNI4
line 1916
;1916:		s_serveroptions.hostname.field.maxchars     = 64;
ADDRGP4 s_serveroptions+1692+60+268
CNSTI4 64
ASGNI4
line 1917
;1917:	}
LABELV $1282
line 1919
;1918:
;1919:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 1920
;1920:	s_serveroptions.punkbuster.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+7044
CNSTI4 3
ASGNI4
line 1921
;1921:	s_serveroptions.punkbuster.generic.name			= "Punkbuster:";
ADDRGP4 s_serveroptions+7044+4
ADDRGP4 $1304
ASGNP4
line 1922
;1922:	s_serveroptions.punkbuster.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+7044+44
CNSTU4 258
ASGNU4
line 1923
;1923:	s_serveroptions.punkbuster.generic.id			= 0;
ADDRGP4 s_serveroptions+7044+8
CNSTI4 0
ASGNI4
line 1924
;1924:	s_serveroptions.punkbuster.generic.x				= OPTIONS_X;
ADDRGP4 s_serveroptions+7044+12
CNSTI4 456
ASGNI4
line 1925
;1925:	s_serveroptions.punkbuster.generic.y				= y;
ADDRGP4 s_serveroptions+7044+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1926
;1926:	s_serveroptions.punkbuster.itemnames				= punkbuster_items;
ADDRGP4 s_serveroptions+7044+76
ADDRGP4 punkbuster_items
ASGNP4
line 1928
;1927:	
;1928:	y = 90;
ADDRLP4 4
CNSTI4 90
ASGNI4
line 1929
;1929:	s_serveroptions.botSkill.generic.type			= MTYPE_SPINCONTROL;
ADDRGP4 s_serveroptions+2088
CNSTI4 3
ASGNI4
line 1930
;1930:	s_serveroptions.botSkill.generic.flags			= QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2088+44
CNSTU4 258
ASGNU4
line 1931
;1931:	s_serveroptions.botSkill.generic.name			= "Bot Skill:  ";
ADDRGP4 s_serveroptions+2088+4
ADDRGP4 $1320
ASGNP4
line 1932
;1932:	s_serveroptions.botSkill.generic.x				= 32 + (strlen(s_serveroptions.botSkill.generic.name) + 2 ) * SMALLCHAR_WIDTH;
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
line 1933
;1933:	s_serveroptions.botSkill.generic.y				= y;
ADDRGP4 s_serveroptions+2088+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1934
;1934:	s_serveroptions.botSkill.itemnames				= botSkill_list;
ADDRGP4 s_serveroptions+2088+76
ADDRGP4 botSkill_list
ASGNP4
line 1935
;1935:	s_serveroptions.botSkill.curvalue				= 1;
ADDRGP4 s_serveroptions+2088+64
CNSTI4 1
ASGNI4
line 1937
;1936:
;1937:	y += ( 2 * SMALLCHAR_HEIGHT );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 32
ADDI4
ASGNI4
line 1938
;1938:	s_serveroptions.player0.generic.type			= MTYPE_TEXT;
ADDRGP4 s_serveroptions+3284
CNSTI4 7
ASGNI4
line 1939
;1939:	s_serveroptions.player0.generic.flags			= QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3284+44
CNSTU4 2
ASGNU4
line 1940
;1940:	s_serveroptions.player0.generic.x				= 32 + SMALLCHAR_WIDTH;
ADDRGP4 s_serveroptions+3284+12
CNSTI4 40
ASGNI4
line 1941
;1941:	s_serveroptions.player0.generic.y				= y;
ADDRGP4 s_serveroptions+3284+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1942
;1942:	s_serveroptions.player0.color					= color_orange;
ADDRGP4 s_serveroptions+3284+68
ADDRGP4 color_orange
ASGNP4
line 1943
;1943:	s_serveroptions.player0.style					= UI_LEFT|UI_SMALLFONT;
ADDRGP4 s_serveroptions+3284+64
CNSTI4 16
ASGNI4
line 1945
;1944:
;1945:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1342
line 1946
;1946:		s_serveroptions.playerType[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356
ADDP4
CNSTI4 3
ASGNI4
line 1947
;1947:		s_serveroptions.playerType[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+44
ADDP4
CNSTU4 2
ASGNU4
line 1948
;1948:		s_serveroptions.playerType[n].generic.id		= ID_PLAYER_TYPE;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+8
ADDP4
CNSTI4 20
ASGNI4
line 1949
;1949:		s_serveroptions.playerType[n].generic.callback	= ServerOptions_Event;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+48
ADDP4
ADDRGP4 ServerOptions_Event
ASGNP4
line 1950
;1950:		s_serveroptions.playerType[n].generic.x			= 32;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+12
ADDP4
CNSTI4 32
ASGNI4
line 1951
;1951:		s_serveroptions.playerType[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1952
;1952:		s_serveroptions.playerType[n].itemnames			= playerType_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+3356+76
ADDP4
ADDRGP4 playerType_list
ASGNP4
line 1954
;1953:
;1954:		s_serveroptions.playerName[n].generic.type		= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508
ADDP4
CNSTI4 7
ASGNI4
line 1955
;1955:		s_serveroptions.playerName[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+44
ADDP4
CNSTU4 2
ASGNU4
line 1956
;1956:		s_serveroptions.playerName[n].generic.x			= 96;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+12
ADDP4
CNSTI4 96
ASGNI4
line 1957
;1957:		s_serveroptions.playerName[n].generic.y			= y;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1958
;1958:		s_serveroptions.playerName[n].generic.callback	= ServerOptions_PlayerNameEvent;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+48
ADDP4
ADDRGP4 ServerOptions_PlayerNameEvent
ASGNP4
line 1959
;1959:		s_serveroptions.playerName[n].generic.id		= n;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1960
;1960:		s_serveroptions.playerName[n].generic.ownerdraw	= PlayerName_Draw;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+56
ADDP4
ADDRGP4 PlayerName_Draw
ASGNP4
line 1961
;1961:		s_serveroptions.playerName[n].color				= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 1962
;1962:		s_serveroptions.playerName[n].style				= UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+4508+64
ADDP4
CNSTI4 16
ASGNI4
line 1963
;1963:		s_serveroptions.playerName[n].string			= s_serveroptions.playerNameBuffers[n];
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
line 1964
;1964:		s_serveroptions.playerName[n].generic.top		= s_serveroptions.playerName[n].generic.y;
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
line 1965
;1965:		s_serveroptions.playerName[n].generic.bottom	= s_serveroptions.playerName[n].generic.y + SMALLCHAR_HEIGHT;
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
line 1966
;1966:		s_serveroptions.playerName[n].generic.left		= s_serveroptions.playerName[n].generic.x - SMALLCHAR_HEIGHT/ 2;
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
line 1967
;1967:		s_serveroptions.playerName[n].generic.right		= s_serveroptions.playerName[n].generic.x + 16 * SMALLCHAR_WIDTH;
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
line 1969
;1968:
;1969:		s_serveroptions.playerTeam[n].generic.type		= MTYPE_SPINCONTROL;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372
ADDP4
CNSTI4 3
ASGNI4
line 1970
;1970:		s_serveroptions.playerTeam[n].generic.flags		= QMF_SMALLFONT;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+44
ADDP4
CNSTU4 2
ASGNU4
line 1971
;1971:		s_serveroptions.playerTeam[n].generic.x			= 240;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+12
ADDP4
CNSTI4 240
ASGNI4
line 1972
;1972:		s_serveroptions.playerTeam[n].generic.y			= y;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+16
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 1973
;1973:		s_serveroptions.playerTeam[n].itemnames			= playerTeam_list;
CNSTI4 96
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 s_serveroptions+5372+76
ADDP4
ADDRGP4 playerTeam_list
ASGNP4
line 1975
;1974:
;1975:		y += ( SMALLCHAR_HEIGHT + 4 );
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
line 1976
;1976:	}
LABELV $1343
line 1945
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1342
line 1978
;1977:
;1978:	s_serveroptions.additionalSlots.generic.type       = MTYPE_FIELD;
ADDRGP4 s_serveroptions+2184
CNSTI4 4
ASGNI4
line 1979
;1979:	s_serveroptions.additionalSlots.generic.name       = "Additional Slots:";
ADDRGP4 s_serveroptions+2184+4
ADDRGP4 $1407
ASGNP4
line 1980
;1980:	s_serveroptions.additionalSlots.generic.flags      = QMF_NUMBERSONLY|QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2184+44
CNSTU4 290
ASGNU4
line 1981
;1981:	s_serveroptions.additionalSlots.generic.id         = ID_MAXCLIENTS;
ADDRGP4 s_serveroptions+2184+8
CNSTI4 21
ASGNI4
line 1982
;1982:	s_serveroptions.additionalSlots.generic.x          = 240;
ADDRGP4 s_serveroptions+2184+12
CNSTI4 240
ASGNI4
line 1983
;1983:	s_serveroptions.additionalSlots.generic.y          = y;
ADDRGP4 s_serveroptions+2184+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1984
;1984:	s_serveroptions.additionalSlots.field.widthInChars = 2;
ADDRGP4 s_serveroptions+2184+60+8
CNSTI4 2
ASGNI4
line 1985
;1985:	s_serveroptions.additionalSlots.field.maxchars     = 2;
ADDRGP4 s_serveroptions+2184+60+268
CNSTI4 2
ASGNI4
line 1987
;1986:	
;1987:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1988
;1988:	s_serveroptions.noPowerups.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2516
CNSTI4 5
ASGNI4
line 1989
;1989:	s_serveroptions.noPowerups.generic.name     = "No Powerups:";
ADDRGP4 s_serveroptions+2516+4
ADDRGP4 $1425
ASGNP4
line 1990
;1990:	s_serveroptions.noPowerups.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2516+44
CNSTU4 258
ASGNU4
line 1991
;1991:	s_serveroptions.noPowerups.generic.x        = 240;
ADDRGP4 s_serveroptions+2516+12
CNSTI4 240
ASGNI4
line 1992
;1992:	s_serveroptions.noPowerups.generic.y        = y;
ADDRGP4 s_serveroptions+2516+16
ADDRLP4 4
INDIRI4
ASGNI4
line 1994
;1993:	
;1994:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 1995
;1995:	s_serveroptions.noHealth.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2580
CNSTI4 5
ASGNI4
line 1996
;1996:	s_serveroptions.noHealth.generic.name = "No Health:";
ADDRGP4 s_serveroptions+2580+4
ADDRGP4 $1435
ASGNP4
line 1997
;1997:	s_serveroptions.noHealth.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2580+44
CNSTU4 258
ASGNU4
line 1998
;1998:	s_serveroptions.noHealth.generic.x = 240;
ADDRGP4 s_serveroptions+2580+12
CNSTI4 240
ASGNI4
line 1999
;1999:	s_serveroptions.noHealth.generic.y = y;
ADDRGP4 s_serveroptions+2580+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2001
;2000:
;2001:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2002
;2002:	s_serveroptions.noArmor.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2644
CNSTI4 5
ASGNI4
line 2003
;2003:	s_serveroptions.noArmor.generic.name = "No Armor:";
ADDRGP4 s_serveroptions+2644+4
ADDRGP4 $1445
ASGNP4
line 2004
;2004:	s_serveroptions.noArmor.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2644+44
CNSTU4 258
ASGNU4
line 2005
;2005:	s_serveroptions.noArmor.generic.x = 240;
ADDRGP4 s_serveroptions+2644+12
CNSTI4 240
ASGNI4
line 2006
;2006:	s_serveroptions.noArmor.generic.y = y;
ADDRGP4 s_serveroptions+2644+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2008
;2007:	
;2008:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2010
;2009:
;2010:	s_serveroptions.noMegaHealth.generic.type  = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2708
CNSTI4 5
ASGNI4
line 2011
;2011:	s_serveroptions.noMegaHealth.generic.name  = "No Mega / Medkit:";
ADDRGP4 s_serveroptions+2708+4
ADDRGP4 $1455
ASGNP4
line 2012
;2012:	s_serveroptions.noMegaHealth.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2708+44
CNSTU4 258
ASGNU4
line 2013
;2013:	s_serveroptions.noMegaHealth.generic.x     = 240;
ADDRGP4 s_serveroptions+2708+12
CNSTI4 240
ASGNI4
line 2014
;2014:	s_serveroptions.noMegaHealth.generic.y     = y;
ADDRGP4 s_serveroptions+2708+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2016
;2015:
;2016:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2017
;2017:	s_serveroptions.noPersonalTeleporter.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2772
CNSTI4 5
ASGNI4
line 2018
;2018:	s_serveroptions.noPersonalTeleporter.generic.name = "No Personal TP:";
ADDRGP4 s_serveroptions+2772+4
ADDRGP4 $1465
ASGNP4
line 2019
;2019:	s_serveroptions.noPersonalTeleporter.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2772+44
CNSTU4 258
ASGNU4
line 2020
;2020:	s_serveroptions.noPersonalTeleporter.generic.x = 240;
ADDRGP4 s_serveroptions+2772+12
CNSTI4 240
ASGNI4
line 2021
;2021:	s_serveroptions.noPersonalTeleporter.generic.y = y;
ADDRGP4 s_serveroptions+2772+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2023
;2022:	
;2023:	y=368;
ADDRLP4 4
CNSTI4 368
ASGNI4
line 2024
;2024:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2025
;2025:	s_serveroptions.noPlasmaBFG.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2836
CNSTI4 5
ASGNI4
line 2026
;2026:	s_serveroptions.noPlasmaBFG.generic.name = "No Energy Guns:";
ADDRGP4 s_serveroptions+2836+4
ADDRGP4 $1475
ASGNP4
line 2027
;2027:	s_serveroptions.noPlasmaBFG.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2836+44
CNSTU4 258
ASGNU4
line 2028
;2028:	s_serveroptions.noPlasmaBFG.generic.x = 440;
ADDRGP4 s_serveroptions+2836+12
CNSTI4 440
ASGNI4
line 2029
;2029:	s_serveroptions.noPlasmaBFG.generic.y = y;
ADDRGP4 s_serveroptions+2836+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2031
;2030:
;2031:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2032
;2032:	s_serveroptions.noGrenadeRocket.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2900
CNSTI4 5
ASGNI4
line 2033
;2033:	s_serveroptions.noGrenadeRocket.generic.name = "No Explosives:";
ADDRGP4 s_serveroptions+2900+4
ADDRGP4 $1485
ASGNP4
line 2034
;2034:	s_serveroptions.noGrenadeRocket.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2900+44
CNSTU4 258
ASGNU4
line 2035
;2035:	s_serveroptions.noGrenadeRocket.generic.x = 440;
ADDRGP4 s_serveroptions+2900+12
CNSTI4 440
ASGNI4
line 2036
;2036:	s_serveroptions.noGrenadeRocket.generic.y = y;
ADDRGP4 s_serveroptions+2900+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2038
;2037:	
;2038:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2039
;2039:	s_serveroptions.noRailgun.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+2964
CNSTI4 5
ASGNI4
line 2040
;2040:	s_serveroptions.noRailgun.generic.name = "No Railgun:";
ADDRGP4 s_serveroptions+2964+4
ADDRGP4 $1495
ASGNP4
line 2041
;2041:	s_serveroptions.noRailgun.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_serveroptions+2964+44
CNSTU4 258
ASGNU4
line 2042
;2042:	s_serveroptions.noRailgun.generic.x = 440;
ADDRGP4 s_serveroptions+2964+12
CNSTI4 440
ASGNI4
line 2043
;2043:	s_serveroptions.noRailgun.generic.y = y;
ADDRGP4 s_serveroptions+2964+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2045
;2044:	
;2045:	y += BIGCHAR_HEIGHT + 1;
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 17
ADDI4
ASGNI4
line 2046
;2046:	s_serveroptions.enableBlaster.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_serveroptions+3028
CNSTI4 5
ASGNI4
line 2047
;2047:	s_serveroptions.enableBlaster.generic.name = "Enable Blaster:";
ADDRGP4 s_serveroptions+3028+4
ADDRGP4 $1505
ASGNP4
line 2048
;2048:	s_serveroptions.enableBlaster.generic.flags = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_serveroptions+3028+44
CNSTU4 258
ASGNU4
line 2049
;2049:	s_serveroptions.enableBlaster.generic.x = 440;
ADDRGP4 s_serveroptions+3028+12
CNSTI4 440
ASGNI4
line 2050
;2050:	s_serveroptions.enableBlaster.generic.y = y;
ADDRGP4 s_serveroptions+3028+16
ADDRLP4 4
INDIRI4
ASGNI4
line 2052
;2051:
;2052:	s_serveroptions.back.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6700
CNSTI4 6
ASGNI4
line 2053
;2053:	s_serveroptions.back.generic.name     = GAMESERVER_BACK0;
ADDRGP4 s_serveroptions+6700+4
ADDRGP4 $439
ASGNP4
line 2054
;2054:	s_serveroptions.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6700+44
CNSTU4 260
ASGNU4
line 2055
;2055:	s_serveroptions.back.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6700+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2056
;2056:	s_serveroptions.back.generic.id	      = ID_BACK;
ADDRGP4 s_serveroptions+6700+8
CNSTI4 24
ASGNI4
line 2057
;2057:	s_serveroptions.back.generic.x		  = 0;
ADDRGP4 s_serveroptions+6700+12
CNSTI4 0
ASGNI4
line 2058
;2058:	s_serveroptions.back.generic.y		  = 480-64;
ADDRGP4 s_serveroptions+6700+16
CNSTI4 416
ASGNI4
line 2059
;2059:	s_serveroptions.back.width  		  = 128;
ADDRGP4 s_serveroptions+6700+76
CNSTI4 128
ASGNI4
line 2060
;2060:	s_serveroptions.back.height  		  = 64;
ADDRGP4 s_serveroptions+6700+80
CNSTI4 64
ASGNI4
line 2061
;2061:	s_serveroptions.back.focuspic         = GAMESERVER_BACK1;
ADDRGP4 s_serveroptions+6700+60
ADDRGP4 $456
ASGNP4
line 2063
;2062:
;2063:	s_serveroptions.next.generic.type	  = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6612
CNSTI4 6
ASGNI4
line 2064
;2064:	s_serveroptions.next.generic.name     = GAMESERVER_NEXT0;
ADDRGP4 s_serveroptions+6612+4
ADDRGP4 $460
ASGNP4
line 2065
;2065:	s_serveroptions.next.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS|QMF_INACTIVE|QMF_GRAYED|QMF_HIDDEN;
ADDRGP4 s_serveroptions+6612+44
CNSTU4 28944
ASGNU4
line 2066
;2066:	s_serveroptions.next.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6612+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2067
;2067:	s_serveroptions.next.generic.id	      = ID_STARTSERVERNEXT;
ADDRGP4 s_serveroptions+6612+8
CNSTI4 18
ASGNI4
line 2068
;2068:	s_serveroptions.next.generic.x		  = 640;
ADDRGP4 s_serveroptions+6612+12
CNSTI4 640
ASGNI4
line 2069
;2069:	s_serveroptions.next.generic.y		  = 480-64-72;
ADDRGP4 s_serveroptions+6612+16
CNSTI4 344
ASGNI4
line 2070
;2070:	s_serveroptions.next.generic.statusbar  = ServerOptions_StatusBar;
ADDRGP4 s_serveroptions+6612+52
ADDRGP4 ServerOptions_StatusBar
ASGNP4
line 2071
;2071:	s_serveroptions.next.width  		  = 128;
ADDRGP4 s_serveroptions+6612+76
CNSTI4 128
ASGNI4
line 2072
;2072:	s_serveroptions.next.height  		  = 64;
ADDRGP4 s_serveroptions+6612+80
CNSTI4 64
ASGNI4
line 2073
;2073:	s_serveroptions.next.focuspic         = GAMESERVER_NEXT1;
ADDRGP4 s_serveroptions+6612+60
ADDRGP4 $477
ASGNP4
line 2075
;2074:
;2075:	s_serveroptions.go.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_serveroptions+6524
CNSTI4 6
ASGNI4
line 2076
;2076:	s_serveroptions.go.generic.name     = GAMESERVER_FIGHT0;
ADDRGP4 s_serveroptions+6524+4
ADDRGP4 $1555
ASGNP4
line 2077
;2077:	s_serveroptions.go.generic.flags    = QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_serveroptions+6524+44
CNSTU4 272
ASGNU4
line 2078
;2078:	s_serveroptions.go.generic.callback = ServerOptions_Event;
ADDRGP4 s_serveroptions+6524+48
ADDRGP4 ServerOptions_Event
ASGNP4
line 2079
;2079:	s_serveroptions.go.generic.id	    = ID_GO;
ADDRGP4 s_serveroptions+6524+8
CNSTI4 23
ASGNI4
line 2080
;2080:	s_serveroptions.go.generic.x		= 640;
ADDRGP4 s_serveroptions+6524+12
CNSTI4 640
ASGNI4
line 2081
;2081:	s_serveroptions.go.generic.y		= 480-64;
ADDRGP4 s_serveroptions+6524+16
CNSTI4 416
ASGNI4
line 2082
;2082:	s_serveroptions.go.width  		    = 128;
ADDRGP4 s_serveroptions+6524+76
CNSTI4 128
ASGNI4
line 2083
;2083:	s_serveroptions.go.height  		    = 64;
ADDRGP4 s_serveroptions+6524+80
CNSTI4 64
ASGNI4
line 2084
;2084:	s_serveroptions.go.focuspic         = GAMESERVER_FIGHT1;
ADDRGP4 s_serveroptions+6524+60
ADDRGP4 $1572
ASGNP4
line 2086
;2085:
;2086:	Menu_AddItem( &s_serveroptions.menu,&s_serveroptions.respawnTime );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3188
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2087
;2087:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.banner );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2088
;2088:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noMegaHealth );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2708
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2089
;2089:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noPersonalTeleporter );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2772
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2090
;2090:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.enableBlaster);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3028
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2091
;2091:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.mappic );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2092
;2092:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.picframe );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2094
;2093:
;2094:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.botSkill );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2088
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2095
;2095:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.player0 );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3284
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2096
;2096:	for( n = 0; n < PLAYER_SLOTS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1582
line 2097
;2097:		if( n != 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1586
line 2098
;2098:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerType[n] );
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
line 2099
;2099:		}
LABELV $1586
line 2100
;2100:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerName[n] );
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
line 2101
;2101:		if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1590
line 2102
;2102:			Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.playerTeam[n] );
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
line 2103
;2103:		}
LABELV $1590
line 2104
;2104:	}
LABELV $1583
line 2096
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 12
LTI4 $1582
line 2106
;2105:
;2106:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.additionalSlots );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2184
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2107
;2107:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPowerups);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2108
;2108:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noHealth);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2580
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2109
;2109:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noArmor);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2644
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2110
;2110:	Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.noPlasmaBFG);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2836
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2111
;2111:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noGrenadeRocket);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2900
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2112
;2112:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.noRailgun);
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2114
;2113:	
;2114:	if( trap_Cvar_VariableValue("g_assaultMode") == 1 ) {
ADDRGP4 $237
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 1065353216
NEF4 $1601
line 2115
;2115:		Menu_AddItem(&s_serveroptions.menu, &s_serveroptions.assaultMiddleItem
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+3092
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2117
;2116:		);
;2117:	}
LABELV $1601
line 2119
;2118:		
;2119:	if( s_serveroptions.gametype != GT_CTF ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 4
EQI4 $1604
line 2120
;2120:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.fraglimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2121
;2121:	}
ADDRGP4 $1605
JUMPV
LABELV $1604
line 2122
;2122:	else {
line 2123
;2123:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.flaglimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1296
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2124
;2124:	}
LABELV $1605
line 2125
;2125:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.timelimit );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+632
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2126
;2126:	if( s_serveroptions.gametype >= GT_TEAM ) {
ADDRGP4 s_serveroptions+6792
INDIRI4
CNSTI4 3
LTI4 $1610
line 2127
;2127:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.friendlyfire );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1628
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2128
;2128:	}
LABELV $1610
line 2129
;2129:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.pure );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+2024
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2130
;2130:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1615
line 2131
;2131:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.dedicated );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2132
;2132:	}
LABELV $1615
line 2133
;2133:	if( s_serveroptions.multiplayer ) {
ADDRGP4 s_serveroptions+6788
INDIRI4
CNSTI4 0
EQI4 $1619
line 2134
;2134:		Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.hostname );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+1692
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2135
;2135:	}
LABELV $1619
line 2137
;2136:
;2137:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.back );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6700
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2138
;2138:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.next );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6612
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2139
;2139:	Menu_AddItem( &s_serveroptions.menu, &s_serveroptions.go );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+6524
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2141
;2140:
;2141:	Menu_AddItem( &s_serveroptions.menu, (void*) &s_serveroptions.punkbuster );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 s_serveroptions+7044
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2144
;2142:	
;2143:	
;2144:	ServerOptions_SetMenuItems();
ADDRGP4 ServerOptions_SetMenuItems
CALLV
pop
line 2145
;2145:}
LABELV $1113
endproc ServerOptions_MenuInit 52 12
export ServerOptions_Cache
proc ServerOptions_Cache 0 4
line 2152
;2146:
;2147:/*
;2148:=================
;2149:ServerOptions_Cache
;2150:=================
;2151:*/
;2152:void ServerOptions_Cache( void ) {
line 2153
;2153:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK0 );
ADDRGP4 $439
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2154
;2154:	trap_R_RegisterShaderNoMip( GAMESERVER_BACK1 );
ADDRGP4 $456
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2155
;2155:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT0 );
ADDRGP4 $1555
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2156
;2156:	trap_R_RegisterShaderNoMip( GAMESERVER_FIGHT1 );
ADDRGP4 $1572
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2157
;2157:	trap_R_RegisterShaderNoMip( GAMESERVER_SELECT );
ADDRGP4 $372
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2158
;2158:	trap_R_RegisterShaderNoMip( GAMESERVER_UNKNOWNMAP );
ADDRGP4 $344
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2159
;2159:}
LABELV $1627
endproc ServerOptions_Cache 0 4
proc UI_ServerOptionsMenu 0 4
line 2167
;2160:
;2161:
;2162:/*
;2163:=================
;2164:UI_ServerOptionsMenu
;2165:=================
;2166:*/
;2167:static void UI_ServerOptionsMenu( qboolean multiplayer ) {
line 2168
;2168:	ServerOptions_MenuInit( multiplayer );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 ServerOptions_MenuInit
CALLV
pop
line 2169
;2169:	UI_PushMenu( &s_serveroptions.menu );
ADDRGP4 s_serveroptions
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2170
;2170:}
LABELV $1628
endproc UI_ServerOptionsMenu 0 4
proc UI_BotSelectMenu_SortCompare 44 8
line 2231
;2171:
;2172:
;2173:
;2174:/*
;2175:=============================================================================
;2176:
;2177:BOT SELECT MENU *****
;2178:
;2179:=============================================================================
;2180:*/
;2181:
;2182:
;2183:#define BOTSELECT_BACK0			"menu/art/back_0"
;2184:#define BOTSELECT_BACK1			"menu/art/back_1"
;2185:#define BOTSELECT_ACCEPT0		"menu/art/accept_0"
;2186:#define BOTSELECT_ACCEPT1		"menu/art/accept_1"
;2187:#define BOTSELECT_SELECT		"menu/art/opponents_select"
;2188:#define BOTSELECT_SELECTED		"menu/art/opponents_selected"
;2189:#define BOTSELECT_ARROWS		"menu/art/gs_arrows_0"
;2190:#define BOTSELECT_ARROWSL		"menu/art/gs_arrows_l"
;2191:#define BOTSELECT_ARROWSR		"menu/art/gs_arrows_r"
;2192:
;2193:#define PLAYERGRID_COLS			4
;2194:#define PLAYERGRID_ROWS			4
;2195:#define MAX_MODELSPERPAGE		(PLAYERGRID_ROWS * PLAYERGRID_COLS)
;2196:
;2197:
;2198:typedef struct {
;2199:	menuframework_s	menu;
;2200:
;2201:	menutext_s		banner;
;2202:
;2203:	menubitmap_s	pics[MAX_MODELSPERPAGE];
;2204:	menubitmap_s	picbuttons[MAX_MODELSPERPAGE];
;2205:	menutext_s		picnames[MAX_MODELSPERPAGE];
;2206:
;2207:	menubitmap_s	arrows;
;2208:	menubitmap_s	left;
;2209:	menubitmap_s	right;
;2210:
;2211:	menubitmap_s	go;
;2212:	menubitmap_s	back;
;2213:
;2214:	int				numBots;
;2215:	int				modelpage;
;2216:	int				numpages;
;2217:	int				selectedmodel;
;2218:	int				sortedBotNums[MAX_BOTS];
;2219:	char			boticons[MAX_MODELSPERPAGE][MAX_QPATH];
;2220:	char			botnames[MAX_MODELSPERPAGE][16];
;2221:} botSelectInfo_t;
;2222:
;2223:static botSelectInfo_t	botSelectInfo;
;2224:
;2225:
;2226:/*
;2227:=================
;2228:UI_BotSelectMenu_SortCompare
;2229:=================
;2230:*/
;2231:static int QDECL UI_BotSelectMenu_SortCompare( const void *arg1, const void *arg2 ) {
line 2236
;2232:	int			num1, num2;
;2233:	const char	*info1, *info2;
;2234:	const char	*name1, *name2;
;2235:
;2236:	num1 = *(int *)arg1;
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRI4
ASGNI4
line 2237
;2237:	num2 = *(int *)arg2;
ADDRLP4 4
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
line 2239
;2238:
;2239:	info1 = UI_GetBotInfoByNumber( num1 );
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
line 2240
;2240:	info2 = UI_GetBotInfoByNumber( num2 );
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
line 2242
;2241:
;2242:	name1 = Info_ValueForKey( info1, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $791
ARGP4
ADDRLP4 32
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 2243
;2243:	name2 = Info_ValueForKey( info2, "name" );
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 $791
ARGP4
ADDRLP4 36
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 36
INDIRP4
ASGNP4
line 2245
;2244:
;2245:	return Q_stricmp( name1, name2 );
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
LABELV $1630
endproc UI_BotSelectMenu_SortCompare 44 8
proc UI_BotSelectMenu_BuildList 12 16
line 2254
;2246:}
;2247:
;2248:
;2249:/*
;2250:=================
;2251:UI_BotSelectMenu_BuildList
;2252:=================
;2253:*/
;2254:static void UI_BotSelectMenu_BuildList( void ) {
line 2257
;2255:	int		n;
;2256:
;2257:	botSelectInfo.modelpage = 0;
ADDRGP4 botSelectInfo+4772
CNSTI4 0
ASGNI4
line 2258
;2258:	botSelectInfo.numBots = UI_GetNumBots();
ADDRLP4 4
ADDRGP4 UI_GetNumBots
CALLI4
ASGNI4
ADDRGP4 botSelectInfo+4768
ADDRLP4 4
INDIRI4
ASGNI4
line 2259
;2259:	botSelectInfo.numpages = botSelectInfo.numBots / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4776
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2260
;2260:	if( botSelectInfo.numBots % MAX_MODELSPERPAGE ) {
ADDRGP4 botSelectInfo+4768
INDIRI4
CNSTI4 16
MODI4
CNSTI4 0
EQI4 $1636
line 2261
;2261:		botSelectInfo.numpages++;
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
line 2262
;2262:	}
LABELV $1636
line 2265
;2263:
;2264:	// initialize the array
;2265:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1643
JUMPV
LABELV $1640
line 2266
;2266:		botSelectInfo.sortedBotNums[n] = n;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2267
;2267:	}
LABELV $1641
line 2265
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1643
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1640
line 2270
;2268:
;2269:	// now sort it
;2270:	qsort( botSelectInfo.sortedBotNums, botSelectInfo.numBots, sizeof(botSelectInfo.sortedBotNums[0]), UI_BotSelectMenu_SortCompare );
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
line 2271
;2271:}
LABELV $1631
endproc UI_BotSelectMenu_BuildList 12 16
proc ServerPlayerIcon 80 20
line 2279
;2272:
;2273:
;2274:/*
;2275:=================
;2276:ServerPlayerIcon
;2277:=================
;2278:*/
;2279:static void ServerPlayerIcon( const char *modelAndSkin, char *iconName, int iconNameMaxSize ) {
line 2283
;2280:	char	*skin;
;2281:	char	model[MAX_QPATH];
;2282:
;2283:	Q_strncpyz( model, modelAndSkin, sizeof(model));
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
line 2284
;2284:	skin = Q_strrchr( model, '/' );
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
line 2285
;2285:	if ( skin ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1650
line 2286
;2286:		*skin++ = '\0';
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
line 2287
;2287:	}
ADDRGP4 $1651
JUMPV
LABELV $1650
line 2288
;2288:	else {
line 2289
;2289:		skin = "default";
ADDRLP4 0
ADDRGP4 $1652
ASGNP4
line 2290
;2290:	}
LABELV $1651
line 2292
;2291:
;2292:	Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_%s.tga", model, skin );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1653
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2294
;2293:
;2294:	if( !trap_R_RegisterShaderNoMip( iconName ) && Q_stricmp( skin, "default" ) != 0 ) {
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
NEI4 $1654
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $1652
ARGP4
ADDRLP4 76
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $1654
line 2295
;2295:		Com_sprintf(iconName, iconNameMaxSize, "models/players/%s/icon_default.tga", model );
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1656
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 2296
;2296:	}
LABELV $1654
line 2297
;2297:}
LABELV $1649
endproc ServerPlayerIcon 80 20
proc UI_BotSelectMenu_UpdateGrid 36 12
line 2305
;2298:
;2299:
;2300:/*
;2301:=================
;2302:UI_BotSelectMenu_UpdateGrid
;2303:=================
;2304:*/
;2305:static void UI_BotSelectMenu_UpdateGrid( void ) {
line 2310
;2306:	const char	*info;
;2307:	int			i;
;2308:    int			j;
;2309:
;2310:	j = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRLP4 4
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2311
;2311:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++, j++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1659
line 2312
;2312:		if( j < botSelectInfo.numBots ) { 
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
GEI4 $1663
line 2313
;2313:			info = UI_GetBotInfoByNumber( botSelectInfo.sortedBotNums[j] );
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
line 2314
;2314:			ServerPlayerIcon( Info_ValueForKey( info, "model" ), botSelectInfo.boticons[i], MAX_QPATH );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $1667
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
line 2315
;2315:			Q_strncpyz( botSelectInfo.botnames[i], Info_ValueForKey( info, "name" ), 16 );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $791
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
line 2316
;2316:			Q_CleanStr( botSelectInfo.botnames[i] );
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
line 2317
;2317: 			botSelectInfo.pics[i].generic.name = botSelectInfo.boticons[i];
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
line 2318
;2318:			if( BotAlreadySelected( botSelectInfo.botnames[i] ) ) {
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
EQI4 $1674
line 2319
;2319:				botSelectInfo.picnames[i].color = color_red;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_red
ASGNP4
line 2320
;2320:			}
ADDRGP4 $1675
JUMPV
LABELV $1674
line 2321
;2321:			else {
line 2322
;2322:				botSelectInfo.picnames[i].color = color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2323
;2323:			}
LABELV $1675
line 2324
;2324:			botSelectInfo.picbuttons[i].generic.flags &= ~QMF_INACTIVE;
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
line 2325
;2325:		}
ADDRGP4 $1664
JUMPV
LABELV $1663
line 2326
;2326:		else {
line 2328
;2327:			// dead slot
;2328: 			botSelectInfo.pics[i].generic.name         = NULL;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+4
ADDP4
CNSTP4 0
ASGNP4
line 2329
;2329:			botSelectInfo.picbuttons[i].generic.flags |= QMF_INACTIVE;
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
line 2330
;2330:			botSelectInfo.botnames[i][0] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 botSelectInfo+9904
ADDP4
CNSTI1 0
ASGNI1
line 2331
;2331:		}
LABELV $1664
line 2333
;2332:
;2333: 		botSelectInfo.pics[i].generic.flags       &= ~QMF_HIGHLIGHT;
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
line 2334
;2334: 		botSelectInfo.pics[i].shader               = 0;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+68
ADDP4
CNSTI4 0
ASGNI4
line 2335
;2335: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2336
;2336:	}
LABELV $1660
line 2311
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
LTI4 $1659
line 2339
;2337:
;2338:	// set selected model
;2339:	i = botSelectInfo.selectedmodel % MAX_MODELSPERPAGE;
ADDRLP4 0
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
MODI4
ASGNI4
line 2340
;2340:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2341
;2341:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2343
;2342:
;2343:	if( botSelectInfo.numpages > 1 ) {
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
LEI4 $1699
line 2344
;2344:		if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1702
line 2345
;2345:			botSelectInfo.left.generic.flags &= ~QMF_INACTIVE;
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
line 2346
;2346:		}
ADDRGP4 $1703
JUMPV
LABELV $1702
line 2347
;2347:		else {
line 2348
;2348:			botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2349
;2349:		}
LABELV $1703
line 2351
;2350:
;2351:		if( botSelectInfo.modelpage < (botSelectInfo.numpages - 1) ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1709
line 2352
;2352:			botSelectInfo.right.generic.flags &= ~QMF_INACTIVE;
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
line 2353
;2353:		}
ADDRGP4 $1700
JUMPV
LABELV $1709
line 2354
;2354:		else {
line 2355
;2355:			botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2356
;2356:		}
line 2357
;2357:	}
ADDRGP4 $1700
JUMPV
LABELV $1699
line 2358
;2358:	else {
line 2360
;2359:		// hide left/right markers
;2360:		botSelectInfo.left.generic.flags |= QMF_INACTIVE;
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
line 2361
;2361:		botSelectInfo.right.generic.flags |= QMF_INACTIVE;
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
line 2362
;2362:	}
LABELV $1700
line 2363
;2363:}
LABELV $1657
endproc UI_BotSelectMenu_UpdateGrid 36 12
proc UI_BotSelectMenu_Default 28 8
line 2371
;2364:
;2365:
;2366:/*
;2367:=================
;2368:UI_BotSelectMenu_Default
;2369:=================
;2370:*/
;2371:static void UI_BotSelectMenu_Default( char *bot ) {
line 2377
;2372:	const char	*botInfo;
;2373:	const char	*test;
;2374:	int			n;
;2375:	int			i;
;2376:
;2377:	for( n = 0; n < botSelectInfo.numBots; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1725
JUMPV
LABELV $1722
line 2378
;2378:		botInfo = UI_GetBotInfoByNumber( n );
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
line 2379
;2379:		test = Info_ValueForKey( botInfo, "name" );
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 $791
ARGP4
ADDRLP4 20
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
line 2380
;2380:		if( Q_stricmp( bot, test ) == 0 ) {
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
NEI4 $1727
line 2381
;2381:			break;
ADDRGP4 $1724
JUMPV
LABELV $1727
line 2383
;2382:		}
;2383:	}
LABELV $1723
line 2377
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1725
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1722
LABELV $1724
line 2384
;2384:	if( n == botSelectInfo.numBots ) {
ADDRLP4 0
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1729
line 2385
;2385:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2386
;2386:		return;
ADDRGP4 $1721
JUMPV
LABELV $1729
line 2389
;2387:	}
;2388:
;2389:	for( i = 0; i < botSelectInfo.numBots; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1736
JUMPV
LABELV $1733
line 2390
;2390:		if( botSelectInfo.sortedBotNums[i] == n ) {
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 botSelectInfo+4784
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $1738
line 2391
;2391:			break;
ADDRGP4 $1735
JUMPV
LABELV $1738
line 2393
;2392:		}
;2393:	}
LABELV $1734
line 2389
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1736
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
LTI4 $1733
LABELV $1735
line 2394
;2394:	if( i == botSelectInfo.numBots ) {
ADDRLP4 4
INDIRI4
ADDRGP4 botSelectInfo+4768
INDIRI4
NEI4 $1741
line 2395
;2395:		botSelectInfo.selectedmodel = 0;
ADDRGP4 botSelectInfo+4780
CNSTI4 0
ASGNI4
line 2396
;2396:		return;
ADDRGP4 $1721
JUMPV
LABELV $1741
line 2399
;2397:	}
;2398:
;2399:	botSelectInfo.selectedmodel = i;
ADDRGP4 botSelectInfo+4780
ADDRLP4 4
INDIRI4
ASGNI4
line 2400
;2400:}
LABELV $1721
endproc UI_BotSelectMenu_Default 28 8
proc UI_BotSelectMenu_LeftEvent 4 0
line 2408
;2401:
;2402:
;2403:/*
;2404:=================
;2405:UI_BotSelectMenu_LeftEvent
;2406:=================
;2407:*/
;2408:static void UI_BotSelectMenu_LeftEvent( void* ptr, int event ) {
line 2409
;2409:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1747
line 2410
;2410:		return;
ADDRGP4 $1746
JUMPV
LABELV $1747
line 2412
;2411:	}
;2412:	if( botSelectInfo.modelpage > 0 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 0
LEI4 $1749
line 2413
;2413:		botSelectInfo.modelpage--;
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
line 2414
;2414:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2415
;2415:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2416
;2416:	}
LABELV $1749
line 2417
;2417:}
LABELV $1746
endproc UI_BotSelectMenu_LeftEvent 4 0
proc UI_BotSelectMenu_RightEvent 4 0
line 2425
;2418:
;2419:
;2420:/*
;2421:=================
;2422:UI_BotSelectMenu_RightEvent
;2423:=================
;2424:*/
;2425:static void UI_BotSelectMenu_RightEvent( void* ptr, int event ) {
line 2426
;2426:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1756
line 2427
;2427:		return;
ADDRGP4 $1755
JUMPV
LABELV $1756
line 2429
;2428:	}
;2429:	if( botSelectInfo.modelpage < botSelectInfo.numpages - 1 ) {
ADDRGP4 botSelectInfo+4772
INDIRI4
ADDRGP4 botSelectInfo+4776
INDIRI4
CNSTI4 1
SUBI4
GEI4 $1758
line 2430
;2430:		botSelectInfo.modelpage++;
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
line 2431
;2431:		botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ASGNI4
line 2432
;2432:		UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2433
;2433:	}
LABELV $1758
line 2434
;2434:}
LABELV $1755
endproc UI_BotSelectMenu_RightEvent 4 0
proc UI_BotSelectMenu_BotEvent 12 0
line 2442
;2435:
;2436:
;2437:/*
;2438:=================
;2439:UI_BotSelectMenu_BotEvent
;2440:=================
;2441:*/
;2442:static void UI_BotSelectMenu_BotEvent( void* ptr, int event ) {
line 2445
;2443:	int		i;
;2444:
;2445:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1766
line 2446
;2446:		return;
ADDRGP4 $1765
JUMPV
LABELV $1766
line 2449
;2447:	}
;2448:
;2449:	for( i = 0; i < (PLAYERGRID_ROWS * PLAYERGRID_COLS); i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1768
line 2450
;2450: 		botSelectInfo.pics[i].generic.flags &= ~QMF_HIGHLIGHT;
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
line 2451
;2451: 		botSelectInfo.picbuttons[i].generic.flags |= QMF_PULSEIFFOCUS;
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
line 2452
;2452:	}
LABELV $1769
line 2449
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 16
LTI4 $1768
line 2455
;2453:
;2454:	// set selected
;2455:	i = ((menucommon_s*)ptr)->id;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 2456
;2456:	botSelectInfo.pics[i].generic.flags |= QMF_HIGHLIGHT;
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
line 2457
;2457:	botSelectInfo.picbuttons[i].generic.flags &= ~QMF_PULSEIFFOCUS;
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
line 2458
;2458:	botSelectInfo.selectedmodel = botSelectInfo.modelpage * MAX_MODELSPERPAGE + i;
ADDRGP4 botSelectInfo+4780
ADDRGP4 botSelectInfo+4772
INDIRI4
CNSTI4 4
LSHI4
ADDRLP4 0
INDIRI4
ADDI4
ASGNI4
line 2459
;2459:}
LABELV $1765
endproc UI_BotSelectMenu_BotEvent 12 0
proc UI_BotSelectMenu_BackEvent 0 0
line 2467
;2460:
;2461:
;2462:/*
;2463:=================
;2464:UI_BotSelectMenu_BackEvent
;2465:=================
;2466:*/
;2467:static void UI_BotSelectMenu_BackEvent( void* ptr, int event ) {
line 2468
;2468:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1783
line 2469
;2469:		return;
ADDRGP4 $1782
JUMPV
LABELV $1783
line 2471
;2470:	}
;2471:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2472
;2472:}
LABELV $1782
endproc UI_BotSelectMenu_BackEvent 0 0
proc UI_BotSelectMenu_SelectEvent 4 12
line 2480
;2473:
;2474:
;2475:/*
;2476:=================
;2477:UI_BotSelectMenu_SelectEvent
;2478:=================
;2479:*/
;2480:static void UI_BotSelectMenu_SelectEvent( void* ptr, int event ) {
line 2481
;2481:	if( event != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $1786
line 2482
;2482:		return;
ADDRGP4 $1785
JUMPV
LABELV $1786
line 2484
;2483:	}
;2484:	UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 2486
;2485:
;2486:	s_serveroptions.newBot = qtrue;
ADDRGP4 s_serveroptions+7020
CNSTI4 1
ASGNI4
line 2487
;2487:	Q_strncpyz( s_serveroptions.newBotName, botSelectInfo.botnames[botSelectInfo.selectedmodel % MAX_MODELSPERPAGE], 16 );
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
line 2488
;2488:}
LABELV $1785
endproc UI_BotSelectMenu_SelectEvent 4 12
export UI_BotSelectMenu_Cache
proc UI_BotSelectMenu_Cache 0 4
line 2496
;2489:
;2490:
;2491:/*
;2492:=================
;2493:UI_BotSelectMenu_Cache
;2494:=================
;2495:*/
;2496:void UI_BotSelectMenu_Cache( void ) {
line 2497
;2497:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK0 );
ADDRGP4 $439
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2498
;2498:	trap_R_RegisterShaderNoMip( BOTSELECT_BACK1 );
ADDRGP4 $456
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2499
;2499:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT0 );
ADDRGP4 $1793
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2500
;2500:	trap_R_RegisterShaderNoMip( BOTSELECT_ACCEPT1 );
ADDRGP4 $1794
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2501
;2501:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECT );
ADDRGP4 $1795
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2502
;2502:	trap_R_RegisterShaderNoMip( BOTSELECT_SELECTED );
ADDRGP4 $1796
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2503
;2503:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWS );
ADDRGP4 $376
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2504
;2504:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSL );
ADDRGP4 $404
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2505
;2505:	trap_R_RegisterShaderNoMip( BOTSELECT_ARROWSR );
ADDRGP4 $422
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 2506
;2506:}
LABELV $1792
endproc UI_BotSelectMenu_Cache 0 4
proc UI_BotSelectMenu_Init 36 12
line 2509
;2507:
;2508:
;2509:static void UI_BotSelectMenu_Init( char *bot ) {
line 2513
;2510:	int		i, j, k;
;2511:	int		x, y;
;2512:
;2513:	memset( &botSelectInfo, 0 ,sizeof(botSelectInfo) );
ADDRGP4 botSelectInfo
ARGP4
CNSTI4 0
ARGI4
CNSTI4 10160
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2514
;2514:	botSelectInfo.menu.wrapAround = qtrue;
ADDRGP4 botSelectInfo+276
CNSTI4 1
ASGNI4
line 2515
;2515:	botSelectInfo.menu.fullscreen = qtrue;
ADDRGP4 botSelectInfo+280
CNSTI4 1
ASGNI4
line 2517
;2516:
;2517:	UI_BotSelectMenu_Cache();
ADDRGP4 UI_BotSelectMenu_Cache
CALLV
pop
line 2519
;2518:
;2519:	botSelectInfo.banner.generic.type	= MTYPE_BTEXT;
ADDRGP4 botSelectInfo+288
CNSTI4 10
ASGNI4
line 2520
;2520:	botSelectInfo.banner.generic.x		= 320;
ADDRGP4 botSelectInfo+288+12
CNSTI4 320
ASGNI4
line 2521
;2521:	botSelectInfo.banner.generic.y		= 16;
ADDRGP4 botSelectInfo+288+16
CNSTI4 16
ASGNI4
line 2522
;2522:	botSelectInfo.banner.string			= "SELECT BOT";
ADDRGP4 botSelectInfo+288+60
ADDRGP4 $1807
ASGNP4
line 2523
;2523:	botSelectInfo.banner.color			= color_white;
ADDRGP4 botSelectInfo+288+68
ADDRGP4 color_white
ASGNP4
line 2524
;2524:	botSelectInfo.banner.style			= UI_CENTER;
ADDRGP4 botSelectInfo+288+64
CNSTI4 1
ASGNI4
line 2526
;2525:
;2526:	y =	80;
ADDRLP4 8
CNSTI4 80
ASGNI4
line 2527
;2527:	for( i = 0, k = 0; i < PLAYERGRID_ROWS; i++) {
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
ADDRGP4 $1815
JUMPV
LABELV $1812
line 2528
;2528:		x =	180;
ADDRLP4 4
CNSTI4 180
ASGNI4
line 2529
;2529:		for( j = 0; j < PLAYERGRID_COLS; j++, k++ ) {
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $1816
line 2530
;2530:			botSelectInfo.pics[k].generic.type				= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360
ADDP4
CNSTI4 6
ASGNI4
line 2531
;2531:			botSelectInfo.pics[k].generic.flags				= QMF_LEFT_JUSTIFY|QMF_INACTIVE;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+44
ADDP4
CNSTU4 16388
ASGNU4
line 2532
;2532:			botSelectInfo.pics[k].generic.x					= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2533
;2533:			botSelectInfo.pics[k].generic.y					= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+16
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2534
;2534: 			botSelectInfo.pics[k].generic.name				= botSelectInfo.boticons[k];
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
line 2535
;2535:			botSelectInfo.pics[k].width						= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+76
ADDP4
CNSTI4 64
ASGNI4
line 2536
;2536:			botSelectInfo.pics[k].height					= 64;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+80
ADDP4
CNSTI4 64
ASGNI4
line 2537
;2537:			botSelectInfo.pics[k].focuspic					= BOTSELECT_SELECTED;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+60
ADDP4
ADDRGP4 $1796
ASGNP4
line 2538
;2538:			botSelectInfo.pics[k].focuscolor				= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+360+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2540
;2539:
;2540:			botSelectInfo.picbuttons[k].generic.type		= MTYPE_BITMAP;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768
ADDP4
CNSTI4 6
ASGNI4
line 2541
;2541:			botSelectInfo.picbuttons[k].generic.flags		= QMF_LEFT_JUSTIFY|QMF_NODEFAULTINIT|QMF_PULSEIFFOCUS;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+44
ADDP4
CNSTU4 33028
ASGNU4
line 2542
;2542:			botSelectInfo.picbuttons[k].generic.callback	= UI_BotSelectMenu_BotEvent;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+48
ADDP4
ADDRGP4 UI_BotSelectMenu_BotEvent
ASGNP4
line 2543
;2543:			botSelectInfo.picbuttons[k].generic.id			= k;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+8
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 2544
;2544:			botSelectInfo.picbuttons[k].generic.x			= x - 16;
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
line 2545
;2545:			botSelectInfo.picbuttons[k].generic.y			= y - 16;
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
line 2546
;2546:			botSelectInfo.picbuttons[k].generic.left		= x;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+20
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 2547
;2547:			botSelectInfo.picbuttons[k].generic.top			= y;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+24
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 2548
;2548:			botSelectInfo.picbuttons[k].generic.right		= x + 64;
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
line 2549
;2549:			botSelectInfo.picbuttons[k].generic.bottom		= y + 64;
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
line 2550
;2550:			botSelectInfo.picbuttons[k].width				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+76
ADDP4
CNSTI4 128
ASGNI4
line 2551
;2551:			botSelectInfo.picbuttons[k].height				= 128;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+80
ADDP4
CNSTI4 128
ASGNI4
line 2552
;2552:			botSelectInfo.picbuttons[k].focuspic			= BOTSELECT_SELECT;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+60
ADDP4
ADDRGP4 $1795
ASGNP4
line 2553
;2553:			botSelectInfo.picbuttons[k].focuscolor			= colorRed;
CNSTI4 88
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+1768+84
ADDP4
ADDRGP4 colorRed
ASGNP4
line 2555
;2554:
;2555:			botSelectInfo.picnames[k].generic.type			= MTYPE_TEXT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176
ADDP4
CNSTI4 7
ASGNI4
line 2556
;2556:			botSelectInfo.picnames[k].generic.flags			= QMF_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+44
ADDP4
CNSTU4 2
ASGNU4
line 2557
;2557:			botSelectInfo.picnames[k].generic.x				= x + 32;
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
line 2558
;2558:			botSelectInfo.picnames[k].generic.y				= y + 64;
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
line 2559
;2559:			botSelectInfo.picnames[k].string				= botSelectInfo.botnames[k];
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
line 2560
;2560:			botSelectInfo.picnames[k].color					= color_orange;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+68
ADDP4
ADDRGP4 color_orange
ASGNP4
line 2561
;2561:			botSelectInfo.picnames[k].style					= UI_CENTER|UI_SMALLFONT;
CNSTI4 72
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botSelectInfo+3176+64
ADDP4
CNSTI4 17
ASGNI4
line 2563
;2562:
;2563:			x += (64 + 6);
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 70
ADDI4
ASGNI4
line 2564
;2564:		}
LABELV $1817
line 2529
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
LTI4 $1816
line 2565
;2565:		y += (64 + SMALLCHAR_HEIGHT + 6);
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 86
ADDI4
ASGNI4
line 2566
;2566:	}
LABELV $1813
line 2527
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1815
ADDRLP4 16
INDIRI4
CNSTI4 4
LTI4 $1812
line 2568
;2567:
;2568:	botSelectInfo.arrows.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4328
CNSTI4 6
ASGNI4
line 2569
;2569:	botSelectInfo.arrows.generic.name		= BOTSELECT_ARROWS;
ADDRGP4 botSelectInfo+4328+4
ADDRGP4 $376
ASGNP4
line 2570
;2570:	botSelectInfo.arrows.generic.flags		= QMF_INACTIVE;
ADDRGP4 botSelectInfo+4328+44
CNSTU4 16384
ASGNU4
line 2571
;2571:	botSelectInfo.arrows.generic.x			= 260;
ADDRGP4 botSelectInfo+4328+12
CNSTI4 260
ASGNI4
line 2572
;2572:	botSelectInfo.arrows.generic.y			= 440;
ADDRGP4 botSelectInfo+4328+16
CNSTI4 440
ASGNI4
line 2573
;2573:	botSelectInfo.arrows.width				= 128;
ADDRGP4 botSelectInfo+4328+76
CNSTI4 128
ASGNI4
line 2574
;2574:	botSelectInfo.arrows.height				= 32;
ADDRGP4 botSelectInfo+4328+80
CNSTI4 32
ASGNI4
line 2576
;2575:
;2576:	botSelectInfo.left.generic.type			= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4416
CNSTI4 6
ASGNI4
line 2577
;2577:	botSelectInfo.left.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4416+44
CNSTU4 260
ASGNU4
line 2578
;2578:	botSelectInfo.left.generic.callback		= UI_BotSelectMenu_LeftEvent;
ADDRGP4 botSelectInfo+4416+48
ADDRGP4 UI_BotSelectMenu_LeftEvent
ASGNP4
line 2579
;2579:	botSelectInfo.left.generic.x			= 260;
ADDRGP4 botSelectInfo+4416+12
CNSTI4 260
ASGNI4
line 2580
;2580:	botSelectInfo.left.generic.y			= 440;
ADDRGP4 botSelectInfo+4416+16
CNSTI4 440
ASGNI4
line 2581
;2581:	botSelectInfo.left.width  				= 64;
ADDRGP4 botSelectInfo+4416+76
CNSTI4 64
ASGNI4
line 2582
;2582:	botSelectInfo.left.height  				= 32;
ADDRGP4 botSelectInfo+4416+80
CNSTI4 32
ASGNI4
line 2583
;2583:	botSelectInfo.left.focuspic				= BOTSELECT_ARROWSL;
ADDRGP4 botSelectInfo+4416+60
ADDRGP4 $404
ASGNP4
line 2585
;2584:
;2585:	botSelectInfo.right.generic.type	    = MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4504
CNSTI4 6
ASGNI4
line 2586
;2586:	botSelectInfo.right.generic.flags		= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4504+44
CNSTU4 260
ASGNU4
line 2587
;2587:	botSelectInfo.right.generic.callback	= UI_BotSelectMenu_RightEvent;
ADDRGP4 botSelectInfo+4504+48
ADDRGP4 UI_BotSelectMenu_RightEvent
ASGNP4
line 2588
;2588:	botSelectInfo.right.generic.x			= 321;
ADDRGP4 botSelectInfo+4504+12
CNSTI4 321
ASGNI4
line 2589
;2589:	botSelectInfo.right.generic.y			= 440;
ADDRGP4 botSelectInfo+4504+16
CNSTI4 440
ASGNI4
line 2590
;2590:	botSelectInfo.right.width  				= 64;
ADDRGP4 botSelectInfo+4504+76
CNSTI4 64
ASGNI4
line 2591
;2591:	botSelectInfo.right.height  		    = 32;
ADDRGP4 botSelectInfo+4504+80
CNSTI4 32
ASGNI4
line 2592
;2592:	botSelectInfo.right.focuspic			= BOTSELECT_ARROWSR;
ADDRGP4 botSelectInfo+4504+60
ADDRGP4 $422
ASGNP4
line 2594
;2593:
;2594:	botSelectInfo.back.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4680
CNSTI4 6
ASGNI4
line 2595
;2595:	botSelectInfo.back.generic.name		= BOTSELECT_BACK0;
ADDRGP4 botSelectInfo+4680+4
ADDRGP4 $439
ASGNP4
line 2596
;2596:	botSelectInfo.back.generic.flags	= QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4680+44
CNSTU4 260
ASGNU4
line 2597
;2597:	botSelectInfo.back.generic.callback	= UI_BotSelectMenu_BackEvent;
ADDRGP4 botSelectInfo+4680+48
ADDRGP4 UI_BotSelectMenu_BackEvent
ASGNP4
line 2598
;2598:	botSelectInfo.back.generic.x		= 0;
ADDRGP4 botSelectInfo+4680+12
CNSTI4 0
ASGNI4
line 2599
;2599:	botSelectInfo.back.generic.y		= 480-64;
ADDRGP4 botSelectInfo+4680+16
CNSTI4 416
ASGNI4
line 2600
;2600:	botSelectInfo.back.width			= 128;
ADDRGP4 botSelectInfo+4680+76
CNSTI4 128
ASGNI4
line 2601
;2601:	botSelectInfo.back.height			= 64;
ADDRGP4 botSelectInfo+4680+80
CNSTI4 64
ASGNI4
line 2602
;2602:	botSelectInfo.back.focuspic			= BOTSELECT_BACK1;
ADDRGP4 botSelectInfo+4680+60
ADDRGP4 $456
ASGNP4
line 2604
;2603:
;2604:	botSelectInfo.go.generic.type		= MTYPE_BITMAP;
ADDRGP4 botSelectInfo+4592
CNSTI4 6
ASGNI4
line 2605
;2605:	botSelectInfo.go.generic.name		= BOTSELECT_ACCEPT0;
ADDRGP4 botSelectInfo+4592+4
ADDRGP4 $1793
ASGNP4
line 2606
;2606:	botSelectInfo.go.generic.flags		= QMF_RIGHT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 botSelectInfo+4592+44
CNSTU4 272
ASGNU4
line 2607
;2607:	botSelectInfo.go.generic.callback	= UI_BotSelectMenu_SelectEvent;
ADDRGP4 botSelectInfo+4592+48
ADDRGP4 UI_BotSelectMenu_SelectEvent
ASGNP4
line 2608
;2608:	botSelectInfo.go.generic.x			= 640;
ADDRGP4 botSelectInfo+4592+12
CNSTI4 640
ASGNI4
line 2609
;2609:	botSelectInfo.go.generic.y			= 480-64;
ADDRGP4 botSelectInfo+4592+16
CNSTI4 416
ASGNI4
line 2610
;2610:	botSelectInfo.go.width				= 128;
ADDRGP4 botSelectInfo+4592+76
CNSTI4 128
ASGNI4
line 2611
;2611:	botSelectInfo.go.height				= 64;
ADDRGP4 botSelectInfo+4592+80
CNSTI4 64
ASGNI4
line 2612
;2612:	botSelectInfo.go.focuspic			= BOTSELECT_ACCEPT1;
ADDRGP4 botSelectInfo+4592+60
ADDRGP4 $1794
ASGNP4
line 2614
;2613:
;2614:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.banner );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2615
;2615:	for( i = 0; i < MAX_MODELSPERPAGE; i++ ) {
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $1957
line 2616
;2616:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.pics[i] );
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
line 2617
;2617:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picbuttons[i] );
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
line 2618
;2618:		Menu_AddItem( &botSelectInfo.menu,	&botSelectInfo.picnames[i] );
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
line 2619
;2619:	}
LABELV $1958
line 2615
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 16
LTI4 $1957
line 2620
;2620:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.arrows );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4328
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2621
;2621:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.left );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4416
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2622
;2622:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.right );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4504
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2623
;2623:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.back );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4680
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2624
;2624:	Menu_AddItem( &botSelectInfo.menu, &botSelectInfo.go );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 botSelectInfo+4592
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 2626
;2625:
;2626:	UI_BotSelectMenu_BuildList();
ADDRGP4 UI_BotSelectMenu_BuildList
CALLV
pop
line 2627
;2627:	UI_BotSelectMenu_Default( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Default
CALLV
pop
line 2628
;2628:	botSelectInfo.modelpage = botSelectInfo.selectedmodel / MAX_MODELSPERPAGE;
ADDRGP4 botSelectInfo+4772
ADDRGP4 botSelectInfo+4780
INDIRI4
CNSTI4 16
DIVI4
ASGNI4
line 2629
;2629:	UI_BotSelectMenu_UpdateGrid();
ADDRGP4 UI_BotSelectMenu_UpdateGrid
CALLV
pop
line 2630
;2630:}
LABELV $1797
endproc UI_BotSelectMenu_Init 36 12
export UI_BotSelectMenu
proc UI_BotSelectMenu 0 4
line 2638
;2631:
;2632:
;2633:/*
;2634:=================
;2635:UI_BotSelectMenu
;2636:=================
;2637:*/
;2638:void UI_BotSelectMenu( char *bot ) {
line 2639
;2639:	UI_BotSelectMenu_Init( bot );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 UI_BotSelectMenu_Init
CALLV
pop
line 2640
;2640:	UI_PushMenu( &botSelectInfo.menu );
ADDRGP4 botSelectInfo
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 2641
;2641:}
LABELV $1971
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
LABELV $1807
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
LABELV $1796
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
LABELV $1795
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
LABELV $1794
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
LABELV $1793
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
LABELV $1667
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $1656
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
LABELV $1653
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
LABELV $1652
byte 1 100
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $1572
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
LABELV $1555
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
LABELV $1505
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
LABELV $1495
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
LABELV $1485
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
LABELV $1475
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
LABELV $1465
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
LABELV $1455
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
LABELV $1445
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
LABELV $1435
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
LABELV $1425
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
LABELV $1407
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
LABELV $1320
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
LABELV $1304
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
LABELV $1288
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
LABELV $1279
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
LABELV $1262
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
LABELV $1252
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
LABELV $1225
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
LABELV $1207
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
LABELV $1189
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
LABELV $1174
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
LABELV $1162
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
LABELV $1048
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $1013
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
LABELV $1007
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
LABELV $1001
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
LABELV $995
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
LABELV $992
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
LABELV $989
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
LABELV $968
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
LABELV $944
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $924
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $912
byte 1 118
byte 1 105
byte 1 115
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $906
byte 1 109
byte 1 97
byte 1 106
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $903
byte 1 103
byte 1 114
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $895
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $883
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
LABELV $823
byte 1 72
byte 1 117
byte 1 109
byte 1 97
byte 1 110
byte 1 0
align 1
LABELV $791
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $760
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
LABELV $755
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
LABELV $751
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
LABELV $733
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 32
byte 1 51
byte 1 10
byte 1 0
align 1
LABELV $730
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
LABELV $729
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
LABELV $728
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 109
byte 1 97
byte 1 112
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
LABELV $720
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
LABELV $717
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
LABELV $712
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
LABELV $709
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
LABELV $706
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
LABELV $703
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
LABELV $700
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
LABELV $697
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
LABELV $694
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
LABELV $691
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
LABELV $688
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
LABELV $685
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
LABELV $681
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
LABELV $680
byte 1 115
byte 1 118
byte 1 95
byte 1 112
byte 1 117
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $679
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
LABELV $678
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
LABELV $677
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
LABELV $676
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
LABELV $675
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
LABELV $674
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
LABELV $672
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
LABELV $671
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
LABELV $670
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
LABELV $668
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
LABELV $667
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
LABELV $666
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
LABELV $664
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
LABELV $663
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
LABELV $661
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
LABELV $660
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
LABELV $653
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
LABELV $648
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
LABELV $645
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
LABELV $642
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
LABELV $639
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
LABELV $636
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
LABELV $633
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
LABELV $630
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
LABELV $627
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
LABELV $626
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
LABELV $590
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
LABELV $587
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
LABELV $584
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
LABELV $581
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
LABELV $559
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
LABELV $558
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
LABELV $557
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
LABELV $556
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
LABELV $555
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
LABELV $554
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
LABELV $553
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
LABELV $552
byte 1 68
byte 1 101
byte 1 102
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 0
align 1
LABELV $551
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
LABELV $550
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
LABELV $549
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
LABELV $548
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
LABELV $547
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
LABELV $546
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $545
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $544
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $543
byte 1 72
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $542
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $541
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
LABELV $540
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $539
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
LABELV $538
byte 1 65
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $537
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
LABELV $536
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
LABELV $535
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
LABELV $534
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
LABELV $533
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
LABELV $532
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $531
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $530
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 0
align 1
LABELV $529
byte 1 66
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $528
byte 1 79
byte 1 112
byte 1 101
byte 1 110
byte 1 0
align 1
LABELV $527
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
LABELV $526
byte 1 76
byte 1 65
byte 1 78
byte 1 0
align 1
LABELV $525
byte 1 78
byte 1 111
byte 1 0
align 1
LABELV $507
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
LABELV $477
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
LABELV $460
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
LABELV $456
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
LABELV $439
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
LABELV $422
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
LABELV $404
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
LABELV $376
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
LABELV $372
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
LABELV $344
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
LABELV $341
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
LABELV $309
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
LABELV $295
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
LABELV $281
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
LABELV $273
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
LABELV $237
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
LABELV $228
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
LABELV $222
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
LABELV $219
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
LABELV $191
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $186
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $141
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
LABELV $108
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
LABELV $97
byte 1 99
byte 1 116
byte 1 102
byte 1 0
align 1
LABELV $94
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 0
align 1
LABELV $91
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $88
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 0
align 1
LABELV $85
byte 1 102
byte 1 102
byte 1 97
byte 1 0
align 1
LABELV $76
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
LABELV $75
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
