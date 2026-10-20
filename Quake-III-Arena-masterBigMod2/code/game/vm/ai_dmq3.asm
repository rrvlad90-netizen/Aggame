export BotSetUserInfo
code
proc BotSetUserInfo 1024 12
file "../ai_dmq3.c"
line 116
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
;47:#include "ai_chat.h"
;48:#include "ai_cmd.h"
;49:#include "ai_dmnet.h"
;50:#include "ai_team.h"
;51://
;52:#include "chars.h"				//characteristics
;53:#include "inv.h"				//indexes into the inventory
;54:#include "syn.h"				//synonyms
;55:#include "match.h"				//string matching types and vars
;56:
;57:// for the voice chats
;58:#include "../../ui/menudef.h" // sos001205 - for q3_ui also
;59:
;60:// from aasfile.h
;61:#define AREACONTENTS_MOVER				1024
;62:#define AREACONTENTS_MODELNUMSHIFT		24
;63:#define AREACONTENTS_MAXMODELNUM		0xFF
;64:#define AREACONTENTS_MODELNUM			(AREACONTENTS_MAXMODELNUM << AREACONTENTS_MODELNUMSHIFT)
;65:
;66:#define IDEAL_ATTACKDIST			140
;67:
;68:#define MAX_WAYPOINTS		128
;69://
;70:bot_waypoint_t botai_waypoints[MAX_WAYPOINTS];
;71:bot_waypoint_t *botai_freewaypoints;
;72:
;73://NOTE: not using a cvars which can be updated because the game should be reloaded anyway
;74:int gametype;		//game type
;75:int maxclients;		//maximum number of clients
;76:
;77:vmCvar_t bot_grapple;
;78:vmCvar_t bot_rocketjump;
;79:vmCvar_t bot_fastchat;
;80:vmCvar_t bot_nochat;
;81:vmCvar_t bot_testrchat;
;82:vmCvar_t bot_challenge;
;83:vmCvar_t bot_predictobstacles;
;84:vmCvar_t g_spSkill;
;85:
;86:extern vmCvar_t bot_developer;
;87:
;88:vec3_t lastteleport_origin;		//last teleport event origin
;89:float lastteleport_time;		//last teleport event time
;90:int max_bspmodelindex;			//maximum BSP model index
;91:
;92://CTF flag goals
;93:bot_goal_t ctf_redflag;
;94:bot_goal_t ctf_blueflag;
;95:#ifdef MISSIONPACK
;96:bot_goal_t ctf_neutralflag;
;97:bot_goal_t redobelisk;
;98:bot_goal_t blueobelisk;
;99:bot_goal_t neutralobelisk;
;100:#endif
;101:
;102:#define MAX_ALTROUTEGOALS		32
;103:
;104:int altroutegoals_setup;
;105:aas_altroutegoal_t red_altroutegoals[MAX_ALTROUTEGOALS];
;106:int red_numaltroutegoals;
;107:aas_altroutegoal_t blue_altroutegoals[MAX_ALTROUTEGOALS];
;108:int blue_numaltroutegoals;
;109:
;110:
;111:/*
;112:==================
;113:BotSetUserInfo
;114:==================
;115:*/
;116:void BotSetUserInfo(bot_state_t *bs, char *key, char *value) {
line 119
;117:	char userinfo[MAX_INFO_STRING];
;118:
;119:	trap_GetUserinfo(bs->client, userinfo, sizeof(userinfo));
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
line 120
;120:	Info_SetValueForKey(userinfo, key, value);
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
line 121
;121:	trap_SetUserinfo(bs->client, userinfo);
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
line 122
;122:	ClientUserinfoChanged( bs->client );
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 ClientUserinfoChanged
CALLV
pop
line 123
;123:}
LABELV $53
endproc BotSetUserInfo 1024 12
export BotCTFCarryingFlag
proc BotCTFCarryingFlag 0 0
line 130
;124:
;125:/*
;126:==================
;127:BotCTFCarryingFlag
;128:==================
;129:*/
;130:int BotCTFCarryingFlag(bot_state_t *bs) {
line 131
;131:	if (gametype != GT_CTF) return CTF_FLAG_NONE;
ADDRGP4 gametype
INDIRI4
CNSTI4 4
EQI4 $55
CNSTI4 0
RETI4
ADDRGP4 $54
JUMPV
LABELV $55
line 133
;132:
;133:	if (bs->inventory[INVENTORY_REDFLAG] > 0) return CTF_FLAG_RED;
ADDRFP4 0
INDIRP4
CNSTI4 5132
ADDP4
INDIRI4
CNSTI4 0
LEI4 $57
CNSTI4 1
RETI4
ADDRGP4 $54
JUMPV
LABELV $57
line 134
;134:	else if (bs->inventory[INVENTORY_BLUEFLAG] > 0) return CTF_FLAG_BLUE;
ADDRFP4 0
INDIRP4
CNSTI4 5136
ADDP4
INDIRI4
CNSTI4 0
LEI4 $59
CNSTI4 2
RETI4
ADDRGP4 $54
JUMPV
LABELV $59
line 135
;135:	return CTF_FLAG_NONE;
CNSTI4 0
RETI4
LABELV $54
endproc BotCTFCarryingFlag 0 0
export BotTeam
proc BotTeam 1044 12
line 143
;136:}
;137:
;138:/*
;139:==================
;140:BotTeam
;141:==================
;142:*/
;143:int BotTeam(bot_state_t *bs) {
line 146
;144:	char info[1024];
;145:
;146:	if (bs->client < 0 || bs->client >= MAX_CLIENTS) {
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
LTI4 $64
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $62
LABELV $64
line 148
;147:		//BotAI_Print(PRT_ERROR, "BotCTFTeam: client out of range\n");
;148:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $61
JUMPV
LABELV $62
line 150
;149:	}
;150:	trap_GetConfigstring(CS_PLAYERS+bs->client, info, sizeof(info));
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
line 152
;151:	//
;152:	if (atoi(Info_ValueForKey(info, "t")) == TEAM_RED) return TEAM_RED;
ADDRLP4 0
ARGP4
ADDRGP4 $67
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
NEI4 $65
CNSTI4 1
RETI4
ADDRGP4 $61
JUMPV
LABELV $65
line 153
;153:	else if (atoi(Info_ValueForKey(info, "t")) == TEAM_BLUE) return TEAM_BLUE;
ADDRLP4 0
ARGP4
ADDRGP4 $67
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
NEI4 $68
CNSTI4 2
RETI4
ADDRGP4 $61
JUMPV
LABELV $68
line 154
;154:	return TEAM_FREE;
CNSTI4 0
RETI4
LABELV $61
endproc BotTeam 1044 12
export BotOppositeTeam
proc BotOppositeTeam 12 4
line 162
;155:}
;156:
;157:/*
;158:==================
;159:BotOppositeTeam
;160:==================
;161:*/
;162:int BotOppositeTeam(bot_state_t *bs) {
line 163
;163:	switch(BotTeam(bs)) {
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
EQI4 $74
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $75
ADDRGP4 $71
JUMPV
LABELV $74
line 164
;164:		case TEAM_RED: return TEAM_BLUE;
CNSTI4 2
RETI4
ADDRGP4 $70
JUMPV
LABELV $75
line 165
;165:		case TEAM_BLUE: return TEAM_RED;
CNSTI4 1
RETI4
ADDRGP4 $70
JUMPV
LABELV $71
line 166
;166:		default: return TEAM_FREE;
CNSTI4 0
RETI4
LABELV $70
endproc BotOppositeTeam 12 4
export BotEnemyFlag
proc BotEnemyFlag 4 4
line 175
;167:	}
;168:}
;169:
;170:/*
;171:==================
;172:BotEnemyFlag
;173:==================
;174:*/
;175:bot_goal_t *BotEnemyFlag(bot_state_t *bs) {
line 176
;176:	if (BotTeam(bs) == TEAM_RED) {
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
NEI4 $77
line 177
;177:		return &ctf_blueflag;
ADDRGP4 ctf_blueflag
RETP4
ADDRGP4 $76
JUMPV
LABELV $77
line 179
;178:	}
;179:	else {
line 180
;180:		return &ctf_redflag;
ADDRGP4 ctf_redflag
RETP4
LABELV $76
endproc BotEnemyFlag 4 4
export BotTeamFlag
proc BotTeamFlag 4 4
line 189
;181:	}
;182:}
;183:
;184:/*
;185:==================
;186:BotTeamFlag
;187:==================
;188:*/
;189:bot_goal_t *BotTeamFlag(bot_state_t *bs) {
line 190
;190:	if (BotTeam(bs) == TEAM_RED) {
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
NEI4 $80
line 191
;191:		return &ctf_redflag;
ADDRGP4 ctf_redflag
RETP4
ADDRGP4 $79
JUMPV
LABELV $80
line 193
;192:	}
;193:	else {
line 194
;194:		return &ctf_blueflag;
ADDRGP4 ctf_blueflag
RETP4
LABELV $79
endproc BotTeamFlag 4 4
export EntityIsDead
proc EntityIsDead 472 8
line 204
;195:	}
;196:}
;197:
;198:
;199:/*
;200:==================
;201:EntityIsDead
;202:==================
;203:*/
;204:qboolean EntityIsDead(aas_entityinfo_t *entinfo) {
line 207
;205:	playerState_t ps;
;206:
;207:	if (entinfo->number >= 0 && entinfo->number < MAX_CLIENTS) {
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
LTI4 $83
ADDRLP4 468
INDIRI4
CNSTI4 64
GEI4 $83
line 209
;208:		//retrieve the current client state
;209:		BotAI_GetClientState( entinfo->number, &ps );
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
line 210
;210:		if (ps.pm_type != PM_NORMAL) return qtrue;
ADDRLP4 0+4
INDIRI4
CNSTI4 0
EQI4 $85
CNSTI4 1
RETI4
ADDRGP4 $82
JUMPV
LABELV $85
line 211
;211:	}
LABELV $83
line 212
;212:	return qfalse;
CNSTI4 0
RETI4
LABELV $82
endproc EntityIsDead 472 8
export EntityCarriesFlag
proc EntityCarriesFlag 0 0
line 220
;213:}
;214:
;215:/*
;216:==================
;217:EntityCarriesFlag
;218:==================
;219:*/
;220:qboolean EntityCarriesFlag(aas_entityinfo_t *entinfo) {
line 221
;221:	if ( entinfo->powerups & ( 1 << PW_REDFLAG ) )
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $89
line 222
;222:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $88
JUMPV
LABELV $89
line 223
;223:	if ( entinfo->powerups & ( 1 << PW_BLUEFLAG ) )
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $91
line 224
;224:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $88
JUMPV
LABELV $91
line 229
;225:#ifdef MISSIONPACK
;226:	if ( entinfo->powerups & ( 1 << PW_NEUTRALFLAG ) )
;227:		return qtrue;
;228:#endif
;229:	return qfalse;
CNSTI4 0
RETI4
LABELV $88
endproc EntityCarriesFlag 0 0
export EntityIsInvisible
proc EntityIsInvisible 4 4
line 237
;230:}
;231:
;232:/*
;233:==================
;234:EntityIsInvisible
;235:==================
;236:*/
;237:qboolean EntityIsInvisible(aas_entityinfo_t *entinfo) {
line 239
;238:	// the flag is always visible
;239:	if (EntityCarriesFlag(entinfo)) {
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
EQI4 $94
line 240
;240:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $93
JUMPV
LABELV $94
line 242
;241:	}
;242:	if (entinfo->powerups & (1 << PW_INVIS)) {
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $96
line 243
;243:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $93
JUMPV
LABELV $96
line 245
;244:	}
;245:	return qfalse;
CNSTI4 0
RETI4
LABELV $93
endproc EntityIsInvisible 4 4
export EntityIsShooting
proc EntityIsShooting 0 0
line 253
;246:}
;247:
;248:/*
;249:==================
;250:EntityIsShooting
;251:==================
;252:*/
;253:qboolean EntityIsShooting(aas_entityinfo_t *entinfo) {
line 254
;254:	if (entinfo->flags & EF_FIRING) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $99
line 255
;255:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $98
JUMPV
LABELV $99
line 257
;256:	}
;257:	return qfalse;
CNSTI4 0
RETI4
LABELV $98
endproc EntityIsShooting 0 0
export EntityIsChatting
proc EntityIsChatting 0 0
line 265
;258:}
;259:
;260:/*
;261:==================
;262:EntityIsChatting
;263:==================
;264:*/
;265:qboolean EntityIsChatting(aas_entityinfo_t *entinfo) {
line 266
;266:	if (entinfo->flags & EF_TALK) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $102
line 267
;267:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $101
JUMPV
LABELV $102
line 269
;268:	}
;269:	return qfalse;
CNSTI4 0
RETI4
LABELV $101
endproc EntityIsChatting 0 0
export EntityHasQuad
proc EntityHasQuad 0 0
line 277
;270:}
;271:
;272:/*
;273:==================
;274:EntityHasQuad
;275:==================
;276:*/
;277:qboolean EntityHasQuad(aas_entityinfo_t *entinfo) {
line 278
;278:	if (entinfo->powerups & (1 << PW_QUAD)) {
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $105
line 279
;279:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $104
JUMPV
LABELV $105
line 281
;280:	}
;281:	return qfalse;
CNSTI4 0
RETI4
LABELV $104
endproc EntityHasQuad 0 0
export BotRememberLastOrderedTask
proc BotRememberLastOrderedTask 16 12
line 345
;282:}
;283:
;284:#ifdef MISSIONPACK
;285:/*
;286:==================
;287:EntityHasKamikze
;288:==================
;289:*/
;290:qboolean EntityHasKamikaze(aas_entityinfo_t *entinfo) {
;291:	if (entinfo->flags & EF_KAMIKAZE) {
;292:		return qtrue;
;293:	}
;294:	return qfalse;
;295:}
;296:
;297:/*
;298:==================
;299:EntityCarriesCubes
;300:==================
;301:*/
;302:qboolean EntityCarriesCubes(aas_entityinfo_t *entinfo) {
;303:	entityState_t state;
;304:
;305:	if (gametype != GT_HARVESTER)
;306:		return qfalse;
;307:	//FIXME: get this info from the aas_entityinfo_t ?
;308:	BotAI_GetEntityState(entinfo->number, &state);
;309:	if (state.generic1 > 0)
;310:		return qtrue;
;311:	return qfalse;
;312:}
;313:
;314:/*
;315:==================
;316:Bot1FCTFCarryingFlag
;317:==================
;318:*/
;319:int Bot1FCTFCarryingFlag(bot_state_t *bs) {
;320:	if (gametype != GT_1FCTF) return qfalse;
;321:
;322:	if (bs->inventory[INVENTORY_NEUTRALFLAG] > 0) return qtrue;
;323:	return qfalse;
;324:}
;325:
;326:/*
;327:==================
;328:BotHarvesterCarryingCubes
;329:==================
;330:*/
;331:int BotHarvesterCarryingCubes(bot_state_t *bs) {
;332:	if (gametype != GT_HARVESTER) return qfalse;
;333:
;334:	if (bs->inventory[INVENTORY_REDCUBE] > 0) return qtrue;
;335:	if (bs->inventory[INVENTORY_BLUECUBE] > 0) return qtrue;
;336:	return qfalse;
;337:}
;338:#endif
;339:
;340:/*
;341:==================
;342:BotRememberLastOrderedTask
;343:==================
;344:*/
;345:void BotRememberLastOrderedTask(bot_state_t *bs) {
line 346
;346:	if (!bs->ordered) {
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $108
line 347
;347:		return;
ADDRGP4 $107
JUMPV
LABELV $108
line 349
;348:	}
;349:	bs->lastgoal_decisionmaker = bs->decisionmaker;
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
line 350
;350:	bs->lastgoal_ltgtype = bs->ltgtype;
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
line 351
;351:	memcpy(&bs->lastgoal_teamgoal, &bs->teamgoal, sizeof(bot_goal_t));
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
line 352
;352:	bs->lastgoal_teammate = bs->teammate;
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
line 353
;353:}
LABELV $107
endproc BotRememberLastOrderedTask 16 12
export BotSetTeamStatus
proc BotSetTeamStatus 0 0
line 360
;354:
;355:/*
;356:==================
;357:BotSetTeamStatus
;358:==================
;359:*/
;360:void BotSetTeamStatus(bot_state_t *bs) {
line 417
;361:#ifdef MISSIONPACK
;362:	int teamtask;
;363:	aas_entityinfo_t entinfo;
;364:
;365:	teamtask = TEAMTASK_PATROL;
;366:
;367:	switch(bs->ltgtype) {
;368:		case LTG_TEAMHELP:
;369:			break;
;370:		case LTG_TEAMACCOMPANY:
;371:			BotEntityInfo(bs->teammate, &entinfo);
;372:			if ( ( (gametype == GT_CTF || gametype == GT_1FCTF) && EntityCarriesFlag(&entinfo))
;373:				|| ( gametype == GT_HARVESTER && EntityCarriesCubes(&entinfo)) ) {
;374:				teamtask = TEAMTASK_ESCORT;
;375:			}
;376:			else {
;377:				teamtask = TEAMTASK_FOLLOW;
;378:			}
;379:			break;
;380:		case LTG_DEFENDKEYAREA:
;381:			teamtask = TEAMTASK_DEFENSE;
;382:			break;
;383:		case LTG_GETFLAG:
;384:			teamtask = TEAMTASK_OFFENSE;
;385:			break;
;386:		case LTG_RUSHBASE:
;387:			teamtask = TEAMTASK_DEFENSE;
;388:			break;
;389:		case LTG_RETURNFLAG:
;390:			teamtask = TEAMTASK_RETRIEVE;
;391:			break;
;392:		case LTG_CAMP:
;393:		case LTG_CAMPORDER:
;394:			teamtask = TEAMTASK_CAMP;
;395:			break;
;396:		case LTG_PATROL:
;397:			teamtask = TEAMTASK_PATROL;
;398:			break;
;399:		case LTG_GETITEM:
;400:			teamtask = TEAMTASK_PATROL;
;401:			break;
;402:		case LTG_KILL:
;403:			teamtask = TEAMTASK_PATROL;
;404:			break;
;405:		case LTG_HARVEST:
;406:			teamtask = TEAMTASK_OFFENSE;
;407:			break;
;408:		case LTG_ATTACKENEMYBASE:
;409:			teamtask = TEAMTASK_OFFENSE;
;410:			break;
;411:		default:
;412:			teamtask = TEAMTASK_PATROL;
;413:			break;
;414:	}
;415:	BotSetUserInfo(bs, "teamtask", va("%d", teamtask));
;416:#endif
;417:}
LABELV $110
endproc BotSetTeamStatus 0 0
export BotSetLastOrderedTask
proc BotSetLastOrderedTask 60 16
line 424
;418:
;419:/*
;420:==================
;421:BotSetLastOrderedTask
;422:==================
;423:*/
;424:int BotSetLastOrderedTask(bot_state_t *bs) {
line 426
;425:
;426:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $112
line 428
;427:		// don't go back to returning the flag if it's at the base
;428:		if ( bs->lastgoal_ltgtype == LTG_RETURNFLAG ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 6
NEI4 $114
line 429
;429:			if ( BotTeam(bs) == TEAM_RED ) {
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
NEI4 $116
line 430
;430:				if ( bs->redflagstatus == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
CNSTI4 0
NEI4 $117
line 431
;431:					bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 432
;432:				}
line 433
;433:			}
ADDRGP4 $117
JUMPV
LABELV $116
line 434
;434:			else {
line 435
;435:				if ( bs->blueflagstatus == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
CNSTI4 0
NEI4 $120
line 436
;436:					bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 437
;437:				}
LABELV $120
line 438
;438:			}
LABELV $117
line 439
;439:		}
LABELV $114
line 440
;440:	}
LABELV $112
line 442
;441:
;442:	if ( bs->lastgoal_ltgtype ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $122
line 443
;443:		bs->decisionmaker = bs->lastgoal_decisionmaker;
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
line 444
;444:		bs->ordered = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 1
ASGNI4
line 445
;445:		bs->ltgtype = bs->lastgoal_ltgtype;
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
line 446
;446:		memcpy(&bs->teamgoal, &bs->lastgoal_teamgoal, sizeof(bot_goal_t));
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
line 447
;447:		bs->teammate = bs->lastgoal_teammate;
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
line 448
;448:		bs->teamgoal_time = FloatTime() + 300;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1133903872
ADDF4
ASGNF4
line 449
;449:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 451
;450:		//
;451:		if ( gametype == GT_CTF ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $124
line 452
;452:			if ( bs->ltgtype == LTG_GETFLAG ) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $126
line 456
;453:				bot_goal_t *tb, *eb;
;454:				int tt, et;
;455:
;456:				tb = BotTeamFlag(bs);
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
line 457
;457:				eb = BotEnemyFlag(bs);
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
line 458
;458:				tt = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, tb->areanum, TFL_DEFAULT);
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
line 459
;459:				et = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, eb->areanum, TFL_DEFAULT);
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
line 461
;460:				// if the travel time towards the enemy base is larger than towards our base
;461:				if (et > tt) {
ADDRLP4 28
INDIRI4
ADDRLP4 24
INDIRI4
LEI4 $128
line 463
;462:					//get an alternative route goal towards the enemy base
;463:					BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 464
;464:				}
LABELV $128
line 465
;465:			}
LABELV $126
line 466
;466:		}
LABELV $124
line 467
;467:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $111
JUMPV
LABELV $122
line 469
;468:	}
;469:	return qfalse;
CNSTI4 0
RETI4
LABELV $111
endproc BotSetLastOrderedTask 60 16
export BotRefuseOrder
proc BotRefuseOrder 8 12
line 477
;470:}
;471:
;472:/*
;473:==================
;474:BotRefuseOrder
;475:==================
;476:*/
;477:void BotRefuseOrder(bot_state_t *bs) {
line 478
;478:	if (!bs->ordered)
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $131
line 479
;479:		return;
ADDRGP4 $130
JUMPV
LABELV $131
line 481
;480:	// if the bot was ordered to do something
;481:	if ( bs->order_time && bs->order_time > FloatTime() - 10 ) {
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
EQF4 $133
ADDRLP4 0
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
SUBF4
LEF4 $133
line 482
;482:		trap_EA_Action(bs->client, ACTION_NEGATIVE);
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
line 483
;483:		BotVoiceChat(bs, bs->decisionmaker, VOICECHAT_NO);
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
ADDRGP4 $135
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 484
;484:		bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 485
;485:	}
LABELV $133
line 486
;486:}
LABELV $130
endproc BotRefuseOrder 8 12
export BotCTFSeekGoals
proc BotCTFSeekGoals 240 12
line 493
;487:
;488:/*
;489:==================
;490:BotCTFSeekGoals
;491:==================
;492:*/
;493:void BotCTFSeekGoals(bot_state_t *bs) {
line 500
;494:	float rnd, l1, l2;
;495:	int flagstatus, c;
;496:	vec3_t dir;
;497:	aas_entityinfo_t entinfo;
;498:
;499:	//when carrying a flag in ctf the bot should rush to the base
;500:	if (BotCTFCarryingFlag(bs)) {
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
EQI4 $137
line 502
;501:		//if not already rushing to the base
;502:		if (bs->ltgtype != LTG_RUSHBASE) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
EQI4 $139
line 503
;503:			BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 504
;504:			bs->ltgtype = LTG_RUSHBASE;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 5
ASGNI4
line 505
;505:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
ASGNF4
line 506
;506:			bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 507
;507:			bs->decisionmaker = bs->client;
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
line 508
;508:			bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 510
;509:			//
;510:			switch(BotTeam(bs)) {
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
EQI4 $144
ADDRLP4 180
INDIRI4
CNSTI4 2
EQI4 $149
ADDRGP4 $141
JUMPV
LABELV $144
line 511
;511:				case TEAM_RED: VectorSubtract(bs->origin, ctf_blueflag.origin, dir); break;
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
ADDRGP4 $142
JUMPV
LABELV $149
line 512
;512:				case TEAM_BLUE: VectorSubtract(bs->origin, ctf_redflag.origin, dir); break;
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
ADDRGP4 $142
JUMPV
LABELV $141
line 513
;513:				default: VectorSet(dir, 999, 999, 999); break;
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
LABELV $142
line 516
;514:			}
;515:			// if the bot picked up the flag very close to the enemy base
;516:			if ( VectorLength(dir) < 128 ) {
ADDRLP4 160
ARGP4
ADDRLP4 192
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 192
INDIRF4
CNSTF4 1124073472
GEF4 $156
line 518
;517:				// get an alternative route goal through the enemy base
;518:				BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 519
;519:			} else {
ADDRGP4 $157
JUMPV
LABELV $156
line 521
;520:				// don't use any alt route goal, just get the hell out of the base
;521:				bs->altroutegoal.areanum = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6692
ADDP4
CNSTI4 0
ASGNI4
line 522
;522:			}
LABELV $157
line 523
;523:			BotSetUserInfo(bs, "teamtask", va("%d", TEAMTASK_OFFENSE));
ADDRGP4 $159
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
ADDRGP4 $158
ARGP4
ADDRLP4 196
INDIRP4
ARGP4
ADDRGP4 BotSetUserInfo
CALLV
pop
line 524
;524:			BotVoiceChat(bs, -1, VOICECHAT_IHAVEFLAG);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 $160
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 525
;525:		}
ADDRGP4 $136
JUMPV
LABELV $139
line 526
;526:		else if (bs->rushbaseaway_time > FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $136
line 527
;527:			if (BotTeam(bs) == TEAM_RED) flagstatus = bs->redflagstatus;
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
NEI4 $163
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $164
JUMPV
LABELV $163
line 528
;528:			else flagstatus = bs->blueflagstatus;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
ASGNI4
LABELV $164
line 530
;529:			//if the flag is back
;530:			if (flagstatus == 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $136
line 531
;531:				bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 532
;532:			}
line 533
;533:		}
line 534
;534:		return;
ADDRGP4 $136
JUMPV
LABELV $137
line 537
;535:	}
;536:	// if the bot decided to follow someone
;537:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
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
NEI4 $167
ADDRLP4 176
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $167
line 539
;538:		// if the team mate being accompanied no longer carries the flag
;539:		BotEntityInfo(bs->teammate, &entinfo);
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
line 540
;540:		if (!EntityCarriesFlag(&entinfo)) {
ADDRLP4 16
ARGP4
ADDRLP4 180
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 0
NEI4 $169
line 541
;541:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 542
;542:		}
LABELV $169
line 543
;543:	}
LABELV $167
line 545
;544:	//
;545:	if (BotTeam(bs) == TEAM_RED) flagstatus = bs->redflagstatus * 2 + bs->blueflagstatus;
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
NEI4 $171
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
ADDRGP4 $172
JUMPV
LABELV $171
line 546
;546:	else flagstatus = bs->blueflagstatus * 2 + bs->redflagstatus;
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
LABELV $172
line 548
;547:	//if our team has the enemy flag and our flag is at the base
;548:	if (flagstatus == 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $173
line 550
;549:		//
;550:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $136
line 552
;551:			//if Not defending the base already
;552:			if (!(bs->ltgtype == LTG_DEFENDKEYAREA &&
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
NEI4 $181
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
EQI4 $136
ADDRLP4 196
INDIRI4
ADDRGP4 ctf_blueflag+44
INDIRI4
EQI4 $136
LABELV $181
line 554
;553:					(bs->teamgoal.number == ctf_redflag.number ||
;554:					bs->teamgoal.number == ctf_blueflag.number))) {
line 556
;555:				//if there is a visible team mate flag carrier
;556:				c = BotTeamFlagCarrierVisible(bs);
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
line 557
;557:				if (c >= 0 &&
ADDRLP4 204
ADDRLP4 156
INDIRI4
ASGNI4
ADDRLP4 204
INDIRI4
CNSTI4 0
LTI4 $136
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
NEI4 $184
ADDRLP4 208
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ADDRLP4 204
INDIRI4
EQI4 $136
LABELV $184
line 559
;558:						// and not already following the team mate flag carrier
;559:						(bs->ltgtype != LTG_TEAMACCOMPANY || bs->teammate != c)) {
line 561
;560:					//
;561:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 563
;562:					//follow the flag carrier
;563:					bs->decisionmaker = bs->client;
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
line 564
;564:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 566
;565:					//the team mate
;566:					bs->teammate = c;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 156
INDIRI4
ASGNI4
line 568
;567:					//last time the team mate was visible
;568:					bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 570
;569:					//no message
;570:					bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 572
;571:					//no arrive message
;572:					bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 574
;573:					//
;574:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
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
ADDRGP4 $185
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 576
;575:					//get the team goal time
;576:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 577
;577:					bs->ltgtype = LTG_TEAMACCOMPANY;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 2
ASGNI4
line 578
;578:					bs->formation_dist = 3.5 * 32;		//3.5 meter
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
CNSTF4 1121976320
ASGNF4
line 579
;579:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 580
;580:					bs->owndecision_time = FloatTime() + 5;
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
line 581
;581:				}
line 582
;582:			}
line 583
;583:		}
line 584
;584:		return;
ADDRGP4 $136
JUMPV
LABELV $173
line 587
;585:	}
;586:	//if the enemy has our flag
;587:	else if (flagstatus == 2) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $186
line 589
;588:		//
;589:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $136
line 591
;590:			//if enemy flag carrier is visible
;591:			c = BotEnemyFlagCarrierVisible(bs);
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
line 592
;592:			if (c >= 0) {
ADDRLP4 156
INDIRI4
CNSTI4 0
LTI4 $190
line 594
;593:				//FIXME: fight enemy flag carrier
;594:			}
LABELV $190
line 596
;595:			//if not already doing something important
;596:			if (bs->ltgtype != LTG_GETFLAG &&
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
EQI4 $136
ADDRLP4 196
INDIRI4
CNSTI4 6
EQI4 $136
ADDRLP4 196
INDIRI4
CNSTI4 1
EQI4 $136
ADDRLP4 196
INDIRI4
CNSTI4 2
EQI4 $136
ADDRLP4 196
INDIRI4
CNSTI4 8
EQI4 $136
ADDRLP4 196
INDIRI4
CNSTI4 9
EQI4 $136
ADDRLP4 196
INDIRI4
CNSTI4 10
EQI4 $136
line 602
;597:				bs->ltgtype != LTG_RETURNFLAG &&
;598:				bs->ltgtype != LTG_TEAMHELP &&
;599:				bs->ltgtype != LTG_TEAMACCOMPANY &&
;600:				bs->ltgtype != LTG_CAMPORDER &&
;601:				bs->ltgtype != LTG_PATROL &&
;602:				bs->ltgtype != LTG_GETITEM) {
line 604
;603:
;604:				BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 605
;605:				bs->decisionmaker = bs->client;
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
line 606
;606:				bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 608
;607:				//
;608:				if (random() < 0.5) {
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
GEF4 $194
line 610
;609:					//go for the enemy flag
;610:					bs->ltgtype = LTG_GETFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 4
ASGNI4
line 611
;611:				}
ADDRGP4 $195
JUMPV
LABELV $194
line 612
;612:				else {
line 613
;613:					bs->ltgtype = LTG_RETURNFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 6
ASGNI4
line 614
;614:				}
LABELV $195
line 616
;615:				//no team message
;616:				bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 618
;617:				//set the time the bot will stop getting the flag
;618:				bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 620
;619:				//get an alternative route goal towards the enemy base
;620:				BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 622
;621:				//
;622:				BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 623
;623:				bs->owndecision_time = FloatTime() + 5;
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
line 624
;624:			}
line 625
;625:		}
line 626
;626:		return;
ADDRGP4 $136
JUMPV
LABELV $186
line 629
;627:	}
;628:	//if both flags Not at their bases
;629:	else if (flagstatus == 3) {
ADDRLP4 0
INDIRI4
CNSTI4 3
NEI4 $196
line 631
;630:		//
;631:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $136
line 633
;632:			// if not trying to return the flag and not following the team flag carrier
;633:			if ( bs->ltgtype != LTG_RETURNFLAG && bs->ltgtype != LTG_TEAMACCOMPANY ) {
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
EQI4 $136
ADDRLP4 192
INDIRI4
CNSTI4 2
EQI4 $136
line 635
;634:				//
;635:				c = BotTeamFlagCarrierVisible(bs);
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
line 637
;636:				// if there is a visible team mate flag carrier
;637:				if (c >= 0) {
ADDRLP4 156
INDIRI4
CNSTI4 0
LTI4 $202
line 638
;638:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 640
;639:					//follow the flag carrier
;640:					bs->decisionmaker = bs->client;
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
line 641
;641:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 643
;642:					//the team mate
;643:					bs->teammate = c;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 156
INDIRI4
ASGNI4
line 645
;644:					//last time the team mate was visible
;645:					bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 647
;646:					//no message
;647:					bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 649
;648:					//no arrive message
;649:					bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 651
;650:					//
;651:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
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
ADDRGP4 $185
ARGP4
ADDRGP4 BotVoiceChat
CALLV
pop
line 653
;652:					//get the team goal time
;653:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 654
;654:					bs->ltgtype = LTG_TEAMACCOMPANY;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 2
ASGNI4
line 655
;655:					bs->formation_dist = 3.5 * 32;		//3.5 meter
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
CNSTF4 1121976320
ASGNF4
line 657
;656:					//
;657:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 658
;658:					bs->owndecision_time = FloatTime() + 5;
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
line 659
;659:				}
ADDRGP4 $136
JUMPV
LABELV $202
line 660
;660:				else {
line 661
;661:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 662
;662:					bs->decisionmaker = bs->client;
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
line 663
;663:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 665
;664:					//get the enemy flag
;665:					bs->teammessage_time = FloatTime() + 2 * random();
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
line 667
;666:					//get the flag
;667:					bs->ltgtype = LTG_RETURNFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 6
ASGNI4
line 669
;668:					//set the time the bot will stop getting the flag
;669:					bs->teamgoal_time = FloatTime() + CTF_RETURNFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 671
;670:					//get an alternative route goal towards the enemy base
;671:					BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 673
;672:					//
;673:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 674
;674:					bs->owndecision_time = FloatTime() + 5;
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
line 675
;675:				}
line 676
;676:			}
line 677
;677:		}
line 678
;678:		return;
ADDRGP4 $136
JUMPV
LABELV $196
line 681
;679:	}
;680:	// don't just do something wait for the bot team leader to give orders
;681:	if (BotTeamLeader(bs)) {
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
EQI4 $204
line 682
;682:		return;
ADDRGP4 $136
JUMPV
LABELV $204
line 685
;683:	}
;684:	// if the bot is ordered to do something
;685:	if ( bs->lastgoal_ltgtype ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $206
line 686
;686:		bs->teamgoal_time += 60;
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
line 687
;687:	}
LABELV $206
line 689
;688:	// if the bot decided to do something on it's own and has a last ordered goal
;689:	if ( !bs->ordered && bs->lastgoal_ltgtype ) {
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
NEI4 $208
ADDRLP4 196
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
ADDRLP4 200
INDIRI4
EQI4 $208
line 690
;690:		bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 691
;691:	}
LABELV $208
line 693
;692:	//if already a CTF or team goal
;693:	if (bs->ltgtype == LTG_TEAMHELP ||
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
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 2
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 3
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 4
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 5
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 6
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 8
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 9
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 10
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 14
EQI4 $221
ADDRLP4 204
INDIRI4
CNSTI4 15
NEI4 $210
LABELV $221
line 703
;694:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;695:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;696:			bs->ltgtype == LTG_GETFLAG ||
;697:			bs->ltgtype == LTG_RUSHBASE ||
;698:			bs->ltgtype == LTG_RETURNFLAG ||
;699:			bs->ltgtype == LTG_CAMPORDER ||
;700:			bs->ltgtype == LTG_PATROL ||
;701:			bs->ltgtype == LTG_GETITEM ||
;702:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;703:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
line 704
;704:		return;
ADDRGP4 $136
JUMPV
LABELV $210
line 707
;705:	}
;706:	//
;707:	if (BotSetLastOrderedTask(bs))
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
EQI4 $222
line 708
;708:		return;
ADDRGP4 $136
JUMPV
LABELV $222
line 710
;709:	//
;710:	if (bs->owndecision_time > FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
LEF4 $224
line 711
;711:		return;;
ADDRGP4 $136
JUMPV
LABELV $224
line 713
;712:	//if the bot is roaming
;713:	if (bs->ctfroam_time > FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6164
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $226
line 714
;714:		return;
ADDRGP4 $136
JUMPV
LABELV $226
line 716
;715:	//if the bot has anough aggression to decide what to do
;716:	if (BotAggression(bs) < 50)
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
GEF4 $228
line 717
;717:		return;
ADDRGP4 $136
JUMPV
LABELV $228
line 719
;718:	//set the time to send a message to the team mates
;719:	bs->teammessage_time = FloatTime() + 2 * random();
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
line 721
;720:	//
;721:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
ADDRFP4 0
INDIRP4
CNSTI4 6752
ADDP4
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 0
EQI4 $230
line 722
;722:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
ADDRFP4 0
INDIRP4
CNSTI4 6752
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $232
line 723
;723:			l1 = 0.7f;
ADDRLP4 8
CNSTF4 1060320051
ASGNF4
line 724
;724:		}
ADDRGP4 $233
JUMPV
LABELV $232
line 725
;725:		else {
line 726
;726:			l1 = 0.2f;
ADDRLP4 8
CNSTF4 1045220557
ASGNF4
line 727
;727:		}
LABELV $233
line 728
;728:		l2 = 0.9f;
ADDRLP4 12
CNSTF4 1063675494
ASGNF4
line 729
;729:	}
ADDRGP4 $231
JUMPV
LABELV $230
line 730
;730:	else {
line 731
;731:		l1 = 0.4f;
ADDRLP4 8
CNSTF4 1053609165
ASGNF4
line 732
;732:		l2 = 0.7f;
ADDRLP4 12
CNSTF4 1060320051
ASGNF4
line 733
;733:	}
LABELV $231
line 735
;734:	//get the flag or defend the base
;735:	rnd = random();
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
line 736
;736:	if (rnd < l1 && ctf_redflag.areanum && ctf_blueflag.areanum) {
ADDRLP4 4
INDIRF4
ADDRLP4 8
INDIRF4
GEF4 $234
ADDRLP4 224
CNSTI4 0
ASGNI4
ADDRGP4 ctf_redflag+12
INDIRI4
ADDRLP4 224
INDIRI4
EQI4 $234
ADDRGP4 ctf_blueflag+12
INDIRI4
ADDRLP4 224
INDIRI4
EQI4 $234
line 737
;737:		bs->decisionmaker = bs->client;
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
line 738
;738:		bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 739
;739:		bs->ltgtype = LTG_GETFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 4
ASGNI4
line 741
;740:		//set the time the bot will stop getting the flag
;741:		bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 743
;742:		//get an alternative route goal towards the enemy base
;743:		BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 744
;744:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 745
;745:	}
ADDRGP4 $235
JUMPV
LABELV $234
line 746
;746:	else if (rnd < l2 && ctf_redflag.areanum && ctf_blueflag.areanum) {
ADDRLP4 4
INDIRF4
ADDRLP4 12
INDIRF4
GEF4 $238
ADDRLP4 228
CNSTI4 0
ASGNI4
ADDRGP4 ctf_redflag+12
INDIRI4
ADDRLP4 228
INDIRI4
EQI4 $238
ADDRGP4 ctf_blueflag+12
INDIRI4
ADDRLP4 228
INDIRI4
EQI4 $238
line 747
;747:		bs->decisionmaker = bs->client;
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
line 748
;748:		bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 750
;749:		//
;750:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
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
NEI4 $242
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
ADDRGP4 $243
JUMPV
LABELV $242
line 751
;751:		else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
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
LABELV $243
line 753
;752:		//set the ltg type
;753:		bs->ltgtype = LTG_DEFENDKEYAREA;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 3
ASGNI4
line 755
;754:		//set the time the bot stops defending the base
;755:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 756
;756:		bs->defendaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6144
ADDP4
CNSTF4 0
ASGNF4
line 757
;757:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 758
;758:	}
ADDRGP4 $239
JUMPV
LABELV $238
line 759
;759:	else {
line 760
;760:		bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 762
;761:		//set the time the bot will stop roaming
;762:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6164
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1114636288
ADDF4
ASGNF4
line 763
;763:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 764
;764:	}
LABELV $239
LABELV $235
line 765
;765:	bs->owndecision_time = FloatTime() + 5;
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
line 769
;766:#ifdef DEBUG
;767:	BotPrintTeamGoal(bs);
;768:#endif //DEBUG
;769:}
LABELV $136
endproc BotCTFSeekGoals 240 12
export BotCTFRetreatGoals
proc BotCTFRetreatGoals 8 4
line 776
;770:
;771:/*
;772:==================
;773:BotCTFRetreatGoals
;774:==================
;775:*/
;776:void BotCTFRetreatGoals(bot_state_t *bs) {
line 778
;777:	//when carrying a flag in ctf the bot should rush to the base
;778:	if (BotCTFCarryingFlag(bs)) {
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
EQI4 $245
line 780
;779:		//if not already rushing to the base
;780:		if (bs->ltgtype != LTG_RUSHBASE) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
EQI4 $247
line 781
;781:			BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 782
;782:			bs->ltgtype = LTG_RUSHBASE;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 5
ASGNI4
line 783
;783:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
ASGNF4
line 784
;784:			bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 785
;785:			bs->decisionmaker = bs->client;
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
line 786
;786:			bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 787
;787:			BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 788
;788:		}
LABELV $247
line 789
;789:	}
LABELV $245
line 790
;790:}
LABELV $244
endproc BotCTFRetreatGoals 8 4
export BotTeamGoals
proc BotTeamGoals 0 4
line 1326
;791:
;792:#ifdef MISSIONPACK
;793:/*
;794:==================
;795:Bot1FCTFSeekGoals
;796:==================
;797:*/
;798:void Bot1FCTFSeekGoals(bot_state_t *bs) {
;799:	aas_entityinfo_t entinfo;
;800:	float rnd, l1, l2;
;801:	int c;
;802:
;803:	//when carrying a flag in ctf the bot should rush to the base
;804:	if (Bot1FCTFCarryingFlag(bs)) {
;805:		//if not already rushing to the base
;806:		if (bs->ltgtype != LTG_RUSHBASE) {
;807:			BotRefuseOrder(bs);
;808:			bs->ltgtype = LTG_RUSHBASE;
;809:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;810:			bs->rushbaseaway_time = 0;
;811:			bs->decisionmaker = bs->client;
;812:			bs->ordered = qfalse;
;813:			//get an alternative route goal towards the enemy base
;814:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;815:			//
;816:			BotSetTeamStatus(bs);
;817:			BotVoiceChat(bs, -1, VOICECHAT_IHAVEFLAG);
;818:		}
;819:		return;
;820:	}
;821:	// if the bot decided to follow someone
;822:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
;823:		// if the team mate being accompanied no longer carries the flag
;824:		BotEntityInfo(bs->teammate, &entinfo);
;825:		if (!EntityCarriesFlag(&entinfo)) {
;826:			bs->ltgtype = 0;
;827:		}
;828:	}
;829:	//our team has the flag
;830:	if (bs->neutralflagstatus == 1) {
;831:		if (bs->owndecision_time < FloatTime()) {
;832:			// if not already following someone
;833:			if (bs->ltgtype != LTG_TEAMACCOMPANY) {
;834:				//if there is a visible team mate flag carrier
;835:				c = BotTeamFlagCarrierVisible(bs);
;836:				if (c >= 0) {
;837:					BotRefuseOrder(bs);
;838:					//follow the flag carrier
;839:					bs->decisionmaker = bs->client;
;840:					bs->ordered = qfalse;
;841:					//the team mate
;842:					bs->teammate = c;
;843:					//last time the team mate was visible
;844:					bs->teammatevisible_time = FloatTime();
;845:					//no message
;846:					bs->teammessage_time = 0;
;847:					//no arrive message
;848:					bs->arrive_time = 1;
;849:					//
;850:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
;851:					//get the team goal time
;852:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
;853:					bs->ltgtype = LTG_TEAMACCOMPANY;
;854:					bs->formation_dist = 3.5 * 32;		//3.5 meter
;855:					BotSetTeamStatus(bs);
;856:					bs->owndecision_time = FloatTime() + 5;
;857:					return;
;858:				}
;859:			}
;860:			//if already a CTF or team goal
;861:			if (bs->ltgtype == LTG_TEAMHELP ||
;862:					bs->ltgtype == LTG_TEAMACCOMPANY ||
;863:					bs->ltgtype == LTG_DEFENDKEYAREA ||
;864:					bs->ltgtype == LTG_GETFLAG ||
;865:					bs->ltgtype == LTG_RUSHBASE ||
;866:					bs->ltgtype == LTG_CAMPORDER ||
;867:					bs->ltgtype == LTG_PATROL ||
;868:					bs->ltgtype == LTG_ATTACKENEMYBASE ||
;869:					bs->ltgtype == LTG_GETITEM ||
;870:					bs->ltgtype == LTG_MAKELOVE_UNDER ||
;871:					bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;872:				return;
;873:			}
;874:			//if not already attacking the enemy base
;875:			if (bs->ltgtype != LTG_ATTACKENEMYBASE) {
;876:				BotRefuseOrder(bs);
;877:				bs->decisionmaker = bs->client;
;878:				bs->ordered = qfalse;
;879:				//
;880:				if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;881:				else memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;882:				//set the ltg type
;883:				bs->ltgtype = LTG_ATTACKENEMYBASE;
;884:				//set the time the bot will stop getting the flag
;885:				bs->teamgoal_time = FloatTime() + TEAM_ATTACKENEMYBASE_TIME;
;886:				BotSetTeamStatus(bs);
;887:				bs->owndecision_time = FloatTime() + 5;
;888:			}
;889:		}
;890:		return;
;891:	}
;892:	//enemy team has the flag
;893:	else if (bs->neutralflagstatus == 2) {
;894:		if (bs->owndecision_time < FloatTime()) {
;895:			c = BotEnemyFlagCarrierVisible(bs);
;896:			if (c >= 0) {
;897:				//FIXME: attack enemy flag carrier
;898:			}
;899:			//if already a CTF or team goal
;900:			if (bs->ltgtype == LTG_TEAMHELP ||
;901:					bs->ltgtype == LTG_TEAMACCOMPANY ||
;902:					bs->ltgtype == LTG_CAMPORDER ||
;903:					bs->ltgtype == LTG_PATROL ||
;904:					bs->ltgtype == LTG_GETITEM) {
;905:				return;
;906:			}
;907:			// if not already defending the base
;908:			if (bs->ltgtype != LTG_DEFENDKEYAREA) {
;909:				BotRefuseOrder(bs);
;910:				bs->decisionmaker = bs->client;
;911:				bs->ordered = qfalse;
;912:				//
;913:				if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;914:				else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;915:				//set the ltg type
;916:				bs->ltgtype = LTG_DEFENDKEYAREA;
;917:				//set the time the bot stops defending the base
;918:				bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;919:				bs->defendaway_time = 0;
;920:				BotSetTeamStatus(bs);
;921:				bs->owndecision_time = FloatTime() + 5;
;922:			}
;923:		}
;924:		return;
;925:	}
;926:	// don't just do something wait for the bot team leader to give orders
;927:	if (BotTeamLeader(bs)) {
;928:		return;
;929:	}
;930:	// if the bot is ordered to do something
;931:	if ( bs->lastgoal_ltgtype ) {
;932:		bs->teamgoal_time += 60;
;933:	}
;934:	// if the bot decided to do something on it's own and has a last ordered goal
;935:	if ( !bs->ordered && bs->lastgoal_ltgtype ) {
;936:		bs->ltgtype = 0;
;937:	}
;938:	//if already a CTF or team goal
;939:	if (bs->ltgtype == LTG_TEAMHELP ||
;940:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;941:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;942:			bs->ltgtype == LTG_GETFLAG ||
;943:			bs->ltgtype == LTG_RUSHBASE ||
;944:			bs->ltgtype == LTG_RETURNFLAG ||
;945:			bs->ltgtype == LTG_CAMPORDER ||
;946:			bs->ltgtype == LTG_PATROL ||
;947:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;948:			bs->ltgtype == LTG_GETITEM ||
;949:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;950:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;951:		return;
;952:	}
;953:	//
;954:	if (BotSetLastOrderedTask(bs))
;955:		return;
;956:	//
;957:	if (bs->owndecision_time > FloatTime())
;958:		return;;
;959:	//if the bot is roaming
;960:	if (bs->ctfroam_time > FloatTime())
;961:		return;
;962:	//if the bot has anough aggression to decide what to do
;963:	if (BotAggression(bs) < 50)
;964:		return;
;965:	//set the time to send a message to the team mates
;966:	bs->teammessage_time = FloatTime() + 2 * random();
;967:	//
;968:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;969:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;970:			l1 = 0.7f;
;971:		}
;972:		else {
;973:			l1 = 0.2f;
;974:		}
;975:		l2 = 0.9f;
;976:	}
;977:	else {
;978:		l1 = 0.4f;
;979:		l2 = 0.7f;
;980:	}
;981:	//get the flag or defend the base
;982:	rnd = random();
;983:	if (rnd < l1 && ctf_neutralflag.areanum) {
;984:		bs->decisionmaker = bs->client;
;985:		bs->ordered = qfalse;
;986:		bs->ltgtype = LTG_GETFLAG;
;987:		//set the time the bot will stop getting the flag
;988:		bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
;989:		BotSetTeamStatus(bs);
;990:	}
;991:	else if (rnd < l2 && ctf_redflag.areanum && ctf_blueflag.areanum) {
;992:		bs->decisionmaker = bs->client;
;993:		bs->ordered = qfalse;
;994:		//
;995:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;996:		else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;997:		//set the ltg type
;998:		bs->ltgtype = LTG_DEFENDKEYAREA;
;999:		//set the time the bot stops defending the base
;1000:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1001:		bs->defendaway_time = 0;
;1002:		BotSetTeamStatus(bs);
;1003:	}
;1004:	else {
;1005:		bs->ltgtype = 0;
;1006:		//set the time the bot will stop roaming
;1007:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1008:		BotSetTeamStatus(bs);
;1009:	}
;1010:	bs->owndecision_time = FloatTime() + 5;
;1011:#ifdef DEBUG
;1012:	BotPrintTeamGoal(bs);
;1013:#endif //DEBUG
;1014:}
;1015:
;1016:/*
;1017:==================
;1018:Bot1FCTFRetreatGoals
;1019:==================
;1020:*/
;1021:void Bot1FCTFRetreatGoals(bot_state_t *bs) {
;1022:	//when carrying a flag in ctf the bot should rush to the enemy base
;1023:	if (Bot1FCTFCarryingFlag(bs)) {
;1024:		//if not already rushing to the base
;1025:		if (bs->ltgtype != LTG_RUSHBASE) {
;1026:			BotRefuseOrder(bs);
;1027:			bs->ltgtype = LTG_RUSHBASE;
;1028:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1029:			bs->rushbaseaway_time = 0;
;1030:			bs->decisionmaker = bs->client;
;1031:			bs->ordered = qfalse;
;1032:			//get an alternative route goal towards the enemy base
;1033:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1034:			BotSetTeamStatus(bs);
;1035:		}
;1036:	}
;1037:}
;1038:
;1039:/*
;1040:==================
;1041:BotObeliskSeekGoals
;1042:==================
;1043:*/
;1044:void BotObeliskSeekGoals(bot_state_t *bs) {
;1045:	float rnd, l1, l2;
;1046:
;1047:	// don't just do something wait for the bot team leader to give orders
;1048:	if (BotTeamLeader(bs)) {
;1049:		return;
;1050:	}
;1051:	// if the bot is ordered to do something
;1052:	if ( bs->lastgoal_ltgtype ) {
;1053:		bs->teamgoal_time += 60;
;1054:	}
;1055:	//if already a team goal
;1056:	if (bs->ltgtype == LTG_TEAMHELP ||
;1057:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;1058:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;1059:			bs->ltgtype == LTG_GETFLAG ||
;1060:			bs->ltgtype == LTG_RUSHBASE ||
;1061:			bs->ltgtype == LTG_RETURNFLAG ||
;1062:			bs->ltgtype == LTG_CAMPORDER ||
;1063:			bs->ltgtype == LTG_PATROL ||
;1064:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;1065:			bs->ltgtype == LTG_GETITEM ||
;1066:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;1067:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;1068:		return;
;1069:	}
;1070:	//
;1071:	if (BotSetLastOrderedTask(bs))
;1072:		return;
;1073:	//if the bot is roaming
;1074:	if (bs->ctfroam_time > FloatTime())
;1075:		return;
;1076:	//if the bot has anough aggression to decide what to do
;1077:	if (BotAggression(bs) < 50)
;1078:		return;
;1079:	//set the time to send a message to the team mates
;1080:	bs->teammessage_time = FloatTime() + 2 * random();
;1081:	//
;1082:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1083:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1084:			l1 = 0.7f;
;1085:		}
;1086:		else {
;1087:			l1 = 0.2f;
;1088:		}
;1089:		l2 = 0.9f;
;1090:	}
;1091:	else {
;1092:		l1 = 0.4f;
;1093:		l2 = 0.7f;
;1094:	}
;1095:	//get the flag or defend the base
;1096:	rnd = random();
;1097:	if (rnd < l1 && redobelisk.areanum && blueobelisk.areanum) {
;1098:		bs->decisionmaker = bs->client;
;1099:		bs->ordered = qfalse;
;1100:		//
;1101:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1102:		else memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1103:		//set the ltg type
;1104:		bs->ltgtype = LTG_ATTACKENEMYBASE;
;1105:		//set the time the bot will stop attacking the enemy base
;1106:		bs->teamgoal_time = FloatTime() + TEAM_ATTACKENEMYBASE_TIME;
;1107:		//get an alternate route goal towards the enemy base
;1108:		BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1109:		BotSetTeamStatus(bs);
;1110:	}
;1111:	else if (rnd < l2 && redobelisk.areanum && blueobelisk.areanum) {
;1112:		bs->decisionmaker = bs->client;
;1113:		bs->ordered = qfalse;
;1114:		//
;1115:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1116:		else memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1117:		//set the ltg type
;1118:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1119:		//set the time the bot stops defending the base
;1120:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1121:		bs->defendaway_time = 0;
;1122:		BotSetTeamStatus(bs);
;1123:	}
;1124:	else {
;1125:		bs->ltgtype = 0;
;1126:		//set the time the bot will stop roaming
;1127:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1128:		BotSetTeamStatus(bs);
;1129:	}
;1130:}
;1131:
;1132:/*
;1133:==================
;1134:BotGoHarvest
;1135:==================
;1136:*/
;1137:void BotGoHarvest(bot_state_t *bs) {
;1138:	//
;1139:	if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1140:	else memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1141:	//set the ltg type
;1142:	bs->ltgtype = LTG_HARVEST;
;1143:	//set the time the bot will stop harvesting
;1144:	bs->teamgoal_time = FloatTime() + TEAM_HARVEST_TIME;
;1145:	bs->harvestaway_time = 0;
;1146:	BotSetTeamStatus(bs);
;1147:}
;1148:
;1149:/*
;1150:==================
;1151:BotObeliskRetreatGoals
;1152:==================
;1153:*/
;1154:void BotObeliskRetreatGoals(bot_state_t *bs) {
;1155:	//nothing special
;1156:}
;1157:
;1158:/*
;1159:==================
;1160:BotHarvesterSeekGoals
;1161:==================
;1162:*/
;1163:void BotHarvesterSeekGoals(bot_state_t *bs) {
;1164:	aas_entityinfo_t entinfo;
;1165:	float rnd, l1, l2;
;1166:	int c;
;1167:
;1168:	//when carrying cubes in harvester the bot should rush to the base
;1169:	if (BotHarvesterCarryingCubes(bs)) {
;1170:		//if not already rushing to the base
;1171:		if (bs->ltgtype != LTG_RUSHBASE) {
;1172:			BotRefuseOrder(bs);
;1173:			bs->ltgtype = LTG_RUSHBASE;
;1174:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1175:			bs->rushbaseaway_time = 0;
;1176:			bs->decisionmaker = bs->client;
;1177:			bs->ordered = qfalse;
;1178:			//get an alternative route goal towards the enemy base
;1179:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1180:			//
;1181:			BotSetTeamStatus(bs);
;1182:		}
;1183:		return;
;1184:	}
;1185:	// don't just do something wait for the bot team leader to give orders
;1186:	if (BotTeamLeader(bs)) {
;1187:		return;
;1188:	}
;1189:	// if the bot decided to follow someone
;1190:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
;1191:		// if the team mate being accompanied no longer carries the flag
;1192:		BotEntityInfo(bs->teammate, &entinfo);
;1193:		if (!EntityCarriesCubes(&entinfo)) {
;1194:			bs->ltgtype = 0;
;1195:		}
;1196:	}
;1197:	// if the bot is ordered to do something
;1198:	if ( bs->lastgoal_ltgtype ) {
;1199:		bs->teamgoal_time += 60;
;1200:	}
;1201:	//if not yet doing something
;1202:	if (bs->ltgtype == LTG_TEAMHELP ||
;1203:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;1204:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;1205:			bs->ltgtype == LTG_GETFLAG ||
;1206:			bs->ltgtype == LTG_CAMPORDER ||
;1207:			bs->ltgtype == LTG_PATROL ||
;1208:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;1209:			bs->ltgtype == LTG_HARVEST ||
;1210:			bs->ltgtype == LTG_GETITEM ||
;1211:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;1212:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;1213:		return;
;1214:	}
;1215:	//
;1216:	if (BotSetLastOrderedTask(bs))
;1217:		return;
;1218:	//if the bot is roaming
;1219:	if (bs->ctfroam_time > FloatTime())
;1220:		return;
;1221:	//if the bot has anough aggression to decide what to do
;1222:	if (BotAggression(bs) < 50)
;1223:		return;
;1224:	//set the time to send a message to the team mates
;1225:	bs->teammessage_time = FloatTime() + 2 * random();
;1226:	//
;1227:	c = BotEnemyCubeCarrierVisible(bs);
;1228:	if (c >= 0) {
;1229:		//FIXME: attack enemy cube carrier
;1230:	}
;1231:	if (bs->ltgtype != LTG_TEAMACCOMPANY) {
;1232:		//if there is a visible team mate carrying cubes
;1233:		c = BotTeamCubeCarrierVisible(bs);
;1234:		if (c >= 0) {
;1235:			//follow the team mate carrying cubes
;1236:			bs->decisionmaker = bs->client;
;1237:			bs->ordered = qfalse;
;1238:			//the team mate
;1239:			bs->teammate = c;
;1240:			//last time the team mate was visible
;1241:			bs->teammatevisible_time = FloatTime();
;1242:			//no message
;1243:			bs->teammessage_time = 0;
;1244:			//no arrive message
;1245:			bs->arrive_time = 1;
;1246:			//
;1247:			BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
;1248:			//get the team goal time
;1249:			bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
;1250:			bs->ltgtype = LTG_TEAMACCOMPANY;
;1251:			bs->formation_dist = 3.5 * 32;		//3.5 meter
;1252:			BotSetTeamStatus(bs);
;1253:			return;
;1254:		}
;1255:	}
;1256:	//
;1257:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1258:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1259:			l1 = 0.7f;
;1260:		}
;1261:		else {
;1262:			l1 = 0.2f;
;1263:		}
;1264:		l2 = 0.9f;
;1265:	}
;1266:	else {
;1267:		l1 = 0.4f;
;1268:		l2 = 0.7f;
;1269:	}
;1270:	//
;1271:	rnd = random();
;1272:	if (rnd < l1 && redobelisk.areanum && blueobelisk.areanum) {
;1273:		bs->decisionmaker = bs->client;
;1274:		bs->ordered = qfalse;
;1275:		BotGoHarvest(bs);
;1276:	}
;1277:	else if (rnd < l2 && redobelisk.areanum && blueobelisk.areanum) {
;1278:		bs->decisionmaker = bs->client;
;1279:		bs->ordered = qfalse;
;1280:		//
;1281:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1282:		else memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1283:		//set the ltg type
;1284:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1285:		//set the time the bot stops defending the base
;1286:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1287:		bs->defendaway_time = 0;
;1288:		BotSetTeamStatus(bs);
;1289:	}
;1290:	else {
;1291:		bs->ltgtype = 0;
;1292:		//set the time the bot will stop roaming
;1293:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1294:		BotSetTeamStatus(bs);
;1295:	}
;1296:}
;1297:
;1298:/*
;1299:==================
;1300:BotHarvesterRetreatGoals
;1301:==================
;1302:*/
;1303:void BotHarvesterRetreatGoals(bot_state_t *bs) {
;1304:	//when carrying cubes in harvester the bot should rush to the base
;1305:	if (BotHarvesterCarryingCubes(bs)) {
;1306:		//if not already rushing to the base
;1307:		if (bs->ltgtype != LTG_RUSHBASE) {
;1308:			BotRefuseOrder(bs);
;1309:			bs->ltgtype = LTG_RUSHBASE;
;1310:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1311:			bs->rushbaseaway_time = 0;
;1312:			bs->decisionmaker = bs->client;
;1313:			bs->ordered = qfalse;
;1314:			BotSetTeamStatus(bs);
;1315:		}
;1316:		return;
;1317:	}
;1318:}
;1319:#endif
;1320:
;1321:/*
;1322:==================
;1323:BotTeamGoals
;1324:==================
;1325:*/
;1326:void BotTeamGoals(bot_state_t *bs, int retreat) {
line 1328
;1327:
;1328:	if ( retreat ) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $250
line 1329
;1329:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $251
line 1330
;1330:			BotCTFRetreatGoals(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCTFRetreatGoals
CALLV
pop
line 1331
;1331:		}
line 1343
;1332:#ifdef MISSIONPACK
;1333:		else if (gametype == GT_1FCTF) {
;1334:			Bot1FCTFRetreatGoals(bs);
;1335:		}
;1336:		else if (gametype == GT_OBELISK) {
;1337:			BotObeliskRetreatGoals(bs);
;1338:		}
;1339:		else if (gametype == GT_HARVESTER) {
;1340:			BotHarvesterRetreatGoals(bs);
;1341:		}
;1342:#endif
;1343:	}
ADDRGP4 $251
JUMPV
LABELV $250
line 1344
;1344:	else {
line 1345
;1345:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $254
line 1347
;1346:			//decide what to do in CTF mode
;1347:			BotCTFSeekGoals(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCTFSeekGoals
CALLV
pop
line 1348
;1348:		}
LABELV $254
line 1360
;1349:#ifdef MISSIONPACK
;1350:		else if (gametype == GT_1FCTF) {
;1351:			Bot1FCTFSeekGoals(bs);
;1352:		}
;1353:		else if (gametype == GT_OBELISK) {
;1354:			BotObeliskSeekGoals(bs);
;1355:		}
;1356:		else if (gametype == GT_HARVESTER) {
;1357:			BotHarvesterSeekGoals(bs);
;1358:		}
;1359:#endif
;1360:	}
LABELV $251
line 1363
;1361:	// reset the order time which is used to see if
;1362:	// we decided to refuse an order
;1363:	bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 1364
;1364:}
LABELV $249
endproc BotTeamGoals 0 4
export BotPointAreaNum
proc BotPointAreaNum 68 20
line 1371
;1365:
;1366:/*
;1367:==================
;1368:BotPointAreaNum
;1369:==================
;1370:*/
;1371:int BotPointAreaNum(vec3_t origin) {
line 1375
;1372:	int areanum, numareas, areas[10];
;1373:	vec3_t end;
;1374:
;1375:	areanum = trap_AAS_PointAreaNum(origin);
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
line 1376
;1376:	if (areanum) return areanum;
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $257
ADDRLP4 12
INDIRI4
RETI4
ADDRGP4 $256
JUMPV
LABELV $257
line 1377
;1377:	VectorCopy(origin, end);
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1378
;1378:	end[2] += 10;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
line 1379
;1379:	numareas = trap_AAS_TraceAreas(origin, end, areas, NULL, 10);
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
line 1380
;1380:	if (numareas > 0) return areas[0];
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $260
ADDRLP4 20
INDIRI4
RETI4
ADDRGP4 $256
JUMPV
LABELV $260
line 1381
;1381:	return 0;
CNSTI4 0
RETI4
LABELV $256
endproc BotPointAreaNum 68 20
export ClientName
proc ClientName 1032 12
line 1389
;1382:}
;1383:
;1384:/*
;1385:==================
;1386:ClientName
;1387:==================
;1388:*/
;1389:char *ClientName(int client, char *name, int size) {
line 1392
;1390:	char buf[MAX_INFO_STRING];
;1391:
;1392:	if (client < 0 || client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $265
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $263
LABELV $265
line 1393
;1393:		BotAI_Print(PRT_ERROR, "ClientName: client out of range\n");
CNSTI4 3
ARGI4
ADDRGP4 $266
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 1394
;1394:		return "[client out of range]";
ADDRGP4 $267
RETP4
ADDRGP4 $262
JUMPV
LABELV $263
line 1396
;1395:	}
;1396:	trap_GetConfigstring(CS_PLAYERS+client, buf, sizeof(buf));
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
line 1397
;1397:	strncpy(name, Info_ValueForKey(buf, "n"), size-1);
ADDRLP4 0
ARGP4
ADDRGP4 $268
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
line 1398
;1398:	name[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1399
;1399:	Q_CleanStr( name );
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1400
;1400:	return name;
ADDRFP4 4
INDIRP4
RETP4
LABELV $262
endproc ClientName 1032 12
export ClientSkin
proc ClientSkin 1032 12
line 1408
;1401:}
;1402:
;1403:/*
;1404:==================
;1405:ClientSkin
;1406:==================
;1407:*/
;1408:char *ClientSkin(int client, char *skin, int size) {
line 1411
;1409:	char buf[MAX_INFO_STRING];
;1410:
;1411:	if (client < 0 || client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $272
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $270
LABELV $272
line 1412
;1412:		BotAI_Print(PRT_ERROR, "ClientSkin: client out of range\n");
CNSTI4 3
ARGI4
ADDRGP4 $273
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 1413
;1413:		return "[client out of range]";
ADDRGP4 $267
RETP4
ADDRGP4 $269
JUMPV
LABELV $270
line 1415
;1414:	}
;1415:	trap_GetConfigstring(CS_PLAYERS+client, buf, sizeof(buf));
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
line 1416
;1416:	strncpy(skin, Info_ValueForKey(buf, "model"), size-1);
ADDRLP4 0
ARGP4
ADDRGP4 $274
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
line 1417
;1417:	skin[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1418
;1418:	return skin;
ADDRFP4 4
INDIRP4
RETP4
LABELV $269
endproc ClientSkin 1032 12
bss
align 4
LABELV $276
skip 4
export ClientFromName
code
proc ClientFromName 1040 12
line 1426
;1419:}
;1420:
;1421:/*
;1422:==================
;1423:ClientFromName
;1424:==================
;1425:*/
;1426:int ClientFromName(char *name) {
line 1431
;1427:	int i;
;1428:	char buf[MAX_INFO_STRING];
;1429:	static int maxclients;
;1430:
;1431:	if (!maxclients)
ADDRGP4 $276
INDIRI4
CNSTI4 0
NEI4 $277
line 1432
;1432:		maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $279
ARGP4
ADDRLP4 1028
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 $276
ADDRLP4 1028
INDIRI4
ASGNI4
LABELV $277
line 1433
;1433:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $283
JUMPV
LABELV $280
line 1434
;1434:		trap_GetConfigstring(CS_PLAYERS+i, buf, sizeof(buf));
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
line 1435
;1435:		Q_CleanStr( buf );
ADDRLP4 4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1436
;1436:		if (!Q_stricmp(Info_ValueForKey(buf, "n"), name)) return i;
ADDRLP4 4
ARGP4
ADDRGP4 $268
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
NEI4 $284
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $275
JUMPV
LABELV $284
line 1437
;1437:	}
LABELV $281
line 1433
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $283
ADDRLP4 0
INDIRI4
ADDRGP4 $276
INDIRI4
GEI4 $286
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $280
LABELV $286
line 1438
;1438:	return -1;
CNSTI4 -1
RETI4
LABELV $275
endproc ClientFromName 1040 12
bss
align 4
LABELV $288
skip 4
export ClientOnSameTeamFromName
code
proc ClientOnSameTeamFromName 1044 12
line 1446
;1439:}
;1440:
;1441:/*
;1442:==================
;1443:ClientOnSameTeamFromName
;1444:==================
;1445:*/
;1446:int ClientOnSameTeamFromName(bot_state_t *bs, char *name) {
line 1451
;1447:	int i;
;1448:	char buf[MAX_INFO_STRING];
;1449:	static int maxclients;
;1450:
;1451:	if (!maxclients)
ADDRGP4 $288
INDIRI4
CNSTI4 0
NEI4 $289
line 1452
;1452:		maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $279
ARGP4
ADDRLP4 1028
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 $288
ADDRLP4 1028
INDIRI4
ASGNI4
LABELV $289
line 1453
;1453:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $294
JUMPV
LABELV $291
line 1454
;1454:		if (!BotSameTeam(bs, i))
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
NEI4 $295
line 1455
;1455:			continue;
ADDRGP4 $292
JUMPV
LABELV $295
line 1456
;1456:		trap_GetConfigstring(CS_PLAYERS+i, buf, sizeof(buf));
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
line 1457
;1457:		Q_CleanStr( buf );
ADDRLP4 4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1458
;1458:		if (!Q_stricmp(Info_ValueForKey(buf, "n"), name)) return i;
ADDRLP4 4
ARGP4
ADDRGP4 $268
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
NEI4 $297
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $287
JUMPV
LABELV $297
line 1459
;1459:	}
LABELV $292
line 1453
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $294
ADDRLP4 0
INDIRI4
ADDRGP4 $288
INDIRI4
GEI4 $299
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $291
LABELV $299
line 1460
;1460:	return -1;
CNSTI4 -1
RETI4
LABELV $287
endproc ClientOnSameTeamFromName 1044 12
export stristr
proc stristr 12 4
line 1468
;1461:}
;1462:
;1463:/*
;1464:==================
;1465:stristr
;1466:==================
;1467:*/
;1468:char *stristr(char *str, char *charset) {
ADDRGP4 $302
JUMPV
LABELV $301
line 1471
;1469:	int i;
;1470:
;1471:	while(*str) {
line 1472
;1472:		for (i = 0; charset[i] && str[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $307
JUMPV
LABELV $304
line 1473
;1473:			if (toupper(charset[i]) != toupper(str[i])) break;
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
EQI4 $308
ADDRGP4 $306
JUMPV
LABELV $308
line 1474
;1474:		}
LABELV $305
line 1472
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $307
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
EQI4 $310
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
ADDRLP4 8
INDIRI4
NEI4 $304
LABELV $310
LABELV $306
line 1475
;1475:		if (!charset[i]) return str;
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $311
ADDRFP4 0
INDIRP4
RETP4
ADDRGP4 $300
JUMPV
LABELV $311
line 1476
;1476:		str++;
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1477
;1477:	}
LABELV $302
line 1471
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $301
line 1478
;1478:	return NULL;
CNSTP4 0
RETP4
LABELV $300
endproc stristr 12 4
export EasyClientName
proc EasyClientName 204 12
line 1486
;1479:}
;1480:
;1481:/*
;1482:==================
;1483:EasyClientName
;1484:==================
;1485:*/
;1486:char *EasyClientName(int client, char *buf, int size) {
line 1491
;1487:	int i;
;1488:	char *str1, *str2, *ptr, c;
;1489:	char name[128];
;1490:
;1491:	strcpy(name, ClientName(client, name, sizeof(name)));
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
line 1492
;1492:	for (i = 0; name[i]; i++) name[i] &= 127;
ADDRLP4 136
CNSTI4 0
ASGNI4
ADDRGP4 $317
JUMPV
LABELV $314
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
LABELV $315
ADDRLP4 136
ADDRLP4 136
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $317
ADDRLP4 136
INDIRI4
ADDRLP4 5
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $314
line 1494
;1493:	//remove all spaces
;1494:	for (ptr = strstr(name, " "); ptr; ptr = strstr(name, " ")) {
ADDRLP4 5
ARGP4
ADDRGP4 $322
ARGP4
ADDRLP4 156
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 156
INDIRP4
ASGNP4
ADDRGP4 $321
JUMPV
LABELV $318
line 1495
;1495:		memmove(ptr, ptr+1, strlen(ptr+1)+1);
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
line 1496
;1496:	}
LABELV $319
line 1494
ADDRLP4 5
ARGP4
ADDRGP4 $322
ARGP4
ADDRLP4 160
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 160
INDIRP4
ASGNP4
LABELV $321
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $318
line 1498
;1497:	//check for [x] and ]x[ clan names
;1498:	str1 = strstr(name, "[");
ADDRLP4 5
ARGP4
ADDRGP4 $323
ARGP4
ADDRLP4 164
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 140
ADDRLP4 164
INDIRP4
ASGNP4
line 1499
;1499:	str2 = strstr(name, "]");
ADDRLP4 5
ARGP4
ADDRGP4 $324
ARGP4
ADDRLP4 168
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 144
ADDRLP4 168
INDIRP4
ASGNP4
line 1500
;1500:	if (str1 && str2) {
ADDRLP4 172
CNSTU4 0
ASGNU4
ADDRLP4 140
INDIRP4
CVPU4 4
ADDRLP4 172
INDIRU4
EQU4 $325
ADDRLP4 144
INDIRP4
CVPU4 4
ADDRLP4 172
INDIRU4
EQU4 $325
line 1501
;1501:		if (str2 > str1) memmove(str1, str2+1, strlen(str2+1)+1);
ADDRLP4 144
INDIRP4
CVPU4 4
ADDRLP4 140
INDIRP4
CVPU4 4
LEU4 $327
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
ADDRGP4 $328
JUMPV
LABELV $327
line 1502
;1502:		else memmove(str2, str1+1, strlen(str1+1)+1);
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
LABELV $328
line 1503
;1503:	}
LABELV $325
line 1505
;1504:	//remove Mr prefix
;1505:	if ((name[0] == 'm' || name[0] == 'M') &&
ADDRLP4 176
ADDRLP4 5
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 109
EQI4 $333
ADDRLP4 176
INDIRI4
CNSTI4 77
NEI4 $329
LABELV $333
ADDRLP4 5+1
INDIRI1
CVII4 1
CNSTI4 114
EQI4 $334
ADDRLP4 5+1
INDIRI1
CVII4 1
CNSTI4 82
NEI4 $329
LABELV $334
line 1506
;1506:			(name[1] == 'r' || name[1] == 'R')) {
line 1507
;1507:		memmove(name, name+2, strlen(name+2)+1);
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
line 1508
;1508:	}
LABELV $329
line 1510
;1509:	//only allow lower case alphabet characters
;1510:	ptr = name;
ADDRLP4 0
ADDRLP4 5
ASGNP4
ADDRGP4 $338
JUMPV
LABELV $337
line 1511
;1511:	while(*ptr) {
line 1512
;1512:		c = *ptr;
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRI1
ASGNI1
line 1513
;1513:		if ((c >= 'a' && c <= 'z') ||
ADDRLP4 180
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 97
LTI4 $343
ADDRLP4 180
INDIRI4
CNSTI4 122
LEI4 $344
LABELV $343
ADDRLP4 184
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 48
LTI4 $345
ADDRLP4 184
INDIRI4
CNSTI4 57
LEI4 $344
LABELV $345
ADDRLP4 4
INDIRI1
CVII4 1
CNSTI4 95
NEI4 $340
LABELV $344
line 1514
;1514:				(c >= '0' && c <= '9') || c == '_') {
line 1515
;1515:			ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1516
;1516:		}
ADDRGP4 $341
JUMPV
LABELV $340
line 1517
;1517:		else if (c >= 'A' && c <= 'Z') {
ADDRLP4 188
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 188
INDIRI4
CNSTI4 65
LTI4 $346
ADDRLP4 188
INDIRI4
CNSTI4 90
GTI4 $346
line 1518
;1518:			*ptr += 'a' - 'A';
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
line 1519
;1519:			ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1520
;1520:		}
ADDRGP4 $347
JUMPV
LABELV $346
line 1521
;1521:		else {
line 1522
;1522:			memmove(ptr, ptr+1, strlen(ptr + 1)+1);
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
line 1523
;1523:		}
LABELV $347
LABELV $341
line 1524
;1524:	}
LABELV $338
line 1511
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $337
line 1525
;1525:	strncpy(buf, name, size-1);
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
line 1526
;1526:	buf[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1527
;1527:	return buf;
ADDRFP4 4
INDIRP4
RETP4
LABELV $313
endproc EasyClientName 204 12
export BotSynonymContext
proc BotSynonymContext 8 4
line 1535
;1528:}
;1529:
;1530:/*
;1531:==================
;1532:BotSynonymContext
;1533:==================
;1534:*/
;1535:int BotSynonymContext(bot_state_t *bs) {
line 1538
;1536:	int context;
;1537:
;1538:	context = CONTEXT_NORMAL|CONTEXT_NEARBYITEM|CONTEXT_NAMES;
ADDRLP4 0
CNSTI4 1027
ASGNI4
line 1540
;1539:	//
;1540:	if (gametype == GT_CTF
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $349
line 1544
;1541:#ifdef MISSIONPACK
;1542:		|| gametype == GT_1FCTF
;1543:#endif
;1544:		) {
line 1545
;1545:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_CTFREDTEAM;
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
NEI4 $351
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 4
BORI4
ASGNI4
ADDRGP4 $352
JUMPV
LABELV $351
line 1546
;1546:		else context |= CONTEXT_CTFBLUETEAM;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 8
BORI4
ASGNI4
LABELV $352
line 1547
;1547:	}
LABELV $349
line 1558
;1548:#ifdef MISSIONPACK
;1549:	else if (gametype == GT_OBELISK) {
;1550:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_OBELISKREDTEAM;
;1551:		else context |= CONTEXT_OBELISKBLUETEAM;
;1552:	}
;1553:	else if (gametype == GT_HARVESTER) {
;1554:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_HARVESTERREDTEAM;
;1555:		else context |= CONTEXT_HARVESTERBLUETEAM;
;1556:	}
;1557:#endif
;1558:	return context;
ADDRLP4 0
INDIRI4
RETI4
LABELV $348
endproc BotSynonymContext 8 4
export BotChooseWeapon
proc BotChooseWeapon 20 8
line 1566
;1559:}
;1560:
;1561:/*
;1562:==================
;1563:BotChooseWeapon
;1564:==================
;1565:*/
;1566:void BotChooseWeapon(bot_state_t *bs) {
line 1569
;1567:	int newweaponnum;
;1568:
;1569:	if (bs->cur_ps.weaponstate == WEAPON_RAISING ||
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
EQI4 $356
ADDRLP4 4
INDIRI4
CNSTI4 2
NEI4 $354
LABELV $356
line 1570
;1570:			bs->cur_ps.weaponstate == WEAPON_DROPPING) {
line 1572
;1571:		//trap_EA_SelectWeapon(bs->client, bs->weaponnum);
;1572:		if( g_blasterMode.integer &&
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $357
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $357
line 1573
;1573:			bs->weaponnum == WP_MACHINEGUN ) {
line 1574
;1574:			trap_EA_SelectWeapon(
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
line 1578
;1575:				bs->client,
;1576:				WP_BLASTER
;1577:			);
;1578:		}
ADDRGP4 $355
JUMPV
LABELV $357
line 1579
;1579:		else {
line 1580
;1580:			trap_EA_SelectWeapon(
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
line 1584
;1581:				bs->client,
;1582:				bs->weaponnum
;1583:			);
;1584:		}
line 1585
;1585:		}
ADDRGP4 $355
JUMPV
LABELV $354
line 1586
;1586:	else {
line 1587
;1587:		newweaponnum = trap_BotChooseBestFightWeapon(bs->ws, bs->inventory);
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
line 1588
;1588:		if (bs->weaponnum != newweaponnum) bs->weaponchange_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $360
ADDRFP4 0
INDIRP4
CNSTI4 6192
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
LABELV $360
line 1589
;1589:		bs->weaponnum = newweaponnum;
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1592
;1590:		//BotAI_Print(PRT_MESSAGE, "bs->weaponnum = %d\n", bs->weaponnum);
;1591:		//trap_EA_SelectWeapon(bs->client, bs->weaponnum);
;1592:		if( g_blasterMode.integer &&
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $362
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $362
line 1593
;1593:			bs->weaponnum == WP_MACHINEGUN ) {
line 1594
;1594:			trap_EA_SelectWeapon(
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
line 1598
;1595:				bs->client,
;1596:				WP_BLASTER
;1597:			);
;1598:		}
ADDRGP4 $363
JUMPV
LABELV $362
line 1599
;1599:		else {
line 1600
;1600:			trap_EA_SelectWeapon(
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
line 1604
;1601:				bs->client,
;1602:				bs->weaponnum
;1603:			);
;1604:		}
LABELV $363
line 1605
;1605:	}
LABELV $355
line 1606
;1606:}
LABELV $353
endproc BotChooseWeapon 20 8
export BotSetupForMovement
proc BotSetupForMovement 88 12
line 1613
;1607:
;1608:/*
;1609:==================
;1610:BotSetupForMovement
;1611:==================
;1612:*/
;1613:void BotSetupForMovement(bot_state_t *bs) {
line 1616
;1614:	bot_initmove_t initmove;
;1615:
;1616:	memset(&initmove, 0, sizeof(bot_initmove_t));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 68
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1617
;1617:	VectorCopy(bs->cur_ps.origin, initmove.origin);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRB
ASGNB 12
line 1618
;1618:	VectorCopy(bs->cur_ps.velocity, initmove.velocity);
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRB
ASGNB 12
line 1619
;1619:	VectorClear(initmove.viewoffset);
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
line 1620
;1620:	initmove.viewoffset[2] += bs->cur_ps.viewheight;
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
line 1621
;1621:	initmove.entitynum = bs->entitynum;
ADDRLP4 0+36
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1622
;1622:	initmove.client = bs->client;
ADDRLP4 0+40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1623
;1623:	initmove.thinktime = bs->thinktime;
ADDRLP4 0+44
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
ASGNF4
line 1625
;1624:	//set the onground flag
;1625:	if (bs->cur_ps.groundEntityNum != ENTITYNUM_NONE) initmove.or_moveflags |= MFL_ONGROUND;
ADDRFP4 0
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 1023
EQI4 $377
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 2
BORI4
ASGNI4
LABELV $377
line 1627
;1626:	//set the teleported flag
;1627:	if ((bs->cur_ps.pm_flags & PMF_TIME_KNOCKBACK) && (bs->cur_ps.pm_time > 0)) {
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
EQI4 $380
ADDRLP4 72
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
LEI4 $380
line 1628
;1628:		initmove.or_moveflags |= MFL_TELEPORTED;
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 1629
;1629:	}
LABELV $380
line 1631
;1630:	//set the waterjump flag
;1631:	if ((bs->cur_ps.pm_flags & PMF_TIME_WATERJUMP) && (bs->cur_ps.pm_time > 0)) {
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
EQI4 $383
ADDRLP4 80
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
LEI4 $383
line 1632
;1632:		initmove.or_moveflags |= MFL_WATERJUMP;
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 1633
;1633:	}
LABELV $383
line 1635
;1634:	//set presence type
;1635:	if (bs->cur_ps.pm_flags & PMF_DUCKED) initmove.presencetype = PRESENCE_CROUCH;
ADDRFP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $386
ADDRLP4 0+48
CNSTI4 4
ASGNI4
ADDRGP4 $387
JUMPV
LABELV $386
line 1636
;1636:	else initmove.presencetype = PRESENCE_NORMAL;
ADDRLP4 0+48
CNSTI4 2
ASGNI4
LABELV $387
line 1638
;1637:	//
;1638:	if (bs->walker > 0.5) initmove.or_moveflags |= MFL_WALK;
ADDRFP4 0
INDIRP4
CNSTI4 6056
ADDP4
INDIRF4
CNSTF4 1056964608
LEF4 $390
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 512
BORI4
ASGNI4
LABELV $390
line 1640
;1639:	//
;1640:	VectorCopy(bs->viewangles, initmove.viewangles);
ADDRLP4 0+52
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
INDIRB
ASGNB 12
line 1642
;1641:	//
;1642:	trap_BotInitMoveState(bs->ms, &initmove);
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
line 1643
;1643:}
LABELV $365
endproc BotSetupForMovement 88 12
export BotCheckItemPickup
proc BotCheckItemPickup 0 0
line 1650
;1644:
;1645:/*
;1646:==================
;1647:BotCheckItemPickup
;1648:==================
;1649:*/
;1650:void BotCheckItemPickup(bot_state_t *bs, int *oldinventory) {
line 1737
;1651:#ifdef MISSIONPACK
;1652:	int offence, leader;
;1653:
;1654:	if (gametype <= GT_TEAM)
;1655:		return;
;1656:
;1657:	offence = -1;
;1658:	// go into offence if picked up the kamikaze or invulnerability
;1659:	if (!oldinventory[INVENTORY_KAMIKAZE] && bs->inventory[INVENTORY_KAMIKAZE] >= 1) {
;1660:		offence = qtrue;
;1661:	}
;1662:	if (!oldinventory[INVENTORY_INVULNERABILITY] && bs->inventory[INVENTORY_INVULNERABILITY] >= 1) {
;1663:		offence = qtrue;
;1664:	}
;1665:	// if not already wearing the kamikaze or invulnerability
;1666:	if (!bs->inventory[INVENTORY_KAMIKAZE] && !bs->inventory[INVENTORY_INVULNERABILITY]) {
;1667:		if (!oldinventory[INVENTORY_SCOUT] && bs->inventory[INVENTORY_SCOUT] >= 1) {
;1668:			offence = qtrue;
;1669:		}
;1670:		if (!oldinventory[INVENTORY_GUARD] && bs->inventory[INVENTORY_GUARD] >= 1) {
;1671:			offence = qtrue;
;1672:		}
;1673:		if (!oldinventory[INVENTORY_DOUBLER] && bs->inventory[INVENTORY_DOUBLER] >= 1) {
;1674:			offence = qfalse;
;1675:		}
;1676:		if (!oldinventory[INVENTORY_AMMOREGEN] && bs->inventory[INVENTORY_AMMOREGEN] >= 1) {
;1677:			offence = qfalse;
;1678:		}
;1679:	}
;1680:
;1681:	if (offence >= 0) {
;1682:		leader = ClientFromName(bs->teamleader);
;1683:		if (offence) {
;1684:			if (!(bs->teamtaskpreference & TEAMTP_ATTACKER)) {
;1685:				// if we have a bot team leader
;1686:				if (BotTeamLeader(bs)) {
;1687:					// tell the leader we want to be on offence
;1688:					BotVoiceChat(bs, leader, VOICECHAT_WANTONOFFENSE);
;1689:					//BotAI_BotInitialChat(bs, "wantoffence", NULL);
;1690:					//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1691:				}
;1692:				else if (g_spSkill.integer <= 3) {
;1693:					if ( bs->ltgtype != LTG_GETFLAG &&
;1694:						 bs->ltgtype != LTG_ATTACKENEMYBASE &&
;1695:						 bs->ltgtype != LTG_HARVEST ) {
;1696:						//
;1697:						if ((gametype != GT_CTF || (bs->redflagstatus == 0 && bs->blueflagstatus == 0)) &&
;1698:							(gametype != GT_1FCTF || bs->neutralflagstatus == 0) ) {
;1699:							// tell the leader we want to be on offence
;1700:							BotVoiceChat(bs, leader, VOICECHAT_WANTONOFFENSE);
;1701:							//BotAI_BotInitialChat(bs, "wantoffence", NULL);
;1702:							//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1703:						}
;1704:					}
;1705:					bs->teamtaskpreference |= TEAMTP_ATTACKER;
;1706:				}
;1707:			}
;1708:			bs->teamtaskpreference &= ~TEAMTP_DEFENDER;
;1709:		}
;1710:		else {
;1711:			if (!(bs->teamtaskpreference & TEAMTP_DEFENDER)) {
;1712:				// if we have a bot team leader
;1713:				if (BotTeamLeader(bs)) {
;1714:					// tell the leader we want to be on defense
;1715:					BotVoiceChat(bs, -1, VOICECHAT_WANTONDEFENSE);
;1716:					//BotAI_BotInitialChat(bs, "wantdefence", NULL);
;1717:					//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1718:				}
;1719:				else if (g_spSkill.integer <= 3) {
;1720:					if ( bs->ltgtype != LTG_DEFENDKEYAREA ) {
;1721:						//
;1722:						if ((gametype != GT_CTF || (bs->redflagstatus == 0 && bs->blueflagstatus == 0)) &&
;1723:							(gametype != GT_1FCTF || bs->neutralflagstatus == 0) ) {
;1724:							// tell the leader we want to be on defense
;1725:							BotVoiceChat(bs, -1, VOICECHAT_WANTONDEFENSE);
;1726:							//BotAI_BotInitialChat(bs, "wantdefence", NULL);
;1727:							//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1728:						}
;1729:					}
;1730:				}
;1731:				bs->teamtaskpreference |= TEAMTP_DEFENDER;
;1732:			}
;1733:			bs->teamtaskpreference &= ~TEAMTP_ATTACKER;
;1734:		}
;1735:	}
;1736:#endif
;1737:}
LABELV $394
endproc BotCheckItemPickup 0 0
export BotUpdateInventory
proc BotUpdateInventory 1216 12
line 1744
;1738:
;1739:/*
;1740:==================
;1741:BotUpdateInventory
;1742:==================
;1743:*/
;1744:void BotUpdateInventory(bot_state_t *bs) {
line 1747
;1745:	int oldinventory[MAX_ITEMS];
;1746:
;1747:	memcpy(oldinventory, bs->inventory, sizeof(oldinventory));
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
line 1749
;1748:	//armor
;1749:	bs->inventory[INVENTORY_ARMOR] = bs->cur_ps.stats[STAT_ARMOR];
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
line 1751
;1750:	//weapons
;1751:	bs->inventory[INVENTORY_GAUNTLET] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GAUNTLET)) != 0;
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
EQI4 $397
ADDRLP4 1028
CNSTI4 1
ASGNI4
ADDRGP4 $398
JUMPV
LABELV $397
ADDRLP4 1028
CNSTI4 0
ASGNI4
LABELV $398
ADDRLP4 1032
INDIRP4
CNSTI4 4968
ADDP4
ADDRLP4 1028
INDIRI4
ASGNI4
line 1752
;1752:	bs->inventory[INVENTORY_SHOTGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_SHOTGUN)) != 0;
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
EQI4 $400
ADDRLP4 1036
CNSTI4 1
ASGNI4
ADDRGP4 $401
JUMPV
LABELV $400
ADDRLP4 1036
CNSTI4 0
ASGNI4
LABELV $401
ADDRLP4 1040
INDIRP4
CNSTI4 4972
ADDP4
ADDRLP4 1036
INDIRI4
ASGNI4
line 1754
;1753:	//bs->inventory[INVENTORY_MACHINEGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_MACHINEGUN)) != 0;
;1754:	if( g_blasterMode.integer ) {
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $402
line 1755
;1755:		bs->inventory[INVENTORY_MACHINEGUN] =
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
EQI4 $406
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $407
JUMPV
LABELV $406
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $407
ADDRLP4 1048
INDIRP4
CNSTI4 4976
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1758
;1756:			(bs->cur_ps.stats[STAT_WEAPONS] &
;1757:			(1 << WP_BLASTER)) != 0;
;1758:	}
ADDRGP4 $403
JUMPV
LABELV $402
line 1759
;1759:	else {
line 1760
;1760:		bs->inventory[INVENTORY_MACHINEGUN] =
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
EQI4 $409
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $410
JUMPV
LABELV $409
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $410
ADDRLP4 1048
INDIRP4
CNSTI4 4976
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1763
;1761:			(bs->cur_ps.stats[STAT_WEAPONS] &
;1762:			(1 << WP_MACHINEGUN)) != 0;
;1763:	}
LABELV $403
line 1764
;1764:	bs->inventory[INVENTORY_GRENADELAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GRENADE_LAUNCHER)) != 0;
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
EQI4 $412
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $413
JUMPV
LABELV $412
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $413
ADDRLP4 1048
INDIRP4
CNSTI4 4980
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1765
;1765:	bs->inventory[INVENTORY_ROCKETLAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_ROCKET_LAUNCHER)) != 0;
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
EQI4 $415
ADDRLP4 1052
CNSTI4 1
ASGNI4
ADDRGP4 $416
JUMPV
LABELV $415
ADDRLP4 1052
CNSTI4 0
ASGNI4
LABELV $416
ADDRLP4 1056
INDIRP4
CNSTI4 4984
ADDP4
ADDRLP4 1052
INDIRI4
ASGNI4
line 1766
;1766:	bs->inventory[INVENTORY_LIGHTNING] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_LIGHTNING)) != 0;
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
EQI4 $418
ADDRLP4 1060
CNSTI4 1
ASGNI4
ADDRGP4 $419
JUMPV
LABELV $418
ADDRLP4 1060
CNSTI4 0
ASGNI4
LABELV $419
ADDRLP4 1064
INDIRP4
CNSTI4 4988
ADDP4
ADDRLP4 1060
INDIRI4
ASGNI4
line 1767
;1767:	bs->inventory[INVENTORY_RAILGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_RAILGUN)) != 0;
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
EQI4 $421
ADDRLP4 1068
CNSTI4 1
ASGNI4
ADDRGP4 $422
JUMPV
LABELV $421
ADDRLP4 1068
CNSTI4 0
ASGNI4
LABELV $422
ADDRLP4 1072
INDIRP4
CNSTI4 4992
ADDP4
ADDRLP4 1068
INDIRI4
ASGNI4
line 1768
;1768:	bs->inventory[INVENTORY_PLASMAGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_PLASMAGUN)) != 0;
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
EQI4 $424
ADDRLP4 1076
CNSTI4 1
ASGNI4
ADDRGP4 $425
JUMPV
LABELV $424
ADDRLP4 1076
CNSTI4 0
ASGNI4
LABELV $425
ADDRLP4 1080
INDIRP4
CNSTI4 4996
ADDP4
ADDRLP4 1076
INDIRI4
ASGNI4
line 1769
;1769:	bs->inventory[INVENTORY_BFG10K] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_BFG)) != 0;
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
EQI4 $427
ADDRLP4 1084
CNSTI4 1
ASGNI4
ADDRGP4 $428
JUMPV
LABELV $427
ADDRLP4 1084
CNSTI4 0
ASGNI4
LABELV $428
ADDRLP4 1088
INDIRP4
CNSTI4 5004
ADDP4
ADDRLP4 1084
INDIRI4
ASGNI4
line 1770
;1770:	bs->inventory[INVENTORY_GRAPPLINGHOOK] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GRAPPLING_HOOK)) != 0;
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
EQI4 $430
ADDRLP4 1092
CNSTI4 1
ASGNI4
ADDRGP4 $431
JUMPV
LABELV $430
ADDRLP4 1092
CNSTI4 0
ASGNI4
LABELV $431
ADDRLP4 1096
INDIRP4
CNSTI4 5008
ADDP4
ADDRLP4 1092
INDIRI4
ASGNI4
line 1777
;1771:#ifdef MISSIONPACK
;1772:	bs->inventory[INVENTORY_NAILGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_NAILGUN)) != 0;;
;1773:	bs->inventory[INVENTORY_PROXLAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_PROX_LAUNCHER)) != 0;;
;1774:	bs->inventory[INVENTORY_CHAINGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_CHAINGUN)) != 0;;
;1775:#endif
;1776:	//ammo
;1777:	bs->inventory[INVENTORY_SHELLS] = bs->cur_ps.ammo[WP_SHOTGUN];
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
line 1779
;1778:	//bs->inventory[INVENTORY_BULLETS] = bs->cur_ps.ammo[WP_MACHINEGUN];
;1779:	if( g_blasterMode.integer &&
ADDRLP4 1104
CNSTI4 0
ASGNI4
ADDRGP4 g_blasterMode+12
INDIRI4
ADDRLP4 1104
INDIRI4
EQI4 $432
ADDRFP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
ADDRLP4 1104
INDIRI4
EQI4 $432
line 1781
;1780:		(bs->cur_ps.stats[STAT_WEAPONS] &
;1781:		(1 << WP_BLASTER)) ) {
line 1786
;1782:		/*
;1783:		 * This value is only used by bot AI when choosing a weapon.
;1784:		 * Actual Blaster ammunition remains infinite.
;1785:		 */
;1786:		bs->inventory[INVENTORY_BULLETS] = 1;
ADDRFP4 0
INDIRP4
CNSTI4 5028
ADDP4
CNSTI4 1
ASGNI4
line 1787
;1787:	}
ADDRGP4 $433
JUMPV
LABELV $432
line 1788
;1788:	else {
line 1789
;1789:		bs->inventory[INVENTORY_BULLETS] =
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
line 1791
;1790:			bs->cur_ps.ammo[WP_MACHINEGUN];
;1791:	}
LABELV $433
line 1792
;1792:	bs->inventory[INVENTORY_GRENADES] = bs->cur_ps.ammo[WP_GRENADE_LAUNCHER];
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
line 1793
;1793:	bs->inventory[INVENTORY_CELLS] = bs->cur_ps.ammo[WP_PLASMAGUN];
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
line 1794
;1794:	bs->inventory[INVENTORY_LIGHTNINGAMMO] = bs->cur_ps.ammo[WP_LIGHTNING];
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
line 1795
;1795:	bs->inventory[INVENTORY_ROCKETS] = bs->cur_ps.ammo[WP_ROCKET_LAUNCHER];
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
line 1796
;1796:	bs->inventory[INVENTORY_SLUGS] = bs->cur_ps.ammo[WP_RAILGUN];
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
line 1797
;1797:	bs->inventory[INVENTORY_BFGAMMO] = bs->cur_ps.ammo[WP_BFG];
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
line 1804
;1798:#ifdef MISSIONPACK
;1799:	bs->inventory[INVENTORY_NAILS] = bs->cur_ps.ammo[WP_NAILGUN];
;1800:	bs->inventory[INVENTORY_MINES] = bs->cur_ps.ammo[WP_PROX_LAUNCHER];
;1801:	bs->inventory[INVENTORY_BELT] = bs->cur_ps.ammo[WP_CHAINGUN];
;1802:#endif
;1803:	//powerups
;1804:	bs->inventory[INVENTORY_HEALTH] = bs->cur_ps.stats[STAT_HEALTH];
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
line 1805
;1805:	bs->inventory[INVENTORY_TELEPORTER] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_TELEPORTER;
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
NEI4 $436
ADDRLP4 1136
CNSTI4 1
ASGNI4
ADDRGP4 $437
JUMPV
LABELV $436
ADDRLP4 1136
CNSTI4 0
ASGNI4
LABELV $437
ADDRLP4 1140
INDIRP4
CNSTI4 5072
ADDP4
ADDRLP4 1136
INDIRI4
ASGNI4
line 1806
;1806:	bs->inventory[INVENTORY_MEDKIT] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_MEDKIT;
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
NEI4 $439
ADDRLP4 1144
CNSTI4 1
ASGNI4
ADDRGP4 $440
JUMPV
LABELV $439
ADDRLP4 1144
CNSTI4 0
ASGNI4
LABELV $440
ADDRLP4 1148
INDIRP4
CNSTI4 5076
ADDP4
ADDRLP4 1144
INDIRI4
ASGNI4
line 1812
;1807:#ifdef MISSIONPACK
;1808:	bs->inventory[INVENTORY_KAMIKAZE] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_KAMIKAZE;
;1809:	bs->inventory[INVENTORY_PORTAL] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_PORTAL;
;1810:	bs->inventory[INVENTORY_INVULNERABILITY] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_INVULNERABILITY;
;1811:#endif
;1812:	bs->inventory[INVENTORY_QUAD] = bs->cur_ps.powerups[PW_QUAD] != 0;
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
EQI4 $442
ADDRLP4 1152
CNSTI4 1
ASGNI4
ADDRGP4 $443
JUMPV
LABELV $442
ADDRLP4 1152
CNSTI4 0
ASGNI4
LABELV $443
ADDRLP4 1156
INDIRP4
CNSTI4 5092
ADDP4
ADDRLP4 1152
INDIRI4
ASGNI4
line 1813
;1813:	bs->inventory[INVENTORY_ENVIRONMENTSUIT] = bs->cur_ps.powerups[PW_BATTLESUIT] != 0;
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
EQI4 $445
ADDRLP4 1160
CNSTI4 1
ASGNI4
ADDRGP4 $446
JUMPV
LABELV $445
ADDRLP4 1160
CNSTI4 0
ASGNI4
LABELV $446
ADDRLP4 1164
INDIRP4
CNSTI4 5096
ADDP4
ADDRLP4 1160
INDIRI4
ASGNI4
line 1814
;1814:	bs->inventory[INVENTORY_HASTE] = bs->cur_ps.powerups[PW_HASTE] != 0;
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
EQI4 $448
ADDRLP4 1168
CNSTI4 1
ASGNI4
ADDRGP4 $449
JUMPV
LABELV $448
ADDRLP4 1168
CNSTI4 0
ASGNI4
LABELV $449
ADDRLP4 1172
INDIRP4
CNSTI4 5100
ADDP4
ADDRLP4 1168
INDIRI4
ASGNI4
line 1815
;1815:	bs->inventory[INVENTORY_INVISIBILITY] = bs->cur_ps.powerups[PW_INVIS] != 0;
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
EQI4 $451
ADDRLP4 1176
CNSTI4 1
ASGNI4
ADDRGP4 $452
JUMPV
LABELV $451
ADDRLP4 1176
CNSTI4 0
ASGNI4
LABELV $452
ADDRLP4 1180
INDIRP4
CNSTI4 5104
ADDP4
ADDRLP4 1176
INDIRI4
ASGNI4
line 1816
;1816:	bs->inventory[INVENTORY_REGEN] = bs->cur_ps.powerups[PW_REGEN] != 0;
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
EQI4 $454
ADDRLP4 1184
CNSTI4 1
ASGNI4
ADDRGP4 $455
JUMPV
LABELV $454
ADDRLP4 1184
CNSTI4 0
ASGNI4
LABELV $455
ADDRLP4 1188
INDIRP4
CNSTI4 5108
ADDP4
ADDRLP4 1184
INDIRI4
ASGNI4
line 1817
;1817:	bs->inventory[INVENTORY_FLIGHT] = bs->cur_ps.powerups[PW_FLIGHT] != 0;
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
EQI4 $457
ADDRLP4 1192
CNSTI4 1
ASGNI4
ADDRGP4 $458
JUMPV
LABELV $457
ADDRLP4 1192
CNSTI4 0
ASGNI4
LABELV $458
ADDRLP4 1196
INDIRP4
CNSTI4 5112
ADDP4
ADDRLP4 1192
INDIRI4
ASGNI4
line 1824
;1818:#ifdef MISSIONPACK
;1819:	bs->inventory[INVENTORY_SCOUT] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_SCOUT;
;1820:	bs->inventory[INVENTORY_GUARD] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_GUARD;
;1821:	bs->inventory[INVENTORY_DOUBLER] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_DOUBLER;
;1822:	bs->inventory[INVENTORY_AMMOREGEN] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_AMMOREGEN;
;1823:#endif
;1824:	bs->inventory[INVENTORY_REDFLAG] = bs->cur_ps.powerups[PW_REDFLAG] != 0;
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
EQI4 $460
ADDRLP4 1200
CNSTI4 1
ASGNI4
ADDRGP4 $461
JUMPV
LABELV $460
ADDRLP4 1200
CNSTI4 0
ASGNI4
LABELV $461
ADDRLP4 1204
INDIRP4
CNSTI4 5132
ADDP4
ADDRLP4 1200
INDIRI4
ASGNI4
line 1825
;1825:	bs->inventory[INVENTORY_BLUEFLAG] = bs->cur_ps.powerups[PW_BLUEFLAG] != 0;
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
EQI4 $463
ADDRLP4 1208
CNSTI4 1
ASGNI4
ADDRGP4 $464
JUMPV
LABELV $463
ADDRLP4 1208
CNSTI4 0
ASGNI4
LABELV $464
ADDRLP4 1212
INDIRP4
CNSTI4 5136
ADDP4
ADDRLP4 1208
INDIRI4
ASGNI4
line 1837
;1826:#ifdef MISSIONPACK
;1827:	bs->inventory[INVENTORY_NEUTRALFLAG] = bs->cur_ps.powerups[PW_NEUTRALFLAG] != 0;
;1828:	if (BotTeam(bs) == TEAM_RED) {
;1829:		bs->inventory[INVENTORY_REDCUBE] = bs->cur_ps.generic1;
;1830:		bs->inventory[INVENTORY_BLUECUBE] = 0;
;1831:	}
;1832:	else {
;1833:		bs->inventory[INVENTORY_REDCUBE] = 0;
;1834:		bs->inventory[INVENTORY_BLUECUBE] = bs->cur_ps.generic1;
;1835:	}
;1836:#endif
;1837:	BotCheckItemPickup(bs, oldinventory);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckItemPickup
CALLV
pop
line 1838
;1838:}
LABELV $395
endproc BotUpdateInventory 1216 12
export BotUpdateBattleInventory
proc BotUpdateBattleInventory 160 8
line 1845
;1839:
;1840:/*
;1841:==================
;1842:BotUpdateBattleInventory
;1843:==================
;1844:*/
;1845:void BotUpdateBattleInventory(bot_state_t *bs, int enemy) {
line 1849
;1846:	vec3_t dir;
;1847:	aas_entityinfo_t entinfo;
;1848:
;1849:	BotEntityInfo(enemy, &entinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 1850
;1850:	VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 1851
;1851:	bs->inventory[ENEMY_HEIGHT] = (int) dir[2];
ADDRFP4 0
INDIRP4
CNSTI4 5756
ADDP4
ADDRLP4 0+8
INDIRF4
CVFI4 4
ASGNI4
line 1852
;1852:	dir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1853
;1853:	bs->inventory[ENEMY_HORIZONTAL_DIST] = (int) VectorLength(dir);
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
line 1855
;1854:	//FIXME: add num visible enemies and num visible team mates to the inventory
;1855:}
LABELV $465
endproc BotUpdateBattleInventory 160 8
export BotBattleUseItems
proc BotBattleUseItems 4 4
line 2082
;1856:
;1857:#ifdef MISSIONPACK
;1858:/*
;1859:==================
;1860:BotUseKamikaze
;1861:==================
;1862:*/
;1863:#define KAMIKAZE_DIST		1024
;1864:
;1865:void BotUseKamikaze(bot_state_t *bs) {
;1866:	int c, teammates, enemies;
;1867:	aas_entityinfo_t entinfo;
;1868:	vec3_t dir, target;
;1869:	bot_goal_t *goal;
;1870:	bsp_trace_t trace;
;1871:
;1872:	//if the bot has no kamikaze
;1873:	if (bs->inventory[INVENTORY_KAMIKAZE] <= 0)
;1874:		return;
;1875:	if (bs->kamikaze_time > FloatTime())
;1876:		return;
;1877:	bs->kamikaze_time = FloatTime() + 0.2;
;1878:	if (gametype == GT_CTF) {
;1879:		//never use kamikaze if the team flag carrier is visible
;1880:		if (BotCTFCarryingFlag(bs))
;1881:			return;
;1882:		c = BotTeamFlagCarrierVisible(bs);
;1883:		if (c >= 0) {
;1884:			BotEntityInfo(c, &entinfo);
;1885:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1886:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1887:				return;
;1888:		}
;1889:		c = BotEnemyFlagCarrierVisible(bs);
;1890:		if (c >= 0) {
;1891:			BotEntityInfo(c, &entinfo);
;1892:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1893:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1894:				trap_EA_Use(bs->client);
;1895:				return;
;1896:			}
;1897:		}
;1898:	}
;1899:	else if (gametype == GT_1FCTF) {
;1900:		//never use kamikaze if the team flag carrier is visible
;1901:		if (Bot1FCTFCarryingFlag(bs))
;1902:			return;
;1903:		c = BotTeamFlagCarrierVisible(bs);
;1904:		if (c >= 0) {
;1905:			BotEntityInfo(c, &entinfo);
;1906:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1907:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1908:				return;
;1909:		}
;1910:		c = BotEnemyFlagCarrierVisible(bs);
;1911:		if (c >= 0) {
;1912:			BotEntityInfo(c, &entinfo);
;1913:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1914:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1915:				trap_EA_Use(bs->client);
;1916:				return;
;1917:			}
;1918:		}
;1919:	}
;1920:	else if (gametype == GT_OBELISK) {
;1921:		switch(BotTeam(bs)) {
;1922:			case TEAM_RED: goal = &blueobelisk; break;
;1923:			default: goal = &redobelisk; break;
;1924:		}
;1925:		//if the obelisk is visible
;1926:		VectorCopy(goal->origin, target);
;1927:		target[2] += 1;
;1928:		VectorSubtract(bs->origin, target, dir);
;1929:		if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST * 0.9)) {
;1930:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;1931:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;1932:				trap_EA_Use(bs->client);
;1933:				return;
;1934:			}
;1935:		}
;1936:	}
;1937:	else if (gametype == GT_HARVESTER) {
;1938:		//
;1939:		if (BotHarvesterCarryingCubes(bs))
;1940:			return;
;1941:		//never use kamikaze if a team mate carrying cubes is visible
;1942:		c = BotTeamCubeCarrierVisible(bs);
;1943:		if (c >= 0) {
;1944:			BotEntityInfo(c, &entinfo);
;1945:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1946:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1947:				return;
;1948:		}
;1949:		c = BotEnemyCubeCarrierVisible(bs);
;1950:		if (c >= 0) {
;1951:			BotEntityInfo(c, &entinfo);
;1952:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1953:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1954:				trap_EA_Use(bs->client);
;1955:				return;
;1956:			}
;1957:		}
;1958:	}
;1959:	//
;1960:	BotVisibleTeamMatesAndEnemies(bs, &teammates, &enemies, KAMIKAZE_DIST);
;1961:	//
;1962:	if (enemies > 2 && enemies > teammates+1) {
;1963:		trap_EA_Use(bs->client);
;1964:		return;
;1965:	}
;1966:}
;1967:
;1968:/*
;1969:==================
;1970:BotUseInvulnerability
;1971:==================
;1972:*/
;1973:void BotUseInvulnerability(bot_state_t *bs) {
;1974:	int c;
;1975:	vec3_t dir, target;
;1976:	bot_goal_t *goal;
;1977:	bsp_trace_t trace;
;1978:
;1979:	//if the bot has no invulnerability
;1980:	if (bs->inventory[INVENTORY_INVULNERABILITY] <= 0)
;1981:		return;
;1982:	if (bs->invulnerability_time > FloatTime())
;1983:		return;
;1984:	bs->invulnerability_time = FloatTime() + 0.2;
;1985:	if (gametype == GT_CTF) {
;1986:		//never use kamikaze if the team flag carrier is visible
;1987:		if (BotCTFCarryingFlag(bs))
;1988:			return;
;1989:		c = BotEnemyFlagCarrierVisible(bs);
;1990:		if (c >= 0)
;1991:			return;
;1992:		//if near enemy flag and the flag is visible
;1993:		switch(BotTeam(bs)) {
;1994:			case TEAM_RED: goal = &ctf_blueflag; break;
;1995:			default: goal = &ctf_redflag; break;
;1996:		}
;1997:		//if the obelisk is visible
;1998:		VectorCopy(goal->origin, target);
;1999:		target[2] += 1;
;2000:		VectorSubtract(bs->origin, target, dir);
;2001:		if (VectorLengthSquared(dir) < Square(200)) {
;2002:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2003:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2004:				trap_EA_Use(bs->client);
;2005:				return;
;2006:			}
;2007:		}
;2008:	}
;2009:	else if (gametype == GT_1FCTF) {
;2010:		//never use kamikaze if the team flag carrier is visible
;2011:		if (Bot1FCTFCarryingFlag(bs))
;2012:			return;
;2013:		c = BotEnemyFlagCarrierVisible(bs);
;2014:		if (c >= 0)
;2015:			return;
;2016:		//if near enemy flag and the flag is visible
;2017:		switch(BotTeam(bs)) {
;2018:			case TEAM_RED: goal = &ctf_blueflag; break;
;2019:			default: goal = &ctf_redflag; break;
;2020:		}
;2021:		//if the obelisk is visible
;2022:		VectorCopy(goal->origin, target);
;2023:		target[2] += 1;
;2024:		VectorSubtract(bs->origin, target, dir);
;2025:		if (VectorLengthSquared(dir) < Square(200)) {
;2026:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2027:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2028:				trap_EA_Use(bs->client);
;2029:				return;
;2030:			}
;2031:		}
;2032:	}
;2033:	else if (gametype == GT_OBELISK) {
;2034:		switch(BotTeam(bs)) {
;2035:			case TEAM_RED: goal = &blueobelisk; break;
;2036:			default: goal = &redobelisk; break;
;2037:		}
;2038:		//if the obelisk is visible
;2039:		VectorCopy(goal->origin, target);
;2040:		target[2] += 1;
;2041:		VectorSubtract(bs->origin, target, dir);
;2042:		if (VectorLengthSquared(dir) < Square(300)) {
;2043:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2044:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2045:				trap_EA_Use(bs->client);
;2046:				return;
;2047:			}
;2048:		}
;2049:	}
;2050:	else if (gametype == GT_HARVESTER) {
;2051:		//
;2052:		if (BotHarvesterCarryingCubes(bs))
;2053:			return;
;2054:		c = BotEnemyCubeCarrierVisible(bs);
;2055:		if (c >= 0)
;2056:			return;
;2057:		//if near enemy base and enemy base is visible
;2058:		switch(BotTeam(bs)) {
;2059:			case TEAM_RED: goal = &blueobelisk; break;
;2060:			default: goal = &redobelisk; break;
;2061:		}
;2062:		//if the obelisk is visible
;2063:		VectorCopy(goal->origin, target);
;2064:		target[2] += 1;
;2065:		VectorSubtract(bs->origin, target, dir);
;2066:		if (VectorLengthSquared(dir) < Square(200)) {
;2067:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2068:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2069:				trap_EA_Use(bs->client);
;2070:				return;
;2071:			}
;2072:		}
;2073:	}
;2074:}
;2075:#endif
;2076:
;2077:/*
;2078:==================
;2079:BotBattleUseItems
;2080:==================
;2081:*/
;2082:void BotBattleUseItems(bot_state_t *bs) {
line 2083
;2083:	if (bs->inventory[INVENTORY_HEALTH] < 40) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 40
GEI4 $476
line 2084
;2084:		if (bs->inventory[INVENTORY_TELEPORTER] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5072
ADDP4
INDIRI4
CNSTI4 0
LEI4 $478
line 2085
;2085:			if (!BotCTFCarryingFlag(bs)
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
NEI4 $480
line 2090
;2086:#ifdef MISSIONPACK
;2087:				&& !Bot1FCTFCarryingFlag(bs)
;2088:				&& !BotHarvesterCarryingCubes(bs)
;2089:#endif
;2090:				) {
line 2091
;2091:				trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 2092
;2092:			}
LABELV $480
line 2093
;2093:		}
LABELV $478
line 2094
;2094:	}
LABELV $476
line 2095
;2095:	if (bs->inventory[INVENTORY_HEALTH] < 60) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $482
line 2096
;2096:		if (bs->inventory[INVENTORY_MEDKIT] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5076
ADDP4
INDIRI4
CNSTI4 0
LEI4 $484
line 2097
;2097:			trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 2098
;2098:		}
LABELV $484
line 2099
;2099:	}
LABELV $482
line 2104
;2100:#ifdef MISSIONPACK
;2101:	BotUseKamikaze(bs);
;2102:	BotUseInvulnerability(bs);
;2103:#endif
;2104:}
LABELV $475
endproc BotBattleUseItems 4 4
export BotSetTeleportTime
proc BotSetTeleportTime 8 0
line 2111
;2105:
;2106:/*
;2107:==================
;2108:BotSetTeleportTime
;2109:==================
;2110:*/
;2111:void BotSetTeleportTime(bot_state_t *bs) {
line 2112
;2112:	if ((bs->cur_ps.eFlags ^ bs->last_eFlags) & EF_TELEPORT_BIT) {
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
EQI4 $487
line 2113
;2113:		bs->teleport_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6180
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2114
;2114:	}
LABELV $487
line 2115
;2115:	bs->last_eFlags = bs->cur_ps.eFlags;
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
line 2116
;2116:}
LABELV $486
endproc BotSetTeleportTime 8 0
export BotIsDead
proc BotIsDead 4 0
line 2123
;2117:
;2118:/*
;2119:==================
;2120:BotIsDead
;2121:==================
;2122:*/
;2123:qboolean BotIsDead(bot_state_t *bs) {
line 2124
;2124:	return (bs->cur_ps.pm_type == PM_DEAD);
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 3
NEI4 $491
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $492
JUMPV
LABELV $491
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $492
ADDRLP4 0
INDIRI4
RETI4
LABELV $489
endproc BotIsDead 4 0
export BotIsObserver
proc BotIsObserver 1032 12
line 2132
;2125:}
;2126:
;2127:/*
;2128:==================
;2129:BotIsObserver
;2130:==================
;2131:*/
;2132:qboolean BotIsObserver(bot_state_t *bs) {
line 2134
;2133:	char buf[MAX_INFO_STRING];
;2134:	if (bs->cur_ps.pm_type == PM_SPECTATOR) return qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 2
NEI4 $494
CNSTI4 1
RETI4
ADDRGP4 $493
JUMPV
LABELV $494
line 2135
;2135:	trap_GetConfigstring(CS_PLAYERS+bs->client, buf, sizeof(buf));
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
line 2136
;2136:	if (atoi(Info_ValueForKey(buf, "t")) == TEAM_SPECTATOR) return qtrue;
ADDRLP4 0
ARGP4
ADDRGP4 $67
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
NEI4 $496
CNSTI4 1
RETI4
ADDRGP4 $493
JUMPV
LABELV $496
line 2137
;2137:	return qfalse;
CNSTI4 0
RETI4
LABELV $493
endproc BotIsObserver 1032 12
export BotIntermission
proc BotIntermission 8 0
line 2145
;2138:}
;2139:
;2140:/*
;2141:==================
;2142:BotIntermission
;2143:==================
;2144:*/
;2145:qboolean BotIntermission(bot_state_t *bs) {
line 2147
;2146:	//NOTE: we shouldn't be looking at the game code...
;2147:	if (level.intermissiontime) return qtrue;
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $499
CNSTI4 1
RETI4
ADDRGP4 $498
JUMPV
LABELV $499
line 2148
;2148:	return (bs->cur_ps.pm_type == PM_FREEZE || bs->cur_ps.pm_type == PM_INTERMISSION);
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
EQI4 $505
ADDRLP4 4
INDIRI4
CNSTI4 5
NEI4 $503
LABELV $505
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $504
JUMPV
LABELV $503
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $504
ADDRLP4 0
INDIRI4
RETI4
LABELV $498
endproc BotIntermission 8 0
export BotInLavaOrSlime
proc BotInLavaOrSlime 16 4
line 2156
;2149:}
;2150:
;2151:/*
;2152:==================
;2153:BotInLavaOrSlime
;2154:==================
;2155:*/
;2156:qboolean BotInLavaOrSlime(bot_state_t *bs) {
line 2159
;2157:	vec3_t feet;
;2158:
;2159:	VectorCopy(bs->origin, feet);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 2160
;2160:	feet[2] -= 23;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1102577664
SUBF4
ASGNF4
line 2161
;2161:	return (trap_AAS_PointContents(feet) & (CONTENTS_LAVA|CONTENTS_SLIME));
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
LABELV $506
endproc BotInLavaOrSlime 16 4
lit
align 4
LABELV $509
byte 4 3238002688
byte 4 3238002688
byte 4 3238002688
align 4
LABELV $510
byte 4 1090519040
byte 4 1090519040
byte 4 1090519040
export BotCreateWayPoint
code
proc BotCreateWayPoint 32 12
line 2169
;2162:}
;2163:
;2164:/*
;2165:==================
;2166:BotCreateWayPoint
;2167:==================
;2168:*/
;2169:bot_waypoint_t *BotCreateWayPoint(char *name, vec3_t origin, int areanum) {
line 2171
;2170:	bot_waypoint_t *wp;
;2171:	vec3_t waypointmins = {-8, -8, -8}, waypointmaxs = {8, 8, 8};
ADDRLP4 4
ADDRGP4 $509
INDIRB
ASGNB 12
ADDRLP4 16
ADDRGP4 $510
INDIRB
ASGNB 12
line 2173
;2172:
;2173:	wp = botai_freewaypoints;
ADDRLP4 0
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2174
;2174:	if ( !wp ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $511
line 2175
;2175:		BotAI_Print( PRT_WARNING, "BotCreateWayPoint: Out of waypoints\n" );
CNSTI4 2
ARGI4
ADDRGP4 $513
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 2176
;2176:		return NULL;
CNSTP4 0
RETP4
ADDRGP4 $508
JUMPV
LABELV $511
line 2178
;2177:	}
;2178:	botai_freewaypoints = botai_freewaypoints->next;
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
line 2180
;2179:
;2180:	Q_strncpyz( wp->name, name, sizeof(wp->name) );
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
line 2181
;2181:	VectorCopy(origin, wp->goal.origin);
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2182
;2182:	VectorCopy(waypointmins, wp->goal.mins);
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 2183
;2183:	VectorCopy(waypointmaxs, wp->goal.maxs);
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
ADDRLP4 16
INDIRB
ASGNB 12
line 2184
;2184:	wp->goal.areanum = areanum;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 2185
;2185:	wp->next = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
CNSTP4 0
ASGNP4
line 2186
;2186:	wp->prev = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
CNSTP4 0
ASGNP4
line 2187
;2187:	return wp;
ADDRLP4 0
INDIRP4
RETP4
LABELV $508
endproc BotCreateWayPoint 32 12
export BotFindWayPoint
proc BotFindWayPoint 8 8
line 2195
;2188:}
;2189:
;2190:/*
;2191:==================
;2192:BotFindWayPoint
;2193:==================
;2194:*/
;2195:bot_waypoint_t *BotFindWayPoint(bot_waypoint_t *waypoints, char *name) {
line 2198
;2196:	bot_waypoint_t *wp;
;2197:
;2198:	for (wp = waypoints; wp; wp = wp->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $518
JUMPV
LABELV $515
line 2199
;2199:		if (!Q_stricmp(wp->name, name)) return wp;
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
NEI4 $519
ADDRLP4 0
INDIRP4
RETP4
ADDRGP4 $514
JUMPV
LABELV $519
line 2200
;2200:	}
LABELV $516
line 2198
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
LABELV $518
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $515
line 2201
;2201:	return NULL;
CNSTP4 0
RETP4
LABELV $514
endproc BotFindWayPoint 8 8
export BotFreeWaypoints
proc BotFreeWaypoints 4 0
line 2209
;2202:}
;2203:
;2204:/*
;2205:==================
;2206:BotFreeWaypoints
;2207:==================
;2208:*/
;2209:void BotFreeWaypoints(bot_waypoint_t *wp) {
line 2212
;2210:	bot_waypoint_t *nextwp;
;2211:
;2212:	for (; wp; wp = nextwp) {
ADDRGP4 $525
JUMPV
LABELV $522
line 2213
;2213:		nextwp = wp->next;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
line 2214
;2214:		wp->next = botai_freewaypoints;
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2215
;2215:		botai_freewaypoints = wp;
ADDRGP4 botai_freewaypoints
ADDRFP4 0
INDIRP4
ASGNP4
line 2216
;2216:	}
LABELV $523
line 2212
ADDRFP4 0
ADDRLP4 0
INDIRP4
ASGNP4
LABELV $525
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $522
line 2217
;2217:}
LABELV $521
endproc BotFreeWaypoints 4 0
export BotInitWaypoints
proc BotInitWaypoints 4 0
line 2224
;2218:
;2219:/*
;2220:==================
;2221:BotInitWaypoints
;2222:==================
;2223:*/
;2224:void BotInitWaypoints(void) {
line 2227
;2225:	int i;
;2226:
;2227:	botai_freewaypoints = NULL;
ADDRGP4 botai_freewaypoints
CNSTP4 0
ASGNP4
line 2228
;2228:	for (i = 0; i < MAX_WAYPOINTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $527
line 2229
;2229:		botai_waypoints[i].next = botai_freewaypoints;
CNSTI4 100
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botai_waypoints+92
ADDP4
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2230
;2230:		botai_freewaypoints = &botai_waypoints[i];
ADDRGP4 botai_freewaypoints
CNSTI4 100
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botai_waypoints
ADDP4
ASGNP4
line 2231
;2231:	}
LABELV $528
line 2228
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 128
LTI4 $527
line 2232
;2232:}
LABELV $526
endproc BotInitWaypoints 4 0
export TeamPlayIsOn
proc TeamPlayIsOn 4 0
line 2239
;2233:
;2234:/*
;2235:==================
;2236:TeamPlayIsOn
;2237:==================
;2238:*/
;2239:int TeamPlayIsOn(void) {
line 2240
;2240:	return ( gametype >= GT_TEAM );
ADDRGP4 gametype
INDIRI4
CNSTI4 3
LTI4 $534
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $535
JUMPV
LABELV $534
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $535
ADDRLP4 0
INDIRI4
RETI4
LABELV $532
endproc TeamPlayIsOn 4 0
export BotAggression
proc BotAggression 28 0
line 2248
;2241:}
;2242:
;2243:/*
;2244:==================
;2245:BotAggression
;2246:==================
;2247:*/
;2248:float BotAggression(bot_state_t *bs) {
line 2250
;2249:	//if the bot has quad
;2250:	if (bs->inventory[INVENTORY_QUAD]) {
ADDRFP4 0
INDIRP4
CNSTI4 5092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $537
line 2252
;2251:		//if the bot is not holding the gauntlet or the enemy is really nearby
;2252:		if (bs->weaponnum != WP_GAUNTLET ||
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
NEI4 $541
ADDRLP4 0
INDIRP4
CNSTI4 5752
ADDP4
INDIRI4
CNSTI4 80
GEI4 $539
LABELV $541
line 2253
;2253:			bs->inventory[ENEMY_HORIZONTAL_DIST] < 80) {
line 2254
;2254:			return 70;
CNSTF4 1116471296
RETF4
ADDRGP4 $536
JUMPV
LABELV $539
line 2256
;2255:		}
;2256:	}
LABELV $537
line 2258
;2257:	//if the enemy is located way higher than the bot
;2258:	if (bs->inventory[ENEMY_HEIGHT] > 200) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 5756
ADDP4
INDIRI4
CNSTI4 200
LEI4 $542
CNSTF4 0
RETF4
ADDRGP4 $536
JUMPV
LABELV $542
line 2260
;2259:	//if the bot is very low on health
;2260:	if (bs->inventory[INVENTORY_HEALTH] < 60) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $544
CNSTF4 0
RETF4
ADDRGP4 $536
JUMPV
LABELV $544
line 2262
;2261:	//if the bot is low on health
;2262:	if (bs->inventory[INVENTORY_HEALTH] < 80) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 80
GEI4 $546
line 2264
;2263:		//if the bot has insufficient armor
;2264:		if (bs->inventory[INVENTORY_ARMOR] < 40) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $548
CNSTF4 0
RETF4
ADDRGP4 $536
JUMPV
LABELV $548
line 2265
;2265:	}
LABELV $546
line 2267
;2266:	//if the bot can use the bfg
;2267:	if (bs->inventory[INVENTORY_BFG10K] > 0 &&
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
LEI4 $550
ADDRLP4 0
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 7
LEI4 $550
line 2268
;2268:			bs->inventory[INVENTORY_BFGAMMO] > 7) return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $536
JUMPV
LABELV $550
line 2270
;2269:	//if the bot can use the railgun
;2270:	if (bs->inventory[INVENTORY_RAILGUN] > 0 &&
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
LEI4 $552
ADDRLP4 4
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 5
LEI4 $552
line 2271
;2271:			bs->inventory[INVENTORY_SLUGS] > 5) return 95;
CNSTF4 1119748096
RETF4
ADDRGP4 $536
JUMPV
LABELV $552
line 2273
;2272:	//if the bot can use the lightning gun
;2273:	if (bs->inventory[INVENTORY_LIGHTNING] > 0 &&
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
LEI4 $554
ADDRLP4 8
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
CNSTI4 50
LEI4 $554
line 2274
;2274:			bs->inventory[INVENTORY_LIGHTNINGAMMO] > 50) return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $536
JUMPV
LABELV $554
line 2276
;2275:	//if the bot can use the rocketlauncher
;2276:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 &&
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
LEI4 $556
ADDRLP4 12
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 5
LEI4 $556
line 2277
;2277:			bs->inventory[INVENTORY_ROCKETS] > 5) return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $536
JUMPV
LABELV $556
line 2279
;2278:	//if the bot can use the plasmagun
;2279:	if (bs->inventory[INVENTORY_PLASMAGUN] > 0 &&
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
LEI4 $558
ADDRLP4 16
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
CNSTI4 40
LEI4 $558
line 2280
;2280:			bs->inventory[INVENTORY_CELLS] > 40) return 85;
CNSTF4 1118437376
RETF4
ADDRGP4 $536
JUMPV
LABELV $558
line 2282
;2281:	//if the bot can use the grenade launcher
;2282:	if (bs->inventory[INVENTORY_GRENADELAUNCHER] > 0 &&
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
LEI4 $560
ADDRLP4 20
INDIRP4
CNSTI4 5032
ADDP4
INDIRI4
CNSTI4 10
LEI4 $560
line 2283
;2283:			bs->inventory[INVENTORY_GRENADES] > 10) return 80;
CNSTF4 1117782016
RETF4
ADDRGP4 $536
JUMPV
LABELV $560
line 2285
;2284:	//if the bot can use the shotgun
;2285:	if (bs->inventory[INVENTORY_SHOTGUN] > 0 &&
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
LEI4 $562
ADDRLP4 24
INDIRP4
CNSTI4 5024
ADDP4
INDIRI4
CNSTI4 10
LEI4 $562
line 2286
;2286:			bs->inventory[INVENTORY_SHELLS] > 10) return 50;
CNSTF4 1112014848
RETF4
ADDRGP4 $536
JUMPV
LABELV $562
line 2288
;2287:	//otherwise the bot is not feeling too good
;2288:	return 0;
CNSTF4 0
RETF4
LABELV $536
endproc BotAggression 28 0
export BotFeelingBad
proc BotFeelingBad 0 0
line 2296
;2289:}
;2290:
;2291:/*
;2292:==================
;2293:BotFeelingBad
;2294:==================
;2295:*/
;2296:float BotFeelingBad(bot_state_t *bs) {
line 2297
;2297:	if (bs->weaponnum == WP_GAUNTLET) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $565
line 2298
;2298:		return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $564
JUMPV
LABELV $565
line 2300
;2299:	}
;2300:	if (bs->inventory[INVENTORY_HEALTH] < 40) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 40
GEI4 $567
line 2301
;2301:		return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $564
JUMPV
LABELV $567
line 2303
;2302:	}
;2303:	if (bs->weaponnum == WP_MACHINEGUN) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $569
line 2304
;2304:		return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $564
JUMPV
LABELV $569
line 2306
;2305:	}
;2306:	if (bs->inventory[INVENTORY_HEALTH] < 60) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $571
line 2307
;2307:		return 80;
CNSTF4 1117782016
RETF4
ADDRGP4 $564
JUMPV
LABELV $571
line 2309
;2308:	}
;2309:	return 0;
CNSTF4 0
RETF4
LABELV $564
endproc BotFeelingBad 0 0
export BotWantsToRetreat
proc BotWantsToRetreat 144 8
line 2317
;2310:}
;2311:
;2312:/*
;2313:==================
;2314:BotWantsToRetreat
;2315:==================
;2316:*/
;2317:int BotWantsToRetreat(bot_state_t *bs) {
line 2320
;2318:	aas_entityinfo_t entinfo;
;2319:
;2320:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $574
line 2322
;2321:		//always retreat when carrying a CTF flag
;2322:		if (BotCTFCarryingFlag(bs))
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
EQI4 $576
line 2323
;2323:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $573
JUMPV
LABELV $576
line 2324
;2324:	}
LABELV $574
line 2350
;2325:#ifdef MISSIONPACK
;2326:	else if (gametype == GT_1FCTF) {
;2327:		//if carrying the flag then always retreat
;2328:		if (Bot1FCTFCarryingFlag(bs))
;2329:			return qtrue;
;2330:	}
;2331:	else if (gametype == GT_OBELISK) {
;2332:		//the bots should be dedicated to attacking the enemy obelisk
;2333:		if (bs->ltgtype == LTG_ATTACKENEMYBASE) {
;2334:			if (bs->enemy != redobelisk.entitynum ||
;2335:						bs->enemy != blueobelisk.entitynum) {
;2336:				return qtrue;
;2337:			}
;2338:		}
;2339:		if (BotFeelingBad(bs) > 50) {
;2340:			return qtrue;
;2341:		}
;2342:		return qfalse;
;2343:	}
;2344:	else if (gametype == GT_HARVESTER) {
;2345:		//if carrying cubes then always retreat
;2346:		if (BotHarvesterCarryingCubes(bs)) return qtrue;
;2347:	}
;2348:#endif
;2349:	//
;2350:	if (bs->enemy >= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
LTI4 $578
line 2352
;2351:		//if the enemy is carrying a flag
;2352:		BotEntityInfo(bs->enemy, &entinfo);
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
line 2353
;2353:		if (EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 140
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $580
line 2354
;2354:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $573
JUMPV
LABELV $580
line 2355
;2355:	}
LABELV $578
line 2357
;2356:	//if the bot is getting the flag
;2357:	if (bs->ltgtype == LTG_GETFLAG)
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $582
line 2358
;2358:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $573
JUMPV
LABELV $582
line 2360
;2359:	//
;2360:	if (BotAggression(bs) < 50)
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
GEF4 $584
line 2361
;2361:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $573
JUMPV
LABELV $584
line 2362
;2362:	return qfalse;
CNSTI4 0
RETI4
LABELV $573
endproc BotWantsToRetreat 144 8
export BotWantsToChase
proc BotWantsToChase 148 8
line 2370
;2363:}
;2364:
;2365:/*
;2366:==================
;2367:BotWantsToChase
;2368:==================
;2369:*/
;2370:int BotWantsToChase(bot_state_t *bs) {
line 2373
;2371:	aas_entityinfo_t entinfo;
;2372:
;2373:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $587
line 2375
;2374:		//never chase when carrying a CTF flag
;2375:		if (BotCTFCarryingFlag(bs))
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
EQI4 $589
line 2376
;2376:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $586
JUMPV
LABELV $589
line 2378
;2377:		//always chase if the enemy is carrying a flag
;2378:		BotEntityInfo(bs->enemy, &entinfo);
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
line 2379
;2379:		if (EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 144
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
EQI4 $591
line 2380
;2380:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $586
JUMPV
LABELV $591
line 2381
;2381:	}
LABELV $587
line 2408
;2382:#ifdef MISSIONPACK
;2383:	else if (gametype == GT_1FCTF) {
;2384:		//never chase if carrying the flag
;2385:		if (Bot1FCTFCarryingFlag(bs))
;2386:			return qfalse;
;2387:		//always chase if the enemy is carrying a flag
;2388:		BotEntityInfo(bs->enemy, &entinfo);
;2389:		if (EntityCarriesFlag(&entinfo))
;2390:			return qtrue;
;2391:	}
;2392:	else if (gametype == GT_OBELISK) {
;2393:		//the bots should be dedicated to attacking the enemy obelisk
;2394:		if (bs->ltgtype == LTG_ATTACKENEMYBASE) {
;2395:			if (bs->enemy != redobelisk.entitynum ||
;2396:						bs->enemy != blueobelisk.entitynum) {
;2397:				return qfalse;
;2398:			}
;2399:		}
;2400:	}
;2401:	else if (gametype == GT_HARVESTER) {
;2402:		//never chase if carrying cubes
;2403:		if (BotHarvesterCarryingCubes(bs))
;2404:			return qfalse;
;2405:	}
;2406:#endif
;2407:	//if the bot is getting the flag
;2408:	if (bs->ltgtype == LTG_GETFLAG)
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $593
line 2409
;2409:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $586
JUMPV
LABELV $593
line 2411
;2410:	//
;2411:	if (BotAggression(bs) > 50)
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
LEF4 $595
line 2412
;2412:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $586
JUMPV
LABELV $595
line 2413
;2413:	return qfalse;
CNSTI4 0
RETI4
LABELV $586
endproc BotWantsToChase 148 8
export BotWantsToHelp
proc BotWantsToHelp 0 0
line 2421
;2414:}
;2415:
;2416:/*
;2417:==================
;2418:BotWantsToHelp
;2419:==================
;2420:*/
;2421:int BotWantsToHelp(bot_state_t *bs) {
line 2422
;2422:	return qtrue;
CNSTI4 1
RETI4
LABELV $597
endproc BotWantsToHelp 0 0
export BotCanAndWantsToRocketJump
proc BotCanAndWantsToRocketJump 8 16
line 2430
;2423:}
;2424:
;2425:/*
;2426:==================
;2427:BotCanAndWantsToRocketJump
;2428:==================
;2429:*/
;2430:int BotCanAndWantsToRocketJump(bot_state_t *bs) {
line 2434
;2431:	float rocketjumper;
;2432:
;2433:	//if rocket jumping is disabled
;2434:	if (!bot_rocketjump.integer) return qfalse;
ADDRGP4 bot_rocketjump+12
INDIRI4
CNSTI4 0
NEI4 $599
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $599
line 2436
;2435:	//if no rocket launcher
;2436:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] <= 0) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
CNSTI4 0
GTI4 $602
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $602
line 2438
;2437:	//if low on rockets
;2438:	if (bs->inventory[INVENTORY_ROCKETS] < 3) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 3
GEI4 $604
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $604
line 2440
;2439:	//never rocket jump with the Quad
;2440:	if (bs->inventory[INVENTORY_QUAD]) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $606
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $606
line 2442
;2441:	//if low on health
;2442:	if (bs->inventory[INVENTORY_HEALTH] < 60) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $608
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $608
line 2444
;2443:	//if not full health
;2444:	if (bs->inventory[INVENTORY_HEALTH] < 90) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 90
GEI4 $610
line 2446
;2445:		//if the bot has insufficient armor
;2446:		if (bs->inventory[INVENTORY_ARMOR] < 40) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $612
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $612
line 2447
;2447:	}
LABELV $610
line 2448
;2448:	rocketjumper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_WEAPONJUMPING, 0, 1);
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
line 2449
;2449:	if (rocketjumper < 0.5) return qfalse;
ADDRLP4 0
INDIRF4
CNSTF4 1056964608
GEF4 $614
CNSTI4 0
RETI4
ADDRGP4 $598
JUMPV
LABELV $614
line 2450
;2450:	return qtrue;
CNSTI4 1
RETI4
LABELV $598
endproc BotCanAndWantsToRocketJump 8 16
export BotHasPersistantPowerupAndWeapon
proc BotHasPersistantPowerupAndWeapon 32 0
line 2458
;2451:}
;2452:
;2453:/*
;2454:==================
;2455:BotHasPersistantPowerupAndWeapon
;2456:==================
;2457:*/
;2458:int BotHasPersistantPowerupAndWeapon(bot_state_t *bs) {
line 2469
;2459:#ifdef MISSIONPACK
;2460:	// if the bot does not have a persistant powerup
;2461:	if (!bs->inventory[INVENTORY_SCOUT] &&
;2462:		!bs->inventory[INVENTORY_GUARD] &&
;2463:		!bs->inventory[INVENTORY_DOUBLER] &&
;2464:		!bs->inventory[INVENTORY_AMMOREGEN] ) {
;2465:		return qfalse;
;2466:	}
;2467:#endif
;2468:	//if the bot is very low on health
;2469:	if (bs->inventory[INVENTORY_HEALTH] < 60) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $617
CNSTI4 0
RETI4
ADDRGP4 $616
JUMPV
LABELV $617
line 2471
;2470:	//if the bot is low on health
;2471:	if (bs->inventory[INVENTORY_HEALTH] < 80) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 80
GEI4 $619
line 2473
;2472:		//if the bot has insufficient armor
;2473:		if (bs->inventory[INVENTORY_ARMOR] < 40) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $621
CNSTI4 0
RETI4
ADDRGP4 $616
JUMPV
LABELV $621
line 2474
;2474:	}
LABELV $619
line 2476
;2475:	//if the bot can use the bfg
;2476:	if (bs->inventory[INVENTORY_BFG10K] > 0 &&
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
LEI4 $623
ADDRLP4 0
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 7
LEI4 $623
line 2477
;2477:			bs->inventory[INVENTORY_BFGAMMO] > 7) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $623
line 2479
;2478:	//if the bot can use the railgun
;2479:	if (bs->inventory[INVENTORY_RAILGUN] > 0 &&
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
LEI4 $625
ADDRLP4 4
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 5
LEI4 $625
line 2480
;2480:			bs->inventory[INVENTORY_SLUGS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $625
line 2482
;2481:	//if the bot can use the lightning gun
;2482:	if (bs->inventory[INVENTORY_LIGHTNING] > 0 &&
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
LEI4 $627
ADDRLP4 8
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
CNSTI4 50
LEI4 $627
line 2483
;2483:			bs->inventory[INVENTORY_LIGHTNINGAMMO] > 50) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $627
line 2485
;2484:	//if the bot can use the rocketlauncher
;2485:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 &&
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
LEI4 $629
ADDRLP4 12
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 5
LEI4 $629
line 2486
;2486:			bs->inventory[INVENTORY_ROCKETS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $629
line 2488
;2487:	//
;2488:	if (bs->inventory[INVENTORY_NAILGUN] > 0 &&
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
LEI4 $631
ADDRLP4 16
INDIRP4
CNSTI4 5056
ADDP4
INDIRI4
CNSTI4 5
LEI4 $631
line 2489
;2489:			bs->inventory[INVENTORY_NAILS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $631
line 2491
;2490:	//
;2491:	if (bs->inventory[INVENTORY_PROXLAUNCHER] > 0 &&
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
LEI4 $633
ADDRLP4 20
INDIRP4
CNSTI4 5060
ADDP4
INDIRI4
CNSTI4 5
LEI4 $633
line 2492
;2492:			bs->inventory[INVENTORY_MINES] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $633
line 2494
;2493:	//
;2494:	if (bs->inventory[INVENTORY_CHAINGUN] > 0 &&
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
LEI4 $635
ADDRLP4 24
INDIRP4
CNSTI4 5064
ADDP4
INDIRI4
CNSTI4 40
LEI4 $635
line 2495
;2495:			bs->inventory[INVENTORY_BELT] > 40) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $635
line 2497
;2496:	//if the bot can use the plasmagun
;2497:	if (bs->inventory[INVENTORY_PLASMAGUN] > 0 &&
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
LEI4 $637
ADDRLP4 28
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
CNSTI4 20
LEI4 $637
line 2498
;2498:			bs->inventory[INVENTORY_CELLS] > 20) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $616
JUMPV
LABELV $637
line 2499
;2499:	return qfalse;
CNSTI4 0
RETI4
LABELV $616
endproc BotHasPersistantPowerupAndWeapon 32 0
export BotGoCamp
proc BotGoCamp 16 16
line 2507
;2500:}
;2501:
;2502:/*
;2503:==================
;2504:BotGoCamp
;2505:==================
;2506:*/
;2507:void BotGoCamp(bot_state_t *bs, bot_goal_t *goal) {
line 2510
;2508:	float camper;
;2509:
;2510:	bs->decisionmaker = bs->client;
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
line 2512
;2511:	//set message time to zero so bot will NOT show any message
;2512:	bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 2514
;2513:	//set the ltg type
;2514:	bs->ltgtype = LTG_CAMP;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 7
ASGNI4
line 2516
;2515:	//set the team goal
;2516:	memcpy(&bs->teamgoal, goal, sizeof(bot_goal_t));
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
line 2518
;2517:	//get the team goal time
;2518:	camper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CAMPER, 0, 1);
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
line 2519
;2519:	if (camper > 0.99) bs->teamgoal_time = FloatTime() + 99999;
ADDRLP4 0
INDIRF4
CNSTF4 1065185444
LEF4 $640
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1203982208
ADDF4
ASGNF4
ADDRGP4 $641
JUMPV
LABELV $640
line 2520
;2520:	else bs->teamgoal_time = FloatTime() + 120 + 180 * camper + random() * 15;
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
LABELV $641
line 2522
;2521:	//set the last time the bot started camping
;2522:	bs->camp_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2524
;2523:	//the teammate that requested the camping
;2524:	bs->teammate = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
CNSTI4 0
ASGNI4
line 2526
;2525:	//do NOT type arrive message
;2526:	bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 2527
;2527:}
LABELV $639
endproc BotGoCamp 16 16
export BotWantsToCamp
proc BotWantsToCamp 176 16
line 2534
;2528:
;2529:/*
;2530:==================
;2531:BotWantsToCamp
;2532:==================
;2533:*/
;2534:int BotWantsToCamp(bot_state_t *bs) {
line 2539
;2535:	float camper;
;2536:	int cs, traveltime, besttraveltime;
;2537:	bot_goal_t goal, bestgoal;
;2538:
;2539:	camper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CAMPER, 0, 1);
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
line 2540
;2540:	if (camper < 0.1) return qfalse;
ADDRLP4 124
INDIRF4
CNSTF4 1036831949
GEF4 $643
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $643
line 2542
;2541:	//if the bot has a team goal
;2542:	if (bs->ltgtype == LTG_TEAMHELP ||
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
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 2
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 3
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 4
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 5
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 7
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 8
EQI4 $653
ADDRLP4 132
INDIRI4
CNSTI4 9
NEI4 $645
LABELV $653
line 2549
;2543:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;2544:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;2545:			bs->ltgtype == LTG_GETFLAG ||
;2546:			bs->ltgtype == LTG_RUSHBASE ||
;2547:			bs->ltgtype == LTG_CAMP ||
;2548:			bs->ltgtype == LTG_CAMPORDER ||
;2549:			bs->ltgtype == LTG_PATROL) {
line 2550
;2550:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $645
line 2553
;2551:	}
;2552:	//if camped recently
;2553:	if (bs->camp_time > FloatTime() - 60 + 300 * (1-camper)) return qfalse;
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
LEF4 $654
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $654
line 2555
;2554:	//
;2555:	if (random() > camper) {
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
LEF4 $656
line 2556
;2556:		bs->camp_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2557
;2557:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $656
line 2560
;2558:	}
;2559:	//if the bot isn't healthy anough
;2560:	if (BotAggression(bs) < 50) return qfalse;
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
GEF4 $658
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $658
line 2562
;2561:	//the bot should have at least have the rocket launcher, the railgun or the bfg10k with some ammo
;2562:	if ((bs->inventory[INVENTORY_ROCKETLAUNCHER] <= 0 || bs->inventory[INVENTORY_ROCKETS < 10]) &&
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
LEI4 $662
ADDRLP4 144
INDIRP4
CNSTI4 4952
ADDP4
INDIRI4
ADDRLP4 148
INDIRI4
EQI4 $660
LABELV $662
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
LEI4 $663
ADDRLP4 152
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 10
GEI4 $660
LABELV $663
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
LEI4 $664
ADDRLP4 156
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 10
GEI4 $660
LABELV $664
line 2564
;2563:		(bs->inventory[INVENTORY_RAILGUN] <= 0 || bs->inventory[INVENTORY_SLUGS] < 10) &&
;2564:		(bs->inventory[INVENTORY_BFG10K] <= 0 || bs->inventory[INVENTORY_BFGAMMO] < 10)) {
line 2565
;2565:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $660
line 2568
;2566:	}
;2567:	//find the closest camp spot
;2568:	besttraveltime = 99999;
ADDRLP4 64
CNSTI4 99999
ASGNI4
line 2569
;2569:	for (cs = trap_BotGetNextCampSpotGoal(0, &goal); cs; cs = trap_BotGetNextCampSpotGoal(cs, &goal)) {
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
ADDRGP4 $668
JUMPV
LABELV $665
line 2570
;2570:		traveltime = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, goal.areanum, TFL_DEFAULT);
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
line 2571
;2571:		if (traveltime && traveltime < besttraveltime) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $670
ADDRLP4 0
INDIRI4
ADDRLP4 64
INDIRI4
GEI4 $670
line 2572
;2572:			besttraveltime = traveltime;
ADDRLP4 64
ADDRLP4 0
INDIRI4
ASGNI4
line 2573
;2573:			memcpy(&bestgoal, &goal, sizeof(bot_goal_t));
ADDRLP4 68
ARGP4
ADDRLP4 8
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 2574
;2574:		}
LABELV $670
line 2575
;2575:	}
LABELV $666
line 2569
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
LABELV $668
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $665
line 2576
;2576:	if (besttraveltime > 150) return qfalse;
ADDRLP4 64
INDIRI4
CNSTI4 150
LEI4 $672
CNSTI4 0
RETI4
ADDRGP4 $642
JUMPV
LABELV $672
line 2578
;2577:	//ok found a camp spot, go camp there
;2578:	BotGoCamp(bs, &bestgoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
ADDRGP4 BotGoCamp
CALLV
pop
line 2579
;2579:	bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 2581
;2580:	//
;2581:	return qtrue;
CNSTI4 1
RETI4
LABELV $642
endproc BotWantsToCamp 176 16
export BotDontAvoid
proc BotDontAvoid 68 12
line 2589
;2582:}
;2583:
;2584:/*
;2585:==================
;2586:BotDontAvoid
;2587:==================
;2588:*/
;2589:void BotDontAvoid(bot_state_t *bs, char *itemname) {
line 2593
;2590:	bot_goal_t goal;
;2591:	int num;
;2592:
;2593:	num = trap_BotGetLevelItemGoal(-1, itemname, &goal);
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
ADDRGP4 $676
JUMPV
LABELV $675
line 2594
;2594:	while(num >= 0) {
line 2595
;2595:		trap_BotRemoveFromAvoidGoals(bs->gs, goal.number);
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
line 2596
;2596:		num = trap_BotGetLevelItemGoal(num, itemname, &goal);
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
line 2597
;2597:	}
LABELV $676
line 2594
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $675
line 2598
;2598:}
LABELV $674
endproc BotDontAvoid 68 12
export BotGoForPowerups
proc BotGoForPowerups 0 8
line 2605
;2599:
;2600:/*
;2601:==================
;2602:BotGoForPowerups
;2603:==================
;2604:*/
;2605:void BotGoForPowerups(bot_state_t *bs) {
line 2608
;2606:
;2607:	//don't avoid any of the powerups anymore
;2608:	BotDontAvoid(bs, "Quad Damage");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $680
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2609
;2609:	BotDontAvoid(bs, "Regeneration");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $681
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2610
;2610:	BotDontAvoid(bs, "Battle Suit");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $682
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2611
;2611:	BotDontAvoid(bs, "Speed");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $683
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2612
;2612:	BotDontAvoid(bs, "Invisibility");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $684
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2616
;2613:	//BotDontAvoid(bs, "Flight");
;2614:	//reset the long term goal time so the bot will go for the powerup
;2615:	//NOTE: the long term goal type doesn't change
;2616:	bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2617
;2617:}
LABELV $679
endproc BotGoForPowerups 0 8
export BotRoamGoal
proc BotRoamGoal 180 28
line 2624
;2618:
;2619:/*
;2620:==================
;2621:BotRoamGoal
;2622:==================
;2623:*/
;2624:void BotRoamGoal(bot_state_t *bs, vec3_t goal) {
line 2630
;2625:	int pc, i;
;2626:	float len, rnd;
;2627:	vec3_t dir, bestorg, belowbestorg;
;2628:	bsp_trace_t trace;
;2629:
;2630:	for (i = 0; i < 10; i++) {
ADDRLP4 116
CNSTI4 0
ASGNI4
LABELV $686
line 2632
;2631:		//start at the bot origin
;2632:		VectorCopy(bs->origin, bestorg);
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 2633
;2633:		rnd = random();
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
line 2634
;2634:		if (rnd > 0.25) {
ADDRLP4 112
INDIRF4
CNSTF4 1048576000
LEF4 $690
line 2636
;2635:			//add a random value to the x-coordinate
;2636:			if (random() < 0.5) bestorg[0] -= 800 * random() + 100;
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
GEF4 $692
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
ADDRGP4 $693
JUMPV
LABELV $692
line 2637
;2637:			else bestorg[0] += 800 * random() + 100;
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
LABELV $693
line 2638
;2638:		}
LABELV $690
line 2639
;2639:		if (rnd < 0.75) {
ADDRLP4 112
INDIRF4
CNSTF4 1061158912
GEF4 $694
line 2641
;2640:			//add a random value to the y-coordinate
;2641:			if (random() < 0.5) bestorg[1] -= 800 * random() + 100;
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
GEF4 $696
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
ADDRGP4 $697
JUMPV
LABELV $696
line 2642
;2642:			else bestorg[1] += 800 * random() + 100;
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
LABELV $697
line 2643
;2643:		}
LABELV $694
line 2645
;2644:		//add a random value to the z-coordinate (NOTE: 48 = maxjump?)
;2645:		bestorg[2] += 2 * 48 * crandom();
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
line 2647
;2646:		//trace a line from the origin to the roam target
;2647:		BotAI_Trace(&trace, bs->origin, NULL, NULL, bestorg, bs->entitynum, MASK_SOLID);
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
line 2649
;2648:		//direction and length towards the roam target
;2649:		VectorSubtract(trace.endpos, bs->origin, dir);
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
line 2650
;2650:		len = VectorNormalize(dir);
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
line 2652
;2651:		//if the roam target is far away anough
;2652:		if (len > 200) {
ADDRLP4 108
INDIRF4
CNSTF4 1128792064
LEF4 $708
line 2654
;2653:			//the roam target is in the given direction before walls
;2654:			VectorScale(dir, len * trace.fraction - 40, dir);
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
line 2655
;2655:			VectorAdd(bs->origin, dir, bestorg);
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
line 2657
;2656:			//get the coordinates of the floor below the roam target
;2657:			belowbestorg[0] = bestorg[0];
ADDRLP4 120
ADDRLP4 12
INDIRF4
ASGNF4
line 2658
;2658:			belowbestorg[1] = bestorg[1];
ADDRLP4 120+4
ADDRLP4 12+4
INDIRF4
ASGNF4
line 2659
;2659:			belowbestorg[2] = bestorg[2] - 800;
ADDRLP4 120+8
ADDRLP4 12+8
INDIRF4
CNSTF4 1145569280
SUBF4
ASGNF4
line 2660
;2660:			BotAI_Trace(&trace, bestorg, NULL, NULL, belowbestorg, bs->entitynum, MASK_SOLID);
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
line 2662
;2661:			//
;2662:			if (!trace.startsolid) {
ADDRLP4 24+4
INDIRI4
CNSTI4 0
NEI4 $725
line 2663
;2663:				trace.endpos[2]++;
ADDRLP4 24+12+8
ADDRLP4 24+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2664
;2664:				pc = trap_PointContents(trace.endpos, bs->entitynum);
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
line 2665
;2665:				if (!(pc & (CONTENTS_LAVA | CONTENTS_SLIME))) {
ADDRLP4 132
INDIRI4
CNSTI4 24
BANDI4
CNSTI4 0
NEI4 $731
line 2666
;2666:					VectorCopy(bestorg, goal);
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRB
ASGNB 12
line 2667
;2667:					return;
ADDRGP4 $685
JUMPV
LABELV $731
line 2669
;2668:				}
;2669:			}
LABELV $725
line 2670
;2670:		}
LABELV $708
line 2671
;2671:	}
LABELV $687
line 2630
ADDRLP4 116
ADDRLP4 116
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 116
INDIRI4
CNSTI4 10
LTI4 $686
line 2672
;2672:	VectorCopy(bestorg, goal);
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRB
ASGNB 12
line 2673
;2673:}
LABELV $685
endproc BotRoamGoal 180 28
lit
align 4
LABELV $735
byte 4 0
byte 4 0
byte 4 1065353216
export BotAttackMove
code
proc BotAttackMove 392 16
line 2680
;2674:
;2675:/*
;2676:==================
;2677:BotAttackMove
;2678:==================
;2679:*/
;2680:bot_moveresult_t BotAttackMove(bot_state_t *bs, int tfl) {
line 2684
;2681:	int movetype, i, attackentity;
;2682:	float attack_skill, jumper, croucher, dist, strafechange_time;
;2683:	float attack_dist, attack_range;
;2684:	vec3_t forward, backward, sideward, hordir, up = {0, 0, 1};
ADDRLP4 56
ADDRGP4 $735
INDIRB
ASGNB 12
line 2689
;2685:	aas_entityinfo_t entinfo;
;2686:	bot_moveresult_t moveresult;
;2687:	bot_goal_t goal;
;2688:
;2689:	attackentity = bs->enemy;
ADDRLP4 332
ADDRFP4 4
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 2691
;2690:	//
;2691:	if (bs->attackchase_time > FloatTime()) {
ADDRFP4 4
INDIRP4
CNSTI4 6124
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $736
line 2693
;2692:		//create the chase goal
;2693:		goal.entitynum = attackentity;
ADDRLP4 136+40
ADDRLP4 332
INDIRI4
ASGNI4
line 2694
;2694:		goal.areanum = bs->lastenemyareanum;
ADDRLP4 136+12
ADDRFP4 4
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
ASGNI4
line 2695
;2695:		VectorCopy(bs->lastenemyorigin, goal.origin);
ADDRLP4 136
ADDRFP4 4
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 2696
;2696:		VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 136+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 136+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 136+16+8
CNSTF4 3238002688
ASGNF4
line 2697
;2697:		VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 136+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 136+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 136+28+8
CNSTF4 1090519040
ASGNF4
line 2699
;2698:		//initialize the movement state
;2699:		BotSetupForMovement(bs);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2701
;2700:		//move towards the goal
;2701:		trap_BotMoveToGoal(&moveresult, bs->ms, &goal, tfl);
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
line 2702
;2702:		return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $733
JUMPV
LABELV $736
line 2705
;2703:	}
;2704:	//
;2705:	memset(&moveresult, 0, sizeof(bot_moveresult_t));
ADDRLP4 80
ARGP4
CNSTI4 0
ARGI4
CNSTI4 52
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2707
;2706:	//
;2707:	attack_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ATTACK_SKILL, 0, 1);
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
line 2708
;2708:	jumper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_JUMPER, 0, 1);
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
line 2709
;2709:	croucher = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CROUCHER, 0, 1);
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
line 2711
;2710:	//if the bot is really stupid
;2711:	if (attack_skill < 0.2) return moveresult;
ADDRLP4 132
INDIRF4
CNSTF4 1045220557
GEF4 $750
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $733
JUMPV
LABELV $750
line 2713
;2712:	//initialize the movement state
;2713:	BotSetupForMovement(bs);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2715
;2714:	//get the enemy entity info
;2715:	BotEntityInfo(attackentity, &entinfo);
ADDRLP4 332
INDIRI4
ARGI4
ADDRLP4 192
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2717
;2716:	//direction towards the enemy
;2717:	VectorSubtract(entinfo.origin, bs->origin, forward);
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
line 2719
;2718:	//the distance towards the enemy
;2719:	dist = VectorNormalize(forward);
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
line 2720
;2720:	VectorNegate(forward, backward);
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
line 2722
;2721:	//walk, crouch or jump
;2722:	movetype = MOVE_WALK;
ADDRLP4 52
CNSTI4 1
ASGNI4
line 2724
;2723:	//
;2724:	if (bs->attackcrouch_time < FloatTime() - 1) {
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $763
line 2725
;2725:		if (random() < jumper) {
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
GEF4 $765
line 2726
;2726:			movetype = MOVE_JUMP;
ADDRLP4 52
CNSTI4 4
ASGNI4
line 2727
;2727:		}
ADDRGP4 $766
JUMPV
LABELV $765
line 2729
;2728:		//wait at least one second before crouching again
;2729:		else if (bs->attackcrouch_time < FloatTime() - 1 && random() < croucher) {
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $767
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
GEF4 $767
line 2730
;2730:			bs->attackcrouch_time = FloatTime() + croucher * 5;
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
line 2731
;2731:		}
LABELV $767
LABELV $766
line 2732
;2732:	}
LABELV $763
line 2733
;2733:	if (bs->attackcrouch_time > FloatTime()) movetype = MOVE_CROUCH;
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $769
ADDRLP4 52
CNSTI4 2
ASGNI4
LABELV $769
line 2735
;2734:	//if the bot should jump
;2735:	if (movetype == MOVE_JUMP) {
ADDRLP4 52
INDIRI4
CNSTI4 4
NEI4 $771
line 2737
;2736:		//if jumped last frame
;2737:		if (bs->attackjump_time > FloatTime()) {
ADDRFP4 4
INDIRP4
CNSTI4 6128
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $773
line 2738
;2738:			movetype = MOVE_WALK;
ADDRLP4 52
CNSTI4 1
ASGNI4
line 2739
;2739:		}
ADDRGP4 $774
JUMPV
LABELV $773
line 2740
;2740:		else {
line 2741
;2741:			bs->attackjump_time = FloatTime() + 1;
ADDRFP4 4
INDIRP4
CNSTI4 6128
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2742
;2742:		}
LABELV $774
line 2743
;2743:	}
LABELV $771
line 2744
;2744:	if (bs->cur_ps.weapon == WP_GAUNTLET) {
ADDRFP4 4
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $775
line 2745
;2745:		attack_dist = 0;
ADDRLP4 72
CNSTF4 0
ASGNF4
line 2746
;2746:		attack_range = 0;
ADDRLP4 76
CNSTF4 0
ASGNF4
line 2747
;2747:	}
ADDRGP4 $776
JUMPV
LABELV $775
line 2748
;2748:	else {
line 2749
;2749:		attack_dist = IDEAL_ATTACKDIST;
ADDRLP4 72
CNSTF4 1124859904
ASGNF4
line 2750
;2750:		attack_range = 40;
ADDRLP4 76
CNSTF4 1109393408
ASGNF4
line 2751
;2751:	}
LABELV $776
line 2753
;2752:	//if the bot is stupid
;2753:	if (attack_skill <= 0.4) {
ADDRLP4 132
INDIRF4
CNSTF4 1053609165
GTF4 $777
line 2755
;2754:		//just walk to or away from the enemy
;2755:		if (dist > attack_dist + attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
ADDF4
LEF4 $779
line 2756
;2756:			if (trap_BotMoveInDirection(bs->ms, forward, 400, movetype)) return moveresult;
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
EQI4 $781
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $733
JUMPV
LABELV $781
line 2757
;2757:		}
LABELV $779
line 2758
;2758:		if (dist < attack_dist - attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
GEF4 $783
line 2759
;2759:			if (trap_BotMoveInDirection(bs->ms, backward, 400, movetype)) return moveresult;
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
EQI4 $785
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $733
JUMPV
LABELV $785
line 2760
;2760:		}
LABELV $783
line 2761
;2761:		return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $733
JUMPV
LABELV $777
line 2764
;2762:	}
;2763:	//increase the strafe time
;2764:	bs->attackstrafe_time += bs->thinktime;
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
line 2766
;2765:	//get the strafe change time
;2766:	strafechange_time = 0.4 + (1 - attack_skill) * 0.2;
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
line 2767
;2767:	if (attack_skill > 0.7) strafechange_time += crandom() * 0.2;
ADDRLP4 132
INDIRF4
CNSTF4 1060320051
LEF4 $787
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
LABELV $787
line 2769
;2768:	//if the strafe direction should be changed
;2769:	if (bs->attackstrafe_time > strafechange_time) {
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
INDIRF4
ADDRLP4 336
INDIRF4
LEF4 $789
line 2771
;2770:		//some magic number :)
;2771:		if (random() > 0.935) {
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
LEF4 $791
line 2773
;2772:			//flip the strafe direction
;2773:			bs->flags ^= BFL_STRAFERIGHT;
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
line 2774
;2774:			bs->attackstrafe_time = 0;
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
CNSTF4 0
ASGNF4
line 2775
;2775:		}
LABELV $791
line 2776
;2776:	}
LABELV $789
line 2778
;2777:	//
;2778:	for (i = 0; i < 2; i++) {
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $793
line 2779
;2779:		hordir[0] = forward[0];
ADDRLP4 12
ADDRLP4 24
INDIRF4
ASGNF4
line 2780
;2780:		hordir[1] = forward[1];
ADDRLP4 12+4
ADDRLP4 24+4
INDIRF4
ASGNF4
line 2781
;2781:		hordir[2] = 0;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 2782
;2782:		VectorNormalize(hordir);
ADDRLP4 12
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2784
;2783:		//get the sideward vector
;2784:		CrossProduct(hordir, up, sideward);
ADDRLP4 12
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 2786
;2785:		//reverse the vector depending on the strafe direction
;2786:		if (bs->flags & BFL_STRAFERIGHT) VectorNegate(sideward, sideward);
ADDRFP4 4
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $800
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
LABELV $800
line 2788
;2787:		//randomly go back a little
;2788:		if (random() > 0.9) {
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
LEF4 $806
line 2789
;2789:			VectorAdd(sideward, backward, sideward);
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
line 2790
;2790:		}
ADDRGP4 $807
JUMPV
LABELV $806
line 2791
;2791:		else {
line 2793
;2792:			//walk forward or backward to get at the ideal attack distance
;2793:			if (dist > attack_dist + attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
ADDF4
LEF4 $814
line 2794
;2794:				VectorAdd(sideward, forward, sideward);
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
line 2795
;2795:			}
ADDRGP4 $815
JUMPV
LABELV $814
line 2796
;2796:			else if (dist < attack_dist - attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
GEF4 $822
line 2797
;2797:				VectorAdd(sideward, backward, sideward);
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
line 2798
;2798:			}
LABELV $822
LABELV $815
line 2799
;2799:		}
LABELV $807
line 2801
;2800:		//perform the movement
;2801:		if (trap_BotMoveInDirection(bs->ms, sideward, 400, movetype))
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
EQI4 $830
line 2802
;2802:			return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $733
JUMPV
LABELV $830
line 2804
;2803:		//movement failed, flip the strafe direction
;2804:		bs->flags ^= BFL_STRAFERIGHT;
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
line 2805
;2805:		bs->attackstrafe_time = 0;
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
CNSTF4 0
ASGNF4
line 2806
;2806:	}
LABELV $794
line 2778
ADDRLP4 48
ADDRLP4 48
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 2
LTI4 $793
line 2809
;2807:	//bot couldn't do any usefull movement
;2808://	bs->attackchase_time = AAS_Time() + 6;
;2809:	return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
LABELV $733
endproc BotAttackMove 392 16
export BotSameTeam
proc BotSameTeam 2072 12
line 2817
;2810:}
;2811:
;2812:/*
;2813:==================
;2814:BotSameTeam
;2815:==================
;2816:*/
;2817:int BotSameTeam(bot_state_t *bs, int entnum) {
line 2820
;2818:	char info1[1024], info2[1024];
;2819:
;2820:	if (bs->client < 0 || bs->client >= MAX_CLIENTS) {
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
LTI4 $835
ADDRLP4 2048
INDIRI4
CNSTI4 64
LTI4 $833
LABELV $835
line 2822
;2821:		//BotAI_Print(PRT_ERROR, "BotSameTeam: client out of range\n");
;2822:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $832
JUMPV
LABELV $833
line 2824
;2823:	}
;2824:	if (entnum < 0 || entnum >= MAX_CLIENTS) {
ADDRLP4 2052
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 2052
INDIRI4
CNSTI4 0
LTI4 $838
ADDRLP4 2052
INDIRI4
CNSTI4 64
LTI4 $836
LABELV $838
line 2826
;2825:		//BotAI_Print(PRT_ERROR, "BotSameTeam: client out of range\n");
;2826:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $832
JUMPV
LABELV $836
line 2828
;2827:	}
;2828:	if ( gametype >= GT_TEAM ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 3
LTI4 $839
line 2829
;2829:		trap_GetConfigstring(CS_PLAYERS+bs->client, info1, sizeof(info1));
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
line 2830
;2830:		trap_GetConfigstring(CS_PLAYERS+entnum, info2, sizeof(info2));
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
line 2832
;2831:		//
;2832:		if (atoi(Info_ValueForKey(info1, "t")) == atoi(Info_ValueForKey(info2, "t"))) return qtrue;
ADDRLP4 0
ARGP4
ADDRGP4 $67
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
ADDRGP4 $67
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
NEI4 $841
CNSTI4 1
RETI4
ADDRGP4 $832
JUMPV
LABELV $841
line 2833
;2833:	}
LABELV $839
line 2834
;2834:	return qfalse;
CNSTI4 0
RETI4
LABELV $832
endproc BotSameTeam 2072 12
export InFieldOfVision
proc InFieldOfVision 24 4
line 2843
;2835:}
;2836:
;2837:/*
;2838:==================
;2839:InFieldOfVision
;2840:==================
;2841:*/
;2842:qboolean InFieldOfVision(vec3_t viewangles, float fov, vec3_t angles)
;2843:{
line 2847
;2844:	int i;
;2845:	float diff, angle;
;2846:
;2847:	for (i = 0; i < 2; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $844
line 2848
;2848:		angle = AngleMod(viewangles[i]);
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
line 2849
;2849:		angles[i] = AngleMod(angles[i]);
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
line 2850
;2850:		diff = angles[i] - angle;
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
line 2851
;2851:		if (angles[i] > angle) {
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
LEF4 $848
line 2852
;2852:			if (diff > 180.0) diff -= 360.0;
ADDRLP4 4
INDIRF4
CNSTF4 1127481344
LEF4 $849
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1135869952
SUBF4
ASGNF4
line 2853
;2853:		}
ADDRGP4 $849
JUMPV
LABELV $848
line 2854
;2854:		else {
line 2855
;2855:			if (diff < -180.0) diff += 360.0;
ADDRLP4 4
INDIRF4
CNSTF4 3274964992
GEF4 $852
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1135869952
ADDF4
ASGNF4
LABELV $852
line 2856
;2856:		}
LABELV $849
line 2857
;2857:		if (diff > 0) {
ADDRLP4 4
INDIRF4
CNSTF4 0
LEF4 $854
line 2858
;2858:			if (diff > fov * 0.5) return qfalse;
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
MULF4
LEF4 $855
CNSTI4 0
RETI4
ADDRGP4 $843
JUMPV
line 2859
;2859:		}
LABELV $854
line 2860
;2860:		else {
line 2861
;2861:			if (diff < -fov * 0.5) return qfalse;
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
NEGF4
MULF4
GEF4 $858
CNSTI4 0
RETI4
ADDRGP4 $843
JUMPV
LABELV $858
line 2862
;2862:		}
LABELV $855
line 2863
;2863:	}
LABELV $845
line 2847
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LTI4 $844
line 2864
;2864:	return qtrue;
CNSTI4 1
RETI4
LABELV $843
endproc InFieldOfVision 24 4
export BotEntityVisible
proc BotEntityVisible 376 28
line 2874
;2865:}
;2866:
;2867:/*
;2868:==================
;2869:BotEntityVisible
;2870:
;2871:returns visibility in the range [0, 1] taking fog and water surfaces into account
;2872:==================
;2873:*/
;2874:float BotEntityVisible(int viewer, vec3_t eye, vec3_t viewangles, float fov, int ent) {
line 2882
;2875:	int i, contents_mask, passent, hitent, infog, inwater, otherinfog, pc;
;2876:	float squaredfogdist, waterfactor, vis, bestvis;
;2877:	bsp_trace_t trace;
;2878:	aas_entityinfo_t entinfo;
;2879:	vec3_t dir, entangles, start, end, middle;
;2880:
;2881:	//calculate middle of bounding box
;2882:	BotEntityInfo(ent, &entinfo);
ADDRFP4 16
INDIRI4
ARGI4
ADDRLP4 148
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2883
;2883:	VectorAdd(entinfo.mins, entinfo.maxs, middle);
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
line 2884
;2884:	VectorScale(middle, 0.5, middle);
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
line 2885
;2885:	VectorAdd(entinfo.origin, middle, middle);
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
line 2887
;2886:	//check if entity is within field of vision
;2887:	VectorSubtract(middle, eye, dir);
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
line 2888
;2888:	vectoangles(dir, entangles);
ADDRLP4 136
ARGP4
ADDRLP4 320
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2889
;2889:	if (!InFieldOfVision(viewangles, fov, entangles)) return 0;
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
NEI4 $890
CNSTF4 0
RETF4
ADDRGP4 $860
JUMPV
LABELV $890
line 2891
;2890:	//
;2891:	pc = trap_AAS_PointContents(eye);
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
line 2892
;2892:	infog = (pc & CONTENTS_FOG);
ADDRLP4 312
ADDRLP4 316
INDIRI4
CNSTI4 64
BANDI4
ASGNI4
line 2893
;2893:	inwater = (pc & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER));
ADDRLP4 308
ADDRLP4 316
INDIRI4
CNSTI4 56
BANDI4
ASGNI4
line 2895
;2894:	//
;2895:	bestvis = 0;
ADDRLP4 296
CNSTF4 0
ASGNF4
line 2896
;2896:	for (i = 0; i < 3; i++) {
ADDRLP4 100
CNSTI4 0
ASGNI4
LABELV $892
line 2900
;2897:		//if the point is not in potential visible sight
;2898:		//if (!AAS_inPVS(eye, middle)) continue;
;2899:		//
;2900:		contents_mask = CONTENTS_SOLID|CONTENTS_PLAYERCLIP;
ADDRLP4 96
CNSTI4 65537
ASGNI4
line 2901
;2901:		passent = viewer;
ADDRLP4 116
ADDRFP4 0
INDIRI4
ASGNI4
line 2902
;2902:		hitent = ent;
ADDRLP4 132
ADDRFP4 16
INDIRI4
ASGNI4
line 2903
;2903:		VectorCopy(eye, start);
ADDRLP4 120
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2904
;2904:		VectorCopy(middle, end);
ADDRLP4 104
ADDRLP4 84
INDIRB
ASGNB 12
line 2906
;2905:		//if the entity is in water, lava or slime
;2906:		if (trap_AAS_PointContents(middle) & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER)) {
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
EQI4 $896
line 2907
;2907:			contents_mask |= (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 56
BORI4
ASGNI4
line 2908
;2908:		}
LABELV $896
line 2910
;2909:		//if eye is in water, lava or slime
;2910:		if (inwater) {
ADDRLP4 308
INDIRI4
CNSTI4 0
EQI4 $898
line 2911
;2911:			if (!(contents_mask & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER))) {
ADDRLP4 96
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
NEI4 $900
line 2912
;2912:				passent = ent;
ADDRLP4 116
ADDRFP4 16
INDIRI4
ASGNI4
line 2913
;2913:				hitent = viewer;
ADDRLP4 132
ADDRFP4 0
INDIRI4
ASGNI4
line 2914
;2914:				VectorCopy(middle, start);
ADDRLP4 120
ADDRLP4 84
INDIRB
ASGNB 12
line 2915
;2915:				VectorCopy(eye, end);
ADDRLP4 104
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2916
;2916:			}
LABELV $900
line 2917
;2917:			contents_mask ^= (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 56
BXORI4
ASGNI4
line 2918
;2918:		}
LABELV $898
line 2920
;2919:		//trace from start to end
;2920:		BotAI_Trace(&trace, start, NULL, NULL, end, passent, contents_mask);
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
line 2922
;2921:		//if water was hit
;2922:		waterfactor = 1.0;
ADDRLP4 288
CNSTF4 1065353216
ASGNF4
line 2923
;2923:		if (trace.contents & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER)) {
ADDRLP4 0+76
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $902
line 2925
;2924:			//if the water surface is translucent
;2925:			if (1) {
line 2927
;2926:				//trace through the water
;2927:				contents_mask &= ~(CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 -57
BANDI4
ASGNI4
line 2928
;2928:				BotAI_Trace(&trace, trace.endpos, NULL, NULL, end, passent, contents_mask);
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
line 2929
;2929:				waterfactor = 0.5;
ADDRLP4 288
CNSTF4 1056964608
ASGNF4
line 2930
;2930:			}
LABELV $905
line 2931
;2931:		}
LABELV $902
line 2933
;2932:		//if a full trace or the hitent was hit
;2933:		if (trace.fraction >= 1 || trace.ent == hitent) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $912
ADDRLP4 0+80
INDIRI4
ADDRLP4 132
INDIRI4
NEI4 $908
LABELV $912
line 2936
;2934:			//check for fog, assuming there's only one fog brush where
;2935:			//either the viewer or the entity is in or both are in
;2936:			otherinfog = (trap_AAS_PointContents(middle) & CONTENTS_FOG);
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
line 2937
;2937:			if (infog && otherinfog) {
ADDRLP4 360
CNSTI4 0
ASGNI4
ADDRLP4 312
INDIRI4
ADDRLP4 360
INDIRI4
EQI4 $913
ADDRLP4 304
INDIRI4
ADDRLP4 360
INDIRI4
EQI4 $913
line 2938
;2938:				VectorSubtract(trace.endpos, eye, dir);
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
line 2939
;2939:				squaredfogdist = VectorLengthSquared(dir);
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
line 2940
;2940:			}
ADDRGP4 $914
JUMPV
LABELV $913
line 2941
;2941:			else if (infog) {
ADDRLP4 312
INDIRI4
CNSTI4 0
EQI4 $922
line 2942
;2942:				VectorCopy(trace.endpos, start);
ADDRLP4 120
ADDRLP4 0+12
INDIRB
ASGNB 12
line 2943
;2943:				BotAI_Trace(&trace, start, NULL, NULL, eye, viewer, CONTENTS_FOG);
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
line 2944
;2944:				VectorSubtract(eye, trace.endpos, dir);
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
line 2945
;2945:				squaredfogdist = VectorLengthSquared(dir);
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
line 2946
;2946:			}
ADDRGP4 $923
JUMPV
LABELV $922
line 2947
;2947:			else if (otherinfog) {
ADDRLP4 304
INDIRI4
CNSTI4 0
EQI4 $932
line 2948
;2948:				VectorCopy(trace.endpos, end);
ADDRLP4 104
ADDRLP4 0+12
INDIRB
ASGNB 12
line 2949
;2949:				BotAI_Trace(&trace, eye, NULL, NULL, end, viewer, CONTENTS_FOG);
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
line 2950
;2950:				VectorSubtract(end, trace.endpos, dir);
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
line 2951
;2951:				squaredfogdist = VectorLengthSquared(dir);
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
line 2952
;2952:			}
ADDRGP4 $933
JUMPV
LABELV $932
line 2953
;2953:			else {
line 2955
;2954:				//if the entity and the viewer are not in fog assume there's no fog in between
;2955:				squaredfogdist = 0;
ADDRLP4 300
CNSTF4 0
ASGNF4
line 2956
;2956:			}
LABELV $933
LABELV $923
LABELV $914
line 2958
;2957:			//decrease visibility with the view distance through fog
;2958:			vis = 1 / ((squaredfogdist * 0.001) < 1 ? 1 : (squaredfogdist * 0.001));
ADDRLP4 368
CNSTF4 1065353216
ASGNF4
CNSTF4 981668463
ADDRLP4 300
INDIRF4
MULF4
ADDRLP4 368
INDIRF4
GEF4 $945
ADDRLP4 364
CNSTF4 1065353216
ASGNF4
ADDRGP4 $946
JUMPV
LABELV $945
ADDRLP4 364
CNSTF4 981668463
ADDRLP4 300
INDIRF4
MULF4
ASGNF4
LABELV $946
ADDRLP4 292
ADDRLP4 368
INDIRF4
ADDRLP4 364
INDIRF4
DIVF4
ASGNF4
line 2960
;2959:			//if entering water visibility is reduced
;2960:			vis *= waterfactor;
ADDRLP4 292
ADDRLP4 292
INDIRF4
ADDRLP4 288
INDIRF4
MULF4
ASGNF4
line 2962
;2961:			//
;2962:			if (vis > bestvis) bestvis = vis;
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
LEF4 $947
ADDRLP4 296
ADDRLP4 292
INDIRF4
ASGNF4
LABELV $947
line 2964
;2963:			//if pretty much no fog
;2964:			if (bestvis >= 0.95) return bestvis;
ADDRLP4 296
INDIRF4
CNSTF4 1064514355
LTF4 $949
ADDRLP4 296
INDIRF4
RETF4
ADDRGP4 $860
JUMPV
LABELV $949
line 2965
;2965:		}
LABELV $908
line 2967
;2966:		//check bottom and top of bounding box as well
;2967:		if (i == 0) middle[2] += entinfo.mins[2];
ADDRLP4 100
INDIRI4
CNSTI4 0
NEI4 $951
ADDRLP4 84+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 148+72+8
INDIRF4
ADDF4
ASGNF4
ADDRGP4 $952
JUMPV
LABELV $951
line 2968
;2968:		else if (i == 1) middle[2] += entinfo.maxs[2] - entinfo.mins[2];
ADDRLP4 100
INDIRI4
CNSTI4 1
NEI4 $956
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
LABELV $956
LABELV $952
line 2969
;2969:	}
LABELV $893
line 2896
ADDRLP4 100
ADDRLP4 100
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 100
INDIRI4
CNSTI4 3
LTI4 $892
line 2970
;2970:	return bestvis;
ADDRLP4 296
INDIRF4
RETF4
LABELV $860
endproc BotEntityVisible 376 28
export BotFindEnemy
proc BotFindEnemy 432 20
line 2978
;2971:}
;2972:
;2973:/*
;2974:==================
;2975:BotFindEnemy
;2976:==================
;2977:*/
;2978:int BotFindEnemy(bot_state_t *bs, int curenemy) {
line 2985
;2979:	int i, healthdecrease;
;2980:	float f, alertness, easyfragger, vis;
;2981:	float squaredist, cursquaredist;
;2982:	aas_entityinfo_t entinfo, curenemyinfo;
;2983:	vec3_t dir, angles;
;2984:
;2985:	alertness = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ALERTNESS, 0, 1);
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
line 2986
;2986:	easyfragger = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_EASY_FRAGGER, 0, 1);
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
line 2988
;2987:	//check if the health decreased
;2988:	healthdecrease = bs->lasthealth > bs->inventory[INVENTORY_HEALTH];
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
LEI4 $965
ADDRLP4 344
CNSTI4 1
ASGNI4
ADDRGP4 $966
JUMPV
LABELV $965
ADDRLP4 344
CNSTI4 0
ASGNI4
LABELV $966
ADDRLP4 160
ADDRLP4 344
INDIRI4
ASGNI4
line 2990
;2989:	//remember the current health value
;2990:	bs->lasthealth = bs->inventory[INVENTORY_HEALTH];
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
line 2992
;2991:	//
;2992:	if (curenemy >= 0) {
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $967
line 2993
;2993:		BotEntityInfo(curenemy, &curenemyinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 196
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2994
;2994:		if (EntityCarriesFlag(&curenemyinfo)) return qfalse;
ADDRLP4 196
ARGP4
ADDRLP4 356
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 356
INDIRI4
CNSTI4 0
EQI4 $969
CNSTI4 0
RETI4
ADDRGP4 $963
JUMPV
LABELV $969
line 2995
;2995:		VectorSubtract(curenemyinfo.origin, bs->origin, dir);
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
line 2996
;2996:		cursquaredist = VectorLengthSquared(dir);
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
line 2997
;2997:	}
ADDRGP4 $968
JUMPV
LABELV $967
line 2998
;2998:	else {
line 2999
;2999:		cursquaredist = 0;
ADDRLP4 192
CNSTF4 0
ASGNF4
line 3000
;3000:	}
LABELV $968
line 3029
;3001:#ifdef MISSIONPACK
;3002:	if (gametype == GT_OBELISK) {
;3003:		vec3_t target;
;3004:		bot_goal_t *goal;
;3005:		bsp_trace_t trace;
;3006:
;3007:		if (BotTeam(bs) == TEAM_RED)
;3008:			goal = &blueobelisk;
;3009:		else
;3010:			goal = &redobelisk;
;3011:		//if the obelisk is visible
;3012:		VectorCopy(goal->origin, target);
;3013:		target[2] += 1;
;3014:		BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;3015:		if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;3016:			if (goal->entitynum == bs->enemy) {
;3017:				return qfalse;
;3018:			}
;3019:			bs->enemy = goal->entitynum;
;3020:			bs->enemysight_time = FloatTime();
;3021:			bs->enemysuicide = qfalse;
;3022:			bs->enemydeath_time = 0;
;3023:			bs->enemyvisible_time = FloatTime();
;3024:			return qtrue;
;3025:		}
;3026:	}
;3027:#endif
;3028:	//
;3029:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 140
CNSTI4 0
ASGNI4
ADDRGP4 $981
JUMPV
LABELV $978
line 3031
;3030:
;3031:		if (i == bs->client) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $982
ADDRGP4 $979
JUMPV
LABELV $982
line 3033
;3032:		//if it's the current enemy
;3033:		if (i == curenemy) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $984
ADDRGP4 $979
JUMPV
LABELV $984
line 3035
;3034:		//
;3035:		BotEntityInfo(i, &entinfo);
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3037
;3036:		//
;3037:		if (!entinfo.valid) continue;
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $986
ADDRGP4 $979
JUMPV
LABELV $986
line 3039
;3038:		//if the enemy isn't dead and the enemy isn't the bot self
;3039:		if (EntityIsDead(&entinfo) || entinfo.number == bs->entitynum) continue;
ADDRLP4 0
ARGP4
ADDRLP4 356
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 356
INDIRI4
CNSTI4 0
NEI4 $991
ADDRLP4 0+20
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $988
LABELV $991
ADDRGP4 $979
JUMPV
LABELV $988
line 3041
;3040:		//if the enemy is invisible and not shooting
;3041:		if (EntityIsInvisible(&entinfo) && !EntityIsShooting(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 360
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 360
INDIRI4
CNSTI4 0
EQI4 $992
ADDRLP4 0
ARGP4
ADDRLP4 364
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 364
INDIRI4
CNSTI4 0
NEI4 $992
line 3042
;3042:			continue;
ADDRGP4 $979
JUMPV
LABELV $992
line 3045
;3043:		}
;3044:		//if not an easy fragger don't shoot at chatting players
;3045:		if (easyfragger < 0.5 && EntityIsChatting(&entinfo)) continue;
ADDRLP4 176
INDIRF4
CNSTF4 1056964608
GEF4 $994
ADDRLP4 0
ARGP4
ADDRLP4 368
ADDRGP4 EntityIsChatting
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 0
EQI4 $994
ADDRGP4 $979
JUMPV
LABELV $994
line 3047
;3046:		//
;3047:		if (lastteleport_time > FloatTime() - 3) {
ADDRGP4 lastteleport_time
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1077936128
SUBF4
LEF4 $996
line 3048
;3048:			VectorSubtract(entinfo.origin, lastteleport_origin, dir);
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
line 3049
;3049:			if (VectorLengthSquared(dir) < Square(70)) continue;
ADDRLP4 144
ARGP4
ADDRLP4 372
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 372
INDIRF4
CNSTF4 1167663104
GEF4 $1007
ADDRGP4 $979
JUMPV
LABELV $1007
line 3050
;3050:		}
LABELV $996
line 3052
;3051:		//calculate the distance towards the enemy
;3052:		VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3053
;3053:		squaredist = VectorLengthSquared(dir);
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
line 3055
;3054:		//if this entity is not carrying a flag
;3055:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 380
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 380
INDIRI4
CNSTI4 0
NEI4 $1016
line 3056
;3056:		{
line 3058
;3057:			//if this enemy is further away than the current one
;3058:			if (curenemy >= 0 && squaredist > cursquaredist) continue;
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1018
ADDRLP4 156
INDIRF4
ADDRLP4 192
INDIRF4
LEF4 $1018
ADDRGP4 $979
JUMPV
LABELV $1018
line 3059
;3059:		} //end if
LABELV $1016
line 3061
;3060:		//if the bot has no
;3061:		if (squaredist > Square(900.0 + alertness * 4000.0)) continue;
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
LEF4 $1020
ADDRGP4 $979
JUMPV
LABELV $1020
line 3063
;3062:		//if on the same team
;3063:		if (BotSameTeam(bs, i)) continue;
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
EQI4 $1022
ADDRGP4 $979
JUMPV
LABELV $1022
line 3065
;3064:		//if the bot's health decreased or the enemy is shooting
;3065:		if (curenemy < 0 && (healthdecrease || EntityIsShooting(&entinfo)))
ADDRLP4 392
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 392
INDIRI4
GEI4 $1024
ADDRLP4 160
INDIRI4
ADDRLP4 392
INDIRI4
NEI4 $1026
ADDRLP4 0
ARGP4
ADDRLP4 396
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 396
INDIRI4
CNSTI4 0
EQI4 $1024
LABELV $1026
line 3066
;3066:			f = 360;
ADDRLP4 168
CNSTF4 1135869952
ASGNF4
ADDRGP4 $1025
JUMPV
LABELV $1024
line 3068
;3067:		else
;3068:			f = 90 + 90 - (90 - (squaredist > Square(810) ? Square(810) : squaredist) / (810 * 9));
ADDRLP4 156
INDIRF4
CNSTF4 1226845760
LEF4 $1028
ADDRLP4 400
CNSTF4 1226845760
ASGNF4
ADDRGP4 $1029
JUMPV
LABELV $1028
ADDRLP4 400
ADDRLP4 156
INDIRF4
ASGNF4
LABELV $1029
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
LABELV $1025
line 3070
;3069:		//check if the enemy is visible
;3070:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, f, i);
ADDRLP4 404
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 404
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 404
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 404
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
ADDRLP4 408
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 172
ADDRLP4 408
INDIRF4
ASGNF4
line 3071
;3071:		if (vis <= 0) continue;
ADDRLP4 172
INDIRF4
CNSTF4 0
GTF4 $1030
ADDRGP4 $979
JUMPV
LABELV $1030
line 3073
;3072:		//if the enemy is quite far away, not shooting and the bot is not damaged
;3073:		if (curenemy < 0 && squaredist > Square(100) && !healthdecrease && !EntityIsShooting(&entinfo))
ADDRLP4 412
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 412
INDIRI4
GEI4 $1032
ADDRLP4 156
INDIRF4
CNSTF4 1176256512
LEF4 $1032
ADDRLP4 160
INDIRI4
ADDRLP4 412
INDIRI4
NEI4 $1032
ADDRLP4 0
ARGP4
ADDRLP4 416
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 416
INDIRI4
CNSTI4 0
NEI4 $1032
line 3074
;3074:		{
line 3076
;3075:			//check if we can avoid this enemy
;3076:			VectorSubtract(bs->origin, entinfo.origin, dir);
ADDRLP4 420
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 144
ADDRLP4 420
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRLP4 0+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 144+4
ADDRLP4 420
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
line 3077
;3077:			vectoangles(dir, angles);
ADDRLP4 144
ARGP4
ADDRLP4 180
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3079
;3078:			//if the bot isn't in the fov of the enemy
;3079:			if (!InFieldOfVision(entinfo.angles, 90, angles)) {
ADDRLP4 0+36
ARGP4
CNSTF4 1119092736
ARGF4
ADDRLP4 180
ARGP4
ADDRLP4 424
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 424
INDIRI4
CNSTI4 0
NEI4 $1041
line 3081
;3080:				//update some stuff for this enemy
;3081:				BotUpdateBattleInventory(bs, i);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 3083
;3082:				//if the bot doesn't really want to fight
;3083:				if (BotWantsToRetreat(bs)) continue;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 428
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 428
INDIRI4
CNSTI4 0
EQI4 $1044
ADDRGP4 $979
JUMPV
LABELV $1044
line 3084
;3084:			}
LABELV $1041
line 3085
;3085:		}
LABELV $1032
line 3087
;3086:		//found an enemy
;3087:		bs->enemy = entinfo.number;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
ADDRLP4 0+20
INDIRI4
ASGNI4
line 3088
;3088:		if (curenemy >= 0) bs->enemysight_time = FloatTime() - 2;
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1047
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
ASGNF4
ADDRGP4 $1048
JUMPV
LABELV $1047
line 3089
;3089:		else bs->enemysight_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
LABELV $1048
line 3090
;3090:		bs->enemysuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 0
ASGNI4
line 3091
;3091:		bs->enemydeath_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
CNSTF4 0
ASGNF4
line 3092
;3092:		bs->enemyvisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 3093
;3093:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $963
JUMPV
LABELV $979
line 3029
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $981
ADDRLP4 140
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1049
ADDRLP4 140
INDIRI4
CNSTI4 64
LTI4 $978
LABELV $1049
line 3095
;3094:	}
;3095:	return qfalse;
CNSTI4 0
RETI4
LABELV $963
endproc BotFindEnemy 432 20
export BotTeamFlagCarrierVisible
proc BotTeamFlagCarrierVisible 164 20
line 3103
;3096:}
;3097:
;3098:/*
;3099:==================
;3100:BotTeamFlagCarrierVisible
;3101:==================
;3102:*/
;3103:int BotTeamFlagCarrierVisible(bot_state_t *bs) {
line 3108
;3104:	int i;
;3105:	float vis;
;3106:	aas_entityinfo_t entinfo;
;3107:
;3108:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1054
JUMPV
LABELV $1051
line 3109
;3109:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1055
line 3110
;3110:			continue;
ADDRGP4 $1052
JUMPV
LABELV $1055
line 3112
;3111:		//
;3112:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3114
;3113:		//if this player is active
;3114:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1057
line 3115
;3115:			continue;
ADDRGP4 $1052
JUMPV
LABELV $1057
line 3117
;3116:		//if this player is carrying a flag
;3117:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 148
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1059
line 3118
;3118:			continue;
ADDRGP4 $1052
JUMPV
LABELV $1059
line 3120
;3119:		//if the flag carrier is not on the same team
;3120:		if (!BotSameTeam(bs, i))
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
NEI4 $1061
line 3121
;3121:			continue;
ADDRGP4 $1052
JUMPV
LABELV $1061
line 3123
;3122:		//if the flag carrier is not visible
;3123:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
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
line 3124
;3124:		if (vis <= 0)
ADDRLP4 144
INDIRF4
CNSTF4 0
GTF4 $1063
line 3125
;3125:			continue;
ADDRGP4 $1052
JUMPV
LABELV $1063
line 3127
;3126:		//
;3127:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1050
JUMPV
LABELV $1052
line 3108
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1054
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1065
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1051
LABELV $1065
line 3129
;3128:	}
;3129:	return -1;
CNSTI4 -1
RETI4
LABELV $1050
endproc BotTeamFlagCarrierVisible 164 20
export BotTeamFlagCarrier
proc BotTeamFlagCarrier 152 8
line 3137
;3130:}
;3131:
;3132:/*
;3133:==================
;3134:BotTeamFlagCarrier
;3135:==================
;3136:*/
;3137:int BotTeamFlagCarrier(bot_state_t *bs) {
line 3141
;3138:	int i;
;3139:	aas_entityinfo_t entinfo;
;3140:
;3141:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1070
JUMPV
LABELV $1067
line 3142
;3142:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1071
line 3143
;3143:			continue;
ADDRGP4 $1068
JUMPV
LABELV $1071
line 3145
;3144:		//
;3145:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3147
;3146:		//if this player is active
;3147:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1073
line 3148
;3148:			continue;
ADDRGP4 $1068
JUMPV
LABELV $1073
line 3150
;3149:		//if this player is carrying a flag
;3150:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 144
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
NEI4 $1075
line 3151
;3151:			continue;
ADDRGP4 $1068
JUMPV
LABELV $1075
line 3153
;3152:		//if the flag carrier is not on the same team
;3153:		if (!BotSameTeam(bs, i))
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
NEI4 $1077
line 3154
;3154:			continue;
ADDRGP4 $1068
JUMPV
LABELV $1077
line 3156
;3155:		//
;3156:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1066
JUMPV
LABELV $1068
line 3141
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1070
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1079
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1067
LABELV $1079
line 3158
;3157:	}
;3158:	return -1;
CNSTI4 -1
RETI4
LABELV $1066
endproc BotTeamFlagCarrier 152 8
export BotEnemyFlagCarrierVisible
proc BotEnemyFlagCarrierVisible 164 20
line 3166
;3159:}
;3160:
;3161:/*
;3162:==================
;3163:BotEnemyFlagCarrierVisible
;3164:==================
;3165:*/
;3166:int BotEnemyFlagCarrierVisible(bot_state_t *bs) {
line 3171
;3167:	int i;
;3168:	float vis;
;3169:	aas_entityinfo_t entinfo;
;3170:
;3171:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1084
JUMPV
LABELV $1081
line 3172
;3172:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1085
line 3173
;3173:			continue;
ADDRGP4 $1082
JUMPV
LABELV $1085
line 3175
;3174:		//
;3175:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3177
;3176:		//if this player is active
;3177:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1087
line 3178
;3178:			continue;
ADDRGP4 $1082
JUMPV
LABELV $1087
line 3180
;3179:		//if this player is carrying a flag
;3180:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 148
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1089
line 3181
;3181:			continue;
ADDRGP4 $1082
JUMPV
LABELV $1089
line 3183
;3182:		//if the flag carrier is on the same team
;3183:		if (BotSameTeam(bs, i))
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
EQI4 $1091
line 3184
;3184:			continue;
ADDRGP4 $1082
JUMPV
LABELV $1091
line 3186
;3185:		//if the flag carrier is not visible
;3186:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
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
line 3187
;3187:		if (vis <= 0)
ADDRLP4 144
INDIRF4
CNSTF4 0
GTF4 $1093
line 3188
;3188:			continue;
ADDRGP4 $1082
JUMPV
LABELV $1093
line 3190
;3189:		//
;3190:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1080
JUMPV
LABELV $1082
line 3171
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1084
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1095
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1081
LABELV $1095
line 3192
;3191:	}
;3192:	return -1;
CNSTI4 -1
RETI4
LABELV $1080
endproc BotEnemyFlagCarrierVisible 164 20
export BotVisibleTeamMatesAndEnemies
proc BotVisibleTeamMatesAndEnemies 192 20
line 3200
;3193:}
;3194:
;3195:/*
;3196:==================
;3197:BotVisibleTeamMatesAndEnemies
;3198:==================
;3199:*/
;3200:void BotVisibleTeamMatesAndEnemies(bot_state_t *bs, int *teammates, int *enemies, float range) {
line 3206
;3201:	int i;
;3202:	float vis;
;3203:	aas_entityinfo_t entinfo;
;3204:	vec3_t dir;
;3205:
;3206:	if (teammates)
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1097
line 3207
;3207:		*teammates = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
LABELV $1097
line 3208
;3208:	if (enemies)
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1099
line 3209
;3209:		*enemies = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
LABELV $1099
line 3210
;3210:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1104
JUMPV
LABELV $1101
line 3211
;3211:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1105
line 3212
;3212:			continue;
ADDRGP4 $1102
JUMPV
LABELV $1105
line 3214
;3213:		//
;3214:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3216
;3215:		//if this player is active
;3216:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1107
line 3217
;3217:			continue;
ADDRGP4 $1102
JUMPV
LABELV $1107
line 3219
;3218:		//if this player is carrying a flag
;3219:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 160
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $1109
line 3220
;3220:			continue;
ADDRGP4 $1102
JUMPV
LABELV $1109
line 3222
;3221:		//if not within range
;3222:		VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3223
;3223:		if (VectorLengthSquared(dir) > Square(range))
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
LEF4 $1118
line 3224
;3224:			continue;
ADDRGP4 $1102
JUMPV
LABELV $1118
line 3226
;3225:		//if the flag carrier is not visible
;3226:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
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
line 3227
;3227:		if (vis <= 0)
ADDRLP4 156
INDIRF4
CNSTF4 0
GTF4 $1120
line 3228
;3228:			continue;
ADDRGP4 $1102
JUMPV
LABELV $1120
line 3230
;3229:		//if the flag carrier is on the same team
;3230:		if (BotSameTeam(bs, i)) {
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
EQI4 $1122
line 3231
;3231:			if (teammates)
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1123
line 3232
;3232:				(*teammates)++;
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
line 3233
;3233:		}
ADDRGP4 $1123
JUMPV
LABELV $1122
line 3234
;3234:		else {
line 3235
;3235:			if (enemies)
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1126
line 3236
;3236:				(*enemies)++;
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
LABELV $1126
line 3237
;3237:		}
LABELV $1123
line 3238
;3238:	}
LABELV $1102
line 3210
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1104
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1128
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1101
LABELV $1128
line 3239
;3239:}
LABELV $1096
endproc BotVisibleTeamMatesAndEnemies 192 20
lit
align 4
LABELV $1130
byte 4 3229614080
byte 4 3229614080
byte 4 3229614080
align 4
LABELV $1131
byte 4 1082130432
byte 4 1082130432
byte 4 1082130432
export BotAimAtEnemy
code
proc BotAimAtEnemy 1144 52
line 3310
;3240:
;3241:#ifdef MISSIONPACK
;3242:/*
;3243:==================
;3244:BotTeamCubeCarrierVisible
;3245:==================
;3246:*/
;3247:int BotTeamCubeCarrierVisible(bot_state_t *bs) {
;3248:	int i;
;3249:	float vis;
;3250:	aas_entityinfo_t entinfo;
;3251:
;3252:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
;3253:		if (i == bs->client) continue;
;3254:		//
;3255:		BotEntityInfo(i, &entinfo);
;3256:		//if this player is active
;3257:		if (!entinfo.valid) continue;
;3258:		//if this player is carrying a flag
;3259:		if (!EntityCarriesCubes(&entinfo)) continue;
;3260:		//if the flag carrier is not on the same team
;3261:		if (!BotSameTeam(bs, i)) continue;
;3262:		//if the flag carrier is not visible
;3263:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
;3264:		if (vis <= 0) continue;
;3265:		//
;3266:		return i;
;3267:	}
;3268:	return -1;
;3269:}
;3270:
;3271:/*
;3272:==================
;3273:BotEnemyCubeCarrierVisible
;3274:==================
;3275:*/
;3276:int BotEnemyCubeCarrierVisible(bot_state_t *bs) {
;3277:	int i;
;3278:	float vis;
;3279:	aas_entityinfo_t entinfo;
;3280:
;3281:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
;3282:		if (i == bs->client)
;3283:			continue;
;3284:		//
;3285:		BotEntityInfo(i, &entinfo);
;3286:		//if this player is active
;3287:		if (!entinfo.valid)
;3288:			continue;
;3289:		//if this player is carrying a flag
;3290:		if (!EntityCarriesCubes(&entinfo)) continue;
;3291:		//if the flag carrier is on the same team
;3292:		if (BotSameTeam(bs, i))
;3293:			continue;
;3294:		//if the flag carrier is not visible
;3295:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
;3296:		if (vis <= 0)
;3297:			continue;
;3298:		//
;3299:		return i;
;3300:	}
;3301:	return -1;
;3302:}
;3303:#endif
;3304:
;3305:/*
;3306:==================
;3307:BotAimAtEnemy
;3308:==================
;3309:*/
;3310:void BotAimAtEnemy(bot_state_t *bs) {
line 3314
;3311:	int i, enemyvisible;
;3312:	float dist, f, aim_skill, aim_accuracy, speed, reactiontime;
;3313:	vec3_t dir, bestorigin, end, start, groundtarget, cmdmove, enemyvelocity;
;3314:	vec3_t mins = {-4,-4,-4}, maxs = {4, 4, 4};
ADDRLP4 860
ADDRGP4 $1130
INDIRB
ASGNB 12
ADDRLP4 872
ADDRGP4 $1131
INDIRB
ASGNB 12
line 3322
;3315:	weaponinfo_t wi;
;3316:	aas_entityinfo_t entinfo;
;3317:	bot_goal_t goal;
;3318:	bsp_trace_t trace;
;3319:	vec3_t target;
;3320:
;3321:	//if the bot has no enemy
;3322:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $1132
line 3323
;3323:		return;
ADDRGP4 $1129
JUMPV
LABELV $1132
line 3326
;3324:	}
;3325:	//get the enemy entity information
;3326:	BotEntityInfo(bs->enemy, &entinfo);
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
line 3328
;3327:	//if this is not a player (should be an obelisk)
;3328:	if (bs->enemy >= MAX_CLIENTS) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 64
LTI4 $1134
line 3330
;3329:		//if the obelisk is visible
;3330:		VectorCopy(entinfo.origin, target);
ADDRLP4 828
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3339
;3331:#ifdef MISSIONPACK
;3332:		// if attacking an obelisk
;3333:		if ( bs->enemy == redobelisk.entitynum ||
;3334:			bs->enemy == blueobelisk.entitynum ) {
;3335:			target[2] += 32;
;3336:		}
;3337:#endif
;3338:		//aim at the obelisk
;3339:		VectorSubtract(target, bs->eye, dir);
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
line 3340
;3340:		vectoangles(dir, bs->ideal_viewangles);
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
line 3342
;3341:		//set the aim target before trying to attack
;3342:		VectorCopy(target, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 828
INDIRB
ASGNB 12
line 3343
;3343:		return;
ADDRGP4 $1129
JUMPV
LABELV $1134
line 3348
;3344:	}
;3345:	//
;3346:	//BotAI_Print(PRT_MESSAGE, "client %d: aiming at client %d\n", bs->entitynum, bs->enemy);
;3347:	//
;3348:	aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL, 0, 1);
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
line 3349
;3349:	aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY, 0, 1);
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
line 3351
;3350:	//
;3351:	if (aim_skill > 0.95) {
ADDRLP4 736
INDIRF4
CNSTF4 1064514355
LEF4 $1141
line 3353
;3352:		//don't aim too early
;3353:		reactiontime = 0.5 * trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_REACTIONTIME, 0, 1);
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
line 3354
;3354:		if (bs->enemysight_time > FloatTime() - reactiontime) return;
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
LEF4 $1143
ADDRGP4 $1129
JUMPV
LABELV $1143
line 3355
;3355:		if (bs->teleport_time > FloatTime() - reactiontime) return;
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
LEF4 $1145
ADDRGP4 $1129
JUMPV
LABELV $1145
line 3356
;3356:	}
LABELV $1141
line 3359
;3357:
;3358:	//get the weapon information
;3359:	trap_BotGetWeaponInfo(bs->ws, bs->weaponnum, &wi);
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
line 3361
;3360:	//get the weapon specific aim accuracy and or aim skill
;3361:	if (wi.number == WP_MACHINEGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 2
NEI4 $1147
line 3362
;3362:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_MACHINEGUN, 0, 1);
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
line 3363
;3363:	}
ADDRGP4 $1148
JUMPV
LABELV $1147
line 3364
;3364:	else if (wi.number == WP_SHOTGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 3
NEI4 $1150
line 3365
;3365:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_SHOTGUN, 0, 1);
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
line 3366
;3366:	}
ADDRGP4 $1151
JUMPV
LABELV $1150
line 3367
;3367:	else if (wi.number == WP_GRENADE_LAUNCHER) {
ADDRLP4 160+4
INDIRI4
CNSTI4 4
NEI4 $1153
line 3368
;3368:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_GRENADELAUNCHER, 0, 1);
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
line 3369
;3369:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_GRENADELAUNCHER, 0, 1);
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
line 3370
;3370:	}
ADDRGP4 $1154
JUMPV
LABELV $1153
line 3371
;3371:	else if (wi.number == WP_ROCKET_LAUNCHER) {
ADDRLP4 160+4
INDIRI4
CNSTI4 5
NEI4 $1156
line 3372
;3372:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_ROCKETLAUNCHER, 0, 1);
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
line 3373
;3373:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_ROCKETLAUNCHER, 0, 1);
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
line 3374
;3374:	}
ADDRGP4 $1157
JUMPV
LABELV $1156
line 3375
;3375:	else if (wi.number == WP_LIGHTNING) {
ADDRLP4 160+4
INDIRI4
CNSTI4 6
NEI4 $1159
line 3376
;3376:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_LIGHTNING, 0, 1);
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
line 3377
;3377:	}
ADDRGP4 $1160
JUMPV
LABELV $1159
line 3378
;3378:	else if (wi.number == WP_RAILGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 7
NEI4 $1162
line 3379
;3379:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_RAILGUN, 0, 1);
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
line 3380
;3380:	}
ADDRGP4 $1163
JUMPV
LABELV $1162
line 3381
;3381:	else if (wi.number == WP_PLASMAGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 8
NEI4 $1165
line 3382
;3382:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_PLASMAGUN, 0, 1);
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
line 3383
;3383:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_PLASMAGUN, 0, 1);
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
line 3384
;3384:	}
ADDRGP4 $1166
JUMPV
LABELV $1165
line 3385
;3385:	else if (wi.number == WP_BFG) {
ADDRLP4 160+4
INDIRI4
CNSTI4 9
NEI4 $1168
line 3386
;3386:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_BFG10K, 0, 1);
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
line 3387
;3387:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_BFG10K, 0, 1);
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
line 3388
;3388:	}
LABELV $1168
LABELV $1166
LABELV $1163
LABELV $1160
LABELV $1157
LABELV $1154
LABELV $1151
LABELV $1148
line 3390
;3389:	//
;3390:	if (aim_accuracy <= 0) aim_accuracy = 0.0001f;
ADDRLP4 156
INDIRF4
CNSTF4 0
GTF4 $1171
ADDRLP4 156
CNSTF4 953267991
ASGNF4
LABELV $1171
line 3392
;3391:	//get the enemy entity information
;3392:	BotEntityInfo(bs->enemy, &entinfo);
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
line 3394
;3393:	//if the enemy is invisible then shoot crappy most of the time
;3394:	if (EntityIsInvisible(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 996
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 996
INDIRI4
CNSTI4 0
EQI4 $1173
line 3395
;3395:		if (random() > 0.1) aim_accuracy *= 0.4f;
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
LEF4 $1175
ADDRLP4 156
CNSTF4 1053609165
ADDRLP4 156
INDIRF4
MULF4
ASGNF4
LABELV $1175
line 3396
;3396:	}
LABELV $1173
line 3398
;3397:	//
;3398:	VectorSubtract(entinfo.origin, entinfo.lastvisorigin, enemyvelocity);
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
line 3399
;3399:	VectorScale(enemyvelocity, 1 / entinfo.update_time, enemyvelocity);
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
line 3401
;3400:	//enemy origin and velocity is remembered every 0.5 seconds
;3401:	if (bs->enemyposition_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6140
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1196
line 3403
;3402:		//
;3403:		bs->enemyposition_time = FloatTime() + 0.5;
ADDRFP4 0
INDIRP4
CNSTI4 6140
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1056964608
ADDF4
ASGNF4
line 3404
;3404:		VectorCopy(enemyvelocity, bs->enemyvelocity);
ADDRFP4 0
INDIRP4
CNSTI4 6232
ADDP4
ADDRLP4 712
INDIRB
ASGNB 12
line 3405
;3405:		VectorCopy(entinfo.origin, bs->enemyorigin);
ADDRFP4 0
INDIRP4
CNSTI4 6244
ADDP4
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3406
;3406:	}
LABELV $1196
line 3408
;3407:	//if not extremely skilled
;3408:	if (aim_skill < 0.9) {
ADDRLP4 736
INDIRF4
CNSTF4 1063675494
GEF4 $1199
line 3409
;3409:		VectorSubtract(entinfo.origin, bs->enemyorigin, dir);
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
line 3411
;3410:		//if the enemy moved a bit
;3411:		if (VectorLengthSquared(dir) > Square(48)) {
ADDRLP4 140
ARGP4
ADDRLP4 1008
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1008
INDIRF4
CNSTF4 1158676480
LEF4 $1208
line 3413
;3412:			//if the enemy changed direction
;3413:			if (DotProduct(bs->enemyvelocity, enemyvelocity) < 0) {
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
GEF4 $1210
line 3415
;3414:				//aim accuracy should be worse now
;3415:				aim_accuracy *= 0.7f;
ADDRLP4 156
CNSTF4 1060320051
ADDRLP4 156
INDIRF4
MULF4
ASGNF4
line 3416
;3416:			}
LABELV $1210
line 3417
;3417:		}
LABELV $1208
line 3418
;3418:	}
LABELV $1199
line 3420
;3419:	//check visibility of enemy
;3420:	enemyvisible = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy);
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
line 3422
;3421:	//if the enemy is visible
;3422:	if (enemyvisible) {
ADDRLP4 824
INDIRI4
CNSTI4 0
EQI4 $1214
line 3424
;3423:		//
;3424:		VectorCopy(entinfo.origin, bestorigin);
ADDRLP4 724
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3425
;3425:		bestorigin[2] += 8;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 3428
;3426:		//get the start point shooting from
;3427:		//NOTE: the x and y projectile start offsets are ignored
;3428:		VectorCopy(bs->origin, start);
ADDRLP4 844
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 3429
;3429:		start[2] += bs->cur_ps.viewheight;
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
line 3430
;3430:		start[2] += wi.offset[2];
ADDRLP4 844+8
ADDRLP4 844+8
INDIRF4
ADDRLP4 160+292+8
INDIRF4
ADDF4
ASGNF4
line 3432
;3431:		//
;3432:		BotAI_Trace(&trace, start, mins, maxs, bestorigin, bs->entitynum, MASK_SHOT);
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
line 3434
;3433:		//if the enemy is NOT hit
;3434:		if (trace.fraction <= 1 && trace.ent != entinfo.number) {
ADDRLP4 740+8
INDIRF4
CNSTF4 1065353216
GTF4 $1222
ADDRLP4 740+80
INDIRI4
ADDRLP4 0+20
INDIRI4
EQI4 $1222
line 3435
;3435:			bestorigin[2] += 16;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 3436
;3436:		}
LABELV $1222
line 3438
;3437:		//if it is not an instant hit weapon the bot might want to predict the enemy
;3438:		if (wi.speed) {
ADDRLP4 160+272
INDIRF4
CNSTF4 0
EQF4 $1228
line 3440
;3439:			//
;3440:			VectorSubtract(bestorigin, bs->origin, dir);
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
line 3441
;3441:			dist = VectorLength(dir);
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
line 3442
;3442:			VectorSubtract(entinfo.origin, bs->enemyorigin, dir);
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
line 3444
;3443:			//if the enemy is NOT pretty far away and strafing just small steps left and right
;3444:			if (!(dist > 100 && VectorLengthSquared(dir) < Square(32))) {
ADDRLP4 840
INDIRF4
CNSTF4 1120403456
LEF4 $1244
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1149239296
LTF4 $1242
LABELV $1244
line 3446
;3445:				//if skilled anough do exact prediction
;3446:				if (aim_skill > 0.8 &&
ADDRLP4 736
INDIRF4
CNSTF4 1061997773
LEF4 $1245
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1245
line 3448
;3447:						//if the weapon is ready to fire
;3448:						bs->cur_ps.weaponstate == WEAPON_READY) {
line 3452
;3449:					aas_clientmove_t move;
;3450:					vec3_t origin;
;3451:
;3452:					VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3454
;3453:					//distance towards the enemy
;3454:					dist = VectorLength(dir);
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
line 3456
;3455:					//direction the enemy is moving in
;3456:					VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
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
line 3458
;3457:					//
;3458:					VectorScale(dir, 1 / entinfo.update_time, dir);
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
line 3460
;3459:					//
;3460:					VectorCopy(entinfo.origin, origin);
ADDRLP4 1028
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3461
;3461:					origin[2] += 1;
ADDRLP4 1028+8
ADDRLP4 1028+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 3463
;3462:					//
;3463:					VectorClear(cmdmove);
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
line 3465
;3464:					//AAS_ClearShownDebugLines();
;3465:					trap_AAS_PredictClientMovement(&move, bs->enemy, origin,
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
line 3469
;3466:														PRESENCE_CROUCH, qfalse,
;3467:														dir, cmdmove, 0,
;3468:														dist * 10 / wi.speed, 0.1f, 0, 0, qfalse);
;3469:					VectorCopy(move.endpos, bestorigin);
ADDRLP4 724
ADDRLP4 1040
INDIRB
ASGNB 12
line 3471
;3470:					//BotAI_Print(PRT_MESSAGE, "%1.1f predicted speed = %f, frames = %f\n", FloatTime(), VectorLength(dir), dist * 10 / wi.speed);
;3471:				}
ADDRGP4 $1246
JUMPV
LABELV $1245
line 3473
;3472:				//if not that skilled do linear prediction
;3473:				else if (aim_skill > 0.4) {
ADDRLP4 736
INDIRF4
CNSTF4 1053609165
LEF4 $1278
line 3474
;3474:					VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3476
;3475:					//distance towards the enemy
;3476:					dist = VectorLength(dir);
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
line 3478
;3477:					//direction the enemy is moving in
;3478:					VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
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
line 3479
;3479:					dir[2] = 0;
ADDRLP4 140+8
CNSTF4 0
ASGNF4
line 3481
;3480:					//
;3481:					speed = VectorNormalize(dir) / entinfo.update_time;
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
line 3484
;3482:					//botimport.Print(PRT_MESSAGE, "speed = %f, wi->speed = %f\n", speed, wi->speed);
;3483:					//best spot to aim at
;3484:					VectorMA(entinfo.origin, (dist / wi.speed) * speed, dir, bestorigin);
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
line 3485
;3485:				}
LABELV $1278
LABELV $1246
line 3486
;3486:			}
LABELV $1242
line 3487
;3487:		}
LABELV $1228
line 3489
;3488:		//if the projectile does radial damage
;3489:		if (aim_skill > 0.6 && wi.proj.damagetype & DAMAGETYPE_RADIAL) {
ADDRLP4 736
INDIRF4
CNSTF4 1058642330
LEF4 $1313
ADDRLP4 160+344+180
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1313
line 3491
;3490:			//if the enemy isn't standing significantly higher than the bot
;3491:			if (entinfo.origin[2] < bs->origin[2] + 16) {
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
CNSTF4 1098907648
ADDF4
GEF4 $1317
line 3493
;3492:				//try to aim at the ground in front of the enemy
;3493:				VectorCopy(entinfo.origin, end);
ADDRLP4 956
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3494
;3494:				end[2] -= 64;
ADDRLP4 956+8
ADDRLP4 956+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 3495
;3495:				BotAI_Trace(&trace, entinfo.origin, NULL, NULL, end, entinfo.number, MASK_SHOT);
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
line 3497
;3496:				//
;3497:				VectorCopy(bestorigin, groundtarget);
ADDRLP4 944
ADDRLP4 724
INDIRB
ASGNB 12
line 3498
;3498:				if (trace.startsolid) groundtarget[2] = entinfo.origin[2] - 16;
ADDRLP4 740+4
INDIRI4
CNSTI4 0
EQI4 $1325
ADDRLP4 944+8
ADDRLP4 0+24+8
INDIRF4
CNSTF4 1098907648
SUBF4
ASGNF4
ADDRGP4 $1326
JUMPV
LABELV $1325
line 3499
;3499:				else groundtarget[2] = trace.endpos[2] - 8;
ADDRLP4 944+8
ADDRLP4 740+12+8
INDIRF4
CNSTF4 1090519040
SUBF4
ASGNF4
LABELV $1326
line 3501
;3500:				//trace a line from projectile start to ground target
;3501:				BotAI_Trace(&trace, start, NULL, NULL, groundtarget, bs->entitynum, MASK_SHOT);
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
line 3503
;3502:				//if hitpoint is not vertically too far from the ground target
;3503:				if (fabs(trace.endpos[2] - groundtarget[2]) < 50) {
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
GEF4 $1334
line 3504
;3504:					VectorSubtract(trace.endpos, groundtarget, dir);
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
line 3506
;3505:					//if the hitpoint is near anough the ground target
;3506:					if (VectorLengthSquared(dir) < Square(60)) {
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1163984896
GEF4 $1348
line 3507
;3507:						VectorSubtract(trace.endpos, start, dir);
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
line 3509
;3508:						//if the hitpoint is far anough from the bot
;3509:						if (VectorLengthSquared(dir) > Square(100)) {
ADDRLP4 140
ARGP4
ADDRLP4 1028
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1028
INDIRF4
CNSTF4 1176256512
LEF4 $1359
line 3511
;3510:							//check if the bot is visible from the ground target
;3511:							trace.endpos[2] += 1;
ADDRLP4 740+12+8
ADDRLP4 740+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 3512
;3512:							BotAI_Trace(&trace, trace.endpos, NULL, NULL, entinfo.origin, entinfo.number, MASK_SHOT);
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
line 3513
;3513:							if (trace.fraction >= 1) {
ADDRLP4 740+8
INDIRF4
CNSTF4 1065353216
LTF4 $1366
line 3515
;3514:								//botimport.Print(PRT_MESSAGE, "%1.1f aiming at ground\n", AAS_Time());
;3515:								VectorCopy(groundtarget, bestorigin);
ADDRLP4 724
ADDRLP4 944
INDIRB
ASGNB 12
line 3516
;3516:							}
LABELV $1366
line 3517
;3517:						}
LABELV $1359
line 3518
;3518:					}
LABELV $1348
line 3519
;3519:				}
LABELV $1334
line 3520
;3520:			}
LABELV $1317
line 3521
;3521:		}
LABELV $1313
line 3522
;3522:		bestorigin[0] += 20 * crandom() * (1 - aim_accuracy);
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
line 3523
;3523:		bestorigin[1] += 20 * crandom() * (1 - aim_accuracy);
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
line 3524
;3524:		bestorigin[2] += 10 * crandom() * (1 - aim_accuracy);
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
line 3525
;3525:	}
ADDRGP4 $1215
JUMPV
LABELV $1214
line 3526
;3526:	else {
line 3528
;3527:		//
;3528:		VectorCopy(bs->lastenemyorigin, bestorigin);
ADDRLP4 724
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 3529
;3529:		bestorigin[2] += 8;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 3531
;3530:		//if the bot is skilled anough
;3531:		if (aim_skill > 0.5) {
ADDRLP4 736
INDIRF4
CNSTF4 1056964608
LEF4 $1372
line 3533
;3532:			//do prediction shots around corners
;3533:			if (wi.number == WP_BFG ||
ADDRLP4 160+4
INDIRI4
CNSTI4 9
EQI4 $1380
ADDRLP4 160+4
INDIRI4
CNSTI4 5
EQI4 $1380
ADDRLP4 160+4
INDIRI4
CNSTI4 4
NEI4 $1374
LABELV $1380
line 3535
;3534:				wi.number == WP_ROCKET_LAUNCHER ||
;3535:				wi.number == WP_GRENADE_LAUNCHER) {
line 3537
;3536:				//create the chase goal
;3537:				goal.entitynum = bs->client;
ADDRLP4 884+40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 3538
;3538:				goal.areanum = bs->areanum;
ADDRLP4 884+12
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ASGNI4
line 3539
;3539:				VectorCopy(bs->eye, goal.origin);
ADDRLP4 884
ADDRFP4 0
INDIRP4
CNSTI4 4936
ADDP4
INDIRB
ASGNB 12
line 3540
;3540:				VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 884+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 884+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 884+16+8
CNSTF4 3238002688
ASGNF4
line 3541
;3541:				VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 884+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 884+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 884+28+8
CNSTF4 1090519040
ASGNF4
line 3543
;3542:				//
;3543:				if (trap_BotPredictVisiblePosition(bs->lastenemyorigin, bs->lastenemyareanum, &goal, TFL_DEFAULT, target)) {
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
EQI4 $1393
line 3544
;3544:					VectorSubtract(target, bs->eye, dir);
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
line 3545
;3545:					if (VectorLengthSquared(dir) > Square(80)) {
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1170735104
LEF4 $1399
line 3546
;3546:						VectorCopy(target, bestorigin);
ADDRLP4 724
ADDRLP4 828
INDIRB
ASGNB 12
line 3547
;3547:						bestorigin[2] -= 20;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1101004800
SUBF4
ASGNF4
line 3548
;3548:					}
LABELV $1399
line 3549
;3549:				}
LABELV $1393
line 3550
;3550:				aim_accuracy = 1;
ADDRLP4 156
CNSTF4 1065353216
ASGNF4
line 3551
;3551:			}
LABELV $1374
line 3552
;3552:		}
LABELV $1372
line 3553
;3553:	}
LABELV $1215
line 3555
;3554:	//
;3555:	if (enemyvisible) {
ADDRLP4 824
INDIRI4
CNSTI4 0
EQI4 $1402
line 3556
;3556:		BotAI_Trace(&trace, bs->eye, NULL, NULL, bestorigin, bs->entitynum, MASK_SHOT);
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
line 3557
;3557:		VectorCopy(trace.endpos, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 740+12
INDIRB
ASGNB 12
line 3558
;3558:	}
ADDRGP4 $1403
JUMPV
LABELV $1402
line 3559
;3559:	else {
line 3560
;3560:		VectorCopy(bestorigin, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 724
INDIRB
ASGNB 12
line 3561
;3561:	}
LABELV $1403
line 3563
;3562:	//get aim direction
;3563:	VectorSubtract(bestorigin, bs->eye, dir);
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
line 3565
;3564:	//
;3565:	if (wi.number == WP_MACHINEGUN ||
ADDRLP4 160+4
INDIRI4
CNSTI4 2
EQI4 $1417
ADDRLP4 160+4
INDIRI4
CNSTI4 3
EQI4 $1417
ADDRLP4 160+4
INDIRI4
CNSTI4 6
EQI4 $1417
ADDRLP4 160+4
INDIRI4
CNSTI4 7
NEI4 $1409
LABELV $1417
line 3568
;3566:		wi.number == WP_SHOTGUN ||
;3567:		wi.number == WP_LIGHTNING ||
;3568:		wi.number == WP_RAILGUN) {
line 3570
;3569:		//distance towards the enemy
;3570:		dist = VectorLength(dir);
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
line 3571
;3571:		if (dist > 150) dist = 150;
ADDRLP4 840
INDIRF4
CNSTF4 1125515264
LEF4 $1418
ADDRLP4 840
CNSTF4 1125515264
ASGNF4
LABELV $1418
line 3572
;3572:		f = 0.6 + dist / 150 * 0.4;
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
line 3573
;3573:		aim_accuracy *= f;
ADDRLP4 156
ADDRLP4 156
INDIRF4
ADDRLP4 940
INDIRF4
MULF4
ASGNF4
line 3574
;3574:	}
LABELV $1409
line 3576
;3575:	//add some random stuff to the aim direction depending on the aim accuracy
;3576:	if (aim_accuracy < 0.8) {
ADDRLP4 156
INDIRF4
CNSTF4 1061997773
GEF4 $1420
line 3577
;3577:		VectorNormalize(dir);
ADDRLP4 140
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 3578
;3578:		for (i = 0; i < 3; i++) dir[i] += 0.3 * crandom() * (1 - aim_accuracy);
ADDRLP4 152
CNSTI4 0
ASGNI4
LABELV $1422
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
LABELV $1423
ADDRLP4 152
ADDRLP4 152
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 3
LTI4 $1422
line 3579
;3579:	}
LABELV $1420
line 3581
;3580:	//set the ideal view angles
;3581:	vectoangles(dir, bs->ideal_viewangles);
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
line 3583
;3582:	//take the weapon spread into account for lower skilled bots
;3583:	bs->ideal_viewangles[PITCH] += 6 * wi.vspread * crandom() * (1 - aim_accuracy);
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
line 3584
;3584:	bs->ideal_viewangles[PITCH] = AngleMod(bs->ideal_viewangles[PITCH]);
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
line 3585
;3585:	bs->ideal_viewangles[YAW] += 6 * wi.hspread * crandom() * (1 - aim_accuracy);
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
line 3586
;3586:	bs->ideal_viewangles[YAW] = AngleMod(bs->ideal_viewangles[YAW]);
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
line 3588
;3587:	//if the bots should be really challenging
;3588:	if (bot_challenge.integer) {
ADDRGP4 bot_challenge+12
INDIRI4
CNSTI4 0
EQI4 $1428
line 3590
;3589:		//if the bot is really accurate and has the enemy in view for some time
;3590:		if (aim_accuracy > 0.9 && bs->enemysight_time < FloatTime() - 1) {
ADDRLP4 156
INDIRF4
CNSTF4 1063675494
LEF4 $1431
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $1431
line 3592
;3591:			//set the view angles directly
;3592:			if (bs->ideal_viewangles[PITCH] > 180) bs->ideal_viewangles[PITCH] -= 360;
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
INDIRF4
CNSTF4 1127481344
LEF4 $1433
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
LABELV $1433
line 3593
;3593:			VectorCopy(bs->ideal_viewangles, bs->viewangles);
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
line 3594
;3594:			trap_EA_View(bs->client, bs->viewangles);
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
line 3595
;3595:		}
LABELV $1431
line 3596
;3596:	}
LABELV $1428
line 3597
;3597:}
LABELV $1129
endproc BotAimAtEnemy 1144 52
lit
align 4
LABELV $1436
byte 4 3238002688
byte 4 3238002688
byte 4 3238002688
align 4
LABELV $1437
byte 4 1090519040
byte 4 1090519040
byte 4 1090519040
export BotCheckAttack
code
proc BotCheckAttack 1028 28
line 3604
;3598:
;3599:/*
;3600:==================
;3601:BotCheckAttack
;3602:==================
;3603:*/
;3604:void BotCheckAttack(bot_state_t *bs) {
line 3613
;3605:	float points, reactiontime, fov, firethrottle;
;3606:	int attackentity;
;3607:	bsp_trace_t bsptrace;
;3608:	//float selfpreservation;
;3609:	vec3_t forward, right, start, end, dir, angles;
;3610:	weaponinfo_t wi;
;3611:	bsp_trace_t trace;
;3612:	aas_entityinfo_t entinfo;
;3613:	vec3_t mins = {-8, -8, -8}, maxs = {8, 8, 8};
ADDRLP4 808
ADDRGP4 $1436
INDIRB
ASGNB 12
ADDRLP4 820
ADDRGP4 $1437
INDIRB
ASGNB 12
line 3615
;3614:
;3615:	attackentity = bs->enemy;
ADDRLP4 576
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 3617
;3616:	//
;3617:	BotEntityInfo(attackentity, &entinfo);
ADDRLP4 576
INDIRI4
ARGI4
ADDRLP4 832
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3619
;3618:	// if not attacking a player
;3619:	if (attackentity >= MAX_CLIENTS) {
ADDRLP4 576
INDIRI4
CNSTI4 64
LTI4 $1438
line 3631
;3620:#ifdef MISSIONPACK
;3621:		// if attacking an obelisk
;3622:		if ( entinfo.number == redobelisk.entitynum ||
;3623:			entinfo.number == blueobelisk.entitynum ) {
;3624:			// if obelisk is respawning return
;3625:			if ( g_entities[entinfo.number].activator &&
;3626:				g_entities[entinfo.number].activator->s.frame == 2 ) {
;3627:				return;
;3628:			}
;3629:		}
;3630:#endif
;3631:	}
LABELV $1438
line 3633
;3632:	//
;3633:	reactiontime = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_REACTIONTIME, 0, 1);
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
line 3634
;3634:	if (bs->enemysight_time > FloatTime() - reactiontime) return;
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
LEF4 $1440
ADDRGP4 $1435
JUMPV
LABELV $1440
line 3635
;3635:	if (bs->teleport_time > FloatTime() - reactiontime) return;
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
LEF4 $1442
ADDRGP4 $1435
JUMPV
LABELV $1442
line 3637
;3636:	//if changing weapons
;3637:	if (bs->weaponchange_time > FloatTime() - 0.1) return;
ADDRFP4 0
INDIRP4
CNSTI4 6192
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1036831949
SUBF4
LEF4 $1444
ADDRGP4 $1435
JUMPV
LABELV $1444
line 3639
;3638:	//check fire throttle characteristic
;3639:	if (bs->firethrottlewait_time > FloatTime()) return;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $1446
ADDRGP4 $1435
JUMPV
LABELV $1446
line 3640
;3640:	firethrottle = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_FIRETHROTTLE, 0, 1);
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
line 3641
;3641:	if (bs->firethrottleshoot_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1448
line 3642
;3642:		if (random() > firethrottle) {
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
LEF4 $1450
line 3643
;3643:			bs->firethrottlewait_time = FloatTime() + firethrottle;
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
line 3644
;3644:			bs->firethrottleshoot_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
CNSTF4 0
ASGNF4
line 3645
;3645:		}
ADDRGP4 $1451
JUMPV
LABELV $1450
line 3646
;3646:		else {
line 3647
;3647:			bs->firethrottleshoot_time = FloatTime() + 1 - firethrottle;
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
line 3648
;3648:			bs->firethrottlewait_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
CNSTF4 0
ASGNF4
line 3649
;3649:		}
LABELV $1451
line 3650
;3650:	}
LABELV $1448
line 3653
;3651:	//
;3652:	//
;3653:	VectorSubtract(bs->aimtarget, bs->eye, dir);
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
line 3655
;3654:	//
;3655:	if (bs->weaponnum == WP_GAUNTLET) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $1454
line 3656
;3656:		if (VectorLengthSquared(dir) > Square(60)) {
ADDRLP4 580
ARGP4
ADDRLP4 992
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 992
INDIRF4
CNSTF4 1163984896
LEF4 $1456
line 3657
;3657:			return;
ADDRGP4 $1435
JUMPV
LABELV $1456
line 3659
;3658:		}
;3659:	}
LABELV $1454
line 3660
;3660:	if (VectorLengthSquared(dir) < Square(100))
ADDRLP4 580
ARGP4
ADDRLP4 992
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 992
INDIRF4
CNSTF4 1176256512
GEF4 $1458
line 3661
;3661:		fov = 120;
ADDRLP4 788
CNSTF4 1123024896
ASGNF4
ADDRGP4 $1459
JUMPV
LABELV $1458
line 3663
;3662:	else
;3663:		fov = 50;
ADDRLP4 788
CNSTF4 1112014848
ASGNF4
LABELV $1459
line 3665
;3664:	//
;3665:	vectoangles(dir, angles);
ADDRLP4 580
ARGP4
ADDRLP4 796
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3666
;3666:	if (!InFieldOfVision(bs->viewangles, fov, angles))
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
NEI4 $1460
line 3667
;3667:		return;
ADDRGP4 $1435
JUMPV
LABELV $1460
line 3668
;3668:	BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, bs->aimtarget, bs->client, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
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
line 3669
;3669:	if (bsptrace.fraction < 1 && bsptrace.ent != attackentity)
ADDRLP4 704+8
INDIRF4
CNSTF4 1065353216
GEF4 $1462
ADDRLP4 704+80
INDIRI4
ADDRLP4 576
INDIRI4
EQI4 $1462
line 3670
;3670:		return;
ADDRGP4 $1435
JUMPV
LABELV $1462
line 3673
;3671:
;3672:	//get the weapon info
;3673:	trap_BotGetWeaponInfo(bs->ws, bs->weaponnum, &wi);
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
line 3675
;3674:	//get the start point shooting from
;3675:	VectorCopy(bs->origin, start);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 3676
;3676:	start[2] += bs->cur_ps.viewheight;
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
line 3677
;3677:	AngleVectors(bs->viewangles, forward, right, NULL);
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
line 3678
;3678:	start[0] += forward[0] * wi.offset[0] + right[0] * wi.offset[1];
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
line 3679
;3679:	start[1] += forward[1] * wi.offset[0] + right[1] * wi.offset[1];
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
line 3680
;3680:	start[2] += forward[2] * wi.offset[0] + right[2] * wi.offset[1] + wi.offset[2];
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
line 3682
;3681:	//end point aiming at
;3682:	VectorMA(start, 1000, forward, end);
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
line 3684
;3683:	//a little back to make sure not inside a very close enemy
;3684:	VectorMA(start, -12, forward, start);
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
line 3685
;3685:	BotAI_Trace(&trace, start, mins, maxs, end, bs->entitynum, MASK_SHOT);
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
line 3687
;3686:	//if the entity is a client
;3687:	if (trace.ent > 0 && trace.ent <= MAX_CLIENTS) {
ADDRLP4 592+80
INDIRI4
CNSTI4 0
LEI4 $1496
ADDRLP4 592+80
INDIRI4
CNSTI4 64
GTI4 $1496
line 3688
;3688:		if (trace.ent != attackentity) {
ADDRLP4 592+80
INDIRI4
ADDRLP4 576
INDIRI4
EQI4 $1500
line 3690
;3689:			//if a teammate is hit
;3690:			if (BotSameTeam(bs, trace.ent))
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
EQI4 $1503
line 3691
;3691:				return;
ADDRGP4 $1435
JUMPV
LABELV $1503
line 3692
;3692:		}
LABELV $1500
line 3693
;3693:	}
LABELV $1496
line 3695
;3694:	//if won't hit the enemy or not attacking a player (obelisk)
;3695:	if (trace.ent != attackentity || attackentity >= MAX_CLIENTS) {
ADDRLP4 592+80
INDIRI4
ADDRLP4 576
INDIRI4
NEI4 $1509
ADDRLP4 576
INDIRI4
CNSTI4 64
LTI4 $1506
LABELV $1509
line 3697
;3696:		//if the projectile does radial damage
;3697:		if (wi.proj.damagetype & DAMAGETYPE_RADIAL) {
ADDRLP4 24+344+180
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1510
line 3698
;3698:			if (trace.fraction * 1000 < wi.proj.radius) {
CNSTF4 1148846080
ADDRLP4 592+8
INDIRF4
MULF4
ADDRLP4 24+344+172
INDIRF4
GEF4 $1514
line 3699
;3699:				points = (wi.proj.damage - 0.5 * trace.fraction * 1000) * 0.5;
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
line 3700
;3700:				if (points > 0) {
ADDRLP4 972
INDIRF4
CNSTF4 0
LEF4 $1522
line 3701
;3701:					return;
ADDRGP4 $1435
JUMPV
LABELV $1522
line 3703
;3702:				}
;3703:			}
LABELV $1514
line 3705
;3704:			//FIXME: check if a teammate gets radial damage
;3705:		}
LABELV $1510
line 3706
;3706:	}
LABELV $1506
line 3708
;3707:	//if fire has to be release to activate weapon
;3708:	if (wi.flags & WFL_FIRERELEASED) {
ADDRLP4 24+176
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $1524
line 3709
;3709:		if (bs->flags & BFL_ATTACKED) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1525
line 3710
;3710:			trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3711
;3711:		}
line 3712
;3712:	}
ADDRGP4 $1525
JUMPV
LABELV $1524
line 3713
;3713:	else {
line 3714
;3714:		trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3715
;3715:	}
LABELV $1525
line 3716
;3716:	bs->flags ^= BFL_ATTACKED;
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
line 3717
;3717:}
LABELV $1435
endproc BotCheckAttack 1028 28
lit
align 4
LABELV $1535
byte 4 1143930880
byte 4 1129054208
byte 4 1143472128
align 4
LABELV $1536
byte 4 1148256256
byte 4 1139408896
byte 4 1143603200
align 4
LABELV $1537
byte 4 1134034944
byte 4 1135607808
byte 4 1147535360
export BotMapScripts
code
proc BotMapScripts 1424 16
line 3724
;3718:
;3719:/*
;3720:==================
;3721:BotMapScripts
;3722:==================
;3723:*/
;3724:void BotMapScripts(bot_state_t *bs) {
line 3732
;3725:	char info[1024];
;3726:	char mapname[128];
;3727:	int i, shootbutton;
;3728:	float aim_accuracy;
;3729:	aas_entityinfo_t entinfo;
;3730:	vec3_t dir;
;3731:
;3732:	trap_GetServerinfo(info, sizeof(info));
ADDRLP4 272
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetServerinfo
CALLV
pop
line 3734
;3733:
;3734:	strncpy(mapname, Info_ValueForKey( info, "mapname" ), sizeof(mapname)-1);
ADDRLP4 272
ARGP4
ADDRGP4 $1530
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
line 3735
;3735:	mapname[sizeof(mapname)-1] = '\0';
ADDRLP4 144+127
CNSTI1 0
ASGNI1
line 3737
;3736:
;3737:	if (!Q_stricmp(mapname, "q3tourney6")) {
ADDRLP4 144
ARGP4
ADDRGP4 $1534
ARGP4
ADDRLP4 1320
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1320
INDIRI4
CNSTI4 0
NEI4 $1532
line 3738
;3738:		vec3_t mins = {700, 204, 672}, maxs = {964, 468, 680};
ADDRLP4 1324
ADDRGP4 $1535
INDIRB
ASGNB 12
ADDRLP4 1336
ADDRGP4 $1536
INDIRB
ASGNB 12
line 3739
;3739:		vec3_t buttonorg = {304, 352, 920};
ADDRLP4 1348
ADDRGP4 $1537
INDIRB
ASGNB 12
line 3741
;3740:		//NOTE: NEVER use the func_bobbing in q3tourney6
;3741:		bs->tfl &= ~TFL_FUNCBOB;
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
line 3743
;3742:		//if the bot is below the bounding box
;3743:		if (bs->origin[0] > mins[0] && bs->origin[0] < maxs[0]) {
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
LEF4 $1538
ADDRLP4 1364
INDIRF4
ADDRLP4 1336
INDIRF4
GEF4 $1538
line 3744
;3744:			if (bs->origin[1] > mins[1] && bs->origin[1] < maxs[1]) {
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
LEF4 $1540
ADDRLP4 1368
INDIRF4
ADDRLP4 1336+4
INDIRF4
GEF4 $1540
line 3745
;3745:				if (bs->origin[2] < mins[2]) {
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 1324+8
INDIRF4
GEF4 $1544
line 3746
;3746:					return;
ADDRGP4 $1529
JUMPV
LABELV $1544
line 3748
;3747:				}
;3748:			}
LABELV $1540
line 3749
;3749:		}
LABELV $1538
line 3750
;3750:		shootbutton = qfalse;
ADDRLP4 1296
CNSTI4 0
ASGNI4
line 3752
;3751:		//if an enemy is below this bounding box then shoot the button
;3752:		for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 140
CNSTI4 0
ASGNI4
ADDRGP4 $1550
JUMPV
LABELV $1547
line 3754
;3753:
;3754:			if (i == bs->client) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1551
ADDRGP4 $1548
JUMPV
LABELV $1551
line 3756
;3755:			//
;3756:			BotEntityInfo(i, &entinfo);
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3758
;3757:			//
;3758:			if (!entinfo.valid) continue;
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1553
ADDRGP4 $1548
JUMPV
LABELV $1553
line 3760
;3759:			//if the enemy isn't dead and the enemy isn't the bot self
;3760:			if (EntityIsDead(&entinfo) || entinfo.number == bs->entitynum) continue;
ADDRLP4 0
ARGP4
ADDRLP4 1368
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 1368
INDIRI4
CNSTI4 0
NEI4 $1558
ADDRLP4 0+20
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $1555
LABELV $1558
ADDRGP4 $1548
JUMPV
LABELV $1555
line 3762
;3761:			//
;3762:			if (entinfo.origin[0] > mins[0] && entinfo.origin[0] < maxs[0]) {
ADDRLP4 0+24
INDIRF4
ADDRLP4 1324
INDIRF4
LEF4 $1559
ADDRLP4 0+24
INDIRF4
ADDRLP4 1336
INDIRF4
GEF4 $1559
line 3763
;3763:				if (entinfo.origin[1] > mins[1] && entinfo.origin[1] < maxs[1]) {
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1324+4
INDIRF4
LEF4 $1563
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1336+4
INDIRF4
GEF4 $1563
line 3764
;3764:					if (entinfo.origin[2] < mins[2]) {
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 1324+8
INDIRF4
GEF4 $1571
line 3766
;3765:						//if there's a team mate below the crusher
;3766:						if (BotSameTeam(bs, i)) {
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
EQI4 $1576
line 3767
;3767:							shootbutton = qfalse;
ADDRLP4 1296
CNSTI4 0
ASGNI4
line 3768
;3768:							break;
ADDRGP4 $1549
JUMPV
LABELV $1576
line 3770
;3769:						}
;3770:						else {
line 3771
;3771:							shootbutton = qtrue;
ADDRLP4 1296
CNSTI4 1
ASGNI4
line 3772
;3772:						}
line 3773
;3773:					}
LABELV $1571
line 3774
;3774:				}
LABELV $1563
line 3775
;3775:			}
LABELV $1559
line 3776
;3776:		}
LABELV $1548
line 3752
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1550
ADDRLP4 140
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1578
ADDRLP4 140
INDIRI4
CNSTI4 64
LTI4 $1547
LABELV $1578
LABELV $1549
line 3777
;3777:		if (shootbutton) {
ADDRLP4 1296
INDIRI4
CNSTI4 0
EQI4 $1533
line 3778
;3778:			bs->flags |= BFL_IDEALVIEWSET;
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
line 3779
;3779:			VectorSubtract(buttonorg, bs->eye, dir);
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
line 3780
;3780:			vectoangles(dir, bs->ideal_viewangles);
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
line 3781
;3781:			aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY, 0, 1);
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
line 3782
;3782:			bs->ideal_viewangles[PITCH] += 8 * crandom() * (1 - aim_accuracy);
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
line 3783
;3783:			bs->ideal_viewangles[PITCH] = AngleMod(bs->ideal_viewangles[PITCH]);
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
line 3784
;3784:			bs->ideal_viewangles[YAW] += 8 * crandom() * (1 - aim_accuracy);
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
line 3785
;3785:			bs->ideal_viewangles[YAW] = AngleMod(bs->ideal_viewangles[YAW]);
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
line 3787
;3786:			//
;3787:			if (InFieldOfVision(bs->viewangles, 20, bs->ideal_viewangles)) {
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
EQI4 $1533
line 3788
;3788:				trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3789
;3789:			}
line 3790
;3790:		}
line 3791
;3791:	}
ADDRGP4 $1533
JUMPV
LABELV $1532
line 3792
;3792:	else if (!Q_stricmp(mapname, "mpq3tourney6")) {
ADDRLP4 144
ARGP4
ADDRGP4 $1589
ARGP4
ADDRLP4 1324
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1324
INDIRI4
CNSTI4 0
NEI4 $1587
line 3794
;3793:		//NOTE: NEVER use the func_bobbing in mpq3tourney6
;3794:		bs->tfl &= ~TFL_FUNCBOB;
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
line 3795
;3795:	}
LABELV $1587
LABELV $1533
line 3796
;3796:}
LABELV $1529
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
line 3809
;3797:
;3798:/*
;3799:==================
;3800:BotSetMovedir
;3801:==================
;3802:*/
;3803:// bk001205 - made these static
;3804:static vec3_t VEC_UP		= {0, -1,  0};
;3805:static vec3_t MOVEDIR_UP	= {0,  0,  1};
;3806:static vec3_t VEC_DOWN		= {0, -2,  0};
;3807:static vec3_t MOVEDIR_DOWN	= {0,  0, -1};
;3808:
;3809:void BotSetMovedir(vec3_t angles, vec3_t movedir) {
line 3810
;3810:	if (VectorCompare(angles, VEC_UP)) {
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
EQI4 $1591
line 3811
;3811:		VectorCopy(MOVEDIR_UP, movedir);
ADDRFP4 4
INDIRP4
ADDRGP4 MOVEDIR_UP
INDIRB
ASGNB 12
line 3812
;3812:	}
ADDRGP4 $1592
JUMPV
LABELV $1591
line 3813
;3813:	else if (VectorCompare(angles, VEC_DOWN)) {
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
EQI4 $1593
line 3814
;3814:		VectorCopy(MOVEDIR_DOWN, movedir);
ADDRFP4 4
INDIRP4
ADDRGP4 MOVEDIR_DOWN
INDIRB
ASGNB 12
line 3815
;3815:	}
ADDRGP4 $1594
JUMPV
LABELV $1593
line 3816
;3816:	else {
line 3817
;3817:		AngleVectors(angles, movedir, NULL, NULL);
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
line 3818
;3818:	}
LABELV $1594
LABELV $1592
line 3819
;3819:}
LABELV $1590
endproc BotSetMovedir 12 16
export BotModelMinsMaxs
proc BotModelMinsMaxs 40 0
line 3828
;3820:
;3821:/*
;3822:==================
;3823:BotModelMinsMaxs
;3824:
;3825:this is ugly
;3826:==================
;3827:*/
;3828:int BotModelMinsMaxs(int modelindex, int eType, int contents, vec3_t mins, vec3_t maxs) {
line 3832
;3829:	gentity_t *ent;
;3830:	int i;
;3831:
;3832:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 3833
;3833:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1599
JUMPV
LABELV $1596
line 3834
;3834:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1601
line 3835
;3835:			continue;
ADDRGP4 $1597
JUMPV
LABELV $1601
line 3837
;3836:		}
;3837:		if ( eType && ent->s.eType != eType) {
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $1603
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
EQI4 $1603
line 3838
;3838:			continue;
ADDRGP4 $1597
JUMPV
LABELV $1603
line 3840
;3839:		}
;3840:		if ( contents && ent->r.contents != contents) {
ADDRLP4 12
ADDRFP4 8
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $1605
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $1605
line 3841
;3841:			continue;
ADDRGP4 $1597
JUMPV
LABELV $1605
line 3843
;3842:		}
;3843:		if (ent->s.modelindex == modelindex) {
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $1607
line 3844
;3844:			if (mins)
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1609
line 3845
;3845:				VectorAdd(ent->r.currentOrigin, ent->r.mins, mins);
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
LABELV $1609
line 3846
;3846:			if (maxs)
ADDRFP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1611
line 3847
;3847:				VectorAdd(ent->r.currentOrigin, ent->r.maxs, maxs);
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
LABELV $1611
line 3848
;3848:			return i;
ADDRLP4 4
INDIRI4
RETI4
ADDRGP4 $1595
JUMPV
LABELV $1607
line 3850
;3849:		}
;3850:	}
LABELV $1597
line 3833
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 808
ADDP4
ASGNP4
LABELV $1599
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $1596
line 3851
;3851:	if (mins)
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1613
line 3852
;3852:		VectorClear(mins);
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
LABELV $1613
line 3853
;3853:	if (maxs)
ADDRFP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1615
line 3854
;3854:		VectorClear(maxs);
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
LABELV $1615
line 3855
;3855:	return 0;
CNSTI4 0
RETI4
LABELV $1595
endproc BotModelMinsMaxs 40 0
lit
align 4
LABELV $1618
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
align 4
LABELV $1619
byte 4 3212836864
byte 4 3212836864
byte 4 3212836864
export BotFuncButtonActivateGoal
code
proc BotFuncButtonActivateGoal 648 28
line 3863
;3856:}
;3857:
;3858:/*
;3859:==================
;3860:BotFuncButtonGoal
;3861:==================
;3862:*/
;3863:int BotFuncButtonActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 3869
;3864:	int i, areas[10], numareas, modelindex, entitynum;
;3865:	char model[128];
;3866:	float lip, dist, health, angle;
;3867:	vec3_t size, start, end, mins, maxs, angles, points[10];
;3868:	vec3_t movedir, origin, goalorigin, bboxmins, bboxmaxs;
;3869:	vec3_t extramins = {1, 1, 1}, extramaxs = {-1, -1, -1};
ADDRLP4 304
ADDRGP4 $1618
INDIRB
ASGNB 12
ADDRLP4 316
ADDRGP4 $1619
INDIRB
ASGNB 12
line 3872
;3870:	bsp_trace_t bsptrace;
;3871:
;3872:	activategoal->shoot = qfalse;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 0
ASGNI4
line 3873
;3873:	VectorClear(activategoal->target);
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
line 3875
;3874:	//create a bot goal towards the button
;3875:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $274
ARGP4
ADDRLP4 160
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 3876
;3876:	if (!*model)
ADDRLP4 160
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1620
line 3877
;3877:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1617
JUMPV
LABELV $1620
line 3878
;3878:	modelindex = atoi(model+1);
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
line 3879
;3879:	if (!modelindex)
ADDRLP4 288
INDIRI4
CNSTI4 0
NEI4 $1623
line 3880
;3880:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1617
JUMPV
LABELV $1623
line 3881
;3881:	VectorClear(angles);
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
line 3882
;3882:	entitynum = BotModelMinsMaxs(modelindex, ET_MOVER, 0, mins, maxs);
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
line 3884
;3883:	//get the lip of the button
;3884:	trap_AAS_FloatForBSPEpairKey(bspent, "lip", &lip);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1627
ARGP4
ADDRLP4 328
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 3885
;3885:	if (!lip) lip = 4;
ADDRLP4 328
INDIRF4
CNSTF4 0
NEF4 $1628
ADDRLP4 328
CNSTF4 1082130432
ASGNF4
LABELV $1628
line 3887
;3886:	//get the move direction from the angle
;3887:	trap_AAS_FloatForBSPEpairKey(bspent, "angle", &angle);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1630
ARGP4
ADDRLP4 352
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 3888
;3888:	VectorSet(angles, 0, angle, 0);
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
line 3889
;3889:	BotSetMovedir(angles, movedir);
ADDRLP4 96
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 BotSetMovedir
CALLV
pop
line 3891
;3890:	//button size
;3891:	VectorSubtract(maxs, mins, size);
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
line 3893
;3892:	//button origin
;3893:	VectorAdd(mins, maxs, origin);
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
line 3894
;3894:	VectorScale(origin, 0.5, origin);
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
line 3896
;3895:	//touch distance of the button
;3896:	dist = fabs(movedir[0]) * size[0] + fabs(movedir[1]) * size[1] + fabs(movedir[2]) * size[2];
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
line 3897
;3897:	dist *= 0.5;
ADDRLP4 28
CNSTF4 1056964608
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 3899
;3898:	//
;3899:	trap_AAS_FloatForBSPEpairKey(bspent, "health", &health);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1653
ARGP4
ADDRLP4 348
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 3901
;3900:	//if the button is shootable
;3901:	if (health) {
ADDRLP4 348
INDIRF4
CNSTF4 0
EQF4 $1654
line 3903
;3902:		//calculate the shoot target
;3903:		VectorMA(origin, -dist, movedir, goalorigin);
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
line 3905
;3904:		//
;3905:		VectorCopy(goalorigin, activategoal->target);
ADDRFP4 8
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 124
INDIRB
ASGNB 12
line 3906
;3906:		activategoal->shoot = qtrue;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 1
ASGNI4
line 3908
;3907:		//
;3908:		BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, goalorigin, bs->entitynum, MASK_SHOT);
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
line 3910
;3909:		// if the button is visible from the current position
;3910:		if (bsptrace.fraction >= 1.0 || bsptrace.ent == entitynum) {
ADDRLP4 356+8
INDIRF4
CNSTF4 1065353216
GEF4 $1666
ADDRLP4 356+80
INDIRI4
ADDRLP4 344
INDIRI4
NEI4 $1662
LABELV $1666
line 3912
;3911:			//
;3912:			activategoal->goal.entitynum = entitynum; //NOTE: this is the entity number of the shootable button
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 3913
;3913:			activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 3914
;3914:			activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 3915
;3915:			VectorCopy(bs->origin, activategoal->goal.origin);
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
line 3916
;3916:			activategoal->goal.areanum = bs->areanum;
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
line 3917
;3917:			VectorSet(activategoal->goal.mins, -8, -8, -8);
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
line 3918
;3918:			VectorSet(activategoal->goal.maxs, 8, 8, 8);
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
line 3920
;3919:			//
;3920:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1617
JUMPV
LABELV $1662
line 3922
;3921:		}
;3922:		else {
line 3925
;3923:			//create a goal from where the button is visible and shoot at the button from there
;3924:			//add bounding box size to the dist
;3925:			trap_AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bboxmins, bboxmaxs);
CNSTI4 4
ARGI4
ADDRLP4 136
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 trap_AAS_PresenceTypeBoundingBox
CALLV
pop
line 3926
;3926:			for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1667
line 3927
;3927:				if (movedir[i] < 0) dist += fabs(movedir[i]) * fabs(bboxmaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1671
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
ADDRGP4 $1672
JUMPV
LABELV $1671
line 3928
;3928:				else dist += fabs(movedir[i]) * fabs(bboxmins[i]);
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
LABELV $1672
line 3929
;3929:			}
LABELV $1668
line 3926
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1667
line 3931
;3930:			//calculate the goal origin
;3931:			VectorMA(origin, -dist, movedir, goalorigin);
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
line 3933
;3932:			//
;3933:			VectorCopy(goalorigin, start);
ADDRLP4 292
ADDRLP4 124
INDIRB
ASGNB 12
line 3934
;3934:			start[2] += 24;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 3935
;3935:			VectorCopy(start, end);
ADDRLP4 332
ADDRLP4 292
INDIRB
ASGNB 12
line 3936
;3936:			end[2] -= 512;
ADDRLP4 332+8
ADDRLP4 332+8
INDIRF4
CNSTF4 1140850688
SUBF4
ASGNF4
line 3937
;3937:			numareas = trap_AAS_TraceAreas(start, end, areas, points, 10);
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
line 3939
;3938:			//
;3939:			for (i = numareas-1; i >= 0; i--) {
ADDRLP4 0
ADDRLP4 108
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $1684
JUMPV
LABELV $1681
line 3940
;3940:				if (trap_AAS_AreaReachability(areas[i])) {
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
EQI4 $1685
line 3941
;3941:					break;
ADDRGP4 $1683
JUMPV
LABELV $1685
line 3943
;3942:				}
;3943:			}
LABELV $1682
line 3939
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $1684
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1681
LABELV $1683
line 3944
;3944:			if (i < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1687
line 3946
;3945:				// FIXME: trace forward and maybe in other directions to find a valid area
;3946:			}
LABELV $1687
line 3947
;3947:			if (i >= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $1689
line 3949
;3948:				//
;3949:				VectorCopy(points[i], activategoal->goal.origin);
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
line 3950
;3950:				activategoal->goal.areanum = areas[i];
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
line 3951
;3951:				VectorSet(activategoal->goal.mins, 8, 8, 8);
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
line 3952
;3952:				VectorSet(activategoal->goal.maxs, -8, -8, -8);
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
line 3954
;3953:				//
;3954:				for (i = 0; i < 3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1691
line 3955
;3955:				{
line 3956
;3956:					if (movedir[i] < 0) activategoal->goal.maxs[i] += fabs(movedir[i]) * fabs(extramaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1695
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
ADDRGP4 $1696
JUMPV
LABELV $1695
line 3957
;3957:					else activategoal->goal.mins[i] += fabs(movedir[i]) * fabs(extramins[i]);
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
LABELV $1696
line 3958
;3958:				} //end for
LABELV $1692
line 3954
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1691
line 3960
;3959:				//
;3960:				activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 3961
;3961:				activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 3962
;3962:				activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 3963
;3963:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1617
JUMPV
LABELV $1689
line 3965
;3964:			}
;3965:		}
line 3966
;3966:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1617
JUMPV
LABELV $1654
line 3968
;3967:	}
;3968:	else {
line 3970
;3969:		//add bounding box size to the dist
;3970:		trap_AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bboxmins, bboxmaxs);
CNSTI4 4
ARGI4
ADDRLP4 136
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 trap_AAS_PresenceTypeBoundingBox
CALLV
pop
line 3971
;3971:		for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1697
line 3972
;3972:			if (movedir[i] < 0) dist += fabs(movedir[i]) * fabs(bboxmaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1701
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
ADDRGP4 $1702
JUMPV
LABELV $1701
line 3973
;3973:			else dist += fabs(movedir[i]) * fabs(bboxmins[i]);
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
LABELV $1702
line 3974
;3974:		}
LABELV $1698
line 3971
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1697
line 3976
;3975:		//calculate the goal origin
;3976:		VectorMA(origin, -dist, movedir, goalorigin);
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
line 3978
;3977:		//
;3978:		VectorCopy(goalorigin, start);
ADDRLP4 292
ADDRLP4 124
INDIRB
ASGNB 12
line 3979
;3979:		start[2] += 24;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 3980
;3980:		VectorCopy(start, end);
ADDRLP4 332
ADDRLP4 292
INDIRB
ASGNB 12
line 3981
;3981:		end[2] -= 100;
ADDRLP4 332+8
ADDRLP4 332+8
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
line 3982
;3982:		numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
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
line 3984
;3983:		//
;3984:		for (i = 0; i < numareas; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1714
JUMPV
LABELV $1711
line 3985
;3985:			if (trap_AAS_AreaReachability(areas[i])) {
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
EQI4 $1715
line 3986
;3986:				break;
ADDRGP4 $1713
JUMPV
LABELV $1715
line 3988
;3987:			}
;3988:		}
LABELV $1712
line 3984
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1714
ADDRLP4 0
INDIRI4
ADDRLP4 108
INDIRI4
LTI4 $1711
LABELV $1713
line 3989
;3989:		if (i < numareas) {
ADDRLP4 0
INDIRI4
ADDRLP4 108
INDIRI4
GEI4 $1717
line 3991
;3990:			//
;3991:			VectorCopy(origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 16
INDIRB
ASGNB 12
line 3992
;3992:			activategoal->goal.areanum = areas[i];
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
line 3993
;3993:			VectorSubtract(mins, origin, activategoal->goal.mins);
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
line 3994
;3994:			VectorSubtract(maxs, origin, activategoal->goal.maxs);
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
line 3996
;3995:			//
;3996:			for (i = 0; i < 3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1727
line 3997
;3997:			{
line 3998
;3998:				if (movedir[i] < 0) activategoal->goal.maxs[i] += fabs(movedir[i]) * fabs(extramaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1731
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
ADDRGP4 $1732
JUMPV
LABELV $1731
line 3999
;3999:				else activategoal->goal.mins[i] += fabs(movedir[i]) * fabs(extramins[i]);
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
LABELV $1732
line 4000
;4000:			} //end for
LABELV $1728
line 3996
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1727
line 4002
;4001:			//
;4002:			activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 4003
;4003:			activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4004
;4004:			activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4005
;4005:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1617
JUMPV
LABELV $1717
line 4007
;4006:		}
;4007:	}
line 4008
;4008:	return qfalse;
CNSTI4 0
RETI4
LABELV $1617
endproc BotFuncButtonActivateGoal 648 28
export BotFuncDoorActivateGoal
proc BotFuncDoorActivateGoal 1096 20
line 4016
;4009:}
;4010:
;4011:/*
;4012:==================
;4013:BotFuncDoorGoal
;4014:==================
;4015:*/
;4016:int BotFuncDoorActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4022
;4017:	int modelindex, entitynum;
;4018:	char model[MAX_INFO_STRING];
;4019:	vec3_t mins, maxs, origin, angles;
;4020:
;4021:	//shoot at the shootable door
;4022:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $274
ARGP4
ADDRLP4 12
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4023
;4023:	if (!*model)
ADDRLP4 12
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1734
line 4024
;4024:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1733
JUMPV
LABELV $1734
line 4025
;4025:	modelindex = atoi(model+1);
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
line 4026
;4026:	if (!modelindex)
ADDRLP4 1060
INDIRI4
CNSTI4 0
NEI4 $1737
line 4027
;4027:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1733
JUMPV
LABELV $1737
line 4028
;4028:	VectorClear(angles);
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
line 4029
;4029:	entitynum = BotModelMinsMaxs(modelindex, ET_MOVER, 0, mins, maxs);
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
line 4031
;4030:	//door origin
;4031:	VectorAdd(mins, maxs, origin);
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
line 4032
;4032:	VectorScale(origin, 0.5, origin);
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
line 4033
;4033:	VectorCopy(origin, activategoal->target);
ADDRFP4 8
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 4034
;4034:	activategoal->shoot = qtrue;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 1
ASGNI4
line 4036
;4035:	//
;4036:	activategoal->goal.entitynum = entitynum; //NOTE: this is the entity number of the shootable door
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 1076
INDIRI4
ASGNI4
line 4037
;4037:	activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4038
;4038:	activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4039
;4039:	VectorCopy(bs->origin, activategoal->goal.origin);
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
line 4040
;4040:	activategoal->goal.areanum = bs->areanum;
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
line 4041
;4041:	VectorSet(activategoal->goal.mins, -8, -8, -8);
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
line 4042
;4042:	VectorSet(activategoal->goal.maxs, 8, 8, 8);
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
line 4043
;4043:	return qtrue;
CNSTI4 1
RETI4
LABELV $1733
endproc BotFuncDoorActivateGoal 1096 20
export BotTriggerMultipleActivateGoal
proc BotTriggerMultipleActivateGoal 300 20
line 4051
;4044:}
;4045:
;4046:/*
;4047:==================
;4048:BotTriggerMultipleGoal
;4049:==================
;4050:*/
;4051:int BotTriggerMultipleActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4057
;4052:	int i, areas[10], numareas, modelindex, entitynum;
;4053:	char model[128];
;4054:	vec3_t start, end, mins, maxs, angles;
;4055:	vec3_t origin, goalorigin;
;4056:
;4057:	activategoal->shoot = qfalse;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 0
ASGNI4
line 4058
;4058:	VectorClear(activategoal->target);
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
line 4060
;4059:	//create a bot goal towards the trigger
;4060:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $274
ARGP4
ADDRLP4 84
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4061
;4061:	if (!*model)
ADDRLP4 84
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1752
line 4062
;4062:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1751
JUMPV
LABELV $1752
line 4063
;4063:	modelindex = atoi(model+1);
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
line 4064
;4064:	if (!modelindex)
ADDRLP4 224
INDIRI4
CNSTI4 0
NEI4 $1755
line 4065
;4065:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1751
JUMPV
LABELV $1755
line 4066
;4066:	VectorClear(angles);
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
line 4067
;4067:	entitynum = BotModelMinsMaxs(modelindex, 0, CONTENTS_TRIGGER, mins, maxs);
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
line 4069
;4068:	//trigger origin
;4069:	VectorAdd(mins, maxs, origin);
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
line 4070
;4070:	VectorScale(origin, 0.5, origin);
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
line 4071
;4071:	VectorCopy(origin, goalorigin);
ADDRLP4 252
ADDRLP4 4
INDIRB
ASGNB 12
line 4073
;4072:	//
;4073:	VectorCopy(goalorigin, start);
ADDRLP4 212
ADDRLP4 252
INDIRB
ASGNB 12
line 4074
;4074:	start[2] += 24;
ADDRLP4 212+8
ADDRLP4 212+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 4075
;4075:	VectorCopy(start, end);
ADDRLP4 228
ADDRLP4 212
INDIRB
ASGNB 12
line 4076
;4076:	end[2] -= 100;
ADDRLP4 228+8
ADDRLP4 228+8
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
line 4077
;4077:	numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
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
line 4079
;4078:	//
;4079:	for (i = 0; i < numareas; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1774
JUMPV
LABELV $1771
line 4080
;4080:		if (trap_AAS_AreaReachability(areas[i])) {
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
EQI4 $1775
line 4081
;4081:			break;
ADDRGP4 $1773
JUMPV
LABELV $1775
line 4083
;4082:		}
;4083:	}
LABELV $1772
line 4079
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1774
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $1771
LABELV $1773
line 4084
;4084:	if (i < numareas) {
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
GEI4 $1777
line 4085
;4085:		VectorCopy(origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 4086
;4086:		activategoal->goal.areanum = areas[i];
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
line 4087
;4087:		VectorSubtract(mins, origin, activategoal->goal.mins);
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
line 4088
;4088:		VectorSubtract(maxs, origin, activategoal->goal.maxs);
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
line 4090
;4089:		//
;4090:		activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 264
INDIRI4
ASGNI4
line 4091
;4091:		activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4092
;4092:		activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4093
;4093:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1751
JUMPV
LABELV $1777
line 4095
;4094:	}
;4095:	return qfalse;
CNSTI4 0
RETI4
LABELV $1751
endproc BotTriggerMultipleActivateGoal 300 20
export BotPopFromActivateGoalStack
proc BotPopFromActivateGoalStack 4 8
line 4103
;4096:}
;4097:
;4098:/*
;4099:==================
;4100:BotPopFromActivateGoalStack
;4101:==================
;4102:*/
;4103:int BotPopFromActivateGoalStack(bot_state_t *bs) {
line 4104
;4104:	if (!bs->activatestack)
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1788
line 4105
;4105:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1787
JUMPV
LABELV $1788
line 4106
;4106:	BotEnableActivateGoalAreas(bs->activatestack, qtrue);
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
line 4107
;4107:	bs->activatestack->inuse = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 0
ASGNI4
line 4108
;4108:	bs->activatestack->justused_time = FloatTime();
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
line 4109
;4109:	bs->activatestack = bs->activatestack->next;
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
line 4110
;4110:	return qtrue;
CNSTI4 1
RETI4
LABELV $1787
endproc BotPopFromActivateGoalStack 4 8
export BotPushOntoActivateGoalStack
proc BotPushOntoActivateGoalStack 24 12
line 4118
;4111:}
;4112:
;4113:/*
;4114:==================
;4115:BotPushOntoActivateGoalStack
;4116:==================
;4117:*/
;4118:int BotPushOntoActivateGoalStack(bot_state_t *bs, bot_activategoal_t *activategoal) {
line 4122
;4119:	int i, best;
;4120:	float besttime;
;4121:
;4122:	best = -1;
ADDRLP4 8
CNSTI4 -1
ASGNI4
line 4123
;4123:	besttime = FloatTime() + 9999;
ADDRLP4 4
ADDRGP4 floattime
INDIRF4
CNSTF4 1176255488
ADDF4
ASGNF4
line 4125
;4124:	//
;4125:	for (i = 0; i < MAX_ACTIVATESTACK; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1791
line 4126
;4126:		if (!bs->activategoalheap[i].inuse) {
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
NEI4 $1795
line 4127
;4127:			if (bs->activategoalheap[i].justused_time < besttime) {
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
GEF4 $1797
line 4128
;4128:				besttime = bs->activategoalheap[i].justused_time;
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
line 4129
;4129:				best = i;
ADDRLP4 8
ADDRLP4 0
INDIRI4
ASGNI4
line 4130
;4130:			}
LABELV $1797
line 4131
;4131:		}
LABELV $1795
line 4132
;4132:	}
LABELV $1792
line 4125
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 8
LTI4 $1791
line 4133
;4133:	if (best != -1) {
ADDRLP4 8
INDIRI4
CNSTI4 -1
EQI4 $1799
line 4134
;4134:		memcpy(&bs->activategoalheap[best], activategoal, sizeof(bot_activategoal_t));
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
line 4135
;4135:		bs->activategoalheap[best].inuse = qtrue;
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
line 4136
;4136:		bs->activategoalheap[best].next = bs->activatestack;
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
line 4137
;4137:		bs->activatestack = &bs->activategoalheap[best];
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
line 4138
;4138:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1790
JUMPV
LABELV $1799
line 4140
;4139:	}
;4140:	return qfalse;
CNSTI4 0
RETI4
LABELV $1790
endproc BotPushOntoActivateGoalStack 24 12
export BotClearActivateGoalStack
proc BotClearActivateGoalStack 0 4
line 4148
;4141:}
;4142:
;4143:/*
;4144:==================
;4145:BotClearActivateGoalStack
;4146:==================
;4147:*/
;4148:void BotClearActivateGoalStack(bot_state_t *bs) {
ADDRGP4 $1803
JUMPV
LABELV $1802
line 4150
;4149:	while(bs->activatestack)
;4150:		BotPopFromActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotPopFromActivateGoalStack
CALLI4
pop
LABELV $1803
line 4149
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1802
line 4151
;4151:}
LABELV $1801
endproc BotClearActivateGoalStack 0 4
export BotEnableActivateGoalAreas
proc BotEnableActivateGoalAreas 12 8
line 4158
;4152:
;4153:/*
;4154:==================
;4155:BotEnableActivateGoalAreas
;4156:==================
;4157:*/
;4158:void BotEnableActivateGoalAreas(bot_activategoal_t *activategoal, int enable) {
line 4161
;4159:	int i;
;4160:
;4161:	if (activategoal->areasdisabled == !enable)
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1809
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $1810
JUMPV
LABELV $1809
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $1810
ADDRFP4 0
INDIRP4
CNSTI4 236
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $1806
line 4162
;4162:		return;
ADDRGP4 $1805
JUMPV
LABELV $1806
line 4163
;4163:	for (i = 0; i < activategoal->numareas; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1814
JUMPV
LABELV $1811
line 4164
;4164:		trap_AAS_EnableRoutingArea( activategoal->areas[i], enable );
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
LABELV $1812
line 4163
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1814
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
LTI4 $1811
line 4165
;4165:	activategoal->areasdisabled = !enable;
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1816
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $1817
JUMPV
LABELV $1816
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $1817
ADDRFP4 0
INDIRP4
CNSTI4 236
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 4166
;4166:}
LABELV $1805
endproc BotEnableActivateGoalAreas 12 8
export BotIsGoingToActivateEntity
proc BotIsGoingToActivateEntity 8 0
line 4173
;4167:
;4168:/*
;4169:==================
;4170:BotIsGoingToActivateEntity
;4171:==================
;4172:*/
;4173:int BotIsGoingToActivateEntity(bot_state_t *bs, int entitynum) {
line 4177
;4174:	bot_activategoal_t *a;
;4175:	int i;
;4176:
;4177:	for (a = bs->activatestack; a; a = a->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRGP4 $1822
JUMPV
LABELV $1819
line 4178
;4178:		if (a->time < FloatTime())
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1823
line 4179
;4179:			continue;
ADDRGP4 $1820
JUMPV
LABELV $1823
line 4180
;4180:		if (a->goal.entitynum == entitynum)
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $1825
line 4181
;4181:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1818
JUMPV
LABELV $1825
line 4182
;4182:	}
LABELV $1820
line 4177
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 240
ADDP4
INDIRP4
ASGNP4
LABELV $1822
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1819
line 4183
;4183:	for (i = 0; i < MAX_ACTIVATESTACK; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $1827
line 4184
;4184:		if (bs->activategoalheap[i].inuse)
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
EQI4 $1831
line 4185
;4185:			continue;
ADDRGP4 $1828
JUMPV
LABELV $1831
line 4187
;4186:		//
;4187:		if (bs->activategoalheap[i].goal.entitynum == entitynum) {
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
NEI4 $1833
line 4189
;4188:			// if the bot went for this goal less than 2 seconds ago
;4189:			if (bs->activategoalheap[i].justused_time > FloatTime() - 2)
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
LEF4 $1835
line 4190
;4190:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1818
JUMPV
LABELV $1835
line 4191
;4191:		}
LABELV $1833
line 4192
;4192:	}
LABELV $1828
line 4183
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $1827
line 4193
;4193:	return qfalse;
CNSTI4 0
RETI4
LABELV $1818
endproc BotIsGoingToActivateEntity 8 0
export BotGetActivateGoal
proc BotGetActivateGoal 3320 20
line 4206
;4194:}
;4195:
;4196:/*
;4197:==================
;4198:BotGetActivateGoal
;4199:
;4200:  returns the number of the bsp entity to activate
;4201:  goal->entitynum will be set to the game entity to activate
;4202:==================
;4203:*/
;4204://#define OBSTACLEDEBUG
;4205:
;4206:int BotGetActivateGoal(bot_state_t *bs, int entitynum, bot_activategoal_t *activategoal) {
line 4216
;4207:	int i, ent, cur_entities[10], spawnflags, modelindex, areas[MAX_ACTIVATEAREAS*2], numareas, t;
;4208:	char model[MAX_INFO_STRING], tmpmodel[128];
;4209:	char target[128], classname[128];
;4210:	float health;
;4211:	char targetname[10][128];
;4212:	aas_entityinfo_t entinfo;
;4213:	aas_areainfo_t areainfo;
;4214:	vec3_t origin, angles, absmins, absmaxs;
;4215:
;4216:	memset(activategoal, 0, sizeof(bot_activategoal_t));
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
line 4217
;4217:	BotEntityInfo(entitynum, &entinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 3052
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 4218
;4218:	Com_sprintf(model, sizeof( model ), "*%d", entinfo.modelindex);
ADDRLP4 1712
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $1838
ARGP4
ADDRLP4 3052+104
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 4219
;4219:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
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
ADDRGP4 $1843
JUMPV
LABELV $1840
line 4220
;4220:		if (!trap_AAS_ValueForBSPEpairKey(ent, "model", tmpmodel, sizeof(tmpmodel))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $274
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
NEI4 $1844
ADDRGP4 $1841
JUMPV
LABELV $1844
line 4221
;4221:		if (!strcmp(model, tmpmodel)) break;
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
NEI4 $1846
ADDRGP4 $1842
JUMPV
LABELV $1846
line 4222
;4222:	}
LABELV $1841
line 4219
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
LABELV $1843
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1840
LABELV $1842
line 4223
;4223:	if (!ent) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1848
line 4224
;4224:		BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no entity found with model %s\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1850
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4225
;4225:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1848
line 4227
;4226:	}
;4227:	trap_AAS_ValueForBSPEpairKey(ent, "classname", classname, sizeof(classname));
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1851
ARGP4
ADDRLP4 1456
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4228
;4228:	if (!classname) {
ADDRLP4 1456
CVPU4 4
CNSTU4 0
NEU4 $1852
line 4229
;4229:		BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with model %s has no classname\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1854
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4230
;4230:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1852
line 4233
;4231:	}
;4232:	//if it is a door
;4233:	if (!strcmp(classname, "func_door")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1857
ARGP4
ADDRLP4 3260
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3260
INDIRI4
CNSTI4 0
NEI4 $1855
line 4234
;4234:		if (trap_AAS_FloatForBSPEpairKey(ent, "health", &health)) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1653
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
EQI4 $1858
line 4236
;4235:			//if the door has health then the door must be shot to open
;4236:			if (health) {
ADDRLP4 3208
INDIRF4
CNSTF4 0
EQF4 $1860
line 4237
;4237:				BotFuncDoorActivateGoal(bs, ent, activategoal);
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
line 4238
;4238:				return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1860
line 4240
;4239:			}
;4240:		}
LABELV $1858
line 4242
;4241:		//
;4242:		trap_AAS_IntForBSPEpairKey(ent, "spawnflags", &spawnflags);
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1862
ARGP4
ADDRLP4 3204
ARGP4
ADDRGP4 trap_AAS_IntForBSPEpairKey
CALLI4
pop
line 4244
;4243:		// if the door starts open then just wait for the door to return
;4244:		if ( spawnflags & 1 )
ADDRLP4 3204
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $1863
line 4245
;4245:			return 0;
CNSTI4 0
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1863
line 4247
;4246:		//get the door origin
;4247:		if (!trap_AAS_VectorForBSPEpairKey(ent, "origin", origin)) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1867
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
NEI4 $1865
line 4248
;4248:			VectorClear(origin);
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
line 4249
;4249:		}
LABELV $1865
line 4251
;4250:		//if the door is open or opening already
;4251:		if (!VectorCompare(origin, entinfo.origin))
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
NEI4 $1870
line 4252
;4252:			return 0;
CNSTI4 0
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1870
line 4254
;4253:		// store all the areas the door is in
;4254:		trap_AAS_ValueForBSPEpairKey(ent, "model", model, sizeof(model));
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $274
ARGP4
ADDRLP4 1712
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4255
;4255:		if (*model) {
ADDRLP4 1712
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $1873
line 4256
;4256:			modelindex = atoi(model+1);
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
line 4257
;4257:			if (modelindex) {
ADDRLP4 3212
INDIRI4
CNSTI4 0
EQI4 $1876
line 4258
;4258:				VectorClear(angles);
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
line 4259
;4259:				BotModelMinsMaxs(modelindex, ET_MOVER, 0, absmins, absmaxs);
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
line 4261
;4260:				//
;4261:				numareas = trap_AAS_BBoxAreas(absmins, absmaxs, areas, MAX_ACTIVATEAREAS*2);
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
line 4263
;4262:				// store the areas with reachabilities first
;4263:				for (i = 0; i < numareas; i++) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1883
JUMPV
LABELV $1880
line 4264
;4264:					if (activategoal->numareas >= MAX_ACTIVATEAREAS)
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
CNSTI4 32
LTI4 $1884
line 4265
;4265:						break;
ADDRGP4 $1882
JUMPV
LABELV $1884
line 4266
;4266:					if ( !trap_AAS_AreaReachability(areas[i]) ) {
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
NEI4 $1886
line 4267
;4267:						continue;
ADDRGP4 $1881
JUMPV
LABELV $1886
line 4269
;4268:					}
;4269:					trap_AAS_AreaInfo(areas[i], &areainfo);
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
line 4270
;4270:					if (areainfo.contents & AREACONTENTS_MOVER) {
ADDRLP4 2996
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $1888
line 4271
;4271:						activategoal->areas[activategoal->numareas++] = areas[i];
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
line 4272
;4272:					}
LABELV $1888
line 4273
;4273:				}
LABELV $1881
line 4263
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1883
ADDRLP4 132
INDIRI4
ADDRLP4 3048
INDIRI4
LTI4 $1880
LABELV $1882
line 4275
;4274:				// store any remaining areas
;4275:				for (i = 0; i < numareas; i++) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1893
JUMPV
LABELV $1890
line 4276
;4276:					if (activategoal->numareas >= MAX_ACTIVATEAREAS)
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
CNSTI4 32
LTI4 $1894
line 4277
;4277:						break;
ADDRGP4 $1892
JUMPV
LABELV $1894
line 4278
;4278:					if ( trap_AAS_AreaReachability(areas[i]) ) {
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
EQI4 $1896
line 4279
;4279:						continue;
ADDRGP4 $1891
JUMPV
LABELV $1896
line 4281
;4280:					}
;4281:					trap_AAS_AreaInfo(areas[i], &areainfo);
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
line 4282
;4282:					if (areainfo.contents & AREACONTENTS_MOVER) {
ADDRLP4 2996
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $1898
line 4283
;4283:						activategoal->areas[activategoal->numareas++] = areas[i];
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
line 4284
;4284:					}
LABELV $1898
line 4285
;4285:				}
LABELV $1891
line 4275
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1893
ADDRLP4 132
INDIRI4
ADDRLP4 3048
INDIRI4
LTI4 $1890
LABELV $1892
line 4286
;4286:			}
LABELV $1876
line 4287
;4287:		}
LABELV $1873
line 4288
;4288:	}
LABELV $1855
line 4290
;4289:	// if the bot is blocked by or standing on top of a button
;4290:	if (!strcmp(classname, "func_button")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1902
ARGP4
ADDRLP4 3264
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3264
INDIRI4
CNSTI4 0
NEI4 $1900
line 4291
;4291:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1900
line 4294
;4292:	}
;4293:	// get the targetname so we can find an entity with a matching target
;4294:	if (!trap_AAS_ValueForBSPEpairKey(ent, "targetname", targetname[0], sizeof(targetname[0]))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1905
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
NEI4 $1903
line 4295
;4295:		if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1906
line 4296
;4296:			BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with model \"%s\" has no targetname\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1909
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4297
;4297:		}
LABELV $1906
line 4298
;4298:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1903
line 4301
;4299:	}
;4300:	// allow tree-like activation
;4301:	cur_entities[0] = trap_AAS_NextBSPEntity(0);
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
line 4302
;4302:	for (i = 0; i >= 0 && i < 10;) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1913
JUMPV
LABELV $1910
line 4303
;4303:		for (ent = cur_entities[i]; ent; ent = trap_AAS_NextBSPEntity(ent)) {
ADDRLP4 0
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 1416
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $1917
JUMPV
LABELV $1914
line 4304
;4304:			if (!trap_AAS_ValueForBSPEpairKey(ent, "target", target, sizeof(target))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1920
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
NEI4 $1918
ADDRGP4 $1915
JUMPV
LABELV $1918
line 4305
;4305:			if (!strcmp(targetname[i], target)) {
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
NEI4 $1921
line 4306
;4306:				cur_entities[i] = trap_AAS_NextBSPEntity(ent);
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
line 4307
;4307:				break;
ADDRGP4 $1916
JUMPV
LABELV $1921
line 4309
;4308:			}
;4309:		}
LABELV $1915
line 4303
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
LABELV $1917
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1914
LABELV $1916
line 4310
;4310:		if (!ent) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1923
line 4311
;4311:			if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1925
line 4312
;4312:				BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no entity with target \"%s\"\n", targetname[i]);
CNSTI4 3
ARGI4
ADDRGP4 $1928
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
line 4313
;4313:			}
LABELV $1925
line 4314
;4314:			i--;
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 4315
;4315:			continue;
ADDRGP4 $1911
JUMPV
LABELV $1923
line 4317
;4316:		}
;4317:		if (!trap_AAS_ValueForBSPEpairKey(ent, "classname", classname, sizeof(classname))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1851
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
NEI4 $1929
line 4318
;4318:			if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1911
line 4319
;4319:				BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with target \"%s\" has no classname\n", targetname[i]);
CNSTI4 3
ARGI4
ADDRGP4 $1934
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
line 4320
;4320:			}
line 4321
;4321:			continue;
ADDRGP4 $1911
JUMPV
LABELV $1929
line 4324
;4322:		}
;4323:		// BSP button model
;4324:		if (!strcmp(classname, "func_button")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1902
ARGP4
ADDRLP4 3284
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3284
INDIRI4
CNSTI4 0
NEI4 $1935
line 4326
;4325:			//
;4326:			if (!BotFuncButtonActivateGoal(bs, ent, activategoal))
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
NEI4 $1937
line 4327
;4327:				continue;
ADDRGP4 $1911
JUMPV
LABELV $1937
line 4329
;4328:			// if the bot tries to activate this button already
;4329:			if ( bs->activatestack && bs->activatestack->inuse &&
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
EQU4 $1939
ADDRLP4 3292
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $1939
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
NEI4 $1939
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
LEF4 $1939
ADDRLP4 3292
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ADDRLP4 3300
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $1939
line 4333
;4330:				 bs->activatestack->goal.entitynum == activategoal->goal.entitynum &&
;4331:				 bs->activatestack->time > FloatTime() &&
;4332:				 bs->activatestack->start_time < FloatTime() - 2)
;4333:				continue;
ADDRGP4 $1911
JUMPV
LABELV $1939
line 4335
;4334:			// if the bot is in a reachability area
;4335:			if ( trap_AAS_AreaReachability(bs->areanum) ) {
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
EQI4 $1941
line 4337
;4336:				// disable all areas the blocking entity is in
;4337:				BotEnableActivateGoalAreas( activategoal, qfalse );
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4339
;4338:				//
;4339:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, activategoal->goal.areanum, bs->tfl);
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
line 4341
;4340:				// if the button is not reachable
;4341:				if (!t) {
ADDRLP4 2736
INDIRI4
CNSTI4 0
NEI4 $1943
line 4342
;4342:					continue;
ADDRGP4 $1911
JUMPV
LABELV $1943
line 4344
;4343:				}
;4344:				activategoal->time = FloatTime() + t * 0.01 + 5;
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
line 4345
;4345:			}
LABELV $1941
line 4346
;4346:			return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1935
line 4349
;4347:		}
;4348:		// invisible trigger multiple box
;4349:		else if (!strcmp(classname, "trigger_multiple")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1947
ARGP4
ADDRLP4 3288
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3288
INDIRI4
CNSTI4 0
NEI4 $1945
line 4351
;4350:			//
;4351:			if (!BotTriggerMultipleActivateGoal(bs, ent, activategoal))
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
NEI4 $1948
line 4352
;4352:				continue;
ADDRGP4 $1911
JUMPV
LABELV $1948
line 4354
;4353:			// if the bot tries to activate this trigger already
;4354:			if ( bs->activatestack && bs->activatestack->inuse &&
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
EQU4 $1950
ADDRLP4 3296
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $1950
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
NEI4 $1950
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
LEF4 $1950
ADDRLP4 3296
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ADDRLP4 3304
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $1950
line 4358
;4355:				 bs->activatestack->goal.entitynum == activategoal->goal.entitynum &&
;4356:				 bs->activatestack->time > FloatTime() &&
;4357:				 bs->activatestack->start_time < FloatTime() - 2)
;4358:				continue;
ADDRGP4 $1911
JUMPV
LABELV $1950
line 4360
;4359:			// if the bot is in a reachability area
;4360:			if ( trap_AAS_AreaReachability(bs->areanum) ) {
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
EQI4 $1952
line 4362
;4361:				// disable all areas the blocking entity is in
;4362:				BotEnableActivateGoalAreas( activategoal, qfalse );
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4364
;4363:				//
;4364:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, activategoal->goal.areanum, bs->tfl);
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
line 4366
;4365:				// if the trigger is not reachable
;4366:				if (!t) {
ADDRLP4 2736
INDIRI4
CNSTI4 0
NEI4 $1954
line 4367
;4367:					continue;
ADDRGP4 $1911
JUMPV
LABELV $1954
line 4369
;4368:				}
;4369:				activategoal->time = FloatTime() + t * 0.01 + 5;
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
line 4370
;4370:			}
LABELV $1952
line 4371
;4371:			return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1837
JUMPV
LABELV $1945
line 4373
;4372:		}
;4373:		else if (!strcmp(classname, "func_timer")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1958
ARGP4
ADDRLP4 3292
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3292
INDIRI4
CNSTI4 0
NEI4 $1956
line 4375
;4374:			// just skip the func_timer
;4375:			continue;
ADDRGP4 $1911
JUMPV
LABELV $1956
line 4378
;4376:		}
;4377:		// the actual button or trigger might be linked through a target_relay or target_delay
;4378:		else if (!strcmp(classname, "target_relay") || !strcmp(classname, "target_delay")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1961
ARGP4
ADDRLP4 3296
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3296
INDIRI4
CNSTI4 0
EQI4 $1963
ADDRLP4 1456
ARGP4
ADDRGP4 $1962
ARGP4
ADDRLP4 3300
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3300
INDIRI4
CNSTI4 0
NEI4 $1959
LABELV $1963
line 4379
;4379:			if (trap_AAS_ValueForBSPEpairKey(ent, "targetname", targetname[i+1], sizeof(targetname[0]))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1905
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
EQI4 $1964
line 4380
;4380:				i++;
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 4381
;4381:				cur_entities[i] = trap_AAS_NextBSPEntity(0);
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
line 4382
;4382:			}
LABELV $1964
line 4383
;4383:		}
LABELV $1959
line 4384
;4384:	}
LABELV $1911
line 4302
LABELV $1913
ADDRLP4 132
INDIRI4
CNSTI4 0
LTI4 $1967
ADDRLP4 132
INDIRI4
CNSTI4 10
LTI4 $1910
LABELV $1967
line 4388
;4385:#ifdef OBSTACLEDEBUG
;4386:	BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no valid activator for entity with target \"%s\"\n", targetname[0]);
;4387:#endif
;4388:	return 0;
CNSTI4 0
RETI4
LABELV $1837
endproc BotGetActivateGoal 3320 20
export BotGoForActivateGoal
proc BotGoForActivateGoal 144 8
line 4396
;4389:}
;4390:
;4391:/*
;4392:==================
;4393:BotGoForActivateGoal
;4394:==================
;4395:*/
;4396:int BotGoForActivateGoal(bot_state_t *bs, bot_activategoal_t *activategoal) {
line 4399
;4397:	aas_entityinfo_t activateinfo;
;4398:
;4399:	activategoal->inuse = qtrue;
ADDRFP4 4
INDIRP4
CNSTI4 1
ASGNI4
line 4400
;4400:	if (!activategoal->time)
ADDRFP4 4
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
CNSTF4 0
NEF4 $1969
line 4401
;4401:		activategoal->time = FloatTime() + 10;
ADDRFP4 4
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
LABELV $1969
line 4402
;4402:	activategoal->start_time = FloatTime();
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4403
;4403:	BotEntityInfo(activategoal->goal.entitynum, &activateinfo);
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
line 4404
;4404:	VectorCopy(activateinfo.origin, activategoal->origin);
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
ADDRLP4 0+24
INDIRB
ASGNB 12
line 4406
;4405:	//
;4406:	if (BotPushOntoActivateGoalStack(bs, activategoal)) {
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
EQI4 $1972
line 4408
;4407:		// enter the activate entity AI node
;4408:		AIEnter_Seek_ActivateEntity(bs, "BotGoForActivateGoal");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1974
ARGP4
ADDRGP4 AIEnter_Seek_ActivateEntity
CALLV
pop
line 4409
;4409:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1968
JUMPV
LABELV $1972
line 4411
;4410:	}
;4411:	else {
line 4413
;4412:		// enable any routing areas that were disabled
;4413:		BotEnableActivateGoalAreas(activategoal, qtrue);
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4414
;4414:		return qfalse;
CNSTI4 0
RETI4
LABELV $1968
endproc BotGoForActivateGoal 144 8
export BotPrintActivateGoalInfo
proc BotPrintActivateGoalInfo 296 36
line 4423
;4415:	}
;4416:}
;4417:
;4418:/*
;4419:==================
;4420:BotPrintActivateGoalInfo
;4421:==================
;4422:*/
;4423:void BotPrintActivateGoalInfo(bot_state_t *bs, bot_activategoal_t *activategoal, int bspent) {
line 4428
;4424:	char netname[MAX_NETNAME];
;4425:	char classname[128];
;4426:	char buf[128];
;4427:
;4428:	ClientName(bs->client, netname, sizeof(netname));
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
line 4429
;4429:	trap_AAS_ValueForBSPEpairKey(bspent, "classname", classname, sizeof(classname));
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1851
ARGP4
ADDRLP4 36
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4430
;4430:	if (activategoal->shoot) {
ADDRFP4 4
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1976
line 4431
;4431:		Com_sprintf(buf, sizeof(buf), "%s: I have to shoot at a %s from %1.1f %1.1f %1.1f in area %d\n",
ADDRLP4 164
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $1978
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
line 4437
;4432:						netname, classname,
;4433:						activategoal->goal.origin[0],
;4434:						activategoal->goal.origin[1],
;4435:						activategoal->goal.origin[2],
;4436:						activategoal->goal.areanum);
;4437:	}
ADDRGP4 $1977
JUMPV
LABELV $1976
line 4438
;4438:	else {
line 4439
;4439:		Com_sprintf(buf, sizeof(buf), "%s: I have to activate a %s at %1.1f %1.1f %1.1f in area %d\n",
ADDRLP4 164
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $1979
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
line 4445
;4440:						netname, classname,
;4441:						activategoal->goal.origin[0],
;4442:						activategoal->goal.origin[1],
;4443:						activategoal->goal.origin[2],
;4444:						activategoal->goal.areanum);
;4445:	}
LABELV $1977
line 4446
;4446:	trap_EA_Say(bs->client, buf);
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
line 4447
;4447:}
LABELV $1975
endproc BotPrintActivateGoalInfo 296 36
export BotRandomMove
proc BotRandomMove 32 16
line 4454
;4448:
;4449:/*
;4450:==================
;4451:BotRandomMove
;4452:==================
;4453:*/
;4454:void BotRandomMove(bot_state_t *bs, bot_moveresult_t *moveresult) {
line 4457
;4455:	vec3_t dir, angles;
;4456:
;4457:	angles[0] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 4458
;4458:	angles[1] = random() * 360;
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
line 4459
;4459:	angles[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 4460
;4460:	AngleVectors(angles, dir, NULL, NULL);
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
line 4462
;4461:
;4462:	trap_BotMoveInDirection(bs->ms, dir, 400, MOVE_WALK);
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
line 4464
;4463:
;4464:	moveresult->failure = qfalse;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 4465
;4465:	VectorCopy(dir, moveresult->movedir);
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 12
INDIRB
ASGNB 12
line 4466
;4466:}
LABELV $1980
endproc BotRandomMove 32 16
lit
align 4
LABELV $1984
byte 4 0
byte 4 0
byte 4 1065353216
export BotAIBlocked
code
proc BotAIBlocked 528 16
line 4479
;4467:
;4468:/*
;4469:==================
;4470:BotAIBlocked
;4471:
;4472:Very basic handling of bots being blocked by other entities.
;4473:Check what kind of entity is blocking the bot and try to activate
;4474:it. If that's not an option then try to walk around or over the entity.
;4475:Before the bot ends in this part of the AI it should predict which doors to
;4476:open, which buttons to activate etc.
;4477:==================
;4478:*/
;4479:void BotAIBlocked(bot_state_t *bs, bot_moveresult_t *moveresult, int activate) {
line 4481
;4480:	int movetype, bspent;
;4481:	vec3_t hordir, start, end, mins, maxs, sideward, angles, up = {0, 0, 1};
ADDRLP4 228
ADDRGP4 $1984
INDIRB
ASGNB 12
line 4486
;4482:	aas_entityinfo_t entinfo;
;4483:	bot_activategoal_t activategoal;
;4484:
;4485:	// if the bot is not blocked by anything
;4486:	if (!moveresult->blocked) {
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1985
line 4487
;4487:		bs->notblocked_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6204
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4488
;4488:		return;
ADDRGP4 $1983
JUMPV
LABELV $1985
line 4491
;4489:	}
;4490:	// if stuck in a solid area
;4491:	if ( moveresult->type == RESULTTYPE_INSOLIDAREA ) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 8
NEI4 $1987
line 4493
;4492:		// move in a random direction in the hope to get out
;4493:		BotRandomMove(bs, moveresult);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRandomMove
CALLV
pop
line 4495
;4494:		//
;4495:		return;
ADDRGP4 $1983
JUMPV
LABELV $1987
line 4498
;4496:	}
;4497:	// get info for the entity that is blocking the bot
;4498:	BotEntityInfo(moveresult->blockentity, &entinfo);
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
line 4504
;4499:#ifdef OBSTACLEDEBUG
;4500:	ClientName(bs->client, netname, sizeof(netname));
;4501:	BotAI_Print(PRT_MESSAGE, "%s: I'm blocked by model %d\n", netname, entinfo.modelindex);
;4502:#endif // OBSTACLEDEBUG
;4503:	// if blocked by a bsp model and the bot wants to activate it
;4504:	if (activate && entinfo.modelindex > 0 && entinfo.modelindex <= max_bspmodelindex) {
ADDRLP4 488
CNSTI4 0
ASGNI4
ADDRFP4 8
INDIRI4
ADDRLP4 488
INDIRI4
EQI4 $1989
ADDRLP4 40+104
INDIRI4
ADDRLP4 488
INDIRI4
LEI4 $1989
ADDRLP4 40+104
INDIRI4
ADDRGP4 max_bspmodelindex
INDIRI4
GTI4 $1989
line 4506
;4505:		// find the bsp entity which should be activated in order to get the blocking entity out of the way
;4506:		bspent = BotGetActivateGoal(bs, entinfo.number, &activategoal);
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
line 4507
;4507:		if (bspent) {
ADDRLP4 484
INDIRI4
CNSTI4 0
EQI4 $1994
line 4509
;4508:			//
;4509:			if (bs->activatestack && !bs->activatestack->inuse)
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
EQU4 $1996
ADDRLP4 496
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $1996
line 4510
;4510:				bs->activatestack = NULL;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
CNSTP4 0
ASGNP4
LABELV $1996
line 4512
;4511:			// if not already trying to activate this entity
;4512:			if (!BotIsGoingToActivateEntity(bs, activategoal.goal.entitynum)) {
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
NEI4 $1998
line 4514
;4513:				//
;4514:				BotGoForActivateGoal(bs, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 240
ARGP4
ADDRGP4 BotGoForActivateGoal
CALLI4
pop
line 4515
;4515:			}
LABELV $1998
line 4519
;4516:			// if ontop of an obstacle or
;4517:			// if the bot is not in a reachability area it'll still
;4518:			// need some dynamic obstacle avoidance, otherwise return
;4519:			if (!(moveresult->flags & MOVERESULT_ONTOPOFOBSTACLE) &&
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $1995
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
EQI4 $1995
line 4521
;4520:				trap_AAS_AreaReachability(bs->areanum))
;4521:				return;
ADDRGP4 $1983
JUMPV
line 4522
;4522:		}
LABELV $1994
line 4523
;4523:		else {
line 4525
;4524:			// enable any routing areas that were disabled
;4525:			BotEnableActivateGoalAreas(&activategoal, qtrue);
ADDRLP4 240
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4526
;4526:		}
LABELV $1995
line 4527
;4527:	}
LABELV $1989
line 4529
;4528:	// just some basic dynamic obstacle avoidance code
;4529:	hordir[0] = moveresult->movedir[0];
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ASGNF4
line 4530
;4530:	hordir[1] = moveresult->movedir[1];
ADDRLP4 0+4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ASGNF4
line 4531
;4531:	hordir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 4533
;4532:	// if no direction just take a random direction
;4533:	if (VectorNormalize(hordir) < 0.1) {
ADDRLP4 0
ARGP4
ADDRLP4 492
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 492
INDIRF4
CNSTF4 1036831949
GEF4 $2006
line 4534
;4534:		VectorSet(angles, 0, 360 * random(), 0);
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
line 4535
;4535:		AngleVectors(angles, hordir, NULL, NULL);
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
line 4536
;4536:	}
LABELV $2006
line 4540
;4537:	//
;4538:	//if (moveresult->flags & MOVERESULT_ONTOPOFOBSTACLE) movetype = MOVE_JUMP;
;4539:	//else
;4540:	movetype = MOVE_WALK;
ADDRLP4 36
CNSTI4 1
ASGNI4
line 4543
;4541:	// if there's an obstacle at the bot's feet and head then
;4542:	// the bot might be able to crouch through
;4543:	VectorCopy(bs->origin, start);
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 4544
;4544:	start[2] += 18;
ADDRLP4 24+8
ADDRLP4 24+8
INDIRF4
CNSTF4 1099956224
ADDF4
ASGNF4
line 4545
;4545:	VectorMA(start, 5, hordir, end);
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
line 4546
;4546:	VectorSet(mins, -16, -16, -24);
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
line 4547
;4547:	VectorSet(maxs, 16, 16, 4);
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
line 4552
;4548:	//
;4549:	//bsptrace = AAS_Trace(start, mins, maxs, end, bs->entitynum, MASK_PLAYERSOLID);
;4550:	//if (bsptrace.fraction >= 1) movetype = MOVE_CROUCH;
;4551:	// get the sideward vector
;4552:	CrossProduct(hordir, up, sideward);
ADDRLP4 0
ARGP4
ADDRLP4 228
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 4554
;4553:	//
;4554:	if (bs->flags & BFL_AVOIDRIGHT) VectorNegate(sideward, sideward);
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $2021
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
LABELV $2021
line 4556
;4555:	// try to crouch straight forward?
;4556:	if (movetype != MOVE_CROUCH || !trap_BotMoveInDirection(bs->ms, hordir, 400, movetype)) {
ADDRLP4 36
INDIRI4
CNSTI4 2
NEI4 $2029
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
NEI4 $2027
LABELV $2029
line 4558
;4557:		// perform the movement
;4558:		if (!trap_BotMoveInDirection(bs->ms, sideward, 400, movetype)) {
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
NEI4 $2030
line 4560
;4559:			// flip the avoid direction flag
;4560:			bs->flags ^= BFL_AVOIDRIGHT;
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
line 4563
;4561:			// flip the direction
;4562:			// VectorNegate(sideward, sideward);
;4563:			VectorMA(sideward, -1, hordir, sideward);
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
line 4565
;4564:			// move in the other direction
;4565:			trap_BotMoveInDirection(bs->ms, sideward, 400, movetype);
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
line 4566
;4566:		}
LABELV $2030
line 4567
;4567:	}
LABELV $2027
line 4569
;4568:	//
;4569:	if (bs->notblocked_time < FloatTime() - 0.4) {
ADDRFP4 0
INDIRP4
CNSTI4 6204
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1053609165
SUBF4
GEF4 $2038
line 4572
;4570:		// just reset goals and hope the bot will go into another direction?
;4571:		// is this still needed??
;4572:		if (bs->ainode == AINode_Seek_NBG) bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Seek_NBG
CVPU4 4
NEU4 $2040
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
ADDRGP4 $2041
JUMPV
LABELV $2040
line 4573
;4573:		else if (bs->ainode == AINode_Seek_LTG) bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Seek_LTG
CVPU4 4
NEU4 $2042
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
LABELV $2042
LABELV $2041
line 4574
;4574:	}
LABELV $2038
line 4575
;4575:}
LABELV $1983
endproc BotAIBlocked 528 16
export BotAIPredictObstacles
proc BotAIPredictObstacles 324 44
line 4587
;4576:
;4577:/*
;4578:==================
;4579:BotAIPredictObstacles
;4580:
;4581:Predict the route towards the goal and check if the bot
;4582:will be blocked by certain obstacles. When the bot has obstacles
;4583:on it's path the bot should figure out if they can be removed
;4584:by activating certain entities.
;4585:==================
;4586:*/
;4587:int BotAIPredictObstacles(bot_state_t *bs, bot_goal_t *goal) {
line 4592
;4588:	int modelnum, entitynum, bspent;
;4589:	bot_activategoal_t activategoal;
;4590:	aas_predictroute_t route;
;4591:
;4592:	if (!bot_predictobstacles.integer)
ADDRGP4 bot_predictobstacles+12
INDIRI4
CNSTI4 0
NEI4 $2045
line 4593
;4593:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2044
JUMPV
LABELV $2045
line 4596
;4594:
;4595:	// always predict when the goal change or at regular intervals
;4596:	if (bs->predictobstacles_goalareanum == goal->areanum &&
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
NEI4 $2048
ADDRLP4 292
INDIRP4
CNSTI4 6212
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1086324736
SUBF4
LEF4 $2048
line 4597
;4597:		bs->predictobstacles_time > FloatTime() - 6) {
line 4598
;4598:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2044
JUMPV
LABELV $2048
line 4600
;4599:	}
;4600:	bs->predictobstacles_goalareanum = goal->areanum;
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
line 4601
;4601:	bs->predictobstacles_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6212
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4604
;4602:
;4603:	// predict at most 100 areas or 10 seconds ahead
;4604:	trap_AAS_PredictRoute(&route, bs->areanum, bs->origin,
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
line 4609
;4605:							goal->areanum, bs->tfl, 100, 1000,
;4606:							RSE_USETRAVELTYPE|RSE_ENTERCONTENTS,
;4607:							AREACONTENTS_MOVER, TFL_BRIDGE, 0);
;4608:	// if bot has to travel through an area with a mover
;4609:	if (route.stopevent & RSE_ENTERCONTENTS) {
ADDRLP4 0+16
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $2050
line 4611
;4610:		// if the bot will run into a mover
;4611:		if (route.endcontents & AREACONTENTS_MOVER) {
ADDRLP4 0+20
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $2051
line 4613
;4612:			//NOTE: this only works with bspc 2.1 or higher
;4613:			modelnum = (route.endcontents & AREACONTENTS_MODELNUM) >> AREACONTENTS_MODELNUMSHIFT;
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
line 4614
;4614:			if (modelnum) {
ADDRLP4 36
INDIRI4
CNSTI4 0
EQI4 $2051
line 4616
;4615:				//
;4616:				entitynum = BotModelMinsMaxs(modelnum, ET_MOVER, 0, NULL, NULL);
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
line 4617
;4617:				if (entitynum) {
ADDRLP4 40
INDIRI4
CNSTI4 0
EQI4 $2051
line 4619
;4618:					//NOTE: BotGetActivateGoal already checks if the door is open or not
;4619:					bspent = BotGetActivateGoal(bs, entitynum, &activategoal);
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
line 4620
;4620:					if (bspent) {
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $2051
line 4622
;4621:						//
;4622:						if (bs->activatestack && !bs->activatestack->inuse)
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
EQU4 $2063
ADDRLP4 316
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2063
line 4623
;4623:							bs->activatestack = NULL;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
CNSTP4 0
ASGNP4
LABELV $2063
line 4625
;4624:						// if not already trying to activate this entity
;4625:						if (!BotIsGoingToActivateEntity(bs, activategoal.goal.entitynum)) {
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
NEI4 $2065
line 4629
;4626:							//
;4627:							//BotAI_Print(PRT_MESSAGE, "blocked by mover model %d, entity %d ?\n", modelnum, entitynum);
;4628:							//
;4629:							BotGoForActivateGoal(bs, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 48
ARGP4
ADDRGP4 BotGoForActivateGoal
CALLI4
pop
line 4630
;4630:							return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2044
JUMPV
LABELV $2065
line 4632
;4631:						}
;4632:						else {
line 4634
;4633:							// enable any routing areas that were disabled
;4634:							BotEnableActivateGoalAreas(&activategoal, qtrue);
ADDRLP4 48
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4635
;4635:						}
line 4636
;4636:					}
line 4637
;4637:				}
line 4638
;4638:			}
line 4639
;4639:		}
line 4640
;4640:	}
ADDRGP4 $2051
JUMPV
LABELV $2050
line 4641
;4641:	else if (route.stopevent & RSE_USETRAVELTYPE) {
ADDRLP4 0+16
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $2069
line 4642
;4642:		if (route.endtravelflags & TFL_BRIDGE) {
ADDRLP4 0+24
INDIRI4
CNSTI4 67108864
BANDI4
CNSTI4 0
EQI4 $2072
line 4644
;4643:			//FIXME: check if the bridge is available to travel over
;4644:		}
LABELV $2072
line 4645
;4645:	}
LABELV $2069
LABELV $2051
line 4646
;4646:	return qfalse;
CNSTI4 0
RETI4
LABELV $2044
endproc BotAIPredictObstacles 324 44
export BotCheckConsoleMessages
proc BotCheckConsoleMessages 1012 48
line 4654
;4647:}
;4648:
;4649:/*
;4650:==================
;4651:BotCheckConsoleMessages
;4652:==================
;4653:*/
;4654:void BotCheckConsoleMessages(bot_state_t *bs) {
line 4662
;4655:	char botname[MAX_NETNAME], message[MAX_MESSAGE_SIZE], netname[MAX_NETNAME], *ptr;
;4656:	float chat_reply;
;4657:	int context, handle;
;4658:	bot_consolemessage_t m;
;4659:	bot_match_t match;
;4660:
;4661:	//the name of this bot
;4662:	ClientName(bs->client, botname, sizeof(botname));
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
ADDRGP4 $2077
JUMPV
LABELV $2076
line 4664
;4663:	//
;4664:	while((handle = trap_BotNextConsoleMessage(bs->cs, &m)) != 0) {
line 4666
;4665:		//if the chat state is flooded with messages the bot will read them quickly
;4666:		if (trap_BotNumConsoleMessages(bs->cs) < 10) {
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
GEI4 $2079
line 4668
;4667:			//if it is a chat message the bot needs some time to read it
;4668:			if (m.type == CMS_CHAT && m.time > FloatTime() - (1 + random())) break;
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2081
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
LEF4 $2081
ADDRGP4 $2078
JUMPV
LABELV $2081
line 4669
;4669:		}
LABELV $2079
line 4671
;4670:		//
;4671:		ptr = m.message;
ADDRLP4 276
ADDRLP4 0+12
ASGNP4
line 4674
;4672:		//if it is a chat message then don't unify white spaces and don't
;4673:		//replace synonyms in the netname
;4674:		if (m.type == CMS_CHAT) {
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2086
line 4676
;4675:			//
;4676:			if (trap_BotFindMatch(m.message, &match, MTCONTEXT_REPLYCHAT)) {
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
EQI4 $2089
line 4677
;4677:				ptr = m.message + match.variables[MESSAGE].offset;
ADDRLP4 276
ADDRLP4 288+264+16
INDIRI1
CVII4 1
ADDRLP4 0+12
ADDP4
ASGNP4
line 4678
;4678:			}
LABELV $2089
line 4679
;4679:		}
LABELV $2086
line 4681
;4680:		//unify the white spaces in the message
;4681:		trap_UnifyWhiteSpaces(ptr);
ADDRLP4 276
INDIRP4
ARGP4
ADDRGP4 trap_UnifyWhiteSpaces
CALLV
pop
line 4683
;4682:		//replace synonyms in the right context
;4683:		context = BotSynonymContext(bs);
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
line 4684
;4684:		trap_BotReplaceSynonyms(ptr, context);
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
line 4686
;4685:		//if there's no match
;4686:		if (!BotMatchMessage(bs, m.message)) {
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
NEI4 $2095
line 4688
;4687:			//if it is a chat message
;4688:			if (m.type == CMS_CHAT && !bot_nochat.integer) {
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2098
ADDRGP4 bot_nochat+12
INDIRI4
CNSTI4 0
NEI4 $2098
line 4690
;4689:				//
;4690:				if (!trap_BotFindMatch(m.message, &match, MTCONTEXT_REPLYCHAT)) {
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
NEI4 $2102
line 4691
;4691:					trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4692
;4692:					continue;
ADDRGP4 $2077
JUMPV
LABELV $2102
line 4695
;4693:				}
;4694:				//don't use eliza chats with team messages
;4695:				if (match.subtype & ST_TEAM) {
ADDRLP4 288+260
INDIRI4
CNSTI4 32768
BANDI4
CNSTI4 0
EQI4 $2105
line 4696
;4696:					trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4697
;4697:					continue;
ADDRGP4 $2077
JUMPV
LABELV $2105
line 4700
;4698:				}
;4699:				//
;4700:				trap_BotMatchVariable(&match, NETNAME, netname, sizeof(netname));
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
line 4701
;4701:				trap_BotMatchVariable(&match, MESSAGE, message, sizeof(message));
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
line 4703
;4702:				//if this is a message from the bot self
;4703:				if (bs->client == ClientFromName(netname)) {
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
NEI4 $2108
line 4704
;4704:					trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4705
;4705:					continue;
ADDRGP4 $2077
JUMPV
LABELV $2108
line 4708
;4706:				}
;4707:				//unify the message
;4708:				trap_UnifyWhiteSpaces(message);
ADDRLP4 616
ARGP4
ADDRGP4 trap_UnifyWhiteSpaces
CALLV
pop
line 4710
;4709:				//
;4710:				trap_Cvar_Update(&bot_testrchat);
ADDRGP4 bot_testrchat
ARGP4
ADDRGP4 trap_Cvar_Update
CALLV
pop
line 4711
;4711:				if (bot_testrchat.integer) {
ADDRGP4 bot_testrchat+12
INDIRI4
CNSTI4 0
EQI4 $2110
line 4713
;4712:					//
;4713:					trap_BotLibVarSet("bot_testrchat", "1");
ADDRGP4 $2113
ARGP4
ADDRGP4 $2114
ARGP4
ADDRGP4 trap_BotLibVarSet
CALLI4
pop
line 4715
;4714:					//if bot replies with a chat message
;4715:					if (trap_BotReplyChat(bs->cs, message, context, CONTEXT_REPLY,
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
EQI4 $2115
line 4719
;4716:															NULL, NULL,
;4717:															NULL, NULL,
;4718:															NULL, NULL,
;4719:															botname, netname)) {
line 4720
;4720:						BotAI_Print(PRT_MESSAGE, "------------------------\n");
CNSTI4 1
ARGI4
ADDRGP4 $2117
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4721
;4721:					}
ADDRGP4 $2111
JUMPV
LABELV $2115
line 4722
;4722:					else {
line 4723
;4723:						BotAI_Print(PRT_MESSAGE, "**** no valid reply ****\n");
CNSTI4 1
ARGI4
ADDRGP4 $2118
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4724
;4724:					}
line 4725
;4725:				}
ADDRGP4 $2111
JUMPV
LABELV $2110
line 4727
;4726:				//if at a valid chat position and not chatting already and not in teamplay
;4727:				else if (bs->ainode != AINode_Stand && BotValidChatPosition(bs) && !TeamPlayIsOn()) {
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
EQU4 $2119
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
EQI4 $2119
ADDRLP4 976
ADDRGP4 TeamPlayIsOn
CALLI4
ASGNI4
ADDRLP4 976
INDIRI4
CNSTI4 0
NEI4 $2119
line 4728
;4728:					chat_reply = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CHAT_REPLY, 0, 1);
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
line 4729
;4729:					if (random() < 1.5 / (NumBots()+1) && random() < chat_reply) {
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
GEF4 $2121
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
GEF4 $2121
line 4731
;4730:						//if bot replies with a chat message
;4731:						if (trap_BotReplyChat(bs->cs, message, context, CONTEXT_REPLY,
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
EQI4 $2123
line 4735
;4732:																NULL, NULL,
;4733:																NULL, NULL,
;4734:																NULL, NULL,
;4735:																botname, netname)) {
line 4737
;4736:							//remove the console message
;4737:							trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4738
;4738:							bs->stand_time = FloatTime() + BotChatTime(bs);
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
line 4739
;4739:							AIEnter_Stand(bs, "BotCheckConsoleMessages: reply chat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2125
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 4741
;4740:							//EA_Say(bs->client, bs->cs.chatmessage);
;4741:							break;
ADDRGP4 $2078
JUMPV
LABELV $2123
line 4743
;4742:						}
;4743:					}
LABELV $2121
line 4744
;4744:				}
LABELV $2119
LABELV $2111
line 4745
;4745:			}
LABELV $2098
line 4746
;4746:		}
LABELV $2095
line 4748
;4747:		//remove the console message
;4748:		trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4749
;4749:	}
LABELV $2077
line 4664
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
NEI4 $2076
LABELV $2078
line 4750
;4750:}
LABELV $2075
endproc BotCheckConsoleMessages 1012 48
export BotCheckForGrenades
proc BotCheckForGrenades 8 16
line 4757
;4751:
;4752:/*
;4753:==================
;4754:BotCheckEvents
;4755:==================
;4756:*/
;4757:void BotCheckForGrenades(bot_state_t *bs, entityState_t *state) {
line 4759
;4758:	// if this is not a grenade
;4759:	if (state->eType != ET_MISSILE || state->weapon != WP_GRENADE_LAUNCHER)
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
NEI4 $2129
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $2127
LABELV $2129
line 4760
;4760:		return;
ADDRGP4 $2126
JUMPV
LABELV $2127
line 4762
;4761:	// try to avoid the grenade
;4762:	trap_BotAddAvoidSpot(bs->ms, state->pos.trBase, 160, AVOID_ALWAYS);
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
line 4763
;4763:}
LABELV $2126
endproc BotCheckForGrenades 8 16
export BotCheckEvents
proc BotCheckEvents 164 12
line 4815
;4764:
;4765:#ifdef MISSIONPACK
;4766:/*
;4767:==================
;4768:BotCheckForProxMines
;4769:==================
;4770:*/
;4771:void BotCheckForProxMines(bot_state_t *bs, entityState_t *state) {
;4772:	// if this is not a prox mine
;4773:	if (state->eType != ET_MISSILE || state->weapon != WP_PROX_LAUNCHER)
;4774:		return;
;4775:	// if this prox mine is from someone on our own team
;4776:	if (state->generic1 == BotTeam(bs))
;4777:		return;
;4778:	// if the bot doesn't have a weapon to deactivate the mine
;4779:	if (!(bs->inventory[INVENTORY_PLASMAGUN] > 0 && bs->inventory[INVENTORY_CELLS] > 0) &&
;4780:		!(bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 && bs->inventory[INVENTORY_ROCKETS] > 0) &&
;4781:		!(bs->inventory[INVENTORY_BFG10K] > 0 && bs->inventory[INVENTORY_BFGAMMO] > 0) ) {
;4782:		return;
;4783:	}
;4784:	// try to avoid the prox mine
;4785:	trap_BotAddAvoidSpot(bs->ms, state->pos.trBase, 160, AVOID_ALWAYS);
;4786:	//
;4787:	if (bs->numproxmines >= MAX_PROXMINES)
;4788:		return;
;4789:	bs->proxmines[bs->numproxmines] = state->number;
;4790:	bs->numproxmines++;
;4791:}
;4792:
;4793:/*
;4794:==================
;4795:BotCheckForKamikazeBody
;4796:==================
;4797:*/
;4798:void BotCheckForKamikazeBody(bot_state_t *bs, entityState_t *state) {
;4799:	// if this entity is not wearing the kamikaze
;4800:	if (!(state->eFlags & EF_KAMIKAZE))
;4801:		return;
;4802:	// if this entity isn't dead
;4803:	if (!(state->eFlags & EF_DEAD))
;4804:		return;
;4805:	//remember this kamikaze body
;4806:	bs->kamikazebody = state->number;
;4807:}
;4808:#endif
;4809:
;4810:/*
;4811:==================
;4812:BotCheckEvents
;4813:==================
;4814:*/
;4815:void BotCheckEvents(bot_state_t *bs, entityState_t *state) {
line 4824
;4816:	int event;
;4817:	char buf[128];
;4818:#ifdef MISSIONPACK
;4819:	aas_entityinfo_t entinfo;
;4820:#endif
;4821:
;4822:	//NOTE: this sucks, we're accessing the gentity_t directly
;4823:	//but there's no other fast way to do it right now
;4824:	if (bs->entityeventTime[state->number] == g_entities[state->number].eventTime) {
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
CNSTI4 808
ADDRLP4 132
INDIRI4
MULI4
ADDRGP4 g_entities+552
ADDP4
INDIRI4
NEI4 $2131
line 4825
;4825:		return;
ADDRGP4 $2130
JUMPV
LABELV $2131
line 4827
;4826:	}
;4827:	bs->entityeventTime[state->number] = g_entities[state->number].eventTime;
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
CNSTI4 808
ADDRLP4 136
INDIRI4
MULI4
ADDRGP4 g_entities+552
ADDP4
INDIRI4
ASGNI4
line 4829
;4828:	//if it's an event only entity
;4829:	if (state->eType > ET_EVENTS) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
LEI4 $2135
line 4830
;4830:		event = (state->eType - ET_EVENTS) & ~EV_EVENT_BITS;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
SUBI4
CNSTI4 -769
BANDI4
ASGNI4
line 4831
;4831:	}
ADDRGP4 $2136
JUMPV
LABELV $2135
line 4832
;4832:	else {
line 4833
;4833:		event = state->event & ~EV_EVENT_BITS;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 -769
BANDI4
ASGNI4
line 4834
;4834:	}
LABELV $2136
line 4836
;4835:	//
;4836:	switch(event) {
ADDRLP4 140
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 1
LTI4 $2137
ADDRLP4 140
INDIRI4
CNSTI4 76
GTI4 $2137
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $2186-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $2186
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2138
address $2137
address $2137
address $2137
address $2171
address $2137
address $2137
address $2172
address $2150
address $2158
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2139
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2137
address $2138
code
LABELV $2139
line 4839
;4837:		//client obituary event
;4838:		case EV_OBITUARY:
;4839:		{
line 4842
;4840:			int target, attacker, mod;
;4841:
;4842:			target = state->otherEntityNum;
ADDRLP4 144
ADDRFP4 4
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 4843
;4843:			attacker = state->otherEntityNum2;
ADDRLP4 148
ADDRFP4 4
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 4844
;4844:			mod = state->eventParm;
ADDRLP4 152
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 4846
;4845:			//
;4846:			if (target == bs->client) {
ADDRLP4 144
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2140
line 4847
;4847:				bs->botdeathtype = mod;
ADDRFP4 0
INDIRP4
CNSTI4 6000
ADDP4
ADDRLP4 152
INDIRI4
ASGNI4
line 4848
;4848:				bs->lastkilledby = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 5996
ADDP4
ADDRLP4 148
INDIRI4
ASGNI4
line 4850
;4849:				//
;4850:				if (target == attacker ||
ADDRLP4 156
ADDRLP4 144
INDIRI4
ASGNI4
ADDRLP4 156
INDIRI4
ADDRLP4 148
INDIRI4
EQI4 $2145
ADDRLP4 156
INDIRI4
CNSTI4 1023
EQI4 $2145
ADDRLP4 156
INDIRI4
CNSTI4 1022
NEI4 $2142
LABELV $2145
line 4852
;4851:					target == ENTITYNUM_NONE ||
;4852:					target == ENTITYNUM_WORLD) bs->botsuicide = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6008
ADDP4
CNSTI4 1
ASGNI4
ADDRGP4 $2143
JUMPV
LABELV $2142
line 4853
;4853:				else bs->botsuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6008
ADDP4
CNSTI4 0
ASGNI4
LABELV $2143
line 4855
;4854:				//
;4855:				bs->num_deaths++;
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
line 4856
;4856:			}
ADDRGP4 $2138
JUMPV
LABELV $2140
line 4858
;4857:			//else if this client was killed by the bot
;4858:			else if (attacker == bs->client) {
ADDRLP4 148
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2146
line 4859
;4859:				bs->enemydeathtype = mod;
ADDRFP4 0
INDIRP4
CNSTI4 6004
ADDP4
ADDRLP4 152
INDIRI4
ASGNI4
line 4860
;4860:				bs->lastkilledplayer = target;
ADDRFP4 0
INDIRP4
CNSTI4 5992
ADDP4
ADDRLP4 144
INDIRI4
ASGNI4
line 4861
;4861:				bs->killedenemy_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6168
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4863
;4862:				//
;4863:				bs->num_kills++;
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
line 4864
;4864:			}
ADDRGP4 $2138
JUMPV
LABELV $2146
line 4865
;4865:			else if (attacker == bs->enemy && target == attacker) {
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
NEI4 $2138
ADDRLP4 144
INDIRI4
ADDRLP4 156
INDIRI4
NEI4 $2138
line 4866
;4866:				bs->enemysuicide = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 1
ASGNI4
line 4867
;4867:			}
line 4881
;4868:			//
;4869:#ifdef MISSIONPACK			
;4870:			if (gametype == GT_1FCTF) {
;4871:				//
;4872:				BotEntityInfo(target, &entinfo);
;4873:				if ( entinfo.powerups & ( 1 << PW_NEUTRALFLAG ) ) {
;4874:					if (!BotSameTeam(bs, target)) {
;4875:						bs->neutralflagstatus = 3;	//enemy dropped the flag
;4876:						bs->flagstatuschanged = qtrue;
;4877:					}
;4878:				}
;4879:			}
;4880:#endif
;4881:			break;
ADDRGP4 $2138
JUMPV
LABELV $2150
line 4884
;4882:		}
;4883:		case EV_GLOBAL_SOUND:
;4884:		{
line 4885
;4885:			if (state->eventParm < 0 || state->eventParm > MAX_SOUNDS) {
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
LTI4 $2153
ADDRLP4 144
INDIRI4
CNSTI4 256
LEI4 $2151
LABELV $2153
line 4886
;4886:				BotAI_Print(PRT_ERROR, "EV_GLOBAL_SOUND: eventParm (%d) out of range\n", state->eventParm);
CNSTI4 3
ARGI4
ADDRGP4 $2154
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
line 4887
;4887:				break;
ADDRGP4 $2138
JUMPV
LABELV $2151
line 4889
;4888:			}
;4889:			trap_GetConfigstring(CS_SOUNDS + state->eventParm, buf, sizeof(buf));
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
line 4909
;4890:			/*
;4891:			if (!strcmp(buf, "sound/teamplay/flagret_red.wav")) {
;4892:				//red flag is returned
;4893:				bs->redflagstatus = 0;
;4894:				bs->flagstatuschanged = qtrue;
;4895:			}
;4896:			else if (!strcmp(buf, "sound/teamplay/flagret_blu.wav")) {
;4897:				//blue flag is returned
;4898:				bs->blueflagstatus = 0;
;4899:				bs->flagstatuschanged = qtrue;
;4900:			}
;4901:			else*/
;4902:#ifdef MISSIONPACK
;4903:			if (!strcmp(buf, "sound/items/kamikazerespawn.wav" )) {
;4904:				//the kamikaze respawned so dont avoid it
;4905:				BotDontAvoid(bs, "Kamikaze");
;4906:			}
;4907:			else
;4908:#endif
;4909:				if (!strcmp(buf, "sound/items/poweruprespawn.wav")) {
ADDRLP4 4
ARGP4
ADDRGP4 $2157
ARGP4
ADDRLP4 148
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2138
line 4911
;4910:				//powerup respawned... go get it
;4911:				BotGoForPowerups(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotGoForPowerups
CALLV
pop
line 4912
;4912:			}
line 4913
;4913:			break;
ADDRGP4 $2138
JUMPV
LABELV $2158
line 4916
;4914:		}
;4915:		case EV_GLOBAL_TEAM_SOUND:
;4916:		{
line 4917
;4917:			if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $2138
line 4918
;4918:				switch(state->eventParm) {
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
LTI4 $2138
ADDRLP4 144
INDIRI4
CNSTI4 5
GTI4 $2138
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $2170
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $2170
address $2164
address $2165
address $2166
address $2167
address $2168
address $2169
code
LABELV $2164
line 4920
;4919:					case GTS_RED_CAPTURE:
;4920:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 4921
;4921:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 4922
;4922:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4923
;4923:						break; //see BotMatch_CTF
ADDRGP4 $2138
JUMPV
LABELV $2165
line 4925
;4924:					case GTS_BLUE_CAPTURE:
;4925:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 4926
;4926:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 4927
;4927:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4928
;4928:						break; //see BotMatch_CTF
ADDRGP4 $2138
JUMPV
LABELV $2166
line 4931
;4929:					case GTS_RED_RETURN:
;4930:						//blue flag is returned
;4931:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 4932
;4932:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4933
;4933:						break;
ADDRGP4 $2138
JUMPV
LABELV $2167
line 4936
;4934:					case GTS_BLUE_RETURN:
;4935:						//red flag is returned
;4936:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 4937
;4937:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4938
;4938:						break;
ADDRGP4 $2138
JUMPV
LABELV $2168
line 4941
;4939:					case GTS_RED_TAKEN:
;4940:						//blue flag is taken
;4941:						bs->blueflagstatus = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 1
ASGNI4
line 4942
;4942:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4943
;4943:						break; //see BotMatch_CTF
ADDRGP4 $2138
JUMPV
LABELV $2169
line 4946
;4944:					case GTS_BLUE_TAKEN:
;4945:						//red flag is taken
;4946:						bs->redflagstatus = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 1
ASGNI4
line 4947
;4947:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4948
;4948:						break; //see BotMatch_CTF
line 4950
;4949:				}
;4950:			}
line 4983
;4951:#ifdef MISSIONPACK
;4952:			else if (gametype == GT_1FCTF) {
;4953:				switch(state->eventParm) {
;4954:					case GTS_RED_CAPTURE:
;4955:						bs->neutralflagstatus = 0;
;4956:						bs->flagstatuschanged = qtrue;
;4957:						break;
;4958:					case GTS_BLUE_CAPTURE:
;4959:						bs->neutralflagstatus = 0;
;4960:						bs->flagstatuschanged = qtrue;
;4961:						break;
;4962:					case GTS_RED_RETURN:
;4963:						//flag has returned
;4964:						bs->neutralflagstatus = 0;
;4965:						bs->flagstatuschanged = qtrue;
;4966:						break;
;4967:					case GTS_BLUE_RETURN:
;4968:						//flag has returned
;4969:						bs->neutralflagstatus = 0;
;4970:						bs->flagstatuschanged = qtrue;
;4971:						break;
;4972:					case GTS_RED_TAKEN:
;4973:						bs->neutralflagstatus = BotTeam(bs) == TEAM_RED ? 2 : 1; //FIXME: check Team_TakeFlagSound in g_team.c
;4974:						bs->flagstatuschanged = qtrue;
;4975:						break;
;4976:					case GTS_BLUE_TAKEN:
;4977:						bs->neutralflagstatus = BotTeam(bs) == TEAM_BLUE ? 2 : 1; //FIXME: check Team_TakeFlagSound in g_team.c
;4978:						bs->flagstatuschanged = qtrue;
;4979:						break;
;4980:				}
;4981:			}
;4982:#endif
;4983:			break;
ADDRGP4 $2138
JUMPV
LABELV $2171
line 4986
;4984:		}
;4985:		case EV_PLAYER_TELEPORT_IN:
;4986:		{
line 4987
;4987:			VectorCopy(state->origin, lastteleport_origin);
ADDRGP4 lastteleport_origin
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 4988
;4988:			lastteleport_time = FloatTime();
ADDRGP4 lastteleport_time
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4989
;4989:			break;
ADDRGP4 $2138
JUMPV
LABELV $2172
line 4992
;4990:		}
;4991:		case EV_GENERAL_SOUND:
;4992:		{
line 4994
;4993:			//if this sound is played on the bot
;4994:			if (state->number == bs->client) {
ADDRFP4 4
INDIRP4
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2138
line 4995
;4995:				if (state->eventParm < 0 || state->eventParm > MAX_SOUNDS) {
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
LTI4 $2177
ADDRLP4 144
INDIRI4
CNSTI4 256
LEI4 $2175
LABELV $2177
line 4996
;4996:					BotAI_Print(PRT_ERROR, "EV_GENERAL_SOUND: eventParm (%d) out of range\n", state->eventParm);
CNSTI4 3
ARGI4
ADDRGP4 $2178
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
line 4997
;4997:					break;
ADDRGP4 $2138
JUMPV
LABELV $2175
line 5000
;4998:				}
;4999:				//check out the sound
;5000:				trap_GetConfigstring(CS_SOUNDS + state->eventParm, buf, sizeof(buf));
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
line 5002
;5001:				//if falling into a death pit
;5002:				if (!strcmp(buf, "*falling1.wav")) {
ADDRLP4 4
ARGP4
ADDRGP4 $2181
ARGP4
ADDRLP4 148
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2138
line 5004
;5003:					//if the bot has a personal teleporter
;5004:					if (bs->inventory[INVENTORY_TELEPORTER] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5072
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2138
line 5006
;5005:						//use the holdable item
;5006:						trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 5007
;5007:					}
line 5008
;5008:				}
line 5009
;5009:			}
line 5010
;5010:			break;
line 5037
;5011:		}
;5012:		case EV_FOOTSTEP:
;5013:		case EV_FOOTSTEP_METAL:
;5014:		case EV_FOOTSPLASH:
;5015:		case EV_FOOTWADE:
;5016:		case EV_SWIM:
;5017:		case EV_FALL_SHORT:
;5018:		case EV_FALL_MEDIUM:
;5019:		case EV_FALL_FAR:
;5020:		case EV_STEP_4:
;5021:		case EV_STEP_8:
;5022:		case EV_STEP_12:
;5023:		case EV_STEP_16:
;5024:		case EV_JUMP_PAD:
;5025:		case EV_JUMP:
;5026:		case EV_TAUNT:
;5027:		case EV_WATER_TOUCH:
;5028:		case EV_WATER_LEAVE:
;5029:		case EV_WATER_UNDER:
;5030:		case EV_WATER_CLEAR:
;5031:		case EV_ITEM_PICKUP:
;5032:		case EV_GLOBAL_ITEM_PICKUP:
;5033:		case EV_NOAMMO:
;5034:		case EV_CHANGE_WEAPON:
;5035:		case EV_FIRE_WEAPON:
;5036:			//FIXME: either add to sound queue or mark player as someone making noise
;5037:			break;
line 5053
;5038:		case EV_USE_ITEM0:
;5039:		case EV_USE_ITEM1:
;5040:		case EV_USE_ITEM2:
;5041:		case EV_USE_ITEM3:
;5042:		case EV_USE_ITEM4:
;5043:		case EV_USE_ITEM5:
;5044:		case EV_USE_ITEM6:
;5045:		case EV_USE_ITEM7:
;5046:		case EV_USE_ITEM8:
;5047:		case EV_USE_ITEM9:
;5048:		case EV_USE_ITEM10:
;5049:		case EV_USE_ITEM11:
;5050:		case EV_USE_ITEM12:
;5051:		case EV_USE_ITEM13:
;5052:		case EV_USE_ITEM14:
;5053:			break;
LABELV $2137
LABELV $2138
line 5055
;5054:	}
;5055:}
LABELV $2130
endproc BotCheckEvents 164 12
export BotCheckSnapshot
proc BotCheckSnapshot 216 16
line 5062
;5056:
;5057:/*
;5058:==================
;5059:BotCheckSnapshot
;5060:==================
;5061:*/
;5062:void BotCheckSnapshot(bot_state_t *bs) {
line 5067
;5063:	int ent;
;5064:	entityState_t state;
;5065:
;5066:	//remove all avoid spots
;5067:	trap_BotAddAvoidSpot(bs->ms, vec3_origin, 0, AVOID_CLEAR);
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
line 5069
;5068:	//reset kamikaze body
;5069:	bs->kamikazebody = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6256
ADDP4
CNSTI4 0
ASGNI4
line 5071
;5070:	//reset number of proxmines
;5071:	bs->numproxmines = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6516
ADDP4
CNSTI4 0
ASGNI4
line 5073
;5072:	//
;5073:	ent = 0;
ADDRLP4 208
CNSTI4 0
ASGNI4
ADDRGP4 $2190
JUMPV
LABELV $2189
line 5074
;5074:	while( ( ent = BotAI_GetSnapshotEntity( bs->client, ent, &state ) ) != -1 ) {
line 5076
;5075:		//check the entity state for events
;5076:		BotCheckEvents(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckEvents
CALLV
pop
line 5078
;5077:		//check for grenades the bot should avoid
;5078:		BotCheckForGrenades(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckForGrenades
CALLV
pop
line 5086
;5079:		//
;5080:#ifdef MISSIONPACK
;5081:		//check for proximity mines which the bot should deactivate
;5082:		BotCheckForProxMines(bs, &state);
;5083:		//check for dead bodies with the kamikaze effect which should be gibbed
;5084:		BotCheckForKamikazeBody(bs, &state);
;5085:#endif
;5086:	}
LABELV $2190
line 5074
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
NEI4 $2189
line 5088
;5087:	//check the player state for events
;5088:	BotAI_GetEntityState(bs->client, &state);
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
line 5090
;5089:	//copy the player state events to the entity state
;5090:	state.event = bs->cur_ps.externalEvent;
ADDRLP4 0+180
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 5091
;5091:	state.eventParm = bs->cur_ps.externalEventParm;
ADDRLP4 0+184
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
ASGNI4
line 5093
;5092:	//
;5093:	BotCheckEvents(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckEvents
CALLV
pop
line 5094
;5094:}
LABELV $2188
endproc BotCheckSnapshot 216 16
export BotCheckAir
proc BotCheckAir 4 4
line 5101
;5095:
;5096:/*
;5097:==================
;5098:BotCheckAir
;5099:==================
;5100:*/
;5101:void BotCheckAir(bot_state_t *bs) {
line 5102
;5102:	if (bs->inventory[INVENTORY_ENVIRONMENTSUIT] <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5096
ADDP4
INDIRI4
CNSTI4 0
GTI4 $2195
line 5103
;5103:		if (trap_AAS_PointContents(bs->eye) & (CONTENTS_WATER|CONTENTS_SLIME|CONTENTS_LAVA)) {
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
EQI4 $2197
line 5104
;5104:			return;
ADDRGP4 $2194
JUMPV
LABELV $2197
line 5106
;5105:		}
;5106:	}
LABELV $2195
line 5107
;5107:	bs->lastair_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6176
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5108
;5108:}
LABELV $2194
endproc BotCheckAir 4 4
export BotAlternateRoute
proc BotAlternateRoute 16 16
line 5115
;5109:
;5110:/*
;5111:==================
;5112:BotAlternateRoute
;5113:==================
;5114:*/
;5115:bot_goal_t *BotAlternateRoute(bot_state_t *bs, bot_goal_t *goal) {
line 5119
;5116:	int t;
;5117:
;5118:	// if the bot has an alternative route goal
;5119:	if (bs->altroutegoal.areanum) {
ADDRFP4 0
INDIRP4
CNSTI4 6692
ADDP4
INDIRI4
CNSTI4 0
EQI4 $2200
line 5121
;5120:		//
;5121:		if (bs->reachedaltroutegoal_time)
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
INDIRF4
CNSTF4 0
EQF4 $2202
line 5122
;5122:			return goal;
ADDRFP4 4
INDIRP4
RETP4
ADDRGP4 $2199
JUMPV
LABELV $2202
line 5124
;5123:		// travel time towards alternative route goal
;5124:		t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, bs->altroutegoal.areanum, bs->tfl);
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
line 5125
;5125:		if (t && t < 20) {
ADDRLP4 12
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $2204
ADDRLP4 12
INDIRI4
CNSTI4 20
GEI4 $2204
line 5127
;5126:			//BotAI_Print(PRT_MESSAGE, "reached alternate route goal\n");
;5127:			bs->reachedaltroutegoal_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5128
;5128:		}
LABELV $2204
line 5129
;5129:		memcpy(goal, &bs->altroutegoal, sizeof(bot_goal_t));
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
line 5130
;5130:		return &bs->altroutegoal;
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
RETP4
ADDRGP4 $2199
JUMPV
LABELV $2200
line 5132
;5131:	}
;5132:	return goal;
ADDRFP4 4
INDIRP4
RETP4
LABELV $2199
endproc BotAlternateRoute 16 16
export BotGetAlternateRouteGoal
proc BotGetAlternateRouteGoal 24 0
line 5140
;5133:}
;5134:
;5135:/*
;5136:==================
;5137:BotGetAlternateRouteGoal
;5138:==================
;5139:*/
;5140:int BotGetAlternateRouteGoal(bot_state_t *bs, int base) {
line 5145
;5141:	aas_altroutegoal_t *altroutegoals;
;5142:	bot_goal_t *goal;
;5143:	int numaltroutegoals, rnd;
;5144:
;5145:	if (base == TEAM_RED) {
ADDRFP4 4
INDIRI4
CNSTI4 1
NEI4 $2207
line 5146
;5146:		altroutegoals = red_altroutegoals;
ADDRLP4 12
ADDRGP4 red_altroutegoals
ASGNP4
line 5147
;5147:		numaltroutegoals = red_numaltroutegoals;
ADDRLP4 4
ADDRGP4 red_numaltroutegoals
INDIRI4
ASGNI4
line 5148
;5148:	}
ADDRGP4 $2208
JUMPV
LABELV $2207
line 5149
;5149:	else {
line 5150
;5150:		altroutegoals = blue_altroutegoals;
ADDRLP4 12
ADDRGP4 blue_altroutegoals
ASGNP4
line 5151
;5151:		numaltroutegoals = blue_numaltroutegoals;
ADDRLP4 4
ADDRGP4 blue_numaltroutegoals
INDIRI4
ASGNI4
line 5152
;5152:	}
LABELV $2208
line 5153
;5153:	if (!numaltroutegoals)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2209
line 5154
;5154:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2206
JUMPV
LABELV $2209
line 5155
;5155:	rnd = (float) random() * numaltroutegoals;
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
line 5156
;5156:	if (rnd >= numaltroutegoals)
ADDRLP4 8
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $2211
line 5157
;5157:		rnd = numaltroutegoals-1;
ADDRLP4 8
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $2211
line 5158
;5158:	goal = &bs->altroutegoal;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
ASGNP4
line 5159
;5159:	goal->areanum = altroutegoals[rnd].areanum;
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
line 5160
;5160:	VectorCopy(altroutegoals[rnd].origin, goal->origin);
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
line 5161
;5161:	VectorSet(goal->mins, -8, -8, -8);
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
line 5162
;5162:	VectorSet(goal->maxs, 8, 8, 8);
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
line 5163
;5163:	goal->entitynum = 0;
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTI4 0
ASGNI4
line 5164
;5164:	goal->iteminfo = 0;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 5165
;5165:	goal->number = 0;
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTI4 0
ASGNI4
line 5166
;5166:	goal->flags = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 5168
;5167:	//
;5168:	bs->reachedaltroutegoal_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
CNSTF4 0
ASGNF4
line 5169
;5169:	return qtrue;
CNSTI4 1
RETI4
LABELV $2206
endproc BotGetAlternateRouteGoal 24 0
export BotSetupAlternativeRouteGoals
proc BotSetupAlternativeRouteGoals 0 0
line 5177
;5170:}
;5171:
;5172:/*
;5173:==================
;5174:BotSetupAlternateRouteGoals
;5175:==================
;5176:*/
;5177:void BotSetupAlternativeRouteGoals(void) {
line 5179
;5178:
;5179:	if (altroutegoals_setup)
ADDRGP4 altroutegoals_setup
INDIRI4
CNSTI4 0
EQI4 $2214
line 5180
;5180:		return;
ADDRGP4 $2213
JUMPV
LABELV $2214
line 5249
;5181:#ifdef MISSIONPACK
;5182:	if (gametype == GT_CTF) {
;5183:		if (trap_BotGetLevelItemGoal(-1, "Neutral Flag", &ctf_neutralflag) < 0)
;5184:			BotAI_Print(PRT_WARNING, "no alt routes without Neutral Flag\n");
;5185:		if (ctf_neutralflag.areanum) {
;5186:			//
;5187:			red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5188:										ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5189:										ctf_redflag.origin, ctf_redflag.areanum, TFL_DEFAULT,
;5190:										red_altroutegoals, MAX_ALTROUTEGOALS,
;5191:										ALTROUTEGOAL_CLUSTERPORTALS|
;5192:										ALTROUTEGOAL_VIEWPORTALS);
;5193:			blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5194:										ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5195:										ctf_blueflag.origin, ctf_blueflag.areanum, TFL_DEFAULT,
;5196:										blue_altroutegoals, MAX_ALTROUTEGOALS,
;5197:										ALTROUTEGOAL_CLUSTERPORTALS|
;5198:										ALTROUTEGOAL_VIEWPORTALS);
;5199:		}
;5200:	}
;5201:	else if (gametype == GT_1FCTF) {
;5202:		//
;5203:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5204:									ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5205:									ctf_redflag.origin, ctf_redflag.areanum, TFL_DEFAULT,
;5206:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5207:									ALTROUTEGOAL_CLUSTERPORTALS|
;5208:									ALTROUTEGOAL_VIEWPORTALS);
;5209:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5210:									ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5211:									ctf_blueflag.origin, ctf_blueflag.areanum, TFL_DEFAULT,
;5212:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5213:									ALTROUTEGOAL_CLUSTERPORTALS|
;5214:									ALTROUTEGOAL_VIEWPORTALS);
;5215:	}
;5216:	else if (gametype == GT_OBELISK) {
;5217:		if (trap_BotGetLevelItemGoal(-1, "Neutral Obelisk", &neutralobelisk) < 0)
;5218:			BotAI_Print(PRT_WARNING, "Harvester without neutral obelisk\n");
;5219:		//
;5220:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5221:									neutralobelisk.origin, neutralobelisk.areanum,
;5222:									redobelisk.origin, redobelisk.areanum, TFL_DEFAULT,
;5223:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5224:									ALTROUTEGOAL_CLUSTERPORTALS|
;5225:									ALTROUTEGOAL_VIEWPORTALS);
;5226:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5227:									neutralobelisk.origin, neutralobelisk.areanum,
;5228:									blueobelisk.origin, blueobelisk.areanum, TFL_DEFAULT,
;5229:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5230:									ALTROUTEGOAL_CLUSTERPORTALS|
;5231:									ALTROUTEGOAL_VIEWPORTALS);
;5232:	}
;5233:	else if (gametype == GT_HARVESTER) {
;5234:		//
;5235:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5236:									neutralobelisk.origin, neutralobelisk.areanum,
;5237:									redobelisk.origin, redobelisk.areanum, TFL_DEFAULT,
;5238:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5239:									ALTROUTEGOAL_CLUSTERPORTALS|
;5240:									ALTROUTEGOAL_VIEWPORTALS);
;5241:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5242:									neutralobelisk.origin, neutralobelisk.areanum,
;5243:									blueobelisk.origin, blueobelisk.areanum, TFL_DEFAULT,
;5244:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5245:									ALTROUTEGOAL_CLUSTERPORTALS|
;5246:									ALTROUTEGOAL_VIEWPORTALS);
;5247:	}
;5248:#endif
;5249:	altroutegoals_setup = qtrue;
ADDRGP4 altroutegoals_setup
CNSTI4 1
ASGNI4
line 5250
;5250:}
LABELV $2213
endproc BotSetupAlternativeRouteGoals 0 0
export BotDeathmatchAI
proc BotDeathmatchAI 1492 20
line 5257
;5251:
;5252:/*
;5253:==================
;5254:BotDeathmatchAI
;5255:==================
;5256:*/
;5257:void BotDeathmatchAI(bot_state_t *bs, float thinktime) {
line 5263
;5258:	char gender[144], name[144], buf[144];
;5259:	char userinfo[MAX_INFO_STRING];
;5260:	int i;
;5261:
;5262:	//if the bot has just been setup
;5263:	if (bs->setupcount > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2217
line 5264
;5264:		bs->setupcount--;
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
line 5265
;5265:		if (bs->setupcount > 0) return;
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2219
ADDRGP4 $2216
JUMPV
LABELV $2219
line 5267
;5266:		//get the gender characteristic
;5267:		trap_Characteristic_String(bs->character, CHARACTERISTIC_GENDER, gender, sizeof(gender));
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
line 5269
;5268:		//set the bot gender
;5269:		trap_GetUserinfo(bs->client, userinfo, sizeof(userinfo));
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
line 5270
;5270:		Info_SetValueForKey(userinfo, "sex", gender);
ADDRLP4 292
ARGP4
ADDRGP4 $2221
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 Info_SetValueForKey
CALLV
pop
line 5271
;5271:		trap_SetUserinfo(bs->client, userinfo);
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
line 5273
;5272:		//set the team
;5273:		if ( !bs->map_restart && g_gametype.integer != GT_TOURNAMENT ) {
ADDRFP4 0
INDIRP4
CNSTI4 6020
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2222
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 1
EQI4 $2222
line 5274
;5274:			Com_sprintf(buf, sizeof(buf), "team %s", bs->settings.team);
ADDRLP4 1316
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 $2225
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 4756
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 5275
;5275:			trap_EA_Command(bs->client, buf);
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
line 5276
;5276:		}
LABELV $2222
line 5278
;5277:		//set the chat gender
;5278:		if (gender[0] == 'm') trap_BotSetChatGender(bs->cs, CHAT_GENDERMALE);
ADDRLP4 148
INDIRI1
CVII4 1
CNSTI4 109
NEI4 $2226
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
ADDRGP4 $2227
JUMPV
LABELV $2226
line 5279
;5279:		else if (gender[0] == 'f')  trap_BotSetChatGender(bs->cs, CHAT_GENDERFEMALE);
ADDRLP4 148
INDIRI1
CVII4 1
CNSTI4 102
NEI4 $2228
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
ADDRGP4 $2229
JUMPV
LABELV $2228
line 5280
;5280:		else  trap_BotSetChatGender(bs->cs, CHAT_GENDERLESS);
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
LABELV $2229
LABELV $2227
line 5282
;5281:		//set the chat name
;5282:		ClientName(bs->client, name, sizeof(name));
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
line 5283
;5283:		trap_BotSetChatName(bs->cs, name, bs->client);
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
line 5285
;5284:		//
;5285:		bs->lastframe_health = bs->inventory[INVENTORY_HEALTH];
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
line 5286
;5286:		bs->lasthitcount = bs->cur_ps.persistant[PERS_HITS];
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
line 5288
;5287:		//
;5288:		bs->setupcount = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
CNSTI4 0
ASGNI4
line 5290
;5289:		//
;5290:		BotSetupAlternativeRouteGoals();
ADDRGP4 BotSetupAlternativeRouteGoals
CALLV
pop
line 5291
;5291:	}
LABELV $2217
line 5293
;5292:	//no ideal view set
;5293:	bs->flags &= ~BFL_IDEALVIEWSET;
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
line 5295
;5294:	//
;5295:	if (!BotIntermission(bs)) {
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
NEI4 $2230
line 5297
;5296:		//set the teleport time
;5297:		BotSetTeleportTime(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeleportTime
CALLV
pop
line 5299
;5298:		//update some inventory values
;5299:		BotUpdateInventory(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotUpdateInventory
CALLV
pop
line 5301
;5300:		//check out the snapshot
;5301:		BotCheckSnapshot(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckSnapshot
CALLV
pop
line 5303
;5302:		//check for air
;5303:		BotCheckAir(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckAir
CALLV
pop
line 5304
;5304:	}
LABELV $2230
line 5306
;5305:	//check the console messages
;5306:	BotCheckConsoleMessages(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckConsoleMessages
CALLV
pop
line 5308
;5307:	//if not in the intermission and not in observer mode
;5308:	if (!BotIntermission(bs) && !BotIsObserver(bs)) {
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
NEI4 $2232
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
NEI4 $2232
line 5310
;5309:		//do team AI
;5310:		BotTeamAI(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotTeamAI
CALLV
pop
line 5311
;5311:	}
LABELV $2232
line 5313
;5312:	//if the bot has no ai node
;5313:	if (!bs->ainode) {
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $2234
line 5314
;5314:		AIEnter_Seek_LTG(bs, "BotDeathmatchAI: no ai node");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2236
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 5315
;5315:	}
LABELV $2234
line 5317
;5316:	//if the bot entered the game less than 8 seconds ago
;5317:	if (!bs->entergamechat && bs->entergame_time > FloatTime() - 8) {
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
NEI4 $2237
ADDRLP4 1476
INDIRP4
CNSTI4 6064
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1090519040
SUBF4
LEF4 $2237
line 5318
;5318:		if (BotChat_EnterGame(bs)) {
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
EQI4 $2239
line 5319
;5319:			bs->stand_time = FloatTime() + BotChatTime(bs);
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
line 5320
;5320:			AIEnter_Stand(bs, "BotDeathmatchAI: chat enter game");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2241
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 5321
;5321:		}
LABELV $2239
line 5322
;5322:		bs->entergamechat = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6024
ADDP4
CNSTI4 1
ASGNI4
line 5323
;5323:	}
LABELV $2237
line 5325
;5324:	//reset the node switches from the previous frame
;5325:	BotResetNodeSwitches();
ADDRGP4 BotResetNodeSwitches
CALLV
pop
line 5327
;5326:	//execute AI nodes
;5327:	for (i = 0; i < MAX_NODESWITCHES; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $2242
line 5328
;5328:		if (bs->ainode(bs)) break;
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
EQI4 $2246
ADDRGP4 $2244
JUMPV
LABELV $2246
line 5329
;5329:	}
LABELV $2243
line 5327
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 50
LTI4 $2242
LABELV $2244
line 5331
;5330:	//if the bot removed itself :)
;5331:	if (!bs->inuse) return;
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2248
ADDRGP4 $2216
JUMPV
LABELV $2248
line 5333
;5332:	//if the bot executed too many AI nodes
;5333:	if (i >= MAX_NODESWITCHES) {
ADDRLP4 0
INDIRI4
CNSTI4 50
LTI4 $2250
line 5334
;5334:		trap_BotDumpGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotDumpGoalStack
CALLV
pop
line 5335
;5335:		trap_BotDumpAvoidGoals(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotDumpAvoidGoals
CALLV
pop
line 5336
;5336:		BotDumpNodeSwitches(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotDumpNodeSwitches
CALLV
pop
line 5337
;5337:		ClientName(bs->client, name, sizeof(name));
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
line 5338
;5338:		BotAI_Print(PRT_ERROR, "%s at %1.1f switched more than %d AI nodes\n", name, FloatTime(), MAX_NODESWITCHES);
CNSTI4 3
ARGI4
ADDRGP4 $2252
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
line 5339
;5339:	}
LABELV $2250
line 5341
;5340:	//
;5341:	bs->lastframe_health = bs->inventory[INVENTORY_HEALTH];
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
line 5342
;5342:	bs->lasthitcount = bs->cur_ps.persistant[PERS_HITS];
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
line 5343
;5343:}
LABELV $2216
endproc BotDeathmatchAI 1492 20
export BotSetEntityNumForGoalWithModel
proc BotSetEntityNumForGoalWithModel 44 4
line 5350
;5344:
;5345:/*
;5346:==================
;5347:BotSetEntityNumForGoalWithModel
;5348:==================
;5349:*/
;5350:void BotSetEntityNumForGoalWithModel(bot_goal_t *goal, int eType, char *modelname) {
line 5355
;5351:	gentity_t *ent;
;5352:	int i, modelindex;
;5353:	vec3_t dir;
;5354:
;5355:	modelindex = G_ModelIndex( modelname );
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
line 5356
;5356:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 5357
;5357:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $2257
JUMPV
LABELV $2254
line 5358
;5358:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2259
line 5359
;5359:			continue;
ADDRGP4 $2255
JUMPV
LABELV $2259
line 5361
;5360:		}
;5361:		if ( eType && ent->s.eType != eType) {
ADDRLP4 28
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
EQI4 $2261
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $2261
line 5362
;5362:			continue;
ADDRGP4 $2255
JUMPV
LABELV $2261
line 5364
;5363:		}
;5364:		if (ent->s.modelindex != modelindex) {
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
EQI4 $2263
line 5365
;5365:			continue;
ADDRGP4 $2255
JUMPV
LABELV $2263
line 5367
;5366:		}
;5367:		VectorSubtract(goal->origin, ent->s.origin, dir);
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
line 5368
;5368:		if (VectorLengthSquared(dir) < Square(10)) {
ADDRLP4 4
ARGP4
ADDRLP4 40
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 40
INDIRF4
CNSTF4 1120403456
GEF4 $2267
line 5369
;5369:			goal->entitynum = i;
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 5370
;5370:			return;
ADDRGP4 $2253
JUMPV
LABELV $2267
line 5372
;5371:		}
;5372:	}
LABELV $2255
line 5357
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 808
ADDP4
ASGNP4
LABELV $2257
ADDRLP4 16
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $2254
line 5373
;5373:}
LABELV $2253
endproc BotSetEntityNumForGoalWithModel 44 4
export BotSetEntityNumForGoal
proc BotSetEntityNumForGoal 36 8
line 5380
;5374:
;5375:/*
;5376:==================
;5377:BotSetEntityNumForGoal
;5378:==================
;5379:*/
;5380:void BotSetEntityNumForGoal(bot_goal_t *goal, char *classname) {
line 5385
;5381:	gentity_t *ent;
;5382:	int i;
;5383:	vec3_t dir;
;5384:
;5385:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 5386
;5386:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $2273
JUMPV
LABELV $2270
line 5387
;5387:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2275
line 5388
;5388:			continue;
ADDRGP4 $2271
JUMPV
LABELV $2275
line 5390
;5389:		}
;5390:		if ( !Q_stricmp(ent->classname, classname) ) {
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
NEI4 $2277
line 5391
;5391:			continue;
ADDRGP4 $2271
JUMPV
LABELV $2277
line 5393
;5392:		}
;5393:		VectorSubtract(goal->origin, ent->s.origin, dir);
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
line 5394
;5394:		if (VectorLengthSquared(dir) < Square(10)) {
ADDRLP4 4
ARGP4
ADDRLP4 32
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 32
INDIRF4
CNSTF4 1120403456
GEF4 $2281
line 5395
;5395:			goal->entitynum = i;
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 5396
;5396:			return;
ADDRGP4 $2269
JUMPV
LABELV $2281
line 5398
;5397:		}
;5398:	}
LABELV $2271
line 5386
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 808
ADDP4
ASGNP4
LABELV $2273
ADDRLP4 16
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $2270
line 5399
;5399:}
LABELV $2269
endproc BotSetEntityNumForGoal 36 8
export BotGoalForBSPEntity
proc BotGoalForBSPEntity 1128 20
line 5406
;5400:
;5401:/*
;5402:==================
;5403:BotGoalForBSPEntity
;5404:==================
;5405:*/
;5406:int BotGoalForBSPEntity( char *classname, bot_goal_t *goal ) {
line 5411
;5407:	char value[MAX_INFO_STRING];
;5408:	vec3_t origin, start, end;
;5409:	int ent, numareas, areas[10];
;5410:
;5411:	memset(goal, 0, sizeof(bot_goal_t));
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
line 5412
;5412:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
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
ADDRGP4 $2287
JUMPV
LABELV $2284
line 5413
;5413:		if (!trap_AAS_ValueForBSPEpairKey(ent, "classname", value, sizeof(value)))
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1851
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
NEI4 $2288
line 5414
;5414:			continue;
ADDRGP4 $2285
JUMPV
LABELV $2288
line 5415
;5415:		if (!strcmp(value, classname)) {
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
NEI4 $2290
line 5416
;5416:			if (!trap_AAS_VectorForBSPEpairKey(ent, "origin", origin))
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1867
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
NEI4 $2292
line 5417
;5417:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2283
JUMPV
LABELV $2292
line 5418
;5418:			VectorCopy(origin, goal->origin);
ADDRFP4 4
INDIRP4
ADDRLP4 1028
INDIRB
ASGNB 12
line 5419
;5419:			VectorCopy(origin, start);
ADDRLP4 1040
ADDRLP4 1028
INDIRB
ASGNB 12
line 5420
;5420:			start[2] -= 32;
ADDRLP4 1040+8
ADDRLP4 1040+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 5421
;5421:			VectorCopy(origin, end);
ADDRLP4 1052
ADDRLP4 1028
INDIRB
ASGNB 12
line 5422
;5422:			end[2] += 32;
ADDRLP4 1052+8
ADDRLP4 1052+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 5423
;5423:			numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
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
line 5424
;5424:			if (!numareas)
ADDRLP4 1064
INDIRI4
CNSTI4 0
NEI4 $2296
line 5425
;5425:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2283
JUMPV
LABELV $2296
line 5426
;5426:			goal->areanum = areas[0];
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 1068
INDIRI4
ASGNI4
line 5427
;5427:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2283
JUMPV
LABELV $2290
line 5429
;5428:		}
;5429:	}
LABELV $2285
line 5412
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
LABELV $2287
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $2284
line 5430
;5430:	return qfalse;
CNSTI4 0
RETI4
LABELV $2283
endproc BotGoalForBSPEntity 1128 20
export BotSetupDeathmatchAI
proc BotSetupDeathmatchAI 156 16
line 5438
;5431:}
;5432:
;5433:/*
;5434:==================
;5435:BotSetupDeathmatchAI
;5436:==================
;5437:*/
;5438:void BotSetupDeathmatchAI(void) {
line 5442
;5439:	int ent, modelnum;
;5440:	char model[128];
;5441:
;5442:	gametype = trap_Cvar_VariableIntegerValue("g_gametype");
ADDRGP4 $2299
ARGP4
ADDRLP4 136
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 gametype
ADDRLP4 136
INDIRI4
ASGNI4
line 5443
;5443:	maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $279
ARGP4
ADDRLP4 140
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 maxclients
ADDRLP4 140
INDIRI4
ASGNI4
line 5445
;5444:
;5445:	trap_Cvar_Register(&bot_rocketjump, "bot_rocketjump", "1", 0);
ADDRGP4 bot_rocketjump
ARGP4
ADDRGP4 $2300
ARGP4
ADDRGP4 $2114
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5446
;5446:	trap_Cvar_Register(&bot_grapple, "bot_grapple", "0", 0);
ADDRGP4 bot_grapple
ARGP4
ADDRGP4 $2301
ARGP4
ADDRGP4 $2302
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5447
;5447:	trap_Cvar_Register(&bot_fastchat, "bot_fastchat", "0", 0);
ADDRGP4 bot_fastchat
ARGP4
ADDRGP4 $2303
ARGP4
ADDRGP4 $2302
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5448
;5448:	trap_Cvar_Register(&bot_nochat, "bot_nochat", "0", 0);
ADDRGP4 bot_nochat
ARGP4
ADDRGP4 $2304
ARGP4
ADDRGP4 $2302
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5449
;5449:	trap_Cvar_Register(&bot_testrchat, "bot_testrchat", "0", 0);
ADDRGP4 bot_testrchat
ARGP4
ADDRGP4 $2113
ARGP4
ADDRGP4 $2302
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5450
;5450:	trap_Cvar_Register(&bot_challenge, "bot_challenge", "0", 0);
ADDRGP4 bot_challenge
ARGP4
ADDRGP4 $2305
ARGP4
ADDRGP4 $2302
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5451
;5451:	trap_Cvar_Register(&bot_predictobstacles, "bot_predictobstacles", "1", 0);
ADDRGP4 bot_predictobstacles
ARGP4
ADDRGP4 $2306
ARGP4
ADDRGP4 $2114
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5452
;5452:	trap_Cvar_Register(&g_spSkill, "g_spSkill", "2", 0);
ADDRGP4 g_spSkill
ARGP4
ADDRGP4 $2307
ARGP4
ADDRGP4 $2308
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5454
;5453:	//
;5454:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $2309
line 5455
;5455:		if (trap_BotGetLevelItemGoal(-1, "Red Flag", &ctf_redflag) < 0)
CNSTI4 -1
ARGI4
ADDRGP4 $2313
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
GEI4 $2311
line 5456
;5456:			BotAI_Print(PRT_WARNING, "CTF without Red Flag\n");
CNSTI4 2
ARGI4
ADDRGP4 $2314
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
LABELV $2311
line 5457
;5457:		if (trap_BotGetLevelItemGoal(-1, "Blue Flag", &ctf_blueflag) < 0)
CNSTI4 -1
ARGI4
ADDRGP4 $2317
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
GEI4 $2315
line 5458
;5458:			BotAI_Print(PRT_WARNING, "CTF without Blue Flag\n");
CNSTI4 2
ARGI4
ADDRGP4 $2318
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
LABELV $2315
line 5459
;5459:	}
LABELV $2309
line 5490
;5460:#ifdef MISSIONPACK
;5461:	else if (gametype == GT_1FCTF) {
;5462:		if (trap_BotGetLevelItemGoal(-1, "Neutral Flag", &ctf_neutralflag) < 0)
;5463:			BotAI_Print(PRT_WARNING, "One Flag CTF without Neutral Flag\n");
;5464:		if (trap_BotGetLevelItemGoal(-1, "Red Flag", &ctf_redflag) < 0)
;5465:			BotAI_Print(PRT_WARNING, "CTF without Red Flag\n");
;5466:		if (trap_BotGetLevelItemGoal(-1, "Blue Flag", &ctf_blueflag) < 0)
;5467:			BotAI_Print(PRT_WARNING, "CTF without Blue Flag\n");
;5468:	}
;5469:	else if (gametype == GT_OBELISK) {
;5470:		if (trap_BotGetLevelItemGoal(-1, "Red Obelisk", &redobelisk) < 0)
;5471:			BotAI_Print(PRT_WARNING, "Obelisk without red obelisk\n");
;5472:		BotSetEntityNumForGoal(&redobelisk, "team_redobelisk");
;5473:		if (trap_BotGetLevelItemGoal(-1, "Blue Obelisk", &blueobelisk) < 0)
;5474:			BotAI_Print(PRT_WARNING, "Obelisk without blue obelisk\n");
;5475:		BotSetEntityNumForGoal(&blueobelisk, "team_blueobelisk");
;5476:	}
;5477:	else if (gametype == GT_HARVESTER) {
;5478:		if (trap_BotGetLevelItemGoal(-1, "Red Obelisk", &redobelisk) < 0)
;5479:			BotAI_Print(PRT_WARNING, "Harvester without red obelisk\n");
;5480:		BotSetEntityNumForGoal(&redobelisk, "team_redobelisk");
;5481:		if (trap_BotGetLevelItemGoal(-1, "Blue Obelisk", &blueobelisk) < 0)
;5482:			BotAI_Print(PRT_WARNING, "Harvester without blue obelisk\n");
;5483:		BotSetEntityNumForGoal(&blueobelisk, "team_blueobelisk");
;5484:		if (trap_BotGetLevelItemGoal(-1, "Neutral Obelisk", &neutralobelisk) < 0)
;5485:			BotAI_Print(PRT_WARNING, "Harvester without neutral obelisk\n");
;5486:		BotSetEntityNumForGoal(&neutralobelisk, "team_neutralobelisk");
;5487:	}
;5488:#endif
;5489:
;5490:	max_bspmodelindex = 0;
ADDRGP4 max_bspmodelindex
CNSTI4 0
ASGNI4
line 5491
;5491:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
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
ADDRGP4 $2322
JUMPV
LABELV $2319
line 5492
;5492:		if (!trap_AAS_ValueForBSPEpairKey(ent, "model", model, sizeof(model))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $274
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
NEI4 $2323
ADDRGP4 $2320
JUMPV
LABELV $2323
line 5493
;5493:		if (model[0] == '*') {
ADDRLP4 4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $2325
line 5494
;5494:			modelnum = atoi(model+1);
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
line 5495
;5495:			if (modelnum > max_bspmodelindex)
ADDRLP4 132
INDIRI4
ADDRGP4 max_bspmodelindex
INDIRI4
LEI4 $2328
line 5496
;5496:				max_bspmodelindex = modelnum;
ADDRGP4 max_bspmodelindex
ADDRLP4 132
INDIRI4
ASGNI4
LABELV $2328
line 5497
;5497:		}
LABELV $2325
line 5498
;5498:	}
LABELV $2320
line 5491
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
LABELV $2322
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $2319
line 5500
;5499:	//initialize the waypoint heap
;5500:	BotInitWaypoints();
ADDRGP4 BotInitWaypoints
CALLV
pop
line 5501
;5501:}
LABELV $2298
endproc BotSetupDeathmatchAI 156 16
export BotShutdownDeathmatchAI
proc BotShutdownDeathmatchAI 0 0
line 5508
;5502:
;5503:/*
;5504:==================
;5505:BotShutdownDeathmatchAI
;5506:==================
;5507:*/
;5508:void BotShutdownDeathmatchAI(void) {
line 5509
;5509:	altroutegoals_setup = qfalse;
ADDRGP4 altroutegoals_setup
CNSTI4 0
ASGNI4
line 5510
;5510:}
LABELV $2330
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
LABELV $2318
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
LABELV $2317
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
LABELV $2314
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
LABELV $2313
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
LABELV $2308
byte 1 50
byte 1 0
align 1
LABELV $2307
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
LABELV $2306
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
LABELV $2305
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
LABELV $2304
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
LABELV $2303
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
LABELV $2302
byte 1 48
byte 1 0
align 1
LABELV $2301
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
LABELV $2300
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
LABELV $2299
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
LABELV $2252
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
LABELV $2241
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
LABELV $2236
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
LABELV $2225
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $2221
byte 1 115
byte 1 101
byte 1 120
byte 1 0
align 1
LABELV $2181
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
LABELV $2178
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
LABELV $2157
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
LABELV $2154
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
LABELV $2125
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
LABELV $2118
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
LABELV $2117
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
LABELV $2114
byte 1 49
byte 1 0
align 1
LABELV $2113
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
LABELV $1979
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
LABELV $1978
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
LABELV $1974
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
LABELV $1962
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
LABELV $1961
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
LABELV $1958
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
LABELV $1947
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
LABELV $1934
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
LABELV $1928
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
LABELV $1920
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $1909
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
LABELV $1905
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
LABELV $1902
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
LABELV $1867
byte 1 111
byte 1 114
byte 1 105
byte 1 103
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $1862
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
LABELV $1857
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
LABELV $1854
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
LABELV $1851
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
LABELV $1850
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
LABELV $1838
byte 1 42
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $1653
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $1630
byte 1 97
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $1627
byte 1 108
byte 1 105
byte 1 112
byte 1 0
align 1
LABELV $1589
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
LABELV $1534
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
LABELV $1530
byte 1 109
byte 1 97
byte 1 112
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $684
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
LABELV $683
byte 1 83
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $682
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
LABELV $681
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
LABELV $680
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
LABELV $513
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
LABELV $324
byte 1 93
byte 1 0
align 1
LABELV $323
byte 1 91
byte 1 0
align 1
LABELV $322
byte 1 32
byte 1 0
align 1
LABELV $279
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
LABELV $274
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $273
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
LABELV $268
byte 1 110
byte 1 0
align 1
LABELV $267
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
LABELV $266
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
LABELV $185
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
LABELV $160
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
LABELV $159
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $158
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
LABELV $135
byte 1 110
byte 1 111
byte 1 0
align 1
LABELV $67
byte 1 116
byte 1 0
