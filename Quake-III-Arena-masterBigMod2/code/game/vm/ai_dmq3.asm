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
LABELV $53
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
EQI4 $55
CNSTI4 0
RETI4
ADDRGP4 $54
JUMPV
LABELV $55
line 134
;133:
;134:	if (bs->inventory[INVENTORY_REDFLAG] > 0) return CTF_FLAG_RED;
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
line 135
;135:	else if (bs->inventory[INVENTORY_BLUEFLAG] > 0) return CTF_FLAG_BLUE;
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
line 136
;136:	return CTF_FLAG_NONE;
CNSTI4 0
RETI4
LABELV $54
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
LTI4 $64
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $62
LABELV $64
line 149
;148:		//BotAI_Print(PRT_ERROR, "BotCTFTeam: client out of range\n");
;149:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $61
JUMPV
LABELV $62
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
line 154
;154:	else if (atoi(Info_ValueForKey(info, "t")) == TEAM_BLUE) return TEAM_BLUE;
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
line 155
;155:	return TEAM_FREE;
CNSTI4 0
RETI4
LABELV $61
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
EQI4 $74
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $75
ADDRGP4 $71
JUMPV
LABELV $74
line 165
;165:		case TEAM_RED: return TEAM_BLUE;
CNSTI4 2
RETI4
ADDRGP4 $70
JUMPV
LABELV $75
line 166
;166:		case TEAM_BLUE: return TEAM_RED;
CNSTI4 1
RETI4
ADDRGP4 $70
JUMPV
LABELV $71
line 167
;167:		default: return TEAM_FREE;
CNSTI4 0
RETI4
LABELV $70
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
NEI4 $77
line 178
;178:		return &ctf_blueflag;
ADDRGP4 ctf_blueflag
RETP4
ADDRGP4 $76
JUMPV
LABELV $77
line 180
;179:	}
;180:	else {
line 181
;181:		return &ctf_redflag;
ADDRGP4 ctf_redflag
RETP4
LABELV $76
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
NEI4 $80
line 192
;192:		return &ctf_redflag;
ADDRGP4 ctf_redflag
RETP4
ADDRGP4 $79
JUMPV
LABELV $80
line 194
;193:	}
;194:	else {
line 195
;195:		return &ctf_blueflag;
ADDRGP4 ctf_blueflag
RETP4
LABELV $79
endproc BotTeamFlag 4 4
export EntityIsDead
proc EntityIsDead 472 8
line 205
;196:	}
;197:}
;198:
;199:
;200:/*
;201:==================
;202:EntityIsDead
;203:==================
;204:*/
;205:qboolean EntityIsDead(aas_entityinfo_t *entinfo) {
line 208
;206:	playerState_t ps;
;207:
;208:	if (entinfo->number >= 0 && entinfo->number < MAX_CLIENTS) {
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
line 210
;209:		//retrieve the current client state
;210:		BotAI_GetClientState( entinfo->number, &ps );
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
line 211
;211:		if (ps.pm_type != PM_NORMAL) return qtrue;
ADDRLP4 0+4
INDIRI4
CNSTI4 0
EQI4 $85
CNSTI4 1
RETI4
ADDRGP4 $82
JUMPV
LABELV $85
line 212
;212:	}
LABELV $83
line 213
;213:	return qfalse;
CNSTI4 0
RETI4
LABELV $82
endproc EntityIsDead 472 8
export EntityCarriesFlag
proc EntityCarriesFlag 0 0
line 221
;214:}
;215:
;216:/*
;217:==================
;218:EntityCarriesFlag
;219:==================
;220:*/
;221:qboolean EntityCarriesFlag(aas_entityinfo_t *entinfo) {
line 222
;222:	if ( entinfo->powerups & ( 1 << PW_REDFLAG ) )
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $89
line 223
;223:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $88
JUMPV
LABELV $89
line 224
;224:	if ( entinfo->powerups & ( 1 << PW_BLUEFLAG ) )
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $91
line 225
;225:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $88
JUMPV
LABELV $91
line 230
;226:#ifdef MISSIONPACK
;227:	if ( entinfo->powerups & ( 1 << PW_NEUTRALFLAG ) )
;228:		return qtrue;
;229:#endif
;230:	return qfalse;
CNSTI4 0
RETI4
LABELV $88
endproc EntityCarriesFlag 0 0
export EntityIsInvisible
proc EntityIsInvisible 4 4
line 238
;231:}
;232:
;233:/*
;234:==================
;235:EntityIsInvisible
;236:==================
;237:*/
;238:qboolean EntityIsInvisible(aas_entityinfo_t *entinfo) {
line 240
;239:	// the flag is always visible
;240:	if (EntityCarriesFlag(entinfo)) {
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
line 241
;241:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $93
JUMPV
LABELV $94
line 243
;242:	}
;243:	if (entinfo->powerups & (1 << PW_INVIS)) {
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $96
line 244
;244:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $93
JUMPV
LABELV $96
line 246
;245:	}
;246:	return qfalse;
CNSTI4 0
RETI4
LABELV $93
endproc EntityIsInvisible 4 4
export EntityIsShooting
proc EntityIsShooting 0 0
line 254
;247:}
;248:
;249:/*
;250:==================
;251:EntityIsShooting
;252:==================
;253:*/
;254:qboolean EntityIsShooting(aas_entityinfo_t *entinfo) {
line 255
;255:	if (entinfo->flags & EF_FIRING) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $99
line 256
;256:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $98
JUMPV
LABELV $99
line 258
;257:	}
;258:	return qfalse;
CNSTI4 0
RETI4
LABELV $98
endproc EntityIsShooting 0 0
export EntityIsChatting
proc EntityIsChatting 0 0
line 266
;259:}
;260:
;261:/*
;262:==================
;263:EntityIsChatting
;264:==================
;265:*/
;266:qboolean EntityIsChatting(aas_entityinfo_t *entinfo) {
line 267
;267:	if (entinfo->flags & EF_TALK) {
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
EQI4 $102
line 268
;268:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $101
JUMPV
LABELV $102
line 270
;269:	}
;270:	return qfalse;
CNSTI4 0
RETI4
LABELV $101
endproc EntityIsChatting 0 0
export EntityHasQuad
proc EntityHasQuad 0 0
line 278
;271:}
;272:
;273:/*
;274:==================
;275:EntityHasQuad
;276:==================
;277:*/
;278:qboolean EntityHasQuad(aas_entityinfo_t *entinfo) {
line 279
;279:	if (entinfo->powerups & (1 << PW_QUAD)) {
ADDRFP4 0
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $105
line 280
;280:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $104
JUMPV
LABELV $105
line 282
;281:	}
;282:	return qfalse;
CNSTI4 0
RETI4
LABELV $104
endproc EntityHasQuad 0 0
export BotRememberLastOrderedTask
proc BotRememberLastOrderedTask 16 12
line 346
;283:}
;284:
;285:#ifdef MISSIONPACK
;286:/*
;287:==================
;288:EntityHasKamikze
;289:==================
;290:*/
;291:qboolean EntityHasKamikaze(aas_entityinfo_t *entinfo) {
;292:	if (entinfo->flags & EF_KAMIKAZE) {
;293:		return qtrue;
;294:	}
;295:	return qfalse;
;296:}
;297:
;298:/*
;299:==================
;300:EntityCarriesCubes
;301:==================
;302:*/
;303:qboolean EntityCarriesCubes(aas_entityinfo_t *entinfo) {
;304:	entityState_t state;
;305:
;306:	if (gametype != GT_HARVESTER)
;307:		return qfalse;
;308:	//FIXME: get this info from the aas_entityinfo_t ?
;309:	BotAI_GetEntityState(entinfo->number, &state);
;310:	if (state.generic1 > 0)
;311:		return qtrue;
;312:	return qfalse;
;313:}
;314:
;315:/*
;316:==================
;317:Bot1FCTFCarryingFlag
;318:==================
;319:*/
;320:int Bot1FCTFCarryingFlag(bot_state_t *bs) {
;321:	if (gametype != GT_1FCTF) return qfalse;
;322:
;323:	if (bs->inventory[INVENTORY_NEUTRALFLAG] > 0) return qtrue;
;324:	return qfalse;
;325:}
;326:
;327:/*
;328:==================
;329:BotHarvesterCarryingCubes
;330:==================
;331:*/
;332:int BotHarvesterCarryingCubes(bot_state_t *bs) {
;333:	if (gametype != GT_HARVESTER) return qfalse;
;334:
;335:	if (bs->inventory[INVENTORY_REDCUBE] > 0) return qtrue;
;336:	if (bs->inventory[INVENTORY_BLUECUBE] > 0) return qtrue;
;337:	return qfalse;
;338:}
;339:#endif
;340:
;341:/*
;342:==================
;343:BotRememberLastOrderedTask
;344:==================
;345:*/
;346:void BotRememberLastOrderedTask(bot_state_t *bs) {
line 347
;347:	if (!bs->ordered) {
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $108
line 348
;348:		return;
ADDRGP4 $107
JUMPV
LABELV $108
line 350
;349:	}
;350:	bs->lastgoal_decisionmaker = bs->decisionmaker;
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
line 351
;351:	bs->lastgoal_ltgtype = bs->ltgtype;
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
line 352
;352:	memcpy(&bs->lastgoal_teamgoal, &bs->teamgoal, sizeof(bot_goal_t));
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
line 353
;353:	bs->lastgoal_teammate = bs->teammate;
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
line 354
;354:}
LABELV $107
endproc BotRememberLastOrderedTask 16 12
export BotSetTeamStatus
proc BotSetTeamStatus 0 0
line 361
;355:
;356:/*
;357:==================
;358:BotSetTeamStatus
;359:==================
;360:*/
;361:void BotSetTeamStatus(bot_state_t *bs) {
line 418
;362:#ifdef MISSIONPACK
;363:	int teamtask;
;364:	aas_entityinfo_t entinfo;
;365:
;366:	teamtask = TEAMTASK_PATROL;
;367:
;368:	switch(bs->ltgtype) {
;369:		case LTG_TEAMHELP:
;370:			break;
;371:		case LTG_TEAMACCOMPANY:
;372:			BotEntityInfo(bs->teammate, &entinfo);
;373:			if ( ( (gametype == GT_CTF || gametype == GT_1FCTF) && EntityCarriesFlag(&entinfo))
;374:				|| ( gametype == GT_HARVESTER && EntityCarriesCubes(&entinfo)) ) {
;375:				teamtask = TEAMTASK_ESCORT;
;376:			}
;377:			else {
;378:				teamtask = TEAMTASK_FOLLOW;
;379:			}
;380:			break;
;381:		case LTG_DEFENDKEYAREA:
;382:			teamtask = TEAMTASK_DEFENSE;
;383:			break;
;384:		case LTG_GETFLAG:
;385:			teamtask = TEAMTASK_OFFENSE;
;386:			break;
;387:		case LTG_RUSHBASE:
;388:			teamtask = TEAMTASK_DEFENSE;
;389:			break;
;390:		case LTG_RETURNFLAG:
;391:			teamtask = TEAMTASK_RETRIEVE;
;392:			break;
;393:		case LTG_CAMP:
;394:		case LTG_CAMPORDER:
;395:			teamtask = TEAMTASK_CAMP;
;396:			break;
;397:		case LTG_PATROL:
;398:			teamtask = TEAMTASK_PATROL;
;399:			break;
;400:		case LTG_GETITEM:
;401:			teamtask = TEAMTASK_PATROL;
;402:			break;
;403:		case LTG_KILL:
;404:			teamtask = TEAMTASK_PATROL;
;405:			break;
;406:		case LTG_HARVEST:
;407:			teamtask = TEAMTASK_OFFENSE;
;408:			break;
;409:		case LTG_ATTACKENEMYBASE:
;410:			teamtask = TEAMTASK_OFFENSE;
;411:			break;
;412:		default:
;413:			teamtask = TEAMTASK_PATROL;
;414:			break;
;415:	}
;416:	BotSetUserInfo(bs, "teamtask", va("%d", teamtask));
;417:#endif
;418:}
LABELV $110
endproc BotSetTeamStatus 0 0
export BotSetLastOrderedTask
proc BotSetLastOrderedTask 60 16
line 425
;419:
;420:/*
;421:==================
;422:BotSetLastOrderedTask
;423:==================
;424:*/
;425:int BotSetLastOrderedTask(bot_state_t *bs) {
line 427
;426:
;427:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $112
line 429
;428:		// don't go back to returning the flag if it's at the base
;429:		if ( bs->lastgoal_ltgtype == LTG_RETURNFLAG ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 6
NEI4 $114
line 430
;430:			if ( BotTeam(bs) == TEAM_RED ) {
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
line 431
;431:				if ( bs->redflagstatus == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
INDIRI4
CNSTI4 0
NEI4 $117
line 432
;432:					bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 433
;433:				}
line 434
;434:			}
ADDRGP4 $117
JUMPV
LABELV $116
line 435
;435:			else {
line 436
;436:				if ( bs->blueflagstatus == 0 ) {
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
CNSTI4 0
NEI4 $120
line 437
;437:					bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 438
;438:				}
LABELV $120
line 439
;439:			}
LABELV $117
line 440
;440:		}
LABELV $114
line 441
;441:	}
LABELV $112
line 443
;442:
;443:	if ( bs->lastgoal_ltgtype ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $122
line 444
;444:		bs->decisionmaker = bs->lastgoal_decisionmaker;
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
line 445
;445:		bs->ordered = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 1
ASGNI4
line 446
;446:		bs->ltgtype = bs->lastgoal_ltgtype;
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
line 447
;447:		memcpy(&bs->teamgoal, &bs->lastgoal_teamgoal, sizeof(bot_goal_t));
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
line 448
;448:		bs->teammate = bs->lastgoal_teammate;
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
line 449
;449:		bs->teamgoal_time = FloatTime() + 300;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1133903872
ADDF4
ASGNF4
line 450
;450:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 452
;451:		//
;452:		if ( gametype == GT_CTF ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $124
line 453
;453:			if ( bs->ltgtype == LTG_GETFLAG ) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $126
line 457
;454:				bot_goal_t *tb, *eb;
;455:				int tt, et;
;456:
;457:				tb = BotTeamFlag(bs);
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
line 458
;458:				eb = BotEnemyFlag(bs);
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
line 459
;459:				tt = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, tb->areanum, TFL_DEFAULT);
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
line 460
;460:				et = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, eb->areanum, TFL_DEFAULT);
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
line 462
;461:				// if the travel time towards the enemy base is larger than towards our base
;462:				if (et > tt) {
ADDRLP4 28
INDIRI4
ADDRLP4 24
INDIRI4
LEI4 $128
line 464
;463:					//get an alternative route goal towards the enemy base
;464:					BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 465
;465:				}
LABELV $128
line 466
;466:			}
LABELV $126
line 467
;467:		}
LABELV $124
line 468
;468:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $111
JUMPV
LABELV $122
line 470
;469:	}
;470:	return qfalse;
CNSTI4 0
RETI4
LABELV $111
endproc BotSetLastOrderedTask 60 16
export BotRefuseOrder
proc BotRefuseOrder 8 12
line 478
;471:}
;472:
;473:/*
;474:==================
;475:BotRefuseOrder
;476:==================
;477:*/
;478:void BotRefuseOrder(bot_state_t *bs) {
line 479
;479:	if (!bs->ordered)
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
INDIRI4
CNSTI4 0
NEI4 $131
line 480
;480:		return;
ADDRGP4 $130
JUMPV
LABELV $131
line 482
;481:	// if the bot was ordered to do something
;482:	if ( bs->order_time && bs->order_time > FloatTime() - 10 ) {
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
line 483
;483:		trap_EA_Action(bs->client, ACTION_NEGATIVE);
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
line 484
;484:		BotVoiceChat(bs, bs->decisionmaker, VOICECHAT_NO);
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
line 485
;485:		bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 486
;486:	}
LABELV $133
line 487
;487:}
LABELV $130
endproc BotRefuseOrder 8 12
export BotCTFSeekGoals
proc BotCTFSeekGoals 240 12
line 494
;488:
;489:/*
;490:==================
;491:BotCTFSeekGoals
;492:==================
;493:*/
;494:void BotCTFSeekGoals(bot_state_t *bs) {
line 501
;495:	float rnd, l1, l2;
;496:	int flagstatus, c;
;497:	vec3_t dir;
;498:	aas_entityinfo_t entinfo;
;499:
;500:	//when carrying a flag in ctf the bot should rush to the base
;501:	if (BotCTFCarryingFlag(bs)) {
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
line 503
;502:		//if not already rushing to the base
;503:		if (bs->ltgtype != LTG_RUSHBASE) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
EQI4 $139
line 504
;504:			BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 505
;505:			bs->ltgtype = LTG_RUSHBASE;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 5
ASGNI4
line 506
;506:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
ASGNF4
line 507
;507:			bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 508
;508:			bs->decisionmaker = bs->client;
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
line 509
;509:			bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 511
;510:			//
;511:			switch(BotTeam(bs)) {
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
line 512
;512:				case TEAM_RED: VectorSubtract(bs->origin, ctf_blueflag.origin, dir); break;
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
line 513
;513:				case TEAM_BLUE: VectorSubtract(bs->origin, ctf_redflag.origin, dir); break;
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
line 514
;514:				default: VectorSet(dir, 999, 999, 999); break;
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
line 517
;515:			}
;516:			// if the bot picked up the flag very close to the enemy base
;517:			if ( VectorLength(dir) < 128 ) {
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
line 519
;518:				// get an alternative route goal through the enemy base
;519:				BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 520
;520:			} else {
ADDRGP4 $157
JUMPV
LABELV $156
line 522
;521:				// don't use any alt route goal, just get the hell out of the base
;522:				bs->altroutegoal.areanum = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6692
ADDP4
CNSTI4 0
ASGNI4
line 523
;523:			}
LABELV $157
line 524
;524:			BotSetUserInfo(bs, "teamtask", va("%d", TEAMTASK_OFFENSE));
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
line 525
;525:			BotVoiceChat(bs, -1, VOICECHAT_IHAVEFLAG);
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
line 526
;526:		}
ADDRGP4 $136
JUMPV
LABELV $139
line 527
;527:		else if (bs->rushbaseaway_time > FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $136
line 528
;528:			if (BotTeam(bs) == TEAM_RED) flagstatus = bs->redflagstatus;
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
line 529
;529:			else flagstatus = bs->blueflagstatus;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
INDIRI4
ASGNI4
LABELV $164
line 531
;530:			//if the flag is back
;531:			if (flagstatus == 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $136
line 532
;532:				bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 533
;533:			}
line 534
;534:		}
line 535
;535:		return;
ADDRGP4 $136
JUMPV
LABELV $137
line 538
;536:	}
;537:	// if the bot decided to follow someone
;538:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
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
line 540
;539:		// if the team mate being accompanied no longer carries the flag
;540:		BotEntityInfo(bs->teammate, &entinfo);
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
line 541
;541:		if (!EntityCarriesFlag(&entinfo)) {
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
line 542
;542:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 543
;543:		}
LABELV $169
line 544
;544:	}
LABELV $167
line 546
;545:	//
;546:	if (BotTeam(bs) == TEAM_RED) flagstatus = bs->redflagstatus * 2 + bs->blueflagstatus;
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
line 547
;547:	else flagstatus = bs->blueflagstatus * 2 + bs->redflagstatus;
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
line 549
;548:	//if our team has the enemy flag and our flag is at the base
;549:	if (flagstatus == 1) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $173
line 551
;550:		//
;551:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $136
line 553
;552:			//if Not defending the base already
;553:			if (!(bs->ltgtype == LTG_DEFENDKEYAREA &&
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
line 555
;554:					(bs->teamgoal.number == ctf_redflag.number ||
;555:					bs->teamgoal.number == ctf_blueflag.number))) {
line 557
;556:				//if there is a visible team mate flag carrier
;557:				c = BotTeamFlagCarrierVisible(bs);
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
line 558
;558:				if (c >= 0 &&
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
line 560
;559:						// and not already following the team mate flag carrier
;560:						(bs->ltgtype != LTG_TEAMACCOMPANY || bs->teammate != c)) {
line 562
;561:					//
;562:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 564
;563:					//follow the flag carrier
;564:					bs->decisionmaker = bs->client;
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
line 565
;565:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 567
;566:					//the team mate
;567:					bs->teammate = c;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 156
INDIRI4
ASGNI4
line 569
;568:					//last time the team mate was visible
;569:					bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 571
;570:					//no message
;571:					bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 573
;572:					//no arrive message
;573:					bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 575
;574:					//
;575:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
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
line 577
;576:					//get the team goal time
;577:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 578
;578:					bs->ltgtype = LTG_TEAMACCOMPANY;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 2
ASGNI4
line 579
;579:					bs->formation_dist = 3.5 * 32;		//3.5 meter
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
CNSTF4 1121976320
ASGNF4
line 580
;580:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 581
;581:					bs->owndecision_time = FloatTime() + 5;
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
line 582
;582:				}
line 583
;583:			}
line 584
;584:		}
line 585
;585:		return;
ADDRGP4 $136
JUMPV
LABELV $173
line 588
;586:	}
;587:	//if the enemy has our flag
;588:	else if (flagstatus == 2) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $186
line 590
;589:		//
;590:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $136
line 592
;591:			//if enemy flag carrier is visible
;592:			c = BotEnemyFlagCarrierVisible(bs);
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
line 593
;593:			if (c >= 0) {
ADDRLP4 156
INDIRI4
CNSTI4 0
LTI4 $190
line 595
;594:				//FIXME: fight enemy flag carrier
;595:			}
LABELV $190
line 597
;596:			//if not already doing something important
;597:			if (bs->ltgtype != LTG_GETFLAG &&
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
line 603
;598:				bs->ltgtype != LTG_RETURNFLAG &&
;599:				bs->ltgtype != LTG_TEAMHELP &&
;600:				bs->ltgtype != LTG_TEAMACCOMPANY &&
;601:				bs->ltgtype != LTG_CAMPORDER &&
;602:				bs->ltgtype != LTG_PATROL &&
;603:				bs->ltgtype != LTG_GETITEM) {
line 605
;604:
;605:				BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 606
;606:				bs->decisionmaker = bs->client;
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
line 607
;607:				bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 609
;608:				//
;609:				if (random() < 0.5) {
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
line 611
;610:					//go for the enemy flag
;611:					bs->ltgtype = LTG_GETFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 4
ASGNI4
line 612
;612:				}
ADDRGP4 $195
JUMPV
LABELV $194
line 613
;613:				else {
line 614
;614:					bs->ltgtype = LTG_RETURNFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 6
ASGNI4
line 615
;615:				}
LABELV $195
line 617
;616:				//no team message
;617:				bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 619
;618:				//set the time the bot will stop getting the flag
;619:				bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 621
;620:				//get an alternative route goal towards the enemy base
;621:				BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 623
;622:				//
;623:				BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 624
;624:				bs->owndecision_time = FloatTime() + 5;
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
line 625
;625:			}
line 626
;626:		}
line 627
;627:		return;
ADDRGP4 $136
JUMPV
LABELV $186
line 630
;628:	}
;629:	//if both flags Not at their bases
;630:	else if (flagstatus == 3) {
ADDRLP4 0
INDIRI4
CNSTI4 3
NEI4 $196
line 632
;631:		//
;632:		if (bs->owndecision_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
GEF4 $136
line 634
;633:			// if not trying to return the flag and not following the team flag carrier
;634:			if ( bs->ltgtype != LTG_RETURNFLAG && bs->ltgtype != LTG_TEAMACCOMPANY ) {
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
line 636
;635:				//
;636:				c = BotTeamFlagCarrierVisible(bs);
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
line 638
;637:				// if there is a visible team mate flag carrier
;638:				if (c >= 0) {
ADDRLP4 156
INDIRI4
CNSTI4 0
LTI4 $202
line 639
;639:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 641
;640:					//follow the flag carrier
;641:					bs->decisionmaker = bs->client;
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
line 642
;642:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 644
;643:					//the team mate
;644:					bs->teammate = c;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
ADDRLP4 156
INDIRI4
ASGNI4
line 646
;645:					//last time the team mate was visible
;646:					bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 648
;647:					//no message
;648:					bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 650
;649:					//no arrive message
;650:					bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 652
;651:					//
;652:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
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
line 654
;653:					//get the team goal time
;654:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 655
;655:					bs->ltgtype = LTG_TEAMACCOMPANY;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 2
ASGNI4
line 656
;656:					bs->formation_dist = 3.5 * 32;		//3.5 meter
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
CNSTF4 1121976320
ASGNF4
line 658
;657:					//
;658:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 659
;659:					bs->owndecision_time = FloatTime() + 5;
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
line 660
;660:				}
ADDRGP4 $136
JUMPV
LABELV $202
line 661
;661:				else {
line 662
;662:					BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 663
;663:					bs->decisionmaker = bs->client;
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
line 664
;664:					bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 666
;665:					//get the enemy flag
;666:					bs->teammessage_time = FloatTime() + 2 * random();
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
line 668
;667:					//get the flag
;668:					bs->ltgtype = LTG_RETURNFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 6
ASGNI4
line 670
;669:					//set the time the bot will stop getting the flag
;670:					bs->teamgoal_time = FloatTime() + CTF_RETURNFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1127481344
ADDF4
ASGNF4
line 672
;671:					//get an alternative route goal towards the enemy base
;672:					BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 674
;673:					//
;674:					BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 675
;675:					bs->owndecision_time = FloatTime() + 5;
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
line 676
;676:				}
line 677
;677:			}
line 678
;678:		}
line 679
;679:		return;
ADDRGP4 $136
JUMPV
LABELV $196
line 682
;680:	}
;681:	// don't just do something wait for the bot team leader to give orders
;682:	if (BotTeamLeader(bs)) {
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
line 683
;683:		return;
ADDRGP4 $136
JUMPV
LABELV $204
line 686
;684:	}
;685:	// if the bot is ordered to do something
;686:	if ( bs->lastgoal_ltgtype ) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 0
EQI4 $206
line 687
;687:		bs->teamgoal_time += 60;
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
line 688
;688:	}
LABELV $206
line 690
;689:	// if the bot decided to do something on it's own and has a last ordered goal
;690:	if ( !bs->ordered && bs->lastgoal_ltgtype ) {
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
line 691
;691:		bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 692
;692:	}
LABELV $208
line 694
;693:	//if already a CTF or team goal
;694:	if (bs->ltgtype == LTG_TEAMHELP ||
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
line 704
;695:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;696:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;697:			bs->ltgtype == LTG_GETFLAG ||
;698:			bs->ltgtype == LTG_RUSHBASE ||
;699:			bs->ltgtype == LTG_RETURNFLAG ||
;700:			bs->ltgtype == LTG_CAMPORDER ||
;701:			bs->ltgtype == LTG_PATROL ||
;702:			bs->ltgtype == LTG_GETITEM ||
;703:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;704:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
line 705
;705:		return;
ADDRGP4 $136
JUMPV
LABELV $210
line 708
;706:	}
;707:	//
;708:	if (BotSetLastOrderedTask(bs))
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
line 709
;709:		return;
ADDRGP4 $136
JUMPV
LABELV $222
line 711
;710:	//
;711:	if (bs->owndecision_time > FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6620
ADDP4
INDIRI4
CVIF4 4
ADDRGP4 floattime
INDIRF4
LEF4 $224
line 712
;712:		return;;
ADDRGP4 $136
JUMPV
LABELV $224
line 714
;713:	//if the bot is roaming
;714:	if (bs->ctfroam_time > FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6164
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $226
line 715
;715:		return;
ADDRGP4 $136
JUMPV
LABELV $226
line 717
;716:	//if the bot has anough aggression to decide what to do
;717:	if (BotAggression(bs) < 50)
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
line 718
;718:		return;
ADDRGP4 $136
JUMPV
LABELV $228
line 720
;719:	//set the time to send a message to the team mates
;720:	bs->teammessage_time = FloatTime() + 2 * random();
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
line 722
;721:	//
;722:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
ADDRFP4 0
INDIRP4
CNSTI4 6752
ADDP4
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 0
EQI4 $230
line 723
;723:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
ADDRFP4 0
INDIRP4
CNSTI4 6752
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $232
line 724
;724:			l1 = 0.7f;
ADDRLP4 8
CNSTF4 1060320051
ASGNF4
line 725
;725:		}
ADDRGP4 $233
JUMPV
LABELV $232
line 726
;726:		else {
line 727
;727:			l1 = 0.2f;
ADDRLP4 8
CNSTF4 1045220557
ASGNF4
line 728
;728:		}
LABELV $233
line 729
;729:		l2 = 0.9f;
ADDRLP4 12
CNSTF4 1063675494
ASGNF4
line 730
;730:	}
ADDRGP4 $231
JUMPV
LABELV $230
line 731
;731:	else {
line 732
;732:		l1 = 0.4f;
ADDRLP4 8
CNSTF4 1053609165
ASGNF4
line 733
;733:		l2 = 0.7f;
ADDRLP4 12
CNSTF4 1060320051
ASGNF4
line 734
;734:	}
LABELV $231
line 736
;735:	//get the flag or defend the base
;736:	rnd = random();
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
line 737
;737:	if (rnd < l1 && ctf_redflag.areanum && ctf_blueflag.areanum) {
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
line 738
;738:		bs->decisionmaker = bs->client;
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
line 739
;739:		bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 740
;740:		bs->ltgtype = LTG_GETFLAG;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 4
ASGNI4
line 742
;741:		//set the time the bot will stop getting the flag
;742:		bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 744
;743:		//get an alternative route goal towards the enemy base
;744:		BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
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
line 745
;745:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 746
;746:	}
ADDRGP4 $235
JUMPV
LABELV $234
line 747
;747:	else if (rnd < l2 && ctf_redflag.areanum && ctf_blueflag.areanum) {
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
line 748
;748:		bs->decisionmaker = bs->client;
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
line 749
;749:		bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 751
;750:		//
;751:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
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
line 752
;752:		else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
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
line 754
;753:		//set the ltg type
;754:		bs->ltgtype = LTG_DEFENDKEYAREA;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 3
ASGNI4
line 756
;755:		//set the time the bot stops defending the base
;756:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1142292480
ADDF4
ASGNF4
line 757
;757:		bs->defendaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6144
ADDP4
CNSTF4 0
ASGNF4
line 758
;758:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 759
;759:	}
ADDRGP4 $239
JUMPV
LABELV $238
line 760
;760:	else {
line 761
;761:		bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 763
;762:		//set the time the bot will stop roaming
;763:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6164
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1114636288
ADDF4
ASGNF4
line 764
;764:		BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 765
;765:	}
LABELV $239
LABELV $235
line 766
;766:	bs->owndecision_time = FloatTime() + 5;
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
line 770
;767:#ifdef DEBUG
;768:	BotPrintTeamGoal(bs);
;769:#endif //DEBUG
;770:}
LABELV $136
endproc BotCTFSeekGoals 240 12
export BotCTFRetreatGoals
proc BotCTFRetreatGoals 8 4
line 777
;771:
;772:/*
;773:==================
;774:BotCTFRetreatGoals
;775:==================
;776:*/
;777:void BotCTFRetreatGoals(bot_state_t *bs) {
line 779
;778:	//when carrying a flag in ctf the bot should rush to the base
;779:	if (BotCTFCarryingFlag(bs)) {
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
line 781
;780:		//if not already rushing to the base
;781:		if (bs->ltgtype != LTG_RUSHBASE) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
EQI4 $247
line 782
;782:			BotRefuseOrder(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotRefuseOrder
CALLV
pop
line 783
;783:			bs->ltgtype = LTG_RUSHBASE;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 5
ASGNI4
line 784
;784:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1123024896
ADDF4
ASGNF4
line 785
;785:			bs->rushbaseaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
CNSTF4 0
ASGNF4
line 786
;786:			bs->decisionmaker = bs->client;
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
line 787
;787:			bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 788
;788:			BotSetTeamStatus(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeamStatus
CALLV
pop
line 789
;789:		}
LABELV $247
line 790
;790:	}
LABELV $245
line 791
;791:}
LABELV $244
endproc BotCTFRetreatGoals 8 4
export BotTeamGoals
proc BotTeamGoals 0 4
line 1327
;792:
;793:#ifdef MISSIONPACK
;794:/*
;795:==================
;796:Bot1FCTFSeekGoals
;797:==================
;798:*/
;799:void Bot1FCTFSeekGoals(bot_state_t *bs) {
;800:	aas_entityinfo_t entinfo;
;801:	float rnd, l1, l2;
;802:	int c;
;803:
;804:	//when carrying a flag in ctf the bot should rush to the base
;805:	if (Bot1FCTFCarryingFlag(bs)) {
;806:		//if not already rushing to the base
;807:		if (bs->ltgtype != LTG_RUSHBASE) {
;808:			BotRefuseOrder(bs);
;809:			bs->ltgtype = LTG_RUSHBASE;
;810:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;811:			bs->rushbaseaway_time = 0;
;812:			bs->decisionmaker = bs->client;
;813:			bs->ordered = qfalse;
;814:			//get an alternative route goal towards the enemy base
;815:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;816:			//
;817:			BotSetTeamStatus(bs);
;818:			BotVoiceChat(bs, -1, VOICECHAT_IHAVEFLAG);
;819:		}
;820:		return;
;821:	}
;822:	// if the bot decided to follow someone
;823:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
;824:		// if the team mate being accompanied no longer carries the flag
;825:		BotEntityInfo(bs->teammate, &entinfo);
;826:		if (!EntityCarriesFlag(&entinfo)) {
;827:			bs->ltgtype = 0;
;828:		}
;829:	}
;830:	//our team has the flag
;831:	if (bs->neutralflagstatus == 1) {
;832:		if (bs->owndecision_time < FloatTime()) {
;833:			// if not already following someone
;834:			if (bs->ltgtype != LTG_TEAMACCOMPANY) {
;835:				//if there is a visible team mate flag carrier
;836:				c = BotTeamFlagCarrierVisible(bs);
;837:				if (c >= 0) {
;838:					BotRefuseOrder(bs);
;839:					//follow the flag carrier
;840:					bs->decisionmaker = bs->client;
;841:					bs->ordered = qfalse;
;842:					//the team mate
;843:					bs->teammate = c;
;844:					//last time the team mate was visible
;845:					bs->teammatevisible_time = FloatTime();
;846:					//no message
;847:					bs->teammessage_time = 0;
;848:					//no arrive message
;849:					bs->arrive_time = 1;
;850:					//
;851:					BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
;852:					//get the team goal time
;853:					bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
;854:					bs->ltgtype = LTG_TEAMACCOMPANY;
;855:					bs->formation_dist = 3.5 * 32;		//3.5 meter
;856:					BotSetTeamStatus(bs);
;857:					bs->owndecision_time = FloatTime() + 5;
;858:					return;
;859:				}
;860:			}
;861:			//if already a CTF or team goal
;862:			if (bs->ltgtype == LTG_TEAMHELP ||
;863:					bs->ltgtype == LTG_TEAMACCOMPANY ||
;864:					bs->ltgtype == LTG_DEFENDKEYAREA ||
;865:					bs->ltgtype == LTG_GETFLAG ||
;866:					bs->ltgtype == LTG_RUSHBASE ||
;867:					bs->ltgtype == LTG_CAMPORDER ||
;868:					bs->ltgtype == LTG_PATROL ||
;869:					bs->ltgtype == LTG_ATTACKENEMYBASE ||
;870:					bs->ltgtype == LTG_GETITEM ||
;871:					bs->ltgtype == LTG_MAKELOVE_UNDER ||
;872:					bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;873:				return;
;874:			}
;875:			//if not already attacking the enemy base
;876:			if (bs->ltgtype != LTG_ATTACKENEMYBASE) {
;877:				BotRefuseOrder(bs);
;878:				bs->decisionmaker = bs->client;
;879:				bs->ordered = qfalse;
;880:				//
;881:				if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;882:				else memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;883:				//set the ltg type
;884:				bs->ltgtype = LTG_ATTACKENEMYBASE;
;885:				//set the time the bot will stop getting the flag
;886:				bs->teamgoal_time = FloatTime() + TEAM_ATTACKENEMYBASE_TIME;
;887:				BotSetTeamStatus(bs);
;888:				bs->owndecision_time = FloatTime() + 5;
;889:			}
;890:		}
;891:		return;
;892:	}
;893:	//enemy team has the flag
;894:	else if (bs->neutralflagstatus == 2) {
;895:		if (bs->owndecision_time < FloatTime()) {
;896:			c = BotEnemyFlagCarrierVisible(bs);
;897:			if (c >= 0) {
;898:				//FIXME: attack enemy flag carrier
;899:			}
;900:			//if already a CTF or team goal
;901:			if (bs->ltgtype == LTG_TEAMHELP ||
;902:					bs->ltgtype == LTG_TEAMACCOMPANY ||
;903:					bs->ltgtype == LTG_CAMPORDER ||
;904:					bs->ltgtype == LTG_PATROL ||
;905:					bs->ltgtype == LTG_GETITEM) {
;906:				return;
;907:			}
;908:			// if not already defending the base
;909:			if (bs->ltgtype != LTG_DEFENDKEYAREA) {
;910:				BotRefuseOrder(bs);
;911:				bs->decisionmaker = bs->client;
;912:				bs->ordered = qfalse;
;913:				//
;914:				if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;915:				else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;916:				//set the ltg type
;917:				bs->ltgtype = LTG_DEFENDKEYAREA;
;918:				//set the time the bot stops defending the base
;919:				bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;920:				bs->defendaway_time = 0;
;921:				BotSetTeamStatus(bs);
;922:				bs->owndecision_time = FloatTime() + 5;
;923:			}
;924:		}
;925:		return;
;926:	}
;927:	// don't just do something wait for the bot team leader to give orders
;928:	if (BotTeamLeader(bs)) {
;929:		return;
;930:	}
;931:	// if the bot is ordered to do something
;932:	if ( bs->lastgoal_ltgtype ) {
;933:		bs->teamgoal_time += 60;
;934:	}
;935:	// if the bot decided to do something on it's own and has a last ordered goal
;936:	if ( !bs->ordered && bs->lastgoal_ltgtype ) {
;937:		bs->ltgtype = 0;
;938:	}
;939:	//if already a CTF or team goal
;940:	if (bs->ltgtype == LTG_TEAMHELP ||
;941:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;942:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;943:			bs->ltgtype == LTG_GETFLAG ||
;944:			bs->ltgtype == LTG_RUSHBASE ||
;945:			bs->ltgtype == LTG_RETURNFLAG ||
;946:			bs->ltgtype == LTG_CAMPORDER ||
;947:			bs->ltgtype == LTG_PATROL ||
;948:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;949:			bs->ltgtype == LTG_GETITEM ||
;950:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;951:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;952:		return;
;953:	}
;954:	//
;955:	if (BotSetLastOrderedTask(bs))
;956:		return;
;957:	//
;958:	if (bs->owndecision_time > FloatTime())
;959:		return;;
;960:	//if the bot is roaming
;961:	if (bs->ctfroam_time > FloatTime())
;962:		return;
;963:	//if the bot has anough aggression to decide what to do
;964:	if (BotAggression(bs) < 50)
;965:		return;
;966:	//set the time to send a message to the team mates
;967:	bs->teammessage_time = FloatTime() + 2 * random();
;968:	//
;969:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;970:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;971:			l1 = 0.7f;
;972:		}
;973:		else {
;974:			l1 = 0.2f;
;975:		}
;976:		l2 = 0.9f;
;977:	}
;978:	else {
;979:		l1 = 0.4f;
;980:		l2 = 0.7f;
;981:	}
;982:	//get the flag or defend the base
;983:	rnd = random();
;984:	if (rnd < l1 && ctf_neutralflag.areanum) {
;985:		bs->decisionmaker = bs->client;
;986:		bs->ordered = qfalse;
;987:		bs->ltgtype = LTG_GETFLAG;
;988:		//set the time the bot will stop getting the flag
;989:		bs->teamgoal_time = FloatTime() + CTF_GETFLAG_TIME;
;990:		BotSetTeamStatus(bs);
;991:	}
;992:	else if (rnd < l2 && ctf_redflag.areanum && ctf_blueflag.areanum) {
;993:		bs->decisionmaker = bs->client;
;994:		bs->ordered = qfalse;
;995:		//
;996:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &ctf_redflag, sizeof(bot_goal_t));
;997:		else memcpy(&bs->teamgoal, &ctf_blueflag, sizeof(bot_goal_t));
;998:		//set the ltg type
;999:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1000:		//set the time the bot stops defending the base
;1001:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1002:		bs->defendaway_time = 0;
;1003:		BotSetTeamStatus(bs);
;1004:	}
;1005:	else {
;1006:		bs->ltgtype = 0;
;1007:		//set the time the bot will stop roaming
;1008:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1009:		BotSetTeamStatus(bs);
;1010:	}
;1011:	bs->owndecision_time = FloatTime() + 5;
;1012:#ifdef DEBUG
;1013:	BotPrintTeamGoal(bs);
;1014:#endif //DEBUG
;1015:}
;1016:
;1017:/*
;1018:==================
;1019:Bot1FCTFRetreatGoals
;1020:==================
;1021:*/
;1022:void Bot1FCTFRetreatGoals(bot_state_t *bs) {
;1023:	//when carrying a flag in ctf the bot should rush to the enemy base
;1024:	if (Bot1FCTFCarryingFlag(bs)) {
;1025:		//if not already rushing to the base
;1026:		if (bs->ltgtype != LTG_RUSHBASE) {
;1027:			BotRefuseOrder(bs);
;1028:			bs->ltgtype = LTG_RUSHBASE;
;1029:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1030:			bs->rushbaseaway_time = 0;
;1031:			bs->decisionmaker = bs->client;
;1032:			bs->ordered = qfalse;
;1033:			//get an alternative route goal towards the enemy base
;1034:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1035:			BotSetTeamStatus(bs);
;1036:		}
;1037:	}
;1038:}
;1039:
;1040:/*
;1041:==================
;1042:BotObeliskSeekGoals
;1043:==================
;1044:*/
;1045:void BotObeliskSeekGoals(bot_state_t *bs) {
;1046:	float rnd, l1, l2;
;1047:
;1048:	// don't just do something wait for the bot team leader to give orders
;1049:	if (BotTeamLeader(bs)) {
;1050:		return;
;1051:	}
;1052:	// if the bot is ordered to do something
;1053:	if ( bs->lastgoal_ltgtype ) {
;1054:		bs->teamgoal_time += 60;
;1055:	}
;1056:	//if already a team goal
;1057:	if (bs->ltgtype == LTG_TEAMHELP ||
;1058:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;1059:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;1060:			bs->ltgtype == LTG_GETFLAG ||
;1061:			bs->ltgtype == LTG_RUSHBASE ||
;1062:			bs->ltgtype == LTG_RETURNFLAG ||
;1063:			bs->ltgtype == LTG_CAMPORDER ||
;1064:			bs->ltgtype == LTG_PATROL ||
;1065:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;1066:			bs->ltgtype == LTG_GETITEM ||
;1067:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;1068:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;1069:		return;
;1070:	}
;1071:	//
;1072:	if (BotSetLastOrderedTask(bs))
;1073:		return;
;1074:	//if the bot is roaming
;1075:	if (bs->ctfroam_time > FloatTime())
;1076:		return;
;1077:	//if the bot has anough aggression to decide what to do
;1078:	if (BotAggression(bs) < 50)
;1079:		return;
;1080:	//set the time to send a message to the team mates
;1081:	bs->teammessage_time = FloatTime() + 2 * random();
;1082:	//
;1083:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1084:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1085:			l1 = 0.7f;
;1086:		}
;1087:		else {
;1088:			l1 = 0.2f;
;1089:		}
;1090:		l2 = 0.9f;
;1091:	}
;1092:	else {
;1093:		l1 = 0.4f;
;1094:		l2 = 0.7f;
;1095:	}
;1096:	//get the flag or defend the base
;1097:	rnd = random();
;1098:	if (rnd < l1 && redobelisk.areanum && blueobelisk.areanum) {
;1099:		bs->decisionmaker = bs->client;
;1100:		bs->ordered = qfalse;
;1101:		//
;1102:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1103:		else memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1104:		//set the ltg type
;1105:		bs->ltgtype = LTG_ATTACKENEMYBASE;
;1106:		//set the time the bot will stop attacking the enemy base
;1107:		bs->teamgoal_time = FloatTime() + TEAM_ATTACKENEMYBASE_TIME;
;1108:		//get an alternate route goal towards the enemy base
;1109:		BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1110:		BotSetTeamStatus(bs);
;1111:	}
;1112:	else if (rnd < l2 && redobelisk.areanum && blueobelisk.areanum) {
;1113:		bs->decisionmaker = bs->client;
;1114:		bs->ordered = qfalse;
;1115:		//
;1116:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1117:		else memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1118:		//set the ltg type
;1119:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1120:		//set the time the bot stops defending the base
;1121:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1122:		bs->defendaway_time = 0;
;1123:		BotSetTeamStatus(bs);
;1124:	}
;1125:	else {
;1126:		bs->ltgtype = 0;
;1127:		//set the time the bot will stop roaming
;1128:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1129:		BotSetTeamStatus(bs);
;1130:	}
;1131:}
;1132:
;1133:/*
;1134:==================
;1135:BotGoHarvest
;1136:==================
;1137:*/
;1138:void BotGoHarvest(bot_state_t *bs) {
;1139:	//
;1140:	if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1141:	else memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1142:	//set the ltg type
;1143:	bs->ltgtype = LTG_HARVEST;
;1144:	//set the time the bot will stop harvesting
;1145:	bs->teamgoal_time = FloatTime() + TEAM_HARVEST_TIME;
;1146:	bs->harvestaway_time = 0;
;1147:	BotSetTeamStatus(bs);
;1148:}
;1149:
;1150:/*
;1151:==================
;1152:BotObeliskRetreatGoals
;1153:==================
;1154:*/
;1155:void BotObeliskRetreatGoals(bot_state_t *bs) {
;1156:	//nothing special
;1157:}
;1158:
;1159:/*
;1160:==================
;1161:BotHarvesterSeekGoals
;1162:==================
;1163:*/
;1164:void BotHarvesterSeekGoals(bot_state_t *bs) {
;1165:	aas_entityinfo_t entinfo;
;1166:	float rnd, l1, l2;
;1167:	int c;
;1168:
;1169:	//when carrying cubes in harvester the bot should rush to the base
;1170:	if (BotHarvesterCarryingCubes(bs)) {
;1171:		//if not already rushing to the base
;1172:		if (bs->ltgtype != LTG_RUSHBASE) {
;1173:			BotRefuseOrder(bs);
;1174:			bs->ltgtype = LTG_RUSHBASE;
;1175:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1176:			bs->rushbaseaway_time = 0;
;1177:			bs->decisionmaker = bs->client;
;1178:			bs->ordered = qfalse;
;1179:			//get an alternative route goal towards the enemy base
;1180:			BotGetAlternateRouteGoal(bs, BotOppositeTeam(bs));
;1181:			//
;1182:			BotSetTeamStatus(bs);
;1183:		}
;1184:		return;
;1185:	}
;1186:	// don't just do something wait for the bot team leader to give orders
;1187:	if (BotTeamLeader(bs)) {
;1188:		return;
;1189:	}
;1190:	// if the bot decided to follow someone
;1191:	if ( bs->ltgtype == LTG_TEAMACCOMPANY && !bs->ordered ) {
;1192:		// if the team mate being accompanied no longer carries the flag
;1193:		BotEntityInfo(bs->teammate, &entinfo);
;1194:		if (!EntityCarriesCubes(&entinfo)) {
;1195:			bs->ltgtype = 0;
;1196:		}
;1197:	}
;1198:	// if the bot is ordered to do something
;1199:	if ( bs->lastgoal_ltgtype ) {
;1200:		bs->teamgoal_time += 60;
;1201:	}
;1202:	//if not yet doing something
;1203:	if (bs->ltgtype == LTG_TEAMHELP ||
;1204:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;1205:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;1206:			bs->ltgtype == LTG_GETFLAG ||
;1207:			bs->ltgtype == LTG_CAMPORDER ||
;1208:			bs->ltgtype == LTG_PATROL ||
;1209:			bs->ltgtype == LTG_ATTACKENEMYBASE ||
;1210:			bs->ltgtype == LTG_HARVEST ||
;1211:			bs->ltgtype == LTG_GETITEM ||
;1212:			bs->ltgtype == LTG_MAKELOVE_UNDER ||
;1213:			bs->ltgtype == LTG_MAKELOVE_ONTOP) {
;1214:		return;
;1215:	}
;1216:	//
;1217:	if (BotSetLastOrderedTask(bs))
;1218:		return;
;1219:	//if the bot is roaming
;1220:	if (bs->ctfroam_time > FloatTime())
;1221:		return;
;1222:	//if the bot has anough aggression to decide what to do
;1223:	if (BotAggression(bs) < 50)
;1224:		return;
;1225:	//set the time to send a message to the team mates
;1226:	bs->teammessage_time = FloatTime() + 2 * random();
;1227:	//
;1228:	c = BotEnemyCubeCarrierVisible(bs);
;1229:	if (c >= 0) {
;1230:		//FIXME: attack enemy cube carrier
;1231:	}
;1232:	if (bs->ltgtype != LTG_TEAMACCOMPANY) {
;1233:		//if there is a visible team mate carrying cubes
;1234:		c = BotTeamCubeCarrierVisible(bs);
;1235:		if (c >= 0) {
;1236:			//follow the team mate carrying cubes
;1237:			bs->decisionmaker = bs->client;
;1238:			bs->ordered = qfalse;
;1239:			//the team mate
;1240:			bs->teammate = c;
;1241:			//last time the team mate was visible
;1242:			bs->teammatevisible_time = FloatTime();
;1243:			//no message
;1244:			bs->teammessage_time = 0;
;1245:			//no arrive message
;1246:			bs->arrive_time = 1;
;1247:			//
;1248:			BotVoiceChat(bs, bs->teammate, VOICECHAT_ONFOLLOW);
;1249:			//get the team goal time
;1250:			bs->teamgoal_time = FloatTime() + TEAM_ACCOMPANY_TIME;
;1251:			bs->ltgtype = LTG_TEAMACCOMPANY;
;1252:			bs->formation_dist = 3.5 * 32;		//3.5 meter
;1253:			BotSetTeamStatus(bs);
;1254:			return;
;1255:		}
;1256:	}
;1257:	//
;1258:	if (bs->teamtaskpreference & (TEAMTP_ATTACKER|TEAMTP_DEFENDER)) {
;1259:		if (bs->teamtaskpreference & TEAMTP_ATTACKER) {
;1260:			l1 = 0.7f;
;1261:		}
;1262:		else {
;1263:			l1 = 0.2f;
;1264:		}
;1265:		l2 = 0.9f;
;1266:	}
;1267:	else {
;1268:		l1 = 0.4f;
;1269:		l2 = 0.7f;
;1270:	}
;1271:	//
;1272:	rnd = random();
;1273:	if (rnd < l1 && redobelisk.areanum && blueobelisk.areanum) {
;1274:		bs->decisionmaker = bs->client;
;1275:		bs->ordered = qfalse;
;1276:		BotGoHarvest(bs);
;1277:	}
;1278:	else if (rnd < l2 && redobelisk.areanum && blueobelisk.areanum) {
;1279:		bs->decisionmaker = bs->client;
;1280:		bs->ordered = qfalse;
;1281:		//
;1282:		if (BotTeam(bs) == TEAM_RED) memcpy(&bs->teamgoal, &redobelisk, sizeof(bot_goal_t));
;1283:		else memcpy(&bs->teamgoal, &blueobelisk, sizeof(bot_goal_t));
;1284:		//set the ltg type
;1285:		bs->ltgtype = LTG_DEFENDKEYAREA;
;1286:		//set the time the bot stops defending the base
;1287:		bs->teamgoal_time = FloatTime() + TEAM_DEFENDKEYAREA_TIME;
;1288:		bs->defendaway_time = 0;
;1289:		BotSetTeamStatus(bs);
;1290:	}
;1291:	else {
;1292:		bs->ltgtype = 0;
;1293:		//set the time the bot will stop roaming
;1294:		bs->ctfroam_time = FloatTime() + CTF_ROAM_TIME;
;1295:		BotSetTeamStatus(bs);
;1296:	}
;1297:}
;1298:
;1299:/*
;1300:==================
;1301:BotHarvesterRetreatGoals
;1302:==================
;1303:*/
;1304:void BotHarvesterRetreatGoals(bot_state_t *bs) {
;1305:	//when carrying cubes in harvester the bot should rush to the base
;1306:	if (BotHarvesterCarryingCubes(bs)) {
;1307:		//if not already rushing to the base
;1308:		if (bs->ltgtype != LTG_RUSHBASE) {
;1309:			BotRefuseOrder(bs);
;1310:			bs->ltgtype = LTG_RUSHBASE;
;1311:			bs->teamgoal_time = FloatTime() + CTF_RUSHBASE_TIME;
;1312:			bs->rushbaseaway_time = 0;
;1313:			bs->decisionmaker = bs->client;
;1314:			bs->ordered = qfalse;
;1315:			BotSetTeamStatus(bs);
;1316:		}
;1317:		return;
;1318:	}
;1319:}
;1320:#endif
;1321:
;1322:/*
;1323:==================
;1324:BotTeamGoals
;1325:==================
;1326:*/
;1327:void BotTeamGoals(bot_state_t *bs, int retreat) {
line 1329
;1328:
;1329:	if( g_assaultMode.integer ) {
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 0
EQI4 $250
line 1330
;1330:		BotAssaultSeekGoals( bs );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotAssaultSeekGoals
CALLV
pop
line 1331
;1331:		bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 1332
;1332:		return;
ADDRGP4 $249
JUMPV
LABELV $250
line 1335
;1333:	}
;1334:
;1335:	if ( retreat ) {
ADDRFP4 4
INDIRI4
CNSTI4 0
EQI4 $253
line 1336
;1336:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $254
line 1337
;1337:			BotCTFRetreatGoals(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCTFRetreatGoals
CALLV
pop
line 1338
;1338:		}
line 1350
;1339:#ifdef MISSIONPACK
;1340:		else if (gametype == GT_1FCTF) {
;1341:			Bot1FCTFRetreatGoals(bs);
;1342:		}
;1343:		else if (gametype == GT_OBELISK) {
;1344:			BotObeliskRetreatGoals(bs);
;1345:		}
;1346:		else if (gametype == GT_HARVESTER) {
;1347:			BotHarvesterRetreatGoals(bs);
;1348:		}
;1349:#endif
;1350:	}
ADDRGP4 $254
JUMPV
LABELV $253
line 1351
;1351:	else {
line 1352
;1352:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $257
line 1354
;1353:			//decide what to do in CTF mode
;1354:			BotCTFSeekGoals(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCTFSeekGoals
CALLV
pop
line 1355
;1355:		}
LABELV $257
line 1367
;1356:#ifdef MISSIONPACK
;1357:		else if (gametype == GT_1FCTF) {
;1358:			Bot1FCTFSeekGoals(bs);
;1359:		}
;1360:		else if (gametype == GT_OBELISK) {
;1361:			BotObeliskSeekGoals(bs);
;1362:		}
;1363:		else if (gametype == GT_HARVESTER) {
;1364:			BotHarvesterSeekGoals(bs);
;1365:		}
;1366:#endif
;1367:	}
LABELV $254
line 1370
;1368:	// reset the order time which is used to see if
;1369:	// we decided to refuse an order
;1370:	bs->order_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6616
ADDP4
CNSTF4 0
ASGNF4
line 1371
;1371:}
LABELV $249
endproc BotTeamGoals 0 4
export BotPointAreaNum
proc BotPointAreaNum 68 20
line 1378
;1372:
;1373:/*
;1374:==================
;1375:BotPointAreaNum
;1376:==================
;1377:*/
;1378:int BotPointAreaNum(vec3_t origin) {
line 1382
;1379:	int areanum, numareas, areas[10];
;1380:	vec3_t end;
;1381:
;1382:	areanum = trap_AAS_PointAreaNum(origin);
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
line 1383
;1383:	if (areanum) return areanum;
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $260
ADDRLP4 12
INDIRI4
RETI4
ADDRGP4 $259
JUMPV
LABELV $260
line 1384
;1384:	VectorCopy(origin, end);
ADDRLP4 0
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 1385
;1385:	end[2] += 10;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
line 1386
;1386:	numareas = trap_AAS_TraceAreas(origin, end, areas, NULL, 10);
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
line 1387
;1387:	if (numareas > 0) return areas[0];
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $263
ADDRLP4 20
INDIRI4
RETI4
ADDRGP4 $259
JUMPV
LABELV $263
line 1388
;1388:	return 0;
CNSTI4 0
RETI4
LABELV $259
endproc BotPointAreaNum 68 20
export ClientName
proc ClientName 1032 12
line 1396
;1389:}
;1390:
;1391:/*
;1392:==================
;1393:ClientName
;1394:==================
;1395:*/
;1396:char *ClientName(int client, char *name, int size) {
line 1399
;1397:	char buf[MAX_INFO_STRING];
;1398:
;1399:	if (client < 0 || client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $268
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $266
LABELV $268
line 1400
;1400:		BotAI_Print(PRT_ERROR, "ClientName: client out of range\n");
CNSTI4 3
ARGI4
ADDRGP4 $269
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 1401
;1401:		return "[client out of range]";
ADDRGP4 $270
RETP4
ADDRGP4 $265
JUMPV
LABELV $266
line 1403
;1402:	}
;1403:	trap_GetConfigstring(CS_PLAYERS+client, buf, sizeof(buf));
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
line 1404
;1404:	strncpy(name, Info_ValueForKey(buf, "n"), size-1);
ADDRLP4 0
ARGP4
ADDRGP4 $271
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
line 1405
;1405:	name[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1406
;1406:	Q_CleanStr( name );
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1407
;1407:	return name;
ADDRFP4 4
INDIRP4
RETP4
LABELV $265
endproc ClientName 1032 12
export ClientSkin
proc ClientSkin 1032 12
line 1415
;1408:}
;1409:
;1410:/*
;1411:==================
;1412:ClientSkin
;1413:==================
;1414:*/
;1415:char *ClientSkin(int client, char *skin, int size) {
line 1418
;1416:	char buf[MAX_INFO_STRING];
;1417:
;1418:	if (client < 0 || client >= MAX_CLIENTS) {
ADDRLP4 1024
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 1024
INDIRI4
CNSTI4 0
LTI4 $275
ADDRLP4 1024
INDIRI4
CNSTI4 64
LTI4 $273
LABELV $275
line 1419
;1419:		BotAI_Print(PRT_ERROR, "ClientSkin: client out of range\n");
CNSTI4 3
ARGI4
ADDRGP4 $276
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 1420
;1420:		return "[client out of range]";
ADDRGP4 $270
RETP4
ADDRGP4 $272
JUMPV
LABELV $273
line 1422
;1421:	}
;1422:	trap_GetConfigstring(CS_PLAYERS+client, buf, sizeof(buf));
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
line 1423
;1423:	strncpy(skin, Info_ValueForKey(buf, "model"), size-1);
ADDRLP4 0
ARGP4
ADDRGP4 $277
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
line 1424
;1424:	skin[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1425
;1425:	return skin;
ADDRFP4 4
INDIRP4
RETP4
LABELV $272
endproc ClientSkin 1032 12
bss
align 4
LABELV $279
skip 4
export ClientFromName
code
proc ClientFromName 1040 12
line 1433
;1426:}
;1427:
;1428:/*
;1429:==================
;1430:ClientFromName
;1431:==================
;1432:*/
;1433:int ClientFromName(char *name) {
line 1438
;1434:	int i;
;1435:	char buf[MAX_INFO_STRING];
;1436:	static int maxclients;
;1437:
;1438:	if (!maxclients)
ADDRGP4 $279
INDIRI4
CNSTI4 0
NEI4 $280
line 1439
;1439:		maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $282
ARGP4
ADDRLP4 1028
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 $279
ADDRLP4 1028
INDIRI4
ASGNI4
LABELV $280
line 1440
;1440:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $286
JUMPV
LABELV $283
line 1441
;1441:		trap_GetConfigstring(CS_PLAYERS+i, buf, sizeof(buf));
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
line 1442
;1442:		Q_CleanStr( buf );
ADDRLP4 4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1443
;1443:		if (!Q_stricmp(Info_ValueForKey(buf, "n"), name)) return i;
ADDRLP4 4
ARGP4
ADDRGP4 $271
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
NEI4 $287
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $278
JUMPV
LABELV $287
line 1444
;1444:	}
LABELV $284
line 1440
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $286
ADDRLP4 0
INDIRI4
ADDRGP4 $279
INDIRI4
GEI4 $289
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $283
LABELV $289
line 1445
;1445:	return -1;
CNSTI4 -1
RETI4
LABELV $278
endproc ClientFromName 1040 12
bss
align 4
LABELV $291
skip 4
export ClientOnSameTeamFromName
code
proc ClientOnSameTeamFromName 1044 12
line 1453
;1446:}
;1447:
;1448:/*
;1449:==================
;1450:ClientOnSameTeamFromName
;1451:==================
;1452:*/
;1453:int ClientOnSameTeamFromName(bot_state_t *bs, char *name) {
line 1458
;1454:	int i;
;1455:	char buf[MAX_INFO_STRING];
;1456:	static int maxclients;
;1457:
;1458:	if (!maxclients)
ADDRGP4 $291
INDIRI4
CNSTI4 0
NEI4 $292
line 1459
;1459:		maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $282
ARGP4
ADDRLP4 1028
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 $291
ADDRLP4 1028
INDIRI4
ASGNI4
LABELV $292
line 1460
;1460:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $297
JUMPV
LABELV $294
line 1461
;1461:		if (!BotSameTeam(bs, i))
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
NEI4 $298
line 1462
;1462:			continue;
ADDRGP4 $295
JUMPV
LABELV $298
line 1463
;1463:		trap_GetConfigstring(CS_PLAYERS+i, buf, sizeof(buf));
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
line 1464
;1464:		Q_CleanStr( buf );
ADDRLP4 4
ARGP4
ADDRGP4 Q_CleanStr
CALLP4
pop
line 1465
;1465:		if (!Q_stricmp(Info_ValueForKey(buf, "n"), name)) return i;
ADDRLP4 4
ARGP4
ADDRGP4 $271
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
NEI4 $300
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $290
JUMPV
LABELV $300
line 1466
;1466:	}
LABELV $295
line 1460
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $297
ADDRLP4 0
INDIRI4
ADDRGP4 $291
INDIRI4
GEI4 $302
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $294
LABELV $302
line 1467
;1467:	return -1;
CNSTI4 -1
RETI4
LABELV $290
endproc ClientOnSameTeamFromName 1044 12
export stristr
proc stristr 12 4
line 1475
;1468:}
;1469:
;1470:/*
;1471:==================
;1472:stristr
;1473:==================
;1474:*/
;1475:char *stristr(char *str, char *charset) {
ADDRGP4 $305
JUMPV
LABELV $304
line 1478
;1476:	int i;
;1477:
;1478:	while(*str) {
line 1479
;1479:		for (i = 0; charset[i] && str[i]; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $310
JUMPV
LABELV $307
line 1480
;1480:			if (toupper(charset[i]) != toupper(str[i])) break;
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
EQI4 $311
ADDRGP4 $309
JUMPV
LABELV $311
line 1481
;1481:		}
LABELV $308
line 1479
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $310
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
EQI4 $313
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
CVII4 1
ADDRLP4 8
INDIRI4
NEI4 $307
LABELV $313
LABELV $309
line 1482
;1482:		if (!charset[i]) return str;
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRP4
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $314
ADDRFP4 0
INDIRP4
RETP4
ADDRGP4 $303
JUMPV
LABELV $314
line 1483
;1483:		str++;
ADDRFP4 0
ADDRFP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1484
;1484:	}
LABELV $305
line 1478
ADDRFP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $304
line 1485
;1485:	return NULL;
CNSTP4 0
RETP4
LABELV $303
endproc stristr 12 4
export EasyClientName
proc EasyClientName 204 12
line 1493
;1486:}
;1487:
;1488:/*
;1489:==================
;1490:EasyClientName
;1491:==================
;1492:*/
;1493:char *EasyClientName(int client, char *buf, int size) {
line 1498
;1494:	int i;
;1495:	char *str1, *str2, *ptr, c;
;1496:	char name[128];
;1497:
;1498:	strcpy(name, ClientName(client, name, sizeof(name)));
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
line 1499
;1499:	for (i = 0; name[i]; i++) name[i] &= 127;
ADDRLP4 136
CNSTI4 0
ASGNI4
ADDRGP4 $320
JUMPV
LABELV $317
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
LABELV $318
ADDRLP4 136
ADDRLP4 136
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $320
ADDRLP4 136
INDIRI4
ADDRLP4 5
ADDP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $317
line 1501
;1500:	//remove all spaces
;1501:	for (ptr = strstr(name, " "); ptr; ptr = strstr(name, " ")) {
ADDRLP4 5
ARGP4
ADDRGP4 $325
ARGP4
ADDRLP4 156
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 156
INDIRP4
ASGNP4
ADDRGP4 $324
JUMPV
LABELV $321
line 1502
;1502:		memmove(ptr, ptr+1, strlen(ptr+1)+1);
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
line 1503
;1503:	}
LABELV $322
line 1501
ADDRLP4 5
ARGP4
ADDRGP4 $325
ARGP4
ADDRLP4 160
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 160
INDIRP4
ASGNP4
LABELV $324
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $321
line 1505
;1504:	//check for [x] and ]x[ clan names
;1505:	str1 = strstr(name, "[");
ADDRLP4 5
ARGP4
ADDRGP4 $326
ARGP4
ADDRLP4 164
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 140
ADDRLP4 164
INDIRP4
ASGNP4
line 1506
;1506:	str2 = strstr(name, "]");
ADDRLP4 5
ARGP4
ADDRGP4 $327
ARGP4
ADDRLP4 168
ADDRGP4 strstr
CALLP4
ASGNP4
ADDRLP4 144
ADDRLP4 168
INDIRP4
ASGNP4
line 1507
;1507:	if (str1 && str2) {
ADDRLP4 172
CNSTU4 0
ASGNU4
ADDRLP4 140
INDIRP4
CVPU4 4
ADDRLP4 172
INDIRU4
EQU4 $328
ADDRLP4 144
INDIRP4
CVPU4 4
ADDRLP4 172
INDIRU4
EQU4 $328
line 1508
;1508:		if (str2 > str1) memmove(str1, str2+1, strlen(str2+1)+1);
ADDRLP4 144
INDIRP4
CVPU4 4
ADDRLP4 140
INDIRP4
CVPU4 4
LEU4 $330
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
ADDRGP4 $331
JUMPV
LABELV $330
line 1509
;1509:		else memmove(str2, str1+1, strlen(str1+1)+1);
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
LABELV $331
line 1510
;1510:	}
LABELV $328
line 1512
;1511:	//remove Mr prefix
;1512:	if ((name[0] == 'm' || name[0] == 'M') &&
ADDRLP4 176
ADDRLP4 5
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 109
EQI4 $336
ADDRLP4 176
INDIRI4
CNSTI4 77
NEI4 $332
LABELV $336
ADDRLP4 5+1
INDIRI1
CVII4 1
CNSTI4 114
EQI4 $337
ADDRLP4 5+1
INDIRI1
CVII4 1
CNSTI4 82
NEI4 $332
LABELV $337
line 1513
;1513:			(name[1] == 'r' || name[1] == 'R')) {
line 1514
;1514:		memmove(name, name+2, strlen(name+2)+1);
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
line 1515
;1515:	}
LABELV $332
line 1517
;1516:	//only allow lower case alphabet characters
;1517:	ptr = name;
ADDRLP4 0
ADDRLP4 5
ASGNP4
ADDRGP4 $341
JUMPV
LABELV $340
line 1518
;1518:	while(*ptr) {
line 1519
;1519:		c = *ptr;
ADDRLP4 4
ADDRLP4 0
INDIRP4
INDIRI1
ASGNI1
line 1520
;1520:		if ((c >= 'a' && c <= 'z') ||
ADDRLP4 180
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 97
LTI4 $346
ADDRLP4 180
INDIRI4
CNSTI4 122
LEI4 $347
LABELV $346
ADDRLP4 184
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 48
LTI4 $348
ADDRLP4 184
INDIRI4
CNSTI4 57
LEI4 $347
LABELV $348
ADDRLP4 4
INDIRI1
CVII4 1
CNSTI4 95
NEI4 $343
LABELV $347
line 1521
;1521:				(c >= '0' && c <= '9') || c == '_') {
line 1522
;1522:			ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1523
;1523:		}
ADDRGP4 $344
JUMPV
LABELV $343
line 1524
;1524:		else if (c >= 'A' && c <= 'Z') {
ADDRLP4 188
ADDRLP4 4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 188
INDIRI4
CNSTI4 65
LTI4 $349
ADDRLP4 188
INDIRI4
CNSTI4 90
GTI4 $349
line 1525
;1525:			*ptr += 'a' - 'A';
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
line 1526
;1526:			ptr++;
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
line 1527
;1527:		}
ADDRGP4 $350
JUMPV
LABELV $349
line 1528
;1528:		else {
line 1529
;1529:			memmove(ptr, ptr+1, strlen(ptr + 1)+1);
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
line 1530
;1530:		}
LABELV $350
LABELV $344
line 1531
;1531:	}
LABELV $341
line 1518
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $340
line 1532
;1532:	strncpy(buf, name, size-1);
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
line 1533
;1533:	buf[size-1] = '\0';
ADDRFP4 8
INDIRI4
CNSTI4 1
SUBI4
ADDRFP4 4
INDIRP4
ADDP4
CNSTI1 0
ASGNI1
line 1534
;1534:	return buf;
ADDRFP4 4
INDIRP4
RETP4
LABELV $316
endproc EasyClientName 204 12
export BotSynonymContext
proc BotSynonymContext 8 4
line 1542
;1535:}
;1536:
;1537:/*
;1538:==================
;1539:BotSynonymContext
;1540:==================
;1541:*/
;1542:int BotSynonymContext(bot_state_t *bs) {
line 1545
;1543:	int context;
;1544:
;1545:	context = CONTEXT_NORMAL|CONTEXT_NEARBYITEM|CONTEXT_NAMES;
ADDRLP4 0
CNSTI4 1027
ASGNI4
line 1547
;1546:	//
;1547:	if (gametype == GT_CTF
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $352
line 1551
;1548:#ifdef MISSIONPACK
;1549:		|| gametype == GT_1FCTF
;1550:#endif
;1551:		) {
line 1552
;1552:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_CTFREDTEAM;
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
NEI4 $354
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 4
BORI4
ASGNI4
ADDRGP4 $355
JUMPV
LABELV $354
line 1553
;1553:		else context |= CONTEXT_CTFBLUETEAM;
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 8
BORI4
ASGNI4
LABELV $355
line 1554
;1554:	}
LABELV $352
line 1565
;1555:#ifdef MISSIONPACK
;1556:	else if (gametype == GT_OBELISK) {
;1557:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_OBELISKREDTEAM;
;1558:		else context |= CONTEXT_OBELISKBLUETEAM;
;1559:	}
;1560:	else if (gametype == GT_HARVESTER) {
;1561:		if (BotTeam(bs) == TEAM_RED) context |= CONTEXT_HARVESTERREDTEAM;
;1562:		else context |= CONTEXT_HARVESTERBLUETEAM;
;1563:	}
;1564:#endif
;1565:	return context;
ADDRLP4 0
INDIRI4
RETI4
LABELV $351
endproc BotSynonymContext 8 4
export BotChooseWeapon
proc BotChooseWeapon 20 8
line 1573
;1566:}
;1567:
;1568:/*
;1569:==================
;1570:BotChooseWeapon
;1571:==================
;1572:*/
;1573:void BotChooseWeapon(bot_state_t *bs) {
line 1576
;1574:	int newweaponnum;
;1575:
;1576:	if (bs->cur_ps.weaponstate == WEAPON_RAISING ||
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
EQI4 $359
ADDRLP4 4
INDIRI4
CNSTI4 2
NEI4 $357
LABELV $359
line 1577
;1577:			bs->cur_ps.weaponstate == WEAPON_DROPPING) {
line 1579
;1578:		//trap_EA_SelectWeapon(bs->client, bs->weaponnum);
;1579:		if( g_blasterMode.integer &&
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $360
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $360
line 1580
;1580:			bs->weaponnum == WP_MACHINEGUN ) {
line 1581
;1581:			trap_EA_SelectWeapon(
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
line 1585
;1582:				bs->client,
;1583:				WP_BLASTER
;1584:			);
;1585:		}
ADDRGP4 $358
JUMPV
LABELV $360
line 1586
;1586:		else {
line 1587
;1587:			trap_EA_SelectWeapon(
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
line 1591
;1588:				bs->client,
;1589:				bs->weaponnum
;1590:			);
;1591:		}
line 1592
;1592:		}
ADDRGP4 $358
JUMPV
LABELV $357
line 1593
;1593:	else {
line 1594
;1594:		newweaponnum = trap_BotChooseBestFightWeapon(bs->ws, bs->inventory);
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
line 1595
;1595:		if (bs->weaponnum != newweaponnum) bs->weaponchange_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $363
ADDRFP4 0
INDIRP4
CNSTI4 6192
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
LABELV $363
line 1596
;1596:		bs->weaponnum = newweaponnum;
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
line 1599
;1597:		//BotAI_Print(PRT_MESSAGE, "bs->weaponnum = %d\n", bs->weaponnum);
;1598:		//trap_EA_SelectWeapon(bs->client, bs->weaponnum);
;1599:		if( g_blasterMode.integer &&
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $365
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $365
line 1600
;1600:			bs->weaponnum == WP_MACHINEGUN ) {
line 1601
;1601:			trap_EA_SelectWeapon(
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
line 1605
;1602:				bs->client,
;1603:				WP_BLASTER
;1604:			);
;1605:		}
ADDRGP4 $366
JUMPV
LABELV $365
line 1606
;1606:		else {
line 1607
;1607:			trap_EA_SelectWeapon(
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
line 1611
;1608:				bs->client,
;1609:				bs->weaponnum
;1610:			);
;1611:		}
LABELV $366
line 1612
;1612:	}
LABELV $358
line 1613
;1613:}
LABELV $356
endproc BotChooseWeapon 20 8
export BotSetupForMovement
proc BotSetupForMovement 88 12
line 1620
;1614:
;1615:/*
;1616:==================
;1617:BotSetupForMovement
;1618:==================
;1619:*/
;1620:void BotSetupForMovement(bot_state_t *bs) {
line 1623
;1621:	bot_initmove_t initmove;
;1622:
;1623:	memset(&initmove, 0, sizeof(bot_initmove_t));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 68
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1624
;1624:	VectorCopy(bs->cur_ps.origin, initmove.origin);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRB
ASGNB 12
line 1625
;1625:	VectorCopy(bs->cur_ps.velocity, initmove.velocity);
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
INDIRB
ASGNB 12
line 1626
;1626:	VectorClear(initmove.viewoffset);
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
line 1627
;1627:	initmove.viewoffset[2] += bs->cur_ps.viewheight;
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
line 1628
;1628:	initmove.entitynum = bs->entitynum;
ADDRLP4 0+36
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
line 1629
;1629:	initmove.client = bs->client;
ADDRLP4 0+40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 1630
;1630:	initmove.thinktime = bs->thinktime;
ADDRLP4 0+44
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
ASGNF4
line 1632
;1631:	//set the onground flag
;1632:	if (bs->cur_ps.groundEntityNum != ENTITYNUM_NONE) initmove.or_moveflags |= MFL_ONGROUND;
ADDRFP4 0
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
CNSTI4 1023
EQI4 $380
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 2
BORI4
ASGNI4
LABELV $380
line 1634
;1633:	//set the teleported flag
;1634:	if ((bs->cur_ps.pm_flags & PMF_TIME_KNOCKBACK) && (bs->cur_ps.pm_time > 0)) {
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
EQI4 $383
ADDRLP4 72
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
LEI4 $383
line 1635
;1635:		initmove.or_moveflags |= MFL_TELEPORTED;
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 1636
;1636:	}
LABELV $383
line 1638
;1637:	//set the waterjump flag
;1638:	if ((bs->cur_ps.pm_flags & PMF_TIME_WATERJUMP) && (bs->cur_ps.pm_time > 0)) {
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
EQI4 $386
ADDRLP4 80
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
LEI4 $386
line 1639
;1639:		initmove.or_moveflags |= MFL_WATERJUMP;
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 1640
;1640:	}
LABELV $386
line 1642
;1641:	//set presence type
;1642:	if (bs->cur_ps.pm_flags & PMF_DUCKED) initmove.presencetype = PRESENCE_CROUCH;
ADDRFP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $389
ADDRLP4 0+48
CNSTI4 4
ASGNI4
ADDRGP4 $390
JUMPV
LABELV $389
line 1643
;1643:	else initmove.presencetype = PRESENCE_NORMAL;
ADDRLP4 0+48
CNSTI4 2
ASGNI4
LABELV $390
line 1645
;1644:	//
;1645:	if (bs->walker > 0.5) initmove.or_moveflags |= MFL_WALK;
ADDRFP4 0
INDIRP4
CNSTI4 6056
ADDP4
INDIRF4
CNSTF4 1056964608
LEF4 $393
ADDRLP4 0+64
ADDRLP4 0+64
INDIRI4
CNSTI4 512
BORI4
ASGNI4
LABELV $393
line 1647
;1646:	//
;1647:	VectorCopy(bs->viewangles, initmove.viewangles);
ADDRLP4 0+52
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
INDIRB
ASGNB 12
line 1649
;1648:	//
;1649:	trap_BotInitMoveState(bs->ms, &initmove);
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
line 1650
;1650:}
LABELV $368
endproc BotSetupForMovement 88 12
export BotCheckItemPickup
proc BotCheckItemPickup 0 0
line 1657
;1651:
;1652:/*
;1653:==================
;1654:BotCheckItemPickup
;1655:==================
;1656:*/
;1657:void BotCheckItemPickup(bot_state_t *bs, int *oldinventory) {
line 1744
;1658:#ifdef MISSIONPACK
;1659:	int offence, leader;
;1660:
;1661:	if (gametype <= GT_TEAM)
;1662:		return;
;1663:
;1664:	offence = -1;
;1665:	// go into offence if picked up the kamikaze or invulnerability
;1666:	if (!oldinventory[INVENTORY_KAMIKAZE] && bs->inventory[INVENTORY_KAMIKAZE] >= 1) {
;1667:		offence = qtrue;
;1668:	}
;1669:	if (!oldinventory[INVENTORY_INVULNERABILITY] && bs->inventory[INVENTORY_INVULNERABILITY] >= 1) {
;1670:		offence = qtrue;
;1671:	}
;1672:	// if not already wearing the kamikaze or invulnerability
;1673:	if (!bs->inventory[INVENTORY_KAMIKAZE] && !bs->inventory[INVENTORY_INVULNERABILITY]) {
;1674:		if (!oldinventory[INVENTORY_SCOUT] && bs->inventory[INVENTORY_SCOUT] >= 1) {
;1675:			offence = qtrue;
;1676:		}
;1677:		if (!oldinventory[INVENTORY_GUARD] && bs->inventory[INVENTORY_GUARD] >= 1) {
;1678:			offence = qtrue;
;1679:		}
;1680:		if (!oldinventory[INVENTORY_DOUBLER] && bs->inventory[INVENTORY_DOUBLER] >= 1) {
;1681:			offence = qfalse;
;1682:		}
;1683:		if (!oldinventory[INVENTORY_AMMOREGEN] && bs->inventory[INVENTORY_AMMOREGEN] >= 1) {
;1684:			offence = qfalse;
;1685:		}
;1686:	}
;1687:
;1688:	if (offence >= 0) {
;1689:		leader = ClientFromName(bs->teamleader);
;1690:		if (offence) {
;1691:			if (!(bs->teamtaskpreference & TEAMTP_ATTACKER)) {
;1692:				// if we have a bot team leader
;1693:				if (BotTeamLeader(bs)) {
;1694:					// tell the leader we want to be on offence
;1695:					BotVoiceChat(bs, leader, VOICECHAT_WANTONOFFENSE);
;1696:					//BotAI_BotInitialChat(bs, "wantoffence", NULL);
;1697:					//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1698:				}
;1699:				else if (g_spSkill.integer <= 3) {
;1700:					if ( bs->ltgtype != LTG_GETFLAG &&
;1701:						 bs->ltgtype != LTG_ATTACKENEMYBASE &&
;1702:						 bs->ltgtype != LTG_HARVEST ) {
;1703:						//
;1704:						if ((gametype != GT_CTF || (bs->redflagstatus == 0 && bs->blueflagstatus == 0)) &&
;1705:							(gametype != GT_1FCTF || bs->neutralflagstatus == 0) ) {
;1706:							// tell the leader we want to be on offence
;1707:							BotVoiceChat(bs, leader, VOICECHAT_WANTONOFFENSE);
;1708:							//BotAI_BotInitialChat(bs, "wantoffence", NULL);
;1709:							//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1710:						}
;1711:					}
;1712:					bs->teamtaskpreference |= TEAMTP_ATTACKER;
;1713:				}
;1714:			}
;1715:			bs->teamtaskpreference &= ~TEAMTP_DEFENDER;
;1716:		}
;1717:		else {
;1718:			if (!(bs->teamtaskpreference & TEAMTP_DEFENDER)) {
;1719:				// if we have a bot team leader
;1720:				if (BotTeamLeader(bs)) {
;1721:					// tell the leader we want to be on defense
;1722:					BotVoiceChat(bs, -1, VOICECHAT_WANTONDEFENSE);
;1723:					//BotAI_BotInitialChat(bs, "wantdefence", NULL);
;1724:					//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1725:				}
;1726:				else if (g_spSkill.integer <= 3) {
;1727:					if ( bs->ltgtype != LTG_DEFENDKEYAREA ) {
;1728:						//
;1729:						if ((gametype != GT_CTF || (bs->redflagstatus == 0 && bs->blueflagstatus == 0)) &&
;1730:							(gametype != GT_1FCTF || bs->neutralflagstatus == 0) ) {
;1731:							// tell the leader we want to be on defense
;1732:							BotVoiceChat(bs, -1, VOICECHAT_WANTONDEFENSE);
;1733:							//BotAI_BotInitialChat(bs, "wantdefence", NULL);
;1734:							//trap_BotEnterChat(bs->cs, leader, CHAT_TELL);
;1735:						}
;1736:					}
;1737:				}
;1738:				bs->teamtaskpreference |= TEAMTP_DEFENDER;
;1739:			}
;1740:			bs->teamtaskpreference &= ~TEAMTP_ATTACKER;
;1741:		}
;1742:	}
;1743:#endif
;1744:}
LABELV $397
endproc BotCheckItemPickup 0 0
export BotUpdateInventory
proc BotUpdateInventory 1216 12
line 1751
;1745:
;1746:/*
;1747:==================
;1748:BotUpdateInventory
;1749:==================
;1750:*/
;1751:void BotUpdateInventory(bot_state_t *bs) {
line 1754
;1752:	int oldinventory[MAX_ITEMS];
;1753:
;1754:	memcpy(oldinventory, bs->inventory, sizeof(oldinventory));
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
line 1756
;1755:	//armor
;1756:	bs->inventory[INVENTORY_ARMOR] = bs->cur_ps.stats[STAT_ARMOR];
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
line 1758
;1757:	//weapons
;1758:	bs->inventory[INVENTORY_GAUNTLET] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GAUNTLET)) != 0;
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
EQI4 $400
ADDRLP4 1028
CNSTI4 1
ASGNI4
ADDRGP4 $401
JUMPV
LABELV $400
ADDRLP4 1028
CNSTI4 0
ASGNI4
LABELV $401
ADDRLP4 1032
INDIRP4
CNSTI4 4968
ADDP4
ADDRLP4 1028
INDIRI4
ASGNI4
line 1759
;1759:	bs->inventory[INVENTORY_SHOTGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_SHOTGUN)) != 0;
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
EQI4 $403
ADDRLP4 1036
CNSTI4 1
ASGNI4
ADDRGP4 $404
JUMPV
LABELV $403
ADDRLP4 1036
CNSTI4 0
ASGNI4
LABELV $404
ADDRLP4 1040
INDIRP4
CNSTI4 4972
ADDP4
ADDRLP4 1036
INDIRI4
ASGNI4
line 1761
;1760:	//bs->inventory[INVENTORY_MACHINEGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_MACHINEGUN)) != 0;
;1761:	if( g_blasterMode.integer ) {
ADDRGP4 g_blasterMode+12
INDIRI4
CNSTI4 0
EQI4 $405
line 1762
;1762:		bs->inventory[INVENTORY_MACHINEGUN] =
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
line 1765
;1763:			(bs->cur_ps.stats[STAT_WEAPONS] &
;1764:			(1 << WP_BLASTER)) != 0;
;1765:	}
ADDRGP4 $406
JUMPV
LABELV $405
line 1766
;1766:	else {
line 1767
;1767:		bs->inventory[INVENTORY_MACHINEGUN] =
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
CNSTI4 4976
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1770
;1768:			(bs->cur_ps.stats[STAT_WEAPONS] &
;1769:			(1 << WP_MACHINEGUN)) != 0;
;1770:	}
LABELV $406
line 1771
;1771:	bs->inventory[INVENTORY_GRENADELAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GRENADE_LAUNCHER)) != 0;
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
EQI4 $415
ADDRLP4 1044
CNSTI4 1
ASGNI4
ADDRGP4 $416
JUMPV
LABELV $415
ADDRLP4 1044
CNSTI4 0
ASGNI4
LABELV $416
ADDRLP4 1048
INDIRP4
CNSTI4 4980
ADDP4
ADDRLP4 1044
INDIRI4
ASGNI4
line 1772
;1772:	bs->inventory[INVENTORY_ROCKETLAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_ROCKET_LAUNCHER)) != 0;
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
EQI4 $418
ADDRLP4 1052
CNSTI4 1
ASGNI4
ADDRGP4 $419
JUMPV
LABELV $418
ADDRLP4 1052
CNSTI4 0
ASGNI4
LABELV $419
ADDRLP4 1056
INDIRP4
CNSTI4 4984
ADDP4
ADDRLP4 1052
INDIRI4
ASGNI4
line 1773
;1773:	bs->inventory[INVENTORY_LIGHTNING] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_LIGHTNING)) != 0;
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
EQI4 $421
ADDRLP4 1060
CNSTI4 1
ASGNI4
ADDRGP4 $422
JUMPV
LABELV $421
ADDRLP4 1060
CNSTI4 0
ASGNI4
LABELV $422
ADDRLP4 1064
INDIRP4
CNSTI4 4988
ADDP4
ADDRLP4 1060
INDIRI4
ASGNI4
line 1774
;1774:	bs->inventory[INVENTORY_RAILGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_RAILGUN)) != 0;
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
EQI4 $424
ADDRLP4 1068
CNSTI4 1
ASGNI4
ADDRGP4 $425
JUMPV
LABELV $424
ADDRLP4 1068
CNSTI4 0
ASGNI4
LABELV $425
ADDRLP4 1072
INDIRP4
CNSTI4 4992
ADDP4
ADDRLP4 1068
INDIRI4
ASGNI4
line 1775
;1775:	bs->inventory[INVENTORY_PLASMAGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_PLASMAGUN)) != 0;
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
EQI4 $427
ADDRLP4 1076
CNSTI4 1
ASGNI4
ADDRGP4 $428
JUMPV
LABELV $427
ADDRLP4 1076
CNSTI4 0
ASGNI4
LABELV $428
ADDRLP4 1080
INDIRP4
CNSTI4 4996
ADDP4
ADDRLP4 1076
INDIRI4
ASGNI4
line 1776
;1776:	bs->inventory[INVENTORY_BFG10K] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_BFG)) != 0;
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
EQI4 $430
ADDRLP4 1084
CNSTI4 1
ASGNI4
ADDRGP4 $431
JUMPV
LABELV $430
ADDRLP4 1084
CNSTI4 0
ASGNI4
LABELV $431
ADDRLP4 1088
INDIRP4
CNSTI4 5004
ADDP4
ADDRLP4 1084
INDIRI4
ASGNI4
line 1777
;1777:	bs->inventory[INVENTORY_GRAPPLINGHOOK] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_GRAPPLING_HOOK)) != 0;
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
EQI4 $433
ADDRLP4 1092
CNSTI4 1
ASGNI4
ADDRGP4 $434
JUMPV
LABELV $433
ADDRLP4 1092
CNSTI4 0
ASGNI4
LABELV $434
ADDRLP4 1096
INDIRP4
CNSTI4 5008
ADDP4
ADDRLP4 1092
INDIRI4
ASGNI4
line 1784
;1778:#ifdef MISSIONPACK
;1779:	bs->inventory[INVENTORY_NAILGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_NAILGUN)) != 0;;
;1780:	bs->inventory[INVENTORY_PROXLAUNCHER] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_PROX_LAUNCHER)) != 0;;
;1781:	bs->inventory[INVENTORY_CHAINGUN] = (bs->cur_ps.stats[STAT_WEAPONS] & (1 << WP_CHAINGUN)) != 0;;
;1782:#endif
;1783:	//ammo
;1784:	bs->inventory[INVENTORY_SHELLS] = bs->cur_ps.ammo[WP_SHOTGUN];
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
line 1786
;1785:	//bs->inventory[INVENTORY_BULLETS] = bs->cur_ps.ammo[WP_MACHINEGUN];
;1786:	if( g_blasterMode.integer &&
ADDRLP4 1104
CNSTI4 0
ASGNI4
ADDRGP4 g_blasterMode+12
INDIRI4
ADDRLP4 1104
INDIRI4
EQI4 $435
ADDRFP4 0
INDIRP4
CNSTI4 208
ADDP4
INDIRI4
CNSTI4 2048
BANDI4
ADDRLP4 1104
INDIRI4
EQI4 $435
line 1788
;1787:		(bs->cur_ps.stats[STAT_WEAPONS] &
;1788:		(1 << WP_BLASTER)) ) {
line 1793
;1789:		/*
;1790:		 * This value is only used by bot AI when choosing a weapon.
;1791:		 * Actual Blaster ammunition remains infinite.
;1792:		 */
;1793:		bs->inventory[INVENTORY_BULLETS] = 1;
ADDRFP4 0
INDIRP4
CNSTI4 5028
ADDP4
CNSTI4 1
ASGNI4
line 1794
;1794:	}
ADDRGP4 $436
JUMPV
LABELV $435
line 1795
;1795:	else {
line 1796
;1796:		bs->inventory[INVENTORY_BULLETS] =
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
line 1798
;1797:			bs->cur_ps.ammo[WP_MACHINEGUN];
;1798:	}
LABELV $436
line 1799
;1799:	bs->inventory[INVENTORY_GRENADES] = bs->cur_ps.ammo[WP_GRENADE_LAUNCHER];
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
line 1800
;1800:	bs->inventory[INVENTORY_CELLS] = bs->cur_ps.ammo[WP_PLASMAGUN];
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
line 1801
;1801:	bs->inventory[INVENTORY_LIGHTNINGAMMO] = bs->cur_ps.ammo[WP_LIGHTNING];
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
line 1802
;1802:	bs->inventory[INVENTORY_ROCKETS] = bs->cur_ps.ammo[WP_ROCKET_LAUNCHER];
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
line 1803
;1803:	bs->inventory[INVENTORY_SLUGS] = bs->cur_ps.ammo[WP_RAILGUN];
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
line 1804
;1804:	bs->inventory[INVENTORY_BFGAMMO] = bs->cur_ps.ammo[WP_BFG];
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
line 1811
;1805:#ifdef MISSIONPACK
;1806:	bs->inventory[INVENTORY_NAILS] = bs->cur_ps.ammo[WP_NAILGUN];
;1807:	bs->inventory[INVENTORY_MINES] = bs->cur_ps.ammo[WP_PROX_LAUNCHER];
;1808:	bs->inventory[INVENTORY_BELT] = bs->cur_ps.ammo[WP_CHAINGUN];
;1809:#endif
;1810:	//powerups
;1811:	bs->inventory[INVENTORY_HEALTH] = bs->cur_ps.stats[STAT_HEALTH];
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
line 1812
;1812:	bs->inventory[INVENTORY_TELEPORTER] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_TELEPORTER;
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
NEI4 $439
ADDRLP4 1136
CNSTI4 1
ASGNI4
ADDRGP4 $440
JUMPV
LABELV $439
ADDRLP4 1136
CNSTI4 0
ASGNI4
LABELV $440
ADDRLP4 1140
INDIRP4
CNSTI4 5072
ADDP4
ADDRLP4 1136
INDIRI4
ASGNI4
line 1813
;1813:	bs->inventory[INVENTORY_MEDKIT] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_MEDKIT;
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
NEI4 $442
ADDRLP4 1144
CNSTI4 1
ASGNI4
ADDRGP4 $443
JUMPV
LABELV $442
ADDRLP4 1144
CNSTI4 0
ASGNI4
LABELV $443
ADDRLP4 1148
INDIRP4
CNSTI4 5076
ADDP4
ADDRLP4 1144
INDIRI4
ASGNI4
line 1819
;1814:#ifdef MISSIONPACK
;1815:	bs->inventory[INVENTORY_KAMIKAZE] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_KAMIKAZE;
;1816:	bs->inventory[INVENTORY_PORTAL] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_PORTAL;
;1817:	bs->inventory[INVENTORY_INVULNERABILITY] = bs->cur_ps.stats[STAT_HOLDABLE_ITEM] == MODELINDEX_INVULNERABILITY;
;1818:#endif
;1819:	bs->inventory[INVENTORY_QUAD] = bs->cur_ps.powerups[PW_QUAD] != 0;
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
EQI4 $445
ADDRLP4 1152
CNSTI4 1
ASGNI4
ADDRGP4 $446
JUMPV
LABELV $445
ADDRLP4 1152
CNSTI4 0
ASGNI4
LABELV $446
ADDRLP4 1156
INDIRP4
CNSTI4 5092
ADDP4
ADDRLP4 1152
INDIRI4
ASGNI4
line 1820
;1820:	bs->inventory[INVENTORY_ENVIRONMENTSUIT] = bs->cur_ps.powerups[PW_BATTLESUIT] != 0;
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
EQI4 $448
ADDRLP4 1160
CNSTI4 1
ASGNI4
ADDRGP4 $449
JUMPV
LABELV $448
ADDRLP4 1160
CNSTI4 0
ASGNI4
LABELV $449
ADDRLP4 1164
INDIRP4
CNSTI4 5096
ADDP4
ADDRLP4 1160
INDIRI4
ASGNI4
line 1821
;1821:	bs->inventory[INVENTORY_HASTE] = bs->cur_ps.powerups[PW_HASTE] != 0;
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
EQI4 $451
ADDRLP4 1168
CNSTI4 1
ASGNI4
ADDRGP4 $452
JUMPV
LABELV $451
ADDRLP4 1168
CNSTI4 0
ASGNI4
LABELV $452
ADDRLP4 1172
INDIRP4
CNSTI4 5100
ADDP4
ADDRLP4 1168
INDIRI4
ASGNI4
line 1822
;1822:	bs->inventory[INVENTORY_INVISIBILITY] = bs->cur_ps.powerups[PW_INVIS] != 0;
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
EQI4 $454
ADDRLP4 1176
CNSTI4 1
ASGNI4
ADDRGP4 $455
JUMPV
LABELV $454
ADDRLP4 1176
CNSTI4 0
ASGNI4
LABELV $455
ADDRLP4 1180
INDIRP4
CNSTI4 5104
ADDP4
ADDRLP4 1176
INDIRI4
ASGNI4
line 1823
;1823:	bs->inventory[INVENTORY_REGEN] = bs->cur_ps.powerups[PW_REGEN] != 0;
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
EQI4 $457
ADDRLP4 1184
CNSTI4 1
ASGNI4
ADDRGP4 $458
JUMPV
LABELV $457
ADDRLP4 1184
CNSTI4 0
ASGNI4
LABELV $458
ADDRLP4 1188
INDIRP4
CNSTI4 5108
ADDP4
ADDRLP4 1184
INDIRI4
ASGNI4
line 1824
;1824:	bs->inventory[INVENTORY_FLIGHT] = bs->cur_ps.powerups[PW_FLIGHT] != 0;
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
EQI4 $460
ADDRLP4 1192
CNSTI4 1
ASGNI4
ADDRGP4 $461
JUMPV
LABELV $460
ADDRLP4 1192
CNSTI4 0
ASGNI4
LABELV $461
ADDRLP4 1196
INDIRP4
CNSTI4 5112
ADDP4
ADDRLP4 1192
INDIRI4
ASGNI4
line 1831
;1825:#ifdef MISSIONPACK
;1826:	bs->inventory[INVENTORY_SCOUT] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_SCOUT;
;1827:	bs->inventory[INVENTORY_GUARD] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_GUARD;
;1828:	bs->inventory[INVENTORY_DOUBLER] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_DOUBLER;
;1829:	bs->inventory[INVENTORY_AMMOREGEN] = bs->cur_ps.stats[STAT_PERSISTANT_POWERUP] == MODELINDEX_AMMOREGEN;
;1830:#endif
;1831:	bs->inventory[INVENTORY_REDFLAG] = bs->cur_ps.powerups[PW_REDFLAG] != 0;
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
EQI4 $463
ADDRLP4 1200
CNSTI4 1
ASGNI4
ADDRGP4 $464
JUMPV
LABELV $463
ADDRLP4 1200
CNSTI4 0
ASGNI4
LABELV $464
ADDRLP4 1204
INDIRP4
CNSTI4 5132
ADDP4
ADDRLP4 1200
INDIRI4
ASGNI4
line 1832
;1832:	bs->inventory[INVENTORY_BLUEFLAG] = bs->cur_ps.powerups[PW_BLUEFLAG] != 0;
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
EQI4 $466
ADDRLP4 1208
CNSTI4 1
ASGNI4
ADDRGP4 $467
JUMPV
LABELV $466
ADDRLP4 1208
CNSTI4 0
ASGNI4
LABELV $467
ADDRLP4 1212
INDIRP4
CNSTI4 5136
ADDP4
ADDRLP4 1208
INDIRI4
ASGNI4
line 1844
;1833:#ifdef MISSIONPACK
;1834:	bs->inventory[INVENTORY_NEUTRALFLAG] = bs->cur_ps.powerups[PW_NEUTRALFLAG] != 0;
;1835:	if (BotTeam(bs) == TEAM_RED) {
;1836:		bs->inventory[INVENTORY_REDCUBE] = bs->cur_ps.generic1;
;1837:		bs->inventory[INVENTORY_BLUECUBE] = 0;
;1838:	}
;1839:	else {
;1840:		bs->inventory[INVENTORY_REDCUBE] = 0;
;1841:		bs->inventory[INVENTORY_BLUECUBE] = bs->cur_ps.generic1;
;1842:	}
;1843:#endif
;1844:	BotCheckItemPickup(bs, oldinventory);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckItemPickup
CALLV
pop
line 1845
;1845:}
LABELV $398
endproc BotUpdateInventory 1216 12
export BotUpdateBattleInventory
proc BotUpdateBattleInventory 160 8
line 1852
;1846:
;1847:/*
;1848:==================
;1849:BotUpdateBattleInventory
;1850:==================
;1851:*/
;1852:void BotUpdateBattleInventory(bot_state_t *bs, int enemy) {
line 1856
;1853:	vec3_t dir;
;1854:	aas_entityinfo_t entinfo;
;1855:
;1856:	BotEntityInfo(enemy, &entinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 1857
;1857:	VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 1858
;1858:	bs->inventory[ENEMY_HEIGHT] = (int) dir[2];
ADDRFP4 0
INDIRP4
CNSTI4 5756
ADDP4
ADDRLP4 0+8
INDIRF4
CVFI4 4
ASGNI4
line 1859
;1859:	dir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 1860
;1860:	bs->inventory[ENEMY_HORIZONTAL_DIST] = (int) VectorLength(dir);
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
line 1862
;1861:	//FIXME: add num visible enemies and num visible team mates to the inventory
;1862:}
LABELV $468
endproc BotUpdateBattleInventory 160 8
export BotBattleUseItems
proc BotBattleUseItems 4 4
line 2089
;1863:
;1864:#ifdef MISSIONPACK
;1865:/*
;1866:==================
;1867:BotUseKamikaze
;1868:==================
;1869:*/
;1870:#define KAMIKAZE_DIST		1024
;1871:
;1872:void BotUseKamikaze(bot_state_t *bs) {
;1873:	int c, teammates, enemies;
;1874:	aas_entityinfo_t entinfo;
;1875:	vec3_t dir, target;
;1876:	bot_goal_t *goal;
;1877:	bsp_trace_t trace;
;1878:
;1879:	//if the bot has no kamikaze
;1880:	if (bs->inventory[INVENTORY_KAMIKAZE] <= 0)
;1881:		return;
;1882:	if (bs->kamikaze_time > FloatTime())
;1883:		return;
;1884:	bs->kamikaze_time = FloatTime() + 0.2;
;1885:	if (gametype == GT_CTF) {
;1886:		//never use kamikaze if the team flag carrier is visible
;1887:		if (BotCTFCarryingFlag(bs))
;1888:			return;
;1889:		c = BotTeamFlagCarrierVisible(bs);
;1890:		if (c >= 0) {
;1891:			BotEntityInfo(c, &entinfo);
;1892:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1893:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1894:				return;
;1895:		}
;1896:		c = BotEnemyFlagCarrierVisible(bs);
;1897:		if (c >= 0) {
;1898:			BotEntityInfo(c, &entinfo);
;1899:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1900:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1901:				trap_EA_Use(bs->client);
;1902:				return;
;1903:			}
;1904:		}
;1905:	}
;1906:	else if (gametype == GT_1FCTF) {
;1907:		//never use kamikaze if the team flag carrier is visible
;1908:		if (Bot1FCTFCarryingFlag(bs))
;1909:			return;
;1910:		c = BotTeamFlagCarrierVisible(bs);
;1911:		if (c >= 0) {
;1912:			BotEntityInfo(c, &entinfo);
;1913:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1914:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1915:				return;
;1916:		}
;1917:		c = BotEnemyFlagCarrierVisible(bs);
;1918:		if (c >= 0) {
;1919:			BotEntityInfo(c, &entinfo);
;1920:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1921:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1922:				trap_EA_Use(bs->client);
;1923:				return;
;1924:			}
;1925:		}
;1926:	}
;1927:	else if (gametype == GT_OBELISK) {
;1928:		switch(BotTeam(bs)) {
;1929:			case TEAM_RED: goal = &blueobelisk; break;
;1930:			default: goal = &redobelisk; break;
;1931:		}
;1932:		//if the obelisk is visible
;1933:		VectorCopy(goal->origin, target);
;1934:		target[2] += 1;
;1935:		VectorSubtract(bs->origin, target, dir);
;1936:		if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST * 0.9)) {
;1937:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;1938:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;1939:				trap_EA_Use(bs->client);
;1940:				return;
;1941:			}
;1942:		}
;1943:	}
;1944:	else if (gametype == GT_HARVESTER) {
;1945:		//
;1946:		if (BotHarvesterCarryingCubes(bs))
;1947:			return;
;1948:		//never use kamikaze if a team mate carrying cubes is visible
;1949:		c = BotTeamCubeCarrierVisible(bs);
;1950:		if (c >= 0) {
;1951:			BotEntityInfo(c, &entinfo);
;1952:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1953:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST))
;1954:				return;
;1955:		}
;1956:		c = BotEnemyCubeCarrierVisible(bs);
;1957:		if (c >= 0) {
;1958:			BotEntityInfo(c, &entinfo);
;1959:			VectorSubtract(entinfo.origin, bs->origin, dir);
;1960:			if (VectorLengthSquared(dir) < Square(KAMIKAZE_DIST)) {
;1961:				trap_EA_Use(bs->client);
;1962:				return;
;1963:			}
;1964:		}
;1965:	}
;1966:	//
;1967:	BotVisibleTeamMatesAndEnemies(bs, &teammates, &enemies, KAMIKAZE_DIST);
;1968:	//
;1969:	if (enemies > 2 && enemies > teammates+1) {
;1970:		trap_EA_Use(bs->client);
;1971:		return;
;1972:	}
;1973:}
;1974:
;1975:/*
;1976:==================
;1977:BotUseInvulnerability
;1978:==================
;1979:*/
;1980:void BotUseInvulnerability(bot_state_t *bs) {
;1981:	int c;
;1982:	vec3_t dir, target;
;1983:	bot_goal_t *goal;
;1984:	bsp_trace_t trace;
;1985:
;1986:	//if the bot has no invulnerability
;1987:	if (bs->inventory[INVENTORY_INVULNERABILITY] <= 0)
;1988:		return;
;1989:	if (bs->invulnerability_time > FloatTime())
;1990:		return;
;1991:	bs->invulnerability_time = FloatTime() + 0.2;
;1992:	if (gametype == GT_CTF) {
;1993:		//never use kamikaze if the team flag carrier is visible
;1994:		if (BotCTFCarryingFlag(bs))
;1995:			return;
;1996:		c = BotEnemyFlagCarrierVisible(bs);
;1997:		if (c >= 0)
;1998:			return;
;1999:		//if near enemy flag and the flag is visible
;2000:		switch(BotTeam(bs)) {
;2001:			case TEAM_RED: goal = &ctf_blueflag; break;
;2002:			default: goal = &ctf_redflag; break;
;2003:		}
;2004:		//if the obelisk is visible
;2005:		VectorCopy(goal->origin, target);
;2006:		target[2] += 1;
;2007:		VectorSubtract(bs->origin, target, dir);
;2008:		if (VectorLengthSquared(dir) < Square(200)) {
;2009:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2010:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2011:				trap_EA_Use(bs->client);
;2012:				return;
;2013:			}
;2014:		}
;2015:	}
;2016:	else if (gametype == GT_1FCTF) {
;2017:		//never use kamikaze if the team flag carrier is visible
;2018:		if (Bot1FCTFCarryingFlag(bs))
;2019:			return;
;2020:		c = BotEnemyFlagCarrierVisible(bs);
;2021:		if (c >= 0)
;2022:			return;
;2023:		//if near enemy flag and the flag is visible
;2024:		switch(BotTeam(bs)) {
;2025:			case TEAM_RED: goal = &ctf_blueflag; break;
;2026:			default: goal = &ctf_redflag; break;
;2027:		}
;2028:		//if the obelisk is visible
;2029:		VectorCopy(goal->origin, target);
;2030:		target[2] += 1;
;2031:		VectorSubtract(bs->origin, target, dir);
;2032:		if (VectorLengthSquared(dir) < Square(200)) {
;2033:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2034:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2035:				trap_EA_Use(bs->client);
;2036:				return;
;2037:			}
;2038:		}
;2039:	}
;2040:	else if (gametype == GT_OBELISK) {
;2041:		switch(BotTeam(bs)) {
;2042:			case TEAM_RED: goal = &blueobelisk; break;
;2043:			default: goal = &redobelisk; break;
;2044:		}
;2045:		//if the obelisk is visible
;2046:		VectorCopy(goal->origin, target);
;2047:		target[2] += 1;
;2048:		VectorSubtract(bs->origin, target, dir);
;2049:		if (VectorLengthSquared(dir) < Square(300)) {
;2050:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2051:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2052:				trap_EA_Use(bs->client);
;2053:				return;
;2054:			}
;2055:		}
;2056:	}
;2057:	else if (gametype == GT_HARVESTER) {
;2058:		//
;2059:		if (BotHarvesterCarryingCubes(bs))
;2060:			return;
;2061:		c = BotEnemyCubeCarrierVisible(bs);
;2062:		if (c >= 0)
;2063:			return;
;2064:		//if near enemy base and enemy base is visible
;2065:		switch(BotTeam(bs)) {
;2066:			case TEAM_RED: goal = &blueobelisk; break;
;2067:			default: goal = &redobelisk; break;
;2068:		}
;2069:		//if the obelisk is visible
;2070:		VectorCopy(goal->origin, target);
;2071:		target[2] += 1;
;2072:		VectorSubtract(bs->origin, target, dir);
;2073:		if (VectorLengthSquared(dir) < Square(200)) {
;2074:			BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;2075:			if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;2076:				trap_EA_Use(bs->client);
;2077:				return;
;2078:			}
;2079:		}
;2080:	}
;2081:}
;2082:#endif
;2083:
;2084:/*
;2085:==================
;2086:BotBattleUseItems
;2087:==================
;2088:*/
;2089:void BotBattleUseItems(bot_state_t *bs) {
line 2090
;2090:	if (bs->inventory[INVENTORY_HEALTH] < 40) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 40
GEI4 $479
line 2091
;2091:		if (bs->inventory[INVENTORY_TELEPORTER] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5072
ADDP4
INDIRI4
CNSTI4 0
LEI4 $481
line 2092
;2092:			if (!BotCTFCarryingFlag(bs)
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
NEI4 $483
line 2097
;2093:#ifdef MISSIONPACK
;2094:				&& !Bot1FCTFCarryingFlag(bs)
;2095:				&& !BotHarvesterCarryingCubes(bs)
;2096:#endif
;2097:				) {
line 2098
;2098:				trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 2099
;2099:			}
LABELV $483
line 2100
;2100:		}
LABELV $481
line 2101
;2101:	}
LABELV $479
line 2102
;2102:	if (bs->inventory[INVENTORY_HEALTH] < 60) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $485
line 2103
;2103:		if (bs->inventory[INVENTORY_MEDKIT] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5076
ADDP4
INDIRI4
CNSTI4 0
LEI4 $487
line 2104
;2104:			trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 2105
;2105:		}
LABELV $487
line 2106
;2106:	}
LABELV $485
line 2111
;2107:#ifdef MISSIONPACK
;2108:	BotUseKamikaze(bs);
;2109:	BotUseInvulnerability(bs);
;2110:#endif
;2111:}
LABELV $478
endproc BotBattleUseItems 4 4
export BotSetTeleportTime
proc BotSetTeleportTime 8 0
line 2118
;2112:
;2113:/*
;2114:==================
;2115:BotSetTeleportTime
;2116:==================
;2117:*/
;2118:void BotSetTeleportTime(bot_state_t *bs) {
line 2119
;2119:	if ((bs->cur_ps.eFlags ^ bs->last_eFlags) & EF_TELEPORT_BIT) {
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
EQI4 $490
line 2120
;2120:		bs->teleport_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6180
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2121
;2121:	}
LABELV $490
line 2122
;2122:	bs->last_eFlags = bs->cur_ps.eFlags;
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
line 2123
;2123:}
LABELV $489
endproc BotSetTeleportTime 8 0
export BotIsDead
proc BotIsDead 4 0
line 2130
;2124:
;2125:/*
;2126:==================
;2127:BotIsDead
;2128:==================
;2129:*/
;2130:qboolean BotIsDead(bot_state_t *bs) {
line 2131
;2131:	return (bs->cur_ps.pm_type == PM_DEAD);
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 3
NEI4 $494
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $495
JUMPV
LABELV $494
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $495
ADDRLP4 0
INDIRI4
RETI4
LABELV $492
endproc BotIsDead 4 0
export BotIsObserver
proc BotIsObserver 1032 12
line 2139
;2132:}
;2133:
;2134:/*
;2135:==================
;2136:BotIsObserver
;2137:==================
;2138:*/
;2139:qboolean BotIsObserver(bot_state_t *bs) {
line 2141
;2140:	char buf[MAX_INFO_STRING];
;2141:	if (bs->cur_ps.pm_type == PM_SPECTATOR) return qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 2
NEI4 $497
CNSTI4 1
RETI4
ADDRGP4 $496
JUMPV
LABELV $497
line 2142
;2142:	trap_GetConfigstring(CS_PLAYERS+bs->client, buf, sizeof(buf));
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
line 2143
;2143:	if (atoi(Info_ValueForKey(buf, "t")) == TEAM_SPECTATOR) return qtrue;
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
NEI4 $499
CNSTI4 1
RETI4
ADDRGP4 $496
JUMPV
LABELV $499
line 2144
;2144:	return qfalse;
CNSTI4 0
RETI4
LABELV $496
endproc BotIsObserver 1032 12
export BotIntermission
proc BotIntermission 8 0
line 2152
;2145:}
;2146:
;2147:/*
;2148:==================
;2149:BotIntermission
;2150:==================
;2151:*/
;2152:qboolean BotIntermission(bot_state_t *bs) {
line 2154
;2153:	//NOTE: we shouldn't be looking at the game code...
;2154:	if (level.intermissiontime) return qtrue;
ADDRGP4 level+9128
INDIRI4
CNSTI4 0
EQI4 $502
CNSTI4 1
RETI4
ADDRGP4 $501
JUMPV
LABELV $502
line 2155
;2155:	return (bs->cur_ps.pm_type == PM_FREEZE || bs->cur_ps.pm_type == PM_INTERMISSION);
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
EQI4 $508
ADDRLP4 4
INDIRI4
CNSTI4 5
NEI4 $506
LABELV $508
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $507
JUMPV
LABELV $506
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $507
ADDRLP4 0
INDIRI4
RETI4
LABELV $501
endproc BotIntermission 8 0
export BotInLavaOrSlime
proc BotInLavaOrSlime 16 4
line 2163
;2156:}
;2157:
;2158:/*
;2159:==================
;2160:BotInLavaOrSlime
;2161:==================
;2162:*/
;2163:qboolean BotInLavaOrSlime(bot_state_t *bs) {
line 2166
;2164:	vec3_t feet;
;2165:
;2166:	VectorCopy(bs->origin, feet);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 2167
;2167:	feet[2] -= 23;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1102577664
SUBF4
ASGNF4
line 2168
;2168:	return (trap_AAS_PointContents(feet) & (CONTENTS_LAVA|CONTENTS_SLIME));
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
LABELV $509
endproc BotInLavaOrSlime 16 4
lit
align 4
LABELV $512
byte 4 3238002688
byte 4 3238002688
byte 4 3238002688
align 4
LABELV $513
byte 4 1090519040
byte 4 1090519040
byte 4 1090519040
export BotCreateWayPoint
code
proc BotCreateWayPoint 32 12
line 2176
;2169:}
;2170:
;2171:/*
;2172:==================
;2173:BotCreateWayPoint
;2174:==================
;2175:*/
;2176:bot_waypoint_t *BotCreateWayPoint(char *name, vec3_t origin, int areanum) {
line 2178
;2177:	bot_waypoint_t *wp;
;2178:	vec3_t waypointmins = {-8, -8, -8}, waypointmaxs = {8, 8, 8};
ADDRLP4 4
ADDRGP4 $512
INDIRB
ASGNB 12
ADDRLP4 16
ADDRGP4 $513
INDIRB
ASGNB 12
line 2180
;2179:
;2180:	wp = botai_freewaypoints;
ADDRLP4 0
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2181
;2181:	if ( !wp ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $514
line 2182
;2182:		BotAI_Print( PRT_WARNING, "BotCreateWayPoint: Out of waypoints\n" );
CNSTI4 2
ARGI4
ADDRGP4 $516
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 2183
;2183:		return NULL;
CNSTP4 0
RETP4
ADDRGP4 $511
JUMPV
LABELV $514
line 2185
;2184:	}
;2185:	botai_freewaypoints = botai_freewaypoints->next;
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
line 2187
;2186:
;2187:	Q_strncpyz( wp->name, name, sizeof(wp->name) );
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
line 2188
;2188:	VectorCopy(origin, wp->goal.origin);
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2189
;2189:	VectorCopy(waypointmins, wp->goal.mins);
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 2190
;2190:	VectorCopy(waypointmaxs, wp->goal.maxs);
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
ADDRLP4 16
INDIRB
ASGNB 12
line 2191
;2191:	wp->goal.areanum = areanum;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 2192
;2192:	wp->next = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
CNSTP4 0
ASGNP4
line 2193
;2193:	wp->prev = NULL;
ADDRLP4 0
INDIRP4
CNSTI4 96
ADDP4
CNSTP4 0
ASGNP4
line 2194
;2194:	return wp;
ADDRLP4 0
INDIRP4
RETP4
LABELV $511
endproc BotCreateWayPoint 32 12
export BotFindWayPoint
proc BotFindWayPoint 8 8
line 2202
;2195:}
;2196:
;2197:/*
;2198:==================
;2199:BotFindWayPoint
;2200:==================
;2201:*/
;2202:bot_waypoint_t *BotFindWayPoint(bot_waypoint_t *waypoints, char *name) {
line 2205
;2203:	bot_waypoint_t *wp;
;2204:
;2205:	for (wp = waypoints; wp; wp = wp->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $521
JUMPV
LABELV $518
line 2206
;2206:		if (!Q_stricmp(wp->name, name)) return wp;
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
NEI4 $522
ADDRLP4 0
INDIRP4
RETP4
ADDRGP4 $517
JUMPV
LABELV $522
line 2207
;2207:	}
LABELV $519
line 2205
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
LABELV $521
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $518
line 2208
;2208:	return NULL;
CNSTP4 0
RETP4
LABELV $517
endproc BotFindWayPoint 8 8
export BotFreeWaypoints
proc BotFreeWaypoints 4 0
line 2216
;2209:}
;2210:
;2211:/*
;2212:==================
;2213:BotFreeWaypoints
;2214:==================
;2215:*/
;2216:void BotFreeWaypoints(bot_waypoint_t *wp) {
line 2219
;2217:	bot_waypoint_t *nextwp;
;2218:
;2219:	for (; wp; wp = nextwp) {
ADDRGP4 $528
JUMPV
LABELV $525
line 2220
;2220:		nextwp = wp->next;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
line 2221
;2221:		wp->next = botai_freewaypoints;
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2222
;2222:		botai_freewaypoints = wp;
ADDRGP4 botai_freewaypoints
ADDRFP4 0
INDIRP4
ASGNP4
line 2223
;2223:	}
LABELV $526
line 2219
ADDRFP4 0
ADDRLP4 0
INDIRP4
ASGNP4
LABELV $528
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $525
line 2224
;2224:}
LABELV $524
endproc BotFreeWaypoints 4 0
export BotInitWaypoints
proc BotInitWaypoints 4 0
line 2231
;2225:
;2226:/*
;2227:==================
;2228:BotInitWaypoints
;2229:==================
;2230:*/
;2231:void BotInitWaypoints(void) {
line 2234
;2232:	int i;
;2233:
;2234:	botai_freewaypoints = NULL;
ADDRGP4 botai_freewaypoints
CNSTP4 0
ASGNP4
line 2235
;2235:	for (i = 0; i < MAX_WAYPOINTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $530
line 2236
;2236:		botai_waypoints[i].next = botai_freewaypoints;
CNSTI4 100
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botai_waypoints+92
ADDP4
ADDRGP4 botai_freewaypoints
INDIRP4
ASGNP4
line 2237
;2237:		botai_freewaypoints = &botai_waypoints[i];
ADDRGP4 botai_freewaypoints
CNSTI4 100
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 botai_waypoints
ADDP4
ASGNP4
line 2238
;2238:	}
LABELV $531
line 2235
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 128
LTI4 $530
line 2239
;2239:}
LABELV $529
endproc BotInitWaypoints 4 0
export TeamPlayIsOn
proc TeamPlayIsOn 4 0
line 2246
;2240:
;2241:/*
;2242:==================
;2243:TeamPlayIsOn
;2244:==================
;2245:*/
;2246:int TeamPlayIsOn(void) {
line 2247
;2247:	return ( gametype >= GT_TEAM );
ADDRGP4 gametype
INDIRI4
CNSTI4 3
LTI4 $537
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $538
JUMPV
LABELV $537
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $538
ADDRLP4 0
INDIRI4
RETI4
LABELV $535
endproc TeamPlayIsOn 4 0
export BotAggression
proc BotAggression 28 0
line 2255
;2248:}
;2249:
;2250:/*
;2251:==================
;2252:BotAggression
;2253:==================
;2254:*/
;2255:float BotAggression(bot_state_t *bs) {
line 2257
;2256:	//if the bot has quad
;2257:	if (bs->inventory[INVENTORY_QUAD]) {
ADDRFP4 0
INDIRP4
CNSTI4 5092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $540
line 2259
;2258:		//if the bot is not holding the gauntlet or the enemy is really nearby
;2259:		if (bs->weaponnum != WP_GAUNTLET ||
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
NEI4 $544
ADDRLP4 0
INDIRP4
CNSTI4 5752
ADDP4
INDIRI4
CNSTI4 80
GEI4 $542
LABELV $544
line 2260
;2260:			bs->inventory[ENEMY_HORIZONTAL_DIST] < 80) {
line 2261
;2261:			return 70;
CNSTF4 1116471296
RETF4
ADDRGP4 $539
JUMPV
LABELV $542
line 2263
;2262:		}
;2263:	}
LABELV $540
line 2265
;2264:	//if the enemy is located way higher than the bot
;2265:	if (bs->inventory[ENEMY_HEIGHT] > 200) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 5756
ADDP4
INDIRI4
CNSTI4 200
LEI4 $545
CNSTF4 0
RETF4
ADDRGP4 $539
JUMPV
LABELV $545
line 2267
;2266:	//if the bot is very low on health
;2267:	if (bs->inventory[INVENTORY_HEALTH] < 60) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $547
CNSTF4 0
RETF4
ADDRGP4 $539
JUMPV
LABELV $547
line 2269
;2268:	//if the bot is low on health
;2269:	if (bs->inventory[INVENTORY_HEALTH] < 80) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 80
GEI4 $549
line 2271
;2270:		//if the bot has insufficient armor
;2271:		if (bs->inventory[INVENTORY_ARMOR] < 40) return 0;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $551
CNSTF4 0
RETF4
ADDRGP4 $539
JUMPV
LABELV $551
line 2272
;2272:	}
LABELV $549
line 2274
;2273:	//if the bot can use the bfg
;2274:	if (bs->inventory[INVENTORY_BFG10K] > 0 &&
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
LEI4 $553
ADDRLP4 0
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 7
LEI4 $553
line 2275
;2275:			bs->inventory[INVENTORY_BFGAMMO] > 7) return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $539
JUMPV
LABELV $553
line 2277
;2276:	//if the bot can use the railgun
;2277:	if (bs->inventory[INVENTORY_RAILGUN] > 0 &&
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
LEI4 $555
ADDRLP4 4
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 5
LEI4 $555
line 2278
;2278:			bs->inventory[INVENTORY_SLUGS] > 5) return 95;
CNSTF4 1119748096
RETF4
ADDRGP4 $539
JUMPV
LABELV $555
line 2280
;2279:	//if the bot can use the lightning gun
;2280:	if (bs->inventory[INVENTORY_LIGHTNING] > 0 &&
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
LEI4 $557
ADDRLP4 8
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
CNSTI4 50
LEI4 $557
line 2281
;2281:			bs->inventory[INVENTORY_LIGHTNINGAMMO] > 50) return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $539
JUMPV
LABELV $557
line 2283
;2282:	//if the bot can use the rocketlauncher
;2283:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 &&
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
LEI4 $559
ADDRLP4 12
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 5
LEI4 $559
line 2284
;2284:			bs->inventory[INVENTORY_ROCKETS] > 5) return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $539
JUMPV
LABELV $559
line 2286
;2285:	//if the bot can use the plasmagun
;2286:	if (bs->inventory[INVENTORY_PLASMAGUN] > 0 &&
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
LEI4 $561
ADDRLP4 16
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
CNSTI4 40
LEI4 $561
line 2287
;2287:			bs->inventory[INVENTORY_CELLS] > 40) return 85;
CNSTF4 1118437376
RETF4
ADDRGP4 $539
JUMPV
LABELV $561
line 2289
;2288:	//if the bot can use the grenade launcher
;2289:	if (bs->inventory[INVENTORY_GRENADELAUNCHER] > 0 &&
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
LEI4 $563
ADDRLP4 20
INDIRP4
CNSTI4 5032
ADDP4
INDIRI4
CNSTI4 10
LEI4 $563
line 2290
;2290:			bs->inventory[INVENTORY_GRENADES] > 10) return 80;
CNSTF4 1117782016
RETF4
ADDRGP4 $539
JUMPV
LABELV $563
line 2292
;2291:	//if the bot can use the shotgun
;2292:	if (bs->inventory[INVENTORY_SHOTGUN] > 0 &&
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
LEI4 $565
ADDRLP4 24
INDIRP4
CNSTI4 5024
ADDP4
INDIRI4
CNSTI4 10
LEI4 $565
line 2293
;2293:			bs->inventory[INVENTORY_SHELLS] > 10) return 50;
CNSTF4 1112014848
RETF4
ADDRGP4 $539
JUMPV
LABELV $565
line 2295
;2294:	//otherwise the bot is not feeling too good
;2295:	return 0;
CNSTF4 0
RETF4
LABELV $539
endproc BotAggression 28 0
export BotFeelingBad
proc BotFeelingBad 0 0
line 2303
;2296:}
;2297:
;2298:/*
;2299:==================
;2300:BotFeelingBad
;2301:==================
;2302:*/
;2303:float BotFeelingBad(bot_state_t *bs) {
line 2304
;2304:	if (bs->weaponnum == WP_GAUNTLET) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $568
line 2305
;2305:		return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $567
JUMPV
LABELV $568
line 2307
;2306:	}
;2307:	if (bs->inventory[INVENTORY_HEALTH] < 40) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 40
GEI4 $570
line 2308
;2308:		return 100;
CNSTF4 1120403456
RETF4
ADDRGP4 $567
JUMPV
LABELV $570
line 2310
;2309:	}
;2310:	if (bs->weaponnum == WP_MACHINEGUN) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 2
NEI4 $572
line 2311
;2311:		return 90;
CNSTF4 1119092736
RETF4
ADDRGP4 $567
JUMPV
LABELV $572
line 2313
;2312:	}
;2313:	if (bs->inventory[INVENTORY_HEALTH] < 60) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $574
line 2314
;2314:		return 80;
CNSTF4 1117782016
RETF4
ADDRGP4 $567
JUMPV
LABELV $574
line 2316
;2315:	}
;2316:	return 0;
CNSTF4 0
RETF4
LABELV $567
endproc BotFeelingBad 0 0
export BotWantsToRetreat
proc BotWantsToRetreat 144 8
line 2324
;2317:}
;2318:
;2319:/*
;2320:==================
;2321:BotWantsToRetreat
;2322:==================
;2323:*/
;2324:int BotWantsToRetreat(bot_state_t *bs) {
line 2327
;2325:	aas_entityinfo_t entinfo;
;2326:
;2327:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $577
line 2329
;2328:		//always retreat when carrying a CTF flag
;2329:		if (BotCTFCarryingFlag(bs))
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
EQI4 $579
line 2330
;2330:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $576
JUMPV
LABELV $579
line 2331
;2331:	}
LABELV $577
line 2357
;2332:#ifdef MISSIONPACK
;2333:	else if (gametype == GT_1FCTF) {
;2334:		//if carrying the flag then always retreat
;2335:		if (Bot1FCTFCarryingFlag(bs))
;2336:			return qtrue;
;2337:	}
;2338:	else if (gametype == GT_OBELISK) {
;2339:		//the bots should be dedicated to attacking the enemy obelisk
;2340:		if (bs->ltgtype == LTG_ATTACKENEMYBASE) {
;2341:			if (bs->enemy != redobelisk.entitynum ||
;2342:						bs->enemy != blueobelisk.entitynum) {
;2343:				return qtrue;
;2344:			}
;2345:		}
;2346:		if (BotFeelingBad(bs) > 50) {
;2347:			return qtrue;
;2348:		}
;2349:		return qfalse;
;2350:	}
;2351:	else if (gametype == GT_HARVESTER) {
;2352:		//if carrying cubes then always retreat
;2353:		if (BotHarvesterCarryingCubes(bs)) return qtrue;
;2354:	}
;2355:#endif
;2356:	//
;2357:	if (bs->enemy >= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
LTI4 $581
line 2359
;2358:		//if the enemy is carrying a flag
;2359:		BotEntityInfo(bs->enemy, &entinfo);
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
line 2360
;2360:		if (EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 140
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $583
line 2361
;2361:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $576
JUMPV
LABELV $583
line 2362
;2362:	}
LABELV $581
line 2364
;2363:	//if the bot is getting the flag
;2364:	if (bs->ltgtype == LTG_GETFLAG)
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $585
line 2365
;2365:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $576
JUMPV
LABELV $585
line 2367
;2366:	//
;2367:	if (BotAggression(bs) < 50)
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
GEF4 $587
line 2368
;2368:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $576
JUMPV
LABELV $587
line 2369
;2369:	return qfalse;
CNSTI4 0
RETI4
LABELV $576
endproc BotWantsToRetreat 144 8
export BotWantsToChase
proc BotWantsToChase 148 8
line 2377
;2370:}
;2371:
;2372:/*
;2373:==================
;2374:BotWantsToChase
;2375:==================
;2376:*/
;2377:int BotWantsToChase(bot_state_t *bs) {
line 2380
;2378:	aas_entityinfo_t entinfo;
;2379:
;2380:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $590
line 2382
;2381:		//never chase when carrying a CTF flag
;2382:		if (BotCTFCarryingFlag(bs))
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
EQI4 $592
line 2383
;2383:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $589
JUMPV
LABELV $592
line 2385
;2384:		//always chase if the enemy is carrying a flag
;2385:		BotEntityInfo(bs->enemy, &entinfo);
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
line 2386
;2386:		if (EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 144
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
EQI4 $594
line 2387
;2387:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $589
JUMPV
LABELV $594
line 2388
;2388:	}
LABELV $590
line 2415
;2389:#ifdef MISSIONPACK
;2390:	else if (gametype == GT_1FCTF) {
;2391:		//never chase if carrying the flag
;2392:		if (Bot1FCTFCarryingFlag(bs))
;2393:			return qfalse;
;2394:		//always chase if the enemy is carrying a flag
;2395:		BotEntityInfo(bs->enemy, &entinfo);
;2396:		if (EntityCarriesFlag(&entinfo))
;2397:			return qtrue;
;2398:	}
;2399:	else if (gametype == GT_OBELISK) {
;2400:		//the bots should be dedicated to attacking the enemy obelisk
;2401:		if (bs->ltgtype == LTG_ATTACKENEMYBASE) {
;2402:			if (bs->enemy != redobelisk.entitynum ||
;2403:						bs->enemy != blueobelisk.entitynum) {
;2404:				return qfalse;
;2405:			}
;2406:		}
;2407:	}
;2408:	else if (gametype == GT_HARVESTER) {
;2409:		//never chase if carrying cubes
;2410:		if (BotHarvesterCarryingCubes(bs))
;2411:			return qfalse;
;2412:	}
;2413:#endif
;2414:	//if the bot is getting the flag
;2415:	if (bs->ltgtype == LTG_GETFLAG)
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $596
line 2416
;2416:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $589
JUMPV
LABELV $596
line 2418
;2417:	//
;2418:	if (BotAggression(bs) > 50)
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
LEF4 $598
line 2419
;2419:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $589
JUMPV
LABELV $598
line 2420
;2420:	return qfalse;
CNSTI4 0
RETI4
LABELV $589
endproc BotWantsToChase 148 8
export BotWantsToHelp
proc BotWantsToHelp 0 0
line 2428
;2421:}
;2422:
;2423:/*
;2424:==================
;2425:BotWantsToHelp
;2426:==================
;2427:*/
;2428:int BotWantsToHelp(bot_state_t *bs) {
line 2429
;2429:	return qtrue;
CNSTI4 1
RETI4
LABELV $600
endproc BotWantsToHelp 0 0
export BotCanAndWantsToRocketJump
proc BotCanAndWantsToRocketJump 8 16
line 2437
;2430:}
;2431:
;2432:/*
;2433:==================
;2434:BotCanAndWantsToRocketJump
;2435:==================
;2436:*/
;2437:int BotCanAndWantsToRocketJump(bot_state_t *bs) {
line 2441
;2438:	float rocketjumper;
;2439:
;2440:	//if rocket jumping is disabled
;2441:	if (!bot_rocketjump.integer) return qfalse;
ADDRGP4 bot_rocketjump+12
INDIRI4
CNSTI4 0
NEI4 $602
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $602
line 2443
;2442:	//if no rocket launcher
;2443:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] <= 0) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
CNSTI4 0
GTI4 $605
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $605
line 2445
;2444:	//if low on rockets
;2445:	if (bs->inventory[INVENTORY_ROCKETS] < 3) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 3
GEI4 $607
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $607
line 2447
;2446:	//never rocket jump with the Quad
;2447:	if (bs->inventory[INVENTORY_QUAD]) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $609
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $609
line 2449
;2448:	//if low on health
;2449:	if (bs->inventory[INVENTORY_HEALTH] < 60) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $611
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $611
line 2451
;2450:	//if not full health
;2451:	if (bs->inventory[INVENTORY_HEALTH] < 90) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 90
GEI4 $613
line 2453
;2452:		//if the bot has insufficient armor
;2453:		if (bs->inventory[INVENTORY_ARMOR] < 40) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $615
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $615
line 2454
;2454:	}
LABELV $613
line 2455
;2455:	rocketjumper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_WEAPONJUMPING, 0, 1);
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
line 2456
;2456:	if (rocketjumper < 0.5) return qfalse;
ADDRLP4 0
INDIRF4
CNSTF4 1056964608
GEF4 $617
CNSTI4 0
RETI4
ADDRGP4 $601
JUMPV
LABELV $617
line 2457
;2457:	return qtrue;
CNSTI4 1
RETI4
LABELV $601
endproc BotCanAndWantsToRocketJump 8 16
export BotHasPersistantPowerupAndWeapon
proc BotHasPersistantPowerupAndWeapon 32 0
line 2465
;2458:}
;2459:
;2460:/*
;2461:==================
;2462:BotHasPersistantPowerupAndWeapon
;2463:==================
;2464:*/
;2465:int BotHasPersistantPowerupAndWeapon(bot_state_t *bs) {
line 2476
;2466:#ifdef MISSIONPACK
;2467:	// if the bot does not have a persistant powerup
;2468:	if (!bs->inventory[INVENTORY_SCOUT] &&
;2469:		!bs->inventory[INVENTORY_GUARD] &&
;2470:		!bs->inventory[INVENTORY_DOUBLER] &&
;2471:		!bs->inventory[INVENTORY_AMMOREGEN] ) {
;2472:		return qfalse;
;2473:	}
;2474:#endif
;2475:	//if the bot is very low on health
;2476:	if (bs->inventory[INVENTORY_HEALTH] < 60) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 60
GEI4 $620
CNSTI4 0
RETI4
ADDRGP4 $619
JUMPV
LABELV $620
line 2478
;2477:	//if the bot is low on health
;2478:	if (bs->inventory[INVENTORY_HEALTH] < 80) {
ADDRFP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
CNSTI4 80
GEI4 $622
line 2480
;2479:		//if the bot has insufficient armor
;2480:		if (bs->inventory[INVENTORY_ARMOR] < 40) return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 4956
ADDP4
INDIRI4
CNSTI4 40
GEI4 $624
CNSTI4 0
RETI4
ADDRGP4 $619
JUMPV
LABELV $624
line 2481
;2481:	}
LABELV $622
line 2483
;2482:	//if the bot can use the bfg
;2483:	if (bs->inventory[INVENTORY_BFG10K] > 0 &&
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
LEI4 $626
ADDRLP4 0
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 7
LEI4 $626
line 2484
;2484:			bs->inventory[INVENTORY_BFGAMMO] > 7) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $626
line 2486
;2485:	//if the bot can use the railgun
;2486:	if (bs->inventory[INVENTORY_RAILGUN] > 0 &&
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
LEI4 $628
ADDRLP4 4
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 5
LEI4 $628
line 2487
;2487:			bs->inventory[INVENTORY_SLUGS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $628
line 2489
;2488:	//if the bot can use the lightning gun
;2489:	if (bs->inventory[INVENTORY_LIGHTNING] > 0 &&
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
LEI4 $630
ADDRLP4 8
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
CNSTI4 50
LEI4 $630
line 2490
;2490:			bs->inventory[INVENTORY_LIGHTNINGAMMO] > 50) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $630
line 2492
;2491:	//if the bot can use the rocketlauncher
;2492:	if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 &&
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
LEI4 $632
ADDRLP4 12
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
CNSTI4 5
LEI4 $632
line 2493
;2493:			bs->inventory[INVENTORY_ROCKETS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $632
line 2495
;2494:	//
;2495:	if (bs->inventory[INVENTORY_NAILGUN] > 0 &&
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
LEI4 $634
ADDRLP4 16
INDIRP4
CNSTI4 5056
ADDP4
INDIRI4
CNSTI4 5
LEI4 $634
line 2496
;2496:			bs->inventory[INVENTORY_NAILS] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $634
line 2498
;2497:	//
;2498:	if (bs->inventory[INVENTORY_PROXLAUNCHER] > 0 &&
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
LEI4 $636
ADDRLP4 20
INDIRP4
CNSTI4 5060
ADDP4
INDIRI4
CNSTI4 5
LEI4 $636
line 2499
;2499:			bs->inventory[INVENTORY_MINES] > 5) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $636
line 2501
;2500:	//
;2501:	if (bs->inventory[INVENTORY_CHAINGUN] > 0 &&
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
LEI4 $638
ADDRLP4 24
INDIRP4
CNSTI4 5064
ADDP4
INDIRI4
CNSTI4 40
LEI4 $638
line 2502
;2502:			bs->inventory[INVENTORY_BELT] > 40) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $638
line 2504
;2503:	//if the bot can use the plasmagun
;2504:	if (bs->inventory[INVENTORY_PLASMAGUN] > 0 &&
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
LEI4 $640
ADDRLP4 28
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
CNSTI4 20
LEI4 $640
line 2505
;2505:			bs->inventory[INVENTORY_CELLS] > 20) return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $619
JUMPV
LABELV $640
line 2506
;2506:	return qfalse;
CNSTI4 0
RETI4
LABELV $619
endproc BotHasPersistantPowerupAndWeapon 32 0
export BotGoCamp
proc BotGoCamp 16 16
line 2514
;2507:}
;2508:
;2509:/*
;2510:==================
;2511:BotGoCamp
;2512:==================
;2513:*/
;2514:void BotGoCamp(bot_state_t *bs, bot_goal_t *goal) {
line 2517
;2515:	float camper;
;2516:
;2517:	bs->decisionmaker = bs->client;
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
line 2519
;2518:	//set message time to zero so bot will NOT show any message
;2519:	bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 2521
;2520:	//set the ltg type
;2521:	bs->ltgtype = LTG_CAMP;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 7
ASGNI4
line 2523
;2522:	//set the team goal
;2523:	memcpy(&bs->teamgoal, goal, sizeof(bot_goal_t));
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
line 2525
;2524:	//get the team goal time
;2525:	camper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CAMPER, 0, 1);
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
line 2526
;2526:	if (camper > 0.99) bs->teamgoal_time = FloatTime() + 99999;
ADDRLP4 0
INDIRF4
CNSTF4 1065185444
LEF4 $643
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1203982208
ADDF4
ASGNF4
ADDRGP4 $644
JUMPV
LABELV $643
line 2527
;2527:	else bs->teamgoal_time = FloatTime() + 120 + 180 * camper + random() * 15;
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
LABELV $644
line 2529
;2528:	//set the last time the bot started camping
;2529:	bs->camp_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2531
;2530:	//the teammate that requested the camping
;2531:	bs->teammate = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
CNSTI4 0
ASGNI4
line 2533
;2532:	//do NOT type arrive message
;2533:	bs->arrive_time = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
CNSTF4 1065353216
ASGNF4
line 2534
;2534:}
LABELV $642
endproc BotGoCamp 16 16
export BotWantsToCamp
proc BotWantsToCamp 176 16
line 2541
;2535:
;2536:/*
;2537:==================
;2538:BotWantsToCamp
;2539:==================
;2540:*/
;2541:int BotWantsToCamp(bot_state_t *bs) {
line 2546
;2542:	float camper;
;2543:	int cs, traveltime, besttraveltime;
;2544:	bot_goal_t goal, bestgoal;
;2545:
;2546:	camper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CAMPER, 0, 1);
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
line 2547
;2547:	if (camper < 0.1) return qfalse;
ADDRLP4 124
INDIRF4
CNSTF4 1036831949
GEF4 $646
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $646
line 2549
;2548:	//if the bot has a team goal
;2549:	if (bs->ltgtype == LTG_TEAMHELP ||
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
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 2
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 3
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 4
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 5
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 7
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 8
EQI4 $656
ADDRLP4 132
INDIRI4
CNSTI4 9
NEI4 $648
LABELV $656
line 2556
;2550:			bs->ltgtype == LTG_TEAMACCOMPANY ||
;2551:			bs->ltgtype == LTG_DEFENDKEYAREA ||
;2552:			bs->ltgtype == LTG_GETFLAG ||
;2553:			bs->ltgtype == LTG_RUSHBASE ||
;2554:			bs->ltgtype == LTG_CAMP ||
;2555:			bs->ltgtype == LTG_CAMPORDER ||
;2556:			bs->ltgtype == LTG_PATROL) {
line 2557
;2557:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $648
line 2560
;2558:	}
;2559:	//if camped recently
;2560:	if (bs->camp_time > FloatTime() - 60 + 300 * (1-camper)) return qfalse;
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
LEF4 $657
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $657
line 2562
;2561:	//
;2562:	if (random() > camper) {
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
LEF4 $659
line 2563
;2563:		bs->camp_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6184
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2564
;2564:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $659
line 2567
;2565:	}
;2566:	//if the bot isn't healthy anough
;2567:	if (BotAggression(bs) < 50) return qfalse;
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
GEF4 $661
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $661
line 2569
;2568:	//the bot should have at least have the rocket launcher, the railgun or the bfg10k with some ammo
;2569:	if ((bs->inventory[INVENTORY_ROCKETLAUNCHER] <= 0 || bs->inventory[INVENTORY_ROCKETS < 10]) &&
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
LEI4 $665
ADDRLP4 144
INDIRP4
CNSTI4 4952
ADDP4
INDIRI4
ADDRLP4 148
INDIRI4
EQI4 $663
LABELV $665
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
LEI4 $666
ADDRLP4 152
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
CNSTI4 10
GEI4 $663
LABELV $666
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
LEI4 $667
ADDRLP4 156
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
CNSTI4 10
GEI4 $663
LABELV $667
line 2571
;2570:		(bs->inventory[INVENTORY_RAILGUN] <= 0 || bs->inventory[INVENTORY_SLUGS] < 10) &&
;2571:		(bs->inventory[INVENTORY_BFG10K] <= 0 || bs->inventory[INVENTORY_BFGAMMO] < 10)) {
line 2572
;2572:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $663
line 2575
;2573:	}
;2574:	//find the closest camp spot
;2575:	besttraveltime = 99999;
ADDRLP4 64
CNSTI4 99999
ASGNI4
line 2576
;2576:	for (cs = trap_BotGetNextCampSpotGoal(0, &goal); cs; cs = trap_BotGetNextCampSpotGoal(cs, &goal)) {
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
ADDRGP4 $671
JUMPV
LABELV $668
line 2577
;2577:		traveltime = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, goal.areanum, TFL_DEFAULT);
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
line 2578
;2578:		if (traveltime && traveltime < besttraveltime) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $673
ADDRLP4 0
INDIRI4
ADDRLP4 64
INDIRI4
GEI4 $673
line 2579
;2579:			besttraveltime = traveltime;
ADDRLP4 64
ADDRLP4 0
INDIRI4
ASGNI4
line 2580
;2580:			memcpy(&bestgoal, &goal, sizeof(bot_goal_t));
ADDRLP4 68
ARGP4
ADDRLP4 8
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 2581
;2581:		}
LABELV $673
line 2582
;2582:	}
LABELV $669
line 2576
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
LABELV $671
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $668
line 2583
;2583:	if (besttraveltime > 150) return qfalse;
ADDRLP4 64
INDIRI4
CNSTI4 150
LEI4 $675
CNSTI4 0
RETI4
ADDRGP4 $645
JUMPV
LABELV $675
line 2585
;2584:	//ok found a camp spot, go camp there
;2585:	BotGoCamp(bs, &bestgoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
ADDRGP4 BotGoCamp
CALLV
pop
line 2586
;2586:	bs->ordered = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6612
ADDP4
CNSTI4 0
ASGNI4
line 2588
;2587:	//
;2588:	return qtrue;
CNSTI4 1
RETI4
LABELV $645
endproc BotWantsToCamp 176 16
export BotDontAvoid
proc BotDontAvoid 68 12
line 2596
;2589:}
;2590:
;2591:/*
;2592:==================
;2593:BotDontAvoid
;2594:==================
;2595:*/
;2596:void BotDontAvoid(bot_state_t *bs, char *itemname) {
line 2600
;2597:	bot_goal_t goal;
;2598:	int num;
;2599:
;2600:	num = trap_BotGetLevelItemGoal(-1, itemname, &goal);
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
ADDRGP4 $679
JUMPV
LABELV $678
line 2601
;2601:	while(num >= 0) {
line 2602
;2602:		trap_BotRemoveFromAvoidGoals(bs->gs, goal.number);
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
line 2603
;2603:		num = trap_BotGetLevelItemGoal(num, itemname, &goal);
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
line 2604
;2604:	}
LABELV $679
line 2601
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $678
line 2605
;2605:}
LABELV $677
endproc BotDontAvoid 68 12
export BotGoForPowerups
proc BotGoForPowerups 0 8
line 2612
;2606:
;2607:/*
;2608:==================
;2609:BotGoForPowerups
;2610:==================
;2611:*/
;2612:void BotGoForPowerups(bot_state_t *bs) {
line 2615
;2613:
;2614:	//don't avoid any of the powerups anymore
;2615:	BotDontAvoid(bs, "Quad Damage");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $683
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2616
;2616:	BotDontAvoid(bs, "Regeneration");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $684
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2617
;2617:	BotDontAvoid(bs, "Battle Suit");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $685
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2618
;2618:	BotDontAvoid(bs, "Speed");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $686
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2619
;2619:	BotDontAvoid(bs, "Invisibility");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $687
ARGP4
ADDRGP4 BotDontAvoid
CALLV
pop
line 2623
;2620:	//BotDontAvoid(bs, "Flight");
;2621:	//reset the long term goal time so the bot will go for the powerup
;2622:	//NOTE: the long term goal type doesn't change
;2623:	bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2624
;2624:}
LABELV $682
endproc BotGoForPowerups 0 8
export BotRoamGoal
proc BotRoamGoal 180 28
line 2631
;2625:
;2626:/*
;2627:==================
;2628:BotRoamGoal
;2629:==================
;2630:*/
;2631:void BotRoamGoal(bot_state_t *bs, vec3_t goal) {
line 2637
;2632:	int pc, i;
;2633:	float len, rnd;
;2634:	vec3_t dir, bestorg, belowbestorg;
;2635:	bsp_trace_t trace;
;2636:
;2637:	for (i = 0; i < 10; i++) {
ADDRLP4 116
CNSTI4 0
ASGNI4
LABELV $689
line 2639
;2638:		//start at the bot origin
;2639:		VectorCopy(bs->origin, bestorg);
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 2640
;2640:		rnd = random();
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
line 2641
;2641:		if (rnd > 0.25) {
ADDRLP4 112
INDIRF4
CNSTF4 1048576000
LEF4 $693
line 2643
;2642:			//add a random value to the x-coordinate
;2643:			if (random() < 0.5) bestorg[0] -= 800 * random() + 100;
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
GEF4 $695
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
ADDRGP4 $696
JUMPV
LABELV $695
line 2644
;2644:			else bestorg[0] += 800 * random() + 100;
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
LABELV $696
line 2645
;2645:		}
LABELV $693
line 2646
;2646:		if (rnd < 0.75) {
ADDRLP4 112
INDIRF4
CNSTF4 1061158912
GEF4 $697
line 2648
;2647:			//add a random value to the y-coordinate
;2648:			if (random() < 0.5) bestorg[1] -= 800 * random() + 100;
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
GEF4 $699
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
ADDRGP4 $700
JUMPV
LABELV $699
line 2649
;2649:			else bestorg[1] += 800 * random() + 100;
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
LABELV $700
line 2650
;2650:		}
LABELV $697
line 2652
;2651:		//add a random value to the z-coordinate (NOTE: 48 = maxjump?)
;2652:		bestorg[2] += 2 * 48 * crandom();
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
line 2654
;2653:		//trace a line from the origin to the roam target
;2654:		BotAI_Trace(&trace, bs->origin, NULL, NULL, bestorg, bs->entitynum, MASK_SOLID);
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
line 2656
;2655:		//direction and length towards the roam target
;2656:		VectorSubtract(trace.endpos, bs->origin, dir);
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
line 2657
;2657:		len = VectorNormalize(dir);
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
line 2659
;2658:		//if the roam target is far away anough
;2659:		if (len > 200) {
ADDRLP4 108
INDIRF4
CNSTF4 1128792064
LEF4 $711
line 2661
;2660:			//the roam target is in the given direction before walls
;2661:			VectorScale(dir, len * trace.fraction - 40, dir);
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
line 2662
;2662:			VectorAdd(bs->origin, dir, bestorg);
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
line 2664
;2663:			//get the coordinates of the floor below the roam target
;2664:			belowbestorg[0] = bestorg[0];
ADDRLP4 120
ADDRLP4 12
INDIRF4
ASGNF4
line 2665
;2665:			belowbestorg[1] = bestorg[1];
ADDRLP4 120+4
ADDRLP4 12+4
INDIRF4
ASGNF4
line 2666
;2666:			belowbestorg[2] = bestorg[2] - 800;
ADDRLP4 120+8
ADDRLP4 12+8
INDIRF4
CNSTF4 1145569280
SUBF4
ASGNF4
line 2667
;2667:			BotAI_Trace(&trace, bestorg, NULL, NULL, belowbestorg, bs->entitynum, MASK_SOLID);
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
line 2669
;2668:			//
;2669:			if (!trace.startsolid) {
ADDRLP4 24+4
INDIRI4
CNSTI4 0
NEI4 $728
line 2670
;2670:				trace.endpos[2]++;
ADDRLP4 24+12+8
ADDRLP4 24+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2671
;2671:				pc = trap_PointContents(trace.endpos, bs->entitynum);
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
line 2672
;2672:				if (!(pc & (CONTENTS_LAVA | CONTENTS_SLIME))) {
ADDRLP4 132
INDIRI4
CNSTI4 24
BANDI4
CNSTI4 0
NEI4 $734
line 2673
;2673:					VectorCopy(bestorg, goal);
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRB
ASGNB 12
line 2674
;2674:					return;
ADDRGP4 $688
JUMPV
LABELV $734
line 2676
;2675:				}
;2676:			}
LABELV $728
line 2677
;2677:		}
LABELV $711
line 2678
;2678:	}
LABELV $690
line 2637
ADDRLP4 116
ADDRLP4 116
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 116
INDIRI4
CNSTI4 10
LTI4 $689
line 2679
;2679:	VectorCopy(bestorg, goal);
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRB
ASGNB 12
line 2680
;2680:}
LABELV $688
endproc BotRoamGoal 180 28
lit
align 4
LABELV $738
byte 4 0
byte 4 0
byte 4 1065353216
export BotAttackMove
code
proc BotAttackMove 392 16
line 2687
;2681:
;2682:/*
;2683:==================
;2684:BotAttackMove
;2685:==================
;2686:*/
;2687:bot_moveresult_t BotAttackMove(bot_state_t *bs, int tfl) {
line 2691
;2688:	int movetype, i, attackentity;
;2689:	float attack_skill, jumper, croucher, dist, strafechange_time;
;2690:	float attack_dist, attack_range;
;2691:	vec3_t forward, backward, sideward, hordir, up = {0, 0, 1};
ADDRLP4 56
ADDRGP4 $738
INDIRB
ASGNB 12
line 2696
;2692:	aas_entityinfo_t entinfo;
;2693:	bot_moveresult_t moveresult;
;2694:	bot_goal_t goal;
;2695:
;2696:	attackentity = bs->enemy;
ADDRLP4 332
ADDRFP4 4
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 2698
;2697:	//
;2698:	if (bs->attackchase_time > FloatTime()) {
ADDRFP4 4
INDIRP4
CNSTI4 6124
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $739
line 2700
;2699:		//create the chase goal
;2700:		goal.entitynum = attackentity;
ADDRLP4 136+40
ADDRLP4 332
INDIRI4
ASGNI4
line 2701
;2701:		goal.areanum = bs->lastenemyareanum;
ADDRLP4 136+12
ADDRFP4 4
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
ASGNI4
line 2702
;2702:		VectorCopy(bs->lastenemyorigin, goal.origin);
ADDRLP4 136
ADDRFP4 4
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 2703
;2703:		VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 136+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 136+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 136+16+8
CNSTF4 3238002688
ASGNF4
line 2704
;2704:		VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 136+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 136+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 136+28+8
CNSTF4 1090519040
ASGNF4
line 2706
;2705:		//initialize the movement state
;2706:		BotSetupForMovement(bs);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2708
;2707:		//move towards the goal
;2708:		trap_BotMoveToGoal(&moveresult, bs->ms, &goal, tfl);
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
line 2709
;2709:		return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $736
JUMPV
LABELV $739
line 2712
;2710:	}
;2711:	//
;2712:	memset(&moveresult, 0, sizeof(bot_moveresult_t));
ADDRLP4 80
ARGP4
CNSTI4 0
ARGI4
CNSTI4 52
ARGI4
ADDRGP4 memset
CALLP4
pop
line 2714
;2713:	//
;2714:	attack_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ATTACK_SKILL, 0, 1);
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
line 2715
;2715:	jumper = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_JUMPER, 0, 1);
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
line 2716
;2716:	croucher = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CROUCHER, 0, 1);
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
line 2718
;2717:	//if the bot is really stupid
;2718:	if (attack_skill < 0.2) return moveresult;
ADDRLP4 132
INDIRF4
CNSTF4 1045220557
GEF4 $753
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $736
JUMPV
LABELV $753
line 2720
;2719:	//initialize the movement state
;2720:	BotSetupForMovement(bs);
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2722
;2721:	//get the enemy entity info
;2722:	BotEntityInfo(attackentity, &entinfo);
ADDRLP4 332
INDIRI4
ARGI4
ADDRLP4 192
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2724
;2723:	//direction towards the enemy
;2724:	VectorSubtract(entinfo.origin, bs->origin, forward);
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
line 2726
;2725:	//the distance towards the enemy
;2726:	dist = VectorNormalize(forward);
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
line 2727
;2727:	VectorNegate(forward, backward);
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
line 2729
;2728:	//walk, crouch or jump
;2729:	movetype = MOVE_WALK;
ADDRLP4 52
CNSTI4 1
ASGNI4
line 2731
;2730:	//
;2731:	if (bs->attackcrouch_time < FloatTime() - 1) {
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $766
line 2732
;2732:		if (random() < jumper) {
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
GEF4 $768
line 2733
;2733:			movetype = MOVE_JUMP;
ADDRLP4 52
CNSTI4 4
ASGNI4
line 2734
;2734:		}
ADDRGP4 $769
JUMPV
LABELV $768
line 2736
;2735:		//wait at least one second before crouching again
;2736:		else if (bs->attackcrouch_time < FloatTime() - 1 && random() < croucher) {
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $770
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
GEF4 $770
line 2737
;2737:			bs->attackcrouch_time = FloatTime() + croucher * 5;
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
line 2738
;2738:		}
LABELV $770
LABELV $769
line 2739
;2739:	}
LABELV $766
line 2740
;2740:	if (bs->attackcrouch_time > FloatTime()) movetype = MOVE_CROUCH;
ADDRFP4 4
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $772
ADDRLP4 52
CNSTI4 2
ASGNI4
LABELV $772
line 2742
;2741:	//if the bot should jump
;2742:	if (movetype == MOVE_JUMP) {
ADDRLP4 52
INDIRI4
CNSTI4 4
NEI4 $774
line 2744
;2743:		//if jumped last frame
;2744:		if (bs->attackjump_time > FloatTime()) {
ADDRFP4 4
INDIRP4
CNSTI4 6128
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $776
line 2745
;2745:			movetype = MOVE_WALK;
ADDRLP4 52
CNSTI4 1
ASGNI4
line 2746
;2746:		}
ADDRGP4 $777
JUMPV
LABELV $776
line 2747
;2747:		else {
line 2748
;2748:			bs->attackjump_time = FloatTime() + 1;
ADDRFP4 4
INDIRP4
CNSTI4 6128
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2749
;2749:		}
LABELV $777
line 2750
;2750:	}
LABELV $774
line 2751
;2751:	if (bs->cur_ps.weapon == WP_GAUNTLET) {
ADDRFP4 4
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
CNSTI4 1
NEI4 $778
line 2752
;2752:		attack_dist = 0;
ADDRLP4 72
CNSTF4 0
ASGNF4
line 2753
;2753:		attack_range = 0;
ADDRLP4 76
CNSTF4 0
ASGNF4
line 2754
;2754:	}
ADDRGP4 $779
JUMPV
LABELV $778
line 2755
;2755:	else {
line 2756
;2756:		attack_dist = IDEAL_ATTACKDIST;
ADDRLP4 72
CNSTF4 1124859904
ASGNF4
line 2757
;2757:		attack_range = 40;
ADDRLP4 76
CNSTF4 1109393408
ASGNF4
line 2758
;2758:	}
LABELV $779
line 2760
;2759:	//if the bot is stupid
;2760:	if (attack_skill <= 0.4) {
ADDRLP4 132
INDIRF4
CNSTF4 1053609165
GTF4 $780
line 2762
;2761:		//just walk to or away from the enemy
;2762:		if (dist > attack_dist + attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
ADDF4
LEF4 $782
line 2763
;2763:			if (trap_BotMoveInDirection(bs->ms, forward, 400, movetype)) return moveresult;
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
EQI4 $784
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $736
JUMPV
LABELV $784
line 2764
;2764:		}
LABELV $782
line 2765
;2765:		if (dist < attack_dist - attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
GEF4 $786
line 2766
;2766:			if (trap_BotMoveInDirection(bs->ms, backward, 400, movetype)) return moveresult;
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
EQI4 $788
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $736
JUMPV
LABELV $788
line 2767
;2767:		}
LABELV $786
line 2768
;2768:		return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $736
JUMPV
LABELV $780
line 2771
;2769:	}
;2770:	//increase the strafe time
;2771:	bs->attackstrafe_time += bs->thinktime;
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
line 2773
;2772:	//get the strafe change time
;2773:	strafechange_time = 0.4 + (1 - attack_skill) * 0.2;
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
line 2774
;2774:	if (attack_skill > 0.7) strafechange_time += crandom() * 0.2;
ADDRLP4 132
INDIRF4
CNSTF4 1060320051
LEF4 $790
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
LABELV $790
line 2776
;2775:	//if the strafe direction should be changed
;2776:	if (bs->attackstrafe_time > strafechange_time) {
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
INDIRF4
ADDRLP4 336
INDIRF4
LEF4 $792
line 2778
;2777:		//some magic number :)
;2778:		if (random() > 0.935) {
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
LEF4 $794
line 2780
;2779:			//flip the strafe direction
;2780:			bs->flags ^= BFL_STRAFERIGHT;
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
line 2781
;2781:			bs->attackstrafe_time = 0;
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
CNSTF4 0
ASGNF4
line 2782
;2782:		}
LABELV $794
line 2783
;2783:	}
LABELV $792
line 2785
;2784:	//
;2785:	for (i = 0; i < 2; i++) {
ADDRLP4 48
CNSTI4 0
ASGNI4
LABELV $796
line 2786
;2786:		hordir[0] = forward[0];
ADDRLP4 12
ADDRLP4 24
INDIRF4
ASGNF4
line 2787
;2787:		hordir[1] = forward[1];
ADDRLP4 12+4
ADDRLP4 24+4
INDIRF4
ASGNF4
line 2788
;2788:		hordir[2] = 0;
ADDRLP4 12+8
CNSTF4 0
ASGNF4
line 2789
;2789:		VectorNormalize(hordir);
ADDRLP4 12
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 2791
;2790:		//get the sideward vector
;2791:		CrossProduct(hordir, up, sideward);
ADDRLP4 12
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 2793
;2792:		//reverse the vector depending on the strafe direction
;2793:		if (bs->flags & BFL_STRAFERIGHT) VectorNegate(sideward, sideward);
ADDRFP4 4
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $803
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
LABELV $803
line 2795
;2794:		//randomly go back a little
;2795:		if (random() > 0.9) {
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
LEF4 $809
line 2796
;2796:			VectorAdd(sideward, backward, sideward);
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
line 2797
;2797:		}
ADDRGP4 $810
JUMPV
LABELV $809
line 2798
;2798:		else {
line 2800
;2799:			//walk forward or backward to get at the ideal attack distance
;2800:			if (dist > attack_dist + attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
ADDF4
LEF4 $817
line 2801
;2801:				VectorAdd(sideward, forward, sideward);
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
line 2802
;2802:			}
ADDRGP4 $818
JUMPV
LABELV $817
line 2803
;2803:			else if (dist < attack_dist - attack_range) {
ADDRLP4 68
INDIRF4
ADDRLP4 72
INDIRF4
ADDRLP4 76
INDIRF4
SUBF4
GEF4 $825
line 2804
;2804:				VectorAdd(sideward, backward, sideward);
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
line 2805
;2805:			}
LABELV $825
LABELV $818
line 2806
;2806:		}
LABELV $810
line 2808
;2807:		//perform the movement
;2808:		if (trap_BotMoveInDirection(bs->ms, sideward, 400, movetype))
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
EQI4 $833
line 2809
;2809:			return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
ADDRGP4 $736
JUMPV
LABELV $833
line 2811
;2810:		//movement failed, flip the strafe direction
;2811:		bs->flags ^= BFL_STRAFERIGHT;
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
line 2812
;2812:		bs->attackstrafe_time = 0;
ADDRFP4 4
INDIRP4
CNSTI4 6116
ADDP4
CNSTF4 0
ASGNF4
line 2813
;2813:	}
LABELV $797
line 2785
ADDRLP4 48
ADDRLP4 48
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 2
LTI4 $796
line 2816
;2814:	//bot couldn't do any usefull movement
;2815://	bs->attackchase_time = AAS_Time() + 6;
;2816:	return moveresult;
ADDRFP4 0
INDIRP4
ADDRLP4 80
INDIRB
ASGNB 52
LABELV $736
endproc BotAttackMove 392 16
export BotSameTeam
proc BotSameTeam 2072 12
line 2824
;2817:}
;2818:
;2819:/*
;2820:==================
;2821:BotSameTeam
;2822:==================
;2823:*/
;2824:int BotSameTeam(bot_state_t *bs, int entnum) {
line 2827
;2825:	char info1[1024], info2[1024];
;2826:
;2827:	if (bs->client < 0 || bs->client >= MAX_CLIENTS) {
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
LTI4 $838
ADDRLP4 2048
INDIRI4
CNSTI4 64
LTI4 $836
LABELV $838
line 2829
;2828:		//BotAI_Print(PRT_ERROR, "BotSameTeam: client out of range\n");
;2829:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $835
JUMPV
LABELV $836
line 2831
;2830:	}
;2831:	if (entnum < 0 || entnum >= MAX_CLIENTS) {
ADDRLP4 2052
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 2052
INDIRI4
CNSTI4 0
LTI4 $841
ADDRLP4 2052
INDIRI4
CNSTI4 64
LTI4 $839
LABELV $841
line 2833
;2832:		//BotAI_Print(PRT_ERROR, "BotSameTeam: client out of range\n");
;2833:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $835
JUMPV
LABELV $839
line 2835
;2834:	}
;2835:	if ( gametype >= GT_TEAM ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 3
LTI4 $842
line 2836
;2836:		trap_GetConfigstring(CS_PLAYERS+bs->client, info1, sizeof(info1));
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
line 2837
;2837:		trap_GetConfigstring(CS_PLAYERS+entnum, info2, sizeof(info2));
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
line 2839
;2838:		//
;2839:		if (atoi(Info_ValueForKey(info1, "t")) == atoi(Info_ValueForKey(info2, "t"))) return qtrue;
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
NEI4 $844
CNSTI4 1
RETI4
ADDRGP4 $835
JUMPV
LABELV $844
line 2840
;2840:	}
LABELV $842
line 2841
;2841:	return qfalse;
CNSTI4 0
RETI4
LABELV $835
endproc BotSameTeam 2072 12
export InFieldOfVision
proc InFieldOfVision 24 4
line 2850
;2842:}
;2843:
;2844:/*
;2845:==================
;2846:InFieldOfVision
;2847:==================
;2848:*/
;2849:qboolean InFieldOfVision(vec3_t viewangles, float fov, vec3_t angles)
;2850:{
line 2854
;2851:	int i;
;2852:	float diff, angle;
;2853:
;2854:	for (i = 0; i < 2; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $847
line 2855
;2855:		angle = AngleMod(viewangles[i]);
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
line 2856
;2856:		angles[i] = AngleMod(angles[i]);
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
line 2857
;2857:		diff = angles[i] - angle;
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
line 2858
;2858:		if (angles[i] > angle) {
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
LEF4 $851
line 2859
;2859:			if (diff > 180.0) diff -= 360.0;
ADDRLP4 4
INDIRF4
CNSTF4 1127481344
LEF4 $852
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1135869952
SUBF4
ASGNF4
line 2860
;2860:		}
ADDRGP4 $852
JUMPV
LABELV $851
line 2861
;2861:		else {
line 2862
;2862:			if (diff < -180.0) diff += 360.0;
ADDRLP4 4
INDIRF4
CNSTF4 3274964992
GEF4 $855
ADDRLP4 4
ADDRLP4 4
INDIRF4
CNSTF4 1135869952
ADDF4
ASGNF4
LABELV $855
line 2863
;2863:		}
LABELV $852
line 2864
;2864:		if (diff > 0) {
ADDRLP4 4
INDIRF4
CNSTF4 0
LEF4 $857
line 2865
;2865:			if (diff > fov * 0.5) return qfalse;
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
MULF4
LEF4 $858
CNSTI4 0
RETI4
ADDRGP4 $846
JUMPV
line 2866
;2866:		}
LABELV $857
line 2867
;2867:		else {
line 2868
;2868:			if (diff < -fov * 0.5) return qfalse;
ADDRLP4 4
INDIRF4
CNSTF4 1056964608
ADDRFP4 4
INDIRF4
NEGF4
MULF4
GEF4 $861
CNSTI4 0
RETI4
ADDRGP4 $846
JUMPV
LABELV $861
line 2869
;2869:		}
LABELV $858
line 2870
;2870:	}
LABELV $848
line 2854
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LTI4 $847
line 2871
;2871:	return qtrue;
CNSTI4 1
RETI4
LABELV $846
endproc InFieldOfVision 24 4
export BotEntityVisible
proc BotEntityVisible 376 28
line 2881
;2872:}
;2873:
;2874:/*
;2875:==================
;2876:BotEntityVisible
;2877:
;2878:returns visibility in the range [0, 1] taking fog and water surfaces into account
;2879:==================
;2880:*/
;2881:float BotEntityVisible(int viewer, vec3_t eye, vec3_t viewangles, float fov, int ent) {
line 2889
;2882:	int i, contents_mask, passent, hitent, infog, inwater, otherinfog, pc;
;2883:	float squaredfogdist, waterfactor, vis, bestvis;
;2884:	bsp_trace_t trace;
;2885:	aas_entityinfo_t entinfo;
;2886:	vec3_t dir, entangles, start, end, middle;
;2887:
;2888:	//calculate middle of bounding box
;2889:	BotEntityInfo(ent, &entinfo);
ADDRFP4 16
INDIRI4
ARGI4
ADDRLP4 148
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2890
;2890:	VectorAdd(entinfo.mins, entinfo.maxs, middle);
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
line 2891
;2891:	VectorScale(middle, 0.5, middle);
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
line 2892
;2892:	VectorAdd(entinfo.origin, middle, middle);
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
line 2894
;2893:	//check if entity is within field of vision
;2894:	VectorSubtract(middle, eye, dir);
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
line 2895
;2895:	vectoangles(dir, entangles);
ADDRLP4 136
ARGP4
ADDRLP4 320
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2896
;2896:	if (!InFieldOfVision(viewangles, fov, entangles)) return 0;
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
NEI4 $893
CNSTF4 0
RETF4
ADDRGP4 $863
JUMPV
LABELV $893
line 2898
;2897:	//
;2898:	pc = trap_AAS_PointContents(eye);
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
line 2899
;2899:	infog = (pc & CONTENTS_FOG);
ADDRLP4 312
ADDRLP4 316
INDIRI4
CNSTI4 64
BANDI4
ASGNI4
line 2900
;2900:	inwater = (pc & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER));
ADDRLP4 308
ADDRLP4 316
INDIRI4
CNSTI4 56
BANDI4
ASGNI4
line 2902
;2901:	//
;2902:	bestvis = 0;
ADDRLP4 296
CNSTF4 0
ASGNF4
line 2903
;2903:	for (i = 0; i < 3; i++) {
ADDRLP4 100
CNSTI4 0
ASGNI4
LABELV $895
line 2907
;2904:		//if the point is not in potential visible sight
;2905:		//if (!AAS_inPVS(eye, middle)) continue;
;2906:		//
;2907:		contents_mask = CONTENTS_SOLID|CONTENTS_PLAYERCLIP;
ADDRLP4 96
CNSTI4 65537
ASGNI4
line 2908
;2908:		passent = viewer;
ADDRLP4 116
ADDRFP4 0
INDIRI4
ASGNI4
line 2909
;2909:		hitent = ent;
ADDRLP4 132
ADDRFP4 16
INDIRI4
ASGNI4
line 2910
;2910:		VectorCopy(eye, start);
ADDRLP4 120
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2911
;2911:		VectorCopy(middle, end);
ADDRLP4 104
ADDRLP4 84
INDIRB
ASGNB 12
line 2913
;2912:		//if the entity is in water, lava or slime
;2913:		if (trap_AAS_PointContents(middle) & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER)) {
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
EQI4 $899
line 2914
;2914:			contents_mask |= (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 56
BORI4
ASGNI4
line 2915
;2915:		}
LABELV $899
line 2917
;2916:		//if eye is in water, lava or slime
;2917:		if (inwater) {
ADDRLP4 308
INDIRI4
CNSTI4 0
EQI4 $901
line 2918
;2918:			if (!(contents_mask & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER))) {
ADDRLP4 96
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
NEI4 $903
line 2919
;2919:				passent = ent;
ADDRLP4 116
ADDRFP4 16
INDIRI4
ASGNI4
line 2920
;2920:				hitent = viewer;
ADDRLP4 132
ADDRFP4 0
INDIRI4
ASGNI4
line 2921
;2921:				VectorCopy(middle, start);
ADDRLP4 120
ADDRLP4 84
INDIRB
ASGNB 12
line 2922
;2922:				VectorCopy(eye, end);
ADDRLP4 104
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
line 2923
;2923:			}
LABELV $903
line 2924
;2924:			contents_mask ^= (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 56
BXORI4
ASGNI4
line 2925
;2925:		}
LABELV $901
line 2927
;2926:		//trace from start to end
;2927:		BotAI_Trace(&trace, start, NULL, NULL, end, passent, contents_mask);
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
line 2929
;2928:		//if water was hit
;2929:		waterfactor = 1.0;
ADDRLP4 288
CNSTF4 1065353216
ASGNF4
line 2930
;2930:		if (trace.contents & (CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER)) {
ADDRLP4 0+76
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $905
line 2932
;2931:			//if the water surface is translucent
;2932:			if (1) {
line 2934
;2933:				//trace through the water
;2934:				contents_mask &= ~(CONTENTS_LAVA|CONTENTS_SLIME|CONTENTS_WATER);
ADDRLP4 96
ADDRLP4 96
INDIRI4
CNSTI4 -57
BANDI4
ASGNI4
line 2935
;2935:				BotAI_Trace(&trace, trace.endpos, NULL, NULL, end, passent, contents_mask);
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
line 2936
;2936:				waterfactor = 0.5;
ADDRLP4 288
CNSTF4 1056964608
ASGNF4
line 2937
;2937:			}
LABELV $908
line 2938
;2938:		}
LABELV $905
line 2940
;2939:		//if a full trace or the hitent was hit
;2940:		if (trace.fraction >= 1 || trace.ent == hitent) {
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $915
ADDRLP4 0+80
INDIRI4
ADDRLP4 132
INDIRI4
NEI4 $911
LABELV $915
line 2943
;2941:			//check for fog, assuming there's only one fog brush where
;2942:			//either the viewer or the entity is in or both are in
;2943:			otherinfog = (trap_AAS_PointContents(middle) & CONTENTS_FOG);
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
line 2944
;2944:			if (infog && otherinfog) {
ADDRLP4 360
CNSTI4 0
ASGNI4
ADDRLP4 312
INDIRI4
ADDRLP4 360
INDIRI4
EQI4 $916
ADDRLP4 304
INDIRI4
ADDRLP4 360
INDIRI4
EQI4 $916
line 2945
;2945:				VectorSubtract(trace.endpos, eye, dir);
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
line 2946
;2946:				squaredfogdist = VectorLengthSquared(dir);
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
line 2947
;2947:			}
ADDRGP4 $917
JUMPV
LABELV $916
line 2948
;2948:			else if (infog) {
ADDRLP4 312
INDIRI4
CNSTI4 0
EQI4 $925
line 2949
;2949:				VectorCopy(trace.endpos, start);
ADDRLP4 120
ADDRLP4 0+12
INDIRB
ASGNB 12
line 2950
;2950:				BotAI_Trace(&trace, start, NULL, NULL, eye, viewer, CONTENTS_FOG);
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
line 2951
;2951:				VectorSubtract(eye, trace.endpos, dir);
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
line 2952
;2952:				squaredfogdist = VectorLengthSquared(dir);
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
line 2953
;2953:			}
ADDRGP4 $926
JUMPV
LABELV $925
line 2954
;2954:			else if (otherinfog) {
ADDRLP4 304
INDIRI4
CNSTI4 0
EQI4 $935
line 2955
;2955:				VectorCopy(trace.endpos, end);
ADDRLP4 104
ADDRLP4 0+12
INDIRB
ASGNB 12
line 2956
;2956:				BotAI_Trace(&trace, eye, NULL, NULL, end, viewer, CONTENTS_FOG);
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
line 2957
;2957:				VectorSubtract(end, trace.endpos, dir);
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
line 2958
;2958:				squaredfogdist = VectorLengthSquared(dir);
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
line 2959
;2959:			}
ADDRGP4 $936
JUMPV
LABELV $935
line 2960
;2960:			else {
line 2962
;2961:				//if the entity and the viewer are not in fog assume there's no fog in between
;2962:				squaredfogdist = 0;
ADDRLP4 300
CNSTF4 0
ASGNF4
line 2963
;2963:			}
LABELV $936
LABELV $926
LABELV $917
line 2965
;2964:			//decrease visibility with the view distance through fog
;2965:			vis = 1 / ((squaredfogdist * 0.001) < 1 ? 1 : (squaredfogdist * 0.001));
ADDRLP4 368
CNSTF4 1065353216
ASGNF4
CNSTF4 981668463
ADDRLP4 300
INDIRF4
MULF4
ADDRLP4 368
INDIRF4
GEF4 $948
ADDRLP4 364
CNSTF4 1065353216
ASGNF4
ADDRGP4 $949
JUMPV
LABELV $948
ADDRLP4 364
CNSTF4 981668463
ADDRLP4 300
INDIRF4
MULF4
ASGNF4
LABELV $949
ADDRLP4 292
ADDRLP4 368
INDIRF4
ADDRLP4 364
INDIRF4
DIVF4
ASGNF4
line 2967
;2966:			//if entering water visibility is reduced
;2967:			vis *= waterfactor;
ADDRLP4 292
ADDRLP4 292
INDIRF4
ADDRLP4 288
INDIRF4
MULF4
ASGNF4
line 2969
;2968:			//
;2969:			if (vis > bestvis) bestvis = vis;
ADDRLP4 292
INDIRF4
ADDRLP4 296
INDIRF4
LEF4 $950
ADDRLP4 296
ADDRLP4 292
INDIRF4
ASGNF4
LABELV $950
line 2971
;2970:			//if pretty much no fog
;2971:			if (bestvis >= 0.95) return bestvis;
ADDRLP4 296
INDIRF4
CNSTF4 1064514355
LTF4 $952
ADDRLP4 296
INDIRF4
RETF4
ADDRGP4 $863
JUMPV
LABELV $952
line 2972
;2972:		}
LABELV $911
line 2974
;2973:		//check bottom and top of bounding box as well
;2974:		if (i == 0) middle[2] += entinfo.mins[2];
ADDRLP4 100
INDIRI4
CNSTI4 0
NEI4 $954
ADDRLP4 84+8
ADDRLP4 84+8
INDIRF4
ADDRLP4 148+72+8
INDIRF4
ADDF4
ASGNF4
ADDRGP4 $955
JUMPV
LABELV $954
line 2975
;2975:		else if (i == 1) middle[2] += entinfo.maxs[2] - entinfo.mins[2];
ADDRLP4 100
INDIRI4
CNSTI4 1
NEI4 $959
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
LABELV $959
LABELV $955
line 2976
;2976:	}
LABELV $896
line 2903
ADDRLP4 100
ADDRLP4 100
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 100
INDIRI4
CNSTI4 3
LTI4 $895
line 2977
;2977:	return bestvis;
ADDRLP4 296
INDIRF4
RETF4
LABELV $863
endproc BotEntityVisible 376 28
export BotFindEnemy
proc BotFindEnemy 432 20
line 2985
;2978:}
;2979:
;2980:/*
;2981:==================
;2982:BotFindEnemy
;2983:==================
;2984:*/
;2985:int BotFindEnemy(bot_state_t *bs, int curenemy) {
line 2992
;2986:	int i, healthdecrease;
;2987:	float f, alertness, easyfragger, vis;
;2988:	float squaredist, cursquaredist;
;2989:	aas_entityinfo_t entinfo, curenemyinfo;
;2990:	vec3_t dir, angles;
;2991:
;2992:	alertness = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ALERTNESS, 0, 1);
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
line 2993
;2993:	easyfragger = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_EASY_FRAGGER, 0, 1);
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
line 2995
;2994:	//check if the health decreased
;2995:	healthdecrease = bs->lasthealth > bs->inventory[INVENTORY_HEALTH];
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
LEI4 $968
ADDRLP4 344
CNSTI4 1
ASGNI4
ADDRGP4 $969
JUMPV
LABELV $968
ADDRLP4 344
CNSTI4 0
ASGNI4
LABELV $969
ADDRLP4 160
ADDRLP4 344
INDIRI4
ASGNI4
line 2997
;2996:	//remember the current health value
;2997:	bs->lasthealth = bs->inventory[INVENTORY_HEALTH];
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
line 2999
;2998:	//
;2999:	if (curenemy >= 0) {
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $970
line 3000
;3000:		BotEntityInfo(curenemy, &curenemyinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 196
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3001
;3001:		if (EntityCarriesFlag(&curenemyinfo)) return qfalse;
ADDRLP4 196
ARGP4
ADDRLP4 356
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 356
INDIRI4
CNSTI4 0
EQI4 $972
CNSTI4 0
RETI4
ADDRGP4 $966
JUMPV
LABELV $972
line 3002
;3002:		VectorSubtract(curenemyinfo.origin, bs->origin, dir);
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
line 3003
;3003:		cursquaredist = VectorLengthSquared(dir);
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
line 3004
;3004:	}
ADDRGP4 $971
JUMPV
LABELV $970
line 3005
;3005:	else {
line 3006
;3006:		cursquaredist = 0;
ADDRLP4 192
CNSTF4 0
ASGNF4
line 3007
;3007:	}
LABELV $971
line 3036
;3008:#ifdef MISSIONPACK
;3009:	if (gametype == GT_OBELISK) {
;3010:		vec3_t target;
;3011:		bot_goal_t *goal;
;3012:		bsp_trace_t trace;
;3013:
;3014:		if (BotTeam(bs) == TEAM_RED)
;3015:			goal = &blueobelisk;
;3016:		else
;3017:			goal = &redobelisk;
;3018:		//if the obelisk is visible
;3019:		VectorCopy(goal->origin, target);
;3020:		target[2] += 1;
;3021:		BotAI_Trace(&trace, bs->eye, NULL, NULL, target, bs->client, CONTENTS_SOLID);
;3022:		if (trace.fraction >= 1 || trace.ent == goal->entitynum) {
;3023:			if (goal->entitynum == bs->enemy) {
;3024:				return qfalse;
;3025:			}
;3026:			bs->enemy = goal->entitynum;
;3027:			bs->enemysight_time = FloatTime();
;3028:			bs->enemysuicide = qfalse;
;3029:			bs->enemydeath_time = 0;
;3030:			bs->enemyvisible_time = FloatTime();
;3031:			return qtrue;
;3032:		}
;3033:	}
;3034:#endif
;3035:	//
;3036:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 140
CNSTI4 0
ASGNI4
ADDRGP4 $984
JUMPV
LABELV $981
line 3038
;3037:
;3038:		if (i == bs->client) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $985
ADDRGP4 $982
JUMPV
LABELV $985
line 3040
;3039:		//if it's the current enemy
;3040:		if (i == curenemy) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $987
ADDRGP4 $982
JUMPV
LABELV $987
line 3042
;3041:		//
;3042:		BotEntityInfo(i, &entinfo);
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3044
;3043:		//
;3044:		if (!entinfo.valid) continue;
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $989
ADDRGP4 $982
JUMPV
LABELV $989
line 3046
;3045:		//if the enemy isn't dead and the enemy isn't the bot self
;3046:		if (EntityIsDead(&entinfo) || entinfo.number == bs->entitynum) continue;
ADDRLP4 0
ARGP4
ADDRLP4 356
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 356
INDIRI4
CNSTI4 0
NEI4 $994
ADDRLP4 0+20
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $991
LABELV $994
ADDRGP4 $982
JUMPV
LABELV $991
line 3048
;3047:		//if the enemy is invisible and not shooting
;3048:		if (EntityIsInvisible(&entinfo) && !EntityIsShooting(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 360
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 360
INDIRI4
CNSTI4 0
EQI4 $995
ADDRLP4 0
ARGP4
ADDRLP4 364
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 364
INDIRI4
CNSTI4 0
NEI4 $995
line 3049
;3049:			continue;
ADDRGP4 $982
JUMPV
LABELV $995
line 3052
;3050:		}
;3051:		//if not an easy fragger don't shoot at chatting players
;3052:		if (easyfragger < 0.5 && EntityIsChatting(&entinfo)) continue;
ADDRLP4 176
INDIRF4
CNSTF4 1056964608
GEF4 $997
ADDRLP4 0
ARGP4
ADDRLP4 368
ADDRGP4 EntityIsChatting
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 0
EQI4 $997
ADDRGP4 $982
JUMPV
LABELV $997
line 3054
;3053:		//
;3054:		if (lastteleport_time > FloatTime() - 3) {
ADDRGP4 lastteleport_time
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1077936128
SUBF4
LEF4 $999
line 3055
;3055:			VectorSubtract(entinfo.origin, lastteleport_origin, dir);
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
line 3056
;3056:			if (VectorLengthSquared(dir) < Square(70)) continue;
ADDRLP4 144
ARGP4
ADDRLP4 372
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 372
INDIRF4
CNSTF4 1167663104
GEF4 $1010
ADDRGP4 $982
JUMPV
LABELV $1010
line 3057
;3057:		}
LABELV $999
line 3059
;3058:		//calculate the distance towards the enemy
;3059:		VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3060
;3060:		squaredist = VectorLengthSquared(dir);
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
line 3062
;3061:		//if this entity is not carrying a flag
;3062:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 0
ARGP4
ADDRLP4 380
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 380
INDIRI4
CNSTI4 0
NEI4 $1019
line 3063
;3063:		{
line 3065
;3064:			//if this enemy is further away than the current one
;3065:			if (curenemy >= 0 && squaredist > cursquaredist) continue;
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1021
ADDRLP4 156
INDIRF4
ADDRLP4 192
INDIRF4
LEF4 $1021
ADDRGP4 $982
JUMPV
LABELV $1021
line 3066
;3066:		} //end if
LABELV $1019
line 3068
;3067:		//if the bot has no
;3068:		if (squaredist > Square(900.0 + alertness * 4000.0)) continue;
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
LEF4 $1023
ADDRGP4 $982
JUMPV
LABELV $1023
line 3070
;3069:		//if on the same team
;3070:		if (BotSameTeam(bs, i)) continue;
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
EQI4 $1025
ADDRGP4 $982
JUMPV
LABELV $1025
line 3072
;3071:		//if the bot's health decreased or the enemy is shooting
;3072:		if (curenemy < 0 && (healthdecrease || EntityIsShooting(&entinfo)))
ADDRLP4 392
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 392
INDIRI4
GEI4 $1027
ADDRLP4 160
INDIRI4
ADDRLP4 392
INDIRI4
NEI4 $1029
ADDRLP4 0
ARGP4
ADDRLP4 396
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 396
INDIRI4
CNSTI4 0
EQI4 $1027
LABELV $1029
line 3073
;3073:			f = 360;
ADDRLP4 168
CNSTF4 1135869952
ASGNF4
ADDRGP4 $1028
JUMPV
LABELV $1027
line 3075
;3074:		else
;3075:			f = 90 + 90 - (90 - (squaredist > Square(810) ? Square(810) : squaredist) / (810 * 9));
ADDRLP4 156
INDIRF4
CNSTF4 1226845760
LEF4 $1031
ADDRLP4 400
CNSTF4 1226845760
ASGNF4
ADDRGP4 $1032
JUMPV
LABELV $1031
ADDRLP4 400
ADDRLP4 156
INDIRF4
ASGNF4
LABELV $1032
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
LABELV $1028
line 3077
;3076:		//check if the enemy is visible
;3077:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, f, i);
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
line 3078
;3078:		if (vis <= 0) continue;
ADDRLP4 172
INDIRF4
CNSTF4 0
GTF4 $1033
ADDRGP4 $982
JUMPV
LABELV $1033
line 3080
;3079:		//if the enemy is quite far away, not shooting and the bot is not damaged
;3080:		if (curenemy < 0 && squaredist > Square(100) && !healthdecrease && !EntityIsShooting(&entinfo))
ADDRLP4 412
CNSTI4 0
ASGNI4
ADDRFP4 4
INDIRI4
ADDRLP4 412
INDIRI4
GEI4 $1035
ADDRLP4 156
INDIRF4
CNSTF4 1176256512
LEF4 $1035
ADDRLP4 160
INDIRI4
ADDRLP4 412
INDIRI4
NEI4 $1035
ADDRLP4 0
ARGP4
ADDRLP4 416
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 416
INDIRI4
CNSTI4 0
NEI4 $1035
line 3081
;3081:		{
line 3083
;3082:			//check if we can avoid this enemy
;3083:			VectorSubtract(bs->origin, entinfo.origin, dir);
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
line 3084
;3084:			vectoangles(dir, angles);
ADDRLP4 144
ARGP4
ADDRLP4 180
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3086
;3085:			//if the bot isn't in the fov of the enemy
;3086:			if (!InFieldOfVision(entinfo.angles, 90, angles)) {
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
NEI4 $1044
line 3088
;3087:				//update some stuff for this enemy
;3088:				BotUpdateBattleInventory(bs, i);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 3090
;3089:				//if the bot doesn't really want to fight
;3090:				if (BotWantsToRetreat(bs)) continue;
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
EQI4 $1047
ADDRGP4 $982
JUMPV
LABELV $1047
line 3091
;3091:			}
LABELV $1044
line 3092
;3092:		}
LABELV $1035
line 3094
;3093:		//found an enemy
;3094:		bs->enemy = entinfo.number;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
ADDRLP4 0+20
INDIRI4
ASGNI4
line 3095
;3095:		if (curenemy >= 0) bs->enemysight_time = FloatTime() - 2;
ADDRFP4 4
INDIRI4
CNSTI4 0
LTI4 $1050
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
ASGNF4
ADDRGP4 $1051
JUMPV
LABELV $1050
line 3096
;3096:		else bs->enemysight_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
LABELV $1051
line 3097
;3097:		bs->enemysuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 0
ASGNI4
line 3098
;3098:		bs->enemydeath_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
CNSTF4 0
ASGNF4
line 3099
;3099:		bs->enemyvisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 3100
;3100:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $966
JUMPV
LABELV $982
line 3036
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $984
ADDRLP4 140
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1052
ADDRLP4 140
INDIRI4
CNSTI4 64
LTI4 $981
LABELV $1052
line 3102
;3101:	}
;3102:	return qfalse;
CNSTI4 0
RETI4
LABELV $966
endproc BotFindEnemy 432 20
export BotTeamFlagCarrierVisible
proc BotTeamFlagCarrierVisible 164 20
line 3110
;3103:}
;3104:
;3105:/*
;3106:==================
;3107:BotTeamFlagCarrierVisible
;3108:==================
;3109:*/
;3110:int BotTeamFlagCarrierVisible(bot_state_t *bs) {
line 3115
;3111:	int i;
;3112:	float vis;
;3113:	aas_entityinfo_t entinfo;
;3114:
;3115:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1057
JUMPV
LABELV $1054
line 3116
;3116:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1058
line 3117
;3117:			continue;
ADDRGP4 $1055
JUMPV
LABELV $1058
line 3119
;3118:		//
;3119:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3121
;3120:		//if this player is active
;3121:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1060
line 3122
;3122:			continue;
ADDRGP4 $1055
JUMPV
LABELV $1060
line 3124
;3123:		//if this player is carrying a flag
;3124:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 148
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1062
line 3125
;3125:			continue;
ADDRGP4 $1055
JUMPV
LABELV $1062
line 3127
;3126:		//if the flag carrier is not on the same team
;3127:		if (!BotSameTeam(bs, i))
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
NEI4 $1064
line 3128
;3128:			continue;
ADDRGP4 $1055
JUMPV
LABELV $1064
line 3130
;3129:		//if the flag carrier is not visible
;3130:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
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
line 3131
;3131:		if (vis <= 0)
ADDRLP4 144
INDIRF4
CNSTF4 0
GTF4 $1066
line 3132
;3132:			continue;
ADDRGP4 $1055
JUMPV
LABELV $1066
line 3134
;3133:		//
;3134:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1053
JUMPV
LABELV $1055
line 3115
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1057
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1068
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1054
LABELV $1068
line 3136
;3135:	}
;3136:	return -1;
CNSTI4 -1
RETI4
LABELV $1053
endproc BotTeamFlagCarrierVisible 164 20
export BotTeamFlagCarrier
proc BotTeamFlagCarrier 152 8
line 3144
;3137:}
;3138:
;3139:/*
;3140:==================
;3141:BotTeamFlagCarrier
;3142:==================
;3143:*/
;3144:int BotTeamFlagCarrier(bot_state_t *bs) {
line 3148
;3145:	int i;
;3146:	aas_entityinfo_t entinfo;
;3147:
;3148:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1073
JUMPV
LABELV $1070
line 3149
;3149:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1074
line 3150
;3150:			continue;
ADDRGP4 $1071
JUMPV
LABELV $1074
line 3152
;3151:		//
;3152:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3154
;3153:		//if this player is active
;3154:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1076
line 3155
;3155:			continue;
ADDRGP4 $1071
JUMPV
LABELV $1076
line 3157
;3156:		//if this player is carrying a flag
;3157:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 144
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
NEI4 $1078
line 3158
;3158:			continue;
ADDRGP4 $1071
JUMPV
LABELV $1078
line 3160
;3159:		//if the flag carrier is not on the same team
;3160:		if (!BotSameTeam(bs, i))
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
NEI4 $1080
line 3161
;3161:			continue;
ADDRGP4 $1071
JUMPV
LABELV $1080
line 3163
;3162:		//
;3163:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1069
JUMPV
LABELV $1071
line 3148
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1073
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1082
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1070
LABELV $1082
line 3165
;3164:	}
;3165:	return -1;
CNSTI4 -1
RETI4
LABELV $1069
endproc BotTeamFlagCarrier 152 8
export BotEnemyFlagCarrierVisible
proc BotEnemyFlagCarrierVisible 164 20
line 3173
;3166:}
;3167:
;3168:/*
;3169:==================
;3170:BotEnemyFlagCarrierVisible
;3171:==================
;3172:*/
;3173:int BotEnemyFlagCarrierVisible(bot_state_t *bs) {
line 3178
;3174:	int i;
;3175:	float vis;
;3176:	aas_entityinfo_t entinfo;
;3177:
;3178:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1087
JUMPV
LABELV $1084
line 3179
;3179:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1088
line 3180
;3180:			continue;
ADDRGP4 $1085
JUMPV
LABELV $1088
line 3182
;3181:		//
;3182:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3184
;3183:		//if this player is active
;3184:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1090
line 3185
;3185:			continue;
ADDRGP4 $1085
JUMPV
LABELV $1090
line 3187
;3186:		//if this player is carrying a flag
;3187:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 148
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $1092
line 3188
;3188:			continue;
ADDRGP4 $1085
JUMPV
LABELV $1092
line 3190
;3189:		//if the flag carrier is on the same team
;3190:		if (BotSameTeam(bs, i))
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
EQI4 $1094
line 3191
;3191:			continue;
ADDRGP4 $1085
JUMPV
LABELV $1094
line 3193
;3192:		//if the flag carrier is not visible
;3193:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
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
line 3194
;3194:		if (vis <= 0)
ADDRLP4 144
INDIRF4
CNSTF4 0
GTF4 $1096
line 3195
;3195:			continue;
ADDRGP4 $1085
JUMPV
LABELV $1096
line 3197
;3196:		//
;3197:		return i;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1083
JUMPV
LABELV $1085
line 3178
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1087
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1098
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1084
LABELV $1098
line 3199
;3198:	}
;3199:	return -1;
CNSTI4 -1
RETI4
LABELV $1083
endproc BotEnemyFlagCarrierVisible 164 20
export BotVisibleTeamMatesAndEnemies
proc BotVisibleTeamMatesAndEnemies 192 20
line 3207
;3200:}
;3201:
;3202:/*
;3203:==================
;3204:BotVisibleTeamMatesAndEnemies
;3205:==================
;3206:*/
;3207:void BotVisibleTeamMatesAndEnemies(bot_state_t *bs, int *teammates, int *enemies, float range) {
line 3213
;3208:	int i;
;3209:	float vis;
;3210:	aas_entityinfo_t entinfo;
;3211:	vec3_t dir;
;3212:
;3213:	if (teammates)
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1100
line 3214
;3214:		*teammates = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
LABELV $1100
line 3215
;3215:	if (enemies)
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1102
line 3216
;3216:		*enemies = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
LABELV $1102
line 3217
;3217:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1107
JUMPV
LABELV $1104
line 3218
;3218:		if (i == bs->client)
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1108
line 3219
;3219:			continue;
ADDRGP4 $1105
JUMPV
LABELV $1108
line 3221
;3220:		//
;3221:		BotEntityInfo(i, &entinfo);
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3223
;3222:		//if this player is active
;3223:		if (!entinfo.valid)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $1110
line 3224
;3224:			continue;
ADDRGP4 $1105
JUMPV
LABELV $1110
line 3226
;3225:		//if this player is carrying a flag
;3226:		if (!EntityCarriesFlag(&entinfo))
ADDRLP4 4
ARGP4
ADDRLP4 160
ADDRGP4 EntityCarriesFlag
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $1112
line 3227
;3227:			continue;
ADDRGP4 $1105
JUMPV
LABELV $1112
line 3229
;3228:		//if not within range
;3229:		VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3230
;3230:		if (VectorLengthSquared(dir) > Square(range))
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
LEF4 $1121
line 3231
;3231:			continue;
ADDRGP4 $1105
JUMPV
LABELV $1121
line 3233
;3232:		//if the flag carrier is not visible
;3233:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
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
line 3234
;3234:		if (vis <= 0)
ADDRLP4 156
INDIRF4
CNSTF4 0
GTF4 $1123
line 3235
;3235:			continue;
ADDRGP4 $1105
JUMPV
LABELV $1123
line 3237
;3236:		//if the flag carrier is on the same team
;3237:		if (BotSameTeam(bs, i)) {
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
EQI4 $1125
line 3238
;3238:			if (teammates)
ADDRFP4 4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1126
line 3239
;3239:				(*teammates)++;
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
line 3240
;3240:		}
ADDRGP4 $1126
JUMPV
LABELV $1125
line 3241
;3241:		else {
line 3242
;3242:			if (enemies)
ADDRFP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1129
line 3243
;3243:				(*enemies)++;
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
LABELV $1129
line 3244
;3244:		}
LABELV $1126
line 3245
;3245:	}
LABELV $1105
line 3217
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1107
ADDRLP4 0
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1131
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $1104
LABELV $1131
line 3246
;3246:}
LABELV $1099
endproc BotVisibleTeamMatesAndEnemies 192 20
lit
align 4
LABELV $1133
byte 4 3229614080
byte 4 3229614080
byte 4 3229614080
align 4
LABELV $1134
byte 4 1082130432
byte 4 1082130432
byte 4 1082130432
export BotAimAtEnemy
code
proc BotAimAtEnemy 1144 52
line 3317
;3247:
;3248:#ifdef MISSIONPACK
;3249:/*
;3250:==================
;3251:BotTeamCubeCarrierVisible
;3252:==================
;3253:*/
;3254:int BotTeamCubeCarrierVisible(bot_state_t *bs) {
;3255:	int i;
;3256:	float vis;
;3257:	aas_entityinfo_t entinfo;
;3258:
;3259:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
;3260:		if (i == bs->client) continue;
;3261:		//
;3262:		BotEntityInfo(i, &entinfo);
;3263:		//if this player is active
;3264:		if (!entinfo.valid) continue;
;3265:		//if this player is carrying a flag
;3266:		if (!EntityCarriesCubes(&entinfo)) continue;
;3267:		//if the flag carrier is not on the same team
;3268:		if (!BotSameTeam(bs, i)) continue;
;3269:		//if the flag carrier is not visible
;3270:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
;3271:		if (vis <= 0) continue;
;3272:		//
;3273:		return i;
;3274:	}
;3275:	return -1;
;3276:}
;3277:
;3278:/*
;3279:==================
;3280:BotEnemyCubeCarrierVisible
;3281:==================
;3282:*/
;3283:int BotEnemyCubeCarrierVisible(bot_state_t *bs) {
;3284:	int i;
;3285:	float vis;
;3286:	aas_entityinfo_t entinfo;
;3287:
;3288:	for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
;3289:		if (i == bs->client)
;3290:			continue;
;3291:		//
;3292:		BotEntityInfo(i, &entinfo);
;3293:		//if this player is active
;3294:		if (!entinfo.valid)
;3295:			continue;
;3296:		//if this player is carrying a flag
;3297:		if (!EntityCarriesCubes(&entinfo)) continue;
;3298:		//if the flag carrier is on the same team
;3299:		if (BotSameTeam(bs, i))
;3300:			continue;
;3301:		//if the flag carrier is not visible
;3302:		vis = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, i);
;3303:		if (vis <= 0)
;3304:			continue;
;3305:		//
;3306:		return i;
;3307:	}
;3308:	return -1;
;3309:}
;3310:#endif
;3311:
;3312:/*
;3313:==================
;3314:BotAimAtEnemy
;3315:==================
;3316:*/
;3317:void BotAimAtEnemy(bot_state_t *bs) {
line 3321
;3318:	int i, enemyvisible;
;3319:	float dist, f, aim_skill, aim_accuracy, speed, reactiontime;
;3320:	vec3_t dir, bestorigin, end, start, groundtarget, cmdmove, enemyvelocity;
;3321:	vec3_t mins = {-4,-4,-4}, maxs = {4, 4, 4};
ADDRLP4 860
ADDRGP4 $1133
INDIRB
ASGNB 12
ADDRLP4 872
ADDRGP4 $1134
INDIRB
ASGNB 12
line 3329
;3322:	weaponinfo_t wi;
;3323:	aas_entityinfo_t entinfo;
;3324:	bot_goal_t goal;
;3325:	bsp_trace_t trace;
;3326:	vec3_t target;
;3327:
;3328:	//if the bot has no enemy
;3329:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $1135
line 3330
;3330:		return;
ADDRGP4 $1132
JUMPV
LABELV $1135
line 3333
;3331:	}
;3332:	//get the enemy entity information
;3333:	BotEntityInfo(bs->enemy, &entinfo);
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
line 3335
;3334:	//if this is not a player (should be an obelisk)
;3335:	if (bs->enemy >= MAX_CLIENTS) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 64
LTI4 $1137
line 3337
;3336:		//if the obelisk is visible
;3337:		VectorCopy(entinfo.origin, target);
ADDRLP4 828
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3346
;3338:#ifdef MISSIONPACK
;3339:		// if attacking an obelisk
;3340:		if ( bs->enemy == redobelisk.entitynum ||
;3341:			bs->enemy == blueobelisk.entitynum ) {
;3342:			target[2] += 32;
;3343:		}
;3344:#endif
;3345:		//aim at the obelisk
;3346:		VectorSubtract(target, bs->eye, dir);
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
line 3347
;3347:		vectoangles(dir, bs->ideal_viewangles);
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
line 3349
;3348:		//set the aim target before trying to attack
;3349:		VectorCopy(target, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 828
INDIRB
ASGNB 12
line 3350
;3350:		return;
ADDRGP4 $1132
JUMPV
LABELV $1137
line 3355
;3351:	}
;3352:	//
;3353:	//BotAI_Print(PRT_MESSAGE, "client %d: aiming at client %d\n", bs->entitynum, bs->enemy);
;3354:	//
;3355:	aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL, 0, 1);
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
line 3356
;3356:	aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY, 0, 1);
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
line 3358
;3357:	//
;3358:	if (aim_skill > 0.95) {
ADDRLP4 736
INDIRF4
CNSTF4 1064514355
LEF4 $1144
line 3360
;3359:		//don't aim too early
;3360:		reactiontime = 0.5 * trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_REACTIONTIME, 0, 1);
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
line 3361
;3361:		if (bs->enemysight_time > FloatTime() - reactiontime) return;
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
LEF4 $1146
ADDRGP4 $1132
JUMPV
LABELV $1146
line 3362
;3362:		if (bs->teleport_time > FloatTime() - reactiontime) return;
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
LEF4 $1148
ADDRGP4 $1132
JUMPV
LABELV $1148
line 3363
;3363:	}
LABELV $1144
line 3366
;3364:
;3365:	//get the weapon information
;3366:	trap_BotGetWeaponInfo(bs->ws, bs->weaponnum, &wi);
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
line 3368
;3367:	//get the weapon specific aim accuracy and or aim skill
;3368:	if (wi.number == WP_MACHINEGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 2
NEI4 $1150
line 3369
;3369:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_MACHINEGUN, 0, 1);
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
line 3370
;3370:	}
ADDRGP4 $1151
JUMPV
LABELV $1150
line 3371
;3371:	else if (wi.number == WP_SHOTGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 3
NEI4 $1153
line 3372
;3372:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_SHOTGUN, 0, 1);
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
line 3373
;3373:	}
ADDRGP4 $1154
JUMPV
LABELV $1153
line 3374
;3374:	else if (wi.number == WP_GRENADE_LAUNCHER) {
ADDRLP4 160+4
INDIRI4
CNSTI4 4
NEI4 $1156
line 3375
;3375:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_GRENADELAUNCHER, 0, 1);
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
line 3376
;3376:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_GRENADELAUNCHER, 0, 1);
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
line 3377
;3377:	}
ADDRGP4 $1157
JUMPV
LABELV $1156
line 3378
;3378:	else if (wi.number == WP_ROCKET_LAUNCHER) {
ADDRLP4 160+4
INDIRI4
CNSTI4 5
NEI4 $1159
line 3379
;3379:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_ROCKETLAUNCHER, 0, 1);
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
line 3380
;3380:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_ROCKETLAUNCHER, 0, 1);
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
line 3381
;3381:	}
ADDRGP4 $1160
JUMPV
LABELV $1159
line 3382
;3382:	else if (wi.number == WP_LIGHTNING) {
ADDRLP4 160+4
INDIRI4
CNSTI4 6
NEI4 $1162
line 3383
;3383:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_LIGHTNING, 0, 1);
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
line 3384
;3384:	}
ADDRGP4 $1163
JUMPV
LABELV $1162
line 3385
;3385:	else if (wi.number == WP_RAILGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 7
NEI4 $1165
line 3386
;3386:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_RAILGUN, 0, 1);
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
line 3387
;3387:	}
ADDRGP4 $1166
JUMPV
LABELV $1165
line 3388
;3388:	else if (wi.number == WP_PLASMAGUN) {
ADDRLP4 160+4
INDIRI4
CNSTI4 8
NEI4 $1168
line 3389
;3389:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_PLASMAGUN, 0, 1);
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
line 3390
;3390:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_PLASMAGUN, 0, 1);
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
line 3391
;3391:	}
ADDRGP4 $1169
JUMPV
LABELV $1168
line 3392
;3392:	else if (wi.number == WP_BFG) {
ADDRLP4 160+4
INDIRI4
CNSTI4 9
NEI4 $1171
line 3393
;3393:		aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY_BFG10K, 0, 1);
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
line 3394
;3394:		aim_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_SKILL_BFG10K, 0, 1);
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
line 3395
;3395:	}
LABELV $1171
LABELV $1169
LABELV $1166
LABELV $1163
LABELV $1160
LABELV $1157
LABELV $1154
LABELV $1151
line 3397
;3396:	//
;3397:	if (aim_accuracy <= 0) aim_accuracy = 0.0001f;
ADDRLP4 156
INDIRF4
CNSTF4 0
GTF4 $1174
ADDRLP4 156
CNSTF4 953267991
ASGNF4
LABELV $1174
line 3399
;3398:	//get the enemy entity information
;3399:	BotEntityInfo(bs->enemy, &entinfo);
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
line 3401
;3400:	//if the enemy is invisible then shoot crappy most of the time
;3401:	if (EntityIsInvisible(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 996
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 996
INDIRI4
CNSTI4 0
EQI4 $1176
line 3402
;3402:		if (random() > 0.1) aim_accuracy *= 0.4f;
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
LEF4 $1178
ADDRLP4 156
CNSTF4 1053609165
ADDRLP4 156
INDIRF4
MULF4
ASGNF4
LABELV $1178
line 3403
;3403:	}
LABELV $1176
line 3405
;3404:	//
;3405:	VectorSubtract(entinfo.origin, entinfo.lastvisorigin, enemyvelocity);
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
line 3406
;3406:	VectorScale(enemyvelocity, 1 / entinfo.update_time, enemyvelocity);
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
line 3408
;3407:	//enemy origin and velocity is remembered every 0.5 seconds
;3408:	if (bs->enemyposition_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6140
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1199
line 3410
;3409:		//
;3410:		bs->enemyposition_time = FloatTime() + 0.5;
ADDRFP4 0
INDIRP4
CNSTI4 6140
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1056964608
ADDF4
ASGNF4
line 3411
;3411:		VectorCopy(enemyvelocity, bs->enemyvelocity);
ADDRFP4 0
INDIRP4
CNSTI4 6232
ADDP4
ADDRLP4 712
INDIRB
ASGNB 12
line 3412
;3412:		VectorCopy(entinfo.origin, bs->enemyorigin);
ADDRFP4 0
INDIRP4
CNSTI4 6244
ADDP4
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3413
;3413:	}
LABELV $1199
line 3415
;3414:	//if not extremely skilled
;3415:	if (aim_skill < 0.9) {
ADDRLP4 736
INDIRF4
CNSTF4 1063675494
GEF4 $1202
line 3416
;3416:		VectorSubtract(entinfo.origin, bs->enemyorigin, dir);
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
line 3418
;3417:		//if the enemy moved a bit
;3418:		if (VectorLengthSquared(dir) > Square(48)) {
ADDRLP4 140
ARGP4
ADDRLP4 1008
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1008
INDIRF4
CNSTF4 1158676480
LEF4 $1211
line 3420
;3419:			//if the enemy changed direction
;3420:			if (DotProduct(bs->enemyvelocity, enemyvelocity) < 0) {
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
GEF4 $1213
line 3422
;3421:				//aim accuracy should be worse now
;3422:				aim_accuracy *= 0.7f;
ADDRLP4 156
CNSTF4 1060320051
ADDRLP4 156
INDIRF4
MULF4
ASGNF4
line 3423
;3423:			}
LABELV $1213
line 3424
;3424:		}
LABELV $1211
line 3425
;3425:	}
LABELV $1202
line 3427
;3426:	//check visibility of enemy
;3427:	enemyvisible = BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy);
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
line 3429
;3428:	//if the enemy is visible
;3429:	if (enemyvisible) {
ADDRLP4 824
INDIRI4
CNSTI4 0
EQI4 $1217
line 3431
;3430:		//
;3431:		VectorCopy(entinfo.origin, bestorigin);
ADDRLP4 724
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3432
;3432:		bestorigin[2] += 8;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 3435
;3433:		//get the start point shooting from
;3434:		//NOTE: the x and y projectile start offsets are ignored
;3435:		VectorCopy(bs->origin, start);
ADDRLP4 844
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 3436
;3436:		start[2] += bs->cur_ps.viewheight;
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
line 3437
;3437:		start[2] += wi.offset[2];
ADDRLP4 844+8
ADDRLP4 844+8
INDIRF4
ADDRLP4 160+292+8
INDIRF4
ADDF4
ASGNF4
line 3439
;3438:		//
;3439:		BotAI_Trace(&trace, start, mins, maxs, bestorigin, bs->entitynum, MASK_SHOT);
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
line 3441
;3440:		//if the enemy is NOT hit
;3441:		if (trace.fraction <= 1 && trace.ent != entinfo.number) {
ADDRLP4 740+8
INDIRF4
CNSTF4 1065353216
GTF4 $1225
ADDRLP4 740+80
INDIRI4
ADDRLP4 0+20
INDIRI4
EQI4 $1225
line 3442
;3442:			bestorigin[2] += 16;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1098907648
ADDF4
ASGNF4
line 3443
;3443:		}
LABELV $1225
line 3445
;3444:		//if it is not an instant hit weapon the bot might want to predict the enemy
;3445:		if (wi.speed) {
ADDRLP4 160+272
INDIRF4
CNSTF4 0
EQF4 $1231
line 3447
;3446:			//
;3447:			VectorSubtract(bestorigin, bs->origin, dir);
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
line 3448
;3448:			dist = VectorLength(dir);
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
line 3449
;3449:			VectorSubtract(entinfo.origin, bs->enemyorigin, dir);
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
line 3451
;3450:			//if the enemy is NOT pretty far away and strafing just small steps left and right
;3451:			if (!(dist > 100 && VectorLengthSquared(dir) < Square(32))) {
ADDRLP4 840
INDIRF4
CNSTF4 1120403456
LEF4 $1247
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1149239296
LTF4 $1245
LABELV $1247
line 3453
;3452:				//if skilled anough do exact prediction
;3453:				if (aim_skill > 0.8 &&
ADDRLP4 736
INDIRF4
CNSTF4 1061997773
LEF4 $1248
ADDRFP4 0
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1248
line 3455
;3454:						//if the weapon is ready to fire
;3455:						bs->cur_ps.weaponstate == WEAPON_READY) {
line 3459
;3456:					aas_clientmove_t move;
;3457:					vec3_t origin;
;3458:
;3459:					VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3461
;3460:					//distance towards the enemy
;3461:					dist = VectorLength(dir);
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
line 3463
;3462:					//direction the enemy is moving in
;3463:					VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
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
line 3465
;3464:					//
;3465:					VectorScale(dir, 1 / entinfo.update_time, dir);
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
line 3467
;3466:					//
;3467:					VectorCopy(entinfo.origin, origin);
ADDRLP4 1028
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3468
;3468:					origin[2] += 1;
ADDRLP4 1028+8
ADDRLP4 1028+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 3470
;3469:					//
;3470:					VectorClear(cmdmove);
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
line 3472
;3471:					//AAS_ClearShownDebugLines();
;3472:					trap_AAS_PredictClientMovement(&move, bs->enemy, origin,
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
line 3476
;3473:														PRESENCE_CROUCH, qfalse,
;3474:														dir, cmdmove, 0,
;3475:														dist * 10 / wi.speed, 0.1f, 0, 0, qfalse);
;3476:					VectorCopy(move.endpos, bestorigin);
ADDRLP4 724
ADDRLP4 1040
INDIRB
ASGNB 12
line 3478
;3477:					//BotAI_Print(PRT_MESSAGE, "%1.1f predicted speed = %f, frames = %f\n", FloatTime(), VectorLength(dir), dist * 10 / wi.speed);
;3478:				}
ADDRGP4 $1249
JUMPV
LABELV $1248
line 3480
;3479:				//if not that skilled do linear prediction
;3480:				else if (aim_skill > 0.4) {
ADDRLP4 736
INDIRF4
CNSTF4 1053609165
LEF4 $1281
line 3481
;3481:					VectorSubtract(entinfo.origin, bs->origin, dir);
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
line 3483
;3482:					//distance towards the enemy
;3483:					dist = VectorLength(dir);
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
line 3485
;3484:					//direction the enemy is moving in
;3485:					VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
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
line 3486
;3486:					dir[2] = 0;
ADDRLP4 140+8
CNSTF4 0
ASGNF4
line 3488
;3487:					//
;3488:					speed = VectorNormalize(dir) / entinfo.update_time;
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
line 3491
;3489:					//botimport.Print(PRT_MESSAGE, "speed = %f, wi->speed = %f\n", speed, wi->speed);
;3490:					//best spot to aim at
;3491:					VectorMA(entinfo.origin, (dist / wi.speed) * speed, dir, bestorigin);
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
line 3492
;3492:				}
LABELV $1281
LABELV $1249
line 3493
;3493:			}
LABELV $1245
line 3494
;3494:		}
LABELV $1231
line 3496
;3495:		//if the projectile does radial damage
;3496:		if (aim_skill > 0.6 && wi.proj.damagetype & DAMAGETYPE_RADIAL) {
ADDRLP4 736
INDIRF4
CNSTF4 1058642330
LEF4 $1316
ADDRLP4 160+344+180
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1316
line 3498
;3497:			//if the enemy isn't standing significantly higher than the bot
;3498:			if (entinfo.origin[2] < bs->origin[2] + 16) {
ADDRLP4 0+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
CNSTF4 1098907648
ADDF4
GEF4 $1320
line 3500
;3499:				//try to aim at the ground in front of the enemy
;3500:				VectorCopy(entinfo.origin, end);
ADDRLP4 956
ADDRLP4 0+24
INDIRB
ASGNB 12
line 3501
;3501:				end[2] -= 64;
ADDRLP4 956+8
ADDRLP4 956+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 3502
;3502:				BotAI_Trace(&trace, entinfo.origin, NULL, NULL, end, entinfo.number, MASK_SHOT);
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
line 3504
;3503:				//
;3504:				VectorCopy(bestorigin, groundtarget);
ADDRLP4 944
ADDRLP4 724
INDIRB
ASGNB 12
line 3505
;3505:				if (trace.startsolid) groundtarget[2] = entinfo.origin[2] - 16;
ADDRLP4 740+4
INDIRI4
CNSTI4 0
EQI4 $1328
ADDRLP4 944+8
ADDRLP4 0+24+8
INDIRF4
CNSTF4 1098907648
SUBF4
ASGNF4
ADDRGP4 $1329
JUMPV
LABELV $1328
line 3506
;3506:				else groundtarget[2] = trace.endpos[2] - 8;
ADDRLP4 944+8
ADDRLP4 740+12+8
INDIRF4
CNSTF4 1090519040
SUBF4
ASGNF4
LABELV $1329
line 3508
;3507:				//trace a line from projectile start to ground target
;3508:				BotAI_Trace(&trace, start, NULL, NULL, groundtarget, bs->entitynum, MASK_SHOT);
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
line 3510
;3509:				//if hitpoint is not vertically too far from the ground target
;3510:				if (fabs(trace.endpos[2] - groundtarget[2]) < 50) {
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
GEF4 $1337
line 3511
;3511:					VectorSubtract(trace.endpos, groundtarget, dir);
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
line 3513
;3512:					//if the hitpoint is near anough the ground target
;3513:					if (VectorLengthSquared(dir) < Square(60)) {
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1163984896
GEF4 $1351
line 3514
;3514:						VectorSubtract(trace.endpos, start, dir);
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
line 3516
;3515:						//if the hitpoint is far anough from the bot
;3516:						if (VectorLengthSquared(dir) > Square(100)) {
ADDRLP4 140
ARGP4
ADDRLP4 1028
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1028
INDIRF4
CNSTF4 1176256512
LEF4 $1362
line 3518
;3517:							//check if the bot is visible from the ground target
;3518:							trace.endpos[2] += 1;
ADDRLP4 740+12+8
ADDRLP4 740+12+8
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 3519
;3519:							BotAI_Trace(&trace, trace.endpos, NULL, NULL, entinfo.origin, entinfo.number, MASK_SHOT);
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
line 3520
;3520:							if (trace.fraction >= 1) {
ADDRLP4 740+8
INDIRF4
CNSTF4 1065353216
LTF4 $1369
line 3522
;3521:								//botimport.Print(PRT_MESSAGE, "%1.1f aiming at ground\n", AAS_Time());
;3522:								VectorCopy(groundtarget, bestorigin);
ADDRLP4 724
ADDRLP4 944
INDIRB
ASGNB 12
line 3523
;3523:							}
LABELV $1369
line 3524
;3524:						}
LABELV $1362
line 3525
;3525:					}
LABELV $1351
line 3526
;3526:				}
LABELV $1337
line 3527
;3527:			}
LABELV $1320
line 3528
;3528:		}
LABELV $1316
line 3529
;3529:		bestorigin[0] += 20 * crandom() * (1 - aim_accuracy);
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
line 3530
;3530:		bestorigin[1] += 20 * crandom() * (1 - aim_accuracy);
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
line 3531
;3531:		bestorigin[2] += 10 * crandom() * (1 - aim_accuracy);
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
line 3532
;3532:	}
ADDRGP4 $1218
JUMPV
LABELV $1217
line 3533
;3533:	else {
line 3535
;3534:		//
;3535:		VectorCopy(bs->lastenemyorigin, bestorigin);
ADDRLP4 724
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 3536
;3536:		bestorigin[2] += 8;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 3538
;3537:		//if the bot is skilled anough
;3538:		if (aim_skill > 0.5) {
ADDRLP4 736
INDIRF4
CNSTF4 1056964608
LEF4 $1375
line 3540
;3539:			//do prediction shots around corners
;3540:			if (wi.number == WP_BFG ||
ADDRLP4 160+4
INDIRI4
CNSTI4 9
EQI4 $1383
ADDRLP4 160+4
INDIRI4
CNSTI4 5
EQI4 $1383
ADDRLP4 160+4
INDIRI4
CNSTI4 4
NEI4 $1377
LABELV $1383
line 3542
;3541:				wi.number == WP_ROCKET_LAUNCHER ||
;3542:				wi.number == WP_GRENADE_LAUNCHER) {
line 3544
;3543:				//create the chase goal
;3544:				goal.entitynum = bs->client;
ADDRLP4 884+40
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
line 3545
;3545:				goal.areanum = bs->areanum;
ADDRLP4 884+12
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ASGNI4
line 3546
;3546:				VectorCopy(bs->eye, goal.origin);
ADDRLP4 884
ADDRFP4 0
INDIRP4
CNSTI4 4936
ADDP4
INDIRB
ASGNB 12
line 3547
;3547:				VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 884+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 884+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 884+16+8
CNSTF4 3238002688
ASGNF4
line 3548
;3548:				VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 884+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 884+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 884+28+8
CNSTF4 1090519040
ASGNF4
line 3550
;3549:				//
;3550:				if (trap_BotPredictVisiblePosition(bs->lastenemyorigin, bs->lastenemyareanum, &goal, TFL_DEFAULT, target)) {
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
EQI4 $1396
line 3551
;3551:					VectorSubtract(target, bs->eye, dir);
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
line 3552
;3552:					if (VectorLengthSquared(dir) > Square(80)) {
ADDRLP4 140
ARGP4
ADDRLP4 1024
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 1024
INDIRF4
CNSTF4 1170735104
LEF4 $1402
line 3553
;3553:						VectorCopy(target, bestorigin);
ADDRLP4 724
ADDRLP4 828
INDIRB
ASGNB 12
line 3554
;3554:						bestorigin[2] -= 20;
ADDRLP4 724+8
ADDRLP4 724+8
INDIRF4
CNSTF4 1101004800
SUBF4
ASGNF4
line 3555
;3555:					}
LABELV $1402
line 3556
;3556:				}
LABELV $1396
line 3557
;3557:				aim_accuracy = 1;
ADDRLP4 156
CNSTF4 1065353216
ASGNF4
line 3558
;3558:			}
LABELV $1377
line 3559
;3559:		}
LABELV $1375
line 3560
;3560:	}
LABELV $1218
line 3562
;3561:	//
;3562:	if (enemyvisible) {
ADDRLP4 824
INDIRI4
CNSTI4 0
EQI4 $1405
line 3563
;3563:		BotAI_Trace(&trace, bs->eye, NULL, NULL, bestorigin, bs->entitynum, MASK_SHOT);
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
line 3564
;3564:		VectorCopy(trace.endpos, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 740+12
INDIRB
ASGNB 12
line 3565
;3565:	}
ADDRGP4 $1406
JUMPV
LABELV $1405
line 3566
;3566:	else {
line 3567
;3567:		VectorCopy(bestorigin, bs->aimtarget);
ADDRFP4 0
INDIRP4
CNSTI4 6220
ADDP4
ADDRLP4 724
INDIRB
ASGNB 12
line 3568
;3568:	}
LABELV $1406
line 3570
;3569:	//get aim direction
;3570:	VectorSubtract(bestorigin, bs->eye, dir);
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
line 3572
;3571:	//
;3572:	if (wi.number == WP_MACHINEGUN ||
ADDRLP4 160+4
INDIRI4
CNSTI4 2
EQI4 $1420
ADDRLP4 160+4
INDIRI4
CNSTI4 3
EQI4 $1420
ADDRLP4 160+4
INDIRI4
CNSTI4 6
EQI4 $1420
ADDRLP4 160+4
INDIRI4
CNSTI4 7
NEI4 $1412
LABELV $1420
line 3575
;3573:		wi.number == WP_SHOTGUN ||
;3574:		wi.number == WP_LIGHTNING ||
;3575:		wi.number == WP_RAILGUN) {
line 3577
;3576:		//distance towards the enemy
;3577:		dist = VectorLength(dir);
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
line 3578
;3578:		if (dist > 150) dist = 150;
ADDRLP4 840
INDIRF4
CNSTF4 1125515264
LEF4 $1421
ADDRLP4 840
CNSTF4 1125515264
ASGNF4
LABELV $1421
line 3579
;3579:		f = 0.6 + dist / 150 * 0.4;
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
line 3580
;3580:		aim_accuracy *= f;
ADDRLP4 156
ADDRLP4 156
INDIRF4
ADDRLP4 940
INDIRF4
MULF4
ASGNF4
line 3581
;3581:	}
LABELV $1412
line 3583
;3582:	//add some random stuff to the aim direction depending on the aim accuracy
;3583:	if (aim_accuracy < 0.8) {
ADDRLP4 156
INDIRF4
CNSTF4 1061997773
GEF4 $1423
line 3584
;3584:		VectorNormalize(dir);
ADDRLP4 140
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 3585
;3585:		for (i = 0; i < 3; i++) dir[i] += 0.3 * crandom() * (1 - aim_accuracy);
ADDRLP4 152
CNSTI4 0
ASGNI4
LABELV $1425
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
LABELV $1426
ADDRLP4 152
ADDRLP4 152
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 3
LTI4 $1425
line 3586
;3586:	}
LABELV $1423
line 3588
;3587:	//set the ideal view angles
;3588:	vectoangles(dir, bs->ideal_viewangles);
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
line 3590
;3589:	//take the weapon spread into account for lower skilled bots
;3590:	bs->ideal_viewangles[PITCH] += 6 * wi.vspread * crandom() * (1 - aim_accuracy);
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
line 3591
;3591:	bs->ideal_viewangles[PITCH] = AngleMod(bs->ideal_viewangles[PITCH]);
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
line 3592
;3592:	bs->ideal_viewangles[YAW] += 6 * wi.hspread * crandom() * (1 - aim_accuracy);
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
line 3593
;3593:	bs->ideal_viewangles[YAW] = AngleMod(bs->ideal_viewangles[YAW]);
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
line 3595
;3594:	//if the bots should be really challenging
;3595:	if (bot_challenge.integer) {
ADDRGP4 bot_challenge+12
INDIRI4
CNSTI4 0
EQI4 $1431
line 3597
;3596:		//if the bot is really accurate and has the enemy in view for some time
;3597:		if (aim_accuracy > 0.9 && bs->enemysight_time < FloatTime() - 1) {
ADDRLP4 156
INDIRF4
CNSTF4 1063675494
LEF4 $1434
ADDRFP4 0
INDIRP4
CNSTI4 6132
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $1434
line 3599
;3598:			//set the view angles directly
;3599:			if (bs->ideal_viewangles[PITCH] > 180) bs->ideal_viewangles[PITCH] -= 360;
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
INDIRF4
CNSTF4 1127481344
LEF4 $1436
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
LABELV $1436
line 3600
;3600:			VectorCopy(bs->ideal_viewangles, bs->viewangles);
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
line 3601
;3601:			trap_EA_View(bs->client, bs->viewangles);
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
line 3602
;3602:		}
LABELV $1434
line 3603
;3603:	}
LABELV $1431
line 3604
;3604:}
LABELV $1132
endproc BotAimAtEnemy 1144 52
lit
align 4
LABELV $1439
byte 4 3238002688
byte 4 3238002688
byte 4 3238002688
align 4
LABELV $1440
byte 4 1090519040
byte 4 1090519040
byte 4 1090519040
export BotCheckAttack
code
proc BotCheckAttack 1028 28
line 3611
;3605:
;3606:/*
;3607:==================
;3608:BotCheckAttack
;3609:==================
;3610:*/
;3611:void BotCheckAttack(bot_state_t *bs) {
line 3620
;3612:	float points, reactiontime, fov, firethrottle;
;3613:	int attackentity;
;3614:	bsp_trace_t bsptrace;
;3615:	//float selfpreservation;
;3616:	vec3_t forward, right, start, end, dir, angles;
;3617:	weaponinfo_t wi;
;3618:	bsp_trace_t trace;
;3619:	aas_entityinfo_t entinfo;
;3620:	vec3_t mins = {-8, -8, -8}, maxs = {8, 8, 8};
ADDRLP4 808
ADDRGP4 $1439
INDIRB
ASGNB 12
ADDRLP4 820
ADDRGP4 $1440
INDIRB
ASGNB 12
line 3622
;3621:
;3622:	attackentity = bs->enemy;
ADDRLP4 576
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 3624
;3623:	//
;3624:	BotEntityInfo(attackentity, &entinfo);
ADDRLP4 576
INDIRI4
ARGI4
ADDRLP4 832
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3626
;3625:	// if not attacking a player
;3626:	if (attackentity >= MAX_CLIENTS) {
ADDRLP4 576
INDIRI4
CNSTI4 64
LTI4 $1441
line 3638
;3627:#ifdef MISSIONPACK
;3628:		// if attacking an obelisk
;3629:		if ( entinfo.number == redobelisk.entitynum ||
;3630:			entinfo.number == blueobelisk.entitynum ) {
;3631:			// if obelisk is respawning return
;3632:			if ( g_entities[entinfo.number].activator &&
;3633:				g_entities[entinfo.number].activator->s.frame == 2 ) {
;3634:				return;
;3635:			}
;3636:		}
;3637:#endif
;3638:	}
LABELV $1441
line 3640
;3639:	//
;3640:	reactiontime = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_REACTIONTIME, 0, 1);
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
line 3641
;3641:	if (bs->enemysight_time > FloatTime() - reactiontime) return;
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
LEF4 $1443
ADDRGP4 $1438
JUMPV
LABELV $1443
line 3642
;3642:	if (bs->teleport_time > FloatTime() - reactiontime) return;
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
LEF4 $1445
ADDRGP4 $1438
JUMPV
LABELV $1445
line 3644
;3643:	//if changing weapons
;3644:	if (bs->weaponchange_time > FloatTime() - 0.1) return;
ADDRFP4 0
INDIRP4
CNSTI4 6192
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1036831949
SUBF4
LEF4 $1447
ADDRGP4 $1438
JUMPV
LABELV $1447
line 3646
;3645:	//check fire throttle characteristic
;3646:	if (bs->firethrottlewait_time > FloatTime()) return;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $1449
ADDRGP4 $1438
JUMPV
LABELV $1449
line 3647
;3647:	firethrottle = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_FIRETHROTTLE, 0, 1);
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
line 3648
;3648:	if (bs->firethrottleshoot_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1451
line 3649
;3649:		if (random() > firethrottle) {
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
LEF4 $1453
line 3650
;3650:			bs->firethrottlewait_time = FloatTime() + firethrottle;
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
line 3651
;3651:			bs->firethrottleshoot_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6200
ADDP4
CNSTF4 0
ASGNF4
line 3652
;3652:		}
ADDRGP4 $1454
JUMPV
LABELV $1453
line 3653
;3653:		else {
line 3654
;3654:			bs->firethrottleshoot_time = FloatTime() + 1 - firethrottle;
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
line 3655
;3655:			bs->firethrottlewait_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6196
ADDP4
CNSTF4 0
ASGNF4
line 3656
;3656:		}
LABELV $1454
line 3657
;3657:	}
LABELV $1451
line 3660
;3658:	//
;3659:	//
;3660:	VectorSubtract(bs->aimtarget, bs->eye, dir);
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
line 3662
;3661:	//
;3662:	if (bs->weaponnum == WP_GAUNTLET) {
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
INDIRI4
CNSTI4 1
NEI4 $1457
line 3663
;3663:		if (VectorLengthSquared(dir) > Square(60)) {
ADDRLP4 580
ARGP4
ADDRLP4 992
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 992
INDIRF4
CNSTF4 1163984896
LEF4 $1459
line 3664
;3664:			return;
ADDRGP4 $1438
JUMPV
LABELV $1459
line 3666
;3665:		}
;3666:	}
LABELV $1457
line 3667
;3667:	if (VectorLengthSquared(dir) < Square(100))
ADDRLP4 580
ARGP4
ADDRLP4 992
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 992
INDIRF4
CNSTF4 1176256512
GEF4 $1461
line 3668
;3668:		fov = 120;
ADDRLP4 788
CNSTF4 1123024896
ASGNF4
ADDRGP4 $1462
JUMPV
LABELV $1461
line 3670
;3669:	else
;3670:		fov = 50;
ADDRLP4 788
CNSTF4 1112014848
ASGNF4
LABELV $1462
line 3672
;3671:	//
;3672:	vectoangles(dir, angles);
ADDRLP4 580
ARGP4
ADDRLP4 796
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 3673
;3673:	if (!InFieldOfVision(bs->viewangles, fov, angles))
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
NEI4 $1463
line 3674
;3674:		return;
ADDRGP4 $1438
JUMPV
LABELV $1463
line 3675
;3675:	BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, bs->aimtarget, bs->client, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
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
line 3676
;3676:	if (bsptrace.fraction < 1 && bsptrace.ent != attackentity)
ADDRLP4 704+8
INDIRF4
CNSTF4 1065353216
GEF4 $1465
ADDRLP4 704+80
INDIRI4
ADDRLP4 576
INDIRI4
EQI4 $1465
line 3677
;3677:		return;
ADDRGP4 $1438
JUMPV
LABELV $1465
line 3680
;3678:
;3679:	//get the weapon info
;3680:	trap_BotGetWeaponInfo(bs->ws, bs->weaponnum, &wi);
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
line 3682
;3681:	//get the start point shooting from
;3682:	VectorCopy(bs->origin, start);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 3683
;3683:	start[2] += bs->cur_ps.viewheight;
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
line 3684
;3684:	AngleVectors(bs->viewangles, forward, right, NULL);
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
line 3685
;3685:	start[0] += forward[0] * wi.offset[0] + right[0] * wi.offset[1];
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
line 3686
;3686:	start[1] += forward[1] * wi.offset[0] + right[1] * wi.offset[1];
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
line 3687
;3687:	start[2] += forward[2] * wi.offset[0] + right[2] * wi.offset[1] + wi.offset[2];
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
line 3689
;3688:	//end point aiming at
;3689:	VectorMA(start, 1000, forward, end);
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
line 3691
;3690:	//a little back to make sure not inside a very close enemy
;3691:	VectorMA(start, -12, forward, start);
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
line 3692
;3692:	BotAI_Trace(&trace, start, mins, maxs, end, bs->entitynum, MASK_SHOT);
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
line 3694
;3693:	//if the entity is a client
;3694:	if (trace.ent > 0 && trace.ent <= MAX_CLIENTS) {
ADDRLP4 592+80
INDIRI4
CNSTI4 0
LEI4 $1499
ADDRLP4 592+80
INDIRI4
CNSTI4 64
GTI4 $1499
line 3695
;3695:		if (trace.ent != attackentity) {
ADDRLP4 592+80
INDIRI4
ADDRLP4 576
INDIRI4
EQI4 $1503
line 3697
;3696:			//if a teammate is hit
;3697:			if (BotSameTeam(bs, trace.ent))
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
EQI4 $1506
line 3698
;3698:				return;
ADDRGP4 $1438
JUMPV
LABELV $1506
line 3699
;3699:		}
LABELV $1503
line 3700
;3700:	}
LABELV $1499
line 3702
;3701:	//if won't hit the enemy or not attacking a player (obelisk)
;3702:	if (trace.ent != attackentity || attackentity >= MAX_CLIENTS) {
ADDRLP4 592+80
INDIRI4
ADDRLP4 576
INDIRI4
NEI4 $1512
ADDRLP4 576
INDIRI4
CNSTI4 64
LTI4 $1509
LABELV $1512
line 3704
;3703:		//if the projectile does radial damage
;3704:		if (wi.proj.damagetype & DAMAGETYPE_RADIAL) {
ADDRLP4 24+344+180
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1513
line 3705
;3705:			if (trace.fraction * 1000 < wi.proj.radius) {
CNSTF4 1148846080
ADDRLP4 592+8
INDIRF4
MULF4
ADDRLP4 24+344+172
INDIRF4
GEF4 $1517
line 3706
;3706:				points = (wi.proj.damage - 0.5 * trace.fraction * 1000) * 0.5;
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
line 3707
;3707:				if (points > 0) {
ADDRLP4 972
INDIRF4
CNSTF4 0
LEF4 $1525
line 3708
;3708:					return;
ADDRGP4 $1438
JUMPV
LABELV $1525
line 3710
;3709:				}
;3710:			}
LABELV $1517
line 3712
;3711:			//FIXME: check if a teammate gets radial damage
;3712:		}
LABELV $1513
line 3713
;3713:	}
LABELV $1509
line 3715
;3714:	//if fire has to be release to activate weapon
;3715:	if (wi.flags & WFL_FIRERELEASED) {
ADDRLP4 24+176
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $1527
line 3716
;3716:		if (bs->flags & BFL_ATTACKED) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $1528
line 3717
;3717:			trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3718
;3718:		}
line 3719
;3719:	}
ADDRGP4 $1528
JUMPV
LABELV $1527
line 3720
;3720:	else {
line 3721
;3721:		trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3722
;3722:	}
LABELV $1528
line 3723
;3723:	bs->flags ^= BFL_ATTACKED;
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
line 3724
;3724:}
LABELV $1438
endproc BotCheckAttack 1028 28
lit
align 4
LABELV $1538
byte 4 1143930880
byte 4 1129054208
byte 4 1143472128
align 4
LABELV $1539
byte 4 1148256256
byte 4 1139408896
byte 4 1143603200
align 4
LABELV $1540
byte 4 1134034944
byte 4 1135607808
byte 4 1147535360
export BotMapScripts
code
proc BotMapScripts 1424 16
line 3731
;3725:
;3726:/*
;3727:==================
;3728:BotMapScripts
;3729:==================
;3730:*/
;3731:void BotMapScripts(bot_state_t *bs) {
line 3739
;3732:	char info[1024];
;3733:	char mapname[128];
;3734:	int i, shootbutton;
;3735:	float aim_accuracy;
;3736:	aas_entityinfo_t entinfo;
;3737:	vec3_t dir;
;3738:
;3739:	trap_GetServerinfo(info, sizeof(info));
ADDRLP4 272
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_GetServerinfo
CALLV
pop
line 3741
;3740:
;3741:	strncpy(mapname, Info_ValueForKey( info, "mapname" ), sizeof(mapname)-1);
ADDRLP4 272
ARGP4
ADDRGP4 $1533
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
line 3742
;3742:	mapname[sizeof(mapname)-1] = '\0';
ADDRLP4 144+127
CNSTI1 0
ASGNI1
line 3744
;3743:
;3744:	if (!Q_stricmp(mapname, "q3tourney6")) {
ADDRLP4 144
ARGP4
ADDRGP4 $1537
ARGP4
ADDRLP4 1320
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1320
INDIRI4
CNSTI4 0
NEI4 $1535
line 3745
;3745:		vec3_t mins = {700, 204, 672}, maxs = {964, 468, 680};
ADDRLP4 1324
ADDRGP4 $1538
INDIRB
ASGNB 12
ADDRLP4 1336
ADDRGP4 $1539
INDIRB
ASGNB 12
line 3746
;3746:		vec3_t buttonorg = {304, 352, 920};
ADDRLP4 1348
ADDRGP4 $1540
INDIRB
ASGNB 12
line 3748
;3747:		//NOTE: NEVER use the func_bobbing in q3tourney6
;3748:		bs->tfl &= ~TFL_FUNCBOB;
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
line 3750
;3749:		//if the bot is below the bounding box
;3750:		if (bs->origin[0] > mins[0] && bs->origin[0] < maxs[0]) {
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
LEF4 $1541
ADDRLP4 1364
INDIRF4
ADDRLP4 1336
INDIRF4
GEF4 $1541
line 3751
;3751:			if (bs->origin[1] > mins[1] && bs->origin[1] < maxs[1]) {
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
LEF4 $1543
ADDRLP4 1368
INDIRF4
ADDRLP4 1336+4
INDIRF4
GEF4 $1543
line 3752
;3752:				if (bs->origin[2] < mins[2]) {
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 1324+8
INDIRF4
GEF4 $1547
line 3753
;3753:					return;
ADDRGP4 $1532
JUMPV
LABELV $1547
line 3755
;3754:				}
;3755:			}
LABELV $1543
line 3756
;3756:		}
LABELV $1541
line 3757
;3757:		shootbutton = qfalse;
ADDRLP4 1296
CNSTI4 0
ASGNI4
line 3759
;3758:		//if an enemy is below this bounding box then shoot the button
;3759:		for (i = 0; i < maxclients && i < MAX_CLIENTS; i++) {
ADDRLP4 140
CNSTI4 0
ASGNI4
ADDRGP4 $1553
JUMPV
LABELV $1550
line 3761
;3760:
;3761:			if (i == bs->client) continue;
ADDRLP4 140
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $1554
ADDRGP4 $1551
JUMPV
LABELV $1554
line 3763
;3762:			//
;3763:			BotEntityInfo(i, &entinfo);
ADDRLP4 140
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 3765
;3764:			//
;3765:			if (!entinfo.valid) continue;
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1556
ADDRGP4 $1551
JUMPV
LABELV $1556
line 3767
;3766:			//if the enemy isn't dead and the enemy isn't the bot self
;3767:			if (EntityIsDead(&entinfo) || entinfo.number == bs->entitynum) continue;
ADDRLP4 0
ARGP4
ADDRLP4 1368
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 1368
INDIRI4
CNSTI4 0
NEI4 $1561
ADDRLP4 0+20
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $1558
LABELV $1561
ADDRGP4 $1551
JUMPV
LABELV $1558
line 3769
;3768:			//
;3769:			if (entinfo.origin[0] > mins[0] && entinfo.origin[0] < maxs[0]) {
ADDRLP4 0+24
INDIRF4
ADDRLP4 1324
INDIRF4
LEF4 $1562
ADDRLP4 0+24
INDIRF4
ADDRLP4 1336
INDIRF4
GEF4 $1562
line 3770
;3770:				if (entinfo.origin[1] > mins[1] && entinfo.origin[1] < maxs[1]) {
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1324+4
INDIRF4
LEF4 $1566
ADDRLP4 0+24+4
INDIRF4
ADDRLP4 1336+4
INDIRF4
GEF4 $1566
line 3771
;3771:					if (entinfo.origin[2] < mins[2]) {
ADDRLP4 0+24+8
INDIRF4
ADDRLP4 1324+8
INDIRF4
GEF4 $1574
line 3773
;3772:						//if there's a team mate below the crusher
;3773:						if (BotSameTeam(bs, i)) {
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
EQI4 $1579
line 3774
;3774:							shootbutton = qfalse;
ADDRLP4 1296
CNSTI4 0
ASGNI4
line 3775
;3775:							break;
ADDRGP4 $1552
JUMPV
LABELV $1579
line 3777
;3776:						}
;3777:						else {
line 3778
;3778:							shootbutton = qtrue;
ADDRLP4 1296
CNSTI4 1
ASGNI4
line 3779
;3779:						}
line 3780
;3780:					}
LABELV $1574
line 3781
;3781:				}
LABELV $1566
line 3782
;3782:			}
LABELV $1562
line 3783
;3783:		}
LABELV $1551
line 3759
ADDRLP4 140
ADDRLP4 140
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1553
ADDRLP4 140
INDIRI4
ADDRGP4 maxclients
INDIRI4
GEI4 $1581
ADDRLP4 140
INDIRI4
CNSTI4 64
LTI4 $1550
LABELV $1581
LABELV $1552
line 3784
;3784:		if (shootbutton) {
ADDRLP4 1296
INDIRI4
CNSTI4 0
EQI4 $1536
line 3785
;3785:			bs->flags |= BFL_IDEALVIEWSET;
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
line 3786
;3786:			VectorSubtract(buttonorg, bs->eye, dir);
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
line 3787
;3787:			vectoangles(dir, bs->ideal_viewangles);
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
line 3788
;3788:			aim_accuracy = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_AIM_ACCURACY, 0, 1);
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
line 3789
;3789:			bs->ideal_viewangles[PITCH] += 8 * crandom() * (1 - aim_accuracy);
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
line 3790
;3790:			bs->ideal_viewangles[PITCH] = AngleMod(bs->ideal_viewangles[PITCH]);
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
line 3791
;3791:			bs->ideal_viewangles[YAW] += 8 * crandom() * (1 - aim_accuracy);
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
line 3792
;3792:			bs->ideal_viewangles[YAW] = AngleMod(bs->ideal_viewangles[YAW]);
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
line 3794
;3793:			//
;3794:			if (InFieldOfVision(bs->viewangles, 20, bs->ideal_viewangles)) {
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
EQI4 $1536
line 3795
;3795:				trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 3796
;3796:			}
line 3797
;3797:		}
line 3798
;3798:	}
ADDRGP4 $1536
JUMPV
LABELV $1535
line 3799
;3799:	else if (!Q_stricmp(mapname, "mpq3tourney6")) {
ADDRLP4 144
ARGP4
ADDRGP4 $1592
ARGP4
ADDRLP4 1324
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1324
INDIRI4
CNSTI4 0
NEI4 $1590
line 3801
;3800:		//NOTE: NEVER use the func_bobbing in mpq3tourney6
;3801:		bs->tfl &= ~TFL_FUNCBOB;
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
line 3802
;3802:	}
LABELV $1590
LABELV $1536
line 3803
;3803:}
LABELV $1532
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
line 3816
;3804:
;3805:/*
;3806:==================
;3807:BotSetMovedir
;3808:==================
;3809:*/
;3810:// bk001205 - made these static
;3811:static vec3_t VEC_UP		= {0, -1,  0};
;3812:static vec3_t MOVEDIR_UP	= {0,  0,  1};
;3813:static vec3_t VEC_DOWN		= {0, -2,  0};
;3814:static vec3_t MOVEDIR_DOWN	= {0,  0, -1};
;3815:
;3816:void BotSetMovedir(vec3_t angles, vec3_t movedir) {
line 3817
;3817:	if (VectorCompare(angles, VEC_UP)) {
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
EQI4 $1594
line 3818
;3818:		VectorCopy(MOVEDIR_UP, movedir);
ADDRFP4 4
INDIRP4
ADDRGP4 MOVEDIR_UP
INDIRB
ASGNB 12
line 3819
;3819:	}
ADDRGP4 $1595
JUMPV
LABELV $1594
line 3820
;3820:	else if (VectorCompare(angles, VEC_DOWN)) {
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
EQI4 $1596
line 3821
;3821:		VectorCopy(MOVEDIR_DOWN, movedir);
ADDRFP4 4
INDIRP4
ADDRGP4 MOVEDIR_DOWN
INDIRB
ASGNB 12
line 3822
;3822:	}
ADDRGP4 $1597
JUMPV
LABELV $1596
line 3823
;3823:	else {
line 3824
;3824:		AngleVectors(angles, movedir, NULL, NULL);
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
line 3825
;3825:	}
LABELV $1597
LABELV $1595
line 3826
;3826:}
LABELV $1593
endproc BotSetMovedir 12 16
export BotModelMinsMaxs
proc BotModelMinsMaxs 40 0
line 3835
;3827:
;3828:/*
;3829:==================
;3830:BotModelMinsMaxs
;3831:
;3832:this is ugly
;3833:==================
;3834:*/
;3835:int BotModelMinsMaxs(int modelindex, int eType, int contents, vec3_t mins, vec3_t maxs) {
line 3839
;3836:	gentity_t *ent;
;3837:	int i;
;3838:
;3839:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 3840
;3840:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $1602
JUMPV
LABELV $1599
line 3841
;3841:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1604
line 3842
;3842:			continue;
ADDRGP4 $1600
JUMPV
LABELV $1604
line 3844
;3843:		}
;3844:		if ( eType && ent->s.eType != eType) {
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $1606
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
EQI4 $1606
line 3845
;3845:			continue;
ADDRGP4 $1600
JUMPV
LABELV $1606
line 3847
;3846:		}
;3847:		if ( contents && ent->r.contents != contents) {
ADDRLP4 12
ADDRFP4 8
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $1608
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
EQI4 $1608
line 3848
;3848:			continue;
ADDRGP4 $1600
JUMPV
LABELV $1608
line 3850
;3849:		}
;3850:		if (ent->s.modelindex == modelindex) {
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRFP4 0
INDIRI4
NEI4 $1610
line 3851
;3851:			if (mins)
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1612
line 3852
;3852:				VectorAdd(ent->r.currentOrigin, ent->r.mins, mins);
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
LABELV $1612
line 3853
;3853:			if (maxs)
ADDRFP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1614
line 3854
;3854:				VectorAdd(ent->r.currentOrigin, ent->r.maxs, maxs);
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
LABELV $1614
line 3855
;3855:			return i;
ADDRLP4 4
INDIRI4
RETI4
ADDRGP4 $1598
JUMPV
LABELV $1610
line 3857
;3856:		}
;3857:	}
LABELV $1600
line 3840
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
LABELV $1602
ADDRLP4 4
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $1599
line 3858
;3858:	if (mins)
ADDRFP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1616
line 3859
;3859:		VectorClear(mins);
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
LABELV $1616
line 3860
;3860:	if (maxs)
ADDRFP4 16
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $1618
line 3861
;3861:		VectorClear(maxs);
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
LABELV $1618
line 3862
;3862:	return 0;
CNSTI4 0
RETI4
LABELV $1598
endproc BotModelMinsMaxs 40 0
lit
align 4
LABELV $1621
byte 4 1065353216
byte 4 1065353216
byte 4 1065353216
align 4
LABELV $1622
byte 4 3212836864
byte 4 3212836864
byte 4 3212836864
export BotFuncButtonActivateGoal
code
proc BotFuncButtonActivateGoal 648 28
line 3870
;3863:}
;3864:
;3865:/*
;3866:==================
;3867:BotFuncButtonGoal
;3868:==================
;3869:*/
;3870:int BotFuncButtonActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 3876
;3871:	int i, areas[10], numareas, modelindex, entitynum;
;3872:	char model[128];
;3873:	float lip, dist, health, angle;
;3874:	vec3_t size, start, end, mins, maxs, angles, points[10];
;3875:	vec3_t movedir, origin, goalorigin, bboxmins, bboxmaxs;
;3876:	vec3_t extramins = {1, 1, 1}, extramaxs = {-1, -1, -1};
ADDRLP4 304
ADDRGP4 $1621
INDIRB
ASGNB 12
ADDRLP4 316
ADDRGP4 $1622
INDIRB
ASGNB 12
line 3879
;3877:	bsp_trace_t bsptrace;
;3878:
;3879:	activategoal->shoot = qfalse;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 0
ASGNI4
line 3880
;3880:	VectorClear(activategoal->target);
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
line 3882
;3881:	//create a bot goal towards the button
;3882:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $277
ARGP4
ADDRLP4 160
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 3883
;3883:	if (!*model)
ADDRLP4 160
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1623
line 3884
;3884:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1620
JUMPV
LABELV $1623
line 3885
;3885:	modelindex = atoi(model+1);
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
line 3886
;3886:	if (!modelindex)
ADDRLP4 288
INDIRI4
CNSTI4 0
NEI4 $1626
line 3887
;3887:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1620
JUMPV
LABELV $1626
line 3888
;3888:	VectorClear(angles);
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
line 3889
;3889:	entitynum = BotModelMinsMaxs(modelindex, ET_MOVER, 0, mins, maxs);
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
line 3891
;3890:	//get the lip of the button
;3891:	trap_AAS_FloatForBSPEpairKey(bspent, "lip", &lip);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1630
ARGP4
ADDRLP4 328
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 3892
;3892:	if (!lip) lip = 4;
ADDRLP4 328
INDIRF4
CNSTF4 0
NEF4 $1631
ADDRLP4 328
CNSTF4 1082130432
ASGNF4
LABELV $1631
line 3894
;3893:	//get the move direction from the angle
;3894:	trap_AAS_FloatForBSPEpairKey(bspent, "angle", &angle);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1633
ARGP4
ADDRLP4 352
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 3895
;3895:	VectorSet(angles, 0, angle, 0);
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
line 3896
;3896:	BotSetMovedir(angles, movedir);
ADDRLP4 96
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 BotSetMovedir
CALLV
pop
line 3898
;3897:	//button size
;3898:	VectorSubtract(maxs, mins, size);
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
line 3900
;3899:	//button origin
;3900:	VectorAdd(mins, maxs, origin);
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
line 3901
;3901:	VectorScale(origin, 0.5, origin);
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
line 3903
;3902:	//touch distance of the button
;3903:	dist = fabs(movedir[0]) * size[0] + fabs(movedir[1]) * size[1] + fabs(movedir[2]) * size[2];
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
line 3904
;3904:	dist *= 0.5;
ADDRLP4 28
CNSTF4 1056964608
ADDRLP4 28
INDIRF4
MULF4
ASGNF4
line 3906
;3905:	//
;3906:	trap_AAS_FloatForBSPEpairKey(bspent, "health", &health);
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $1656
ARGP4
ADDRLP4 348
ARGP4
ADDRGP4 trap_AAS_FloatForBSPEpairKey
CALLI4
pop
line 3908
;3907:	//if the button is shootable
;3908:	if (health) {
ADDRLP4 348
INDIRF4
CNSTF4 0
EQF4 $1657
line 3910
;3909:		//calculate the shoot target
;3910:		VectorMA(origin, -dist, movedir, goalorigin);
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
line 3912
;3911:		//
;3912:		VectorCopy(goalorigin, activategoal->target);
ADDRFP4 8
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 124
INDIRB
ASGNB 12
line 3913
;3913:		activategoal->shoot = qtrue;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 1
ASGNI4
line 3915
;3914:		//
;3915:		BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, goalorigin, bs->entitynum, MASK_SHOT);
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
line 3917
;3916:		// if the button is visible from the current position
;3917:		if (bsptrace.fraction >= 1.0 || bsptrace.ent == entitynum) {
ADDRLP4 356+8
INDIRF4
CNSTF4 1065353216
GEF4 $1669
ADDRLP4 356+80
INDIRI4
ADDRLP4 344
INDIRI4
NEI4 $1665
LABELV $1669
line 3919
;3918:			//
;3919:			activategoal->goal.entitynum = entitynum; //NOTE: this is the entity number of the shootable button
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 3920
;3920:			activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 3921
;3921:			activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 3922
;3922:			VectorCopy(bs->origin, activategoal->goal.origin);
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
line 3923
;3923:			activategoal->goal.areanum = bs->areanum;
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
line 3924
;3924:			VectorSet(activategoal->goal.mins, -8, -8, -8);
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
line 3925
;3925:			VectorSet(activategoal->goal.maxs, 8, 8, 8);
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
line 3927
;3926:			//
;3927:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1620
JUMPV
LABELV $1665
line 3929
;3928:		}
;3929:		else {
line 3932
;3930:			//create a goal from where the button is visible and shoot at the button from there
;3931:			//add bounding box size to the dist
;3932:			trap_AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bboxmins, bboxmaxs);
CNSTI4 4
ARGI4
ADDRLP4 136
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 trap_AAS_PresenceTypeBoundingBox
CALLV
pop
line 3933
;3933:			for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1670
line 3934
;3934:				if (movedir[i] < 0) dist += fabs(movedir[i]) * fabs(bboxmaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1674
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
ADDRGP4 $1675
JUMPV
LABELV $1674
line 3935
;3935:				else dist += fabs(movedir[i]) * fabs(bboxmins[i]);
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
LABELV $1675
line 3936
;3936:			}
LABELV $1671
line 3933
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1670
line 3938
;3937:			//calculate the goal origin
;3938:			VectorMA(origin, -dist, movedir, goalorigin);
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
line 3940
;3939:			//
;3940:			VectorCopy(goalorigin, start);
ADDRLP4 292
ADDRLP4 124
INDIRB
ASGNB 12
line 3941
;3941:			start[2] += 24;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 3942
;3942:			VectorCopy(start, end);
ADDRLP4 332
ADDRLP4 292
INDIRB
ASGNB 12
line 3943
;3943:			end[2] -= 512;
ADDRLP4 332+8
ADDRLP4 332+8
INDIRF4
CNSTF4 1140850688
SUBF4
ASGNF4
line 3944
;3944:			numareas = trap_AAS_TraceAreas(start, end, areas, points, 10);
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
line 3946
;3945:			//
;3946:			for (i = numareas-1; i >= 0; i--) {
ADDRLP4 0
ADDRLP4 108
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRGP4 $1687
JUMPV
LABELV $1684
line 3947
;3947:				if (trap_AAS_AreaReachability(areas[i])) {
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
EQI4 $1688
line 3948
;3948:					break;
ADDRGP4 $1686
JUMPV
LABELV $1688
line 3950
;3949:				}
;3950:			}
LABELV $1685
line 3946
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $1687
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1684
LABELV $1686
line 3951
;3951:			if (i < 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $1690
line 3953
;3952:				// FIXME: trace forward and maybe in other directions to find a valid area
;3953:			}
LABELV $1690
line 3954
;3954:			if (i >= 0) {
ADDRLP4 0
INDIRI4
CNSTI4 0
LTI4 $1692
line 3956
;3955:				//
;3956:				VectorCopy(points[i], activategoal->goal.origin);
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
line 3957
;3957:				activategoal->goal.areanum = areas[i];
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
line 3958
;3958:				VectorSet(activategoal->goal.mins, 8, 8, 8);
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
line 3959
;3959:				VectorSet(activategoal->goal.maxs, -8, -8, -8);
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
line 3961
;3960:				//
;3961:				for (i = 0; i < 3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1694
line 3962
;3962:				{
line 3963
;3963:					if (movedir[i] < 0) activategoal->goal.maxs[i] += fabs(movedir[i]) * fabs(extramaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1698
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
ADDRGP4 $1699
JUMPV
LABELV $1698
line 3964
;3964:					else activategoal->goal.mins[i] += fabs(movedir[i]) * fabs(extramins[i]);
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
LABELV $1699
line 3965
;3965:				} //end for
LABELV $1695
line 3961
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1694
line 3967
;3966:				//
;3967:				activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 3968
;3968:				activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 3969
;3969:				activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 3970
;3970:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1620
JUMPV
LABELV $1692
line 3972
;3971:			}
;3972:		}
line 3973
;3973:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1620
JUMPV
LABELV $1657
line 3975
;3974:	}
;3975:	else {
line 3977
;3976:		//add bounding box size to the dist
;3977:		trap_AAS_PresenceTypeBoundingBox(PRESENCE_CROUCH, bboxmins, bboxmaxs);
CNSTI4 4
ARGI4
ADDRLP4 136
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 trap_AAS_PresenceTypeBoundingBox
CALLV
pop
line 3978
;3978:		for (i = 0; i < 3; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1700
line 3979
;3979:			if (movedir[i] < 0) dist += fabs(movedir[i]) * fabs(bboxmaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1704
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
ADDRGP4 $1705
JUMPV
LABELV $1704
line 3980
;3980:			else dist += fabs(movedir[i]) * fabs(bboxmins[i]);
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
LABELV $1705
line 3981
;3981:		}
LABELV $1701
line 3978
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1700
line 3983
;3982:		//calculate the goal origin
;3983:		VectorMA(origin, -dist, movedir, goalorigin);
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
line 3985
;3984:		//
;3985:		VectorCopy(goalorigin, start);
ADDRLP4 292
ADDRLP4 124
INDIRB
ASGNB 12
line 3986
;3986:		start[2] += 24;
ADDRLP4 292+8
ADDRLP4 292+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 3987
;3987:		VectorCopy(start, end);
ADDRLP4 332
ADDRLP4 292
INDIRB
ASGNB 12
line 3988
;3988:		end[2] -= 100;
ADDRLP4 332+8
ADDRLP4 332+8
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
line 3989
;3989:		numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
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
line 3991
;3990:		//
;3991:		for (i = 0; i < numareas; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1717
JUMPV
LABELV $1714
line 3992
;3992:			if (trap_AAS_AreaReachability(areas[i])) {
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
EQI4 $1718
line 3993
;3993:				break;
ADDRGP4 $1716
JUMPV
LABELV $1718
line 3995
;3994:			}
;3995:		}
LABELV $1715
line 3991
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1717
ADDRLP4 0
INDIRI4
ADDRLP4 108
INDIRI4
LTI4 $1714
LABELV $1716
line 3996
;3996:		if (i < numareas) {
ADDRLP4 0
INDIRI4
ADDRLP4 108
INDIRI4
GEI4 $1720
line 3998
;3997:			//
;3998:			VectorCopy(origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 16
INDIRB
ASGNB 12
line 3999
;3999:			activategoal->goal.areanum = areas[i];
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
line 4000
;4000:			VectorSubtract(mins, origin, activategoal->goal.mins);
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
line 4001
;4001:			VectorSubtract(maxs, origin, activategoal->goal.maxs);
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
line 4003
;4002:			//
;4003:			for (i = 0; i < 3; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1730
line 4004
;4004:			{
line 4005
;4005:				if (movedir[i] < 0) activategoal->goal.maxs[i] += fabs(movedir[i]) * fabs(extramaxs[i]);
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRF4
CNSTF4 0
GEF4 $1734
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
ADDRGP4 $1735
JUMPV
LABELV $1734
line 4006
;4006:				else activategoal->goal.mins[i] += fabs(movedir[i]) * fabs(extramins[i]);
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
LABELV $1735
line 4007
;4007:			} //end for
LABELV $1731
line 4003
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $1730
line 4009
;4008:			//
;4009:			activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 344
INDIRI4
ASGNI4
line 4010
;4010:			activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4011
;4011:			activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4012
;4012:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1620
JUMPV
LABELV $1720
line 4014
;4013:		}
;4014:	}
line 4015
;4015:	return qfalse;
CNSTI4 0
RETI4
LABELV $1620
endproc BotFuncButtonActivateGoal 648 28
export BotFuncDoorActivateGoal
proc BotFuncDoorActivateGoal 1096 20
line 4023
;4016:}
;4017:
;4018:/*
;4019:==================
;4020:BotFuncDoorGoal
;4021:==================
;4022:*/
;4023:int BotFuncDoorActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4029
;4024:	int modelindex, entitynum;
;4025:	char model[MAX_INFO_STRING];
;4026:	vec3_t mins, maxs, origin, angles;
;4027:
;4028:	//shoot at the shootable door
;4029:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $277
ARGP4
ADDRLP4 12
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4030
;4030:	if (!*model)
ADDRLP4 12
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1737
line 4031
;4031:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1736
JUMPV
LABELV $1737
line 4032
;4032:	modelindex = atoi(model+1);
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
line 4033
;4033:	if (!modelindex)
ADDRLP4 1060
INDIRI4
CNSTI4 0
NEI4 $1740
line 4034
;4034:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1736
JUMPV
LABELV $1740
line 4035
;4035:	VectorClear(angles);
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
line 4036
;4036:	entitynum = BotModelMinsMaxs(modelindex, ET_MOVER, 0, mins, maxs);
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
line 4038
;4037:	//door origin
;4038:	VectorAdd(mins, maxs, origin);
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
line 4039
;4039:	VectorScale(origin, 0.5, origin);
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
line 4040
;4040:	VectorCopy(origin, activategoal->target);
ADDRFP4 8
INDIRP4
CNSTI4 80
ADDP4
ADDRLP4 0
INDIRB
ASGNB 12
line 4041
;4041:	activategoal->shoot = qtrue;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 1
ASGNI4
line 4043
;4042:	//
;4043:	activategoal->goal.entitynum = entitynum; //NOTE: this is the entity number of the shootable door
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 1076
INDIRI4
ASGNI4
line 4044
;4044:	activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4045
;4045:	activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4046
;4046:	VectorCopy(bs->origin, activategoal->goal.origin);
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
line 4047
;4047:	activategoal->goal.areanum = bs->areanum;
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
line 4048
;4048:	VectorSet(activategoal->goal.mins, -8, -8, -8);
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
line 4049
;4049:	VectorSet(activategoal->goal.maxs, 8, 8, 8);
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
line 4050
;4050:	return qtrue;
CNSTI4 1
RETI4
LABELV $1736
endproc BotFuncDoorActivateGoal 1096 20
export BotTriggerMultipleActivateGoal
proc BotTriggerMultipleActivateGoal 300 20
line 4058
;4051:}
;4052:
;4053:/*
;4054:==================
;4055:BotTriggerMultipleGoal
;4056:==================
;4057:*/
;4058:int BotTriggerMultipleActivateGoal(bot_state_t *bs, int bspent, bot_activategoal_t *activategoal) {
line 4064
;4059:	int i, areas[10], numareas, modelindex, entitynum;
;4060:	char model[128];
;4061:	vec3_t start, end, mins, maxs, angles;
;4062:	vec3_t origin, goalorigin;
;4063:
;4064:	activategoal->shoot = qfalse;
ADDRFP4 8
INDIRP4
CNSTI4 72
ADDP4
CNSTI4 0
ASGNI4
line 4065
;4065:	VectorClear(activategoal->target);
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
line 4067
;4066:	//create a bot goal towards the trigger
;4067:	trap_AAS_ValueForBSPEpairKey(bspent, "model", model, sizeof(model));
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 $277
ARGP4
ADDRLP4 84
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4068
;4068:	if (!*model)
ADDRLP4 84
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $1755
line 4069
;4069:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1754
JUMPV
LABELV $1755
line 4070
;4070:	modelindex = atoi(model+1);
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
line 4071
;4071:	if (!modelindex)
ADDRLP4 224
INDIRI4
CNSTI4 0
NEI4 $1758
line 4072
;4072:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1754
JUMPV
LABELV $1758
line 4073
;4073:	VectorClear(angles);
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
line 4074
;4074:	entitynum = BotModelMinsMaxs(modelindex, 0, CONTENTS_TRIGGER, mins, maxs);
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
line 4076
;4075:	//trigger origin
;4076:	VectorAdd(mins, maxs, origin);
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
line 4077
;4077:	VectorScale(origin, 0.5, origin);
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
line 4078
;4078:	VectorCopy(origin, goalorigin);
ADDRLP4 252
ADDRLP4 4
INDIRB
ASGNB 12
line 4080
;4079:	//
;4080:	VectorCopy(goalorigin, start);
ADDRLP4 212
ADDRLP4 252
INDIRB
ASGNB 12
line 4081
;4081:	start[2] += 24;
ADDRLP4 212+8
ADDRLP4 212+8
INDIRF4
CNSTF4 1103101952
ADDF4
ASGNF4
line 4082
;4082:	VectorCopy(start, end);
ADDRLP4 228
ADDRLP4 212
INDIRB
ASGNB 12
line 4083
;4083:	end[2] -= 100;
ADDRLP4 228+8
ADDRLP4 228+8
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
line 4084
;4084:	numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
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
line 4086
;4085:	//
;4086:	for (i = 0; i < numareas; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1777
JUMPV
LABELV $1774
line 4087
;4087:		if (trap_AAS_AreaReachability(areas[i])) {
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
EQI4 $1778
line 4088
;4088:			break;
ADDRGP4 $1776
JUMPV
LABELV $1778
line 4090
;4089:		}
;4090:	}
LABELV $1775
line 4086
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1777
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
LTI4 $1774
LABELV $1776
line 4091
;4091:	if (i < numareas) {
ADDRLP4 0
INDIRI4
ADDRLP4 16
INDIRI4
GEI4 $1780
line 4092
;4092:		VectorCopy(origin, activategoal->goal.origin);
ADDRFP4 8
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 4093
;4093:		activategoal->goal.areanum = areas[i];
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
line 4094
;4094:		VectorSubtract(mins, origin, activategoal->goal.mins);
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
line 4095
;4095:		VectorSubtract(maxs, origin, activategoal->goal.maxs);
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
line 4097
;4096:		//
;4097:		activategoal->goal.entitynum = entitynum;
ADDRFP4 8
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 264
INDIRI4
ASGNI4
line 4098
;4098:		activategoal->goal.number = 0;
ADDRFP4 8
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 4099
;4099:		activategoal->goal.flags = 0;
ADDRFP4 8
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 4100
;4100:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1754
JUMPV
LABELV $1780
line 4102
;4101:	}
;4102:	return qfalse;
CNSTI4 0
RETI4
LABELV $1754
endproc BotTriggerMultipleActivateGoal 300 20
export BotPopFromActivateGoalStack
proc BotPopFromActivateGoalStack 4 8
line 4110
;4103:}
;4104:
;4105:/*
;4106:==================
;4107:BotPopFromActivateGoalStack
;4108:==================
;4109:*/
;4110:int BotPopFromActivateGoalStack(bot_state_t *bs) {
line 4111
;4111:	if (!bs->activatestack)
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1791
line 4112
;4112:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1790
JUMPV
LABELV $1791
line 4113
;4113:	BotEnableActivateGoalAreas(bs->activatestack, qtrue);
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
line 4114
;4114:	bs->activatestack->inuse = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 0
ASGNI4
line 4115
;4115:	bs->activatestack->justused_time = FloatTime();
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
line 4116
;4116:	bs->activatestack = bs->activatestack->next;
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
line 4117
;4117:	return qtrue;
CNSTI4 1
RETI4
LABELV $1790
endproc BotPopFromActivateGoalStack 4 8
export BotPushOntoActivateGoalStack
proc BotPushOntoActivateGoalStack 24 12
line 4125
;4118:}
;4119:
;4120:/*
;4121:==================
;4122:BotPushOntoActivateGoalStack
;4123:==================
;4124:*/
;4125:int BotPushOntoActivateGoalStack(bot_state_t *bs, bot_activategoal_t *activategoal) {
line 4129
;4126:	int i, best;
;4127:	float besttime;
;4128:
;4129:	best = -1;
ADDRLP4 8
CNSTI4 -1
ASGNI4
line 4130
;4130:	besttime = FloatTime() + 9999;
ADDRLP4 4
ADDRGP4 floattime
INDIRF4
CNSTF4 1176255488
ADDF4
ASGNF4
line 4132
;4131:	//
;4132:	for (i = 0; i < MAX_ACTIVATESTACK; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $1794
line 4133
;4133:		if (!bs->activategoalheap[i].inuse) {
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
NEI4 $1798
line 4134
;4134:			if (bs->activategoalheap[i].justused_time < besttime) {
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
GEF4 $1800
line 4135
;4135:				besttime = bs->activategoalheap[i].justused_time;
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
line 4136
;4136:				best = i;
ADDRLP4 8
ADDRLP4 0
INDIRI4
ASGNI4
line 4137
;4137:			}
LABELV $1800
line 4138
;4138:		}
LABELV $1798
line 4139
;4139:	}
LABELV $1795
line 4132
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 8
LTI4 $1794
line 4140
;4140:	if (best != -1) {
ADDRLP4 8
INDIRI4
CNSTI4 -1
EQI4 $1802
line 4141
;4141:		memcpy(&bs->activategoalheap[best], activategoal, sizeof(bot_activategoal_t));
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
line 4142
;4142:		bs->activategoalheap[best].inuse = qtrue;
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
line 4143
;4143:		bs->activategoalheap[best].next = bs->activatestack;
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
line 4144
;4144:		bs->activatestack = &bs->activategoalheap[best];
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
line 4145
;4145:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1793
JUMPV
LABELV $1802
line 4147
;4146:	}
;4147:	return qfalse;
CNSTI4 0
RETI4
LABELV $1793
endproc BotPushOntoActivateGoalStack 24 12
export BotClearActivateGoalStack
proc BotClearActivateGoalStack 0 4
line 4155
;4148:}
;4149:
;4150:/*
;4151:==================
;4152:BotClearActivateGoalStack
;4153:==================
;4154:*/
;4155:void BotClearActivateGoalStack(bot_state_t *bs) {
ADDRGP4 $1806
JUMPV
LABELV $1805
line 4157
;4156:	while(bs->activatestack)
;4157:		BotPopFromActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotPopFromActivateGoalStack
CALLI4
pop
LABELV $1806
line 4156
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1805
line 4158
;4158:}
LABELV $1804
endproc BotClearActivateGoalStack 0 4
export BotEnableActivateGoalAreas
proc BotEnableActivateGoalAreas 12 8
line 4165
;4159:
;4160:/*
;4161:==================
;4162:BotEnableActivateGoalAreas
;4163:==================
;4164:*/
;4165:void BotEnableActivateGoalAreas(bot_activategoal_t *activategoal, int enable) {
line 4168
;4166:	int i;
;4167:
;4168:	if (activategoal->areasdisabled == !enable)
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1812
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $1813
JUMPV
LABELV $1812
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $1813
ADDRFP4 0
INDIRP4
CNSTI4 236
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $1809
line 4169
;4169:		return;
ADDRGP4 $1808
JUMPV
LABELV $1809
line 4170
;4170:	for (i = 0; i < activategoal->numareas; i++)
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $1817
JUMPV
LABELV $1814
line 4171
;4171:		trap_AAS_EnableRoutingArea( activategoal->areas[i], enable );
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
LABELV $1815
line 4170
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1817
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
LTI4 $1814
line 4172
;4172:	activategoal->areasdisabled = !enable;
ADDRFP4 4
INDIRI4
CNSTI4 0
NEI4 $1819
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $1820
JUMPV
LABELV $1819
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $1820
ADDRFP4 0
INDIRP4
CNSTI4 236
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 4173
;4173:}
LABELV $1808
endproc BotEnableActivateGoalAreas 12 8
export BotIsGoingToActivateEntity
proc BotIsGoingToActivateEntity 8 0
line 4180
;4174:
;4175:/*
;4176:==================
;4177:BotIsGoingToActivateEntity
;4178:==================
;4179:*/
;4180:int BotIsGoingToActivateEntity(bot_state_t *bs, int entitynum) {
line 4184
;4181:	bot_activategoal_t *a;
;4182:	int i;
;4183:
;4184:	for (a = bs->activatestack; a; a = a->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
ASGNP4
ADDRGP4 $1825
JUMPV
LABELV $1822
line 4185
;4185:		if (a->time < FloatTime())
ADDRLP4 0
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1826
line 4186
;4186:			continue;
ADDRGP4 $1823
JUMPV
LABELV $1826
line 4187
;4187:		if (a->goal.entitynum == entitynum)
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ADDRFP4 4
INDIRI4
NEI4 $1828
line 4188
;4188:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1821
JUMPV
LABELV $1828
line 4189
;4189:	}
LABELV $1823
line 4184
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 240
ADDP4
INDIRP4
ASGNP4
LABELV $1825
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $1822
line 4190
;4190:	for (i = 0; i < MAX_ACTIVATESTACK; i++) {
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $1830
line 4191
;4191:		if (bs->activategoalheap[i].inuse)
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
EQI4 $1834
line 4192
;4192:			continue;
ADDRGP4 $1831
JUMPV
LABELV $1834
line 4194
;4193:		//
;4194:		if (bs->activategoalheap[i].goal.entitynum == entitynum) {
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
NEI4 $1836
line 4196
;4195:			// if the bot went for this goal less than 2 seconds ago
;4196:			if (bs->activategoalheap[i].justused_time > FloatTime() - 2)
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
LEF4 $1838
line 4197
;4197:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1821
JUMPV
LABELV $1838
line 4198
;4198:		}
LABELV $1836
line 4199
;4199:	}
LABELV $1831
line 4190
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 8
LTI4 $1830
line 4200
;4200:	return qfalse;
CNSTI4 0
RETI4
LABELV $1821
endproc BotIsGoingToActivateEntity 8 0
export BotGetActivateGoal
proc BotGetActivateGoal 3320 20
line 4213
;4201:}
;4202:
;4203:/*
;4204:==================
;4205:BotGetActivateGoal
;4206:
;4207:  returns the number of the bsp entity to activate
;4208:  goal->entitynum will be set to the game entity to activate
;4209:==================
;4210:*/
;4211://#define OBSTACLEDEBUG
;4212:
;4213:int BotGetActivateGoal(bot_state_t *bs, int entitynum, bot_activategoal_t *activategoal) {
line 4223
;4214:	int i, ent, cur_entities[10], spawnflags, modelindex, areas[MAX_ACTIVATEAREAS*2], numareas, t;
;4215:	char model[MAX_INFO_STRING], tmpmodel[128];
;4216:	char target[128], classname[128];
;4217:	float health;
;4218:	char targetname[10][128];
;4219:	aas_entityinfo_t entinfo;
;4220:	aas_areainfo_t areainfo;
;4221:	vec3_t origin, angles, absmins, absmaxs;
;4222:
;4223:	memset(activategoal, 0, sizeof(bot_activategoal_t));
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
line 4224
;4224:	BotEntityInfo(entitynum, &entinfo);
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 3052
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 4225
;4225:	Com_sprintf(model, sizeof( model ), "*%d", entinfo.modelindex);
ADDRLP4 1712
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $1841
ARGP4
ADDRLP4 3052+104
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
line 4226
;4226:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
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
ADDRGP4 $1846
JUMPV
LABELV $1843
line 4227
;4227:		if (!trap_AAS_ValueForBSPEpairKey(ent, "model", tmpmodel, sizeof(tmpmodel))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $277
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
NEI4 $1847
ADDRGP4 $1844
JUMPV
LABELV $1847
line 4228
;4228:		if (!strcmp(model, tmpmodel)) break;
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
NEI4 $1849
ADDRGP4 $1845
JUMPV
LABELV $1849
line 4229
;4229:	}
LABELV $1844
line 4226
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
LABELV $1846
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1843
LABELV $1845
line 4230
;4230:	if (!ent) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1851
line 4231
;4231:		BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no entity found with model %s\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1853
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4232
;4232:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1851
line 4234
;4233:	}
;4234:	trap_AAS_ValueForBSPEpairKey(ent, "classname", classname, sizeof(classname));
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1854
ARGP4
ADDRLP4 1456
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4235
;4235:	if (!classname) {
ADDRLP4 1456
CVPU4 4
CNSTU4 0
NEU4 $1855
line 4236
;4236:		BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with model %s has no classname\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1857
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4237
;4237:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1855
line 4240
;4238:	}
;4239:	//if it is a door
;4240:	if (!strcmp(classname, "func_door")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1860
ARGP4
ADDRLP4 3260
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3260
INDIRI4
CNSTI4 0
NEI4 $1858
line 4241
;4241:		if (trap_AAS_FloatForBSPEpairKey(ent, "health", &health)) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1656
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
EQI4 $1861
line 4243
;4242:			//if the door has health then the door must be shot to open
;4243:			if (health) {
ADDRLP4 3208
INDIRF4
CNSTF4 0
EQF4 $1863
line 4244
;4244:				BotFuncDoorActivateGoal(bs, ent, activategoal);
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
line 4245
;4245:				return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1863
line 4247
;4246:			}
;4247:		}
LABELV $1861
line 4249
;4248:		//
;4249:		trap_AAS_IntForBSPEpairKey(ent, "spawnflags", &spawnflags);
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1865
ARGP4
ADDRLP4 3204
ARGP4
ADDRGP4 trap_AAS_IntForBSPEpairKey
CALLI4
pop
line 4251
;4250:		// if the door starts open then just wait for the door to return
;4251:		if ( spawnflags & 1 )
ADDRLP4 3204
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $1866
line 4252
;4252:			return 0;
CNSTI4 0
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1866
line 4254
;4253:		//get the door origin
;4254:		if (!trap_AAS_VectorForBSPEpairKey(ent, "origin", origin)) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1870
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
NEI4 $1868
line 4255
;4255:			VectorClear(origin);
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
line 4256
;4256:		}
LABELV $1868
line 4258
;4257:		//if the door is open or opening already
;4258:		if (!VectorCompare(origin, entinfo.origin))
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
NEI4 $1873
line 4259
;4259:			return 0;
CNSTI4 0
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1873
line 4261
;4260:		// store all the areas the door is in
;4261:		trap_AAS_ValueForBSPEpairKey(ent, "model", model, sizeof(model));
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $277
ARGP4
ADDRLP4 1712
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4262
;4262:		if (*model) {
ADDRLP4 1712
INDIRI1
CVII4 1
CNSTI4 0
EQI4 $1876
line 4263
;4263:			modelindex = atoi(model+1);
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
line 4264
;4264:			if (modelindex) {
ADDRLP4 3212
INDIRI4
CNSTI4 0
EQI4 $1879
line 4265
;4265:				VectorClear(angles);
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
line 4266
;4266:				BotModelMinsMaxs(modelindex, ET_MOVER, 0, absmins, absmaxs);
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
line 4268
;4267:				//
;4268:				numareas = trap_AAS_BBoxAreas(absmins, absmaxs, areas, MAX_ACTIVATEAREAS*2);
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
line 4270
;4269:				// store the areas with reachabilities first
;4270:				for (i = 0; i < numareas; i++) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1886
JUMPV
LABELV $1883
line 4271
;4271:					if (activategoal->numareas >= MAX_ACTIVATEAREAS)
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
CNSTI4 32
LTI4 $1887
line 4272
;4272:						break;
ADDRGP4 $1885
JUMPV
LABELV $1887
line 4273
;4273:					if ( !trap_AAS_AreaReachability(areas[i]) ) {
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
NEI4 $1889
line 4274
;4274:						continue;
ADDRGP4 $1884
JUMPV
LABELV $1889
line 4276
;4275:					}
;4276:					trap_AAS_AreaInfo(areas[i], &areainfo);
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
line 4277
;4277:					if (areainfo.contents & AREACONTENTS_MOVER) {
ADDRLP4 2996
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $1891
line 4278
;4278:						activategoal->areas[activategoal->numareas++] = areas[i];
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
line 4279
;4279:					}
LABELV $1891
line 4280
;4280:				}
LABELV $1884
line 4270
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1886
ADDRLP4 132
INDIRI4
ADDRLP4 3048
INDIRI4
LTI4 $1883
LABELV $1885
line 4282
;4281:				// store any remaining areas
;4282:				for (i = 0; i < numareas; i++) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1896
JUMPV
LABELV $1893
line 4283
;4283:					if (activategoal->numareas >= MAX_ACTIVATEAREAS)
ADDRFP4 8
INDIRP4
CNSTI4 232
ADDP4
INDIRI4
CNSTI4 32
LTI4 $1897
line 4284
;4284:						break;
ADDRGP4 $1895
JUMPV
LABELV $1897
line 4285
;4285:					if ( trap_AAS_AreaReachability(areas[i]) ) {
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
EQI4 $1899
line 4286
;4286:						continue;
ADDRGP4 $1894
JUMPV
LABELV $1899
line 4288
;4287:					}
;4288:					trap_AAS_AreaInfo(areas[i], &areainfo);
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
line 4289
;4289:					if (areainfo.contents & AREACONTENTS_MOVER) {
ADDRLP4 2996
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $1901
line 4290
;4290:						activategoal->areas[activategoal->numareas++] = areas[i];
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
line 4291
;4291:					}
LABELV $1901
line 4292
;4292:				}
LABELV $1894
line 4282
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $1896
ADDRLP4 132
INDIRI4
ADDRLP4 3048
INDIRI4
LTI4 $1893
LABELV $1895
line 4293
;4293:			}
LABELV $1879
line 4294
;4294:		}
LABELV $1876
line 4295
;4295:	}
LABELV $1858
line 4297
;4296:	// if the bot is blocked by or standing on top of a button
;4297:	if (!strcmp(classname, "func_button")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1905
ARGP4
ADDRLP4 3264
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3264
INDIRI4
CNSTI4 0
NEI4 $1903
line 4298
;4298:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1903
line 4301
;4299:	}
;4300:	// get the targetname so we can find an entity with a matching target
;4301:	if (!trap_AAS_ValueForBSPEpairKey(ent, "targetname", targetname[0], sizeof(targetname[0]))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1908
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
NEI4 $1906
line 4302
;4302:		if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1909
line 4303
;4303:			BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with model \"%s\" has no targetname\n", model);
CNSTI4 3
ARGI4
ADDRGP4 $1912
ARGP4
ADDRLP4 1712
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4304
;4304:		}
LABELV $1909
line 4305
;4305:		return 0;
CNSTI4 0
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1906
line 4308
;4306:	}
;4307:	// allow tree-like activation
;4308:	cur_entities[0] = trap_AAS_NextBSPEntity(0);
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
line 4309
;4309:	for (i = 0; i >= 0 && i < 10;) {
ADDRLP4 132
CNSTI4 0
ASGNI4
ADDRGP4 $1916
JUMPV
LABELV $1913
line 4310
;4310:		for (ent = cur_entities[i]; ent; ent = trap_AAS_NextBSPEntity(ent)) {
ADDRLP4 0
ADDRLP4 132
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 1416
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $1920
JUMPV
LABELV $1917
line 4311
;4311:			if (!trap_AAS_ValueForBSPEpairKey(ent, "target", target, sizeof(target))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1923
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
NEI4 $1921
ADDRGP4 $1918
JUMPV
LABELV $1921
line 4312
;4312:			if (!strcmp(targetname[i], target)) {
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
NEI4 $1924
line 4313
;4313:				cur_entities[i] = trap_AAS_NextBSPEntity(ent);
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
line 4314
;4314:				break;
ADDRGP4 $1919
JUMPV
LABELV $1924
line 4316
;4315:			}
;4316:		}
LABELV $1918
line 4310
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
LABELV $1920
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1917
LABELV $1919
line 4317
;4317:		if (!ent) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $1926
line 4318
;4318:			if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1928
line 4319
;4319:				BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no entity with target \"%s\"\n", targetname[i]);
CNSTI4 3
ARGI4
ADDRGP4 $1931
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
LABELV $1928
line 4321
;4321:			i--;
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 4322
;4322:			continue;
ADDRGP4 $1914
JUMPV
LABELV $1926
line 4324
;4323:		}
;4324:		if (!trap_AAS_ValueForBSPEpairKey(ent, "classname", classname, sizeof(classname))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1854
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
NEI4 $1932
line 4325
;4325:			if (bot_developer.integer) {
ADDRGP4 bot_developer+12
INDIRI4
CNSTI4 0
EQI4 $1914
line 4326
;4326:				BotAI_Print(PRT_ERROR, "BotGetActivateGoal: entity with target \"%s\" has no classname\n", targetname[i]);
CNSTI4 3
ARGI4
ADDRGP4 $1937
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
line 4327
;4327:			}
line 4328
;4328:			continue;
ADDRGP4 $1914
JUMPV
LABELV $1932
line 4331
;4329:		}
;4330:		// BSP button model
;4331:		if (!strcmp(classname, "func_button")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1905
ARGP4
ADDRLP4 3284
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3284
INDIRI4
CNSTI4 0
NEI4 $1938
line 4333
;4332:			//
;4333:			if (!BotFuncButtonActivateGoal(bs, ent, activategoal))
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
NEI4 $1940
line 4334
;4334:				continue;
ADDRGP4 $1914
JUMPV
LABELV $1940
line 4336
;4335:			// if the bot tries to activate this button already
;4336:			if ( bs->activatestack && bs->activatestack->inuse &&
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
EQU4 $1942
ADDRLP4 3292
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $1942
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
NEI4 $1942
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
LEF4 $1942
ADDRLP4 3292
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ADDRLP4 3300
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $1942
line 4340
;4337:				 bs->activatestack->goal.entitynum == activategoal->goal.entitynum &&
;4338:				 bs->activatestack->time > FloatTime() &&
;4339:				 bs->activatestack->start_time < FloatTime() - 2)
;4340:				continue;
ADDRGP4 $1914
JUMPV
LABELV $1942
line 4342
;4341:			// if the bot is in a reachability area
;4342:			if ( trap_AAS_AreaReachability(bs->areanum) ) {
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
EQI4 $1944
line 4344
;4343:				// disable all areas the blocking entity is in
;4344:				BotEnableActivateGoalAreas( activategoal, qfalse );
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4346
;4345:				//
;4346:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, activategoal->goal.areanum, bs->tfl);
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
line 4348
;4347:				// if the button is not reachable
;4348:				if (!t) {
ADDRLP4 2736
INDIRI4
CNSTI4 0
NEI4 $1946
line 4349
;4349:					continue;
ADDRGP4 $1914
JUMPV
LABELV $1946
line 4351
;4350:				}
;4351:				activategoal->time = FloatTime() + t * 0.01 + 5;
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
line 4352
;4352:			}
LABELV $1944
line 4353
;4353:			return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1938
line 4356
;4354:		}
;4355:		// invisible trigger multiple box
;4356:		else if (!strcmp(classname, "trigger_multiple")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1950
ARGP4
ADDRLP4 3288
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3288
INDIRI4
CNSTI4 0
NEI4 $1948
line 4358
;4357:			//
;4358:			if (!BotTriggerMultipleActivateGoal(bs, ent, activategoal))
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
NEI4 $1951
line 4359
;4359:				continue;
ADDRGP4 $1914
JUMPV
LABELV $1951
line 4361
;4360:			// if the bot tries to activate this trigger already
;4361:			if ( bs->activatestack && bs->activatestack->inuse &&
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
EQU4 $1953
ADDRLP4 3296
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $1953
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
NEI4 $1953
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
LEF4 $1953
ADDRLP4 3296
INDIRP4
CNSTI4 64
ADDP4
INDIRF4
ADDRLP4 3304
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $1953
line 4365
;4362:				 bs->activatestack->goal.entitynum == activategoal->goal.entitynum &&
;4363:				 bs->activatestack->time > FloatTime() &&
;4364:				 bs->activatestack->start_time < FloatTime() - 2)
;4365:				continue;
ADDRGP4 $1914
JUMPV
LABELV $1953
line 4367
;4366:			// if the bot is in a reachability area
;4367:			if ( trap_AAS_AreaReachability(bs->areanum) ) {
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
EQI4 $1955
line 4369
;4368:				// disable all areas the blocking entity is in
;4369:				BotEnableActivateGoalAreas( activategoal, qfalse );
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4371
;4370:				//
;4371:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, activategoal->goal.areanum, bs->tfl);
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
line 4373
;4372:				// if the trigger is not reachable
;4373:				if (!t) {
ADDRLP4 2736
INDIRI4
CNSTI4 0
NEI4 $1957
line 4374
;4374:					continue;
ADDRGP4 $1914
JUMPV
LABELV $1957
line 4376
;4375:				}
;4376:				activategoal->time = FloatTime() + t * 0.01 + 5;
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
line 4377
;4377:			}
LABELV $1955
line 4378
;4378:			return ent;
ADDRLP4 0
INDIRI4
RETI4
ADDRGP4 $1840
JUMPV
LABELV $1948
line 4380
;4379:		}
;4380:		else if (!strcmp(classname, "func_timer")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1961
ARGP4
ADDRLP4 3292
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3292
INDIRI4
CNSTI4 0
NEI4 $1959
line 4382
;4381:			// just skip the func_timer
;4382:			continue;
ADDRGP4 $1914
JUMPV
LABELV $1959
line 4385
;4383:		}
;4384:		// the actual button or trigger might be linked through a target_relay or target_delay
;4385:		else if (!strcmp(classname, "target_relay") || !strcmp(classname, "target_delay")) {
ADDRLP4 1456
ARGP4
ADDRGP4 $1964
ARGP4
ADDRLP4 3296
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3296
INDIRI4
CNSTI4 0
EQI4 $1966
ADDRLP4 1456
ARGP4
ADDRGP4 $1965
ARGP4
ADDRLP4 3300
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 3300
INDIRI4
CNSTI4 0
NEI4 $1962
LABELV $1966
line 4386
;4386:			if (trap_AAS_ValueForBSPEpairKey(ent, "targetname", targetname[i+1], sizeof(targetname[0]))) {
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1908
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
EQI4 $1967
line 4387
;4387:				i++;
ADDRLP4 132
ADDRLP4 132
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 4388
;4388:				cur_entities[i] = trap_AAS_NextBSPEntity(0);
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
line 4389
;4389:			}
LABELV $1967
line 4390
;4390:		}
LABELV $1962
line 4391
;4391:	}
LABELV $1914
line 4309
LABELV $1916
ADDRLP4 132
INDIRI4
CNSTI4 0
LTI4 $1970
ADDRLP4 132
INDIRI4
CNSTI4 10
LTI4 $1913
LABELV $1970
line 4395
;4392:#ifdef OBSTACLEDEBUG
;4393:	BotAI_Print(PRT_ERROR, "BotGetActivateGoal: no valid activator for entity with target \"%s\"\n", targetname[0]);
;4394:#endif
;4395:	return 0;
CNSTI4 0
RETI4
LABELV $1840
endproc BotGetActivateGoal 3320 20
export BotGoForActivateGoal
proc BotGoForActivateGoal 144 8
line 4403
;4396:}
;4397:
;4398:/*
;4399:==================
;4400:BotGoForActivateGoal
;4401:==================
;4402:*/
;4403:int BotGoForActivateGoal(bot_state_t *bs, bot_activategoal_t *activategoal) {
line 4406
;4404:	aas_entityinfo_t activateinfo;
;4405:
;4406:	activategoal->inuse = qtrue;
ADDRFP4 4
INDIRP4
CNSTI4 1
ASGNI4
line 4407
;4407:	if (!activategoal->time)
ADDRFP4 4
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
CNSTF4 0
NEF4 $1972
line 4408
;4408:		activategoal->time = FloatTime() + 10;
ADDRFP4 4
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
LABELV $1972
line 4409
;4409:	activategoal->start_time = FloatTime();
ADDRFP4 4
INDIRP4
CNSTI4 64
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4410
;4410:	BotEntityInfo(activategoal->goal.entitynum, &activateinfo);
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
line 4411
;4411:	VectorCopy(activateinfo.origin, activategoal->origin);
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
ADDRLP4 0+24
INDIRB
ASGNB 12
line 4413
;4412:	//
;4413:	if (BotPushOntoActivateGoalStack(bs, activategoal)) {
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
EQI4 $1975
line 4415
;4414:		// enter the activate entity AI node
;4415:		AIEnter_Seek_ActivateEntity(bs, "BotGoForActivateGoal");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1977
ARGP4
ADDRGP4 AIEnter_Seek_ActivateEntity
CALLV
pop
line 4416
;4416:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $1971
JUMPV
LABELV $1975
line 4418
;4417:	}
;4418:	else {
line 4420
;4419:		// enable any routing areas that were disabled
;4420:		BotEnableActivateGoalAreas(activategoal, qtrue);
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4421
;4421:		return qfalse;
CNSTI4 0
RETI4
LABELV $1971
endproc BotGoForActivateGoal 144 8
export BotPrintActivateGoalInfo
proc BotPrintActivateGoalInfo 296 36
line 4430
;4422:	}
;4423:}
;4424:
;4425:/*
;4426:==================
;4427:BotPrintActivateGoalInfo
;4428:==================
;4429:*/
;4430:void BotPrintActivateGoalInfo(bot_state_t *bs, bot_activategoal_t *activategoal, int bspent) {
line 4435
;4431:	char netname[MAX_NETNAME];
;4432:	char classname[128];
;4433:	char buf[128];
;4434:
;4435:	ClientName(bs->client, netname, sizeof(netname));
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
line 4436
;4436:	trap_AAS_ValueForBSPEpairKey(bspent, "classname", classname, sizeof(classname));
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $1854
ARGP4
ADDRLP4 36
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 trap_AAS_ValueForBSPEpairKey
CALLI4
pop
line 4437
;4437:	if (activategoal->shoot) {
ADDRFP4 4
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
EQI4 $1979
line 4438
;4438:		Com_sprintf(buf, sizeof(buf), "%s: I have to shoot at a %s from %1.1f %1.1f %1.1f in area %d\n",
ADDRLP4 164
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $1981
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
line 4444
;4439:						netname, classname,
;4440:						activategoal->goal.origin[0],
;4441:						activategoal->goal.origin[1],
;4442:						activategoal->goal.origin[2],
;4443:						activategoal->goal.areanum);
;4444:	}
ADDRGP4 $1980
JUMPV
LABELV $1979
line 4445
;4445:	else {
line 4446
;4446:		Com_sprintf(buf, sizeof(buf), "%s: I have to activate a %s at %1.1f %1.1f %1.1f in area %d\n",
ADDRLP4 164
ARGP4
CNSTI4 128
ARGI4
ADDRGP4 $1982
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
line 4452
;4447:						netname, classname,
;4448:						activategoal->goal.origin[0],
;4449:						activategoal->goal.origin[1],
;4450:						activategoal->goal.origin[2],
;4451:						activategoal->goal.areanum);
;4452:	}
LABELV $1980
line 4453
;4453:	trap_EA_Say(bs->client, buf);
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
line 4454
;4454:}
LABELV $1978
endproc BotPrintActivateGoalInfo 296 36
export BotRandomMove
proc BotRandomMove 32 16
line 4461
;4455:
;4456:/*
;4457:==================
;4458:BotRandomMove
;4459:==================
;4460:*/
;4461:void BotRandomMove(bot_state_t *bs, bot_moveresult_t *moveresult) {
line 4464
;4462:	vec3_t dir, angles;
;4463:
;4464:	angles[0] = 0;
ADDRLP4 0
CNSTF4 0
ASGNF4
line 4465
;4465:	angles[1] = random() * 360;
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
line 4466
;4466:	angles[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 4467
;4467:	AngleVectors(angles, dir, NULL, NULL);
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
line 4469
;4468:
;4469:	trap_BotMoveInDirection(bs->ms, dir, 400, MOVE_WALK);
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
line 4471
;4470:
;4471:	moveresult->failure = qfalse;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 4472
;4472:	VectorCopy(dir, moveresult->movedir);
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
ADDRLP4 12
INDIRB
ASGNB 12
line 4473
;4473:}
LABELV $1983
endproc BotRandomMove 32 16
lit
align 4
LABELV $1987
byte 4 0
byte 4 0
byte 4 1065353216
export BotAIBlocked
code
proc BotAIBlocked 528 16
line 4486
;4474:
;4475:/*
;4476:==================
;4477:BotAIBlocked
;4478:
;4479:Very basic handling of bots being blocked by other entities.
;4480:Check what kind of entity is blocking the bot and try to activate
;4481:it. If that's not an option then try to walk around or over the entity.
;4482:Before the bot ends in this part of the AI it should predict which doors to
;4483:open, which buttons to activate etc.
;4484:==================
;4485:*/
;4486:void BotAIBlocked(bot_state_t *bs, bot_moveresult_t *moveresult, int activate) {
line 4488
;4487:	int movetype, bspent;
;4488:	vec3_t hordir, start, end, mins, maxs, sideward, angles, up = {0, 0, 1};
ADDRLP4 228
ADDRGP4 $1987
INDIRB
ASGNB 12
line 4493
;4489:	aas_entityinfo_t entinfo;
;4490:	bot_activategoal_t activategoal;
;4491:
;4492:	// if the bot is not blocked by anything
;4493:	if (!moveresult->blocked) {
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
CNSTI4 0
NEI4 $1988
line 4494
;4494:		bs->notblocked_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6204
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4495
;4495:		return;
ADDRGP4 $1986
JUMPV
LABELV $1988
line 4498
;4496:	}
;4497:	// if stuck in a solid area
;4498:	if ( moveresult->type == RESULTTYPE_INSOLIDAREA ) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 8
NEI4 $1990
line 4500
;4499:		// move in a random direction in the hope to get out
;4500:		BotRandomMove(bs, moveresult);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRandomMove
CALLV
pop
line 4502
;4501:		//
;4502:		return;
ADDRGP4 $1986
JUMPV
LABELV $1990
line 4505
;4503:	}
;4504:	// get info for the entity that is blocking the bot
;4505:	BotEntityInfo(moveresult->blockentity, &entinfo);
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
line 4511
;4506:#ifdef OBSTACLEDEBUG
;4507:	ClientName(bs->client, netname, sizeof(netname));
;4508:	BotAI_Print(PRT_MESSAGE, "%s: I'm blocked by model %d\n", netname, entinfo.modelindex);
;4509:#endif // OBSTACLEDEBUG
;4510:	// if blocked by a bsp model and the bot wants to activate it
;4511:	if (activate && entinfo.modelindex > 0 && entinfo.modelindex <= max_bspmodelindex) {
ADDRLP4 488
CNSTI4 0
ASGNI4
ADDRFP4 8
INDIRI4
ADDRLP4 488
INDIRI4
EQI4 $1992
ADDRLP4 40+104
INDIRI4
ADDRLP4 488
INDIRI4
LEI4 $1992
ADDRLP4 40+104
INDIRI4
ADDRGP4 max_bspmodelindex
INDIRI4
GTI4 $1992
line 4513
;4512:		// find the bsp entity which should be activated in order to get the blocking entity out of the way
;4513:		bspent = BotGetActivateGoal(bs, entinfo.number, &activategoal);
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
line 4514
;4514:		if (bspent) {
ADDRLP4 484
INDIRI4
CNSTI4 0
EQI4 $1997
line 4516
;4515:			//
;4516:			if (bs->activatestack && !bs->activatestack->inuse)
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
EQU4 $1999
ADDRLP4 496
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $1999
line 4517
;4517:				bs->activatestack = NULL;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
CNSTP4 0
ASGNP4
LABELV $1999
line 4519
;4518:			// if not already trying to activate this entity
;4519:			if (!BotIsGoingToActivateEntity(bs, activategoal.goal.entitynum)) {
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
NEI4 $2001
line 4521
;4520:				//
;4521:				BotGoForActivateGoal(bs, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 240
ARGP4
ADDRGP4 BotGoForActivateGoal
CALLI4
pop
line 4522
;4522:			}
LABELV $2001
line 4526
;4523:			// if ontop of an obstacle or
;4524:			// if the bot is not in a reachability area it'll still
;4525:			// need some dynamic obstacle avoidance, otherwise return
;4526:			if (!(moveresult->flags & MOVERESULT_ONTOPOFOBSTACLE) &&
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $1998
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
EQI4 $1998
line 4528
;4527:				trap_AAS_AreaReachability(bs->areanum))
;4528:				return;
ADDRGP4 $1986
JUMPV
line 4529
;4529:		}
LABELV $1997
line 4530
;4530:		else {
line 4532
;4531:			// enable any routing areas that were disabled
;4532:			BotEnableActivateGoalAreas(&activategoal, qtrue);
ADDRLP4 240
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4533
;4533:		}
LABELV $1998
line 4534
;4534:	}
LABELV $1992
line 4536
;4535:	// just some basic dynamic obstacle avoidance code
;4536:	hordir[0] = moveresult->movedir[0];
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ASGNF4
line 4537
;4537:	hordir[1] = moveresult->movedir[1];
ADDRLP4 0+4
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ASGNF4
line 4538
;4538:	hordir[2] = 0;
ADDRLP4 0+8
CNSTF4 0
ASGNF4
line 4540
;4539:	// if no direction just take a random direction
;4540:	if (VectorNormalize(hordir) < 0.1) {
ADDRLP4 0
ARGP4
ADDRLP4 492
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 492
INDIRF4
CNSTF4 1036831949
GEF4 $2009
line 4541
;4541:		VectorSet(angles, 0, 360 * random(), 0);
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
line 4542
;4542:		AngleVectors(angles, hordir, NULL, NULL);
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
line 4543
;4543:	}
LABELV $2009
line 4547
;4544:	//
;4545:	//if (moveresult->flags & MOVERESULT_ONTOPOFOBSTACLE) movetype = MOVE_JUMP;
;4546:	//else
;4547:	movetype = MOVE_WALK;
ADDRLP4 36
CNSTI4 1
ASGNI4
line 4550
;4548:	// if there's an obstacle at the bot's feet and head then
;4549:	// the bot might be able to crouch through
;4550:	VectorCopy(bs->origin, start);
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 4551
;4551:	start[2] += 18;
ADDRLP4 24+8
ADDRLP4 24+8
INDIRF4
CNSTF4 1099956224
ADDF4
ASGNF4
line 4552
;4552:	VectorMA(start, 5, hordir, end);
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
line 4553
;4553:	VectorSet(mins, -16, -16, -24);
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
line 4554
;4554:	VectorSet(maxs, 16, 16, 4);
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
line 4559
;4555:	//
;4556:	//bsptrace = AAS_Trace(start, mins, maxs, end, bs->entitynum, MASK_PLAYERSOLID);
;4557:	//if (bsptrace.fraction >= 1) movetype = MOVE_CROUCH;
;4558:	// get the sideward vector
;4559:	CrossProduct(hordir, up, sideward);
ADDRLP4 0
ARGP4
ADDRLP4 228
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
line 4561
;4560:	//
;4561:	if (bs->flags & BFL_AVOIDRIGHT) VectorNegate(sideward, sideward);
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $2024
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
LABELV $2024
line 4563
;4562:	// try to crouch straight forward?
;4563:	if (movetype != MOVE_CROUCH || !trap_BotMoveInDirection(bs->ms, hordir, 400, movetype)) {
ADDRLP4 36
INDIRI4
CNSTI4 2
NEI4 $2032
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
NEI4 $2030
LABELV $2032
line 4565
;4564:		// perform the movement
;4565:		if (!trap_BotMoveInDirection(bs->ms, sideward, 400, movetype)) {
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
NEI4 $2033
line 4567
;4566:			// flip the avoid direction flag
;4567:			bs->flags ^= BFL_AVOIDRIGHT;
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
line 4570
;4568:			// flip the direction
;4569:			// VectorNegate(sideward, sideward);
;4570:			VectorMA(sideward, -1, hordir, sideward);
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
line 4572
;4571:			// move in the other direction
;4572:			trap_BotMoveInDirection(bs->ms, sideward, 400, movetype);
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
line 4573
;4573:		}
LABELV $2033
line 4574
;4574:	}
LABELV $2030
line 4576
;4575:	//
;4576:	if (bs->notblocked_time < FloatTime() - 0.4) {
ADDRFP4 0
INDIRP4
CNSTI4 6204
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1053609165
SUBF4
GEF4 $2041
line 4579
;4577:		// just reset goals and hope the bot will go into another direction?
;4578:		// is this still needed??
;4579:		if (bs->ainode == AINode_Seek_NBG) bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Seek_NBG
CVPU4 4
NEU4 $2043
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
ADDRGP4 $2044
JUMPV
LABELV $2043
line 4580
;4580:		else if (bs->ainode == AINode_Seek_LTG) bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
ADDRGP4 AINode_Seek_LTG
CVPU4 4
NEU4 $2045
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
LABELV $2045
LABELV $2044
line 4581
;4581:	}
LABELV $2041
line 4582
;4582:}
LABELV $1986
endproc BotAIBlocked 528 16
export BotAIPredictObstacles
proc BotAIPredictObstacles 324 44
line 4594
;4583:
;4584:/*
;4585:==================
;4586:BotAIPredictObstacles
;4587:
;4588:Predict the route towards the goal and check if the bot
;4589:will be blocked by certain obstacles. When the bot has obstacles
;4590:on it's path the bot should figure out if they can be removed
;4591:by activating certain entities.
;4592:==================
;4593:*/
;4594:int BotAIPredictObstacles(bot_state_t *bs, bot_goal_t *goal) {
line 4599
;4595:	int modelnum, entitynum, bspent;
;4596:	bot_activategoal_t activategoal;
;4597:	aas_predictroute_t route;
;4598:
;4599:	if (!bot_predictobstacles.integer)
ADDRGP4 bot_predictobstacles+12
INDIRI4
CNSTI4 0
NEI4 $2048
line 4600
;4600:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2047
JUMPV
LABELV $2048
line 4603
;4601:
;4602:	// always predict when the goal change or at regular intervals
;4603:	if (bs->predictobstacles_goalareanum == goal->areanum &&
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
NEI4 $2051
ADDRLP4 292
INDIRP4
CNSTI4 6212
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1086324736
SUBF4
LEF4 $2051
line 4604
;4604:		bs->predictobstacles_time > FloatTime() - 6) {
line 4605
;4605:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2047
JUMPV
LABELV $2051
line 4607
;4606:	}
;4607:	bs->predictobstacles_goalareanum = goal->areanum;
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
line 4608
;4608:	bs->predictobstacles_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6212
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4611
;4609:
;4610:	// predict at most 100 areas or 10 seconds ahead
;4611:	trap_AAS_PredictRoute(&route, bs->areanum, bs->origin,
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
line 4616
;4612:							goal->areanum, bs->tfl, 100, 1000,
;4613:							RSE_USETRAVELTYPE|RSE_ENTERCONTENTS,
;4614:							AREACONTENTS_MOVER, TFL_BRIDGE, 0);
;4615:	// if bot has to travel through an area with a mover
;4616:	if (route.stopevent & RSE_ENTERCONTENTS) {
ADDRLP4 0+16
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $2053
line 4618
;4617:		// if the bot will run into a mover
;4618:		if (route.endcontents & AREACONTENTS_MOVER) {
ADDRLP4 0+20
INDIRI4
CNSTI4 1024
BANDI4
CNSTI4 0
EQI4 $2054
line 4620
;4619:			//NOTE: this only works with bspc 2.1 or higher
;4620:			modelnum = (route.endcontents & AREACONTENTS_MODELNUM) >> AREACONTENTS_MODELNUMSHIFT;
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
line 4621
;4621:			if (modelnum) {
ADDRLP4 36
INDIRI4
CNSTI4 0
EQI4 $2054
line 4623
;4622:				//
;4623:				entitynum = BotModelMinsMaxs(modelnum, ET_MOVER, 0, NULL, NULL);
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
line 4624
;4624:				if (entitynum) {
ADDRLP4 40
INDIRI4
CNSTI4 0
EQI4 $2054
line 4626
;4625:					//NOTE: BotGetActivateGoal already checks if the door is open or not
;4626:					bspent = BotGetActivateGoal(bs, entitynum, &activategoal);
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
line 4627
;4627:					if (bspent) {
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $2054
line 4629
;4628:						//
;4629:						if (bs->activatestack && !bs->activatestack->inuse)
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
EQU4 $2066
ADDRLP4 316
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2066
line 4630
;4630:							bs->activatestack = NULL;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
CNSTP4 0
ASGNP4
LABELV $2066
line 4632
;4631:						// if not already trying to activate this entity
;4632:						if (!BotIsGoingToActivateEntity(bs, activategoal.goal.entitynum)) {
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
NEI4 $2068
line 4636
;4633:							//
;4634:							//BotAI_Print(PRT_MESSAGE, "blocked by mover model %d, entity %d ?\n", modelnum, entitynum);
;4635:							//
;4636:							BotGoForActivateGoal(bs, &activategoal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 48
ARGP4
ADDRGP4 BotGoForActivateGoal
CALLI4
pop
line 4637
;4637:							return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2047
JUMPV
LABELV $2068
line 4639
;4638:						}
;4639:						else {
line 4641
;4640:							// enable any routing areas that were disabled
;4641:							BotEnableActivateGoalAreas(&activategoal, qtrue);
ADDRLP4 48
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotEnableActivateGoalAreas
CALLV
pop
line 4642
;4642:						}
line 4643
;4643:					}
line 4644
;4644:				}
line 4645
;4645:			}
line 4646
;4646:		}
line 4647
;4647:	}
ADDRGP4 $2054
JUMPV
LABELV $2053
line 4648
;4648:	else if (route.stopevent & RSE_USETRAVELTYPE) {
ADDRLP4 0+16
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $2072
line 4649
;4649:		if (route.endtravelflags & TFL_BRIDGE) {
ADDRLP4 0+24
INDIRI4
CNSTI4 67108864
BANDI4
CNSTI4 0
EQI4 $2075
line 4651
;4650:			//FIXME: check if the bridge is available to travel over
;4651:		}
LABELV $2075
line 4652
;4652:	}
LABELV $2072
LABELV $2054
line 4653
;4653:	return qfalse;
CNSTI4 0
RETI4
LABELV $2047
endproc BotAIPredictObstacles 324 44
export BotCheckConsoleMessages
proc BotCheckConsoleMessages 1012 48
line 4661
;4654:}
;4655:
;4656:/*
;4657:==================
;4658:BotCheckConsoleMessages
;4659:==================
;4660:*/
;4661:void BotCheckConsoleMessages(bot_state_t *bs) {
line 4669
;4662:	char botname[MAX_NETNAME], message[MAX_MESSAGE_SIZE], netname[MAX_NETNAME], *ptr;
;4663:	float chat_reply;
;4664:	int context, handle;
;4665:	bot_consolemessage_t m;
;4666:	bot_match_t match;
;4667:
;4668:	//the name of this bot
;4669:	ClientName(bs->client, botname, sizeof(botname));
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
ADDRGP4 $2080
JUMPV
LABELV $2079
line 4671
;4670:	//
;4671:	while((handle = trap_BotNextConsoleMessage(bs->cs, &m)) != 0) {
line 4673
;4672:		//if the chat state is flooded with messages the bot will read them quickly
;4673:		if (trap_BotNumConsoleMessages(bs->cs) < 10) {
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
GEI4 $2082
line 4675
;4674:			//if it is a chat message the bot needs some time to read it
;4675:			if (m.type == CMS_CHAT && m.time > FloatTime() - (1 + random())) break;
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2084
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
LEF4 $2084
ADDRGP4 $2081
JUMPV
LABELV $2084
line 4676
;4676:		}
LABELV $2082
line 4678
;4677:		//
;4678:		ptr = m.message;
ADDRLP4 276
ADDRLP4 0+12
ASGNP4
line 4681
;4679:		//if it is a chat message then don't unify white spaces and don't
;4680:		//replace synonyms in the netname
;4681:		if (m.type == CMS_CHAT) {
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2089
line 4683
;4682:			//
;4683:			if (trap_BotFindMatch(m.message, &match, MTCONTEXT_REPLYCHAT)) {
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
EQI4 $2092
line 4684
;4684:				ptr = m.message + match.variables[MESSAGE].offset;
ADDRLP4 276
ADDRLP4 288+264+16
INDIRI1
CVII4 1
ADDRLP4 0+12
ADDP4
ASGNP4
line 4685
;4685:			}
LABELV $2092
line 4686
;4686:		}
LABELV $2089
line 4688
;4687:		//unify the white spaces in the message
;4688:		trap_UnifyWhiteSpaces(ptr);
ADDRLP4 276
INDIRP4
ARGP4
ADDRGP4 trap_UnifyWhiteSpaces
CALLV
pop
line 4690
;4689:		//replace synonyms in the right context
;4690:		context = BotSynonymContext(bs);
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
line 4691
;4691:		trap_BotReplaceSynonyms(ptr, context);
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
line 4693
;4692:		//if there's no match
;4693:		if (!BotMatchMessage(bs, m.message)) {
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
NEI4 $2098
line 4695
;4694:			//if it is a chat message
;4695:			if (m.type == CMS_CHAT && !bot_nochat.integer) {
ADDRLP4 0+8
INDIRI4
CNSTI4 1
NEI4 $2101
ADDRGP4 bot_nochat+12
INDIRI4
CNSTI4 0
NEI4 $2101
line 4697
;4696:				//
;4697:				if (!trap_BotFindMatch(m.message, &match, MTCONTEXT_REPLYCHAT)) {
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
NEI4 $2105
line 4698
;4698:					trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4699
;4699:					continue;
ADDRGP4 $2080
JUMPV
LABELV $2105
line 4702
;4700:				}
;4701:				//don't use eliza chats with team messages
;4702:				if (match.subtype & ST_TEAM) {
ADDRLP4 288+260
INDIRI4
CNSTI4 32768
BANDI4
CNSTI4 0
EQI4 $2108
line 4703
;4703:					trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4704
;4704:					continue;
ADDRGP4 $2080
JUMPV
LABELV $2108
line 4707
;4705:				}
;4706:				//
;4707:				trap_BotMatchVariable(&match, NETNAME, netname, sizeof(netname));
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
line 4708
;4708:				trap_BotMatchVariable(&match, MESSAGE, message, sizeof(message));
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
line 4710
;4709:				//if this is a message from the bot self
;4710:				if (bs->client == ClientFromName(netname)) {
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
NEI4 $2111
line 4711
;4711:					trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4712
;4712:					continue;
ADDRGP4 $2080
JUMPV
LABELV $2111
line 4715
;4713:				}
;4714:				//unify the message
;4715:				trap_UnifyWhiteSpaces(message);
ADDRLP4 616
ARGP4
ADDRGP4 trap_UnifyWhiteSpaces
CALLV
pop
line 4717
;4716:				//
;4717:				trap_Cvar_Update(&bot_testrchat);
ADDRGP4 bot_testrchat
ARGP4
ADDRGP4 trap_Cvar_Update
CALLV
pop
line 4718
;4718:				if (bot_testrchat.integer) {
ADDRGP4 bot_testrchat+12
INDIRI4
CNSTI4 0
EQI4 $2113
line 4720
;4719:					//
;4720:					trap_BotLibVarSet("bot_testrchat", "1");
ADDRGP4 $2116
ARGP4
ADDRGP4 $2117
ARGP4
ADDRGP4 trap_BotLibVarSet
CALLI4
pop
line 4722
;4721:					//if bot replies with a chat message
;4722:					if (trap_BotReplyChat(bs->cs, message, context, CONTEXT_REPLY,
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
EQI4 $2118
line 4726
;4723:															NULL, NULL,
;4724:															NULL, NULL,
;4725:															NULL, NULL,
;4726:															botname, netname)) {
line 4727
;4727:						BotAI_Print(PRT_MESSAGE, "------------------------\n");
CNSTI4 1
ARGI4
ADDRGP4 $2120
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4728
;4728:					}
ADDRGP4 $2114
JUMPV
LABELV $2118
line 4729
;4729:					else {
line 4730
;4730:						BotAI_Print(PRT_MESSAGE, "**** no valid reply ****\n");
CNSTI4 1
ARGI4
ADDRGP4 $2121
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 4731
;4731:					}
line 4732
;4732:				}
ADDRGP4 $2114
JUMPV
LABELV $2113
line 4734
;4733:				//if at a valid chat position and not chatting already and not in teamplay
;4734:				else if (bs->ainode != AINode_Stand && BotValidChatPosition(bs) && !TeamPlayIsOn()) {
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
EQU4 $2122
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
EQI4 $2122
ADDRLP4 976
ADDRGP4 TeamPlayIsOn
CALLI4
ASGNI4
ADDRLP4 976
INDIRI4
CNSTI4 0
NEI4 $2122
line 4735
;4735:					chat_reply = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CHAT_REPLY, 0, 1);
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
line 4736
;4736:					if (random() < 1.5 / (NumBots()+1) && random() < chat_reply) {
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
GEF4 $2124
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
GEF4 $2124
line 4738
;4737:						//if bot replies with a chat message
;4738:						if (trap_BotReplyChat(bs->cs, message, context, CONTEXT_REPLY,
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
EQI4 $2126
line 4742
;4739:																NULL, NULL,
;4740:																NULL, NULL,
;4741:																NULL, NULL,
;4742:																botname, netname)) {
line 4744
;4743:							//remove the console message
;4744:							trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4745
;4745:							bs->stand_time = FloatTime() + BotChatTime(bs);
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
line 4746
;4746:							AIEnter_Stand(bs, "BotCheckConsoleMessages: reply chat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2128
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 4748
;4747:							//EA_Say(bs->client, bs->cs.chatmessage);
;4748:							break;
ADDRGP4 $2081
JUMPV
LABELV $2126
line 4750
;4749:						}
;4750:					}
LABELV $2124
line 4751
;4751:				}
LABELV $2122
LABELV $2114
line 4752
;4752:			}
LABELV $2101
line 4753
;4753:		}
LABELV $2098
line 4755
;4754:		//remove the console message
;4755:		trap_BotRemoveConsoleMessage(bs->cs, handle);
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
line 4756
;4756:	}
LABELV $2080
line 4671
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
NEI4 $2079
LABELV $2081
line 4757
;4757:}
LABELV $2078
endproc BotCheckConsoleMessages 1012 48
export BotCheckForGrenades
proc BotCheckForGrenades 8 16
line 4764
;4758:
;4759:/*
;4760:==================
;4761:BotCheckEvents
;4762:==================
;4763:*/
;4764:void BotCheckForGrenades(bot_state_t *bs, entityState_t *state) {
line 4766
;4765:	// if this is not a grenade
;4766:	if (state->eType != ET_MISSILE || state->weapon != WP_GRENADE_LAUNCHER)
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
NEI4 $2132
ADDRLP4 0
INDIRP4
CNSTI4 192
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $2130
LABELV $2132
line 4767
;4767:		return;
ADDRGP4 $2129
JUMPV
LABELV $2130
line 4769
;4768:	// try to avoid the grenade
;4769:	trap_BotAddAvoidSpot(bs->ms, state->pos.trBase, 160, AVOID_ALWAYS);
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
line 4770
;4770:}
LABELV $2129
endproc BotCheckForGrenades 8 16
export BotCheckEvents
proc BotCheckEvents 164 12
line 4822
;4771:
;4772:#ifdef MISSIONPACK
;4773:/*
;4774:==================
;4775:BotCheckForProxMines
;4776:==================
;4777:*/
;4778:void BotCheckForProxMines(bot_state_t *bs, entityState_t *state) {
;4779:	// if this is not a prox mine
;4780:	if (state->eType != ET_MISSILE || state->weapon != WP_PROX_LAUNCHER)
;4781:		return;
;4782:	// if this prox mine is from someone on our own team
;4783:	if (state->generic1 == BotTeam(bs))
;4784:		return;
;4785:	// if the bot doesn't have a weapon to deactivate the mine
;4786:	if (!(bs->inventory[INVENTORY_PLASMAGUN] > 0 && bs->inventory[INVENTORY_CELLS] > 0) &&
;4787:		!(bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 && bs->inventory[INVENTORY_ROCKETS] > 0) &&
;4788:		!(bs->inventory[INVENTORY_BFG10K] > 0 && bs->inventory[INVENTORY_BFGAMMO] > 0) ) {
;4789:		return;
;4790:	}
;4791:	// try to avoid the prox mine
;4792:	trap_BotAddAvoidSpot(bs->ms, state->pos.trBase, 160, AVOID_ALWAYS);
;4793:	//
;4794:	if (bs->numproxmines >= MAX_PROXMINES)
;4795:		return;
;4796:	bs->proxmines[bs->numproxmines] = state->number;
;4797:	bs->numproxmines++;
;4798:}
;4799:
;4800:/*
;4801:==================
;4802:BotCheckForKamikazeBody
;4803:==================
;4804:*/
;4805:void BotCheckForKamikazeBody(bot_state_t *bs, entityState_t *state) {
;4806:	// if this entity is not wearing the kamikaze
;4807:	if (!(state->eFlags & EF_KAMIKAZE))
;4808:		return;
;4809:	// if this entity isn't dead
;4810:	if (!(state->eFlags & EF_DEAD))
;4811:		return;
;4812:	//remember this kamikaze body
;4813:	bs->kamikazebody = state->number;
;4814:}
;4815:#endif
;4816:
;4817:/*
;4818:==================
;4819:BotCheckEvents
;4820:==================
;4821:*/
;4822:void BotCheckEvents(bot_state_t *bs, entityState_t *state) {
line 4831
;4823:	int event;
;4824:	char buf[128];
;4825:#ifdef MISSIONPACK
;4826:	aas_entityinfo_t entinfo;
;4827:#endif
;4828:
;4829:	//NOTE: this sucks, we're accessing the gentity_t directly
;4830:	//but there's no other fast way to do it right now
;4831:	if (bs->entityeventTime[state->number] == g_entities[state->number].eventTime) {
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
NEI4 $2134
line 4832
;4832:		return;
ADDRGP4 $2133
JUMPV
LABELV $2134
line 4834
;4833:	}
;4834:	bs->entityeventTime[state->number] = g_entities[state->number].eventTime;
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
line 4836
;4835:	//if it's an event only entity
;4836:	if (state->eType > ET_EVENTS) {
ADDRFP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 13
LEI4 $2138
line 4837
;4837:		event = (state->eType - ET_EVENTS) & ~EV_EVENT_BITS;
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
line 4838
;4838:	}
ADDRGP4 $2139
JUMPV
LABELV $2138
line 4839
;4839:	else {
line 4840
;4840:		event = state->event & ~EV_EVENT_BITS;
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
CNSTI4 -769
BANDI4
ASGNI4
line 4841
;4841:	}
LABELV $2139
line 4843
;4842:	//
;4843:	switch(event) {
ADDRLP4 140
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 1
LTI4 $2140
ADDRLP4 140
INDIRI4
CNSTI4 76
GTI4 $2140
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $2189-4
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $2189
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2141
address $2140
address $2140
address $2140
address $2174
address $2140
address $2140
address $2175
address $2153
address $2161
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2142
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2140
address $2141
code
LABELV $2142
line 4846
;4844:		//client obituary event
;4845:		case EV_OBITUARY:
;4846:		{
line 4849
;4847:			int target, attacker, mod;
;4848:
;4849:			target = state->otherEntityNum;
ADDRLP4 144
ADDRFP4 4
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
line 4850
;4850:			attacker = state->otherEntityNum2;
ADDRLP4 148
ADDRFP4 4
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 4851
;4851:			mod = state->eventParm;
ADDRLP4 152
ADDRFP4 4
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
ASGNI4
line 4853
;4852:			//
;4853:			if (target == bs->client) {
ADDRLP4 144
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2143
line 4854
;4854:				bs->botdeathtype = mod;
ADDRFP4 0
INDIRP4
CNSTI4 6000
ADDP4
ADDRLP4 152
INDIRI4
ASGNI4
line 4855
;4855:				bs->lastkilledby = attacker;
ADDRFP4 0
INDIRP4
CNSTI4 5996
ADDP4
ADDRLP4 148
INDIRI4
ASGNI4
line 4857
;4856:				//
;4857:				if (target == attacker ||
ADDRLP4 156
ADDRLP4 144
INDIRI4
ASGNI4
ADDRLP4 156
INDIRI4
ADDRLP4 148
INDIRI4
EQI4 $2148
ADDRLP4 156
INDIRI4
CNSTI4 1023
EQI4 $2148
ADDRLP4 156
INDIRI4
CNSTI4 1022
NEI4 $2145
LABELV $2148
line 4859
;4858:					target == ENTITYNUM_NONE ||
;4859:					target == ENTITYNUM_WORLD) bs->botsuicide = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6008
ADDP4
CNSTI4 1
ASGNI4
ADDRGP4 $2146
JUMPV
LABELV $2145
line 4860
;4860:				else bs->botsuicide = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6008
ADDP4
CNSTI4 0
ASGNI4
LABELV $2146
line 4862
;4861:				//
;4862:				bs->num_deaths++;
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
line 4863
;4863:			}
ADDRGP4 $2141
JUMPV
LABELV $2143
line 4865
;4864:			//else if this client was killed by the bot
;4865:			else if (attacker == bs->client) {
ADDRLP4 148
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2149
line 4866
;4866:				bs->enemydeathtype = mod;
ADDRFP4 0
INDIRP4
CNSTI4 6004
ADDP4
ADDRLP4 152
INDIRI4
ASGNI4
line 4867
;4867:				bs->lastkilledplayer = target;
ADDRFP4 0
INDIRP4
CNSTI4 5992
ADDP4
ADDRLP4 144
INDIRI4
ASGNI4
line 4868
;4868:				bs->killedenemy_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6168
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4870
;4869:				//
;4870:				bs->num_kills++;
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
line 4871
;4871:			}
ADDRGP4 $2141
JUMPV
LABELV $2149
line 4872
;4872:			else if (attacker == bs->enemy && target == attacker) {
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
NEI4 $2141
ADDRLP4 144
INDIRI4
ADDRLP4 156
INDIRI4
NEI4 $2141
line 4873
;4873:				bs->enemysuicide = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
CNSTI4 1
ASGNI4
line 4874
;4874:			}
line 4888
;4875:			//
;4876:#ifdef MISSIONPACK			
;4877:			if (gametype == GT_1FCTF) {
;4878:				//
;4879:				BotEntityInfo(target, &entinfo);
;4880:				if ( entinfo.powerups & ( 1 << PW_NEUTRALFLAG ) ) {
;4881:					if (!BotSameTeam(bs, target)) {
;4882:						bs->neutralflagstatus = 3;	//enemy dropped the flag
;4883:						bs->flagstatuschanged = qtrue;
;4884:					}
;4885:				}
;4886:			}
;4887:#endif
;4888:			break;
ADDRGP4 $2141
JUMPV
LABELV $2153
line 4891
;4889:		}
;4890:		case EV_GLOBAL_SOUND:
;4891:		{
line 4892
;4892:			if (state->eventParm < 0 || state->eventParm > MAX_SOUNDS) {
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
LTI4 $2156
ADDRLP4 144
INDIRI4
CNSTI4 256
LEI4 $2154
LABELV $2156
line 4893
;4893:				BotAI_Print(PRT_ERROR, "EV_GLOBAL_SOUND: eventParm (%d) out of range\n", state->eventParm);
CNSTI4 3
ARGI4
ADDRGP4 $2157
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
line 4894
;4894:				break;
ADDRGP4 $2141
JUMPV
LABELV $2154
line 4896
;4895:			}
;4896:			trap_GetConfigstring(CS_SOUNDS + state->eventParm, buf, sizeof(buf));
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
line 4916
;4897:			/*
;4898:			if (!strcmp(buf, "sound/teamplay/flagret_red.wav")) {
;4899:				//red flag is returned
;4900:				bs->redflagstatus = 0;
;4901:				bs->flagstatuschanged = qtrue;
;4902:			}
;4903:			else if (!strcmp(buf, "sound/teamplay/flagret_blu.wav")) {
;4904:				//blue flag is returned
;4905:				bs->blueflagstatus = 0;
;4906:				bs->flagstatuschanged = qtrue;
;4907:			}
;4908:			else*/
;4909:#ifdef MISSIONPACK
;4910:			if (!strcmp(buf, "sound/items/kamikazerespawn.wav" )) {
;4911:				//the kamikaze respawned so dont avoid it
;4912:				BotDontAvoid(bs, "Kamikaze");
;4913:			}
;4914:			else
;4915:#endif
;4916:				if (!strcmp(buf, "sound/items/poweruprespawn.wav")) {
ADDRLP4 4
ARGP4
ADDRGP4 $2160
ARGP4
ADDRLP4 148
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2141
line 4918
;4917:				//powerup respawned... go get it
;4918:				BotGoForPowerups(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotGoForPowerups
CALLV
pop
line 4919
;4919:			}
line 4920
;4920:			break;
ADDRGP4 $2141
JUMPV
LABELV $2161
line 4923
;4921:		}
;4922:		case EV_GLOBAL_TEAM_SOUND:
;4923:		{
line 4924
;4924:			if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $2141
line 4925
;4925:				switch(state->eventParm) {
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
LTI4 $2141
ADDRLP4 144
INDIRI4
CNSTI4 5
GTI4 $2141
ADDRLP4 144
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $2173
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $2173
address $2167
address $2168
address $2169
address $2170
address $2171
address $2172
code
LABELV $2167
line 4927
;4926:					case GTS_RED_CAPTURE:
;4927:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 4928
;4928:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 4929
;4929:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4930
;4930:						break; //see BotMatch_CTF
ADDRGP4 $2141
JUMPV
LABELV $2168
line 4932
;4931:					case GTS_BLUE_CAPTURE:
;4932:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 4933
;4933:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 4934
;4934:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4935
;4935:						break; //see BotMatch_CTF
ADDRGP4 $2141
JUMPV
LABELV $2169
line 4938
;4936:					case GTS_RED_RETURN:
;4937:						//blue flag is returned
;4938:						bs->blueflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 0
ASGNI4
line 4939
;4939:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4940
;4940:						break;
ADDRGP4 $2141
JUMPV
LABELV $2170
line 4943
;4941:					case GTS_BLUE_RETURN:
;4942:						//red flag is returned
;4943:						bs->redflagstatus = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 0
ASGNI4
line 4944
;4944:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4945
;4945:						break;
ADDRGP4 $2141
JUMPV
LABELV $2171
line 4948
;4946:					case GTS_RED_TAKEN:
;4947:						//blue flag is taken
;4948:						bs->blueflagstatus = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 1
ASGNI4
line 4949
;4949:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4950
;4950:						break; //see BotMatch_CTF
ADDRGP4 $2141
JUMPV
LABELV $2172
line 4953
;4951:					case GTS_BLUE_TAKEN:
;4952:						//red flag is taken
;4953:						bs->redflagstatus = 1;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 1
ASGNI4
line 4954
;4954:						bs->flagstatuschanged = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6964
ADDP4
CNSTI4 1
ASGNI4
line 4955
;4955:						break; //see BotMatch_CTF
line 4957
;4956:				}
;4957:			}
line 4990
;4958:#ifdef MISSIONPACK
;4959:			else if (gametype == GT_1FCTF) {
;4960:				switch(state->eventParm) {
;4961:					case GTS_RED_CAPTURE:
;4962:						bs->neutralflagstatus = 0;
;4963:						bs->flagstatuschanged = qtrue;
;4964:						break;
;4965:					case GTS_BLUE_CAPTURE:
;4966:						bs->neutralflagstatus = 0;
;4967:						bs->flagstatuschanged = qtrue;
;4968:						break;
;4969:					case GTS_RED_RETURN:
;4970:						//flag has returned
;4971:						bs->neutralflagstatus = 0;
;4972:						bs->flagstatuschanged = qtrue;
;4973:						break;
;4974:					case GTS_BLUE_RETURN:
;4975:						//flag has returned
;4976:						bs->neutralflagstatus = 0;
;4977:						bs->flagstatuschanged = qtrue;
;4978:						break;
;4979:					case GTS_RED_TAKEN:
;4980:						bs->neutralflagstatus = BotTeam(bs) == TEAM_RED ? 2 : 1; //FIXME: check Team_TakeFlagSound in g_team.c
;4981:						bs->flagstatuschanged = qtrue;
;4982:						break;
;4983:					case GTS_BLUE_TAKEN:
;4984:						bs->neutralflagstatus = BotTeam(bs) == TEAM_BLUE ? 2 : 1; //FIXME: check Team_TakeFlagSound in g_team.c
;4985:						bs->flagstatuschanged = qtrue;
;4986:						break;
;4987:				}
;4988:			}
;4989:#endif
;4990:			break;
ADDRGP4 $2141
JUMPV
LABELV $2174
line 4993
;4991:		}
;4992:		case EV_PLAYER_TELEPORT_IN:
;4993:		{
line 4994
;4994:			VectorCopy(state->origin, lastteleport_origin);
ADDRGP4 lastteleport_origin
ADDRFP4 4
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 4995
;4995:			lastteleport_time = FloatTime();
ADDRGP4 lastteleport_time
ADDRGP4 floattime
INDIRF4
ASGNF4
line 4996
;4996:			break;
ADDRGP4 $2141
JUMPV
LABELV $2175
line 4999
;4997:		}
;4998:		case EV_GENERAL_SOUND:
;4999:		{
line 5001
;5000:			//if this sound is played on the bot
;5001:			if (state->number == bs->client) {
ADDRFP4 4
INDIRP4
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
NEI4 $2141
line 5002
;5002:				if (state->eventParm < 0 || state->eventParm > MAX_SOUNDS) {
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
CNSTI4 256
LEI4 $2178
LABELV $2180
line 5003
;5003:					BotAI_Print(PRT_ERROR, "EV_GENERAL_SOUND: eventParm (%d) out of range\n", state->eventParm);
CNSTI4 3
ARGI4
ADDRGP4 $2181
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
line 5004
;5004:					break;
ADDRGP4 $2141
JUMPV
LABELV $2178
line 5007
;5005:				}
;5006:				//check out the sound
;5007:				trap_GetConfigstring(CS_SOUNDS + state->eventParm, buf, sizeof(buf));
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
line 5009
;5008:				//if falling into a death pit
;5009:				if (!strcmp(buf, "*falling1.wav")) {
ADDRLP4 4
ARGP4
ADDRGP4 $2184
ARGP4
ADDRLP4 148
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
NEI4 $2141
line 5011
;5010:					//if the bot has a personal teleporter
;5011:					if (bs->inventory[INVENTORY_TELEPORTER] > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5072
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2141
line 5013
;5012:						//use the holdable item
;5013:						trap_EA_Use(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Use
CALLV
pop
line 5014
;5014:					}
line 5015
;5015:				}
line 5016
;5016:			}
line 5017
;5017:			break;
line 5044
;5018:		}
;5019:		case EV_FOOTSTEP:
;5020:		case EV_FOOTSTEP_METAL:
;5021:		case EV_FOOTSPLASH:
;5022:		case EV_FOOTWADE:
;5023:		case EV_SWIM:
;5024:		case EV_FALL_SHORT:
;5025:		case EV_FALL_MEDIUM:
;5026:		case EV_FALL_FAR:
;5027:		case EV_STEP_4:
;5028:		case EV_STEP_8:
;5029:		case EV_STEP_12:
;5030:		case EV_STEP_16:
;5031:		case EV_JUMP_PAD:
;5032:		case EV_JUMP:
;5033:		case EV_TAUNT:
;5034:		case EV_WATER_TOUCH:
;5035:		case EV_WATER_LEAVE:
;5036:		case EV_WATER_UNDER:
;5037:		case EV_WATER_CLEAR:
;5038:		case EV_ITEM_PICKUP:
;5039:		case EV_GLOBAL_ITEM_PICKUP:
;5040:		case EV_NOAMMO:
;5041:		case EV_CHANGE_WEAPON:
;5042:		case EV_FIRE_WEAPON:
;5043:			//FIXME: either add to sound queue or mark player as someone making noise
;5044:			break;
line 5060
;5045:		case EV_USE_ITEM0:
;5046:		case EV_USE_ITEM1:
;5047:		case EV_USE_ITEM2:
;5048:		case EV_USE_ITEM3:
;5049:		case EV_USE_ITEM4:
;5050:		case EV_USE_ITEM5:
;5051:		case EV_USE_ITEM6:
;5052:		case EV_USE_ITEM7:
;5053:		case EV_USE_ITEM8:
;5054:		case EV_USE_ITEM9:
;5055:		case EV_USE_ITEM10:
;5056:		case EV_USE_ITEM11:
;5057:		case EV_USE_ITEM12:
;5058:		case EV_USE_ITEM13:
;5059:		case EV_USE_ITEM14:
;5060:			break;
LABELV $2140
LABELV $2141
line 5062
;5061:	}
;5062:}
LABELV $2133
endproc BotCheckEvents 164 12
export BotCheckSnapshot
proc BotCheckSnapshot 216 16
line 5069
;5063:
;5064:/*
;5065:==================
;5066:BotCheckSnapshot
;5067:==================
;5068:*/
;5069:void BotCheckSnapshot(bot_state_t *bs) {
line 5074
;5070:	int ent;
;5071:	entityState_t state;
;5072:
;5073:	//remove all avoid spots
;5074:	trap_BotAddAvoidSpot(bs->ms, vec3_origin, 0, AVOID_CLEAR);
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
line 5076
;5075:	//reset kamikaze body
;5076:	bs->kamikazebody = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6256
ADDP4
CNSTI4 0
ASGNI4
line 5078
;5077:	//reset number of proxmines
;5078:	bs->numproxmines = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6516
ADDP4
CNSTI4 0
ASGNI4
line 5080
;5079:	//
;5080:	ent = 0;
ADDRLP4 208
CNSTI4 0
ASGNI4
ADDRGP4 $2193
JUMPV
LABELV $2192
line 5081
;5081:	while( ( ent = BotAI_GetSnapshotEntity( bs->client, ent, &state ) ) != -1 ) {
line 5083
;5082:		//check the entity state for events
;5083:		BotCheckEvents(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckEvents
CALLV
pop
line 5085
;5084:		//check for grenades the bot should avoid
;5085:		BotCheckForGrenades(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckForGrenades
CALLV
pop
line 5093
;5086:		//
;5087:#ifdef MISSIONPACK
;5088:		//check for proximity mines which the bot should deactivate
;5089:		BotCheckForProxMines(bs, &state);
;5090:		//check for dead bodies with the kamikaze effect which should be gibbed
;5091:		BotCheckForKamikazeBody(bs, &state);
;5092:#endif
;5093:	}
LABELV $2193
line 5081
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
NEI4 $2192
line 5095
;5094:	//check the player state for events
;5095:	BotAI_GetEntityState(bs->client, &state);
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
line 5097
;5096:	//copy the player state events to the entity state
;5097:	state.event = bs->cur_ps.externalEvent;
ADDRLP4 0+180
ADDRFP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
line 5098
;5098:	state.eventParm = bs->cur_ps.externalEventParm;
ADDRLP4 0+184
ADDRFP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
ASGNI4
line 5100
;5099:	//
;5100:	BotCheckEvents(bs, &state);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotCheckEvents
CALLV
pop
line 5101
;5101:}
LABELV $2191
endproc BotCheckSnapshot 216 16
export BotCheckAir
proc BotCheckAir 4 4
line 5108
;5102:
;5103:/*
;5104:==================
;5105:BotCheckAir
;5106:==================
;5107:*/
;5108:void BotCheckAir(bot_state_t *bs) {
line 5109
;5109:	if (bs->inventory[INVENTORY_ENVIRONMENTSUIT] <= 0) {
ADDRFP4 0
INDIRP4
CNSTI4 5096
ADDP4
INDIRI4
CNSTI4 0
GTI4 $2198
line 5110
;5110:		if (trap_AAS_PointContents(bs->eye) & (CONTENTS_WATER|CONTENTS_SLIME|CONTENTS_LAVA)) {
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
EQI4 $2200
line 5111
;5111:			return;
ADDRGP4 $2197
JUMPV
LABELV $2200
line 5113
;5112:		}
;5113:	}
LABELV $2198
line 5114
;5114:	bs->lastair_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6176
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5115
;5115:}
LABELV $2197
endproc BotCheckAir 4 4
export BotAlternateRoute
proc BotAlternateRoute 16 16
line 5122
;5116:
;5117:/*
;5118:==================
;5119:BotAlternateRoute
;5120:==================
;5121:*/
;5122:bot_goal_t *BotAlternateRoute(bot_state_t *bs, bot_goal_t *goal) {
line 5126
;5123:	int t;
;5124:
;5125:	// if the bot has an alternative route goal
;5126:	if (bs->altroutegoal.areanum) {
ADDRFP4 0
INDIRP4
CNSTI4 6692
ADDP4
INDIRI4
CNSTI4 0
EQI4 $2203
line 5128
;5127:		//
;5128:		if (bs->reachedaltroutegoal_time)
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
INDIRF4
CNSTF4 0
EQF4 $2205
line 5129
;5129:			return goal;
ADDRFP4 4
INDIRP4
RETP4
ADDRGP4 $2202
JUMPV
LABELV $2205
line 5131
;5130:		// travel time towards alternative route goal
;5131:		t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, bs->altroutegoal.areanum, bs->tfl);
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
line 5132
;5132:		if (t && t < 20) {
ADDRLP4 12
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $2207
ADDRLP4 12
INDIRI4
CNSTI4 20
GEI4 $2207
line 5134
;5133:			//BotAI_Print(PRT_MESSAGE, "reached alternate route goal\n");
;5134:			bs->reachedaltroutegoal_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 5135
;5135:		}
LABELV $2207
line 5136
;5136:		memcpy(goal, &bs->altroutegoal, sizeof(bot_goal_t));
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
line 5137
;5137:		return &bs->altroutegoal;
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
RETP4
ADDRGP4 $2202
JUMPV
LABELV $2203
line 5139
;5138:	}
;5139:	return goal;
ADDRFP4 4
INDIRP4
RETP4
LABELV $2202
endproc BotAlternateRoute 16 16
export BotGetAlternateRouteGoal
proc BotGetAlternateRouteGoal 24 0
line 5147
;5140:}
;5141:
;5142:/*
;5143:==================
;5144:BotGetAlternateRouteGoal
;5145:==================
;5146:*/
;5147:int BotGetAlternateRouteGoal(bot_state_t *bs, int base) {
line 5152
;5148:	aas_altroutegoal_t *altroutegoals;
;5149:	bot_goal_t *goal;
;5150:	int numaltroutegoals, rnd;
;5151:
;5152:	if (base == TEAM_RED) {
ADDRFP4 4
INDIRI4
CNSTI4 1
NEI4 $2210
line 5153
;5153:		altroutegoals = red_altroutegoals;
ADDRLP4 12
ADDRGP4 red_altroutegoals
ASGNP4
line 5154
;5154:		numaltroutegoals = red_numaltroutegoals;
ADDRLP4 4
ADDRGP4 red_numaltroutegoals
INDIRI4
ASGNI4
line 5155
;5155:	}
ADDRGP4 $2211
JUMPV
LABELV $2210
line 5156
;5156:	else {
line 5157
;5157:		altroutegoals = blue_altroutegoals;
ADDRLP4 12
ADDRGP4 blue_altroutegoals
ASGNP4
line 5158
;5158:		numaltroutegoals = blue_numaltroutegoals;
ADDRLP4 4
ADDRGP4 blue_numaltroutegoals
INDIRI4
ASGNI4
line 5159
;5159:	}
LABELV $2211
line 5160
;5160:	if (!numaltroutegoals)
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2212
line 5161
;5161:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2209
JUMPV
LABELV $2212
line 5162
;5162:	rnd = (float) random() * numaltroutegoals;
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
line 5163
;5163:	if (rnd >= numaltroutegoals)
ADDRLP4 8
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $2214
line 5164
;5164:		rnd = numaltroutegoals-1;
ADDRLP4 8
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $2214
line 5165
;5165:	goal = &bs->altroutegoal;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6680
ADDP4
ASGNP4
line 5166
;5166:	goal->areanum = altroutegoals[rnd].areanum;
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
line 5167
;5167:	VectorCopy(altroutegoals[rnd].origin, goal->origin);
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
line 5168
;5168:	VectorSet(goal->mins, -8, -8, -8);
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
line 5169
;5169:	VectorSet(goal->maxs, 8, 8, 8);
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
line 5170
;5170:	goal->entitynum = 0;
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
CNSTI4 0
ASGNI4
line 5171
;5171:	goal->iteminfo = 0;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 5172
;5172:	goal->number = 0;
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
CNSTI4 0
ASGNI4
line 5173
;5173:	goal->flags = 0;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 5175
;5174:	//
;5175:	bs->reachedaltroutegoal_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6736
ADDP4
CNSTF4 0
ASGNF4
line 5176
;5176:	return qtrue;
CNSTI4 1
RETI4
LABELV $2209
endproc BotGetAlternateRouteGoal 24 0
export BotSetupAlternativeRouteGoals
proc BotSetupAlternativeRouteGoals 0 0
line 5184
;5177:}
;5178:
;5179:/*
;5180:==================
;5181:BotSetupAlternateRouteGoals
;5182:==================
;5183:*/
;5184:void BotSetupAlternativeRouteGoals(void) {
line 5186
;5185:
;5186:	if (altroutegoals_setup)
ADDRGP4 altroutegoals_setup
INDIRI4
CNSTI4 0
EQI4 $2217
line 5187
;5187:		return;
ADDRGP4 $2216
JUMPV
LABELV $2217
line 5256
;5188:#ifdef MISSIONPACK
;5189:	if (gametype == GT_CTF) {
;5190:		if (trap_BotGetLevelItemGoal(-1, "Neutral Flag", &ctf_neutralflag) < 0)
;5191:			BotAI_Print(PRT_WARNING, "no alt routes without Neutral Flag\n");
;5192:		if (ctf_neutralflag.areanum) {
;5193:			//
;5194:			red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5195:										ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5196:										ctf_redflag.origin, ctf_redflag.areanum, TFL_DEFAULT,
;5197:										red_altroutegoals, MAX_ALTROUTEGOALS,
;5198:										ALTROUTEGOAL_CLUSTERPORTALS|
;5199:										ALTROUTEGOAL_VIEWPORTALS);
;5200:			blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5201:										ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5202:										ctf_blueflag.origin, ctf_blueflag.areanum, TFL_DEFAULT,
;5203:										blue_altroutegoals, MAX_ALTROUTEGOALS,
;5204:										ALTROUTEGOAL_CLUSTERPORTALS|
;5205:										ALTROUTEGOAL_VIEWPORTALS);
;5206:		}
;5207:	}
;5208:	else if (gametype == GT_1FCTF) {
;5209:		//
;5210:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5211:									ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5212:									ctf_redflag.origin, ctf_redflag.areanum, TFL_DEFAULT,
;5213:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5214:									ALTROUTEGOAL_CLUSTERPORTALS|
;5215:									ALTROUTEGOAL_VIEWPORTALS);
;5216:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5217:									ctf_neutralflag.origin, ctf_neutralflag.areanum,
;5218:									ctf_blueflag.origin, ctf_blueflag.areanum, TFL_DEFAULT,
;5219:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5220:									ALTROUTEGOAL_CLUSTERPORTALS|
;5221:									ALTROUTEGOAL_VIEWPORTALS);
;5222:	}
;5223:	else if (gametype == GT_OBELISK) {
;5224:		if (trap_BotGetLevelItemGoal(-1, "Neutral Obelisk", &neutralobelisk) < 0)
;5225:			BotAI_Print(PRT_WARNING, "Harvester without neutral obelisk\n");
;5226:		//
;5227:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5228:									neutralobelisk.origin, neutralobelisk.areanum,
;5229:									redobelisk.origin, redobelisk.areanum, TFL_DEFAULT,
;5230:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5231:									ALTROUTEGOAL_CLUSTERPORTALS|
;5232:									ALTROUTEGOAL_VIEWPORTALS);
;5233:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5234:									neutralobelisk.origin, neutralobelisk.areanum,
;5235:									blueobelisk.origin, blueobelisk.areanum, TFL_DEFAULT,
;5236:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5237:									ALTROUTEGOAL_CLUSTERPORTALS|
;5238:									ALTROUTEGOAL_VIEWPORTALS);
;5239:	}
;5240:	else if (gametype == GT_HARVESTER) {
;5241:		//
;5242:		red_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5243:									neutralobelisk.origin, neutralobelisk.areanum,
;5244:									redobelisk.origin, redobelisk.areanum, TFL_DEFAULT,
;5245:									red_altroutegoals, MAX_ALTROUTEGOALS,
;5246:									ALTROUTEGOAL_CLUSTERPORTALS|
;5247:									ALTROUTEGOAL_VIEWPORTALS);
;5248:		blue_numaltroutegoals = trap_AAS_AlternativeRouteGoals(
;5249:									neutralobelisk.origin, neutralobelisk.areanum,
;5250:									blueobelisk.origin, blueobelisk.areanum, TFL_DEFAULT,
;5251:									blue_altroutegoals, MAX_ALTROUTEGOALS,
;5252:									ALTROUTEGOAL_CLUSTERPORTALS|
;5253:									ALTROUTEGOAL_VIEWPORTALS);
;5254:	}
;5255:#endif
;5256:	altroutegoals_setup = qtrue;
ADDRGP4 altroutegoals_setup
CNSTI4 1
ASGNI4
line 5257
;5257:}
LABELV $2216
endproc BotSetupAlternativeRouteGoals 0 0
export BotDeathmatchAI
proc BotDeathmatchAI 1492 20
line 5264
;5258:
;5259:/*
;5260:==================
;5261:BotDeathmatchAI
;5262:==================
;5263:*/
;5264:void BotDeathmatchAI(bot_state_t *bs, float thinktime) {
line 5270
;5265:	char gender[144], name[144], buf[144];
;5266:	char userinfo[MAX_INFO_STRING];
;5267:	int i;
;5268:
;5269:	//if the bot has just been setup
;5270:	if (bs->setupcount > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2220
line 5271
;5271:		bs->setupcount--;
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
line 5272
;5272:		if (bs->setupcount > 0) return;
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
INDIRI4
CNSTI4 0
LEI4 $2222
ADDRGP4 $2219
JUMPV
LABELV $2222
line 5274
;5273:		//get the gender characteristic
;5274:		trap_Characteristic_String(bs->character, CHARACTERISTIC_GENDER, gender, sizeof(gender));
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
line 5276
;5275:		//set the bot gender
;5276:		trap_GetUserinfo(bs->client, userinfo, sizeof(userinfo));
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
line 5277
;5277:		Info_SetValueForKey(userinfo, "sex", gender);
ADDRLP4 292
ARGP4
ADDRGP4 $2224
ARGP4
ADDRLP4 148
ARGP4
ADDRGP4 Info_SetValueForKey
CALLV
pop
line 5278
;5278:		trap_SetUserinfo(bs->client, userinfo);
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
line 5280
;5279:		//set the team
;5280:		if ( !bs->map_restart && g_gametype.integer != GT_TOURNAMENT ) {
ADDRFP4 0
INDIRP4
CNSTI4 6020
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2225
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 1
EQI4 $2225
line 5281
;5281:			Com_sprintf(buf, sizeof(buf), "team %s", bs->settings.team);
ADDRLP4 1316
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 $2228
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 4756
ADDP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 5282
;5282:			trap_EA_Command(bs->client, buf);
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
line 5283
;5283:		}
LABELV $2225
line 5285
;5284:		//set the chat gender
;5285:		if (gender[0] == 'm') trap_BotSetChatGender(bs->cs, CHAT_GENDERMALE);
ADDRLP4 148
INDIRI1
CVII4 1
CNSTI4 109
NEI4 $2229
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
ADDRGP4 $2230
JUMPV
LABELV $2229
line 5286
;5286:		else if (gender[0] == 'f')  trap_BotSetChatGender(bs->cs, CHAT_GENDERFEMALE);
ADDRLP4 148
INDIRI1
CVII4 1
CNSTI4 102
NEI4 $2231
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
ADDRGP4 $2232
JUMPV
LABELV $2231
line 5287
;5287:		else  trap_BotSetChatGender(bs->cs, CHAT_GENDERLESS);
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
LABELV $2232
LABELV $2230
line 5289
;5288:		//set the chat name
;5289:		ClientName(bs->client, name, sizeof(name));
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
line 5290
;5290:		trap_BotSetChatName(bs->cs, name, bs->client);
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
line 5292
;5291:		//
;5292:		bs->lastframe_health = bs->inventory[INVENTORY_HEALTH];
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
line 5293
;5293:		bs->lasthitcount = bs->cur_ps.persistant[PERS_HITS];
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
line 5295
;5294:		//
;5295:		bs->setupcount = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6016
ADDP4
CNSTI4 0
ASGNI4
line 5297
;5296:		//
;5297:		BotSetupAlternativeRouteGoals();
ADDRGP4 BotSetupAlternativeRouteGoals
CALLV
pop
line 5298
;5298:	}
LABELV $2220
line 5300
;5299:	//no ideal view set
;5300:	bs->flags &= ~BFL_IDEALVIEWSET;
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
line 5302
;5301:	//
;5302:	if (!BotIntermission(bs)) {
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
NEI4 $2233
line 5304
;5303:		//set the teleport time
;5304:		BotSetTeleportTime(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetTeleportTime
CALLV
pop
line 5306
;5305:		//update some inventory values
;5306:		BotUpdateInventory(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotUpdateInventory
CALLV
pop
line 5308
;5307:		//check out the snapshot
;5308:		BotCheckSnapshot(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckSnapshot
CALLV
pop
line 5310
;5309:		//check for air
;5310:		BotCheckAir(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckAir
CALLV
pop
line 5311
;5311:	}
LABELV $2233
line 5313
;5312:	//check the console messages
;5313:	BotCheckConsoleMessages(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckConsoleMessages
CALLV
pop
line 5315
;5314:	//if not in the intermission and not in observer mode
;5315:	if (!BotIntermission(bs) && !BotIsObserver(bs)) {
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
NEI4 $2235
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
NEI4 $2235
line 5317
;5316:		//do team AI
;5317:		BotTeamAI(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotTeamAI
CALLV
pop
line 5318
;5318:	}
LABELV $2235
line 5320
;5319:	//if the bot has no ai node
;5320:	if (!bs->ainode) {
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $2237
line 5321
;5321:		AIEnter_Seek_LTG(bs, "BotDeathmatchAI: no ai node");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2239
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 5322
;5322:	}
LABELV $2237
line 5324
;5323:	//if the bot entered the game less than 8 seconds ago
;5324:	if (!bs->entergamechat && bs->entergame_time > FloatTime() - 8) {
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
NEI4 $2240
ADDRLP4 1476
INDIRP4
CNSTI4 6064
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1090519040
SUBF4
LEF4 $2240
line 5325
;5325:		if (BotChat_EnterGame(bs)) {
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
EQI4 $2242
line 5326
;5326:			bs->stand_time = FloatTime() + BotChatTime(bs);
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
line 5327
;5327:			AIEnter_Stand(bs, "BotDeathmatchAI: chat enter game");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $2244
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 5328
;5328:		}
LABELV $2242
line 5329
;5329:		bs->entergamechat = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6024
ADDP4
CNSTI4 1
ASGNI4
line 5330
;5330:	}
LABELV $2240
line 5332
;5331:	//reset the node switches from the previous frame
;5332:	BotResetNodeSwitches();
ADDRGP4 BotResetNodeSwitches
CALLV
pop
line 5334
;5333:	//execute AI nodes
;5334:	for (i = 0; i < MAX_NODESWITCHES; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $2245
line 5335
;5335:		if (bs->ainode(bs)) break;
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
EQI4 $2249
ADDRGP4 $2247
JUMPV
LABELV $2249
line 5336
;5336:	}
LABELV $2246
line 5334
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 50
LTI4 $2245
LABELV $2247
line 5338
;5337:	//if the bot removed itself :)
;5338:	if (!bs->inuse) return;
ADDRFP4 0
INDIRP4
INDIRI4
CNSTI4 0
NEI4 $2251
ADDRGP4 $2219
JUMPV
LABELV $2251
line 5340
;5339:	//if the bot executed too many AI nodes
;5340:	if (i >= MAX_NODESWITCHES) {
ADDRLP4 0
INDIRI4
CNSTI4 50
LTI4 $2253
line 5341
;5341:		trap_BotDumpGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotDumpGoalStack
CALLV
pop
line 5342
;5342:		trap_BotDumpAvoidGoals(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotDumpAvoidGoals
CALLV
pop
line 5343
;5343:		BotDumpNodeSwitches(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotDumpNodeSwitches
CALLV
pop
line 5344
;5344:		ClientName(bs->client, name, sizeof(name));
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
line 5345
;5345:		BotAI_Print(PRT_ERROR, "%s at %1.1f switched more than %d AI nodes\n", name, FloatTime(), MAX_NODESWITCHES);
CNSTI4 3
ARGI4
ADDRGP4 $2255
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
line 5346
;5346:	}
LABELV $2253
line 5348
;5347:	//
;5348:	bs->lastframe_health = bs->inventory[INVENTORY_HEALTH];
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
line 5349
;5349:	bs->lasthitcount = bs->cur_ps.persistant[PERS_HITS];
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
line 5350
;5350:}
LABELV $2219
endproc BotDeathmatchAI 1492 20
export BotSetEntityNumForGoalWithModel
proc BotSetEntityNumForGoalWithModel 44 4
line 5357
;5351:
;5352:/*
;5353:==================
;5354:BotSetEntityNumForGoalWithModel
;5355:==================
;5356:*/
;5357:void BotSetEntityNumForGoalWithModel(bot_goal_t *goal, int eType, char *modelname) {
line 5362
;5358:	gentity_t *ent;
;5359:	int i, modelindex;
;5360:	vec3_t dir;
;5361:
;5362:	modelindex = G_ModelIndex( modelname );
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
line 5363
;5363:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 5364
;5364:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $2260
JUMPV
LABELV $2257
line 5365
;5365:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2262
line 5366
;5366:			continue;
ADDRGP4 $2258
JUMPV
LABELV $2262
line 5368
;5367:		}
;5368:		if ( eType && ent->s.eType != eType) {
ADDRLP4 28
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
EQI4 $2264
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $2264
line 5369
;5369:			continue;
ADDRGP4 $2258
JUMPV
LABELV $2264
line 5371
;5370:		}
;5371:		if (ent->s.modelindex != modelindex) {
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
EQI4 $2266
line 5372
;5372:			continue;
ADDRGP4 $2258
JUMPV
LABELV $2266
line 5374
;5373:		}
;5374:		VectorSubtract(goal->origin, ent->s.origin, dir);
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
line 5375
;5375:		if (VectorLengthSquared(dir) < Square(10)) {
ADDRLP4 4
ARGP4
ADDRLP4 40
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 40
INDIRF4
CNSTF4 1120403456
GEF4 $2270
line 5376
;5376:			goal->entitynum = i;
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 5377
;5377:			return;
ADDRGP4 $2256
JUMPV
LABELV $2270
line 5379
;5378:		}
;5379:	}
LABELV $2258
line 5364
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
LABELV $2260
ADDRLP4 16
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $2257
line 5380
;5380:}
LABELV $2256
endproc BotSetEntityNumForGoalWithModel 44 4
export BotSetEntityNumForGoal
proc BotSetEntityNumForGoal 36 8
line 5387
;5381:
;5382:/*
;5383:==================
;5384:BotSetEntityNumForGoal
;5385:==================
;5386:*/
;5387:void BotSetEntityNumForGoal(bot_goal_t *goal, char *classname) {
line 5392
;5388:	gentity_t *ent;
;5389:	int i;
;5390:	vec3_t dir;
;5391:
;5392:	ent = &g_entities[0];
ADDRLP4 0
ADDRGP4 g_entities
ASGNP4
line 5393
;5393:	for (i = 0; i < level.num_entities; i++, ent++) {
ADDRLP4 16
CNSTI4 0
ASGNI4
ADDRGP4 $2276
JUMPV
LABELV $2273
line 5394
;5394:		if ( !ent->inuse ) {
ADDRLP4 0
INDIRP4
CNSTI4 520
ADDP4
INDIRI4
CNSTI4 0
NEI4 $2278
line 5395
;5395:			continue;
ADDRGP4 $2274
JUMPV
LABELV $2278
line 5397
;5396:		}
;5397:		if ( !Q_stricmp(ent->classname, classname) ) {
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
NEI4 $2280
line 5398
;5398:			continue;
ADDRGP4 $2274
JUMPV
LABELV $2280
line 5400
;5399:		}
;5400:		VectorSubtract(goal->origin, ent->s.origin, dir);
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
line 5401
;5401:		if (VectorLengthSquared(dir) < Square(10)) {
ADDRLP4 4
ARGP4
ADDRLP4 32
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 32
INDIRF4
CNSTF4 1120403456
GEF4 $2284
line 5402
;5402:			goal->entitynum = i;
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 16
INDIRI4
ASGNI4
line 5403
;5403:			return;
ADDRGP4 $2272
JUMPV
LABELV $2284
line 5405
;5404:		}
;5405:	}
LABELV $2274
line 5393
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
LABELV $2276
ADDRLP4 16
INDIRI4
ADDRGP4 level+12
INDIRI4
LTI4 $2273
line 5406
;5406:}
LABELV $2272
endproc BotSetEntityNumForGoal 36 8
export BotGoalForBSPEntity
proc BotGoalForBSPEntity 1128 20
line 5413
;5407:
;5408:/*
;5409:==================
;5410:BotGoalForBSPEntity
;5411:==================
;5412:*/
;5413:int BotGoalForBSPEntity( char *classname, bot_goal_t *goal ) {
line 5418
;5414:	char value[MAX_INFO_STRING];
;5415:	vec3_t origin, start, end;
;5416:	int ent, numareas, areas[10];
;5417:
;5418:	memset(goal, 0, sizeof(bot_goal_t));
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
line 5419
;5419:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
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
ADDRGP4 $2290
JUMPV
LABELV $2287
line 5420
;5420:		if (!trap_AAS_ValueForBSPEpairKey(ent, "classname", value, sizeof(value)))
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1854
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
NEI4 $2291
line 5421
;5421:			continue;
ADDRGP4 $2288
JUMPV
LABELV $2291
line 5422
;5422:		if (!strcmp(value, classname)) {
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
NEI4 $2293
line 5423
;5423:			if (!trap_AAS_VectorForBSPEpairKey(ent, "origin", origin))
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $1870
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
NEI4 $2295
line 5424
;5424:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2286
JUMPV
LABELV $2295
line 5425
;5425:			VectorCopy(origin, goal->origin);
ADDRFP4 4
INDIRP4
ADDRLP4 1028
INDIRB
ASGNB 12
line 5426
;5426:			VectorCopy(origin, start);
ADDRLP4 1040
ADDRLP4 1028
INDIRB
ASGNB 12
line 5427
;5427:			start[2] -= 32;
ADDRLP4 1040+8
ADDRLP4 1040+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 5428
;5428:			VectorCopy(origin, end);
ADDRLP4 1052
ADDRLP4 1028
INDIRB
ASGNB 12
line 5429
;5429:			end[2] += 32;
ADDRLP4 1052+8
ADDRLP4 1052+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 5430
;5430:			numareas = trap_AAS_TraceAreas(start, end, areas, NULL, 10);
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
line 5431
;5431:			if (!numareas)
ADDRLP4 1064
INDIRI4
CNSTI4 0
NEI4 $2299
line 5432
;5432:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2286
JUMPV
LABELV $2299
line 5433
;5433:			goal->areanum = areas[0];
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 1068
INDIRI4
ASGNI4
line 5434
;5434:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $2286
JUMPV
LABELV $2293
line 5436
;5435:		}
;5436:	}
LABELV $2288
line 5419
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
LABELV $2290
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $2287
line 5437
;5437:	return qfalse;
CNSTI4 0
RETI4
LABELV $2286
endproc BotGoalForBSPEntity 1128 20
proc BotAutoCTFFindReachableArea 120 20
line 5447
;5438:}
;5439:
;5440:/*
;5441:========================
;5442:BotAutoCTFFindReachableArea
;5443:========================
;5444:*/
;5445:static int BotAutoCTFFindReachableArea(
;5446:	vec3_t origin
;5447:) {
line 5455
;5448:	int area;
;5449:	int areas[16];
;5450:	int numAreas;
;5451:	int i;
;5452:	vec3_t start;
;5453:	vec3_t end;
;5454:
;5455:	area = trap_AAS_PointAreaNum( origin );
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
line 5457
;5456:
;5457:	if( area &&
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $2302
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
EQI4 $2302
line 5458
;5458:		trap_AAS_AreaReachability(area) ) {
line 5459
;5459:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $2301
JUMPV
LABELV $2302
line 5462
;5460:	}
;5461:
;5462:	VectorCopy( origin, start );
ADDRLP4 76
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 5463
;5463:	VectorCopy( origin, end );
ADDRLP4 88
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 5465
;5464:
;5465:	start[2] -= 64.0f;
ADDRLP4 76+8
ADDRLP4 76+8
INDIRF4
CNSTF4 1115684864
SUBF4
ASGNF4
line 5466
;5466:	end[2] += 64.0f;
ADDRLP4 88+8
ADDRLP4 88+8
INDIRF4
CNSTF4 1115684864
ADDF4
ASGNF4
line 5468
;5467:
;5468:	numAreas = trap_AAS_TraceAreas(
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
line 5476
;5469:		start,
;5470:		end,
;5471:		areas,
;5472:		NULL,
;5473:		16
;5474:	);
;5475:
;5476:	for( i = 0; i < numAreas; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $2309
JUMPV
LABELV $2306
line 5477
;5477:		if( trap_AAS_AreaReachability(areas[i]) ) {
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
EQI4 $2310
line 5478
;5478:			return areas[i];
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
RETI4
ADDRGP4 $2301
JUMPV
LABELV $2310
line 5480
;5479:		}
;5480:	}
LABELV $2307
line 5476
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $2309
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $2306
line 5482
;5481:
;5482:	return 0;
CNSTI4 0
RETI4
LABELV $2301
endproc BotAutoCTFFindReachableArea 120 20
proc BotSetupAutoCTFFlagGoal 20 12
line 5494
;5483:}
;5484:
;5485:/*
;5486:========================
;5487:BotSetupAutoCTFFlagGoal
;5488:========================
;5489:*/
;5490:static qboolean BotSetupAutoCTFFlagGoal(
;5491:	const char *classname,
;5492:	bot_goal_t *goal,
;5493:	int goalNumber
;5494:) {
line 5498
;5495:	gentity_t *flag;
;5496:	int area;
;5497:
;5498:	flag = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $2314
JUMPV
LABELV $2313
line 5504
;5499:
;5500:	while( (flag = G_Find(
;5501:		flag,
;5502:		FOFS(classname),
;5503:		classname
;5504:	)) != NULL ) {
line 5505
;5505:		if( !(flag->flags & FL_DROPPED_ITEM) ) {
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
CNSTI4 0
NEI4 $2316
line 5506
;5506:			break;
ADDRGP4 $2315
JUMPV
LABELV $2316
line 5508
;5507:		}
;5508:	}
LABELV $2314
line 5500
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
NEU4 $2313
LABELV $2315
line 5510
;5509:
;5510:	if( !flag ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $2318
line 5511
;5511:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2312
JUMPV
LABELV $2318
line 5514
;5512:	}
;5513:
;5514:	area = BotAutoCTFFindReachableArea(
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
line 5518
;5515:		flag->r.currentOrigin
;5516:	);
;5517:
;5518:	if( !area ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2320
line 5519
;5519:		area = BotAutoCTFFindReachableArea(
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
line 5522
;5520:			flag->s.origin
;5521:		);
;5522:	}
LABELV $2320
line 5524
;5523:
;5524:	if( !area ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $2322
line 5525
;5525:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $2312
JUMPV
LABELV $2322
line 5528
;5526:	}
;5527:
;5528:	memset( goal, 0, sizeof(*goal) );
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
line 5530
;5529:
;5530:	VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 488
ADDP4
INDIRB
ASGNB 12
line 5539
;5531:		flag->r.currentOrigin,
;5532:		goal->origin
;5533:	);
;5534:
;5535:	/*
;5536:	 * During early initialization currentOrigin can still
;5537:	 * contain zeroes. In that case use the entity origin.
;5538:	 */
;5539:	if( VectorLengthSquared(goal->origin) < 1.0f ) {
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
GEF4 $2324
line 5540
;5540:		VectorCopy(
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
line 5544
;5541:			flag->s.origin,
;5542:			goal->origin
;5543:		);
;5544:	}
LABELV $2324
line 5546
;5545:
;5546:	goal->areanum = area;
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 4
INDIRI4
ASGNI4
line 5548
;5547:
;5548:	VectorSet(
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
line 5555
;5549:		goal->mins,
;5550:		-24.0f,
;5551:		-24.0f,
;5552:		-24.0f
;5553:	);
;5554:
;5555:	VectorSet(
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
line 5562
;5556:		goal->maxs,
;5557:		24.0f,
;5558:		24.0f,
;5559:		40.0f
;5560:	);
;5561:
;5562:	goal->entitynum = flag - g_entities;
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
CNSTI4 808
DIVI4
ASGNI4
line 5563
;5563:	goal->number = goalNumber;
ADDRFP4 4
INDIRP4
CNSTI4 44
ADDP4
ADDRFP4 8
INDIRI4
ASGNI4
line 5564
;5564:	goal->flags = 0;
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 0
ASGNI4
line 5565
;5565:	goal->iteminfo = 0;
ADDRFP4 4
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 5567
;5566:
;5567:	return qtrue;
CNSTI4 1
RETI4
LABELV $2312
endproc BotSetupAutoCTFFlagGoal 20 12
export BotSetupDeathmatchAI
proc BotSetupDeathmatchAI 160 16
line 5575
;5568:}
;5569:
;5570:/*
;5571:==================
;5572:BotSetupDeathmatchAI
;5573:==================
;5574:*/
;5575:void BotSetupDeathmatchAI(void) {
line 5579
;5576:	int ent, modelnum;
;5577:	char model[128];
;5578:
;5579:	gametype = trap_Cvar_VariableIntegerValue("g_gametype");
ADDRGP4 $2327
ARGP4
ADDRLP4 136
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 gametype
ADDRLP4 136
INDIRI4
ASGNI4
line 5580
;5580:	maxclients = trap_Cvar_VariableIntegerValue("sv_maxclients");
ADDRGP4 $282
ARGP4
ADDRLP4 140
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRGP4 maxclients
ADDRLP4 140
INDIRI4
ASGNI4
line 5582
;5581:
;5582:	trap_Cvar_Register(&bot_rocketjump, "bot_rocketjump", "1", 0);
ADDRGP4 bot_rocketjump
ARGP4
ADDRGP4 $2328
ARGP4
ADDRGP4 $2117
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5583
;5583:	trap_Cvar_Register(&bot_grapple, "bot_grapple", "0", 0);
ADDRGP4 bot_grapple
ARGP4
ADDRGP4 $2329
ARGP4
ADDRGP4 $2330
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5584
;5584:	trap_Cvar_Register(&bot_fastchat, "bot_fastchat", "0", 0);
ADDRGP4 bot_fastchat
ARGP4
ADDRGP4 $2331
ARGP4
ADDRGP4 $2330
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5585
;5585:	trap_Cvar_Register(&bot_nochat, "bot_nochat", "0", 0);
ADDRGP4 bot_nochat
ARGP4
ADDRGP4 $2332
ARGP4
ADDRGP4 $2330
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5586
;5586:	trap_Cvar_Register(&bot_testrchat, "bot_testrchat", "0", 0);
ADDRGP4 bot_testrchat
ARGP4
ADDRGP4 $2116
ARGP4
ADDRGP4 $2330
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5587
;5587:	trap_Cvar_Register(&bot_challenge, "bot_challenge", "0", 0);
ADDRGP4 bot_challenge
ARGP4
ADDRGP4 $2333
ARGP4
ADDRGP4 $2330
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5588
;5588:	trap_Cvar_Register(&bot_predictobstacles, "bot_predictobstacles", "1", 0);
ADDRGP4 bot_predictobstacles
ARGP4
ADDRGP4 $2334
ARGP4
ADDRGP4 $2117
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5589
;5589:	trap_Cvar_Register(&g_spSkill, "g_spSkill", "2", 0);
ADDRGP4 g_spSkill
ARGP4
ADDRGP4 $2335
ARGP4
ADDRGP4 $2336
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 trap_Cvar_Register
CALLV
pop
line 5591
;5590:	//
;5591:	if( gametype == GT_CTF ) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $2337
line 5592
;5592:		if( trap_BotGetLevelItemGoal(
CNSTI4 -1
ARGI4
ADDRGP4 $2341
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
GEI4 $2339
line 5596
;5593:			-1,
;5594:			"Red Flag",
;5595:			&ctf_redflag
;5596:		) < 0 ) {
line 5597
;5597:			if( trap_Cvar_VariableIntegerValue(
ADDRGP4 $2344
ARGP4
ADDRLP4 148
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
EQI4 $2342
ADDRGP4 $2345
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
EQI4 $2342
line 5604
;5598:				"g_autoCTF"
;5599:			) &&
;5600:				BotSetupAutoCTFFlagGoal(
;5601:					"team_CTF_redflag",
;5602:					&ctf_redflag,
;5603:					10001
;5604:				) ) {
line 5605
;5605:				BotAI_Print(
CNSTI4 1
ARGI4
ADDRGP4 $2346
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5609
;5606:					PRT_MESSAGE,
;5607:					"Auto CTF: Red Flag bot goal created.\n"
;5608:				);
;5609:			}
ADDRGP4 $2343
JUMPV
LABELV $2342
line 5610
;5610:			else {
line 5611
;5611:				BotAI_Print(
CNSTI4 2
ARGI4
ADDRGP4 $2347
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5615
;5612:					PRT_WARNING,
;5613:					"CTF without reachable Red Flag\n"
;5614:				);
;5615:			}
LABELV $2343
line 5616
;5616:		}
LABELV $2339
line 5618
;5617:
;5618:		if( trap_BotGetLevelItemGoal(
CNSTI4 -1
ARGI4
ADDRGP4 $2350
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
GEI4 $2348
line 5622
;5619:			-1,
;5620:			"Blue Flag",
;5621:			&ctf_blueflag
;5622:		) < 0 ) {
line 5623
;5623:			if( trap_Cvar_VariableIntegerValue(
ADDRGP4 $2344
ARGP4
ADDRLP4 152
ADDRGP4 trap_Cvar_VariableIntegerValue
CALLI4
ASGNI4
ADDRLP4 152
INDIRI4
CNSTI4 0
EQI4 $2351
ADDRGP4 $2353
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
EQI4 $2351
line 5630
;5624:				"g_autoCTF"
;5625:			) &&
;5626:				BotSetupAutoCTFFlagGoal(
;5627:					"team_CTF_blueflag",
;5628:					&ctf_blueflag,
;5629:					10002
;5630:				) ) {
line 5631
;5631:				BotAI_Print(
CNSTI4 1
ARGI4
ADDRGP4 $2354
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5635
;5632:					PRT_MESSAGE,
;5633:					"Auto CTF: Blue Flag bot goal created.\n"
;5634:				);
;5635:			}
ADDRGP4 $2352
JUMPV
LABELV $2351
line 5636
;5636:			else {
line 5637
;5637:				BotAI_Print(
CNSTI4 2
ARGI4
ADDRGP4 $2355
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 5641
;5638:					PRT_WARNING,
;5639:					"CTF without reachable Blue Flag\n"
;5640:				);
;5641:			}
LABELV $2352
line 5642
;5642:		}
LABELV $2348
line 5643
;5643:	}
LABELV $2337
line 5674
;5644:#ifdef MISSIONPACK
;5645:	else if (gametype == GT_1FCTF) {
;5646:		if (trap_BotGetLevelItemGoal(-1, "Neutral Flag", &ctf_neutralflag) < 0)
;5647:			BotAI_Print(PRT_WARNING, "One Flag CTF without Neutral Flag\n");
;5648:		if (trap_BotGetLevelItemGoal(-1, "Red Flag", &ctf_redflag) < 0)
;5649:			BotAI_Print(PRT_WARNING, "CTF without Red Flag\n");
;5650:		if (trap_BotGetLevelItemGoal(-1, "Blue Flag", &ctf_blueflag) < 0)
;5651:			BotAI_Print(PRT_WARNING, "CTF without Blue Flag\n");
;5652:	}
;5653:	else if (gametype == GT_OBELISK) {
;5654:		if (trap_BotGetLevelItemGoal(-1, "Red Obelisk", &redobelisk) < 0)
;5655:			BotAI_Print(PRT_WARNING, "Obelisk without red obelisk\n");
;5656:		BotSetEntityNumForGoal(&redobelisk, "team_redobelisk");
;5657:		if (trap_BotGetLevelItemGoal(-1, "Blue Obelisk", &blueobelisk) < 0)
;5658:			BotAI_Print(PRT_WARNING, "Obelisk without blue obelisk\n");
;5659:		BotSetEntityNumForGoal(&blueobelisk, "team_blueobelisk");
;5660:	}
;5661:	else if (gametype == GT_HARVESTER) {
;5662:		if (trap_BotGetLevelItemGoal(-1, "Red Obelisk", &redobelisk) < 0)
;5663:			BotAI_Print(PRT_WARNING, "Harvester without red obelisk\n");
;5664:		BotSetEntityNumForGoal(&redobelisk, "team_redobelisk");
;5665:		if (trap_BotGetLevelItemGoal(-1, "Blue Obelisk", &blueobelisk) < 0)
;5666:			BotAI_Print(PRT_WARNING, "Harvester without blue obelisk\n");
;5667:		BotSetEntityNumForGoal(&blueobelisk, "team_blueobelisk");
;5668:		if (trap_BotGetLevelItemGoal(-1, "Neutral Obelisk", &neutralobelisk) < 0)
;5669:			BotAI_Print(PRT_WARNING, "Harvester without neutral obelisk\n");
;5670:		BotSetEntityNumForGoal(&neutralobelisk, "team_neutralobelisk");
;5671:	}
;5672:#endif
;5673:
;5674:	max_bspmodelindex = 0;
ADDRGP4 max_bspmodelindex
CNSTI4 0
ASGNI4
line 5675
;5675:	for (ent = trap_AAS_NextBSPEntity(0); ent; ent = trap_AAS_NextBSPEntity(ent)) {
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
ADDRGP4 $2359
JUMPV
LABELV $2356
line 5676
;5676:		if (!trap_AAS_ValueForBSPEpairKey(ent, "model", model, sizeof(model))) continue;
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $277
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
NEI4 $2360
ADDRGP4 $2357
JUMPV
LABELV $2360
line 5677
;5677:		if (model[0] == '*') {
ADDRLP4 4
INDIRI1
CVII4 1
CNSTI4 42
NEI4 $2362
line 5678
;5678:			modelnum = atoi(model+1);
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
line 5679
;5679:			if (modelnum > max_bspmodelindex)
ADDRLP4 132
INDIRI4
ADDRGP4 max_bspmodelindex
INDIRI4
LEI4 $2365
line 5680
;5680:				max_bspmodelindex = modelnum;
ADDRGP4 max_bspmodelindex
ADDRLP4 132
INDIRI4
ASGNI4
LABELV $2365
line 5681
;5681:		}
LABELV $2362
line 5682
;5682:	}
LABELV $2357
line 5675
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
LABELV $2359
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $2356
line 5684
;5683:	//initialize the waypoint heap
;5684:	BotInitWaypoints();
ADDRGP4 BotInitWaypoints
CALLV
pop
line 5685
;5685:}
LABELV $2326
endproc BotSetupDeathmatchAI 160 16
export BotShutdownDeathmatchAI
proc BotShutdownDeathmatchAI 0 0
line 5692
;5686:
;5687:/*
;5688:==================
;5689:BotShutdownDeathmatchAI
;5690:==================
;5691:*/
;5692:void BotShutdownDeathmatchAI(void) {
line 5693
;5693:	altroutegoals_setup = qfalse;
ADDRGP4 altroutegoals_setup
CNSTI4 0
ASGNI4
line 5694
;5694:}
LABELV $2367
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
import G_FindAutomaticBaseSpots
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
LABELV $2355
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
LABELV $2354
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
LABELV $2353
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
LABELV $2350
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
LABELV $2347
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
LABELV $2346
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
LABELV $2345
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
LABELV $2344
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
LABELV $2341
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
LABELV $2336
byte 1 50
byte 1 0
align 1
LABELV $2335
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
LABELV $2334
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
LABELV $2333
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
LABELV $2332
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
LABELV $2331
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
LABELV $2330
byte 1 48
byte 1 0
align 1
LABELV $2329
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
LABELV $2328
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
LABELV $2327
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
LABELV $2255
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
LABELV $2244
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
LABELV $2239
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
LABELV $2228
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $2224
byte 1 115
byte 1 101
byte 1 120
byte 1 0
align 1
LABELV $2184
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
LABELV $2181
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
LABELV $2160
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
LABELV $2157
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
LABELV $2128
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
LABELV $2121
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
LABELV $2120
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
LABELV $2117
byte 1 49
byte 1 0
align 1
LABELV $2116
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
LABELV $1982
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
LABELV $1981
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
LABELV $1977
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
LABELV $1965
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
LABELV $1964
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
LABELV $1961
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
LABELV $1950
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
LABELV $1937
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
LABELV $1931
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
LABELV $1923
byte 1 116
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $1912
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
LABELV $1908
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
LABELV $1905
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
LABELV $1870
byte 1 111
byte 1 114
byte 1 105
byte 1 103
byte 1 105
byte 1 110
byte 1 0
align 1
LABELV $1865
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
LABELV $1860
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
LABELV $1857
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
LABELV $1854
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
LABELV $1853
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
LABELV $1841
byte 1 42
byte 1 37
byte 1 100
byte 1 0
align 1
LABELV $1656
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 0
align 1
LABELV $1633
byte 1 97
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $1630
byte 1 108
byte 1 105
byte 1 112
byte 1 0
align 1
LABELV $1592
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
LABELV $1537
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
LABELV $1533
byte 1 109
byte 1 97
byte 1 112
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $687
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
LABELV $686
byte 1 83
byte 1 112
byte 1 101
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $685
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
LABELV $684
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
LABELV $683
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
LABELV $516
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
LABELV $327
byte 1 93
byte 1 0
align 1
LABELV $326
byte 1 91
byte 1 0
align 1
LABELV $325
byte 1 32
byte 1 0
align 1
LABELV $282
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
LABELV $277
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
align 1
LABELV $276
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
LABELV $271
byte 1 110
byte 1 0
align 1
LABELV $270
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
LABELV $269
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
