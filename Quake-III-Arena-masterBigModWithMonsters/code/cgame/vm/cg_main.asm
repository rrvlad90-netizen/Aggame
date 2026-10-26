data
export forceModelModificationCount
align 4
LABELV forceModelModificationCount
byte 4 -1
export vmMain
code
proc vmMain 16 12
file "../cg_main.c"
line 46
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
;23:// cg_main.c -- initialization and primary entry point for cgame
;24:#include "cg_local.h"
;25:
;26:#ifdef MISSIONPACK
;27:#include "../ui/ui_shared.h"
;28:// display context for new ui stuff
;29:displayContextDef_t cgDC;
;30:#endif
;31:
;32:int forceModelModificationCount = -1;
;33:
;34:void CG_Init( int serverMessageNum, int serverCommandSequence, int clientNum );
;35:void CG_Shutdown( void );
;36:
;37:
;38:/*
;39:================
;40:vmMain
;41:
;42:This is the only way control passes into the module.
;43:This must be the very first function compiled into the .q3vm file
;44:================
;45:*/
;46:int vmMain( int command, int arg0, int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10, int arg11  ) {
line 48
;47:
;48:	switch ( command ) {
ADDRLP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $75
ADDRLP4 0
INDIRI4
CNSTI4 8
GTI4 $75
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $87
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $87
address $77
address $78
address $79
address $80
address $81
address $82
address $83
address $84
address $85
code
LABELV $77
line 50
;49:	case CG_INIT:
;50:		CG_Init( arg0, arg1, arg2 );
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRI4
ARGI4
ADDRFP4 12
INDIRI4
ARGI4
ADDRGP4 CG_Init
CALLV
pop
line 51
;51:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $74
JUMPV
LABELV $78
line 53
;52:	case CG_SHUTDOWN:
;53:		CG_Shutdown();
ADDRGP4 CG_Shutdown
CALLV
pop
line 54
;54:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $74
JUMPV
LABELV $79
line 56
;55:	case CG_CONSOLE_COMMAND:
;56:		return CG_ConsoleCommand();
ADDRLP4 4
ADDRGP4 CG_ConsoleCommand
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
RETI4
ADDRGP4 $74
JUMPV
LABELV $80
line 58
;57:	case CG_DRAW_ACTIVE_FRAME:
;58:		CG_DrawActiveFrame( arg0, arg1, arg2 );
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRI4
ARGI4
ADDRFP4 12
INDIRI4
ARGI4
ADDRGP4 CG_DrawActiveFrame
CALLV
pop
line 59
;59:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $74
JUMPV
LABELV $81
line 61
;60:	case CG_CROSSHAIR_PLAYER:
;61:		return CG_CrosshairPlayer();
ADDRLP4 8
ADDRGP4 CG_CrosshairPlayer
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
RETI4
ADDRGP4 $74
JUMPV
LABELV $82
line 63
;62:	case CG_LAST_ATTACKER:
;63:		return CG_LastAttacker();
ADDRLP4 12
ADDRGP4 CG_LastAttacker
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
RETI4
ADDRGP4 $74
JUMPV
LABELV $83
line 65
;64:	case CG_KEY_EVENT:
;65:		CG_KeyEvent(arg0, arg1);
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 CG_KeyEvent
CALLV
pop
line 66
;66:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $74
JUMPV
LABELV $84
line 72
;67:	case CG_MOUSE_EVENT:
;68:#ifdef MISSIONPACK
;69:		cgDC.cursorx = cgs.cursorX;
;70:		cgDC.cursory = cgs.cursorY;
;71:#endif
;72:		CG_MouseEvent(arg0, arg1);
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 CG_MouseEvent
CALLV
pop
line 73
;73:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $74
JUMPV
LABELV $85
line 75
;74:	case CG_EVENT_HANDLING:
;75:		CG_EventHandling(arg0);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 CG_EventHandling
CALLV
pop
line 76
;76:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $74
JUMPV
LABELV $75
line 78
;77:	default:
;78:		CG_Error( "vmMain: unknown command %i", command );
ADDRGP4 $86
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 79
;79:		break;
LABELV $76
line 81
;80:	}
;81:	return -1;
CNSTI4 -1
RETI4
LABELV $74
endproc vmMain 16 12
data
align 4
LABELV cvarTable
address cg_drawRailTrail
address $89
address $90
byte 4 1
address cg_ignore
address $91
address $92
byte 4 0
address cg_autoswitch
address $93
address $90
byte 4 1
address cg_drawGun
address $94
address $90
byte 4 1
address cg_zoomFov
address $95
address $96
byte 4 1
address cg_fov
address $97
address $98
byte 4 1
address cg_viewsize
address $99
address $100
byte 4 1
address cg_stereoSeparation
address $101
address $102
byte 4 1
address cg_shadows
address $103
address $90
byte 4 1
address cg_gibs
address $104
address $90
byte 4 1
address cg_draw2D
address $105
address $90
byte 4 1
address cg_drawStatus
address $106
address $90
byte 4 1
address cg_drawTimer
address $107
address $92
byte 4 1
address cg_drawFPS
address $108
address $92
byte 4 1
address cg_drawSnapshot
address $109
address $92
byte 4 1
address cg_draw3dIcons
address $110
address $90
byte 4 1
address cg_drawIcons
address $111
address $90
byte 4 1
address cg_drawAmmoWarning
address $112
address $90
byte 4 1
address cg_drawAttacker
address $113
address $90
byte 4 1
address cg_drawCrosshair
address $114
address $115
byte 4 1
address cg_drawCrosshairNames
address $116
address $90
byte 4 1
address cg_drawRewards
address $117
address $90
byte 4 1
address cg_crosshairSize
address $118
address $119
byte 4 1
address cg_crosshairHealth
address $120
address $90
byte 4 1
address cg_crosshairX
address $121
address $92
byte 4 1
address cg_crosshairY
address $122
address $92
byte 4 1
address cg_brassTime
address $123
address $124
byte 4 1
address cg_simpleItems
address $125
address $92
byte 4 1
address cg_staticItems
address $126
address $92
byte 4 1
address cg_addMarks
address $127
address $90
byte 4 1
address cg_lagometer
address $128
address $90
byte 4 1
address cg_railTrailTime
address $129
address $130
byte 4 1
address cg_gun_x
address $131
address $92
byte 4 512
address cg_gun_y
address $132
address $92
byte 4 512
address cg_gun_z
address $133
address $92
byte 4 512
address cg_centertime
address $134
address $135
byte 4 512
address cg_runpitch
address $136
address $137
byte 4 1
address cg_runroll
address $138
address $139
byte 4 1
address cg_bobup
address $140
address $139
byte 4 512
address cg_bobpitch
address $141
address $137
byte 4 1
address cg_bobroll
address $142
address $137
byte 4 1
address cg_swingSpeed
address $143
address $144
byte 4 512
address cg_animSpeed
address $145
address $90
byte 4 512
address cg_debugAnim
address $146
address $92
byte 4 512
address cg_debugPosition
address $147
address $92
byte 4 512
address cg_debugEvents
address $148
address $92
byte 4 512
address cg_errorDecay
address $149
address $100
byte 4 0
address cg_nopredict
address $150
address $92
byte 4 0
address cg_noPlayerAnims
address $151
address $92
byte 4 512
address cg_showmiss
address $152
address $92
byte 4 0
address cg_footsteps
address $153
address $90
byte 4 512
address cg_tracerChance
address $154
address $102
byte 4 512
address cg_tracerWidth
address $155
address $90
byte 4 512
address cg_tracerLength
address $156
address $100
byte 4 512
address cg_thirdPersonRange
address $157
address $158
byte 4 512
address cg_thirdPersonAngle
address $159
address $92
byte 4 512
address cg_thirdPerson
address $160
address $92
byte 4 0
address cg_teamChatTime
address $161
address $162
byte 4 1
address cg_teamChatHeight
address $163
address $92
byte 4 1
address cg_forceModel
address $164
address $92
byte 4 1
address cg_predictItems
address $165
address $90
byte 4 1
address cg_deferPlayers
address $166
address $90
byte 4 1
address cg_drawTeamOverlay
address $167
address $92
byte 4 1
address cg_teamOverlayUserinfo
address $168
address $92
byte 4 66
address cg_stats
address $169
address $92
byte 4 0
address cg_drawFriend
address $170
address $90
byte 4 1
address cg_cleanView
address $171
address $92
byte 4 1
address cg_teamChatsOnly
address $172
address $92
byte 4 1
address cg_noVoiceChats
address $173
address $92
byte 4 1
address cg_noVoiceText
address $174
address $92
byte 4 1
address cg_buildScript
address $175
address $92
byte 4 0
address cg_paused
address $176
address $92
byte 4 64
address cg_blood
address $177
address $90
byte 4 1
address cg_synchronousClients
address $178
address $92
byte 4 0
address cg_cameraOrbit
address $179
address $92
byte 4 512
address cg_cameraOrbitDelay
address $180
address $181
byte 4 1
address cg_timescaleFadeEnd
address $182
address $90
byte 4 0
address cg_timescaleFadeSpeed
address $183
address $92
byte 4 0
address cg_timescale
address $184
address $90
byte 4 0
address cg_scorePlum
address $185
address $90
byte 4 3
address cg_smoothClients
address $186
address $92
byte 4 3
address cg_cameraMode
address $187
address $92
byte 4 512
address pmove_fixed
address $188
address $92
byte 4 0
address pmove_msec
address $189
address $190
byte 4 0
address cg_noTaunt
address $191
address $92
byte 4 1
address cg_noProjectileTrail
address $192
address $92
byte 4 1
address cg_smallFont
address $193
address $194
byte 4 1
address cg_bigFont
address $195
address $102
byte 4 1
address cg_oldRail
address $196
address $90
byte 4 1
address cg_oldRocket
address $197
address $90
byte 4 1
address cg_oldPlasma
address $198
address $90
byte 4 1
address cg_trueLightning
address $199
address $200
byte 4 1
align 4
LABELV cvarTableSize
byte 4 92
export CG_RegisterCvars
code
proc CG_RegisterCvars 1036 16
line 333
;82:}
;83:
;84:
;85:cg_t				cg;
;86:cgs_t				cgs;
;87:centity_t			cg_entities[MAX_GENTITIES];
;88:weaponInfo_t		cg_weapons[MAX_WEAPONS];
;89:itemInfo_t			cg_items[MAX_ITEMS];
;90:
;91:vmCvar_t	cg_railTrailTime;
;92:vmCvar_t	cg_centertime;
;93:vmCvar_t	cg_runpitch;
;94:vmCvar_t	cg_runroll;
;95:vmCvar_t	cg_bobup;
;96:vmCvar_t	cg_bobpitch;
;97:vmCvar_t	cg_bobroll;
;98:vmCvar_t	cg_swingSpeed;
;99:vmCvar_t	cg_shadows;
;100:vmCvar_t	cg_gibs;
;101:vmCvar_t	cg_drawTimer;
;102:vmCvar_t	cg_drawFPS;
;103:vmCvar_t	cg_drawSnapshot;
;104:vmCvar_t	cg_draw3dIcons;
;105:vmCvar_t	cg_drawIcons;
;106:vmCvar_t	cg_drawAmmoWarning;
;107:vmCvar_t	cg_drawCrosshair;
;108:vmCvar_t	cg_drawCrosshairNames;
;109:vmCvar_t	cg_drawRewards;
;110:vmCvar_t	cg_crosshairSize;
;111:vmCvar_t	cg_crosshairX;
;112:vmCvar_t	cg_crosshairY;
;113:vmCvar_t	cg_crosshairHealth;
;114:vmCvar_t	cg_draw2D;
;115:vmCvar_t	cg_drawStatus;
;116:vmCvar_t	cg_animSpeed;
;117:vmCvar_t	cg_debugAnim;
;118:vmCvar_t	cg_debugPosition;
;119:vmCvar_t	cg_debugEvents;
;120:vmCvar_t	cg_errorDecay;
;121:vmCvar_t	cg_nopredict;
;122:vmCvar_t	cg_noPlayerAnims;
;123:vmCvar_t	cg_showmiss;
;124:vmCvar_t	cg_footsteps;
;125:vmCvar_t	cg_addMarks;
;126:vmCvar_t	cg_brassTime;
;127:vmCvar_t	cg_viewsize;
;128:vmCvar_t	cg_drawGun;
;129:vmCvar_t	cg_gun_frame;
;130:vmCvar_t	cg_gun_x;
;131:vmCvar_t	cg_gun_y;
;132:vmCvar_t	cg_gun_z;
;133:vmCvar_t	cg_tracerChance;
;134:vmCvar_t	cg_tracerWidth;
;135:vmCvar_t	cg_tracerLength;
;136:vmCvar_t	cg_autoswitch;
;137:vmCvar_t	cg_ignore;
;138:vmCvar_t	cg_simpleItems;
;139:vmCvar_t	cg_staticItems;
;140:vmCvar_t	cg_fov;
;141:vmCvar_t	cg_zoomFov;
;142:vmCvar_t	cg_thirdPerson;
;143:vmCvar_t	cg_thirdPersonRange;
;144:vmCvar_t	cg_thirdPersonAngle;
;145:vmCvar_t	cg_stereoSeparation;
;146:vmCvar_t	cg_lagometer;
;147:vmCvar_t	cg_drawAttacker;
;148:vmCvar_t	cg_synchronousClients;
;149:vmCvar_t 	cg_teamChatTime;
;150:vmCvar_t 	cg_teamChatHeight;
;151:vmCvar_t 	cg_stats;
;152:vmCvar_t 	cg_buildScript;
;153:vmCvar_t 	cg_forceModel;
;154:vmCvar_t	cg_paused;
;155:vmCvar_t	cg_blood;
;156:vmCvar_t	cg_predictItems;
;157:vmCvar_t	cg_deferPlayers;
;158:vmCvar_t	cg_drawTeamOverlay;
;159:vmCvar_t	cg_teamOverlayUserinfo;
;160:vmCvar_t	cg_drawFriend;
;161:vmCvar_t	cg_cleanView;
;162:vmCvar_t	cg_teamChatsOnly;
;163:vmCvar_t	cg_noVoiceChats;
;164:vmCvar_t	cg_noVoiceText;
;165:vmCvar_t	cg_hudFiles;
;166:vmCvar_t 	cg_scorePlum;
;167:vmCvar_t 	cg_smoothClients;
;168:vmCvar_t	pmove_fixed;
;169://vmCvar_t	cg_pmove_fixed;
;170:vmCvar_t	pmove_msec;
;171:vmCvar_t	cg_pmove_msec;
;172:vmCvar_t	cg_cameraMode;
;173:vmCvar_t	cg_cameraOrbit;
;174:vmCvar_t	cg_cameraOrbitDelay;
;175:vmCvar_t	cg_timescaleFadeEnd;
;176:vmCvar_t	cg_timescaleFadeSpeed;
;177:vmCvar_t	cg_timescale;
;178:vmCvar_t	cg_smallFont;
;179:vmCvar_t	cg_bigFont;
;180:vmCvar_t	cg_noTaunt;
;181:vmCvar_t	cg_noProjectileTrail;
;182:vmCvar_t	cg_oldRail;
;183:vmCvar_t	cg_oldRocket;
;184:vmCvar_t	cg_oldPlasma;
;185:vmCvar_t	cg_trueLightning;
;186:vmCvar_t	cg_drawRailTrail;
;187:
;188:#ifdef MISSIONPACK
;189:vmCvar_t 	cg_redTeamName;
;190:vmCvar_t 	cg_blueTeamName;
;191:vmCvar_t	cg_currentSelectedPlayer;
;192:vmCvar_t	cg_currentSelectedPlayerName;
;193:vmCvar_t	cg_singlePlayer;
;194:vmCvar_t	cg_enableDust;
;195:vmCvar_t	cg_enableBreath;
;196:vmCvar_t	cg_singlePlayerActive;
;197:vmCvar_t	cg_recordSPDemo;
;198:vmCvar_t	cg_recordSPDemoName;
;199:vmCvar_t	cg_obeliskRespawnDelay;
;200:#endif
;201:
;202:typedef struct {
;203:	vmCvar_t	*vmCvar;
;204:	char		*cvarName;
;205:	char		*defaultString;
;206:	int			cvarFlags;
;207:} cvarTable_t;
;208:
;209:static cvarTable_t cvarTable[] = { // bk001129
;210:	{ &cg_drawRailTrail, "cg_drawRailTrail", "1", CVAR_ARCHIVE },	
;211:	{ &cg_ignore, "cg_ignore", "0", 0 },	// used for debugging
;212:	{ &cg_autoswitch, "cg_autoswitch", "1", CVAR_ARCHIVE },
;213:	{ &cg_drawGun, "cg_drawGun", "1", CVAR_ARCHIVE },
;214:	{ &cg_zoomFov, "cg_zoomfov", "22.5", CVAR_ARCHIVE },
;215:	{ &cg_fov, "cg_fov", "90", CVAR_ARCHIVE },
;216:	{ &cg_viewsize, "cg_viewsize", "100", CVAR_ARCHIVE },
;217:	{ &cg_stereoSeparation, "cg_stereoSeparation", "0.4", CVAR_ARCHIVE  },
;218:	{ &cg_shadows, "cg_shadows", "1", CVAR_ARCHIVE  },
;219:	{ &cg_gibs, "cg_gibs", "1", CVAR_ARCHIVE  },
;220:	{ &cg_draw2D, "cg_draw2D", "1", CVAR_ARCHIVE  },
;221:	{ &cg_drawStatus, "cg_drawStatus", "1", CVAR_ARCHIVE  },
;222:	{ &cg_drawTimer, "cg_drawTimer", "0", CVAR_ARCHIVE  },
;223:	{ &cg_drawFPS, "cg_drawFPS", "0", CVAR_ARCHIVE  },
;224:	{ &cg_drawSnapshot, "cg_drawSnapshot", "0", CVAR_ARCHIVE  },
;225:	{ &cg_draw3dIcons, "cg_draw3dIcons", "1", CVAR_ARCHIVE  },
;226:	{ &cg_drawIcons, "cg_drawIcons", "1", CVAR_ARCHIVE  },
;227:	{ &cg_drawAmmoWarning, "cg_drawAmmoWarning", "1", CVAR_ARCHIVE  },
;228:	{ &cg_drawAttacker, "cg_drawAttacker", "1", CVAR_ARCHIVE  },
;229:	{ &cg_drawCrosshair, "cg_drawCrosshair", "4", CVAR_ARCHIVE },
;230:	{ &cg_drawCrosshairNames, "cg_drawCrosshairNames", "1", CVAR_ARCHIVE },
;231:	{ &cg_drawRewards, "cg_drawRewards", "1", CVAR_ARCHIVE },
;232:	{ &cg_crosshairSize, "cg_crosshairSize", "24", CVAR_ARCHIVE },
;233:	{ &cg_crosshairHealth, "cg_crosshairHealth", "1", CVAR_ARCHIVE },
;234:	{ &cg_crosshairX, "cg_crosshairX", "0", CVAR_ARCHIVE },
;235:	{ &cg_crosshairY, "cg_crosshairY", "0", CVAR_ARCHIVE },
;236:	{ &cg_brassTime, "cg_brassTime", "2500", CVAR_ARCHIVE },
;237:	{ &cg_simpleItems, "cg_simpleItems", "0", CVAR_ARCHIVE },
;238:	{ &cg_staticItems, "cg_staticItems", "0", CVAR_ARCHIVE },
;239:	{ &cg_addMarks, "cg_marks", "1", CVAR_ARCHIVE },
;240:	{ &cg_lagometer, "cg_lagometer", "1", CVAR_ARCHIVE },
;241:	{ &cg_railTrailTime, "cg_railTrailTime", "400", CVAR_ARCHIVE  },
;242:	{ &cg_gun_x, "cg_gunX", "0", CVAR_CHEAT },
;243:	{ &cg_gun_y, "cg_gunY", "0", CVAR_CHEAT },
;244:	{ &cg_gun_z, "cg_gunZ", "0", CVAR_CHEAT },
;245:	{ &cg_centertime, "cg_centertime", "3", CVAR_CHEAT },
;246:	{ &cg_runpitch, "cg_runpitch", "0.002", CVAR_ARCHIVE},
;247:	{ &cg_runroll, "cg_runroll", "0.005", CVAR_ARCHIVE },
;248:	{ &cg_bobup , "cg_bobup", "0.005", CVAR_CHEAT },
;249:	{ &cg_bobpitch, "cg_bobpitch", "0.002", CVAR_ARCHIVE },
;250:	{ &cg_bobroll, "cg_bobroll", "0.002", CVAR_ARCHIVE },
;251:	{ &cg_swingSpeed, "cg_swingSpeed", "0.3", CVAR_CHEAT },
;252:	{ &cg_animSpeed, "cg_animspeed", "1", CVAR_CHEAT },
;253:	{ &cg_debugAnim, "cg_debuganim", "0", CVAR_CHEAT },
;254:	{ &cg_debugPosition, "cg_debugposition", "0", CVAR_CHEAT },
;255:	{ &cg_debugEvents, "cg_debugevents", "0", CVAR_CHEAT },
;256:	{ &cg_errorDecay, "cg_errordecay", "100", 0 },
;257:	{ &cg_nopredict, "cg_nopredict", "0", 0 },
;258:	{ &cg_noPlayerAnims, "cg_noplayeranims", "0", CVAR_CHEAT },
;259:	{ &cg_showmiss, "cg_showmiss", "0", 0 },
;260:	{ &cg_footsteps, "cg_footsteps", "1", CVAR_CHEAT },
;261:	{ &cg_tracerChance, "cg_tracerchance", "0.4", CVAR_CHEAT },
;262:	{ &cg_tracerWidth, "cg_tracerwidth", "1", CVAR_CHEAT },
;263:	{ &cg_tracerLength, "cg_tracerlength", "100", CVAR_CHEAT },
;264:	{ &cg_thirdPersonRange, "cg_thirdPersonRange", "40", CVAR_CHEAT },
;265:	{ &cg_thirdPersonAngle, "cg_thirdPersonAngle", "0", CVAR_CHEAT },
;266:	{ &cg_thirdPerson, "cg_thirdPerson", "0", 0 },
;267:	{ &cg_teamChatTime, "cg_teamChatTime", "3000", CVAR_ARCHIVE  },
;268:	{ &cg_teamChatHeight, "cg_teamChatHeight", "0", CVAR_ARCHIVE  },
;269:	{ &cg_forceModel, "cg_forceModel", "0", CVAR_ARCHIVE  },
;270:	{ &cg_predictItems, "cg_predictItems", "1", CVAR_ARCHIVE },
;271:#ifdef MISSIONPACK
;272:	{ &cg_deferPlayers, "cg_deferPlayers", "0", CVAR_ARCHIVE },
;273:#else
;274:	{ &cg_deferPlayers, "cg_deferPlayers", "1", CVAR_ARCHIVE },
;275:#endif
;276:	{ &cg_drawTeamOverlay, "cg_drawTeamOverlay", "0", CVAR_ARCHIVE },
;277:	{ &cg_teamOverlayUserinfo, "teamoverlay", "0", CVAR_ROM | CVAR_USERINFO },
;278:	{ &cg_stats, "cg_stats", "0", 0 },
;279:	{ &cg_drawFriend, "cg_drawFriend", "1", CVAR_ARCHIVE },
;280:	{ &cg_cleanView, "cg_cleanView", "0", CVAR_ARCHIVE },
;281:	{ &cg_teamChatsOnly, "cg_teamChatsOnly", "0", CVAR_ARCHIVE },
;282:	{ &cg_noVoiceChats, "cg_noVoiceChats", "0", CVAR_ARCHIVE },
;283:	{ &cg_noVoiceText, "cg_noVoiceText", "0", CVAR_ARCHIVE },
;284:	// the following variables are created in other parts of the system,
;285:	// but we also reference them here
;286:	{ &cg_buildScript, "com_buildScript", "0", 0 },	// force loading of all possible data amd error on failures
;287:	{ &cg_paused, "cl_paused", "0", CVAR_ROM },
;288:	{ &cg_blood, "com_blood", "1", CVAR_ARCHIVE },
;289:	{ &cg_synchronousClients, "g_synchronousClients", "0", 0 },	// communicated by systeminfo
;290:#ifdef MISSIONPACK
;291:	{ &cg_redTeamName, "g_redteam", DEFAULT_REDTEAM_NAME, CVAR_ARCHIVE | CVAR_SERVERINFO | CVAR_USERINFO },
;292:	{ &cg_blueTeamName, "g_blueteam", DEFAULT_BLUETEAM_NAME, CVAR_ARCHIVE | CVAR_SERVERINFO | CVAR_USERINFO },
;293:	{ &cg_currentSelectedPlayer, "cg_currentSelectedPlayer", "0", CVAR_ARCHIVE},
;294:	{ &cg_currentSelectedPlayerName, "cg_currentSelectedPlayerName", "", CVAR_ARCHIVE},
;295:	{ &cg_singlePlayer, "ui_singlePlayerActive", "0", CVAR_USERINFO},
;296:	{ &cg_enableDust, "g_enableDust", "0", CVAR_SERVERINFO},
;297:	{ &cg_enableBreath, "g_enableBreath", "0", CVAR_SERVERINFO},
;298:	{ &cg_singlePlayerActive, "ui_singlePlayerActive", "0", CVAR_USERINFO},
;299:	{ &cg_recordSPDemo, "ui_recordSPDemo", "0", CVAR_ARCHIVE},
;300:	{ &cg_recordSPDemoName, "ui_recordSPDemoName", "", CVAR_ARCHIVE},
;301:	{ &cg_obeliskRespawnDelay, "g_obeliskRespawnDelay", "10", CVAR_SERVERINFO},
;302:	{ &cg_hudFiles, "cg_hudFiles", "ui/hud.txt", CVAR_ARCHIVE},
;303:#endif
;304:	{ &cg_cameraOrbit, "cg_cameraOrbit", "0", CVAR_CHEAT},
;305:	{ &cg_cameraOrbitDelay, "cg_cameraOrbitDelay", "50", CVAR_ARCHIVE},
;306:	{ &cg_timescaleFadeEnd, "cg_timescaleFadeEnd", "1", 0},
;307:	{ &cg_timescaleFadeSpeed, "cg_timescaleFadeSpeed", "0", 0},
;308:	{ &cg_timescale, "timescale", "1", 0},
;309:	{ &cg_scorePlum, "cg_scorePlums", "1", CVAR_USERINFO | CVAR_ARCHIVE},
;310:	{ &cg_smoothClients, "cg_smoothClients", "0", CVAR_USERINFO | CVAR_ARCHIVE},
;311:	{ &cg_cameraMode, "com_cameraMode", "0", CVAR_CHEAT},
;312:
;313:	{ &pmove_fixed, "pmove_fixed", "0", 0},
;314:	{ &pmove_msec, "pmove_msec", "8", 0},
;315:	{ &cg_noTaunt, "cg_noTaunt", "0", CVAR_ARCHIVE},
;316:	{ &cg_noProjectileTrail, "cg_noProjectileTrail", "0", CVAR_ARCHIVE},
;317:	{ &cg_smallFont, "ui_smallFont", "0.25", CVAR_ARCHIVE},
;318:	{ &cg_bigFont, "ui_bigFont", "0.4", CVAR_ARCHIVE},
;319:	{ &cg_oldRail, "cg_oldRail", "1", CVAR_ARCHIVE},
;320:	{ &cg_oldRocket, "cg_oldRocket", "1", CVAR_ARCHIVE},
;321:	{ &cg_oldPlasma, "cg_oldPlasma", "1", CVAR_ARCHIVE},
;322:	{ &cg_trueLightning, "cg_trueLightning", "0.0", CVAR_ARCHIVE}
;323://	{ &cg_pmove_fixed, "cg_pmove_fixed", "0", CVAR_USERINFO | CVAR_ARCHIVE }
;324:};
;325:
;326:static int  cvarTableSize = sizeof( cvarTable ) / sizeof( cvarTable[0] );
;327:
;328:/*
;329:=================
;330:CG_RegisterCvars
;331:=================
;332:*/
;333:void CG_RegisterCvars( void ) {
line 338
;334:	int			i;
;335:	cvarTable_t	*cv;
;336:	char		var[MAX_TOKEN_CHARS];
;337:
;338:	for ( i = 0, cv = cvarTable ; i < cvarTableSize ; i++, cv++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
ADDRGP4 cvarTable
ASGNP4
ADDRGP4 $205
JUMPV
LABELV $202
line 339
;339:		trap_Cvar_Register( cv->vmCvar, cv->cvarName,
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 341
;340:			cv->defaultString, cv->cvarFlags );
;341:	}
LABELV $203
line 338
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
LABELV $205
ADDRLP4 4
INDIRI4
ADDRGP4 cvarTableSize
INDIRI4
LTI4 $202
line 344
;342:
;343:	// see if we are also running the server on this machine
;344:	trap_Cvar_VariableStringBuffer( "sv_running", var, sizeof( var ) );
ADDRGP4 $206
ARGP4
ADDRLP4 8
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
line 345
;345:	cgs.localServer = atoi( var );
ADDRLP4 8
ARGP4
ADDRLP4 1032
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+31452
ADDRLP4 1032
INDIRI4
ASGNI4
line 347
;346:
;347:	forceModelModificationCount = cg_forceModel.modificationCount;
ADDRGP4 forceModelModificationCount
ADDRGP4 cg_forceModel+4
INDIRI4
ASGNI4
line 349
;348:
;349:	trap_Cvar_Register(NULL, "model", DEFAULT_MODEL, CVAR_USERINFO | CVAR_ARCHIVE );
CNSTP4 0
ARGP4
ADDRGP4 $209
ARGP4
ADDRGP4 $210
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 350
;350:	trap_Cvar_Register(NULL, "headmodel", DEFAULT_MODEL, CVAR_USERINFO | CVAR_ARCHIVE );
CNSTP4 0
ARGP4
ADDRGP4 $211
ARGP4
ADDRGP4 $210
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 351
;351:	trap_Cvar_Register(NULL, "team_model", DEFAULT_TEAM_MODEL, CVAR_USERINFO | CVAR_ARCHIVE );
CNSTP4 0
ARGP4
ADDRGP4 $212
ARGP4
ADDRGP4 $210
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 352
;352:	trap_Cvar_Register(NULL, "team_headmodel", DEFAULT_TEAM_HEAD, CVAR_USERINFO | CVAR_ARCHIVE );
CNSTP4 0
ARGP4
ADDRGP4 $213
ARGP4
ADDRGP4 $210
ARGP4
CNSTI4 3
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 353
;353:}
LABELV $201
endproc CG_RegisterCvars 1036 16
proc CG_ForceModelChange 12 4
line 360
;354:
;355:/*																																			
;356:===================
;357:CG_ForceModelChange
;358:===================
;359:*/
;360:static void CG_ForceModelChange( void ) {
line 363
;361:	int		i;
;362:
;363:	for (i=0 ; i<MAX_CLIENTS ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $215
line 366
;364:		const char		*clientInfo;
;365:
;366:		clientInfo = CG_ConfigString( CS_PLAYERS+i );
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 8
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 367
;367:		if ( !clientInfo[0] ) {
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $219
line 368
;368:			continue;
ADDRGP4 $216
JUMPV
LABELV $219
line 370
;369:		}
;370:		CG_NewClientInfo( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_NewClientInfo
CALLV
pop
line 371
;371:	}
LABELV $216
line 363
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $215
line 372
;372:}
LABELV $214
endproc CG_ForceModelChange 12 4
export CG_UpdateCvars
proc CG_UpdateCvars 8 8
line 379
;373:
;374:/*
;375:=================
;376:CG_UpdateCvars
;377:=================
;378:*/
;379:void CG_UpdateCvars( void ) {
line 383
;380:	int			i;
;381:	cvarTable_t	*cv;
;382:
;383:	for ( i = 0, cv = cvarTable ; i < cvarTableSize ; i++, cv++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRLP4 4
ADDRGP4 cvarTable
ASGNP4
ADDRGP4 $225
JUMPV
LABELV $222
line 384
;384:		trap_Cvar_Update( cv->vmCvar );
ADDRLP4 4
INDIRP4
INDIRP4
ARGP4
ADDRGP4 trap_Cvar_Update
CALLV
pop
line 385
;385:	}
LABELV $223
line 383
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
ADDRLP4 4
INDIRP4
CNSTI4 16
ADDP4
ASGNP4
LABELV $225
ADDRLP4 0
INDIRI4
ADDRGP4 cvarTableSize
INDIRI4
LTI4 $222
line 391
;386:
;387:	// check for modications here
;388:
;389:	// If team overlay is on, ask for updates from the server.  If its off,
;390:	// let the server know so we don't receive it
;391:	if ( drawTeamOverlayModificationCount != cg_drawTeamOverlay.modificationCount ) {
ADDRGP4 drawTeamOverlayModificationCount
INDIRI4
ADDRGP4 cg_drawTeamOverlay+4
INDIRI4
EQI4 $226
line 392
;392:		drawTeamOverlayModificationCount = cg_drawTeamOverlay.modificationCount;
ADDRGP4 drawTeamOverlayModificationCount
ADDRGP4 cg_drawTeamOverlay+4
INDIRI4
ASGNI4
line 394
;393:
;394:		if ( cg_drawTeamOverlay.integer > 0 ) {
ADDRGP4 cg_drawTeamOverlay+12
INDIRI4
CNSTI4 0
LEI4 $230
line 395
;395:			trap_Cvar_Set( "teamoverlay", "1" );
ADDRGP4 $168
ARGP4
ADDRGP4 $90
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 396
;396:		} else {
ADDRGP4 $231
JUMPV
LABELV $230
line 397
;397:			trap_Cvar_Set( "teamoverlay", "0" );
ADDRGP4 $168
ARGP4
ADDRGP4 $92
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 398
;398:		}
LABELV $231
line 400
;399:		// FIXME E3 HACK
;400:		trap_Cvar_Set( "teamoverlay", "1" );
ADDRGP4 $168
ARGP4
ADDRGP4 $90
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
line 401
;401:	}
LABELV $226
line 404
;402:
;403:	// if force model changed
;404:	if ( forceModelModificationCount != cg_forceModel.modificationCount ) {
ADDRGP4 forceModelModificationCount
INDIRI4
ADDRGP4 cg_forceModel+4
INDIRI4
EQI4 $233
line 405
;405:		forceModelModificationCount = cg_forceModel.modificationCount;
ADDRGP4 forceModelModificationCount
ADDRGP4 cg_forceModel+4
INDIRI4
ASGNI4
line 406
;406:		CG_ForceModelChange();
ADDRGP4 CG_ForceModelChange
CALLV
pop
line 407
;407:	}
LABELV $233
line 408
;408:}
LABELV $221
endproc CG_UpdateCvars 8 8
export CG_CrosshairPlayer
proc CG_CrosshairPlayer 0 0
line 410
;409:
;410:int CG_CrosshairPlayer( void ) {
line 411
;411:	if ( cg.time > ( cg.crosshairClientTime + 1000 ) ) {
ADDRGP4 cg+107604
INDIRI4
ADDRGP4 cg+124404
INDIRI4
CNSTI4 1000
ADDI4
LEI4 $238
line 412
;412:		return -1;
CNSTI4 -1
RETI4
ADDRGP4 $237
JUMPV
LABELV $238
line 414
;413:	}
;414:	return cg.crosshairClientNum;
ADDRGP4 cg+124400
INDIRI4
RETI4
LABELV $237
endproc CG_CrosshairPlayer 0 0
export CG_LastAttacker
proc CG_LastAttacker 0 0
line 417
;415:}
;416:
;417:int CG_LastAttacker( void ) {
line 418
;418:	if ( !cg.attackerTime ) {
ADDRGP4 cg+124416
INDIRI4
CNSTI4 0
NEI4 $244
line 419
;419:		return -1;
CNSTI4 -1
RETI4
ADDRGP4 $243
JUMPV
LABELV $244
line 421
;420:	}
;421:	return cg.snap->ps.persistant[PERS_ATTACKER];
ADDRGP4 cg+36
INDIRP4
CNSTI4 316
ADDP4
INDIRI4
RETI4
LABELV $243
endproc CG_LastAttacker 0 0
export CG_Printf
proc CG_Printf 1028 12
line 424
;422:}
;423:
;424:void QDECL CG_Printf( const char *msg, ... ) {
line 428
;425:	va_list		argptr;
;426:	char		text[1024];
;427:
;428:	va_start (argptr, msg);
ADDRLP4 0
ADDRFP4 0+4
ASGNP4
line 429
;429:	vsprintf (text, msg, argptr);
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 vsprintf
CALLI4
pop
line 430
;430:	va_end (argptr);
ADDRLP4 0
CNSTP4 0
ASGNP4
line 432
;431:
;432:	trap_Print( text );
ADDRLP4 4
ARGP4
ADDRGP4 trap_Print
CALLV
pop
line 433
;433:}
LABELV $248
endproc CG_Printf 1028 12
export CG_Error
proc CG_Error 1028 12
line 435
;434:
;435:void QDECL CG_Error( const char *msg, ... ) {
line 439
;436:	va_list		argptr;
;437:	char		text[1024];
;438:
;439:	va_start (argptr, msg);
ADDRLP4 0
ADDRFP4 0+4
ASGNP4
line 440
;440:	vsprintf (text, msg, argptr);
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 vsprintf
CALLI4
pop
line 441
;441:	va_end (argptr);
ADDRLP4 0
CNSTP4 0
ASGNP4
line 443
;442:
;443:	trap_Error( text );
ADDRLP4 4
ARGP4
ADDRGP4 trap_Error
CALLV
pop
line 444
;444:}
LABELV $250
endproc CG_Error 1028 12
export Com_Error
proc Com_Error 1028 12
line 449
;445:
;446:#ifndef CGAME_HARD_LINKED
;447:// this is only here so the functions in q_shared.c and bg_*.c can link (FIXME)
;448:
;449:void QDECL Com_Error( int level, const char *error, ... ) {
line 453
;450:	va_list		argptr;
;451:	char		text[1024];
;452:
;453:	va_start (argptr, error);
ADDRLP4 0
ADDRFP4 4+4
ASGNP4
line 454
;454:	vsprintf (text, error, argptr);
ADDRLP4 4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 vsprintf
CALLI4
pop
line 455
;455:	va_end (argptr);
ADDRLP4 0
CNSTP4 0
ASGNP4
line 457
;456:
;457:	CG_Error( "%s", text);
ADDRGP4 $254
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 458
;458:}
LABELV $252
endproc Com_Error 1028 12
export Com_Printf
proc Com_Printf 1028 12
line 460
;459:
;460:void QDECL Com_Printf( const char *msg, ... ) {
line 464
;461:	va_list		argptr;
;462:	char		text[1024];
;463:
;464:	va_start (argptr, msg);
ADDRLP4 0
ADDRFP4 0+4
ASGNP4
line 465
;465:	vsprintf (text, msg, argptr);
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 vsprintf
CALLI4
pop
line 466
;466:	va_end (argptr);
ADDRLP4 0
CNSTP4 0
ASGNP4
line 468
;467:
;468:	CG_Printf ("%s", text);
ADDRGP4 $254
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 CG_Printf
CALLV
pop
line 469
;469:}
LABELV $255
endproc Com_Printf 1028 12
bss
align 1
LABELV $258
skip 1024
export CG_Argv
code
proc CG_Argv 0 12
line 478
;470:
;471:#endif
;472:
;473:/*
;474:================
;475:CG_Argv
;476:================
;477:*/
;478:const char *CG_Argv( int arg ) {
line 481
;479:	static char	buffer[MAX_STRING_CHARS];
;480:
;481:	trap_Argv( arg, buffer, sizeof( buffer ) );
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 $258
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 483
;482:
;483:	return buffer;
ADDRGP4 $258
RETP4
LABELV $257
endproc CG_Argv 0 12
proc CG_RegisterItemSounds 96 12
line 496
;484:}
;485:
;486:
;487://========================================================================
;488:
;489:/*
;490:=================
;491:CG_RegisterItemSounds
;492:
;493:The server says this item is used on this level
;494:=================
;495:*/
;496:static void CG_RegisterItemSounds( int itemNum ) {
line 502
;497:	gitem_t			*item;
;498:	char			data[MAX_QPATH];
;499:	char			*s, *start;
;500:	int				len;
;501:
;502:	item = &bg_itemlist[ itemNum ];
ADDRLP4 76
CNSTI4 52
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 bg_itemlist
ADDP4
ASGNP4
line 504
;503:
;504:	if( item->pickup_sound ) {
ADDRLP4 76
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $260
line 505
;505:		trap_S_RegisterSound( item->pickup_sound, qfalse );
ADDRLP4 76
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_S_RegisterSound
CALLI4
pop
line 506
;506:	}
LABELV $260
line 509
;507:
;508:	// parse the space seperated precache string for other media
;509:	s = item->sounds;
ADDRLP4 0
ADDRLP4 76
INDIRP4
CNSTI4 48
ADDP4
INDIRP4
ASGNP4
line 510
;510:	if (!s || !s[0])
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $264
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $266
LABELV $264
line 511
;511:		return;
ADDRGP4 $259
JUMPV
LABELV $265
line 513
;512:
;513:	while (*s) {
line 514
;514:		start = s;
ADDRLP4 72
ADDRLP4 0
INDIRP4
ASGNP4
ADDRGP4 $269
JUMPV
LABELV $268
line 515
;515:		while (*s && *s != ' ') {
line 516
;516:			s++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 517
;517:		}
LABELV $269
line 515
ADDRLP4 84
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 84
INDIRI4
CNSTI4 0
EQI4 $271
ADDRLP4 84
INDIRI4
CNSTI4 32
NEI4 $268
LABELV $271
line 519
;518:
;519:		len = s-start;
ADDRLP4 4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRLP4 72
INDIRP4
CVPU4 4
SUBU4
CVUI4 4
ASGNI4
line 520
;520:		if (len >= MAX_QPATH || len < 5) {
ADDRLP4 4
INDIRI4
CNSTI4 64
GEI4 $274
ADDRLP4 4
INDIRI4
CNSTI4 5
GEI4 $272
LABELV $274
line 521
;521:			CG_Error( "PrecacheItem: %s has bad precache string", 
ADDRGP4 $275
ARGP4
ADDRLP4 76
INDIRP4
INDIRP4
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 523
;522:				item->classname);
;523:			return;
ADDRGP4 $259
JUMPV
LABELV $272
line 525
;524:		}
;525:		memcpy (data, start, len);
ADDRLP4 8
ARGP4
ADDRLP4 72
INDIRP4
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 526
;526:		data[len] = 0;
ADDRLP4 4
INDIRI4
ADDRLP4 8
ADDP4
CNSTI1 0
ASGNI1
line 527
;527:		if ( *s ) {
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $276
line 528
;528:			s++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 529
;529:		}
LABELV $276
line 531
;530:
;531:		if ( !strcmp(data+len-3, "wav" )) {
ADDRLP4 4
INDIRI4
ADDRLP4 8-3
ADDP4
ARGP4
ADDRGP4 $281
ARGP4
ADDRLP4 92
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 92
INDIRI4
CNSTI4 0
NEI4 $278
line 532
;532:			trap_S_RegisterSound( data, qfalse );
ADDRLP4 8
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_S_RegisterSound
CALLI4
pop
line 533
;533:		}
LABELV $278
line 534
;534:	}
LABELV $266
line 513
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $265
line 535
;535:}
LABELV $259
endproc CG_RegisterItemSounds 96 12
proc CG_RegisterSounds 548 16
line 545
;536:
;537:
;538:/*
;539:=================
;540:CG_RegisterSounds
;541:
;542:called during a precache command
;543:=================
;544:*/
;545:static void CG_RegisterSounds( void ) {
line 556
;546:	int		i;
;547:	char	items[MAX_ITEMS+1];
;548:	char	name[MAX_QPATH];
;549:	const char	*soundName;
;550:
;551:	// voice commands
;552:#ifdef MISSIONPACK
;553:	CG_LoadVoiceChats();
;554:#endif
;555:
;556:	cgs.media.oneMinuteSound = trap_S_RegisterSound( "sound/feedback/1_minute.wav", qtrue );
ADDRGP4 $285
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 332
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+748
ADDRLP4 332
INDIRI4
ASGNI4
line 557
;557:	cgs.media.fiveMinuteSound = trap_S_RegisterSound( "sound/feedback/5_minute.wav", qtrue );
ADDRGP4 $288
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 336
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+752
ADDRLP4 336
INDIRI4
ASGNI4
line 558
;558:	cgs.media.suddenDeathSound = trap_S_RegisterSound( "sound/feedback/sudden_death.wav", qtrue );
ADDRGP4 $291
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 340
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+756
ADDRLP4 340
INDIRI4
ASGNI4
line 559
;559:	cgs.media.oneFragSound = trap_S_RegisterSound( "sound/feedback/1_frag.wav", qtrue );
ADDRGP4 $294
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 344
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+768
ADDRLP4 344
INDIRI4
ASGNI4
line 560
;560:	cgs.media.twoFragSound = trap_S_RegisterSound( "sound/feedback/2_frags.wav", qtrue );
ADDRGP4 $297
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 348
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+764
ADDRLP4 348
INDIRI4
ASGNI4
line 561
;561:	cgs.media.threeFragSound = trap_S_RegisterSound( "sound/feedback/3_frags.wav", qtrue );
ADDRGP4 $300
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 352
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+760
ADDRLP4 352
INDIRI4
ASGNI4
line 562
;562:	cgs.media.count3Sound = trap_S_RegisterSound( "sound/feedback/three.wav", qtrue );
ADDRGP4 $303
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 356
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+960
ADDRLP4 356
INDIRI4
ASGNI4
line 563
;563:	cgs.media.count2Sound = trap_S_RegisterSound( "sound/feedback/two.wav", qtrue );
ADDRGP4 $306
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 360
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+964
ADDRLP4 360
INDIRI4
ASGNI4
line 564
;564:	cgs.media.count1Sound = trap_S_RegisterSound( "sound/feedback/one.wav", qtrue );
ADDRGP4 $309
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 364
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+968
ADDRLP4 364
INDIRI4
ASGNI4
line 565
;565:	cgs.media.countFightSound = trap_S_RegisterSound( "sound/feedback/fight.wav", qtrue );
ADDRGP4 $312
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 368
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+972
ADDRLP4 368
INDIRI4
ASGNI4
line 566
;566:	cgs.media.countPrepareSound = trap_S_RegisterSound( "sound/feedback/prepare.wav", qtrue );
ADDRGP4 $315
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 372
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+976
ADDRLP4 372
INDIRI4
ASGNI4
line 571
;567:#ifdef MISSIONPACK
;568:	cgs.media.countPrepareTeamSound = trap_S_RegisterSound( "sound/feedback/prepare_team.wav", qtrue );
;569:#endif
;570:
;571:	if ( cgs.gametype >= GT_TEAM || cg_buildScript.integer ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
GEI4 $320
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $316
LABELV $320
line 573
;572:
;573:		cgs.media.captureAwardSound = trap_S_RegisterSound( "sound/teamplay/flagcapture_yourteam.wav", qtrue );
ADDRGP4 $323
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 376
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+872
ADDRLP4 376
INDIRI4
ASGNI4
line 574
;574:		cgs.media.redLeadsSound = trap_S_RegisterSound( "sound/feedback/redleads.wav", qtrue );
ADDRGP4 $326
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 380
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+884
ADDRLP4 380
INDIRI4
ASGNI4
line 575
;575:		cgs.media.blueLeadsSound = trap_S_RegisterSound( "sound/feedback/blueleads.wav", qtrue );
ADDRGP4 $329
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 384
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+888
ADDRLP4 384
INDIRI4
ASGNI4
line 576
;576:		cgs.media.teamsTiedSound = trap_S_RegisterSound( "sound/feedback/teamstied.wav", qtrue );
ADDRGP4 $332
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 388
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+892
ADDRLP4 388
INDIRI4
ASGNI4
line 577
;577:		cgs.media.hitTeamSound = trap_S_RegisterSound( "sound/feedback/hit_teammate.wav", qtrue );
ADDRGP4 $335
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 392
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+784
ADDRLP4 392
INDIRI4
ASGNI4
line 579
;578:
;579:		cgs.media.redScoredSound = trap_S_RegisterSound( "sound/teamplay/voc_red_scores.wav", qtrue );
ADDRGP4 $338
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 396
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+876
ADDRLP4 396
INDIRI4
ASGNI4
line 580
;580:		cgs.media.blueScoredSound = trap_S_RegisterSound( "sound/teamplay/voc_blue_scores.wav", qtrue );
ADDRGP4 $341
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 400
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+880
ADDRLP4 400
INDIRI4
ASGNI4
line 582
;581:
;582:		cgs.media.captureYourTeamSound = trap_S_RegisterSound( "sound/teamplay/flagcapture_yourteam.wav", qtrue );
ADDRGP4 $323
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 404
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+896
ADDRLP4 404
INDIRI4
ASGNI4
line 583
;583:		cgs.media.captureOpponentSound = trap_S_RegisterSound( "sound/teamplay/flagcapture_opponent.wav", qtrue );
ADDRGP4 $346
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 408
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+900
ADDRLP4 408
INDIRI4
ASGNI4
line 585
;584:
;585:		cgs.media.returnYourTeamSound = trap_S_RegisterSound( "sound/teamplay/flagreturn_yourteam.wav", qtrue );
ADDRGP4 $349
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 412
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+904
ADDRLP4 412
INDIRI4
ASGNI4
line 586
;586:		cgs.media.returnOpponentSound = trap_S_RegisterSound( "sound/teamplay/flagreturn_opponent.wav", qtrue );
ADDRGP4 $352
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 416
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+908
ADDRLP4 416
INDIRI4
ASGNI4
line 588
;587:
;588:		cgs.media.takenYourTeamSound = trap_S_RegisterSound( "sound/teamplay/flagtaken_yourteam.wav", qtrue );
ADDRGP4 $355
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 420
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+912
ADDRLP4 420
INDIRI4
ASGNI4
line 589
;589:		cgs.media.takenOpponentSound = trap_S_RegisterSound( "sound/teamplay/flagtaken_opponent.wav", qtrue );
ADDRGP4 $358
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 424
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+916
ADDRLP4 424
INDIRI4
ASGNI4
line 591
;590:
;591:		if ( cgs.gametype == GT_CTF || cg_buildScript.integer ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
EQI4 $363
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $359
LABELV $363
line 592
;592:			cgs.media.redFlagReturnedSound = trap_S_RegisterSound( "sound/teamplay/voc_red_returned.wav", qtrue );
ADDRGP4 $366
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 428
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+920
ADDRLP4 428
INDIRI4
ASGNI4
line 593
;593:			cgs.media.blueFlagReturnedSound = trap_S_RegisterSound( "sound/teamplay/voc_blue_returned.wav", qtrue );
ADDRGP4 $369
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 432
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+924
ADDRLP4 432
INDIRI4
ASGNI4
line 594
;594:			cgs.media.enemyTookYourFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_enemy_flag.wav", qtrue );
ADDRGP4 $372
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 436
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+932
ADDRLP4 436
INDIRI4
ASGNI4
line 595
;595:			cgs.media.yourTeamTookEnemyFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_team_flag.wav", qtrue );
ADDRGP4 $375
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 440
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+940
ADDRLP4 440
INDIRI4
ASGNI4
line 596
;596:		}
LABELV $359
line 615
;597:
;598:#ifdef MISSIONPACK
;599:		if ( cgs.gametype == GT_1FCTF || cg_buildScript.integer ) {
;600:			// FIXME: get a replacement for this sound ?
;601:			cgs.media.neutralFlagReturnedSound = trap_S_RegisterSound( "sound/teamplay/flagreturn_opponent.wav", qtrue );
;602:			cgs.media.yourTeamTookTheFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_team_1flag.wav", qtrue );
;603:			cgs.media.enemyTookTheFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_enemy_1flag.wav", qtrue );
;604:		}
;605:
;606:		if ( cgs.gametype == GT_1FCTF || cgs.gametype == GT_CTF || cg_buildScript.integer ) {
;607:			cgs.media.youHaveFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_you_flag.wav", qtrue );
;608:			cgs.media.holyShitSound = trap_S_RegisterSound("sound/feedback/voc_holyshit.wav", qtrue);
;609:		}
;610:
;611:		if ( cgs.gametype == GT_OBELISK || cg_buildScript.integer ) {
;612:			cgs.media.yourBaseIsUnderAttackSound = trap_S_RegisterSound( "sound/teamplay/voc_base_attack.wav", qtrue );
;613:		}
;614:#else
;615:		cgs.media.youHaveFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_you_flag.wav", qtrue );
ADDRGP4 $378
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 428
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+948
ADDRLP4 428
INDIRI4
ASGNI4
line 616
;616:		cgs.media.holyShitSound = trap_S_RegisterSound("sound/feedback/voc_holyshit.wav", qtrue);
ADDRGP4 $381
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 432
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+956
ADDRLP4 432
INDIRI4
ASGNI4
line 617
;617:		cgs.media.neutralFlagReturnedSound = trap_S_RegisterSound( "sound/teamplay/flagreturn_opponent.wav", qtrue );
ADDRGP4 $352
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 436
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+928
ADDRLP4 436
INDIRI4
ASGNI4
line 618
;618:		cgs.media.yourTeamTookTheFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_team_1flag.wav", qtrue );
ADDRGP4 $386
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 440
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+944
ADDRLP4 440
INDIRI4
ASGNI4
line 619
;619:		cgs.media.enemyTookTheFlagSound = trap_S_RegisterSound( "sound/teamplay/voc_enemy_1flag.wav", qtrue );
ADDRGP4 $389
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 444
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+936
ADDRLP4 444
INDIRI4
ASGNI4
line 621
;620:#endif
;621:	}
LABELV $316
line 623
;622:
;623:	cgs.media.tracerSound = trap_S_RegisterSound( "sound/weapons/machinegun/buletby1.wav", qfalse );
ADDRGP4 $392
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 376
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+536
ADDRLP4 376
INDIRI4
ASGNI4
line 624
;624:	cgs.media.selectSound = trap_S_RegisterSound( "sound/weapons/change.wav", qfalse );
ADDRGP4 $395
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 380
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+540
ADDRLP4 380
INDIRI4
ASGNI4
line 625
;625:	cgs.media.wearOffSound = trap_S_RegisterSound( "sound/items/wearoff.wav", qfalse );
ADDRGP4 $398
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 384
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+548
ADDRLP4 384
INDIRI4
ASGNI4
line 626
;626:	cgs.media.useNothingSound = trap_S_RegisterSound( "sound/items/use_nothing.wav", qfalse );
ADDRGP4 $401
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 388
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+544
ADDRLP4 388
INDIRI4
ASGNI4
line 627
;627:	cgs.media.gibSound = trap_S_RegisterSound( "sound/player/gibsplt1.wav", qfalse );
ADDRGP4 $404
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 392
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+700
ADDRLP4 392
INDIRI4
ASGNI4
line 628
;628:	cgs.media.gibBounce1Sound = trap_S_RegisterSound( "sound/player/gibimp1.wav", qfalse );
ADDRGP4 $407
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 396
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+704
ADDRLP4 396
INDIRI4
ASGNI4
line 629
;629:	cgs.media.gibBounce2Sound = trap_S_RegisterSound( "sound/player/gibimp2.wav", qfalse );
ADDRGP4 $410
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 400
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+708
ADDRLP4 400
INDIRI4
ASGNI4
line 630
;630:	cgs.media.gibBounce3Sound = trap_S_RegisterSound( "sound/player/gibimp3.wav", qfalse );
ADDRGP4 $413
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 404
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+712
ADDRLP4 404
INDIRI4
ASGNI4
line 649
;631:
;632:#ifdef MISSIONPACK
;633:	cgs.media.useInvulnerabilitySound = trap_S_RegisterSound( "sound/items/invul_activate.wav", qfalse );
;634:	cgs.media.invulnerabilityImpactSound1 = trap_S_RegisterSound( "sound/items/invul_impact_01.wav", qfalse );
;635:	cgs.media.invulnerabilityImpactSound2 = trap_S_RegisterSound( "sound/items/invul_impact_02.wav", qfalse );
;636:	cgs.media.invulnerabilityImpactSound3 = trap_S_RegisterSound( "sound/items/invul_impact_03.wav", qfalse );
;637:	cgs.media.invulnerabilityJuicedSound = trap_S_RegisterSound( "sound/items/invul_juiced.wav", qfalse );
;638:	cgs.media.obeliskHitSound1 = trap_S_RegisterSound( "sound/items/obelisk_hit_01.wav", qfalse );
;639:	cgs.media.obeliskHitSound2 = trap_S_RegisterSound( "sound/items/obelisk_hit_02.wav", qfalse );
;640:	cgs.media.obeliskHitSound3 = trap_S_RegisterSound( "sound/items/obelisk_hit_03.wav", qfalse );
;641:	cgs.media.obeliskRespawnSound = trap_S_RegisterSound( "sound/items/obelisk_respawn.wav", qfalse );
;642:
;643:	cgs.media.ammoregenSound = trap_S_RegisterSound("sound/items/cl_ammoregen.wav", qfalse);
;644:	cgs.media.doublerSound = trap_S_RegisterSound("sound/items/cl_doubler.wav", qfalse);
;645:	cgs.media.guardSound = trap_S_RegisterSound("sound/items/cl_guard.wav", qfalse);
;646:	cgs.media.scoutSound = trap_S_RegisterSound("sound/items/cl_scout.wav", qfalse);
;647:#endif
;648:
;649:	cgs.media.teleInSound = trap_S_RegisterSound( "sound/world/telein.wav", qfalse );
ADDRGP4 $416
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 408
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+716
ADDRLP4 408
INDIRI4
ASGNI4
line 650
;650:	cgs.media.teleOutSound = trap_S_RegisterSound( "sound/world/teleout.wav", qfalse );
ADDRGP4 $419
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 412
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+720
ADDRLP4 412
INDIRI4
ASGNI4
line 651
;651:	cgs.media.respawnSound = trap_S_RegisterSound( "sound/items/respawn1.wav", qfalse );
ADDRGP4 $422
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 416
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+728
ADDRLP4 416
INDIRI4
ASGNI4
line 653
;652:
;653:	cgs.media.noAmmoSound = trap_S_RegisterSound( "sound/weapons/noammo.wav", qfalse );
ADDRGP4 $425
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 420
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+724
ADDRLP4 420
INDIRI4
ASGNI4
line 655
;654:
;655:	cgs.media.talkSound = trap_S_RegisterSound( "sound/player/talk.wav", qfalse );
ADDRGP4 $428
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 424
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+732
ADDRLP4 424
INDIRI4
ASGNI4
line 656
;656:	cgs.media.landSound = trap_S_RegisterSound( "sound/player/land1.wav", qfalse);
ADDRGP4 $431
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 428
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+736
ADDRLP4 428
INDIRI4
ASGNI4
line 658
;657:
;658:	cgs.media.hitSound = trap_S_RegisterSound( "sound/feedback/hit.wav", qfalse );
ADDRGP4 $434
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 432
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+772
ADDRLP4 432
INDIRI4
ASGNI4
line 664
;659:#ifdef MISSIONPACK
;660:	cgs.media.hitSoundHighArmor = trap_S_RegisterSound( "sound/feedback/hithi.wav", qfalse );
;661:	cgs.media.hitSoundLowArmor = trap_S_RegisterSound( "sound/feedback/hitlo.wav", qfalse );
;662:#endif
;663:
;664:	cgs.media.impressiveSound = trap_S_RegisterSound( "sound/feedback/impressive.wav", qtrue );
ADDRGP4 $437
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 436
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+788
ADDRLP4 436
INDIRI4
ASGNI4
line 665
;665:	cgs.media.excellentSound = trap_S_RegisterSound( "sound/feedback/excellent.wav", qtrue );
ADDRGP4 $440
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 440
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+792
ADDRLP4 440
INDIRI4
ASGNI4
line 666
;666:	cgs.media.deniedSound = trap_S_RegisterSound( "sound/feedback/denied.wav", qtrue );
ADDRGP4 $443
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 444
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+796
ADDRLP4 444
INDIRI4
ASGNI4
line 667
;667:	cgs.media.humiliationSound = trap_S_RegisterSound( "sound/feedback/humiliation.wav", qtrue );
ADDRGP4 $446
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 448
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+800
ADDRLP4 448
INDIRI4
ASGNI4
line 668
;668:	cgs.media.assistSound = trap_S_RegisterSound( "sound/feedback/assist.wav", qtrue );
ADDRGP4 $449
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 452
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+804
ADDRLP4 452
INDIRI4
ASGNI4
line 669
;669:	cgs.media.defendSound = trap_S_RegisterSound( "sound/feedback/defense.wav", qtrue );
ADDRGP4 $452
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 456
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+808
ADDRLP4 456
INDIRI4
ASGNI4
line 676
;670:#ifdef MISSIONPACK
;671:	cgs.media.firstImpressiveSound = trap_S_RegisterSound( "sound/feedback/first_impressive.wav", qtrue );
;672:	cgs.media.firstExcellentSound = trap_S_RegisterSound( "sound/feedback/first_excellent.wav", qtrue );
;673:	cgs.media.firstHumiliationSound = trap_S_RegisterSound( "sound/feedback/first_gauntlet.wav", qtrue );
;674:#endif
;675:
;676:	cgs.media.takenLeadSound = trap_S_RegisterSound( "sound/feedback/takenlead.wav", qtrue);
ADDRGP4 $455
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 460
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+824
ADDRLP4 460
INDIRI4
ASGNI4
line 677
;677:	cgs.media.tiedLeadSound = trap_S_RegisterSound( "sound/feedback/tiedlead.wav", qtrue);
ADDRGP4 $458
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 464
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+828
ADDRLP4 464
INDIRI4
ASGNI4
line 678
;678:	cgs.media.lostLeadSound = trap_S_RegisterSound( "sound/feedback/lostlead.wav", qtrue);
ADDRGP4 $461
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 468
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+832
ADDRLP4 468
INDIRI4
ASGNI4
line 686
;679:
;680:#ifdef MISSIONPACK
;681:	cgs.media.voteNow = trap_S_RegisterSound( "sound/feedback/vote_now.wav", qtrue);
;682:	cgs.media.votePassed = trap_S_RegisterSound( "sound/feedback/vote_passed.wav", qtrue);
;683:	cgs.media.voteFailed = trap_S_RegisterSound( "sound/feedback/vote_failed.wav", qtrue);
;684:#endif
;685:
;686:	cgs.media.watrInSound = trap_S_RegisterSound( "sound/player/watr_in.wav", qfalse);
ADDRGP4 $464
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 472
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+848
ADDRLP4 472
INDIRI4
ASGNI4
line 687
;687:	cgs.media.watrOutSound = trap_S_RegisterSound( "sound/player/watr_out.wav", qfalse);
ADDRGP4 $467
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 476
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+852
ADDRLP4 476
INDIRI4
ASGNI4
line 688
;688:	cgs.media.watrUnSound = trap_S_RegisterSound( "sound/player/watr_un.wav", qfalse);
ADDRGP4 $470
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 480
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+856
ADDRLP4 480
INDIRI4
ASGNI4
line 690
;689:
;690:	cgs.media.jumpPadSound = trap_S_RegisterSound ("sound/world/jumppad.wav", qfalse );
ADDRGP4 $473
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 484
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+744
ADDRLP4 484
INDIRI4
ASGNI4
line 692
;691:
;692:	for (i=0 ; i<4 ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $474
line 693
;693:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/step%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $478
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 694
;694:		cgs.media.footsteps[FOOTSTEP_NORMAL][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 488
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552
ADDP4
ADDRLP4 488
INDIRI4
ASGNI4
line 696
;695:
;696:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/boot%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $481
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 697
;697:		cgs.media.footsteps[FOOTSTEP_BOOT][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 492
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552+16
ADDP4
ADDRLP4 492
INDIRI4
ASGNI4
line 699
;698:
;699:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/flesh%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $485
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 700
;700:		cgs.media.footsteps[FOOTSTEP_FLESH][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 496
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552+32
ADDP4
ADDRLP4 496
INDIRI4
ASGNI4
line 702
;701:
;702:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/mech%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $489
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 703
;703:		cgs.media.footsteps[FOOTSTEP_MECH][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 500
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552+48
ADDP4
ADDRLP4 500
INDIRI4
ASGNI4
line 705
;704:
;705:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/energy%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $493
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 706
;706:		cgs.media.footsteps[FOOTSTEP_ENERGY][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 504
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552+64
ADDP4
ADDRLP4 504
INDIRI4
ASGNI4
line 708
;707:
;708:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/splash%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $497
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 709
;709:		cgs.media.footsteps[FOOTSTEP_SPLASH][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 508
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552+96
ADDP4
ADDRLP4 508
INDIRI4
ASGNI4
line 711
;710:
;711:		Com_sprintf (name, sizeof(name), "sound/player/footsteps/clank%i.wav", i+1);
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 $501
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 712
;712:		cgs.media.footsteps[FOOTSTEP_METAL][i] = trap_S_RegisterSound (name, qfalse);
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 512
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+552+80
ADDP4
ADDRLP4 512
INDIRI4
ASGNI4
line 713
;713:	}
LABELV $475
line 692
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 4
LTI4 $474
line 716
;714:
;715:	// only register the items that the server says we need
;716:	strcpy( items, CG_ConfigString( CS_ITEMS ) );
CNSTI4 27
ARGI4
ADDRLP4 488
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 72
ARGP4
ADDRLP4 488
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 718
;717:
;718:	for ( i = 1 ; i < bg_numItems ; i++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $508
JUMPV
LABELV $505
line 720
;719://		if ( items[ i ] == '1' || cg_buildScript.integer ) {
;720:			CG_RegisterItemSounds( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_RegisterItemSounds
CALLV
pop
line 722
;721://		}
;722:	}
LABELV $506
line 718
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $508
ADDRLP4 0
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $505
line 724
;723:
;724:	for ( i = 1 ; i < MAX_SOUNDS ; i++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $509
line 725
;725:		soundName = CG_ConfigString( CS_SOUNDS+i );
ADDRLP4 0
INDIRI4
CNSTI4 288
ADDI4
ARGI4
ADDRLP4 492
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 68
ADDRLP4 492
INDIRP4
ASGNP4
line 726
;726:		if ( !soundName[0] ) {
ADDRLP4 68
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $513
line 727
;727:			break;
ADDRGP4 $511
JUMPV
LABELV $513
line 729
;728:		}
;729:		if ( soundName[0] == '*' ) {
ADDRLP4 68
INDIRP4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $515
line 730
;730:			continue;	// custom sound
ADDRGP4 $510
JUMPV
LABELV $515
line 732
;731:		}
;732:		cgs.gameSounds[i] = trap_S_RegisterSound( soundName, qfalse );
ADDRLP4 68
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 496
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+35848
ADDP4
ADDRLP4 496
INDIRI4
ASGNI4
line 733
;733:	}
LABELV $510
line 724
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 256
LTI4 $509
LABELV $511
line 736
;734:
;735:	// FIXME: only needed with item
;736:	cgs.media.flightSound = trap_S_RegisterSound( "sound/items/flight.wav", qfalse );
ADDRGP4 $520
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 492
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+860
ADDRLP4 492
INDIRI4
ASGNI4
line 737
;737:	cgs.media.medkitSound = trap_S_RegisterSound ("sound/items/use_medkit.wav", qfalse);
ADDRGP4 $523
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 496
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+864
ADDRLP4 496
INDIRI4
ASGNI4
line 738
;738:	cgs.media.quadSound = trap_S_RegisterSound("sound/items/damage3.wav", qfalse);
ADDRGP4 $526
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 500
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+532
ADDRLP4 500
INDIRI4
ASGNI4
line 739
;739:	cgs.media.sfx_ric1 = trap_S_RegisterSound ("sound/weapons/machinegun/ric1.wav", qfalse);
ADDRGP4 $529
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 504
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+676
ADDRLP4 504
INDIRI4
ASGNI4
line 740
;740:	cgs.media.sfx_ric2 = trap_S_RegisterSound ("sound/weapons/machinegun/ric2.wav", qfalse);
ADDRGP4 $532
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 508
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+680
ADDRLP4 508
INDIRI4
ASGNI4
line 741
;741:	cgs.media.sfx_ric3 = trap_S_RegisterSound ("sound/weapons/machinegun/ric3.wav", qfalse);
ADDRGP4 $535
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 512
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+684
ADDRLP4 512
INDIRI4
ASGNI4
line 742
;742:	cgs.media.sfx_railg = trap_S_RegisterSound ("sound/weapons/railgun/railgf1a.wav", qfalse);
ADDRGP4 $538
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 516
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+688
ADDRLP4 516
INDIRI4
ASGNI4
line 743
;743:	cgs.media.sfx_rockexp = trap_S_RegisterSound ("sound/weapons/rocket/rocklx1a.wav", qfalse);
ADDRGP4 $541
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 520
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+692
ADDRLP4 520
INDIRI4
ASGNI4
line 744
;744:	cgs.media.sfx_plasmaexp = trap_S_RegisterSound ("sound/weapons/plasma/plasmx1a.wav", qfalse);
ADDRGP4 $544
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 524
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+696
ADDRLP4 524
INDIRI4
ASGNI4
line 767
;745:#ifdef MISSIONPACK
;746:	cgs.media.sfx_proxexp = trap_S_RegisterSound( "sound/weapons/proxmine/wstbexpl.wav" , qfalse);
;747:	cgs.media.sfx_nghit = trap_S_RegisterSound( "sound/weapons/nailgun/wnalimpd.wav" , qfalse);
;748:	cgs.media.sfx_nghitflesh = trap_S_RegisterSound( "sound/weapons/nailgun/wnalimpl.wav" , qfalse);
;749:	cgs.media.sfx_nghitmetal = trap_S_RegisterSound( "sound/weapons/nailgun/wnalimpm.wav", qfalse );
;750:	cgs.media.sfx_chghit = trap_S_RegisterSound( "sound/weapons/vulcan/wvulimpd.wav", qfalse );
;751:	cgs.media.sfx_chghitflesh = trap_S_RegisterSound( "sound/weapons/vulcan/wvulimpl.wav", qfalse );
;752:	cgs.media.sfx_chghitmetal = trap_S_RegisterSound( "sound/weapons/vulcan/wvulimpm.wav", qfalse );
;753:	cgs.media.weaponHoverSound = trap_S_RegisterSound( "sound/weapons/weapon_hover.wav", qfalse );
;754:	cgs.media.kamikazeExplodeSound = trap_S_RegisterSound( "sound/items/kam_explode.wav", qfalse );
;755:	cgs.media.kamikazeImplodeSound = trap_S_RegisterSound( "sound/items/kam_implode.wav", qfalse );
;756:	cgs.media.kamikazeFarSound = trap_S_RegisterSound( "sound/items/kam_explode_far.wav", qfalse );
;757:	cgs.media.winnerSound = trap_S_RegisterSound( "sound/feedback/voc_youwin.wav", qfalse );
;758:	cgs.media.loserSound = trap_S_RegisterSound( "sound/feedback/voc_youlose.wav", qfalse );
;759:	cgs.media.youSuckSound = trap_S_RegisterSound( "sound/misc/yousuck.wav", qfalse );
;760:
;761:	cgs.media.wstbimplSound = trap_S_RegisterSound("sound/weapons/proxmine/wstbimpl.wav", qfalse);
;762:	cgs.media.wstbimpmSound = trap_S_RegisterSound("sound/weapons/proxmine/wstbimpm.wav", qfalse);
;763:	cgs.media.wstbimpdSound = trap_S_RegisterSound("sound/weapons/proxmine/wstbimpd.wav", qfalse);
;764:	cgs.media.wstbactvSound = trap_S_RegisterSound("sound/weapons/proxmine/wstbactv.wav", qfalse);
;765:#endif
;766:
;767:	cgs.media.regenSound = trap_S_RegisterSound("sound/items/regen.wav", qfalse);
ADDRGP4 $547
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 528
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+992
ADDRLP4 528
INDIRI4
ASGNI4
line 768
;768:	cgs.media.protectSound = trap_S_RegisterSound("sound/items/protect3.wav", qfalse);
ADDRGP4 $550
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 532
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+996
ADDRLP4 532
INDIRI4
ASGNI4
line 769
;769:	cgs.media.n_healthSound = trap_S_RegisterSound("sound/items/n_health.wav", qfalse );
ADDRGP4 $553
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 536
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+1000
ADDRLP4 536
INDIRI4
ASGNI4
line 770
;770:	cgs.media.hgrenb1aSound = trap_S_RegisterSound("sound/weapons/grenade/hgrenb1a.wav", qfalse);
ADDRGP4 $556
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 540
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+1004
ADDRLP4 540
INDIRI4
ASGNI4
line 771
;771:	cgs.media.hgrenb2aSound = trap_S_RegisterSound("sound/weapons/grenade/hgrenb2a.wav", qfalse);
ADDRGP4 $559
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 544
ADDRGP4 trap_S_RegisterSound
CALLI4
ASGNI4
ADDRGP4 cgs+152340+1008
ADDRLP4 544
INDIRI4
ASGNI4
line 801
;772:
;773:#ifdef MISSIONPACK
;774:	trap_S_RegisterSound("sound/player/james/death1.wav", qfalse );
;775:	trap_S_RegisterSound("sound/player/james/death2.wav", qfalse );
;776:	trap_S_RegisterSound("sound/player/james/death3.wav", qfalse );
;777:	trap_S_RegisterSound("sound/player/james/jump1.wav", qfalse );
;778:	trap_S_RegisterSound("sound/player/james/pain25_1.wav", qfalse );
;779:	trap_S_RegisterSound("sound/player/james/pain75_1.wav", qfalse );
;780:	trap_S_RegisterSound("sound/player/james/pain100_1.wav", qfalse );
;781:	trap_S_RegisterSound("sound/player/james/falling1.wav", qfalse );
;782:	trap_S_RegisterSound("sound/player/james/gasp.wav", qfalse );
;783:	trap_S_RegisterSound("sound/player/james/drown.wav", qfalse );
;784:	trap_S_RegisterSound("sound/player/james/fall1.wav", qfalse );
;785:	trap_S_RegisterSound("sound/player/james/taunt.wav", qfalse );
;786:
;787:	trap_S_RegisterSound("sound/player/janet/death1.wav", qfalse );
;788:	trap_S_RegisterSound("sound/player/janet/death2.wav", qfalse );
;789:	trap_S_RegisterSound("sound/player/janet/death3.wav", qfalse );
;790:	trap_S_RegisterSound("sound/player/janet/jump1.wav", qfalse );
;791:	trap_S_RegisterSound("sound/player/janet/pain25_1.wav", qfalse );
;792:	trap_S_RegisterSound("sound/player/janet/pain75_1.wav", qfalse );
;793:	trap_S_RegisterSound("sound/player/janet/pain100_1.wav", qfalse );
;794:	trap_S_RegisterSound("sound/player/janet/falling1.wav", qfalse );
;795:	trap_S_RegisterSound("sound/player/janet/gasp.wav", qfalse );
;796:	trap_S_RegisterSound("sound/player/janet/drown.wav", qfalse );
;797:	trap_S_RegisterSound("sound/player/janet/fall1.wav", qfalse );
;798:	trap_S_RegisterSound("sound/player/janet/taunt.wav", qfalse );
;799:#endif
;800:
;801:}
LABELV $282
endproc CG_RegisterSounds 548 16
data
align 4
LABELV $561
address $562
address $563
address $564
address $565
address $566
address $567
address $568
address $569
address $570
address $571
address $572
code
proc CG_RegisterGraphics 588 16
line 814
;802:
;803:
;804://===================================================================================
;805:
;806:
;807:/*
;808:=================
;809:CG_RegisterGraphics
;810:
;811:This function may execute for a couple of minutes with a slow disk.
;812:=================
;813:*/
;814:static void CG_RegisterGraphics( void ) {
line 832
;815:	int			i;
;816:	char		items[MAX_ITEMS+1];
;817:	static char		*sb_nums[11] = {
;818:		"gfx/2d/numbers/zero_32b",
;819:		"gfx/2d/numbers/one_32b",
;820:		"gfx/2d/numbers/two_32b",
;821:		"gfx/2d/numbers/three_32b",
;822:		"gfx/2d/numbers/four_32b",
;823:		"gfx/2d/numbers/five_32b",
;824:		"gfx/2d/numbers/six_32b",
;825:		"gfx/2d/numbers/seven_32b",
;826:		"gfx/2d/numbers/eight_32b",
;827:		"gfx/2d/numbers/nine_32b",
;828:		"gfx/2d/numbers/minus_32b",
;829:	};
;830:
;831:	// clear any references to old media
;832:	memset( &cg.refdef, 0, sizeof( cg.refdef ) );
ADDRGP4 cg+109044
ARGP4
CNSTI4 0
ARGI4
CNSTI4 368
ARGI4
ADDRGP4 memset
CALLP4
pop
line 833
;833:	trap_R_ClearScene();
ADDRGP4 trap_R_ClearScene
CALLV
pop
line 835
;834:
;835:	CG_LoadingString( cgs.mapname );
ADDRGP4 cgs+31484
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 837
;836:
;837:	trap_R_LoadWorldMap( cgs.mapname );
ADDRGP4 cgs+31484
ARGP4
ADDRGP4 trap_R_LoadWorldMap
CALLV
pop
line 840
;838:
;839:	// precache status bar pics
;840:	CG_LoadingString( "game media" );
ADDRGP4 $577
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 842
;841:
;842:	for ( i=0 ; i<11 ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $578
line 843
;843:		cgs.media.numberShaders[i] = trap_R_RegisterShader( sb_nums[i] );
ADDRLP4 264
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 264
INDIRI4
ADDRGP4 $561
ADDP4
INDIRP4
ARGP4
ADDRLP4 268
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 264
INDIRI4
ADDRGP4 cgs+152340+300
ADDP4
ADDRLP4 268
INDIRI4
ASGNI4
line 844
;844:	}
LABELV $579
line 842
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 11
LTI4 $578
line 846
;845:
;846:	cgs.media.botSkillShaders[0] = trap_R_RegisterShader( "menu/art/skill1.tga" );
ADDRGP4 $586
ARGP4
ADDRLP4 264
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+348
ADDRLP4 264
INDIRI4
ASGNI4
line 847
;847:	cgs.media.botSkillShaders[1] = trap_R_RegisterShader( "menu/art/skill2.tga" );
ADDRGP4 $590
ARGP4
ADDRLP4 268
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+348+4
ADDRLP4 268
INDIRI4
ASGNI4
line 848
;848:	cgs.media.botSkillShaders[2] = trap_R_RegisterShader( "menu/art/skill3.tga" );
ADDRGP4 $594
ARGP4
ADDRLP4 272
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+348+8
ADDRLP4 272
INDIRI4
ASGNI4
line 849
;849:	cgs.media.botSkillShaders[3] = trap_R_RegisterShader( "menu/art/skill4.tga" );
ADDRGP4 $598
ARGP4
ADDRLP4 276
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+348+12
ADDRLP4 276
INDIRI4
ASGNI4
line 850
;850:	cgs.media.botSkillShaders[4] = trap_R_RegisterShader( "menu/art/skill5.tga" );
ADDRGP4 $602
ARGP4
ADDRLP4 280
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+348+16
ADDRLP4 280
INDIRI4
ASGNI4
line 852
;851:
;852:	cgs.media.viewBloodShader = trap_R_RegisterShader( "viewBloodBlend" );
ADDRGP4 $605
ARGP4
ADDRLP4 284
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+216
ADDRLP4 284
INDIRI4
ASGNI4
line 854
;853:
;854:	cgs.media.deferShader = trap_R_RegisterShaderNoMip( "gfx/2d/defer.tga" );
ADDRGP4 $608
ARGP4
ADDRLP4 288
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+132
ADDRLP4 288
INDIRI4
ASGNI4
line 856
;855:
;856:	cgs.media.scoreboardName = trap_R_RegisterShaderNoMip( "menu/tab/name.tga" );
ADDRGP4 $611
ARGP4
ADDRLP4 292
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+488
ADDRLP4 292
INDIRI4
ASGNI4
line 857
;857:	cgs.media.scoreboardPing = trap_R_RegisterShaderNoMip( "menu/tab/ping.tga" );
ADDRGP4 $614
ARGP4
ADDRLP4 296
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+492
ADDRLP4 296
INDIRI4
ASGNI4
line 858
;858:	cgs.media.scoreboardScore = trap_R_RegisterShaderNoMip( "menu/tab/score.tga" );
ADDRGP4 $617
ARGP4
ADDRLP4 300
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+496
ADDRLP4 300
INDIRI4
ASGNI4
line 859
;859:	cgs.media.scoreboardTime = trap_R_RegisterShaderNoMip( "menu/tab/time.tga" );
ADDRGP4 $620
ARGP4
ADDRLP4 304
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+500
ADDRLP4 304
INDIRI4
ASGNI4
line 861
;860:
;861:	cgs.media.smokePuffShader = trap_R_RegisterShader( "smokePuff" );
ADDRGP4 $623
ARGP4
ADDRLP4 308
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+276
ADDRLP4 308
INDIRI4
ASGNI4
line 862
;862:	cgs.media.smokePuffRageProShader = trap_R_RegisterShader( "smokePuffRagePro" );
ADDRGP4 $626
ARGP4
ADDRLP4 312
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+280
ADDRLP4 312
INDIRI4
ASGNI4
line 863
;863:	cgs.media.shotgunSmokePuffShader = trap_R_RegisterShader( "shotgunSmokePuff" );
ADDRGP4 $629
ARGP4
ADDRLP4 316
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+284
ADDRLP4 316
INDIRI4
ASGNI4
line 868
;864:#ifdef MISSIONPACK
;865:	cgs.media.nailPuffShader = trap_R_RegisterShader( "nailtrail" );
;866:	cgs.media.blueProxMine = trap_R_RegisterModel( "models/weaphits/proxmineb.md3" );
;867:#endif
;868:	cgs.media.plasmaBallShader = trap_R_RegisterShader( "sprites/plasma1" );
ADDRGP4 $632
ARGP4
ADDRLP4 320
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+288
ADDRLP4 320
INDIRI4
ASGNI4
line 869
;869:	cgs.media.bloodTrailShader = trap_R_RegisterShader( "bloodTrail" );
ADDRGP4 $635
ARGP4
ADDRLP4 324
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+296
ADDRLP4 324
INDIRI4
ASGNI4
line 870
;870:	cgs.media.lagometerShader = trap_R_RegisterShader("lagometer" );
ADDRGP4 $638
ARGP4
ADDRLP4 328
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+264
ADDRLP4 328
INDIRI4
ASGNI4
line 871
;871:	cgs.media.connectionShader = trap_R_RegisterShader( "disconnected" );
ADDRGP4 $641
ARGP4
ADDRLP4 332
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+208
ADDRLP4 332
INDIRI4
ASGNI4
line 873
;872:
;873:	cgs.media.waterBubbleShader = trap_R_RegisterShader( "waterBubble" );
ADDRGP4 $644
ARGP4
ADDRLP4 336
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+292
ADDRLP4 336
INDIRI4
ASGNI4
line 875
;874:
;875:	cgs.media.tracerShader = trap_R_RegisterShader( "gfx/misc/tracer" );
ADDRGP4 $647
ARGP4
ADDRLP4 340
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+220
ADDRLP4 340
INDIRI4
ASGNI4
line 876
;876:	cgs.media.selectShader = trap_R_RegisterShader( "gfx/2d/select" );
ADDRGP4 $650
ARGP4
ADDRLP4 344
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+212
ADDRLP4 344
INDIRI4
ASGNI4
line 878
;877:
;878:	for ( i = 0 ; i < NUM_CROSSHAIRS ; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $651
line 879
;879:		cgs.media.crosshairShader[i] = trap_R_RegisterShader( va("gfx/2d/crosshair%c", 'a'+i) );
ADDRGP4 $657
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 97
ADDI4
ARGI4
ADDRLP4 352
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 352
INDIRP4
ARGP4
ADDRLP4 356
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+152340+224
ADDP4
ADDRLP4 356
INDIRI4
ASGNI4
line 880
;880:	}
LABELV $652
line 878
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 10
LTI4 $651
line 882
;881:
;882:	cgs.media.backTileShader = trap_R_RegisterShader( "gfx/2d/backtile" );
ADDRGP4 $660
ARGP4
ADDRLP4 348
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+268
ADDRLP4 348
INDIRI4
ASGNI4
line 883
;883:	cgs.media.noammoShader = trap_R_RegisterShader( "icons/noammo" );
ADDRGP4 $663
ARGP4
ADDRLP4 352
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+272
ADDRLP4 352
INDIRI4
ASGNI4
line 886
;884:
;885:	// powerup shaders
;886:	cgs.media.quadShader = trap_R_RegisterShader("powerups/quad" );
ADDRGP4 $666
ARGP4
ADDRLP4 356
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+392
ADDRLP4 356
INDIRI4
ASGNI4
line 887
;887:	cgs.media.quadWeaponShader = trap_R_RegisterShader("powerups/quadWeapon" );
ADDRGP4 $669
ARGP4
ADDRLP4 360
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+400
ADDRLP4 360
INDIRI4
ASGNI4
line 888
;888:	cgs.media.battleSuitShader = trap_R_RegisterShader("powerups/battleSuit" );
ADDRGP4 $672
ARGP4
ADDRLP4 364
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+412
ADDRLP4 364
INDIRI4
ASGNI4
line 889
;889:	cgs.media.battleWeaponShader = trap_R_RegisterShader("powerups/battleWeapon" );
ADDRGP4 $675
ARGP4
ADDRLP4 368
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+416
ADDRLP4 368
INDIRI4
ASGNI4
line 890
;890:	cgs.media.invisShader = trap_R_RegisterShader("powerups/invisibility" );
ADDRGP4 $678
ARGP4
ADDRLP4 372
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+404
ADDRLP4 372
INDIRI4
ASGNI4
line 891
;891:	cgs.media.regenShader = trap_R_RegisterShader("powerups/regen" );
ADDRGP4 $681
ARGP4
ADDRLP4 376
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+408
ADDRLP4 376
INDIRI4
ASGNI4
line 892
;892:	cgs.media.hastePuffShader = trap_R_RegisterShader("hasteSmokePuff" );
ADDRGP4 $684
ARGP4
ADDRLP4 380
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+420
ADDRLP4 380
INDIRI4
ASGNI4
line 897
;893:
;894:#ifdef MISSIONPACK
;895:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF || cgs.gametype == GT_HARVESTER || cg_buildScript.integer ) {
;896:#else
;897:	if ( cgs.gametype == GT_CTF || cg_buildScript.integer ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
EQI4 $689
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $685
LABELV $689
line 899
;898:#endif
;899:		cgs.media.redCubeModel = trap_R_RegisterModel( "models/powerups/orb/r_orb.md3" );
ADDRGP4 $692
ARGP4
ADDRLP4 384
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+20
ADDRLP4 384
INDIRI4
ASGNI4
line 900
;900:		cgs.media.blueCubeModel = trap_R_RegisterModel( "models/powerups/orb/b_orb.md3" );
ADDRGP4 $695
ARGP4
ADDRLP4 388
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+24
ADDRLP4 388
INDIRI4
ASGNI4
line 901
;901:		cgs.media.redCubeIcon = trap_R_RegisterShader( "icons/skull_red" );
ADDRGP4 $698
ARGP4
ADDRLP4 392
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+28
ADDRLP4 392
INDIRI4
ASGNI4
line 902
;902:		cgs.media.blueCubeIcon = trap_R_RegisterShader( "icons/skull_blue" );
ADDRGP4 $701
ARGP4
ADDRLP4 396
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+32
ADDRLP4 396
INDIRI4
ASGNI4
line 903
;903:	}
LABELV $685
line 908
;904:
;905:#ifdef MISSIONPACK
;906:	if ( cgs.gametype == GT_CTF || cgs.gametype == GT_1FCTF || cgs.gametype == GT_HARVESTER || cg_buildScript.integer ) {
;907:#else
;908:	if ( cgs.gametype == GT_CTF || cg_buildScript.integer ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 4
EQI4 $706
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $702
LABELV $706
line 910
;909:#endif
;910:		cgs.media.redFlagModel = trap_R_RegisterModel( "models/flags/r_flag.md3" );
ADDRGP4 $709
ARGP4
ADDRLP4 384
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+36
ADDRLP4 384
INDIRI4
ASGNI4
line 911
;911:		cgs.media.blueFlagModel = trap_R_RegisterModel( "models/flags/b_flag.md3" );
ADDRGP4 $712
ARGP4
ADDRLP4 388
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+40
ADDRLP4 388
INDIRI4
ASGNI4
line 912
;912:		cgs.media.redFlagShader[0] = trap_R_RegisterShaderNoMip( "icons/iconf_red1" );
ADDRGP4 $715
ARGP4
ADDRLP4 392
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+48
ADDRLP4 392
INDIRI4
ASGNI4
line 913
;913:		cgs.media.redFlagShader[1] = trap_R_RegisterShaderNoMip( "icons/iconf_red2" );
ADDRGP4 $719
ARGP4
ADDRLP4 396
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+48+4
ADDRLP4 396
INDIRI4
ASGNI4
line 914
;914:		cgs.media.redFlagShader[2] = trap_R_RegisterShaderNoMip( "icons/iconf_red3" );
ADDRGP4 $723
ARGP4
ADDRLP4 400
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+48+8
ADDRLP4 400
INDIRI4
ASGNI4
line 915
;915:		cgs.media.blueFlagShader[0] = trap_R_RegisterShaderNoMip( "icons/iconf_blu1" );
ADDRGP4 $726
ARGP4
ADDRLP4 404
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+60
ADDRLP4 404
INDIRI4
ASGNI4
line 916
;916:		cgs.media.blueFlagShader[1] = trap_R_RegisterShaderNoMip( "icons/iconf_blu2" );
ADDRGP4 $730
ARGP4
ADDRLP4 408
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+60+4
ADDRLP4 408
INDIRI4
ASGNI4
line 917
;917:		cgs.media.blueFlagShader[2] = trap_R_RegisterShaderNoMip( "icons/iconf_blu3" );
ADDRGP4 $734
ARGP4
ADDRLP4 412
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+60+8
ADDRLP4 412
INDIRI4
ASGNI4
line 930
;918:#ifdef MISSIONPACK
;919:		cgs.media.flagPoleModel = trap_R_RegisterModel( "models/flag2/flagpole.md3" );
;920:		cgs.media.flagFlapModel = trap_R_RegisterModel( "models/flag2/flagflap3.md3" );
;921:
;922:		cgs.media.redFlagFlapSkin = trap_R_RegisterSkin( "models/flag2/red.skin" );
;923:		cgs.media.blueFlagFlapSkin = trap_R_RegisterSkin( "models/flag2/blue.skin" );
;924:		cgs.media.neutralFlagFlapSkin = trap_R_RegisterSkin( "models/flag2/white.skin" );
;925:
;926:		cgs.media.redFlagBaseModel = trap_R_RegisterModel( "models/mapobjects/flagbase/red_base.md3" );
;927:		cgs.media.blueFlagBaseModel = trap_R_RegisterModel( "models/mapobjects/flagbase/blue_base.md3" );
;928:		cgs.media.neutralFlagBaseModel = trap_R_RegisterModel( "models/mapobjects/flagbase/ntrl_base.md3" );
;929:#endif
;930:	}
LABELV $702
line 959
;931:
;932:#ifdef MISSIONPACK
;933:	if ( cgs.gametype == GT_1FCTF || cg_buildScript.integer ) {
;934:		cgs.media.neutralFlagModel = trap_R_RegisterModel( "models/flags/n_flag.md3" );
;935:		cgs.media.flagShader[0] = trap_R_RegisterShaderNoMip( "icons/iconf_neutral1" );
;936:		cgs.media.flagShader[1] = trap_R_RegisterShaderNoMip( "icons/iconf_red2" );
;937:		cgs.media.flagShader[2] = trap_R_RegisterShaderNoMip( "icons/iconf_blu2" );
;938:		cgs.media.flagShader[3] = trap_R_RegisterShaderNoMip( "icons/iconf_neutral3" );
;939:	}
;940:
;941:	if ( cgs.gametype == GT_OBELISK || cg_buildScript.integer ) {
;942:		cgs.media.overloadBaseModel = trap_R_RegisterModel( "models/powerups/overload_base.md3" );
;943:		cgs.media.overloadTargetModel = trap_R_RegisterModel( "models/powerups/overload_target.md3" );
;944:		cgs.media.overloadLightsModel = trap_R_RegisterModel( "models/powerups/overload_lights.md3" );
;945:		cgs.media.overloadEnergyModel = trap_R_RegisterModel( "models/powerups/overload_energy.md3" );
;946:	}
;947:
;948:	if ( cgs.gametype == GT_HARVESTER || cg_buildScript.integer ) {
;949:		cgs.media.harvesterModel = trap_R_RegisterModel( "models/powerups/harvester/harvester.md3" );
;950:		cgs.media.harvesterRedSkin = trap_R_RegisterSkin( "models/powerups/harvester/red.skin" );
;951:		cgs.media.harvesterBlueSkin = trap_R_RegisterSkin( "models/powerups/harvester/blue.skin" );
;952:		cgs.media.harvesterNeutralModel = trap_R_RegisterModel( "models/powerups/obelisk/obelisk.md3" );
;953:	}
;954:
;955:	cgs.media.redKamikazeShader = trap_R_RegisterShader( "models/weaphits/kamikred" );
;956:	cgs.media.dustPuffShader = trap_R_RegisterShader("hasteSmokePuff" );
;957:#endif
;958:
;959:	if ( cgs.gametype >= GT_TEAM || cg_buildScript.integer ) {
ADDRGP4 cgs+31456
INDIRI4
CNSTI4 3
GEI4 $739
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $735
LABELV $739
line 960
;960:		cgs.media.friendShader = trap_R_RegisterShader( "sprites/foe" );
ADDRGP4 $742
ARGP4
ADDRLP4 384
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+200
ADDRLP4 384
INDIRI4
ASGNI4
line 961
;961:		cgs.media.redQuadShader = trap_R_RegisterShader("powerups/blueflag" );
ADDRGP4 $745
ARGP4
ADDRLP4 388
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+396
ADDRLP4 388
INDIRI4
ASGNI4
line 962
;962:		cgs.media.teamStatusBar = trap_R_RegisterShader( "gfx/2d/colorbar.tga" );
ADDRGP4 $748
ARGP4
ADDRLP4 392
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+128
ADDRLP4 392
INDIRI4
ASGNI4
line 966
;963:#ifdef MISSIONPACK
;964:		cgs.media.blueKamikazeShader = trap_R_RegisterShader( "models/weaphits/kamikblu" );
;965:#endif
;966:	}
LABELV $735
line 968
;967:
;968:	cgs.media.armorModel = trap_R_RegisterModel( "models/powerups/armor/armor_yel.md3" );
ADDRGP4 $751
ARGP4
ADDRLP4 384
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+120
ADDRLP4 384
INDIRI4
ASGNI4
line 969
;969:	cgs.media.armorIcon  = trap_R_RegisterShaderNoMip( "icons/iconr_yellow" );
ADDRGP4 $754
ARGP4
ADDRLP4 388
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+124
ADDRLP4 388
INDIRI4
ASGNI4
line 971
;970:
;971:	cgs.media.machinegunBrassModel = trap_R_RegisterModel( "models/weapons2/shells/m_shell.md3" );
ADDRGP4 $757
ARGP4
ADDRLP4 392
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+180
ADDRLP4 392
INDIRI4
ASGNI4
line 972
;972:	cgs.media.shotgunBrassModel = trap_R_RegisterModel( "models/weapons2/shells/s_shell.md3" );
ADDRGP4 $760
ARGP4
ADDRLP4 396
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+184
ADDRLP4 396
INDIRI4
ASGNI4
line 974
;973:
;974:	cgs.media.gibAbdomen = trap_R_RegisterModel( "models/gibs/abdomen.md3" );
ADDRGP4 $763
ARGP4
ADDRLP4 400
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+136
ADDRLP4 400
INDIRI4
ASGNI4
line 975
;975:	cgs.media.gibArm = trap_R_RegisterModel( "models/gibs/arm.md3" );
ADDRGP4 $766
ARGP4
ADDRLP4 404
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+140
ADDRLP4 404
INDIRI4
ASGNI4
line 976
;976:	cgs.media.gibChest = trap_R_RegisterModel( "models/gibs/chest.md3" );
ADDRGP4 $769
ARGP4
ADDRLP4 408
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+144
ADDRLP4 408
INDIRI4
ASGNI4
line 977
;977:	cgs.media.gibFist = trap_R_RegisterModel( "models/gibs/fist.md3" );
ADDRGP4 $772
ARGP4
ADDRLP4 412
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+148
ADDRLP4 412
INDIRI4
ASGNI4
line 978
;978:	cgs.media.gibFoot = trap_R_RegisterModel( "models/gibs/foot.md3" );
ADDRGP4 $775
ARGP4
ADDRLP4 416
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+152
ADDRLP4 416
INDIRI4
ASGNI4
line 979
;979:	cgs.media.gibForearm = trap_R_RegisterModel( "models/gibs/forearm.md3" );
ADDRGP4 $778
ARGP4
ADDRLP4 420
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+156
ADDRLP4 420
INDIRI4
ASGNI4
line 980
;980:	cgs.media.gibIntestine = trap_R_RegisterModel( "models/gibs/intestine.md3" );
ADDRGP4 $781
ARGP4
ADDRLP4 424
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+160
ADDRLP4 424
INDIRI4
ASGNI4
line 981
;981:	cgs.media.gibLeg = trap_R_RegisterModel( "models/gibs/leg.md3" );
ADDRGP4 $784
ARGP4
ADDRLP4 428
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+164
ADDRLP4 428
INDIRI4
ASGNI4
line 982
;982:	cgs.media.gibSkull = trap_R_RegisterModel( "models/gibs/skull.md3" );
ADDRGP4 $787
ARGP4
ADDRLP4 432
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+168
ADDRLP4 432
INDIRI4
ASGNI4
line 983
;983:	cgs.media.gibBrain = trap_R_RegisterModel( "models/gibs/brain.md3" );
ADDRGP4 $790
ARGP4
ADDRLP4 436
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+172
ADDRLP4 436
INDIRI4
ASGNI4
line 985
;984:
;985:	cgs.media.smoke2 = trap_R_RegisterModel( "models/weapons2/shells/s_shell.md3" );
ADDRGP4 $760
ARGP4
ADDRLP4 440
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+176
ADDRLP4 440
INDIRI4
ASGNI4
line 987
;986:
;987:	cgs.media.balloonShader = trap_R_RegisterShader( "sprites/balloon3" );
ADDRGP4 $795
ARGP4
ADDRLP4 444
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+204
ADDRLP4 444
INDIRI4
ASGNI4
line 989
;988:
;989:	cgs.media.bloodExplosionShader = trap_R_RegisterShader( "bloodExplosion" );
ADDRGP4 $798
ARGP4
ADDRLP4 448
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+472
ADDRLP4 448
INDIRI4
ASGNI4
line 991
;990:
;991:	cgs.media.bulletFlashModel = trap_R_RegisterModel("models/weaphits/bullet.md3");
ADDRGP4 $801
ARGP4
ADDRLP4 452
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+432
ADDRLP4 452
INDIRI4
ASGNI4
line 992
;992:	cgs.media.ringFlashModel = trap_R_RegisterModel("models/weaphits/ring02.md3");
ADDRGP4 $804
ARGP4
ADDRLP4 456
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+436
ADDRLP4 456
INDIRI4
ASGNI4
line 993
;993:	cgs.media.dishFlashModel = trap_R_RegisterModel("models/weaphits/boom01.md3");
ADDRGP4 $807
ARGP4
ADDRLP4 460
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+440
ADDRLP4 460
INDIRI4
ASGNI4
line 997
;994:#ifdef MISSIONPACK
;995:	cgs.media.teleportEffectModel = trap_R_RegisterModel( "models/powerups/pop.md3" );
;996:#else
;997:	cgs.media.teleportEffectModel = trap_R_RegisterModel( "models/misc/telep.md3" );
ADDRGP4 $810
ARGP4
ADDRLP4 464
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+476
ADDRLP4 464
INDIRI4
ASGNI4
line 998
;998:	cgs.media.teleportEffectShader = trap_R_RegisterShader( "teleportEffect" );
ADDRGP4 $813
ARGP4
ADDRLP4 468
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+480
ADDRLP4 468
INDIRI4
ASGNI4
line 1016
;999:#endif
;1000:#ifdef MISSIONPACK
;1001:	cgs.media.kamikazeEffectModel = trap_R_RegisterModel( "models/weaphits/kamboom2.md3" );
;1002:	cgs.media.kamikazeShockWave = trap_R_RegisterModel( "models/weaphits/kamwave.md3" );
;1003:	cgs.media.kamikazeHeadModel = trap_R_RegisterModel( "models/powerups/kamikazi.md3" );
;1004:	cgs.media.kamikazeHeadTrail = trap_R_RegisterModel( "models/powerups/trailtest.md3" );
;1005:	cgs.media.guardPowerupModel = trap_R_RegisterModel( "models/powerups/guard_player.md3" );
;1006:	cgs.media.scoutPowerupModel = trap_R_RegisterModel( "models/powerups/scout_player.md3" );
;1007:	cgs.media.doublerPowerupModel = trap_R_RegisterModel( "models/powerups/doubler_player.md3" );
;1008:	cgs.media.ammoRegenPowerupModel = trap_R_RegisterModel( "models/powerups/ammo_player.md3" );
;1009:	cgs.media.invulnerabilityImpactModel = trap_R_RegisterModel( "models/powerups/shield/impact.md3" );
;1010:	cgs.media.invulnerabilityJuicedModel = trap_R_RegisterModel( "models/powerups/shield/juicer.md3" );
;1011:	cgs.media.medkitUsageModel = trap_R_RegisterModel( "models/powerups/regen.md3" );
;1012:	cgs.media.heartShader = trap_R_RegisterShaderNoMip( "ui/assets/statusbar/selectedhealth.tga" );
;1013:
;1014:#endif
;1015:
;1016:	cgs.media.invulnerabilityPowerupModel = trap_R_RegisterModel( "models/powerups/shield/shield.md3" );
ADDRGP4 $816
ARGP4
ADDRLP4 472
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRGP4 cgs+152340+484
ADDRLP4 472
INDIRI4
ASGNI4
line 1017
;1017:	cgs.media.medalImpressive = trap_R_RegisterShaderNoMip( "medal_impressive" );
ADDRGP4 $819
ARGP4
ADDRLP4 476
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+504
ADDRLP4 476
INDIRI4
ASGNI4
line 1018
;1018:	cgs.media.medalExcellent = trap_R_RegisterShaderNoMip( "medal_excellent" );
ADDRGP4 $822
ARGP4
ADDRLP4 480
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+508
ADDRLP4 480
INDIRI4
ASGNI4
line 1019
;1019:	cgs.media.medalGauntlet = trap_R_RegisterShaderNoMip( "medal_gauntlet" );
ADDRGP4 $825
ARGP4
ADDRLP4 484
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+512
ADDRLP4 484
INDIRI4
ASGNI4
line 1020
;1020:	cgs.media.medalDefend = trap_R_RegisterShaderNoMip( "medal_defend" );
ADDRGP4 $828
ARGP4
ADDRLP4 488
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+516
ADDRLP4 488
INDIRI4
ASGNI4
line 1021
;1021:	cgs.media.medalAssist = trap_R_RegisterShaderNoMip( "medal_assist" );
ADDRGP4 $831
ARGP4
ADDRLP4 492
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+520
ADDRLP4 492
INDIRI4
ASGNI4
line 1022
;1022:	cgs.media.medalCapture = trap_R_RegisterShaderNoMip( "medal_capture" );
ADDRGP4 $834
ARGP4
ADDRLP4 496
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+524
ADDRLP4 496
INDIRI4
ASGNI4
line 1025
;1023:
;1024:
;1025:	memset( cg_items, 0, sizeof( cg_items ) );
ADDRGP4 cg_items
ARGP4
CNSTI4 0
ARGI4
CNSTI4 6144
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1026
;1026:	memset( cg_weapons, 0, sizeof( cg_weapons ) );
ADDRGP4 cg_weapons
ARGP4
CNSTI4 0
ARGI4
CNSTI4 2176
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1029
;1027:
;1028:	// only register the items that the server says we need
;1029:	strcpy( items, CG_ConfigString( CS_ITEMS) );
CNSTI4 27
ARGI4
ADDRLP4 500
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
ARGP4
ADDRLP4 500
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1031
;1030:
;1031:	for ( i = 1 ; i < bg_numItems ; i++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $838
JUMPV
LABELV $835
line 1032
;1032:		if ( items[ i ] == '1' || cg_buildScript.integer ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
ADDP4
INDIRI1
CVII4 1
CNSTI4 49
EQI4 $842
ADDRGP4 cg_buildScript+12
INDIRI4
CNSTI4 0
EQI4 $839
LABELV $842
line 1033
;1033:			CG_LoadingItem( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_LoadingItem
CALLV
pop
line 1034
;1034:			CG_RegisterItemVisuals( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_RegisterItemVisuals
CALLV
pop
line 1035
;1035:		}
LABELV $839
line 1036
;1036:	}
LABELV $836
line 1031
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $838
ADDRLP4 0
INDIRI4
ADDRGP4 bg_numItems
INDIRI4
LTI4 $835
line 1039
;1037:
;1038:	// wall marks
;1039:	cgs.media.bulletMarkShader = trap_R_RegisterShader( "gfx/damage/bullet_mrk" );
ADDRGP4 $845
ARGP4
ADDRLP4 504
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+376
ADDRLP4 504
INDIRI4
ASGNI4
line 1040
;1040:	cgs.media.burnMarkShader = trap_R_RegisterShader( "gfx/damage/burn_med_mrk" );
ADDRGP4 $848
ARGP4
ADDRLP4 508
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+380
ADDRLP4 508
INDIRI4
ASGNI4
line 1041
;1041:	cgs.media.holeMarkShader = trap_R_RegisterShader( "gfx/damage/hole_lg_mrk" );
ADDRGP4 $851
ARGP4
ADDRLP4 512
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+384
ADDRLP4 512
INDIRI4
ASGNI4
line 1042
;1042:	cgs.media.energyMarkShader = trap_R_RegisterShader( "gfx/damage/plasma_mrk" );
ADDRGP4 $854
ARGP4
ADDRLP4 516
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+388
ADDRLP4 516
INDIRI4
ASGNI4
line 1043
;1043:	cgs.media.shadowMarkShader = trap_R_RegisterShader( "markShadow" );
ADDRGP4 $857
ARGP4
ADDRLP4 520
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+344
ADDRLP4 520
INDIRI4
ASGNI4
line 1044
;1044:	cgs.media.wakeMarkShader = trap_R_RegisterShader( "wake" );
ADDRGP4 $860
ARGP4
ADDRLP4 524
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+368
ADDRLP4 524
INDIRI4
ASGNI4
line 1045
;1045:	cgs.media.bloodMarkShader = trap_R_RegisterShader( "bloodMark" );
ADDRGP4 $863
ARGP4
ADDRLP4 528
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+372
ADDRLP4 528
INDIRI4
ASGNI4
line 1048
;1046:
;1047:	// register the inline models
;1048:	cgs.numInlineModels = trap_CM_NumInlineModels();
ADDRLP4 532
ADDRGP4 trap_CM_NumInlineModels
CALLI4
ASGNI4
ADDRGP4 cgs+36872
ADDRLP4 532
INDIRI4
ASGNI4
line 1049
;1049:	for ( i = 1 ; i < cgs.numInlineModels ; i++ ) {
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $868
JUMPV
LABELV $865
line 1054
;1050:		char	name[10];
;1051:		vec3_t			mins, maxs;
;1052:		int				j;
;1053:
;1054:		Com_sprintf( name, sizeof(name), "*%i", i );
ADDRLP4 564
ARGP4
CNSTI4 10
ARGI4
ADDRGP4 $870
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 1055
;1055:		cgs.inlineDrawModel[i] = trap_R_RegisterModel( name );
ADDRLP4 564
ARGP4
ADDRLP4 576
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+36876
ADDP4
ADDRLP4 576
INDIRI4
ASGNI4
line 1056
;1056:		trap_R_ModelBounds( cgs.inlineDrawModel[i], mins, maxs );
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+36876
ADDP4
INDIRI4
ARGI4
ADDRLP4 540
ARGP4
ADDRLP4 552
ARGP4
ADDRGP4 trap_R_ModelBounds
CALLV
pop
line 1057
;1057:		for ( j = 0 ; j < 3 ; j++ ) {
ADDRLP4 536
CNSTI4 0
ASGNI4
LABELV $873
line 1058
;1058:			cgs.inlineModelMidpoints[i][j] = mins[j] + 0.5 * ( maxs[j] - mins[j] );
ADDRLP4 580
ADDRLP4 536
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 584
ADDRLP4 580
INDIRI4
ADDRLP4 540
ADDP4
INDIRF4
ASGNF4
ADDRLP4 580
INDIRI4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cgs+37900
ADDP4
ADDP4
ADDRLP4 584
INDIRF4
CNSTF4 1056964608
ADDRLP4 580
INDIRI4
ADDRLP4 552
ADDP4
INDIRF4
ADDRLP4 584
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 1059
;1059:		}
LABELV $874
line 1057
ADDRLP4 536
ADDRLP4 536
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 536
INDIRI4
CNSTI4 3
LTI4 $873
line 1060
;1060:	}
LABELV $866
line 1049
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $868
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+36872
INDIRI4
LTI4 $865
line 1063
;1061:
;1062:	// register all the server specified models
;1063:	for (i=1 ; i<MAX_MODELS ; i++) {
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $878
line 1066
;1064:		const char		*modelName;
;1065:
;1066:		modelName = CG_ConfigString( CS_MODELS+i );
ADDRLP4 0
INDIRI4
CNSTI4 32
ADDI4
ARGI4
ADDRLP4 540
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 536
ADDRLP4 540
INDIRP4
ASGNP4
line 1067
;1067:		if ( !modelName[0] ) {
ADDRLP4 536
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $882
line 1068
;1068:			break;
ADDRGP4 $880
JUMPV
LABELV $882
line 1070
;1069:		}
;1070:		cgs.gameModels[i] = trap_R_RegisterModel( modelName );
ADDRLP4 536
INDIRP4
ARGP4
ADDRLP4 544
ADDRGP4 trap_R_RegisterModel
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+34824
ADDP4
ADDRLP4 544
INDIRI4
ASGNI4
line 1071
;1071:	}
LABELV $879
line 1063
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 256
LTI4 $878
LABELV $880
line 1099
;1072:
;1073:#ifdef MISSIONPACK
;1074:	// new stuff
;1075:	cgs.media.patrolShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/patrol.tga");
;1076:	cgs.media.assaultShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/assault.tga");
;1077:	cgs.media.campShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/camp.tga");
;1078:	cgs.media.followShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/follow.tga");
;1079:	cgs.media.defendShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/defend.tga");
;1080:	cgs.media.teamLeaderShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/team_leader.tga");
;1081:	cgs.media.retrieveShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/retrieve.tga");
;1082:	cgs.media.escortShader = trap_R_RegisterShaderNoMip("ui/assets/statusbar/escort.tga");
;1083:	cgs.media.cursor = trap_R_RegisterShaderNoMip( "menu/art/3_cursor2" );
;1084:	cgs.media.sizeCursor = trap_R_RegisterShaderNoMip( "ui/assets/sizecursor.tga" );
;1085:	cgs.media.selectCursor = trap_R_RegisterShaderNoMip( "ui/assets/selectcursor.tga" );
;1086:	cgs.media.flagShaders[0] = trap_R_RegisterShaderNoMip("ui/assets/statusbar/flag_in_base.tga");
;1087:	cgs.media.flagShaders[1] = trap_R_RegisterShaderNoMip("ui/assets/statusbar/flag_capture.tga");
;1088:	cgs.media.flagShaders[2] = trap_R_RegisterShaderNoMip("ui/assets/statusbar/flag_missing.tga");
;1089:
;1090:	trap_R_RegisterModel( "models/players/james/lower.md3" );
;1091:	trap_R_RegisterModel( "models/players/james/upper.md3" );
;1092:	trap_R_RegisterModel( "models/players/heads/james/james.md3" );
;1093:
;1094:	trap_R_RegisterModel( "models/players/janet/lower.md3" );
;1095:	trap_R_RegisterModel( "models/players/janet/upper.md3" );
;1096:	trap_R_RegisterModel( "models/players/heads/janet/janet.md3" );
;1097:
;1098:#endif
;1099:	CG_ClearParticles ();
ADDRGP4 CG_ClearParticles
CALLV
pop
line 1112
;1100:/*
;1101:	for (i=1; i<MAX_PARTICLES_AREAS; i++)
;1102:	{
;1103:		{
;1104:			int rval;
;1105:
;1106:			rval = CG_NewParticleArea ( CS_PARTICLES + i);
;1107:			if (!rval)
;1108:				break;
;1109:		}
;1110:	}
;1111:*/
;1112:}
LABELV $560
endproc CG_RegisterGraphics 588 16
export CG_BuildSpectatorString
proc CG_BuildSpectatorString 12 12
line 1122
;1113:
;1114:
;1115:
;1116:/*																																			
;1117:=======================
;1118:CG_BuildSpectatorString
;1119:
;1120:=======================
;1121:*/
;1122:void CG_BuildSpectatorString() {
line 1124
;1123:	int i;
;1124:	cg.spectatorList[0] = 0;
ADDRGP4 cg+114364
CNSTI1 0
ASGNI1
line 1125
;1125:	for (i = 0; i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $887
line 1126
;1126:		if (cgs.clientinfo[i].infoValid && cgs.clientinfo[i].team == TEAM_SPECTATOR ) {
ADDRLP4 4
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+40972
ADDP4
INDIRI4
CNSTI4 0
EQI4 $891
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+40972+68
ADDP4
INDIRI4
CNSTI4 3
NEI4 $891
line 1127
;1127:			Q_strcat(cg.spectatorList, sizeof(cg.spectatorList), va("%s     ", cgs.clientinfo[i].name));
ADDRGP4 $898
ARGP4
CNSTI4 1708
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cgs+40972+4
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRGP4 cg+114364
ARGP4
CNSTI4 1024
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 Q_strcat
CALLV
pop
line 1128
;1128:		}
LABELV $891
line 1129
;1129:	}
LABELV $888
line 1125
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $887
line 1130
;1130:	i = strlen(cg.spectatorList);
ADDRGP4 cg+114364
ARGP4
ADDRLP4 4
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 1131
;1131:	if (i != cg.spectatorLen) {
ADDRLP4 0
INDIRI4
ADDRGP4 cg+115388
INDIRI4
EQI4 $902
line 1132
;1132:		cg.spectatorLen = i;
ADDRGP4 cg+115388
ADDRLP4 0
INDIRI4
ASGNI4
line 1133
;1133:		cg.spectatorWidth = -1;
ADDRGP4 cg+115392
CNSTF4 3212836864
ASGNF4
line 1134
;1134:	}
LABELV $902
line 1135
;1135:}
LABELV $885
endproc CG_BuildSpectatorString 12 12
proc CG_RegisterClients 12 4
line 1143
;1136:
;1137:
;1138:/*																																			
;1139:===================
;1140:CG_RegisterClients
;1141:===================
;1142:*/
;1143:static void CG_RegisterClients( void ) {
line 1146
;1144:	int		i;
;1145:
;1146:	CG_LoadingClient(cg.clientNum);
ADDRGP4 cg+4
INDIRI4
ARGI4
ADDRGP4 CG_LoadingClient
CALLV
pop
line 1147
;1147:	CG_NewClientInfo(cg.clientNum);
ADDRGP4 cg+4
INDIRI4
ARGI4
ADDRGP4 CG_NewClientInfo
CALLV
pop
line 1149
;1148:
;1149:	for (i=0 ; i<MAX_CLIENTS ; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $910
line 1152
;1150:		const char		*clientInfo;
;1151:
;1152:		if (cg.clientNum == i) {
ADDRGP4 cg+4
INDIRI4
ADDRLP4 0
INDIRI4
NEI4 $914
line 1153
;1153:			continue;
ADDRGP4 $911
JUMPV
LABELV $914
line 1156
;1154:		}
;1155:
;1156:		clientInfo = CG_ConfigString( CS_PLAYERS+i );
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 8
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 8
INDIRP4
ASGNP4
line 1157
;1157:		if ( !clientInfo[0]) {
ADDRLP4 4
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $917
line 1158
;1158:			continue;
ADDRGP4 $911
JUMPV
LABELV $917
line 1160
;1159:		}
;1160:		CG_LoadingClient( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_LoadingClient
CALLV
pop
line 1161
;1161:		CG_NewClientInfo( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 CG_NewClientInfo
CALLV
pop
line 1162
;1162:	}
LABELV $911
line 1149
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $910
line 1163
;1163:	CG_BuildSpectatorString();
ADDRGP4 CG_BuildSpectatorString
CALLV
pop
line 1164
;1164:}
LABELV $907
endproc CG_RegisterClients 12 4
export CG_ConfigString
proc CG_ConfigString 4 8
line 1173
;1165:
;1166://===========================================================================
;1167:
;1168:/*
;1169:=================
;1170:CG_ConfigString
;1171:=================
;1172:*/
;1173:const char *CG_ConfigString( int index ) {
line 1174
;1174:	if ( index < 0 || index >= MAX_CONFIGSTRINGS ) {
ADDRLP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $922
ADDRLP4 0
INDIRI4
CNSTI4 1024
LTI4 $920
LABELV $922
line 1175
;1175:		CG_Error( "CG_ConfigString: bad index: %i", index );
ADDRGP4 $923
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
ADDRGP4 CG_Error
CALLV
pop
line 1176
;1176:	}
LABELV $920
line 1177
;1177:	return cgs.gameState.stringData + cgs.gameState.stringOffsets[ index ];
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs
ADDP4
INDIRI4
ADDRGP4 cgs+4096
ADDP4
RETP4
LABELV $919
endproc CG_ConfigString 4 8
export CG_StartMusic
proc CG_StartMusic 144 12
line 1188
;1178:}
;1179:
;1180://==================================================================
;1181:
;1182:/*
;1183:======================
;1184:CG_StartMusic
;1185:
;1186:======================
;1187:*/
;1188:void CG_StartMusic( void ) {
line 1193
;1189:	char	*s;
;1190:	char	parm1[MAX_QPATH], parm2[MAX_QPATH];
;1191:
;1192:	// start the background music
;1193:	s = (char *)CG_ConfigString( CS_MUSIC );
CNSTI4 2
ARGI4
ADDRLP4 132
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 132
INDIRP4
ASGNP4
line 1194
;1194:	Q_strncpyz( parm1, COM_Parse( &s ), sizeof( parm1 ) );
ADDRLP4 0
ARGP4
ADDRLP4 136
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 4
ARGP4
ADDRLP4 136
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1195
;1195:	Q_strncpyz( parm2, COM_Parse( &s ), sizeof( parm2 ) );
ADDRLP4 0
ARGP4
ADDRLP4 140
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 68
ARGP4
ADDRLP4 140
INDIRP4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 1197
;1196:
;1197:	trap_S_StartBackgroundTrack( parm1, parm2 );
ADDRLP4 4
ARGP4
ADDRLP4 68
ARGP4
ADDRGP4 trap_S_StartBackgroundTrack
CALLV
pop
line 1198
;1198:}
LABELV $925
endproc CG_StartMusic 144 12
export CG_Init
proc CG_Init 44 12
line 1864
;1199:#ifdef MISSIONPACK
;1200:char *CG_GetMenuBuffer(const char *filename) {
;1201:	int	len;
;1202:	fileHandle_t	f;
;1203:	static char buf[MAX_MENUFILE];
;1204:
;1205:	len = trap_FS_FOpenFile( filename, &f, FS_READ );
;1206:	if ( !f ) {
;1207:		trap_Print( va( S_COLOR_RED "menu file not found: %s, using default\n", filename ) );
;1208:		return NULL;
;1209:	}
;1210:	if ( len >= MAX_MENUFILE ) {
;1211:		trap_Print( va( S_COLOR_RED "menu file too large: %s is %i, max allowed is %i", filename, len, MAX_MENUFILE ) );
;1212:		trap_FS_FCloseFile( f );
;1213:		return NULL;
;1214:	}
;1215:
;1216:	trap_FS_Read( buf, len, f );
;1217:	buf[len] = 0;
;1218:	trap_FS_FCloseFile( f );
;1219:
;1220:	return buf;
;1221:}
;1222:
;1223://
;1224:// ==============================
;1225:// new hud stuff ( mission pack )
;1226:// ==============================
;1227://
;1228:qboolean CG_Asset_Parse(int handle) {
;1229:	pc_token_t token;
;1230:	const char *tempStr;
;1231:
;1232:	if (!trap_PC_ReadToken(handle, &token))
;1233:		return qfalse;
;1234:	if (Q_stricmp(token.string, "{") != 0) {
;1235:		return qfalse;
;1236:	}
;1237:    
;1238:	while ( 1 ) {
;1239:		if (!trap_PC_ReadToken(handle, &token))
;1240:			return qfalse;
;1241:
;1242:		if (Q_stricmp(token.string, "}") == 0) {
;1243:			return qtrue;
;1244:		}
;1245:
;1246:		// font
;1247:		if (Q_stricmp(token.string, "font") == 0) {
;1248:			int pointSize;
;1249:			if (!PC_String_Parse(handle, &tempStr) || !PC_Int_Parse(handle, &pointSize)) {
;1250:				return qfalse;
;1251:			}
;1252:			cgDC.registerFont(tempStr, pointSize, &cgDC.Assets.textFont);
;1253:			continue;
;1254:		}
;1255:
;1256:		// smallFont
;1257:		if (Q_stricmp(token.string, "smallFont") == 0) {
;1258:			int pointSize;
;1259:			if (!PC_String_Parse(handle, &tempStr) || !PC_Int_Parse(handle, &pointSize)) {
;1260:				return qfalse;
;1261:			}
;1262:			cgDC.registerFont(tempStr, pointSize, &cgDC.Assets.smallFont);
;1263:			continue;
;1264:		}
;1265:
;1266:		// font
;1267:		if (Q_stricmp(token.string, "bigfont") == 0) {
;1268:			int pointSize;
;1269:			if (!PC_String_Parse(handle, &tempStr) || !PC_Int_Parse(handle, &pointSize)) {
;1270:				return qfalse;
;1271:			}
;1272:			cgDC.registerFont(tempStr, pointSize, &cgDC.Assets.bigFont);
;1273:			continue;
;1274:		}
;1275:
;1276:		// gradientbar
;1277:		if (Q_stricmp(token.string, "gradientbar") == 0) {
;1278:			if (!PC_String_Parse(handle, &tempStr)) {
;1279:				return qfalse;
;1280:			}
;1281:			cgDC.Assets.gradientBar = trap_R_RegisterShaderNoMip(tempStr);
;1282:			continue;
;1283:		}
;1284:
;1285:		// enterMenuSound
;1286:		if (Q_stricmp(token.string, "menuEnterSound") == 0) {
;1287:			if (!PC_String_Parse(handle, &tempStr)) {
;1288:				return qfalse;
;1289:			}
;1290:			cgDC.Assets.menuEnterSound = trap_S_RegisterSound( tempStr, qfalse );
;1291:			continue;
;1292:		}
;1293:
;1294:		// exitMenuSound
;1295:		if (Q_stricmp(token.string, "menuExitSound") == 0) {
;1296:			if (!PC_String_Parse(handle, &tempStr)) {
;1297:				return qfalse;
;1298:			}
;1299:			cgDC.Assets.menuExitSound = trap_S_RegisterSound( tempStr, qfalse );
;1300:			continue;
;1301:		}
;1302:
;1303:		// itemFocusSound
;1304:		if (Q_stricmp(token.string, "itemFocusSound") == 0) {
;1305:			if (!PC_String_Parse(handle, &tempStr)) {
;1306:				return qfalse;
;1307:			}
;1308:			cgDC.Assets.itemFocusSound = trap_S_RegisterSound( tempStr, qfalse );
;1309:			continue;
;1310:		}
;1311:
;1312:		// menuBuzzSound
;1313:		if (Q_stricmp(token.string, "menuBuzzSound") == 0) {
;1314:			if (!PC_String_Parse(handle, &tempStr)) {
;1315:				return qfalse;
;1316:			}
;1317:			cgDC.Assets.menuBuzzSound = trap_S_RegisterSound( tempStr, qfalse );
;1318:			continue;
;1319:		}
;1320:
;1321:		if (Q_stricmp(token.string, "cursor") == 0) {
;1322:			if (!PC_String_Parse(handle, &cgDC.Assets.cursorStr)) {
;1323:				return qfalse;
;1324:			}
;1325:			cgDC.Assets.cursor = trap_R_RegisterShaderNoMip( cgDC.Assets.cursorStr);
;1326:			continue;
;1327:		}
;1328:
;1329:		if (Q_stricmp(token.string, "fadeClamp") == 0) {
;1330:			if (!PC_Float_Parse(handle, &cgDC.Assets.fadeClamp)) {
;1331:				return qfalse;
;1332:			}
;1333:			continue;
;1334:		}
;1335:
;1336:		if (Q_stricmp(token.string, "fadeCycle") == 0) {
;1337:			if (!PC_Int_Parse(handle, &cgDC.Assets.fadeCycle)) {
;1338:				return qfalse;
;1339:			}
;1340:			continue;
;1341:		}
;1342:
;1343:		if (Q_stricmp(token.string, "fadeAmount") == 0) {
;1344:			if (!PC_Float_Parse(handle, &cgDC.Assets.fadeAmount)) {
;1345:				return qfalse;
;1346:			}
;1347:			continue;
;1348:		}
;1349:
;1350:		if (Q_stricmp(token.string, "shadowX") == 0) {
;1351:			if (!PC_Float_Parse(handle, &cgDC.Assets.shadowX)) {
;1352:				return qfalse;
;1353:			}
;1354:			continue;
;1355:		}
;1356:
;1357:		if (Q_stricmp(token.string, "shadowY") == 0) {
;1358:			if (!PC_Float_Parse(handle, &cgDC.Assets.shadowY)) {
;1359:				return qfalse;
;1360:			}
;1361:			continue;
;1362:		}
;1363:
;1364:		if (Q_stricmp(token.string, "shadowColor") == 0) {
;1365:			if (!PC_Color_Parse(handle, &cgDC.Assets.shadowColor)) {
;1366:				return qfalse;
;1367:			}
;1368:			cgDC.Assets.shadowFadeClamp = cgDC.Assets.shadowColor[3];
;1369:			continue;
;1370:		}
;1371:	}
;1372:	return qfalse; // bk001204 - why not?
;1373:}
;1374:
;1375:void CG_ParseMenu(const char *menuFile) {
;1376:	pc_token_t token;
;1377:	int handle;
;1378:
;1379:	handle = trap_PC_LoadSource(menuFile);
;1380:	if (!handle)
;1381:		handle = trap_PC_LoadSource("ui/testhud.menu");
;1382:	if (!handle)
;1383:		return;
;1384:
;1385:	while ( 1 ) {
;1386:		if (!trap_PC_ReadToken( handle, &token )) {
;1387:			break;
;1388:		}
;1389:
;1390:		//if ( Q_stricmp( token, "{" ) ) {
;1391:		//	Com_Printf( "Missing { in menu file\n" );
;1392:		//	break;
;1393:		//}
;1394:
;1395:		//if ( menuCount == MAX_MENUS ) {
;1396:		//	Com_Printf( "Too many menus!\n" );
;1397:		//	break;
;1398:		//}
;1399:
;1400:		if ( token.string[0] == '}' ) {
;1401:			break;
;1402:		}
;1403:
;1404:		if (Q_stricmp(token.string, "assetGlobalDef") == 0) {
;1405:			if (CG_Asset_Parse(handle)) {
;1406:				continue;
;1407:			} else {
;1408:				break;
;1409:			}
;1410:		}
;1411:
;1412:
;1413:		if (Q_stricmp(token.string, "menudef") == 0) {
;1414:			// start a new menu
;1415:			Menu_New(handle);
;1416:		}
;1417:	}
;1418:	trap_PC_FreeSource(handle);
;1419:}
;1420:
;1421:qboolean CG_Load_Menu(char **p) {
;1422:	char *token;
;1423:
;1424:	token = COM_ParseExt(p, qtrue);
;1425:
;1426:	if (token[0] != '{') {
;1427:		return qfalse;
;1428:	}
;1429:
;1430:	while ( 1 ) {
;1431:
;1432:		token = COM_ParseExt(p, qtrue);
;1433:    
;1434:		if (Q_stricmp(token, "}") == 0) {
;1435:			return qtrue;
;1436:		}
;1437:
;1438:		if ( !token || token[0] == 0 ) {
;1439:			return qfalse;
;1440:		}
;1441:
;1442:		CG_ParseMenu(token); 
;1443:	}
;1444:	return qfalse;
;1445:}
;1446:
;1447:
;1448:
;1449:void CG_LoadMenus(const char *menuFile) {
;1450:	char	*token;
;1451:	char *p;
;1452:	int	len, start;
;1453:	fileHandle_t	f;
;1454:	static char buf[MAX_MENUDEFFILE];
;1455:
;1456:	start = trap_Milliseconds();
;1457:
;1458:	len = trap_FS_FOpenFile( menuFile, &f, FS_READ );
;1459:	if ( !f ) {
;1460:		trap_Error( va( S_COLOR_YELLOW "menu file not found: %s, using default\n", menuFile ) );
;1461:		len = trap_FS_FOpenFile( "ui/hud.txt", &f, FS_READ );
;1462:		if (!f) {
;1463:			trap_Error( va( S_COLOR_RED "default menu file not found: ui/hud.txt, unable to continue!\n", menuFile ) );
;1464:		}
;1465:	}
;1466:
;1467:	if ( len >= MAX_MENUDEFFILE ) {
;1468:		trap_Error( va( S_COLOR_RED "menu file too large: %s is %i, max allowed is %i", menuFile, len, MAX_MENUDEFFILE ) );
;1469:		trap_FS_FCloseFile( f );
;1470:		return;
;1471:	}
;1472:
;1473:	trap_FS_Read( buf, len, f );
;1474:	buf[len] = 0;
;1475:	trap_FS_FCloseFile( f );
;1476:	
;1477:	COM_Compress(buf);
;1478:
;1479:	Menu_Reset();
;1480:
;1481:	p = buf;
;1482:
;1483:	while ( 1 ) {
;1484:		token = COM_ParseExt( &p, qtrue );
;1485:		if( !token || token[0] == 0 || token[0] == '}') {
;1486:			break;
;1487:		}
;1488:
;1489:		//if ( Q_stricmp( token, "{" ) ) {
;1490:		//	Com_Printf( "Missing { in menu file\n" );
;1491:		//	break;
;1492:		//}
;1493:
;1494:		//if ( menuCount == MAX_MENUS ) {
;1495:		//	Com_Printf( "Too many menus!\n" );
;1496:		//	break;
;1497:		//}
;1498:
;1499:		if ( Q_stricmp( token, "}" ) == 0 ) {
;1500:			break;
;1501:		}
;1502:
;1503:		if (Q_stricmp(token, "loadmenu") == 0) {
;1504:			if (CG_Load_Menu(&p)) {
;1505:				continue;
;1506:			} else {
;1507:				break;
;1508:			}
;1509:		}
;1510:	}
;1511:
;1512:	Com_Printf("UI menu load time = %d milli seconds\n", trap_Milliseconds() - start);
;1513:
;1514:}
;1515:
;1516:
;1517:
;1518:static qboolean CG_OwnerDrawHandleKey(int ownerDraw, int flags, float *special, int key) {
;1519:	return qfalse;
;1520:}
;1521:
;1522:
;1523:static int CG_FeederCount(float feederID) {
;1524:	int i, count;
;1525:	count = 0;
;1526:	if (feederID == FEEDER_REDTEAM_LIST) {
;1527:		for (i = 0; i < cg.numScores; i++) {
;1528:			if (cg.scores[i].team == TEAM_RED) {
;1529:				count++;
;1530:			}
;1531:		}
;1532:	} else if (feederID == FEEDER_BLUETEAM_LIST) {
;1533:		for (i = 0; i < cg.numScores; i++) {
;1534:			if (cg.scores[i].team == TEAM_BLUE) {
;1535:				count++;
;1536:			}
;1537:		}
;1538:	} else if (feederID == FEEDER_SCOREBOARD) {
;1539:		return cg.numScores;
;1540:	}
;1541:	return count;
;1542:}
;1543:
;1544:
;1545:void CG_SetScoreSelection(void *p) {
;1546:	menuDef_t *menu = (menuDef_t*)p;
;1547:	playerState_t *ps = &cg.snap->ps;
;1548:	int i, red, blue;
;1549:	red = blue = 0;
;1550:	for (i = 0; i < cg.numScores; i++) {
;1551:		if (cg.scores[i].team == TEAM_RED) {
;1552:			red++;
;1553:		} else if (cg.scores[i].team == TEAM_BLUE) {
;1554:			blue++;
;1555:		}
;1556:		if (ps->clientNum == cg.scores[i].client) {
;1557:			cg.selectedScore = i;
;1558:		}
;1559:	}
;1560:
;1561:	if (menu == NULL) {
;1562:		// just interested in setting the selected score
;1563:		return;
;1564:	}
;1565:
;1566:	if ( cgs.gametype >= GT_TEAM ) {
;1567:		int feeder = FEEDER_REDTEAM_LIST;
;1568:		i = red;
;1569:		if (cg.scores[cg.selectedScore].team == TEAM_BLUE) {
;1570:			feeder = FEEDER_BLUETEAM_LIST;
;1571:			i = blue;
;1572:		}
;1573:		Menu_SetFeederSelection(menu, feeder, i, NULL);
;1574:	} else {
;1575:		Menu_SetFeederSelection(menu, FEEDER_SCOREBOARD, cg.selectedScore, NULL);
;1576:	}
;1577:}
;1578:
;1579:// FIXME: might need to cache this info
;1580:static clientInfo_t * CG_InfoFromScoreIndex(int index, int team, int *scoreIndex) {
;1581:	int i, count;
;1582:	if ( cgs.gametype >= GT_TEAM ) {
;1583:		count = 0;
;1584:		for (i = 0; i < cg.numScores; i++) {
;1585:			if (cg.scores[i].team == team) {
;1586:				if (count == index) {
;1587:					*scoreIndex = i;
;1588:					return &cgs.clientinfo[cg.scores[i].client];
;1589:				}
;1590:				count++;
;1591:			}
;1592:		}
;1593:	}
;1594:	*scoreIndex = index;
;1595:	return &cgs.clientinfo[ cg.scores[index].client ];
;1596:}
;1597:
;1598:static const char *CG_FeederItemText(float feederID, int index, int column, qhandle_t *handle) {
;1599:	gitem_t *item;
;1600:	int scoreIndex = 0;
;1601:	clientInfo_t *info = NULL;
;1602:	int team = -1;
;1603:	score_t *sp = NULL;
;1604:
;1605:	*handle = -1;
;1606:
;1607:	if (feederID == FEEDER_REDTEAM_LIST) {
;1608:		team = TEAM_RED;
;1609:	} else if (feederID == FEEDER_BLUETEAM_LIST) {
;1610:		team = TEAM_BLUE;
;1611:	}
;1612:
;1613:	info = CG_InfoFromScoreIndex(index, team, &scoreIndex);
;1614:	sp = &cg.scores[scoreIndex];
;1615:
;1616:	if (info && info->infoValid) {
;1617:		switch (column) {
;1618:			case 0:
;1619:				if ( info->powerups & ( 1 << PW_NEUTRALFLAG ) ) {
;1620:					item = BG_FindItemForPowerup( PW_NEUTRALFLAG );
;1621:					*handle = cg_items[ ITEM_INDEX(item) ].icon;
;1622:				} else if ( info->powerups & ( 1 << PW_REDFLAG ) ) {
;1623:					item = BG_FindItemForPowerup( PW_REDFLAG );
;1624:					*handle = cg_items[ ITEM_INDEX(item) ].icon;
;1625:				} else if ( info->powerups & ( 1 << PW_BLUEFLAG ) ) {
;1626:					item = BG_FindItemForPowerup( PW_BLUEFLAG );
;1627:					*handle = cg_items[ ITEM_INDEX(item) ].icon;
;1628:				} else {
;1629:					if ( info->botSkill > 0 && info->botSkill <= 5 ) {
;1630:						*handle = cgs.media.botSkillShaders[ info->botSkill - 1 ];
;1631:					} else if ( info->handicap < 100 ) {
;1632:					return va("%i", info->handicap );
;1633:					}
;1634:				}
;1635:			break;
;1636:			case 1:
;1637:				if (team == -1) {
;1638:					return "";
;1639:				} else {
;1640:					*handle = CG_StatusHandle(info->teamTask);
;1641:				}
;1642:		  break;
;1643:			case 2:
;1644:				if ( cg.snap->ps.stats[ STAT_CLIENTS_READY ] & ( 1 << sp->client ) ) {
;1645:					return "Ready";
;1646:				}
;1647:				if (team == -1) {
;1648:					if (cgs.gametype == GT_TOURNAMENT) {
;1649:						return va("%i/%i", info->wins, info->losses);
;1650:					} else if (info->infoValid && info->team == TEAM_SPECTATOR ) {
;1651:						return "Spectator";
;1652:					} else {
;1653:						return "";
;1654:					}
;1655:				} else {
;1656:					if (info->teamLeader) {
;1657:						return "Leader";
;1658:					}
;1659:				}
;1660:			break;
;1661:			case 3:
;1662:				return info->name;
;1663:			break;
;1664:			case 4:
;1665:				return va("%i", info->score);
;1666:			break;
;1667:			case 5:
;1668:				return va("%4i", sp->time);
;1669:			break;
;1670:			case 6:
;1671:				if ( sp->ping == -1 ) {
;1672:					return "connecting";
;1673:				} 
;1674:				return va("%4i", sp->ping);
;1675:			break;
;1676:		}
;1677:	}
;1678:
;1679:	return "";
;1680:}
;1681:
;1682:static qhandle_t CG_FeederItemImage(float feederID, int index) {
;1683:	return 0;
;1684:}
;1685:
;1686:static void CG_FeederSelection(float feederID, int index) {
;1687:	if ( cgs.gametype >= GT_TEAM ) {
;1688:		int i, count;
;1689:		int team = (feederID == FEEDER_REDTEAM_LIST) ? TEAM_RED : TEAM_BLUE;
;1690:		count = 0;
;1691:		for (i = 0; i < cg.numScores; i++) {
;1692:			if (cg.scores[i].team == team) {
;1693:				if (index == count) {
;1694:					cg.selectedScore = i;
;1695:				}
;1696:				count++;
;1697:			}
;1698:		}
;1699:	} else {
;1700:		cg.selectedScore = index;
;1701:	}
;1702:}
;1703:#endif
;1704:
;1705:#ifdef MISSIONPACK // bk001204 - only needed there
;1706:static float CG_Cvar_Get(const char *cvar) {
;1707:	char buff[128];
;1708:	memset(buff, 0, sizeof(buff));
;1709:	trap_Cvar_VariableStringBuffer(cvar, buff, sizeof(buff));
;1710:	return atof(buff);
;1711:}
;1712:#endif
;1713:
;1714:#ifdef MISSIONPACK
;1715:void CG_Text_PaintWithCursor(float x, float y, float scale, vec4_t color, const char *text, int cursorPos, char cursor, int limit, int style) {
;1716:	CG_Text_Paint(x, y, scale, color, text, 0, limit, style);
;1717:}
;1718:
;1719:static int CG_OwnerDrawWidth(int ownerDraw, float scale) {
;1720:	switch (ownerDraw) {
;1721:	  case CG_GAME_TYPE:
;1722:			return CG_Text_Width(CG_GameTypeString(), scale, 0);
;1723:	  case CG_GAME_STATUS:
;1724:			return CG_Text_Width(CG_GetGameStatusText(), scale, 0);
;1725:			break;
;1726:	  case CG_KILLER:
;1727:			return CG_Text_Width(CG_GetKillerText(), scale, 0);
;1728:			break;
;1729:	  case CG_RED_NAME:
;1730:			return CG_Text_Width(cg_redTeamName.string, scale, 0);
;1731:			break;
;1732:	  case CG_BLUE_NAME:
;1733:			return CG_Text_Width(cg_blueTeamName.string, scale, 0);
;1734:			break;
;1735:
;1736:
;1737:	}
;1738:	return 0;
;1739:}
;1740:
;1741:static int CG_PlayCinematic(const char *name, float x, float y, float w, float h) {
;1742:  return trap_CIN_PlayCinematic(name, x, y, w, h, CIN_loop);
;1743:}
;1744:
;1745:static void CG_StopCinematic(int handle) {
;1746:  trap_CIN_StopCinematic(handle);
;1747:}
;1748:
;1749:static void CG_DrawCinematic(int handle, float x, float y, float w, float h) {
;1750:  trap_CIN_SetExtents(handle, x, y, w, h);
;1751:  trap_CIN_DrawCinematic(handle);
;1752:}
;1753:
;1754:static void CG_RunCinematicFrame(int handle) {
;1755:  trap_CIN_RunCinematic(handle);
;1756:}
;1757:
;1758:/*
;1759:=================
;1760:CG_LoadHudMenu();
;1761:
;1762:=================
;1763:*/
;1764:void CG_LoadHudMenu() {
;1765:	char buff[1024];
;1766:	const char *hudSet;
;1767:
;1768:	cgDC.registerShaderNoMip = &trap_R_RegisterShaderNoMip;
;1769:	cgDC.setColor = &trap_R_SetColor;
;1770:	cgDC.drawHandlePic = &CG_DrawPic;
;1771:	cgDC.drawStretchPic = &trap_R_DrawStretchPic;
;1772:	cgDC.drawText = &CG_Text_Paint;
;1773:	cgDC.textWidth = &CG_Text_Width;
;1774:	cgDC.textHeight = &CG_Text_Height;
;1775:	cgDC.registerModel = &trap_R_RegisterModel;
;1776:	cgDC.modelBounds = &trap_R_ModelBounds;
;1777:	cgDC.fillRect = &CG_FillRect;
;1778:	cgDC.drawRect = &CG_DrawRect;   
;1779:	cgDC.drawSides = &CG_DrawSides;
;1780:	cgDC.drawTopBottom = &CG_DrawTopBottom;
;1781:	cgDC.clearScene = &trap_R_ClearScene;
;1782:	cgDC.addRefEntityToScene = &trap_R_AddRefEntityToScene;
;1783:	cgDC.renderScene = &trap_R_RenderScene;
;1784:	cgDC.registerFont = &trap_R_RegisterFont;
;1785:	cgDC.ownerDrawItem = &CG_OwnerDraw;
;1786:	cgDC.getValue = &CG_GetValue;
;1787:	cgDC.ownerDrawVisible = &CG_OwnerDrawVisible;
;1788:	cgDC.runScript = &CG_RunMenuScript;
;1789:	cgDC.getTeamColor = &CG_GetTeamColor;
;1790:	cgDC.setCVar = trap_Cvar_Set;
;1791:	cgDC.getCVarString = trap_Cvar_VariableStringBuffer;
;1792:	cgDC.getCVarValue = CG_Cvar_Get;
;1793:	cgDC.drawTextWithCursor = &CG_Text_PaintWithCursor;
;1794:	//cgDC.setOverstrikeMode = &trap_Key_SetOverstrikeMode;
;1795:	//cgDC.getOverstrikeMode = &trap_Key_GetOverstrikeMode;
;1796:	cgDC.startLocalSound = &trap_S_StartLocalSound;
;1797:	cgDC.ownerDrawHandleKey = &CG_OwnerDrawHandleKey;
;1798:	cgDC.feederCount = &CG_FeederCount;
;1799:	cgDC.feederItemImage = &CG_FeederItemImage;
;1800:	cgDC.feederItemText = &CG_FeederItemText;
;1801:	cgDC.feederSelection = &CG_FeederSelection;
;1802:	//cgDC.setBinding = &trap_Key_SetBinding;
;1803:	//cgDC.getBindingBuf = &trap_Key_GetBindingBuf;
;1804:	//cgDC.keynumToStringBuf = &trap_Key_KeynumToStringBuf;
;1805:	//cgDC.executeText = &trap_Cmd_ExecuteText;
;1806:	cgDC.Error = &Com_Error; 
;1807:	cgDC.Print = &Com_Printf; 
;1808:	cgDC.ownerDrawWidth = &CG_OwnerDrawWidth;
;1809:	//cgDC.Pause = &CG_Pause;
;1810:	cgDC.registerSound = &trap_S_RegisterSound;
;1811:	cgDC.startBackgroundTrack = &trap_S_StartBackgroundTrack;
;1812:	cgDC.stopBackgroundTrack = &trap_S_StopBackgroundTrack;
;1813:	cgDC.playCinematic = &CG_PlayCinematic;
;1814:	cgDC.stopCinematic = &CG_StopCinematic;
;1815:	cgDC.drawCinematic = &CG_DrawCinematic;
;1816:	cgDC.runCinematicFrame = &CG_RunCinematicFrame;
;1817:	
;1818:	Init_Display(&cgDC);
;1819:
;1820:	Menu_Reset();
;1821:	
;1822:	trap_Cvar_VariableStringBuffer("cg_hudFiles", buff, sizeof(buff));
;1823:	hudSet = buff;
;1824:	if (hudSet[0] == '\0') {
;1825:		hudSet = "ui/hud.txt";
;1826:	}
;1827:
;1828:	CG_LoadMenus(hudSet);
;1829:}
;1830:
;1831:void CG_AssetCache() {
;1832:	//if (Assets.textFont == NULL) {
;1833:	//  trap_R_RegisterFont("fonts/arial.ttf", 72, &Assets.textFont);
;1834:	//}
;1835:	//Assets.background = trap_R_RegisterShaderNoMip( ASSET_BACKGROUND );
;1836:	//Com_Printf("Menu Size: %i bytes\n", sizeof(Menus));
;1837:	cgDC.Assets.gradientBar = trap_R_RegisterShaderNoMip( ASSET_GRADIENTBAR );
;1838:	cgDC.Assets.fxBasePic = trap_R_RegisterShaderNoMip( ART_FX_BASE );
;1839:	cgDC.Assets.fxPic[0] = trap_R_RegisterShaderNoMip( ART_FX_RED );
;1840:	cgDC.Assets.fxPic[1] = trap_R_RegisterShaderNoMip( ART_FX_YELLOW );
;1841:	cgDC.Assets.fxPic[2] = trap_R_RegisterShaderNoMip( ART_FX_GREEN );
;1842:	cgDC.Assets.fxPic[3] = trap_R_RegisterShaderNoMip( ART_FX_TEAL );
;1843:	cgDC.Assets.fxPic[4] = trap_R_RegisterShaderNoMip( ART_FX_BLUE );
;1844:	cgDC.Assets.fxPic[5] = trap_R_RegisterShaderNoMip( ART_FX_CYAN );
;1845:	cgDC.Assets.fxPic[6] = trap_R_RegisterShaderNoMip( ART_FX_WHITE );
;1846:	cgDC.Assets.scrollBar = trap_R_RegisterShaderNoMip( ASSET_SCROLLBAR );
;1847:	cgDC.Assets.scrollBarArrowDown = trap_R_RegisterShaderNoMip( ASSET_SCROLLBAR_ARROWDOWN );
;1848:	cgDC.Assets.scrollBarArrowUp = trap_R_RegisterShaderNoMip( ASSET_SCROLLBAR_ARROWUP );
;1849:	cgDC.Assets.scrollBarArrowLeft = trap_R_RegisterShaderNoMip( ASSET_SCROLLBAR_ARROWLEFT );
;1850:	cgDC.Assets.scrollBarArrowRight = trap_R_RegisterShaderNoMip( ASSET_SCROLLBAR_ARROWRIGHT );
;1851:	cgDC.Assets.scrollBarThumb = trap_R_RegisterShaderNoMip( ASSET_SCROLL_THUMB );
;1852:	cgDC.Assets.sliderBar = trap_R_RegisterShaderNoMip( ASSET_SLIDER_BAR );
;1853:	cgDC.Assets.sliderThumb = trap_R_RegisterShaderNoMip( ASSET_SLIDER_THUMB );
;1854:}
;1855:#endif
;1856:/*
;1857:=================
;1858:CG_Init
;1859:
;1860:Called after every level change or subsystem restart
;1861:Will perform callbacks to make the loading info screen update.
;1862:=================
;1863:*/
;1864:void CG_Init( int serverMessageNum, int serverCommandSequence, int clientNum ) {
line 1868
;1865:	const char	*s;
;1866:
;1867:	// clear everything
;1868:	memset( &cgs, 0, sizeof( cgs ) );
ADDRGP4 cgs
ARGP4
CNSTI4 0
ARGI4
CNSTI4 153368
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1869
;1869:	memset( &cg, 0, sizeof( cg ) );
ADDRGP4 cg
ARGP4
CNSTI4 0
ARGI4
CNSTI4 124992
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1870
;1870:	memset( cg_entities, 0, sizeof(cg_entities) );
ADDRGP4 cg_entities
ARGP4
CNSTI4 0
ARGI4
CNSTI4 745472
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1871
;1871:	memset( cg_weapons, 0, sizeof(cg_weapons) );
ADDRGP4 cg_weapons
ARGP4
CNSTI4 0
ARGI4
CNSTI4 2176
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1872
;1872:	memset( cg_items, 0, sizeof(cg_items) );
ADDRGP4 cg_items
ARGP4
CNSTI4 0
ARGI4
CNSTI4 6144
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1874
;1873:
;1874:	cg.clientNum = clientNum;
ADDRGP4 cg+4
ADDRFP4 8
INDIRI4
ASGNI4
line 1876
;1875:
;1876:	cgs.processedSnapshotNum = serverMessageNum;
ADDRGP4 cgs+31448
ADDRFP4 0
INDIRI4
ASGNI4
line 1877
;1877:	cgs.serverCommandSequence = serverCommandSequence;
ADDRGP4 cgs+31444
ADDRFP4 4
INDIRI4
ASGNI4
line 1880
;1878:
;1879:	// load a few needed things before we do any screen updates
;1880:	cgs.media.charsetShader		= trap_R_RegisterShader( "gfx/2d/bigchars" );
ADDRGP4 $931
ARGP4
ADDRLP4 4
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340
ADDRLP4 4
INDIRI4
ASGNI4
line 1881
;1881:	cgs.media.whiteShader		= trap_R_RegisterShader( "white" );
ADDRGP4 $934
ARGP4
ADDRLP4 8
ADDRGP4 trap_R_RegisterShader
CALLI4
ASGNI4
ADDRGP4 cgs+152340+16
ADDRLP4 8
INDIRI4
ASGNI4
line 1882
;1882:	cgs.media.charsetProp		= trap_R_RegisterShaderNoMip( "menu/art/font1_prop.tga" );
ADDRGP4 $937
ARGP4
ADDRLP4 12
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+4
ADDRLP4 12
INDIRI4
ASGNI4
line 1883
;1883:	cgs.media.charsetPropGlow	= trap_R_RegisterShaderNoMip( "menu/art/font1_prop_glo.tga" );
ADDRGP4 $940
ARGP4
ADDRLP4 16
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+8
ADDRLP4 16
INDIRI4
ASGNI4
line 1884
;1884:	cgs.media.charsetPropB		= trap_R_RegisterShaderNoMip( "menu/art/font2_prop.tga" );
ADDRGP4 $943
ARGP4
ADDRLP4 20
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRGP4 cgs+152340+12
ADDRLP4 20
INDIRI4
ASGNI4
line 1886
;1885:
;1886:	CG_RegisterCvars();
ADDRGP4 CG_RegisterCvars
CALLV
pop
line 1888
;1887:
;1888:	CG_InitConsoleCommands();
ADDRGP4 CG_InitConsoleCommands
CALLV
pop
line 1890
;1889:
;1890:	cg.weaponSelect = WP_MACHINEGUN;
ADDRGP4 cg+108944
CNSTI4 2
ASGNI4
line 1892
;1891:
;1892:	cgs.redflag = cgs.blueflag = -1; // For compatibily, default to unset for
ADDRLP4 24
CNSTI4 -1
ASGNI4
ADDRGP4 cgs+34812
ADDRLP4 24
INDIRI4
ASGNI4
ADDRGP4 cgs+34808
ADDRLP4 24
INDIRI4
ASGNI4
line 1893
;1893:	cgs.flagStatus = -1;
ADDRGP4 cgs+34816
CNSTI4 -1
ASGNI4
line 1897
;1894:	// old servers
;1895:
;1896:	// get the rendering configuration from the client system
;1897:	trap_GetGlconfig( &cgs.glconfig );
ADDRGP4 cgs+20100
ARGP4
ADDRGP4 trap_GetGlconfig
CALLV
pop
line 1898
;1898:	cgs.screenXScale = cgs.glconfig.vidWidth / 640.0;
ADDRGP4 cgs+31432
ADDRGP4 cgs+20100+11304
INDIRI4
CVIF4 4
CNSTF4 1142947840
DIVF4
ASGNF4
line 1899
;1899:	cgs.screenYScale = cgs.glconfig.vidHeight / 480.0;
ADDRGP4 cgs+31436
ADDRGP4 cgs+20100+11308
INDIRI4
CVIF4 4
CNSTF4 1139802112
DIVF4
ASGNF4
line 1902
;1900:
;1901:	// get the gamestate from the client system
;1902:	trap_GetGameState( &cgs.gameState );
ADDRGP4 cgs
ARGP4
ADDRGP4 trap_GetGameState
CALLV
pop
line 1905
;1903:
;1904:	// check version
;1905:	s = CG_ConfigString( CS_GAME_VERSION );
CNSTI4 20
ARGI4
ADDRLP4 28
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 28
INDIRP4
ASGNP4
line 1906
;1906:	if ( strcmp( s, GAME_VERSION ) ) {
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $957
ARGP4
ADDRLP4 32
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
EQI4 $955
line 1907
;1907:		CG_Error( "Client/Server game mismatch: %s/%s", GAME_VERSION, s );
ADDRGP4 $958
ARGP4
ADDRGP4 $957
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_Error
CALLV
pop
line 1908
;1908:	}
LABELV $955
line 1910
;1909:
;1910:	s = CG_ConfigString( CS_LEVEL_START_TIME );
CNSTI4 21
ARGI4
ADDRLP4 36
ADDRGP4 CG_ConfigString
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 36
INDIRP4
ASGNP4
line 1911
;1911:	cgs.levelStartTime = atoi( s );
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRGP4 cgs+34796
ADDRLP4 40
INDIRI4
ASGNI4
line 1913
;1912:
;1913:	CG_ParseServerinfo();
ADDRGP4 CG_ParseServerinfo
CALLV
pop
line 1916
;1914:
;1915:	// load the new map
;1916:	CG_LoadingString( "collision map" );
ADDRGP4 $960
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 1918
;1917:
;1918:	trap_CM_LoadMap( cgs.mapname );
ADDRGP4 cgs+31484
ARGP4
ADDRGP4 trap_CM_LoadMap
CALLV
pop
line 1924
;1919:
;1920:#ifdef MISSIONPACK
;1921:	String_Init();
;1922:#endif
;1923:
;1924:	cg.loading = qtrue;		// force players to load instead of defer
ADDRGP4 cg+20
CNSTI4 1
ASGNI4
line 1926
;1925:
;1926:	CG_LoadingString( "sounds" );
ADDRGP4 $963
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 1928
;1927:
;1928:	CG_RegisterSounds();
ADDRGP4 CG_RegisterSounds
CALLV
pop
line 1930
;1929:
;1930:	CG_LoadingString( "graphics" );
ADDRGP4 $964
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 1932
;1931:
;1932:	CG_RegisterGraphics();
ADDRGP4 CG_RegisterGraphics
CALLV
pop
line 1934
;1933:
;1934:	CG_LoadingString( "monster shaders" );
ADDRGP4 $965
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 1935
;1935:	CG_InitMonsterShaders();
ADDRGP4 CG_InitMonsterShaders
CALLV
pop
line 1937
;1936:
;1937:	CG_LoadingString( "clients" );
ADDRGP4 $966
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 1939
;1938:
;1939:	CG_RegisterClients();		// if low on memory, some clients will be deferred
ADDRGP4 CG_RegisterClients
CALLV
pop
line 1946
;1940:
;1941:#ifdef MISSIONPACK
;1942:	CG_AssetCache();
;1943:	CG_LoadHudMenu();      // load new hud stuff
;1944:#endif
;1945:
;1946:	cg.loading = qfalse;	// future players will be deferred
ADDRGP4 cg+20
CNSTI4 0
ASGNI4
line 1948
;1947:
;1948:	CG_InitLocalEntities();
ADDRGP4 CG_InitLocalEntities
CALLV
pop
line 1950
;1949:
;1950:	CG_InitMarkPolys();
ADDRGP4 CG_InitMarkPolys
CALLV
pop
line 1953
;1951:
;1952:	// remove the last loading update
;1953:	cg.infoScreenText[0] = 0;
ADDRGP4 cg+109436
CNSTI1 0
ASGNI1
line 1956
;1954:
;1955:	// Make sure we have update values (scores)
;1956:	CG_SetConfigValues();
ADDRGP4 CG_SetConfigValues
CALLV
pop
line 1958
;1957:
;1958:	CG_StartMusic();
ADDRGP4 CG_StartMusic
CALLV
pop
line 1960
;1959:
;1960:	CG_LoadingString( "" );
ADDRGP4 $969
ARGP4
ADDRGP4 CG_LoadingString
CALLV
pop
line 1966
;1961:
;1962:#ifdef MISSIONPACK
;1963:	CG_InitTeamChat();
;1964:#endif
;1965:
;1966:	CG_ShaderStateChanged();
ADDRGP4 CG_ShaderStateChanged
CALLV
pop
line 1968
;1967:
;1968:	trap_S_ClearLoopingSounds( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 trap_S_ClearLoopingSounds
CALLV
pop
line 1969
;1969:}
LABELV $926
endproc CG_Init 44 12
export CG_Shutdown
proc CG_Shutdown 0 0
line 1978
;1970:
;1971:/*
;1972:=================
;1973:CG_Shutdown
;1974:
;1975:Called before every level change or subsystem restart
;1976:=================
;1977:*/
;1978:void CG_Shutdown( void ) {
line 1981
;1979:	// some mods may need to do cleanup work here,
;1980:	// like closing files or archiving session data
;1981:}
LABELV $970
endproc CG_Shutdown 0 0
export CG_EventHandling
proc CG_EventHandling 0 0
line 1994
;1982:
;1983:
;1984:/*
;1985:==================
;1986:CG_EventHandling
;1987:==================
;1988: type 0 - no event handling
;1989:      1 - team menu
;1990:      2 - hud editor
;1991:
;1992:*/
;1993:#ifndef MISSIONPACK
;1994:void CG_EventHandling(int type) {
line 1995
;1995:}
LABELV $971
endproc CG_EventHandling 0 0
export CG_KeyEvent
proc CG_KeyEvent 0 0
line 1999
;1996:
;1997:
;1998:
;1999:void CG_KeyEvent(int key, qboolean down) {
line 2000
;2000:}
LABELV $972
endproc CG_KeyEvent 0 0
export CG_MouseEvent
proc CG_MouseEvent 0 0
line 2002
;2001:
;2002:void CG_MouseEvent(int x, int y) {
line 2003
;2003:}
LABELV $973
endproc CG_MouseEvent 0 0
bss
export cg_pmove_msec
align 4
LABELV cg_pmove_msec
skip 272
export cg_hudFiles
align 4
LABELV cg_hudFiles
skip 272
import CG_NewParticleArea
import initparticles
import CG_ParticleExplosion
import CG_ParticleMisc
import CG_ParticleDust
import CG_ParticleSparks
import CG_ParticleBulletDebris
import CG_ParticleSnowFlurry
import CG_AddParticleShrapnel
import CG_ParticleSmoke
import CG_ParticleSnow
import CG_AddParticles
import CG_ClearParticles
import trap_GetEntityToken
import trap_getCameraInfo
import trap_startCamera
import trap_loadCamera
import trap_SnapVector
import trap_CIN_SetExtents
import trap_CIN_DrawCinematic
import trap_CIN_RunCinematic
import trap_CIN_StopCinematic
import trap_CIN_PlayCinematic
import trap_Key_GetKey
import trap_Key_SetCatcher
import trap_Key_GetCatcher
import trap_Key_IsDown
import trap_R_RegisterFont
import trap_MemoryRemaining
import testPrintFloat
import testPrintInt
import trap_SetUserCmdValue
import trap_GetUserCmd
import trap_GetCurrentCmdNumber
import trap_GetServerCommand
import trap_GetSnapshot
import trap_GetCurrentSnapshotNumber
import trap_GetGameState
import trap_GetGlconfig
import trap_R_RemapShader
import trap_R_LerpTag
import trap_R_ModelBounds
import trap_R_DrawStretchPic
import trap_R_SetColor
import trap_R_RenderScene
import trap_R_LightForPoint
import trap_R_AddLightToScene
import trap_R_AddPolysToScene
import trap_R_AddPolyToScene
import trap_R_AddRefEntityToScene
import trap_R_ClearScene
import trap_R_RegisterShaderNoMip
import trap_R_RegisterShader
import trap_R_RegisterSkin
import trap_R_RegisterModel
import trap_R_LoadWorldMap
import trap_S_StopBackgroundTrack
import trap_S_StartBackgroundTrack
import trap_S_RegisterSound
import trap_S_Respatialize
import trap_S_UpdateEntityPosition
import trap_S_AddRealLoopingSound
import trap_S_AddLoopingSound
import trap_S_ClearLoopingSounds
import trap_S_StartLocalSound
import trap_S_StopLoopingSound
import trap_S_StartSound
import trap_CM_MarkFragments
import trap_CM_TransformedBoxTrace
import trap_CM_BoxTrace
import trap_CM_TransformedPointContents
import trap_CM_PointContents
import trap_CM_TempBoxModel
import trap_CM_InlineModel
import trap_CM_NumInlineModels
import trap_CM_LoadMap
import trap_UpdateScreen
import trap_SendClientCommand
import trap_AddCommand
import trap_SendConsoleCommand
import trap_FS_Seek
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_Cvar_VariableStringBuffer
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_Milliseconds
import trap_Error
import trap_Print
import CG_CheckChangedPredictableEvents
import CG_TransitionPlayerState
import CG_Respawn
import CG_PlayBufferedVoiceChats
import CG_VoiceChatLocal
import CG_ShaderStateChanged
import CG_LoadVoiceChats
import CG_SetConfigValues
import CG_ParseServerinfo
import CG_ExecuteNewServerCommands
import CG_InitConsoleCommands
import CG_ConsoleCommand
import CG_DrawOldTourneyScoreboard
import CG_DrawOldScoreboard
import CG_DrawInformation
import CG_LoadingClient
import CG_LoadingItem
import CG_LoadingString
import CG_ProcessSnapshots
import CG_MakeExplosion
import CG_Bleed
import CG_BigExplode
import CG_GibPlayer
import CG_ScorePlum
import CG_SpawnEffect
import CG_BubbleTrail
import CG_SmokePuff
import CG_AddLocalEntities
import CG_AllocLocalEntity
import CG_InitLocalEntities
import CG_ImpactMark
import CG_AddMarks
import CG_InitMarkPolys
import CG_OutOfAmmoChange
import CG_DrawWeaponSelect
import CG_AddPlayerWeapon
import CG_AddViewWeapon
import CG_GrappleTrail
import CG_RailTrail
import CG_Bullet
import CG_ShotgunFire
import CG_MissileHitPlayer
import CG_MissileHitWall
import CG_FireWeapon
import CG_RegisterItemVisuals
import CG_RegisterWeapon
import CG_Weapon_f
import CG_PrevWeapon_f
import CG_NextWeapon_f
import CG_PositionRotatedEntityOnTag
import CG_PositionEntityOnTag
import CG_AdjustPositionForMover
import CG_Beam
import CG_InitMonsterShaders
import CG_AddPacketEntities
import CG_SetEntitySoundPosition
import CG_PainEvent
import CG_EntityEvent
import CG_PlaceString
import CG_CheckEvents
import CG_LoadDeferredPlayers
import CG_PredictPlayerState
import CG_Trace
import CG_PointContents
import CG_BuildSolidList
import CG_CustomSound
import CG_NewClientInfo
import CG_AddRefEntityWithPowerups
import CG_ResetPlayerEntity
import CG_Player
import CG_StatusHandle
import CG_OtherTeamHasFlag
import CG_YourTeamHasFlag
import CG_GameTypeString
import CG_CheckOrderPending
import CG_Text_PaintChar
import CG_Draw3DModel
import CG_GetKillerText
import CG_GetGameStatusText
import CG_GetTeamColor
import CG_InitTeamChat
import CG_SetPrintString
import CG_ShowResponseHead
import CG_RunMenuScript
import CG_OwnerDrawVisible
import CG_GetValue
import CG_SelectNextPlayer
import CG_SelectPrevPlayer
import CG_Text_Height
import CG_Text_Width
import CG_Text_Paint
import CG_OwnerDraw
import CG_DrawTeamBackground
import CG_DrawFlagModel
import CG_DrawActive
import CG_DrawHead
import CG_CenterPrint
import CG_AddLagometerSnapshotInfo
import CG_AddLagometerFrameInfo
import teamChat2
import teamChat1
import systemChat
import drawTeamOverlayModificationCount
import numSortedTeamPlayers
import sortedTeamPlayers
import CG_DrawTopBottom
import CG_DrawSides
import CG_DrawRect
import UI_DrawProportionalString
import CG_GetColorForHealth
import CG_ColorForHealth
import CG_TileClear
import CG_TeamColor
import CG_FadeColor
import CG_DrawStrlen
import CG_DrawSmallStringColor
import CG_DrawSmallString
import CG_DrawBigStringColor
import CG_DrawBigString
import CG_DrawStringExt
import CG_DrawString
import CG_DrawPic
import CG_FillRect
import CG_AdjustFrom640
import CG_DrawActiveFrame
import CG_AddBufferedSound
import CG_ZoomUp_f
import CG_ZoomDown_f
import CG_TestModelPrevSkin_f
import CG_TestModelNextSkin_f
import CG_TestModelPrevFrame_f
import CG_TestModelNextFrame_f
import CG_TestGun_f
import CG_TestModel_f
import CG_GetSelectedScore
import CG_SetScoreSelection
import CG_RankRunFrame
import CG_LoadMenus
export cg_trueLightning
align 4
LABELV cg_trueLightning
skip 272
export cg_oldPlasma
align 4
LABELV cg_oldPlasma
skip 272
export cg_oldRocket
align 4
LABELV cg_oldRocket
skip 272
export cg_oldRail
align 4
LABELV cg_oldRail
skip 272
export cg_noProjectileTrail
align 4
LABELV cg_noProjectileTrail
skip 272
export cg_noTaunt
align 4
LABELV cg_noTaunt
skip 272
export cg_bigFont
align 4
LABELV cg_bigFont
skip 272
export cg_smallFont
align 4
LABELV cg_smallFont
skip 272
export cg_cameraMode
align 4
LABELV cg_cameraMode
skip 272
export cg_timescale
align 4
LABELV cg_timescale
skip 272
export cg_timescaleFadeSpeed
align 4
LABELV cg_timescaleFadeSpeed
skip 272
export cg_timescaleFadeEnd
align 4
LABELV cg_timescaleFadeEnd
skip 272
export cg_cameraOrbitDelay
align 4
LABELV cg_cameraOrbitDelay
skip 272
export cg_cameraOrbit
align 4
LABELV cg_cameraOrbit
skip 272
export pmove_msec
align 4
LABELV pmove_msec
skip 272
export pmove_fixed
align 4
LABELV pmove_fixed
skip 272
export cg_smoothClients
align 4
LABELV cg_smoothClients
skip 272
export cg_scorePlum
align 4
LABELV cg_scorePlum
skip 272
export cg_noVoiceText
align 4
LABELV cg_noVoiceText
skip 272
export cg_noVoiceChats
align 4
LABELV cg_noVoiceChats
skip 272
export cg_teamChatsOnly
align 4
LABELV cg_teamChatsOnly
skip 272
export cg_drawRailTrail
align 4
LABELV cg_drawRailTrail
skip 272
export cg_cleanView
align 4
LABELV cg_cleanView
skip 272
export cg_drawFriend
align 4
LABELV cg_drawFriend
skip 272
export cg_deferPlayers
align 4
LABELV cg_deferPlayers
skip 272
export cg_predictItems
align 4
LABELV cg_predictItems
skip 272
export cg_blood
align 4
LABELV cg_blood
skip 272
export cg_paused
align 4
LABELV cg_paused
skip 272
export cg_buildScript
align 4
LABELV cg_buildScript
skip 272
export cg_forceModel
align 4
LABELV cg_forceModel
skip 272
export cg_stats
align 4
LABELV cg_stats
skip 272
export cg_teamChatHeight
align 4
LABELV cg_teamChatHeight
skip 272
export cg_teamChatTime
align 4
LABELV cg_teamChatTime
skip 272
export cg_synchronousClients
align 4
LABELV cg_synchronousClients
skip 272
export cg_drawAttacker
align 4
LABELV cg_drawAttacker
skip 272
export cg_lagometer
align 4
LABELV cg_lagometer
skip 272
export cg_stereoSeparation
align 4
LABELV cg_stereoSeparation
skip 272
export cg_thirdPerson
align 4
LABELV cg_thirdPerson
skip 272
export cg_thirdPersonAngle
align 4
LABELV cg_thirdPersonAngle
skip 272
export cg_thirdPersonRange
align 4
LABELV cg_thirdPersonRange
skip 272
export cg_zoomFov
align 4
LABELV cg_zoomFov
skip 272
export cg_fov
align 4
LABELV cg_fov
skip 272
export cg_staticItems
align 4
LABELV cg_staticItems
skip 272
export cg_simpleItems
align 4
LABELV cg_simpleItems
skip 272
export cg_ignore
align 4
LABELV cg_ignore
skip 272
export cg_autoswitch
align 4
LABELV cg_autoswitch
skip 272
export cg_tracerLength
align 4
LABELV cg_tracerLength
skip 272
export cg_tracerWidth
align 4
LABELV cg_tracerWidth
skip 272
export cg_tracerChance
align 4
LABELV cg_tracerChance
skip 272
export cg_viewsize
align 4
LABELV cg_viewsize
skip 272
export cg_drawGun
align 4
LABELV cg_drawGun
skip 272
export cg_gun_z
align 4
LABELV cg_gun_z
skip 272
export cg_gun_y
align 4
LABELV cg_gun_y
skip 272
export cg_gun_x
align 4
LABELV cg_gun_x
skip 272
export cg_gun_frame
align 4
LABELV cg_gun_frame
skip 272
export cg_brassTime
align 4
LABELV cg_brassTime
skip 272
export cg_addMarks
align 4
LABELV cg_addMarks
skip 272
export cg_footsteps
align 4
LABELV cg_footsteps
skip 272
export cg_showmiss
align 4
LABELV cg_showmiss
skip 272
export cg_noPlayerAnims
align 4
LABELV cg_noPlayerAnims
skip 272
export cg_nopredict
align 4
LABELV cg_nopredict
skip 272
export cg_errorDecay
align 4
LABELV cg_errorDecay
skip 272
export cg_railTrailTime
align 4
LABELV cg_railTrailTime
skip 272
export cg_debugEvents
align 4
LABELV cg_debugEvents
skip 272
export cg_debugPosition
align 4
LABELV cg_debugPosition
skip 272
export cg_debugAnim
align 4
LABELV cg_debugAnim
skip 272
export cg_animSpeed
align 4
LABELV cg_animSpeed
skip 272
export cg_draw2D
align 4
LABELV cg_draw2D
skip 272
export cg_drawStatus
align 4
LABELV cg_drawStatus
skip 272
export cg_crosshairHealth
align 4
LABELV cg_crosshairHealth
skip 272
export cg_crosshairSize
align 4
LABELV cg_crosshairSize
skip 272
export cg_crosshairY
align 4
LABELV cg_crosshairY
skip 272
export cg_crosshairX
align 4
LABELV cg_crosshairX
skip 272
export cg_teamOverlayUserinfo
align 4
LABELV cg_teamOverlayUserinfo
skip 272
export cg_drawTeamOverlay
align 4
LABELV cg_drawTeamOverlay
skip 272
export cg_drawRewards
align 4
LABELV cg_drawRewards
skip 272
export cg_drawCrosshairNames
align 4
LABELV cg_drawCrosshairNames
skip 272
export cg_drawCrosshair
align 4
LABELV cg_drawCrosshair
skip 272
export cg_drawAmmoWarning
align 4
LABELV cg_drawAmmoWarning
skip 272
export cg_drawIcons
align 4
LABELV cg_drawIcons
skip 272
export cg_draw3dIcons
align 4
LABELV cg_draw3dIcons
skip 272
export cg_drawSnapshot
align 4
LABELV cg_drawSnapshot
skip 272
export cg_drawFPS
align 4
LABELV cg_drawFPS
skip 272
export cg_drawTimer
align 4
LABELV cg_drawTimer
skip 272
export cg_gibs
align 4
LABELV cg_gibs
skip 272
export cg_shadows
align 4
LABELV cg_shadows
skip 272
export cg_swingSpeed
align 4
LABELV cg_swingSpeed
skip 272
export cg_bobroll
align 4
LABELV cg_bobroll
skip 272
export cg_bobpitch
align 4
LABELV cg_bobpitch
skip 272
export cg_bobup
align 4
LABELV cg_bobup
skip 272
export cg_runroll
align 4
LABELV cg_runroll
skip 272
export cg_runpitch
align 4
LABELV cg_runpitch
skip 272
export cg_centertime
align 4
LABELV cg_centertime
skip 272
import cg_markPolys
export cg_items
align 4
LABELV cg_items
skip 6144
export cg_weapons
align 4
LABELV cg_weapons
skip 2176
export cg_entities
align 4
LABELV cg_entities
skip 745472
export cg
align 4
LABELV cg
skip 124992
export cgs
align 4
LABELV cgs
skip 153368
import BG_ParseMonsterConfig
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
LABELV $969
byte 1 0
align 1
LABELV $966
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $965
byte 1 109
byte 1 111
byte 1 110
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 101
byte 1 114
byte 1 115
byte 1 0
align 1
LABELV $964
byte 1 103
byte 1 114
byte 1 97
byte 1 112
byte 1 104
byte 1 105
byte 1 99
byte 1 115
byte 1 0
align 1
LABELV $963
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $960
byte 1 99
byte 1 111
byte 1 108
byte 1 108
byte 1 105
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 109
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $958
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 47
byte 1 83
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 32
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 32
byte 1 109
byte 1 105
byte 1 115
byte 1 109
byte 1 97
byte 1 116
byte 1 99
byte 1 104
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 47
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $957
byte 1 98
byte 1 97
byte 1 115
byte 1 101
byte 1 113
byte 1 51
byte 1 45
byte 1 49
byte 1 0
align 1
LABELV $943
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
byte 1 111
byte 1 110
byte 1 116
byte 1 50
byte 1 95
byte 1 112
byte 1 114
byte 1 111
byte 1 112
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $940
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
byte 1 111
byte 1 110
byte 1 116
byte 1 49
byte 1 95
byte 1 112
byte 1 114
byte 1 111
byte 1 112
byte 1 95
byte 1 103
byte 1 108
byte 1 111
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $937
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
byte 1 111
byte 1 110
byte 1 116
byte 1 49
byte 1 95
byte 1 112
byte 1 114
byte 1 111
byte 1 112
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $934
byte 1 119
byte 1 104
byte 1 105
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $931
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 98
byte 1 105
byte 1 103
byte 1 99
byte 1 104
byte 1 97
byte 1 114
byte 1 115
byte 1 0
align 1
LABELV $923
byte 1 67
byte 1 71
byte 1 95
byte 1 67
byte 1 111
byte 1 110
byte 1 102
byte 1 105
byte 1 103
byte 1 83
byte 1 116
byte 1 114
byte 1 105
byte 1 110
byte 1 103
byte 1 58
byte 1 32
byte 1 98
byte 1 97
byte 1 100
byte 1 32
byte 1 105
byte 1 110
byte 1 100
byte 1 101
byte 1 120
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $898
byte 1 37
byte 1 115
byte 1 32
byte 1 32
byte 1 32
byte 1 32
byte 1 32
byte 1 0
align 1
LABELV $870
byte 1 42
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $863
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 77
byte 1 97
byte 1 114
byte 1 107
byte 1 0
align 1
LABELV $860
byte 1 119
byte 1 97
byte 1 107
byte 1 101
byte 1 0
align 1
LABELV $857
byte 1 109
byte 1 97
byte 1 114
byte 1 107
byte 1 83
byte 1 104
byte 1 97
byte 1 100
byte 1 111
byte 1 119
byte 1 0
align 1
LABELV $854
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 100
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 95
byte 1 109
byte 1 114
byte 1 107
byte 1 0
align 1
LABELV $851
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 100
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 47
byte 1 104
byte 1 111
byte 1 108
byte 1 101
byte 1 95
byte 1 108
byte 1 103
byte 1 95
byte 1 109
byte 1 114
byte 1 107
byte 1 0
align 1
LABELV $848
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 100
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 47
byte 1 98
byte 1 117
byte 1 114
byte 1 110
byte 1 95
byte 1 109
byte 1 101
byte 1 100
byte 1 95
byte 1 109
byte 1 114
byte 1 107
byte 1 0
align 1
LABELV $845
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 100
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 47
byte 1 98
byte 1 117
byte 1 108
byte 1 108
byte 1 101
byte 1 116
byte 1 95
byte 1 109
byte 1 114
byte 1 107
byte 1 0
align 1
LABELV $834
byte 1 109
byte 1 101
byte 1 100
byte 1 97
byte 1 108
byte 1 95
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $831
byte 1 109
byte 1 101
byte 1 100
byte 1 97
byte 1 108
byte 1 95
byte 1 97
byte 1 115
byte 1 115
byte 1 105
byte 1 115
byte 1 116
byte 1 0
align 1
LABELV $828
byte 1 109
byte 1 101
byte 1 100
byte 1 97
byte 1 108
byte 1 95
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $825
byte 1 109
byte 1 101
byte 1 100
byte 1 97
byte 1 108
byte 1 95
byte 1 103
byte 1 97
byte 1 117
byte 1 110
byte 1 116
byte 1 108
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $822
byte 1 109
byte 1 101
byte 1 100
byte 1 97
byte 1 108
byte 1 95
byte 1 101
byte 1 120
byte 1 99
byte 1 101
byte 1 108
byte 1 108
byte 1 101
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $819
byte 1 109
byte 1 101
byte 1 100
byte 1 97
byte 1 108
byte 1 95
byte 1 105
byte 1 109
byte 1 112
byte 1 114
byte 1 101
byte 1 115
byte 1 115
byte 1 105
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $816
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 115
byte 1 104
byte 1 105
byte 1 101
byte 1 108
byte 1 100
byte 1 47
byte 1 115
byte 1 104
byte 1 105
byte 1 101
byte 1 108
byte 1 100
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $813
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 69
byte 1 102
byte 1 102
byte 1 101
byte 1 99
byte 1 116
byte 1 0
align 1
LABELV $810
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 105
byte 1 115
byte 1 99
byte 1 47
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $807
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 104
byte 1 105
byte 1 116
byte 1 115
byte 1 47
byte 1 98
byte 1 111
byte 1 111
byte 1 109
byte 1 48
byte 1 49
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $804
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 104
byte 1 105
byte 1 116
byte 1 115
byte 1 47
byte 1 114
byte 1 105
byte 1 110
byte 1 103
byte 1 48
byte 1 50
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $801
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 104
byte 1 105
byte 1 116
byte 1 115
byte 1 47
byte 1 98
byte 1 117
byte 1 108
byte 1 108
byte 1 101
byte 1 116
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $798
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 69
byte 1 120
byte 1 112
byte 1 108
byte 1 111
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $795
byte 1 115
byte 1 112
byte 1 114
byte 1 105
byte 1 116
byte 1 101
byte 1 115
byte 1 47
byte 1 98
byte 1 97
byte 1 108
byte 1 108
byte 1 111
byte 1 111
byte 1 110
byte 1 51
byte 1 0
align 1
LABELV $790
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 98
byte 1 114
byte 1 97
byte 1 105
byte 1 110
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $787
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 115
byte 1 107
byte 1 117
byte 1 108
byte 1 108
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $784
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 108
byte 1 101
byte 1 103
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $781
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 115
byte 1 116
byte 1 105
byte 1 110
byte 1 101
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $778
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 102
byte 1 111
byte 1 114
byte 1 101
byte 1 97
byte 1 114
byte 1 109
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $775
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $772
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 102
byte 1 105
byte 1 115
byte 1 116
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $769
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 99
byte 1 104
byte 1 101
byte 1 115
byte 1 116
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $766
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 97
byte 1 114
byte 1 109
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $763
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 47
byte 1 97
byte 1 98
byte 1 100
byte 1 111
byte 1 109
byte 1 101
byte 1 110
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $760
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 50
byte 1 47
byte 1 115
byte 1 104
byte 1 101
byte 1 108
byte 1 108
byte 1 115
byte 1 47
byte 1 115
byte 1 95
byte 1 115
byte 1 104
byte 1 101
byte 1 108
byte 1 108
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $757
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 50
byte 1 47
byte 1 115
byte 1 104
byte 1 101
byte 1 108
byte 1 108
byte 1 115
byte 1 47
byte 1 109
byte 1 95
byte 1 115
byte 1 104
byte 1 101
byte 1 108
byte 1 108
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $754
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 114
byte 1 95
byte 1 121
byte 1 101
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 0
align 1
LABELV $751
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 97
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 47
byte 1 97
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 95
byte 1 121
byte 1 101
byte 1 108
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $748
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 99
byte 1 111
byte 1 108
byte 1 111
byte 1 114
byte 1 98
byte 1 97
byte 1 114
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $745
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $742
byte 1 115
byte 1 112
byte 1 114
byte 1 105
byte 1 116
byte 1 101
byte 1 115
byte 1 47
byte 1 102
byte 1 111
byte 1 101
byte 1 0
align 1
LABELV $734
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 51
byte 1 0
align 1
LABELV $730
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 50
byte 1 0
align 1
LABELV $726
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 49
byte 1 0
align 1
LABELV $723
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $719
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 50
byte 1 0
align 1
LABELV $715
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 102
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 49
byte 1 0
align 1
LABELV $712
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 115
byte 1 47
byte 1 98
byte 1 95
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $709
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 115
byte 1 47
byte 1 114
byte 1 95
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $701
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 115
byte 1 107
byte 1 117
byte 1 108
byte 1 108
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $698
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 115
byte 1 107
byte 1 117
byte 1 108
byte 1 108
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $695
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 111
byte 1 114
byte 1 98
byte 1 47
byte 1 98
byte 1 95
byte 1 111
byte 1 114
byte 1 98
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $692
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 47
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 111
byte 1 114
byte 1 98
byte 1 47
byte 1 114
byte 1 95
byte 1 111
byte 1 114
byte 1 98
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $684
byte 1 104
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 83
byte 1 109
byte 1 111
byte 1 107
byte 1 101
byte 1 80
byte 1 117
byte 1 102
byte 1 102
byte 1 0
align 1
LABELV $681
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 114
byte 1 101
byte 1 103
byte 1 101
byte 1 110
byte 1 0
align 1
LABELV $678
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 105
byte 1 110
byte 1 118
byte 1 105
byte 1 115
byte 1 105
byte 1 98
byte 1 105
byte 1 108
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $675
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 87
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $672
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 83
byte 1 117
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $669
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 113
byte 1 117
byte 1 97
byte 1 100
byte 1 87
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $666
byte 1 112
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 115
byte 1 47
byte 1 113
byte 1 117
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $663
byte 1 105
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 110
byte 1 111
byte 1 97
byte 1 109
byte 1 109
byte 1 111
byte 1 0
align 1
LABELV $660
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 116
byte 1 105
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $657
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
LABELV $650
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 115
byte 1 101
byte 1 108
byte 1 101
byte 1 99
byte 1 116
byte 1 0
align 1
LABELV $647
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 109
byte 1 105
byte 1 115
byte 1 99
byte 1 47
byte 1 116
byte 1 114
byte 1 97
byte 1 99
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $644
byte 1 119
byte 1 97
byte 1 116
byte 1 101
byte 1 114
byte 1 66
byte 1 117
byte 1 98
byte 1 98
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $641
byte 1 100
byte 1 105
byte 1 115
byte 1 99
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $638
byte 1 108
byte 1 97
byte 1 103
byte 1 111
byte 1 109
byte 1 101
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $635
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 84
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 0
align 1
LABELV $632
byte 1 115
byte 1 112
byte 1 114
byte 1 105
byte 1 116
byte 1 101
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 49
byte 1 0
align 1
LABELV $629
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 83
byte 1 109
byte 1 111
byte 1 107
byte 1 101
byte 1 80
byte 1 117
byte 1 102
byte 1 102
byte 1 0
align 1
LABELV $626
byte 1 115
byte 1 109
byte 1 111
byte 1 107
byte 1 101
byte 1 80
byte 1 117
byte 1 102
byte 1 102
byte 1 82
byte 1 97
byte 1 103
byte 1 101
byte 1 80
byte 1 114
byte 1 111
byte 1 0
align 1
LABELV $623
byte 1 115
byte 1 109
byte 1 111
byte 1 107
byte 1 101
byte 1 80
byte 1 117
byte 1 102
byte 1 102
byte 1 0
align 1
LABELV $620
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 116
byte 1 97
byte 1 98
byte 1 47
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $617
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 116
byte 1 97
byte 1 98
byte 1 47
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $614
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 116
byte 1 97
byte 1 98
byte 1 47
byte 1 112
byte 1 105
byte 1 110
byte 1 103
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $611
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 116
byte 1 97
byte 1 98
byte 1 47
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $608
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 114
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $605
byte 1 118
byte 1 105
byte 1 101
byte 1 119
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 100
byte 1 66
byte 1 108
byte 1 101
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $602
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 53
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $598
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 52
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $594
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 51
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $590
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 50
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $586
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 115
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 49
byte 1 46
byte 1 116
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $577
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 32
byte 1 109
byte 1 101
byte 1 100
byte 1 105
byte 1 97
byte 1 0
align 1
LABELV $572
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 109
byte 1 105
byte 1 110
byte 1 117
byte 1 115
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $571
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 110
byte 1 105
byte 1 110
byte 1 101
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $570
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 101
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $569
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 115
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $568
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 115
byte 1 105
byte 1 120
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $567
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 102
byte 1 105
byte 1 118
byte 1 101
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $566
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 102
byte 1 111
byte 1 117
byte 1 114
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $565
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 116
byte 1 104
byte 1 114
byte 1 101
byte 1 101
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $564
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 116
byte 1 119
byte 1 111
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $563
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 111
byte 1 110
byte 1 101
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $562
byte 1 103
byte 1 102
byte 1 120
byte 1 47
byte 1 50
byte 1 100
byte 1 47
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 115
byte 1 47
byte 1 122
byte 1 101
byte 1 114
byte 1 111
byte 1 95
byte 1 51
byte 1 50
byte 1 98
byte 1 0
align 1
LABELV $559
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 47
byte 1 104
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 98
byte 1 50
byte 1 97
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $556
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 47
byte 1 104
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 98
byte 1 49
byte 1 97
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $553
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 110
byte 1 95
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $550
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 112
byte 1 114
byte 1 111
byte 1 116
byte 1 101
byte 1 99
byte 1 116
byte 1 51
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $547
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 114
byte 1 101
byte 1 103
byte 1 101
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $544
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 120
byte 1 49
byte 1 97
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $541
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 47
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 108
byte 1 120
byte 1 49
byte 1 97
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $538
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 102
byte 1 49
byte 1 97
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $535
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 99
byte 1 104
byte 1 105
byte 1 110
byte 1 101
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 114
byte 1 105
byte 1 99
byte 1 51
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $532
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 99
byte 1 104
byte 1 105
byte 1 110
byte 1 101
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 114
byte 1 105
byte 1 99
byte 1 50
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $529
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 99
byte 1 104
byte 1 105
byte 1 110
byte 1 101
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 114
byte 1 105
byte 1 99
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $526
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 100
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 51
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $523
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 117
byte 1 115
byte 1 101
byte 1 95
byte 1 109
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $520
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 102
byte 1 108
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $501
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 99
byte 1 108
byte 1 97
byte 1 110
byte 1 107
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $497
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 115
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 104
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $493
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 101
byte 1 110
byte 1 101
byte 1 114
byte 1 103
byte 1 121
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $489
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 109
byte 1 101
byte 1 99
byte 1 104
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $485
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 102
byte 1 108
byte 1 101
byte 1 115
byte 1 104
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $481
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 98
byte 1 111
byte 1 111
byte 1 116
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $478
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 47
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 37
byte 1 105
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $473
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 111
byte 1 114
byte 1 108
byte 1 100
byte 1 47
byte 1 106
byte 1 117
byte 1 109
byte 1 112
byte 1 112
byte 1 97
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $470
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 119
byte 1 97
byte 1 116
byte 1 114
byte 1 95
byte 1 117
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $467
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 119
byte 1 97
byte 1 116
byte 1 114
byte 1 95
byte 1 111
byte 1 117
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $464
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 119
byte 1 97
byte 1 116
byte 1 114
byte 1 95
byte 1 105
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $461
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 108
byte 1 111
byte 1 115
byte 1 116
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $458
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 116
byte 1 105
byte 1 101
byte 1 100
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $455
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 116
byte 1 97
byte 1 107
byte 1 101
byte 1 110
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $452
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 115
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $449
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 97
byte 1 115
byte 1 115
byte 1 105
byte 1 115
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $446
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 104
byte 1 117
byte 1 109
byte 1 105
byte 1 108
byte 1 105
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $443
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 100
byte 1 101
byte 1 110
byte 1 105
byte 1 101
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $440
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 101
byte 1 120
byte 1 99
byte 1 101
byte 1 108
byte 1 108
byte 1 101
byte 1 110
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $437
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 105
byte 1 109
byte 1 112
byte 1 114
byte 1 101
byte 1 115
byte 1 115
byte 1 105
byte 1 118
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $434
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 104
byte 1 105
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $431
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 108
byte 1 97
byte 1 110
byte 1 100
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $428
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 116
byte 1 97
byte 1 108
byte 1 107
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $425
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 110
byte 1 111
byte 1 97
byte 1 109
byte 1 109
byte 1 111
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $422
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $419
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 111
byte 1 114
byte 1 108
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 111
byte 1 117
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $416
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 111
byte 1 114
byte 1 108
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 105
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $413
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 105
byte 1 109
byte 1 112
byte 1 51
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $410
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 105
byte 1 109
byte 1 112
byte 1 50
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $407
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 105
byte 1 109
byte 1 112
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $404
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 47
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 112
byte 1 108
byte 1 116
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $401
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 117
byte 1 115
byte 1 101
byte 1 95
byte 1 110
byte 1 111
byte 1 116
byte 1 104
byte 1 105
byte 1 110
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $398
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 114
byte 1 111
byte 1 102
byte 1 102
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $395
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 99
byte 1 104
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $392
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 115
byte 1 47
byte 1 109
byte 1 97
byte 1 99
byte 1 104
byte 1 105
byte 1 110
byte 1 101
byte 1 103
byte 1 117
byte 1 110
byte 1 47
byte 1 98
byte 1 117
byte 1 108
byte 1 101
byte 1 116
byte 1 98
byte 1 121
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $389
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 95
byte 1 49
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $386
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 49
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $381
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 104
byte 1 111
byte 1 108
byte 1 121
byte 1 115
byte 1 104
byte 1 105
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $378
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 121
byte 1 111
byte 1 117
byte 1 95
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $375
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $372
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 95
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $369
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 95
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $366
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 95
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $358
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 116
byte 1 97
byte 1 107
byte 1 101
byte 1 110
byte 1 95
byte 1 111
byte 1 112
byte 1 112
byte 1 111
byte 1 110
byte 1 101
byte 1 110
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $355
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 116
byte 1 97
byte 1 107
byte 1 101
byte 1 110
byte 1 95
byte 1 121
byte 1 111
byte 1 117
byte 1 114
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $352
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 95
byte 1 111
byte 1 112
byte 1 112
byte 1 111
byte 1 110
byte 1 101
byte 1 110
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $349
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 95
byte 1 121
byte 1 111
byte 1 117
byte 1 114
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $346
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 95
byte 1 111
byte 1 112
byte 1 112
byte 1 111
byte 1 110
byte 1 101
byte 1 110
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $341
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 95
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 115
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $338
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 118
byte 1 111
byte 1 99
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 95
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 115
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $335
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 104
byte 1 105
byte 1 116
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 109
byte 1 97
byte 1 116
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $332
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 115
byte 1 116
byte 1 105
byte 1 101
byte 1 100
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $329
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 115
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $326
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 114
byte 1 101
byte 1 100
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 115
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $323
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 47
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 95
byte 1 121
byte 1 111
byte 1 117
byte 1 114
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $315
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 112
byte 1 114
byte 1 101
byte 1 112
byte 1 97
byte 1 114
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $312
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $309
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 111
byte 1 110
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $306
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 116
byte 1 119
byte 1 111
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $303
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 116
byte 1 104
byte 1 114
byte 1 101
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $300
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 51
byte 1 95
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 115
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $297
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 50
byte 1 95
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 115
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $294
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 49
byte 1 95
byte 1 102
byte 1 114
byte 1 97
byte 1 103
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $291
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 115
byte 1 117
byte 1 100
byte 1 100
byte 1 101
byte 1 110
byte 1 95
byte 1 100
byte 1 101
byte 1 97
byte 1 116
byte 1 104
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $288
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 53
byte 1 95
byte 1 109
byte 1 105
byte 1 110
byte 1 117
byte 1 116
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $285
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 102
byte 1 101
byte 1 101
byte 1 100
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 47
byte 1 49
byte 1 95
byte 1 109
byte 1 105
byte 1 110
byte 1 117
byte 1 116
byte 1 101
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $281
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $275
byte 1 80
byte 1 114
byte 1 101
byte 1 99
byte 1 97
byte 1 99
byte 1 104
byte 1 101
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 58
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 98
byte 1 97
byte 1 100
byte 1 32
byte 1 112
byte 1 114
byte 1 101
byte 1 99
byte 1 97
byte 1 99
byte 1 104
byte 1 101
byte 1 32
byte 1 115
byte 1 116
byte 1 114
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $254
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $213
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $212
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $211
byte 1 104
byte 1 101
byte 1 97
byte 1 100
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $210
byte 1 115
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $209
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $206
byte 1 115
byte 1 118
byte 1 95
byte 1 114
byte 1 117
byte 1 110
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $200
byte 1 48
byte 1 46
byte 1 48
byte 1 0
align 1
LABELV $199
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 114
byte 1 117
byte 1 101
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
LABELV $198
byte 1 99
byte 1 103
byte 1 95
byte 1 111
byte 1 108
byte 1 100
byte 1 80
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 0
align 1
LABELV $197
byte 1 99
byte 1 103
byte 1 95
byte 1 111
byte 1 108
byte 1 100
byte 1 82
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $196
byte 1 99
byte 1 103
byte 1 95
byte 1 111
byte 1 108
byte 1 100
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 0
align 1
LABELV $195
byte 1 117
byte 1 105
byte 1 95
byte 1 98
byte 1 105
byte 1 103
byte 1 70
byte 1 111
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $194
byte 1 48
byte 1 46
byte 1 50
byte 1 53
byte 1 0
align 1
LABELV $193
byte 1 117
byte 1 105
byte 1 95
byte 1 115
byte 1 109
byte 1 97
byte 1 108
byte 1 108
byte 1 70
byte 1 111
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $192
byte 1 99
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 80
byte 1 114
byte 1 111
byte 1 106
byte 1 101
byte 1 99
byte 1 116
byte 1 105
byte 1 108
byte 1 101
byte 1 84
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 0
align 1
LABELV $191
byte 1 99
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 84
byte 1 97
byte 1 117
byte 1 110
byte 1 116
byte 1 0
align 1
LABELV $190
byte 1 56
byte 1 0
align 1
LABELV $189
byte 1 112
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 95
byte 1 109
byte 1 115
byte 1 101
byte 1 99
byte 1 0
align 1
LABELV $188
byte 1 112
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 95
byte 1 102
byte 1 105
byte 1 120
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $187
byte 1 99
byte 1 111
byte 1 109
byte 1 95
byte 1 99
byte 1 97
byte 1 109
byte 1 101
byte 1 114
byte 1 97
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $186
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 109
byte 1 111
byte 1 111
byte 1 116
byte 1 104
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $185
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 99
byte 1 111
byte 1 114
byte 1 101
byte 1 80
byte 1 108
byte 1 117
byte 1 109
byte 1 115
byte 1 0
align 1
LABELV $184
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 115
byte 1 99
byte 1 97
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $183
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 115
byte 1 99
byte 1 97
byte 1 108
byte 1 101
byte 1 70
byte 1 97
byte 1 100
byte 1 101
byte 1 83
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $182
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 115
byte 1 99
byte 1 97
byte 1 108
byte 1 101
byte 1 70
byte 1 97
byte 1 100
byte 1 101
byte 1 69
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $181
byte 1 53
byte 1 48
byte 1 0
align 1
LABELV $180
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 97
byte 1 109
byte 1 101
byte 1 114
byte 1 97
byte 1 79
byte 1 114
byte 1 98
byte 1 105
byte 1 116
byte 1 68
byte 1 101
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $179
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 97
byte 1 109
byte 1 101
byte 1 114
byte 1 97
byte 1 79
byte 1 114
byte 1 98
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $178
byte 1 103
byte 1 95
byte 1 115
byte 1 121
byte 1 110
byte 1 99
byte 1 104
byte 1 114
byte 1 111
byte 1 110
byte 1 111
byte 1 117
byte 1 115
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $177
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
LABELV $176
byte 1 99
byte 1 108
byte 1 95
byte 1 112
byte 1 97
byte 1 117
byte 1 115
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $175
byte 1 99
byte 1 111
byte 1 109
byte 1 95
byte 1 98
byte 1 117
byte 1 105
byte 1 108
byte 1 100
byte 1 83
byte 1 99
byte 1 114
byte 1 105
byte 1 112
byte 1 116
byte 1 0
align 1
LABELV $174
byte 1 99
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 86
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 84
byte 1 101
byte 1 120
byte 1 116
byte 1 0
align 1
LABELV $173
byte 1 99
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 86
byte 1 111
byte 1 105
byte 1 99
byte 1 101
byte 1 67
byte 1 104
byte 1 97
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $172
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 67
byte 1 104
byte 1 97
byte 1 116
byte 1 115
byte 1 79
byte 1 110
byte 1 108
byte 1 121
byte 1 0
align 1
LABELV $171
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
LABELV $170
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 70
byte 1 114
byte 1 105
byte 1 101
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $169
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $168
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 114
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $167
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
LABELV $166
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 114
byte 1 80
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 115
byte 1 0
align 1
LABELV $165
byte 1 99
byte 1 103
byte 1 95
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 73
byte 1 116
byte 1 101
byte 1 109
byte 1 115
byte 1 0
align 1
LABELV $164
byte 1 99
byte 1 103
byte 1 95
byte 1 102
byte 1 111
byte 1 114
byte 1 99
byte 1 101
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $163
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 67
byte 1 104
byte 1 97
byte 1 116
byte 1 72
byte 1 101
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $162
byte 1 51
byte 1 48
byte 1 48
byte 1 48
byte 1 0
align 1
LABELV $161
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 67
byte 1 104
byte 1 97
byte 1 116
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $160
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 104
byte 1 105
byte 1 114
byte 1 100
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $159
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 104
byte 1 105
byte 1 114
byte 1 100
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 65
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $158
byte 1 52
byte 1 48
byte 1 0
align 1
LABELV $157
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 104
byte 1 105
byte 1 114
byte 1 100
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 82
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $156
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 114
byte 1 97
byte 1 99
byte 1 101
byte 1 114
byte 1 108
byte 1 101
byte 1 110
byte 1 103
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $155
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 114
byte 1 97
byte 1 99
byte 1 101
byte 1 114
byte 1 119
byte 1 105
byte 1 100
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $154
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 114
byte 1 97
byte 1 99
byte 1 101
byte 1 114
byte 1 99
byte 1 104
byte 1 97
byte 1 110
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $153
byte 1 99
byte 1 103
byte 1 95
byte 1 102
byte 1 111
byte 1 111
byte 1 116
byte 1 115
byte 1 116
byte 1 101
byte 1 112
byte 1 115
byte 1 0
align 1
LABELV $152
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 104
byte 1 111
byte 1 119
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 0
align 1
LABELV $151
byte 1 99
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 115
byte 1 0
align 1
LABELV $150
byte 1 99
byte 1 103
byte 1 95
byte 1 110
byte 1 111
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 0
align 1
LABELV $149
byte 1 99
byte 1 103
byte 1 95
byte 1 101
byte 1 114
byte 1 114
byte 1 111
byte 1 114
byte 1 100
byte 1 101
byte 1 99
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $148
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 101
byte 1 98
byte 1 117
byte 1 103
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 115
byte 1 0
align 1
LABELV $147
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 101
byte 1 98
byte 1 117
byte 1 103
byte 1 112
byte 1 111
byte 1 115
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $146
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 101
byte 1 98
byte 1 117
byte 1 103
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 0
align 1
LABELV $145
byte 1 99
byte 1 103
byte 1 95
byte 1 97
byte 1 110
byte 1 105
byte 1 109
byte 1 115
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $144
byte 1 48
byte 1 46
byte 1 51
byte 1 0
align 1
LABELV $143
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 119
byte 1 105
byte 1 110
byte 1 103
byte 1 83
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $142
byte 1 99
byte 1 103
byte 1 95
byte 1 98
byte 1 111
byte 1 98
byte 1 114
byte 1 111
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $141
byte 1 99
byte 1 103
byte 1 95
byte 1 98
byte 1 111
byte 1 98
byte 1 112
byte 1 105
byte 1 116
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $140
byte 1 99
byte 1 103
byte 1 95
byte 1 98
byte 1 111
byte 1 98
byte 1 117
byte 1 112
byte 1 0
align 1
LABELV $139
byte 1 48
byte 1 46
byte 1 48
byte 1 48
byte 1 53
byte 1 0
align 1
LABELV $138
byte 1 99
byte 1 103
byte 1 95
byte 1 114
byte 1 117
byte 1 110
byte 1 114
byte 1 111
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $137
byte 1 48
byte 1 46
byte 1 48
byte 1 48
byte 1 50
byte 1 0
align 1
LABELV $136
byte 1 99
byte 1 103
byte 1 95
byte 1 114
byte 1 117
byte 1 110
byte 1 112
byte 1 105
byte 1 116
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $135
byte 1 51
byte 1 0
align 1
LABELV $134
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 101
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $133
byte 1 99
byte 1 103
byte 1 95
byte 1 103
byte 1 117
byte 1 110
byte 1 90
byte 1 0
align 1
LABELV $132
byte 1 99
byte 1 103
byte 1 95
byte 1 103
byte 1 117
byte 1 110
byte 1 89
byte 1 0
align 1
LABELV $131
byte 1 99
byte 1 103
byte 1 95
byte 1 103
byte 1 117
byte 1 110
byte 1 88
byte 1 0
align 1
LABELV $130
byte 1 52
byte 1 48
byte 1 48
byte 1 0
align 1
LABELV $129
byte 1 99
byte 1 103
byte 1 95
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 84
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $128
byte 1 99
byte 1 103
byte 1 95
byte 1 108
byte 1 97
byte 1 103
byte 1 111
byte 1 109
byte 1 101
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $127
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
LABELV $126
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
LABELV $125
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
LABELV $124
byte 1 50
byte 1 53
byte 1 48
byte 1 48
byte 1 0
align 1
LABELV $123
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
LABELV $122
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 89
byte 1 0
align 1
LABELV $121
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 88
byte 1 0
align 1
LABELV $120
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 72
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $119
byte 1 50
byte 1 52
byte 1 0
align 1
LABELV $118
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 83
byte 1 105
byte 1 122
byte 1 101
byte 1 0
align 1
LABELV $117
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 82
byte 1 101
byte 1 119
byte 1 97
byte 1 114
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $116
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
LABELV $115
byte 1 52
byte 1 0
align 1
LABELV $114
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
LABELV $113
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 65
byte 1 116
byte 1 116
byte 1 97
byte 1 99
byte 1 107
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $112
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 65
byte 1 109
byte 1 109
byte 1 111
byte 1 87
byte 1 97
byte 1 114
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $111
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 73
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 0
align 1
LABELV $110
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 51
byte 1 100
byte 1 73
byte 1 99
byte 1 111
byte 1 110
byte 1 115
byte 1 0
align 1
LABELV $109
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 0
align 1
LABELV $108
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 70
byte 1 80
byte 1 83
byte 1 0
align 1
LABELV $107
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $106
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 83
byte 1 116
byte 1 97
byte 1 116
byte 1 117
byte 1 115
byte 1 0
align 1
LABELV $105
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 50
byte 1 68
byte 1 0
align 1
LABELV $104
byte 1 99
byte 1 103
byte 1 95
byte 1 103
byte 1 105
byte 1 98
byte 1 115
byte 1 0
align 1
LABELV $103
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 104
byte 1 97
byte 1 100
byte 1 111
byte 1 119
byte 1 115
byte 1 0
align 1
LABELV $102
byte 1 48
byte 1 46
byte 1 52
byte 1 0
align 1
LABELV $101
byte 1 99
byte 1 103
byte 1 95
byte 1 115
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 111
byte 1 83
byte 1 101
byte 1 112
byte 1 97
byte 1 114
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $100
byte 1 49
byte 1 48
byte 1 48
byte 1 0
align 1
LABELV $99
byte 1 99
byte 1 103
byte 1 95
byte 1 118
byte 1 105
byte 1 101
byte 1 119
byte 1 115
byte 1 105
byte 1 122
byte 1 101
byte 1 0
align 1
LABELV $98
byte 1 57
byte 1 48
byte 1 0
align 1
LABELV $97
byte 1 99
byte 1 103
byte 1 95
byte 1 102
byte 1 111
byte 1 118
byte 1 0
align 1
LABELV $96
byte 1 50
byte 1 50
byte 1 46
byte 1 53
byte 1 0
align 1
LABELV $95
byte 1 99
byte 1 103
byte 1 95
byte 1 122
byte 1 111
byte 1 111
byte 1 109
byte 1 102
byte 1 111
byte 1 118
byte 1 0
align 1
LABELV $94
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 71
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $93
byte 1 99
byte 1 103
byte 1 95
byte 1 97
byte 1 117
byte 1 116
byte 1 111
byte 1 115
byte 1 119
byte 1 105
byte 1 116
byte 1 99
byte 1 104
byte 1 0
align 1
LABELV $92
byte 1 48
byte 1 0
align 1
LABELV $91
byte 1 99
byte 1 103
byte 1 95
byte 1 105
byte 1 103
byte 1 110
byte 1 111
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $90
byte 1 49
byte 1 0
align 1
LABELV $89
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
LABELV $86
byte 1 118
byte 1 109
byte 1 77
byte 1 97
byte 1 105
byte 1 110
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 110
byte 1 32
byte 1 99
byte 1 111
byte 1 109
byte 1 109
byte 1 97
byte 1 110
byte 1 100
byte 1 32
byte 1 37
byte 1 105
byte 1 0
