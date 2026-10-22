data
align 4
LABELV teamoverlay_names
address $68
address $69
address $70
address $71
byte 4 0
align 4
LABELV moveSpeed_names
address $72
address $73
address $74
address $75
address $76
byte 4 0
lit
align 4
LABELV moveSpeed_values
byte 4 240
byte 4 288
byte 4 320
byte 4 352
byte 4 400
data
align 4
LABELV playerHealth_items
address $77
address $78
address $79
address $80
address $81
byte 4 0
code
proc Preferences_SetMenuItems 200 12
file "../ui_preferences.c"
line 135
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
;24:=======================================================================
;25:
;26:GAME OPTIONS MENU
;27:
;28:=======================================================================
;29:*/
;30:
;31:
;32:#include "ui_local.h"
;33:
;34:
;35:#define ART_FRAMEL				"menu/art/frame2_l"
;36:#define ART_FRAMER				"menu/art/frame1_r"
;37:#define ART_BACK0				"menu/art/back_0"
;38:#define ART_BACK1				"menu/art/back_1"
;39:
;40:#define PREFERENCES_X_POS		360
;41:
;42:#define ID_CROSSHAIR			127
;43:#define ID_SIMPLEITEMS			128
;44:#define ID_HIGHQUALITYSKY		129
;45:#define ID_EJECTINGBRASS		130
;46:#define ID_WALLMARKS			131
;47:#define ID_DYNAMICLIGHTS		132
;48:#define ID_IDENTIFYTARGET		133
;49:#define ID_SYNCEVERYFRAME		134
;50:#define ID_FORCEMODEL			135
;51:#define ID_DRAWTEAMOVERLAY		136
;52:#define ID_ALLOWDOWNLOAD		137
;53:#define ID_BACK				138
;54:#define ID_GORE				139
;55:#define ID_CLEANVIEW			140
;56:#define ID_RAILTRAIL			141
;57:#define ID_MOVESPEED			142
;58:#define ID_STATICITEMS			143
;59:#define ID_PLAYERHEALTH 		144
;60:#define ID_RANDOMSTARTWEAPON 	145
;61:#define ID_SCAVENGERWEAPONS 	146
;62:
;63:
;64:#define	NUM_CROSSHAIRS			10
;65:
;66:
;67:typedef struct {
;68:	menuframework_s		menu;
;69:
;70:	menutext_s			banner;
;71:	menubitmap_s		framel;
;72:	menubitmap_s		framer;
;73:
;74:	menulist_s			crosshair;
;75:	menuradiobutton_s 	scavengerWeapons;
;76:	menuradiobutton_s	simpleitems;
;77:	menuradiobutton_s	brass;
;78:	menuradiobutton_s	wallmarks;
;79:	menuradiobutton_s	dynamiclights;
;80:	menuradiobutton_s	identifytarget;
;81:	menuradiobutton_s	highqualitysky;
;82:	menuradiobutton_s	synceveryframe;
;83:	menuradiobutton_s	forcemodel;
;84:	menulist_s			drawteamoverlay;
;85:	menuradiobutton_s	allowdownload;
;86:	menuradiobutton_s	gore;
;87:	menuradiobutton_s	cleanView;
;88:	menuradiobutton_s	railTrail;
;89:	menulist_s 			playerHealth;
;90:	menulist_s			moveSpeed;
;91:	menuradiobutton_s	staticitems;
;92:	menuradiobutton_s 	randomStartWeapon;
;93:	menubitmap_s		back;
;94:
;95:	qhandle_t			crosshairShader[NUM_CROSSHAIRS];
;96:} preferences_t;
;97:
;98:static preferences_t s_preferences;
;99:
;100:static const char *teamoverlay_names[] =
;101:{
;102:	"off",
;103:	"upper right",
;104:	"lower right",
;105:	"lower left",
;106:	0
;107:};
;108:
;109:static const char *moveSpeed_names[] = {
;110:	"75%",
;111:	"90%",
;112:	"100%",
;113:	"110%",
;114:	"125%",
;115:	0
;116:};
;117:
;118:static const int moveSpeed_values[] = {
;119:	240,
;120:	288,
;121:	320,
;122:	352,
;123:	400
;124:};
;125:
;126:static const char *playerHealth_items[] = {
;127:	"50",
;128:	"75",
;129:	"100",
;130:	"125",
;131:	"150",
;132:	0
;133:};
;134:
;135:static void Preferences_SetMenuItems( void ) {
line 139
;136:
;137:int moveSpeed;
;138:
;139:	s_preferences.scavengerWeapons.curvalue =
ADDRGP4 $85
ARGP4
ADDRLP4 8
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 8
INDIRF4
CNSTF4 0
EQF4 $87
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $88
JUMPV
LABELV $87
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $88
ADDRGP4 s_preferences+632+60
ADDRLP4 4
INDIRI4
ASGNI4
line 144
;140:		trap_Cvar_VariableValue(
;141:			"g_scavengerWeapons"
;142:		) != 0;
;143:
;144:	s_preferences.randomStartWeapon.curvalue =
ADDRGP4 $91
ARGP4
ADDRLP4 16
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 0
EQF4 $93
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRGP4 $94
JUMPV
LABELV $93
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $94
ADDRGP4 s_preferences+1816+60
ADDRLP4 12
INDIRI4
ASGNI4
line 149
;145:		trap_Cvar_VariableValue(
;146:			"g_randomStartWeapon"
;147:		) != 0;
;148:
;149:	s_preferences.staticitems.curvalue =
ADDRGP4 $97
ARGP4
ADDRLP4 24
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 24
INDIRF4
CNSTF4 0
EQF4 $99
ADDRLP4 20
CNSTI4 1
ASGNI4
ADDRGP4 $100
JUMPV
LABELV $99
ADDRLP4 20
CNSTI4 0
ASGNI4
LABELV $100
ADDRGP4 s_preferences+1752+60
ADDRLP4 20
INDIRI4
ASGNI4
line 152
;150:		trap_Cvar_VariableValue( "cg_staticItems" ) != 0;
;151:
;152:	s_preferences.railTrail.curvalue =
ADDRGP4 $103
ARGP4
ADDRLP4 32
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 32
INDIRF4
CNSTF4 0
EQF4 $105
ADDRLP4 28
CNSTI4 1
ASGNI4
ADDRGP4 $106
JUMPV
LABELV $105
ADDRLP4 28
CNSTI4 0
ASGNI4
LABELV $106
ADDRGP4 s_preferences+1496+60
ADDRLP4 28
INDIRI4
ASGNI4
line 155
;153:			trap_Cvar_VariableValue( "cg_drawRailTrail" ) != 0;
;154:
;155:	s_preferences.cleanView.curvalue =
ADDRGP4 $109
ARGP4
ADDRLP4 40
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 40
INDIRF4
CNSTF4 0
EQF4 $111
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $112
JUMPV
LABELV $111
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $112
ADDRGP4 s_preferences+1432+60
ADDRLP4 36
INDIRI4
ASGNI4
line 158
;156:			trap_Cvar_VariableValue( "cg_cleanView" ) != 0;
;157:
;158:	s_preferences.crosshair.curvalue =
ADDRGP4 $115
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRGP4 s_preferences+536+64
ADDRLP4 44
INDIRF4
CVFI4 4
CNSTI4 10
MODI4
ASGNI4
line 161
;159:		(int)trap_Cvar_VariableValue( "cg_drawCrosshair" ) % NUM_CROSSHAIRS;
;160:
;161:	s_preferences.simpleitems.curvalue =
ADDRGP4 $118
ARGP4
ADDRLP4 52
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 52
INDIRF4
CNSTF4 0
EQF4 $120
ADDRLP4 48
CNSTI4 1
ASGNI4
ADDRGP4 $121
JUMPV
LABELV $120
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $121
ADDRGP4 s_preferences+696+60
ADDRLP4 48
INDIRI4
ASGNI4
line 164
;162:		trap_Cvar_VariableValue( "cg_simpleItems" ) != 0;
;163:
;164:	s_preferences.brass.curvalue =
ADDRGP4 $124
ARGP4
ADDRLP4 60
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 60
INDIRF4
CNSTF4 0
EQF4 $126
ADDRLP4 56
CNSTI4 1
ASGNI4
ADDRGP4 $127
JUMPV
LABELV $126
ADDRLP4 56
CNSTI4 0
ASGNI4
LABELV $127
ADDRGP4 s_preferences+760+60
ADDRLP4 56
INDIRI4
ASGNI4
line 167
;165:		trap_Cvar_VariableValue( "cg_brassTime" ) != 0;
;166:
;167:	s_preferences.wallmarks.curvalue =
ADDRGP4 $130
ARGP4
ADDRLP4 68
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 68
INDIRF4
CNSTF4 0
EQF4 $132
ADDRLP4 64
CNSTI4 1
ASGNI4
ADDRGP4 $133
JUMPV
LABELV $132
ADDRLP4 64
CNSTI4 0
ASGNI4
LABELV $133
ADDRGP4 s_preferences+824+60
ADDRLP4 64
INDIRI4
ASGNI4
line 170
;168:		trap_Cvar_VariableValue( "cg_marks" ) != 0;
;169:
;170:	s_preferences.identifytarget.curvalue =
ADDRGP4 $136
ARGP4
ADDRLP4 76
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 76
INDIRF4
CNSTF4 0
EQF4 $138
ADDRLP4 72
CNSTI4 1
ASGNI4
ADDRGP4 $139
JUMPV
LABELV $138
ADDRLP4 72
CNSTI4 0
ASGNI4
LABELV $139
ADDRGP4 s_preferences+952+60
ADDRLP4 72
INDIRI4
ASGNI4
line 173
;171:		trap_Cvar_VariableValue( "cg_drawCrosshairNames" ) != 0;
;172:
;173:	s_preferences.dynamiclights.curvalue =
ADDRGP4 $142
ARGP4
ADDRLP4 84
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 84
INDIRF4
CNSTF4 0
EQF4 $144
ADDRLP4 80
CNSTI4 1
ASGNI4
ADDRGP4 $145
JUMPV
LABELV $144
ADDRLP4 80
CNSTI4 0
ASGNI4
LABELV $145
ADDRGP4 s_preferences+888+60
ADDRLP4 80
INDIRI4
ASGNI4
line 176
;174:		trap_Cvar_VariableValue( "r_dynamiclight" ) != 0;
;175:
;176:	s_preferences.highqualitysky.curvalue =
ADDRGP4 $148
ARGP4
ADDRLP4 92
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 92
INDIRF4
CNSTF4 0
NEF4 $150
ADDRLP4 88
CNSTI4 1
ASGNI4
ADDRGP4 $151
JUMPV
LABELV $150
ADDRLP4 88
CNSTI4 0
ASGNI4
LABELV $151
ADDRGP4 s_preferences+1016+60
ADDRLP4 88
INDIRI4
ASGNI4
line 179
;177:		trap_Cvar_VariableValue( "r_fastsky" ) == 0;
;178:
;179:	s_preferences.synceveryframe.curvalue =
ADDRGP4 $154
ARGP4
ADDRLP4 100
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 100
INDIRF4
CNSTF4 0
EQF4 $156
ADDRLP4 96
CNSTI4 1
ASGNI4
ADDRGP4 $157
JUMPV
LABELV $156
ADDRLP4 96
CNSTI4 0
ASGNI4
LABELV $157
ADDRGP4 s_preferences+1080+60
ADDRLP4 96
INDIRI4
ASGNI4
line 182
;180:		trap_Cvar_VariableValue( "r_finish" ) != 0;
;181:
;182:	s_preferences.forcemodel.curvalue =
ADDRGP4 $160
ARGP4
ADDRLP4 108
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 108
INDIRF4
CNSTF4 0
EQF4 $162
ADDRLP4 104
CNSTI4 1
ASGNI4
ADDRGP4 $163
JUMPV
LABELV $162
ADDRLP4 104
CNSTI4 0
ASGNI4
LABELV $163
ADDRGP4 s_preferences+1144+60
ADDRLP4 104
INDIRI4
ASGNI4
line 185
;183:		trap_Cvar_VariableValue( "cg_forcemodel" ) != 0;
;184:
;185:	s_preferences.drawteamoverlay.curvalue =
ADDRGP4 $166
ARGP4
ADDRLP4 112
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1077936128
ARGF4
ADDRLP4 112
INDIRF4
ARGF4
ADDRLP4 116
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+1208+64
ADDRLP4 116
INDIRF4
CVFI4 4
ASGNI4
line 192
;186:		Com_Clamp(
;187:			0,
;188:			3,
;189:			trap_Cvar_VariableValue( "cg_drawTeamOverlay" )
;190:		);
;191:
;192:	s_preferences.allowdownload.curvalue =
ADDRGP4 $169
ARGP4
ADDRLP4 124
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 124
INDIRF4
CNSTF4 0
EQF4 $171
ADDRLP4 120
CNSTI4 1
ASGNI4
ADDRGP4 $172
JUMPV
LABELV $171
ADDRLP4 120
CNSTI4 0
ASGNI4
LABELV $172
ADDRGP4 s_preferences+1304+60
ADDRLP4 120
INDIRI4
ASGNI4
line 195
;193:		trap_Cvar_VariableValue( "cl_allowDownload" ) != 0;
;194:
;195:	s_preferences.gore.curvalue =
ADDRGP4 $175
ARGP4
ADDRLP4 132
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 132
INDIRF4
CNSTF4 0
EQF4 $178
ADDRGP4 $176
ARGP4
ADDRLP4 136
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 136
INDIRF4
CNSTF4 0
EQF4 $178
ADDRLP4 128
CNSTI4 1
ASGNI4
ADDRGP4 $179
JUMPV
LABELV $178
ADDRLP4 128
CNSTI4 0
ASGNI4
LABELV $179
ADDRGP4 s_preferences+1368+60
ADDRLP4 128
INDIRI4
ASGNI4
line 199
;196:		trap_Cvar_VariableValue( "com_blood" ) != 0 &&
;197:		trap_Cvar_VariableValue( "cg_gibs" ) != 0;
;198:	
;199:	switch( (int)trap_Cvar_VariableValue( "g_playerHealth" ) ) {
ADDRGP4 $182
ARGP4
ADDRLP4 144
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 140
ADDRLP4 144
INDIRF4
CVFI4 4
ASGNI4
ADDRLP4 152
CNSTI4 100
ASGNI4
ADDRLP4 140
INDIRI4
ADDRLP4 152
INDIRI4
EQI4 $196
ADDRLP4 140
INDIRI4
ADDRLP4 152
INDIRI4
GTI4 $200
LABELV $199
ADDRLP4 160
CNSTI4 50
ASGNI4
ADDRLP4 140
INDIRI4
ADDRLP4 160
INDIRI4
EQI4 $184
ADDRLP4 140
INDIRI4
ADDRLP4 160
INDIRI4
LTI4 $180
LABELV $201
ADDRLP4 140
INDIRI4
CNSTI4 75
EQI4 $187
ADDRGP4 $180
JUMPV
LABELV $200
ADDRLP4 168
CNSTI4 125
ASGNI4
ADDRLP4 140
INDIRI4
ADDRLP4 168
INDIRI4
EQI4 $190
ADDRLP4 140
INDIRI4
ADDRLP4 168
INDIRI4
LTI4 $180
LABELV $202
ADDRLP4 140
INDIRI4
CNSTI4 150
EQI4 $193
ADDRGP4 $180
JUMPV
LABELV $184
line 201
;200:	case 50:
;201:		s_preferences.playerHealth.curvalue = 0;
ADDRGP4 s_preferences+1560+64
CNSTI4 0
ASGNI4
line 202
;202:		break;
ADDRGP4 $181
JUMPV
LABELV $187
line 205
;203:
;204:	case 75:
;205:		s_preferences.playerHealth.curvalue = 1;
ADDRGP4 s_preferences+1560+64
CNSTI4 1
ASGNI4
line 206
;206:		break;
ADDRGP4 $181
JUMPV
LABELV $190
line 209
;207:
;208:	case 125:
;209:		s_preferences.playerHealth.curvalue = 3;
ADDRGP4 s_preferences+1560+64
CNSTI4 3
ASGNI4
line 210
;210:		break;
ADDRGP4 $181
JUMPV
LABELV $193
line 213
;211:
;212:	case 150:
;213:		s_preferences.playerHealth.curvalue = 4;
ADDRGP4 s_preferences+1560+64
CNSTI4 4
ASGNI4
line 214
;214:		break;
ADDRGP4 $181
JUMPV
LABELV $196
LABELV $180
line 218
;215:
;216:	case 100:
;217:	default:
;218:		s_preferences.playerHealth.curvalue = 2;
ADDRGP4 s_preferences+1560+64
CNSTI4 2
ASGNI4
line 219
;219:		break;
LABELV $181
line 222
;220:	}
;221:	
;222:	moveSpeed =
ADDRGP4 $203
ARGP4
ADDRLP4 172
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 172
INDIRF4
CVFI4 4
ASGNI4
line 225
;223:			(int)trap_Cvar_VariableValue( "g_speed" );
;224:
;225:		switch( moveSpeed ) {
ADDRLP4 176
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 180
CNSTI4 320
ASGNI4
ADDRLP4 176
INDIRI4
ADDRLP4 180
INDIRI4
EQI4 $218
ADDRLP4 176
INDIRI4
ADDRLP4 180
INDIRI4
GTI4 $222
LABELV $221
ADDRLP4 184
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 188
CNSTI4 240
ASGNI4
ADDRLP4 184
INDIRI4
ADDRLP4 188
INDIRI4
EQI4 $206
ADDRLP4 184
INDIRI4
ADDRLP4 188
INDIRI4
LTI4 $204
LABELV $223
ADDRLP4 0
INDIRI4
CNSTI4 288
EQI4 $209
ADDRGP4 $204
JUMPV
LABELV $222
ADDRLP4 192
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 196
CNSTI4 352
ASGNI4
ADDRLP4 192
INDIRI4
ADDRLP4 196
INDIRI4
EQI4 $212
ADDRLP4 192
INDIRI4
ADDRLP4 196
INDIRI4
LTI4 $204
LABELV $224
ADDRLP4 0
INDIRI4
CNSTI4 400
EQI4 $215
ADDRGP4 $204
JUMPV
LABELV $206
line 227
;226:		case 240:
;227:			s_preferences.moveSpeed.curvalue = 0;
ADDRGP4 s_preferences+1656+64
CNSTI4 0
ASGNI4
line 228
;228:			break;
ADDRGP4 $205
JUMPV
LABELV $209
line 231
;229:
;230:		case 288:
;231:			s_preferences.moveSpeed.curvalue = 1;
ADDRGP4 s_preferences+1656+64
CNSTI4 1
ASGNI4
line 232
;232:			break;
ADDRGP4 $205
JUMPV
LABELV $212
line 235
;233:
;234:		case 352:
;235:			s_preferences.moveSpeed.curvalue = 3;
ADDRGP4 s_preferences+1656+64
CNSTI4 3
ASGNI4
line 236
;236:			break;
ADDRGP4 $205
JUMPV
LABELV $215
line 239
;237:
;238:		case 400:
;239:			s_preferences.moveSpeed.curvalue = 4;
ADDRGP4 s_preferences+1656+64
CNSTI4 4
ASGNI4
line 240
;240:			break;
ADDRGP4 $205
JUMPV
LABELV $218
LABELV $204
line 244
;241:
;242:		case 320:
;243:		default:
;244:			s_preferences.moveSpeed.curvalue = 2;
ADDRGP4 s_preferences+1656+64
CNSTI4 2
ASGNI4
line 245
;245:			break;
LABELV $205
line 247
;246:		}		
;247:}
LABELV $82
endproc Preferences_SetMenuItems 200 12
proc Preferences_Event 20 8
line 249
;248:
;249:static void Preferences_Event( void* ptr, int notification ) {
line 250
;250:	if( notification != QM_ACTIVATED ) {
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $226
line 251
;251:		return;
ADDRGP4 $225
JUMPV
LABELV $226
line 254
;252:	}
;253:
;254:	switch( ((menucommon_s*)ptr)->id ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 127
LTI4 $228
ADDRLP4 0
INDIRI4
CNSTI4 146
GTI4 $228
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $310-508
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $310
address $231
address $242
address $245
address $251
address $256
address $259
address $262
address $265
address $268
address $271
address $274
address $309
address $280
address $285
address $288
address $294
address $300
address $291
address $303
address $306
code
LABELV $231
line 256
;255:	case ID_CROSSHAIR:
;256:		s_preferences.crosshair.curvalue++;
ADDRLP4 8
ADDRGP4 s_preferences+536+64
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 257
;257:		if( s_preferences.crosshair.curvalue == NUM_CROSSHAIRS ) {
ADDRGP4 s_preferences+536+64
INDIRI4
CNSTI4 10
NEI4 $234
line 258
;258:			s_preferences.crosshair.curvalue = 0;
ADDRGP4 s_preferences+536+64
CNSTI4 0
ASGNI4
line 259
;259:		}
LABELV $234
line 260
;260:		trap_Cvar_SetValue( "cg_drawCrosshair", s_preferences.crosshair.curvalue );
ADDRGP4 $115
ARGP4
ADDRGP4 s_preferences+536+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 261
;261:		break;
ADDRGP4 $229
JUMPV
LABELV $242
line 264
;262:
;263:	case ID_SIMPLEITEMS:
;264:		trap_Cvar_SetValue( "cg_simpleItems", s_preferences.simpleitems.curvalue );
ADDRGP4 $118
ARGP4
ADDRGP4 s_preferences+696+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 265
;265:		break;
ADDRGP4 $229
JUMPV
LABELV $245
line 268
;266:
;267:	case ID_HIGHQUALITYSKY:
;268:		trap_Cvar_SetValue( "r_fastsky", !s_preferences.highqualitysky.curvalue );
ADDRGP4 $148
ARGP4
ADDRGP4 s_preferences+1016+60
INDIRI4
CNSTI4 0
NEI4 $249
ADDRLP4 12
CNSTI4 1
ASGNI4
ADDRGP4 $250
JUMPV
LABELV $249
ADDRLP4 12
CNSTI4 0
ASGNI4
LABELV $250
ADDRLP4 12
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 269
;269:		break;
ADDRGP4 $229
JUMPV
LABELV $251
line 272
;270:
;271:	case ID_EJECTINGBRASS:
;272:		if ( s_preferences.brass.curvalue )
ADDRGP4 s_preferences+760+60
INDIRI4
CNSTI4 0
EQI4 $252
line 273
;273:			trap_Cvar_Reset( "cg_brassTime" );
ADDRGP4 $124
ARGP4
ADDRGP4 trap_Cvar_Reset
CALLV
pop
ADDRGP4 $229
JUMPV
LABELV $252
line 275
;274:		else
;275:			trap_Cvar_SetValue( "cg_brassTime", 0 );
ADDRGP4 $124
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 276
;276:		break;
ADDRGP4 $229
JUMPV
LABELV $256
line 279
;277:
;278:	case ID_WALLMARKS:
;279:		trap_Cvar_SetValue( "cg_marks", s_preferences.wallmarks.curvalue );
ADDRGP4 $130
ARGP4
ADDRGP4 s_preferences+824+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 280
;280:		break;
ADDRGP4 $229
JUMPV
LABELV $259
line 283
;281:
;282:	case ID_DYNAMICLIGHTS:
;283:		trap_Cvar_SetValue( "r_dynamiclight", s_preferences.dynamiclights.curvalue );
ADDRGP4 $142
ARGP4
ADDRGP4 s_preferences+888+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 284
;284:		break;		
ADDRGP4 $229
JUMPV
LABELV $262
line 287
;285:
;286:	case ID_IDENTIFYTARGET:
;287:		trap_Cvar_SetValue( "cg_drawCrosshairNames", s_preferences.identifytarget.curvalue );
ADDRGP4 $136
ARGP4
ADDRGP4 s_preferences+952+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 288
;288:		break;
ADDRGP4 $229
JUMPV
LABELV $265
line 291
;289:
;290:	case ID_SYNCEVERYFRAME:
;291:		trap_Cvar_SetValue( "r_finish", s_preferences.synceveryframe.curvalue );
ADDRGP4 $154
ARGP4
ADDRGP4 s_preferences+1080+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 292
;292:		break;
ADDRGP4 $229
JUMPV
LABELV $268
line 295
;293:
;294:	case ID_FORCEMODEL:
;295:		trap_Cvar_SetValue( "cg_forcemodel", s_preferences.forcemodel.curvalue );
ADDRGP4 $160
ARGP4
ADDRGP4 s_preferences+1144+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 296
;296:		break;
ADDRGP4 $229
JUMPV
LABELV $271
line 299
;297:
;298:	case ID_DRAWTEAMOVERLAY:
;299:		trap_Cvar_SetValue( "cg_drawTeamOverlay", s_preferences.drawteamoverlay.curvalue );
ADDRGP4 $166
ARGP4
ADDRGP4 s_preferences+1208+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 300
;300:		break;
ADDRGP4 $229
JUMPV
LABELV $274
line 303
;301:
;302:	case ID_ALLOWDOWNLOAD:
;303:		trap_Cvar_SetValue( "cl_allowDownload", s_preferences.allowdownload.curvalue );
ADDRGP4 $169
ARGP4
ADDRGP4 s_preferences+1304+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 304
;304:		trap_Cvar_SetValue( "sv_allowDownload", s_preferences.allowdownload.curvalue );
ADDRGP4 $277
ARGP4
ADDRGP4 s_preferences+1304+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 305
;305:		break;
ADDRGP4 $229
JUMPV
LABELV $280
line 308
;306:
;307:	case ID_GORE:
;308:		trap_Cvar_SetValue(
ADDRGP4 $175
ARGP4
ADDRGP4 s_preferences+1368+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 312
;309:			"com_blood",
;310:			s_preferences.gore.curvalue
;311:		);
;312:		trap_Cvar_SetValue(
ADDRGP4 $176
ARGP4
ADDRGP4 s_preferences+1368+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 316
;313:			"cg_gibs",
;314:			s_preferences.gore.curvalue
;315:		);
;316:		break;
ADDRGP4 $229
JUMPV
LABELV $285
line 319
;317:
;318:	case ID_CLEANVIEW:
;319:			trap_Cvar_SetValue(
ADDRGP4 $109
ARGP4
ADDRGP4 s_preferences+1432+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 323
;320:				"cg_cleanView",
;321:				s_preferences.cleanView.curvalue
;322:			);
;323:			break;
ADDRGP4 $229
JUMPV
LABELV $288
line 326
;324:
;325:	case ID_RAILTRAIL:
;326:			trap_Cvar_SetValue(
ADDRGP4 $103
ARGP4
ADDRGP4 s_preferences+1496+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 330
;327:				"cg_drawRailTrail",
;328:				s_preferences.railTrail.curvalue
;329:			);
;330:			break;
ADDRGP4 $229
JUMPV
LABELV $291
line 333
;331:
;332:	case ID_PLAYERHEALTH:
;333:		trap_Cvar_SetValue(
ADDRGP4 $182
ARGP4
CNSTI4 25
ADDRGP4 s_preferences+1560+64
INDIRI4
MULI4
CNSTI4 50
ADDI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 337
;334:			"g_playerHealth",
;335:			50 + s_preferences.playerHealth.curvalue * 25
;336:		);
;337:		break;
ADDRGP4 $229
JUMPV
LABELV $294
line 340
;338:
;339:	case ID_MOVESPEED:
;340:			trap_Cvar_SetValue(
ADDRGP4 $203
ARGP4
ADDRGP4 s_preferences+1656+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 moveSpeed_values
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 347
;341:				"g_speed",
;342:				moveSpeed_values[
;343:					s_preferences.moveSpeed.curvalue
;344:				]
;345:			);
;346:
;347:			trap_Cmd_ExecuteText(
ADDRGP4 $297
ARGP4
ADDRGP4 s_preferences+1656+64
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 moveSpeed_values
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 2
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
line 356
;348:				EXEC_APPEND,
;349:				va(
;350:					"seta g_speed \"%i\"\n",
;351:					moveSpeed_values[
;352:						s_preferences.moveSpeed.curvalue
;353:					]
;354:				)
;355:			);
;356:			break;
ADDRGP4 $229
JUMPV
LABELV $300
line 359
;357:
;358:	case ID_STATICITEMS:
;359:			trap_Cvar_SetValue(
ADDRGP4 $97
ARGP4
ADDRGP4 s_preferences+1752+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 363
;360:				"cg_staticItems",
;361:				s_preferences.staticitems.curvalue
;362:			);
;363:			break;
ADDRGP4 $229
JUMPV
LABELV $303
line 366
;364:
;365:	case ID_RANDOMSTARTWEAPON:
;366:		trap_Cvar_SetValue(
ADDRGP4 $91
ARGP4
ADDRGP4 s_preferences+1816+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 370
;367:			"g_randomStartWeapon",
;368:			s_preferences.randomStartWeapon.curvalue
;369:		);
;370:		break;
ADDRGP4 $229
JUMPV
LABELV $306
line 373
;371:		
;372:	case ID_SCAVENGERWEAPONS:
;373:		trap_Cvar_SetValue(
ADDRGP4 $85
ARGP4
ADDRGP4 s_preferences+632+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
line 377
;374:			"g_scavengerWeapons",
;375:			s_preferences.scavengerWeapons.curvalue
;376:		);
;377:		break;	
ADDRGP4 $229
JUMPV
LABELV $309
line 380
;378:
;379:	case ID_BACK:
;380:		UI_PopMenu();
ADDRGP4 UI_PopMenu
CALLV
pop
line 381
;381:		break;
LABELV $228
LABELV $229
line 383
;382:	}
;383:}
LABELV $225
endproc Preferences_Event 20 8
proc Crosshair_Draw 48 20
line 391
;384:
;385:
;386:/*
;387:=================
;388:Crosshair_Draw
;389:=================
;390:*/
;391:static void Crosshair_Draw( void *self ) {
line 398
;392:	menulist_s	*s;
;393:	float		*color;
;394:	int			x, y;
;395:	int			style;
;396:	qboolean	focus;
;397:
;398:	s = (menulist_s *)self;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
line 399
;399:	x = s->generic.x;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 400
;400:	y =	s->generic.y;
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
line 402
;401:
;402:	style = UI_SMALLFONT;
ADDRLP4 20
CNSTI4 16
ASGNI4
line 403
;403:	focus = (s->generic.parent->cursor == s->generic.menuPosition);
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
NEI4 $314
ADDRLP4 24
CNSTI4 1
ASGNI4
ADDRGP4 $315
JUMPV
LABELV $314
ADDRLP4 24
CNSTI4 0
ASGNI4
LABELV $315
ADDRLP4 16
ADDRLP4 24
INDIRI4
ASGNI4
line 405
;404:
;405:	if ( s->generic.flags & QMF_GRAYED )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $316
line 406
;406:		color = text_color_disabled;
ADDRLP4 12
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $317
JUMPV
LABELV $316
line 407
;407:	else if ( focus )
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $318
line 408
;408:	{
line 409
;409:		color = text_color_highlight;
ADDRLP4 12
ADDRGP4 text_color_highlight
ASGNP4
line 410
;410:		style |= UI_PULSE;
ADDRLP4 20
ADDRLP4 20
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
line 411
;411:	}
ADDRGP4 $319
JUMPV
LABELV $318
line 412
;412:	else if ( s->generic.flags & QMF_BLINK )
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $320
line 413
;413:	{
line 414
;414:		color = text_color_highlight;
ADDRLP4 12
ADDRGP4 text_color_highlight
ASGNP4
line 415
;415:		style |= UI_BLINK;
ADDRLP4 20
ADDRLP4 20
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 416
;416:	}
ADDRGP4 $321
JUMPV
LABELV $320
line 418
;417:	else
;418:		color = text_color_normal;
ADDRLP4 12
ADDRGP4 text_color_normal
ASGNP4
LABELV $321
LABELV $319
LABELV $317
line 420
;419:
;420:	if ( focus )
ADDRLP4 16
INDIRI4
CNSTI4 0
EQI4 $322
line 421
;421:	{
line 423
;422:		// draw cursor
;423:		UI_FillRect( s->generic.left, s->generic.top, s->generic.right-s->generic.left+1, s->generic.bottom-s->generic.top+1, listbar_color ); 
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
line 424
;424:		UI_DrawChar( x, y, 13, UI_CENTER|UI_BLINK|UI_SMALLFONT, color);
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
CNSTI4 13
ARGI4
CNSTI4 4113
ARGI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 UI_DrawChar
CALLV
pop
line 425
;425:	}
LABELV $322
line 427
;426:
;427:	UI_DrawString( x - SMALLCHAR_WIDTH, y, s->generic.name, style|UI_RIGHT, color );
ADDRLP4 4
INDIRI4
CNSTI4 8
SUBI4
ARGI4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
ADDRLP4 20
INDIRI4
CNSTI4 2
BORI4
ARGI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
line 428
;428:	if( !s->curvalue ) {
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 0
NEI4 $324
line 429
;429:		return;
ADDRGP4 $312
JUMPV
LABELV $324
line 431
;430:	}
;431:	UI_DrawHandlePic( x + SMALLCHAR_WIDTH, y - 4, 24, 24, s_preferences.crosshairShader[s->curvalue] );
ADDRLP4 4
INDIRI4
CNSTI4 8
ADDI4
CVIF4 4
ARGF4
ADDRLP4 8
INDIRI4
CNSTI4 4
SUBI4
CVIF4 4
ARGF4
ADDRLP4 32
CNSTF4 1103101952
ASGNF4
ADDRLP4 32
INDIRF4
ARGF4
ADDRLP4 32
INDIRF4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_preferences+1968
ADDP4
INDIRI4
ARGI4
ADDRGP4 UI_DrawHandlePic
CALLV
pop
line 432
;432:}
LABELV $312
endproc Crosshair_Draw 48 20
proc Preferences_MenuInit 8 12
line 435
;433:
;434:
;435:static void Preferences_MenuInit( void ) {
line 438
;436:	int				y;
;437:
;438:	memset( &s_preferences, 0 ,sizeof(preferences_t) );
ADDRGP4 s_preferences
ARGP4
CNSTI4 0
ARGI4
CNSTI4 2008
ARGI4
ADDRGP4 memset
CALLP4
pop
line 440
;439:
;440:	Preferences_Cache();
ADDRGP4 Preferences_Cache
CALLV
pop
line 442
;441:
;442:	s_preferences.menu.wrapAround = qtrue;
ADDRGP4 s_preferences+276
CNSTI4 1
ASGNI4
line 443
;443:	s_preferences.menu.fullscreen = qtrue;
ADDRGP4 s_preferences+280
CNSTI4 1
ASGNI4
line 445
;444:
;445:	s_preferences.banner.generic.type  = MTYPE_BTEXT;
ADDRGP4 s_preferences+288
CNSTI4 10
ASGNI4
line 446
;446:	s_preferences.banner.generic.x	   = 320;
ADDRGP4 s_preferences+288+12
CNSTI4 320
ASGNI4
line 447
;447:	s_preferences.banner.generic.y	   = 16;
ADDRGP4 s_preferences+288+16
CNSTI4 16
ASGNI4
line 448
;448:	s_preferences.banner.string		   = "GAME OPTIONS";
ADDRGP4 s_preferences+288+60
ADDRGP4 $337
ASGNP4
line 449
;449:	s_preferences.banner.color         = color_white;
ADDRGP4 s_preferences+288+68
ADDRGP4 color_white
ASGNP4
line 450
;450:	s_preferences.banner.style         = UI_CENTER;
ADDRGP4 s_preferences+288+64
CNSTI4 1
ASGNI4
line 452
;451:
;452:	s_preferences.framel.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_preferences+360
CNSTI4 6
ASGNI4
line 453
;453:	s_preferences.framel.generic.name  = ART_FRAMEL;
ADDRGP4 s_preferences+360+4
ADDRGP4 $345
ASGNP4
line 454
;454:	s_preferences.framel.generic.flags = QMF_INACTIVE;
ADDRGP4 s_preferences+360+44
CNSTU4 16384
ASGNU4
line 455
;455:	s_preferences.framel.generic.x	   = 0;
ADDRGP4 s_preferences+360+12
CNSTI4 0
ASGNI4
line 456
;456:	s_preferences.framel.generic.y	   = 78;
ADDRGP4 s_preferences+360+16
CNSTI4 78
ASGNI4
line 457
;457:	s_preferences.framel.width  	   = 256;
ADDRGP4 s_preferences+360+76
CNSTI4 256
ASGNI4
line 458
;458:	s_preferences.framel.height  	   = 329;
ADDRGP4 s_preferences+360+80
CNSTI4 329
ASGNI4
line 460
;459:
;460:	s_preferences.framer.generic.type  = MTYPE_BITMAP;
ADDRGP4 s_preferences+448
CNSTI4 6
ASGNI4
line 461
;461:	s_preferences.framer.generic.name  = ART_FRAMER;
ADDRGP4 s_preferences+448+4
ADDRGP4 $359
ASGNP4
line 462
;462:	s_preferences.framer.generic.flags = QMF_INACTIVE;
ADDRGP4 s_preferences+448+44
CNSTU4 16384
ASGNU4
line 463
;463:	s_preferences.framer.generic.x	   = 376;
ADDRGP4 s_preferences+448+12
CNSTI4 376
ASGNI4
line 464
;464:	s_preferences.framer.generic.y	   = 76;
ADDRGP4 s_preferences+448+16
CNSTI4 76
ASGNI4
line 465
;465:	s_preferences.framer.width  	   = 256;
ADDRGP4 s_preferences+448+76
CNSTI4 256
ASGNI4
line 466
;466:	s_preferences.framer.height  	   = 334;
ADDRGP4 s_preferences+448+80
CNSTI4 334
ASGNI4
line 468
;467:
;468:	y = 100;
ADDRLP4 0
CNSTI4 100
ASGNI4
line 469
;469:	s_preferences.crosshair.generic.type		= MTYPE_TEXT;
ADDRGP4 s_preferences+536
CNSTI4 7
ASGNI4
line 470
;470:	s_preferences.crosshair.generic.flags		= QMF_PULSEIFFOCUS|QMF_SMALLFONT|QMF_NODEFAULTINIT|QMF_OWNERDRAW;
ADDRGP4 s_preferences+536+44
CNSTU4 98562
ASGNU4
line 471
;471:	s_preferences.crosshair.generic.x			= PREFERENCES_X_POS;
ADDRGP4 s_preferences+536+12
CNSTI4 360
ASGNI4
line 472
;472:	s_preferences.crosshair.generic.y			= y;
ADDRGP4 s_preferences+536+16
ADDRLP4 0
INDIRI4
ASGNI4
line 473
;473:	s_preferences.crosshair.generic.name		= "Crosshair:";
ADDRGP4 s_preferences+536+4
ADDRGP4 $379
ASGNP4
line 474
;474:	s_preferences.crosshair.generic.callback	= Preferences_Event;
ADDRGP4 s_preferences+536+48
ADDRGP4 Preferences_Event
ASGNP4
line 475
;475:	s_preferences.crosshair.generic.ownerdraw	= Crosshair_Draw;
ADDRGP4 s_preferences+536+56
ADDRGP4 Crosshair_Draw
ASGNP4
line 476
;476:	s_preferences.crosshair.generic.id			= ID_CROSSHAIR;
ADDRGP4 s_preferences+536+8
CNSTI4 127
ASGNI4
line 477
;477:	s_preferences.crosshair.generic.top			= y - 4;
ADDRGP4 s_preferences+536+24
ADDRLP4 0
INDIRI4
CNSTI4 4
SUBI4
ASGNI4
line 478
;478:	s_preferences.crosshair.generic.bottom		= y + 20;
ADDRGP4 s_preferences+536+32
ADDRLP4 0
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
line 479
;479:	s_preferences.crosshair.generic.left		= PREFERENCES_X_POS - ( ( strlen(s_preferences.crosshair.generic.name) + 1 ) * SMALLCHAR_WIDTH );
ADDRGP4 s_preferences+536+4
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRGP4 s_preferences+536+20
CNSTI4 360
ADDRLP4 4
INDIRI4
CNSTI4 3
LSHI4
CNSTI4 8
ADDI4
SUBI4
ASGNI4
line 480
;480:	s_preferences.crosshair.generic.right		= PREFERENCES_X_POS + 48;
ADDRGP4 s_preferences+536+28
CNSTI4 408
ASGNI4
line 482
;481:
;482:	y += BIGCHAR_HEIGHT+2+4;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 22
ADDI4
ASGNI4
line 483
;483:	s_preferences.simpleitems.generic.type        = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+696
CNSTI4 5
ASGNI4
line 484
;484:	s_preferences.simpleitems.generic.name	      = "Simple Items:";
ADDRGP4 s_preferences+696+4
ADDRGP4 $399
ASGNP4
line 485
;485:	s_preferences.simpleitems.generic.flags	      = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+696+44
CNSTU4 258
ASGNU4
line 486
;486:	s_preferences.simpleitems.generic.callback    = Preferences_Event;
ADDRGP4 s_preferences+696+48
ADDRGP4 Preferences_Event
ASGNP4
line 487
;487:	s_preferences.simpleitems.generic.id          = ID_SIMPLEITEMS;
ADDRGP4 s_preferences+696+8
CNSTI4 128
ASGNI4
line 488
;488:	s_preferences.simpleitems.generic.x	          = PREFERENCES_X_POS;
ADDRGP4 s_preferences+696+12
CNSTI4 360
ASGNI4
line 489
;489:	s_preferences.simpleitems.generic.y	          = y;
ADDRGP4 s_preferences+696+16
ADDRLP4 0
INDIRI4
ASGNI4
line 491
;490:
;491:	y += BIGCHAR_HEIGHT;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 16
ADDI4
ASGNI4
line 492
;492:	s_preferences.wallmarks.generic.type          = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+824
CNSTI4 5
ASGNI4
line 493
;493:	s_preferences.wallmarks.generic.name	      = "Marks on Walls:";
ADDRGP4 s_preferences+824+4
ADDRGP4 $413
ASGNP4
line 494
;494:	s_preferences.wallmarks.generic.flags	      = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+824+44
CNSTU4 258
ASGNU4
line 495
;495:	s_preferences.wallmarks.generic.callback      = Preferences_Event;
ADDRGP4 s_preferences+824+48
ADDRGP4 Preferences_Event
ASGNP4
line 496
;496:	s_preferences.wallmarks.generic.id            = ID_WALLMARKS;
ADDRGP4 s_preferences+824+8
CNSTI4 131
ASGNI4
line 497
;497:	s_preferences.wallmarks.generic.x	          = PREFERENCES_X_POS;
ADDRGP4 s_preferences+824+12
CNSTI4 360
ASGNI4
line 498
;498:	s_preferences.wallmarks.generic.y	          = y;
ADDRGP4 s_preferences+824+16
ADDRLP4 0
INDIRI4
ASGNI4
line 500
;499:
;500:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 501
;501:	s_preferences.brass.generic.type              = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+760
CNSTI4 5
ASGNI4
line 502
;502:	s_preferences.brass.generic.name	          = "Ejecting Brass:";
ADDRGP4 s_preferences+760+4
ADDRGP4 $427
ASGNP4
line 503
;503:	s_preferences.brass.generic.flags	          = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+760+44
CNSTU4 258
ASGNU4
line 504
;504:	s_preferences.brass.generic.callback          = Preferences_Event;
ADDRGP4 s_preferences+760+48
ADDRGP4 Preferences_Event
ASGNP4
line 505
;505:	s_preferences.brass.generic.id                = ID_EJECTINGBRASS;
ADDRGP4 s_preferences+760+8
CNSTI4 130
ASGNI4
line 506
;506:	s_preferences.brass.generic.x	              = PREFERENCES_X_POS;
ADDRGP4 s_preferences+760+12
CNSTI4 360
ASGNI4
line 507
;507:	s_preferences.brass.generic.y	              = y;
ADDRGP4 s_preferences+760+16
ADDRLP4 0
INDIRI4
ASGNI4
line 509
;508:
;509:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 510
;510:	s_preferences.dynamiclights.generic.type      = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+888
CNSTI4 5
ASGNI4
line 511
;511:	s_preferences.dynamiclights.generic.name	  = "Dynamic Lights:";
ADDRGP4 s_preferences+888+4
ADDRGP4 $441
ASGNP4
line 512
;512:	s_preferences.dynamiclights.generic.flags     = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+888+44
CNSTU4 258
ASGNU4
line 513
;513:	s_preferences.dynamiclights.generic.callback  = Preferences_Event;
ADDRGP4 s_preferences+888+48
ADDRGP4 Preferences_Event
ASGNP4
line 514
;514:	s_preferences.dynamiclights.generic.id        = ID_DYNAMICLIGHTS;
ADDRGP4 s_preferences+888+8
CNSTI4 132
ASGNI4
line 515
;515:	s_preferences.dynamiclights.generic.x	      = PREFERENCES_X_POS;
ADDRGP4 s_preferences+888+12
CNSTI4 360
ASGNI4
line 516
;516:	s_preferences.dynamiclights.generic.y	      = y;
ADDRGP4 s_preferences+888+16
ADDRLP4 0
INDIRI4
ASGNI4
line 518
;517:
;518:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 519
;519:	s_preferences.identifytarget.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+952
CNSTI4 5
ASGNI4
line 520
;520:	s_preferences.identifytarget.generic.name	  = "Identify Target:";
ADDRGP4 s_preferences+952+4
ADDRGP4 $455
ASGNP4
line 521
;521:	s_preferences.identifytarget.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+952+44
CNSTU4 258
ASGNU4
line 522
;522:	s_preferences.identifytarget.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+952+48
ADDRGP4 Preferences_Event
ASGNP4
line 523
;523:	s_preferences.identifytarget.generic.id       = ID_IDENTIFYTARGET;
ADDRGP4 s_preferences+952+8
CNSTI4 133
ASGNI4
line 524
;524:	s_preferences.identifytarget.generic.x	      = PREFERENCES_X_POS;
ADDRGP4 s_preferences+952+12
CNSTI4 360
ASGNI4
line 525
;525:	s_preferences.identifytarget.generic.y	      = y;
ADDRGP4 s_preferences+952+16
ADDRLP4 0
INDIRI4
ASGNI4
line 527
;526:
;527:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 528
;528:	s_preferences.highqualitysky.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1016
CNSTI4 5
ASGNI4
line 529
;529:	s_preferences.highqualitysky.generic.name	  = "High Quality Sky:";
ADDRGP4 s_preferences+1016+4
ADDRGP4 $469
ASGNP4
line 530
;530:	s_preferences.highqualitysky.generic.flags	  = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1016+44
CNSTU4 258
ASGNU4
line 531
;531:	s_preferences.highqualitysky.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1016+48
ADDRGP4 Preferences_Event
ASGNP4
line 532
;532:	s_preferences.highqualitysky.generic.id       = ID_HIGHQUALITYSKY;
ADDRGP4 s_preferences+1016+8
CNSTI4 129
ASGNI4
line 533
;533:	s_preferences.highqualitysky.generic.x	      = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1016+12
CNSTI4 360
ASGNI4
line 534
;534:	s_preferences.highqualitysky.generic.y	      = y;
ADDRGP4 s_preferences+1016+16
ADDRLP4 0
INDIRI4
ASGNI4
line 536
;535:
;536:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 537
;537:	s_preferences.synceveryframe.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1080
CNSTI4 5
ASGNI4
line 538
;538:	s_preferences.synceveryframe.generic.name	  = "Sync Every Frame:";
ADDRGP4 s_preferences+1080+4
ADDRGP4 $483
ASGNP4
line 539
;539:	s_preferences.synceveryframe.generic.flags	  = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1080+44
CNSTU4 258
ASGNU4
line 540
;540:	s_preferences.synceveryframe.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1080+48
ADDRGP4 Preferences_Event
ASGNP4
line 541
;541:	s_preferences.synceveryframe.generic.id       = ID_SYNCEVERYFRAME;
ADDRGP4 s_preferences+1080+8
CNSTI4 134
ASGNI4
line 542
;542:	s_preferences.synceveryframe.generic.x	      = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1080+12
CNSTI4 360
ASGNI4
line 543
;543:	s_preferences.synceveryframe.generic.y	      = y;
ADDRGP4 s_preferences+1080+16
ADDRLP4 0
INDIRI4
ASGNI4
line 545
;544:
;545:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 546
;546:	s_preferences.forcemodel.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1144
CNSTI4 5
ASGNI4
line 547
;547:	s_preferences.forcemodel.generic.name	  = "Force Player Models:";
ADDRGP4 s_preferences+1144+4
ADDRGP4 $497
ASGNP4
line 548
;548:	s_preferences.forcemodel.generic.flags	  = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1144+44
CNSTU4 258
ASGNU4
line 549
;549:	s_preferences.forcemodel.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1144+48
ADDRGP4 Preferences_Event
ASGNP4
line 550
;550:	s_preferences.forcemodel.generic.id       = ID_FORCEMODEL;
ADDRGP4 s_preferences+1144+8
CNSTI4 135
ASGNI4
line 551
;551:	s_preferences.forcemodel.generic.x	      = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1144+12
CNSTI4 360
ASGNI4
line 552
;552:	s_preferences.forcemodel.generic.y	      = y;
ADDRGP4 s_preferences+1144+16
ADDRLP4 0
INDIRI4
ASGNI4
line 554
;553:
;554:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 555
;555:	s_preferences.drawteamoverlay.generic.type     = MTYPE_SPINCONTROL;
ADDRGP4 s_preferences+1208
CNSTI4 3
ASGNI4
line 556
;556:	s_preferences.drawteamoverlay.generic.name	   = "Draw Team Overlay:";
ADDRGP4 s_preferences+1208+4
ADDRGP4 $511
ASGNP4
line 557
;557:	s_preferences.drawteamoverlay.generic.flags	   = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1208+44
CNSTU4 258
ASGNU4
line 558
;558:	s_preferences.drawteamoverlay.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1208+48
ADDRGP4 Preferences_Event
ASGNP4
line 559
;559:	s_preferences.drawteamoverlay.generic.id       = ID_DRAWTEAMOVERLAY;
ADDRGP4 s_preferences+1208+8
CNSTI4 136
ASGNI4
line 560
;560:	s_preferences.drawteamoverlay.generic.x	       = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1208+12
CNSTI4 360
ASGNI4
line 561
;561:	s_preferences.drawteamoverlay.generic.y	       = y;
ADDRGP4 s_preferences+1208+16
ADDRLP4 0
INDIRI4
ASGNI4
line 562
;562:	s_preferences.drawteamoverlay.itemnames			= teamoverlay_names;
ADDRGP4 s_preferences+1208+76
ADDRGP4 teamoverlay_names
ASGNP4
line 564
;563:
;564:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 565
;565:	s_preferences.allowdownload.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1304
CNSTI4 5
ASGNI4
line 566
;566:	s_preferences.allowdownload.generic.name	   = "Automatic Downloading:";
ADDRGP4 s_preferences+1304+4
ADDRGP4 $527
ASGNP4
line 567
;567:	s_preferences.allowdownload.generic.flags	   = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1304+44
CNSTU4 258
ASGNU4
line 568
;568:	s_preferences.allowdownload.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1304+48
ADDRGP4 Preferences_Event
ASGNP4
line 569
;569:	s_preferences.allowdownload.generic.id       = ID_ALLOWDOWNLOAD;
ADDRGP4 s_preferences+1304+8
CNSTI4 137
ASGNI4
line 570
;570:	s_preferences.allowdownload.generic.x	       = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1304+12
CNSTI4 360
ASGNI4
line 571
;571:	s_preferences.allowdownload.generic.y	       = y;
ADDRGP4 s_preferences+1304+16
ADDRLP4 0
INDIRI4
ASGNI4
line 573
;572:
;573:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 574
;574:	s_preferences.gore.generic.type       = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1368
CNSTI4 5
ASGNI4
line 575
;575:	s_preferences.gore.generic.name       = "Blood and Gibs:";
ADDRGP4 s_preferences+1368+4
ADDRGP4 $541
ASGNP4
line 576
;576:	s_preferences.gore.generic.flags      = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1368+44
CNSTU4 258
ASGNU4
line 577
;577:	s_preferences.gore.generic.callback   = Preferences_Event;
ADDRGP4 s_preferences+1368+48
ADDRGP4 Preferences_Event
ASGNP4
line 578
;578:	s_preferences.gore.generic.id         = ID_GORE;
ADDRGP4 s_preferences+1368+8
CNSTI4 139
ASGNI4
line 579
;579:	s_preferences.gore.generic.x          = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1368+12
CNSTI4 360
ASGNI4
line 580
;580:	s_preferences.gore.generic.y          = y;
ADDRGP4 s_preferences+1368+16
ADDRLP4 0
INDIRI4
ASGNI4
line 582
;581:
;582:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 583
;583:	s_preferences.cleanView.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1432
CNSTI4 5
ASGNI4
line 584
;584:	s_preferences.cleanView.generic.name     = "Clean View:";
ADDRGP4 s_preferences+1432+4
ADDRGP4 $555
ASGNP4
line 585
;585:	s_preferences.cleanView.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1432+44
CNSTU4 258
ASGNU4
line 586
;586:	s_preferences.cleanView.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1432+48
ADDRGP4 Preferences_Event
ASGNP4
line 587
;587:	s_preferences.cleanView.generic.id       = ID_CLEANVIEW;
ADDRGP4 s_preferences+1432+8
CNSTI4 140
ASGNI4
line 588
;588:	s_preferences.cleanView.generic.x        = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1432+12
CNSTI4 360
ASGNI4
line 589
;589:	s_preferences.cleanView.generic.y        = y;
ADDRGP4 s_preferences+1432+16
ADDRLP4 0
INDIRI4
ASGNI4
line 591
;590:	
;591:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 592
;592:	s_preferences.railTrail.generic.type     = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1496
CNSTI4 5
ASGNI4
line 593
;593:	s_preferences.railTrail.generic.name     = "Rail Trail:";
ADDRGP4 s_preferences+1496+4
ADDRGP4 $569
ASGNP4
line 594
;594:	s_preferences.railTrail.generic.flags    = QMF_PULSEIFFOCUS|QMF_SMALLFONT;
ADDRGP4 s_preferences+1496+44
CNSTU4 258
ASGNU4
line 595
;595:	s_preferences.railTrail.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1496+48
ADDRGP4 Preferences_Event
ASGNP4
line 596
;596:	s_preferences.railTrail.generic.id       = ID_RAILTRAIL;
ADDRGP4 s_preferences+1496+8
CNSTI4 141
ASGNI4
line 597
;597:	s_preferences.railTrail.generic.x        = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1496+12
CNSTI4 360
ASGNI4
line 598
;598:	s_preferences.railTrail.generic.y        = y;
ADDRGP4 s_preferences+1496+16
ADDRLP4 0
INDIRI4
ASGNI4
line 600
;599:	
;600:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 601
;601:	s_preferences.playerHealth.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_preferences+1560
CNSTI4 3
ASGNI4
line 602
;602:	s_preferences.playerHealth.generic.name = "Player Health:";
ADDRGP4 s_preferences+1560+4
ADDRGP4 $583
ASGNP4
line 603
;603:	s_preferences.playerHealth.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_preferences+1560+44
CNSTU4 258
ASGNU4
line 604
;604:	s_preferences.playerHealth.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1560+48
ADDRGP4 Preferences_Event
ASGNP4
line 605
;605:	s_preferences.playerHealth.generic.id = ID_PLAYERHEALTH;
ADDRGP4 s_preferences+1560+8
CNSTI4 144
ASGNI4
line 606
;606:	s_preferences.playerHealth.generic.x = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1560+12
CNSTI4 360
ASGNI4
line 607
;607:	s_preferences.playerHealth.generic.y = y;
ADDRGP4 s_preferences+1560+16
ADDRLP4 0
INDIRI4
ASGNI4
line 608
;608:	s_preferences.playerHealth.itemnames = playerHealth_items;
ADDRGP4 s_preferences+1560+76
ADDRGP4 playerHealth_items
ASGNP4
line 610
;609:	
;610:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 611
;611:	s_preferences.moveSpeed.generic.type = MTYPE_SPINCONTROL;
ADDRGP4 s_preferences+1656
CNSTI4 3
ASGNI4
line 612
;612:	s_preferences.moveSpeed.generic.name = "Move Speed:";
ADDRGP4 s_preferences+1656+4
ADDRGP4 $599
ASGNP4
line 613
;613:	s_preferences.moveSpeed.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_preferences+1656+44
CNSTU4 258
ASGNU4
line 614
;614:	s_preferences.moveSpeed.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1656+48
ADDRGP4 Preferences_Event
ASGNP4
line 615
;615:	s_preferences.moveSpeed.generic.id =ID_MOVESPEED;
ADDRGP4 s_preferences+1656+8
CNSTI4 142
ASGNI4
line 616
;616:	s_preferences.moveSpeed.generic.x = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1656+12
CNSTI4 360
ASGNI4
line 617
;617:	s_preferences.moveSpeed.generic.y = y;
ADDRGP4 s_preferences+1656+16
ADDRLP4 0
INDIRI4
ASGNI4
line 618
;618:	s_preferences.moveSpeed.itemnames = moveSpeed_names;
ADDRGP4 s_preferences+1656+76
ADDRGP4 moveSpeed_names
ASGNP4
line 620
;619:	
;620:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 621
;621:	s_preferences.staticitems.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1752
CNSTI4 5
ASGNI4
line 622
;622:	s_preferences.staticitems.generic.name = "Static Items:";
ADDRGP4 s_preferences+1752+4
ADDRGP4 $615
ASGNP4
line 623
;623:	s_preferences.staticitems.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_preferences+1752+44
CNSTU4 258
ASGNU4
line 624
;624:	s_preferences.staticitems.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1752+48
ADDRGP4 Preferences_Event
ASGNP4
line 625
;625:	s_preferences.staticitems.generic.id = ID_STATICITEMS;
ADDRGP4 s_preferences+1752+8
CNSTI4 143
ASGNI4
line 626
;626:	s_preferences.staticitems.generic.x = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1752+12
CNSTI4 360
ASGNI4
line 627
;627:	s_preferences.staticitems.generic.y = y;
ADDRGP4 s_preferences+1752+16
ADDRLP4 0
INDIRI4
ASGNI4
line 629
;628:
;629:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 631
;630:
;631:	s_preferences.randomStartWeapon.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+1816
CNSTI4 5
ASGNI4
line 632
;632:	s_preferences.randomStartWeapon.generic.name = "Random Start Weapon:";
ADDRGP4 s_preferences+1816+4
ADDRGP4 $629
ASGNP4
line 633
;633:	s_preferences.randomStartWeapon.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_preferences+1816+44
CNSTU4 258
ASGNU4
line 634
;634:	s_preferences.randomStartWeapon.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1816+48
ADDRGP4 Preferences_Event
ASGNP4
line 635
;635:	s_preferences.randomStartWeapon.generic.id = ID_RANDOMSTARTWEAPON;
ADDRGP4 s_preferences+1816+8
CNSTI4 145
ASGNI4
line 636
;636:	s_preferences.randomStartWeapon.generic.x = PREFERENCES_X_POS;
ADDRGP4 s_preferences+1816+12
CNSTI4 360
ASGNI4
line 637
;637:	s_preferences.randomStartWeapon.generic.y = y;
ADDRGP4 s_preferences+1816+16
ADDRLP4 0
INDIRI4
ASGNI4
line 639
;638:	
;639:	y += BIGCHAR_HEIGHT + 2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 641
;640:
;641:	s_preferences.scavengerWeapons.generic.type = MTYPE_RADIOBUTTON;
ADDRGP4 s_preferences+632
CNSTI4 5
ASGNI4
line 642
;642:	s_preferences.scavengerWeapons.generic.name = "Scavenger Weapons:";
ADDRGP4 s_preferences+632+4
ADDRGP4 $643
ASGNP4
line 643
;643:	s_preferences.scavengerWeapons.generic.flags = QMF_PULSEIFFOCUS | QMF_SMALLFONT;
ADDRGP4 s_preferences+632+44
CNSTU4 258
ASGNU4
line 644
;644:	s_preferences.scavengerWeapons.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+632+48
ADDRGP4 Preferences_Event
ASGNP4
line 645
;645:	s_preferences.scavengerWeapons.generic.id = ID_SCAVENGERWEAPONS;
ADDRGP4 s_preferences+632+8
CNSTI4 146
ASGNI4
line 646
;646:	s_preferences.scavengerWeapons.generic.x = PREFERENCES_X_POS;
ADDRGP4 s_preferences+632+12
CNSTI4 360
ASGNI4
line 647
;647:	s_preferences.scavengerWeapons.generic.y = y;
ADDRGP4 s_preferences+632+16
ADDRLP4 0
INDIRI4
ASGNI4
line 649
;648:
;649:	y += BIGCHAR_HEIGHT+2;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
line 650
;650:	s_preferences.back.generic.type	    = MTYPE_BITMAP;
ADDRGP4 s_preferences+1880
CNSTI4 6
ASGNI4
line 651
;651:	s_preferences.back.generic.name     = ART_BACK0;
ADDRGP4 s_preferences+1880+4
ADDRGP4 $657
ASGNP4
line 652
;652:	s_preferences.back.generic.flags    = QMF_LEFT_JUSTIFY|QMF_PULSEIFFOCUS;
ADDRGP4 s_preferences+1880+44
CNSTU4 260
ASGNU4
line 653
;653:	s_preferences.back.generic.callback = Preferences_Event;
ADDRGP4 s_preferences+1880+48
ADDRGP4 Preferences_Event
ASGNP4
line 654
;654:	s_preferences.back.generic.id	    = ID_BACK;
ADDRGP4 s_preferences+1880+8
CNSTI4 138
ASGNI4
line 655
;655:	s_preferences.back.generic.x		= 0;
ADDRGP4 s_preferences+1880+12
CNSTI4 0
ASGNI4
line 656
;656:	s_preferences.back.generic.y		= 480-64;
ADDRGP4 s_preferences+1880+16
CNSTI4 416
ASGNI4
line 657
;657:	s_preferences.back.width  		    = 128;
ADDRGP4 s_preferences+1880+76
CNSTI4 128
ASGNI4
line 658
;658:	s_preferences.back.height  		    = 64;
ADDRGP4 s_preferences+1880+80
CNSTI4 64
ASGNI4
line 659
;659:	s_preferences.back.focuspic         = ART_BACK1;
ADDRGP4 s_preferences+1880+60
ADDRGP4 $674
ASGNP4
line 661
;660:
;661:	Menu_AddItem( &s_preferences.menu, &s_preferences.banner );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 662
;662:	Menu_AddItem( &s_preferences.menu, &s_preferences.framel );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 663
;663:	Menu_AddItem( &s_preferences.menu, &s_preferences.framer );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+448
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 665
;664:
;665:	Menu_AddItem( &s_preferences.menu, &s_preferences.crosshair );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+536
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 666
;666:	Menu_AddItem( &s_preferences.menu, &s_preferences.simpleitems );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+696
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 667
;667:	Menu_AddItem( &s_preferences.menu, &s_preferences.wallmarks );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+824
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 668
;668:	Menu_AddItem( &s_preferences.menu, &s_preferences.brass );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+760
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 669
;669:	Menu_AddItem( &s_preferences.menu, &s_preferences.dynamiclights );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+888
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 670
;670:	Menu_AddItem( &s_preferences.menu, &s_preferences.identifytarget );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+952
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 671
;671:	Menu_AddItem( &s_preferences.menu, &s_preferences.highqualitysky );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1016
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 672
;672:	Menu_AddItem( &s_preferences.menu, &s_preferences.synceveryframe );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1080
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 673
;673:	Menu_AddItem( &s_preferences.menu, &s_preferences.forcemodel );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1144
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 674
;674:	Menu_AddItem( &s_preferences.menu, &s_preferences.drawteamoverlay );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1208
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 675
;675:	Menu_AddItem( &s_preferences.menu, &s_preferences.allowdownload );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1304
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 676
;676:	Menu_AddItem( &s_preferences.menu, &s_preferences.gore );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1368
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 677
;677:	Menu_AddItem( &s_preferences.menu, &s_preferences.cleanView );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1432
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 678
;678:	Menu_AddItem( &s_preferences.menu, &s_preferences.railTrail );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1496
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 679
;679:	Menu_AddItem( &s_preferences.menu, &s_preferences.playerHealth );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1560
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 680
;680:	Menu_AddItem( &s_preferences.menu, &s_preferences.moveSpeed );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1656
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 681
;681:	Menu_AddItem( &s_preferences.menu, &s_preferences.staticitems );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1752
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 682
;682:	Menu_AddItem( &s_preferences.menu, &s_preferences.randomStartWeapon );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1816
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 683
;683:	Menu_AddItem( &s_preferences.menu, &s_preferences.scavengerWeapons );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+632
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 686
;684:	
;685:
;686:	Menu_AddItem( &s_preferences.menu, &s_preferences.back );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1880
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
line 688
;687:
;688:	Preferences_SetMenuItems();
ADDRGP4 Preferences_SetMenuItems
CALLV
pop
line 689
;689:}
LABELV $327
endproc Preferences_MenuInit 8 12
export Preferences_Cache
proc Preferences_Cache 16 8
line 697
;690:
;691:
;692:/*
;693:===============
;694:Preferences_Cache
;695:===============
;696:*/
;697:void Preferences_Cache( void ) {
line 700
;698:	int		n;
;699:
;700:	trap_R_RegisterShaderNoMip( ART_FRAMEL );
ADDRGP4 $345
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 701
;701:	trap_R_RegisterShaderNoMip( ART_FRAMER );
ADDRGP4 $359
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 702
;702:	trap_R_RegisterShaderNoMip( ART_BACK0 );
ADDRGP4 $657
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 703
;703:	trap_R_RegisterShaderNoMip( ART_BACK1 );
ADDRGP4 $674
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
line 704
;704:	for( n = 0; n < NUM_CROSSHAIRS; n++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $699
line 705
;705:		s_preferences.crosshairShader[n] = trap_R_RegisterShaderNoMip( va("gfx/2d/crosshair%c", 'a' + n ) );
ADDRGP4 $704
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 97
ADDI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_preferences+1968
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
line 706
;706:	}
LABELV $700
line 704
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 10
LTI4 $699
line 707
;707:}
LABELV $698
endproc Preferences_Cache 16 8
export UI_PreferencesMenu
proc UI_PreferencesMenu 0 4
line 715
;708:
;709:
;710:/*
;711:===============
;712:UI_PreferencesMenu
;713:===============
;714:*/
;715:void UI_PreferencesMenu( void ) {
line 716
;716:	Preferences_MenuInit();
ADDRGP4 Preferences_MenuInit
CALLV
pop
line 717
;717:	UI_PushMenu( &s_preferences.menu );
ADDRGP4 s_preferences
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
line 718
;718:}
LABELV $705
endproc UI_PreferencesMenu 0 4
bss
align 4
LABELV s_preferences
skip 2008
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
import UI_BotSelectMenu_Cache
import UI_BotSelectMenu
import ServerOptions_Cache
import StartServer_Cache
import UI_StartServerMenu
import ArenaServers_Cache
import UI_ArenaServersMenu
import SpecifyServer_Cache
import UI_SpecifyServerMenu
import SpecifyLeague_Cache
import UI_SpecifyLeagueMenu
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
LABELV $704
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 37
byte 1 99
byte 1 0
align 1
LABELV $674
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
LABELV $657
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
LABELV $643
byte 1 83
byte 1 99
byte 1 97
byte 1 118
byte 1 101
byte 1 110
byte 1 103
byte 1 101
byte 1 114
byte 1 32
byte 1 87
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $629
byte 1 82
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 32
byte 1 83
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 32
byte 1 87
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 58
byte 1 0
align 1
LABELV $615
byte 1 83
byte 1 116
byte 1 97
byte 1 116
byte 1 105
byte 1 99
byte 1 32
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $599
byte 1 77
byte 1 111
byte 1 118
byte 1 101
byte 1 32
byte 1 83
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 58
byte 1 0
align 1
LABELV $583
byte 1 80
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
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
LABELV $569
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 32
byte 1 84
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 58
byte 1 0
align 1
LABELV $555
byte 1 67
byte 1 108
byte 1 101
byte 1 97
byte 1 110
byte 1 32
byte 1 86
byte 1 105
byte 1 101
byte 1 119
byte 1 58
byte 1 0
align 1
LABELV $541
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 32
byte 1 97
byte 1 110
byte 1 100
byte 1 32
byte 1 71
byte 1 105
byte 1 98
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $527
byte 1 65
byte 1 117
byte 1 116
byte 1 111
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 99
byte 1 32
byte 1 68
byte 1 111
byte 1 119
byte 1 110
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 105
byte 1 110
byte 1 103
byte 1 58
byte 1 0
align 1
LABELV $511
byte 1 68
byte 1 114
byte 1 97
byte 1 119
byte 1 32
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 79
byte 1 118
byte 1 101
byte 1 114
byte 1 108
byte 1 97
byte 1 121
byte 1 58
byte 1 0
align 1
LABELV $497
byte 1 70
byte 1 111
byte 1 114
byte 1 99
byte 1 101
byte 1 32
byte 1 80
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 32
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $483
byte 1 83
byte 1 121
byte 1 110
byte 1 99
byte 1 32
byte 1 69
byte 1 118
byte 1 101
byte 1 114
byte 1 121
byte 1 32
byte 1 70
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $469
byte 1 72
byte 1 105
byte 1 103
byte 1 104
byte 1 32
byte 1 81
byte 1 117
byte 1 97
byte 1 108
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 83
byte 1 107
byte 1 121
byte 1 58
byte 1 0
align 1
LABELV $455
byte 1 73
byte 1 100
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 102
byte 1 121
byte 1 32
byte 1 84
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $441
byte 1 68
byte 1 121
byte 1 110
byte 1 97
byte 1 109
byte 1 105
byte 1 99
byte 1 32
byte 1 76
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $427
byte 1 69
byte 1 106
byte 1 101
byte 1 99
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 66
byte 1 114
byte 1 97
byte 1 115
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $413
byte 1 77
byte 1 97
byte 1 114
byte 1 107
byte 1 115
byte 1 32
byte 1 111
byte 1 110
byte 1 32
byte 1 87
byte 1 97
byte 1 108
byte 1 108
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $399
byte 1 83
byte 1 105
byte 1 109
byte 1 112
byte 1 108
byte 1 101
byte 1 32
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $379
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 58
byte 1 0
align 1
LABELV $359
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
LABELV $345
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
LABELV $337
byte 1 71
byte 1 65
byte 1 77
byte 1 69
byte 1 32
byte 1 79
byte 1 80
byte 1 84
byte 1 73
byte 1 79
byte 1 78
byte 1 83
byte 1 0
align 1
LABELV $297
byte 1 115
byte 1 101
byte 1 116
byte 1 97
byte 1 32
byte 1 103
byte 1 95
byte 1 115
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 32
byte 1 34
byte 1 37
byte 1 105
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $277
byte 1 115
byte 1 118
byte 1 95
byte 1 97
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 68
byte 1 111
byte 1 119
byte 1 110
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $203
byte 1 103
byte 1 95
byte 1 115
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $182
byte 1 103
byte 1 95
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $176
byte 1 99
byte 1 103
byte 1 95
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 0
align 1
LABELV $175
byte 1 99
byte 1 111
byte 1 109
byte 1 95
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 0
align 1
LABELV $169
byte 1 99
byte 1 108
byte 1 95
byte 1 97
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 68
byte 1 111
byte 1 119
byte 1 110
byte 1 108
byte 1 111
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $166
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 84
byte 1 101
byte 1 97
byte 1 109
byte 1 79
byte 1 118
byte 1 101
byte 1 114
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $160
byte 1 99
byte 1 103
byte 1 95
byte 1 102
byte 1 111
byte 1 114
byte 1 99
byte 1 101
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $154
byte 1 114
byte 1 95
byte 1 102
byte 1 105
byte 1 110
byte 1 105
byte 1 115
byte 1 104
byte 1 0
align 1
LABELV $148
byte 1 114
byte 1 95
byte 1 102
byte 1 97
byte 1 115
byte 1 116
byte 1 115
byte 1 107
byte 1 121
byte 1 0
align 1
LABELV $142
byte 1 114
byte 1 95
byte 1 100
byte 1 121
byte 1 110
byte 1 97
byte 1 109
byte 1 105
byte 1 99
byte 1 108
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $136
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 78
byte 1 97
byte 1 109
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $130
byte 1 99
byte 1 103
byte 1 95
byte 1 109
byte 1 97
byte 1 114
byte 1 107
byte 1 115
byte 1 0
align 1
LABELV $124
byte 1 99
byte 1 103
byte 1 95
byte 1 98
byte 1 114
byte 1 97
byte 1 115
byte 1 115
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $118
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 105
byte 1 109
byte 1 112
byte 1 108
byte 1 101
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 0
align 1
LABELV $115
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 0
align 1
LABELV $109
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 108
byte 1 101
byte 1 97
byte 1 110
byte 1 86
byte 1 105
byte 1 101
byte 1 119
byte 1 0
align 1
LABELV $103
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 84
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 0
align 1
LABELV $97
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 116
byte 1 105
byte 1 99
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 0
align 1
LABELV $91
byte 1 103
byte 1 95
byte 1 114
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 83
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 87
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $85
byte 1 103
byte 1 95
byte 1 115
byte 1 99
byte 1 97
byte 1 118
byte 1 101
byte 1 110
byte 1 103
byte 1 101
byte 1 114
byte 1 87
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 0
align 1
LABELV $81
byte 1 49
byte 1 53
byte 1 48
byte 1 0
align 1
LABELV $80
byte 1 49
byte 1 50
byte 1 53
byte 1 0
align 1
LABELV $79
byte 1 49
byte 1 48
byte 1 48
byte 1 0
align 1
LABELV $78
byte 1 55
byte 1 53
byte 1 0
align 1
LABELV $77
byte 1 53
byte 1 48
byte 1 0
align 1
LABELV $76
byte 1 49
byte 1 50
byte 1 53
byte 1 37
byte 1 0
align 1
LABELV $75
byte 1 49
byte 1 49
byte 1 48
byte 1 37
byte 1 0
align 1
LABELV $74
byte 1 49
byte 1 48
byte 1 48
byte 1 37
byte 1 0
align 1
LABELV $73
byte 1 57
byte 1 48
byte 1 37
byte 1 0
align 1
LABELV $72
byte 1 55
byte 1 53
byte 1 37
byte 1 0
align 1
LABELV $71
byte 1 108
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 32
byte 1 108
byte 1 101
byte 1 102
byte 1 116
byte 1 0
align 1
LABELV $70
byte 1 108
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 32
byte 1 114
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $69
byte 1 117
byte 1 112
byte 1 112
byte 1 101
byte 1 114
byte 1 32
byte 1 114
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $68
byte 1 111
byte 1 102
byte 1 102
byte 1 0
