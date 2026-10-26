export BotSetUserInfo
code
proc BotSetUserInfo 1024 12
file "../ai_dmq3.c"
line 117
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
;23:
;24:/*****************************************************************************
;25: * name:		ai_dmq3.c
;26: *
;27: * desc:		Quake3 bot AI
;28: *
;29: * $Archive: /MissionPack/code/game/ai_dmq3.c $
;30: *
;31: *****************************************************************************/
;32:
;33:
;34:#include "g_local.h"
;35:#include "botlib.h"
;36:#include "be_aas.h"
;37:#include "be_ea.h"
;38:#include "be_ai_char.h"
;39:#include "be_ai_chat.h"
;40:#include "be_ai_gen.h"
;41:#include "be_ai_goal.h"
;42:#include "be_ai_move.h"
;43:#include "be_ai_weap.h"
;44://
;45:#include "ai_main.h"
;46:#include "ai_dmq3.h"
;47:#include "ai_assault.h"
;48:#include "ai_chat.h"
;49:#include "ai_cmd.h"
;50:#include "ai_dmnet.h"
;51:#include "ai_team.h"
;52://
;53:#include "chars.h"				//characteristics
;54:#include "inv.h"				//indexes into the inventory
;55:#include "syn.h"				//synonyms
;56:#include "match.h"				//string matching types and vars
;57:
;58:// for the voice chats
;59:#include "../../ui/menudef.h" // sos001205 - for q3_ui also
;60:
;61:// from aasfile.h
;62:#define AREACONTENTS_MOVER				1024
;63:#define AREACONTENTS_MODELNUMSHIFT		24
;64:#define AREACONTENTS_MAXMODELNUM		0xFF
;65:#define AREACONTENTS_MODELNUM			(AREACONTENTS_MAXMODELNUM << AREACONTENTS_MODELNUMSHIFT)
;66:
;67:#define IDEAL_ATTACKDIST			140
;68:
;69:#define MAX_WAYPOINTS		128
;70://
;71:bot_waypoint_t botai_waypoints[MAX_WAYPOINTS];
;72:bot_waypoint_t *botai_freewaypoints;
;73:
;74://NOTE: not using a cvars which can be updated because the game should be reloaded anyway
;75:int gametype;		//game type
;76:int maxclients;		//maximum number of clients
;77:
;78:vmCvar_t bot_grapple;
;79:vmCvar_t bot_rocketjump;
;80:vmCvar_t bot_fastchat;
;81:vmCvar_t bot_nochat;
;82:vmCvar_t bot_testrchat;
;83:vmCvar_t bot_challenge;
;84:vmCvar_t bot_predictobstacles;
;85:vmCvar_t g_spSkill;
;86:
;87:extern vmCvar_t bot_developer;
;88:
;89:vec3_t lastteleport_origin;		//last teleport event origin
;90:float lastteleport_time;		//last teleport event time
;91:int max_bspmodelindex;			//maximum BSP model index
;92:
;93://CTF flag goals
;94:bot_goal_t ctf_redflag;
;95:bot_goal_t ctf_blueflag;
;96:#ifdef MISSIONPACK
;97:bot_goal_t ctf_neutralflag;
;98:bot_goal_t redobelisk;
;99:bot_goal_t blueobelisk;
;100:bot_goal_t neutralobelisk;
;101:#endif
;102:
;103:#define MAX_ALTROUTEGOALS		32
;104:
;105:int altroutegoals_setup;
;106:aas_altroutegoal_t red_altroutegoals[MAX_ALTROUTEGOALS];
;107:int red_numaltroutegoals;
;108:aas_altroutegoal_t blue_altroutegoals[MAX_ALTROUTEGOALS];
;109:int blue_numaltroutegoals;
;110:
;111:
;112:/*
;113:==================
;114:BotSetUserInfo
;115:==================
;116:*/
;117:void BotSetUserInfo(bot_state_t *bs, char *key, char *value) {
line 120
;118:	char userinfo[MAX_INFO_STRING];
;119:
;120:	trap_GetUserinfo(bs->client, userinfo, sizeof(userinfo));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetUserinfo
CALLV
pop
line 121
;121:	Info_SetValueForKey(userinfo, key, value);
ADDRLP4 0
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 Info_SetValueForKey
CALLV
pop
line 122
;122:	trap_SetUserinfo(bs->client, userinfo);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_SetUserinfo
CALLV
pop
line 123
;123:	ClientUserinfoChanged( bs->client );
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 ClientUserinfoChanged
CALLV
pop
line 124
;124:}
LABELV $57
endproc BotSetUserInfo 1024 12
export BotCTFCarryingFlag
proc BotCTFCarryingFlag 0 0
line 131
;125:
;126:/*
;127:==================
;128:BotCTFCarryingFlag
;129:==================
;130:*/
;131:int BotCTFCarryingFlag(bot_state_t *bs) {
line 132
;132:	if (gametype != GT_CTF) return CTF_FLAG_NONE;
ADDRGP4 gametype
INDIRI4
CNSTI4 4
EQI4 $59
CNSTI4 0
RETI4
ADDRGP4 $58
JUMPV
LABELV $59
line 134
;133:
;134:	if (bs->inventory[INVENTORY_REDFLAG] > 0) return CTF_FLAG_RED;
ADDRFP4 0
INDIRP4
CNSTI4 5132
ADDP4
INDIRI4
CNSTI4 0
LEI4 $61
CNSTI4 1
RETI4
ADDRGP4 $58
JUMPV
LABELV $61
line 135
;135:	else if (bs->inventory[INVENTORY_BLUEFLAG] > 0) return CTF_FLAG_BLUE;
ADDRFP4 0
INDIRP4
CNSTI4 5136
ADDP4
INDIRI4
CNSTI4 0
LEI4 $63
CNSTI4 2
RETI4
ADDRGP4 $58
JUMPV
LABELV $63
line 136
;136:	return CTF_FLAG_NONE;
CNSTI4 0
RETI4
LABELV $58
endproc BotCTFCarryingFlag 0 0
export BotTeam
proc BotTeam 1044 12
line 144
;137:}
;138:
;139:/*
;140:==================
;141:BotTeam
;142:==================
;143:*/
;144:int BotTeam(bot_state_t *bs) {
line 147
;145:	char info[1024];
;146:
;147:	if (bs->client < 0 || bs->client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $68
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $66
LABELV $68
line 149
;148:		//BotAI_Print(PRT_ERROR, "BotCTFTeam: client out of range\n");
;149:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $65
JUMPV
LABELV $66
line 151
;150:	}
;151:	trap_GetConfigstring(CS_PLAYERS+bs->client, info, sizeof(info));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 153
;152:	//
;153:	if (atoi(Info_ValueForKey(info, "t")) == TEAM_RED) return TEAM_RED;
ADDRLP4 0
ARGP4
ADDRGP4 $71
ARGP4
ADDRLP4 1028
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1028
INDIRP4
ARGP4
ADDRLP4 1032
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 1
NEI4 $69
CNSTI4 1
RETI4
ADDRGP4 $65
JUMPV
LABELV $69
line 154
;154:	else if (atoi(Info_ValueForKey(info, "t")) == TEAM_BLUE) return TEAM_BLUE;
ADDRLP4 0
ARGP4
ADDRGP4 $71
ARGP4
ADDRLP4 1036
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1036
INDIRP4
ARGP4
ADDRLP4 1040
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 2
NEI4 $72
CNSTI4 2
RETI4
ADDRGP4 $65
JUMPV
LABELV $72
line 155
;155:	return TEAM_FREE;
CNSTI4 0
RETI4
LABELV $65
endproc BotTeam 1044 12
export BotOppositeTeam
proc BotOppositeTeam 12 4
line 163
;156:}
;157:
;158:/*
;159:==================
;160:BotOppositeTeam
;161:==================
;162:*/
;163:int BotOppositeTeam(bot_state_t *bs) {
line 164
;164:	switch(BotTeam(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
EQI4 $78
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $79
ADDRGP4 $75
JUMPV
LABELV $78
line 165
;165:		case TEAM_RED: return TEAM_BLUE;
CNSTI4 2
RETI4
ADDRGP4 $74
JUMPV
LABELV $79
line 166
;166:		case TEAM_BLUE: return TEAM_RED;
CNSTI4 1
RETI4
ADDRGP4 $74
JUMPV
LABELV $75
line 167
;167:		default: return TEAM_FREE;
CNSTI4 0
RETI4
LABELV $74
endproc BotOppositeTeam 12 4
export BotEnemyFlag
proc BotEnemyFlag 4 4
line 176
;168:	}
;169:}
;170:
;171:/*
;172:==================
;173:BotEnemyFlag
;174:==================
;175:*/
;176:bot_goal_t *BotEnemyFlag(bot_state_t *bs) {
line 177
;177:	if (BotTeam(bs) == TEAM_RED) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $81
line 178
;178:		return &ctf_blueflag;
ADDRGP4 ctf_blueflag
RETP4
ADDRGP4 $80
JUMPV
LABELV $81
line 180
;179:	}
;180:	else {
line 181
;181:		return &ctf_redflag;
ADDRGP4 ctf_redflag
RETP4
LABELV $80
endproc BotEnemyFlag 4 4
export BotTeamFlag
proc BotTeamFlag 4 4
line 190
;182:	}
;183:}
;184:
;185:/*
;186:==================
;187:BotTeamFlag
;188:==================
;189:*/
;190:bot_goal_t *BotTeamFlag(bot_state_t *bs) {
line 191
;191:	if (BotTeam(bs) == TEAM_RED) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $84
line 192
;192:		return &ctf_redflag;
ADDRGP4 ctf_redflag
RETP4
ADDRGP4 $83
JUMPV
LABELV $84
line 194
;193:	}
;194:	else {
line 195
;195:		return &ctf_blueflag;
ADDRGP4 ctf_blueflag
RETP4
LABELV $83
endproc BotTeamFlag 4 4
export EntityIsDead
proc EntityIsDead 488 8
line 216
;196:	}
;197:}
;198:
;199:
;200:/*
;201:==================
;202:EntityIsDead
;203:==================
;204:*/
;205:/*qboolean EntityIsDead(aas_entityinfo_t *entinfo) {
;206:	playerState_t ps;
;207:
;208:	if (entinfo->number >= 0 && entinfo->number < MAX_CLIENTS) {
;209:		//retrieve the current client state
;210:		BotAI_GetClientState( entinfo->number, &ps );
;211:		if (ps.pm_type != PM_NORMAL) return qtrue;
;212:	}
;213:	return qfalse;
;214:}*/
;215://for monsters
;216:qboolean EntityIsDead(aas_entityinfo_t *entinfo) {
line 219
;217:	playerState_t ps;
;218:
;219:	if (entinfo->number >= 0 &&
ADDRLP4 468
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ASGNI4
ADDRLP4 468
INDIRI4
CNSTI4 0
LTI4 $87
ADDRLP4 468
INDIRI4
CNSTI4 64
GEI4 $87
line 220
;220:		entinfo->number < MAX_CLIENTS) {
line 221
;221:		BotAI_GetClientState(entinfo->number, &ps);
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotAI_GetClientState
CALLI4
pop
line 223
;222:
;223:		if (ps.pm_type != PM_NORMAL) {
ADDRLP4 0+4
INDIRI4
CNSTI4 0
EQI4 $89
line 224
;224:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $86
JUMPV
LABELV $89
line 226
;225:		}
;226:	}
LABELV $87
line 228
;227:
;228:	if (g_monsterHunt.integer &&
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $92
ADDRLP4 472
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ASGNI4
ADDRLP4 472
INDIRI4
CNSTI4 64
LTI4 $92
ADDRLP4 472
INDIRI4
ADDRGP4 level+12
INDIRI4
GEI4 $92
line 230
;229:		entinfo->number >= MAX_CLIENTS &&
;230:		entinfo->number < level.num_entities) {
line 233
;231:		gentity_t *ent;
;232:
;233:		ent = &g_entities[entinfo->number];
ADDRLP4 476
CNSTI4 884
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 235
;234:
;235:		if (ent->s.eType == ET_MONSTER) {
ADDRLP4 476
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
NEI4 $96
line 236
;236:			if (!ent->inuse ||
ADDRLP4 480
ADDRLP4 476
INDIRP4
ASGNP4
ADDRLP4 484
CNSTI4 0
ASGNI4
ADDRLP4 480
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
ADDRLP4 484
INDIRI4
EQI4 $101
ADDRLP4 480
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 484
INDIRI4
NEI4 $101
ADDRLP4 480
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 484
INDIRI4
GTI4 $98
LABELV $101
line 238
;237:				ent->monsterDead ||
;238:				ent->health <= 0) {
line 239
;239:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $86
JUMPV
LABELV $98
line 241
;240:			}
;241:		}
LABELV $96
line 242
;242:	}
LABELV $92
line 244
;243:
;244:	return qfalse;
CNSTI4 0
RETI4
LABELV $86
endproc EntityIsDead 488 8
export EntityCarriesFlag
proc EntityCarriesFlag 0 0
line 252
;245:}
;246:
;247:/*
;248:==================
;249:EntityCarriesFlag
;250:==================
;251:*/
;252:qboolean EntityCarriesFlag(aas_entityinfo_t *entinfo) {
line 253
;253:	if ( entinfo->powerups & ( 1 << PW_REDFLAG ) )
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $103
line 254
;254:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $102
JUMPV
LABELV $103
line 255
;255:	if ( entinfo->powerups & ( 1 << PW_BLUEFLAG ) )
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $105
line 256
;256:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $102
JUMPV
LABELV $105
line 261
;257:#ifdef MISSIONPACK
;258:	if ( entinfo->powerups & ( 1 << PW_NEUTRALFLAG ) )
;259:		return qtrue;
;260:#endif
;261:	return qfalse;
CNSTI4 0
RETI4
LABELV $102
endproc EntityCarriesFlag 0 0
export EntityIsInvisible
proc EntityIsInvisible 4 4
line 269
;262:}
;263:
;264:/*
;265:==================
;266:EntityIsInvisible
;267:==================
;268:*/
;269:qboolean EntityIsInvisible(aas_entityinfo_t *entinfo) {
line 271
;270:	// the flag is always visible
;271:	if (EntityCarriesFlag(entinfo)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $108
line 272
;272:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $107
JUMPV
LABELV $108
line 274
;273:	}
;274:	if (entinfo->powerups & (1 << PW_INVIS)) {
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $110
line 275
;275:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $107
JUMPV
LABELV $110
line 277
;276:	}
;277:	return qfalse;
CNSTI4 0
RETI4
LABELV $107
endproc EntityIsInvisible 4 4
export EntityIsShooting
proc EntityIsShooting 0 0
line 285
;278:}
;279:
;280:/*
;281:==================
;282:EntityIsShooting
;283:==================
;284:*/
;285:qboolean EntityIsShooting(aas_entityinfo_t *entinfo) {
line 286
;286:	if (entinfo->flags & EF_FIRING) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $113
line 287
;287:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $112
JUMPV
LABELV $113
line 289
;288:	}
;289:	return qfalse;
CNSTI4 0
RETI4
LABELV $112
endproc EntityIsShooting 0 0
export EntityIsChatting
proc EntityIsChatting 0 0
line 297
;290:}
;291:
;292:/*
;293:==================
;294:EntityIsChatting
;295:==================
;296:*/
;297:qboolean EntityIsChatting(aas_entityinfo_t *entinfo) {
line 298
;298:	if (entinfo->flags & EF_TALK) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $116
line 299
;299:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $115
JUMPV
LABELV $116
line 301
;300:	}
;301:	return qfalse;
CNSTI4 0
RETI4
LABELV $115
endproc EntityIsChatting 0 0
export EntityHasQuad
proc EntityHasQuad 0 0
line 309
;302:}
;303:
;304:/*
;305:==================
;306:EntityHasQuad
;307:==================
;308:*/
;309:qboolean EntityHasQuad(aas_entityinfo_t *entinfo) {
line 310
;310:	if (entinfo->powerups & (1 << PW_QUAD)) {
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $119
line 311
;311:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $118
JUMPV
LABELV $119
line 313
;312:	}
;313:	return qfalse;
CNSTI4 0
RETI4
LABELV $118
endproc EntityHasQuad 0 0
export BotRememberLastOrderedTask
proc BotRememberLastOrderedTask 16 12
line 377
;314:}
;315:
;316:#ifdef MISSIONPACK
;317:/*
;318:==================
;319:EntityHasKamikze
;320:==================
;321:*/
;322:qboolean EntityHasKamikaze(aas_entityinfo_t *entinfo) {
;323:	if (entinfo->flags & EF_KAMIKAZE) {
;324:		return qtrue;
;325:	}
;326:	return qfalse;
;327:}
;328:
;329:/*
;330:==================
;331:EntityCarriesCubes
;332:==================
;333:*/
;334:qboolean EntityCarriesCubes(aas_entityinfo_t *entinfo) {
;335:	entityState_t state;
;336:
;337:	if (gametype != GT_HARVESTER)
;338:		return qfalse;
;339:	//FIXME: get this info from the aas_entityinfo_t ?
;340:	BotAI_GetEntityState(entinfo->number, &state);
;341:	if (state.generic1 > 0)
;342:		return qtrue;
;343:	return qfalse;
;344:}
;345:
;346:/*
;347:==================
;348:Bot1FCTFCarryingFlag
;349:==================
;350:*/
;351:int Bot1FCTFCarryingFlag(bot_state_t *bs) {
;352:	if (gametype != GT_1FCTF) return qfalse;
;353:
;354:	if (bs->inventory[INVENTORY_NEUTRALFLAG] > 0) return qtrue;
;355:	return qfalse;
;356:}
;357:
;358:/*
;359:==================
;360:BotHarvesterCarryingCubes
;361:==================
;362:*/
;363:int BotHarvesterCarryingCubes(bot_state_t *bs) {
;364:	if (gametype != GT_HARVESTER) return qfalse;
;365:
;366:	if (bs->inventory[INVENTORY_REDCUBE] > 0) return qtrue;
;367:	if (bs->inventory[INVENTORY_BLUECUBE] > 0) return qtrue;
;368:	return qfalse;
;369:}
;370:#endif
;371:
;372:/*
;373:==================
;374:BotRememberLastOrderedTask
;375:==================
;376:*/
;377:void BotRememberLastOrderedTask(bot_state_t *bs) {
line 378
;378:	if (!bs->ordered) {
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $122
line 379
;379:		return;
ADDRGP4 $121
JUMPV
LABELV $122
line 381
;380:	}
;381:	bs->lastgoal_decisionmaker = bs->decisionmaker;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 6756
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ASGNI4
line 382
;382:	bs->lastgoal_ltgtype = bs->ltgtype;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 6760
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
line 383
;383:	memcpy(&bs->lastgoal_teamgoal, &bs->teamgoal, sizeof(bot_goal_t));
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 6768
ADDP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 384
;384:	bs->lastgoal_teammate = bs->teammate;
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 6764
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ASGNI4
line 385
;385:}
LABELV $121
endproc BotRememberLastOrderedTask 16 12
export BotSetTeamStatus
proc BotSetTeamStatus 0 0
line 392
;386:
;387:/*
;388:==================
;389:BotSetTeamStatus
;390:==================
;391:*/
;392:void BotSetTeamStatus(bot_state_t *bs) {
line 449
;393:#ifdef MISSIONPACK
;394:	int teamtask;
;395:	aas_entityinfo_t entinfo;
;396:
;397:	teamtask = TEAMTASK_PATROL;
;398:
;399:	switch(bs->ltgtype) {
;400:		case LTG_TEAMHELP:
;401:			break;
;402:		case LTG_TEAMACCOMPANY:
;403:			BotEntityInfo(bs->teammate, &entinfo);
;404:			if ( ( (gametype == GT_CTF || gametype == GT_1FCTF) && EntityCarriesFlag(&entinfo))
;405:				|| ( gametype == GT_HARVESTER && EntityCarriesCubes(&entinfo)) ) {
;406:				teamtask = TEAMTASK_ESCORT;
;407:			}
;408:			else {
;409:				teamtask = TEAMTASK_FOLLOW;
;410:			}
;411:			break;
;412:		case LTG_DEFENDKEYAREA:
;413:			teamtask = TEAMTASK_DEFENSE;
;414:			break;
;415:		case LTG_GETFLAG:
;416:			teamtask = TEAMTASK_OFFENSE;
;417:			break;
;418:		case LTG_RUSHBASE:
;419:			teamtask = TEAMTASK_DEFENSE;
;420:			break;
;421:		case LTG_RETURNFLAG:
;422:			teamtask = TEAMTASK_RETRIEVE;
;423:			break;
;424:		case LTG_CAMP:
;425:		case LTG_CAMPORDER:
;426:			teamtask = TEAMTASK_CAMP;
;427:			break;
;428:		case LTG_PATROL:
;429:			teamtask = TEAMTASK_PATROL;
;430:			break;
;431:		case LTG_GETITEM:
;432:			teamtask = TEAMTASK_PATROL;
;433:			break;
;434:		case LTG_KILL:
;435:			teamtask = TEAMTASK_PATROL;
;436:			break;
;437:		case LTG_HARVEST:
;438:			teamtask = TEAMTASK_OFFENSE;
;439:			break;
;440:		case LTG_ATTACKENEMYBASE:
;441:			teamtask = TEAMTASK_OFFENSE;
;442:			break;
;443:		default:
;444:			teamtask = TEAMTASK_PATROL;
;445:			break;
;446:	}
;447:	BotSetUserInfo(bs, "teamtask", va("%d", teamtask));
;448:#endif
;449:}
LABELV $124
endproc BotSetTeamStatus 0 0
export BotSetLastOrderedTask
proc BotSetLastOrderedTask 60 16
line 456
;450:
;451:/*
;452:==================
;453:BotSetLastOrderedTask
;454:==================
;455:*/
;456:int BotSetLastOrderedTask(bot_state_t *bs) {
line 458
;457:
;458:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $126
line 460
;459:		// don't go back to returning the flag if it's at the base
;460:		if ( bs->lastgoal_ltgtype == LTG_RETURNFLAG ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 6
NEI4 $128
line 461
;461:			if ( BotTeam(bs) == TEAM_RED ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $130
line 462
;462:				if ( bs->redflagstatus == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
CNSTI4 0
NEI4 $131
line 463
;463:					bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 464
;464:				}
line 465
;465:			}
ADDRGP4 $131
JUMPV
LABELV $130
line 466
;466:			else {
line 467
;467:				if ( bs->blueflagstatus == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
CNSTI4 0
NEI4 $134
line 468
;468:					bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 469
;469:				}
LABELV $134
line 470
;470:			}
LABELV $131
line 471
;471:		}
LABELV $128
line 472
;472:	}
LABELV $126
line 474
;473:
;474:	if ( bs->lastgoal_ltgtype ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $136
line 475
;475:		bs->decisionmaker = bs->lastgoal_decisionmaker;
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 6756
ADDP4
INDIRI4
ASGNI4
line 476
;476:		bs->ordered = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 1
ASGNI4
line 477
;477:		bs->ltgtype = bs->lastgoal_ltgtype;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 6600
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
ASGNI4
line 478
;478:		memcpy(&bs->teamgoal, &bs->lastgoal_teamgoal, sizeof(bot_goal_t));
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 6768
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 479
;479:		bs->teammate = bs->lastgoal_teammate;
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 6764
ADDP4
INDIRI4
ASGNI4
line 480
;480:		bs->teamgoal_time = FloatTime() + 300;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1133903872
ADDF4
ASGNF4
line 481
;481:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 483
;482:		//
;483:		if ( gametype == GT_CTF ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $138
line 484
;484:			if ( bs->ltgtype == LTG_GETFLAG ) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $140
line 488
;485:				bot_goal_t *tb, *eb;
;486:				int tt, et;
;487:
;488:				tb = BotTeamFlag(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 BotTeamFlag
CALLP4
ASGNP4
ADDRLP4 16
ADDRLP4 32
INDIRP4
ASGNP4
line 489
;489:				eb = BotEnemyFlag(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 36
ADDRGP4 BotEnemyFlag
CALLP4
ASGNP4
ADDRLP4 20
ADDRLP4 36
INDIRP4
ASGNP4
line 490
;490:				tt = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, tb->areanum, TFL_DEFAULT);
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 40
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 40
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 16
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 18616254
ARGI4
ADDRLP4 44
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 24
ADDRLP4 44
INDIRI4
ASGNI4
line 491
;491:				et = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, eb->areanum, TFL_DEFAULT);
ADDRLP4 48
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 48
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 48
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 20
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 18616254
ARGI4
ADDRLP4 52
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 28
ADDRLP4 52
INDIRI4
ASGNI4
line 493
;492:				// if the travel time towards the enemy base is larger than towards our base
;493:				if (et > tt) {
ADDRLP4 28
INDIRI4
ADDRLP4 24
INDIRI4
LEI4 $142
line 495
;494:					//get an alternative route goal towards the enemy base
;495:					BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 56
ADDRGP4 BotOppositeTeam
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 56
INDIRI4
ARGI4
ADDRGP4 BotGetAlternateRouteGoal
CALLI4
pop
line 496
;496:				}
LABELV $142
line 497
;497:			}
LABELV $140
line 498
;498:		}
LABELV $138
line 499
;499:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $125
JUMPV
LABELV $136
line 501
;500:	}
;501:	return qfalse;
CNSTI4 0
RETI4
LABELV $125
endproc BotSetLastOrderedTask 60 16
export BotRefuseOrder
proc BotRefuseOrder 8 12
line 509
;502:}
;503:
;504:/*
;505:==================
;506:BotRefuseOrder
;507:==================
;508:*/
;509:void BotRefuseOrder(bot_state_t *bs) {
line 510
;510:	if (!bs->ordered)
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $145
line 511
;511:		return;
ADDRGP4 $144
JUMPV
LABELV $145
line 513
;512:	// if the bot was ordered to do something
;513:	if ( bs->order_time && bs->order_time > FloatTime() - 10 ) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
INDIRF4
ASGNF4
ADDRLP4 0
INDIRF4
CNSTF4 0
EQF4 $147
ADDRLP4 0
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
SUBF4
LEF4 $147
line 514
;514:		trap_EA_Action(bs->client, ACTION_NEGATIVE);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 2097152
ARGI4
ADDRGP4 trap_EA_Action
CALLV
pop
line 515
;515:		BotVoiceChat(bs, bs->decisionmaker, VOICECHAT_NO);
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $149
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 516
;516:		bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 517
;517:	}
LABELV $147
line 518
;518:}
LABELV $144
endproc BotRefuseOrder 8 12
export BotCTFSeekGoals
proc BotCTFSeekGoals 240 12
line 525
;519:
;520:/*
;521:==================
;522:BotCTFSeekGoals
;523:==================
;524:*/
;525:void BotCTFSeekGoals(bot_state_t *bs) {
line 532
;526:	float rnd, l1, l2;
;527:	int flagstatus, c;
;528:	vec3_t dir;
;529:	aas_entityinfo_t entinfo;
;530:
;531:	//when carrying a flag in ctf the bot should rush to the base
;532:	if (BotCTFCarryingFlag(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 172
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $151
line 534
;533:		//if not already rushing to the base
;534:		if (bs->ltgtype != LTG_RUSHBASE) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
EQI4 $153
line 535
;535:			BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 536
;536:			bs->ltgtype = LTG_RUSHBASE;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 5
ASGNI4
line 537
;537:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
ASGNF4
line 538
;538:			bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 539
;539:			bs->decisionmaker = bs->client;
ADDRLP4 176
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 176
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 540
;540:			bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 542
;541:			//
;542:			switch(BotTeam(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 184
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 180
ADDRLP4 184
INDIRI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 1
EQI4 $158
ADDRLP4 180
INDIRI4
CNSTI4 2
EQI4 $163
ADDRGP4 $155
JUMPV
LABELV $158
line 543
;543:				case TEAM_RED: VectorSubtract(bs->origin, ctf_blueflag.origin, dir); break;
ADDRLP4 192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 160
ADDRLP4 192
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRGP4 ctf_blueflag
INDIRF4
SUBF4
ASGNF4
ADDRLP4 160+4
ADDRLP4 192
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ADDRGP4 ctf_blueflag+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 160+8
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRGP4 ctf_blueflag+8
INDIRF4
SUBF4
ASGNF4
ADDRGP4 $156
JUMPV
LABELV $163
line 544
;544:				case TEAM_BLUE: VectorSubtract(bs->origin, ctf_redflag.origin, dir); break;
ADDRLP4 196
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 160
ADDRLP4 196
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRGP4 ctf_redflag
INDIRF4
SUBF4
ASGNF4
ADDRLP4 160+4
ADDRLP4 196
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ADDRGP4 ctf_redflag+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 160+8
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRGP4 ctf_redflag+8
INDIRF4
SUBF4
ASGNF4
ADDRGP4 $156
JUMPV
LABELV $155
line 545
;545:				default: VectorSet(dir, 999, 999, 999); break;
ADDRLP4 200
CNSTF4 1148829696
ASGNF4
ADDRLP4 160
ADDRLP4 200
INDIRF4
ASGNF4
ADDRLP4 160+4
ADDRLP4 200
INDIRF4
ASGNF4
ADDRLP4 160+8
CNSTF4 1148829696
ASGNF4
LABELV $156
line 548
;546:			}
;547:			// if the bot picked up the flag very close to the enemy base
;548:			if ( VectorLength(dir) < 128 ) {
ADDRLP4 160
ARGP4
ADDRLP4 192
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 192
INDIRF4
CNSTF4 1124073472
GEF4 $170
line 550
;549:				// get an alternative route goal through the enemy base
;550:				BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196
ADDRGP4 BotOppositeTeam
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196
INDIRI4
ARGI4
ADDRGP4 BotGetAlternateRouteGoal
CALLI4
pop
line 551
;551:			} else {
ADDRGP4 $171
JUMPV
LABELV $170
line 553
;552:				// don't use any alt route goal, just get the hell out of the base
;553:				bs->altroutegoal.areanum = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6692
ADDP4
CNSTI4 0
ASGNI4
line 554
;554:			}
LABELV $171
line 555
;555:			BotSetUserInfo(bs, "teamtask", va("%d", TEAMTASK_OFFENSE));
ADDRGP4 $173
ARGP4
CNSTI4 1
ARGI4
ADDRLP4 196
ADDRGP4 va
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $172
ARGP4
ADDRLP4 196
INDIRP4
ARGP4
ADDRGP4 BotSetUserInfo
CALLV
pop
line 556
;556:			BotVoiceChat(bs, -1, VOICECHAT_IHAVEFLAG);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 $174
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 557
;557:		}
ADDRGP4 $150
JUMPV
LABELV $153
line 558
;558:		else if (bs->rushbaseaway_time > FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $150
line 559
;559:			if (BotTeam(bs) == TEAM_RED) flagstatus = bs->redflagstatus;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 176
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 1
NEI4 $177
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $178
JUMPV
LABELV $177
line 560
;560:			else flagstatus = bs->blueflagstatus;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
ASGNI4
LABELV $178
line 562
;561:			//if the flag is back
;562:			if (flagstatus == 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $150
line 563
;563:				bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 564
;564:			}
line 565
;565:		}
line 566
;566:		return;
ADDRGP4 $150
JUMPV
LABELV $151
line 569
;567:	}
;568:	// if the bot decided to follow someone
;569:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
ADDRLP4 176
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 2
NEI4 $181
ADDRLP4 176
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $181
line 571
;570:		// if the team mate being accompanied no longer carries the flag
;571:		BotEntityInfo(bs->teammate, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 572
;572:		if (!EntityCarriesFlag(&entinfo)) {
ADDRLP4 16
ARGP4
ADDRLP4 180
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 0
NEI4 $183
line 573
;573:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 574
;574:		}
LABELV $183
line 575
;575:	}
LABELV $181
line 577
;576:	//
;577:	if (BotTeam(bs) == TEAM_RED) flagstatus = bs->redflagstatus * 2 + bs->blueflagstatus;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 180
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 1
NEI4 $185
ADDRLP4 184
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 184
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
CNSTI4 1
LSHI4
ADDRLP4 184
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
ADDI4
ASGNI4
ADDRGP4 $186
JUMPV
LABELV $185
line 578
;578:	else flagstatus = bs->blueflagstatus * 2 + bs->redflagstatus;
ADDRLP4 188
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 188
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
CNSTI4 1
LSHI4
ADDRLP4 188
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
ADDI4
ASGNI4
LABELV $186
line 580
;579:	//if our team has the enemy flag and our flag is at the base
;580:	if (flagstatus == 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $187
line 582
;581:		//
;582:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $150
line 584
;583:			//if Not defending the base already
;584:			if (!(bs->ltgtype == LTG_DEFENDKEYAREA &&
ADDRLP4 192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 192
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 3
NEI4 $195
ADDRLP4 196
ADDRLP4 192
INDIRP4
CNSTI4 6668
ADDP4
INDIRI4
ASGNI4
ADDRLP4 196
INDIRI4
ADDRGP4 ctf_redflag+44
INDIRI4
EQI4 $150
ADDRLP4 196
INDIRI4
ADDRGP4 ctf_blueflag+44
INDIRI4
EQI4 $150
LABELV $195
line 586
;585:					(bs->teamgoal.number == ctf_redflag.number ||
;586:					bs->teamgoal.number == ctf_blueflag.number))) {
line 588
;587:				//if there is a visible team mate flag carrier
;588:				c = BotTeamFlagCarrierVisible(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 200
ADDRGP4 BotTeamFlagCarrierVisible
CALLI4
ASGNI4
ADDRLP4 156
ADDRLP4 200
INDIRI4
ASGNI4
line 589
;589:				if (c >= 0 &&
ADDRLP4 204
ADDRLP4 156
INDIRI4
ASGNI4
ADDRLP4 204
INDIRI4
CNSTI4 0
LTI4 $150
ADDRLP4 208
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 208
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 2
NEI4 $198
ADDRLP4 208
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ADDRLP4 204
INDIRI4
EQI4 $150
LABELV $198
line 591
;590:						// and not already following the team mate flag carrier
;591:						(bs->ltgtype != LTG_TEAMACCOMPANY || bs->teammate != c)) {
line 593
;592:					//
;593:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 595
;594:					//follow the flag carrier
;595:					bs->decisionmaker = bs->client;
ADDRLP4 212
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 212
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 212
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 596
;596:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 598
;597:					//the team mate
;598:					bs->teammate = c;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 156
INDIRI4
ASGNI4
line 600
;599:					//last time the team mate was visible
;600:					bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 602
;601:					//no message
;602:					bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 604
;603:					//no arrive message
;604:					bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 606
;605:					//
;606:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
ADDRLP4 216
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 216
INDIRP4
ARGP4
ADDRLP4 216
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRGP4 $199
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 608
;607:					//get the team goal time
;608:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 609
;609:					bs->ltgtype = LTG_TEAMACCOMPANY;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 2
ASGNI4
line 610
;610:					bs->formation_dist = 3.5 * 32;		//3.5 meter
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
CNSTF4 1121976320
ASGNF4
line 611
;611:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 612
;612:					bs->owndecision_time = FloatTime() + 5;
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CVFI4 4
ASGNI4
line 613
;613:				}
line 614
;614:			}
line 615
;615:		}
line 616
;616:		return;
ADDRGP4 $150
JUMPV
LABELV $187
line 619
;617:	}
;618:	//if the enemy has our flag
;619:	else if (flagstatus == 2) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $200
line 621
;620:		//
;621:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $150
line 623
;622:			//if enemy flag carrier is visible
;623:			c = BotEnemyFlagCarrierVisible(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 192
ADDRGP4 BotEnemyFlagCarrierVisible
CALLI4
ASGNI4
ADDRLP4 156
ADDRLP4 192
INDIRI4
ASGNI4
line 624
;624:			if (c >= 0) {
ADDRLP4 156
INDIRI4
CNSTI4 0
LTI4 $204
line 626
;625:				//FIXME: fight enemy flag carrier
;626:			}
LABELV $204
line 628
;627:			//if not already doing something important
;628:			if (bs->ltgtype != LTG_GETFLAG &&
ADDRLP4 196
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
ADDRLP4 196
INDIRI4
CNSTI4 4
EQI4 $150
ADDRLP4 196
INDIRI4
CNSTI4 6
EQI4 $150
ADDRLP4 196
INDIRI4
CNSTI4 1
EQI4 $150
ADDRLP4 196
INDIRI4
CNSTI4 2
EQI4 $150
ADDRLP4 196
INDIRI4
CNSTI4 8
EQI4 $150
ADDRLP4 196
INDIRI4
CNSTI4 9
EQI4 $150
ADDRLP4 196
INDIRI4
CNSTI4 10
EQI4 $150
line 634
;629:				bs->ltgtype != LTG_RETURNFLAG &&
;630:				bs->ltgtype != LTG_TEAMHELP &&
;631:				bs->ltgtype != LTG_TEAMACCOMPANY &&
;632:				bs->ltgtype != LTG_CAMPORDER &&
;633:				bs->ltgtype != LTG_PATROL &&
;634:				bs->ltgtype != LTG_GETITEM) {
line 636
;635:
;636:				BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 637
;637:				bs->decisionmaker = bs->client;
ADDRLP4 200
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 200
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 200
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 638
;638:				bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 640
;639:				//
;640:				if (random() < 0.5) {
ADDRLP4 204
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 204
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
GEF4 $208
line 642
;641:					//go for the enemy flag
;642:					bs->ltgtype = LTG_GETFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 4
ASGNI4
line 643
;643:				}
ADDRGP4 $209
JUMPV
LABELV $208
line 644
;644:				else {
line 645
;645:					bs->ltgtype = LTG_RETURNFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 6
ASGNI4
line 646
;646:				}
LABELV $209
line 648
;647:				//no team message
;648:				bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 650
;649:				//set the time the bot will stop getting the flag
;650:				bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 652
;651:				//get an alternative route goal towards the enemy base
;652:				BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 208
ADDRGP4 BotOppositeTeam
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 208
INDIRI4
ARGI4
ADDRGP4 BotGetAlternateRouteGoal
CALLI4
pop
line 654
;653:				//
;654:				BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 655
;655:				bs->owndecision_time = FloatTime() + 5;
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CVFI4 4
ASGNI4
line 656
;656:			}
line 657
;657:		}
line 658
;658:		return;
ADDRGP4 $150
JUMPV
LABELV $200
line 661
;659:	}
;660:	//if both flags Not at their bases
;661:	else if (flagstatus == 3) {
ADDRLP4 0
INDIRI4
CNSTI4 3
NEI4 $210
line 663
;662:		//
;663:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $150
line 665
;664:			// if not trying to return the flag and not following the team flag carrier
;665:			if ( bs->ltgtype != LTG_RETURNFLAG && bs->ltgtype != LTG_TEAMACCOMPANY ) {
ADDRLP4 192
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
ADDRLP4 192
INDIRI4
CNSTI4 6
EQI4 $150
ADDRLP4 192
INDIRI4
CNSTI4 2
EQI4 $150
line 667
;666:				//
;667:				c = BotTeamFlagCarrierVisible(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196
ADDRGP4 BotTeamFlagCarrierVisible
CALLI4
ASGNI4
ADDRLP4 156
ADDRLP4 196
INDIRI4
ASGNI4
line 669
;668:				// if there is a visible team mate flag carrier
;669:				if (c >= 0) {
ADDRLP4 156
INDIRI4
CNSTI4 0
LTI4 $216
line 670
;670:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 672
;671:					//follow the flag carrier
;672:					bs->decisionmaker = bs->client;
ADDRLP4 200
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 200
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 200
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 673
;673:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 675
;674:					//the team mate
;675:					bs->teammate = c;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 156
INDIRI4
ASGNI4
line 677
;676:					//last time the team mate was visible
;677:					bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 679
;678:					//no message
;679:					bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 681
;680:					//no arrive message
;681:					bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 683
;682:					//
;683:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
ADDRLP4 204
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 204
INDIRP4
ARGP4
ADDRLP4 204
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRGP4 $199
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 685
;684:					//get the team goal time
;685:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 686
;686:					bs->ltgtype = LTG_TEAMACCOMPANY;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 2
ASGNI4
line 687
;687:					bs->formation_dist = 3.5 * 32;		//3.5 meter
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
CNSTF4 1121976320
ASGNF4
line 689
;688:					//
;689:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 690
;690:					bs->owndecision_time = FloatTime() + 5;
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CVFI4 4
ASGNI4
line 691
;691:				}
ADDRGP4 $150
JUMPV
LABELV $216
line 692
;692:				else {
line 693
;693:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 694
;694:					bs->decisionmaker = bs->client;
ADDRLP4 200
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 200
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 200
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 695
;695:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 697
;696:					//get the enemy flag
;697:					bs->teammessage_time = FloatTime() + 2 * random();
ADDRLP4 204
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
ADDRLP4 204
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
ASGNF4
line 699
;698:					//get the flag
;699:					bs->ltgtype = LTG_RETURNFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 6
ASGNI4
line 701
;700:					//set the time the bot will stop getting the flag
;701:					bs->teamgoal_time = FloatTime() + CTF_RETURNFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 703
;702:					//get an alternative route goal towards the enemy base
;703:					BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 208
ADDRGP4 BotOppositeTeam
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 208
INDIRI4
ARGI4
ADDRGP4 BotGetAlternateRouteGoal
CALLI4
pop
line 705
;704:					//
;705:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 706
;706:					bs->owndecision_time = FloatTime() + 5;
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CVFI4 4
ASGNI4
line 707
;707:				}
line 708
;708:			}
line 709
;709:		}
line 710
;710:		return;
ADDRGP4 $150
JUMPV
LABELV $210
line 713
;711:	}
;712:	// don't just do something wait for the bot team leader to give orders
;713:	if (BotTeamLeader(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 192
ADDRGP4 BotTeamLeader
CALLI4
ASGNI4
ADDRLP4 192
INDIRI4
CNSTI4 0
EQI4 $218
line 714
;714:		return;
ADDRGP4 $150
JUMPV
LABELV $218
line 717
;715:	}
;716:	// if the bot is ordered to do something
;717:	if ( bs->lastgoal_ltgtype ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $220
line 718
;718:		bs->teamgoal_time += 60;
ADDRLP4 196
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ASGNP4
ADDRLP4 196
INDIRP4
ADDRLP4 196
INDIRP4
INDIRF4
CNSTF4 1114636288
ADDF4
ASGNF4
line 719
;719:	}
LABELV $220
line 721
;720:	// if the bot decided to do something on it's own and has a last ordered goal
;721:	if ( !bs->ordered && bs->lastgoal_ltgtype ) {
ADDRLP4 196
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 200
CNSTI4 0
ASGNI4
ADDRLP4 196
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
ADDRLP4 200
INDIRI4
NEI4 $222
ADDRLP4 196
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
ADDRLP4 200
INDIRI4
EQI4 $222
line 722
;722:		bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 723
;723:	}
LABELV $222
line 725
;724:	//if already a CTF or team goal
;725:	if (bs->ltgtype == LTG_TEAMHELP ||
ADDRLP4 204
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
ADDRLP4 204
INDIRI4
CNSTI4 1
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 2
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 3
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 4
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 5
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 6
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 8
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 9
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 10
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 14
EQI4 $235
ADDRLP4 204
INDIRI4
CNSTI4 15
NEI4 $224
LABELV $235
line 735
;726:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;727:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;728:			bs->ltgtype == LTG_GETFLAG ||
;729:			bs->ltgtype == LTG_RUSHBASE ||
;730:			bs->ltgtype == LTG_RETURNFLAG ||
;731:			bs->ltgtype == LTG_CAMPORDER ||
;732:			bs->ltgtype == LTG_PATROL ||
;733:			bs->ltgtype == LTG_GETITEM ||
;734:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;735:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
line 736
;736:		return;
ADDRGP4 $150
JUMPV
LABELV $224
line 739
;737:	}
;738:	//
;739:	if (BotSetLastOrderedTask(bs))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 208
ADDRGP4 BotSetLastOrderedTask
CALLI4
ASGNI4
ADDRLP4 208
INDIRI4
CNSTI4 0
EQI4 $236
line 740
;740:		return;
ADDRGP4 $150
JUMPV
LABELV $236
line 742
;741:	//
;742:	if (bs->owndecision_time > FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
LEF4 $238
line 743
;743:		return;;
ADDRGP4 $150
JUMPV
LABELV $238
line 745
;744:	//if the bot is roaming
;745:	if (bs->ctfroam_time > FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6164
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $240
line 746
;746:		return;
ADDRGP4 $150
JUMPV
LABELV $240
line 748
;747:	//if the bot has anough aggression to decide what to do
;748:	if (BotAggression(bs) < 50)
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 212
ADDRGP4 BotAggression
CALLF4
ASGNF4
ADDRLP4 212
INDIRF4
CNSTF4 1112014848
GEF4 $242
line 749
;749:		return;
ADDRGP4 $150
JUMPV
LABELV $242
line 751
;750:	//set the time to send a message to the team mates
;751:	bs->teammessage_time = FloatTime() + 2 * random();
ADDRLP4 216
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
ADDRLP4 216
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
ASGNF4
line 753
;752:	//
;753:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
ADDRFP4 0
INDIRP4
CNSTI4 6752
ADDP4
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 0
EQI4 $244
line 754
;754:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
ADDRFP4 0
INDIRP4
CNSTI4 6752
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $246
line 755
;755:			l1 = 0.7f;
ADDRLP4 8
CNSTF4 1060320051
ASGNF4
line 756
;756:		}
ADDRGP4 $247
JUMPV
LABELV $246
line 757
;757:		else {
line 758
;758:			l1 = 0.2f;
ADDRLP4 8
CNSTF4 1045220557
ASGNF4
line 759
;759:		}
LABELV $247
line 760
;760:		l2 = 0.9f;
ADDRLP4 12
CNSTF4 1063675494
ASGNF4
line 761
;761:	}
ADDRGP4 $245
JUMPV
LABELV $244
line 762
;762:	else {
line 763
;763:		l1 = 0.4f;
ADDRLP4 8
CNSTF4 1053609165
ASGNF4
line 764
;764:		l2 = 0.7f;
ADDRLP4 12
CNSTF4 1060320051
ASGNF4
line 765
;765:	}
LABELV $245
line 767
;766:	//get the flag or defend the base
;767:	rnd = random();
ADDRLP4 220
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 220
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ASGNF4
line 768
;768:	if (rnd < l1 && ctf_redflag.areanum && ctf_blueflag.areanum) {
ADDRLP4 4
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $248
ADDRLP4 224
CNSTI4 0
ASGNI4
ADDRGP4 ctf_redflag+12
INDIRI4
ADDRLP4 224
INDIRI4
EQI4 $248
ADDRGP4 ctf_blueflag+12
INDIRI4
ADDRLP4 224
INDIRI4
EQI4 $248
line 769
;769:		bs->decisionmaker = bs->client;
ADDRLP4 228
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 228
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 228
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 770
;770:		bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 771
;771:		bs->ltgtype = LTG_GETFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 4
ASGNI4
line 773
;772:		//set the time the bot will stop getting the flag
;773:		bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 775
;774:		//get an alternative route goal towards the enemy base
;775:		BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 232
ADDRGP4 BotOppositeTeam
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 232
INDIRI4
ARGI4
ADDRGP4 BotGetAlternateRouteGoal
CALLI4
pop
line 776
;776:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 777
;777:	}
ADDRGP4 $249
JUMPV
LABELV $248
line 778
;778:	else if (rnd < l2 && ctf_redflag.areanum && ctf_blueflag.areanum) {
ADDRLP4 4
INDIRF4
ADDRLP4 12
INDIRF4
GEF4 $252
ADDRLP4 228
CNSTI4 0
ASGNI4
ADDRGP4 ctf_redflag+12
INDIRI4
ADDRLP4 228
INDIRI4
EQI4 $252
ADDRGP4 ctf_blueflag+12
INDIRI4
ADDRLP4 228
INDIRI4
EQI4 $252
line 779
;779:		bs->decisionmaker = bs->client;
ADDRLP4 232
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 232
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 232
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 780
;780:		bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 782
;781:		//
;782:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 236
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 236
INDIRI4
CNSTI4 1
NEI4 $256
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
ADDRGP4 ctf_redflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $257
JUMPV
LABELV $256
line 783
;783:		else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
ADDRGP4 ctf_blueflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
LABELV $257
line 785
;784:		//set the ltg type
;785:		bs->ltgtype = LTG_DEFENDKEYAREA;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 3
ASGNI4
line 787
;786:		//set the time the bot stops defending the base
;787:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 788
;788:		bs->defendaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6144
ADDP4
CNSTF4 0
ASGNF4
line 789
;789:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 790
;790:	}
ADDRGP4 $253
JUMPV
LABELV $252
line 791
;791:	else {
line 792
;792:		bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 794
;793:		//set the time the bot will stop roaming
;794:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6164
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1114636288
ADDF4
ASGNF4
line 795
;795:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 796
;796:	}
LABELV $253
LABELV $249
line 797
;797:	bs->owndecision_time = FloatTime() + 5;
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CVFI4 4
ASGNI4
line 801
;798:#ifdef DEBUG
;799:	BotPrintTeamGoal(bs);
;800:#endif //DEBUG
;801:}
LABELV $150
endproc BotCTFSeekGoals 240 12
export BotCTFRetreatGoals
proc BotCTFRetreatGoals 8 4
line 808
;802:
;803:/*
;804:==================
;805:BotCTFRetreatGoals
;806:==================
;807:*/
;808:void BotCTFRetreatGoals(bot_state_t *bs) {
line 810
;809:	//when carrying a flag in ctf the bot should rush to the base
;810:	if (BotCTFCarryingFlag(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $259
line 812
;811:		//if not already rushing to the base
;812:		if (bs->ltgtype != LTG_RUSHBASE) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
EQI4 $261
line 813
;813:			BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 814
;814:			bs->ltgtype = LTG_RUSHBASE;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 5
ASGNI4
line 815
;815:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
ASGNF4
line 816
;816:			bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 817
;817:			bs->decisionmaker = bs->client;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 818
;818:			bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 819
;819:			BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 820
;820:		}
LABELV $261
line 821
;821:	}
LABELV $259
line 822
;822:}
LABELV $258
endproc BotCTFRetreatGoals 8 4
export BotTeamGoals
proc BotTeamGoals 0 4
line 1358
;823:
;824:#ifdef MISSIONPACK
;825:/*
;826:==================
;827:Bot1FCTFSeekGoals
;828:==================
;829:*/
;830:void Bot1FCTFSeekGoals(bot_state_t *bs) {
;831:	aas_entityinfo_t entinfo;
;832:	float rnd, l1, l2;
;833:	int c;
;834:
;835:	//when carrying a flag in ctf the bot should rush to the base
;836:	if (Bot1FCTFCarryingFlag(bs)) {
;837:		//if not already rushing to the base
;838:		if (bs->ltgtype != LTG_RUSHBASE) {
;839:			BotRefuseOrder(bs);
;840:			bs->ltgtype = LTG_RUSHBASE;
;841:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;842:			bs->rushbaseaway_time = 0;
;843:			bs->decisionmaker = bs->client;
;844:			bs->ordered = qfalse;
;845:			//get an alternative route goal towards the enemy base
;846:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;847:			//
;848:			BotSetTeamStatus(bs);
;849:			BotVoiceChat(bs, -1, VOICECHAT_IHAVEFLAG);
;850:		}
;851:		return;
;852:	}
;853:	// if the bot decided to follow someone
;854:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
;855:		// if the team mate being accompanied no longer carries the flag
;856:		BotEntityInfo(bs->teammate, &entinfo);
;857:		if (!EntityCarriesFlag(&entinfo)) {
;858:			bs->ltgtype = 0;
;859:		}
;860:	}
;861:	//our team has the flag
;862:	if (bs->neutralflagstatus == 1) {
;863:		if (bs->owndecision_time < FloatTime()) {
;864:			// if not already following someone
;865:			if (bs->ltgtype != LTG_TEAMACCOMPANY) {
;866:				//if there is a visible team mate flag carrier
;867:				c = BotTeamFlagCarrierVisible(bs);
;868:				if (c >= 0) {
;869:					BotRefuseOrder(bs);
;870:					//follow the flag carrier
;871:					bs->decisionmaker = bs->client;
;872:					bs->ordered = qfalse;
;873:					//the team mate
;874:					bs->teammate = c;
;875:					//last time the team mate was visible
;876:					bs->teammatevisible_time = FloatTime();
;877:					//no message
;878:					bs->teammessage_time = 0;
;879:					//no arrive message
;880:					bs->arrive_time = 1;
;881:					//
;882:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
;883:					//get the team goal time
;884:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
;885:					bs->ltgtype = LTG_TEAMACCOMPANY;
;886:					bs->formation_dist = 3.5 * 32;		//3.5 meter
;887:					BotSetTeamStatus(bs);
;888:					bs->owndecision_time = FloatTime() + 5;
;889:					return;
;890:				}
;891:			}
;892:			//if already a CTF or team goal
;893:			if (bs->ltgtype == LTG_TEAMHELP ||
;894:					bs->ltgtype == LTG_TEAMACCOMPANY ||
;895:					bs->ltgtype == LTG_DEFENDKEYAREA ||
;896:					bs->ltgtype == LTG_GETFLAG ||
;897:					bs->ltgtype == LTG_RUSHBASE ||
;898:					bs->ltgtype == LTG_CAMPORDER ||
;899:					bs->ltgtype == LTG_PATROL ||
;900:					bs->ltgtype == LTG_ATTACKENEMYBASE ||
;901:					bs->ltgtype == LTG_GETITEM ||
;902:					bs->ltgtype == LTG_MAKELOVE_UNDER ||
;903:					bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;904:				return;
;905:			}
;906:			//if not already attacking the enemy base
;907:			if (bs->ltgtype != LTG_ATTACKENEMYBASE) {
;908:				BotRefuseOrder(bs);
;909:				bs->decisionmaker = bs->client;
;910:				bs->ordered = qfalse;
;911:				//
;912:				if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;913:				else memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;914:				//set the ltg type
;915:				bs->ltgtype = LTG_ATTACKENEMYBASE;
;916:				//set the time the bot will stop getting the flag
;917:				bs->teamgoal_time = FloatTime() + TEAM_ATTACKENEMYBASE_TIME;
;918:				BotSetTeamStatus(bs);
;919:				bs->owndecision_time = FloatTime() + 5;
;920:			}
;921:		}
;922:		return;
;923:	}
;924:	//enemy team has the flag
;925:	else if (bs->neutralflagstatus == 2) {
;926:		if (bs->owndecision_time < FloatTime()) {
;927:			c = BotEnemyFlagCarrierVisible(bs);
;928:			if (c >= 0) {
;929:				//FIXME: attack enemy flag carrier
;930:			}
;931:			//if already a CTF or team goal
;932:			if (bs->ltgtype == LTG_TEAMHELP ||
;933:					bs->ltgtype == LTG_TEAMACCOMPANY ||
;934:					bs->ltgtype == LTG_CAMPORDER ||
;935:					bs->ltgtype == LTG_PATROL ||
;936:					bs->ltgtype == LTG_GETITEM) {
;937:				return;
;938:			}
;939:			// if not already defending the base
;940:			if (bs->ltgtype != LTG_DEFENDKEYAREA) {
;941:				BotRefuseOrder(bs);
;942:				bs->decisionmaker = bs->client;
;943:				bs->ordered = qfalse;
;944:				//
;945:				if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;946:				else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;947:				//set the ltg type
;948:				bs->ltgtype = LTG_DEFENDKEYAREA;
;949:				//set the time the bot stops defending the base
;950:				bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;951:				bs->defendaway_time = 0;
;952:				BotSetTeamStatus(bs);
;953:				bs->owndecision_time = FloatTime() + 5;
;954:			}
;955:		}
;956:		return;
;957:	}
;958:	// don't just do something wait for the bot team leader to give orders
;959:	if (BotTeamLeader(bs)) {
;960:		return;
;961:	}
;962:	// if the bot is ordered to do something
;963:	if ( bs->lastgoal_ltgtype ) {
;964:		bs->teamgoal_time += 60;
;965:	}
;966:	// if the bot decided to do something on it's own and has a last ordered goal
;967:	if ( !bs->ordered && bs->lastgoal_ltgtype ) {
;968:		bs->ltgtype = 0;
;969:	}
;970:	//if already a CTF or team goal
;971:	if (bs->ltgtype == LTG_TEAMHELP ||
;972:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;973:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;974:			bs->ltgtype == LTG_GETFLAG ||
;975:			bs->ltgtype == LTG_RUSHBASE ||
;976:			bs->ltgtype == LTG_RETURNFLAG ||
;977:			bs->ltgtype == LTG_CAMPORDER ||
;978:			bs->ltgtype == LTG_PATROL ||
;979:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;980:			bs->ltgtype == LTG_GETITEM ||
;981:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;982:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;983:		return;
;984:	}
;985:	//
;986:	if (BotSetLastOrderedTask(bs))
;987:		return;
;988:	//
;989:	if (bs->owndecision_time > FloatTime())
;990:		return;;
;991:	//if the bot is roaming
;992:	if (bs->ctfroam_time > FloatTime())
;993:		return;
;994:	//if the bot has anough aggression to decide what to do
;995:	if (BotAggression(bs) < 50)
;996:		return;
;997:	//set the time to send a message to the team mates
;998:	bs->teammessage_time = FloatTime() + 2 * random();
;999:	//
;1000:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1001:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1002:			l1 = 0.7f;
;1003:		}
;1004:		else {
;1005:			l1 = 0.2f;
;1006:		}
;1007:		l2 = 0.9f;
;1008:	}
;1009:	else {
;1010:		l1 = 0.4f;
;1011:		l2 = 0.7f;
;1012:	}
;1013:	//get the flag or defend the base
;1014:	rnd = random();
;1015:	if (rnd < l1 && ctf_neutralflag.areanum) {
;1016:		bs->decisionmaker = bs->client;
;1017:		bs->ordered = qfalse;
;1018:		bs->ltgtype = LTG_GETFLAG;
;1019:		//set the time the bot will stop getting the flag
;1020:		bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
;1021:		BotSetTeamStatus(bs);
;1022:	}
;1023:	else if (rnd < l2 && ctf_redflag.areanum && ctf_blueflag.areanum) {
;1024:		bs->decisionmaker = bs->client;
;1025:		bs->ordered = qfalse;
;1026:		//
;1027:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;1028:		else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;1029:		//set the ltg type
;1030:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1031:		//set the time the bot stops defending the base
;1032:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1033:		bs->defendaway_time = 0;
;1034:		BotSetTeamStatus(bs);
;1035:	}
;1036:	else {
;1037:		bs->ltgtype = 0;
;1038:		//set the time the bot will stop roaming
;1039:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1040:		BotSetTeamStatus(bs);
;1041:	}
;1042:	bs->owndecision_time = FloatTime() + 5;
;1043:#ifdef DEBUG
;1044:	BotPrintTeamGoal(bs);
;1045:#endif //DEBUG
;1046:}
;1047:
;1048:/*
;1049:==================
;1050:Bot1FCTFRetreatGoals
;1051:==================
;1052:*/
;1053:void Bot1FCTFRetreatGoals(bot_state_t *bs) {
;1054:	//when carrying a flag in ctf the bot should rush to the enemy base
;1055:	if (Bot1FCTFCarryingFlag(bs)) {
;1056:		//if not already rushing to the base
;1057:		if (bs->ltgtype != LTG_RUSHBASE) {
;1058:			BotRefuseOrder(bs);
;1059:			bs->ltgtype = LTG_RUSHBASE;
;1060:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1061:			bs->rushbaseaway_time = 0;
;1062:			bs->decisionmaker = bs->client;
;1063:			bs->ordered = qfalse;
;1064:			//get an alternative route goal towards the enemy base
;1065:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1066:			BotSetTeamStatus(bs);
;1067:		}
;1068:	}
;1069:}
;1070:
;1071:/*
;1072:==================
;1073:BotObeliskSeekGoals
;1074:==================
;1075:*/
;1076:void BotObeliskSeekGoals(bot_state_t *bs) {
;1077:	float rnd, l1, l2;
;1078:
;1079:	// don't just do something wait for the bot team leader to give orders
;1080:	if (BotTeamLeader(bs)) {
;1081:		return;
;1082:	}
;1083:	// if the bot is ordered to do something
;1084:	if ( bs->lastgoal_ltgtype ) {
;1085:		bs->teamgoal_time += 60;
;1086:	}
;1087:	//if already a team goal
;1088:	if (bs->ltgtype == LTG_TEAMHELP ||
;1089:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;1090:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;1091:			bs->ltgtype == LTG_GETFLAG ||
;1092:			bs->ltgtype == LTG_RUSHBASE ||
;1093:			bs->ltgtype == LTG_RETURNFLAG ||
;1094:			bs->ltgtype == LTG_CAMPORDER ||
;1095:			bs->ltgtype == LTG_PATROL ||
;1096:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;1097:			bs->ltgtype == LTG_GETITEM ||
;1098:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;1099:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;1100:		return;
;1101:	}
;1102:	//
;1103:	if (BotSetLastOrderedTask(bs))
;1104:		return;
;1105:	//if the bot is roaming
;1106:	if (bs->ctfroam_time > FloatTime())
;1107:		return;
;1108:	//if the bot has anough aggression to decide what to do
;1109:	if (BotAggression(bs) < 50)
;1110:		return;
;1111:	//set the time to send a message to the team mates
;1112:	bs->teammessage_time = FloatTime() + 2 * random();
;1113:	//
;1114:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1115:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1116:			l1 = 0.7f;
;1117:		}
;1118:		else {
;1119:			l1 = 0.2f;
;1120:		}
;1121:		l2 = 0.9f;
;1122:	}
;1123:	else {
;1124:		l1 = 0.4f;
;1125:		l2 = 0.7f;
;1126:	}
;1127:	//get the flag or defend the base
;1128:	rnd = random();
;1129:	if (rnd < l1 && redobelisk.areanum && blueobelisk.areanum) {
;1130:		bs->decisionmaker = bs->client;
;1131:		bs->ordered = qfalse;
;1132:		//
;1133:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1134:		else memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1135:		//set the ltg type
;1136:		bs->ltgtype = LTG_ATTACKENEMYBASE;
;1137:		//set the time the bot will stop attacking the enemy base
;1138:		bs->teamgoal_time = FloatTime() + TEAM_ATTACKENEMYBASE_TIME;
;1139:		//get an alternate route goal towards the enemy base
;1140:		BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1141:		BotSetTeamStatus(bs);
;1142:	}
;1143:	else if (rnd < l2 && redobelisk.areanum && blueobelisk.areanum) {
;1144:		bs->decisionmaker = bs->client;
;1145:		bs->ordered = qfalse;
;1146:		//
;1147:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1148:		else memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1149:		//set the ltg type
;1150:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1151:		//set the time the bot stops defending the base
;1152:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1153:		bs->defendaway_time = 0;
;1154:		BotSetTeamStatus(bs);
;1155:	}
;1156:	else {
;1157:		bs->ltgtype = 0;
;1158:		//set the time the bot will stop roaming
;1159:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1160:		BotSetTeamStatus(bs);
;1161:	}
;1162:}
;1163:
;1164:/*
;1165:==================
;1166:BotGoHarvest
;1167:==================
;1168:*/
;1169:void BotGoHarvest(bot_state_t *bs) {
;1170:	//
;1171:	if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1172:	else memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1173:	//set the ltg type
;1174:	bs->ltgtype = LTG_HARVEST;
;1175:	//set the time the bot will stop harvesting
;1176:	bs->teamgoal_time = FloatTime() + TEAM_HARVEST_TIME;
;1177:	bs->harvestaway_time = 0;
;1178:	BotSetTeamStatus(bs);
;1179:}
;1180:
;1181:/*
;1182:==================
;1183:BotObeliskRetreatGoals
;1184:==================
;1185:*/
;1186:void BotObeliskRetreatGoals(bot_state_t *bs) {
;1187:	//nothing special
;1188:}
;1189:
;1190:/*
;1191:==================
;1192:BotHarvesterSeekGoals
;1193:==================
;1194:*/
;1195:void BotHarvesterSeekGoals(bot_state_t *bs) {
;1196:	aas_entityinfo_t entinfo;
;1197:	float rnd, l1, l2;
;1198:	int c;
;1199:
;1200:	//when carrying cubes in harvester the bot should rush to the base
;1201:	if (BotHarvesterCarryingCubes(bs)) {
;1202:		//if not already rushing to the base
;1203:		if (bs->ltgtype != LTG_RUSHBASE) {
;1204:			BotRefuseOrder(bs);
;1205:			bs->ltgtype = LTG_RUSHBASE;
;1206:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1207:			bs->rushbaseaway_time = 0;
;1208:			bs->decisionmaker = bs->client;
;1209:			bs->ordered = qfalse;
;1210:			//get an alternative route goal towards the enemy base
;1211:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1212:			//
;1213:			BotSetTeamStatus(bs);
;1214:		}
;1215:		return;
;1216:	}
;1217:	// don't just do something wait for the bot team leader to give orders
;1218:	if (BotTeamLeader(bs)) {
;1219:		return;
;1220:	}
;1221:	// if the bot decided to follow someone
;1222:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
;1223:		// if the team mate being accompanied no longer carries the flag
;1224:		BotEntityInfo(bs->teammate, &entinfo);
;1225:		if (!EntityCarriesCubes(&entinfo)) {
;1226:			bs->ltgtype = 0;
;1227:		}
;1228:	}
;1229:	// if the bot is ordered to do something
;1230:	if ( bs->lastgoal_ltgtype ) {
;1231:		bs->teamgoal_time += 60;
;1232:	}
;1233:	//if not yet doing something
;1234:	if (bs->ltgtype == LTG_TEAMHELP ||
;1235:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;1236:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;1237:			bs->ltgtype == LTG_GETFLAG ||
;1238:			bs->ltgtype == LTG_CAMPORDER ||
;1239:			bs->ltgtype == LTG_PATROL ||
;1240:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;1241:			bs->ltgtype == LTG_HARVEST ||
;1242:			bs->ltgtype == LTG_GETITEM ||
;1243:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;1244:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;1245:		return;
;1246:	}
;1247:	//
;1248:	if (BotSetLastOrderedTask(bs))
;1249:		return;
;1250:	//if the bot is roaming
;1251:	if (bs->ctfroam_time > FloatTime())
;1252:		return;
;1253:	//if the bot has anough aggression to decide what to do
;1254:	if (BotAggression(bs) < 50)
;1255:		return;
;1256:	//set the time to send a message to the team mates
;1257:	bs->teammessage_time = FloatTime() + 2 * random();
;1258:	//
;1259:	c = BotEnemyCubeCarrierVisible(bs);
;1260:	if (c >= 0) {
;1261:		//FIXME: attack enemy cube carrier
;1262:	}
;1263:	if (bs->ltgtype != LTG_TEAMACCOMPANY) {
;1264:		//if there is a visible team mate carrying cubes
;1265:		c = BotTeamCubeCarrierVisible(bs);
;1266:		if (c >= 0) {
;1267:			//follow the team mate carrying cubes
;1268:			bs->decisionmaker = bs->client;
;1269:			bs->ordered = qfalse;
;1270:			//the team mate
;1271:			bs->teammate = c;
;1272:			//last time the team mate was visible
;1273:			bs->teammatevisible_time = FloatTime();
;1274:			//no message
;1275:			bs->teammessage_time = 0;
;1276:			//no arrive message
;1277:			bs->arrive_time = 1;
;1278:			//
;1279:			BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
;1280:			//get the team goal time
;1281:			bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
;1282:			bs->ltgtype = LTG_TEAMACCOMPANY;
;1283:			bs->formation_dist = 3.5 * 32;		//3.5 meter
;1284:			BotSetTeamStatus(bs);
;1285:			return;
;1286:		}
;1287:	}
;1288:	//
;1289:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1290:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1291:			l1 = 0.7f;
;1292:		}
;1293:		else {
;1294:			l1 = 0.2f;
;1295:		}
;1296:		l2 = 0.9f;
;1297:	}
;1298:	else {
;1299:		l1 = 0.4f;
;1300:		l2 = 0.7f;
;1301:	}
;1302:	//
;1303:	rnd = random();
;1304:	if (rnd < l1 && redobelisk.areanum && blueobelisk.areanum) {
;1305:		bs->decisionmaker = bs->client;
;1306:		bs->ordered = qfalse;
;1307:		BotGoHarvest(bs);
;1308:	}
;1309:	else if (rnd < l2 && redobelisk.areanum && blueobelisk.areanum) {
;1310:		bs->decisionmaker = bs->client;
;1311:		bs->ordered = qfalse;
;1312:		//
;1313:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1314:		else memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1315:		//set the ltg type
;1316:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1317:		//set the time the bot stops defending the base
;1318:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1319:		bs->defendaway_time = 0;
;1320:		BotSetTeamStatus(bs);
;1321:	}
;1322:	else {
;1323:		bs->ltgtype = 0;
;1324:		//set the time the bot will stop roaming
;1325:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1326:		BotSetTeamStatus(bs);
;1327:	}
;1328:}
;1329:
;1330:/*
;1331:==================
;1332:BotHarvesterRetreatGoals
;1333:==================
;1334:*/
;1335:void BotHarvesterRetreatGoals(bot_state_t *bs) {
;1336:	//when carrying cubes in harvester the bot should rush to the base
;1337:	if (BotHarvesterCarryingCubes(bs)) {
;1338:		//if not already rushing to the base
;1339:		if (bs->ltgtype != LTG_RUSHBASE) {
;1340:			BotRefuseOrder(bs);
;1341:			bs->ltgtype = LTG_RUSHBASE;
;1342:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1343:			bs->rushbaseaway_time = 0;
;1344:			bs->decisionmaker = bs->client;
;1345:			bs->ordered = qfalse;
;1346:			BotSetTeamStatus(bs);
;1347:		}
;1348:		return;
;1349:	}
;1350:}
;1351:#endif
;1352:
;1353:/*
;1354:==================
;1355:BotTeamGoals
;1356:==================
;1357:*/
;1358:void BotTeamGoals(bot_state_t *bs, int retreat) {
line 1360
;1359:
;1360:	if( g_assaultMode.integer ) {
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 0
EQI4 $264
line 1361
;1361:		BotAssaultSeekGoals( bs );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotAssaultSeekGoals
CALLV
pop
line 1362
;1362:		bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 1363
;1363:		return;
ADDRGP4 $263
JUMPV
LABELV $264
line 1366
;1364:	}
;1365:
;1366:	if ( retreat ) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $267
line 1367
;1367:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $268
line 1368
;1368:			BotCTFRetreatGoals(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCTFRetreatGoals
CALLV
pop
line 1369
;1369:		}
line 1381
;1370:#ifdef MISSIONPACK
;1371:		else if (gametype == GT_1FCTF) {
;1372:			Bot1FCTFRetreatGoals(bs);
;1373:		}
;1374:		else if (gametype == GT_OBELISK) {
;1375:			BotObeliskRetreatGoals(bs);
;1376:		}
;1377:		else if (gametype == GT_HARVESTER) {
;1378:			BotHarvesterRetreatGoals(bs);
;1379:		}
;1380:#endif
;1381:	}
ADDRGP4 $268
JUMPV
LABELV $267
line 1382
;1382:	else {
line 1383
;1383:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $271
line 1385
;1384:			//decide what to do in CTF mode
;1385:			BotCTFSeekGoals(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCTFSeekGoals
CALLV
pop
line 1386
;1386:		}
LABELV $271
line 1398
;1387:#ifdef MISSIONPACK
;1388:		else if (gametype == GT_1FCTF) {
;1389:			Bot1FCTFSeekGoals(bs);
;1390:		}
;1391:		else if (gametype == GT_OBELISK) {
;1392:			BotObeliskSeekGoals(bs);
;1393:		}
;1394:		else if (gametype == GT_HARVESTER) {
;1395:			BotHarvesterSeekGoals(bs);
;1396:		}
;1397:#endif
;1398:	}
LABELV $268
line 1401
;1399:	// reset the order time which is used to see if
;1400:	// we decided to refuse an order
;1401:	bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 1402
;1402:}
LABELV $263
endproc BotTeamGoals 0 4
export BotPointAreaNum
proc BotPointAreaNum 68 20
line 1409
;1403:
;1404:/*
;1405:==================
;1406:BotPointAreaNum
;1407:==================
;1408:*/
;1409:int BotPointAreaNum(vec3_t origin) {
line 1413
;1410:	int areanum, numareas, areas[10];
;1411:	vec3_t end;
;1412:
;1413:	areanum = trap_AAS_PointAreaNum(origin);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 60
ADDRGP4 trap_AAS_PointAreaNum
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 60
INDIRI4
ASGNI4
line 1414
;1414:	if (areanum) return areanum;
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $274
ADDRLP4 12
INDIRI4
RETI4
ADDRGP4 $273
JUMPV
LABELV $274
line 1415
;1415:	VectorCopy(origin, end);
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1416
;1416:	end[2] += 10;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
line 1417
;1417:	numareas = trap_AAS_TraceAreas(origin, end, areas, NULL, 10);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 20
ARGP4
CNSTP4 0
ARGP4
CNSTI4 10
ARGI4
ADDRLP4 64
ADDRGP4 trap_AAS_TraceAreas
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 64
INDIRI4
ASGNI4
line 1418
;1418:	if (numareas > 0) return areas[0];
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $277
ADDRLP4 20
INDIRI4
RETI4
ADDRGP4 $273
JUMPV
LABELV $277
line 1419
;1419:	return 0;
CNSTI4 0
RETI4
LABELV $273
endproc BotPointAreaNum 68 20
export ClientName
proc ClientName 1032 12
line 1427
;1420:}
;1421:
;1422:/*
;1423:==================
;1424:ClientName
;1425:==================
;1426:*/
;1427:char *ClientName(int client, char *name, int size) {
line 1430
;1428:	char buf[MAX_INFO_STRING];
;1429:
;1430:	if (client < 0 || client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $282
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $280
LABELV $282
line 1431
;1431:		BotAI_Print(PRT_ERROR, "ClientName: client out of range\n");
CNSTI4 3
ARGI4
ADDRGP4 $283
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 1432
;1432:		return "[client out of range]";
ADDRGP4 $284
RETP4
ADDRGP4 $279
JUMPV
LABELV $280
line 1434
;1433:	}
;1434:	trap_GetConfigstring(CS_PLAYERS+client, buf, sizeof(buf));
ADDRFP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 1435
;1435:	strncpy(name, Info_ValueForKey(buf, "n"), size-1);
ADDRLP4 0
ARGP4
ADDRGP4 $285
ARGP4
ADDRLP4 1028
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 1028
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 1436
;1436:	name[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1437
;1437:	Q_CleanStr( name );
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1438
;1438:	return name;
ADDRFP4 4
INDIRP4
RETP4
LABELV $279
endproc ClientName 1032 12
export ClientSkin
proc ClientSkin 1032 12
line 1446
;1439:}
;1440:
;1441:/*
;1442:==================
;1443:ClientSkin
;1444:==================
;1445:*/
;1446:char *ClientSkin(int client, char *skin, int size) {
line 1449
;1447:	char buf[MAX_INFO_STRING];
;1448:
;1449:	if (client < 0 || client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $289
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $287
LABELV $289
line 1450
;1450:		BotAI_Print(PRT_ERROR, "ClientSkin: client out of range\n");
CNSTI4 3
ARGI4
ADDRGP4 $290
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 1451
;1451:		return "[client out of range]";
ADDRGP4 $284
RETP4
ADDRGP4 $286
JUMPV
LABELV $287
line 1453
;1452:	}
;1453:	trap_GetConfigstring(CS_PLAYERS+client, buf, sizeof(buf));
ADDRFP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 1454
;1454:	strncpy(skin, Info_ValueForKey(buf, "model"), size-1);
ADDRLP4 0
ARGP4
ADDRGP4 $291
ARGP4
ADDRLP4 1028
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 1028
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 1455
;1455:	skin[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1456
;1456:	return skin;
ADDRFP4 4
INDIRP4
RETP4
LABELV $286
endproc ClientSkin 1032 12
bss
align 4
LABELV $293
skip 4
export ClientFromName
code
proc ClientFromName 1040 12
line 1464
;1457:}
;1458:
;1459:/*
;1460:==================
;1461:ClientFromName
;1462:==================
;1463:*/
;1464:int ClientFromName(char *name) {
line 1469
;1465:	int i;
;1466:	char buf[MAX_INFO_STRING];
;1467:	static int maxclients;
;1468:
;1469:	if (!maxclients)
ADDRGP4 $293
INDIRI4
CNSTI4 0
NEI4 $294
line 1470
;1470:		maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $296
ARGP4
ADDRLP4 1028
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 $293
ADDRLP4 1028
INDIRI4
ASGNI4
LABELV $294
line 1471
;1471:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $300
JUMPV
LABELV $297
line 1472
;1472:		trap_GetConfigstring(CS_PLAYERS+i, buf, sizeof(buf));
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 1473
;1473:		Q_CleanStr( buf );
ADDRLP4 4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1474
;1474:		if (!Q_stricmp(Info_ValueForKey(buf, "n"), name)) return i;
ADDRLP4 4
ARGP4
ADDRGP4 $285
ARGP4
ADDRLP4 1032
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1032
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1036
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1036
INDIRI4
CNSTI4 0
NEI4 $301
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $292
JUMPV
LABELV $301
line 1475
;1475:	}
LABELV $298
line 1471
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $300
ADDRLP4 0
INDIRI4
ADDRGP4 $293
INDIRI4
GEI4 $303
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $297
LABELV $303
line 1476
;1476:	return -1;
CNSTI4 -1
RETI4
LABELV $292
endproc ClientFromName 1040 12
bss
align 4
LABELV $305
skip 4
export ClientOnSameTeamFromName
code
proc ClientOnSameTeamFromName 1044 12
line 1484
;1477:}
;1478:
;1479:/*
;1480:==================
;1481:ClientOnSameTeamFromName
;1482:==================
;1483:*/
;1484:int ClientOnSameTeamFromName(bot_state_t *bs, char *name) {
line 1489
;1485:	int i;
;1486:	char buf[MAX_INFO_STRING];
;1487:	static int maxclients;
;1488:
;1489:	if (!maxclients)
ADDRGP4 $305
INDIRI4
CNSTI4 0
NEI4 $306
line 1490
;1490:		maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $296
ARGP4
ADDRLP4 1028
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 $305
ADDRLP4 1028
INDIRI4
ASGNI4
LABELV $306
line 1491
;1491:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $311
JUMPV
LABELV $308
line 1492
;1492:		if (!BotSameTeam(bs, i))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 1032
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 0
NEI4 $312
line 1493
;1493:			continue;
ADDRGP4 $309
JUMPV
LABELV $312
line 1494
;1494:		trap_GetConfigstring(CS_PLAYERS+i, buf, sizeof(buf));
ADDRLP4 0
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 1495
;1495:		Q_CleanStr( buf );
ADDRLP4 4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1496
;1496:		if (!Q_stricmp(Info_ValueForKey(buf, "n"), name)) return i;
ADDRLP4 4
ARGP4
ADDRGP4 $285
ARGP4
ADDRLP4 1036
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1036
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 1040
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
NEI4 $314
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $304
JUMPV
LABELV $314
line 1497
;1497:	}
LABELV $309
line 1491
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $311
ADDRLP4 0
INDIRI4
ADDRGP4 $305
INDIRI4
GEI4 $316
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $308
LABELV $316
line 1498
;1498:	return -1;
CNSTI4 -1
RETI4
LABELV $304
endproc ClientOnSameTeamFromName 1044 12
export stristr
proc stristr 12 4
line 1506
;1499:}
;1500:
;1501:/*
;1502:==================
;1503:stristr
;1504:==================
;1505:*/
;1506:char *stristr(char *str, char *charset) {
ADDRGP4 $319
JUMPV
LABELV $318
line 1509
;1507:	int i;
;1508:
;1509:	while(*str) {
line 1510
;1510:		for (i = 0; charset[i] && str[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $324
JUMPV
LABELV $321
line 1511
;1511:			if (toupper(charset[i]) != toupper(str[i])) break;
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRI1
CVII4 1
ARGI4
ADDRLP4 4
ADDRGP4 toupper
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
ARGI4
ADDRLP4 8
ADDRGP4 toupper
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRI4
EQI4 $325
ADDRGP4 $323
JUMPV
LABELV $325
line 1512
;1512:		}
LABELV $322
line 1510
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $324
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRI1
CVII4 1
ADDRLP4 8
INDIRI4
EQI4 $327
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
ADDRLP4 8
INDIRI4
NEI4 $321
LABELV $327
LABELV $323
line 1513
;1513:		if (!charset[i]) return str;
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $328
ADDRFP4 0
INDIRP4
RETP4
ADDRGP4 $317
JUMPV
LABELV $328
line 1514
;1514:		str++;
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1515
;1515:	}
LABELV $319
line 1509
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $318
line 1516
;1516:	return NULL;
CNSTP4 0
RETP4
LABELV $317
endproc stristr 12 4
export EasyClientName
proc EasyClientName 204 12
line 1524
;1517:}
;1518:
;1519:/*
;1520:==================
;1521:EasyClientName
;1522:==================
;1523:*/
;1524:char *EasyClientName(int client, char *buf, int size) {
line 1529
;1525:	int i;
;1526:	char *str1, *str2, *ptr, c;
;1527:	char name[128];
;1528:
;1529:	strcpy(name, ClientName(client, name, sizeof(name)));
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 5
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 148
ADDRGP4 ClientName
CALLP4
ASGNP4
ADDRLP4 5
ARGP4
ADDRLP4 148
INDIRP4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 1530
;1530:	for (i = 0; name[i]; i++) name[i] &= 127;
ADDRLP4 136
CNSTI4 0
ASGNI4
ADDRGP4 $334
JUMPV
LABELV $331
ADDRLP4 152
ADDRLP4 136
INDIRI4
ADDRLP4 5
ADDP4
ASGNP4
ADDRLP4 152
INDIRP4
ADDRLP4 152
INDIRP4
INDIRI1
CVII4 1
CNSTI4 127
BANDI4
CVII1 4
ASGNI1
LABELV $332
ADDRLP4 136
ADDRLP4 136
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $334
ADDRLP4 136
INDIRI4
ADDRLP4 5
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $331
line 1532
;1531:	//remove all spaces
;1532:	for (ptr = strstr(name, " "); ptr; ptr = strstr(name, " ")) {
ADDRLP4 5
ARGP4
ADDRGP4 $339
ARGP4
ADDRLP4 156
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 156
INDIRP4
ASGNP4
ADDRGP4 $338
JUMPV
LABELV $335
line 1533
;1533:		memmove(ptr, ptr+1, strlen(ptr+1)+1);
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ARGP4
ADDRLP4 160
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 168
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 168
INDIRI4
ADDP4
ARGP4
ADDRLP4 160
INDIRI4
ADDRLP4 168
INDIRI4
ADDI4
ARGI4
ADDRGP4 memmove
CALLP4
pop
line 1534
;1534:	}
LABELV $336
line 1532
ADDRLP4 5
ARGP4
ADDRGP4 $339
ARGP4
ADDRLP4 160
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 160
INDIRP4
ASGNP4
LABELV $338
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $335
line 1536
;1535:	//check for [x] and ]x[ clan names
;1536:	str1 = strstr(name, "[");
ADDRLP4 5
ARGP4
ADDRGP4 $340
ARGP4
ADDRLP4 164
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 140
ADDRLP4 164
INDIRP4
ASGNP4
line 1537
;1537:	str2 = strstr(name, "]");
ADDRLP4 5
ARGP4
ADDRGP4 $341
ARGP4
ADDRLP4 168
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 144
ADDRLP4 168
INDIRP4
ASGNP4
line 1538
;1538:	if (str1 && str2) {
ADDRLP4 172
CNSTU4 0
ASGNU4
ADDRLP4 140
INDIRP4
CVPU4 4
ADDRLP4 172
INDIRU4
EQU4 $342
ADDRLP4 144
INDIRP4
CVPU4 4
ADDRLP4 172
INDIRU4
EQU4 $342
line 1539
;1539:		if (str2 > str1) memmove(str1, str2+1, strlen(str2+1)+1);
ADDRLP4 144
INDIRP4
CVPU4 4
ADDRLP4 140
INDIRP4
CVPU4 4
LEU4 $344
ADDRLP4 144
INDIRP4
CNSTI4 1
ADDP4
ARGP4
ADDRLP4 176
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 140
INDIRP4
ARGP4
ADDRLP4 180
CNSTI4 1
ASGNI4
ADDRLP4 144
INDIRP4
ADDRLP4 180
INDIRI4
ADDP4
ARGP4
ADDRLP4 176
INDIRI4
ADDRLP4 180
INDIRI4
ADDI4
ARGI4
ADDRGP4 memmove
CALLP4
pop
ADDRGP4 $345
JUMPV
LABELV $344
line 1540
;1540:		else memmove(str2, str1+1, strlen(str1+1)+1);
ADDRLP4 140
INDIRP4
CNSTI4 1
ADDP4
ARGP4
ADDRLP4 184
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 144
INDIRP4
ARGP4
ADDRLP4 188
CNSTI4 1
ASGNI4
ADDRLP4 140
INDIRP4
ADDRLP4 188
INDIRI4
ADDP4
ARGP4
ADDRLP4 184
INDIRI4
ADDRLP4 188
INDIRI4
ADDI4
ARGI4
ADDRGP4 memmove
CALLP4
pop
LABELV $345
line 1541
;1541:	}
LABELV $342
line 1543
;1542:	//remove Mr prefix
;1543:	if ((name[0] == 'm' || name[0] == 'M') &&
ADDRLP4 176
ADDRLP4 5
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 109
EQI4 $350
ADDRLP4 176
INDIRI4
CNSTI4 77
NEI4 $346
LABELV $350
ADDRLP4 5+1
INDIRI1
CVII4 1
CNSTI4 114
EQI4 $351
ADDRLP4 5+1
INDIRI1
CVII4 1
CNSTI4 82
NEI4 $346
LABELV $351
line 1544
;1544:			(name[1] == 'r' || name[1] == 'R')) {
line 1545
;1545:		memmove(name, name+2, strlen(name+2)+1);
ADDRLP4 5+2
ARGP4
ADDRLP4 180
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 5
ARGP4
ADDRLP4 5+2
ARGP4
ADDRLP4 180
INDIRI4
CNSTI4 1
ADDI4
ARGI4
ADDRGP4 memmove
CALLP4
pop
line 1546
;1546:	}
LABELV $346
line 1548
;1547:	//only allow lower case alphabet characters
;1548:	ptr = name;
ADDRLP4 0
ADDRLP4 5
ASGNP4
ADDRGP4 $355
JUMPV
LABELV $354
line 1549
;1549:	while(*ptr) {
line 1550
;1550:		c = *ptr;
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRI1
ASGNI1
line 1551
;1551:		if ((c >= 'a' && c <= 'z') ||
ADDRLP4 180
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 97
LTI4 $360
ADDRLP4 180
INDIRI4
CNSTI4 122
LEI4 $361
LABELV $360
ADDRLP4 184
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 48
LTI4 $362
ADDRLP4 184
INDIRI4
CNSTI4 57
LEI4 $361
LABELV $362
ADDRLP4 4
INDIRI1
CVII4 1
CNSTI4 95
NEI4 $357
LABELV $361
line 1552
;1552:				(c >= '0' && c <= '9') || c == '_') {
line 1553
;1553:			ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1554
;1554:		}
ADDRGP4 $358
JUMPV
LABELV $357
line 1555
;1555:		else if (c >= 'A' && c <= 'Z') {
ADDRLP4 188
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 188
INDIRI4
CNSTI4 65
LTI4 $363
ADDRLP4 188
INDIRI4
CNSTI4 90
GTI4 $363
line 1556
;1556:			*ptr += 'a' - 'A';
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 32
ADDI4
CVII1 4
ASGNI1
line 1557
;1557:			ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1558
;1558:		}
ADDRGP4 $364
JUMPV
LABELV $363
line 1559
;1559:		else {
line 1560
;1560:			memmove(ptr, ptr+1, strlen(ptr + 1)+1);
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ARGP4
ADDRLP4 192
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 200
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 200
INDIRI4
ADDP4
ARGP4
ADDRLP4 192
INDIRI4
ADDRLP4 200
INDIRI4
ADDI4
ARGI4
ADDRGP4 memmove
CALLP4
pop
line 1561
;1561:		}
LABELV $364
LABELV $358
line 1562
;1562:	}
LABELV $355
line 1549
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $354
line 1563
;1563:	strncpy(buf, name, size-1);
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 5
ARGP4
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 1564
;1564:	buf[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1565
;1565:	return buf;
ADDRFP4 4
INDIRP4
RETP4
LABELV $330
endproc EasyClientName 204 12
export BotSynonymContext
proc BotSynonymContext 8 4
line 1573
;1566:}
;1567:
;1568:/*
;1569:==================
;1570:BotSynonymContext
;1571:==================
;1572:*/
;1573:int BotSynonymContext(bot_state_t *bs) {
line 1576
;1574:	int context;
;1575:
;1576:	context = CONTEXT_NORMAL|CONTEXT_NEARBYITEM|CONTEXT_NAMES;
ADDRLP4 0
CNSTI4 1027
ASGNI4
line 1578
;1577:	//
;1578:	if (gametype == GT_CTF
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $366
line 1582
;1579:#ifdef MISSIONPACK
;1580:		|| gametype == GT_1FCTF
;1581:#endif
;1582:		) {
line 1583
;1583:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_CTFREDTEAM;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 1
NEI4 $368
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 4
BORI4
ASGNI4
ADDRGP4 $369
JUMPV
LABELV $368
line 1584
;1584:		else context |= CONTEXT_CTFBLUETEAM;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 8
BORI4
ASGNI4
LABELV $369
line 1585
;1585:	}
LABELV $366
line 1596
;1586:#ifdef MISSIONPACK
;1587:	else if (gametype == GT_OBELISK) {
;1588:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_OBELISKREDTEAM;
;1589:		else context |= CONTEXT_OBELISKBLUETEAM;
;1590:	}
;1591:	else if (gametype == GT_HARVESTER) {
;1592:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_HARVESTERREDTEAM;
;1593:		else context |= CONTEXT_HARVESTERBLUETEAM;
;1594:	}
;1595:#endif
;1596:	return context;
ADDRLP4 0
INDIRI4
RETI4
LABELV $365
endproc BotSynonymContext 8 4
export BotChooseWeapon
proc BotChooseWeapon 20 8
line 1604
;1597:}
;1598:
;1599:/*
;1600:==================
;1601:BotChooseWeapon
;1602:==================
;1603:*/
;1604:void BotChooseWeapon(bot_state_t *bs) {
line 1607
;1605:	int newweaponnum;
;1606:
;1607:	if (bs->cur_ps.weaponstate == WEAPON_RAISING ||
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 1
EQI4 $373
ADDRLP4 4
INDIRI4
CNSTI4 2
NEI4 $371
LABELV $373
line 1608
;1608:			bs->cur_ps.weaponstate == WEAPON_DROPPING) {
line 1610
;1609:		//trap_EA_SelectWeapon(bs->client, bs->weaponnum);
;1610:		if( g_blasterMode.integer &&
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $374
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $374
line 1611
;1611:			bs->weaponnum == WP_MACHINEGUN ) {
line 1612
;1612:			trap_EA_SelectWeapon(
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 11
ARGI4
ADDRGP4 trap_EA_SelectWeapon
CALLV
pop
line 1616
;1613:				bs->client,
;1614:				WP_BLASTER
;1615:			);
;1616:		}
ADDRGP4 $372
JUMPV
LABELV $374
line 1617
;1617:		else {
line 1618
;1618:			trap_EA_SelectWeapon(
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 8
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_SelectWeapon
CALLV
pop
line 1622
;1619:				bs->client,
;1620:				bs->weaponnum
;1621:			);
;1622:		}
line 1623
;1623:		}
ADDRGP4 $372
JUMPV
LABELV $371
line 1624
;1624:	else {
line 1625
;1625:		newweaponnum = trap_BotChooseBestFightWeapon(bs->ws, bs->inventory);
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 6536
ADDP4
INDIRI4
ARGI4
ADDRLP4 8
INDIRP4
CNSTI4 4952
ADDP4
ARGP4
ADDRLP4 12
ADDRGP4 trap_BotChooseBestFightWeapon
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 1626
;1626:		if (bs->weaponnum != newweaponnum) bs->weaponchange_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $377
ADDRFP4 0
INDIRP4
CNSTI4 6192
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
LABELV $377
line 1627
;1627:		bs->weaponnum = newweaponnum;
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1630
;1628:		//BotAI_Print(PRT_MESSAGE, "bs->weaponnum = %d\n", bs->weaponnum);
;1629:		//trap_EA_SelectWeapon(bs->client, bs->weaponnum);
;1630:		if( g_blasterMode.integer &&
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $379
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $379
line 1631
;1631:			bs->weaponnum == WP_MACHINEGUN ) {
line 1632
;1632:			trap_EA_SelectWeapon(
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 11
ARGI4
ADDRGP4 trap_EA_SelectWeapon
CALLV
pop
line 1636
;1633:				bs->client,
;1634:				WP_BLASTER
;1635:			);
;1636:		}
ADDRGP4 $380
JUMPV
LABELV $379
line 1637
;1637:		else {
line 1638
;1638:			trap_EA_SelectWeapon(
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 16
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_SelectWeapon
CALLV
pop
line 1642
;1639:				bs->client,
;1640:				bs->weaponnum
;1641:			);
;1642:		}
LABELV $380
line 1643
;1643:	}
LABELV $372
line 1644
;1644:}
LABELV $370
endproc BotChooseWeapon 20 8
export BotSetupForMovement
proc BotSetupForMovement 88 12
line 1651
;1645:
;1646:/*
;1647:==================
;1648:BotSetupForMovement
;1649:==================
;1650:*/
;1651:void BotSetupForMovement(bot_state_t *bs) {
line 1654
;1652:	bot_initmove_t initmove;
;1653:
;1654:	memset(&initmove, 0, sizeof(bot_initmove_t));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 68
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1655
;1655:	VectorCopy(bs->cur_ps.origin, initmove.origin);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRB
ASGNB 12
line 1656
;1656:	VectorCopy(bs->cur_ps.velocity, initmove.velocity);
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRB
ASGNB 12
line 1657
;1657:	VectorClear(initmove.viewoffset);
ADDRLP4 68
CNSTF4 0
ASGNF4
ADDRLP4 0+24+8
ADDRLP4 68
INDIRF4
ASGNF4
ADDRLP4 0+24+4
ADDRLP4 68
INDIRF4
ASGNF4
ADDRLP4 0+24
ADDRLP4 68
INDIRF4
ASGNF4
line 1658
;1658:	initmove.viewoffset[2] += bs->cur_ps.viewheight;
ADDRLP4 0+24+8
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 1659
;1659:	initmove.entitynum = bs->entitynum;
ADDRLP4 0+36
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1660
;1660:	initmove.client = bs->client;
ADDRLP4 0+40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1661
;1661:	initmove.thinktime = bs->thinktime;
ADDRLP4 0+44
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
ASGNF4
line 1663
;1662:	//set the onground flag
;1663:	if (bs->cur_ps.groundEntityNum != ENTITYNUM_NONE) initmove.or_moveflags |= MFL_ONGROUND;
ADDRFP4 0
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 1023
EQI4 $394
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 2
BORI4
ASGNI4
LABELV $394
line 1665
;1664:	//set the teleported flag
;1665:	if ((bs->cur_ps.pm_flags & PMF_TIME_KNOCKBACK) && (bs->cur_ps.pm_time > 0)) {
ADDRLP4 72
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 76
CNSTI4 0
ASGNI4
ADDRLP4 72
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
CNSTI4 64
BANDI4
ADDRLP4 76
INDIRI4
EQI4 $397
ADDRLP4 72
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
LEI4 $397
line 1666
;1666:		initmove.or_moveflags |= MFL_TELEPORTED;
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 1667
;1667:	}
LABELV $397
line 1669
;1668:	//set the waterjump flag
;1669:	if ((bs->cur_ps.pm_flags & PMF_TIME_WATERJUMP) && (bs->cur_ps.pm_time > 0)) {
ADDRLP4 80
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 80
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
CNSTI4 256
BANDI4
ADDRLP4 84
INDIRI4
EQI4 $400
ADDRLP4 80
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
LEI4 $400
line 1670
;1670:		initmove.or_moveflags |= MFL_WATERJUMP;
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 1671
;1671:	}
LABELV $400
line 1673
;1672:	//set presence type
;1673:	if (bs->cur_ps.pm_flags & PMF_DUCKED) initmove.presencetype = PRESENCE_CROUCH;
ADDRFP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $403
ADDRLP4 0+48
CNSTI4 4
ASGNI4
ADDRGP4 $404
JUMPV
LABELV $403
line 1674
;1674:	else initmove.presencetype = PRESENCE_NORMAL;
ADDRLP4 0+48
CNSTI4 2
ASGNI4
LABELV $404
line 1676
;1675:	//
;1676:	if (bs->walker > 0.5) initmove.or_moveflags |= MFL_WALK;
ADDRFP4 0
INDIRP4
CNSTI4 6056
ADDP4
INDIRF4
CNSTF4 1056964608
LEF4 $407
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 512
BORI4
ASGNI4
LABELV $407
line 1678
;1677:	//
;1678:	VectorCopy(bs->viewangles, initmove.viewangles);
ADDRLP4 0+52
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
INDIRB
ASGNB 12
line 1680
;1679:	//
;1680:	trap_BotInitMoveState(bs->ms, &initmove);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_BotInitMoveState
CALLV
pop
line 1681
;1681:}
LABELV $382
endproc BotSetupForMovement 88 12
export BotCheckItemPickup
proc BotCheckItemPickup 0 0
line 1688
;1682:
;1683:/*
;1684:==================
;1685:BotCheckItemPickup
;1686:==================
;1687:*/
;1688:void BotCheckItemPickup(bot_state_t *bs, int *oldinventory) {
line 1775
;1689:#ifdef MISSIONPACK
;1690:	int offence, leader;
;1691:
;1692:	if (gametype <= GT_TEAM)
;1693:		return;
;1694:
;1695:	offence = -1;
;1696:	// go into offence if picked up the kamikaze or invulnerability
;1697:	if (!oldinventory[INVENTORY_KAMIKAZE] && bs->inventory[INVENTORY_KAMIKAZE] >= 1) {
;1698:		offence = qtrue;
;1699:	}
;1700:	if (!oldinventory[INVENTORY_INVULNERABILITY] && bs->inventory[INVENTORY_INVULNERABILITY] >= 1) {
;1701:		offence = qtrue;
;1702:	}
;1703:	// if not already wearing the kamikaze or invulnerability
;1704:	if (!bs->inventory[INVENTORY_KAMIKAZE] && !bs->inventory[INVENTORY_INVULNERABILITY]) {
;1705:		if (!oldinventory[INVENTORY_SCOUT] && bs->inventory[INVENTORY_SCOUT] >= 1) {
;1706:			offence = qtrue;
;1707:		}
;1708:		if (!oldinventory[INVENTORY_GUARD] && bs->inventory[INVENTORY_GUARD] >= 1) {
;1709:			offence = qtrue;
;1710:		}
;1711:		if (!oldinventory[INVENTORY_DOUBLER] && bs->inventory[INVENTORY_DOUBLER] >= 1) {
;1712:			offence = qfalse;
;1713:		}
;1714:		if (!oldinventory[INVENTORY_AMMOREGEN] && bs->inventory[INVENTORY_AMMOREGEN] >= 1) {
;1715:			offence = qfalse;
;1716:		}
;1717:	}
;1718:
;1719:	if (offence >= 0) {
;1720:		leader = ClientFromName(bs->teamleader);
;1721:		if (offence) {
;1722:			if (!(bs->teamtaskpreference & TEAMTP_ATTACKER)) {
;1723:				// if we have a bot team leader
;1724:				if (BotTeamLeader(bs)) {
;1725:					// tell the leader we want to be on offence
;1726:					BotVoiceChat(bs, leader, VOICECHAT_WANTONOFFENSE);
;1727:					//BotAI_BotInitialChat(bs, "wantoffence", NULL);
;1728:					//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1729:				}
;1730:				else if (g_spSkill.integer <= 3) {
;1731:					if ( bs->ltgtype != LTG_GETFLAG &&
;1732:						 bs->ltgtype != LTG_ATTACKENEMYBASE &&
;1733:						 bs->ltgtype != LTG_HARVEST ) {
;1734:						//
;1735:						if ((gametype != GT_CTF || (bs->redflagstatus == 0 && bs->blueflagstatus == 0)) &&
;1736:							(gametype != GT_1FCTF || bs->neutralflagstatus == 0) ) {
;1737:							// tell the leader we want to be on offence
;1738:							BotVoiceChat(bs, leader, VOICECHAT_WANTONOFFENSE);
;1739:							//BotAI_BotInitialChat(bs, "wantoffence", NULL);
;1740:							//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1741:						}
;1742:					}
;1743:					bs->teamtaskpreference |= TEAMTP_ATTACKER;
;1744:				}
;1745:			}
;1746:			bs->teamtaskpreference &= ~TEAMTP_DEFENDER;
;1747:		}
;1748:		else {
;1749:			if (!(bs->teamtaskpreference & TEAMTP_DEFENDER)) {
;1750:				// if we have a bot team leader
;1751:				if (BotTeamLeader(bs)) {
;1752:					// tell the leader we want to be on defense
;1753:					BotVoiceChat(bs, -1, VOICECHAT_WANTONDEFENSE);
;1754:					//BotAI_BotInitialChat(bs, "wantdefence", NULL);
;1755:					//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1756:				}
;1757:				else if (g_spSkill.integer <= 3) {
;1758:					if ( bs->ltgtype != LTG_DEFENDKEYAREA ) {
;1759:						//
;1760:						if ((gametype != GT_CTF || (bs->redflagstatus == 0 && bs->blueflagstatus == 0)) &&
;1761:							(gametype != GT_1FCTF || bs->neutralflagstatus == 0) ) {
;1762:							// tell the leader we want to be on defense
;1763:							BotVoiceChat(bs, -1, VOICECHAT_WANTONDEFENSE);
;1764:							//BotAI_BotInitialChat(bs, "wantdefence", NULL);
;1765:							//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1766:						}
;1767:					}
;1768:				}
;1769:				bs->teamtaskpreference |= TEAMTP_DEFENDER;
;1770:			}
;1771:			bs->teamtaskpreference &= ~TEAMTP_ATTACKER;
;1772:		}
;1773:	}
;1774:#endif
;1775:}
LABELV $411
endproc BotCheckItemPickup 0 0
export BotUpdateInventory
proc BotUpdateInventory 1216 12
line 1782
;1776:
;1777:/*
;1778:==================
;1779:BotUpdateInventory
;1780:==================
;1781:*/
;1782:void BotUpdateInventory(bot_state_t *bs) {
line 1785
;1783:	int oldinventory[MAX_ITEMS];
;1784:
;1785:	memcpy(oldinventory, bs->inventory, sizeof(oldinventory));
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 4952
ADDP4
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 1787
;1786:	//armor
;1787:	bs->inventory[INVENTORY_ARMOR] = bs->cur_ps.stats[STAT_ARMOR];
ADDRLP4 1024
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1024
INDIRP4
CNSTI4 4956
ADDP4
ADDRLP4 1024
INDIRP4
CNSTI4 212
ADDP4
INDIRI4
ASGNI4
line 1789
;1788:	//weapons
;1789:	bs->inventory[INVENTORY_GAUNTLET] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GAUNTLET)) != 0;
ADDRLP4 1032
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1032
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $414
ADDRLP4 1028
CNSTI4 1
ASGNI4
ADDRGP4 $415
JUMPV
LABELV $414
ADDRLP4 1028
CNSTI4 0
ASGNI4
LABELV $415
ADDRLP4 1032
INDIRP4
CNSTI4 4968
ADDP4
ADDRLP4 1028
INDIRI4
ASGNI4
line 1790
;1790:	bs->inventory[INVENTORY_SHOTGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_SHOTGUN)) != 0;
ADDRLP4 1040
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1040
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $417
ADDRLP4 1036
CNSTI4 1
ASGNI4
ADDRGP4 $418
JUMPV
LABELV $417
ADDRLP4 1036
CNSTI4 0
ASGNI4
LABELV $418
ADDRLP4 1040
INDIRP4
CNSTI4 4972
ADDP4
ADDRLP4 1036
INDIRI4
ASGNI4
line 1792
;1791:	//bs->inventory[INVENTORY_MACHINEGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_MACHINEGUN)) != 0;
;1792:	if( g_blasterMode.integer ) {
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $419
line 1793
;1793:		bs->inventory[INVENTORY_MACHINEGUN] =
ADDRLP4 1048
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1048
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
CNSTI4 0
EQI4 $423
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $424
JUMPV
LABELV $423
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $424
ADDRLP4 1048
INDIRP4
CNSTI4 4976
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1796
;1794:			(bs->cur_ps.stats[STAT_WEAPONS] &
;1795:			(1 << WP_BLASTER)) != 0;
;1796:	}
ADDRGP4 $420
JUMPV
LABELV $419
line 1797
;1797:	else {
line 1798
;1798:		bs->inventory[INVENTORY_MACHINEGUN] =
ADDRLP4 1048
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1048
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $426
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $427
JUMPV
LABELV $426
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $427
ADDRLP4 1048
INDIRP4
CNSTI4 4976
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1801
;1799:			(bs->cur_ps.stats[STAT_WEAPONS] &
;1800:			(1 << WP_MACHINEGUN)) != 0;
;1801:	}
LABELV $420
line 1802
;1802:	bs->inventory[INVENTORY_GRENADELAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GRENADE_LAUNCHER)) != 0;
ADDRLP4 1048
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1048
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $429
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $430
JUMPV
LABELV $429
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $430
ADDRLP4 1048
INDIRP4
CNSTI4 4980
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1803
;1803:	bs->inventory[INVENTORY_ROCKETLAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_ROCKET_LAUNCHER)) != 0;
ADDRLP4 1056
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1056
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
EQI4 $432
ADDRLP4 1052
CNSTI4 1
ASGNI4
ADDRGP4 $433
JUMPV
LABELV $432
ADDRLP4 1052
CNSTI4 0
ASGNI4
LABELV $433
ADDRLP4 1056
INDIRP4
CNSTI4 4984
ADDP4
ADDRLP4 1052
INDIRI4
ASGNI4
line 1804
;1804:	bs->inventory[INVENTORY_LIGHTNING] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_LIGHTNING)) != 0;
ADDRLP4 1064
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1064
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 64
BANDI4
CNSTI4 0
EQI4 $435
ADDRLP4 1060
CNSTI4 1
ASGNI4
ADDRGP4 $436
JUMPV
LABELV $435
ADDRLP4 1060
CNSTI4 0
ASGNI4
LABELV $436
ADDRLP4 1064
INDIRP4
CNSTI4 4988
ADDP4
ADDRLP4 1060
INDIRI4
ASGNI4
line 1805
;1805:	bs->inventory[INVENTORY_RAILGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_RAILGUN)) != 0;
ADDRLP4 1072
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1072
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $438
ADDRLP4 1068
CNSTI4 1
ASGNI4
ADDRGP4 $439
JUMPV
LABELV $438
ADDRLP4 1068
CNSTI4 0
ASGNI4
LABELV $439
ADDRLP4 1072
INDIRP4
CNSTI4 4992
ADDP4
ADDRLP4 1068
INDIRI4
ASGNI4
line 1806
;1806:	bs->inventory[INVENTORY_PLASMAGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_PLASMAGUN)) != 0;
ADDRLP4 1080
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1080
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $441
ADDRLP4 1076
CNSTI4 1
ASGNI4
ADDRGP4 $442
JUMPV
LABELV $441
ADDRLP4 1076
CNSTI4 0
ASGNI4
LABELV $442
ADDRLP4 1080
INDIRP4
CNSTI4 4996
ADDP4
ADDRLP4 1076
INDIRI4
ASGNI4
line 1807
;1807:	bs->inventory[INVENTORY_BFG10K] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_BFG)) != 0;
ADDRLP4 1088
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1088
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 512
BANDI4
CNSTI4 0
EQI4 $444
ADDRLP4 1084
CNSTI4 1
ASGNI4
ADDRGP4 $445
JUMPV
LABELV $444
ADDRLP4 1084
CNSTI4 0
ASGNI4
LABELV $445
ADDRLP4 1088
INDIRP4
CNSTI4 5004
ADDP4
ADDRLP4 1084
INDIRI4
ASGNI4
line 1808
;1808:	bs->inventory[INVENTORY_GRAPPLINGHOOK] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GRAPPLING_HOOK)) != 0;
ADDRLP4 1096
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1096
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $447
ADDRLP4 1092
CNSTI4 1
ASGNI4
ADDRGP4 $448
JUMPV
LABELV $447
ADDRLP4 1092
CNSTI4 0
ASGNI4
LABELV $448
ADDRLP4 1096
INDIRP4
CNSTI4 5008
ADDP4
ADDRLP4 1092
INDIRI4
ASGNI4
line 1815
;1809:#ifdef MISSIONPACK
;1810:	bs->inventory[INVENTORY_NAILGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_NAILGUN)) != 0;;
;1811:	bs->inventory[INVENTORY_PROXLAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_PROX_LAUNCHER)) != 0;;
;1812:	bs->inventory[INVENTORY_CHAINGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_CHAINGUN)) != 0;;
;1813:#endif
;1814:	//ammo
;1815:	bs->inventory[INVENTORY_SHELLS] = bs->cur_ps.ammo[WP_SHOTGUN];
ADDRLP4 1100
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1100
INDIRP4
CNSTI4 5024
ADDP4
ADDRLP4 1100
INDIRP4
CNSTI4 404
ADDP4
INDIRI4
ASGNI4
line 1817
;1816:	//bs->inventory[INVENTORY_BULLETS] = bs->cur_ps.ammo[WP_MACHINEGUN];
;1817:	if( g_blasterMode.integer &&
ADDRLP4 1104
CNSTI4 0
ASGNI4
ADDRGP4 g_blasterMode+12
INDIRI4
ADDRLP4 1104
INDIRI4
EQI4 $449
ADDRFP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
ADDRLP4 1104
INDIRI4
EQI4 $449
line 1819
;1818:		(bs->cur_ps.stats[STAT_WEAPONS] &
;1819:		(1 << WP_BLASTER)) ) {
line 1824
;1820:		/*
;1821:		 * This value is only used by bot AI when choosing a weapon.
;1822:		 * Actual Blaster ammunition remains infinite.
;1823:		 */
;1824:		bs->inventory[INVENTORY_BULLETS] = 1;
ADDRFP4 0
INDIRP4
CNSTI4 5028
ADDP4
CNSTI4 1
ASGNI4
line 1825
;1825:	}
ADDRGP4 $450
JUMPV
LABELV $449
line 1826
;1826:	else {
line 1827
;1827:		bs->inventory[INVENTORY_BULLETS] =
ADDRLP4 1108
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1108
INDIRP4
CNSTI4 5028
ADDP4
ADDRLP4 1108
INDIRP4
CNSTI4 400
ADDP4
INDIRI4
ASGNI4
line 1829
;1828:			bs->cur_ps.ammo[WP_MACHINEGUN];
;1829:	}
LABELV $450
line 1830
;1830:	bs->inventory[INVENTORY_GRENADES] = bs->cur_ps.ammo[WP_GRENADE_LAUNCHER];
ADDRLP4 1108
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1108
INDIRP4
CNSTI4 5032
ADDP4
ADDRLP4 1108
INDIRP4
CNSTI4 408
ADDP4
INDIRI4
ASGNI4
line 1831
;1831:	bs->inventory[INVENTORY_CELLS] = bs->cur_ps.ammo[WP_PLASMAGUN];
ADDRLP4 1112
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1112
INDIRP4
CNSTI4 5036
ADDP4
ADDRLP4 1112
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
ASGNI4
line 1832
;1832:	bs->inventory[INVENTORY_LIGHTNINGAMMO] = bs->cur_ps.ammo[WP_LIGHTNING];
ADDRLP4 1116
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1116
INDIRP4
CNSTI4 5040
ADDP4
ADDRLP4 1116
INDIRP4
CNSTI4 416
ADDP4
INDIRI4
ASGNI4
line 1833
;1833:	bs->inventory[INVENTORY_ROCKETS] = bs->cur_ps.ammo[WP_ROCKET_LAUNCHER];
ADDRLP4 1120
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1120
INDIRP4
CNSTI4 5044
ADDP4
ADDRLP4 1120
INDIRP4
CNSTI4 412
ADDP4
INDIRI4
ASGNI4
line 1834
;1834:	bs->inventory[INVENTORY_SLUGS] = bs->cur_ps.ammo[WP_RAILGUN];
ADDRLP4 1124
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1124
INDIRP4
CNSTI4 5048
ADDP4
ADDRLP4 1124
INDIRP4
CNSTI4 420
ADDP4
INDIRI4
ASGNI4
line 1835
;1835:	bs->inventory[INVENTORY_BFGAMMO] = bs->cur_ps.ammo[WP_BFG];
ADDRLP4 1128
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1128
INDIRP4
CNSTI4 5052
ADDP4
ADDRLP4 1128
INDIRP4
CNSTI4 428
ADDP4
INDIRI4
ASGNI4
line 1842
;1836:#ifdef MISSIONPACK
;1837:	bs->inventory[INVENTORY_NAILS] = bs->cur_ps.ammo[WP_NAILGUN];
;1838:	bs->inventory[INVENTORY_MINES] = bs->cur_ps.ammo[WP_PROX_LAUNCHER];
;1839:	bs->inventory[INVENTORY_BELT] = bs->cur_ps.ammo[WP_CHAINGUN];
;1840:#endif
;1841:	//powerups
;1842:	bs->inventory[INVENTORY_HEALTH] = bs->cur_ps.stats[STAT_HEALTH];
ADDRLP4 1132
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1132
INDIRP4
CNSTI4 5068
ADDP4
ADDRLP4 1132
INDIRP4
CNSTI4 200
ADDP4
INDIRI4
ASGNI4
line 1843
;1843:	bs->inventory[INVENTORY_TELEPORTER] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_TELEPORTER;
ADDRLP4 1140
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1140
INDIRP4
CNSTI4 204
ADDP4
INDIRI4
CNSTI4 26
NEI4 $453
ADDRLP4 1136
CNSTI4 1
ASGNI4
ADDRGP4 $454
JUMPV
LABELV $453
ADDRLP4 1136
CNSTI4 0
ASGNI4
LABELV $454
ADDRLP4 1140
INDIRP4
CNSTI4 5072
ADDP4
ADDRLP4 1136
INDIRI4
ASGNI4
line 1844
;1844:	bs->inventory[INVENTORY_MEDKIT] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_MEDKIT;
ADDRLP4 1148
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1148
INDIRP4
CNSTI4 204
ADDP4
INDIRI4
CNSTI4 27
NEI4 $456
ADDRLP4 1144
CNSTI4 1
ASGNI4
ADDRGP4 $457
JUMPV
LABELV $456
ADDRLP4 1144
CNSTI4 0
ASGNI4
LABELV $457
ADDRLP4 1148
INDIRP4
CNSTI4 5076
ADDP4
ADDRLP4 1144
INDIRI4
ASGNI4
line 1850
;1845:#ifdef MISSIONPACK
;1846:	bs->inventory[INVENTORY_KAMIKAZE] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_KAMIKAZE;
;1847:	bs->inventory[INVENTORY_PORTAL] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_PORTAL;
;1848:	bs->inventory[INVENTORY_INVULNERABILITY] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_INVULNERABILITY;
;1849:#endif
;1850:	bs->inventory[INVENTORY_QUAD] = bs->cur_ps.powerups[PW_QUAD] != 0;
ADDRLP4 1156
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1156
INDIRP4
CNSTI4 332
ADDP4
INDIRI4
CNSTI4 0
EQI4 $459
ADDRLP4 1152
CNSTI4 1
ASGNI4
ADDRGP4 $460
JUMPV
LABELV $459
ADDRLP4 1152
CNSTI4 0
ASGNI4
LABELV $460
ADDRLP4 1156
INDIRP4
CNSTI4 5092
ADDP4
ADDRLP4 1152
INDIRI4
ASGNI4
line 1851
;1851:	bs->inventory[INVENTORY_ENVIRONMENTSUIT] = bs->cur_ps.powerups[PW_BATTLESUIT] != 0;
ADDRLP4 1164
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1164
INDIRP4
CNSTI4 336
ADDP4
INDIRI4
CNSTI4 0
EQI4 $462
ADDRLP4 1160
CNSTI4 1
ASGNI4
ADDRGP4 $463
JUMPV
LABELV $462
ADDRLP4 1160
CNSTI4 0
ASGNI4
LABELV $463
ADDRLP4 1164
INDIRP4
CNSTI4 5096
ADDP4
ADDRLP4 1160
INDIRI4
ASGNI4
line 1852
;1852:	bs->inventory[INVENTORY_HASTE] = bs->cur_ps.powerups[PW_HASTE] != 0;
ADDRLP4 1172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1172
INDIRP4
CNSTI4 340
ADDP4
INDIRI4
CNSTI4 0
EQI4 $465
ADDRLP4 1168
CNSTI4 1
ASGNI4
ADDRGP4 $466
JUMPV
LABELV $465
ADDRLP4 1168
CNSTI4 0
ASGNI4
LABELV $466
ADDRLP4 1172
INDIRP4
CNSTI4 5100
ADDP4
ADDRLP4 1168
INDIRI4
ASGNI4
line 1853
;1853:	bs->inventory[INVENTORY_INVISIBILITY] = bs->cur_ps.powerups[PW_INVIS] != 0;
ADDRLP4 1180
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1180
INDIRP4
CNSTI4 344
ADDP4
INDIRI4
CNSTI4 0
EQI4 $468
ADDRLP4 1176
CNSTI4 1
ASGNI4
ADDRGP4 $469
JUMPV
LABELV $468
ADDRLP4 1176
CNSTI4 0
ASGNI4
LABELV $469
ADDRLP4 1180
INDIRP4
CNSTI4 5104
ADDP4
ADDRLP4 1176
INDIRI4
ASGNI4
line 1854
;1854:	bs->inventory[INVENTORY_REGEN] = bs->cur_ps.powerups[PW_REGEN] != 0;
ADDRLP4 1188
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1188
INDIRP4
CNSTI4 348
ADDP4
INDIRI4
CNSTI4 0
EQI4 $471
ADDRLP4 1184
CNSTI4 1
ASGNI4
ADDRGP4 $472
JUMPV
LABELV $471
ADDRLP4 1184
CNSTI4 0
ASGNI4
LABELV $472
ADDRLP4 1188
INDIRP4
CNSTI4 5108
ADDP4
ADDRLP4 1184
INDIRI4
ASGNI4
line 1855
;1855:	bs->inventory[INVENTORY_FLIGHT] = bs->cur_ps.powerups[PW_FLIGHT] != 0;
ADDRLP4 1196
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1196
INDIRP4
CNSTI4 352
ADDP4
INDIRI4
CNSTI4 0
EQI4 $474
ADDRLP4 1192
CNSTI4 1
ASGNI4
ADDRGP4 $475
JUMPV
LABELV $474
ADDRLP4 1192
CNSTI4 0
ASGNI4
LABELV $475
ADDRLP4 1196
INDIRP4
CNSTI4 5112
ADDP4
ADDRLP4 1192
INDIRI4
ASGNI4
line 1862
;1856:#ifdef MISSIONPACK
;1857:	bs->inventory[INVENTORY_SCOUT] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_SCOUT;
;1858:	bs->inventory[INVENTORY_GUARD] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_GUARD;
;1859:	bs->inventory[INVENTORY_DOUBLER] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_DOUBLER;
;1860:	bs->inventory[INVENTORY_AMMOREGEN] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_AMMOREGEN;
;1861:#endif
;1862:	bs->inventory[INVENTORY_REDFLAG] = bs->cur_ps.powerups[PW_REDFLAG] != 0;
ADDRLP4 1204
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1204
INDIRP4
CNSTI4 356
ADDP4
INDIRI4
CNSTI4 0
EQI4 $477
ADDRLP4 1200
CNSTI4 1
ASGNI4
ADDRGP4 $478
JUMPV
LABELV $477
ADDRLP4 1200
CNSTI4 0
ASGNI4
LABELV $478
ADDRLP4 1204
INDIRP4
CNSTI4 5132
ADDP4
ADDRLP4 1200
INDIRI4
ASGNI4
line 1863
;1863:	bs->inventory[INVENTORY_BLUEFLAG] = bs->cur_ps.powerups[PW_BLUEFLAG] != 0;
ADDRLP4 1212
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1212
INDIRP4
CNSTI4 360
ADDP4
INDIRI4
CNSTI4 0
EQI4 $480
ADDRLP4 1208
CNSTI4 1
ASGNI4
ADDRGP4 $481
JUMPV
LABELV $480
ADDRLP4 1208
CNSTI4 0
ASGNI4
LABELV $481
ADDRLP4 1212
INDIRP4
CNSTI4 5136
ADDP4
ADDRLP4 1208
INDIRI4
ASGNI4
line 1875
;1864:#ifdef MISSIONPACK
;1865:	bs->inventory[INVENTORY_NEUTRALFLAG] = bs->cur_ps.powerups[PW_NEUTRALFLAG] != 0;
;1866:	if (BotTeam(bs) == TEAM_RED) {
;1867:		bs->inventory[INVENTORY_REDCUBE] = bs->cur_ps.generic1;
;1868:		bs->inventory[INVENTORY_BLUECUBE] = 0;
;1869:	}
;1870:	else {
;1871:		bs->inventory[INVENTORY_REDCUBE] = 0;
;1872:		bs->inventory[INVENTORY_BLUECUBE] = bs->cur_ps.generic1;
;1873:	}
;1874:#endif
;1875:	BotCheckItemPickup(bs, oldinventory);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckItemPickup
CALLV
pop
line 1876
;1876:}
LABELV $412
endproc BotUpdateInventory 1216 12
export BotUpdateBattleInventory
proc BotUpdateBattleInventory 160 8
line 1883
;1877:
;1878:/*
;1879:==================
;1880:BotUpdateBattleInventory
;1881:==================
;1882:*/
;1883:void BotUpdateBattleInventory(bot_state_t *bs, int enemy) {
line 1887
;1884:	vec3_t dir;
;1885:	aas_entityinfo_t entinfo;
;1886:
;1887:	BotEntityInfo(enemy, &entinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 1888
;1888:	VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 152
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 12+24
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 12+24+4
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 12+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1889
;1889:	bs->inventory[ENEMY_HEIGHT] = (int) dir[2];
ADDRFP4 0
INDIRP4
CNSTI4 5756
ADDP4
ADDRLP4 0+8
INDIRF4
CVFI4 4
ASGNI4
line 1890
;1890:	dir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1891
;1891:	bs->inventory[ENEMY_HORIZONTAL_DIST] = (int) VectorLength(dir);
ADDRLP4 0
ARGP4
ADDRLP4 156
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 5752
ADDP4
ADDRLP4 156
INDIRF4
CVFI4 4
ASGNI4
line 1893
;1892:	//FIXME: add num visible enemies and num visible team mates to the inventory
;1893:}
LABELV $482
endproc BotUpdateBattleInventory 160 8
export BotBattleUseItems
proc BotBattleUseItems 4 4
line 2120
;1894:
;1895:#ifdef MISSIONPACK
;1896:/*
;1897:==================
;1898:BotUseKamikaze
;1899:==================
;1900:*/
;1901:#define KAMIKAZE_DIST		1024
;1902:
;1903:void BotUseKamikaze(bot_state_t *bs) {
;1904:	int c, teammates, enemies;
;1905:	aas_entityinfo_t entinfo;
;1906:	vec3_t dir, target;
;1907:	bot_goal_t *goal;
;1908:	bsp_trace_t trace;
;1909:
;1910:	//if the bot has no kamikaze
;1911:	if (bs->inventory[INVENTORY_KAMIKAZE] <= 0)
;1912:		return;
;1913:	if (bs->kamikaze_time > FloatTime())
;1914:		return;
;1915:	bs->kamikaze_time = FloatTime() + 0.2;
;1916:	if (gametype == GT_CTF) {
;1917:		//never use kamikaze if the team flag carrier is visible
;1918:		if (BotCTFCarryingFlag(bs))
;1919:			return;
;1920:		c = BotTeamFlagCarrierVisible(bs);
;1921:		if (c >= 0) {
;1922:			BotEntityInfo(c, &entinfo);
;1923:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1924:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1925:				return;
;1926:		}
;1927:		c = BotEnemyFlagCarrierVisible(bs);
;1928:		if (c >= 0) {
;1929:			BotEntityInfo(c, &entinfo);
;1930:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1931:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1932:				trap_EA_Use(bs->client);
;1933:				return;
;1934:			}
;1935:		}
;1936:	}
;1937:	else if (gametype == GT_1FCTF) {
;1938:		//never use kamikaze if the team flag carrier is visible
;1939:		if (Bot1FCTFCarryingFlag(bs))
;1940:			return;
;1941:		c = BotTeamFlagCarrierVisible(bs);
;1942:		if (c >= 0) {
;1943:			BotEntityInfo(c, &entinfo);
;1944:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1945:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1946:				return;
;1947:		}
;1948:		c = BotEnemyFlagCarrierVisible(bs);
;1949:		if (c >= 0) {
;1950:			BotEntityInfo(c, &entinfo);
;1951:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1952:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1953:				trap_EA_Use(bs->client);
;1954:				return;
;1955:			}
;1956:		}
;1957:	}
;1958:	else if (gametype == GT_OBELISK) {
;1959:		switch(BotTeam(bs)) {
;1960:			case TEAM_RED: goal = &blueobelisk; break;
;1961:			default: goal = &redobelisk; break;
;1962:		}
;1963:		//if the obelisk is visible
;1964:		VectorCopy(goal->origin, target);
;1965:		target[2] += 1;
;1966:		VectorSubtract(bs->origin, target, dir);
;1967:		if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST * 0.9)) {
;1968:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;1969:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;1970:				trap_EA_Use(bs->client);
;1971:				return;
;1972:			}
;1973:		}
;1974:	}
;1975:	else if (gametype == GT_HARVESTER) {
;1976:		//
;1977:		if (BotHarvesterCarryingCubes(bs))
;1978:			return;
;1979:		//never use kamikaze if a team mate carrying cubes is visible
;1980:		c = BotTeamCubeCarrierVisible(bs);
;1981:		if (c >= 0) {
;1982:			BotEntityInfo(c, &entinfo);
;1983:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1984:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1985:				return;
;1986:		}
;1987:		c = BotEnemyCubeCarrierVisible(bs);
;1988:		if (c >= 0) {
;1989:			BotEntityInfo(c, &entinfo);
;1990:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1991:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1992:				trap_EA_Use(bs->client);
;1993:				return;
;1994:			}
;1995:		}
;1996:	}
;1997:	//
;1998:	BotVisibleTeamMatesAndEnemies(bs, &teammates, &enemies, KAMIKAZE_DIST);
;1999:	//
;2000:	if (enemies > 2 && enemies > teammates+1) {
;2001:		trap_EA_Use(bs->client);
;2002:		return;
;2003:	}
;2004:}
;2005:
;2006:/*
;2007:==================
;2008:BotUseInvulnerability
;2009:==================
;2010:*/
;2011:void BotUseInvulnerability(bot_state_t *bs) {
;2012:	int c;
;2013:	vec3_t dir, target;
;2014:	bot_goal_t *goal;
;2015:	bsp_trace_t trace;
;2016:
;2017:	//if the bot has no invulnerability
;2018:	if (bs->inventory[INVENTORY_INVULNERABILITY] <= 0)
;2019:		return;
;2020:	if (bs->invulnerability_time > FloatTime())
;2021:		return;
;2022:	bs->invulnerability_time = FloatTime() + 0.2;
;2023:	if (gametype == GT_CTF) {
;2024:		//never use kamikaze if the team flag carrier is visible
;2025:		if (BotCTFCarryingFlag(bs))
;2026:			return;
;2027:		c = BotEnemyFlagCarrierVisible(bs);
;2028:		if (c >= 0)
;2029:			return;
;2030:		//if near enemy flag and the flag is visible
;2031:		switch(BotTeam(bs)) {
;2032:			case TEAM_RED: goal = &ctf_blueflag; break;
;2033:			default: goal = &ctf_redflag; break;
;2034:		}
;2035:		//if the obelisk is visible
;2036:		VectorCopy(goal->origin, target);
;2037:		target[2] += 1;
;2038:		VectorSubtract(bs->origin, target, dir);
;2039:		if (VectorLengthSquared(dir) < Square(200)) {
;2040:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2041:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2042:				trap_EA_Use(bs->client);
;2043:				return;
;2044:			}
;2045:		}
;2046:	}
;2047:	else if (gametype == GT_1FCTF) {
;2048:		//never use kamikaze if the team flag carrier is visible
;2049:		if (Bot1FCTFCarryingFlag(bs))
;2050:			return;
;2051:		c = BotEnemyFlagCarrierVisible(bs);
;2052:		if (c >= 0)
;2053:			return;
;2054:		//if near enemy flag and the flag is visible
;2055:		switch(BotTeam(bs)) {
;2056:			case TEAM_RED: goal = &ctf_blueflag; break;
;2057:			default: goal = &ctf_redflag; break;
;2058:		}
;2059:		//if the obelisk is visible
;2060:		VectorCopy(goal->origin, target);
;2061:		target[2] += 1;
;2062:		VectorSubtract(bs->origin, target, dir);
;2063:		if (VectorLengthSquared(dir) < Square(200)) {
;2064:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2065:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2066:				trap_EA_Use(bs->client);
;2067:				return;
;2068:			}
;2069:		}
;2070:	}
;2071:	else if (gametype == GT_OBELISK) {
;2072:		switch(BotTeam(bs)) {
;2073:			case TEAM_RED: goal = &blueobelisk; break;
;2074:			default: goal = &redobelisk; break;
;2075:		}
;2076:		//if the obelisk is visible
;2077:		VectorCopy(goal->origin, target);
;2078:		target[2] += 1;
;2079:		VectorSubtract(bs->origin, target, dir);
;2080:		if (VectorLengthSquared(dir) < Square(300)) {
;2081:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2082:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2083:				trap_EA_Use(bs->client);
;2084:				return;
;2085:			}
;2086:		}
;2087:	}
;2088:	else if (gametype == GT_HARVESTER) {
;2089:		//
;2090:		if (BotHarvesterCarryingCubes(bs))
;2091:			return;
;2092:		c = BotEnemyCubeCarrierVisible(bs);
;2093:		if (c >= 0)
;2094:			return;
;2095:		//if near enemy base and enemy base is visible
;2096:		switch(BotTeam(bs)) {
;2097:			case TEAM_RED: goal = &blueobelisk; break;
;2098:			default: goal = &redobelisk; break;
;2099:		}
;2100:		//if the obelisk is visible
;2101:		VectorCopy(goal->origin, target);
;2102:		target[2] += 1;
;2103:		VectorSubtract(bs->origin, target, dir);
;2104:		if (VectorLengthSquared(dir) < Square(200)) {
;2105:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2106:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2107:				trap_EA_Use(bs->client);
;2108:				return;
;2109:			}
;2110:		}
;2111:	}
;2112:}
;2113:#endif
;2114:
;2115:/*
;2116:==================
;2117:BotBattleUseItems
;2118:==================
;2119:*/
;2120:void BotBattleUseItems(bot_state_t *bs) {
line 2121
;2121:	if (bs->inventory[INVENTORY_HEALTH] < 40) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 40
GEI4 $493
line 2122
;2122:		if (bs->inventory[INVENTORY_TELEPORTER] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5072
ADDP4
INDIRI4
CNSTI4 0
LEI4 $495
line 2123
;2123:			if (!BotCTFCarryingFlag(bs)
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $497
line 2128
;2124:#ifdef MISSIONPACK
;2125:				&& !Bot1FCTFCarryingFlag(bs)
;2126:				&& !BotHarvesterCarryingCubes(bs)
;2127:#endif
;2128:				) {
line 2129
;2129:				trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 2130
;2130:			}
LABELV $497
line 2131
;2131:		}
LABELV $495
line 2132
;2132:	}
LABELV $493
line 2133
;2133:	if (bs->inventory[INVENTORY_HEALTH] < 60) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $499
line 2134
;2134:		if (bs->inventory[INVENTORY_MEDKIT] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5076
ADDP4
INDIRI4
CNSTI4 0
LEI4 $501
line 2135
;2135:			trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 2136
;2136:		}
LABELV $501
line 2137
;2137:	}
LABELV $499
line 2142
;2138:#ifdef MISSIONPACK
;2139:	BotUseKamikaze(bs);
;2140:	BotUseInvulnerability(bs);
;2141:#endif
;2142:}
LABELV $492
endproc BotBattleUseItems 4 4
export BotSetTeleportTime
proc BotSetTeleportTime 8 0
line 2149
;2143:
;2144:/*
;2145:==================
;2146:BotSetTeleportTime
;2147:==================
;2148:*/
;2149:void BotSetTeleportTime(bot_state_t *bs) {
line 2150
;2150:	if ((bs->cur_ps.eFlags ^ bs->last_eFlags) & EF_TELEPORT_BIT) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 484
ADDP4
INDIRI4
BXORI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $504
line 2151
;2151:		bs->teleport_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6180
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2152
;2152:	}
LABELV $504
line 2153
;2153:	bs->last_eFlags = bs->cur_ps.eFlags;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 484
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
ASGNI4
line 2154
;2154:}
LABELV $503
endproc BotSetTeleportTime 8 0
export BotIsDead
proc BotIsDead 4 0
line 2161
;2155:
;2156:/*
;2157:==================
;2158:BotIsDead
;2159:==================
;2160:*/
;2161:qboolean BotIsDead(bot_state_t *bs) {
line 2162
;2162:	return (bs->cur_ps.pm_type == PM_DEAD);
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 3
NEI4 $508
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $509
JUMPV
LABELV $508
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $509
ADDRLP4 0
INDIRI4
RETI4
LABELV $506
endproc BotIsDead 4 0
export BotIsObserver
proc BotIsObserver 1032 12
line 2170
;2163:}
;2164:
;2165:/*
;2166:==================
;2167:BotIsObserver
;2168:==================
;2169:*/
;2170:qboolean BotIsObserver(bot_state_t *bs) {
line 2172
;2171:	char buf[MAX_INFO_STRING];
;2172:	if (bs->cur_ps.pm_type == PM_SPECTATOR) return qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 2
NEI4 $511
CNSTI4 1
RETI4
ADDRGP4 $510
JUMPV
LABELV $511
line 2173
;2173:	trap_GetConfigstring(CS_PLAYERS+bs->client, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 2174
;2174:	if (atoi(Info_ValueForKey(buf, "t")) == TEAM_SPECTATOR) return qtrue;
ADDRLP4 0
ARGP4
ADDRGP4 $71
ARGP4
ADDRLP4 1024
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 1024
INDIRP4
ARGP4
ADDRLP4 1028
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 1028
INDIRI4
CNSTI4 3
NEI4 $513
CNSTI4 1
RETI4
ADDRGP4 $510
JUMPV
LABELV $513
line 2175
;2175:	return qfalse;
CNSTI4 0
RETI4
LABELV $510
endproc BotIsObserver 1032 12
export BotIntermission
proc BotIntermission 8 0
line 2183
;2176:}
;2177:
;2178:/*
;2179:==================
;2180:BotIntermission
;2181:==================
;2182:*/
;2183:qboolean BotIntermission(bot_state_t *bs) {
line 2185
;2184:	//NOTE: we shouldn't be looking at the game code...
;2185:	if (level.intermissiontime) return qtrue;
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $516
CNSTI4 1
RETI4
ADDRGP4 $515
JUMPV
LABELV $516
line 2186
;2186:	return (bs->cur_ps.pm_type == PM_FREEZE || bs->cur_ps.pm_type == PM_INTERMISSION);
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 4
EQI4 $522
ADDRLP4 4
INDIRI4
CNSTI4 5
NEI4 $520
LABELV $522
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $521
JUMPV
LABELV $520
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $521
ADDRLP4 0
INDIRI4
RETI4
LABELV $515
endproc BotIntermission 8 0
export BotInLavaOrSlime
proc BotInLavaOrSlime 16 4
line 2194
;2187:}
;2188:
;2189:/*
;2190:==================
;2191:BotInLavaOrSlime
;2192:==================
;2193:*/
;2194:qboolean BotInLavaOrSlime(bot_state_t *bs) {
line 2197
;2195:	vec3_t feet;
;2196:
;2197:	VectorCopy(bs->origin, feet);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 2198
;2198:	feet[2] -= 23;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1102577664
SUBF4
ASGNF4
line 2199
;2199:	return (trap_AAS_PointContents(feet) & (CONTENTS_LAVA|CONTENTS_SLIME));
ADDRLP4 0
ARGP4
ADDRLP4 12
ADDRGP4 trap_AAS_PointContents
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 24
BANDI4
RETI4
LABELV $523
endproc BotInLavaOrSlime 16 4
lit
align 4
LABELV $526
byte 4 3238002688
byte 4 3238002688
byte 4 3238002688
align 4
LABELV $527
byte 4 1090519040
byte 4 1090519040
byte 4 1090519040
export BotCreateWayPoint
code
proc BotCreateWayPoint 32 12
line 2207
;2200:}
;2201:
;2202:/*
;2203:==================
;2204:BotCreateWayPoint
;2205:==================
;2206:*/
;2207:bot_waypoint_t *BotCreateWayPoint(char *name, vec3_t origin, int areanum) {
line 2209
;2208:	bot_waypoint_t *wp;
;2209:	vec3_t waypointmins = {-8, -8, -8}, waypointmaxs = {8, 8, 8};
ADDRLP4 4
ADDRGP4 $526
INDIRB
ASGNB 12
ADDRLP4 16
ADDRGP4 $527
INDIRB
ASGNB 12
line 2211
;2210:
;2211:	wp = botai_freewaypoints;
ADDRLP4 0
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2212
;2212:	if ( !wp ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $528
line 2213
;2213:		BotAI_Print( PRT_WARNING, "BotCreateWayPoint: Out of waypoints\n" );
CNSTI4 2
ARGI4
ADDRGP4 $530
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 2214
;2214:		return NULL;
CNSTP4 0
RETP4
ADDRGP4 $525
JUMPV
LABELV $528
line 2216
;2215:	}
;2216:	botai_freewaypoints = botai_freewaypoints->next;
ADDRLP4 28
ADDRGP4 botai_freewaypoints
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
line 2218
;2217:
;2218:	Q_strncpyz( wp->name, name, sizeof(wp->name) );
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 32
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
line 2219
;2219:	VectorCopy(origin, wp->goal.origin);
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2220
;2220:	VectorCopy(waypointmins, wp->goal.mins);
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 2221
;2221:	VectorCopy(waypointmaxs, wp->goal.maxs);
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
ADDRLP4 16
INDIRB
ASGNB 12
line 2222
;2222:	wp->goal.areanum = areanum;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 2223
;2223:	wp->next = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
CNSTP4 0
ASGNP4
line 2224
;2224:	wp->prev = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
CNSTP4 0
ASGNP4
line 2225
;2225:	return wp;
ADDRLP4 0
INDIRP4
RETP4
LABELV $525
endproc BotCreateWayPoint 32 12
export BotFindWayPoint
proc BotFindWayPoint 8 8
line 2233
;2226:}
;2227:
;2228:/*
;2229:==================
;2230:BotFindWayPoint
;2231:==================
;2232:*/
;2233:bot_waypoint_t *BotFindWayPoint(bot_waypoint_t *waypoints, char *name) {
line 2236
;2234:	bot_waypoint_t *wp;
;2235:
;2236:	for (wp = waypoints; wp; wp = wp->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $535
JUMPV
LABELV $532
line 2237
;2237:		if (!Q_stricmp(wp->name, name)) return wp;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $536
ADDRLP4 0
INDIRP4
RETP4
ADDRGP4 $531
JUMPV
LABELV $536
line 2238
;2238:	}
LABELV $533
line 2236
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
LABELV $535
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $532
line 2239
;2239:	return NULL;
CNSTP4 0
RETP4
LABELV $531
endproc BotFindWayPoint 8 8
export BotFreeWaypoints
proc BotFreeWaypoints 4 0
line 2247
;2240:}
;2241:
;2242:/*
;2243:==================
;2244:BotFreeWaypoints
;2245:==================
;2246:*/
;2247:void BotFreeWaypoints(bot_waypoint_t *wp) {
line 2250
;2248:	bot_waypoint_t *nextwp;
;2249:
;2250:	for (; wp; wp = nextwp) {
ADDRGP4 $542
JUMPV
LABELV $539
line 2251
;2251:		nextwp = wp->next;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
line 2252
;2252:		wp->next = botai_freewaypoints;
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2253
;2253:		botai_freewaypoints = wp;
ADDRGP4 botai_freewaypoints
ADDRFP4 0
INDIRP4
ASGNP4
line 2254
;2254:	}
LABELV $540
line 2250
ADDRFP4 0
ADDRLP4 0
INDIRP4
ASGNP4
LABELV $542
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $539
line 2255
;2255:}
LABELV $538
endproc BotFreeWaypoints 4 0
export BotInitWaypoints
proc BotInitWaypoints 4 0
line 2262
;2256:
;2257:/*
;2258:==================
;2259:BotInitWaypoints
;2260:==================
;2261:*/
;2262:void BotInitWaypoints(void) {
line 2265
;2263:	int i;
;2264:
;2265:	botai_freewaypoints = NULL;
ADDRGP4 botai_freewaypoints
CNSTP4 0
ASGNP4
line 2266
;2266:	for (i = 0; i < MAX_WAYPOINTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $544
line 2267
;2267:		botai_waypoints[i].next = botai_freewaypoints;
CNSTI4 100
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botai_waypoints+92
ADDP4
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2268
;2268:		botai_freewaypoints = &botai_waypoints[i];
ADDRGP4 botai_freewaypoints
CNSTI4 100
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botai_waypoints
ADDP4
ASGNP4
line 2269
;2269:	}
LABELV $545
line 2266
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 128
LTI4 $544
line 2270
;2270:}
LABELV $543
endproc BotInitWaypoints 4 0
export TeamPlayIsOn
proc TeamPlayIsOn 4 0
line 2277
;2271:
;2272:/*
;2273:==================
;2274:TeamPlayIsOn
;2275:==================
;2276:*/
;2277:int TeamPlayIsOn(void) {
line 2278
;2278:	return ( gametype >= GT_TEAM );
ADDRGP4 gametype
INDIRI4
CNSTI4 3
LTI4 $551
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $552
JUMPV
LABELV $551
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $552
ADDRLP4 0
INDIRI4
RETI4
LABELV $549
endproc TeamPlayIsOn 4 0
export BotAggression
proc BotAggression 28 0
line 2286
;2279:}
;2280:
;2281:/*
;2282:==================
;2283:BotAggression
;2284:==================
;2285:*/
;2286:float BotAggression(bot_state_t *bs) {
line 2288
;2287:	//if the bot has quad
;2288:	if (bs->inventory[INVENTORY_QUAD]) {
ADDRFP4 0
INDIRP4
CNSTI4 5092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $554
line 2290
;2289:		//if the bot is not holding the gauntlet or the enemy is really nearby
;2290:		if (bs->weaponnum != WP_GAUNTLET ||
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $558
ADDRLP4 0
INDIRP4
CNSTI4 5752
ADDP4
INDIRI4
CNSTI4 80
GEI4 $556
LABELV $558
line 2291
;2291:			bs->inventory[ENEMY_HORIZONTAL_DIST] < 80) {
line 2292
;2292:			return 70;
CNSTF4 1116471296
RETF4
ADDRGP4 $553
JUMPV
LABELV $556
line 2294
;2293:		}
;2294:	}
LABELV $554
line 2296
;2295:	//if the enemy is located way higher than the bot
;2296:	if (bs->inventory[ENEMY_HEIGHT] > 200) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 5756
ADDP4
INDIRI4
CNSTI4 200
LEI4 $559
CNSTF4 0
RETF4
ADDRGP4 $553
JUMPV
LABELV $559
line 2298
;2297:	//if the bot is very low on health
;2298:	if (bs->inventory[INVENTORY_HEALTH] < 60) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $561
CNSTF4 0
RETF4
ADDRGP4 $553
JUMPV
LABELV $561
line 2300
;2299:	//if the bot is low on health
;2300:	if (bs->inventory[INVENTORY_HEALTH] < 80) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 80
GEI4 $563
line 2302
;2301:		//if the bot has insufficient armor
;2302:		if (bs->inventory[INVENTORY_ARMOR] < 40) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $565
CNSTF4 0
RETF4
ADDRGP4 $553
JUMPV
LABELV $565
line 2303
;2303:	}
LABELV $563
line 2305
;2304:	//if the bot can use the bfg
;2305:	if (bs->inventory[INVENTORY_BFG10K] > 0 &&
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 5004
ADDP4
INDIRI4
CNSTI4 0
LEI4 $567
ADDRLP4 0
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 7
LEI4 $567
line 2306
;2306:			bs->inventory[INVENTORY_BFGAMMO] > 7) return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $553
JUMPV
LABELV $567
line 2308
;2307:	//if the bot can use the railgun
;2308:	if (bs->inventory[INVENTORY_RAILGUN] > 0 &&
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 4992
ADDP4
INDIRI4
CNSTI4 0
LEI4 $569
ADDRLP4 4
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 5
LEI4 $569
line 2309
;2309:			bs->inventory[INVENTORY_SLUGS] > 5) return 95;
CNSTF4 1119748096
RETF4
ADDRGP4 $553
JUMPV
LABELV $569
line 2311
;2310:	//if the bot can use the lightning gun
;2311:	if (bs->inventory[INVENTORY_LIGHTNING] > 0 &&
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 4988
ADDP4
INDIRI4
CNSTI4 0
LEI4 $571
ADDRLP4 8
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
CNSTI4 50
LEI4 $571
line 2312
;2312:			bs->inventory[INVENTORY_LIGHTNINGAMMO] > 50) return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $553
JUMPV
LABELV $571
line 2314
;2313:	//if the bot can use the rocketlauncher
;2314:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 &&
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
CNSTI4 0
LEI4 $573
ADDRLP4 12
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 5
LEI4 $573
line 2315
;2315:			bs->inventory[INVENTORY_ROCKETS] > 5) return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $553
JUMPV
LABELV $573
line 2317
;2316:	//if the bot can use the plasmagun
;2317:	if (bs->inventory[INVENTORY_PLASMAGUN] > 0 &&
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 4996
ADDP4
INDIRI4
CNSTI4 0
LEI4 $575
ADDRLP4 16
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
CNSTI4 40
LEI4 $575
line 2318
;2318:			bs->inventory[INVENTORY_CELLS] > 40) return 85;
CNSTF4 1118437376
RETF4
ADDRGP4 $553
JUMPV
LABELV $575
line 2320
;2319:	//if the bot can use the grenade launcher
;2320:	if (bs->inventory[INVENTORY_GRENADELAUNCHER] > 0 &&
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 4980
ADDP4
INDIRI4
CNSTI4 0
LEI4 $577
ADDRLP4 20
INDIRP4
CNSTI4 5032
ADDP4
INDIRI4
CNSTI4 10
LEI4 $577
line 2321
;2321:			bs->inventory[INVENTORY_GRENADES] > 10) return 80;
CNSTF4 1117782016
RETF4
ADDRGP4 $553
JUMPV
LABELV $577
line 2323
;2322:	//if the bot can use the shotgun
;2323:	if (bs->inventory[INVENTORY_SHOTGUN] > 0 &&
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
CNSTI4 4972
ADDP4
INDIRI4
CNSTI4 0
LEI4 $579
ADDRLP4 24
INDIRP4
CNSTI4 5024
ADDP4
INDIRI4
CNSTI4 10
LEI4 $579
line 2324
;2324:			bs->inventory[INVENTORY_SHELLS] > 10) return 50;
CNSTF4 1112014848
RETF4
ADDRGP4 $553
JUMPV
LABELV $579
line 2326
;2325:	//otherwise the bot is not feeling too good
;2326:	return 0;
CNSTF4 0
RETF4
LABELV $553
endproc BotAggression 28 0
export BotFeelingBad
proc BotFeelingBad 0 0
line 2334
;2327:}
;2328:
;2329:/*
;2330:==================
;2331:BotFeelingBad
;2332:==================
;2333:*/
;2334:float BotFeelingBad(bot_state_t *bs) {
line 2335
;2335:	if (bs->weaponnum == WP_GAUNTLET) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $582
line 2336
;2336:		return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $581
JUMPV
LABELV $582
line 2338
;2337:	}
;2338:	if (bs->inventory[INVENTORY_HEALTH] < 40) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 40
GEI4 $584
line 2339
;2339:		return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $581
JUMPV
LABELV $584
line 2341
;2340:	}
;2341:	if (bs->weaponnum == WP_MACHINEGUN) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $586
line 2342
;2342:		return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $581
JUMPV
LABELV $586
line 2344
;2343:	}
;2344:	if (bs->inventory[INVENTORY_HEALTH] < 60) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $588
line 2345
;2345:		return 80;
CNSTF4 1117782016
RETF4
ADDRGP4 $581
JUMPV
LABELV $588
line 2347
;2346:	}
;2347:	return 0;
CNSTF4 0
RETF4
LABELV $581
endproc BotFeelingBad 0 0
export BotWantsToRetreat
proc BotWantsToRetreat 144 8
line 2355
;2348:}
;2349:
;2350:/*
;2351:==================
;2352:BotWantsToRetreat
;2353:==================
;2354:*/
;2355:int BotWantsToRetreat(bot_state_t *bs) {
line 2358
;2356:	aas_entityinfo_t entinfo;
;2357:
;2358:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $591
line 2360
;2359:		//always retreat when carrying a CTF flag
;2360:		if (BotCTFCarryingFlag(bs))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $593
line 2361
;2361:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $590
JUMPV
LABELV $593
line 2362
;2362:	}
LABELV $591
line 2388
;2363:#ifdef MISSIONPACK
;2364:	else if (gametype == GT_1FCTF) {
;2365:		//if carrying the flag then always retreat
;2366:		if (Bot1FCTFCarryingFlag(bs))
;2367:			return qtrue;
;2368:	}
;2369:	else if (gametype == GT_OBELISK) {
;2370:		//the bots should be dedicated to attacking the enemy obelisk
;2371:		if (bs->ltgtype == LTG_ATTACKENEMYBASE) {
;2372:			if (bs->enemy != redobelisk.entitynum ||
;2373:						bs->enemy != blueobelisk.entitynum) {
;2374:				return qtrue;
;2375:			}
;2376:		}
;2377:		if (BotFeelingBad(bs) > 50) {
;2378:			return qtrue;
;2379:		}
;2380:		return qfalse;
;2381:	}
;2382:	else if (gametype == GT_HARVESTER) {
;2383:		//if carrying cubes then always retreat
;2384:		if (BotHarvesterCarryingCubes(bs)) return qtrue;
;2385:	}
;2386:#endif
;2387:	//
;2388:	if (bs->enemy >= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
LTI4 $595
line 2390
;2389:		//if the enemy is carrying a flag
;2390:		BotEntityInfo(bs->enemy, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2391
;2391:		if (EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 140
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $597
line 2392
;2392:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $590
JUMPV
LABELV $597
line 2393
;2393:	}
LABELV $595
line 2395
;2394:	//if the bot is getting the flag
;2395:	if (bs->ltgtype == LTG_GETFLAG)
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $599
line 2396
;2396:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $590
JUMPV
LABELV $599
line 2398
;2397:	//
;2398:	if (BotAggression(bs) < 50)
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotAggression
CALLF4
ASGNF4
ADDRLP4 140
INDIRF4
CNSTF4 1112014848
GEF4 $601
line 2399
;2399:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $590
JUMPV
LABELV $601
line 2400
;2400:	return qfalse;
CNSTI4 0
RETI4
LABELV $590
endproc BotWantsToRetreat 144 8
export BotWantsToChase
proc BotWantsToChase 148 8
line 2408
;2401:}
;2402:
;2403:/*
;2404:==================
;2405:BotWantsToChase
;2406:==================
;2407:*/
;2408:int BotWantsToChase(bot_state_t *bs) {
line 2411
;2409:	aas_entityinfo_t entinfo;
;2410:
;2411:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $604
line 2413
;2412:		//never chase when carrying a CTF flag
;2413:		if (BotCTFCarryingFlag(bs))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $606
line 2414
;2414:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $603
JUMPV
LABELV $606
line 2416
;2415:		//always chase if the enemy is carrying a flag
;2416:		BotEntityInfo(bs->enemy, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2417
;2417:		if (EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 144
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
EQI4 $608
line 2418
;2418:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $603
JUMPV
LABELV $608
line 2419
;2419:	}
LABELV $604
line 2446
;2420:#ifdef MISSIONPACK
;2421:	else if (gametype == GT_1FCTF) {
;2422:		//never chase if carrying the flag
;2423:		if (Bot1FCTFCarryingFlag(bs))
;2424:			return qfalse;
;2425:		//always chase if the enemy is carrying a flag
;2426:		BotEntityInfo(bs->enemy, &entinfo);
;2427:		if (EntityCarriesFlag(&entinfo))
;2428:			return qtrue;
;2429:	}
;2430:	else if (gametype == GT_OBELISK) {
;2431:		//the bots should be dedicated to attacking the enemy obelisk
;2432:		if (bs->ltgtype == LTG_ATTACKENEMYBASE) {
;2433:			if (bs->enemy != redobelisk.entitynum ||
;2434:						bs->enemy != blueobelisk.entitynum) {
;2435:				return qfalse;
;2436:			}
;2437:		}
;2438:	}
;2439:	else if (gametype == GT_HARVESTER) {
;2440:		//never chase if carrying cubes
;2441:		if (BotHarvesterCarryingCubes(bs))
;2442:			return qfalse;
;2443:	}
;2444:#endif
;2445:	//if the bot is getting the flag
;2446:	if (bs->ltgtype == LTG_GETFLAG)
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $610
line 2447
;2447:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $603
JUMPV
LABELV $610
line 2449
;2448:	//
;2449:	if (BotAggression(bs) > 50)
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotAggression
CALLF4
ASGNF4
ADDRLP4 140
INDIRF4
CNSTF4 1112014848
LEF4 $612
line 2450
;2450:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $603
JUMPV
LABELV $612
line 2451
;2451:	return qfalse;
CNSTI4 0
RETI4
LABELV $603
endproc BotWantsToChase 148 8
export BotWantsToHelp
proc BotWantsToHelp 0 0
line 2459
;2452:}
;2453:
;2454:/*
;2455:==================
;2456:BotWantsToHelp
;2457:==================
;2458:*/
;2459:int BotWantsToHelp(bot_state_t *bs) {
line 2460
;2460:	return qtrue;
CNSTI4 1
RETI4
LABELV $614
endproc BotWantsToHelp 0 0
export BotCanAndWantsToRocketJump
proc BotCanAndWantsToRocketJump 8 16
line 2468
;2461:}
;2462:
;2463:/*
;2464:==================
;2465:BotCanAndWantsToRocketJump
;2466:==================
;2467:*/
;2468:int BotCanAndWantsToRocketJump(bot_state_t *bs) {
line 2472
;2469:	float rocketjumper;
;2470:
;2471:	//if rocket jumping is disabled
;2472:	if (!bot_rocketjump.integer) return qfalse;
ADDRGP4 bot_rocketjump+12
INDIRI4
CNSTI4 0
NEI4 $616
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $616
line 2474
;2473:	//if no rocket launcher
;2474:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] <= 0) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
CNSTI4 0
GTI4 $619
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $619
line 2476
;2475:	//if low on rockets
;2476:	if (bs->inventory[INVENTORY_ROCKETS] < 3) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 3
GEI4 $621
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $621
line 2478
;2477:	//never rocket jump with the Quad
;2478:	if (bs->inventory[INVENTORY_QUAD]) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $623
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $623
line 2480
;2479:	//if low on health
;2480:	if (bs->inventory[INVENTORY_HEALTH] < 60) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $625
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $625
line 2482
;2481:	//if not full health
;2482:	if (bs->inventory[INVENTORY_HEALTH] < 90) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 90
GEI4 $627
line 2484
;2483:		//if the bot has insufficient armor
;2484:		if (bs->inventory[INVENTORY_ARMOR] < 40) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $629
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $629
line 2485
;2485:	}
LABELV $627
line 2486
;2486:	rocketjumper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_WEAPONJUMPING, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 38
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 4
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 4
INDIRF4
ASGNF4
line 2487
;2487:	if (rocketjumper < 0.5) return qfalse;
ADDRLP4 0
INDIRF4
CNSTF4 1056964608
GEF4 $631
CNSTI4 0
RETI4
ADDRGP4 $615
JUMPV
LABELV $631
line 2488
;2488:	return qtrue;
CNSTI4 1
RETI4
LABELV $615
endproc BotCanAndWantsToRocketJump 8 16
export BotHasPersistantPowerupAndWeapon
proc BotHasPersistantPowerupAndWeapon 32 0
line 2496
;2489:}
;2490:
;2491:/*
;2492:==================
;2493:BotHasPersistantPowerupAndWeapon
;2494:==================
;2495:*/
;2496:int BotHasPersistantPowerupAndWeapon(bot_state_t *bs) {
line 2507
;2497:#ifdef MISSIONPACK
;2498:	// if the bot does not have a persistant powerup
;2499:	if (!bs->inventory[INVENTORY_SCOUT] &&
;2500:		!bs->inventory[INVENTORY_GUARD] &&
;2501:		!bs->inventory[INVENTORY_DOUBLER] &&
;2502:		!bs->inventory[INVENTORY_AMMOREGEN] ) {
;2503:		return qfalse;
;2504:	}
;2505:#endif
;2506:	//if the bot is very low on health
;2507:	if (bs->inventory[INVENTORY_HEALTH] < 60) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $634
CNSTI4 0
RETI4
ADDRGP4 $633
JUMPV
LABELV $634
line 2509
;2508:	//if the bot is low on health
;2509:	if (bs->inventory[INVENTORY_HEALTH] < 80) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 80
GEI4 $636
line 2511
;2510:		//if the bot has insufficient armor
;2511:		if (bs->inventory[INVENTORY_ARMOR] < 40) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $638
CNSTI4 0
RETI4
ADDRGP4 $633
JUMPV
LABELV $638
line 2512
;2512:	}
LABELV $636
line 2514
;2513:	//if the bot can use the bfg
;2514:	if (bs->inventory[INVENTORY_BFG10K] > 0 &&
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 5004
ADDP4
INDIRI4
CNSTI4 0
LEI4 $640
ADDRLP4 0
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 7
LEI4 $640
line 2515
;2515:			bs->inventory[INVENTORY_BFGAMMO] > 7) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $640
line 2517
;2516:	//if the bot can use the railgun
;2517:	if (bs->inventory[INVENTORY_RAILGUN] > 0 &&
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 4992
ADDP4
INDIRI4
CNSTI4 0
LEI4 $642
ADDRLP4 4
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 5
LEI4 $642
line 2518
;2518:			bs->inventory[INVENTORY_SLUGS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $642
line 2520
;2519:	//if the bot can use the lightning gun
;2520:	if (bs->inventory[INVENTORY_LIGHTNING] > 0 &&
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 4988
ADDP4
INDIRI4
CNSTI4 0
LEI4 $644
ADDRLP4 8
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
CNSTI4 50
LEI4 $644
line 2521
;2521:			bs->inventory[INVENTORY_LIGHTNINGAMMO] > 50) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $644
line 2523
;2522:	//if the bot can use the rocketlauncher
;2523:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 &&
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
CNSTI4 0
LEI4 $646
ADDRLP4 12
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 5
LEI4 $646
line 2524
;2524:			bs->inventory[INVENTORY_ROCKETS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $646
line 2526
;2525:	//
;2526:	if (bs->inventory[INVENTORY_NAILGUN] > 0 &&
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
CNSTI4 5012
ADDP4
INDIRI4
CNSTI4 0
LEI4 $648
ADDRLP4 16
INDIRP4
CNSTI4 5056
ADDP4
INDIRI4
CNSTI4 5
LEI4 $648
line 2527
;2527:			bs->inventory[INVENTORY_NAILS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $648
line 2529
;2528:	//
;2529:	if (bs->inventory[INVENTORY_PROXLAUNCHER] > 0 &&
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 5016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $650
ADDRLP4 20
INDIRP4
CNSTI4 5060
ADDP4
INDIRI4
CNSTI4 5
LEI4 $650
line 2530
;2530:			bs->inventory[INVENTORY_MINES] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $650
line 2532
;2531:	//
;2532:	if (bs->inventory[INVENTORY_CHAINGUN] > 0 &&
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
CNSTI4 5020
ADDP4
INDIRI4
CNSTI4 0
LEI4 $652
ADDRLP4 24
INDIRP4
CNSTI4 5064
ADDP4
INDIRI4
CNSTI4 40
LEI4 $652
line 2533
;2533:			bs->inventory[INVENTORY_BELT] > 40) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $652
line 2535
;2534:	//if the bot can use the plasmagun
;2535:	if (bs->inventory[INVENTORY_PLASMAGUN] > 0 &&
ADDRLP4 28
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 4996
ADDP4
INDIRI4
CNSTI4 0
LEI4 $654
ADDRLP4 28
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
CNSTI4 20
LEI4 $654
line 2536
;2536:			bs->inventory[INVENTORY_CELLS] > 20) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $633
JUMPV
LABELV $654
line 2537
;2537:	return qfalse;
CNSTI4 0
RETI4
LABELV $633
endproc BotHasPersistantPowerupAndWeapon 32 0
export BotGoCamp
proc BotGoCamp 16 16
line 2545
;2538:}
;2539:
;2540:/*
;2541:==================
;2542:BotGoCamp
;2543:==================
;2544:*/
;2545:void BotGoCamp(bot_state_t *bs, bot_goal_t *goal) {
line 2548
;2546:	float camper;
;2547:
;2548:	bs->decisionmaker = bs->client;
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 6608
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 2550
;2549:	//set message time to zero so bot will NOT show any message
;2550:	bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 2552
;2551:	//set the ltg type
;2552:	bs->ltgtype = LTG_CAMP;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 7
ASGNI4
line 2554
;2553:	//set the team goal
;2554:	memcpy(&bs->teamgoal, goal, sizeof(bot_goal_t));
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 2556
;2555:	//get the team goal time
;2556:	camper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CAMPER, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 44
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 8
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 8
INDIRF4
ASGNF4
line 2557
;2557:	if (camper > 0.99) bs->teamgoal_time = FloatTime() + 99999;
ADDRLP4 0
INDIRF4
CNSTF4 1065185444
LEF4 $657
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1203982208
ADDF4
ASGNF4
ADDRGP4 $658
JUMPV
LABELV $657
line 2558
;2558:	else bs->teamgoal_time = FloatTime() + 120 + 180 * camper + random() * 15;
ADDRLP4 12
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
CNSTF4 1127481344
ADDRLP4 0
INDIRF4
MULF4
ADDF4
CNSTF4 1097859072
ADDRLP4 12
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
ASGNF4
LABELV $658
line 2560
;2559:	//set the last time the bot started camping
;2560:	bs->camp_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2562
;2561:	//the teammate that requested the camping
;2562:	bs->teammate = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
CNSTI4 0
ASGNI4
line 2564
;2563:	//do NOT type arrive message
;2564:	bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 2565
;2565:}
LABELV $656
endproc BotGoCamp 16 16
export BotWantsToCamp
proc BotWantsToCamp 176 16
line 2572
;2566:
;2567:/*
;2568:==================
;2569:BotWantsToCamp
;2570:==================
;2571:*/
;2572:int BotWantsToCamp(bot_state_t *bs) {
line 2577
;2573:	float camper;
;2574:	int cs, traveltime, besttraveltime;
;2575:	bot_goal_t goal, bestgoal;
;2576:
;2577:	camper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CAMPER, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 44
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 128
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 124
ADDRLP4 128
INDIRF4
ASGNF4
line 2578
;2578:	if (camper < 0.1) return qfalse;
ADDRLP4 124
INDIRF4
CNSTF4 1036831949
GEF4 $660
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $660
line 2580
;2579:	//if the bot has a team goal
;2580:	if (bs->ltgtype == LTG_TEAMHELP ||
ADDRLP4 132
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
ADDRLP4 132
INDIRI4
CNSTI4 1
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 2
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 3
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 4
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 5
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 7
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 8
EQI4 $670
ADDRLP4 132
INDIRI4
CNSTI4 9
NEI4 $662
LABELV $670
line 2587
;2581:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;2582:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;2583:			bs->ltgtype == LTG_GETFLAG ||
;2584:			bs->ltgtype == LTG_RUSHBASE ||
;2585:			bs->ltgtype == LTG_CAMP ||
;2586:			bs->ltgtype == LTG_CAMPORDER ||
;2587:			bs->ltgtype == LTG_PATROL) {
line 2588
;2588:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $662
line 2591
;2589:	}
;2590:	//if camped recently
;2591:	if (bs->camp_time > FloatTime() - 60 + 300 * (1-camper)) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1114636288
SUBF4
CNSTF4 1133903872
CNSTF4 1065353216
ADDRLP4 124
INDIRF4
SUBF4
MULF4
ADDF4
LEF4 $671
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $671
line 2593
;2592:	//
;2593:	if (random() > camper) {
ADDRLP4 136
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 136
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 124
INDIRF4
LEF4 $673
line 2594
;2594:		bs->camp_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2595
;2595:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $673
line 2598
;2596:	}
;2597:	//if the bot isn't healthy anough
;2598:	if (BotAggression(bs) < 50) return qfalse;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotAggression
CALLF4
ASGNF4
ADDRLP4 140
INDIRF4
CNSTF4 1112014848
GEF4 $675
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $675
line 2600
;2599:	//the bot should have at least have the rocket launcher, the railgun or the bfg10k with some ammo
;2600:	if ((bs->inventory[INVENTORY_ROCKETLAUNCHER] <= 0 || bs->inventory[INVENTORY_ROCKETS < 10]) &&
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 148
CNSTI4 0
ASGNI4
ADDRLP4 144
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
ADDRLP4 148
INDIRI4
LEI4 $679
ADDRLP4 144
INDIRP4
CNSTI4 4952
ADDP4
INDIRI4
ADDRLP4 148
INDIRI4
EQI4 $677
LABELV $679
ADDRLP4 152
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 152
INDIRP4
CNSTI4 4992
ADDP4
INDIRI4
CNSTI4 0
LEI4 $680
ADDRLP4 152
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 10
GEI4 $677
LABELV $680
ADDRLP4 156
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 156
INDIRP4
CNSTI4 5004
ADDP4
INDIRI4
CNSTI4 0
LEI4 $681
ADDRLP4 156
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 10
GEI4 $677
LABELV $681
line 2602
;2601:		(bs->inventory[INVENTORY_RAILGUN] <= 0 || bs->inventory[INVENTORY_SLUGS] < 10) &&
;2602:		(bs->inventory[INVENTORY_BFG10K] <= 0 || bs->inventory[INVENTORY_BFGAMMO] < 10)) {
line 2603
;2603:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $677
line 2606
;2604:	}
;2605:	//find the closest camp spot
;2606:	besttraveltime = 99999;
ADDRLP4 64
CNSTI4 99999
ASGNI4
line 2607
;2607:	for (cs = trap_BotGetNextCampSpotGoal(0, &goal); cs; cs = trap_BotGetNextCampSpotGoal(cs, &goal)) {
CNSTI4 0
ARGI4
ADDRLP4 8
ARGP4
ADDRLP4 160
ADDRGP4 trap_BotGetNextCampSpotGoal
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 160
INDIRI4
ASGNI4
ADDRGP4 $685
JUMPV
LABELV $682
line 2608
;2608:		traveltime = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, goal.areanum, TFL_DEFAULT);
ADDRLP4 164
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 164
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 164
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 8+12
INDIRI4
ARGI4
CNSTI4 18616254
ARGI4
ADDRLP4 168
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 168
INDIRI4
ASGNI4
line 2609
;2609:		if (traveltime && traveltime < besttraveltime) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $687
ADDRLP4 0
INDIRI4
ADDRLP4 64
INDIRI4
GEI4 $687
line 2610
;2610:			besttraveltime = traveltime;
ADDRLP4 64
ADDRLP4 0
INDIRI4
ASGNI4
line 2611
;2611:			memcpy(&bestgoal, &goal, sizeof(bot_goal_t));
ADDRLP4 68
ARGP4
ADDRLP4 8
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 2612
;2612:		}
LABELV $687
line 2613
;2613:	}
LABELV $683
line 2607
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 8
ARGP4
ADDRLP4 164
ADDRGP4 trap_BotGetNextCampSpotGoal
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 164
INDIRI4
ASGNI4
LABELV $685
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $682
line 2614
;2614:	if (besttraveltime > 150) return qfalse;
ADDRLP4 64
INDIRI4
CNSTI4 150
LEI4 $689
CNSTI4 0
RETI4
ADDRGP4 $659
JUMPV
LABELV $689
line 2616
;2615:	//ok found a camp spot, go camp there
;2616:	BotGoCamp(bs, &bestgoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
ADDRGP4 BotGoCamp
CALLV
pop
line 2617
;2617:	bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 2619
;2618:	//
;2619:	return qtrue;
CNSTI4 1
RETI4
LABELV $659
endproc BotWantsToCamp 176 16
export BotDontAvoid
proc BotDontAvoid 68 12
line 2627
;2620:}
;2621:
;2622:/*
;2623:==================
;2624:BotDontAvoid
;2625:==================
;2626:*/
;2627:void BotDontAvoid(bot_state_t *bs, char *itemname) {
line 2631
;2628:	bot_goal_t goal;
;2629:	int num;
;2630:
;2631:	num = trap_BotGetLevelItemGoal(-1, itemname, &goal);
CNSTI4 -1
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 60
ADDRGP4 trap_BotGetLevelItemGoal
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 60
INDIRI4
ASGNI4
ADDRGP4 $693
JUMPV
LABELV $692
line 2632
;2632:	while(num >= 0) {
line 2633
;2633:		trap_BotRemoveFromAvoidGoals(bs->gs, goal.number);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 4+44
INDIRI4
ARGI4
ADDRGP4 trap_BotRemoveFromAvoidGoals
CALLV
pop
line 2634
;2634:		num = trap_BotGetLevelItemGoal(num, itemname, &goal);
ADDRLP4 0
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 64
ADDRGP4 trap_BotGetLevelItemGoal
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 64
INDIRI4
ASGNI4
line 2635
;2635:	}
LABELV $693
line 2632
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $692
line 2636
;2636:}
LABELV $691
endproc BotDontAvoid 68 12
export BotGoForPowerups
proc BotGoForPowerups 0 8
line 2643
;2637:
;2638:/*
;2639:==================
;2640:BotGoForPowerups
;2641:==================
;2642:*/
;2643:void BotGoForPowerups(bot_state_t *bs) {
line 2646
;2644:
;2645:	//don't avoid any of the powerups anymore
;2646:	BotDontAvoid(bs, "Quad Damage");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $697
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2647
;2647:	BotDontAvoid(bs, "Regeneration");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $698
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2648
;2648:	BotDontAvoid(bs, "Battle Suit");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $699
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2649
;2649:	BotDontAvoid(bs, "Speed");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $700
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2650
;2650:	BotDontAvoid(bs, "Invisibility");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $701
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2654
;2651:	//BotDontAvoid(bs, "Flight");
;2652:	//reset the long term goal time so the bot will go for the powerup
;2653:	//NOTE: the long term goal type doesn't change
;2654:	bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2655
;2655:}
LABELV $696
endproc BotGoForPowerups 0 8
export BotRoamGoal
proc BotRoamGoal 180 28
line 2662
;2656:
;2657:/*
;2658:==================
;2659:BotRoamGoal
;2660:==================
;2661:*/
;2662:void BotRoamGoal(bot_state_t *bs, vec3_t goal) {
line 2668
;2663:	int pc, i;
;2664:	float len, rnd;
;2665:	vec3_t dir, bestorg, belowbestorg;
;2666:	bsp_trace_t trace;
;2667:
;2668:	for (i = 0; i < 10; i++) {
ADDRLP4 116
CNSTI4 0
ASGNI4
LABELV $703
line 2670
;2669:		//start at the bot origin
;2670:		VectorCopy(bs->origin, bestorg);
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 2671
;2671:		rnd = random();
ADDRLP4 136
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 112
ADDRLP4 136
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ASGNF4
line 2672
;2672:		if (rnd > 0.25) {
ADDRLP4 112
INDIRF4
CNSTF4 1048576000
LEF4 $707
line 2674
;2673:			//add a random value to the x-coordinate
;2674:			if (random() < 0.5) bestorg[0] -= 800 * random() + 100;
ADDRLP4 140
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
GEF4 $709
ADDRLP4 144
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 12
INDIRF4
CNSTF4 1145569280
ADDRLP4 144
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
CNSTF4 1120403456
ADDF4
SUBF4
ASGNF4
ADDRGP4 $710
JUMPV
LABELV $709
line 2675
;2675:			else bestorg[0] += 800 * random() + 100;
ADDRLP4 148
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 12
INDIRF4
CNSTF4 1145569280
ADDRLP4 148
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
CNSTF4 1120403456
ADDF4
ADDF4
ASGNF4
LABELV $710
line 2676
;2676:		}
LABELV $707
line 2677
;2677:		if (rnd < 0.75) {
ADDRLP4 112
INDIRF4
CNSTF4 1061158912
GEF4 $711
line 2679
;2678:			//add a random value to the y-coordinate
;2679:			if (random() < 0.5) bestorg[1] -= 800 * random() + 100;
ADDRLP4 140
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
GEF4 $713
ADDRLP4 144
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
CNSTF4 1145569280
ADDRLP4 144
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
CNSTF4 1120403456
ADDF4
SUBF4
ASGNF4
ADDRGP4 $714
JUMPV
LABELV $713
line 2680
;2680:			else bestorg[1] += 800 * random() + 100;
ADDRLP4 148
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
CNSTF4 1145569280
ADDRLP4 148
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
CNSTF4 1120403456
ADDF4
ADDF4
ASGNF4
LABELV $714
line 2681
;2681:		}
LABELV $711
line 2683
;2682:		//add a random value to the z-coordinate (NOTE: 48 = maxjump?)
;2683:		bestorg[2] += 2 * 48 * crandom();
ADDRLP4 140
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
CNSTF4 1119879168
CNSTF4 1073741824
ADDRLP4 140
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
line 2685
;2684:		//trace a line from the origin to the roam target
;2685:		BotAI_Trace(&trace, bs->origin, NULL, NULL, bestorg, bs->entitynum, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRLP4 144
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 144
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 148
CNSTP4 0
ASGNP4
ADDRLP4 148
INDIRP4
ARGP4
ADDRLP4 148
INDIRP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 144
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 2687
;2686:		//direction and length towards the roam target
;2687:		VectorSubtract(trace.endpos, bs->origin, dir);
ADDRLP4 152
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 24+12
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 24+12+4
INDIRF4
ADDRLP4 152
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 24+12+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2688
;2688:		len = VectorNormalize(dir);
ADDRLP4 0
ARGP4
ADDRLP4 156
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 108
ADDRLP4 156
INDIRF4
ASGNF4
line 2690
;2689:		//if the roam target is far away anough
;2690:		if (len > 200) {
ADDRLP4 108
INDIRF4
CNSTF4 1128792064
LEF4 $725
line 2692
;2691:			//the roam target is in the given direction before walls
;2692:			VectorScale(dir, len * trace.fraction - 40, dir);
ADDRLP4 164
CNSTF4 1109393408
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 108
INDIRF4
ADDRLP4 24+8
INDIRF4
MULF4
ADDRLP4 164
INDIRF4
SUBF4
MULF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 108
INDIRF4
ADDRLP4 24+8
INDIRF4
MULF4
ADDRLP4 164
INDIRF4
SUBF4
MULF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 108
INDIRF4
ADDRLP4 24+8
INDIRF4
MULF4
CNSTF4 1109393408
SUBF4
MULF4
ASGNF4
line 2693
;2693:			VectorAdd(bs->origin, dir, bestorg);
ADDRLP4 168
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
ADDRLP4 168
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 168
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ADDRLP4 0+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 12+8
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 0+8
INDIRF4
ADDF4
ASGNF4
line 2695
;2694:			//get the coordinates of the floor below the roam target
;2695:			belowbestorg[0] = bestorg[0];
ADDRLP4 120
ADDRLP4 12
INDIRF4
ASGNF4
line 2696
;2696:			belowbestorg[1] = bestorg[1];
ADDRLP4 120+4
ADDRLP4 12+4
INDIRF4
ASGNF4
line 2697
;2697:			belowbestorg[2] = bestorg[2] - 800;
ADDRLP4 120+8
ADDRLP4 12+8
INDIRF4
CNSTF4 1145569280
SUBF4
ASGNF4
line 2698
;2698:			BotAI_Trace(&trace, bestorg, NULL, NULL, belowbestorg, bs->entitynum, MASK_SOLID);
ADDRLP4 24
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 172
CNSTP4 0
ASGNP4
ADDRLP4 172
INDIRP4
ARGP4
ADDRLP4 172
INDIRP4
ARGP4
ADDRLP4 120
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 2700
;2699:			//
;2700:			if (!trace.startsolid) {
ADDRLP4 24+4
INDIRI4
CNSTI4 0
NEI4 $742
line 2701
;2701:				trace.endpos[2]++;
ADDRLP4 24+12+8
ADDRLP4 24+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2702
;2702:				pc = trap_PointContents(trace.endpos, bs->entitynum);
ADDRLP4 24+12
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 176
ADDRGP4 trap_PointContents
CALLI4
ASGNI4
ADDRLP4 132
ADDRLP4 176
INDIRI4
ASGNI4
line 2703
;2703:				if (!(pc & (CONTENTS_LAVA | CONTENTS_SLIME))) {
ADDRLP4 132
INDIRI4
CNSTI4 24
BANDI4
CNSTI4 0
NEI4 $748
line 2704
;2704:					VectorCopy(bestorg, goal);
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRB
ASGNB 12
line 2705
;2705:					return;
ADDRGP4 $702
JUMPV
LABELV $748
line 2707
;2706:				}
;2707:			}
LABELV $742
line 2708
;2708:		}
LABELV $725
line 2709
;2709:	}
LABELV $704
line 2668
ADDRLP4 116
ADDRLP4 116
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 116
INDIRI4
CNSTI4 10
LTI4 $703
line 2710
;2710:	VectorCopy(bestorg, goal);
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRB
ASGNB 12
line 2711
;2711:}
LABELV $702
endproc BotRoamGoal 180 28
lit
align 4
LABELV $752
byte 4 0
byte 4 0
byte 4 1065353216
export BotAttackMove
code
proc BotAttackMove 392 16
line 2718
;2712:
;2713:/*
;2714:==================
;2715:BotAttackMove
;2716:==================
;2717:*/
;2718:bot_moveresult_t BotAttackMove(bot_state_t *bs, int tfl) {
line 2722
;2719:	int movetype, i, attackentity;
;2720:	float attack_skill, jumper, croucher, dist, strafechange_time;
;2721:	float attack_dist, attack_range;
;2722:	vec3_t forward, backward, sideward, hordir, up = {0, 0, 1};
ADDRLP4 56
ADDRGP4 $752
INDIRB
ASGNB 12
line 2727
;2723:	aas_entityinfo_t entinfo;
;2724:	bot_moveresult_t moveresult;
;2725:	bot_goal_t goal;
;2726:
;2727:	attackentity = bs->enemy;
ADDRLP4 332
ADDRFP4 4
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 2729
;2728:	//
;2729:	if (bs->attackchase_time > FloatTime()) {
ADDRFP4 4
INDIRP4
CNSTI4 6124
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $753
line 2731
;2730:		//create the chase goal
;2731:		goal.entitynum = attackentity;
ADDRLP4 136+40
ADDRLP4 332
INDIRI4
ASGNI4
line 2732
;2732:		goal.areanum = bs->lastenemyareanum;
ADDRLP4 136+12
ADDRFP4 4
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
ASGNI4
line 2733
;2733:		VectorCopy(bs->lastenemyorigin, goal.origin);
ADDRLP4 136
ADDRFP4 4
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 2734
;2734:		VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 136+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 136+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 136+16+8
CNSTF4 3238002688
ASGNF4
line 2735
;2735:		VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 136+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 136+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 136+28+8
CNSTF4 1090519040
ASGNF4
line 2737
;2736:		//initialize the movement state
;2737:		BotSetupForMovement(bs);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2739
;2738:		//move towards the goal
;2739:		trap_BotMoveToGoal(&moveresult, bs->ms, &goal, tfl);
ADDRLP4 80
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 136
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 2740
;2740:		return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $750
JUMPV
LABELV $753
line 2743
;2741:	}
;2742:	//
;2743:	memset(&moveresult, 0, sizeof(bot_moveresult_t));
ADDRLP4 80
ARGP4
CNSTI4 0
ARGI4
CNSTI4 52
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2745
;2744:	//
;2745:	attack_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ATTACK_SKILL, 0, 1);
ADDRFP4 4
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 348
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 132
ADDRLP4 348
INDIRF4
ASGNF4
line 2746
;2746:	jumper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_JUMPER, 0, 1);
ADDRFP4 4
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 37
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 352
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 340
ADDRLP4 352
INDIRF4
ASGNF4
line 2747
;2747:	croucher = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CROUCHER, 0, 1);
ADDRFP4 4
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 36
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 356
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 344
ADDRLP4 356
INDIRF4
ASGNF4
line 2749
;2748:	//if the bot is really stupid
;2749:	if (attack_skill < 0.2) return moveresult;
ADDRLP4 132
INDIRF4
CNSTF4 1045220557
GEF4 $767
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $750
JUMPV
LABELV $767
line 2751
;2750:	//initialize the movement state
;2751:	BotSetupForMovement(bs);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2753
;2752:	//get the enemy entity info
;2753:	BotEntityInfo(attackentity, &entinfo);
ADDRLP4 332
INDIRI4
ARGI4
ADDRLP4 192
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2755
;2754:	//direction towards the enemy
;2755:	VectorSubtract(entinfo.origin, bs->origin, forward);
ADDRLP4 360
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
ADDRLP4 192+24
INDIRF4
ADDRLP4 360
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 24+4
ADDRLP4 192+24+4
INDIRF4
ADDRLP4 360
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 24+8
ADDRLP4 192+24+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2757
;2756:	//the distance towards the enemy
;2757:	dist = VectorNormalize(forward);
ADDRLP4 24
ARGP4
ADDRLP4 364
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 68
ADDRLP4 364
INDIRF4
ASGNF4
line 2758
;2758:	VectorNegate(forward, backward);
ADDRLP4 36
ADDRLP4 24
INDIRF4
NEGF4
ASGNF4
ADDRLP4 36+4
ADDRLP4 24+4
INDIRF4
NEGF4
ASGNF4
ADDRLP4 36+8
ADDRLP4 24+8
INDIRF4
NEGF4
ASGNF4
line 2760
;2759:	//walk, crouch or jump
;2760:	movetype = MOVE_WALK;
ADDRLP4 52
CNSTI4 1
ASGNI4
line 2762
;2761:	//
;2762:	if (bs->attackcrouch_time < FloatTime() - 1) {
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $780
line 2763
;2763:		if (random() < jumper) {
ADDRLP4 368
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 340
INDIRF4
GEF4 $782
line 2764
;2764:			movetype = MOVE_JUMP;
ADDRLP4 52
CNSTI4 4
ASGNI4
line 2765
;2765:		}
ADDRGP4 $783
JUMPV
LABELV $782
line 2767
;2766:		//wait at least one second before crouching again
;2767:		else if (bs->attackcrouch_time < FloatTime() - 1 && random() < croucher) {
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $784
ADDRLP4 372
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 372
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 344
INDIRF4
GEF4 $784
line 2768
;2768:			bs->attackcrouch_time = FloatTime() + croucher * 5;
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDRLP4 344
INDIRF4
MULF4
ADDF4
ASGNF4
line 2769
;2769:		}
LABELV $784
LABELV $783
line 2770
;2770:	}
LABELV $780
line 2771
;2771:	if (bs->attackcrouch_time > FloatTime()) movetype = MOVE_CROUCH;
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $786
ADDRLP4 52
CNSTI4 2
ASGNI4
LABELV $786
line 2773
;2772:	//if the bot should jump
;2773:	if (movetype == MOVE_JUMP) {
ADDRLP4 52
INDIRI4
CNSTI4 4
NEI4 $788
line 2775
;2774:		//if jumped last frame
;2775:		if (bs->attackjump_time > FloatTime()) {
ADDRFP4 4
INDIRP4
CNSTI4 6128
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $790
line 2776
;2776:			movetype = MOVE_WALK;
ADDRLP4 52
CNSTI4 1
ASGNI4
line 2777
;2777:		}
ADDRGP4 $791
JUMPV
LABELV $790
line 2778
;2778:		else {
line 2779
;2779:			bs->attackjump_time = FloatTime() + 1;
ADDRFP4 4
INDIRP4
CNSTI4 6128
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2780
;2780:		}
LABELV $791
line 2781
;2781:	}
LABELV $788
line 2782
;2782:	if (bs->cur_ps.weapon == WP_GAUNTLET) {
ADDRFP4 4
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $792
line 2783
;2783:		attack_dist = 0;
ADDRLP4 72
CNSTF4 0
ASGNF4
line 2784
;2784:		attack_range = 0;
ADDRLP4 76
CNSTF4 0
ASGNF4
line 2785
;2785:	}
ADDRGP4 $793
JUMPV
LABELV $792
line 2786
;2786:	else {
line 2787
;2787:		attack_dist = IDEAL_ATTACKDIST;
ADDRLP4 72
CNSTF4 1124859904
ASGNF4
line 2788
;2788:		attack_range = 40;
ADDRLP4 76
CNSTF4 1109393408
ASGNF4
line 2789
;2789:	}
LABELV $793
line 2791
;2790:	//if the bot is stupid
;2791:	if (attack_skill <= 0.4) {
ADDRLP4 132
INDIRF4
CNSTF4 1053609165
GTF4 $794
line 2793
;2792:		//just walk to or away from the enemy
;2793:		if (dist > attack_dist + attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
ADDF4
LEF4 $796
line 2794
;2794:			if (trap_BotMoveInDirection(bs->ms, forward, 400, movetype)) return moveresult;
ADDRFP4 4
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 368
ADDRGP4 trap_BotMoveInDirection
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 0
EQI4 $798
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $750
JUMPV
LABELV $798
line 2795
;2795:		}
LABELV $796
line 2796
;2796:		if (dist < attack_dist - attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
GEF4 $800
line 2797
;2797:			if (trap_BotMoveInDirection(bs->ms, backward, 400, movetype)) return moveresult;
ADDRFP4 4
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 36
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 368
ADDRGP4 trap_BotMoveInDirection
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 0
EQI4 $802
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $750
JUMPV
LABELV $802
line 2798
;2798:		}
LABELV $800
line 2799
;2799:		return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $750
JUMPV
LABELV $794
line 2802
;2800:	}
;2801:	//increase the strafe time
;2802:	bs->attackstrafe_time += bs->thinktime;
ADDRLP4 368
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 372
ADDRLP4 368
INDIRP4
CNSTI4 6116
ADDP4
ASGNP4
ADDRLP4 372
INDIRP4
ADDRLP4 372
INDIRP4
INDIRF4
ADDRLP4 368
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
ADDF4
ASGNF4
line 2804
;2803:	//get the strafe change time
;2804:	strafechange_time = 0.4 + (1 - attack_skill) * 0.2;
ADDRLP4 336
CNSTF4 1045220557
CNSTF4 1065353216
ADDRLP4 132
INDIRF4
SUBF4
MULF4
CNSTF4 1053609165
ADDF4
ASGNF4
line 2805
;2805:	if (attack_skill > 0.7) strafechange_time += crandom() * 0.2;
ADDRLP4 132
INDIRF4
CNSTF4 1060320051
LEF4 $804
ADDRLP4 376
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 336
ADDRLP4 336
INDIRF4
CNSTF4 1045220557
CNSTF4 1073741824
ADDRLP4 376
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
ASGNF4
LABELV $804
line 2807
;2806:	//if the strafe direction should be changed
;2807:	if (bs->attackstrafe_time > strafechange_time) {
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
INDIRF4
ADDRLP4 336
INDIRF4
LEF4 $806
line 2809
;2808:		//some magic number :)
;2809:		if (random() > 0.935) {
ADDRLP4 380
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 380
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1064262697
LEF4 $808
line 2811
;2810:			//flip the strafe direction
;2811:			bs->flags ^= BFL_STRAFERIGHT;
ADDRLP4 384
ADDRFP4 4
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 384
INDIRP4
ADDRLP4 384
INDIRP4
INDIRI4
CNSTI4 1
BXORI4
ASGNI4
line 2812
;2812:			bs->attackstrafe_time = 0;
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
CNSTF4 0
ASGNF4
line 2813
;2813:		}
LABELV $808
line 2814
;2814:	}
LABELV $806
line 2816
;2815:	//
;2816:	for (i = 0; i < 2; i++) {
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $810
line 2817
;2817:		hordir[0] = forward[0];
ADDRLP4 12
ADDRLP4 24
INDIRF4
ASGNF4
line 2818
;2818:		hordir[1] = forward[1];
ADDRLP4 12+4
ADDRLP4 24+4
INDIRF4
ASGNF4
line 2819
;2819:		hordir[2] = 0;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 2820
;2820:		VectorNormalize(hordir);
ADDRLP4 12
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2822
;2821:		//get the sideward vector
;2822:		CrossProduct(hordir, up, sideward);
ADDRLP4 12
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 2824
;2823:		//reverse the vector depending on the strafe direction
;2824:		if (bs->flags & BFL_STRAFERIGHT) VectorNegate(sideward, sideward);
ADDRFP4 4
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $817
ADDRLP4 0
ADDRLP4 0
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
NEGF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
NEGF4
ASGNF4
LABELV $817
line 2826
;2825:		//randomly go back a little
;2826:		if (random() > 0.9) {
ADDRLP4 380
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 380
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1063675494
LEF4 $823
line 2827
;2827:			VectorAdd(sideward, backward, sideward);
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 36
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 36+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 36+8
INDIRF4
ADDF4
ASGNF4
line 2828
;2828:		}
ADDRGP4 $824
JUMPV
LABELV $823
line 2829
;2829:		else {
line 2831
;2830:			//walk forward or backward to get at the ideal attack distance
;2831:			if (dist > attack_dist + attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
ADDF4
LEF4 $831
line 2832
;2832:				VectorAdd(sideward, forward, sideward);
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 24
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 24+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 24+8
INDIRF4
ADDF4
ASGNF4
line 2833
;2833:			}
ADDRGP4 $832
JUMPV
LABELV $831
line 2834
;2834:			else if (dist < attack_dist - attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
GEF4 $839
line 2835
;2835:				VectorAdd(sideward, backward, sideward);
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 36
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 36+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 36+8
INDIRF4
ADDF4
ASGNF4
line 2836
;2836:			}
LABELV $839
LABELV $832
line 2837
;2837:		}
LABELV $824
line 2839
;2838:		//perform the movement
;2839:		if (trap_BotMoveInDirection(bs->ms, sideward, 400, movetype))
ADDRFP4 4
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 52
INDIRI4
ARGI4
ADDRLP4 384
ADDRGP4 trap_BotMoveInDirection
CALLI4
ASGNI4
ADDRLP4 384
INDIRI4
CNSTI4 0
EQI4 $847
line 2840
;2840:			return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $750
JUMPV
LABELV $847
line 2842
;2841:		//movement failed, flip the strafe direction
;2842:		bs->flags ^= BFL_STRAFERIGHT;
ADDRLP4 388
ADDRFP4 4
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 388
INDIRP4
ADDRLP4 388
INDIRP4
INDIRI4
CNSTI4 1
BXORI4
ASGNI4
line 2843
;2843:		bs->attackstrafe_time = 0;
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
CNSTF4 0
ASGNF4
line 2844
;2844:	}
LABELV $811
line 2816
ADDRLP4 48
ADDRLP4 48
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 2
LTI4 $810
line 2847
;2845:	//bot couldn't do any usefull movement
;2846://	bs->attackchase_time = AAS_Time() + 6;
;2847:	return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
LABELV $750
endproc BotAttackMove 392 16
export BotSameTeam
proc BotSameTeam 2072 12
line 2855
;2848:}
;2849:
;2850:/*
;2851:==================
;2852:BotSameTeam
;2853:==================
;2854:*/
;2855:int BotSameTeam(bot_state_t *bs, int entnum) {
line 2858
;2856:	char info1[1024], info2[1024];
;2857:
;2858:	if (bs->client < 0 || bs->client >= MAX_CLIENTS) {
ADDRLP4 2048
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 2048
INDIRI4
CNSTI4 0
LTI4 $852
ADDRLP4 2048
INDIRI4
CNSTI4 64
LTI4 $850
LABELV $852
line 2860
;2859:		//BotAI_Print(PRT_ERROR, "BotSameTeam: client out of range\n");
;2860:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $849
JUMPV
LABELV $850
line 2862
;2861:	}
;2862:	if (entnum < 0 || entnum >= MAX_CLIENTS) {
ADDRLP4 2052
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 2052
INDIRI4
CNSTI4 0
LTI4 $855
ADDRLP4 2052
INDIRI4
CNSTI4 64
LTI4 $853
LABELV $855
line 2864
;2863:		//BotAI_Print(PRT_ERROR, "BotSameTeam: client out of range\n");
;2864:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $849
JUMPV
LABELV $853
line 2866
;2865:	}
;2866:	if ( gametype >= GT_TEAM ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 3
LTI4 $856
line 2867
;2867:		trap_GetConfigstring(CS_PLAYERS+bs->client, info1, sizeof(info1));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 2868
;2868:		trap_GetConfigstring(CS_PLAYERS+entnum, info2, sizeof(info2));
ADDRFP4 4
INDIRI4
CNSTI4 544
ADDI4
ARGI4
ADDRLP4 1024
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 2870
;2869:		//
;2870:		if (atoi(Info_ValueForKey(info1, "t")) == atoi(Info_ValueForKey(info2, "t"))) return qtrue;
ADDRLP4 0
ARGP4
ADDRGP4 $71
ARGP4
ADDRLP4 2056
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 2056
INDIRP4
ARGP4
ADDRLP4 2060
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 1024
ARGP4
ADDRGP4 $71
ARGP4
ADDRLP4 2064
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 2064
INDIRP4
ARGP4
ADDRLP4 2068
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 2060
INDIRI4
ADDRLP4 2068
INDIRI4
NEI4 $858
CNSTI4 1
RETI4
ADDRGP4 $849
JUMPV
LABELV $858
line 2871
;2871:	}
LABELV $856
line 2872
;2872:	return qfalse;
CNSTI4 0
RETI4
LABELV $849
endproc BotSameTeam 2072 12
export InFieldOfVision
proc InFieldOfVision 24 4
line 2881
;2873:}
;2874:
;2875:/*
;2876:==================
;2877:InFieldOfVision
;2878:==================
;2879:*/
;2880:qboolean InFieldOfVision(vec3_t viewangles, float fov, vec3_t angles)
;2881:{
line 2885
;2882:	int i;
;2883:	float diff, angle;
;2884:
;2885:	for (i = 0; i < 2; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $861
line 2886
;2886:		angle = AngleMod(viewangles[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 8
ADDRLP4 12
INDIRF4
ASGNF4
line 2887
;2887:		angles[i] = AngleMod(angles[i]);
ADDRLP4 16
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 8
INDIRP4
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
INDIRF4
ARGF4
ADDRLP4 20
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 16
INDIRP4
ADDRLP4 20
INDIRF4
ASGNF4
line 2888
;2888:		diff = angles[i] - angle;
ADDRLP4 4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 8
INDIRP4
ADDP4
INDIRF4
ADDRLP4 8
INDIRF4
SUBF4
ASGNF4
line 2889
;2889:		if (angles[i] > angle) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 8
INDIRP4
ADDP4
INDIRF4
ADDRLP4 8
INDIRF4
LEF4 $865
line 2890
;2890:			if (diff > 180.0) diff -= 360.0;
ADDRLP4 4
INDIRF4
CNSTF4 1127481344
LEF4 $866
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1135869952
SUBF4
ASGNF4
line 2891
;2891:		}
ADDRGP4 $866
JUMPV
LABELV $865
line 2892
;2892:		else {
line 2893
;2893:			if (diff < -180.0) diff += 360.0;
ADDRLP4 4
INDIRF4
CNSTF4 3274964992
GEF4 $869
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1135869952
ADDF4
ASGNF4
LABELV $869
line 2894
;2894:		}
LABELV $866
line 2895
;2895:		if (diff > 0) {
ADDRLP4 4
INDIRF4
CNSTF4 0
LEF4 $871
line 2896
;2896:			if (diff > fov * 0.5) return qfalse;
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
MULF4
LEF4 $872
CNSTI4 0
RETI4
ADDRGP4 $860
JUMPV
line 2897
;2897:		}
LABELV $871
line 2898
;2898:		else {
line 2899
;2899:			if (diff < -fov * 0.5) return qfalse;
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
NEGF4
MULF4
GEF4 $875
CNSTI4 0
RETI4
ADDRGP4 $860
JUMPV
LABELV $875
line 2900
;2900:		}
LABELV $872
line 2901
;2901:	}
LABELV $862
line 2885
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LTI4 $861
line 2902
;2902:	return qtrue;
CNSTI4 1
RETI4
LABELV $860
endproc InFieldOfVision 24 4
export BotEntityVisible
proc BotEntityVisible 376 28
line 2912
;2903:}
;2904:
;2905:/*
;2906:==================
;2907:BotEntityVisible
;2908:
;2909:returns visibility in the range [0, 1] taking fog and water surfaces into account
;2910:==================
;2911:*/
;2912:float BotEntityVisible(int viewer, vec3_t eye, vec3_t viewangles, float fov, int ent) {
line 2920
;2913:	int i, contents_mask, passent, hitent, infog, inwater, otherinfog, pc;
;2914:	float squaredfogdist, waterfactor, vis, bestvis;
;2915:	bsp_trace_t trace;
;2916:	aas_entityinfo_t entinfo;
;2917:	vec3_t dir, entangles, start, end, middle;
;2918:
;2919:	//calculate middle of bounding box
;2920:	BotEntityInfo(ent, &entinfo);
ADDRFP4 16
INDIRI4
ARGI4
ADDRLP4 148
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2921
;2921:	VectorAdd(entinfo.mins, entinfo.maxs, middle);
ADDRLP4 84
ADDRLP4 148+72
INDIRF4
ADDRLP4 148+84
INDIRF4
ADDF4
ASGNF4
ADDRLP4 84+4
ADDRLP4 148+72+4
INDIRF4
ADDRLP4 148+84+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 84+8
ADDRLP4 148+72+8
INDIRF4
ADDRLP4 148+84+8
INDIRF4
ADDF4
ASGNF4
line 2922
;2922:	VectorScale(middle, 0.5, middle);
ADDRLP4 332
CNSTF4 1056964608
ASGNF4
ADDRLP4 84
ADDRLP4 332
INDIRF4
ADDRLP4 84
INDIRF4
MULF4
ASGNF4
ADDRLP4 84+4
ADDRLP4 332
INDIRF4
ADDRLP4 84+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 84+8
CNSTF4 1056964608
ADDRLP4 84+8
INDIRF4
MULF4
ASGNF4
line 2923
;2923:	VectorAdd(entinfo.origin, middle, middle);
ADDRLP4 84
ADDRLP4 148+24
INDIRF4
ADDRLP4 84
INDIRF4
ADDF4
ASGNF4
ADDRLP4 84+4
ADDRLP4 148+24+4
INDIRF4
ADDRLP4 84+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 84+8
ADDRLP4 148+24+8
INDIRF4
ADDRLP4 84+8
INDIRF4
ADDF4
ASGNF4
line 2925
;2924:	//check if entity is within field of vision
;2925:	VectorSubtract(middle, eye, dir);
ADDRLP4 336
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 136
ADDRLP4 84
INDIRF4
ADDRLP4 336
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+4
ADDRLP4 84+4
INDIRF4
ADDRLP4 336
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+8
ADDRLP4 84+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2926
;2926:	vectoangles(dir, entangles);
ADDRLP4 136
ARGP4
ADDRLP4 320
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2927
;2927:	if (!InFieldOfVision(viewangles, fov, entangles)) return 0;
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 320
ARGP4
ADDRLP4 340
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 340
INDIRI4
CNSTI4 0
NEI4 $907
CNSTF4 0
RETF4
ADDRGP4 $877
JUMPV
LABELV $907
line 2929
;2928:	//
;2929:	pc = trap_AAS_PointContents(eye);
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 344
ADDRGP4 trap_AAS_PointContents
CALLI4
ASGNI4
ADDRLP4 316
ADDRLP4 344
INDIRI4
ASGNI4
line 2930
;2930:	infog = (pc & CONTENTS_FOG);
ADDRLP4 312
ADDRLP4 316
INDIRI4
CNSTI4 64
BANDI4
ASGNI4
line 2931
;2931:	inwater = (pc & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER));
ADDRLP4 308
ADDRLP4 316
INDIRI4
CNSTI4 56
BANDI4
ASGNI4
line 2933
;2932:	//
;2933:	bestvis = 0;
ADDRLP4 296
CNSTF4 0
ASGNF4
line 2934
;2934:	for (i = 0; i < 3; i++) {
ADDRLP4 100
CNSTI4 0
ASGNI4
LABELV $909
line 2938
;2935:		//if the point is not in potential visible sight
;2936:		//if (!AAS_inPVS(eye, middle)) continue;
;2937:		//
;2938:		contents_mask = CONTENTS_SOLID|CONTENTS_PLAYERCLIP;
ADDRLP4 96
CNSTI4 65537
ASGNI4
line 2939
;2939:		passent = viewer;
ADDRLP4 116
ADDRFP4 0
INDIRI4
ASGNI4
line 2940
;2940:		hitent = ent;
ADDRLP4 132
ADDRFP4 16
INDIRI4
ASGNI4
line 2941
;2941:		VectorCopy(eye, start);
ADDRLP4 120
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2942
;2942:		VectorCopy(middle, end);
ADDRLP4 104
ADDRLP4 84
INDIRB
ASGNB 12
line 2944
;2943:		//if the entity is in water, lava or slime
;2944:		if (trap_AAS_PointContents(middle) & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER)) {
ADDRLP4 84
ARGP4
ADDRLP4 348
ADDRGP4 trap_AAS_PointContents
CALLI4
ASGNI4
ADDRLP4 348
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $913
line 2945
;2945:			contents_mask |= (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 56
BORI4
ASGNI4
line 2946
;2946:		}
LABELV $913
line 2948
;2947:		//if eye is in water, lava or slime
;2948:		if (inwater) {
ADDRLP4 308
INDIRI4
CNSTI4 0
EQI4 $915
line 2949
;2949:			if (!(contents_mask & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER))) {
ADDRLP4 96
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
NEI4 $917
line 2950
;2950:				passent = ent;
ADDRLP4 116
ADDRFP4 16
INDIRI4
ASGNI4
line 2951
;2951:				hitent = viewer;
ADDRLP4 132
ADDRFP4 0
INDIRI4
ASGNI4
line 2952
;2952:				VectorCopy(middle, start);
ADDRLP4 120
ADDRLP4 84
INDIRB
ASGNB 12
line 2953
;2953:				VectorCopy(eye, end);
ADDRLP4 104
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2954
;2954:			}
LABELV $917
line 2955
;2955:			contents_mask ^= (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 56
BXORI4
ASGNI4
line 2956
;2956:		}
LABELV $915
line 2958
;2957:		//trace from start to end
;2958:		BotAI_Trace(&trace, start, NULL, NULL, end, passent, contents_mask);
ADDRLP4 0
ARGP4
ADDRLP4 120
ARGP4
ADDRLP4 352
CNSTP4 0
ASGNP4
ADDRLP4 352
INDIRP4
ARGP4
ADDRLP4 352
INDIRP4
ARGP4
ADDRLP4 104
ARGP4
ADDRLP4 116
INDIRI4
ARGI4
ADDRLP4 96
INDIRI4
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 2960
;2959:		//if water was hit
;2960:		waterfactor = 1.0;
ADDRLP4 288
CNSTF4 1065353216
ASGNF4
line 2961
;2961:		if (trace.contents & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER)) {
ADDRLP4 0+76
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $919
line 2963
;2962:			//if the water surface is translucent
;2963:			if (1) {
line 2965
;2964:				//trace through the water
;2965:				contents_mask &= ~(CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 -57
BANDI4
ASGNI4
line 2966
;2966:				BotAI_Trace(&trace, trace.endpos, NULL, NULL, end, passent, contents_mask);
ADDRLP4 0
ARGP4
ADDRLP4 0+12
ARGP4
ADDRLP4 356
CNSTP4 0
ASGNP4
ADDRLP4 356
INDIRP4
ARGP4
ADDRLP4 356
INDIRP4
ARGP4
ADDRLP4 104
ARGP4
ADDRLP4 116
INDIRI4
ARGI4
ADDRLP4 96
INDIRI4
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 2967
;2967:				waterfactor = 0.5;
ADDRLP4 288
CNSTF4 1056964608
ASGNF4
line 2968
;2968:			}
LABELV $922
line 2969
;2969:		}
LABELV $919
line 2971
;2970:		//if a full trace or the hitent was hit
;2971:		if (trace.fraction >= 1 || trace.ent == hitent) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $929
ADDRLP4 0+80
INDIRI4
ADDRLP4 132
INDIRI4
NEI4 $925
LABELV $929
line 2974
;2972:			//check for fog, assuming there's only one fog brush where
;2973:			//either the viewer or the entity is in or both are in
;2974:			otherinfog = (trap_AAS_PointContents(middle) & CONTENTS_FOG);
ADDRLP4 84
ARGP4
ADDRLP4 356
ADDRGP4 trap_AAS_PointContents
CALLI4
ASGNI4
ADDRLP4 304
ADDRLP4 356
INDIRI4
CNSTI4 64
BANDI4
ASGNI4
line 2975
;2975:			if (infog && otherinfog) {
ADDRLP4 360
CNSTI4 0
ASGNI4
ADDRLP4 312
INDIRI4
ADDRLP4 360
INDIRI4
EQI4 $930
ADDRLP4 304
INDIRI4
ADDRLP4 360
INDIRI4
EQI4 $930
line 2976
;2976:				VectorSubtract(trace.endpos, eye, dir);
ADDRLP4 364
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 136
ADDRLP4 0+12
INDIRF4
ADDRLP4 364
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+4
ADDRLP4 0+12+4
INDIRF4
ADDRLP4 364
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+8
ADDRLP4 0+12+8
INDIRF4
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2977
;2977:				squaredfogdist = VectorLengthSquared(dir);
ADDRLP4 136
ARGP4
ADDRLP4 368
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 300
ADDRLP4 368
INDIRF4
ASGNF4
line 2978
;2978:			}
ADDRGP4 $931
JUMPV
LABELV $930
line 2979
;2979:			else if (infog) {
ADDRLP4 312
INDIRI4
CNSTI4 0
EQI4 $939
line 2980
;2980:				VectorCopy(trace.endpos, start);
ADDRLP4 120
ADDRLP4 0+12
INDIRB
ASGNB 12
line 2981
;2981:				BotAI_Trace(&trace, start, NULL, NULL, eye, viewer, CONTENTS_FOG);
ADDRLP4 0
ARGP4
ADDRLP4 120
ARGP4
ADDRLP4 364
CNSTP4 0
ASGNP4
ADDRLP4 364
INDIRP4
ARGP4
ADDRLP4 364
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
CNSTI4 64
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 2982
;2982:				VectorSubtract(eye, trace.endpos, dir);
ADDRLP4 368
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 136
ADDRLP4 368
INDIRP4
INDIRF4
ADDRLP4 0+12
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+4
ADDRLP4 368
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 0+12+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+8
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 0+12+8
INDIRF4
SUBF4
ASGNF4
line 2983
;2983:				squaredfogdist = VectorLengthSquared(dir);
ADDRLP4 136
ARGP4
ADDRLP4 372
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 300
ADDRLP4 372
INDIRF4
ASGNF4
line 2984
;2984:			}
ADDRGP4 $940
JUMPV
LABELV $939
line 2985
;2985:			else if (otherinfog) {
ADDRLP4 304
INDIRI4
CNSTI4 0
EQI4 $949
line 2986
;2986:				VectorCopy(trace.endpos, end);
ADDRLP4 104
ADDRLP4 0+12
INDIRB
ASGNB 12
line 2987
;2987:				BotAI_Trace(&trace, eye, NULL, NULL, end, viewer, CONTENTS_FOG);
ADDRLP4 0
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 364
CNSTP4 0
ASGNP4
ADDRLP4 364
INDIRP4
ARGP4
ADDRLP4 364
INDIRP4
ARGP4
ADDRLP4 104
ARGP4
ADDRFP4 0
INDIRI4
ARGI4
CNSTI4 64
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 2988
;2988:				VectorSubtract(end, trace.endpos, dir);
ADDRLP4 136
ADDRLP4 104
INDIRF4
ADDRLP4 0+12
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+4
ADDRLP4 104+4
INDIRF4
ADDRLP4 0+12+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 136+8
ADDRLP4 104+8
INDIRF4
ADDRLP4 0+12+8
INDIRF4
SUBF4
ASGNF4
line 2989
;2989:				squaredfogdist = VectorLengthSquared(dir);
ADDRLP4 136
ARGP4
ADDRLP4 368
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 300
ADDRLP4 368
INDIRF4
ASGNF4
line 2990
;2990:			}
ADDRGP4 $950
JUMPV
LABELV $949
line 2991
;2991:			else {
line 2993
;2992:				//if the entity and the viewer are not in fog assume there's no fog in between
;2993:				squaredfogdist = 0;
ADDRLP4 300
CNSTF4 0
ASGNF4
line 2994
;2994:			}
LABELV $950
LABELV $940
LABELV $931
line 2996
;2995:			//decrease visibility with the view distance through fog
;2996:			vis = 1 / ((squaredfogdist * 0.001) < 1 ? 1 : (squaredfogdist * 0.001));
ADDRLP4 368
CNSTF4 1065353216
ASGNF4
CNSTF4 981668463
ADDRLP4 300
INDIRF4
MULF4
ADDRLP4 368
INDIRF4
GEF4 $962
ADDRLP4 364
CNSTF4 1065353216
ASGNF4
ADDRGP4 $963
JUMPV
LABELV $962
ADDRLP4 364
CNSTF4 981668463
ADDRLP4 300
INDIRF4
MULF4
ASGNF4
LABELV $963
ADDRLP4 292
ADDRLP4 368
INDIRF4
ADDRLP4 364
INDIRF4
DIVF4
ASGNF4
line 2998
;2997:			//if entering water visibility is reduced
;2998:			vis *= waterfactor;
ADDRLP4 292
ADDRLP4 292
INDIRF4
ADDRLP4 288
INDIRF4
MULF4
ASGNF4
line 3000
;2999:			//
;3000:			if (vis > bestvis) bestvis = vis;
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
LEF4 $964
ADDRLP4 296
ADDRLP4 292
INDIRF4
ASGNF4
LABELV $964
line 3002
;3001:			//if pretty much no fog
;3002:			if (bestvis >= 0.95) return bestvis;
ADDRLP4 296
INDIRF4
CNSTF4 1064514355
LTF4 $966
ADDRLP4 296
INDIRF4
RETF4
ADDRGP4 $877
JUMPV
LABELV $966
line 3003
;3003:		}
LABELV $925
line 3005
;3004:		//check bottom and top of bounding box as well
;3005:		if (i == 0) middle[2] += entinfo.mins[2];
ADDRLP4 100
INDIRI4
CNSTI4 0
NEI4 $968
ADDRLP4 84+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 148+72+8
INDIRF4
ADDF4
ASGNF4
ADDRGP4 $969
JUMPV
LABELV $968
line 3006
;3006:		else if (i == 1) middle[2] += entinfo.maxs[2] - entinfo.mins[2];
ADDRLP4 100
INDIRI4
CNSTI4 1
NEI4 $973
ADDRLP4 84+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 148+84+8
INDIRF4
ADDRLP4 148+72+8
INDIRF4
SUBF4
ADDF4
ASGNF4
LABELV $973
LABELV $969
line 3007
;3007:	}
LABELV $910
line 2934
ADDRLP4 100
ADDRLP4 100
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 100
INDIRI4
CNSTI4 3
LTI4 $909
line 3008
;3008:	return bestvis;
ADDRLP4 296
INDIRF4
RETF4
LABELV $877
endproc BotEntityVisible 376 28
proc BotFindMonsterHuntEnemy 184 20
line 3018
;3009:}
;3010:/*
;3011:=========
;3012:FOR MONSTER SEEKER
;3013:=========
;3014:*/
;3015:
;3016:
;3017:
;3018:static int BotFindMonsterHuntEnemy(bot_state_t *bs) {
line 3027
;3019:	aas_entityinfo_t entinfo;
;3020:	gentity_t *ent;
;3021:	int bestEnemy;
;3022:	int i;
;3023:	float distance;
;3024:	float bestDistance;
;3025:	float visibility;
;3026:
;3027:	bestEnemy = -1;
ADDRLP4 160
CNSTI4 -1
ASGNI4
line 3028
;3028:	bestDistance = 99999999.0f;
ADDRLP4 156
CNSTF4 1287568416
ASGNF4
line 3030
;3029:
;3030:	for (i = MAX_CLIENTS;
ADDRLP4 4
CNSTI4 64
ASGNI4
ADDRGP4 $984
JUMPV
LABELV $981
line 3032
;3031:		i < level.num_entities;
;3032:		i++) {
line 3033
;3033:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 3035
;3034:
;3035:		if (!ent->inuse) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $986
line 3036
;3036:			continue;
ADDRGP4 $982
JUMPV
LABELV $986
line 3039
;3037:		}
;3038:
;3039:		if (ent->s.eType != ET_MONSTER) {
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
EQI4 $988
line 3040
;3040:			continue;
ADDRGP4 $982
JUMPV
LABELV $988
line 3043
;3041:		}
;3042:
;3043:		if (ent->monsterDead ||
ADDRLP4 168
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 860
ADDP4
INDIRI4
ADDRLP4 168
INDIRI4
NEI4 $993
ADDRLP4 0
INDIRP4
CNSTI4 732
ADDP4
INDIRI4
ADDRLP4 168
INDIRI4
LEI4 $993
ADDRLP4 0
INDIRP4
CNSTI4 736
ADDP4
INDIRI4
ADDRLP4 168
INDIRI4
NEI4 $990
LABELV $993
line 3045
;3044:			ent->health <= 0 ||
;3045:			!ent->takedamage) {
line 3046
;3046:			continue;
ADDRGP4 $982
JUMPV
LABELV $990
line 3049
;3047:		}
;3048:
;3049:		BotEntityInfo(i, &entinfo);
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3051
;3050:
;3051:		if (!entinfo.valid) {
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $994
line 3052
;3052:			continue;
ADDRGP4 $982
JUMPV
LABELV $994
line 3055
;3053:		}
;3054:
;3055:		visibility = BotEntityVisible(
ADDRLP4 172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 172
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 172
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 172
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 176
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 152
ADDRLP4 176
INDIRF4
ASGNF4
line 3063
;3056:			bs->entitynum,
;3057:			bs->eye,
;3058:			bs->viewangles,
;3059:			360,
;3060:			i
;3061:		);
;3062:
;3063:		if (visibility <= 0) {
ADDRLP4 152
INDIRF4
CNSTF4 0
GTF4 $996
line 3064
;3064:			continue;
ADDRGP4 $982
JUMPV
LABELV $996
line 3067
;3065:		}
;3066:
;3067:		distance = DistanceSquared(
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 180
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 8
ADDRLP4 180
INDIRF4
ASGNF4
line 3072
;3068:			bs->origin,
;3069:			ent->r.currentOrigin
;3070:		);
;3071:
;3072:		if (distance < bestDistance) {
ADDRLP4 8
INDIRF4
ADDRLP4 156
INDIRF4
GEF4 $998
line 3073
;3073:			bestDistance = distance;
ADDRLP4 156
ADDRLP4 8
INDIRF4
ASGNF4
line 3074
;3074:			bestEnemy = i;
ADDRLP4 160
ADDRLP4 4
INDIRI4
ASGNI4
line 3075
;3075:		}
LABELV $998
line 3076
;3076:	}
LABELV $982
line 3032
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $984
line 3031
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $981
line 3078
;3077:
;3078:	if (bestEnemy < 0) {
ADDRLP4 160
INDIRI4
CNSTI4 0
GEI4 $1000
line 3079
;3079:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $980
JUMPV
LABELV $1000
line 3082
;3080:	}
;3081:
;3082:	bs->enemy = bestEnemy;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
ADDRLP4 160
INDIRI4
ASGNI4
line 3083
;3083:	bs->enemysight_time = FloatTime() - 1.0f;
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
ASGNF4
line 3084
;3084:	bs->enemysuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 0
ASGNI4
line 3085
;3085:	bs->enemydeath_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
CNSTF4 0
ASGNF4
line 3086
;3086:	bs->enemyvisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 3088
;3087:
;3088:	return qtrue;
CNSTI4 1
RETI4
LABELV $980
endproc BotFindMonsterHuntEnemy 184 20
export BotFindEnemy
proc BotFindEnemy 428 20
line 3096
;3089:}
;3090:
;3091:/*
;3092:==================
;3093:BotFindEnemy
;3094:==================
;3095:*/
;3096:int BotFindEnemy(bot_state_t *bs, int curenemy) {
line 3115
;3097:	int i;
;3098:	int healthdecrease;
;3099:	float f;
;3100:	float alertness;
;3101:	float easyfragger;
;3102:	float vis;
;3103:	float squaredist;
;3104:	float cursquaredist;
;3105:	aas_entityinfo_t entinfo;
;3106:	aas_entityinfo_t curenemyinfo;
;3107:	vec3_t dir;
;3108:	vec3_t angles;
;3109:
;3110:	/*
;3111:	 * Cooperative Monster Hunt uses only monster targets.
;3112:	 * Every standard game mode continues through the
;3113:	 * original player-enemy AI below.
;3114:	 */
;3115:	if (g_monsterHunt.integer) {
ADDRGP4 g_monsterHunt+12
INDIRI4
CNSTI4 0
EQI4 $1003
line 3116
;3116:		return BotFindMonsterHuntEnemy(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 336
ADDRGP4 BotFindMonsterHuntEnemy
CALLI4
ASGNI4
ADDRLP4 336
INDIRI4
RETI4
ADDRGP4 $1002
JUMPV
LABELV $1003
line 3119
;3117:	}
;3118:
;3119:	alertness = trap_Characteristic_BFloat(
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 46
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 336
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 164
ADDRLP4 336
INDIRF4
ASGNF4
line 3126
;3120:		bs->character,
;3121:		CHARACTERISTIC_ALERTNESS,
;3122:		0,
;3123:		1
;3124:	);
;3125:
;3126:	easyfragger = trap_Characteristic_BFloat(
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 45
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 340
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 176
ADDRLP4 340
INDIRF4
ASGNF4
line 3134
;3127:		bs->character,
;3128:		CHARACTERISTIC_EASY_FRAGGER,
;3129:		0,
;3130:		1
;3131:	);
;3132:
;3133:	// check if the health decreased
;3134:	healthdecrease =
ADDRLP4 348
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 348
INDIRP4
CNSTI4 5988
ADDP4
INDIRI4
ADDRLP4 348
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
LEI4 $1007
ADDRLP4 344
CNSTI4 1
ASGNI4
ADDRGP4 $1008
JUMPV
LABELV $1007
ADDRLP4 344
CNSTI4 0
ASGNI4
LABELV $1008
ADDRLP4 160
ADDRLP4 344
INDIRI4
ASGNI4
line 3139
;3135:		bs->lasthealth >
;3136:		bs->inventory[INVENTORY_HEALTH];
;3137:
;3138:	// remember the current health value
;3139:	bs->lasthealth =
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 352
INDIRP4
CNSTI4 5988
ADDP4
ADDRLP4 352
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
ASGNI4
line 3142
;3140:		bs->inventory[INVENTORY_HEALTH];
;3141:
;3142:	if (curenemy >= 0) {
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1009
line 3143
;3143:		BotEntityInfo(
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 196
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3148
;3144:			curenemy,
;3145:			&curenemyinfo
;3146:		);
;3147:
;3148:		if (EntityCarriesFlag(&curenemyinfo)) {
ADDRLP4 196
ARGP4
ADDRLP4 356
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 356
INDIRI4
CNSTI4 0
EQI4 $1011
line 3149
;3149:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1002
JUMPV
LABELV $1011
line 3152
;3150:		}
;3151:
;3152:		VectorSubtract(
ADDRLP4 360
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 144
ADDRLP4 196+24
INDIRF4
ADDRLP4 360
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+4
ADDRLP4 196+24+4
INDIRF4
ADDRLP4 360
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+8
ADDRLP4 196+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3158
;3153:			curenemyinfo.origin,
;3154:			bs->origin,
;3155:			dir
;3156:		);
;3157:
;3158:		cursquaredist =
ADDRLP4 144
ARGP4
ADDRLP4 364
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 192
ADDRLP4 364
INDIRF4
ASGNF4
line 3160
;3159:			VectorLengthSquared(dir);
;3160:	}
ADDRGP4 $1010
JUMPV
LABELV $1009
line 3161
;3161:	else {
line 3162
;3162:		cursquaredist = 0;
ADDRLP4 192
CNSTF4 0
ASGNF4
line 3163
;3163:	}
LABELV $1010
line 3212
;3164:
;3165:#ifdef MISSIONPACK
;3166:	if (gametype == GT_OBELISK) {
;3167:		vec3_t target;
;3168:		bot_goal_t *goal;
;3169:		bsp_trace_t trace;
;3170:
;3171:		if (BotTeam(bs) == TEAM_RED) {
;3172:			goal = &blueobelisk;
;3173:		}
;3174:		else {
;3175:			goal = &redobelisk;
;3176:		}
;3177:
;3178:		VectorCopy(
;3179:			goal->origin,
;3180:			target
;3181:		);
;3182:
;3183:		target[2] += 1;
;3184:
;3185:		BotAI_Trace(
;3186:			&trace,
;3187:			bs->eye,
;3188:			NULL,
;3189:			NULL,
;3190:			target,
;3191:			bs->client,
;3192:			CONTENTS_SOLID
;3193:		);
;3194:
;3195:		if (trace.fraction >= 1 ||
;3196:			trace.ent == goal->entitynum) {
;3197:			if (goal->entitynum == bs->enemy) {
;3198:				return qfalse;
;3199:			}
;3200:
;3201:			bs->enemy = goal->entitynum;
;3202:			bs->enemysight_time = FloatTime();
;3203:			bs->enemysuicide = qfalse;
;3204:			bs->enemydeath_time = 0;
;3205:			bs->enemyvisible_time = FloatTime();
;3206:
;3207:			return qtrue;
;3208:		}
;3209:	}
;3210:#endif
;3211:
;3212:	for (i = 0;
ADDRLP4 140
CNSTI4 0
ASGNI4
ADDRGP4 $1023
JUMPV
LABELV $1020
line 3214
;3213:		i < maxclients && i < MAX_CLIENTS;
;3214:		i++) {
line 3215
;3215:		if (i == bs->client) {
ADDRLP4 140
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1024
line 3216
;3216:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1024
line 3219
;3217:		}
;3218:
;3219:		if (i == curenemy) {
ADDRLP4 140
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $1026
line 3220
;3220:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1026
line 3223
;3221:		}
;3222:
;3223:		BotEntityInfo(i, &entinfo);
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3225
;3224:
;3225:		if (!entinfo.valid) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1028
line 3226
;3226:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1028
line 3229
;3227:		}
;3228:
;3229:		if (EntityIsDead(&entinfo) ||
ADDRLP4 0
ARGP4
ADDRLP4 356
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 356
INDIRI4
CNSTI4 0
NEI4 $1033
ADDRLP4 0+20
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $1030
LABELV $1033
line 3230
;3230:			entinfo.number == bs->entitynum) {
line 3231
;3231:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1030
line 3234
;3232:		}
;3233:
;3234:		if (EntityIsInvisible(&entinfo) &&
ADDRLP4 0
ARGP4
ADDRLP4 360
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 360
INDIRI4
CNSTI4 0
EQI4 $1034
ADDRLP4 0
ARGP4
ADDRLP4 364
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 364
INDIRI4
CNSTI4 0
NEI4 $1034
line 3235
;3235:			!EntityIsShooting(&entinfo)) {
line 3236
;3236:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1034
line 3239
;3237:		}
;3238:
;3239:		if (easyfragger < 0.5f &&
ADDRLP4 176
INDIRF4
CNSTF4 1056964608
GEF4 $1036
ADDRLP4 0
ARGP4
ADDRLP4 368
ADDRGP4 EntityIsChatting
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 0
EQI4 $1036
line 3240
;3240:			EntityIsChatting(&entinfo)) {
line 3241
;3241:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1036
line 3244
;3242:		}
;3243:
;3244:		if (lastteleport_time >
ADDRGP4 lastteleport_time
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1077936128
SUBF4
LEF4 $1038
line 3245
;3245:			FloatTime() - 3) {
line 3246
;3246:			VectorSubtract(
ADDRLP4 144
ADDRLP4 0+24
INDIRF4
ADDRGP4 lastteleport_origin
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+4
ADDRLP4 0+24+4
INDIRF4
ADDRGP4 lastteleport_origin+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+8
ADDRLP4 0+24+8
INDIRF4
ADDRGP4 lastteleport_origin+8
INDIRF4
SUBF4
ASGNF4
line 3252
;3247:				entinfo.origin,
;3248:				lastteleport_origin,
;3249:				dir
;3250:			);
;3251:
;3252:			if (VectorLengthSquared(dir) <
ADDRLP4 144
ARGP4
ADDRLP4 372
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 372
INDIRF4
CNSTF4 1167663104
GEF4 $1049
line 3253
;3253:				Square(70)) {
line 3254
;3254:				continue;
ADDRGP4 $1021
JUMPV
LABELV $1049
line 3256
;3255:			}
;3256:		}
LABELV $1038
line 3258
;3257:
;3258:		VectorSubtract(
ADDRLP4 372
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 144
ADDRLP4 0+24
INDIRF4
ADDRLP4 372
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 372
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+8
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3264
;3259:			entinfo.origin,
;3260:			bs->origin,
;3261:			dir
;3262:		);
;3263:
;3264:		squaredist =
ADDRLP4 144
ARGP4
ADDRLP4 376
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 376
INDIRF4
ASGNF4
line 3267
;3265:			VectorLengthSquared(dir);
;3266:
;3267:		if (!EntityCarriesFlag(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 380
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 380
INDIRI4
CNSTI4 0
NEI4 $1058
line 3268
;3268:			if (curenemy >= 0 &&
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1060
ADDRLP4 156
INDIRF4
ADDRLP4 192
INDIRF4
LEF4 $1060
line 3269
;3269:				squaredist > cursquaredist) {
line 3270
;3270:				continue;
ADDRGP4 $1021
JUMPV
LABELV $1060
line 3272
;3271:			}
;3272:		}
LABELV $1058
line 3274
;3273:
;3274:		if (squaredist >
ADDRLP4 384
CNSTF4 1165623296
ADDRLP4 164
INDIRF4
MULF4
CNSTF4 1147207680
ADDF4
ASGNF4
ADDRLP4 156
INDIRF4
ADDRLP4 384
INDIRF4
ADDRLP4 384
INDIRF4
MULF4
LEF4 $1062
line 3275
;3275:			Square(
line 3279
;3276:				900.0f +
;3277:				alertness * 4000.0f
;3278:			)) {
;3279:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1062
line 3282
;3280:		}
;3281:
;3282:		if (BotSameTeam(bs, i)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 388
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 388
INDIRI4
CNSTI4 0
EQI4 $1064
line 3283
;3283:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1064
line 3286
;3284:		}
;3285:
;3286:		if (curenemy < 0 &&
ADDRLP4 392
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 392
INDIRI4
GEI4 $1066
ADDRLP4 160
INDIRI4
ADDRLP4 392
INDIRI4
NEI4 $1068
ADDRLP4 0
ARGP4
ADDRLP4 396
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 396
INDIRI4
CNSTI4 0
EQI4 $1066
LABELV $1068
line 3288
;3287:			(healthdecrease ||
;3288:			 EntityIsShooting(&entinfo))) {
line 3289
;3289:			f = 360;
ADDRLP4 168
CNSTF4 1135869952
ASGNF4
line 3290
;3290:		}
ADDRGP4 $1067
JUMPV
LABELV $1066
line 3291
;3291:		else {
line 3292
;3292:			f =
ADDRLP4 156
INDIRF4
CNSTF4 1226845760
LEF4 $1070
ADDRLP4 400
CNSTF4 1226845760
ASGNF4
ADDRGP4 $1071
JUMPV
LABELV $1070
ADDRLP4 400
ADDRLP4 156
INDIRF4
ASGNF4
LABELV $1071
ADDRLP4 168
CNSTF4 1127481344
CNSTF4 1119092736
ADDRLP4 400
INDIRF4
CNSTF4 1172557824
DIVF4
SUBF4
SUBF4
ASGNF4
line 3304
;3293:				90 + 90 -
;3294:				(
;3295:					90 -
;3296:					(
;3297:						squaredist >
;3298:							Square(810)
;3299:							? Square(810)
;3300:							: squaredist
;3301:					) /
;3302:					(810 * 9)
;3303:				);
;3304:		}
LABELV $1067
line 3306
;3305:
;3306:		vis = BotEntityVisible(
ADDRLP4 400
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 400
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 400
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 400
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
ADDRLP4 168
INDIRF4
ARGF4
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 404
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 172
ADDRLP4 404
INDIRF4
ASGNF4
line 3314
;3307:			bs->entitynum,
;3308:			bs->eye,
;3309:			bs->viewangles,
;3310:			f,
;3311:			i
;3312:		);
;3313:
;3314:		if (vis <= 0) {
ADDRLP4 172
INDIRF4
CNSTF4 0
GTF4 $1072
line 3315
;3315:			continue;
ADDRGP4 $1021
JUMPV
LABELV $1072
line 3318
;3316:		}
;3317:
;3318:		if (curenemy < 0 &&
ADDRLP4 408
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 408
INDIRI4
GEI4 $1074
ADDRLP4 156
INDIRF4
CNSTF4 1176256512
LEF4 $1074
ADDRLP4 160
INDIRI4
ADDRLP4 408
INDIRI4
NEI4 $1074
ADDRLP4 0
ARGP4
ADDRLP4 412
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 412
INDIRI4
CNSTI4 0
NEI4 $1074
line 3321
;3319:			squaredist > Square(100) &&
;3320:			!healthdecrease &&
;3321:			!EntityIsShooting(&entinfo)) {
line 3322
;3322:			VectorSubtract(
ADDRLP4 416
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 144
ADDRLP4 416
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRLP4 0+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+4
ADDRLP4 416
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ADDRLP4 0+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+8
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 0+24+8
INDIRF4
SUBF4
ASGNF4
line 3328
;3323:				bs->origin,
;3324:				entinfo.origin,
;3325:				dir
;3326:			);
;3327:
;3328:			vectoangles(dir, angles);
ADDRLP4 144
ARGP4
ADDRLP4 180
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3330
;3329:
;3330:			if (!InFieldOfVision(
ADDRLP4 0+36
ARGP4
CNSTF4 1119092736
ARGF4
ADDRLP4 180
ARGP4
ADDRLP4 420
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 420
INDIRI4
CNSTI4 0
NEI4 $1083
line 3334
;3331:				entinfo.angles,
;3332:				90,
;3333:				angles
;3334:			)) {
line 3335
;3335:				BotUpdateBattleInventory(
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 3340
;3336:					bs,
;3337:					i
;3338:				);
;3339:
;3340:				if (BotWantsToRetreat(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 424
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 424
INDIRI4
CNSTI4 0
EQI4 $1086
line 3341
;3341:					continue;
ADDRGP4 $1021
JUMPV
LABELV $1086
line 3343
;3342:				}
;3343:			}
LABELV $1083
line 3344
;3344:		}
LABELV $1074
line 3346
;3345:
;3346:		bs->enemy = entinfo.number;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
ADDRLP4 0+20
INDIRI4
ASGNI4
line 3348
;3347:
;3348:		if (curenemy >= 0) {
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1089
line 3349
;3349:			bs->enemysight_time =
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
ASGNF4
line 3351
;3350:				FloatTime() - 2;
;3351:		}
ADDRGP4 $1090
JUMPV
LABELV $1089
line 3352
;3352:		else {
line 3353
;3353:			bs->enemysight_time =
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 3355
;3354:				FloatTime();
;3355:		}
LABELV $1090
line 3357
;3356:
;3357:		bs->enemysuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 0
ASGNI4
line 3358
;3358:		bs->enemydeath_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
CNSTF4 0
ASGNF4
line 3359
;3359:		bs->enemyvisible_time =
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 3362
;3360:			FloatTime();
;3361:
;3362:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1002
JUMPV
LABELV $1021
line 3214
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1023
line 3213
ADDRLP4 140
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1091
ADDRLP4 140
INDIRI4
CNSTI4 64
LTI4 $1020
LABELV $1091
line 3365
;3363:	}
;3364:
;3365:	return qfalse;
CNSTI4 0
RETI4
LABELV $1002
endproc BotFindEnemy 428 20
export BotTeamFlagCarrierVisible
proc BotTeamFlagCarrierVisible 164 20
line 3373
;3366:}
;3367:
;3368:/*
;3369:==================
;3370:BotTeamFlagCarrierVisible
;3371:==================
;3372:*/
;3373:int BotTeamFlagCarrierVisible(bot_state_t *bs) {
line 3378
;3374:	int i;
;3375:	float vis;
;3376:	aas_entityinfo_t entinfo;
;3377:
;3378:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1096
JUMPV
LABELV $1093
line 3379
;3379:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1097
line 3380
;3380:			continue;
ADDRGP4 $1094
JUMPV
LABELV $1097
line 3382
;3381:		//
;3382:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3384
;3383:		//if this player is active
;3384:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1099
line 3385
;3385:			continue;
ADDRGP4 $1094
JUMPV
LABELV $1099
line 3387
;3386:		//if this player is carrying a flag
;3387:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 148
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1101
line 3388
;3388:			continue;
ADDRGP4 $1094
JUMPV
LABELV $1101
line 3390
;3389:		//if the flag carrier is not on the same team
;3390:		if (!BotSameTeam(bs, i))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 152
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 0
NEI4 $1103
line 3391
;3391:			continue;
ADDRGP4 $1094
JUMPV
LABELV $1103
line 3393
;3392:		//if the flag carrier is not visible
;3393:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
ADDRLP4 156
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 156
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 156
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 156
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 160
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 144
ADDRLP4 160
INDIRF4
ASGNF4
line 3394
;3394:		if (vis <= 0)
ADDRLP4 144
INDIRF4
CNSTF4 0
GTF4 $1105
line 3395
;3395:			continue;
ADDRGP4 $1094
JUMPV
LABELV $1105
line 3397
;3396:		//
;3397:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1092
JUMPV
LABELV $1094
line 3378
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1096
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1107
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1093
LABELV $1107
line 3399
;3398:	}
;3399:	return -1;
CNSTI4 -1
RETI4
LABELV $1092
endproc BotTeamFlagCarrierVisible 164 20
export BotTeamFlagCarrier
proc BotTeamFlagCarrier 152 8
line 3407
;3400:}
;3401:
;3402:/*
;3403:==================
;3404:BotTeamFlagCarrier
;3405:==================
;3406:*/
;3407:int BotTeamFlagCarrier(bot_state_t *bs) {
line 3411
;3408:	int i;
;3409:	aas_entityinfo_t entinfo;
;3410:
;3411:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1112
JUMPV
LABELV $1109
line 3412
;3412:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1113
line 3413
;3413:			continue;
ADDRGP4 $1110
JUMPV
LABELV $1113
line 3415
;3414:		//
;3415:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3417
;3416:		//if this player is active
;3417:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1115
line 3418
;3418:			continue;
ADDRGP4 $1110
JUMPV
LABELV $1115
line 3420
;3419:		//if this player is carrying a flag
;3420:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 144
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
NEI4 $1117
line 3421
;3421:			continue;
ADDRGP4 $1110
JUMPV
LABELV $1117
line 3423
;3422:		//if the flag carrier is not on the same team
;3423:		if (!BotSameTeam(bs, i))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 148
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1119
line 3424
;3424:			continue;
ADDRGP4 $1110
JUMPV
LABELV $1119
line 3426
;3425:		//
;3426:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1108
JUMPV
LABELV $1110
line 3411
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1112
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1121
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1109
LABELV $1121
line 3428
;3427:	}
;3428:	return -1;
CNSTI4 -1
RETI4
LABELV $1108
endproc BotTeamFlagCarrier 152 8
export BotEnemyFlagCarrierVisible
proc BotEnemyFlagCarrierVisible 164 20
line 3436
;3429:}
;3430:
;3431:/*
;3432:==================
;3433:BotEnemyFlagCarrierVisible
;3434:==================
;3435:*/
;3436:int BotEnemyFlagCarrierVisible(bot_state_t *bs) {
line 3441
;3437:	int i;
;3438:	float vis;
;3439:	aas_entityinfo_t entinfo;
;3440:
;3441:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1126
JUMPV
LABELV $1123
line 3442
;3442:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1127
line 3443
;3443:			continue;
ADDRGP4 $1124
JUMPV
LABELV $1127
line 3445
;3444:		//
;3445:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3447
;3446:		//if this player is active
;3447:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1129
line 3448
;3448:			continue;
ADDRGP4 $1124
JUMPV
LABELV $1129
line 3450
;3449:		//if this player is carrying a flag
;3450:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 148
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1131
line 3451
;3451:			continue;
ADDRGP4 $1124
JUMPV
LABELV $1131
line 3453
;3452:		//if the flag carrier is on the same team
;3453:		if (BotSameTeam(bs, i))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 152
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 0
EQI4 $1133
line 3454
;3454:			continue;
ADDRGP4 $1124
JUMPV
LABELV $1133
line 3456
;3455:		//if the flag carrier is not visible
;3456:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
ADDRLP4 156
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 156
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 156
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 156
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 160
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 144
ADDRLP4 160
INDIRF4
ASGNF4
line 3457
;3457:		if (vis <= 0)
ADDRLP4 144
INDIRF4
CNSTF4 0
GTF4 $1135
line 3458
;3458:			continue;
ADDRGP4 $1124
JUMPV
LABELV $1135
line 3460
;3459:		//
;3460:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1122
JUMPV
LABELV $1124
line 3441
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1126
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1137
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1123
LABELV $1137
line 3462
;3461:	}
;3462:	return -1;
CNSTI4 -1
RETI4
LABELV $1122
endproc BotEnemyFlagCarrierVisible 164 20
export BotVisibleTeamMatesAndEnemies
proc BotVisibleTeamMatesAndEnemies 192 20
line 3470
;3463:}
;3464:
;3465:/*
;3466:==================
;3467:BotVisibleTeamMatesAndEnemies
;3468:==================
;3469:*/
;3470:void BotVisibleTeamMatesAndEnemies(bot_state_t *bs, int *teammates, int *enemies, float range) {
line 3476
;3471:	int i;
;3472:	float vis;
;3473:	aas_entityinfo_t entinfo;
;3474:	vec3_t dir;
;3475:
;3476:	if (teammates)
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1139
line 3477
;3477:		*teammates = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
LABELV $1139
line 3478
;3478:	if (enemies)
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1141
line 3479
;3479:		*enemies = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
LABELV $1141
line 3480
;3480:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1146
JUMPV
LABELV $1143
line 3481
;3481:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1147
line 3482
;3482:			continue;
ADDRGP4 $1144
JUMPV
LABELV $1147
line 3484
;3483:		//
;3484:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3486
;3485:		//if this player is active
;3486:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1149
line 3487
;3487:			continue;
ADDRGP4 $1144
JUMPV
LABELV $1149
line 3489
;3488:		//if this player is carrying a flag
;3489:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 160
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $1151
line 3490
;3490:			continue;
ADDRGP4 $1144
JUMPV
LABELV $1151
line 3492
;3491:		//if not within range
;3492:		VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 164
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 144
ADDRLP4 4+24
INDIRF4
ADDRLP4 164
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+4
ADDRLP4 4+24+4
INDIRF4
ADDRLP4 164
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+8
ADDRLP4 4+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3493
;3493:		if (VectorLengthSquared(dir) > Square(range))
ADDRLP4 144
ARGP4
ADDRLP4 168
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 172
ADDRFP4 12
INDIRF4
ASGNF4
ADDRLP4 168
INDIRF4
ADDRLP4 172
INDIRF4
ADDRLP4 172
INDIRF4
MULF4
LEF4 $1160
line 3494
;3494:			continue;
ADDRGP4 $1144
JUMPV
LABELV $1160
line 3496
;3495:		//if the flag carrier is not visible
;3496:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
ADDRLP4 176
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 176
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 176
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 176
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 180
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 180
INDIRF4
ASGNF4
line 3497
;3497:		if (vis <= 0)
ADDRLP4 156
INDIRF4
CNSTF4 0
GTF4 $1162
line 3498
;3498:			continue;
ADDRGP4 $1144
JUMPV
LABELV $1162
line 3500
;3499:		//if the flag carrier is on the same team
;3500:		if (BotSameTeam(bs, i)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 184
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 0
EQI4 $1164
line 3501
;3501:			if (teammates)
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1165
line 3502
;3502:				(*teammates)++;
ADDRLP4 188
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 188
INDIRP4
ADDRLP4 188
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 3503
;3503:		}
ADDRGP4 $1165
JUMPV
LABELV $1164
line 3504
;3504:		else {
line 3505
;3505:			if (enemies)
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1168
line 3506
;3506:				(*enemies)++;
ADDRLP4 188
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 188
INDIRP4
ADDRLP4 188
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1168
line 3507
;3507:		}
LABELV $1165
line 3508
;3508:	}
LABELV $1144
line 3480
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1146
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1170
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1143
LABELV $1170
line 3509
;3509:}
LABELV $1138
endproc BotVisibleTeamMatesAndEnemies 192 20
lit
align 4
LABELV $1172
byte 4 3229614080
byte 4 3229614080
byte 4 3229614080
align 4
LABELV $1173
byte 4 1082130432
byte 4 1082130432
byte 4 1082130432
export BotAimAtEnemy
code
proc BotAimAtEnemy 1144 52
line 3580
;3510:
;3511:#ifdef MISSIONPACK
;3512:/*
;3513:==================
;3514:BotTeamCubeCarrierVisible
;3515:==================
;3516:*/
;3517:int BotTeamCubeCarrierVisible(bot_state_t *bs) {
;3518:	int i;
;3519:	float vis;
;3520:	aas_entityinfo_t entinfo;
;3521:
;3522:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
;3523:		if (i == bs->client) continue;
;3524:		//
;3525:		BotEntityInfo(i, &entinfo);
;3526:		//if this player is active
;3527:		if (!entinfo.valid) continue;
;3528:		//if this player is carrying a flag
;3529:		if (!EntityCarriesCubes(&entinfo)) continue;
;3530:		//if the flag carrier is not on the same team
;3531:		if (!BotSameTeam(bs, i)) continue;
;3532:		//if the flag carrier is not visible
;3533:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
;3534:		if (vis <= 0) continue;
;3535:		//
;3536:		return i;
;3537:	}
;3538:	return -1;
;3539:}
;3540:
;3541:/*
;3542:==================
;3543:BotEnemyCubeCarrierVisible
;3544:==================
;3545:*/
;3546:int BotEnemyCubeCarrierVisible(bot_state_t *bs) {
;3547:	int i;
;3548:	float vis;
;3549:	aas_entityinfo_t entinfo;
;3550:
;3551:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
;3552:		if (i == bs->client)
;3553:			continue;
;3554:		//
;3555:		BotEntityInfo(i, &entinfo);
;3556:		//if this player is active
;3557:		if (!entinfo.valid)
;3558:			continue;
;3559:		//if this player is carrying a flag
;3560:		if (!EntityCarriesCubes(&entinfo)) continue;
;3561:		//if the flag carrier is on the same team
;3562:		if (BotSameTeam(bs, i))
;3563:			continue;
;3564:		//if the flag carrier is not visible
;3565:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
;3566:		if (vis <= 0)
;3567:			continue;
;3568:		//
;3569:		return i;
;3570:	}
;3571:	return -1;
;3572:}
;3573:#endif
;3574:
;3575:/*
;3576:==================
;3577:BotAimAtEnemy
;3578:==================
;3579:*/
;3580:void BotAimAtEnemy(bot_state_t *bs) {
line 3584
;3581:	int i, enemyvisible;
;3582:	float dist, f, aim_skill, aim_accuracy, speed, reactiontime;
;3583:	vec3_t dir, bestorigin, end, start, groundtarget, cmdmove, enemyvelocity;
;3584:	vec3_t mins = {-4,-4,-4}, maxs = {4, 4, 4};
ADDRLP4 860
ADDRGP4 $1172
INDIRB
ASGNB 12
ADDRLP4 872
ADDRGP4 $1173
INDIRB
ASGNB 12
line 3592
;3585:	weaponinfo_t wi;
;3586:	aas_entityinfo_t entinfo;
;3587:	bot_goal_t goal;
;3588:	bsp_trace_t trace;
;3589:	vec3_t target;
;3590:
;3591:	//if the bot has no enemy
;3592:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $1174
line 3593
;3593:		return;
ADDRGP4 $1171
JUMPV
LABELV $1174
line 3596
;3594:	}
;3595:	//get the enemy entity information
;3596:	BotEntityInfo(bs->enemy, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3598
;3597:	//if this is not a player (should be an obelisk)
;3598:	if (bs->enemy >= MAX_CLIENTS) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 64
LTI4 $1176
line 3600
;3599:		//if the obelisk is visible
;3600:		VectorCopy(entinfo.origin, target);
ADDRLP4 828
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3609
;3601:#ifdef MISSIONPACK
;3602:		// if attacking an obelisk
;3603:		if ( bs->enemy == redobelisk.entitynum ||
;3604:			bs->enemy == blueobelisk.entitynum ) {
;3605:			target[2] += 32;
;3606:		}
;3607:#endif
;3608:		//aim at the obelisk
;3609:		VectorSubtract(target, bs->eye, dir);
ADDRLP4 984
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 828
INDIRF4
ADDRLP4 984
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 828+4
INDIRF4
ADDRLP4 984
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 828+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3610
;3610:		vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 140
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3612
;3611:		//set the aim target before trying to attack
;3612:		VectorCopy(target, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 828
INDIRB
ASGNB 12
line 3613
;3613:		return;
ADDRGP4 $1171
JUMPV
LABELV $1176
line 3618
;3614:	}
;3615:	//
;3616:	//BotAI_Print(PRT_MESSAGE, "client %d: aiming at client %d\n", bs->entitynum, bs->enemy);
;3617:	//
;3618:	aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 16
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 984
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 736
ADDRLP4 984
INDIRF4
ASGNF4
line 3619
;3619:	aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 7
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 988
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 988
INDIRF4
ASGNF4
line 3621
;3620:	//
;3621:	if (aim_skill > 0.95) {
ADDRLP4 736
INDIRF4
CNSTF4 1064514355
LEF4 $1183
line 3623
;3622:		//don't aim too early
;3623:		reactiontime = 0.5 * trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_REACTIONTIME, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 6
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 992
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 856
CNSTF4 1056964608
ADDRLP4 992
INDIRF4
MULF4
ASGNF4
line 3624
;3624:		if (bs->enemysight_time > FloatTime() - reactiontime) return;
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
ADDRLP4 856
INDIRF4
SUBF4
LEF4 $1185
ADDRGP4 $1171
JUMPV
LABELV $1185
line 3625
;3625:		if (bs->teleport_time > FloatTime() - reactiontime) return;
ADDRFP4 0
INDIRP4
CNSTI4 6180
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
ADDRLP4 856
INDIRF4
SUBF4
LEF4 $1187
ADDRGP4 $1171
JUMPV
LABELV $1187
line 3626
;3626:	}
LABELV $1183
line 3629
;3627:
;3628:	//get the weapon information
;3629:	trap_BotGetWeaponInfo(bs->ws, bs->weaponnum, &wi);
ADDRLP4 992
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 992
INDIRP4
CNSTI4 6536
ADDP4
INDIRI4
ARGI4
ADDRLP4 992
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ARGI4
ADDRLP4 160
ARGP4
ADDRGP4 trap_BotGetWeaponInfo
CALLV
pop
line 3631
;3630:	//get the weapon specific aim accuracy and or aim skill
;3631:	if (wi.number == WP_MACHINEGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 2
NEI4 $1189
line 3632
;3632:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_MACHINEGUN, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 8
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3633
;3633:	}
ADDRGP4 $1190
JUMPV
LABELV $1189
line 3634
;3634:	else if (wi.number == WP_SHOTGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 3
NEI4 $1192
line 3635
;3635:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_SHOTGUN, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 9
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3636
;3636:	}
ADDRGP4 $1193
JUMPV
LABELV $1192
line 3637
;3637:	else if (wi.number == WP_GRENADE_LAUNCHER) {
ADDRLP4 160+4
INDIRI4
CNSTI4 4
NEI4 $1195
line 3638
;3638:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_GRENADELAUNCHER, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 11
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3639
;3639:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_GRENADELAUNCHER, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 18
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 1000
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 736
ADDRLP4 1000
INDIRF4
ASGNF4
line 3640
;3640:	}
ADDRGP4 $1196
JUMPV
LABELV $1195
line 3641
;3641:	else if (wi.number == WP_ROCKET_LAUNCHER) {
ADDRLP4 160+4
INDIRI4
CNSTI4 5
NEI4 $1198
line 3642
;3642:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_ROCKETLAUNCHER, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 10
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3643
;3643:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_ROCKETLAUNCHER, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 17
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 1000
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 736
ADDRLP4 1000
INDIRF4
ASGNF4
line 3644
;3644:	}
ADDRGP4 $1199
JUMPV
LABELV $1198
line 3645
;3645:	else if (wi.number == WP_LIGHTNING) {
ADDRLP4 160+4
INDIRI4
CNSTI4 6
NEI4 $1201
line 3646
;3646:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_LIGHTNING, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 12
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3647
;3647:	}
ADDRGP4 $1202
JUMPV
LABELV $1201
line 3648
;3648:	else if (wi.number == WP_RAILGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 7
NEI4 $1204
line 3649
;3649:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_RAILGUN, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 14
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3650
;3650:	}
ADDRGP4 $1205
JUMPV
LABELV $1204
line 3651
;3651:	else if (wi.number == WP_PLASMAGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 8
NEI4 $1207
line 3652
;3652:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_PLASMAGUN, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 13
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3653
;3653:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_PLASMAGUN, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 19
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 1000
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 736
ADDRLP4 1000
INDIRF4
ASGNF4
line 3654
;3654:	}
ADDRGP4 $1208
JUMPV
LABELV $1207
line 3655
;3655:	else if (wi.number == WP_BFG) {
ADDRLP4 160+4
INDIRI4
CNSTI4 9
NEI4 $1210
line 3656
;3656:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_BFG10K, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 15
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 996
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 156
ADDRLP4 996
INDIRF4
ASGNF4
line 3657
;3657:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_BFG10K, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 20
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 1000
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 736
ADDRLP4 1000
INDIRF4
ASGNF4
line 3658
;3658:	}
LABELV $1210
LABELV $1208
LABELV $1205
LABELV $1202
LABELV $1199
LABELV $1196
LABELV $1193
LABELV $1190
line 3660
;3659:	//
;3660:	if (aim_accuracy <= 0) aim_accuracy = 0.0001f;
ADDRLP4 156
INDIRF4
CNSTF4 0
GTF4 $1213
ADDRLP4 156
CNSTF4 953267991
ASGNF4
LABELV $1213
line 3662
;3661:	//get the enemy entity information
;3662:	BotEntityInfo(bs->enemy, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3664
;3663:	//if the enemy is invisible then shoot crappy most of the time
;3664:	if (EntityIsInvisible(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 996
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 996
INDIRI4
CNSTI4 0
EQI4 $1215
line 3665
;3665:		if (random() > 0.1) aim_accuracy *= 0.4f;
ADDRLP4 1000
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 1000
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1036831949
LEF4 $1217
ADDRLP4 156
CNSTF4 1053609165
ADDRLP4 156
INDIRF4
MULF4
ASGNF4
LABELV $1217
line 3666
;3666:	}
LABELV $1215
line 3668
;3667:	//
;3668:	VectorSubtract(entinfo.origin, entinfo.lastvisorigin, enemyvelocity);
ADDRLP4 712
ADDRLP4 0+24
INDIRF4
ADDRLP4 0+60
INDIRF4
SUBF4
ASGNF4
ADDRLP4 712+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 0+60+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 712+8
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 0+60+8
INDIRF4
SUBF4
ASGNF4
line 3669
;3669:	VectorScale(enemyvelocity, 1 / entinfo.update_time, enemyvelocity);
ADDRLP4 1000
CNSTF4 1065353216
ASGNF4
ADDRLP4 712
ADDRLP4 712
INDIRF4
ADDRLP4 1000
INDIRF4
ADDRLP4 0+16
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 712+4
ADDRLP4 712+4
INDIRF4
ADDRLP4 1000
INDIRF4
ADDRLP4 0+16
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 712+8
ADDRLP4 712+8
INDIRF4
CNSTF4 1065353216
ADDRLP4 0+16
INDIRF4
DIVF4
MULF4
ASGNF4
line 3671
;3670:	//enemy origin and velocity is remembered every 0.5 seconds
;3671:	if (bs->enemyposition_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6140
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1238
line 3673
;3672:		//
;3673:		bs->enemyposition_time = FloatTime() + 0.5;
ADDRFP4 0
INDIRP4
CNSTI4 6140
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1056964608
ADDF4
ASGNF4
line 3674
;3674:		VectorCopy(enemyvelocity, bs->enemyvelocity);
ADDRFP4 0
INDIRP4
CNSTI4 6232
ADDP4
ADDRLP4 712
INDIRB
ASGNB 12
line 3675
;3675:		VectorCopy(entinfo.origin, bs->enemyorigin);
ADDRFP4 0
INDIRP4
CNSTI4 6244
ADDP4
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3676
;3676:	}
LABELV $1238
line 3678
;3677:	//if not extremely skilled
;3678:	if (aim_skill < 0.9) {
ADDRLP4 736
INDIRF4
CNSTF4 1063675494
GEF4 $1241
line 3679
;3679:		VectorSubtract(entinfo.origin, bs->enemyorigin, dir);
ADDRLP4 1004
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 0+24
INDIRF4
ADDRLP4 1004
INDIRP4
CNSTI4 6244
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1004
INDIRP4
CNSTI4 6248
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 6252
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3681
;3680:		//if the enemy moved a bit
;3681:		if (VectorLengthSquared(dir) > Square(48)) {
ADDRLP4 140
ARGP4
ADDRLP4 1008
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1008
INDIRF4
CNSTF4 1158676480
LEF4 $1250
line 3683
;3682:			//if the enemy changed direction
;3683:			if (DotProduct(bs->enemyvelocity, enemyvelocity) < 0) {
ADDRLP4 1012
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1012
INDIRP4
CNSTI4 6232
ADDP4
INDIRF4
ADDRLP4 712
INDIRF4
MULF4
ADDRLP4 1012
INDIRP4
CNSTI4 6236
ADDP4
INDIRF4
ADDRLP4 712+4
INDIRF4
MULF4
ADDF4
ADDRLP4 1012
INDIRP4
CNSTI4 6240
ADDP4
INDIRF4
ADDRLP4 712+8
INDIRF4
MULF4
ADDF4
CNSTF4 0
GEF4 $1252
line 3685
;3684:				//aim accuracy should be worse now
;3685:				aim_accuracy *= 0.7f;
ADDRLP4 156
CNSTF4 1060320051
ADDRLP4 156
INDIRF4
MULF4
ASGNF4
line 3686
;3686:			}
LABELV $1252
line 3687
;3687:		}
LABELV $1250
line 3688
;3688:	}
LABELV $1241
line 3690
;3689:	//check visibility of enemy
;3690:	enemyvisible = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy);
ADDRLP4 1004
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1004
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 1004
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 1004
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 1004
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 1008
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 824
ADDRLP4 1008
INDIRF4
CVFI4 4
ASGNI4
line 3692
;3691:	//if the enemy is visible
;3692:	if (enemyvisible) {
ADDRLP4 824
INDIRI4
CNSTI4 0
EQI4 $1256
line 3694
;3693:		//
;3694:		VectorCopy(entinfo.origin, bestorigin);
ADDRLP4 724
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3695
;3695:		bestorigin[2] += 8;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 3698
;3696:		//get the start point shooting from
;3697:		//NOTE: the x and y projectile start offsets are ignored
;3698:		VectorCopy(bs->origin, start);
ADDRLP4 844
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 3699
;3699:		start[2] += bs->cur_ps.viewheight;
ADDRLP4 844+8
ADDRLP4 844+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 3700
;3700:		start[2] += wi.offset[2];
ADDRLP4 844+8
ADDRLP4 844+8
INDIRF4
ADDRLP4 160+292+8
INDIRF4
ADDF4
ASGNF4
line 3702
;3701:		//
;3702:		BotAI_Trace(&trace, start, mins, maxs, bestorigin, bs->entitynum, MASK_SHOT);
ADDRLP4 740
ARGP4
ADDRLP4 844
ARGP4
ADDRLP4 860
ARGP4
ADDRLP4 872
ARGP4
ADDRLP4 724
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3704
;3703:		//if the enemy is NOT hit
;3704:		if (trace.fraction <= 1 && trace.ent != entinfo.number) {
ADDRLP4 740+8
INDIRF4
CNSTF4 1065353216
GTF4 $1264
ADDRLP4 740+80
INDIRI4
ADDRLP4 0+20
INDIRI4
EQI4 $1264
line 3705
;3705:			bestorigin[2] += 16;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 3706
;3706:		}
LABELV $1264
line 3708
;3707:		//if it is not an instant hit weapon the bot might want to predict the enemy
;3708:		if (wi.speed) {
ADDRLP4 160+272
INDIRF4
CNSTF4 0
EQF4 $1270
line 3710
;3709:			//
;3710:			VectorSubtract(bestorigin, bs->origin, dir);
ADDRLP4 1012
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 724
INDIRF4
ADDRLP4 1012
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 724+4
INDIRF4
ADDRLP4 1012
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 724+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3711
;3711:			dist = VectorLength(dir);
ADDRLP4 140
ARGP4
ADDRLP4 1016
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 840
ADDRLP4 1016
INDIRF4
ASGNF4
line 3712
;3712:			VectorSubtract(entinfo.origin, bs->enemyorigin, dir);
ADDRLP4 1020
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 0+24
INDIRF4
ADDRLP4 1020
INDIRP4
CNSTI4 6244
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1020
INDIRP4
CNSTI4 6248
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 6252
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3714
;3713:			//if the enemy is NOT pretty far away and strafing just small steps left and right
;3714:			if (!(dist > 100 && VectorLengthSquared(dir) < Square(32))) {
ADDRLP4 840
INDIRF4
CNSTF4 1120403456
LEF4 $1286
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1149239296
LTF4 $1284
LABELV $1286
line 3716
;3715:				//if skilled anough do exact prediction
;3716:				if (aim_skill > 0.8 &&
ADDRLP4 736
INDIRF4
CNSTF4 1061997773
LEF4 $1287
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1287
line 3718
;3717:						//if the weapon is ready to fire
;3718:						bs->cur_ps.weaponstate == WEAPON_READY) {
line 3722
;3719:					aas_clientmove_t move;
;3720:					vec3_t origin;
;3721:
;3722:					VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 1124
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 0+24
INDIRF4
ADDRLP4 1124
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1124
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3724
;3723:					//distance towards the enemy
;3724:					dist = VectorLength(dir);
ADDRLP4 140
ARGP4
ADDRLP4 1128
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 840
ADDRLP4 1128
INDIRF4
ASGNF4
line 3726
;3725:					//direction the enemy is moving in
;3726:					VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
ADDRLP4 140
ADDRLP4 0+24
INDIRF4
ADDRLP4 0+60
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 0+60+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 0+60+8
INDIRF4
SUBF4
ASGNF4
line 3728
;3727:					//
;3728:					VectorScale(dir, 1 / entinfo.update_time, dir);
ADDRLP4 1132
CNSTF4 1065353216
ASGNF4
ADDRLP4 140
ADDRLP4 140
INDIRF4
ADDRLP4 1132
INDIRF4
ADDRLP4 0+16
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 140+4
INDIRF4
ADDRLP4 1132
INDIRF4
ADDRLP4 0+16
INDIRF4
DIVF4
MULF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 140+8
INDIRF4
CNSTF4 1065353216
ADDRLP4 0+16
INDIRF4
DIVF4
MULF4
ASGNF4
line 3730
;3729:					//
;3730:					VectorCopy(entinfo.origin, origin);
ADDRLP4 1028
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3731
;3731:					origin[2] += 1;
ADDRLP4 1028+8
ADDRLP4 1028+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 3733
;3732:					//
;3733:					VectorClear(cmdmove);
ADDRLP4 1136
CNSTF4 0
ASGNF4
ADDRLP4 968+8
ADDRLP4 1136
INDIRF4
ASGNF4
ADDRLP4 968+4
ADDRLP4 1136
INDIRF4
ASGNF4
ADDRLP4 968
ADDRLP4 1136
INDIRF4
ASGNF4
line 3735
;3734:					//AAS_ClearShownDebugLines();
;3735:					trap_AAS_PredictClientMovement(&move, bs->enemy, origin,
ADDRLP4 1040
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 1028
ARGP4
CNSTI4 4
ARGI4
ADDRLP4 1140
CNSTI4 0
ASGNI4
ADDRLP4 1140
INDIRI4
ARGI4
ADDRLP4 140
ARGP4
ADDRLP4 968
ARGP4
ADDRLP4 1140
INDIRI4
ARGI4
CNSTF4 1092616192
ADDRLP4 840
INDIRF4
MULF4
ADDRLP4 160+272
INDIRF4
DIVF4
CVFI4 4
ARGI4
CNSTF4 1036831949
ARGF4
ADDRLP4 1140
INDIRI4
ARGI4
ADDRLP4 1140
INDIRI4
ARGI4
ADDRLP4 1140
INDIRI4
ARGI4
ADDRGP4 trap_AAS_PredictClientMovement
CALLI4
pop
line 3739
;3736:														PRESENCE_CROUCH, qfalse,
;3737:														dir, cmdmove, 0,
;3738:														dist * 10 / wi.speed, 0.1f, 0, 0, qfalse);
;3739:					VectorCopy(move.endpos, bestorigin);
ADDRLP4 724
ADDRLP4 1040
INDIRB
ASGNB 12
line 3741
;3740:					//BotAI_Print(PRT_MESSAGE, "%1.1f predicted speed = %f, frames = %f\n", FloatTime(), VectorLength(dir), dist * 10 / wi.speed);
;3741:				}
ADDRGP4 $1288
JUMPV
LABELV $1287
line 3743
;3742:				//if not that skilled do linear prediction
;3743:				else if (aim_skill > 0.4) {
ADDRLP4 736
INDIRF4
CNSTF4 1053609165
LEF4 $1320
line 3744
;3744:					VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 1028
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 0+24
INDIRF4
ADDRLP4 1028
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1028
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3746
;3745:					//distance towards the enemy
;3746:					dist = VectorLength(dir);
ADDRLP4 140
ARGP4
ADDRLP4 1032
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 840
ADDRLP4 1032
INDIRF4
ASGNF4
line 3748
;3747:					//direction the enemy is moving in
;3748:					VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
ADDRLP4 140
ADDRLP4 0+24
INDIRF4
ADDRLP4 0+60
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 0+60+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 0+60+8
INDIRF4
SUBF4
ASGNF4
line 3749
;3749:					dir[2] = 0;
ADDRLP4 140+8
CNSTF4 0
ASGNF4
line 3751
;3750:					//
;3751:					speed = VectorNormalize(dir) / entinfo.update_time;
ADDRLP4 140
ARGP4
ADDRLP4 1036
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 980
ADDRLP4 1036
INDIRF4
ADDRLP4 0+16
INDIRF4
DIVF4
ASGNF4
line 3754
;3752:					//botimport.Print(PRT_MESSAGE, "speed = %f, wi->speed = %f\n", speed, wi->speed);
;3753:					//best spot to aim at
;3754:					VectorMA(entinfo.origin, (dist / wi.speed) * speed, dir, bestorigin);
ADDRLP4 1040
ADDRLP4 840
INDIRF4
ASGNF4
ADDRLP4 1044
ADDRLP4 980
INDIRF4
ASGNF4
ADDRLP4 724
ADDRLP4 0+24
INDIRF4
ADDRLP4 140
INDIRF4
ADDRLP4 1040
INDIRF4
ADDRLP4 160+272
INDIRF4
DIVF4
ADDRLP4 1044
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 724+4
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 140+4
INDIRF4
ADDRLP4 1040
INDIRF4
ADDRLP4 160+272
INDIRF4
DIVF4
ADDRLP4 1044
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
ADDRLP4 724+8
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 140+8
INDIRF4
ADDRLP4 840
INDIRF4
ADDRLP4 160+272
INDIRF4
DIVF4
ADDRLP4 980
INDIRF4
MULF4
MULF4
ADDF4
ASGNF4
line 3755
;3755:				}
LABELV $1320
LABELV $1288
line 3756
;3756:			}
LABELV $1284
line 3757
;3757:		}
LABELV $1270
line 3759
;3758:		//if the projectile does radial damage
;3759:		if (aim_skill > 0.6 && wi.proj.damagetype & DAMAGETYPE_RADIAL) {
ADDRLP4 736
INDIRF4
CNSTF4 1058642330
LEF4 $1355
ADDRLP4 160+344+180
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1355
line 3761
;3760:			//if the enemy isn't standing significantly higher than the bot
;3761:			if (entinfo.origin[2] < bs->origin[2] + 16) {
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
CNSTF4 1098907648
ADDF4
GEF4 $1359
line 3763
;3762:				//try to aim at the ground in front of the enemy
;3763:				VectorCopy(entinfo.origin, end);
ADDRLP4 956
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3764
;3764:				end[2] -= 64;
ADDRLP4 956+8
ADDRLP4 956+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 3765
;3765:				BotAI_Trace(&trace, entinfo.origin, NULL, NULL, end, entinfo.number, MASK_SHOT);
ADDRLP4 740
ARGP4
ADDRLP4 0+24
ARGP4
ADDRLP4 1012
CNSTP4 0
ASGNP4
ADDRLP4 1012
INDIRP4
ARGP4
ADDRLP4 1012
INDIRP4
ARGP4
ADDRLP4 956
ARGP4
ADDRLP4 0+20
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3767
;3766:				//
;3767:				VectorCopy(bestorigin, groundtarget);
ADDRLP4 944
ADDRLP4 724
INDIRB
ASGNB 12
line 3768
;3768:				if (trace.startsolid) groundtarget[2] = entinfo.origin[2] - 16;
ADDRLP4 740+4
INDIRI4
CNSTI4 0
EQI4 $1367
ADDRLP4 944+8
ADDRLP4 0+24+8
INDIRF4
CNSTF4 1098907648
SUBF4
ASGNF4
ADDRGP4 $1368
JUMPV
LABELV $1367
line 3769
;3769:				else groundtarget[2] = trace.endpos[2] - 8;
ADDRLP4 944+8
ADDRLP4 740+12+8
INDIRF4
CNSTF4 1090519040
SUBF4
ASGNF4
LABELV $1368
line 3771
;3770:				//trace a line from projectile start to ground target
;3771:				BotAI_Trace(&trace, start, NULL, NULL, groundtarget, bs->entitynum, MASK_SHOT);
ADDRLP4 740
ARGP4
ADDRLP4 844
ARGP4
ADDRLP4 1016
CNSTP4 0
ASGNP4
ADDRLP4 1016
INDIRP4
ARGP4
ADDRLP4 1016
INDIRP4
ARGP4
ADDRLP4 944
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3773
;3772:				//if hitpoint is not vertically too far from the ground target
;3773:				if (fabs(trace.endpos[2] - groundtarget[2]) < 50) {
ADDRLP4 740+12+8
INDIRF4
ADDRLP4 944+8
INDIRF4
SUBF4
ARGF4
ADDRLP4 1020
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 1020
INDIRF4
CNSTF4 1112014848
GEF4 $1376
line 3774
;3774:					VectorSubtract(trace.endpos, groundtarget, dir);
ADDRLP4 140
ADDRLP4 740+12
INDIRF4
ADDRLP4 944
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 740+12+4
INDIRF4
ADDRLP4 944+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 740+12+8
INDIRF4
ADDRLP4 944+8
INDIRF4
SUBF4
ASGNF4
line 3776
;3775:					//if the hitpoint is near anough the ground target
;3776:					if (VectorLengthSquared(dir) < Square(60)) {
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1163984896
GEF4 $1390
line 3777
;3777:						VectorSubtract(trace.endpos, start, dir);
ADDRLP4 140
ADDRLP4 740+12
INDIRF4
ADDRLP4 844
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 740+12+4
INDIRF4
ADDRLP4 844+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 740+12+8
INDIRF4
ADDRLP4 844+8
INDIRF4
SUBF4
ASGNF4
line 3779
;3778:						//if the hitpoint is far anough from the bot
;3779:						if (VectorLengthSquared(dir) > Square(100)) {
ADDRLP4 140
ARGP4
ADDRLP4 1028
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1028
INDIRF4
CNSTF4 1176256512
LEF4 $1401
line 3781
;3780:							//check if the bot is visible from the ground target
;3781:							trace.endpos[2] += 1;
ADDRLP4 740+12+8
ADDRLP4 740+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 3782
;3782:							BotAI_Trace(&trace, trace.endpos, NULL, NULL, entinfo.origin, entinfo.number, MASK_SHOT);
ADDRLP4 740
ARGP4
ADDRLP4 740+12
ARGP4
ADDRLP4 1032
CNSTP4 0
ASGNP4
ADDRLP4 1032
INDIRP4
ARGP4
ADDRLP4 1032
INDIRP4
ARGP4
ADDRLP4 0+24
ARGP4
ADDRLP4 0+20
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3783
;3783:							if (trace.fraction >= 1) {
ADDRLP4 740+8
INDIRF4
CNSTF4 1065353216
LTF4 $1408
line 3785
;3784:								//botimport.Print(PRT_MESSAGE, "%1.1f aiming at ground\n", AAS_Time());
;3785:								VectorCopy(groundtarget, bestorigin);
ADDRLP4 724
ADDRLP4 944
INDIRB
ASGNB 12
line 3786
;3786:							}
LABELV $1408
line 3787
;3787:						}
LABELV $1401
line 3788
;3788:					}
LABELV $1390
line 3789
;3789:				}
LABELV $1376
line 3790
;3790:			}
LABELV $1359
line 3791
;3791:		}
LABELV $1355
line 3792
;3792:		bestorigin[0] += 20 * crandom() * (1 - aim_accuracy);
ADDRLP4 1012
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 724
ADDRLP4 724
INDIRF4
CNSTF4 1101004800
CNSTF4 1073741824
ADDRLP4 1012
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 156
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 3793
;3793:		bestorigin[1] += 20 * crandom() * (1 - aim_accuracy);
ADDRLP4 1016
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 724+4
ADDRLP4 724+4
INDIRF4
CNSTF4 1101004800
CNSTF4 1073741824
ADDRLP4 1016
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 156
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 3794
;3794:		bestorigin[2] += 10 * crandom() * (1 - aim_accuracy);
ADDRLP4 1020
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1092616192
CNSTF4 1073741824
ADDRLP4 1020
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 156
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 3795
;3795:	}
ADDRGP4 $1257
JUMPV
LABELV $1256
line 3796
;3796:	else {
line 3798
;3797:		//
;3798:		VectorCopy(bs->lastenemyorigin, bestorigin);
ADDRLP4 724
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 3799
;3799:		bestorigin[2] += 8;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 3801
;3800:		//if the bot is skilled anough
;3801:		if (aim_skill > 0.5) {
ADDRLP4 736
INDIRF4
CNSTF4 1056964608
LEF4 $1414
line 3803
;3802:			//do prediction shots around corners
;3803:			if (wi.number == WP_BFG ||
ADDRLP4 160+4
INDIRI4
CNSTI4 9
EQI4 $1422
ADDRLP4 160+4
INDIRI4
CNSTI4 5
EQI4 $1422
ADDRLP4 160+4
INDIRI4
CNSTI4 4
NEI4 $1416
LABELV $1422
line 3805
;3804:				wi.number == WP_ROCKET_LAUNCHER ||
;3805:				wi.number == WP_GRENADE_LAUNCHER) {
line 3807
;3806:				//create the chase goal
;3807:				goal.entitynum = bs->client;
ADDRLP4 884+40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 3808
;3808:				goal.areanum = bs->areanum;
ADDRLP4 884+12
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ASGNI4
line 3809
;3809:				VectorCopy(bs->eye, goal.origin);
ADDRLP4 884
ADDRFP4 0
INDIRP4
CNSTI4 4936
ADDP4
INDIRB
ASGNB 12
line 3810
;3810:				VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 884+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 884+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 884+16+8
CNSTF4 3238002688
ASGNF4
line 3811
;3811:				VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 884+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 884+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 884+28+8
CNSTF4 1090519040
ASGNF4
line 3813
;3812:				//
;3813:				if (trap_BotPredictVisiblePosition(bs->lastenemyorigin, bs->lastenemyareanum, &goal, TFL_DEFAULT, target)) {
ADDRLP4 1012
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1012
INDIRP4
CNSTI4 6548
ADDP4
ARGP4
ADDRLP4 1012
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
ARGI4
ADDRLP4 884
ARGP4
CNSTI4 18616254
ARGI4
ADDRLP4 828
ARGP4
ADDRLP4 1016
ADDRGP4 trap_BotPredictVisiblePosition
CALLI4
ASGNI4
ADDRLP4 1016
INDIRI4
CNSTI4 0
EQI4 $1435
line 3814
;3814:					VectorSubtract(target, bs->eye, dir);
ADDRLP4 1020
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 828
INDIRF4
ADDRLP4 1020
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 828+4
INDIRF4
ADDRLP4 1020
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 828+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3815
;3815:					if (VectorLengthSquared(dir) > Square(80)) {
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1170735104
LEF4 $1441
line 3816
;3816:						VectorCopy(target, bestorigin);
ADDRLP4 724
ADDRLP4 828
INDIRB
ASGNB 12
line 3817
;3817:						bestorigin[2] -= 20;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1101004800
SUBF4
ASGNF4
line 3818
;3818:					}
LABELV $1441
line 3819
;3819:				}
LABELV $1435
line 3820
;3820:				aim_accuracy = 1;
ADDRLP4 156
CNSTF4 1065353216
ASGNF4
line 3821
;3821:			}
LABELV $1416
line 3822
;3822:		}
LABELV $1414
line 3823
;3823:	}
LABELV $1257
line 3825
;3824:	//
;3825:	if (enemyvisible) {
ADDRLP4 824
INDIRI4
CNSTI4 0
EQI4 $1444
line 3826
;3826:		BotAI_Trace(&trace, bs->eye, NULL, NULL, bestorigin, bs->entitynum, MASK_SHOT);
ADDRLP4 740
ARGP4
ADDRLP4 1012
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1012
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 1016
CNSTP4 0
ASGNP4
ADDRLP4 1016
INDIRP4
ARGP4
ADDRLP4 1016
INDIRP4
ARGP4
ADDRLP4 724
ARGP4
ADDRLP4 1012
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3827
;3827:		VectorCopy(trace.endpos, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 740+12
INDIRB
ASGNB 12
line 3828
;3828:	}
ADDRGP4 $1445
JUMPV
LABELV $1444
line 3829
;3829:	else {
line 3830
;3830:		VectorCopy(bestorigin, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 724
INDIRB
ASGNB 12
line 3831
;3831:	}
LABELV $1445
line 3833
;3832:	//get aim direction
;3833:	VectorSubtract(bestorigin, bs->eye, dir);
ADDRLP4 1012
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 140
ADDRLP4 724
INDIRF4
ADDRLP4 1012
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+4
ADDRLP4 724+4
INDIRF4
ADDRLP4 1012
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 140+8
ADDRLP4 724+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3835
;3834:	//
;3835:	if (wi.number == WP_MACHINEGUN ||
ADDRLP4 160+4
INDIRI4
CNSTI4 2
EQI4 $1459
ADDRLP4 160+4
INDIRI4
CNSTI4 3
EQI4 $1459
ADDRLP4 160+4
INDIRI4
CNSTI4 6
EQI4 $1459
ADDRLP4 160+4
INDIRI4
CNSTI4 7
NEI4 $1451
LABELV $1459
line 3838
;3836:		wi.number == WP_SHOTGUN ||
;3837:		wi.number == WP_LIGHTNING ||
;3838:		wi.number == WP_RAILGUN) {
line 3840
;3839:		//distance towards the enemy
;3840:		dist = VectorLength(dir);
ADDRLP4 140
ARGP4
ADDRLP4 1016
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 840
ADDRLP4 1016
INDIRF4
ASGNF4
line 3841
;3841:		if (dist > 150) dist = 150;
ADDRLP4 840
INDIRF4
CNSTF4 1125515264
LEF4 $1460
ADDRLP4 840
CNSTF4 1125515264
ASGNF4
LABELV $1460
line 3842
;3842:		f = 0.6 + dist / 150 * 0.4;
ADDRLP4 940
CNSTF4 1053609165
ADDRLP4 840
INDIRF4
CNSTF4 1125515264
DIVF4
MULF4
CNSTF4 1058642330
ADDF4
ASGNF4
line 3843
;3843:		aim_accuracy *= f;
ADDRLP4 156
ADDRLP4 156
INDIRF4
ADDRLP4 940
INDIRF4
MULF4
ASGNF4
line 3844
;3844:	}
LABELV $1451
line 3846
;3845:	//add some random stuff to the aim direction depending on the aim accuracy
;3846:	if (aim_accuracy < 0.8) {
ADDRLP4 156
INDIRF4
CNSTF4 1061997773
GEF4 $1462
line 3847
;3847:		VectorNormalize(dir);
ADDRLP4 140
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 3848
;3848:		for (i = 0; i < 3; i++) dir[i] += 0.3 * crandom() * (1 - aim_accuracy);
ADDRLP4 152
CNSTI4 0
ASGNI4
LABELV $1464
ADDRLP4 1016
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 1020
ADDRLP4 152
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 140
ADDP4
ASGNP4
ADDRLP4 1020
INDIRP4
ADDRLP4 1020
INDIRP4
INDIRF4
CNSTF4 1050253722
CNSTF4 1073741824
ADDRLP4 1016
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 156
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
LABELV $1465
ADDRLP4 152
ADDRLP4 152
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 3
LTI4 $1464
line 3849
;3849:	}
LABELV $1462
line 3851
;3850:	//set the ideal view angles
;3851:	vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 140
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3853
;3852:	//take the weapon spread into account for lower skilled bots
;3853:	bs->ideal_viewangles[PITCH] += 6 * wi.vspread * crandom() * (1 - aim_accuracy);
ADDRLP4 1016
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 1020
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ASGNP4
ADDRLP4 1020
INDIRP4
ADDRLP4 1020
INDIRP4
INDIRF4
CNSTF4 1086324736
ADDRLP4 160+268
INDIRF4
MULF4
CNSTF4 1073741824
ADDRLP4 1016
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 156
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 3854
;3854:	bs->ideal_viewangles[PITCH] = AngleMod(bs->ideal_viewangles[PITCH]);
ADDRLP4 1024
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ASGNP4
ADDRLP4 1024
INDIRP4
INDIRF4
ARGF4
ADDRLP4 1028
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 1024
INDIRP4
ADDRLP4 1028
INDIRF4
ASGNF4
line 3855
;3855:	bs->ideal_viewangles[YAW] += 6 * wi.hspread * crandom() * (1 - aim_accuracy);
ADDRLP4 1032
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 1036
ADDRFP4 0
INDIRP4
CNSTI4 6580
ADDP4
ASGNP4
ADDRLP4 1036
INDIRP4
ADDRLP4 1036
INDIRP4
INDIRF4
CNSTF4 1086324736
ADDRLP4 160+264
INDIRF4
MULF4
CNSTF4 1073741824
ADDRLP4 1032
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 156
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 3856
;3856:	bs->ideal_viewangles[YAW] = AngleMod(bs->ideal_viewangles[YAW]);
ADDRLP4 1040
ADDRFP4 0
INDIRP4
CNSTI4 6580
ADDP4
ASGNP4
ADDRLP4 1040
INDIRP4
INDIRF4
ARGF4
ADDRLP4 1044
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 1040
INDIRP4
ADDRLP4 1044
INDIRF4
ASGNF4
line 3858
;3857:	//if the bots should be really challenging
;3858:	if (bot_challenge.integer) {
ADDRGP4 bot_challenge+12
INDIRI4
CNSTI4 0
EQI4 $1470
line 3860
;3859:		//if the bot is really accurate and has the enemy in view for some time
;3860:		if (aim_accuracy > 0.9 && bs->enemysight_time < FloatTime() - 1) {
ADDRLP4 156
INDIRF4
CNSTF4 1063675494
LEF4 $1473
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $1473
line 3862
;3861:			//set the view angles directly
;3862:			if (bs->ideal_viewangles[PITCH] > 180) bs->ideal_viewangles[PITCH] -= 360;
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
INDIRF4
CNSTF4 1127481344
LEF4 $1475
ADDRLP4 1048
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ASGNP4
ADDRLP4 1048
INDIRP4
ADDRLP4 1048
INDIRP4
INDIRF4
CNSTF4 1135869952
SUBF4
ASGNF4
LABELV $1475
line 3863
;3863:			VectorCopy(bs->ideal_viewangles, bs->viewangles);
ADDRLP4 1052
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1052
INDIRP4
CNSTI4 6564
ADDP4
ADDRLP4 1052
INDIRP4
CNSTI4 6576
ADDP4
INDIRB
ASGNB 12
line 3864
;3864:			trap_EA_View(bs->client, bs->viewangles);
ADDRLP4 1056
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1056
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 1056
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
ADDRGP4 trap_EA_View
CALLV
pop
line 3865
;3865:		}
LABELV $1473
line 3866
;3866:	}
LABELV $1470
line 3867
;3867:}
LABELV $1171
endproc BotAimAtEnemy 1144 52
lit
align 4
LABELV $1478
byte 4 3238002688
byte 4 3238002688
byte 4 3238002688
align 4
LABELV $1479
byte 4 1090519040
byte 4 1090519040
byte 4 1090519040
export BotCheckAttack
code
proc BotCheckAttack 1028 28
line 3874
;3868:
;3869:/*
;3870:==================
;3871:BotCheckAttack
;3872:==================
;3873:*/
;3874:void BotCheckAttack(bot_state_t *bs) {
line 3883
;3875:	float points, reactiontime, fov, firethrottle;
;3876:	int attackentity;
;3877:	bsp_trace_t bsptrace;
;3878:	//float selfpreservation;
;3879:	vec3_t forward, right, start, end, dir, angles;
;3880:	weaponinfo_t wi;
;3881:	bsp_trace_t trace;
;3882:	aas_entityinfo_t entinfo;
;3883:	vec3_t mins = {-8, -8, -8}, maxs = {8, 8, 8};
ADDRLP4 808
ADDRGP4 $1478
INDIRB
ASGNB 12
ADDRLP4 820
ADDRGP4 $1479
INDIRB
ASGNB 12
line 3885
;3884:
;3885:	attackentity = bs->enemy;
ADDRLP4 576
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 3887
;3886:	//
;3887:	BotEntityInfo(attackentity, &entinfo);
ADDRLP4 576
INDIRI4
ARGI4
ADDRLP4 832
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3889
;3888:	// if not attacking a player
;3889:	if (attackentity >= MAX_CLIENTS) {
ADDRLP4 576
INDIRI4
CNSTI4 64
LTI4 $1480
line 3901
;3890:#ifdef MISSIONPACK
;3891:		// if attacking an obelisk
;3892:		if ( entinfo.number == redobelisk.entitynum ||
;3893:			entinfo.number == blueobelisk.entitynum ) {
;3894:			// if obelisk is respawning return
;3895:			if ( g_entities[entinfo.number].activator &&
;3896:				g_entities[entinfo.number].activator->s.frame == 2 ) {
;3897:				return;
;3898:			}
;3899:		}
;3900:#endif
;3901:	}
LABELV $1480
line 3903
;3902:	//
;3903:	reactiontime = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_REACTIONTIME, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 6
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 976
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 700
ADDRLP4 976
INDIRF4
ASGNF4
line 3904
;3904:	if (bs->enemysight_time > FloatTime() - reactiontime) return;
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
ADDRLP4 700
INDIRF4
SUBF4
LEF4 $1482
ADDRGP4 $1477
JUMPV
LABELV $1482
line 3905
;3905:	if (bs->teleport_time > FloatTime() - reactiontime) return;
ADDRFP4 0
INDIRP4
CNSTI4 6180
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
ADDRLP4 700
INDIRF4
SUBF4
LEF4 $1484
ADDRGP4 $1477
JUMPV
LABELV $1484
line 3907
;3906:	//if changing weapons
;3907:	if (bs->weaponchange_time > FloatTime() - 0.1) return;
ADDRFP4 0
INDIRP4
CNSTI4 6192
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1036831949
SUBF4
LEF4 $1486
ADDRGP4 $1477
JUMPV
LABELV $1486
line 3909
;3908:	//check fire throttle characteristic
;3909:	if (bs->firethrottlewait_time > FloatTime()) return;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $1488
ADDRGP4 $1477
JUMPV
LABELV $1488
line 3910
;3910:	firethrottle = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_FIRETHROTTLE, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 47
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 980
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 792
ADDRLP4 980
INDIRF4
ASGNF4
line 3911
;3911:	if (bs->firethrottleshoot_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1490
line 3912
;3912:		if (random() > firethrottle) {
ADDRLP4 984
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 984
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 792
INDIRF4
LEF4 $1492
line 3913
;3913:			bs->firethrottlewait_time = FloatTime() + firethrottle;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 792
INDIRF4
ADDF4
ASGNF4
line 3914
;3914:			bs->firethrottleshoot_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
CNSTF4 0
ASGNF4
line 3915
;3915:		}
ADDRGP4 $1493
JUMPV
LABELV $1492
line 3916
;3916:		else {
line 3917
;3917:			bs->firethrottleshoot_time = FloatTime() + 1 - firethrottle;
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ADDRLP4 792
INDIRF4
SUBF4
ASGNF4
line 3918
;3918:			bs->firethrottlewait_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
CNSTF4 0
ASGNF4
line 3919
;3919:		}
LABELV $1493
line 3920
;3920:	}
LABELV $1490
line 3923
;3921:	//
;3922:	//
;3923:	VectorSubtract(bs->aimtarget, bs->eye, dir);
ADDRLP4 984
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 580
ADDRLP4 984
INDIRP4
CNSTI4 6220
ADDP4
INDIRF4
ADDRLP4 984
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 580+4
ADDRLP4 984
INDIRP4
CNSTI4 6224
ADDP4
INDIRF4
ADDRLP4 984
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 988
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 580+8
ADDRLP4 988
INDIRP4
CNSTI4 6228
ADDP4
INDIRF4
ADDRLP4 988
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 3925
;3924:	//
;3925:	if (bs->weaponnum == WP_GAUNTLET) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $1496
line 3926
;3926:		if (VectorLengthSquared(dir) > Square(60)) {
ADDRLP4 580
ARGP4
ADDRLP4 992
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 992
INDIRF4
CNSTF4 1163984896
LEF4 $1498
line 3927
;3927:			return;
ADDRGP4 $1477
JUMPV
LABELV $1498
line 3929
;3928:		}
;3929:	}
LABELV $1496
line 3930
;3930:	if (VectorLengthSquared(dir) < Square(100))
ADDRLP4 580
ARGP4
ADDRLP4 992
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 992
INDIRF4
CNSTF4 1176256512
GEF4 $1500
line 3931
;3931:		fov = 120;
ADDRLP4 788
CNSTF4 1123024896
ASGNF4
ADDRGP4 $1501
JUMPV
LABELV $1500
line 3933
;3932:	else
;3933:		fov = 50;
ADDRLP4 788
CNSTF4 1112014848
ASGNF4
LABELV $1501
line 3935
;3934:	//
;3935:	vectoangles(dir, angles);
ADDRLP4 580
ARGP4
ADDRLP4 796
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3936
;3936:	if (!InFieldOfVision(bs->viewangles, fov, angles))
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
ADDRLP4 788
INDIRF4
ARGF4
ADDRLP4 796
ARGP4
ADDRLP4 996
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 996
INDIRI4
CNSTI4 0
NEI4 $1502
line 3937
;3937:		return;
ADDRGP4 $1477
JUMPV
LABELV $1502
line 3938
;3938:	BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, bs->aimtarget, bs->client, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
ADDRLP4 704
ARGP4
ADDRLP4 1000
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1000
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 1004
CNSTP4 0
ASGNP4
ADDRLP4 1004
INDIRP4
ARGP4
ADDRLP4 1004
INDIRP4
ARGP4
ADDRLP4 1000
INDIRP4
CNSTI4 6220
ADDP4
ARGP4
ADDRLP4 1000
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 65537
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3939
;3939:	if (bsptrace.fraction < 1 && bsptrace.ent != attackentity)
ADDRLP4 704+8
INDIRF4
CNSTF4 1065353216
GEF4 $1504
ADDRLP4 704+80
INDIRI4
ADDRLP4 576
INDIRI4
EQI4 $1504
line 3940
;3940:		return;
ADDRGP4 $1477
JUMPV
LABELV $1504
line 3943
;3941:
;3942:	//get the weapon info
;3943:	trap_BotGetWeaponInfo(bs->ws, bs->weaponnum, &wi);
ADDRLP4 1008
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1008
INDIRP4
CNSTI4 6536
ADDP4
INDIRI4
ARGI4
ADDRLP4 1008
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ARGI4
ADDRLP4 24
ARGP4
ADDRGP4 trap_BotGetWeaponInfo
CALLV
pop
line 3945
;3944:	//get the start point shooting from
;3945:	VectorCopy(bs->origin, start);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 3946
;3946:	start[2] += bs->cur_ps.viewheight;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 3947
;3947:	AngleVectors(bs->viewangles, forward, right, NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 676
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 3948
;3948:	start[0] += forward[0] * wi.offset[0] + right[0] * wi.offset[1];
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 12
INDIRF4
ADDRLP4 24+292
INDIRF4
MULF4
ADDRLP4 676
INDIRF4
ADDRLP4 24+292+4
INDIRF4
MULF4
ADDF4
ADDF4
ASGNF4
line 3949
;3949:	start[1] += forward[1] * wi.offset[0] + right[1] * wi.offset[1];
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 12+4
INDIRF4
ADDRLP4 24+292
INDIRF4
MULF4
ADDRLP4 676+4
INDIRF4
ADDRLP4 24+292+4
INDIRF4
MULF4
ADDF4
ADDF4
ASGNF4
line 3950
;3950:	start[2] += forward[2] * wi.offset[0] + right[2] * wi.offset[1] + wi.offset[2];
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
ADDRLP4 12+8
INDIRF4
ADDRLP4 24+292
INDIRF4
MULF4
ADDRLP4 676+8
INDIRF4
ADDRLP4 24+292+4
INDIRF4
MULF4
ADDF4
ADDRLP4 24+292+8
INDIRF4
ADDF4
ADDF4
ASGNF4
line 3952
;3951:	//end point aiming at
;3952:	VectorMA(start, 1000, forward, end);
ADDRLP4 1012
CNSTF4 1148846080
ASGNF4
ADDRLP4 688
ADDRLP4 0
INDIRF4
ADDRLP4 1012
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 688+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 1012
INDIRF4
ADDRLP4 12+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 688+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1148846080
ADDRLP4 12+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 3954
;3953:	//a little back to make sure not inside a very close enemy
;3954:	VectorMA(start, -12, forward, start);
ADDRLP4 1016
CNSTF4 3242196992
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRF4
ADDRLP4 1016
INDIRF4
ADDRLP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 0+4
INDIRF4
ADDRLP4 1016
INDIRF4
ADDRLP4 12+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 3242196992
ADDRLP4 12+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 3955
;3955:	BotAI_Trace(&trace, start, mins, maxs, end, bs->entitynum, MASK_SHOT);
ADDRLP4 592
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 808
ARGP4
ADDRLP4 820
ARGP4
ADDRLP4 688
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 3957
;3956:	//if the entity is a client
;3957:	if (trace.ent > 0 && trace.ent <= MAX_CLIENTS) {
ADDRLP4 592+80
INDIRI4
CNSTI4 0
LEI4 $1538
ADDRLP4 592+80
INDIRI4
CNSTI4 64
GTI4 $1538
line 3958
;3958:		if (trace.ent != attackentity) {
ADDRLP4 592+80
INDIRI4
ADDRLP4 576
INDIRI4
EQI4 $1542
line 3960
;3959:			//if a teammate is hit
;3960:			if (BotSameTeam(bs, trace.ent))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 592+80
INDIRI4
ARGI4
ADDRLP4 1020
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 1020
INDIRI4
CNSTI4 0
EQI4 $1545
line 3961
;3961:				return;
ADDRGP4 $1477
JUMPV
LABELV $1545
line 3962
;3962:		}
LABELV $1542
line 3963
;3963:	}
LABELV $1538
line 3965
;3964:	//if won't hit the enemy or not attacking a player (obelisk)
;3965:	if (trace.ent != attackentity || attackentity >= MAX_CLIENTS) {
ADDRLP4 592+80
INDIRI4
ADDRLP4 576
INDIRI4
NEI4 $1551
ADDRLP4 576
INDIRI4
CNSTI4 64
LTI4 $1548
LABELV $1551
line 3967
;3966:		//if the projectile does radial damage
;3967:		if (wi.proj.damagetype & DAMAGETYPE_RADIAL) {
ADDRLP4 24+344+180
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1552
line 3968
;3968:			if (trace.fraction * 1000 < wi.proj.radius) {
CNSTF4 1148846080
ADDRLP4 592+8
INDIRF4
MULF4
ADDRLP4 24+344+172
INDIRF4
GEF4 $1556
line 3969
;3969:				points = (wi.proj.damage - 0.5 * trace.fraction * 1000) * 0.5;
ADDRLP4 1024
CNSTF4 1056964608
ASGNF4
ADDRLP4 972
ADDRLP4 1024
INDIRF4
ADDRLP4 24+344+168
INDIRI4
CVIF4 4
CNSTF4 1148846080
ADDRLP4 1024
INDIRF4
ADDRLP4 592+8
INDIRF4
MULF4
MULF4
SUBF4
MULF4
ASGNF4
line 3970
;3970:				if (points > 0) {
ADDRLP4 972
INDIRF4
CNSTF4 0
LEF4 $1564
line 3971
;3971:					return;
ADDRGP4 $1477
JUMPV
LABELV $1564
line 3973
;3972:				}
;3973:			}
LABELV $1556
line 3975
;3974:			//FIXME: check if a teammate gets radial damage
;3975:		}
LABELV $1552
line 3976
;3976:	}
LABELV $1548
line 3978
;3977:	//if fire has to be release to activate weapon
;3978:	if (wi.flags & WFL_FIRERELEASED) {
ADDRLP4 24+176
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $1566
line 3979
;3979:		if (bs->flags & BFL_ATTACKED) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1567
line 3980
;3980:			trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3981
;3981:		}
line 3982
;3982:	}
ADDRGP4 $1567
JUMPV
LABELV $1566
line 3983
;3983:	else {
line 3984
;3984:		trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3985
;3985:	}
LABELV $1567
line 3986
;3986:	bs->flags ^= BFL_ATTACKED;
ADDRLP4 1024
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 1024
INDIRP4
ADDRLP4 1024
INDIRP4
INDIRI4
CNSTI4 2
BXORI4
ASGNI4
line 3987
;3987:}
LABELV $1477
endproc BotCheckAttack 1028 28
lit
align 4
LABELV $1577
byte 4 1143930880
byte 4 1129054208
byte 4 1143472128
align 4
LABELV $1578
byte 4 1148256256
byte 4 1139408896
byte 4 1143603200
align 4
LABELV $1579
byte 4 1134034944
byte 4 1135607808
byte 4 1147535360
export BotMapScripts
code
proc BotMapScripts 1424 16
line 3994
;3988:
;3989:/*
;3990:==================
;3991:BotMapScripts
;3992:==================
;3993:*/
;3994:void BotMapScripts(bot_state_t *bs) {
line 4002
;3995:	char info[1024];
;3996:	char mapname[128];
;3997:	int i, shootbutton;
;3998:	float aim_accuracy;
;3999:	aas_entityinfo_t entinfo;
;4000:	vec3_t dir;
;4001:
;4002:	trap_GetServerinfo(info, sizeof(info));
ADDRLP4 272
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetServerinfo
CALLV
pop
line 4004
;4003:
;4004:	strncpy(mapname, Info_ValueForKey( info, "mapname" ), sizeof(mapname)-1);
ADDRLP4 272
ARGP4
ADDRGP4 $1572
ARGP4
ADDRLP4 1316
ADDRGP4 Info_ValueForKey
CALLP4
ASGNP4
ADDRLP4 144
ARGP4
ADDRLP4 1316
INDIRP4
ARGP4
CNSTI4 127
ARGI4
ADDRGP4 strncpy
CALLP4
pop
line 4005
;4005:	mapname[sizeof(mapname)-1] = '\0';
ADDRLP4 144+127
CNSTI1 0
ASGNI1
line 4007
;4006:
;4007:	if (!Q_stricmp(mapname, "q3tourney6")) {
ADDRLP4 144
ARGP4
ADDRGP4 $1576
ARGP4
ADDRLP4 1320
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1320
INDIRI4
CNSTI4 0
NEI4 $1574
line 4008
;4008:		vec3_t mins = {700, 204, 672}, maxs = {964, 468, 680};
ADDRLP4 1324
ADDRGP4 $1577
INDIRB
ASGNB 12
ADDRLP4 1336
ADDRGP4 $1578
INDIRB
ASGNB 12
line 4009
;4009:		vec3_t buttonorg = {304, 352, 920};
ADDRLP4 1348
ADDRGP4 $1579
INDIRB
ASGNB 12
line 4011
;4010:		//NOTE: NEVER use the func_bobbing in q3tourney6
;4011:		bs->tfl &= ~TFL_FUNCBOB;
ADDRLP4 1360
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 1360
INDIRP4
ADDRLP4 1360
INDIRP4
INDIRI4
CNSTI4 -16777217
BANDI4
ASGNI4
line 4013
;4012:		//if the bot is below the bounding box
;4013:		if (bs->origin[0] > mins[0] && bs->origin[0] < maxs[0]) {
ADDRLP4 1364
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ASGNF4
ADDRLP4 1364
INDIRF4
ADDRLP4 1324
INDIRF4
LEF4 $1580
ADDRLP4 1364
INDIRF4
ADDRLP4 1336
INDIRF4
GEF4 $1580
line 4014
;4014:			if (bs->origin[1] > mins[1] && bs->origin[1] < maxs[1]) {
ADDRLP4 1368
ADDRFP4 0
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ASGNF4
ADDRLP4 1368
INDIRF4
ADDRLP4 1324+4
INDIRF4
LEF4 $1582
ADDRLP4 1368
INDIRF4
ADDRLP4 1336+4
INDIRF4
GEF4 $1582
line 4015
;4015:				if (bs->origin[2] < mins[2]) {
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 1324+8
INDIRF4
GEF4 $1586
line 4016
;4016:					return;
ADDRGP4 $1571
JUMPV
LABELV $1586
line 4018
;4017:				}
;4018:			}
LABELV $1582
line 4019
;4019:		}
LABELV $1580
line 4020
;4020:		shootbutton = qfalse;
ADDRLP4 1296
CNSTI4 0
ASGNI4
line 4022
;4021:		//if an enemy is below this bounding box then shoot the button
;4022:		for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 140
CNSTI4 0
ASGNI4
ADDRGP4 $1592
JUMPV
LABELV $1589
line 4024
;4023:
;4024:			if (i == bs->client) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1593
ADDRGP4 $1590
JUMPV
LABELV $1593
line 4026
;4025:			//
;4026:			BotEntityInfo(i, &entinfo);
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 4028
;4027:			//
;4028:			if (!entinfo.valid) continue;
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1595
ADDRGP4 $1590
JUMPV
LABELV $1595
line 4030
;4029:			//if the enemy isn't dead and the enemy isn't the bot self
;4030:			if (EntityIsDead(&entinfo) || entinfo.number == bs->entitynum) continue;
ADDRLP4 0
ARGP4
ADDRLP4 1368
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 1368
INDIRI4
CNSTI4 0
NEI4 $1600
ADDRLP4 0+20
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $1597
LABELV $1600
ADDRGP4 $1590
JUMPV
LABELV $1597
line 4032
;4031:			//
;4032:			if (entinfo.origin[0] > mins[0] && entinfo.origin[0] < maxs[0]) {
ADDRLP4 0+24
INDIRF4
ADDRLP4 1324
INDIRF4
LEF4 $1601
ADDRLP4 0+24
INDIRF4
ADDRLP4 1336
INDIRF4
GEF4 $1601
line 4033
;4033:				if (entinfo.origin[1] > mins[1] && entinfo.origin[1] < maxs[1]) {
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1324+4
INDIRF4
LEF4 $1605
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1336+4
INDIRF4
GEF4 $1605
line 4034
;4034:					if (entinfo.origin[2] < mins[2]) {
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 1324+8
INDIRF4
GEF4 $1613
line 4036
;4035:						//if there's a team mate below the crusher
;4036:						if (BotSameTeam(bs, i)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 1372
ADDRGP4 BotSameTeam
CALLI4
ASGNI4
ADDRLP4 1372
INDIRI4
CNSTI4 0
EQI4 $1618
line 4037
;4037:							shootbutton = qfalse;
ADDRLP4 1296
CNSTI4 0
ASGNI4
line 4038
;4038:							break;
ADDRGP4 $1591
JUMPV
LABELV $1618
line 4040
;4039:						}
;4040:						else {
line 4041
;4041:							shootbutton = qtrue;
ADDRLP4 1296
CNSTI4 1
ASGNI4
line 4042
;4042:						}
line 4043
;4043:					}
LABELV $1613
line 4044
;4044:				}
LABELV $1605
line 4045
;4045:			}
LABELV $1601
line 4046
;4046:		}
LABELV $1590
line 4022
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1592
ADDRLP4 140
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1620
ADDRLP4 140
INDIRI4
CNSTI4 64
LTI4 $1589
LABELV $1620
LABELV $1591
line 4047
;4047:		if (shootbutton) {
ADDRLP4 1296
INDIRI4
CNSTI4 0
EQI4 $1575
line 4048
;4048:			bs->flags |= BFL_IDEALVIEWSET;
ADDRLP4 1372
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 1372
INDIRP4
ADDRLP4 1372
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 4049
;4049:			VectorSubtract(buttonorg, bs->eye, dir);
ADDRLP4 1376
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1300
ADDRLP4 1348
INDIRF4
ADDRLP4 1376
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 1300+4
ADDRLP4 1348+4
INDIRF4
ADDRLP4 1376
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 1300+8
ADDRLP4 1348+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 4050
;4050:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 1300
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 4051
;4051:			aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 7
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 1380
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 1312
ADDRLP4 1380
INDIRF4
ASGNF4
line 4052
;4052:			bs->ideal_viewangles[PITCH] += 8 * crandom() * (1 - aim_accuracy);
ADDRLP4 1384
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 1388
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ASGNP4
ADDRLP4 1388
INDIRP4
ADDRLP4 1388
INDIRP4
INDIRF4
CNSTF4 1090519040
CNSTF4 1073741824
ADDRLP4 1384
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 1312
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 4053
;4053:			bs->ideal_viewangles[PITCH] = AngleMod(bs->ideal_viewangles[PITCH]);
ADDRLP4 1392
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ASGNP4
ADDRLP4 1392
INDIRP4
INDIRF4
ARGF4
ADDRLP4 1396
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 1392
INDIRP4
ADDRLP4 1396
INDIRF4
ASGNF4
line 4054
;4054:			bs->ideal_viewangles[YAW] += 8 * crandom() * (1 - aim_accuracy);
ADDRLP4 1400
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 1404
ADDRFP4 0
INDIRP4
CNSTI4 6580
ADDP4
ASGNP4
ADDRLP4 1404
INDIRP4
ADDRLP4 1404
INDIRP4
INDIRF4
CNSTF4 1090519040
CNSTF4 1073741824
ADDRLP4 1400
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
CNSTF4 1065353216
ADDRLP4 1312
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
line 4055
;4055:			bs->ideal_viewangles[YAW] = AngleMod(bs->ideal_viewangles[YAW]);
ADDRLP4 1408
ADDRFP4 0
INDIRP4
CNSTI4 6580
ADDP4
ASGNP4
ADDRLP4 1408
INDIRP4
INDIRF4
ARGF4
ADDRLP4 1412
ADDRGP4 AngleMod
CALLF4
ASGNF4
ADDRLP4 1408
INDIRP4
ADDRLP4 1412
INDIRF4
ASGNF4
line 4057
;4056:			//
;4057:			if (InFieldOfVision(bs->viewangles, 20, bs->ideal_viewangles)) {
ADDRLP4 1416
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1416
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1101004800
ARGF4
ADDRLP4 1416
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRLP4 1420
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 1420
INDIRI4
CNSTI4 0
EQI4 $1575
line 4058
;4058:				trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 4059
;4059:			}
line 4060
;4060:		}
line 4061
;4061:	}
ADDRGP4 $1575
JUMPV
LABELV $1574
line 4062
;4062:	else if (!Q_stricmp(mapname, "mpq3tourney6")) {
ADDRLP4 144
ARGP4
ADDRGP4 $1631
ARGP4
ADDRLP4 1324
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1324
INDIRI4
CNSTI4 0
NEI4 $1629
line 4064
;4063:		//NOTE: NEVER use the func_bobbing in mpq3tourney6
;4064:		bs->tfl &= ~TFL_FUNCBOB;
ADDRLP4 1328
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 1328
INDIRP4
ADDRLP4 1328
INDIRP4
INDIRI4
CNSTI4 -16777217
BANDI4
ASGNI4
line 4065
;4065:	}
LABELV $1629
LABELV $1575
line 4066
;4066:}
LABELV $1571
endproc BotMapScripts 1424 16
data
align 4
LABELV VEC_UP
byte 4 0
byte 4 3212836864
byte 4 0
align 4
LABELV MOVEDIR_UP
byte 4 0
byte 4 0
byte 4 1065353216
align 4
LABELV VEC_DOWN
byte 4 0
byte 4 3221225472
byte 4 0
align 4
LABELV MOVEDIR_DOWN
byte 4 0
byte 4 0
byte 4 3212836864
export BotSetMovedir
code
proc BotSetMovedir 12 16
line 4079
;4067:
;4068:/*
;4069:==================
;4070:BotSetMovedir
;4071:==================
;4072:*/
;4073:// bk001205 - made these static
;4074:static vec3_t VEC_UP		= {0, -1,  0};
;4075:static vec3_t MOVEDIR_UP	= {0,  0,  1};
;4076:static vec3_t VEC_DOWN		= {0, -2,  0};
;4077:static vec3_t MOVEDIR_DOWN	= {0,  0, -1};
;4078:
;4079:void BotSetMovedir(vec3_t angles, vec3_t movedir) {
line 4080
;4080:	if (VectorCompare(angles, VEC_UP)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 VEC_UP
ARGP4
ADDRLP4 0
ADDRGP4 VectorCompare
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1633
line 4081
;4081:		VectorCopy(MOVEDIR_UP, movedir);
ADDRFP4 4
INDIRP4
ADDRGP4 MOVEDIR_UP
INDIRB
ASGNB 12
line 4082
;4082:	}
ADDRGP4 $1634
JUMPV
LABELV $1633
line 4083
;4083:	else if (VectorCompare(angles, VEC_DOWN)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 VEC_DOWN
ARGP4
ADDRLP4 4
ADDRGP4 VectorCompare
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $1635
line 4084
;4084:		VectorCopy(MOVEDIR_DOWN, movedir);
ADDRFP4 4
INDIRP4
ADDRGP4 MOVEDIR_DOWN
INDIRB
ASGNB 12
line 4085
;4085:	}
ADDRGP4 $1636
JUMPV
LABELV $1635
line 4086
;4086:	else {
line 4087
;4087:		AngleVectors(angles, movedir, NULL, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 8
CNSTP4 0
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 4088
;4088:	}
LABELV $1636
LABELV $1634
line 4089
;4089:}
LABELV $1632
endproc BotSetMovedir 12 16
export BotModelMinsMaxs
proc BotModelMinsMaxs 40 0
line 4098
;4090:
;4091:/*
;4092:==================
;4093:BotModelMinsMaxs
;4094:
;4095:this is ugly
;4096:==================
;4097:*/
;4098:int BotModelMinsMaxs(int modelindex, int eType, int contents, vec3_t mins, vec3_t maxs) {
line 4102
;4099:	gentity_t *ent;
;4100:	int i;
;4101:
;4102:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 4103
;4103:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1641
JUMPV
LABELV $1638
line 4104
;4104:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1643
line 4105
;4105:			continue;
ADDRGP4 $1639
JUMPV
LABELV $1643
line 4107
;4106:		}
;4107:		if ( eType && ent->s.eType != eType) {
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $1645
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
EQI4 $1645
line 4108
;4108:			continue;
ADDRGP4 $1639
JUMPV
LABELV $1645
line 4110
;4109:		}
;4110:		if ( contents && ent->r.contents != contents) {
ADDRLP4 12
ADDRFP4 8
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $1647
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $1647
line 4111
;4111:			continue;
ADDRGP4 $1639
JUMPV
LABELV $1647
line 4113
;4112:		}
;4113:		if (ent->s.modelindex == modelindex) {
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $1649
line 4114
;4114:			if (mins)
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1651
line 4115
;4115:				VectorAdd(ent->r.currentOrigin, ent->r.mins, mins);
ADDRFP4 12
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 436
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRFP4 12
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 440
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRFP4 12
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 444
ADDP4
INDIRF4
ADDF4
ASGNF4
LABELV $1651
line 4116
;4116:			if (maxs)
ADDRFP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1653
line 4117
;4117:				VectorAdd(ent->r.currentOrigin, ent->r.maxs, maxs);
ADDRFP4 16
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 448
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRFP4 16
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 492
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 452
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRFP4 16
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 456
ADDP4
INDIRF4
ADDF4
ASGNF4
LABELV $1653
line 4118
;4118:			return i;
ADDRLP4 4
INDIRI4
RETI4
ADDRGP4 $1637
JUMPV
LABELV $1649
line 4120
;4119:		}
;4120:	}
LABELV $1639
line 4103
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 884
ADDP4
ASGNP4
LABELV $1641
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $1638
line 4121
;4121:	if (mins)
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1655
line 4122
;4122:		VectorClear(mins);
ADDRLP4 8
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 12
CNSTF4 0
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 8
INDIRP4
ADDRLP4 12
INDIRF4
ASGNF4
LABELV $1655
line 4123
;4123:	if (maxs)
ADDRFP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1657
line 4124
;4124:		VectorClear(maxs);
ADDRLP4 16
ADDRFP4 16
INDIRP4
ASGNP4
ADDRLP4 20
CNSTF4 0
ASGNF4
ADDRLP4 16
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
ADDRLP4 16
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
ADDRLP4 16
INDIRP4
ADDRLP4 20
INDIRF4
ASGNF4
LABELV $1657
line 4125
;4125:	return 0;
CNSTI4 0
RETI4
LABELV $1637
endproc BotModelMinsMaxs 40 0
lit
align 4
LABELV $1660
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
align 4
LABELV $1661
byte 4 3212836864
byte 4 3212836864
byte 4 3212836864
export BotFuncButtonActivateGoal
code
proc BotFuncButtonActivateGoal 648 28
line 4133
;4126:}
;4127:
;4128:/*
;4129:==================
;4130:BotFuncButtonGoal
;4131:==================
;4132:*/
;4133:int BotFuncButtonActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4139
;4134:	int i, areas[10], numareas, modelindex, entitynum;
;4135:	char model[128];
;4136:	float lip, dist, health, angle;
;4137:	vec3_t size, start, end, mins, maxs, angles, points[10];
;4138:	vec3_t movedir, origin, goalorigin, bboxmins, bboxmaxs;
;4139:	vec3_t extramins = {1, 1, 1}, extramaxs = {-1, -1, -1};
ADDRLP4 304
ADDRGP4 $1660
INDIRB
ASGNB 12
ADDRLP4 316
ADDRGP4 $1661
INDIRB
ASGNB 12
line 4142
;4140:	bsp_trace_t bsptrace;
;4141:
;4142:	activategoal->shoot = qfalse;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 0
ASGNI4
line 4143
;4143:	VectorClear(activategoal->target);
ADDRLP4 560
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 564
CNSTF4 0
ASGNF4
ADDRLP4 560
INDIRP4
CNSTI4 88
ADDP4
ADDRLP4 564
INDIRF4
ASGNF4
ADDRLP4 560
INDIRP4
CNSTI4 84
ADDP4
ADDRLP4 564
INDIRF4
ASGNF4
ADDRLP4 560
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 564
INDIRF4
ASGNF4
line 4145
;4144:	//create a bot goal towards the button
;4145:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $291
ARGP4
ADDRLP4 160
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4146
;4146:	if (!*model)
ADDRLP4 160
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1662
line 4147
;4147:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1659
JUMPV
LABELV $1662
line 4148
;4148:	modelindex = atoi(model+1);
ADDRLP4 160+1
ARGP4
ADDRLP4 568
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 288
ADDRLP4 568
INDIRI4
ASGNI4
line 4149
;4149:	if (!modelindex)
ADDRLP4 288
INDIRI4
CNSTI4 0
NEI4 $1665
line 4150
;4150:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1659
JUMPV
LABELV $1665
line 4151
;4151:	VectorClear(angles);
ADDRLP4 572
CNSTF4 0
ASGNF4
ADDRLP4 96+8
ADDRLP4 572
INDIRF4
ASGNF4
ADDRLP4 96+4
ADDRLP4 572
INDIRF4
ASGNF4
ADDRLP4 96
ADDRLP4 572
INDIRF4
ASGNF4
line 4152
;4152:	entitynum = BotModelMinsMaxs(modelindex, ET_MOVER, 0, mins, maxs);
ADDRLP4 288
INDIRI4
ARGI4
CNSTI4 4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 72
ARGP4
ADDRLP4 84
ARGP4
ADDRLP4 576
ADDRGP4 BotModelMinsMaxs
CALLI4
ASGNI4
ADDRLP4 344
ADDRLP4 576
INDIRI4
ASGNI4
line 4154
;4153:	//get the lip of the button
;4154:	trap_AAS_FloatForBSPEpairKey(bspent, "lip", &lip);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1669
ARGP4
ADDRLP4 328
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 4155
;4155:	if (!lip) lip = 4;
ADDRLP4 328
INDIRF4
CNSTF4 0
NEF4 $1670
ADDRLP4 328
CNSTF4 1082130432
ASGNF4
LABELV $1670
line 4157
;4156:	//get the move direction from the angle
;4157:	trap_AAS_FloatForBSPEpairKey(bspent, "angle", &angle);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1672
ARGP4
ADDRLP4 352
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 4158
;4158:	VectorSet(angles, 0, angle, 0);
ADDRLP4 96
CNSTF4 0
ASGNF4
ADDRLP4 96+4
ADDRLP4 352
INDIRF4
ASGNF4
ADDRLP4 96+8
CNSTF4 0
ASGNF4
line 4159
;4159:	BotSetMovedir(angles, movedir);
ADDRLP4 96
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 BotSetMovedir
CALLV
pop
line 4161
;4160:	//button size
;4161:	VectorSubtract(maxs, mins, size);
ADDRLP4 112
ADDRLP4 84
INDIRF4
ADDRLP4 72
INDIRF4
SUBF4
ASGNF4
ADDRLP4 112+4
ADDRLP4 84+4
INDIRF4
ADDRLP4 72+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 112+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 72+8
INDIRF4
SUBF4
ASGNF4
line 4163
;4162:	//button origin
;4163:	VectorAdd(mins, maxs, origin);
ADDRLP4 16
ADDRLP4 72
INDIRF4
ADDRLP4 84
INDIRF4
ADDF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 72+4
INDIRF4
ADDRLP4 84+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 16+8
ADDRLP4 72+8
INDIRF4
ADDRLP4 84+8
INDIRF4
ADDF4
ASGNF4
line 4164
;4164:	VectorScale(origin, 0.5, origin);
ADDRLP4 580
CNSTF4 1056964608
ASGNF4
ADDRLP4 16
ADDRLP4 580
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
ASGNF4
ADDRLP4 16+4
ADDRLP4 580
INDIRF4
ADDRLP4 16+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 16+8
CNSTF4 1056964608
ADDRLP4 16+8
INDIRF4
MULF4
ASGNF4
line 4166
;4165:	//touch distance of the button
;4166:	dist = fabs(movedir[0]) * size[0] + fabs(movedir[1]) * size[1] + fabs(movedir[2]) * size[2];
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 584
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 4+4
INDIRF4
ARGF4
ADDRLP4 588
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 4+8
INDIRF4
ARGF4
ADDRLP4 592
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 28
ADDRLP4 584
INDIRF4
ADDRLP4 112
INDIRF4
MULF4
ADDRLP4 588
INDIRF4
ADDRLP4 112+4
INDIRF4
MULF4
ADDF4
ADDRLP4 592
INDIRF4
ADDRLP4 112+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 4167
;4167:	dist *= 0.5;
ADDRLP4 28
CNSTF4 1056964608
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 4169
;4168:	//
;4169:	trap_AAS_FloatForBSPEpairKey(bspent, "health", &health);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1695
ARGP4
ADDRLP4 348
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 4171
;4170:	//if the button is shootable
;4171:	if (health) {
ADDRLP4 348
INDIRF4
CNSTF4 0
EQF4 $1696
line 4173
;4172:		//calculate the shoot target
;4173:		VectorMA(origin, -dist, movedir, goalorigin);
ADDRLP4 596
ADDRLP4 28
INDIRF4
NEGF4
ASGNF4
ADDRLP4 124
ADDRLP4 16
INDIRF4
ADDRLP4 4
INDIRF4
ADDRLP4 596
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 16+4
INDIRF4
ADDRLP4 4+4
INDIRF4
ADDRLP4 596
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 16+8
INDIRF4
ADDRLP4 4+8
INDIRF4
ADDRLP4 28
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 4175
;4174:		//
;4175:		VectorCopy(goalorigin, activategoal->target);
ADDRFP4 8
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 124
INDIRB
ASGNB 12
line 4176
;4176:		activategoal->shoot = qtrue;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 1
ASGNI4
line 4178
;4177:		//
;4178:		BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, goalorigin, bs->entitynum, MASK_SHOT);
ADDRLP4 356
ARGP4
ADDRLP4 600
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 600
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 604
CNSTP4 0
ASGNP4
ADDRLP4 604
INDIRP4
ARGP4
ADDRLP4 604
INDIRP4
ARGP4
ADDRLP4 124
ARGP4
ADDRLP4 600
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 100663297
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 4180
;4179:		// if the button is visible from the current position
;4180:		if (bsptrace.fraction >= 1.0 || bsptrace.ent == entitynum) {
ADDRLP4 356+8
INDIRF4
CNSTF4 1065353216
GEF4 $1708
ADDRLP4 356+80
INDIRI4
ADDRLP4 344
INDIRI4
NEI4 $1704
LABELV $1708
line 4182
;4181:			//
;4182:			activategoal->goal.entitynum = entitynum; //NOTE: this is the entity number of the shootable button
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 4183
;4183:			activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4184
;4184:			activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4185
;4185:			VectorCopy(bs->origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 4186
;4186:			activategoal->goal.areanum = bs->areanum;
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ASGNI4
line 4187
;4187:			VectorSet(activategoal->goal.mins, -8, -8, -8);
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 3238002688
ASGNF4
line 4188
;4188:			VectorSet(activategoal->goal.maxs, 8, 8, 8);
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 1090519040
ASGNF4
line 4190
;4189:			//
;4190:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1659
JUMPV
LABELV $1704
line 4192
;4191:		}
;4192:		else {
line 4195
;4193:			//create a goal from where the button is visible and shoot at the button from there
;4194:			//add bounding box size to the dist
;4195:			trap_AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bboxmins, bboxmaxs);
CNSTI4 4
ARGI4
ADDRLP4 136
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 trap_AAS_PresenceTypeBoundingBox
CALLV
pop
line 4196
;4196:			for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1709
line 4197
;4197:				if (movedir[i] < 0) dist += fabs(movedir[i]) * fabs(bboxmaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1713
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 608
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 148
ADDP4
INDIRF4
ARGF4
ADDRLP4 612
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 28
ADDRLP4 28
INDIRF4
ADDRLP4 608
INDIRF4
ADDRLP4 612
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 $1714
JUMPV
LABELV $1713
line 4198
;4198:				else dist += fabs(movedir[i]) * fabs(bboxmins[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 616
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 136
ADDP4
INDIRF4
ARGF4
ADDRLP4 620
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 28
ADDRLP4 28
INDIRF4
ADDRLP4 616
INDIRF4
ADDRLP4 620
INDIRF4
MULF4
ADDF4
ASGNF4
LABELV $1714
line 4199
;4199:			}
LABELV $1710
line 4196
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1709
line 4201
;4200:			//calculate the goal origin
;4201:			VectorMA(origin, -dist, movedir, goalorigin);
ADDRLP4 608
ADDRLP4 28
INDIRF4
NEGF4
ASGNF4
ADDRLP4 124
ADDRLP4 16
INDIRF4
ADDRLP4 4
INDIRF4
ADDRLP4 608
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 16+4
INDIRF4
ADDRLP4 4+4
INDIRF4
ADDRLP4 608
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 16+8
INDIRF4
ADDRLP4 4+8
INDIRF4
ADDRLP4 28
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 4203
;4202:			//
;4203:			VectorCopy(goalorigin, start);
ADDRLP4 292
ADDRLP4 124
INDIRB
ASGNB 12
line 4204
;4204:			start[2] += 24;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 4205
;4205:			VectorCopy(start, end);
ADDRLP4 332
ADDRLP4 292
INDIRB
ASGNB 12
line 4206
;4206:			end[2] -= 512;
ADDRLP4 332+8
ADDRLP4 332+8
INDIRF4
CNSTF4 1140850688
SUBF4
ASGNF4
line 4207
;4207:			numareas = trap_AAS_TraceAreas(start, end, areas, points, 10);
ADDRLP4 292
ARGP4
ADDRLP4 332
ARGP4
ADDRLP4 32
ARGP4
ADDRLP4 440
ARGP4
CNSTI4 10
ARGI4
ADDRLP4 612
ADDRGP4 trap_AAS_TraceAreas
CALLI4
ASGNI4
ADDRLP4 108
ADDRLP4 612
INDIRI4
ASGNI4
line 4209
;4208:			//
;4209:			for (i = numareas-1; i >= 0; i--) {
ADDRLP4 0
ADDRLP4 108
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $1726
JUMPV
LABELV $1723
line 4210
;4210:				if (trap_AAS_AreaReachability(areas[i])) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 32
ADDP4
INDIRI4
ARGI4
ADDRLP4 616
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 616
INDIRI4
CNSTI4 0
EQI4 $1727
line 4211
;4211:					break;
ADDRGP4 $1725
JUMPV
LABELV $1727
line 4213
;4212:				}
;4213:			}
LABELV $1724
line 4209
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $1726
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1723
LABELV $1725
line 4214
;4214:			if (i < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1729
line 4216
;4215:				// FIXME: trace forward and maybe in other directions to find a valid area
;4216:			}
LABELV $1729
line 4217
;4217:			if (i >= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $1731
line 4219
;4218:				//
;4219:				VectorCopy(points[i], activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 440
ADDP4
INDIRB
ASGNB 12
line 4220
;4220:				activategoal->goal.areanum = areas[i];
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 32
ADDP4
INDIRI4
ASGNI4
line 4221
;4221:				VectorSet(activategoal->goal.mins, 8, 8, 8);
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1090519040
ASGNF4
line 4222
;4222:				VectorSet(activategoal->goal.maxs, -8, -8, -8);
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 3238002688
ASGNF4
line 4224
;4223:				//
;4224:				for (i = 0; i < 3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1733
line 4225
;4225:				{
line 4226
;4226:					if (movedir[i] < 0) activategoal->goal.maxs[i] += fabs(movedir[i]) * fabs(extramaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1737
ADDRLP4 616
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 616
INDIRI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 620
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 316
ADDP4
INDIRF4
ARGF4
ADDRLP4 624
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 628
ADDRLP4 616
INDIRI4
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
ADDP4
ASGNP4
ADDRLP4 628
INDIRP4
ADDRLP4 628
INDIRP4
INDIRF4
ADDRLP4 620
INDIRF4
ADDRLP4 624
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 $1738
JUMPV
LABELV $1737
line 4227
;4227:					else activategoal->goal.mins[i] += fabs(movedir[i]) * fabs(extramins[i]);
ADDRLP4 632
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 632
INDIRI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 636
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 304
ADDP4
INDIRF4
ARGF4
ADDRLP4 640
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 644
ADDRLP4 632
INDIRI4
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
ADDP4
ASGNP4
ADDRLP4 644
INDIRP4
ADDRLP4 644
INDIRP4
INDIRF4
ADDRLP4 636
INDIRF4
ADDRLP4 640
INDIRF4
MULF4
ADDF4
ASGNF4
LABELV $1738
line 4228
;4228:				} //end for
LABELV $1734
line 4224
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1733
line 4230
;4229:				//
;4230:				activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 4231
;4231:				activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4232
;4232:				activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4233
;4233:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1659
JUMPV
LABELV $1731
line 4235
;4234:			}
;4235:		}
line 4236
;4236:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1659
JUMPV
LABELV $1696
line 4238
;4237:	}
;4238:	else {
line 4240
;4239:		//add bounding box size to the dist
;4240:		trap_AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bboxmins, bboxmaxs);
CNSTI4 4
ARGI4
ADDRLP4 136
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 trap_AAS_PresenceTypeBoundingBox
CALLV
pop
line 4241
;4241:		for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1739
line 4242
;4242:			if (movedir[i] < 0) dist += fabs(movedir[i]) * fabs(bboxmaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1743
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 596
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 148
ADDP4
INDIRF4
ARGF4
ADDRLP4 600
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 28
ADDRLP4 28
INDIRF4
ADDRLP4 596
INDIRF4
ADDRLP4 600
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 $1744
JUMPV
LABELV $1743
line 4243
;4243:			else dist += fabs(movedir[i]) * fabs(bboxmins[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 604
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 136
ADDP4
INDIRF4
ARGF4
ADDRLP4 608
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 28
ADDRLP4 28
INDIRF4
ADDRLP4 604
INDIRF4
ADDRLP4 608
INDIRF4
MULF4
ADDF4
ASGNF4
LABELV $1744
line 4244
;4244:		}
LABELV $1740
line 4241
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1739
line 4246
;4245:		//calculate the goal origin
;4246:		VectorMA(origin, -dist, movedir, goalorigin);
ADDRLP4 596
ADDRLP4 28
INDIRF4
NEGF4
ASGNF4
ADDRLP4 124
ADDRLP4 16
INDIRF4
ADDRLP4 4
INDIRF4
ADDRLP4 596
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 16+4
INDIRF4
ADDRLP4 4+4
INDIRF4
ADDRLP4 596
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 16+8
INDIRF4
ADDRLP4 4+8
INDIRF4
ADDRLP4 28
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
line 4248
;4247:		//
;4248:		VectorCopy(goalorigin, start);
ADDRLP4 292
ADDRLP4 124
INDIRB
ASGNB 12
line 4249
;4249:		start[2] += 24;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 4250
;4250:		VectorCopy(start, end);
ADDRLP4 332
ADDRLP4 292
INDIRB
ASGNB 12
line 4251
;4251:		end[2] -= 100;
ADDRLP4 332+8
ADDRLP4 332+8
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
line 4252
;4252:		numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
ADDRLP4 292
ARGP4
ADDRLP4 332
ARGP4
ADDRLP4 32
ARGP4
CNSTP4 0
ARGP4
CNSTI4 10
ARGI4
ADDRLP4 600
ADDRGP4 trap_AAS_TraceAreas
CALLI4
ASGNI4
ADDRLP4 108
ADDRLP4 600
INDIRI4
ASGNI4
line 4254
;4253:		//
;4254:		for (i = 0; i < numareas; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1756
JUMPV
LABELV $1753
line 4255
;4255:			if (trap_AAS_AreaReachability(areas[i])) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 32
ADDP4
INDIRI4
ARGI4
ADDRLP4 604
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 604
INDIRI4
CNSTI4 0
EQI4 $1757
line 4256
;4256:				break;
ADDRGP4 $1755
JUMPV
LABELV $1757
line 4258
;4257:			}
;4258:		}
LABELV $1754
line 4254
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1756
ADDRLP4 0
INDIRI4
ADDRLP4 108
INDIRI4
LTI4 $1753
LABELV $1755
line 4259
;4259:		if (i < numareas) {
ADDRLP4 0
INDIRI4
ADDRLP4 108
INDIRI4
GEI4 $1759
line 4261
;4260:			//
;4261:			VectorCopy(origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 16
INDIRB
ASGNB 12
line 4262
;4262:			activategoal->goal.areanum = areas[i];
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 32
ADDP4
INDIRI4
ASGNI4
line 4263
;4263:			VectorSubtract(mins, origin, activategoal->goal.mins);
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 72
INDIRF4
ADDRLP4 16
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 72+4
INDIRF4
ADDRLP4 16+4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 72+8
INDIRF4
ADDRLP4 16+8
INDIRF4
SUBF4
ASGNF4
line 4264
;4264:			VectorSubtract(maxs, origin, activategoal->goal.maxs);
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
ADDRLP4 84
INDIRF4
ADDRLP4 16
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 84+4
INDIRF4
ADDRLP4 16+4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 84+8
INDIRF4
ADDRLP4 16+8
INDIRF4
SUBF4
ASGNF4
line 4266
;4265:			//
;4266:			for (i = 0; i < 3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1769
line 4267
;4267:			{
line 4268
;4268:				if (movedir[i] < 0) activategoal->goal.maxs[i] += fabs(movedir[i]) * fabs(extramaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1773
ADDRLP4 604
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 604
INDIRI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 608
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 316
ADDP4
INDIRF4
ARGF4
ADDRLP4 612
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 616
ADDRLP4 604
INDIRI4
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
ADDP4
ASGNP4
ADDRLP4 616
INDIRP4
ADDRLP4 616
INDIRP4
INDIRF4
ADDRLP4 608
INDIRF4
ADDRLP4 612
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRGP4 $1774
JUMPV
LABELV $1773
line 4269
;4269:				else activategoal->goal.mins[i] += fabs(movedir[i]) * fabs(extramins[i]);
ADDRLP4 620
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ASGNI4
ADDRLP4 620
INDIRI4
ADDRLP4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 624
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 304
ADDP4
INDIRF4
ARGF4
ADDRLP4 628
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 632
ADDRLP4 620
INDIRI4
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
ADDP4
ASGNP4
ADDRLP4 632
INDIRP4
ADDRLP4 632
INDIRP4
INDIRF4
ADDRLP4 624
INDIRF4
ADDRLP4 628
INDIRF4
MULF4
ADDF4
ASGNF4
LABELV $1774
line 4270
;4270:			} //end for
LABELV $1770
line 4266
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1769
line 4272
;4271:			//
;4272:			activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 4273
;4273:			activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4274
;4274:			activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4275
;4275:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1659
JUMPV
LABELV $1759
line 4277
;4276:		}
;4277:	}
line 4278
;4278:	return qfalse;
CNSTI4 0
RETI4
LABELV $1659
endproc BotFuncButtonActivateGoal 648 28
export BotFuncDoorActivateGoal
proc BotFuncDoorActivateGoal 1096 20
line 4286
;4279:}
;4280:
;4281:/*
;4282:==================
;4283:BotFuncDoorGoal
;4284:==================
;4285:*/
;4286:int BotFuncDoorActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4292
;4287:	int modelindex, entitynum;
;4288:	char model[MAX_INFO_STRING];
;4289:	vec3_t mins, maxs, origin, angles;
;4290:
;4291:	//shoot at the shootable door
;4292:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $291
ARGP4
ADDRLP4 12
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4293
;4293:	if (!*model)
ADDRLP4 12
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1776
line 4294
;4294:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1775
JUMPV
LABELV $1776
line 4295
;4295:	modelindex = atoi(model+1);
ADDRLP4 12+1
ARGP4
ADDRLP4 1080
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 1060
ADDRLP4 1080
INDIRI4
ASGNI4
line 4296
;4296:	if (!modelindex)
ADDRLP4 1060
INDIRI4
CNSTI4 0
NEI4 $1779
line 4297
;4297:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1775
JUMPV
LABELV $1779
line 4298
;4298:	VectorClear(angles);
ADDRLP4 1084
CNSTF4 0
ASGNF4
ADDRLP4 1064+8
ADDRLP4 1084
INDIRF4
ASGNF4
ADDRLP4 1064+4
ADDRLP4 1084
INDIRF4
ASGNF4
ADDRLP4 1064
ADDRLP4 1084
INDIRF4
ASGNF4
line 4299
;4299:	entitynum = BotModelMinsMaxs(modelindex, ET_MOVER, 0, mins, maxs);
ADDRLP4 1060
INDIRI4
ARGI4
CNSTI4 4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 1036
ARGP4
ADDRLP4 1048
ARGP4
ADDRLP4 1088
ADDRGP4 BotModelMinsMaxs
CALLI4
ASGNI4
ADDRLP4 1076
ADDRLP4 1088
INDIRI4
ASGNI4
line 4301
;4300:	//door origin
;4301:	VectorAdd(mins, maxs, origin);
ADDRLP4 0
ADDRLP4 1036
INDIRF4
ADDRLP4 1048
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 1036+4
INDIRF4
ADDRLP4 1048+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 1036+8
INDIRF4
ADDRLP4 1048+8
INDIRF4
ADDF4
ASGNF4
line 4302
;4302:	VectorScale(origin, 0.5, origin);
ADDRLP4 1092
CNSTF4 1056964608
ASGNF4
ADDRLP4 0
ADDRLP4 1092
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 1092
INDIRF4
ADDRLP4 0+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+8
CNSTF4 1056964608
ADDRLP4 0+8
INDIRF4
MULF4
ASGNF4
line 4303
;4303:	VectorCopy(origin, activategoal->target);
ADDRFP4 8
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 4304
;4304:	activategoal->shoot = qtrue;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 1
ASGNI4
line 4306
;4305:	//
;4306:	activategoal->goal.entitynum = entitynum; //NOTE: this is the entity number of the shootable door
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 1076
INDIRI4
ASGNI4
line 4307
;4307:	activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4308
;4308:	activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4309
;4309:	VectorCopy(bs->origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 4310
;4310:	activategoal->goal.areanum = bs->areanum;
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ASGNI4
line 4311
;4311:	VectorSet(activategoal->goal.mins, -8, -8, -8);
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 3238002688
ASGNF4
line 4312
;4312:	VectorSet(activategoal->goal.maxs, 8, 8, 8);
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 40
ADDP4
CNSTF4 1090519040
ASGNF4
line 4313
;4313:	return qtrue;
CNSTI4 1
RETI4
LABELV $1775
endproc BotFuncDoorActivateGoal 1096 20
export BotTriggerMultipleActivateGoal
proc BotTriggerMultipleActivateGoal 300 20
line 4321
;4314:}
;4315:
;4316:/*
;4317:==================
;4318:BotTriggerMultipleGoal
;4319:==================
;4320:*/
;4321:int BotTriggerMultipleActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4327
;4322:	int i, areas[10], numareas, modelindex, entitynum;
;4323:	char model[128];
;4324:	vec3_t start, end, mins, maxs, angles;
;4325:	vec3_t origin, goalorigin;
;4326:
;4327:	activategoal->shoot = qfalse;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 0
ASGNI4
line 4328
;4328:	VectorClear(activategoal->target);
ADDRLP4 268
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 272
CNSTF4 0
ASGNF4
ADDRLP4 268
INDIRP4
CNSTI4 88
ADDP4
ADDRLP4 272
INDIRF4
ASGNF4
ADDRLP4 268
INDIRP4
CNSTI4 84
ADDP4
ADDRLP4 272
INDIRF4
ASGNF4
ADDRLP4 268
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 272
INDIRF4
ASGNF4
line 4330
;4329:	//create a bot goal towards the trigger
;4330:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $291
ARGP4
ADDRLP4 84
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4331
;4331:	if (!*model)
ADDRLP4 84
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1794
line 4332
;4332:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1793
JUMPV
LABELV $1794
line 4333
;4333:	modelindex = atoi(model+1);
ADDRLP4 84+1
ARGP4
ADDRLP4 276
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 224
ADDRLP4 276
INDIRI4
ASGNI4
line 4334
;4334:	if (!modelindex)
ADDRLP4 224
INDIRI4
CNSTI4 0
NEI4 $1797
line 4335
;4335:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1793
JUMPV
LABELV $1797
line 4336
;4336:	VectorClear(angles);
ADDRLP4 280
CNSTF4 0
ASGNF4
ADDRLP4 240+8
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 240+4
ADDRLP4 280
INDIRF4
ASGNF4
ADDRLP4 240
ADDRLP4 280
INDIRF4
ASGNF4
line 4337
;4337:	entitynum = BotModelMinsMaxs(modelindex, 0, CONTENTS_TRIGGER, mins, maxs);
ADDRLP4 224
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 1073741824
ARGI4
ADDRLP4 60
ARGP4
ADDRLP4 72
ARGP4
ADDRLP4 284
ADDRGP4 BotModelMinsMaxs
CALLI4
ASGNI4
ADDRLP4 264
ADDRLP4 284
INDIRI4
ASGNI4
line 4339
;4338:	//trigger origin
;4339:	VectorAdd(mins, maxs, origin);
ADDRLP4 4
ADDRLP4 60
INDIRF4
ADDRLP4 72
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 60+4
INDIRF4
ADDRLP4 72+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRLP4 60+8
INDIRF4
ADDRLP4 72+8
INDIRF4
ADDF4
ASGNF4
line 4340
;4340:	VectorScale(origin, 0.5, origin);
ADDRLP4 288
CNSTF4 1056964608
ASGNF4
ADDRLP4 4
ADDRLP4 288
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 288
INDIRF4
ADDRLP4 4+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 4+8
CNSTF4 1056964608
ADDRLP4 4+8
INDIRF4
MULF4
ASGNF4
line 4341
;4341:	VectorCopy(origin, goalorigin);
ADDRLP4 252
ADDRLP4 4
INDIRB
ASGNB 12
line 4343
;4342:	//
;4343:	VectorCopy(goalorigin, start);
ADDRLP4 212
ADDRLP4 252
INDIRB
ASGNB 12
line 4344
;4344:	start[2] += 24;
ADDRLP4 212+8
ADDRLP4 212+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 4345
;4345:	VectorCopy(start, end);
ADDRLP4 228
ADDRLP4 212
INDIRB
ASGNB 12
line 4346
;4346:	end[2] -= 100;
ADDRLP4 228+8
ADDRLP4 228+8
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
line 4347
;4347:	numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
ADDRLP4 212
ARGP4
ADDRLP4 228
ARGP4
ADDRLP4 20
ARGP4
CNSTP4 0
ARGP4
CNSTI4 10
ARGI4
ADDRLP4 292
ADDRGP4 trap_AAS_TraceAreas
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 292
INDIRI4
ASGNI4
line 4349
;4348:	//
;4349:	for (i = 0; i < numareas; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1816
JUMPV
LABELV $1813
line 4350
;4350:		if (trap_AAS_AreaReachability(areas[i])) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 20
ADDP4
INDIRI4
ARGI4
ADDRLP4 296
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 296
INDIRI4
CNSTI4 0
EQI4 $1817
line 4351
;4351:			break;
ADDRGP4 $1815
JUMPV
LABELV $1817
line 4353
;4352:		}
;4353:	}
LABELV $1814
line 4349
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1816
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $1813
LABELV $1815
line 4354
;4354:	if (i < numareas) {
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
GEI4 $1819
line 4355
;4355:		VectorCopy(origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 4356
;4356:		activategoal->goal.areanum = areas[i];
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 20
ADDP4
INDIRI4
ASGNI4
line 4357
;4357:		VectorSubtract(mins, origin, activategoal->goal.mins);
ADDRFP4 8
INDIRP4
CNSTI4 20
ADDP4
ADDRLP4 60
INDIRF4
ADDRLP4 4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 60+4
INDIRF4
ADDRLP4 4+4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 60+8
INDIRF4
ADDRLP4 4+8
INDIRF4
SUBF4
ASGNF4
line 4358
;4358:		VectorSubtract(maxs, origin, activategoal->goal.maxs);
ADDRFP4 8
INDIRP4
CNSTI4 32
ADDP4
ADDRLP4 72
INDIRF4
ADDRLP4 4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 72+4
INDIRF4
ADDRLP4 4+4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 8
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 72+8
INDIRF4
ADDRLP4 4+8
INDIRF4
SUBF4
ASGNF4
line 4360
;4359:		//
;4360:		activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 264
INDIRI4
ASGNI4
line 4361
;4361:		activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4362
;4362:		activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4363
;4363:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1793
JUMPV
LABELV $1819
line 4365
;4364:	}
;4365:	return qfalse;
CNSTI4 0
RETI4
LABELV $1793
endproc BotTriggerMultipleActivateGoal 300 20
export BotPopFromActivateGoalStack
proc BotPopFromActivateGoalStack 4 8
line 4373
;4366:}
;4367:
;4368:/*
;4369:==================
;4370:BotPopFromActivateGoalStack
;4371:==================
;4372:*/
;4373:int BotPopFromActivateGoalStack(bot_state_t *bs) {
line 4374
;4374:	if (!bs->activatestack)
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1830
line 4375
;4375:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1829
JUMPV
LABELV $1830
line 4376
;4376:	BotEnableActivateGoalAreas(bs->activatestack, qtrue);
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4377
;4377:	bs->activatestack->inuse = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 0
ASGNI4
line 4378
;4378:	bs->activatestack->justused_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 68
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4379
;4379:	bs->activatestack = bs->activatestack->next;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRP4
CNSTI4 240
ADDP4
INDIRP4
ASGNP4
line 4380
;4380:	return qtrue;
CNSTI4 1
RETI4
LABELV $1829
endproc BotPopFromActivateGoalStack 4 8
export BotPushOntoActivateGoalStack
proc BotPushOntoActivateGoalStack 24 12
line 4388
;4381:}
;4382:
;4383:/*
;4384:==================
;4385:BotPushOntoActivateGoalStack
;4386:==================
;4387:*/
;4388:int BotPushOntoActivateGoalStack(bot_state_t *bs, bot_activategoal_t *activategoal) {
line 4392
;4389:	int i, best;
;4390:	float besttime;
;4391:
;4392:	best = -1;
ADDRLP4 8
CNSTI4 -1
ASGNI4
line 4393
;4393:	besttime = FloatTime() + 9999;
ADDRLP4 4
ADDRGP4 floattime
INDIRF4
CNSTF4 1176255488
ADDF4
ASGNF4
line 4395
;4394:	//
;4395:	for (i = 0; i < MAX_ACTIVATESTACK; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1833
line 4396
;4396:		if (!bs->activategoalheap[i].inuse) {
CNSTI4 244
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1837
line 4397
;4397:			if (bs->activategoalheap[i].justused_time < besttime) {
CNSTI4 244
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
CNSTI4 68
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
GEF4 $1839
line 4398
;4398:				besttime = bs->activategoalheap[i].justused_time;
ADDRLP4 4
CNSTI4 244
ADDRLP4 0
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
CNSTI4 68
ADDP4
INDIRF4
ASGNF4
line 4399
;4399:				best = i;
ADDRLP4 8
ADDRLP4 0
INDIRI4
ASGNI4
line 4400
;4400:			}
LABELV $1839
line 4401
;4401:		}
LABELV $1837
line 4402
;4402:	}
LABELV $1834
line 4395
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 8
LTI4 $1833
line 4403
;4403:	if (best != -1) {
ADDRLP4 8
INDIRI4
CNSTI4 -1
EQI4 $1841
line 4404
;4404:		memcpy(&bs->activategoalheap[best], activategoal, sizeof(bot_activategoal_t));
ADDRLP4 12
CNSTI4 244
ASGNI4
ADDRLP4 12
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 12
INDIRI4
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 4405
;4405:		bs->activategoalheap[best].inuse = qtrue;
CNSTI4 244
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
CNSTI4 1
ASGNI4
line 4406
;4406:		bs->activategoalheap[best].next = bs->activatestack;
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
CNSTI4 244
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 16
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
CNSTI4 240
ADDP4
ADDRLP4 16
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
line 4407
;4407:		bs->activatestack = &bs->activategoalheap[best];
ADDRLP4 20
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CNSTI4 7116
ADDP4
CNSTI4 244
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 20
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
ASGNP4
line 4408
;4408:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1832
JUMPV
LABELV $1841
line 4410
;4409:	}
;4410:	return qfalse;
CNSTI4 0
RETI4
LABELV $1832
endproc BotPushOntoActivateGoalStack 24 12
export BotClearActivateGoalStack
proc BotClearActivateGoalStack 0 4
line 4418
;4411:}
;4412:
;4413:/*
;4414:==================
;4415:BotClearActivateGoalStack
;4416:==================
;4417:*/
;4418:void BotClearActivateGoalStack(bot_state_t *bs) {
ADDRGP4 $1845
JUMPV
LABELV $1844
line 4420
;4419:	while(bs->activatestack)
;4420:		BotPopFromActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotPopFromActivateGoalStack
CALLI4
pop
LABELV $1845
line 4419
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1844
line 4421
;4421:}
LABELV $1843
endproc BotClearActivateGoalStack 0 4
export BotEnableActivateGoalAreas
proc BotEnableActivateGoalAreas 12 8
line 4428
;4422:
;4423:/*
;4424:==================
;4425:BotEnableActivateGoalAreas
;4426:==================
;4427:*/
;4428:void BotEnableActivateGoalAreas(bot_activategoal_t *activategoal, int enable) {
line 4431
;4429:	int i;
;4430:
;4431:	if (activategoal->areasdisabled == !enable)
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1851
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $1852
JUMPV
LABELV $1851
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $1852
ADDRFP4 0
INDIRP4
CNSTI4 236
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $1848
line 4432
;4432:		return;
ADDRGP4 $1847
JUMPV
LABELV $1848
line 4433
;4433:	for (i = 0; i < activategoal->numareas; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1856
JUMPV
LABELV $1853
line 4434
;4434:		trap_AAS_EnableRoutingArea( activategoal->areas[i], enable );
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ADDP4
INDIRI4
ARGI4
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 trap_AAS_EnableRoutingArea
CALLI4
pop
LABELV $1854
line 4433
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1856
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
LTI4 $1853
line 4435
;4435:	activategoal->areasdisabled = !enable;
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1858
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $1859
JUMPV
LABELV $1858
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $1859
ADDRFP4 0
INDIRP4
CNSTI4 236
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 4436
;4436:}
LABELV $1847
endproc BotEnableActivateGoalAreas 12 8
export BotIsGoingToActivateEntity
proc BotIsGoingToActivateEntity 8 0
line 4443
;4437:
;4438:/*
;4439:==================
;4440:BotIsGoingToActivateEntity
;4441:==================
;4442:*/
;4443:int BotIsGoingToActivateEntity(bot_state_t *bs, int entitynum) {
line 4447
;4444:	bot_activategoal_t *a;
;4445:	int i;
;4446:
;4447:	for (a = bs->activatestack; a; a = a->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRGP4 $1864
JUMPV
LABELV $1861
line 4448
;4448:		if (a->time < FloatTime())
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1865
line 4449
;4449:			continue;
ADDRGP4 $1862
JUMPV
LABELV $1865
line 4450
;4450:		if (a->goal.entitynum == entitynum)
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $1867
line 4451
;4451:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1860
JUMPV
LABELV $1867
line 4452
;4452:	}
LABELV $1862
line 4447
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 240
ADDP4
INDIRP4
ASGNP4
LABELV $1864
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1861
line 4453
;4453:	for (i = 0; i < MAX_ACTIVATESTACK; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $1869
line 4454
;4454:		if (bs->activategoalheap[i].inuse)
CNSTI4 244
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1873
line 4455
;4455:			continue;
ADDRGP4 $1870
JUMPV
LABELV $1873
line 4457
;4456:		//
;4457:		if (bs->activategoalheap[i].goal.entitynum == entitynum) {
CNSTI4 244
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
CNSTI4 44
ADDP4
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $1875
line 4459
;4458:			// if the bot went for this goal less than 2 seconds ago
;4459:			if (bs->activategoalheap[i].justused_time > FloatTime() - 2)
CNSTI4 244
ADDRLP4 4
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 7120
ADDP4
ADDP4
CNSTI4 68
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
LEF4 $1877
line 4460
;4460:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1860
JUMPV
LABELV $1877
line 4461
;4461:		}
LABELV $1875
line 4462
;4462:	}
LABELV $1870
line 4453
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $1869
line 4463
;4463:	return qfalse;
CNSTI4 0
RETI4
LABELV $1860
endproc BotIsGoingToActivateEntity 8 0
export BotGetActivateGoal
proc BotGetActivateGoal 3320 20
line 4476
;4464:}
;4465:
;4466:/*
;4467:==================
;4468:BotGetActivateGoal
;4469:
;4470:  returns the number of the bsp entity to activate
;4471:  goal->entitynum will be set to the game entity to activate
;4472:==================
;4473:*/
;4474://#define OBSTACLEDEBUG
;4475:
;4476:int BotGetActivateGoal(bot_state_t *bs, int entitynum, bot_activategoal_t *activategoal) {
line 4486
;4477:	int i, ent, cur_entities[10], spawnflags, modelindex, areas[MAX_ACTIVATEAREAS*2], numareas, t;
;4478:	char model[MAX_INFO_STRING], tmpmodel[128];
;4479:	char target[128], classname[128];
;4480:	float health;
;4481:	char targetname[10][128];
;4482:	aas_entityinfo_t entinfo;
;4483:	aas_areainfo_t areainfo;
;4484:	vec3_t origin, angles, absmins, absmaxs;
;4485:
;4486:	memset(activategoal, 0, sizeof(bot_activategoal_t));
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 244
ARGI4
ADDRGP4 memset
CALLP4
pop
line 4487
;4487:	BotEntityInfo(entitynum, &entinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 3052
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 4488
;4488:	Com_sprintf(model, sizeof( model ), "*%d", entinfo.modelindex);
ADDRLP4 1712
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $1880
ARGP4
ADDRLP4 3052+104
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 4489
;4489:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
CNSTI4 0
ARGI4
ADDRLP4 3252
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 3252
INDIRI4
ASGNI4
ADDRGP4 $1885
JUMPV
LABELV $1882
line 4490
;4490:		if (!trap_AAS_ValueForBSPEpairKey(ent, "model", tmpmodel, sizeof(tmpmodel))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $291
ARGP4
ADDRLP4 1584
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 3256
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3256
INDIRI4
CNSTI4 0
NEI4 $1886
ADDRGP4 $1883
JUMPV
LABELV $1886
line 4491
;4491:		if (!strcmp(model, tmpmodel)) break;
ADDRLP4 1712
ARGP4
ADDRLP4 1584
ARGP4
ADDRLP4 3260
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3260
INDIRI4
CNSTI4 0
NEI4 $1888
ADDRGP4 $1884
JUMPV
LABELV $1888
line 4492
;4492:	}
LABELV $1883
line 4489
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 3256
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 3256
INDIRI4
ASGNI4
LABELV $1885
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1882
LABELV $1884
line 4493
;4493:	if (!ent) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1890
line 4494
;4494:		BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no entity found with model %s\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1892
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4495
;4495:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1890
line 4497
;4496:	}
;4497:	trap_AAS_ValueForBSPEpairKey(ent, "classname", classname, sizeof(classname));
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1893
ARGP4
ADDRLP4 1456
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4498
;4498:	if (!classname) {
ADDRLP4 1456
CVPU4 4
CNSTU4 0
NEU4 $1894
line 4499
;4499:		BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with model %s has no classname\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1896
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4500
;4500:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1894
line 4503
;4501:	}
;4502:	//if it is a door
;4503:	if (!strcmp(classname, "func_door")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1899
ARGP4
ADDRLP4 3260
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3260
INDIRI4
CNSTI4 0
NEI4 $1897
line 4504
;4504:		if (trap_AAS_FloatForBSPEpairKey(ent, "health", &health)) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1695
ARGP4
ADDRLP4 3208
ARGP4
ADDRLP4 3264
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3264
INDIRI4
CNSTI4 0
EQI4 $1900
line 4506
;4505:			//if the door has health then the door must be shot to open
;4506:			if (health) {
ADDRLP4 3208
INDIRF4
CNSTF4 0
EQF4 $1902
line 4507
;4507:				BotFuncDoorActivateGoal(bs, ent, activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 BotFuncDoorActivateGoal
CALLI4
pop
line 4508
;4508:				return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1902
line 4510
;4509:			}
;4510:		}
LABELV $1900
line 4512
;4511:		//
;4512:		trap_AAS_IntForBSPEpairKey(ent, "spawnflags", &spawnflags);
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1904
ARGP4
ADDRLP4 3204
ARGP4
ADDRGP4 trap_AAS_IntForBSPEpairKey
CALLI4
pop
line 4514
;4513:		// if the door starts open then just wait for the door to return
;4514:		if ( spawnflags & 1 )
ADDRLP4 3204
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $1905
line 4515
;4515:			return 0;
CNSTI4 0
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1905
line 4517
;4516:		//get the door origin
;4517:		if (!trap_AAS_VectorForBSPEpairKey(ent, "origin", origin)) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1909
ARGP4
ADDRLP4 3192
ARGP4
ADDRLP4 3268
ADDRGP4 trap_AAS_VectorForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3268
INDIRI4
CNSTI4 0
NEI4 $1907
line 4518
;4518:			VectorClear(origin);
ADDRLP4 3272
CNSTF4 0
ASGNF4
ADDRLP4 3192+8
ADDRLP4 3272
INDIRF4
ASGNF4
ADDRLP4 3192+4
ADDRLP4 3272
INDIRF4
ASGNF4
ADDRLP4 3192
ADDRLP4 3272
INDIRF4
ASGNF4
line 4519
;4519:		}
LABELV $1907
line 4521
;4520:		//if the door is open or opening already
;4521:		if (!VectorCompare(origin, entinfo.origin))
ADDRLP4 3192
ARGP4
ADDRLP4 3052+24
ARGP4
ADDRLP4 3272
ADDRGP4 VectorCompare
CALLI4
ASGNI4
ADDRLP4 3272
INDIRI4
CNSTI4 0
NEI4 $1912
line 4522
;4522:			return 0;
CNSTI4 0
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1912
line 4524
;4523:		// store all the areas the door is in
;4524:		trap_AAS_ValueForBSPEpairKey(ent, "model", model, sizeof(model));
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $291
ARGP4
ADDRLP4 1712
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4525
;4525:		if (*model) {
ADDRLP4 1712
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $1915
line 4526
;4526:			modelindex = atoi(model+1);
ADDRLP4 1712+1
ARGP4
ADDRLP4 3276
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 3212
ADDRLP4 3276
INDIRI4
ASGNI4
line 4527
;4527:			if (modelindex) {
ADDRLP4 3212
INDIRI4
CNSTI4 0
EQI4 $1918
line 4528
;4528:				VectorClear(angles);
ADDRLP4 3280
CNSTF4 0
ASGNF4
ADDRLP4 3216+8
ADDRLP4 3280
INDIRF4
ASGNF4
ADDRLP4 3216+4
ADDRLP4 3280
INDIRF4
ASGNF4
ADDRLP4 3216
ADDRLP4 3280
INDIRF4
ASGNF4
line 4529
;4529:				BotModelMinsMaxs(modelindex, ET_MOVER, 0, absmins, absmaxs);
ADDRLP4 3212
INDIRI4
ARGI4
CNSTI4 4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 3228
ARGP4
ADDRLP4 3240
ARGP4
ADDRGP4 BotModelMinsMaxs
CALLI4
pop
line 4531
;4530:				//
;4531:				numareas = trap_AAS_BBoxAreas(absmins, absmaxs, areas, MAX_ACTIVATEAREAS*2);
ADDRLP4 3228
ARGP4
ADDRLP4 3240
ARGP4
ADDRLP4 2740
ARGP4
CNSTI4 64
ARGI4
ADDRLP4 3284
ADDRGP4 trap_AAS_BBoxAreas
CALLI4
ASGNI4
ADDRLP4 3048
ADDRLP4 3284
INDIRI4
ASGNI4
line 4533
;4532:				// store the areas with reachabilities first
;4533:				for (i = 0; i < numareas; i++) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1925
JUMPV
LABELV $1922
line 4534
;4534:					if (activategoal->numareas >= MAX_ACTIVATEAREAS)
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
CNSTI4 32
LTI4 $1926
line 4535
;4535:						break;
ADDRGP4 $1924
JUMPV
LABELV $1926
line 4536
;4536:					if ( !trap_AAS_AreaReachability(areas[i]) ) {
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 2740
ADDP4
INDIRI4
ARGI4
ADDRLP4 3288
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 3288
INDIRI4
CNSTI4 0
NEI4 $1928
line 4537
;4537:						continue;
ADDRGP4 $1923
JUMPV
LABELV $1928
line 4539
;4538:					}
;4539:					trap_AAS_AreaInfo(areas[i], &areainfo);
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 2740
ADDP4
INDIRI4
ARGI4
ADDRLP4 2996
ARGP4
ADDRGP4 trap_AAS_AreaInfo
CALLI4
pop
line 4540
;4540:					if (areainfo.contents & AREACONTENTS_MOVER) {
ADDRLP4 2996
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $1930
line 4541
;4541:						activategoal->areas[activategoal->numareas++] = areas[i];
ADDRLP4 3296
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
ASGNP4
ADDRLP4 3292
ADDRLP4 3296
INDIRP4
INDIRI4
ASGNI4
ADDRLP4 3296
INDIRP4
ADDRLP4 3292
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 3300
CNSTI4 2
ASGNI4
ADDRLP4 3292
INDIRI4
ADDRLP4 3300
INDIRI4
LSHI4
ADDRFP4 8
INDIRP4
CNSTI4 104
ADDP4
ADDP4
ADDRLP4 132
INDIRI4
ADDRLP4 3300
INDIRI4
LSHI4
ADDRLP4 2740
ADDP4
INDIRI4
ASGNI4
line 4542
;4542:					}
LABELV $1930
line 4543
;4543:				}
LABELV $1923
line 4533
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1925
ADDRLP4 132
INDIRI4
ADDRLP4 3048
INDIRI4
LTI4 $1922
LABELV $1924
line 4545
;4544:				// store any remaining areas
;4545:				for (i = 0; i < numareas; i++) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1935
JUMPV
LABELV $1932
line 4546
;4546:					if (activategoal->numareas >= MAX_ACTIVATEAREAS)
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
CNSTI4 32
LTI4 $1936
line 4547
;4547:						break;
ADDRGP4 $1934
JUMPV
LABELV $1936
line 4548
;4548:					if ( trap_AAS_AreaReachability(areas[i]) ) {
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 2740
ADDP4
INDIRI4
ARGI4
ADDRLP4 3288
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 3288
INDIRI4
CNSTI4 0
EQI4 $1938
line 4549
;4549:						continue;
ADDRGP4 $1933
JUMPV
LABELV $1938
line 4551
;4550:					}
;4551:					trap_AAS_AreaInfo(areas[i], &areainfo);
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 2740
ADDP4
INDIRI4
ARGI4
ADDRLP4 2996
ARGP4
ADDRGP4 trap_AAS_AreaInfo
CALLI4
pop
line 4552
;4552:					if (areainfo.contents & AREACONTENTS_MOVER) {
ADDRLP4 2996
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $1940
line 4553
;4553:						activategoal->areas[activategoal->numareas++] = areas[i];
ADDRLP4 3296
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
ASGNP4
ADDRLP4 3292
ADDRLP4 3296
INDIRP4
INDIRI4
ASGNI4
ADDRLP4 3296
INDIRP4
ADDRLP4 3292
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 3300
CNSTI4 2
ASGNI4
ADDRLP4 3292
INDIRI4
ADDRLP4 3300
INDIRI4
LSHI4
ADDRFP4 8
INDIRP4
CNSTI4 104
ADDP4
ADDP4
ADDRLP4 132
INDIRI4
ADDRLP4 3300
INDIRI4
LSHI4
ADDRLP4 2740
ADDP4
INDIRI4
ASGNI4
line 4554
;4554:					}
LABELV $1940
line 4555
;4555:				}
LABELV $1933
line 4545
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1935
ADDRLP4 132
INDIRI4
ADDRLP4 3048
INDIRI4
LTI4 $1932
LABELV $1934
line 4556
;4556:			}
LABELV $1918
line 4557
;4557:		}
LABELV $1915
line 4558
;4558:	}
LABELV $1897
line 4560
;4559:	// if the bot is blocked by or standing on top of a button
;4560:	if (!strcmp(classname, "func_button")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1944
ARGP4
ADDRLP4 3264
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3264
INDIRI4
CNSTI4 0
NEI4 $1942
line 4561
;4561:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1942
line 4564
;4562:	}
;4563:	// get the targetname so we can find an entity with a matching target
;4564:	if (!trap_AAS_ValueForBSPEpairKey(ent, "targetname", targetname[0], sizeof(targetname[0]))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1947
ARGP4
ADDRLP4 136
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 3268
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3268
INDIRI4
CNSTI4 0
NEI4 $1945
line 4565
;4565:		if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1948
line 4566
;4566:			BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with model \"%s\" has no targetname\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1951
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4567
;4567:		}
LABELV $1948
line 4568
;4568:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1945
line 4571
;4569:	}
;4570:	// allow tree-like activation
;4571:	cur_entities[0] = trap_AAS_NextBSPEntity(0);
CNSTI4 0
ARGI4
ADDRLP4 3272
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 1416
ADDRLP4 3272
INDIRI4
ASGNI4
line 4572
;4572:	for (i = 0; i >= 0 && i < 10;) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1955
JUMPV
LABELV $1952
line 4573
;4573:		for (ent = cur_entities[i]; ent; ent = trap_AAS_NextBSPEntity(ent)) {
ADDRLP4 0
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 1416
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $1959
JUMPV
LABELV $1956
line 4574
;4574:			if (!trap_AAS_ValueForBSPEpairKey(ent, "target", target, sizeof(target))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1962
ARGP4
ADDRLP4 4
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 3276
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3276
INDIRI4
CNSTI4 0
NEI4 $1960
ADDRGP4 $1957
JUMPV
LABELV $1960
line 4575
;4575:			if (!strcmp(targetname[i], target)) {
ADDRLP4 132
INDIRI4
CNSTI4 7
LSHI4
ADDRLP4 136
ADDP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 3280
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3280
INDIRI4
CNSTI4 0
NEI4 $1963
line 4576
;4576:				cur_entities[i] = trap_AAS_NextBSPEntity(ent);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 3284
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 1416
ADDP4
ADDRLP4 3284
INDIRI4
ASGNI4
line 4577
;4577:				break;
ADDRGP4 $1958
JUMPV
LABELV $1963
line 4579
;4578:			}
;4579:		}
LABELV $1957
line 4573
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 3276
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 3276
INDIRI4
ASGNI4
LABELV $1959
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1956
LABELV $1958
line 4580
;4580:		if (!ent) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1965
line 4581
;4581:			if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1967
line 4582
;4582:				BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no entity with target \"%s\"\n", targetname[i]);
CNSTI4 3
ARGI4
ADDRGP4 $1970
ARGP4
ADDRLP4 132
INDIRI4
CNSTI4 7
LSHI4
ADDRLP4 136
ADDP4
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4583
;4583:			}
LABELV $1967
line 4584
;4584:			i--;
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 4585
;4585:			continue;
ADDRGP4 $1953
JUMPV
LABELV $1965
line 4587
;4586:		}
;4587:		if (!trap_AAS_ValueForBSPEpairKey(ent, "classname", classname, sizeof(classname))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1893
ARGP4
ADDRLP4 1456
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 3280
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3280
INDIRI4
CNSTI4 0
NEI4 $1971
line 4588
;4588:			if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1953
line 4589
;4589:				BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with target \"%s\" has no classname\n", targetname[i]);
CNSTI4 3
ARGI4
ADDRGP4 $1976
ARGP4
ADDRLP4 132
INDIRI4
CNSTI4 7
LSHI4
ADDRLP4 136
ADDP4
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4590
;4590:			}
line 4591
;4591:			continue;
ADDRGP4 $1953
JUMPV
LABELV $1971
line 4594
;4592:		}
;4593:		// BSP button model
;4594:		if (!strcmp(classname, "func_button")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1944
ARGP4
ADDRLP4 3284
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3284
INDIRI4
CNSTI4 0
NEI4 $1977
line 4596
;4595:			//
;4596:			if (!BotFuncButtonActivateGoal(bs, ent, activategoal))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 3288
ADDRGP4 BotFuncButtonActivateGoal
CALLI4
ASGNI4
ADDRLP4 3288
INDIRI4
CNSTI4 0
NEI4 $1979
line 4597
;4597:				continue;
ADDRGP4 $1953
JUMPV
LABELV $1979
line 4599
;4598:			// if the bot tries to activate this button already
;4599:			if ( bs->activatestack && bs->activatestack->inuse &&
ADDRLP4 3292
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRLP4 3292
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1981
ADDRLP4 3292
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $1981
ADDRLP4 3296
CNSTI4 44
ASGNI4
ADDRLP4 3292
INDIRP4
ADDRLP4 3296
INDIRI4
ADDP4
INDIRI4
ADDRFP4 8
INDIRP4
ADDRLP4 3296
INDIRI4
ADDP4
INDIRI4
NEI4 $1981
ADDRLP4 3300
ADDRGP4 floattime
INDIRF4
ASGNF4
ADDRLP4 3292
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRLP4 3300
INDIRF4
LEF4 $1981
ADDRLP4 3292
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ADDRLP4 3300
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $1981
line 4603
;4600:				 bs->activatestack->goal.entitynum == activategoal->goal.entitynum &&
;4601:				 bs->activatestack->time > FloatTime() &&
;4602:				 bs->activatestack->start_time < FloatTime() - 2)
;4603:				continue;
ADDRGP4 $1953
JUMPV
LABELV $1981
line 4605
;4604:			// if the bot is in a reachability area
;4605:			if ( trap_AAS_AreaReachability(bs->areanum) ) {
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 3304
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 3304
INDIRI4
CNSTI4 0
EQI4 $1983
line 4607
;4606:				// disable all areas the blocking entity is in
;4607:				BotEnableActivateGoalAreas( activategoal, qfalse );
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4609
;4608:				//
;4609:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, activategoal->goal.areanum, bs->tfl);
ADDRLP4 3308
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 3308
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 3308
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ARGI4
ADDRLP4 3308
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 3312
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 2736
ADDRLP4 3312
INDIRI4
ASGNI4
line 4611
;4610:				// if the button is not reachable
;4611:				if (!t) {
ADDRLP4 2736
INDIRI4
CNSTI4 0
NEI4 $1985
line 4612
;4612:					continue;
ADDRGP4 $1953
JUMPV
LABELV $1985
line 4614
;4613:				}
;4614:				activategoal->time = FloatTime() + t * 0.01 + 5;
ADDRFP4 8
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1008981770
ADDRLP4 2736
INDIRI4
CVIF4 4
MULF4
ADDF4
CNSTF4 1084227584
ADDF4
ASGNF4
line 4615
;4615:			}
LABELV $1983
line 4616
;4616:			return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1977
line 4619
;4617:		}
;4618:		// invisible trigger multiple box
;4619:		else if (!strcmp(classname, "trigger_multiple")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1989
ARGP4
ADDRLP4 3288
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3288
INDIRI4
CNSTI4 0
NEI4 $1987
line 4621
;4620:			//
;4621:			if (!BotTriggerMultipleActivateGoal(bs, ent, activategoal))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 3292
ADDRGP4 BotTriggerMultipleActivateGoal
CALLI4
ASGNI4
ADDRLP4 3292
INDIRI4
CNSTI4 0
NEI4 $1990
line 4622
;4622:				continue;
ADDRGP4 $1953
JUMPV
LABELV $1990
line 4624
;4623:			// if the bot tries to activate this trigger already
;4624:			if ( bs->activatestack && bs->activatestack->inuse &&
ADDRLP4 3296
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRLP4 3296
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1992
ADDRLP4 3296
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $1992
ADDRLP4 3300
CNSTI4 44
ASGNI4
ADDRLP4 3296
INDIRP4
ADDRLP4 3300
INDIRI4
ADDP4
INDIRI4
ADDRFP4 8
INDIRP4
ADDRLP4 3300
INDIRI4
ADDP4
INDIRI4
NEI4 $1992
ADDRLP4 3304
ADDRGP4 floattime
INDIRF4
ASGNF4
ADDRLP4 3296
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRLP4 3304
INDIRF4
LEF4 $1992
ADDRLP4 3296
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ADDRLP4 3304
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $1992
line 4628
;4625:				 bs->activatestack->goal.entitynum == activategoal->goal.entitynum &&
;4626:				 bs->activatestack->time > FloatTime() &&
;4627:				 bs->activatestack->start_time < FloatTime() - 2)
;4628:				continue;
ADDRGP4 $1953
JUMPV
LABELV $1992
line 4630
;4629:			// if the bot is in a reachability area
;4630:			if ( trap_AAS_AreaReachability(bs->areanum) ) {
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 3308
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 3308
INDIRI4
CNSTI4 0
EQI4 $1994
line 4632
;4631:				// disable all areas the blocking entity is in
;4632:				BotEnableActivateGoalAreas( activategoal, qfalse );
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4634
;4633:				//
;4634:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, activategoal->goal.areanum, bs->tfl);
ADDRLP4 3312
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 3312
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 3312
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 8
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ARGI4
ADDRLP4 3312
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 3316
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 2736
ADDRLP4 3316
INDIRI4
ASGNI4
line 4636
;4635:				// if the trigger is not reachable
;4636:				if (!t) {
ADDRLP4 2736
INDIRI4
CNSTI4 0
NEI4 $1996
line 4637
;4637:					continue;
ADDRGP4 $1953
JUMPV
LABELV $1996
line 4639
;4638:				}
;4639:				activategoal->time = FloatTime() + t * 0.01 + 5;
ADDRFP4 8
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1008981770
ADDRLP4 2736
INDIRI4
CVIF4 4
MULF4
ADDF4
CNSTF4 1084227584
ADDF4
ASGNF4
line 4640
;4640:			}
LABELV $1994
line 4641
;4641:			return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1879
JUMPV
LABELV $1987
line 4643
;4642:		}
;4643:		else if (!strcmp(classname, "func_timer")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $2000
ARGP4
ADDRLP4 3292
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3292
INDIRI4
CNSTI4 0
NEI4 $1998
line 4645
;4644:			// just skip the func_timer
;4645:			continue;
ADDRGP4 $1953
JUMPV
LABELV $1998
line 4648
;4646:		}
;4647:		// the actual button or trigger might be linked through a target_relay or target_delay
;4648:		else if (!strcmp(classname, "target_relay") || !strcmp(classname, "target_delay")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $2003
ARGP4
ADDRLP4 3296
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3296
INDIRI4
CNSTI4 0
EQI4 $2005
ADDRLP4 1456
ARGP4
ADDRGP4 $2004
ARGP4
ADDRLP4 3300
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3300
INDIRI4
CNSTI4 0
NEI4 $2001
LABELV $2005
line 4649
;4649:			if (trap_AAS_ValueForBSPEpairKey(ent, "targetname", targetname[i+1], sizeof(targetname[0]))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1947
ARGP4
ADDRLP4 132
INDIRI4
CNSTI4 7
LSHI4
ADDRLP4 136+128
ADDP4
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 3304
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 3304
INDIRI4
CNSTI4 0
EQI4 $2006
line 4650
;4650:				i++;
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 4651
;4651:				cur_entities[i] = trap_AAS_NextBSPEntity(0);
CNSTI4 0
ARGI4
ADDRLP4 3308
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 1416
ADDP4
ADDRLP4 3308
INDIRI4
ASGNI4
line 4652
;4652:			}
LABELV $2006
line 4653
;4653:		}
LABELV $2001
line 4654
;4654:	}
LABELV $1953
line 4572
LABELV $1955
ADDRLP4 132
INDIRI4
CNSTI4 0
LTI4 $2009
ADDRLP4 132
INDIRI4
CNSTI4 10
LTI4 $1952
LABELV $2009
line 4658
;4655:#ifdef OBSTACLEDEBUG
;4656:	BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no valid activator for entity with target \"%s\"\n", targetname[0]);
;4657:#endif
;4658:	return 0;
CNSTI4 0
RETI4
LABELV $1879
endproc BotGetActivateGoal 3320 20
export BotGoForActivateGoal
proc BotGoForActivateGoal 144 8
line 4666
;4659:}
;4660:
;4661:/*
;4662:==================
;4663:BotGoForActivateGoal
;4664:==================
;4665:*/
;4666:int BotGoForActivateGoal(bot_state_t *bs, bot_activategoal_t *activategoal) {
line 4669
;4667:	aas_entityinfo_t activateinfo;
;4668:
;4669:	activategoal->inuse = qtrue;
ADDRFP4 4
INDIRP4
CNSTI4 1
ASGNI4
line 4670
;4670:	if (!activategoal->time)
ADDRFP4 4
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
CNSTF4 0
NEF4 $2011
line 4671
;4671:		activategoal->time = FloatTime() + 10;
ADDRFP4 4
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
LABELV $2011
line 4672
;4672:	activategoal->start_time = FloatTime();
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4673
;4673:	BotEntityInfo(activategoal->goal.entitynum, &activateinfo);
ADDRFP4 4
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 4674
;4674:	VectorCopy(activateinfo.origin, activategoal->origin);
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
ADDRLP4 0+24
INDIRB
ASGNB 12
line 4676
;4675:	//
;4676:	if (BotPushOntoActivateGoalStack(bs, activategoal)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotPushOntoActivateGoalStack
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $2014
line 4678
;4677:		// enter the activate entity AI node
;4678:		AIEnter_Seek_ActivateEntity(bs, "BotGoForActivateGoal");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2016
ARGP4
ADDRGP4 AIEnter_Seek_ActivateEntity
CALLV
pop
line 4679
;4679:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2010
JUMPV
LABELV $2014
line 4681
;4680:	}
;4681:	else {
line 4683
;4682:		// enable any routing areas that were disabled
;4683:		BotEnableActivateGoalAreas(activategoal, qtrue);
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4684
;4684:		return qfalse;
CNSTI4 0
RETI4
LABELV $2010
endproc BotGoForActivateGoal 144 8
export BotPrintActivateGoalInfo
proc BotPrintActivateGoalInfo 296 36
line 4693
;4685:	}
;4686:}
;4687:
;4688:/*
;4689:==================
;4690:BotPrintActivateGoalInfo
;4691:==================
;4692:*/
;4693:void BotPrintActivateGoalInfo(bot_state_t *bs, bot_activategoal_t *activategoal, int bspent) {
line 4698
;4694:	char netname[MAX_NETNAME];
;4695:	char classname[128];
;4696:	char buf[128];
;4697:
;4698:	ClientName(bs->client, netname, sizeof(netname));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 36
ARGI4
ADDRGP4 ClientName
CALLP4
pop
line 4699
;4699:	trap_AAS_ValueForBSPEpairKey(bspent, "classname", classname, sizeof(classname));
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1893
ARGP4
ADDRLP4 36
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4700
;4700:	if (activategoal->shoot) {
ADDRFP4 4
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
EQI4 $2018
line 4701
;4701:		Com_sprintf(buf, sizeof(buf), "%s: I have to shoot at a %s from %1.1f %1.1f %1.1f in area %d\n",
ADDRLP4 164
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $2020
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 292
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 292
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 292
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ARGF4
ADDRLP4 292
INDIRP4
CNSTI4 12
ADDP4
INDIRF4
ARGF4
ADDRLP4 292
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 4707
;4702:						netname, classname,
;4703:						activategoal->goal.origin[0],
;4704:						activategoal->goal.origin[1],
;4705:						activategoal->goal.origin[2],
;4706:						activategoal->goal.areanum);
;4707:	}
ADDRGP4 $2019
JUMPV
LABELV $2018
line 4708
;4708:	else {
line 4709
;4709:		Com_sprintf(buf, sizeof(buf), "%s: I have to activate a %s at %1.1f %1.1f %1.1f in area %d\n",
ADDRLP4 164
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $2021
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 36
ARGP4
ADDRLP4 292
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 292
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ARGF4
ADDRLP4 292
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ARGF4
ADDRLP4 292
INDIRP4
CNSTI4 12
ADDP4
INDIRF4
ARGF4
ADDRLP4 292
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 4715
;4710:						netname, classname,
;4711:						activategoal->goal.origin[0],
;4712:						activategoal->goal.origin[1],
;4713:						activategoal->goal.origin[2],
;4714:						activategoal->goal.areanum);
;4715:	}
LABELV $2019
line 4716
;4716:	trap_EA_Say(bs->client, buf);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 164
ARGP4
ADDRGP4 trap_EA_Say
CALLV
pop
line 4717
;4717:}
LABELV $2017
endproc BotPrintActivateGoalInfo 296 36
export BotRandomMove
proc BotRandomMove 32 16
line 4724
;4718:
;4719:/*
;4720:==================
;4721:BotRandomMove
;4722:==================
;4723:*/
;4724:void BotRandomMove(bot_state_t *bs, bot_moveresult_t *moveresult) {
line 4727
;4725:	vec3_t dir, angles;
;4726:
;4727:	angles[0] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 4728
;4728:	angles[1] = random() * 360;
ADDRLP4 24
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
CNSTF4 1135869952
ADDRLP4 24
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ASGNF4
line 4729
;4729:	angles[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 4730
;4730:	AngleVectors(angles, dir, NULL, NULL);
ADDRLP4 0
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 28
CNSTP4 0
ASGNP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 4732
;4731:
;4732:	trap_BotMoveInDirection(bs->ms, dir, 400, MOVE_WALK);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
CNSTF4 1137180672
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotMoveInDirection
CALLI4
pop
line 4734
;4733:
;4734:	moveresult->failure = qfalse;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 4735
;4735:	VectorCopy(dir, moveresult->movedir);
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 12
INDIRB
ASGNB 12
line 4736
;4736:}
LABELV $2022
endproc BotRandomMove 32 16
lit
align 4
LABELV $2026
byte 4 0
byte 4 0
byte 4 1065353216
export BotAIBlocked
code
proc BotAIBlocked 528 16
line 4749
;4737:
;4738:/*
;4739:==================
;4740:BotAIBlocked
;4741:
;4742:Very basic handling of bots being blocked by other entities.
;4743:Check what kind of entity is blocking the bot and try to activate
;4744:it. If that's not an option then try to walk around or over the entity.
;4745:Before the bot ends in this part of the AI it should predict which doors to
;4746:open, which buttons to activate etc.
;4747:==================
;4748:*/
;4749:void BotAIBlocked(bot_state_t *bs, bot_moveresult_t *moveresult, int activate) {
line 4751
;4750:	int movetype, bspent;
;4751:	vec3_t hordir, start, end, mins, maxs, sideward, angles, up = {0, 0, 1};
ADDRLP4 228
ADDRGP4 $2026
INDIRB
ASGNB 12
line 4756
;4752:	aas_entityinfo_t entinfo;
;4753:	bot_activategoal_t activategoal;
;4754:
;4755:	// if the bot is not blocked by anything
;4756:	if (!moveresult->blocked) {
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2027
line 4757
;4757:		bs->notblocked_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6204
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4758
;4758:		return;
ADDRGP4 $2025
JUMPV
LABELV $2027
line 4761
;4759:	}
;4760:	// if stuck in a solid area
;4761:	if ( moveresult->type == RESULTTYPE_INSOLIDAREA ) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 8
NEI4 $2029
line 4763
;4762:		// move in a random direction in the hope to get out
;4763:		BotRandomMove(bs, moveresult);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRandomMove
CALLV
pop
line 4765
;4764:		//
;4765:		return;
ADDRGP4 $2025
JUMPV
LABELV $2029
line 4768
;4766:	}
;4767:	// get info for the entity that is blocking the bot
;4768:	BotEntityInfo(moveresult->blockentity, &entinfo);
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 40
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 4774
;4769:#ifdef OBSTACLEDEBUG
;4770:	ClientName(bs->client, netname, sizeof(netname));
;4771:	BotAI_Print(PRT_MESSAGE, "%s: I'm blocked by model %d\n", netname, entinfo.modelindex);
;4772:#endif // OBSTACLEDEBUG
;4773:	// if blocked by a bsp model and the bot wants to activate it
;4774:	if (activate && entinfo.modelindex > 0 && entinfo.modelindex <= max_bspmodelindex) {
ADDRLP4 488
CNSTI4 0
ASGNI4
ADDRFP4 8
INDIRI4
ADDRLP4 488
INDIRI4
EQI4 $2031
ADDRLP4 40+104
INDIRI4
ADDRLP4 488
INDIRI4
LEI4 $2031
ADDRLP4 40+104
INDIRI4
ADDRGP4 max_bspmodelindex
INDIRI4
GTI4 $2031
line 4776
;4775:		// find the bsp entity which should be activated in order to get the blocking entity out of the way
;4776:		bspent = BotGetActivateGoal(bs, entinfo.number, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 40+20
INDIRI4
ARGI4
ADDRLP4 240
ARGP4
ADDRLP4 492
ADDRGP4 BotGetActivateGoal
CALLI4
ASGNI4
ADDRLP4 484
ADDRLP4 492
INDIRI4
ASGNI4
line 4777
;4777:		if (bspent) {
ADDRLP4 484
INDIRI4
CNSTI4 0
EQI4 $2036
line 4779
;4778:			//
;4779:			if (bs->activatestack && !bs->activatestack->inuse)
ADDRLP4 496
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRLP4 496
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $2038
ADDRLP4 496
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2038
line 4780
;4780:				bs->activatestack = NULL;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
CNSTP4 0
ASGNP4
LABELV $2038
line 4782
;4781:			// if not already trying to activate this entity
;4782:			if (!BotIsGoingToActivateEntity(bs, activategoal.goal.entitynum)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 240+4+40
INDIRI4
ARGI4
ADDRLP4 500
ADDRGP4 BotIsGoingToActivateEntity
CALLI4
ASGNI4
ADDRLP4 500
INDIRI4
CNSTI4 0
NEI4 $2040
line 4784
;4783:				//
;4784:				BotGoForActivateGoal(bs, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 240
ARGP4
ADDRGP4 BotGoForActivateGoal
CALLI4
pop
line 4785
;4785:			}
LABELV $2040
line 4789
;4786:			// if ontop of an obstacle or
;4787:			// if the bot is not in a reachability area it'll still
;4788:			// need some dynamic obstacle avoidance, otherwise return
;4789:			if (!(moveresult->flags & MOVERESULT_ONTOPOFOBSTACLE) &&
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $2037
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 504
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 504
INDIRI4
CNSTI4 0
EQI4 $2037
line 4791
;4790:				trap_AAS_AreaReachability(bs->areanum))
;4791:				return;
ADDRGP4 $2025
JUMPV
line 4792
;4792:		}
LABELV $2036
line 4793
;4793:		else {
line 4795
;4794:			// enable any routing areas that were disabled
;4795:			BotEnableActivateGoalAreas(&activategoal, qtrue);
ADDRLP4 240
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4796
;4796:		}
LABELV $2037
line 4797
;4797:	}
LABELV $2031
line 4799
;4798:	// just some basic dynamic obstacle avoidance code
;4799:	hordir[0] = moveresult->movedir[0];
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ASGNF4
line 4800
;4800:	hordir[1] = moveresult->movedir[1];
ADDRLP4 0+4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ASGNF4
line 4801
;4801:	hordir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 4803
;4802:	// if no direction just take a random direction
;4803:	if (VectorNormalize(hordir) < 0.1) {
ADDRLP4 0
ARGP4
ADDRLP4 492
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 492
INDIRF4
CNSTF4 1036831949
GEF4 $2048
line 4804
;4804:		VectorSet(angles, 0, 360 * random(), 0);
ADDRLP4 216
CNSTF4 0
ASGNF4
ADDRLP4 496
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 216+4
CNSTF4 1135869952
ADDRLP4 496
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ASGNF4
ADDRLP4 216+8
CNSTF4 0
ASGNF4
line 4805
;4805:		AngleVectors(angles, hordir, NULL, NULL);
ADDRLP4 216
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 500
CNSTP4 0
ASGNP4
ADDRLP4 500
INDIRP4
ARGP4
ADDRLP4 500
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 4806
;4806:	}
LABELV $2048
line 4810
;4807:	//
;4808:	//if (moveresult->flags & MOVERESULT_ONTOPOFOBSTACLE) movetype = MOVE_JUMP;
;4809:	//else
;4810:	movetype = MOVE_WALK;
ADDRLP4 36
CNSTI4 1
ASGNI4
line 4813
;4811:	// if there's an obstacle at the bot's feet and head then
;4812:	// the bot might be able to crouch through
;4813:	VectorCopy(bs->origin, start);
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 4814
;4814:	start[2] += 18;
ADDRLP4 24+8
ADDRLP4 24+8
INDIRF4
CNSTF4 1099956224
ADDF4
ASGNF4
line 4815
;4815:	VectorMA(start, 5, hordir, end);
ADDRLP4 496
CNSTF4 1084227584
ASGNF4
ADDRLP4 180
ADDRLP4 24
INDIRF4
ADDRLP4 496
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 180+4
ADDRLP4 24+4
INDIRF4
ADDRLP4 496
INDIRF4
ADDRLP4 0+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 180+8
ADDRLP4 24+8
INDIRF4
CNSTF4 1084227584
ADDRLP4 0+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 4816
;4816:	VectorSet(mins, -16, -16, -24);
ADDRLP4 500
CNSTF4 3246391296
ASGNF4
ADDRLP4 192
ADDRLP4 500
INDIRF4
ASGNF4
ADDRLP4 192+4
ADDRLP4 500
INDIRF4
ASGNF4
ADDRLP4 192+8
CNSTF4 3250585600
ASGNF4
line 4817
;4817:	VectorSet(maxs, 16, 16, 4);
ADDRLP4 504
CNSTF4 1098907648
ASGNF4
ADDRLP4 204
ADDRLP4 504
INDIRF4
ASGNF4
ADDRLP4 204+4
ADDRLP4 504
INDIRF4
ASGNF4
ADDRLP4 204+8
CNSTF4 1082130432
ASGNF4
line 4822
;4818:	//
;4819:	//bsptrace = AAS_Trace(start, mins, maxs, end, bs->entitynum, MASK_PLAYERSOLID);
;4820:	//if (bsptrace.fraction >= 1) movetype = MOVE_CROUCH;
;4821:	// get the sideward vector
;4822:	CrossProduct(hordir, up, sideward);
ADDRLP4 0
ARGP4
ADDRLP4 228
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 4824
;4823:	//
;4824:	if (bs->flags & BFL_AVOIDRIGHT) VectorNegate(sideward, sideward);
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $2063
ADDRLP4 12
ADDRLP4 12
INDIRF4
NEGF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
NEGF4
ASGNF4
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
NEGF4
ASGNF4
LABELV $2063
line 4826
;4825:	// try to crouch straight forward?
;4826:	if (movetype != MOVE_CROUCH || !trap_BotMoveInDirection(bs->ms, hordir, 400, movetype)) {
ADDRLP4 36
INDIRI4
CNSTI4 2
NEI4 $2071
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 512
ADDRGP4 trap_BotMoveInDirection
CALLI4
ASGNI4
ADDRLP4 512
INDIRI4
CNSTI4 0
NEI4 $2069
LABELV $2071
line 4828
;4827:		// perform the movement
;4828:		if (!trap_BotMoveInDirection(bs->ms, sideward, 400, movetype)) {
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 36
INDIRI4
ARGI4
ADDRLP4 516
ADDRGP4 trap_BotMoveInDirection
CALLI4
ASGNI4
ADDRLP4 516
INDIRI4
CNSTI4 0
NEI4 $2072
line 4830
;4829:			// flip the avoid direction flag
;4830:			bs->flags ^= BFL_AVOIDRIGHT;
ADDRLP4 520
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 520
INDIRP4
ADDRLP4 520
INDIRP4
INDIRI4
CNSTI4 16
BXORI4
ASGNI4
line 4833
;4831:			// flip the direction
;4832:			// VectorNegate(sideward, sideward);
;4833:			VectorMA(sideward, -1, hordir, sideward);
ADDRLP4 524
CNSTF4 3212836864
ASGNF4
ADDRLP4 12
ADDRLP4 12
INDIRF4
ADDRLP4 524
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 12+4
INDIRF4
ADDRLP4 524
INDIRF4
ADDRLP4 0+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 12+8
ADDRLP4 12+8
INDIRF4
CNSTF4 3212836864
ADDRLP4 0+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 4835
;4834:			// move in the other direction
;4835:			trap_BotMoveInDirection(bs->ms, sideward, 400, movetype);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 36
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveInDirection
CALLI4
pop
line 4836
;4836:		}
LABELV $2072
line 4837
;4837:	}
LABELV $2069
line 4839
;4838:	//
;4839:	if (bs->notblocked_time < FloatTime() - 0.4) {
ADDRFP4 0
INDIRP4
CNSTI4 6204
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1053609165
SUBF4
GEF4 $2080
line 4842
;4840:		// just reset goals and hope the bot will go into another direction?
;4841:		// is this still needed??
;4842:		if (bs->ainode == AINode_Seek_NBG) bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Seek_NBG
CVPU4 4
NEU4 $2082
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
ADDRGP4 $2083
JUMPV
LABELV $2082
line 4843
;4843:		else if (bs->ainode == AINode_Seek_LTG) bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Seek_LTG
CVPU4 4
NEU4 $2084
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
LABELV $2084
LABELV $2083
line 4844
;4844:	}
LABELV $2080
line 4845
;4845:}
LABELV $2025
endproc BotAIBlocked 528 16
export BotAIPredictObstacles
proc BotAIPredictObstacles 324 44
line 4857
;4846:
;4847:/*
;4848:==================
;4849:BotAIPredictObstacles
;4850:
;4851:Predict the route towards the goal and check if the bot
;4852:will be blocked by certain obstacles. When the bot has obstacles
;4853:on it's path the bot should figure out if they can be removed
;4854:by activating certain entities.
;4855:==================
;4856:*/
;4857:int BotAIPredictObstacles(bot_state_t *bs, bot_goal_t *goal) {
line 4862
;4858:	int modelnum, entitynum, bspent;
;4859:	bot_activategoal_t activategoal;
;4860:	aas_predictroute_t route;
;4861:
;4862:	if (!bot_predictobstacles.integer)
ADDRGP4 bot_predictobstacles+12
INDIRI4
CNSTI4 0
NEI4 $2087
line 4863
;4863:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2086
JUMPV
LABELV $2087
line 4866
;4864:
;4865:	// always predict when the goal change or at regular intervals
;4866:	if (bs->predictobstacles_goalareanum == goal->areanum &&
ADDRLP4 292
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 292
INDIRP4
CNSTI4 6216
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $2090
ADDRLP4 292
INDIRP4
CNSTI4 6212
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1086324736
SUBF4
LEF4 $2090
line 4867
;4867:		bs->predictobstacles_time > FloatTime() - 6) {
line 4868
;4868:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2086
JUMPV
LABELV $2090
line 4870
;4869:	}
;4870:	bs->predictobstacles_goalareanum = goal->areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6216
ADDP4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 4871
;4871:	bs->predictobstacles_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6212
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4874
;4872:
;4873:	// predict at most 100 areas or 10 seconds ahead
;4874:	trap_AAS_PredictRoute(&route, bs->areanum, bs->origin,
ADDRLP4 0
ARGP4
ADDRLP4 296
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 296
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 296
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 296
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTI4 100
ARGI4
CNSTI4 1000
ARGI4
CNSTI4 6
ARGI4
CNSTI4 1024
ARGI4
CNSTI4 67108864
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 trap_AAS_PredictRoute
CALLI4
pop
line 4879
;4875:							goal->areanum, bs->tfl, 100, 1000,
;4876:							RSE_USETRAVELTYPE|RSE_ENTERCONTENTS,
;4877:							AREACONTENTS_MOVER, TFL_BRIDGE, 0);
;4878:	// if bot has to travel through an area with a mover
;4879:	if (route.stopevent & RSE_ENTERCONTENTS) {
ADDRLP4 0+16
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $2092
line 4881
;4880:		// if the bot will run into a mover
;4881:		if (route.endcontents & AREACONTENTS_MOVER) {
ADDRLP4 0+20
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $2093
line 4883
;4882:			//NOTE: this only works with bspc 2.1 or higher
;4883:			modelnum = (route.endcontents & AREACONTENTS_MODELNUM) >> AREACONTENTS_MODELNUMSHIFT;
ADDRLP4 300
CNSTI4 24
ASGNI4
ADDRLP4 36
ADDRLP4 0+20
INDIRI4
CNSTI4 255
ADDRLP4 300
INDIRI4
LSHI4
BANDI4
ADDRLP4 300
INDIRI4
RSHI4
ASGNI4
line 4884
;4884:			if (modelnum) {
ADDRLP4 36
INDIRI4
CNSTI4 0
EQI4 $2093
line 4886
;4885:				//
;4886:				entitynum = BotModelMinsMaxs(modelnum, ET_MOVER, 0, NULL, NULL);
ADDRLP4 36
INDIRI4
ARGI4
CNSTI4 4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 304
CNSTP4 0
ASGNP4
ADDRLP4 304
INDIRP4
ARGP4
ADDRLP4 304
INDIRP4
ARGP4
ADDRLP4 308
ADDRGP4 BotModelMinsMaxs
CALLI4
ASGNI4
ADDRLP4 40
ADDRLP4 308
INDIRI4
ASGNI4
line 4887
;4887:				if (entitynum) {
ADDRLP4 40
INDIRI4
CNSTI4 0
EQI4 $2093
line 4889
;4888:					//NOTE: BotGetActivateGoal already checks if the door is open or not
;4889:					bspent = BotGetActivateGoal(bs, entitynum, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 40
INDIRI4
ARGI4
ADDRLP4 48
ARGP4
ADDRLP4 312
ADDRGP4 BotGetActivateGoal
CALLI4
ASGNI4
ADDRLP4 44
ADDRLP4 312
INDIRI4
ASGNI4
line 4890
;4890:					if (bspent) {
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $2093
line 4892
;4891:						//
;4892:						if (bs->activatestack && !bs->activatestack->inuse)
ADDRLP4 316
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRLP4 316
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $2105
ADDRLP4 316
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2105
line 4893
;4893:							bs->activatestack = NULL;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
CNSTP4 0
ASGNP4
LABELV $2105
line 4895
;4894:						// if not already trying to activate this entity
;4895:						if (!BotIsGoingToActivateEntity(bs, activategoal.goal.entitynum)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 48+4+40
INDIRI4
ARGI4
ADDRLP4 320
ADDRGP4 BotIsGoingToActivateEntity
CALLI4
ASGNI4
ADDRLP4 320
INDIRI4
CNSTI4 0
NEI4 $2107
line 4899
;4896:							//
;4897:							//BotAI_Print(PRT_MESSAGE, "blocked by mover model %d, entity %d ?\n", modelnum, entitynum);
;4898:							//
;4899:							BotGoForActivateGoal(bs, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 48
ARGP4
ADDRGP4 BotGoForActivateGoal
CALLI4
pop
line 4900
;4900:							return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2086
JUMPV
LABELV $2107
line 4902
;4901:						}
;4902:						else {
line 4904
;4903:							// enable any routing areas that were disabled
;4904:							BotEnableActivateGoalAreas(&activategoal, qtrue);
ADDRLP4 48
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4905
;4905:						}
line 4906
;4906:					}
line 4907
;4907:				}
line 4908
;4908:			}
line 4909
;4909:		}
line 4910
;4910:	}
ADDRGP4 $2093
JUMPV
LABELV $2092
line 4911
;4911:	else if (route.stopevent & RSE_USETRAVELTYPE) {
ADDRLP4 0+16
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $2111
line 4912
;4912:		if (route.endtravelflags & TFL_BRIDGE) {
ADDRLP4 0+24
INDIRI4
CNSTI4 67108864
BANDI4
CNSTI4 0
EQI4 $2114
line 4914
;4913:			//FIXME: check if the bridge is available to travel over
;4914:		}
LABELV $2114
line 4915
;4915:	}
LABELV $2111
LABELV $2093
line 4916
;4916:	return qfalse;
CNSTI4 0
RETI4
LABELV $2086
endproc BotAIPredictObstacles 324 44
export BotCheckConsoleMessages
proc BotCheckConsoleMessages 1012 48
line 4924
;4917:}
;4918:
;4919:/*
;4920:==================
;4921:BotCheckConsoleMessages
;4922:==================
;4923:*/
;4924:void BotCheckConsoleMessages(bot_state_t *bs) {
line 4932
;4925:	char botname[MAX_NETNAME], message[MAX_MESSAGE_SIZE], netname[MAX_NETNAME], *ptr;
;4926:	float chat_reply;
;4927:	int context, handle;
;4928:	bot_consolemessage_t m;
;4929:	bot_match_t match;
;4930:
;4931:	//the name of this bot
;4932:	ClientName(bs->client, botname, sizeof(botname));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 908
ARGP4
CNSTI4 36
ARGI4
ADDRGP4 ClientName
CALLP4
pop
ADDRGP4 $2119
JUMPV
LABELV $2118
line 4934
;4933:	//
;4934:	while((handle = trap_BotNextConsoleMessage(bs->cs, &m)) != 0) {
line 4936
;4935:		//if the chat state is flooded with messages the bot will read them quickly
;4936:		if (trap_BotNumConsoleMessages(bs->cs) < 10) {
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 948
ADDRGP4 trap_BotNumConsoleMessages
CALLI4
ASGNI4
ADDRLP4 948
INDIRI4
CNSTI4 10
GEI4 $2121
line 4938
;4937:			//if it is a chat message the bot needs some time to read it
;4938:			if (m.type == CMS_CHAT && m.time > FloatTime() - (1 + random())) break;
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2123
ADDRLP4 952
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 0+4
INDIRF4
ADDRGP4 floattime
INDIRF4
ADDRLP4 952
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1065353216
ADDF4
SUBF4
LEF4 $2123
ADDRGP4 $2120
JUMPV
LABELV $2123
line 4939
;4939:		}
LABELV $2121
line 4941
;4940:		//
;4941:		ptr = m.message;
ADDRLP4 276
ADDRLP4 0+12
ASGNP4
line 4944
;4942:		//if it is a chat message then don't unify white spaces and don't
;4943:		//replace synonyms in the netname
;4944:		if (m.type == CMS_CHAT) {
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2128
line 4946
;4945:			//
;4946:			if (trap_BotFindMatch(m.message, &match, MTCONTEXT_REPLYCHAT)) {
ADDRLP4 0+12
ARGP4
ADDRLP4 288
ARGP4
CNSTU4 128
ARGU4
ADDRLP4 952
ADDRGP4 trap_BotFindMatch
CALLI4
ASGNI4
ADDRLP4 952
INDIRI4
CNSTI4 0
EQI4 $2131
line 4947
;4947:				ptr = m.message + match.variables[MESSAGE].offset;
ADDRLP4 276
ADDRLP4 288+264+16
INDIRI1
CVII4 1
ADDRLP4 0+12
ADDP4
ASGNP4
line 4948
;4948:			}
LABELV $2131
line 4949
;4949:		}
LABELV $2128
line 4951
;4950:		//unify the white spaces in the message
;4951:		trap_UnifyWhiteSpaces(ptr);
ADDRLP4 276
INDIRP4
ARGP4
ADDRGP4 trap_UnifyWhiteSpaces
CALLV
pop
line 4953
;4952:		//replace synonyms in the right context
;4953:		context = BotSynonymContext(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 952
ADDRGP4 BotSynonymContext
CALLI4
ASGNI4
ADDRLP4 284
ADDRLP4 952
INDIRI4
ASGNI4
line 4954
;4954:		trap_BotReplaceSynonyms(ptr, context);
ADDRLP4 276
INDIRP4
ARGP4
ADDRLP4 284
INDIRI4
CVIU4 4
ARGU4
ADDRGP4 trap_BotReplaceSynonyms
CALLV
pop
line 4956
;4955:		//if there's no match
;4956:		if (!BotMatchMessage(bs, m.message)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0+12
ARGP4
ADDRLP4 956
ADDRGP4 BotMatchMessage
CALLI4
ASGNI4
ADDRLP4 956
INDIRI4
CNSTI4 0
NEI4 $2137
line 4958
;4957:			//if it is a chat message
;4958:			if (m.type == CMS_CHAT && !bot_nochat.integer) {
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2140
ADDRGP4 bot_nochat+12
INDIRI4
CNSTI4 0
NEI4 $2140
line 4960
;4959:				//
;4960:				if (!trap_BotFindMatch(m.message, &match, MTCONTEXT_REPLYCHAT)) {
ADDRLP4 0+12
ARGP4
ADDRLP4 288
ARGP4
CNSTU4 128
ARGU4
ADDRLP4 960
ADDRGP4 trap_BotFindMatch
CALLI4
ASGNI4
ADDRLP4 960
INDIRI4
CNSTI4 0
NEI4 $2144
line 4961
;4961:					trap_BotRemoveConsoleMessage(bs->cs, handle);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 280
INDIRI4
ARGI4
ADDRGP4 trap_BotRemoveConsoleMessage
CALLV
pop
line 4962
;4962:					continue;
ADDRGP4 $2119
JUMPV
LABELV $2144
line 4965
;4963:				}
;4964:				//don't use eliza chats with team messages
;4965:				if (match.subtype & ST_TEAM) {
ADDRLP4 288+260
INDIRI4
CNSTI4 32768
BANDI4
CNSTI4 0
EQI4 $2147
line 4966
;4966:					trap_BotRemoveConsoleMessage(bs->cs, handle);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 280
INDIRI4
ARGI4
ADDRGP4 trap_BotRemoveConsoleMessage
CALLV
pop
line 4967
;4967:					continue;
ADDRGP4 $2119
JUMPV
LABELV $2147
line 4970
;4968:				}
;4969:				//
;4970:				trap_BotMatchVariable(&match, NETNAME, netname, sizeof(netname));
ADDRLP4 288
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 872
ARGP4
CNSTI4 36
ARGI4
ADDRGP4 trap_BotMatchVariable
CALLV
pop
line 4971
;4971:				trap_BotMatchVariable(&match, MESSAGE, message, sizeof(message));
ADDRLP4 288
ARGP4
CNSTI4 2
ARGI4
ADDRLP4 616
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 trap_BotMatchVariable
CALLV
pop
line 4973
;4972:				//if this is a message from the bot self
;4973:				if (bs->client == ClientFromName(netname)) {
ADDRLP4 872
ARGP4
ADDRLP4 964
ADDRGP4 ClientFromName
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ADDRLP4 964
INDIRI4
NEI4 $2150
line 4974
;4974:					trap_BotRemoveConsoleMessage(bs->cs, handle);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 280
INDIRI4
ARGI4
ADDRGP4 trap_BotRemoveConsoleMessage
CALLV
pop
line 4975
;4975:					continue;
ADDRGP4 $2119
JUMPV
LABELV $2150
line 4978
;4976:				}
;4977:				//unify the message
;4978:				trap_UnifyWhiteSpaces(message);
ADDRLP4 616
ARGP4
ADDRGP4 trap_UnifyWhiteSpaces
CALLV
pop
line 4980
;4979:				//
;4980:				trap_Cvar_Update(&bot_testrchat);
ADDRGP4 bot_testrchat
ARGP4
ADDRGP4 trap_Cvar_Update
CALLV
pop
line 4981
;4981:				if (bot_testrchat.integer) {
ADDRGP4 bot_testrchat+12
INDIRI4
CNSTI4 0
EQI4 $2152
line 4983
;4982:					//
;4983:					trap_BotLibVarSet("bot_testrchat", "1");
ADDRGP4 $2155
ARGP4
ADDRGP4 $2156
ARGP4
ADDRGP4 trap_BotLibVarSet
CALLI4
pop
line 4985
;4984:					//if bot replies with a chat message
;4985:					if (trap_BotReplyChat(bs->cs, message, context, CONTEXT_REPLY,
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 616
ARGP4
ADDRLP4 284
INDIRI4
ARGI4
CNSTI4 16
ARGI4
ADDRLP4 968
CNSTP4 0
ASGNP4
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 908
ARGP4
ADDRLP4 872
ARGP4
ADDRLP4 972
ADDRGP4 trap_BotReplyChat
CALLI4
ASGNI4
ADDRLP4 972
INDIRI4
CNSTI4 0
EQI4 $2157
line 4989
;4986:															NULL, NULL,
;4987:															NULL, NULL,
;4988:															NULL, NULL,
;4989:															botname, netname)) {
line 4990
;4990:						BotAI_Print(PRT_MESSAGE, "------------------------\n");
CNSTI4 1
ARGI4
ADDRGP4 $2159
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4991
;4991:					}
ADDRGP4 $2153
JUMPV
LABELV $2157
line 4992
;4992:					else {
line 4993
;4993:						BotAI_Print(PRT_MESSAGE, "**** no valid reply ****\n");
CNSTI4 1
ARGI4
ADDRGP4 $2160
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4994
;4994:					}
line 4995
;4995:				}
ADDRGP4 $2153
JUMPV
LABELV $2152
line 4997
;4996:				//if at a valid chat position and not chatting already and not in teamplay
;4997:				else if (bs->ainode != AINode_Stand && BotValidChatPosition(bs) && !TeamPlayIsOn()) {
ADDRLP4 968
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 968
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Stand
CVPU4 4
EQU4 $2161
ADDRLP4 968
INDIRP4
ARGP4
ADDRLP4 972
ADDRGP4 BotValidChatPosition
CALLI4
ASGNI4
ADDRLP4 972
INDIRI4
CNSTI4 0
EQI4 $2161
ADDRLP4 976
ADDRGP4 TeamPlayIsOn
CALLI4
ASGNI4
ADDRLP4 976
INDIRI4
CNSTI4 0
NEI4 $2161
line 4998
;4998:					chat_reply = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CHAT_REPLY, 0, 1);
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 35
ARGI4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 980
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 944
ADDRLP4 980
INDIRF4
ASGNF4
line 4999
;4999:					if (random() < 1.5 / (NumBots()+1) && random() < chat_reply) {
ADDRLP4 984
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 988
ADDRGP4 NumBots
CALLI4
ASGNI4
ADDRLP4 984
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1069547520
ADDRLP4 988
INDIRI4
CNSTI4 1
ADDI4
CVIF4 4
DIVF4
GEF4 $2163
ADDRLP4 992
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 992
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 944
INDIRF4
GEF4 $2163
line 5001
;5000:						//if bot replies with a chat message
;5001:						if (trap_BotReplyChat(bs->cs, message, context, CONTEXT_REPLY,
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 616
ARGP4
ADDRLP4 284
INDIRI4
ARGI4
CNSTI4 16
ARGI4
ADDRLP4 996
CNSTP4 0
ASGNP4
ADDRLP4 996
INDIRP4
ARGP4
ADDRLP4 996
INDIRP4
ARGP4
ADDRLP4 996
INDIRP4
ARGP4
ADDRLP4 996
INDIRP4
ARGP4
ADDRLP4 996
INDIRP4
ARGP4
ADDRLP4 996
INDIRP4
ARGP4
ADDRLP4 908
ARGP4
ADDRLP4 872
ARGP4
ADDRLP4 1000
ADDRGP4 trap_BotReplyChat
CALLI4
ASGNI4
ADDRLP4 1000
INDIRI4
CNSTI4 0
EQI4 $2165
line 5005
;5002:																NULL, NULL,
;5003:																NULL, NULL,
;5004:																NULL, NULL,
;5005:																botname, netname)) {
line 5007
;5006:							//remove the console message
;5007:							trap_BotRemoveConsoleMessage(bs->cs, handle);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 280
INDIRI4
ARGI4
ADDRGP4 trap_BotRemoveConsoleMessage
CALLV
pop
line 5008
;5008:							bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 1004
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1004
INDIRP4
ARGP4
ADDRLP4 1008
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 1004
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 1008
INDIRF4
ADDF4
ASGNF4
line 5009
;5009:							AIEnter_Stand(bs, "BotCheckConsoleMessages: reply chat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2167
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 5011
;5010:							//EA_Say(bs->client, bs->cs.chatmessage);
;5011:							break;
ADDRGP4 $2120
JUMPV
LABELV $2165
line 5013
;5012:						}
;5013:					}
LABELV $2163
line 5014
;5014:				}
LABELV $2161
LABELV $2153
line 5015
;5015:			}
LABELV $2140
line 5016
;5016:		}
LABELV $2137
line 5018
;5017:		//remove the console message
;5018:		trap_BotRemoveConsoleMessage(bs->cs, handle);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 280
INDIRI4
ARGI4
ADDRGP4 trap_BotRemoveConsoleMessage
CALLV
pop
line 5019
;5019:	}
LABELV $2119
line 4934
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 948
ADDRGP4 trap_BotNextConsoleMessage
CALLI4
ASGNI4
ADDRLP4 280
ADDRLP4 948
INDIRI4
ASGNI4
ADDRLP4 948
INDIRI4
CNSTI4 0
NEI4 $2118
LABELV $2120
line 5020
;5020:}
LABELV $2117
endproc BotCheckConsoleMessages 1012 48
export BotCheckForGrenades
proc BotCheckForGrenades 8 16
line 5027
;5021:
;5022:/*
;5023:==================
;5024:BotCheckEvents
;5025:==================
;5026:*/
;5027:void BotCheckForGrenades(bot_state_t *bs, entityState_t *state) {
line 5029
;5028:	// if this is not a grenade
;5029:	if (state->eType != ET_MISSILE || state->weapon != WP_GRENADE_LAUNCHER)
ADDRLP4 0
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 4
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $2171
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $2169
LABELV $2171
line 5030
;5030:		return;
ADDRGP4 $2168
JUMPV
LABELV $2169
line 5032
;5031:	// try to avoid the grenade
;5032:	trap_BotAddAvoidSpot(bs->ms, state->pos.trBase, 160, AVOID_ALWAYS);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
ARGP4
CNSTF4 1126170624
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotAddAvoidSpot
CALLV
pop
line 5033
;5033:}
LABELV $2168
endproc BotCheckForGrenades 8 16
export BotCheckEvents
proc BotCheckEvents 164 12
line 5085
;5034:
;5035:#ifdef MISSIONPACK
;5036:/*
;5037:==================
;5038:BotCheckForProxMines
;5039:==================
;5040:*/
;5041:void BotCheckForProxMines(bot_state_t *bs, entityState_t *state) {
;5042:	// if this is not a prox mine
;5043:	if (state->eType != ET_MISSILE || state->weapon != WP_PROX_LAUNCHER)
;5044:		return;
;5045:	// if this prox mine is from someone on our own team
;5046:	if (state->generic1 == BotTeam(bs))
;5047:		return;
;5048:	// if the bot doesn't have a weapon to deactivate the mine
;5049:	if (!(bs->inventory[INVENTORY_PLASMAGUN] > 0 && bs->inventory[INVENTORY_CELLS] > 0) &&
;5050:		!(bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 && bs->inventory[INVENTORY_ROCKETS] > 0) &&
;5051:		!(bs->inventory[INVENTORY_BFG10K] > 0 && bs->inventory[INVENTORY_BFGAMMO] > 0) ) {
;5052:		return;
;5053:	}
;5054:	// try to avoid the prox mine
;5055:	trap_BotAddAvoidSpot(bs->ms, state->pos.trBase, 160, AVOID_ALWAYS);
;5056:	//
;5057:	if (bs->numproxmines >= MAX_PROXMINES)
;5058:		return;
;5059:	bs->proxmines[bs->numproxmines] = state->number;
;5060:	bs->numproxmines++;
;5061:}
;5062:
;5063:/*
;5064:==================
;5065:BotCheckForKamikazeBody
;5066:==================
;5067:*/
;5068:void BotCheckForKamikazeBody(bot_state_t *bs, entityState_t *state) {
;5069:	// if this entity is not wearing the kamikaze
;5070:	if (!(state->eFlags & EF_KAMIKAZE))
;5071:		return;
;5072:	// if this entity isn't dead
;5073:	if (!(state->eFlags & EF_DEAD))
;5074:		return;
;5075:	//remember this kamikaze body
;5076:	bs->kamikazebody = state->number;
;5077:}
;5078:#endif
;5079:
;5080:/*
;5081:==================
;5082:BotCheckEvents
;5083:==================
;5084:*/
;5085:void BotCheckEvents(bot_state_t *bs, entityState_t *state) {
line 5094
;5086:	int event;
;5087:	char buf[128];
;5088:#ifdef MISSIONPACK
;5089:	aas_entityinfo_t entinfo;
;5090:#endif
;5091:
;5092:	//NOTE: this sucks, we're accessing the gentity_t directly
;5093:	//but there's no other fast way to do it right now
;5094:	if (bs->entityeventTime[state->number] == g_entities[state->number].eventTime) {
ADDRLP4 132
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 512
ADDP4
ADDP4
INDIRI4
CNSTI4 884
ADDRLP4 132
INDIRI4
MULI4
ADDRGP4 g_entities+552
ADDP4
INDIRI4
NEI4 $2173
line 5095
;5095:		return;
ADDRGP4 $2172
JUMPV
LABELV $2173
line 5097
;5096:	}
;5097:	bs->entityeventTime[state->number] = g_entities[state->number].eventTime;
ADDRLP4 136
ADDRFP4 4
INDIRP4
INDIRI4
ASGNI4
ADDRLP4 136
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 512
ADDP4
ADDP4
CNSTI4 884
ADDRLP4 136
INDIRI4
MULI4
ADDRGP4 g_entities+552
ADDP4
INDIRI4
ASGNI4
line 5099
;5098:	//if it's an event only entity
;5099:	if (state->eType > ET_EVENTS) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 14
LEI4 $2177
line 5100
;5100:		event = (state->eType - ET_EVENTS) & ~EV_EVENT_BITS;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 14
SUBI4
CNSTI4 -769
BANDI4
ASGNI4
line 5101
;5101:	}
ADDRGP4 $2178
JUMPV
LABELV $2177
line 5102
;5102:	else {
line 5103
;5103:		event = state->event & ~EV_EVENT_BITS;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 -769
BANDI4
ASGNI4
line 5104
;5104:	}
LABELV $2178
line 5106
;5105:	//
;5106:	switch(event) {
ADDRLP4 140
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 1
LTI4 $2179
ADDRLP4 140
INDIRI4
CNSTI4 76
GTI4 $2179
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $2228-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $2228
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2180
address $2179
address $2179
address $2179
address $2213
address $2179
address $2179
address $2214
address $2192
address $2200
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2181
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2179
address $2180
code
LABELV $2181
line 5109
;5107:		//client obituary event
;5108:		case EV_OBITUARY:
;5109:		{
line 5112
;5110:			int target, attacker, mod;
;5111:
;5112:			target = state->otherEntityNum;
ADDRLP4 144
ADDRFP4 4
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 5113
;5113:			attacker = state->otherEntityNum2;
ADDRLP4 148
ADDRFP4 4
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 5114
;5114:			mod = state->eventParm;
ADDRLP4 152
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 5116
;5115:			//
;5116:			if (target == bs->client) {
ADDRLP4 144
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2182
line 5117
;5117:				bs->botdeathtype = mod;
ADDRFP4 0
INDIRP4
CNSTI4 6000
ADDP4
ADDRLP4 152
INDIRI4
ASGNI4
line 5118
;5118:				bs->lastkilledby = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 5996
ADDP4
ADDRLP4 148
INDIRI4
ASGNI4
line 5120
;5119:				//
;5120:				if (target == attacker ||
ADDRLP4 156
ADDRLP4 144
INDIRI4
ASGNI4
ADDRLP4 156
INDIRI4
ADDRLP4 148
INDIRI4
EQI4 $2187
ADDRLP4 156
INDIRI4
CNSTI4 1023
EQI4 $2187
ADDRLP4 156
INDIRI4
CNSTI4 1022
NEI4 $2184
LABELV $2187
line 5122
;5121:					target == ENTITYNUM_NONE ||
;5122:					target == ENTITYNUM_WORLD) bs->botsuicide = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6008
ADDP4
CNSTI4 1
ASGNI4
ADDRGP4 $2185
JUMPV
LABELV $2184
line 5123
;5123:				else bs->botsuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6008
ADDP4
CNSTI4 0
ASGNI4
LABELV $2185
line 5125
;5124:				//
;5125:				bs->num_deaths++;
ADDRLP4 160
ADDRFP4 0
INDIRP4
CNSTI4 6028
ADDP4
ASGNP4
ADDRLP4 160
INDIRP4
ADDRLP4 160
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 5126
;5126:			}
ADDRGP4 $2180
JUMPV
LABELV $2182
line 5128
;5127:			//else if this client was killed by the bot
;5128:			else if (attacker == bs->client) {
ADDRLP4 148
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2188
line 5129
;5129:				bs->enemydeathtype = mod;
ADDRFP4 0
INDIRP4
CNSTI4 6004
ADDP4
ADDRLP4 152
INDIRI4
ASGNI4
line 5130
;5130:				bs->lastkilledplayer = target;
ADDRFP4 0
INDIRP4
CNSTI4 5992
ADDP4
ADDRLP4 144
INDIRI4
ASGNI4
line 5131
;5131:				bs->killedenemy_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6168
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5133
;5132:				//
;5133:				bs->num_kills++;
ADDRLP4 156
ADDRFP4 0
INDIRP4
CNSTI4 6032
ADDP4
ASGNP4
ADDRLP4 156
INDIRP4
ADDRLP4 156
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 5134
;5134:			}
ADDRGP4 $2180
JUMPV
LABELV $2188
line 5135
;5135:			else if (attacker == bs->enemy && target == attacker) {
ADDRLP4 156
ADDRLP4 148
INDIRI4
ASGNI4
ADDRLP4 156
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
NEI4 $2180
ADDRLP4 144
INDIRI4
ADDRLP4 156
INDIRI4
NEI4 $2180
line 5136
;5136:				bs->enemysuicide = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 1
ASGNI4
line 5137
;5137:			}
line 5151
;5138:			//
;5139:#ifdef MISSIONPACK			
;5140:			if (gametype == GT_1FCTF) {
;5141:				//
;5142:				BotEntityInfo(target, &entinfo);
;5143:				if ( entinfo.powerups & ( 1 << PW_NEUTRALFLAG ) ) {
;5144:					if (!BotSameTeam(bs, target)) {
;5145:						bs->neutralflagstatus = 3;	//enemy dropped the flag
;5146:						bs->flagstatuschanged = qtrue;
;5147:					}
;5148:				}
;5149:			}
;5150:#endif
;5151:			break;
ADDRGP4 $2180
JUMPV
LABELV $2192
line 5154
;5152:		}
;5153:		case EV_GLOBAL_SOUND:
;5154:		{
line 5155
;5155:			if (state->eventParm < 0 || state->eventParm > MAX_SOUNDS) {
ADDRLP4 144
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $2195
ADDRLP4 144
INDIRI4
CNSTI4 256
LEI4 $2193
LABELV $2195
line 5156
;5156:				BotAI_Print(PRT_ERROR, "EV_GLOBAL_SOUND: eventParm (%d) out of range\n", state->eventParm);
CNSTI4 3
ARGI4
ADDRGP4 $2196
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotAI_Print
CALLV
pop
line 5157
;5157:				break;
ADDRGP4 $2180
JUMPV
LABELV $2193
line 5159
;5158:			}
;5159:			trap_GetConfigstring(CS_SOUNDS + state->eventParm, buf, sizeof(buf));
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 288
ADDI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 5179
;5160:			/*
;5161:			if (!strcmp(buf, "sound/teamplay/flagret_red.wav")) {
;5162:				//red flag is returned
;5163:				bs->redflagstatus = 0;
;5164:				bs->flagstatuschanged = qtrue;
;5165:			}
;5166:			else if (!strcmp(buf, "sound/teamplay/flagret_blu.wav")) {
;5167:				//blue flag is returned
;5168:				bs->blueflagstatus = 0;
;5169:				bs->flagstatuschanged = qtrue;
;5170:			}
;5171:			else*/
;5172:#ifdef MISSIONPACK
;5173:			if (!strcmp(buf, "sound/items/kamikazerespawn.wav" )) {
;5174:				//the kamikaze respawned so dont avoid it
;5175:				BotDontAvoid(bs, "Kamikaze");
;5176:			}
;5177:			else
;5178:#endif
;5179:				if (!strcmp(buf, "sound/items/poweruprespawn.wav")) {
ADDRLP4 4
ARGP4
ADDRGP4 $2199
ARGP4
ADDRLP4 148
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2180
line 5181
;5180:				//powerup respawned... go get it
;5181:				BotGoForPowerups(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotGoForPowerups
CALLV
pop
line 5182
;5182:			}
line 5183
;5183:			break;
ADDRGP4 $2180
JUMPV
LABELV $2200
line 5186
;5184:		}
;5185:		case EV_GLOBAL_TEAM_SOUND:
;5186:		{
line 5187
;5187:			if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $2180
line 5188
;5188:				switch(state->eventParm) {
ADDRLP4 144
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $2180
ADDRLP4 144
INDIRI4
CNSTI4 5
GTI4 $2180
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $2212
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $2212
address $2206
address $2207
address $2208
address $2209
address $2210
address $2211
code
LABELV $2206
line 5190
;5189:					case GTS_RED_CAPTURE:
;5190:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 5191
;5191:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 5192
;5192:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 5193
;5193:						break; //see BotMatch_CTF
ADDRGP4 $2180
JUMPV
LABELV $2207
line 5195
;5194:					case GTS_BLUE_CAPTURE:
;5195:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 5196
;5196:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 5197
;5197:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 5198
;5198:						break; //see BotMatch_CTF
ADDRGP4 $2180
JUMPV
LABELV $2208
line 5201
;5199:					case GTS_RED_RETURN:
;5200:						//blue flag is returned
;5201:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 5202
;5202:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 5203
;5203:						break;
ADDRGP4 $2180
JUMPV
LABELV $2209
line 5206
;5204:					case GTS_BLUE_RETURN:
;5205:						//red flag is returned
;5206:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 5207
;5207:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 5208
;5208:						break;
ADDRGP4 $2180
JUMPV
LABELV $2210
line 5211
;5209:					case GTS_RED_TAKEN:
;5210:						//blue flag is taken
;5211:						bs->blueflagstatus = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 1
ASGNI4
line 5212
;5212:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 5213
;5213:						break; //see BotMatch_CTF
ADDRGP4 $2180
JUMPV
LABELV $2211
line 5216
;5214:					case GTS_BLUE_TAKEN:
;5215:						//red flag is taken
;5216:						bs->redflagstatus = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 1
ASGNI4
line 5217
;5217:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 5218
;5218:						break; //see BotMatch_CTF
line 5220
;5219:				}
;5220:			}
line 5253
;5221:#ifdef MISSIONPACK
;5222:			else if (gametype == GT_1FCTF) {
;5223:				switch(state->eventParm) {
;5224:					case GTS_RED_CAPTURE:
;5225:						bs->neutralflagstatus = 0;
;5226:						bs->flagstatuschanged = qtrue;
;5227:						break;
;5228:					case GTS_BLUE_CAPTURE:
;5229:						bs->neutralflagstatus = 0;
;5230:						bs->flagstatuschanged = qtrue;
;5231:						break;
;5232:					case GTS_RED_RETURN:
;5233:						//flag has returned
;5234:						bs->neutralflagstatus = 0;
;5235:						bs->flagstatuschanged = qtrue;
;5236:						break;
;5237:					case GTS_BLUE_RETURN:
;5238:						//flag has returned
;5239:						bs->neutralflagstatus = 0;
;5240:						bs->flagstatuschanged = qtrue;
;5241:						break;
;5242:					case GTS_RED_TAKEN:
;5243:						bs->neutralflagstatus = BotTeam(bs) == TEAM_RED ? 2 : 1; //FIXME: check Team_TakeFlagSound in g_team.c
;5244:						bs->flagstatuschanged = qtrue;
;5245:						break;
;5246:					case GTS_BLUE_TAKEN:
;5247:						bs->neutralflagstatus = BotTeam(bs) == TEAM_BLUE ? 2 : 1; //FIXME: check Team_TakeFlagSound in g_team.c
;5248:						bs->flagstatuschanged = qtrue;
;5249:						break;
;5250:				}
;5251:			}
;5252:#endif
;5253:			break;
ADDRGP4 $2180
JUMPV
LABELV $2213
line 5256
;5254:		}
;5255:		case EV_PLAYER_TELEPORT_IN:
;5256:		{
line 5257
;5257:			VectorCopy(state->origin, lastteleport_origin);
ADDRGP4 lastteleport_origin
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 5258
;5258:			lastteleport_time = FloatTime();
ADDRGP4 lastteleport_time
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5259
;5259:			break;
ADDRGP4 $2180
JUMPV
LABELV $2214
line 5262
;5260:		}
;5261:		case EV_GENERAL_SOUND:
;5262:		{
line 5264
;5263:			//if this sound is played on the bot
;5264:			if (state->number == bs->client) {
ADDRFP4 4
INDIRP4
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2180
line 5265
;5265:				if (state->eventParm < 0 || state->eventParm > MAX_SOUNDS) {
ADDRLP4 144
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
LTI4 $2219
ADDRLP4 144
INDIRI4
CNSTI4 256
LEI4 $2217
LABELV $2219
line 5266
;5266:					BotAI_Print(PRT_ERROR, "EV_GENERAL_SOUND: eventParm (%d) out of range\n", state->eventParm);
CNSTI4 3
ARGI4
ADDRGP4 $2220
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotAI_Print
CALLV
pop
line 5267
;5267:					break;
ADDRGP4 $2180
JUMPV
LABELV $2217
line 5270
;5268:				}
;5269:				//check out the sound
;5270:				trap_GetConfigstring(CS_SOUNDS + state->eventParm, buf, sizeof(buf));
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 288
ADDI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_GetConfigstring
CALLV
pop
line 5272
;5271:				//if falling into a death pit
;5272:				if (!strcmp(buf, "*falling1.wav")) {
ADDRLP4 4
ARGP4
ADDRGP4 $2223
ARGP4
ADDRLP4 148
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2180
line 5274
;5273:					//if the bot has a personal teleporter
;5274:					if (bs->inventory[INVENTORY_TELEPORTER] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5072
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2180
line 5276
;5275:						//use the holdable item
;5276:						trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 5277
;5277:					}
line 5278
;5278:				}
line 5279
;5279:			}
line 5280
;5280:			break;
line 5307
;5281:		}
;5282:		case EV_FOOTSTEP:
;5283:		case EV_FOOTSTEP_METAL:
;5284:		case EV_FOOTSPLASH:
;5285:		case EV_FOOTWADE:
;5286:		case EV_SWIM:
;5287:		case EV_FALL_SHORT:
;5288:		case EV_FALL_MEDIUM:
;5289:		case EV_FALL_FAR:
;5290:		case EV_STEP_4:
;5291:		case EV_STEP_8:
;5292:		case EV_STEP_12:
;5293:		case EV_STEP_16:
;5294:		case EV_JUMP_PAD:
;5295:		case EV_JUMP:
;5296:		case EV_TAUNT:
;5297:		case EV_WATER_TOUCH:
;5298:		case EV_WATER_LEAVE:
;5299:		case EV_WATER_UNDER:
;5300:		case EV_WATER_CLEAR:
;5301:		case EV_ITEM_PICKUP:
;5302:		case EV_GLOBAL_ITEM_PICKUP:
;5303:		case EV_NOAMMO:
;5304:		case EV_CHANGE_WEAPON:
;5305:		case EV_FIRE_WEAPON:
;5306:			//FIXME: either add to sound queue or mark player as someone making noise
;5307:			break;
line 5323
;5308:		case EV_USE_ITEM0:
;5309:		case EV_USE_ITEM1:
;5310:		case EV_USE_ITEM2:
;5311:		case EV_USE_ITEM3:
;5312:		case EV_USE_ITEM4:
;5313:		case EV_USE_ITEM5:
;5314:		case EV_USE_ITEM6:
;5315:		case EV_USE_ITEM7:
;5316:		case EV_USE_ITEM8:
;5317:		case EV_USE_ITEM9:
;5318:		case EV_USE_ITEM10:
;5319:		case EV_USE_ITEM11:
;5320:		case EV_USE_ITEM12:
;5321:		case EV_USE_ITEM13:
;5322:		case EV_USE_ITEM14:
;5323:			break;
LABELV $2179
LABELV $2180
line 5325
;5324:	}
;5325:}
LABELV $2172
endproc BotCheckEvents 164 12
export BotCheckSnapshot
proc BotCheckSnapshot 216 16
line 5332
;5326:
;5327:/*
;5328:==================
;5329:BotCheckSnapshot
;5330:==================
;5331:*/
;5332:void BotCheckSnapshot(bot_state_t *bs) {
line 5337
;5333:	int ent;
;5334:	entityState_t state;
;5335:
;5336:	//remove all avoid spots
;5337:	trap_BotAddAvoidSpot(bs->ms, vec3_origin, 0, AVOID_CLEAR);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 vec3_origin
ARGP4
CNSTF4 0
ARGF4
CNSTI4 0
ARGI4
ADDRGP4 trap_BotAddAvoidSpot
CALLV
pop
line 5339
;5338:	//reset kamikaze body
;5339:	bs->kamikazebody = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6256
ADDP4
CNSTI4 0
ASGNI4
line 5341
;5340:	//reset number of proxmines
;5341:	bs->numproxmines = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6516
ADDP4
CNSTI4 0
ASGNI4
line 5343
;5342:	//
;5343:	ent = 0;
ADDRLP4 208
CNSTI4 0
ASGNI4
ADDRGP4 $2232
JUMPV
LABELV $2231
line 5344
;5344:	while( ( ent = BotAI_GetSnapshotEntity( bs->client, ent, &state ) ) != -1 ) {
line 5346
;5345:		//check the entity state for events
;5346:		BotCheckEvents(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckEvents
CALLV
pop
line 5348
;5347:		//check for grenades the bot should avoid
;5348:		BotCheckForGrenades(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckForGrenades
CALLV
pop
line 5356
;5349:		//
;5350:#ifdef MISSIONPACK
;5351:		//check for proximity mines which the bot should deactivate
;5352:		BotCheckForProxMines(bs, &state);
;5353:		//check for dead bodies with the kamikaze effect which should be gibbed
;5354:		BotCheckForKamikazeBody(bs, &state);
;5355:#endif
;5356:	}
LABELV $2232
line 5344
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 208
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 212
ADDRGP4 BotAI_GetSnapshotEntity
CALLI4
ASGNI4
ADDRLP4 208
ADDRLP4 212
INDIRI4
ASGNI4
ADDRLP4 212
INDIRI4
CNSTI4 -1
NEI4 $2231
line 5358
;5357:	//check the player state for events
;5358:	BotAI_GetEntityState(bs->client, &state);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotAI_GetEntityState
CALLI4
pop
line 5360
;5359:	//copy the player state events to the entity state
;5360:	state.event = bs->cur_ps.externalEvent;
ADDRLP4 0+180
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 5361
;5361:	state.eventParm = bs->cur_ps.externalEventParm;
ADDRLP4 0+184
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
ASGNI4
line 5363
;5362:	//
;5363:	BotCheckEvents(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckEvents
CALLV
pop
line 5364
;5364:}
LABELV $2230
endproc BotCheckSnapshot 216 16
export BotCheckAir
proc BotCheckAir 4 4
line 5371
;5365:
;5366:/*
;5367:==================
;5368:BotCheckAir
;5369:==================
;5370:*/
;5371:void BotCheckAir(bot_state_t *bs) {
line 5372
;5372:	if (bs->inventory[INVENTORY_ENVIRONMENTSUIT] <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5096
ADDP4
INDIRI4
CNSTI4 0
GTI4 $2237
line 5373
;5373:		if (trap_AAS_PointContents(bs->eye) & (CONTENTS_WATER|CONTENTS_SLIME|CONTENTS_LAVA)) {
ADDRFP4 0
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 0
ADDRGP4 trap_AAS_PointContents
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $2239
line 5374
;5374:			return;
ADDRGP4 $2236
JUMPV
LABELV $2239
line 5376
;5375:		}
;5376:	}
LABELV $2237
line 5377
;5377:	bs->lastair_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6176
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5378
;5378:}
LABELV $2236
endproc BotCheckAir 4 4
export BotAlternateRoute
proc BotAlternateRoute 16 16
line 5385
;5379:
;5380:/*
;5381:==================
;5382:BotAlternateRoute
;5383:==================
;5384:*/
;5385:bot_goal_t *BotAlternateRoute(bot_state_t *bs, bot_goal_t *goal) {
line 5389
;5386:	int t;
;5387:
;5388:	// if the bot has an alternative route goal
;5389:	if (bs->altroutegoal.areanum) {
ADDRFP4 0
INDIRP4
CNSTI4 6692
ADDP4
INDIRI4
CNSTI4 0
EQI4 $2242
line 5391
;5390:		//
;5391:		if (bs->reachedaltroutegoal_time)
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
INDIRF4
CNSTF4 0
EQF4 $2244
line 5392
;5392:			return goal;
ADDRFP4 4
INDIRP4
RETP4
ADDRGP4 $2241
JUMPV
LABELV $2244
line 5394
;5393:		// travel time towards alternative route goal
;5394:		t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, bs->altroutegoal.areanum, bs->tfl);
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 6692
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 8
INDIRI4
ASGNI4
line 5395
;5395:		if (t && t < 20) {
ADDRLP4 12
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $2246
ADDRLP4 12
INDIRI4
CNSTI4 20
GEI4 $2246
line 5397
;5396:			//BotAI_Print(PRT_MESSAGE, "reached alternate route goal\n");
;5397:			bs->reachedaltroutegoal_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5398
;5398:		}
LABELV $2246
line 5399
;5399:		memcpy(goal, &bs->altroutegoal, sizeof(bot_goal_t));
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 5400
;5400:		return &bs->altroutegoal;
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
RETP4
ADDRGP4 $2241
JUMPV
LABELV $2242
line 5402
;5401:	}
;5402:	return goal;
ADDRFP4 4
INDIRP4
RETP4
LABELV $2241
endproc BotAlternateRoute 16 16
export BotGetAlternateRouteGoal
proc BotGetAlternateRouteGoal 24 0
line 5410
;5403:}
;5404:
;5405:/*
;5406:==================
;5407:BotGetAlternateRouteGoal
;5408:==================
;5409:*/
;5410:int BotGetAlternateRouteGoal(bot_state_t *bs, int base) {
line 5415
;5411:	aas_altroutegoal_t *altroutegoals;
;5412:	bot_goal_t *goal;
;5413:	int numaltroutegoals, rnd;
;5414:
;5415:	if (base == TEAM_RED) {
ADDRFP4 4
INDIRI4
CNSTI4 1
NEI4 $2249
line 5416
;5416:		altroutegoals = red_altroutegoals;
ADDRLP4 12
ADDRGP4 red_altroutegoals
ASGNP4
line 5417
;5417:		numaltroutegoals = red_numaltroutegoals;
ADDRLP4 4
ADDRGP4 red_numaltroutegoals
INDIRI4
ASGNI4
line 5418
;5418:	}
ADDRGP4 $2250
JUMPV
LABELV $2249
line 5419
;5419:	else {
line 5420
;5420:		altroutegoals = blue_altroutegoals;
ADDRLP4 12
ADDRGP4 blue_altroutegoals
ASGNP4
line 5421
;5421:		numaltroutegoals = blue_numaltroutegoals;
ADDRLP4 4
ADDRGP4 blue_numaltroutegoals
INDIRI4
ASGNI4
line 5422
;5422:	}
LABELV $2250
line 5423
;5423:	if (!numaltroutegoals)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2251
line 5424
;5424:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2248
JUMPV
LABELV $2251
line 5425
;5425:	rnd = (float) random() * numaltroutegoals;
ADDRLP4 16
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 16
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRLP4 4
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 5426
;5426:	if (rnd >= numaltroutegoals)
ADDRLP4 8
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $2253
line 5427
;5427:		rnd = numaltroutegoals-1;
ADDRLP4 8
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $2253
line 5428
;5428:	goal = &bs->altroutegoal;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
ASGNP4
line 5429
;5429:	goal->areanum = altroutegoals[rnd].areanum;
ADDRLP4 20
CNSTI4 12
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
CNSTI4 24
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 12
INDIRP4
ADDP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ASGNI4
line 5430
;5430:	VectorCopy(altroutegoals[rnd].origin, goal->origin);
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDRLP4 8
INDIRI4
MULI4
ADDRLP4 12
INDIRP4
ADDP4
INDIRB
ASGNB 12
line 5431
;5431:	VectorSet(goal->mins, -8, -8, -8);
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 3238002688
ASGNF4
line 5432
;5432:	VectorSet(goal->maxs, 8, 8, 8);
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1090519040
ASGNF4
line 5433
;5433:	goal->entitynum = 0;
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTI4 0
ASGNI4
line 5434
;5434:	goal->iteminfo = 0;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 5435
;5435:	goal->number = 0;
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTI4 0
ASGNI4
line 5436
;5436:	goal->flags = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 5438
;5437:	//
;5438:	bs->reachedaltroutegoal_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
CNSTF4 0
ASGNF4
line 5439
;5439:	return qtrue;
CNSTI4 1
RETI4
LABELV $2248
endproc BotGetAlternateRouteGoal 24 0
export BotSetupAlternativeRouteGoals
proc BotSetupAlternativeRouteGoals 0 0
line 5447
;5440:}
;5441:
;5442:/*
;5443:==================
;5444:BotSetupAlternateRouteGoals
;5445:==================
;5446:*/
;5447:void BotSetupAlternativeRouteGoals(void) {
line 5449
;5448:
;5449:	if (altroutegoals_setup)
ADDRGP4 altroutegoals_setup
INDIRI4
CNSTI4 0
EQI4 $2256
line 5450
;5450:		return;
ADDRGP4 $2255
JUMPV
LABELV $2256
line 5519
;5451:#ifdef MISSIONPACK
;5452:	if (gametype == GT_CTF) {
;5453:		if (trap_BotGetLevelItemGoal(-1, "Neutral Flag", &ctf_neutralflag) < 0)
;5454:			BotAI_Print(PRT_WARNING, "no alt routes without Neutral Flag\n");
;5455:		if (ctf_neutralflag.areanum) {
;5456:			//
;5457:			red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5458:										ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5459:										ctf_redflag.origin, ctf_redflag.areanum, TFL_DEFAULT,
;5460:										red_altroutegoals, MAX_ALTROUTEGOALS,
;5461:										ALTROUTEGOAL_CLUSTERPORTALS|
;5462:										ALTROUTEGOAL_VIEWPORTALS);
;5463:			blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5464:										ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5465:										ctf_blueflag.origin, ctf_blueflag.areanum, TFL_DEFAULT,
;5466:										blue_altroutegoals, MAX_ALTROUTEGOALS,
;5467:										ALTROUTEGOAL_CLUSTERPORTALS|
;5468:										ALTROUTEGOAL_VIEWPORTALS);
;5469:		}
;5470:	}
;5471:	else if (gametype == GT_1FCTF) {
;5472:		//
;5473:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5474:									ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5475:									ctf_redflag.origin, ctf_redflag.areanum, TFL_DEFAULT,
;5476:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5477:									ALTROUTEGOAL_CLUSTERPORTALS|
;5478:									ALTROUTEGOAL_VIEWPORTALS);
;5479:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5480:									ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5481:									ctf_blueflag.origin, ctf_blueflag.areanum, TFL_DEFAULT,
;5482:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5483:									ALTROUTEGOAL_CLUSTERPORTALS|
;5484:									ALTROUTEGOAL_VIEWPORTALS);
;5485:	}
;5486:	else if (gametype == GT_OBELISK) {
;5487:		if (trap_BotGetLevelItemGoal(-1, "Neutral Obelisk", &neutralobelisk) < 0)
;5488:			BotAI_Print(PRT_WARNING, "Harvester without neutral obelisk\n");
;5489:		//
;5490:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5491:									neutralobelisk.origin, neutralobelisk.areanum,
;5492:									redobelisk.origin, redobelisk.areanum, TFL_DEFAULT,
;5493:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5494:									ALTROUTEGOAL_CLUSTERPORTALS|
;5495:									ALTROUTEGOAL_VIEWPORTALS);
;5496:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5497:									neutralobelisk.origin, neutralobelisk.areanum,
;5498:									blueobelisk.origin, blueobelisk.areanum, TFL_DEFAULT,
;5499:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5500:									ALTROUTEGOAL_CLUSTERPORTALS|
;5501:									ALTROUTEGOAL_VIEWPORTALS);
;5502:	}
;5503:	else if (gametype == GT_HARVESTER) {
;5504:		//
;5505:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5506:									neutralobelisk.origin, neutralobelisk.areanum,
;5507:									redobelisk.origin, redobelisk.areanum, TFL_DEFAULT,
;5508:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5509:									ALTROUTEGOAL_CLUSTERPORTALS|
;5510:									ALTROUTEGOAL_VIEWPORTALS);
;5511:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5512:									neutralobelisk.origin, neutralobelisk.areanum,
;5513:									blueobelisk.origin, blueobelisk.areanum, TFL_DEFAULT,
;5514:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5515:									ALTROUTEGOAL_CLUSTERPORTALS|
;5516:									ALTROUTEGOAL_VIEWPORTALS);
;5517:	}
;5518:#endif
;5519:	altroutegoals_setup = qtrue;
ADDRGP4 altroutegoals_setup
CNSTI4 1
ASGNI4
line 5520
;5520:}
LABELV $2255
endproc BotSetupAlternativeRouteGoals 0 0
export BotDeathmatchAI
proc BotDeathmatchAI 1492 20
line 5527
;5521:
;5522:/*
;5523:==================
;5524:BotDeathmatchAI
;5525:==================
;5526:*/
;5527:void BotDeathmatchAI(bot_state_t *bs, float thinktime) {
line 5533
;5528:	char gender[144], name[144], buf[144];
;5529:	char userinfo[MAX_INFO_STRING];
;5530:	int i;
;5531:
;5532:	//if the bot has just been setup
;5533:	if (bs->setupcount > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2259
line 5534
;5534:		bs->setupcount--;
ADDRLP4 1460
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
ASGNP4
ADDRLP4 1460
INDIRP4
ADDRLP4 1460
INDIRP4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 5535
;5535:		if (bs->setupcount > 0) return;
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2261
ADDRGP4 $2258
JUMPV
LABELV $2261
line 5537
;5536:		//get the gender characteristic
;5537:		trap_Characteristic_String(bs->character, CHARACTERISTIC_GENDER, gender, sizeof(gender));
ADDRFP4 0
INDIRP4
CNSTI4 6520
ADDP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 148
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 trap_Characteristic_String
CALLV
pop
line 5539
;5538:		//set the bot gender
;5539:		trap_GetUserinfo(bs->client, userinfo, sizeof(userinfo));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 292
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetUserinfo
CALLV
pop
line 5540
;5540:		Info_SetValueForKey(userinfo, "sex", gender);
ADDRLP4 292
ARGP4
ADDRGP4 $2263
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 Info_SetValueForKey
CALLV
pop
line 5541
;5541:		trap_SetUserinfo(bs->client, userinfo);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 292
ARGP4
ADDRGP4 trap_SetUserinfo
CALLV
pop
line 5543
;5542:		//set the team
;5543:		if ( !bs->map_restart && g_gametype.integer != GT_TOURNAMENT ) {
ADDRFP4 0
INDIRP4
CNSTI4 6020
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2264
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 1
EQI4 $2264
line 5544
;5544:			Com_sprintf(buf, sizeof(buf), "team %s", bs->settings.team);
ADDRLP4 1316
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 $2267
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 4756
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 5545
;5545:			trap_EA_Command(bs->client, buf);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 1316
ARGP4
ADDRGP4 trap_EA_Command
CALLV
pop
line 5546
;5546:		}
LABELV $2264
line 5548
;5547:		//set the chat gender
;5548:		if (gender[0] == 'm') trap_BotSetChatGender(bs->cs, CHAT_GENDERMALE);
ADDRLP4 148
INDIRI1
CVII4 1
CNSTI4 109
NEI4 $2268
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotSetChatGender
CALLV
pop
ADDRGP4 $2269
JUMPV
LABELV $2268
line 5549
;5549:		else if (gender[0] == 'f')  trap_BotSetChatGender(bs->cs, CHAT_GENDERFEMALE);
ADDRLP4 148
INDIRI1
CVII4 1
CNSTI4 102
NEI4 $2270
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotSetChatGender
CALLV
pop
ADDRGP4 $2271
JUMPV
LABELV $2270
line 5550
;5550:		else  trap_BotSetChatGender(bs->cs, CHAT_GENDERLESS);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 trap_BotSetChatGender
CALLV
pop
LABELV $2271
LABELV $2269
line 5552
;5551:		//set the chat name
;5552:		ClientName(bs->client, name, sizeof(name));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 ClientName
CALLP4
pop
line 5553
;5553:		trap_BotSetChatName(bs->cs, name, bs->client);
ADDRLP4 1464
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1464
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRLP4 1464
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotSetChatName
CALLV
pop
line 5555
;5554:		//
;5555:		bs->lastframe_health = bs->inventory[INVENTORY_HEALTH];
ADDRLP4 1468
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1468
INDIRP4
CNSTI4 6044
ADDP4
ADDRLP4 1468
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
ASGNI4
line 5556
;5556:		bs->lasthitcount = bs->cur_ps.persistant[PERS_HITS];
ADDRLP4 1472
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1472
INDIRP4
CNSTI4 6048
ADDP4
ADDRLP4 1472
INDIRP4
CNSTI4 268
ADDP4
INDIRI4
ASGNI4
line 5558
;5557:		//
;5558:		bs->setupcount = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
CNSTI4 0
ASGNI4
line 5560
;5559:		//
;5560:		BotSetupAlternativeRouteGoals();
ADDRGP4 BotSetupAlternativeRouteGoals
CALLV
pop
line 5561
;5561:	}
LABELV $2259
line 5563
;5562:	//no ideal view set
;5563:	bs->flags &= ~BFL_IDEALVIEWSET;
ADDRLP4 1460
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 1460
INDIRP4
ADDRLP4 1460
INDIRP4
INDIRI4
CNSTI4 -33
BANDI4
ASGNI4
line 5565
;5564:	//
;5565:	if (!BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1464
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 1464
INDIRI4
CNSTI4 0
NEI4 $2272
line 5567
;5566:		//set the teleport time
;5567:		BotSetTeleportTime(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeleportTime
CALLV
pop
line 5569
;5568:		//update some inventory values
;5569:		BotUpdateInventory(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotUpdateInventory
CALLV
pop
line 5571
;5570:		//check out the snapshot
;5571:		BotCheckSnapshot(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckSnapshot
CALLV
pop
line 5573
;5572:		//check for air
;5573:		BotCheckAir(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckAir
CALLV
pop
line 5574
;5574:	}
LABELV $2272
line 5576
;5575:	//check the console messages
;5576:	BotCheckConsoleMessages(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckConsoleMessages
CALLV
pop
line 5578
;5577:	//if not in the intermission and not in observer mode
;5578:	if (!BotIntermission(bs) && !BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1468
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 1468
INDIRI4
CNSTI4 0
NEI4 $2274
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1472
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 1472
INDIRI4
CNSTI4 0
NEI4 $2274
line 5580
;5579:		//do team AI
;5580:		BotTeamAI(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotTeamAI
CALLV
pop
line 5581
;5581:	}
LABELV $2274
line 5583
;5582:	//if the bot has no ai node
;5583:	if (!bs->ainode) {
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $2276
line 5584
;5584:		AIEnter_Seek_LTG(bs, "BotDeathmatchAI: no ai node");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2278
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 5585
;5585:	}
LABELV $2276
line 5587
;5586:	//if the bot entered the game less than 8 seconds ago
;5587:	if (!bs->entergamechat && bs->entergame_time > FloatTime() - 8) {
ADDRLP4 1476
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1476
INDIRP4
CNSTI4 6024
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2279
ADDRLP4 1476
INDIRP4
CNSTI4 6064
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1090519040
SUBF4
LEF4 $2279
line 5588
;5588:		if (BotChat_EnterGame(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1480
ADDRGP4 BotChat_EnterGame
CALLI4
ASGNI4
ADDRLP4 1480
INDIRI4
CNSTI4 0
EQI4 $2281
line 5589
;5589:			bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 1484
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1484
INDIRP4
ARGP4
ADDRLP4 1488
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 1484
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 1488
INDIRF4
ADDF4
ASGNF4
line 5590
;5590:			AIEnter_Stand(bs, "BotDeathmatchAI: chat enter game");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2283
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 5591
;5591:		}
LABELV $2281
line 5592
;5592:		bs->entergamechat = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6024
ADDP4
CNSTI4 1
ASGNI4
line 5593
;5593:	}
LABELV $2279
line 5595
;5594:	//reset the node switches from the previous frame
;5595:	BotResetNodeSwitches();
ADDRGP4 BotResetNodeSwitches
CALLV
pop
line 5597
;5596:	//execute AI nodes
;5597:	for (i = 0; i < MAX_NODESWITCHES; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $2284
line 5598
;5598:		if (bs->ainode(bs)) break;
ADDRLP4 1480
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1480
INDIRP4
ARGP4
ADDRLP4 1484
ADDRLP4 1480
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CALLI4
ASGNI4
ADDRLP4 1484
INDIRI4
CNSTI4 0
EQI4 $2288
ADDRGP4 $2286
JUMPV
LABELV $2288
line 5599
;5599:	}
LABELV $2285
line 5597
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 50
LTI4 $2284
LABELV $2286
line 5601
;5600:	//if the bot removed itself :)
;5601:	if (!bs->inuse) return;
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2290
ADDRGP4 $2258
JUMPV
LABELV $2290
line 5603
;5602:	//if the bot executed too many AI nodes
;5603:	if (i >= MAX_NODESWITCHES) {
ADDRLP4 0
INDIRI4
CNSTI4 50
LTI4 $2292
line 5604
;5604:		trap_BotDumpGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotDumpGoalStack
CALLV
pop
line 5605
;5605:		trap_BotDumpAvoidGoals(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotDumpAvoidGoals
CALLV
pop
line 5606
;5606:		BotDumpNodeSwitches(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotDumpNodeSwitches
CALLV
pop
line 5607
;5607:		ClientName(bs->client, name, sizeof(name));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 ClientName
CALLP4
pop
line 5608
;5608:		BotAI_Print(PRT_ERROR, "%s at %1.1f switched more than %d AI nodes\n", name, FloatTime(), MAX_NODESWITCHES);
CNSTI4 3
ARGI4
ADDRGP4 $2294
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 floattime
INDIRF4
ARGF4
CNSTI4 50
ARGI4
ADDRGP4 BotAI_Print
CALLV
pop
line 5609
;5609:	}
LABELV $2292
line 5611
;5610:	//
;5611:	bs->lastframe_health = bs->inventory[INVENTORY_HEALTH];
ADDRLP4 1480
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1480
INDIRP4
CNSTI4 6044
ADDP4
ADDRLP4 1480
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
ASGNI4
line 5612
;5612:	bs->lasthitcount = bs->cur_ps.persistant[PERS_HITS];
ADDRLP4 1484
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 1484
INDIRP4
CNSTI4 6048
ADDP4
ADDRLP4 1484
INDIRP4
CNSTI4 268
ADDP4
INDIRI4
ASGNI4
line 5613
;5613:}
LABELV $2258
endproc BotDeathmatchAI 1492 20
export BotSetEntityNumForGoalWithModel
proc BotSetEntityNumForGoalWithModel 44 4
line 5620
;5614:
;5615:/*
;5616:==================
;5617:BotSetEntityNumForGoalWithModel
;5618:==================
;5619:*/
;5620:void BotSetEntityNumForGoalWithModel(bot_goal_t *goal, int eType, char *modelname) {
line 5625
;5621:	gentity_t *ent;
;5622:	int i, modelindex;
;5623:	vec3_t dir;
;5624:
;5625:	modelindex = G_ModelIndex( modelname );
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 G_ModelIndex
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 24
INDIRI4
ASGNI4
line 5626
;5626:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 5627
;5627:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $2299
JUMPV
LABELV $2296
line 5628
;5628:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2301
line 5629
;5629:			continue;
ADDRGP4 $2297
JUMPV
LABELV $2301
line 5631
;5630:		}
;5631:		if ( eType && ent->s.eType != eType) {
ADDRLP4 28
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
EQI4 $2303
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $2303
line 5632
;5632:			continue;
ADDRGP4 $2297
JUMPV
LABELV $2303
line 5634
;5633:		}
;5634:		if (ent->s.modelindex != modelindex) {
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
EQI4 $2305
line 5635
;5635:			continue;
ADDRGP4 $2297
JUMPV
LABELV $2305
line 5637
;5636:		}
;5637:		VectorSubtract(goal->origin, ent->s.origin, dir);
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 32
INDIRP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 32
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
SUBF4
ASGNF4
line 5638
;5638:		if (VectorLengthSquared(dir) < Square(10)) {
ADDRLP4 4
ARGP4
ADDRLP4 40
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 40
INDIRF4
CNSTF4 1120403456
GEF4 $2309
line 5639
;5639:			goal->entitynum = i;
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 5640
;5640:			return;
ADDRGP4 $2295
JUMPV
LABELV $2309
line 5642
;5641:		}
;5642:	}
LABELV $2297
line 5627
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 884
ADDP4
ASGNP4
LABELV $2299
ADDRLP4 16
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $2296
line 5643
;5643:}
LABELV $2295
endproc BotSetEntityNumForGoalWithModel 44 4
export BotSetEntityNumForGoal
proc BotSetEntityNumForGoal 36 8
line 5650
;5644:
;5645:/*
;5646:==================
;5647:BotSetEntityNumForGoal
;5648:==================
;5649:*/
;5650:void BotSetEntityNumForGoal(bot_goal_t *goal, char *classname) {
line 5655
;5651:	gentity_t *ent;
;5652:	int i;
;5653:	vec3_t dir;
;5654:
;5655:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 5656
;5656:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $2315
JUMPV
LABELV $2312
line 5657
;5657:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2317
line 5658
;5658:			continue;
ADDRGP4 $2313
JUMPV
LABELV $2317
line 5660
;5659:		}
;5660:		if ( !Q_stricmp(ent->classname, classname) ) {
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $2319
line 5661
;5661:			continue;
ADDRGP4 $2313
JUMPV
LABELV $2319
line 5663
;5662:		}
;5663:		VectorSubtract(goal->origin, ent->s.origin, dir);
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRLP4 24
INDIRP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 24
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
SUBF4
ASGNF4
line 5664
;5664:		if (VectorLengthSquared(dir) < Square(10)) {
ADDRLP4 4
ARGP4
ADDRLP4 32
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 32
INDIRF4
CNSTF4 1120403456
GEF4 $2323
line 5665
;5665:			goal->entitynum = i;
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 5666
;5666:			return;
ADDRGP4 $2311
JUMPV
LABELV $2323
line 5668
;5667:		}
;5668:	}
LABELV $2313
line 5656
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 884
ADDP4
ASGNP4
LABELV $2315
ADDRLP4 16
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $2312
line 5669
;5669:}
LABELV $2311
endproc BotSetEntityNumForGoal 36 8
export BotGoalForBSPEntity
proc BotGoalForBSPEntity 1128 20
line 5676
;5670:
;5671:/*
;5672:==================
;5673:BotGoalForBSPEntity
;5674:==================
;5675:*/
;5676:int BotGoalForBSPEntity( char *classname, bot_goal_t *goal ) {
line 5681
;5677:	char value[MAX_INFO_STRING];
;5678:	vec3_t origin, start, end;
;5679:	int ent, numareas, areas[10];
;5680:
;5681:	memset(goal, 0, sizeof(bot_goal_t));
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 56
ARGI4
ADDRGP4 memset
CALLP4
pop
line 5682
;5682:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
CNSTI4 0
ARGI4
ADDRLP4 1108
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 1108
INDIRI4
ASGNI4
ADDRGP4 $2329
JUMPV
LABELV $2326
line 5683
;5683:		if (!trap_AAS_ValueForBSPEpairKey(ent, "classname", value, sizeof(value)))
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1893
ARGP4
ADDRLP4 4
ARGP4
CNSTI4 1024
ARGI4
ADDRLP4 1112
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 1112
INDIRI4
CNSTI4 0
NEI4 $2330
line 5684
;5684:			continue;
ADDRGP4 $2327
JUMPV
LABELV $2330
line 5685
;5685:		if (!strcmp(value, classname)) {
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1116
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 1116
INDIRI4
CNSTI4 0
NEI4 $2332
line 5686
;5686:			if (!trap_AAS_VectorForBSPEpairKey(ent, "origin", origin))
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1909
ARGP4
ADDRLP4 1028
ARGP4
ADDRLP4 1120
ADDRGP4 trap_AAS_VectorForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 1120
INDIRI4
CNSTI4 0
NEI4 $2334
line 5687
;5687:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2325
JUMPV
LABELV $2334
line 5688
;5688:			VectorCopy(origin, goal->origin);
ADDRFP4 4
INDIRP4
ADDRLP4 1028
INDIRB
ASGNB 12
line 5689
;5689:			VectorCopy(origin, start);
ADDRLP4 1040
ADDRLP4 1028
INDIRB
ASGNB 12
line 5690
;5690:			start[2] -= 32;
ADDRLP4 1040+8
ADDRLP4 1040+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 5691
;5691:			VectorCopy(origin, end);
ADDRLP4 1052
ADDRLP4 1028
INDIRB
ASGNB 12
line 5692
;5692:			end[2] += 32;
ADDRLP4 1052+8
ADDRLP4 1052+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 5693
;5693:			numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
ADDRLP4 1040
ARGP4
ADDRLP4 1052
ARGP4
ADDRLP4 1068
ARGP4
CNSTP4 0
ARGP4
CNSTI4 10
ARGI4
ADDRLP4 1124
ADDRGP4 trap_AAS_TraceAreas
CALLI4
ASGNI4
ADDRLP4 1064
ADDRLP4 1124
INDIRI4
ASGNI4
line 5694
;5694:			if (!numareas)
ADDRLP4 1064
INDIRI4
CNSTI4 0
NEI4 $2338
line 5695
;5695:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2325
JUMPV
LABELV $2338
line 5696
;5696:			goal->areanum = areas[0];
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 1068
INDIRI4
ASGNI4
line 5697
;5697:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2325
JUMPV
LABELV $2332
line 5699
;5698:		}
;5699:	}
LABELV $2327
line 5682
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 1112
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 1112
INDIRI4
ASGNI4
LABELV $2329
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $2326
line 5700
;5700:	return qfalse;
CNSTI4 0
RETI4
LABELV $2325
endproc BotGoalForBSPEntity 1128 20
proc BotAutoCTFFindReachableArea 120 20
line 5710
;5701:}
;5702:
;5703:/*
;5704:========================
;5705:BotAutoCTFFindReachableArea
;5706:========================
;5707:*/
;5708:static int BotAutoCTFFindReachableArea(
;5709:	vec3_t origin
;5710:) {
line 5718
;5711:	int area;
;5712:	int areas[16];
;5713:	int numAreas;
;5714:	int i;
;5715:	vec3_t start;
;5716:	vec3_t end;
;5717:
;5718:	area = trap_AAS_PointAreaNum( origin );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 100
ADDRGP4 trap_AAS_PointAreaNum
CALLI4
ASGNI4
ADDRLP4 72
ADDRLP4 100
INDIRI4
ASGNI4
line 5720
;5719:
;5720:	if( area &&
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $2341
ADDRLP4 72
INDIRI4
ARGI4
ADDRLP4 108
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 108
INDIRI4
CNSTI4 0
EQI4 $2341
line 5721
;5721:		trap_AAS_AreaReachability(area) ) {
line 5722
;5722:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $2340
JUMPV
LABELV $2341
line 5725
;5723:	}
;5724:
;5725:	VectorCopy( origin, start );
ADDRLP4 76
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 5726
;5726:	VectorCopy( origin, end );
ADDRLP4 88
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 5728
;5727:
;5728:	start[2] -= 64.0f;
ADDRLP4 76+8
ADDRLP4 76+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 5729
;5729:	end[2] += 64.0f;
ADDRLP4 88+8
ADDRLP4 88+8
INDIRF4
CNSTF4 1115684864
ADDF4
ASGNF4
line 5731
;5730:
;5731:	numAreas = trap_AAS_TraceAreas(
ADDRLP4 76
ARGP4
ADDRLP4 88
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
CNSTI4 16
ARGI4
ADDRLP4 112
ADDRGP4 trap_AAS_TraceAreas
CALLI4
ASGNI4
ADDRLP4 68
ADDRLP4 112
INDIRI4
ASGNI4
line 5739
;5732:		start,
;5733:		end,
;5734:		areas,
;5735:		NULL,
;5736:		16
;5737:	);
;5738:
;5739:	for( i = 0; i < numAreas; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $2348
JUMPV
LABELV $2345
line 5740
;5740:		if( trap_AAS_AreaReachability(areas[i]) ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
ARGI4
ADDRLP4 116
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 116
INDIRI4
CNSTI4 0
EQI4 $2349
line 5741
;5741:			return areas[i];
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
RETI4
ADDRGP4 $2340
JUMPV
LABELV $2349
line 5743
;5742:		}
;5743:	}
LABELV $2346
line 5739
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $2348
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $2345
line 5745
;5744:
;5745:	return 0;
CNSTI4 0
RETI4
LABELV $2340
endproc BotAutoCTFFindReachableArea 120 20
proc BotSetupAutoCTFFlagGoal 20 12
line 5757
;5746:}
;5747:
;5748:/*
;5749:========================
;5750:BotSetupAutoCTFFlagGoal
;5751:========================
;5752:*/
;5753:static qboolean BotSetupAutoCTFFlagGoal(
;5754:	const char *classname,
;5755:	bot_goal_t *goal,
;5756:	int goalNumber
;5757:) {
line 5761
;5758:	gentity_t *flag;
;5759:	int area;
;5760:
;5761:	flag = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $2353
JUMPV
LABELV $2352
line 5767
;5762:
;5763:	while( (flag = G_Find(
;5764:		flag,
;5765:		FOFS(classname),
;5766:		classname
;5767:	)) != NULL ) {
line 5768
;5768:		if( !(flag->flags & FL_DROPPED_ITEM) ) {
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $2355
line 5769
;5769:			break;
ADDRGP4 $2354
JUMPV
LABELV $2355
line 5771
;5770:		}
;5771:	}
LABELV $2353
line 5763
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $2352
LABELV $2354
line 5773
;5772:
;5773:	if( !flag ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $2357
line 5774
;5774:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2351
JUMPV
LABELV $2357
line 5777
;5775:	}
;5776:
;5777:	area = BotAutoCTFFindReachableArea(
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
ARGP4
ADDRLP4 12
ADDRGP4 BotAutoCTFFindReachableArea
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ASGNI4
line 5781
;5778:		flag->r.currentOrigin
;5779:	);
;5780:
;5781:	if( !area ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2359
line 5782
;5782:		area = BotAutoCTFFindReachableArea(
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 16
ADDRGP4 BotAutoCTFFindReachableArea
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 16
INDIRI4
ASGNI4
line 5785
;5783:			flag->s.origin
;5784:		);
;5785:	}
LABELV $2359
line 5787
;5786:
;5787:	if( !area ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2361
line 5788
;5788:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2351
JUMPV
LABELV $2361
line 5791
;5789:	}
;5790:
;5791:	memset( goal, 0, sizeof(*goal) );
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 56
ARGI4
ADDRGP4 memset
CALLP4
pop
line 5793
;5792:
;5793:	VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 5802
;5794:		flag->r.currentOrigin,
;5795:		goal->origin
;5796:	);
;5797:
;5798:	/*
;5799:	 * During early initialization currentOrigin can still
;5800:	 * contain zeroes. In that case use the entity origin.
;5801:	 */
;5802:	if( VectorLengthSquared(goal->origin) < 1.0f ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 1065353216
GEF4 $2363
line 5803
;5803:		VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 5807
;5804:			flag->s.origin,
;5805:			goal->origin
;5806:		);
;5807:	}
LABELV $2363
line 5809
;5808:
;5809:	goal->areanum = area;
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 5811
;5810:
;5811:	VectorSet(
ADDRFP4 4
INDIRP4
CNSTI4 16
ADDP4
CNSTF4 3250585600
ASGNF4
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
CNSTF4 3250585600
ASGNF4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 3250585600
ASGNF4
line 5818
;5812:		goal->mins,
;5813:		-24.0f,
;5814:		-24.0f,
;5815:		-24.0f
;5816:	);
;5817:
;5818:	VectorSet(
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1103101952
ASGNF4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1103101952
ASGNF4
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1109393408
ASGNF4
line 5825
;5819:		goal->maxs,
;5820:		24.0f,
;5821:		24.0f,
;5822:		40.0f
;5823:	);
;5824:
;5825:	goal->entitynum = flag - g_entities;
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ASGNI4
line 5826
;5826:	goal->number = goalNumber;
ADDRFP4 4
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 5827
;5827:	goal->flags = 0;
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 5828
;5828:	goal->iteminfo = 0;
ADDRFP4 4
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 5830
;5829:
;5830:	return qtrue;
CNSTI4 1
RETI4
LABELV $2351
endproc BotSetupAutoCTFFlagGoal 20 12
export BotSetupDeathmatchAI
proc BotSetupDeathmatchAI 160 16
line 5838
;5831:}
;5832:
;5833:/*
;5834:==================
;5835:BotSetupDeathmatchAI
;5836:==================
;5837:*/
;5838:void BotSetupDeathmatchAI(void) {
line 5842
;5839:	int ent, modelnum;
;5840:	char model[128];
;5841:
;5842:	gametype = trap_Cvar_VariableIntegerValue("g_gametype");
ADDRGP4 $2366
ARGP4
ADDRLP4 136
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 gametype
ADDRLP4 136
INDIRI4
ASGNI4
line 5843
;5843:	maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $296
ARGP4
ADDRLP4 140
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 maxclients
ADDRLP4 140
INDIRI4
ASGNI4
line 5845
;5844:
;5845:	trap_Cvar_Register(&bot_rocketjump, "bot_rocketjump", "1", 0);
ADDRGP4 bot_rocketjump
ARGP4
ADDRGP4 $2367
ARGP4
ADDRGP4 $2156
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5846
;5846:	trap_Cvar_Register(&bot_grapple, "bot_grapple", "0", 0);
ADDRGP4 bot_grapple
ARGP4
ADDRGP4 $2368
ARGP4
ADDRGP4 $2369
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5847
;5847:	trap_Cvar_Register(&bot_fastchat, "bot_fastchat", "0", 0);
ADDRGP4 bot_fastchat
ARGP4
ADDRGP4 $2370
ARGP4
ADDRGP4 $2369
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5848
;5848:	trap_Cvar_Register(&bot_nochat, "bot_nochat", "0", 0);
ADDRGP4 bot_nochat
ARGP4
ADDRGP4 $2371
ARGP4
ADDRGP4 $2369
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5849
;5849:	trap_Cvar_Register(&bot_testrchat, "bot_testrchat", "0", 0);
ADDRGP4 bot_testrchat
ARGP4
ADDRGP4 $2155
ARGP4
ADDRGP4 $2369
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5850
;5850:	trap_Cvar_Register(&bot_challenge, "bot_challenge", "0", 0);
ADDRGP4 bot_challenge
ARGP4
ADDRGP4 $2372
ARGP4
ADDRGP4 $2369
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5851
;5851:	trap_Cvar_Register(&bot_predictobstacles, "bot_predictobstacles", "1", 0);
ADDRGP4 bot_predictobstacles
ARGP4
ADDRGP4 $2373
ARGP4
ADDRGP4 $2156
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5852
;5852:	trap_Cvar_Register(&g_spSkill, "g_spSkill", "2", 0);
ADDRGP4 g_spSkill
ARGP4
ADDRGP4 $2374
ARGP4
ADDRGP4 $2375
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5854
;5853:	//
;5854:	if( gametype == GT_CTF ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $2376
line 5855
;5855:		if( trap_BotGetLevelItemGoal(
CNSTI4 -1
ARGI4
ADDRGP4 $2380
ARGP4
ADDRGP4 ctf_redflag
ARGP4
ADDRLP4 144
ADDRGP4 trap_BotGetLevelItemGoal
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
GEI4 $2378
line 5859
;5856:			-1,
;5857:			"Red Flag",
;5858:			&ctf_redflag
;5859:		) < 0 ) {
line 5860
;5860:			if( trap_Cvar_VariableIntegerValue(
ADDRGP4 $2383
ARGP4
ADDRLP4 148
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
EQI4 $2381
ADDRGP4 $2384
ARGP4
ADDRGP4 ctf_redflag
ARGP4
CNSTI4 10001
ARGI4
ADDRLP4 152
ADDRGP4 BotSetupAutoCTFFlagGoal
CALLI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 0
EQI4 $2381
line 5867
;5861:				"g_autoCTF"
;5862:			) &&
;5863:				BotSetupAutoCTFFlagGoal(
;5864:					"team_CTF_redflag",
;5865:					&ctf_redflag,
;5866:					10001
;5867:				) ) {
line 5868
;5868:				BotAI_Print(
CNSTI4 1
ARGI4
ADDRGP4 $2385
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5872
;5869:					PRT_MESSAGE,
;5870:					"Auto CTF: Red Flag bot goal created.\n"
;5871:				);
;5872:			}
ADDRGP4 $2382
JUMPV
LABELV $2381
line 5873
;5873:			else {
line 5874
;5874:				BotAI_Print(
CNSTI4 2
ARGI4
ADDRGP4 $2386
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5878
;5875:					PRT_WARNING,
;5876:					"CTF without reachable Red Flag\n"
;5877:				);
;5878:			}
LABELV $2382
line 5879
;5879:		}
LABELV $2378
line 5881
;5880:
;5881:		if( trap_BotGetLevelItemGoal(
CNSTI4 -1
ARGI4
ADDRGP4 $2389
ARGP4
ADDRGP4 ctf_blueflag
ARGP4
ADDRLP4 148
ADDRGP4 trap_BotGetLevelItemGoal
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
GEI4 $2387
line 5885
;5882:			-1,
;5883:			"Blue Flag",
;5884:			&ctf_blueflag
;5885:		) < 0 ) {
line 5886
;5886:			if( trap_Cvar_VariableIntegerValue(
ADDRGP4 $2383
ARGP4
ADDRLP4 152
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 0
EQI4 $2390
ADDRGP4 $2392
ARGP4
ADDRGP4 ctf_blueflag
ARGP4
CNSTI4 10002
ARGI4
ADDRLP4 156
ADDRGP4 BotSetupAutoCTFFlagGoal
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
EQI4 $2390
line 5893
;5887:				"g_autoCTF"
;5888:			) &&
;5889:				BotSetupAutoCTFFlagGoal(
;5890:					"team_CTF_blueflag",
;5891:					&ctf_blueflag,
;5892:					10002
;5893:				) ) {
line 5894
;5894:				BotAI_Print(
CNSTI4 1
ARGI4
ADDRGP4 $2393
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5898
;5895:					PRT_MESSAGE,
;5896:					"Auto CTF: Blue Flag bot goal created.\n"
;5897:				);
;5898:			}
ADDRGP4 $2391
JUMPV
LABELV $2390
line 5899
;5899:			else {
line 5900
;5900:				BotAI_Print(
CNSTI4 2
ARGI4
ADDRGP4 $2394
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5904
;5901:					PRT_WARNING,
;5902:					"CTF without reachable Blue Flag\n"
;5903:				);
;5904:			}
LABELV $2391
line 5905
;5905:		}
LABELV $2387
line 5906
;5906:	}
LABELV $2376
line 5937
;5907:#ifdef MISSIONPACK
;5908:	else if (gametype == GT_1FCTF) {
;5909:		if (trap_BotGetLevelItemGoal(-1, "Neutral Flag", &ctf_neutralflag) < 0)
;5910:			BotAI_Print(PRT_WARNING, "One Flag CTF without Neutral Flag\n");
;5911:		if (trap_BotGetLevelItemGoal(-1, "Red Flag", &ctf_redflag) < 0)
;5912:			BotAI_Print(PRT_WARNING, "CTF without Red Flag\n");
;5913:		if (trap_BotGetLevelItemGoal(-1, "Blue Flag", &ctf_blueflag) < 0)
;5914:			BotAI_Print(PRT_WARNING, "CTF without Blue Flag\n");
;5915:	}
;5916:	else if (gametype == GT_OBELISK) {
;5917:		if (trap_BotGetLevelItemGoal(-1, "Red Obelisk", &redobelisk) < 0)
;5918:			BotAI_Print(PRT_WARNING, "Obelisk without red obelisk\n");
;5919:		BotSetEntityNumForGoal(&redobelisk, "team_redobelisk");
;5920:		if (trap_BotGetLevelItemGoal(-1, "Blue Obelisk", &blueobelisk) < 0)
;5921:			BotAI_Print(PRT_WARNING, "Obelisk without blue obelisk\n");
;5922:		BotSetEntityNumForGoal(&blueobelisk, "team_blueobelisk");
;5923:	}
;5924:	else if (gametype == GT_HARVESTER) {
;5925:		if (trap_BotGetLevelItemGoal(-1, "Red Obelisk", &redobelisk) < 0)
;5926:			BotAI_Print(PRT_WARNING, "Harvester without red obelisk\n");
;5927:		BotSetEntityNumForGoal(&redobelisk, "team_redobelisk");
;5928:		if (trap_BotGetLevelItemGoal(-1, "Blue Obelisk", &blueobelisk) < 0)
;5929:			BotAI_Print(PRT_WARNING, "Harvester without blue obelisk\n");
;5930:		BotSetEntityNumForGoal(&blueobelisk, "team_blueobelisk");
;5931:		if (trap_BotGetLevelItemGoal(-1, "Neutral Obelisk", &neutralobelisk) < 0)
;5932:			BotAI_Print(PRT_WARNING, "Harvester without neutral obelisk\n");
;5933:		BotSetEntityNumForGoal(&neutralobelisk, "team_neutralobelisk");
;5934:	}
;5935:#endif
;5936:
;5937:	max_bspmodelindex = 0;
ADDRGP4 max_bspmodelindex
CNSTI4 0
ASGNI4
line 5938
;5938:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
CNSTI4 0
ARGI4
ADDRLP4 144
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 144
INDIRI4
ASGNI4
ADDRGP4 $2398
JUMPV
LABELV $2395
line 5939
;5939:		if (!trap_AAS_ValueForBSPEpairKey(ent, "model", model, sizeof(model))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $291
ARGP4
ADDRLP4 4
ARGP4
CNSTI4 128
ARGI4
ADDRLP4 148
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2399
ADDRGP4 $2396
JUMPV
LABELV $2399
line 5940
;5940:		if (model[0] == '*') {
ADDRLP4 4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $2401
line 5941
;5941:			modelnum = atoi(model+1);
ADDRLP4 4+1
ARGP4
ADDRLP4 152
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 132
ADDRLP4 152
INDIRI4
ASGNI4
line 5942
;5942:			if (modelnum > max_bspmodelindex)
ADDRLP4 132
INDIRI4
ADDRGP4 max_bspmodelindex
INDIRI4
LEI4 $2404
line 5943
;5943:				max_bspmodelindex = modelnum;
ADDRGP4 max_bspmodelindex
ADDRLP4 132
INDIRI4
ASGNI4
LABELV $2404
line 5944
;5944:		}
LABELV $2401
line 5945
;5945:	}
LABELV $2396
line 5938
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 148
ADDRGP4 trap_AAS_NextBSPEntity
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 148
INDIRI4
ASGNI4
LABELV $2398
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $2395
line 5947
;5946:	//initialize the waypoint heap
;5947:	BotInitWaypoints();
ADDRGP4 BotInitWaypoints
CALLV
pop
line 5948
;5948:}
LABELV $2365
endproc BotSetupDeathmatchAI 160 16
export BotShutdownDeathmatchAI
proc BotShutdownDeathmatchAI 0 0
line 5955
;5949:
;5950:/*
;5951:==================
;5952:BotShutdownDeathmatchAI
;5953:==================
;5954:*/
;5955:void BotShutdownDeathmatchAI(void) {
line 5956
;5956:	altroutegoals_setup = qfalse;
ADDRGP4 altroutegoals_setup
CNSTI4 0
ASGNI4
line 5957
;5957:}
LABELV $2406
endproc BotShutdownDeathmatchAI 0 0
bss
export blue_numaltroutegoals
align 4
LABELV blue_numaltroutegoals
skip 4
export blue_altroutegoals
align 4
LABELV blue_altroutegoals
skip 768
export red_numaltroutegoals
align 4
LABELV red_numaltroutegoals
skip 4
export red_altroutegoals
align 4
LABELV red_altroutegoals
skip 768
export altroutegoals_setup
align 4
LABELV altroutegoals_setup
skip 4
export max_bspmodelindex
align 4
LABELV max_bspmodelindex
skip 4
export lastteleport_time
align 4
LABELV lastteleport_time
skip 4
export lastteleport_origin
align 4
LABELV lastteleport_origin
skip 12
import bot_developer
export g_spSkill
align 4
LABELV g_spSkill
skip 272
export bot_predictobstacles
align 4
LABELV bot_predictobstacles
skip 272
export botai_freewaypoints
align 4
LABELV botai_freewaypoints
skip 4
export botai_waypoints
align 4
LABELV botai_waypoints
skip 12800
import BotVoiceChatOnly
import BotVoiceChat
import BotSetTeamMateTaskPreference
import BotGetTeamMateTaskPreference
import BotTeamAI
import BotDumpNodeSwitches
import BotResetNodeSwitches
import AINode_Battle_NBG
import AINode_Battle_Retreat
import AINode_Battle_Chase
import AINode_Battle_Fight
import AINode_Seek_LTG
import AINode_Seek_NBG
import AINode_Seek_ActivateEntity
import AINode_Stand
import AINode_Respawn
import AINode_Observer
import AINode_Intermission
import AIEnter_Battle_NBG
import AIEnter_Battle_Retreat
import AIEnter_Battle_Chase
import AIEnter_Battle_Fight
import AIEnter_Seek_Camp
import AIEnter_Seek_LTG
import AIEnter_Seek_NBG
import AIEnter_Seek_ActivateEntity
import AIEnter_Stand
import AIEnter_Respawn
import AIEnter_Observer
import AIEnter_Intermission
import BotPrintTeamGoal
import BotMatchMessage
import notleader
import BotChatTest
import BotValidChatPosition
import BotChatTime
import BotChat_Random
import BotChat_EnemySuicide
import BotChat_Kill
import BotChat_Death
import BotChat_HitNoKill
import BotChat_HitNoDeath
import BotChat_HitTalking
import BotChat_EndLevel
import BotChat_StartLevel
import BotChat_ExitGame
import BotChat_EnterGame
import BotAssaultSeekGoals
export ctf_blueflag
align 4
LABELV ctf_blueflag
skip 56
export ctf_redflag
align 4
LABELV ctf_redflag
skip 56
export bot_challenge
align 4
LABELV bot_challenge
skip 272
export bot_testrchat
align 4
LABELV bot_testrchat
skip 272
export bot_nochat
align 4
LABELV bot_nochat
skip 272
export bot_fastchat
align 4
LABELV bot_fastchat
skip 272
export bot_rocketjump
align 4
LABELV bot_rocketjump
skip 272
export bot_grapple
align 4
LABELV bot_grapple
skip 272
export maxclients
align 4
LABELV maxclients
skip 4
export gametype
align 4
LABELV gametype
skip 4
import BotTeamLeader
import BotAI_GetSnapshotEntity
import BotAI_GetEntityState
import BotAI_GetClientState
import BotAI_Trace
import BotAI_BotInitialChat
import BotAI_Print
import floattime
import BotEntityInfo
import NumBots
import BotResetState
import BotResetWeaponState
import BotFreeWeaponState
import BotAllocWeaponState
import BotLoadWeaponWeights
import BotGetWeaponInfo
import BotChooseBestFightWeapon
import BotShutdownWeaponAI
import BotSetupWeaponAI
import BotShutdownMoveAI
import BotSetupMoveAI
import BotSetBrushModelTypes
import BotAddAvoidSpot
import BotInitMoveState
import BotFreeMoveState
import BotAllocMoveState
import BotPredictVisiblePosition
import BotMovementViewTarget
import BotReachabilityArea
import BotResetLastAvoidReach
import BotResetAvoidReach
import BotMoveInDirection
import BotMoveToGoal
import BotResetMoveState
import BotShutdownGoalAI
import BotSetupGoalAI
import BotFreeGoalState
import BotAllocGoalState
import BotFreeItemWeights
import BotLoadItemWeights
import BotMutateGoalFuzzyLogic
import BotSaveGoalFuzzyLogic
import BotInterbreedGoalFuzzyLogic
import BotUpdateEntityItems
import BotInitLevelItems
import BotSetAvoidGoalTime
import BotAvoidGoalTime
import BotGetMapLocationGoal
import BotGetNextCampSpotGoal
import BotGetLevelItemGoal
import BotItemGoalInVisButNotVisible
import BotTouchingGoal
import BotChooseNBGItem
import BotChooseLTGItem
import BotGetSecondGoal
import BotGetTopGoal
import BotGoalName
import BotDumpGoalStack
import BotDumpAvoidGoals
import BotEmptyGoalStack
import BotPopGoal
import BotPushGoal
import BotRemoveFromAvoidGoals
import BotResetAvoidGoals
import BotResetGoalState
import GeneticParentsAndChildSelection
import BotSetChatName
import BotSetChatGender
import BotLoadChatFile
import BotReplaceSynonyms
import UnifyWhiteSpaces
import BotMatchVariable
import BotFindMatch
import StringContains
import BotGetChatMessage
import BotEnterChat
import BotChatLength
import BotReplyChat
import BotNumInitialChats
import BotInitialChat
import BotNumConsoleMessages
import BotNextConsoleMessage
import BotRemoveConsoleMessage
import BotQueueConsoleMessage
import BotFreeChatState
import BotAllocChatState
import BotShutdownChatAI
import BotSetupChatAI
import BotShutdownCharacters
import Characteristic_String
import Characteristic_BInteger
import Characteristic_Integer
import Characteristic_BFloat
import Characteristic_Float
import BotFreeCharacter
import BotLoadCharacter
import EA_Shutdown
import EA_Setup
import EA_ResetInput
import EA_GetInput
import EA_EndRegular
import EA_View
import EA_Move
import EA_DelayedJump
import EA_Jump
import EA_SelectWeapon
import EA_Use
import EA_Gesture
import EA_Talk
import EA_Respawn
import EA_Attack
import EA_MoveRight
import EA_MoveLeft
import EA_MoveBack
import EA_MoveForward
import EA_MoveDown
import EA_MoveUp
import EA_Walk
import EA_Crouch
import EA_Action
import EA_Command
import EA_SayTeam
import EA_Say
import GetBotLibAPI
import G_MonsterTryReplaceItem
import G_FindAutomaticBaseSpots
import G_MonsterRunFrame
import G_MonsterInitDefinitions
import g_monsterDefLoaded
import g_monsterDefs
import G_AutoCTFInit
import trap_SnapVector
import trap_GeneticParentsAndChildSelection
import trap_BotResetWeaponState
import trap_BotFreeWeaponState
import trap_BotAllocWeaponState
import trap_BotLoadWeaponWeights
import trap_BotGetWeaponInfo
import trap_BotChooseBestFightWeapon
import trap_BotAddAvoidSpot
import trap_BotInitMoveState
import trap_BotFreeMoveState
import trap_BotAllocMoveState
import trap_BotPredictVisiblePosition
import trap_BotMovementViewTarget
import trap_BotReachabilityArea
import trap_BotResetLastAvoidReach
import trap_BotResetAvoidReach
import trap_BotMoveInDirection
import trap_BotMoveToGoal
import trap_BotResetMoveState
import trap_BotFreeGoalState
import trap_BotAllocGoalState
import trap_BotMutateGoalFuzzyLogic
import trap_BotSaveGoalFuzzyLogic
import trap_BotInterbreedGoalFuzzyLogic
import trap_BotFreeItemWeights
import trap_BotLoadItemWeights
import trap_BotUpdateEntityItems
import trap_BotInitLevelItems
import trap_BotSetAvoidGoalTime
import trap_BotAvoidGoalTime
import trap_BotGetLevelItemGoal
import trap_BotGetMapLocationGoal
import trap_BotGetNextCampSpotGoal
import trap_BotItemGoalInVisButNotVisible
import trap_BotTouchingGoal
import trap_BotChooseNBGItem
import trap_BotChooseLTGItem
import trap_BotGetSecondGoal
import trap_BotGetTopGoal
import trap_BotGoalName
import trap_BotDumpGoalStack
import trap_BotDumpAvoidGoals
import trap_BotEmptyGoalStack
import trap_BotPopGoal
import trap_BotPushGoal
import trap_BotResetAvoidGoals
import trap_BotRemoveFromAvoidGoals
import trap_BotResetGoalState
import trap_BotSetChatName
import trap_BotSetChatGender
import trap_BotLoadChatFile
import trap_BotReplaceSynonyms
import trap_UnifyWhiteSpaces
import trap_BotMatchVariable
import trap_BotFindMatch
import trap_StringContains
import trap_BotGetChatMessage
import trap_BotEnterChat
import trap_BotChatLength
import trap_BotReplyChat
import trap_BotNumInitialChats
import trap_BotInitialChat
import trap_BotNumConsoleMessages
import trap_BotNextConsoleMessage
import trap_BotRemoveConsoleMessage
import trap_BotQueueConsoleMessage
import trap_BotFreeChatState
import trap_BotAllocChatState
import trap_Characteristic_String
import trap_Characteristic_BInteger
import trap_Characteristic_Integer
import trap_Characteristic_BFloat
import trap_Characteristic_Float
import trap_BotFreeCharacter
import trap_BotLoadCharacter
import trap_EA_ResetInput
import trap_EA_GetInput
import trap_EA_EndRegular
import trap_EA_View
import trap_EA_Move
import trap_EA_DelayedJump
import trap_EA_Jump
import trap_EA_SelectWeapon
import trap_EA_MoveRight
import trap_EA_MoveLeft
import trap_EA_MoveBack
import trap_EA_MoveForward
import trap_EA_MoveDown
import trap_EA_MoveUp
import trap_EA_Crouch
import trap_EA_Respawn
import trap_EA_Use
import trap_EA_Attack
import trap_EA_Talk
import trap_EA_Gesture
import trap_EA_Action
import trap_EA_Command
import trap_EA_SayTeam
import trap_EA_Say
import trap_AAS_PredictClientMovement
import trap_AAS_Swimming
import trap_AAS_AlternativeRouteGoals
import trap_AAS_PredictRoute
import trap_AAS_EnableRoutingArea
import trap_AAS_AreaTravelTimeToGoalArea
import trap_AAS_AreaReachability
import trap_AAS_IntForBSPEpairKey
import trap_AAS_FloatForBSPEpairKey
import trap_AAS_VectorForBSPEpairKey
import trap_AAS_ValueForBSPEpairKey
import trap_AAS_NextBSPEntity
import trap_AAS_PointContents
import trap_AAS_TraceAreas
import trap_AAS_PointReachabilityAreaIndex
import trap_AAS_PointAreaNum
import trap_AAS_Time
import trap_AAS_PresenceTypeBoundingBox
import trap_AAS_Initialized
import trap_AAS_EntityInfo
import trap_AAS_AreaInfo
import trap_AAS_BBoxAreas
import trap_BotUserCommand
import trap_BotGetServerCommand
import trap_BotGetSnapshotEntity
import trap_BotLibTest
import trap_BotLibUpdateEntity
import trap_BotLibLoadMap
import trap_BotLibStartFrame
import trap_BotLibDefine
import trap_BotLibVarGet
import trap_BotLibVarSet
import trap_BotLibShutdown
import trap_BotLibSetup
import trap_DebugPolygonDelete
import trap_DebugPolygonCreate
import trap_GetEntityToken
import trap_GetUsercmd
import trap_BotFreeClient
import trap_BotAllocateClient
import trap_EntityContact
import trap_EntitiesInBox
import trap_UnlinkEntity
import trap_LinkEntity
import trap_AreasConnected
import trap_AdjustAreaPortalState
import trap_InPVSIgnorePortals
import trap_InPVS
import trap_PointContents
import trap_Trace
import trap_SetBrushModel
import trap_GetServerinfo
import trap_SetUserinfo
import trap_GetUserinfo
import trap_GetConfigstring
import trap_SetConfigstring
import trap_SendServerCommand
import trap_DropClient
import trap_LocateGameData
import trap_Cvar_VariableStringBuffer
import trap_Cvar_VariableValue
import trap_Cvar_VariableIntegerValue
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_SendConsoleCommand
import trap_FS_Seek
import trap_FS_GetFileList
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_Milliseconds
import trap_Error
import trap_Printf
import g_proxMineTimeout
import g_singlePlayer
import g_enableBreath
import g_enableDust
import g_rankings
import pmove_msec
import pmove_fixed
import g_smoothClients
import g_blueteam
import g_redteam
import g_cubeTimeout
import g_obeliskRespawnDelay
import g_obeliskRegenAmount
import g_obeliskRegenPeriod
import g_obeliskHealth
import g_filterBan
import g_banIPs
import g_teamForceBalance
import g_teamAutoJoin
import g_allowVote
import g_blood
import g_doWarmup
import g_warmup
import g_motd
import g_synchronousClients
import g_weaponTeamRespawn
import g_weaponRespawn
import g_debugDamage
import g_debugAlloc
import g_debugMove
import g_inactivity
import g_forcerespawn
import g_quadfactor
import g_knockback
import g_speed
import g_gravity
import g_needpass
import g_password
import g_friendlyFire
import g_capturelimit
import g_timelimit
import g_fraglimit
import g_dmflags
import g_restarted
import g_maxGameClients
import g_maxclients
import g_cheats
import g_dedicated
import g_gametype
import g_noPowerups
import g_noMedkit
import g_noMegaHealth
import g_noGrenadeRocket
import g_noPlasmaBFG
import g_noRailgun
import g_noPersonalTeleporter
import g_blasterMode
import g_baseTDM
import g_oneLifeTDM
import g_noArmor
import g_noHealth
import g_playerHealth
import g_randomStartWeapon
import g_scavengerWeapons
import g_assaultMiddleItem
import g_assaultRadius
import g_assaultRoundTime
import g_assaultHoldTime
import g_assaultMode
import g_autoCTF
import g_respawnTime
import g_monsterHunt
import G_AssaultGetActiveGoal
import G_AssaultClientCommand
import G_AssaultRunFrame
import G_AssaultInit
import G_AssaultControlsExitRules
import G_AssaultBlocksWarmup
import G_AssaultEnabled
import g_entities
import level
import Pickup_Team
import CheckTeamStatus
import TeamplayInfoMessage
import Team_GetLocationMsg
import Team_GetLocation
import SelectCTFSpawnPoint
import Team_FreeEntity
import Team_ReturnFlag
import Team_InitGame
import Team_CheckHurtCarrier
import Team_FragBonuses
import Team_DroppedFlagThink
import AddTeamScore
import TeamColorString
import OtherTeamName
import TeamName
import OtherTeam
import BotTestAAS
import BotAIStartFrame
import BotAIShutdownClient
import BotAISetupClient
import BotAILoadMap
import BotAIShutdown
import BotAISetup
import BotInterbreedEndMatch
import Svcmd_BotList_f
import Svcmd_AddBot_f
import G_BotConnect
import G_RemoveQueuedBotBegin
import G_CheckBotSpawn
import G_GetBotInfoByName
import G_GetBotInfoByNumber
import G_InitBots
import Svcmd_AbortPodium_f
import SpawnModelsOnVictoryPads
import UpdateTournamentInfo
import G_WriteSessionData
import G_InitWorldSession
import G_InitSessionData
import G_ReadSessionData
import Svcmd_GameMem_f
import G_InitMemory
import G_Alloc
import CheckObeliskAttack
import Team_CheckDroppedItem
import OnSameTeam
import G_RunClient
import ClientEndFrame
import ClientThink
import ClientCommand
import ClientBegin
import ClientDisconnect
import ClientUserinfoChanged
import ClientConnect
import G_Error
import G_Printf
import SendScoreboardMessageToAllClients
import LogExit
import G_LogPrintf
import G_RunThink
import CheckTeamLeader
import SetLeader
import FindIntermissionPoint
import DeathmatchScoreboardMessage
import G_SetStats
import MoveClientToIntermission
import FireWeapon
import G_FilterPacket
import G_ProcessIPBans
import ConsoleCommand
import SpotWouldTelefrag
import CalculateRanks
import AddScore
import player_die
import ClientSpawn
import InitBodyQue
import InitClientResp
import InitClientPersistant
import BeginIntermission
import respawn
import CopyToBodyQue
import SelectSpawnPoint
import SetClientViewAngle
import PickTeam
import TeamLeader
import TeamCount
import Weapon_HookThink
import Weapon_HookFree
import CheckGauntletAttack
import SnapVectorTowards
import CalcMuzzlePoint
import LogAccuracyHit
import TeleportPlayer
import trigger_teleporter_touch
import Touch_DoorTrigger
import G_RunMover
import fire_grapple
import fire_bfg
import fire_rocket
import fire_grenade
import fire_plasma
import fire_blaster
import G_RunMissile
import TossClientCubes
import TossClientItems
import body_die
import G_InvulnerabilityEffect
import G_RadiusDamage
import G_Damage
import CanDamage
import BuildShaderStateConfig
import AddRemap
import G_SetOrigin
import G_AddEvent
import G_AddPredictableEvent
import vectoyaw
import vtos
import tv
import G_TouchSolids
import G_TouchTriggers
import G_EntitiesFree
import G_FreeEntity
import G_Sound
import G_TempEntity
import G_Spawn
import G_InitGentity
import G_SetMovedir
import G_UseTargets
import G_PickTarget
import G_Find
import G_KillBox
import G_TeamCommand
import G_SoundIndex
import G_ModelIndex
import SaveRegisteredItems
import RegisterItem
import ClearRegisteredItems
import Touch_Item
import Add_Ammo
import ArmorIndex
import Think_Weapon
import FinishSpawningItem
import G_SpawnItem
import SetRespawn
import LaunchItem
import Drop_Item
import PrecacheItem
import UseHoldableItem
import RespawnItem
import G_RunItem
import G_CheckTeamItems
import Cmd_FollowCycle_f
import SetTeam
import BroadcastTeamChange
import StopFollowing
import Cmd_Score_f
import G_NewString
import G_SpawnEntitiesFromString
import G_SpawnVector
import G_SpawnInt
import G_SpawnFloat
import G_SpawnString
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
LABELV $2394
byte 1 67
byte 1 84
byte 1 70
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 114
byte 1 101
byte 1 97
byte 1 99
byte 1 104
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 10
byte 1 0
align 1
LABELV $2393
byte 1 65
byte 1 117
byte 1 116
byte 1 111
byte 1 32
byte 1 67
byte 1 84
byte 1 70
byte 1 58
byte 1 32
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 103
byte 1 111
byte 1 97
byte 1 108
byte 1 32
byte 1 99
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $2392
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
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
LABELV $2389
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $2386
byte 1 67
byte 1 84
byte 1 70
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 114
byte 1 101
byte 1 97
byte 1 99
byte 1 104
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 10
byte 1 0
align 1
LABELV $2385
byte 1 65
byte 1 117
byte 1 116
byte 1 111
byte 1 32
byte 1 67
byte 1 84
byte 1 70
byte 1 58
byte 1 32
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 103
byte 1 111
byte 1 97
byte 1 108
byte 1 32
byte 1 99
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $2384
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $2383
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
LABELV $2380
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 70
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $2375
byte 1 50
byte 1 0
align 1
LABELV $2374
byte 1 103
byte 1 95
byte 1 115
byte 1 112
byte 1 83
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $2373
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 112
byte 1 114
byte 1 101
byte 1 100
byte 1 105
byte 1 99
byte 1 116
byte 1 111
byte 1 98
byte 1 115
byte 1 116
byte 1 97
byte 1 99
byte 1 108
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $2372
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 99
byte 1 104
byte 1 97
byte 1 108
byte 1 108
byte 1 101
byte 1 110
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $2371
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 110
byte 1 111
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $2370
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 102
byte 1 97
byte 1 115
byte 1 116
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $2369
byte 1 48
byte 1 0
align 1
LABELV $2368
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 103
byte 1 114
byte 1 97
byte 1 112
byte 1 112
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $2367
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 106
byte 1 117
byte 1 109
byte 1 112
byte 1 0
align 1
LABELV $2366
byte 1 103
byte 1 95
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $2294
byte 1 37
byte 1 115
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 115
byte 1 119
byte 1 105
byte 1 116
byte 1 99
byte 1 104
byte 1 101
byte 1 100
byte 1 32
byte 1 109
byte 1 111
byte 1 114
byte 1 101
byte 1 32
byte 1 116
byte 1 104
byte 1 97
byte 1 110
byte 1 32
byte 1 37
byte 1 100
byte 1 32
byte 1 65
byte 1 73
byte 1 32
byte 1 110
byte 1 111
byte 1 100
byte 1 101
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $2283
byte 1 66
byte 1 111
byte 1 116
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
byte 1 65
byte 1 73
byte 1 58
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 103
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $2278
byte 1 66
byte 1 111
byte 1 116
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
byte 1 65
byte 1 73
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 97
byte 1 105
byte 1 32
byte 1 110
byte 1 111
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $2267
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $2263
byte 1 115
byte 1 101
byte 1 120
byte 1 0
align 1
LABELV $2223
byte 1 42
byte 1 102
byte 1 97
byte 1 108
byte 1 108
byte 1 105
byte 1 110
byte 1 103
byte 1 49
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $2220
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 69
byte 1 78
byte 1 69
byte 1 82
byte 1 65
byte 1 76
byte 1 95
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 58
byte 1 32
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 80
byte 1 97
byte 1 114
byte 1 109
byte 1 32
byte 1 40
byte 1 37
byte 1 100
byte 1 41
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $2199
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
byte 1 111
byte 1 119
byte 1 101
byte 1 114
byte 1 117
byte 1 112
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 46
byte 1 119
byte 1 97
byte 1 118
byte 1 0
align 1
LABELV $2196
byte 1 69
byte 1 86
byte 1 95
byte 1 71
byte 1 76
byte 1 79
byte 1 66
byte 1 65
byte 1 76
byte 1 95
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 58
byte 1 32
byte 1 101
byte 1 118
byte 1 101
byte 1 110
byte 1 116
byte 1 80
byte 1 97
byte 1 114
byte 1 109
byte 1 32
byte 1 40
byte 1 37
byte 1 100
byte 1 41
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $2167
byte 1 66
byte 1 111
byte 1 116
byte 1 67
byte 1 104
byte 1 101
byte 1 99
byte 1 107
byte 1 67
byte 1 111
byte 1 110
byte 1 115
byte 1 111
byte 1 108
byte 1 101
byte 1 77
byte 1 101
byte 1 115
byte 1 115
byte 1 97
byte 1 103
byte 1 101
byte 1 115
byte 1 58
byte 1 32
byte 1 114
byte 1 101
byte 1 112
byte 1 108
byte 1 121
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $2160
byte 1 42
byte 1 42
byte 1 42
byte 1 42
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 32
byte 1 114
byte 1 101
byte 1 112
byte 1 108
byte 1 121
byte 1 32
byte 1 42
byte 1 42
byte 1 42
byte 1 42
byte 1 10
byte 1 0
align 1
LABELV $2159
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 45
byte 1 10
byte 1 0
align 1
LABELV $2156
byte 1 49
byte 1 0
align 1
LABELV $2155
byte 1 98
byte 1 111
byte 1 116
byte 1 95
byte 1 116
byte 1 101
byte 1 115
byte 1 116
byte 1 114
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $2021
byte 1 37
byte 1 115
byte 1 58
byte 1 32
byte 1 73
byte 1 32
byte 1 104
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 97
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 97
byte 1 32
byte 1 37
byte 1 100
byte 1 10
byte 1 0
align 1
LABELV $2020
byte 1 37
byte 1 115
byte 1 58
byte 1 32
byte 1 73
byte 1 32
byte 1 104
byte 1 97
byte 1 118
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 115
byte 1 104
byte 1 111
byte 1 111
byte 1 116
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 97
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 102
byte 1 114
byte 1 111
byte 1 109
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 37
byte 1 49
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 97
byte 1 32
byte 1 37
byte 1 100
byte 1 10
byte 1 0
align 1
LABELV $2016
byte 1 66
byte 1 111
byte 1 116
byte 1 71
byte 1 111
byte 1 70
byte 1 111
byte 1 114
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 0
align 1
LABELV $2004
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 95
byte 1 100
byte 1 101
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $2003
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 95
byte 1 114
byte 1 101
byte 1 108
byte 1 97
byte 1 121
byte 1 0
align 1
LABELV $2000
byte 1 102
byte 1 117
byte 1 110
byte 1 99
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $1989
byte 1 116
byte 1 114
byte 1 105
byte 1 103
byte 1 103
byte 1 101
byte 1 114
byte 1 95
byte 1 109
byte 1 117
byte 1 108
byte 1 116
byte 1 105
byte 1 112
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $1976
byte 1 66
byte 1 111
byte 1 116
byte 1 71
byte 1 101
byte 1 116
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 34
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 99
byte 1 108
byte 1 97
byte 1 115
byte 1 115
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $1970
byte 1 66
byte 1 111
byte 1 116
byte 1 71
byte 1 101
byte 1 116
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 34
byte 1 10
byte 1 0
align 1
LABELV $1962
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $1951
byte 1 66
byte 1 111
byte 1 116
byte 1 71
byte 1 101
byte 1 116
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 34
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $1947
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $1944
byte 1 102
byte 1 117
byte 1 110
byte 1 99
byte 1 95
byte 1 98
byte 1 117
byte 1 116
byte 1 116
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $1909
byte 1 111
byte 1 114
byte 1 105
byte 1 103
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $1904
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 115
byte 1 0
align 1
LABELV $1899
byte 1 102
byte 1 117
byte 1 110
byte 1 99
byte 1 95
byte 1 100
byte 1 111
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $1896
byte 1 66
byte 1 111
byte 1 116
byte 1 71
byte 1 101
byte 1 116
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 99
byte 1 108
byte 1 97
byte 1 115
byte 1 115
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $1893
byte 1 99
byte 1 108
byte 1 97
byte 1 115
byte 1 115
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $1892
byte 1 66
byte 1 111
byte 1 116
byte 1 71
byte 1 101
byte 1 116
byte 1 65
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 119
byte 1 105
byte 1 116
byte 1 104
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 32
byte 1 37
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $1880
byte 1 42
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $1695
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $1672
byte 1 97
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $1669
byte 1 108
byte 1 105
byte 1 112
byte 1 0
align 1
LABELV $1631
byte 1 109
byte 1 112
byte 1 113
byte 1 51
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 54
byte 1 0
align 1
LABELV $1576
byte 1 113
byte 1 51
byte 1 116
byte 1 111
byte 1 117
byte 1 114
byte 1 110
byte 1 101
byte 1 121
byte 1 54
byte 1 0
align 1
LABELV $1572
byte 1 109
byte 1 97
byte 1 112
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $701
byte 1 73
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
LABELV $700
byte 1 83
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $699
byte 1 66
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 83
byte 1 117
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $698
byte 1 82
byte 1 101
byte 1 103
byte 1 101
byte 1 110
byte 1 101
byte 1 114
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $697
byte 1 81
byte 1 117
byte 1 97
byte 1 100
byte 1 32
byte 1 68
byte 1 97
byte 1 109
byte 1 97
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $530
byte 1 66
byte 1 111
byte 1 116
byte 1 67
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 101
byte 1 87
byte 1 97
byte 1 121
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 58
byte 1 32
byte 1 79
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 119
byte 1 97
byte 1 121
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $341
byte 1 93
byte 1 0
align 1
LABELV $340
byte 1 91
byte 1 0
align 1
LABELV $339
byte 1 32
byte 1 0
align 1
LABELV $296
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
LABELV $291
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $290
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 83
byte 1 107
byte 1 105
byte 1 110
byte 1 58
byte 1 32
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $285
byte 1 110
byte 1 0
align 1
LABELV $284
byte 1 91
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 93
byte 1 0
align 1
LABELV $283
byte 1 67
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 78
byte 1 97
byte 1 109
byte 1 101
byte 1 58
byte 1 32
byte 1 99
byte 1 108
byte 1 105
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 10
byte 1 0
align 1
LABELV $199
byte 1 111
byte 1 110
byte 1 102
byte 1 111
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 0
align 1
LABELV $174
byte 1 105
byte 1 104
byte 1 97
byte 1 118
byte 1 101
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $173
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $172
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 116
byte 1 97
byte 1 115
byte 1 107
byte 1 0
align 1
LABELV $149
byte 1 110
byte 1 111
byte 1 0
align 1
LABELV $71
byte 1 116
byte 1 0
