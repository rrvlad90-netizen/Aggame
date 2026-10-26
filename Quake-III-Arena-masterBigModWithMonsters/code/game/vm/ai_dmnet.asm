export BotResetNodeSwitches
code
proc BotResetNodeSwitches 0 0
file "../ai_dmnet.c"
line 72
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
;25: * name:		ai_dmnet.c
;26: *
;27: * desc:		Quake3 bot AI
;28: *
;29: * $Archive: /MissionPack/code/game/ai_dmnet.c $
;30: *
;31: *****************************************************************************/
;32:
;33:#include "g_local.h"
;34:#include "botlib.h"
;35:#include "be_aas.h"
;36:#include "be_ea.h"
;37:#include "be_ai_char.h"
;38:#include "be_ai_chat.h"
;39:#include "be_ai_gen.h"
;40:#include "be_ai_goal.h"
;41:#include "be_ai_move.h"
;42:#include "be_ai_weap.h"
;43://
;44:#include "ai_main.h"
;45:#include "ai_dmq3.h"
;46:#include "ai_chat.h"
;47:#include "ai_cmd.h"
;48:#include "ai_dmnet.h"
;49:#include "ai_team.h"
;50://data file headers
;51:#include "chars.h"			//characteristics
;52:#include "inv.h"			//indexes into the inventory
;53:#include "syn.h"			//synonyms
;54:#include "match.h"			//string matching types and vars
;55:
;56:// for the voice chats
;57:#include "../../ui/menudef.h"
;58:
;59://goal flag, see be_ai_goal.h for the other GFL_*
;60:#define GFL_AIR			128
;61:
;62:int numnodeswitches;
;63:char nodeswitch[MAX_NODESWITCHES+1][144];
;64:
;65:#define LOOKAHEAD_DISTANCE			300
;66:
;67:/*
;68:==================
;69:BotResetNodeSwitches
;70:==================
;71:*/
;72:void BotResetNodeSwitches(void) {
line 73
;73:	numnodeswitches = 0;
ADDRGP4 numnodeswitches
CNSTI4 0
ASGNI4
line 74
;74:}
LABELV $57
endproc BotResetNodeSwitches 0 0
export BotDumpNodeSwitches
proc BotDumpNodeSwitches 40 20
line 81
;75:
;76:/*
;77:==================
;78:BotDumpNodeSwitches
;79:==================
;80:*/
;81:void BotDumpNodeSwitches(bot_state_t *bs) {
line 85
;82:	int i;
;83:	char netname[MAX_NETNAME];
;84:
;85:	ClientName(bs->client, netname, sizeof(netname));
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 36
ARGI4
ADDRGP4 ClientName
CALLP4
pop
line 86
;86:	BotAI_Print(PRT_MESSAGE, "%s at %1.1f switched more than %d AI nodes\n", netname, FloatTime(), MAX_NODESWITCHES);
CNSTI4 1
ARGI4
ADDRGP4 $59
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
line 87
;87:	for (i = 0; i < numnodeswitches; i++) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $63
JUMPV
LABELV $60
line 88
;88:		BotAI_Print(PRT_MESSAGE, nodeswitch[i]);
CNSTI4 1
ARGI4
CNSTI4 144
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 nodeswitch
ADDP4
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 89
;89:	}
LABELV $61
line 87
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $63
ADDRLP4 0
INDIRI4
ADDRGP4 numnodeswitches
INDIRI4
LTI4 $60
line 90
;90:	BotAI_Print(PRT_FATAL, "");
CNSTI4 4
ARGI4
ADDRGP4 $64
ARGP4
ADDRGP4 BotAI_Print
CALLV
pop
line 91
;91:}
LABELV $58
endproc BotDumpNodeSwitches 40 20
export BotRecordNodeSwitch
proc BotRecordNodeSwitch 44 32
line 98
;92:
;93:/*
;94:==================
;95:BotRecordNodeSwitch
;96:==================
;97:*/
;98:void BotRecordNodeSwitch(bot_state_t *bs, char *node, char *str, char *s) {
line 101
;99:	char netname[MAX_NETNAME];
;100:
;101:	ClientName(bs->client, netname, sizeof(netname));
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
line 102
;102:	Com_sprintf(nodeswitch[numnodeswitches], 144, "%s at %2.1f entered %s: %s from %s\n", netname, FloatTime(), node, str, s);
ADDRLP4 36
CNSTI4 144
ASGNI4
ADDRLP4 36
INDIRI4
ADDRGP4 numnodeswitches
INDIRI4
MULI4
ADDRGP4 nodeswitch
ADDP4
ARGP4
ADDRLP4 36
INDIRI4
ARGI4
ADDRGP4 $66
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 floattime
INDIRF4
ARGF4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
line 108
;103:#ifdef DEBUG
;104:	if (0) {
;105:		BotAI_Print(PRT_MESSAGE, nodeswitch[numnodeswitches]);
;106:	}
;107:#endif //DEBUG
;108:	numnodeswitches++;
ADDRLP4 40
ADDRGP4 numnodeswitches
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 109
;109:}
LABELV $65
endproc BotRecordNodeSwitch 44 32
lit
align 4
LABELV $68
byte 4 3245342720
byte 4 3245342720
byte 4 3221225472
align 4
LABELV $69
byte 4 1097859072
byte 4 1097859072
byte 4 1073741824
export BotGetAirGoal
code
proc BotGetAirGoal 140 28
line 116
;110:
;111:/*
;112:==================
;113:BotGetAirGoal
;114:==================
;115:*/
;116:int BotGetAirGoal(bot_state_t *bs, bot_goal_t *goal) {
line 118
;117:	bsp_trace_t bsptrace;
;118:	vec3_t end, mins = {-15, -15, -2}, maxs = {15, 15, 2};
ADDRLP4 96
ADDRGP4 $68
INDIRB
ASGNB 12
ADDRLP4 108
ADDRGP4 $69
INDIRB
ASGNB 12
line 122
;119:	int areanum;
;120:
;121:	//trace up until we hit solid
;122:	VectorCopy(bs->origin, end);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRB
ASGNB 12
line 123
;123:	end[2] += 1000;
ADDRLP4 0+8
ADDRLP4 0+8
INDIRF4
CNSTF4 1148846080
ADDF4
ASGNF4
line 124
;124:	BotAI_Trace(&bsptrace, bs->origin, mins, maxs, end, bs->entitynum, CONTENTS_SOLID|CONTENTS_PLAYERCLIP);
ADDRLP4 12
ARGP4
ADDRLP4 124
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 124
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 96
ARGP4
ADDRLP4 108
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 124
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 65537
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 126
;125:	//trace down until we hit water
;126:	VectorCopy(bsptrace.endpos, end);
ADDRLP4 0
ADDRLP4 12+12
INDIRB
ASGNB 12
line 127
;127:	BotAI_Trace(&bsptrace, end, mins, maxs, bs->origin, bs->entitynum, CONTENTS_WATER|CONTENTS_SLIME|CONTENTS_LAVA);
ADDRLP4 12
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 96
ARGP4
ADDRLP4 108
ARGP4
ADDRLP4 128
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 128
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 128
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
CNSTI4 56
ARGI4
ADDRGP4 BotAI_Trace
CALLV
pop
line 129
;128:	//if we found the water surface
;129:	if (bsptrace.fraction > 0) {
ADDRLP4 12+8
INDIRF4
CNSTF4 0
LEF4 $72
line 130
;130:		areanum = BotPointAreaNum(bsptrace.endpos);
ADDRLP4 12+12
ARGP4
ADDRLP4 132
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 120
ADDRLP4 132
INDIRI4
ASGNI4
line 131
;131:		if (areanum) {
ADDRLP4 120
INDIRI4
CNSTI4 0
EQI4 $76
line 132
;132:			VectorCopy(bsptrace.endpos, goal->origin);
ADDRFP4 4
INDIRP4
ADDRLP4 12+12
INDIRB
ASGNB 12
line 133
;133:			goal->origin[2] -= 2;
ADDRLP4 136
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 136
INDIRP4
ADDRLP4 136
INDIRP4
INDIRF4
CNSTF4 1073741824
SUBF4
ASGNF4
line 134
;134:			goal->areanum = areanum;
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
ADDRLP4 120
INDIRI4
ASGNI4
line 135
;135:			goal->mins[0] = -15;
ADDRFP4 4
INDIRP4
CNSTI4 16
ADDP4
CNSTF4 3245342720
ASGNF4
line 136
;136:			goal->mins[1] = -15;
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
CNSTF4 3245342720
ASGNF4
line 137
;137:			goal->mins[2] = -1;
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTF4 3212836864
ASGNF4
line 138
;138:			goal->maxs[0] = 15;
ADDRFP4 4
INDIRP4
CNSTI4 28
ADDP4
CNSTF4 1097859072
ASGNF4
line 139
;139:			goal->maxs[1] = 15;
ADDRFP4 4
INDIRP4
CNSTI4 32
ADDP4
CNSTF4 1097859072
ASGNF4
line 140
;140:			goal->maxs[2] = 1;
ADDRFP4 4
INDIRP4
CNSTI4 36
ADDP4
CNSTF4 1065353216
ASGNF4
line 141
;141:			goal->flags = GFL_AIR;
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 128
ASGNI4
line 142
;142:			goal->number = 0;
ADDRFP4 4
INDIRP4
CNSTI4 44
ADDP4
CNSTI4 0
ASGNI4
line 143
;143:			goal->iteminfo = 0;
ADDRFP4 4
INDIRP4
CNSTI4 52
ADDP4
CNSTI4 0
ASGNI4
line 144
;144:			goal->entitynum = 0;
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
CNSTI4 0
ASGNI4
line 145
;145:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $67
JUMPV
LABELV $76
line 147
;146:		}
;147:	}
LABELV $72
line 148
;148:	return qfalse;
CNSTI4 0
RETI4
LABELV $67
endproc BotGetAirGoal 140 28
export BotGoForAir
proc BotGoForAir 68 24
line 156
;149:}
;150:
;151:/*
;152:==================
;153:BotGoForAir
;154:==================
;155:*/
;156:int BotGoForAir(bot_state_t *bs, int tfl, bot_goal_t *ltg, float range) {
line 160
;157:	bot_goal_t goal;
;158:
;159:	//if the bot needs air
;160:	if (bs->lastair_time < FloatTime() - 6) {
ADDRFP4 0
INDIRP4
CNSTI4 6176
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1086324736
SUBF4
GEF4 $80
line 166
;161:		//
;162:#ifdef DEBUG
;163:		//BotAI_Print(PRT_MESSAGE, "going for air\n");
;164:#endif //DEBUG
;165:		//if we can find an air goal
;166:		if (BotGetAirGoal(bs, &goal)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 56
ADDRGP4 BotGetAirGoal
CALLI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 0
EQI4 $85
line 167
;167:			trap_BotPushGoal(bs->gs, &goal);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_BotPushGoal
CALLV
pop
line 168
;168:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $79
JUMPV
line 170
;169:		}
;170:		else {
LABELV $84
line 172
;171:			//get a nearby goal outside the water
;172:			while(trap_BotChooseNBGItem(bs->gs, bs->origin, bs->inventory, tfl, ltg, range)) {
line 173
;173:				trap_BotGetTopGoal(bs->gs, &goal);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRGP4 trap_BotGetTopGoal
CALLI4
pop
line 175
;174:				//if the goal is not in water
;175:				if (!(trap_AAS_PointContents(goal.origin) & (CONTENTS_WATER|CONTENTS_SLIME|CONTENTS_LAVA))) {
ADDRLP4 0
ARGP4
ADDRLP4 60
ADDRGP4 trap_AAS_PointContents
CALLI4
ASGNI4
ADDRLP4 60
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
NEI4 $87
line 176
;176:					return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $79
JUMPV
LABELV $87
line 178
;177:				}
;178:				trap_BotPopGoal(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotPopGoal
CALLV
pop
line 179
;179:			}
LABELV $85
line 172
ADDRLP4 60
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 60
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 60
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 60
INDIRP4
CNSTI4 4952
ADDP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 64
ADDRGP4 trap_BotChooseNBGItem
CALLI4
ASGNI4
ADDRLP4 64
INDIRI4
CNSTI4 0
NEI4 $84
line 180
;180:			trap_BotResetAvoidGoals(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidGoals
CALLV
pop
line 181
;181:		}
line 182
;182:	}
LABELV $80
line 183
;183:	return qfalse;
CNSTI4 0
RETI4
LABELV $79
endproc BotGoForAir 68 24
export BotNearbyGoal
proc BotNearbyGoal 20 24
line 191
;184:}
;185:
;186:/*
;187:==================
;188:BotNearbyGoal
;189:==================
;190:*/
;191:int BotNearbyGoal(bot_state_t *bs, int tfl, bot_goal_t *ltg, float range) {
line 195
;192:	int ret;
;193:
;194:	//check if the bot should go for air
;195:	if (BotGoForAir(bs, tfl, ltg, range)) return qtrue;
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 BotGoForAir
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $90
CNSTI4 1
RETI4
ADDRGP4 $89
JUMPV
LABELV $90
line 197
;196:	//if the bot is carrying the enemy flag
;197:	if (BotCTFCarryingFlag(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $92
line 199
;198:		//if the bot is just a few secs away from the base 
;199:		if (trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin,
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 6636
ADDP4
INDIRI4
ARGI4
CNSTI4 18616254
ARGI4
ADDRLP4 16
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 300
GEI4 $94
line 200
;200:				bs->teamgoal.areanum, TFL_DEFAULT) < 300) {
line 202
;201:			//make the range really small
;202:			range = 50;
ADDRFP4 12
CNSTF4 1112014848
ASGNF4
line 203
;203:		}
LABELV $94
line 204
;204:	}
LABELV $92
line 206
;205:	//
;206:	ret = trap_BotChooseNBGItem(bs->gs, bs->origin, bs->inventory, tfl, ltg, range);
ADDRLP4 12
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 12
INDIRP4
CNSTI4 4952
ADDP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRF4
ARGF4
ADDRLP4 16
ADDRGP4 trap_BotChooseNBGItem
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
line 217
;207:	/*
;208:	if (ret)
;209:	{
;210:		char buf[128];
;211:		//get the goal at the top of the stack
;212:		trap_BotGetTopGoal(bs->gs, &goal);
;213:		trap_BotGoalName(goal.number, buf, sizeof(buf));
;214:		BotAI_Print(PRT_MESSAGE, "%1.1f: new nearby goal %s\n", FloatTime(), buf);
;215:	}
;216:    */
;217:	return ret;
ADDRLP4 0
INDIRI4
RETI4
LABELV $89
endproc BotNearbyGoal 20 24
export BotReachedGoal
proc BotReachedGoal 40 16
line 225
;218:}
;219:
;220:/*
;221:==================
;222:BotReachedGoal
;223:==================
;224:*/
;225:int BotReachedGoal(bot_state_t *bs, bot_goal_t *goal) {
line 226
;226:	if (goal->flags & GFL_ITEM) {
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $97
line 228
;227:		//if touching the goal
;228:		if (trap_BotTouchingGoal(bs->origin, goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $99
line 229
;229:			if (!(goal->flags & GFL_DROPPED)) {
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
NEI4 $101
line 230
;230:				trap_BotSetAvoidGoalTime(bs->gs, goal->number, -1);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRFP4 4
INDIRP4
CNSTI4 44
ADDP4
INDIRI4
ARGI4
CNSTF4 3212836864
ARGF4
ADDRGP4 trap_BotSetAvoidGoalTime
CALLV
pop
line 231
;231:			}
LABELV $101
line 232
;232:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $96
JUMPV
LABELV $99
line 235
;233:		}
;234:		//if the goal isn't there
;235:		if (trap_BotItemGoalInVisButNotVisible(bs->entitynum, bs->eye, bs->viewangles, goal)) {
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 trap_BotItemGoalInVisButNotVisible
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
EQI4 $103
line 247
;236:			/*
;237:			float avoidtime;
;238:			int t;
;239:
;240:			avoidtime = trap_BotAvoidGoalTime(bs->gs, goal->number);
;241:			if (avoidtime > 0) {
;242:				t = trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin, goal->areanum, bs->tfl);
;243:				if ((float) t * 0.009 < avoidtime)
;244:					return qtrue;
;245:			}
;246:			*/
;247:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $96
JUMPV
LABELV $103
line 250
;248:		}
;249:		//if in the goal area and below or above the goal and not swimming
;250:		if (bs->areanum == goal->areanum) {
ADDRFP4 0
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
NEI4 $98
line 251
;251:			if (bs->origin[0] > goal->origin[0] + goal->mins[0] && bs->origin[0] < goal->origin[0] + goal->maxs[0]) {
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ASGNF4
ADDRLP4 16
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 20
ADDRLP4 16
INDIRP4
INDIRF4
ASGNF4
ADDRLP4 12
INDIRF4
ADDRLP4 20
INDIRF4
ADDRLP4 16
INDIRP4
CNSTI4 16
ADDP4
INDIRF4
ADDF4
LEF4 $98
ADDRLP4 12
INDIRF4
ADDRLP4 20
INDIRF4
ADDRLP4 16
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
ADDF4
GEF4 $98
line 252
;252:				if (bs->origin[1] > goal->origin[1] + goal->mins[1] && bs->origin[1] < goal->origin[1] + goal->maxs[1]) {
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ASGNF4
ADDRLP4 28
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 32
ADDRLP4 28
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ASGNF4
ADDRLP4 24
INDIRF4
ADDRLP4 32
INDIRF4
ADDRLP4 28
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
ADDF4
LEF4 $98
ADDRLP4 24
INDIRF4
ADDRLP4 32
INDIRF4
ADDRLP4 28
INDIRP4
CNSTI4 32
ADDP4
INDIRF4
ADDF4
GEF4 $98
line 253
;253:					if (!trap_AAS_Swimming(bs->origin)) {
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 36
ADDRGP4 trap_AAS_Swimming
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 0
NEI4 $98
line 254
;254:						return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $96
JUMPV
line 256
;255:					}
;256:				}
line 257
;257:			}
line 258
;258:		}
line 259
;259:	}
LABELV $97
line 260
;260:	else if (goal->flags & GFL_AIR) {
ADDRFP4 4
INDIRP4
CNSTI4 48
ADDP4
INDIRI4
CNSTI4 128
BANDI4
CNSTI4 0
EQI4 $113
line 262
;261:		//if touching the goal
;262:		if (trap_BotTouchingGoal(bs->origin, goal)) return qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $115
CNSTI4 1
RETI4
ADDRGP4 $96
JUMPV
LABELV $115
line 264
;263:		//if the bot got air
;264:		if (bs->lastair_time > FloatTime() - 1) return qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 6176
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
LEF4 $114
CNSTI4 1
RETI4
ADDRGP4 $96
JUMPV
line 265
;265:	}
LABELV $113
line 266
;266:	else {
line 268
;267:		//if touching the goal
;268:		if (trap_BotTouchingGoal(bs->origin, goal)) return qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $119
CNSTI4 1
RETI4
ADDRGP4 $96
JUMPV
LABELV $119
line 269
;269:	}
LABELV $114
LABELV $98
line 270
;270:	return qfalse;
CNSTI4 0
RETI4
LABELV $96
endproc BotReachedGoal 40 16
export BotGetItemLongTermGoal
proc BotGetItemLongTermGoal 20 16
line 278
;271:}
;272:
;273:/*
;274:==================
;275:BotGetItemLongTermGoal
;276:==================
;277:*/
;278:int BotGetItemLongTermGoal(bot_state_t *bs, int tfl, bot_goal_t *goal) {
line 280
;279:	//if the bot has no goal
;280:	if (!trap_BotGetTopGoal(bs->gs, goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $122
line 282
;281:		//BotAI_Print(PRT_MESSAGE, "no ltg on stack\n");
;282:		bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 283
;283:	}
ADDRGP4 $123
JUMPV
LABELV $122
line 285
;284:	//if the bot touches the current goal
;285:	else if (BotReachedGoal(bs, goal)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 BotReachedGoal
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $124
line 286
;286:		BotChooseWeapon(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotChooseWeapon
CALLV
pop
line 287
;287:		bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 288
;288:	}
LABELV $124
LABELV $123
line 290
;289:	//if it is time to find a new long term goal
;290:	if (bs->ltg_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $126
line 292
;291:		//pop the current goal from the stack
;292:		trap_BotPopGoal(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotPopGoal
CALLV
pop
line 296
;293:		//BotAI_Print(PRT_MESSAGE, "%s: choosing new ltg\n", ClientName(bs->client, netname, sizeof(netname)));
;294:		//choose a new goal
;295:		//BotAI_Print(PRT_MESSAGE, "%6.1f client %d: BotChooseLTGItem\n", FloatTime(), bs->client);
;296:		if (trap_BotChooseLTGItem(bs->gs, bs->origin, bs->inventory, tfl)) {
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 8
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 4952
ADDP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 trap_BotChooseLTGItem
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $128
line 304
;297:			/*
;298:			char buf[128];
;299:			//get the goal at the top of the stack
;300:			trap_BotGetTopGoal(bs->gs, goal);
;301:			trap_BotGoalName(goal->number, buf, sizeof(buf));
;302:			BotAI_Print(PRT_MESSAGE, "%1.1f: new long term goal %s\n", FloatTime(), buf);
;303:            */
;304:			bs->ltg_time = FloatTime() + 20;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1101004800
ADDF4
ASGNF4
line 305
;305:		}
ADDRGP4 $129
JUMPV
LABELV $128
line 306
;306:		else {//the bot gets sorta stuck with all the avoid timings, shouldn't happen though
line 315
;307:			//
;308:#ifdef DEBUG
;309:			char netname[128];
;310:
;311:			BotAI_Print(PRT_MESSAGE, "%s: no valid ltg (probably stuck)\n", ClientName(bs->client, netname, sizeof(netname)));
;312:#endif
;313:			//trap_BotDumpAvoidGoals(bs->gs);
;314:			//reset the avoid goals and the avoid reach
;315:			trap_BotResetAvoidGoals(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidGoals
CALLV
pop
line 316
;316:			trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 317
;317:		}
LABELV $129
line 319
;318:		//get the goal at the top of the stack
;319:		return trap_BotGetTopGoal(bs->gs, goal);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
RETI4
ADDRGP4 $121
JUMPV
LABELV $126
line 321
;320:	}
;321:	return qtrue;
CNSTI4 1
RETI4
LABELV $121
endproc BotGetItemLongTermGoal 20 16
export BotGetLongTermGoal
proc BotGetLongTermGoal 664 20
line 332
;322:}
;323:
;324:/*
;325:==================
;326:BotGetLongTermGoal
;327:
;328:we could also create a seperate AI node for every long term goal type
;329:however this saves us a lot of code
;330:==================
;331:*/
;332:int BotGetLongTermGoal(bot_state_t *bs, int tfl, int retreat, bot_goal_t *goal) {
line 341
;333:	vec3_t target, dir, dir2;
;334:	char netname[MAX_NETNAME];
;335:	char buf[MAX_MESSAGE_SIZE];
;336:	int areanum;
;337:	float croucher;
;338:	aas_entityinfo_t entinfo, botinfo;
;339:	bot_waypoint_t *wp;
;340:
;341:	if (bs->ltgtype == LTG_TEAMHELP && !retreat) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 1
NEI4 $131
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $131
line 343
;342:		//check for bot typing status message
;343:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 620
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 620
INDIRF4
CNSTF4 0
EQF4 $133
ADDRLP4 620
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $133
line 344
;344:			BotAI_BotInitialChat(bs, "help_start", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 624
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $135
ARGP4
ADDRLP4 624
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 345
;345:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 346
;346:			BotVoiceChatOnly(bs, bs->decisionmaker, VOICECHAT_YES);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
ARGP4
ADDRLP4 632
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $136
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 347
;347:			trap_EA_Action(bs->client, ACTION_AFFIRMATIVE);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 1048576
ARGI4
ADDRGP4 trap_EA_Action
CALLV
pop
line 348
;348:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 349
;349:		}
LABELV $133
line 351
;350:		//if trying to help the team mate for more than a minute
;351:		if (bs->teamgoal_time < FloatTime())
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $137
line 352
;352:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
LABELV $137
line 354
;353:		//if the team mate IS visible for quite some time
;354:		if (bs->teammatevisible_time < FloatTime() - 10) bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
SUBF4
GEF4 $139
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
LABELV $139
line 356
;355:		//get entity information of the companion
;356:		BotEntityInfo(bs->teammate, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 272
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 358
;357:		//if the team mate is visible
;358:		if (BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->teammate)) {
ADDRLP4 624
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 624
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 624
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 624
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 624
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 628
INDIRF4
CNSTF4 0
EQF4 $141
line 360
;359:			//if close just stand still there
;360:			VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 272+24
INDIRF4
ADDRLP4 632
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 272+24+4
INDIRF4
ADDRLP4 632
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRLP4 272+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 361
;361:			if (VectorLengthSquared(dir) < Square(100)) {
ADDRLP4 260
ARGP4
ADDRLP4 636
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 636
INDIRF4
CNSTF4 1176256512
GEF4 $142
line 362
;362:				trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 363
;363:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
line 365
;364:			}
;365:		}
LABELV $141
line 366
;366:		else {
line 368
;367:			//last time the bot was NOT visible
;368:			bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 369
;369:		}
LABELV $142
line 371
;370:		//if the entity information is valid (entity in PVS)
;371:		if (entinfo.valid) {
ADDRLP4 272
INDIRI4
CNSTI4 0
EQI4 $152
line 372
;372:			areanum = BotPointAreaNum(entinfo.origin);
ADDRLP4 272+24
ARGP4
ADDRLP4 632
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 448
ADDRLP4 632
INDIRI4
ASGNI4
line 373
;373:			if (areanum && trap_AAS_AreaReachability(areanum)) {
ADDRLP4 636
ADDRLP4 448
INDIRI4
ASGNI4
ADDRLP4 636
INDIRI4
CNSTI4 0
EQI4 $155
ADDRLP4 636
INDIRI4
ARGI4
ADDRLP4 640
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 640
INDIRI4
CNSTI4 0
EQI4 $155
line 375
;374:				//update team goal
;375:				bs->teamgoal.entitynum = bs->teammate;
ADDRLP4 644
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 644
INDIRP4
CNSTI4 6664
ADDP4
ADDRLP4 644
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ASGNI4
line 376
;376:				bs->teamgoal.areanum = areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6636
ADDP4
ADDRLP4 448
INDIRI4
ASGNI4
line 377
;377:				VectorCopy(entinfo.origin, bs->teamgoal.origin);
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ADDRLP4 272+24
INDIRB
ASGNB 12
line 378
;378:				VectorSet(bs->teamgoal.mins, -8, -8, -8);
ADDRFP4 0
INDIRP4
CNSTI4 6640
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6644
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6648
ADDP4
CNSTF4 3238002688
ASGNF4
line 379
;379:				VectorSet(bs->teamgoal.maxs, 8, 8, 8);
ADDRFP4 0
INDIRP4
CNSTI4 6652
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6656
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6660
ADDP4
CNSTF4 1090519040
ASGNF4
line 380
;380:			}
LABELV $155
line 381
;381:		}
LABELV $152
line 382
;382:		memcpy(goal, &bs->teamgoal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 383
;383:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $131
line 386
;384:	}
;385:	//if the bot accompanies someone
;386:	if (bs->ltgtype == LTG_TEAMACCOMPANY && !retreat) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 2
NEI4 $158
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $158
line 388
;387:		//check for bot typing status message
;388:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 620
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 620
INDIRF4
CNSTF4 0
EQF4 $160
ADDRLP4 620
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $160
line 389
;389:			BotAI_BotInitialChat(bs, "accompany_start", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 624
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $162
ARGP4
ADDRLP4 624
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 390
;390:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 391
;391:			BotVoiceChatOnly(bs, bs->decisionmaker, VOICECHAT_YES);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
ARGP4
ADDRLP4 632
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $136
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 392
;392:			trap_EA_Action(bs->client, ACTION_AFFIRMATIVE);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 1048576
ARGI4
ADDRGP4 trap_EA_Action
CALLV
pop
line 393
;393:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 394
;394:		}
LABELV $160
line 396
;395:		//if accompanying the companion for 3 minutes
;396:		if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $163
line 397
;397:			BotAI_BotInitialChat(bs, "accompany_stop", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 624
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $165
ARGP4
ADDRLP4 624
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 398
;398:			trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 399
;399:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 400
;400:		}
LABELV $163
line 402
;401:		//get entity information of the companion
;402:		BotEntityInfo(bs->teammate, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 272
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 404
;403:		//if the companion is visible
;404:		if (BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->teammate)) {
ADDRLP4 624
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 624
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 624
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 624
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 624
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 628
INDIRF4
CNSTF4 0
EQF4 $166
line 406
;405:			//update visible time
;406:			bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 407
;407:			VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 272+24
INDIRF4
ADDRLP4 632
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 272+24+4
INDIRF4
ADDRLP4 632
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRLP4 272+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 408
;408:			if (VectorLengthSquared(dir) < Square(bs->formation_dist)) {
ADDRLP4 260
ARGP4
ADDRLP4 636
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 640
ADDRFP4 0
INDIRP4
CNSTI4 7012
ADDP4
INDIRF4
ASGNF4
ADDRLP4 636
INDIRF4
ADDRLP4 640
INDIRF4
ADDRLP4 640
INDIRF4
MULF4
GEF4 $175
line 412
;409:				//
;410:				// if the client being followed bumps into this bot then
;411:				// the bot should back up
;412:				BotEntityInfo(bs->entitynum, &botinfo);
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 452
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 414
;413:				// if the followed client is not standing ontop of the bot
;414:				if (botinfo.origin[2] + botinfo.maxs[2] > entinfo.origin[2] + entinfo.mins[2]) {
ADDRLP4 452+24+8
INDIRF4
ADDRLP4 452+84+8
INDIRF4
ADDF4
ADDRLP4 272+24+8
INDIRF4
ADDRLP4 272+72+8
INDIRF4
ADDF4
LEF4 $177
line 416
;415:					// if the bounding boxes touch each other
;416:					if (botinfo.origin[0] + botinfo.maxs[0] > entinfo.origin[0] + entinfo.mins[0] - 4&&
ADDRLP4 644
CNSTF4 1082130432
ASGNF4
ADDRLP4 452+24
INDIRF4
ADDRLP4 452+84
INDIRF4
ADDF4
ADDRLP4 272+24
INDIRF4
ADDRLP4 272+72
INDIRF4
ADDF4
ADDRLP4 644
INDIRF4
SUBF4
LEF4 $187
ADDRLP4 452+24
INDIRF4
ADDRLP4 452+72
INDIRF4
ADDF4
ADDRLP4 272+24
INDIRF4
ADDRLP4 272+84
INDIRF4
ADDF4
ADDRLP4 644
INDIRF4
ADDF4
GEF4 $187
line 417
;417:						botinfo.origin[0] + botinfo.mins[0] < entinfo.origin[0] + entinfo.maxs[0] + 4) {
line 418
;418:						if (botinfo.origin[1] + botinfo.maxs[1] > entinfo.origin[1] + entinfo.mins[1] - 4 &&
ADDRLP4 648
CNSTF4 1082130432
ASGNF4
ADDRLP4 452+24+4
INDIRF4
ADDRLP4 452+84+4
INDIRF4
ADDF4
ADDRLP4 272+24+4
INDIRF4
ADDRLP4 272+72+4
INDIRF4
ADDF4
ADDRLP4 648
INDIRF4
SUBF4
LEF4 $197
ADDRLP4 452+24+4
INDIRF4
ADDRLP4 452+72+4
INDIRF4
ADDF4
ADDRLP4 272+24+4
INDIRF4
ADDRLP4 272+84+4
INDIRF4
ADDF4
ADDRLP4 648
INDIRF4
ADDF4
GEF4 $197
line 419
;419:							botinfo.origin[1] + botinfo.mins[1] < entinfo.origin[1] + entinfo.maxs[1] + 4) {
line 420
;420:							if (botinfo.origin[2] + botinfo.maxs[2] > entinfo.origin[2] + entinfo.mins[2] - 4 &&
ADDRLP4 652
CNSTF4 1082130432
ASGNF4
ADDRLP4 452+24+8
INDIRF4
ADDRLP4 452+84+8
INDIRF4
ADDF4
ADDRLP4 272+24+8
INDIRF4
ADDRLP4 272+72+8
INDIRF4
ADDF4
ADDRLP4 652
INDIRF4
SUBF4
LEF4 $215
ADDRLP4 452+24+8
INDIRF4
ADDRLP4 452+72+8
INDIRF4
ADDF4
ADDRLP4 272+24+8
INDIRF4
ADDRLP4 272+84+8
INDIRF4
ADDF4
ADDRLP4 652
INDIRF4
ADDF4
GEF4 $215
line 421
;421:								botinfo.origin[2] + botinfo.mins[2] < entinfo.origin[2] + entinfo.maxs[2] + 4) {
line 423
;422:								// if the followed client looks in the direction of this bot
;423:								AngleVectors(entinfo.angles, dir, NULL, NULL);
ADDRLP4 272+36
ARGP4
ADDRLP4 260
ARGP4
ADDRLP4 656
CNSTP4 0
ASGNP4
ADDRLP4 656
INDIRP4
ARGP4
ADDRLP4 656
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 424
;424:								dir[2] = 0;
ADDRLP4 260+8
CNSTF4 0
ASGNF4
line 425
;425:								VectorNormalize(dir);
ADDRLP4 260
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 427
;426:								//VectorSubtract(entinfo.origin, entinfo.lastvisorigin, dir);
;427:								VectorSubtract(bs->origin, entinfo.origin, dir2);
ADDRLP4 660
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 608
ADDRLP4 660
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRLP4 272+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 608+4
ADDRLP4 660
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ADDRLP4 272+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 608+8
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 272+24+8
INDIRF4
SUBF4
ASGNF4
line 428
;428:								VectorNormalize(dir2);
ADDRLP4 608
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
line 429
;429:								if (DotProduct(dir, dir2) > 0.7) {
ADDRLP4 260
INDIRF4
ADDRLP4 608
INDIRF4
MULF4
ADDRLP4 260+4
INDIRF4
ADDRLP4 608+4
INDIRF4
MULF4
ADDF4
ADDRLP4 260+8
INDIRF4
ADDRLP4 608+8
INDIRF4
MULF4
ADDF4
CNSTF4 1060320051
LEF4 $242
line 431
;430:									// back up
;431:									BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 432
;432:									trap_BotMoveInDirection(bs->ms, dir2, 400, MOVE_WALK);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 608
ARGP4
CNSTF4 1137180672
ARGF4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotMoveInDirection
CALLI4
pop
line 433
;433:								}
LABELV $242
line 434
;434:							}
LABELV $215
line 435
;435:						}
LABELV $197
line 436
;436:					}
LABELV $187
line 437
;437:				}
LABELV $177
line 440
;438:				//check if the bot wants to crouch
;439:				//don't crouch if crouched less than 5 seconds ago
;440:				if (bs->attackcrouch_time < FloatTime() - 5) {
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
SUBF4
GEF4 $248
line 441
;441:					croucher = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CROUCHER, 0, 1);
ADDRFP4 0
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
ADDRLP4 644
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 604
ADDRLP4 644
INDIRF4
ASGNF4
line 442
;442:					if (random() < bs->thinktime * croucher) {
ADDRLP4 648
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
ADDRLP4 604
INDIRF4
MULF4
GEF4 $250
line 443
;443:						bs->attackcrouch_time = FloatTime() + 5 + croucher * 15;
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CNSTF4 1097859072
ADDRLP4 604
INDIRF4
MULF4
ADDF4
ASGNF4
line 444
;444:					}
LABELV $250
line 445
;445:				}
LABELV $248
line 447
;446:				//don't crouch when swimming
;447:				if (trap_AAS_Swimming(bs->origin)) bs->attackcrouch_time = FloatTime() - 1;
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 644
ADDRGP4 trap_AAS_Swimming
CALLI4
ASGNI4
ADDRLP4 644
INDIRI4
CNSTI4 0
EQI4 $252
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
ASGNF4
LABELV $252
line 449
;448:				//if not arrived yet or arived some time ago
;449:				if (bs->arrive_time < FloatTime() - 2) {
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
GEF4 $254
line 451
;450:					//if not arrived yet
;451:					if (!bs->arrive_time) {
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
INDIRF4
CNSTF4 0
NEF4 $256
line 452
;452:						trap_EA_Gesture(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Gesture
CALLV
pop
line 453
;453:						BotAI_BotInitialChat(bs, "accompany_arrive", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 648
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $258
ARGP4
ADDRLP4 648
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 454
;454:						trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 652
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 652
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 652
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 455
;455:						bs->arrive_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 456
;456:					}
ADDRGP4 $257
JUMPV
LABELV $256
line 458
;457:					//if the bot wants to crouch
;458:					else if (bs->attackcrouch_time > FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $259
line 459
;459:						trap_EA_Crouch(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Crouch
CALLV
pop
line 460
;460:					}
ADDRGP4 $260
JUMPV
LABELV $259
line 462
;461:					//else do some model taunts
;462:					else if (random() < bs->thinktime * 0.05) {
ADDRLP4 648
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1028443341
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $261
line 464
;463:						//do a gesture :)
;464:						trap_EA_Gesture(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Gesture
CALLV
pop
line 465
;465:					}
LABELV $261
LABELV $260
LABELV $257
line 466
;466:				}
LABELV $254
line 468
;467:				//if just arrived look at the companion
;468:				if (bs->arrive_time > FloatTime() - 2) {
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
LEF4 $263
line 469
;469:					VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 648
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 272+24
INDIRF4
ADDRLP4 648
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 272+24+4
INDIRF4
ADDRLP4 648
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRLP4 272+24+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 470
;470:					vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 260
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 471
;471:					bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 652
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 652
INDIRP4
CNSTF4 1056964608
ADDRLP4 652
INDIRP4
INDIRF4
MULF4
ASGNF4
line 472
;472:				}
ADDRGP4 $264
JUMPV
LABELV $263
line 474
;473:				//else look strategically around for enemies
;474:				else if (random() < bs->thinktime * 0.8) {
ADDRLP4 648
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1061997773
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $272
line 475
;475:					BotRoamGoal(bs, target);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 592
ARGP4
ADDRGP4 BotRoamGoal
CALLV
pop
line 476
;476:					VectorSubtract(target, bs->origin, dir);
ADDRLP4 652
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 592
INDIRF4
ADDRLP4 652
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 592+4
INDIRF4
ADDRLP4 652
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRLP4 592+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 477
;477:					vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 260
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 478
;478:					bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 656
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 656
INDIRP4
CNSTF4 1056964608
ADDRLP4 656
INDIRP4
INDIRF4
MULF4
ASGNF4
line 479
;479:				}
LABELV $272
LABELV $264
line 481
;480:				//check if the bot wants to go for air
;481:				if (BotGoForAir(bs, bs->tfl, &bs->teamgoal, 400)) {
ADDRLP4 652
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 652
INDIRP4
ARGP4
ADDRLP4 652
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 652
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTF4 1137180672
ARGF4
ADDRLP4 656
ADDRGP4 BotGoForAir
CALLI4
ASGNI4
ADDRLP4 656
INDIRI4
CNSTI4 0
EQI4 $278
line 482
;482:					trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 488
;483:					//get the goal at the top of the stack
;484:					//trap_BotGetTopGoal(bs->gs, &tmpgoal);
;485:					//trap_BotGoalName(tmpgoal.number, buf, 144);
;486:					//BotAI_Print(PRT_MESSAGE, "new nearby goal %s\n", buf);
;487:					//time the bot gets to pick up the nearby goal item
;488:					bs->nbg_time = FloatTime() + 8;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 489
;489:					AIEnter_Seek_NBG(bs, "BotLongTermGoal: go for air");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $280
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 490
;490:					return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $278
line 493
;491:				}
;492:				//
;493:				trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 494
;494:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $175
line 496
;495:			}
;496:		}
LABELV $166
line 498
;497:		//if the entity information is valid (entity in PVS)
;498:		if (entinfo.valid) {
ADDRLP4 272
INDIRI4
CNSTI4 0
EQI4 $281
line 499
;499:			areanum = BotPointAreaNum(entinfo.origin);
ADDRLP4 272+24
ARGP4
ADDRLP4 632
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 448
ADDRLP4 632
INDIRI4
ASGNI4
line 500
;500:			if (areanum && trap_AAS_AreaReachability(areanum)) {
ADDRLP4 636
ADDRLP4 448
INDIRI4
ASGNI4
ADDRLP4 636
INDIRI4
CNSTI4 0
EQI4 $284
ADDRLP4 636
INDIRI4
ARGI4
ADDRLP4 640
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 640
INDIRI4
CNSTI4 0
EQI4 $284
line 502
;501:				//update team goal
;502:				bs->teamgoal.entitynum = bs->teammate;
ADDRLP4 644
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 644
INDIRP4
CNSTI4 6664
ADDP4
ADDRLP4 644
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ASGNI4
line 503
;503:				bs->teamgoal.areanum = areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6636
ADDP4
ADDRLP4 448
INDIRI4
ASGNI4
line 504
;504:				VectorCopy(entinfo.origin, bs->teamgoal.origin);
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ADDRLP4 272+24
INDIRB
ASGNB 12
line 505
;505:				VectorSet(bs->teamgoal.mins, -8, -8, -8);
ADDRFP4 0
INDIRP4
CNSTI4 6640
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6644
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6648
ADDP4
CNSTF4 3238002688
ASGNF4
line 506
;506:				VectorSet(bs->teamgoal.maxs, 8, 8, 8);
ADDRFP4 0
INDIRP4
CNSTI4 6652
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6656
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6660
ADDP4
CNSTF4 1090519040
ASGNF4
line 507
;507:			}
LABELV $284
line 508
;508:		}
LABELV $281
line 510
;509:		//the goal the bot should go for
;510:		memcpy(goal, &bs->teamgoal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 512
;511:		//if the companion is NOT visible for too long
;512:		if (bs->teammatevisible_time < FloatTime() - 60) {
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1114636288
SUBF4
GEF4 $287
line 513
;513:			BotAI_BotInitialChat(bs, "accompany_cannotfind", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 632
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $289
ARGP4
ADDRLP4 632
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 514
;514:			trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 636
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 636
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 636
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 515
;515:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 517
;516:			// just to make sure the bot won't spam this message
;517:			bs->teammatevisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6748
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 518
;518:		}
LABELV $287
line 519
;519:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $158
line 522
;520:	}
;521:	//
;522:	if (bs->ltgtype == LTG_DEFENDKEYAREA) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 3
NEI4 $290
line 523
;523:		if (trap_AAS_AreaTravelTimeToGoalArea(bs->areanum, bs->origin,
ADDRLP4 620
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 620
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ARGI4
ADDRLP4 620
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 620
INDIRP4
CNSTI4 6636
ADDP4
INDIRI4
ARGI4
CNSTI4 18616254
ARGI4
ADDRLP4 624
ADDRGP4 trap_AAS_AreaTravelTimeToGoalArea
CALLI4
ASGNI4
ADDRLP4 624
INDIRI4
CVIF4 4
ADDRFP4 0
INDIRP4
CNSTI4 6148
ADDP4
INDIRF4
LEF4 $292
line 524
;524:				bs->teamgoal.areanum, TFL_DEFAULT) > bs->defendaway_range) {
line 525
;525:			bs->defendaway_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6144
ADDP4
CNSTF4 0
ASGNF4
line 526
;526:		}
LABELV $292
line 527
;527:	}
LABELV $290
line 529
;528:	//if defending a key area
;529:	if (bs->ltgtype == LTG_DEFENDKEYAREA && !retreat &&
ADDRLP4 620
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 620
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 3
NEI4 $294
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $294
ADDRLP4 620
INDIRP4
CNSTI4 6144
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $294
line 530
;530:				bs->defendaway_time < FloatTime()) {
line 532
;531:		//check for bot typing status message
;532:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 624
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 624
INDIRF4
CNSTF4 0
EQF4 $296
ADDRLP4 624
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $296
line 533
;533:			trap_BotGoalName(bs->teamgoal.number, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6668
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 534
;534:			BotAI_BotInitialChat(bs, "defend_start", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $298
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 535
;535:			trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 536
;536:			BotVoiceChatOnly(bs, -1, VOICECHAT_ONDEFENSE);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 $299
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 537
;537:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 538
;538:		}
LABELV $296
line 540
;539:		//set the bot goal
;540:		memcpy(goal, &bs->teamgoal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 542
;541:		//stop after 2 minutes
;542:		if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $300
line 543
;543:			trap_BotGoalName(bs->teamgoal.number, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6668
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 544
;544:			BotAI_BotInitialChat(bs, "defend_stop", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $302
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 545
;545:			trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 546
;546:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 547
;547:		}
LABELV $300
line 549
;548:		//if very close... go away for some time
;549:		VectorSubtract(goal->origin, bs->origin, dir);
ADDRLP4 628
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 628
INDIRP4
INDIRF4
ADDRLP4 632
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 628
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 632
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRFP4 12
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 550
;550:		if (VectorLengthSquared(dir) < Square(70)) {
ADDRLP4 260
ARGP4
ADDRLP4 636
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 636
INDIRF4
CNSTF4 1167663104
GEF4 $305
line 551
;551:			trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 552
;552:			bs->defendaway_time = FloatTime() + 3 + 3 * random();
ADDRLP4 640
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 644
CNSTF4 1077936128
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6144
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 644
INDIRF4
ADDF4
ADDRLP4 644
INDIRF4
ADDRLP4 640
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
ASGNF4
line 553
;553:			if (BotHasPersistantPowerupAndWeapon(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 648
ADDRGP4 BotHasPersistantPowerupAndWeapon
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 0
EQI4 $307
line 554
;554:				bs->defendaway_range = 100;
ADDRFP4 0
INDIRP4
CNSTI4 6148
ADDP4
CNSTF4 1120403456
ASGNF4
line 555
;555:			}
ADDRGP4 $308
JUMPV
LABELV $307
line 556
;556:			else {
line 557
;557:				bs->defendaway_range = 350;
ADDRFP4 0
INDIRP4
CNSTI4 6148
ADDP4
CNSTF4 1135542272
ASGNF4
line 558
;558:			}
LABELV $308
line 559
;559:		}
LABELV $305
line 560
;560:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $294
line 563
;561:	}
;562:	//going to kill someone
;563:	if (bs->ltgtype == LTG_KILL && !retreat) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 11
NEI4 $309
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $309
line 565
;564:		//check for bot typing status message
;565:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 624
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 624
INDIRF4
CNSTF4 0
EQF4 $311
ADDRLP4 624
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $311
line 566
;566:			EasyClientName(bs->teamgoal.entitynum, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6664
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 EasyClientName
CALLP4
pop
line 567
;567:			BotAI_BotInitialChat(bs, "kill_start", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $313
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 568
;568:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 569
;569:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 570
;570:		}
LABELV $311
line 572
;571:		//
;572:		if (bs->lastkilledplayer == bs->teamgoal.entitynum) {
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 5992
ADDP4
INDIRI4
ADDRLP4 628
INDIRP4
CNSTI4 6664
ADDP4
INDIRI4
NEI4 $314
line 573
;573:			EasyClientName(bs->teamgoal.entitynum, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6664
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 EasyClientName
CALLP4
pop
line 574
;574:			BotAI_BotInitialChat(bs, "kill_done", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $316
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 575
;575:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 632
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 576
;576:			bs->lastkilledplayer = -1;
ADDRFP4 0
INDIRP4
CNSTI4 5992
ADDP4
CNSTI4 -1
ASGNI4
line 577
;577:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 578
;578:		}
LABELV $314
line 580
;579:		//
;580:		if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $317
line 581
;581:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 582
;582:		}
LABELV $317
line 584
;583:		//just roam around
;584:		return BotGetItemLongTermGoal(bs, tfl, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 632
ADDRGP4 BotGetItemLongTermGoal
CALLI4
ASGNI4
ADDRLP4 632
INDIRI4
RETI4
ADDRGP4 $130
JUMPV
LABELV $309
line 587
;585:	}
;586:	//get an item
;587:	if (bs->ltgtype == LTG_GETITEM && !retreat) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 10
NEI4 $319
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $319
line 589
;588:		//check for bot typing status message
;589:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 624
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 624
INDIRF4
CNSTF4 0
EQF4 $321
ADDRLP4 624
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $321
line 590
;590:			trap_BotGoalName(bs->teamgoal.number, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6668
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 591
;591:			BotAI_BotInitialChat(bs, "getitem_start", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $323
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 592
;592:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 593
;593:			BotVoiceChatOnly(bs, bs->decisionmaker, VOICECHAT_YES);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
ARGP4
ADDRLP4 632
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $136
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 594
;594:			trap_EA_Action(bs->client, ACTION_AFFIRMATIVE);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 1048576
ARGI4
ADDRGP4 trap_EA_Action
CALLV
pop
line 595
;595:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 596
;596:		}
LABELV $321
line 598
;597:		//set the bot goal
;598:		memcpy(goal, &bs->teamgoal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 600
;599:		//stop after some time
;600:		if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $324
line 601
;601:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 602
;602:		}
LABELV $324
line 604
;603:		//
;604:		if (trap_BotItemGoalInVisButNotVisible(bs->entitynum, bs->eye, bs->viewangles, goal)) {
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 628
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 628
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 632
ADDRGP4 trap_BotItemGoalInVisButNotVisible
CALLI4
ASGNI4
ADDRLP4 632
INDIRI4
CNSTI4 0
EQI4 $326
line 605
;605:			trap_BotGoalName(bs->teamgoal.number, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6668
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 606
;606:			BotAI_BotInitialChat(bs, "getitem_notthere", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $328
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 607
;607:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 636
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 636
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 636
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 608
;608:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 609
;609:		}
ADDRGP4 $327
JUMPV
LABELV $326
line 610
;610:		else if (BotReachedGoal(bs, goal)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 636
ADDRGP4 BotReachedGoal
CALLI4
ASGNI4
ADDRLP4 636
INDIRI4
CNSTI4 0
EQI4 $329
line 611
;611:			trap_BotGoalName(bs->teamgoal.number, buf, sizeof(buf));
ADDRFP4 0
INDIRP4
CNSTI4 6668
ADDP4
INDIRI4
ARGI4
ADDRLP4 4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 612
;612:			BotAI_BotInitialChat(bs, "getitem_gotit", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $331
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 613
;613:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 640
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 640
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 640
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 614
;614:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 615
;615:		}
LABELV $329
LABELV $327
line 616
;616:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $319
line 619
;617:	}
;618:	//if camping somewhere
;619:	if ((bs->ltgtype == LTG_CAMP || bs->ltgtype == LTG_CAMPORDER) && !retreat) {
ADDRLP4 624
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
ADDRLP4 624
INDIRI4
CNSTI4 7
EQI4 $334
ADDRLP4 624
INDIRI4
CNSTI4 8
NEI4 $332
LABELV $334
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $332
line 621
;620:		//check for bot typing status message
;621:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 628
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 628
INDIRF4
CNSTF4 0
EQF4 $335
ADDRLP4 628
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $335
line 622
;622:			if (bs->ltgtype == LTG_CAMPORDER) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 8
NEI4 $337
line 623
;623:				BotAI_BotInitialChat(bs, "camp_start", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 632
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $339
ARGP4
ADDRLP4 632
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 624
;624:				trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 636
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 636
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 636
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 625
;625:				BotVoiceChatOnly(bs, bs->decisionmaker, VOICECHAT_YES);
ADDRLP4 640
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 640
INDIRP4
ARGP4
ADDRLP4 640
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $136
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 626
;626:				trap_EA_Action(bs->client, ACTION_AFFIRMATIVE);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 1048576
ARGI4
ADDRGP4 trap_EA_Action
CALLV
pop
line 627
;627:			}
LABELV $337
line 628
;628:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 629
;629:		}
LABELV $335
line 631
;630:		//set the bot goal
;631:		memcpy(goal, &bs->teamgoal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 633
;632:		//
;633:		if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $340
line 634
;634:			if (bs->ltgtype == LTG_CAMPORDER) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 8
NEI4 $342
line 635
;635:				BotAI_BotInitialChat(bs, "camp_stop", NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $344
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 636
;636:				trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 632
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 637
;637:			}
LABELV $342
line 638
;638:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 639
;639:		}
LABELV $340
line 641
;640:		//if really near the camp spot
;641:		VectorSubtract(goal->origin, bs->origin, dir);
ADDRLP4 632
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 636
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 632
INDIRP4
INDIRF4
ADDRLP4 636
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 632
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 636
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRFP4 12
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 642
;642:		if (VectorLengthSquared(dir) < Square(60))
ADDRLP4 260
ARGP4
ADDRLP4 640
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 640
INDIRF4
CNSTF4 1163984896
GEF4 $347
line 643
;643:		{
line 645
;644:			//if not arrived yet
;645:			if (!bs->arrive_time) {
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
INDIRF4
CNSTF4 0
NEF4 $349
line 646
;646:				if (bs->ltgtype == LTG_CAMPORDER) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 8
NEI4 $351
line 647
;647:					BotAI_BotInitialChat(bs, "camp_arrive", EasyClientName(bs->teammate, netname, sizeof(netname)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
ADDRLP4 412
ARGP4
CNSTI4 36
ARGI4
ADDRLP4 644
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $353
ARGP4
ADDRLP4 644
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 648
;648:					trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 648
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 648
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 648
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 649
;649:					BotVoiceChatOnly(bs, bs->decisionmaker, VOICECHAT_INPOSITION);
ADDRLP4 652
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 652
INDIRP4
ARGP4
ADDRLP4 652
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $354
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 650
;650:				}
LABELV $351
line 651
;651:				bs->arrive_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6172
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 652
;652:			}
LABELV $349
line 654
;653:			//look strategically around for enemies
;654:			if (random() < bs->thinktime * 0.8) {
ADDRLP4 644
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 644
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1061997773
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $355
line 655
;655:				BotRoamGoal(bs, target);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 592
ARGP4
ADDRGP4 BotRoamGoal
CALLV
pop
line 656
;656:				VectorSubtract(target, bs->origin, dir);
ADDRLP4 648
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
ADDRLP4 592
INDIRF4
ADDRLP4 648
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+4
ADDRLP4 592+4
INDIRF4
ADDRLP4 648
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 260+8
ADDRLP4 592+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 657
;657:				vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 260
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 658
;658:				bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 652
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 652
INDIRP4
CNSTF4 1056964608
ADDRLP4 652
INDIRP4
INDIRF4
MULF4
ASGNF4
line 659
;659:			}
LABELV $355
line 662
;660:			//check if the bot wants to crouch
;661:			//don't crouch if crouched less than 5 seconds ago
;662:			if (bs->attackcrouch_time < FloatTime() - 5) {
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
SUBF4
GEF4 $361
line 663
;663:				croucher = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_CROUCHER, 0, 1);
ADDRFP4 0
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
ADDRLP4 648
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 604
ADDRLP4 648
INDIRF4
ASGNF4
line 664
;664:				if (random() < bs->thinktime * croucher) {
ADDRLP4 652
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 652
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
ADDRLP4 604
INDIRF4
MULF4
GEF4 $363
line 665
;665:					bs->attackcrouch_time = FloatTime() + 5 + croucher * 15;
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CNSTF4 1097859072
ADDRLP4 604
INDIRF4
MULF4
ADDF4
ASGNF4
line 666
;666:				}
LABELV $363
line 667
;667:			}
LABELV $361
line 669
;668:			//if the bot wants to crouch
;669:			if (bs->attackcrouch_time > FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $365
line 670
;670:				trap_EA_Crouch(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Crouch
CALLV
pop
line 671
;671:			}
LABELV $365
line 673
;672:			//don't crouch when swimming
;673:			if (trap_AAS_Swimming(bs->origin)) bs->attackcrouch_time = FloatTime() - 1;
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 648
ADDRGP4 trap_AAS_Swimming
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 0
EQI4 $367
ADDRFP4 0
INDIRP4
CNSTI4 6120
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
ASGNF4
LABELV $367
line 675
;674:			//make sure the bot is not gonna drown
;675:			if (trap_PointContents(bs->eye,bs->entitynum) & (CONTENTS_WATER|CONTENTS_SLIME|CONTENTS_LAVA)) {
ADDRLP4 652
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 652
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 652
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 656
ADDRGP4 trap_PointContents
CALLI4
ASGNI4
ADDRLP4 656
INDIRI4
CNSTI4 56
BANDI4
CNSTI4 0
EQI4 $369
line 676
;676:				if (bs->ltgtype == LTG_CAMPORDER) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 8
NEI4 $371
line 677
;677:					BotAI_BotInitialChat(bs, "camp_stop", NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $344
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 678
;678:					trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 660
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 660
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 660
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 680
;679:					//
;680:					if (bs->lastgoal_ltgtype == LTG_CAMPORDER) {
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
INDIRI4
CNSTI4 8
NEI4 $373
line 681
;681:						bs->lastgoal_ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6760
ADDP4
CNSTI4 0
ASGNI4
line 682
;682:					}
LABELV $373
line 683
;683:				}
LABELV $371
line 684
;684:				bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 685
;685:			}
LABELV $369
line 687
;686:			//
;687:			if (bs->camp_range > 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6188
ADDP4
INDIRF4
CNSTF4 0
LEF4 $375
line 689
;688:				//FIXME: move around a bit
;689:			}
LABELV $375
line 691
;690:			//
;691:			trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 692
;692:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $347
line 694
;693:		}
;694:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $332
line 697
;695:	}
;696:	//patrolling along several waypoints
;697:	if (bs->ltgtype == LTG_PATROL && !retreat) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 9
NEI4 $377
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $377
line 699
;698:		//check for bot typing status message
;699:		if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 628
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 628
INDIRF4
CNSTF4 0
EQF4 $379
ADDRLP4 628
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $379
line 700
;700:			strcpy(buf, "");
ADDRLP4 4
ARGP4
ADDRGP4 $64
ARGP4
ADDRGP4 strcpy
CALLP4
pop
line 701
;701:			for (wp = bs->patrolpoints; wp; wp = wp->next) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 9076
ADDP4
INDIRP4
ASGNP4
ADDRGP4 $384
JUMPV
LABELV $381
line 702
;702:				strcat(buf, wp->name);
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ARGP4
ADDRGP4 strcat
CALLP4
pop
line 703
;703:				if (wp->next) strcat(buf, " to ");
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $385
ADDRLP4 4
ARGP4
ADDRGP4 $387
ARGP4
ADDRGP4 strcat
CALLP4
pop
LABELV $385
line 704
;704:			}
LABELV $382
line 701
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
LABELV $384
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $381
line 705
;705:			BotAI_BotInitialChat(bs, "patrol_start", buf, NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $388
ARGP4
ADDRLP4 4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 706
;706:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 632
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 707
;707:			BotVoiceChatOnly(bs, bs->decisionmaker, VOICECHAT_YES);
ADDRLP4 636
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 636
INDIRP4
ARGP4
ADDRLP4 636
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
ADDRGP4 $136
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 708
;708:			trap_EA_Action(bs->client, ACTION_AFFIRMATIVE);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
CNSTI4 1048576
ARGI4
ADDRGP4 trap_EA_Action
CALLV
pop
line 709
;709:			bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 710
;710:		}
LABELV $379
line 712
;711:		//
;712:		if (!bs->curpatrolpoint) {
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $389
line 713
;713:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 714
;714:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $389
line 717
;715:		}
;716:		//if the bot touches the current goal
;717:		if (trap_BotTouchingGoal(bs->origin, &bs->curpatrolpoint->goal)) {
ADDRLP4 632
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 632
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 632
INDIRP4
CNSTI4 9080
ADDP4
INDIRP4
CNSTI4 36
ADDP4
ARGP4
ADDRLP4 636
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 636
INDIRI4
CNSTI4 0
EQI4 $391
line 718
;718:			if (bs->patrolflags & PATROL_BACK) {
ADDRFP4 0
INDIRP4
CNSTI4 9084
ADDP4
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $393
line 719
;719:				if (bs->curpatrolpoint->prev) {
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
INDIRP4
CNSTI4 96
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $395
line 720
;720:					bs->curpatrolpoint = bs->curpatrolpoint->prev;
ADDRLP4 640
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
ASGNP4
ADDRLP4 640
INDIRP4
ADDRLP4 640
INDIRP4
INDIRP4
CNSTI4 96
ADDP4
INDIRP4
ASGNP4
line 721
;721:				}
ADDRGP4 $394
JUMPV
LABELV $395
line 722
;722:				else {
line 723
;723:					bs->curpatrolpoint = bs->curpatrolpoint->next;
ADDRLP4 640
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
ASGNP4
ADDRLP4 640
INDIRP4
ADDRLP4 640
INDIRP4
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
line 724
;724:					bs->patrolflags &= ~PATROL_BACK;
ADDRLP4 644
ADDRFP4 0
INDIRP4
CNSTI4 9084
ADDP4
ASGNP4
ADDRLP4 644
INDIRP4
ADDRLP4 644
INDIRP4
INDIRI4
CNSTI4 -5
BANDI4
ASGNI4
line 725
;725:				}
line 726
;726:			}
ADDRGP4 $394
JUMPV
LABELV $393
line 727
;727:			else {
line 728
;728:				if (bs->curpatrolpoint->next) {
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $397
line 729
;729:					bs->curpatrolpoint = bs->curpatrolpoint->next;
ADDRLP4 640
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
ASGNP4
ADDRLP4 640
INDIRP4
ADDRLP4 640
INDIRP4
INDIRP4
CNSTI4 92
ADDP4
INDIRP4
ASGNP4
line 730
;730:				}
ADDRGP4 $398
JUMPV
LABELV $397
line 731
;731:				else {
line 732
;732:					bs->curpatrolpoint = bs->curpatrolpoint->prev;
ADDRLP4 640
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
ASGNP4
ADDRLP4 640
INDIRP4
ADDRLP4 640
INDIRP4
INDIRP4
CNSTI4 96
ADDP4
INDIRP4
ASGNP4
line 733
;733:					bs->patrolflags |= PATROL_BACK;
ADDRLP4 644
ADDRFP4 0
INDIRP4
CNSTI4 9084
ADDP4
ASGNP4
ADDRLP4 644
INDIRP4
ADDRLP4 644
INDIRP4
INDIRI4
CNSTI4 4
BORI4
ASGNI4
line 734
;734:				}
LABELV $398
line 735
;735:			}
LABELV $394
line 736
;736:		}
LABELV $391
line 738
;737:		//stop after 5 minutes
;738:		if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $399
line 739
;739:			BotAI_BotInitialChat(bs, "patrol_stop", NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $401
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 740
;740:			trap_BotEnterChat(bs->cs, bs->decisionmaker, CHAT_TELL);
ADDRLP4 640
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 640
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 640
INDIRP4
CNSTI4 6608
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 741
;741:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 742
;742:		}
LABELV $399
line 743
;743:		if (!bs->curpatrolpoint) {
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $402
line 744
;744:			bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 745
;745:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $402
line 747
;746:		}
;747:		memcpy(goal, &bs->curpatrolpoint->goal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 9080
ADDP4
INDIRP4
CNSTI4 36
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 748
;748:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $377
line 751
;749:	}
;750:#ifdef CTF
;751:	if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $404
line 753
;752:		//if going for enemy flag
;753:		if (bs->ltgtype == LTG_GETFLAG) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 4
NEI4 $406
line 755
;754:			//check for bot typing status message
;755:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 628
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 628
INDIRF4
CNSTF4 0
EQF4 $408
ADDRLP4 628
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $408
line 756
;756:				BotAI_BotInitialChat(bs, "captureflag_start", NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $410
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 757
;757:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 758
;758:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONGETFLAG);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 $411
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 759
;759:				bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 760
;760:			}
LABELV $408
line 762
;761:			//
;762:			switch(BotTeam(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 636
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 632
ADDRLP4 636
INDIRI4
ASGNI4
ADDRLP4 632
INDIRI4
CNSTI4 1
EQI4 $415
ADDRLP4 632
INDIRI4
CNSTI4 2
EQI4 $416
ADDRGP4 $412
JUMPV
LABELV $415
line 763
;763:				case TEAM_RED: memcpy(goal, &ctf_blueflag, sizeof(bot_goal_t)); break;
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 ctf_blueflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $413
JUMPV
LABELV $416
line 764
;764:				case TEAM_BLUE: memcpy(goal, &ctf_redflag, sizeof(bot_goal_t)); break;
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 ctf_redflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $413
JUMPV
LABELV $412
line 765
;765:				default: bs->ltgtype = 0; return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $413
line 768
;766:			}
;767:			//if touching the flag
;768:			if (trap_BotTouchingGoal(bs->origin, goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 644
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 644
INDIRI4
CNSTI4 0
EQI4 $417
line 770
;769:				// make sure the bot knows the flag isn't there anymore
;770:				switch(BotTeam(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 652
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 648
ADDRLP4 652
INDIRI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 1
EQI4 $422
ADDRLP4 648
INDIRI4
CNSTI4 2
EQI4 $423
ADDRGP4 $419
JUMPV
LABELV $422
line 771
;771:					case TEAM_RED: bs->blueflagstatus = 1; break;
ADDRFP4 0
INDIRP4
CNSTI4 6956
ADDP4
CNSTI4 1
ASGNI4
ADDRGP4 $420
JUMPV
LABELV $423
line 772
;772:					case TEAM_BLUE: bs->redflagstatus = 1; break;
ADDRFP4 0
INDIRP4
CNSTI4 6952
ADDP4
CNSTI4 1
ASGNI4
LABELV $419
LABELV $420
line 774
;773:				}
;774:				bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 775
;775:			}
LABELV $417
line 777
;776:			//stop after 3 minutes
;777:			if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $424
line 778
;778:				bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 779
;779:			}
LABELV $424
line 780
;780:			BotAlternateRoute(bs, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 BotAlternateRoute
CALLP4
pop
line 781
;781:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $406
line 784
;782:		}
;783:		//if rushing to the base
;784:		if (bs->ltgtype == LTG_RUSHBASE && bs->rushbaseaway_time < FloatTime()) {
ADDRLP4 628
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 628
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 5
NEI4 $426
ADDRLP4 628
INDIRP4
CNSTI4 6152
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $426
line 785
;785:			switch(BotTeam(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 636
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 632
ADDRLP4 636
INDIRI4
ASGNI4
ADDRLP4 632
INDIRI4
CNSTI4 1
EQI4 $431
ADDRLP4 632
INDIRI4
CNSTI4 2
EQI4 $432
ADDRGP4 $428
JUMPV
LABELV $431
line 786
;786:				case TEAM_RED: memcpy(goal, &ctf_redflag, sizeof(bot_goal_t)); break;
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 ctf_redflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $429
JUMPV
LABELV $432
line 787
;787:				case TEAM_BLUE: memcpy(goal, &ctf_blueflag, sizeof(bot_goal_t)); break;
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 ctf_blueflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $429
JUMPV
LABELV $428
line 788
;788:				default: bs->ltgtype = 0; return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $429
line 791
;789:			}
;790:			//if not carrying the flag anymore
;791:			if (!BotCTFCarryingFlag(bs)) bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 644
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 644
INDIRI4
CNSTI4 0
NEI4 $433
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
LABELV $433
line 793
;792:			//quit rushing after 2 minutes
;793:			if (bs->teamgoal_time < FloatTime()) bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $435
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
LABELV $435
line 795
;794:			//if touching the base flag the bot should loose the enemy flag
;795:			if (trap_BotTouchingGoal(bs->origin, goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 648
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 0
EQI4 $437
line 798
;796:				//if the bot is still carrying the enemy flag then the
;797:				//base flag is gone, now just walk near the base a bit
;798:				if (BotCTFCarryingFlag(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 652
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 652
INDIRI4
CNSTI4 0
EQI4 $439
line 799
;799:					trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 800
;800:					bs->rushbaseaway_time = FloatTime() + 5 + 10 * random();
ADDRLP4 656
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 6152
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
CNSTF4 1092616192
ADDRLP4 656
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
MULF4
ADDF4
ASGNF4
line 802
;801:					//FIXME: add chat to tell the others to get back the flag
;802:				}
ADDRGP4 $440
JUMPV
LABELV $439
line 803
;803:				else {
line 804
;804:					bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 805
;805:				}
LABELV $440
line 806
;806:			}
LABELV $437
line 807
;807:			BotAlternateRoute(bs, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 BotAlternateRoute
CALLP4
pop
line 808
;808:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $426
line 811
;809:		}
;810:		//returning flag
;811:		if (bs->ltgtype == LTG_RETURNFLAG) {
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 6
NEI4 $441
line 813
;812:			//check for bot typing status message
;813:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
ADDRLP4 632
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
INDIRF4
ASGNF4
ADDRLP4 632
INDIRF4
CNSTF4 0
EQF4 $443
ADDRLP4 632
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $443
line 814
;814:				BotAI_BotInitialChat(bs, "returnflag_start", NULL);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $445
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 815
;815:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
ADDRFP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 816
;816:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONRETURNFLAG);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 $446
ARGP4
ADDRGP4 BotVoiceChatOnly
CALLV
pop
line 817
;817:				bs->teammessage_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6740
ADDP4
CNSTF4 0
ASGNF4
line 818
;818:			}
LABELV $443
line 820
;819:			//
;820:			switch(BotTeam(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 640
ADDRGP4 BotTeam
CALLI4
ASGNI4
ADDRLP4 636
ADDRLP4 640
INDIRI4
ASGNI4
ADDRLP4 636
INDIRI4
CNSTI4 1
EQI4 $450
ADDRLP4 636
INDIRI4
CNSTI4 2
EQI4 $451
ADDRGP4 $447
JUMPV
LABELV $450
line 821
;821:				case TEAM_RED: memcpy(goal, &ctf_blueflag, sizeof(bot_goal_t)); break;
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 ctf_blueflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $448
JUMPV
LABELV $451
line 822
;822:				case TEAM_BLUE: memcpy(goal, &ctf_redflag, sizeof(bot_goal_t)); break;
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 ctf_redflag
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRGP4 $448
JUMPV
LABELV $447
line 823
;823:				default: bs->ltgtype = 0; return qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
CNSTI4 0
RETI4
ADDRGP4 $130
JUMPV
LABELV $448
line 826
;824:			}
;825:			//if touching the flag
;826:			if (trap_BotTouchingGoal(bs->origin, goal)) bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 648
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 648
INDIRI4
CNSTI4 0
EQI4 $452
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
LABELV $452
line 828
;827:			//stop after 3 minutes
;828:			if (bs->teamgoal_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6744
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $454
line 829
;829:				bs->ltgtype = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
CNSTI4 0
ASGNI4
line 830
;830:			}
LABELV $454
line 831
;831:			BotAlternateRoute(bs, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRGP4 BotAlternateRoute
CALLP4
pop
line 832
;832:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $130
JUMPV
LABELV $441
line 834
;833:		}
;834:	}
LABELV $404
line 1034
;835:#endif //CTF
;836:#ifdef MISSIONPACK
;837:	else if (gametype == GT_1FCTF) {
;838:		if (bs->ltgtype == LTG_GETFLAG) {
;839:			//check for bot typing status message
;840:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
;841:				BotAI_BotInitialChat(bs, "captureflag_start", NULL);
;842:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
;843:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONGETFLAG);
;844:				bs->teammessage_time = 0;
;845:			}
;846:			memcpy(goal, &ctf_neutralflag, sizeof(bot_goal_t));
;847:			//if touching the flag
;848:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;849:				bs->ltgtype = 0;
;850:			}
;851:			//stop after 3 minutes
;852:			if (bs->teamgoal_time < FloatTime()) {
;853:				bs->ltgtype = 0;
;854:			}
;855:			return qtrue;
;856:		}
;857:		//if rushing to the base
;858:		if (bs->ltgtype == LTG_RUSHBASE) {
;859:			switch(BotTeam(bs)) {
;860:				case TEAM_RED: memcpy(goal, &ctf_blueflag, sizeof(bot_goal_t)); break;
;861:				case TEAM_BLUE: memcpy(goal, &ctf_redflag, sizeof(bot_goal_t)); break;
;862:				default: bs->ltgtype = 0; return qfalse;
;863:			}
;864:			//if not carrying the flag anymore
;865:			if (!Bot1FCTFCarryingFlag(bs)) {
;866:				bs->ltgtype = 0;
;867:			}
;868:			//quit rushing after 2 minutes
;869:			if (bs->teamgoal_time < FloatTime()) {
;870:				bs->ltgtype = 0;
;871:			}
;872:			//if touching the base flag the bot should loose the enemy flag
;873:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;874:				bs->ltgtype = 0;
;875:			}
;876:			BotAlternateRoute(bs, goal);
;877:			return qtrue;
;878:		}
;879:		//attack the enemy base
;880:		if (bs->ltgtype == LTG_ATTACKENEMYBASE &&
;881:				bs->attackaway_time < FloatTime()) {
;882:			//check for bot typing status message
;883:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
;884:				BotAI_BotInitialChat(bs, "attackenemybase_start", NULL);
;885:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
;886:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONOFFENSE);
;887:				bs->teammessage_time = 0;
;888:			}
;889:			switch(BotTeam(bs)) {
;890:				case TEAM_RED: memcpy(goal, &ctf_blueflag, sizeof(bot_goal_t)); break;
;891:				case TEAM_BLUE: memcpy(goal, &ctf_redflag, sizeof(bot_goal_t)); break;
;892:				default: bs->ltgtype = 0; return qfalse;
;893:			}
;894:			//quit rushing after 2 minutes
;895:			if (bs->teamgoal_time < FloatTime()) {
;896:				bs->ltgtype = 0;
;897:			}
;898:			//if touching the base flag the bot should loose the enemy flag
;899:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;900:				bs->attackaway_time = FloatTime() + 2 + 5 * random();
;901:			}
;902:			return qtrue;
;903:		}
;904:		//returning flag
;905:		if (bs->ltgtype == LTG_RETURNFLAG) {
;906:			//check for bot typing status message
;907:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
;908:				BotAI_BotInitialChat(bs, "returnflag_start", NULL);
;909:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
;910:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONRETURNFLAG);
;911:				bs->teammessage_time = 0;
;912:			}
;913:			//
;914:			if (bs->teamgoal_time < FloatTime()) {
;915:				bs->ltgtype = 0;
;916:			}
;917:			//just roam around
;918:			return BotGetItemLongTermGoal(bs, tfl, goal);
;919:		}
;920:	}
;921:	else if (gametype == GT_OBELISK) {
;922:		if (bs->ltgtype == LTG_ATTACKENEMYBASE &&
;923:				bs->attackaway_time < FloatTime()) {
;924:
;925:			//check for bot typing status message
;926:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
;927:				BotAI_BotInitialChat(bs, "attackenemybase_start", NULL);
;928:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
;929:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONOFFENSE);
;930:				bs->teammessage_time = 0;
;931:			}
;932:			switch(BotTeam(bs)) {
;933:				case TEAM_RED: memcpy(goal, &blueobelisk, sizeof(bot_goal_t)); break;
;934:				case TEAM_BLUE: memcpy(goal, &redobelisk, sizeof(bot_goal_t)); break;
;935:				default: bs->ltgtype = 0; return qfalse;
;936:			}
;937:			//if the bot no longer wants to attack the obelisk
;938:			if (BotFeelingBad(bs) > 50) {
;939:				return BotGetItemLongTermGoal(bs, tfl, goal);
;940:			}
;941:			//if touching the obelisk
;942:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;943:				bs->attackaway_time = FloatTime() + 3 + 5 * random();
;944:			}
;945:			// or very close to the obelisk
;946:			VectorSubtract(bs->origin, goal->origin, dir);
;947:			if (VectorLengthSquared(dir) < Square(60)) {
;948:				bs->attackaway_time = FloatTime() + 3 + 5 * random();
;949:			}
;950:			//quit rushing after 2 minutes
;951:			if (bs->teamgoal_time < FloatTime()) {
;952:				bs->ltgtype = 0;
;953:			}
;954:			BotAlternateRoute(bs, goal);
;955:			//just move towards the obelisk
;956:			return qtrue;
;957:		}
;958:	}
;959:	else if (gametype == GT_HARVESTER) {
;960:		//if rushing to the base
;961:		if (bs->ltgtype == LTG_RUSHBASE) {
;962:			switch(BotTeam(bs)) {
;963:				case TEAM_RED: memcpy(goal, &blueobelisk, sizeof(bot_goal_t)); break;
;964:				case TEAM_BLUE: memcpy(goal, &redobelisk, sizeof(bot_goal_t)); break;
;965:				default: BotGoHarvest(bs); return qfalse;
;966:			}
;967:			//if not carrying any cubes
;968:			if (!BotHarvesterCarryingCubes(bs)) {
;969:				BotGoHarvest(bs);
;970:				return qfalse;
;971:			}
;972:			//quit rushing after 2 minutes
;973:			if (bs->teamgoal_time < FloatTime()) {
;974:				BotGoHarvest(bs);
;975:				return qfalse;
;976:			}
;977:			//if touching the base flag the bot should loose the enemy flag
;978:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;979:				BotGoHarvest(bs);
;980:				return qfalse;
;981:			}
;982:			BotAlternateRoute(bs, goal);
;983:			return qtrue;
;984:		}
;985:		//attack the enemy base
;986:		if (bs->ltgtype == LTG_ATTACKENEMYBASE &&
;987:				bs->attackaway_time < FloatTime()) {
;988:			//check for bot typing status message
;989:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
;990:				BotAI_BotInitialChat(bs, "attackenemybase_start", NULL);
;991:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
;992:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONOFFENSE);
;993:				bs->teammessage_time = 0;
;994:			}
;995:			switch(BotTeam(bs)) {
;996:				case TEAM_RED: memcpy(goal, &blueobelisk, sizeof(bot_goal_t)); break;
;997:				case TEAM_BLUE: memcpy(goal, &redobelisk, sizeof(bot_goal_t)); break;
;998:				default: bs->ltgtype = 0; return qfalse;
;999:			}
;1000:			//quit rushing after 2 minutes
;1001:			if (bs->teamgoal_time < FloatTime()) {
;1002:				bs->ltgtype = 0;
;1003:			}
;1004:			//if touching the base flag the bot should loose the enemy flag
;1005:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;1006:				bs->attackaway_time = FloatTime() + 2 + 5 * random();
;1007:			}
;1008:			return qtrue;
;1009:		}
;1010:		//harvest cubes
;1011:		if (bs->ltgtype == LTG_HARVEST &&
;1012:			bs->harvestaway_time < FloatTime()) {
;1013:			//check for bot typing status message
;1014:			if (bs->teammessage_time && bs->teammessage_time < FloatTime()) {
;1015:				BotAI_BotInitialChat(bs, "harvest_start", NULL);
;1016:				trap_BotEnterChat(bs->cs, 0, CHAT_TEAM);
;1017:				BotVoiceChatOnly(bs, -1, VOICECHAT_ONOFFENSE);
;1018:				bs->teammessage_time = 0;
;1019:			}
;1020:			memcpy(goal, &neutralobelisk, sizeof(bot_goal_t));
;1021:			//
;1022:			if (bs->teamgoal_time < FloatTime()) {
;1023:				bs->ltgtype = 0;
;1024:			}
;1025:			//
;1026:			if (trap_BotTouchingGoal(bs->origin, goal)) {
;1027:				bs->harvestaway_time = FloatTime() + 4 + 3 * random();
;1028:			}
;1029:			return qtrue;
;1030:		}
;1031:	}
;1032:#endif
;1033:	//normal goal stuff
;1034:	return BotGetItemLongTermGoal(bs, tfl, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 628
ADDRGP4 BotGetItemLongTermGoal
CALLI4
ASGNI4
ADDRLP4 628
INDIRI4
RETI4
LABELV $130
endproc BotGetLongTermGoal 664 20
export BotLongTermGoal
proc BotLongTermGoal 452 20
line 1042
;1035:}
;1036:
;1037:/*
;1038:==================
;1039:BotLongTermGoal
;1040:==================
;1041:*/
;1042:int BotLongTermGoal(bot_state_t *bs, int tfl, int retreat, bot_goal_t *goal) {
line 1049
;1043:	aas_entityinfo_t entinfo;
;1044:	char teammate[MAX_MESSAGE_SIZE];
;1045:	float squaredist;
;1046:	int areanum;
;1047:	vec3_t dir;
;1048:	
;1049:	if( bs->ltgtype == LTG_ASSAULT_ATTACK ||
ADDRLP4 416
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
ASGNI4
ADDRLP4 416
INDIRI4
CNSTI4 16
EQI4 $459
ADDRLP4 416
INDIRI4
CNSTI4 17
NEI4 $457
LABELV $459
line 1050
;1050:		bs->ltgtype == LTG_ASSAULT_DEFEND ) {
line 1051
;1051:		memcpy(
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6624
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 1057
;1052:			goal,
;1053:			&bs->teamgoal,
;1054:			sizeof(bot_goal_t)
;1055:		);
;1056:
;1057:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $456
JUMPV
LABELV $457
line 1063
;1058:	}
;1059:
;1060:	//FIXME: also have air long term goals?
;1061:	//
;1062:	//if the bot is leading someone and not retreating
;1063:	if (bs->lead_time > 0 && !retreat) {
ADDRFP4 0
INDIRP4
CNSTI4 6884
ADDP4
INDIRF4
CNSTF4 0
LEF4 $460
ADDRFP4 8
INDIRI4
CNSTI4 0
NEI4 $460
line 1064
;1064:		if (bs->lead_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6884
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $462
line 1065
;1065:			BotAI_BotInitialChat(bs, "lead_stop", EasyClientName(bs->lead_teammate, teammate, sizeof(teammate)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ARGI4
ADDRLP4 152
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 420
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $464
ARGP4
ADDRLP4 420
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 1066
;1066:			trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 424
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 424
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 424
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1067
;1067:			bs->lead_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6884
ADDP4
CNSTF4 0
ASGNF4
line 1068
;1068:			return BotGetLongTermGoal(bs, tfl, retreat, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRI4
ARGI4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 428
ADDRGP4 BotGetLongTermGoal
CALLI4
ASGNI4
ADDRLP4 428
INDIRI4
RETI4
ADDRGP4 $456
JUMPV
LABELV $462
line 1071
;1069:		}
;1070:		//
;1071:		if (bs->leadmessage_time < 0 && -bs->leadmessage_time < FloatTime()) {
ADDRLP4 420
ADDRFP4 0
INDIRP4
CNSTI4 6892
ADDP4
INDIRF4
ASGNF4
ADDRLP4 420
INDIRF4
CNSTF4 0
GEF4 $465
ADDRLP4 420
INDIRF4
NEGF4
ADDRGP4 floattime
INDIRF4
GEF4 $465
line 1072
;1072:			BotAI_BotInitialChat(bs, "followme", EasyClientName(bs->lead_teammate, teammate, sizeof(teammate)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ARGI4
ADDRLP4 152
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 424
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $467
ARGP4
ADDRLP4 424
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 1073
;1073:			trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 428
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 428
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 428
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1074
;1074:			bs->leadmessage_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6892
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 1075
;1075:		}
LABELV $465
line 1077
;1076:		//get entity information of the companion
;1077:		BotEntityInfo(bs->lead_teammate, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 1079
;1078:		//
;1079:		if (entinfo.valid) {
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $468
line 1080
;1080:			areanum = BotPointAreaNum(entinfo.origin);
ADDRLP4 12+24
ARGP4
ADDRLP4 424
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 412
ADDRLP4 424
INDIRI4
ASGNI4
line 1081
;1081:			if (areanum && trap_AAS_AreaReachability(areanum)) {
ADDRLP4 428
ADDRLP4 412
INDIRI4
ASGNI4
ADDRLP4 428
INDIRI4
CNSTI4 0
EQI4 $471
ADDRLP4 428
INDIRI4
ARGI4
ADDRLP4 432
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 432
INDIRI4
CNSTI4 0
EQI4 $471
line 1083
;1082:				//update team goal
;1083:				bs->lead_teamgoal.entitynum = bs->lead_teammate;
ADDRLP4 436
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 436
INDIRP4
CNSTI4 6868
ADDP4
ADDRLP4 436
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ASGNI4
line 1084
;1084:				bs->lead_teamgoal.areanum = areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6840
ADDP4
ADDRLP4 412
INDIRI4
ASGNI4
line 1085
;1085:				VectorCopy(entinfo.origin, bs->lead_teamgoal.origin);
ADDRFP4 0
INDIRP4
CNSTI4 6828
ADDP4
ADDRLP4 12+24
INDIRB
ASGNB 12
line 1086
;1086:				VectorSet(bs->lead_teamgoal.mins, -8, -8, -8);
ADDRFP4 0
INDIRP4
CNSTI4 6844
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6848
ADDP4
CNSTF4 3238002688
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6852
ADDP4
CNSTF4 3238002688
ASGNF4
line 1087
;1087:				VectorSet(bs->lead_teamgoal.maxs, 8, 8, 8);
ADDRFP4 0
INDIRP4
CNSTI4 6856
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6860
ADDP4
CNSTF4 1090519040
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 6864
ADDP4
CNSTF4 1090519040
ASGNF4
line 1088
;1088:			}
LABELV $471
line 1089
;1089:		}
LABELV $468
line 1091
;1090:		//if the team mate is visible
;1091:		if (BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->lead_teammate)) {
ADDRLP4 424
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 424
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 424
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 424
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 424
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ARGI4
ADDRLP4 428
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 428
INDIRF4
CNSTF4 0
EQF4 $474
line 1092
;1092:			bs->leadvisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6888
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 1093
;1093:		}
LABELV $474
line 1095
;1094:		//if the team mate is not visible for 1 seconds
;1095:		if (bs->leadvisible_time < FloatTime() - 1) {
ADDRFP4 0
INDIRP4
CNSTI4 6888
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $476
line 1096
;1096:			bs->leadbackup_time = FloatTime() + 2;
ADDRFP4 0
INDIRP4
CNSTI4 6896
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
ADDF4
ASGNF4
line 1097
;1097:		}
LABELV $476
line 1099
;1098:		//distance towards the team mate
;1099:		VectorSubtract(bs->origin, bs->lead_teamgoal.origin, dir);
ADDRLP4 432
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 432
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
ADDRLP4 432
INDIRP4
CNSTI4 6828
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 432
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
ADDRLP4 432
INDIRP4
CNSTI4 6832
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 436
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0+8
ADDRLP4 436
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
ADDRLP4 436
INDIRP4
CNSTI4 6836
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1100
;1100:		squaredist = VectorLengthSquared(dir);
ADDRLP4 0
ARGP4
ADDRLP4 440
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 408
ADDRLP4 440
INDIRF4
ASGNF4
line 1102
;1101:		//if backing up towards the team mate
;1102:		if (bs->leadbackup_time > FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6896
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $480
line 1103
;1103:			if (bs->leadmessage_time < FloatTime() - 20) {
ADDRFP4 0
INDIRP4
CNSTI4 6892
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1101004800
SUBF4
GEF4 $482
line 1104
;1104:				BotAI_BotInitialChat(bs, "followme", EasyClientName(bs->lead_teammate, teammate, sizeof(teammate)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ARGI4
ADDRLP4 152
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 444
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $467
ARGP4
ADDRLP4 444
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 1105
;1105:				trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 448
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 448
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 448
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1106
;1106:				bs->leadmessage_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6892
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 1107
;1107:			}
LABELV $482
line 1109
;1108:			//if very close to the team mate
;1109:			if (squaredist < Square(100)) {
ADDRLP4 408
INDIRF4
CNSTF4 1176256512
GEF4 $484
line 1110
;1110:				bs->leadbackup_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6896
ADDP4
CNSTF4 0
ASGNF4
line 1111
;1111:			}
LABELV $484
line 1113
;1112:			//the bot should go back to the team mate
;1113:			memcpy(goal, &bs->lead_teamgoal, sizeof(bot_goal_t));
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6828
ADDP4
ARGP4
CNSTI4 56
ARGI4
ADDRGP4 memcpy
CALLP4
pop
line 1114
;1114:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $456
JUMPV
LABELV $480
line 1116
;1115:		}
;1116:		else {
line 1118
;1117:			//if quite distant from the team mate
;1118:			if (squaredist > Square(500)) {
ADDRLP4 408
INDIRF4
CNSTF4 1215570944
LEF4 $486
line 1119
;1119:				if (bs->leadmessage_time < FloatTime() - 20) {
ADDRFP4 0
INDIRP4
CNSTI4 6892
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1101004800
SUBF4
GEF4 $488
line 1120
;1120:					BotAI_BotInitialChat(bs, "followme", EasyClientName(bs->lead_teammate, teammate, sizeof(teammate)), NULL);
ADDRFP4 0
INDIRP4
CNSTI4 6824
ADDP4
INDIRI4
ARGI4
ADDRLP4 152
ARGP4
CNSTI4 256
ARGI4
ADDRLP4 444
ADDRGP4 EasyClientName
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $467
ARGP4
ADDRLP4 444
INDIRP4
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 BotAI_BotInitialChat
CALLV
pop
line 1121
;1121:					trap_BotEnterChat(bs->cs, bs->teammate, CHAT_TELL);
ADDRLP4 448
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 448
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
ADDRLP4 448
INDIRP4
CNSTI4 6604
ADDP4
INDIRI4
ARGI4
CNSTI4 2
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1122
;1122:					bs->leadmessage_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6892
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 1123
;1123:				}
LABELV $488
line 1125
;1124:				//look at the team mate
;1125:				VectorSubtract(entinfo.origin, bs->origin, dir);
ADDRLP4 444
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 12+24
INDIRF4
ADDRLP4 444
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 12+24+4
INDIRF4
ADDRLP4 444
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
line 1126
;1126:				vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 0
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1127
;1127:				bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 448
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 448
INDIRP4
CNSTF4 1056964608
ADDRLP4 448
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1129
;1128:				//just wait for the team mate
;1129:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $456
JUMPV
LABELV $486
line 1131
;1130:			}
;1131:		}
line 1132
;1132:	}
LABELV $460
line 1133
;1133:	return BotGetLongTermGoal(bs, tfl, retreat, goal);
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 8
INDIRI4
ARGI4
ADDRFP4 12
INDIRP4
ARGP4
ADDRLP4 420
ADDRGP4 BotGetLongTermGoal
CALLI4
ASGNI4
ADDRLP4 420
INDIRI4
RETI4
LABELV $456
endproc BotLongTermGoal 452 20
export AIEnter_Intermission
proc AIEnter_Intermission 8 16
line 1141
;1134:}
;1135:
;1136:/*
;1137:==================
;1138:AIEnter_Intermission
;1139:==================
;1140:*/
;1141:void AIEnter_Intermission(bot_state_t *bs, char *s) {
line 1142
;1142:	BotRecordNodeSwitch(bs, "intermission", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $498
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1144
;1143:	//reset the bot state
;1144:	BotResetState(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotResetState
CALLV
pop
line 1146
;1145:	//check for end level chat
;1146:	if (BotChat_EndLevel(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotChat_EndLevel
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $499
line 1147
;1147:		trap_BotEnterChat(bs->cs, 0, bs->chatto);
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 6052
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1148
;1148:	}
LABELV $499
line 1149
;1149:	bs->ainode = AINode_Intermission;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Intermission
ASGNP4
line 1150
;1150:}
LABELV $497
endproc AIEnter_Intermission 8 16
export AINode_Intermission
proc AINode_Intermission 16 8
line 1157
;1151:
;1152:/*
;1153:==================
;1154:AINode_Intermission
;1155:==================
;1156:*/
;1157:int AINode_Intermission(bot_state_t *bs) {
line 1159
;1158:	//if the intermission ended
;1159:	if (!BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $502
line 1160
;1160:		if (BotChat_StartLevel(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 BotChat_StartLevel
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $504
line 1161
;1161:			bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
ASGNF4
line 1162
;1162:		}
ADDRGP4 $505
JUMPV
LABELV $504
line 1163
;1163:		else {
line 1164
;1164:			bs->stand_time = FloatTime() + 2;
ADDRFP4 0
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
ADDF4
ASGNF4
line 1165
;1165:		}
LABELV $505
line 1166
;1166:		AIEnter_Stand(bs, "intermission: chat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $506
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 1167
;1167:	}
LABELV $502
line 1168
;1168:	return qtrue;
CNSTI4 1
RETI4
LABELV $501
endproc AINode_Intermission 16 8
export AIEnter_Observer
proc AIEnter_Observer 0 16
line 1176
;1169:}
;1170:
;1171:/*
;1172:==================
;1173:AIEnter_Observer
;1174:==================
;1175:*/
;1176:void AIEnter_Observer(bot_state_t *bs, char *s) {
line 1177
;1177:	BotRecordNodeSwitch(bs, "observer", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $508
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1179
;1178:	//reset the bot state
;1179:	BotResetState(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotResetState
CALLV
pop
line 1180
;1180:	bs->ainode = AINode_Observer;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Observer
ASGNP4
line 1181
;1181:}
LABELV $507
endproc AIEnter_Observer 0 16
export AINode_Observer
proc AINode_Observer 4 8
line 1188
;1182:
;1183:/*
;1184:==================
;1185:AINode_Observer
;1186:==================
;1187:*/
;1188:int AINode_Observer(bot_state_t *bs) {
line 1190
;1189:	//if the bot left observer mode
;1190:	if (!BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $510
line 1191
;1191:		AIEnter_Stand(bs, "observer: left observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $512
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 1192
;1192:	}
LABELV $510
line 1193
;1193:	return qtrue;
CNSTI4 1
RETI4
LABELV $509
endproc AINode_Observer 4 8
export AIEnter_Stand
proc AIEnter_Stand 0 16
line 1201
;1194:}
;1195:
;1196:/*
;1197:==================
;1198:AIEnter_Stand
;1199:==================
;1200:*/
;1201:void AIEnter_Stand(bot_state_t *bs, char *s) {
line 1202
;1202:	BotRecordNodeSwitch(bs, "stand", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $514
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1203
;1203:	bs->standfindenemy_time = FloatTime() + 1;
ADDRFP4 0
INDIRP4
CNSTI4 6112
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 1204
;1204:	bs->ainode = AINode_Stand;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Stand
ASGNP4
line 1205
;1205:}
LABELV $513
endproc AIEnter_Stand 0 16
export AINode_Stand
proc AINode_Stand 24 12
line 1212
;1206:
;1207:/*
;1208:==================
;1209:AINode_Stand
;1210:==================
;1211:*/
;1212:int AINode_Stand(bot_state_t *bs) {
line 1215
;1213:
;1214:	//if the bot's health decreased
;1215:	if (bs->lastframe_health > bs->inventory[INVENTORY_HEALTH]) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 6044
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
LEI4 $516
line 1216
;1216:		if (BotChat_HitTalking(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 BotChat_HitTalking
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $518
line 1217
;1217:			bs->standfindenemy_time = FloatTime() + BotChatTime(bs) + 0.1;
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 6112
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 12
INDIRF4
ADDF4
CNSTF4 1036831949
ADDF4
ASGNF4
line 1218
;1218:			bs->stand_time = FloatTime() + BotChatTime(bs) + 0.1;
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 16
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 20
INDIRF4
ADDF4
CNSTF4 1036831949
ADDF4
ASGNF4
line 1219
;1219:		}
LABELV $518
line 1220
;1220:	}
LABELV $516
line 1221
;1221:	if (bs->standfindenemy_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6112
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $520
line 1222
;1222:		if (BotFindEnemy(bs, -1)) {
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 4
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $522
line 1223
;1223:			AIEnter_Battle_Fight(bs, "stand: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $524
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 1224
;1224:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $515
JUMPV
LABELV $522
line 1226
;1225:		}
;1226:		bs->standfindenemy_time = FloatTime() + 1;
ADDRFP4 0
INDIRP4
CNSTI4 6112
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 1227
;1227:	}
LABELV $520
line 1229
;1228:	// put up chat icon
;1229:	trap_EA_Talk(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Talk
CALLV
pop
line 1231
;1230:	// when done standing
;1231:	if (bs->stand_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6096
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $525
line 1232
;1232:		trap_BotEnterChat(bs->cs, 0, bs->chatto);
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 4
INDIRP4
CNSTI4 6052
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1233
;1233:		AIEnter_Seek_LTG(bs, "stand: time out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $527
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 1234
;1234:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $515
JUMPV
LABELV $525
line 1237
;1235:	}
;1236:	//
;1237:	return qtrue;
CNSTI4 1
RETI4
LABELV $515
endproc AINode_Stand 24 12
export AIEnter_Respawn
proc AIEnter_Respawn 12 16
line 1245
;1238:}
;1239:
;1240:/*
;1241:==================
;1242:AIEnter_Respawn
;1243:==================
;1244:*/
;1245:void AIEnter_Respawn(bot_state_t *bs, char *s) {
line 1246
;1246:	BotRecordNodeSwitch(bs, "respawn", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $529
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1248
;1247:	//reset some states
;1248:	trap_BotResetMoveState(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetMoveState
CALLV
pop
line 1249
;1249:	trap_BotResetGoalState(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetGoalState
CALLV
pop
line 1250
;1250:	trap_BotResetAvoidGoals(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidGoals
CALLV
pop
line 1251
;1251:	trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 1253
;1252:	//if the bot wants to chat
;1253:	if (BotChat_Death(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotChat_Death
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $530
line 1254
;1254:		bs->respawn_time = FloatTime() + BotChatTime(bs);
ADDRLP4 4
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 4
INDIRP4
CNSTI4 6076
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 8
INDIRF4
ADDF4
ASGNF4
line 1255
;1255:		bs->respawnchat_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6080
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 1256
;1256:	}
ADDRGP4 $531
JUMPV
LABELV $530
line 1257
;1257:	else {
line 1258
;1258:		bs->respawn_time = FloatTime() + 1 + random();
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 6076
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ADDRLP4 4
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
ADDF4
ASGNF4
line 1259
;1259:		bs->respawnchat_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6080
ADDP4
CNSTF4 0
ASGNF4
line 1260
;1260:	}
LABELV $531
line 1262
;1261:	//set respawn state
;1262:	bs->respawn_wait = qfalse;
ADDRFP4 0
INDIRP4
CNSTI4 5984
ADDP4
CNSTI4 0
ASGNI4
line 1263
;1263:	bs->ainode = AINode_Respawn;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Respawn
ASGNP4
line 1264
;1264:}
LABELV $528
endproc AIEnter_Respawn 12 16
export AINode_Respawn
proc AINode_Respawn 4 12
line 1271
;1265:
;1266:/*
;1267:==================
;1268:AINode_Respawn
;1269:==================
;1270:*/
;1271:int AINode_Respawn(bot_state_t *bs) {
line 1273
;1272:	// if waiting for the actual respawn
;1273:	if (bs->respawn_wait) {
ADDRFP4 0
INDIRP4
CNSTI4 5984
ADDP4
INDIRI4
CNSTI4 0
EQI4 $533
line 1274
;1274:		if (!BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $535
line 1275
;1275:			AIEnter_Seek_LTG(bs, "respawn: respawned");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $537
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 1276
;1276:		}
ADDRGP4 $534
JUMPV
LABELV $535
line 1277
;1277:		else {
line 1278
;1278:			trap_EA_Respawn(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Respawn
CALLV
pop
line 1279
;1279:		}
line 1280
;1280:	}
ADDRGP4 $534
JUMPV
LABELV $533
line 1281
;1281:	else if (bs->respawn_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6076
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $538
line 1283
;1282:		// wait until respawned
;1283:		bs->respawn_wait = qtrue;
ADDRFP4 0
INDIRP4
CNSTI4 5984
ADDP4
CNSTI4 1
ASGNI4
line 1285
;1284:		// elementary action respawn
;1285:		trap_EA_Respawn(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Respawn
CALLV
pop
line 1287
;1286:		//
;1287:		if (bs->respawnchat_time) {
ADDRFP4 0
INDIRP4
CNSTI4 6080
ADDP4
INDIRF4
CNSTF4 0
EQF4 $540
line 1288
;1288:			trap_BotEnterChat(bs->cs, 0, bs->chatto);
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 6532
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 6052
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEnterChat
CALLV
pop
line 1289
;1289:			bs->enemy = -1;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
CNSTI4 -1
ASGNI4
line 1290
;1290:		}
LABELV $540
line 1291
;1291:	}
LABELV $538
LABELV $534
line 1292
;1292:	if (bs->respawnchat_time && bs->respawnchat_time < FloatTime() - 0.5) {
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6080
ADDP4
INDIRF4
ASGNF4
ADDRLP4 0
INDIRF4
CNSTF4 0
EQF4 $542
ADDRLP4 0
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1056964608
SUBF4
GEF4 $542
line 1293
;1293:		trap_EA_Talk(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Talk
CALLV
pop
line 1294
;1294:	}
LABELV $542
line 1296
;1295:	//
;1296:	return qtrue;
CNSTI4 1
RETI4
LABELV $532
endproc AINode_Respawn 4 12
export BotSelectActivateWeapon
proc BotSelectActivateWeapon 56 0
line 1304
;1297:}
;1298:
;1299:/*
;1300:==================
;1301:BotSelectActivateWeapon
;1302:==================
;1303:*/
;1304:int BotSelectActivateWeapon(bot_state_t *bs) {
line 1306
;1305:	//
;1306:	if (bs->inventory[INVENTORY_MACHINEGUN] > 0 && bs->inventory[INVENTORY_BULLETS] > 0)
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 4976
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
LEI4 $545
ADDRLP4 0
INDIRP4
CNSTI4 5028
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
LEI4 $545
line 1307
;1307:		return WEAPONINDEX_MACHINEGUN;
CNSTI4 2
RETI4
ADDRGP4 $544
JUMPV
LABELV $545
line 1308
;1308:	else if (bs->inventory[INVENTORY_SHOTGUN] > 0 && bs->inventory[INVENTORY_SHELLS] > 0)
ADDRLP4 8
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 12
CNSTI4 0
ASGNI4
ADDRLP4 8
INDIRP4
CNSTI4 4972
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
LEI4 $547
ADDRLP4 8
INDIRP4
CNSTI4 5024
ADDP4
INDIRI4
ADDRLP4 12
INDIRI4
LEI4 $547
line 1309
;1309:		return WEAPONINDEX_SHOTGUN;
CNSTI4 3
RETI4
ADDRGP4 $544
JUMPV
LABELV $547
line 1310
;1310:	else if (bs->inventory[INVENTORY_PLASMAGUN] > 0 && bs->inventory[INVENTORY_CELLS] > 0)
ADDRLP4 16
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 16
INDIRP4
CNSTI4 4996
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
LEI4 $549
ADDRLP4 16
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
ADDRLP4 20
INDIRI4
LEI4 $549
line 1311
;1311:		return WEAPONINDEX_PLASMAGUN;
CNSTI4 8
RETI4
ADDRGP4 $544
JUMPV
LABELV $549
line 1312
;1312:	else if (bs->inventory[INVENTORY_LIGHTNING] > 0 && bs->inventory[INVENTORY_LIGHTNINGAMMO] > 0)
ADDRLP4 24
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRLP4 24
INDIRP4
CNSTI4 4988
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
LEI4 $551
ADDRLP4 24
INDIRP4
CNSTI4 5040
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
LEI4 $551
line 1313
;1313:		return WEAPONINDEX_LIGHTNING;
CNSTI4 6
RETI4
ADDRGP4 $544
JUMPV
LABELV $551
line 1320
;1314:#ifdef MISSIONPACK
;1315:	else if (bs->inventory[INVENTORY_CHAINGUN] > 0 && bs->inventory[INVENTORY_BELT] > 0)
;1316:		return WEAPONINDEX_CHAINGUN;
;1317:	else if (bs->inventory[INVENTORY_NAILGUN] > 0 && bs->inventory[INVENTORY_NAILS] > 0)
;1318:		return WEAPONINDEX_NAILGUN;
;1319:#endif
;1320:	else if (bs->inventory[INVENTORY_RAILGUN] > 0 && bs->inventory[INVENTORY_SLUGS] > 0)
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 32
INDIRP4
CNSTI4 4992
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $553
ADDRLP4 32
INDIRP4
CNSTI4 5048
ADDP4
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $553
line 1321
;1321:		return WEAPONINDEX_RAILGUN;
CNSTI4 7
RETI4
ADDRGP4 $544
JUMPV
LABELV $553
line 1322
;1322:	else if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 && bs->inventory[INVENTORY_ROCKETS] > 0)
ADDRLP4 40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 44
CNSTI4 0
ASGNI4
ADDRLP4 40
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $555
ADDRLP4 40
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
LEI4 $555
line 1323
;1323:		return WEAPONINDEX_ROCKET_LAUNCHER;
CNSTI4 5
RETI4
ADDRGP4 $544
JUMPV
LABELV $555
line 1324
;1324:	else if (bs->inventory[INVENTORY_BFG10K] > 0 && bs->inventory[INVENTORY_BFGAMMO] > 0)
ADDRLP4 48
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 52
CNSTI4 0
ASGNI4
ADDRLP4 48
INDIRP4
CNSTI4 5004
ADDP4
INDIRI4
ADDRLP4 52
INDIRI4
LEI4 $557
ADDRLP4 48
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
ADDRLP4 52
INDIRI4
LEI4 $557
line 1325
;1325:		return WEAPONINDEX_BFG;
CNSTI4 9
RETI4
ADDRGP4 $544
JUMPV
LABELV $557
line 1326
;1326:	else {
line 1327
;1327:		return -1;
CNSTI4 -1
RETI4
LABELV $544
endproc BotSelectActivateWeapon 56 0
export BotClearPath
proc BotClearPath 376 28
line 1338
;1328:	}
;1329:}
;1330:
;1331:/*
;1332:==================
;1333:BotClearPath
;1334:
;1335: try to deactivate obstacles like proximity mines on the bot's path
;1336:==================
;1337:*/
;1338:void BotClearPath(bot_state_t *bs, bot_moveresult_t *moveresult) {
line 1346
;1339:	int i, bestmine;
;1340:	float dist, bestdist;
;1341:	vec3_t target, dir;
;1342:	bsp_trace_t bsptrace;
;1343:	entityState_t state;
;1344:
;1345:	// if there is a dead body wearing kamikze nearby
;1346:	if (bs->kamikazebody) {
ADDRFP4 0
INDIRP4
CNSTI4 6256
ADDP4
INDIRI4
CNSTI4 0
EQI4 $560
line 1348
;1347:		// if the bot's view angles and weapon are not used for movement
;1348:		if ( !(moveresult->flags & (MOVERESULT_MOVEMENTVIEW | MOVERESULT_MOVEMENTWEAPON)) ) {
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 17
BANDI4
CNSTI4 0
NEI4 $562
line 1350
;1349:			//
;1350:			BotAI_GetEntityState(bs->kamikazebody, &state);
ADDRFP4 0
INDIRP4
CNSTI4 6256
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotAI_GetEntityState
CALLI4
pop
line 1351
;1351:			VectorCopy(state.pos.trBase, target);
ADDRLP4 236
ADDRLP4 12+12+12
INDIRB
ASGNB 12
line 1352
;1352:			target[2] += 8;
ADDRLP4 236+8
ADDRLP4 236+8
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 1353
;1353:			VectorSubtract(target, bs->eye, dir);
ADDRLP4 332
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 236
INDIRF4
ADDRLP4 332
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 236+4
INDIRF4
ADDRLP4 332
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 236+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1354
;1354:			vectoangles(dir, moveresult->ideal_viewangles);
ADDRLP4 0
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1356
;1355:			//
;1356:			moveresult->weapon = BotSelectActivateWeapon(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 336
ADDRGP4 BotSelectActivateWeapon
CALLI4
ASGNI4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
ADDRLP4 336
INDIRI4
ASGNI4
line 1357
;1357:			if (moveresult->weapon == -1) {
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 -1
NEI4 $571
line 1359
;1358:				// FIXME: run away!
;1359:				moveresult->weapon = 0;
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTI4 0
ASGNI4
line 1360
;1360:			}
LABELV $571
line 1361
;1361:			if (moveresult->weapon) {
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 0
EQI4 $573
line 1363
;1362:				//
;1363:				moveresult->flags |= MOVERESULT_MOVEMENTWEAPON | MOVERESULT_MOVEMENTVIEW;
ADDRLP4 340
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 340
INDIRP4
ADDRLP4 340
INDIRP4
INDIRI4
CNSTI4 17
BORI4
ASGNI4
line 1365
;1364:				// if holding the right weapon
;1365:				if (bs->cur_ps.weapon == moveresult->weapon) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
NEI4 $575
line 1367
;1366:					// if the bot is pretty close with it's aim
;1367:					if (InFieldOfVision(bs->viewangles, 20, moveresult->ideal_viewangles)) {
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1101004800
ARGF4
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
ARGP4
ADDRLP4 344
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
EQI4 $577
line 1369
;1368:						//
;1369:						BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, target, bs->entitynum, MASK_SHOT);
ADDRLP4 248
ARGP4
ADDRLP4 348
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 348
INDIRP4
CNSTI4 4936
ADDP4
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
ADDRLP4 236
ARGP4
ADDRLP4 348
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
line 1371
;1370:						// if the mine is visible from the current position
;1371:						if (bsptrace.fraction >= 1.0 || bsptrace.ent == state.number) {
ADDRLP4 248+8
INDIRF4
CNSTF4 1065353216
GEF4 $583
ADDRLP4 248+80
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $579
LABELV $583
line 1373
;1372:							// shoot at the mine
;1373:							trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 1374
;1374:						}
LABELV $579
line 1375
;1375:					}
LABELV $577
line 1376
;1376:				}
LABELV $575
line 1377
;1377:			}
LABELV $573
line 1378
;1378:		}
LABELV $562
line 1379
;1379:	}
LABELV $560
line 1380
;1380:	if (moveresult->flags & MOVERESULT_BLOCKEDBYAVOIDSPOT) {
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 256
BANDI4
CNSTI4 0
EQI4 $584
line 1381
;1381:		bs->blockedbyavoidspot_time = FloatTime() + 5;
ADDRFP4 0
INDIRP4
CNSTI4 6208
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1084227584
ADDF4
ASGNF4
line 1382
;1382:	}
LABELV $584
line 1384
;1383:	// if blocked by an avoid spot and the view angles and weapon are used for movement
;1384:	if (bs->blockedbyavoidspot_time > FloatTime() &&
ADDRFP4 0
INDIRP4
CNSTI4 6208
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
LEF4 $586
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
CNSTI4 17
BANDI4
CNSTI4 0
NEI4 $586
line 1385
;1385:		!(moveresult->flags & (MOVERESULT_MOVEMENTVIEW | MOVERESULT_MOVEMENTWEAPON)) ) {
line 1386
;1386:		bestdist = 300;
ADDRLP4 228
CNSTF4 1133903872
ASGNF4
line 1387
;1387:		bestmine = -1;
ADDRLP4 232
CNSTI4 -1
ASGNI4
line 1388
;1388:		for (i = 0; i < bs->numproxmines; i++) {
ADDRLP4 220
CNSTI4 0
ASGNI4
ADDRGP4 $591
JUMPV
LABELV $588
line 1389
;1389:			BotAI_GetEntityState(bs->proxmines[i], &state);
ADDRLP4 220
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 6260
ADDP4
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotAI_GetEntityState
CALLI4
pop
line 1390
;1390:			VectorSubtract(state.pos.trBase, bs->origin, dir);
ADDRLP4 332
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 12+12+12
INDIRF4
ADDRLP4 332
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 12+12+12+4
INDIRF4
ADDRLP4 332
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 12+12+12+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1391
;1391:			dist = VectorLength(dir);
ADDRLP4 0
ARGP4
ADDRLP4 336
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 224
ADDRLP4 336
INDIRF4
ASGNF4
line 1392
;1392:			if (dist < bestdist) {
ADDRLP4 224
INDIRF4
ADDRLP4 228
INDIRF4
GEF4 $602
line 1393
;1393:				bestdist = dist;
ADDRLP4 228
ADDRLP4 224
INDIRF4
ASGNF4
line 1394
;1394:				bestmine = i;
ADDRLP4 232
ADDRLP4 220
INDIRI4
ASGNI4
line 1395
;1395:			}
LABELV $602
line 1396
;1396:		}
LABELV $589
line 1388
ADDRLP4 220
ADDRLP4 220
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $591
ADDRLP4 220
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 6516
ADDP4
INDIRI4
LTI4 $588
line 1397
;1397:		if (bestmine != -1) {
ADDRLP4 232
INDIRI4
CNSTI4 -1
EQI4 $604
line 1403
;1398:			//
;1399:			// state->generic1 == TEAM_RED || state->generic1 == TEAM_BLUE
;1400:			//
;1401:			// deactivate prox mines in the bot's path by shooting
;1402:			// rockets or plasma cells etc. at them
;1403:			BotAI_GetEntityState(bs->proxmines[bestmine], &state);
ADDRLP4 232
INDIRI4
CNSTI4 2
LSHI4
ADDRFP4 0
INDIRP4
CNSTI4 6260
ADDP4
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 BotAI_GetEntityState
CALLI4
pop
line 1404
;1404:			VectorCopy(state.pos.trBase, target);
ADDRLP4 236
ADDRLP4 12+12+12
INDIRB
ASGNB 12
line 1405
;1405:			target[2] += 2;
ADDRLP4 236+8
ADDRLP4 236+8
INDIRF4
CNSTF4 1073741824
ADDF4
ASGNF4
line 1406
;1406:			VectorSubtract(target, bs->eye, dir);
ADDRLP4 332
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 236
INDIRF4
ADDRLP4 332
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 236+4
INDIRF4
ADDRLP4 332
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 0+8
ADDRLP4 236+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1407
;1407:			vectoangles(dir, moveresult->ideal_viewangles);
ADDRLP4 0
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1409
;1408:			// if the bot has a weapon that does splash damage
;1409:			if (bs->inventory[INVENTORY_PLASMAGUN] > 0 && bs->inventory[INVENTORY_CELLS] > 0)
ADDRLP4 336
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 340
CNSTI4 0
ASGNI4
ADDRLP4 336
INDIRP4
CNSTI4 4996
ADDP4
INDIRI4
ADDRLP4 340
INDIRI4
LEI4 $613
ADDRLP4 336
INDIRP4
CNSTI4 5036
ADDP4
INDIRI4
ADDRLP4 340
INDIRI4
LEI4 $613
line 1410
;1410:				moveresult->weapon = WEAPONINDEX_PLASMAGUN;
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTI4 8
ASGNI4
ADDRGP4 $614
JUMPV
LABELV $613
line 1411
;1411:			else if (bs->inventory[INVENTORY_ROCKETLAUNCHER] > 0 && bs->inventory[INVENTORY_ROCKETS] > 0)
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 348
CNSTI4 0
ASGNI4
ADDRLP4 344
INDIRP4
CNSTI4 4984
ADDP4
INDIRI4
ADDRLP4 348
INDIRI4
LEI4 $615
ADDRLP4 344
INDIRP4
CNSTI4 5044
ADDP4
INDIRI4
ADDRLP4 348
INDIRI4
LEI4 $615
line 1412
;1412:				moveresult->weapon = WEAPONINDEX_ROCKET_LAUNCHER;
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTI4 5
ASGNI4
ADDRGP4 $616
JUMPV
LABELV $615
line 1413
;1413:			else if (bs->inventory[INVENTORY_BFG10K] > 0 && bs->inventory[INVENTORY_BFGAMMO] > 0)
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 356
CNSTI4 0
ASGNI4
ADDRLP4 352
INDIRP4
CNSTI4 5004
ADDP4
INDIRI4
ADDRLP4 356
INDIRI4
LEI4 $617
ADDRLP4 352
INDIRP4
CNSTI4 5052
ADDP4
INDIRI4
ADDRLP4 356
INDIRI4
LEI4 $617
line 1414
;1414:				moveresult->weapon = WEAPONINDEX_BFG;
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTI4 9
ASGNI4
ADDRGP4 $618
JUMPV
LABELV $617
line 1415
;1415:			else {
line 1416
;1416:				moveresult->weapon = 0;
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
CNSTI4 0
ASGNI4
line 1417
;1417:			}
LABELV $618
LABELV $616
LABELV $614
line 1418
;1418:			if (moveresult->weapon) {
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 0
EQI4 $619
line 1420
;1419:				//
;1420:				moveresult->flags |= MOVERESULT_MOVEMENTWEAPON | MOVERESULT_MOVEMENTVIEW;
ADDRLP4 360
ADDRFP4 4
INDIRP4
CNSTI4 20
ADDP4
ASGNP4
ADDRLP4 360
INDIRP4
ADDRLP4 360
INDIRP4
INDIRI4
CNSTI4 17
BORI4
ASGNI4
line 1422
;1421:				// if holding the right weapon
;1422:				if (bs->cur_ps.weapon == moveresult->weapon) {
ADDRFP4 0
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
NEI4 $621
line 1424
;1423:					// if the bot is pretty close with it's aim
;1424:					if (InFieldOfVision(bs->viewangles, 20, moveresult->ideal_viewangles)) {
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1101004800
ARGF4
ADDRFP4 4
INDIRP4
CNSTI4 40
ADDP4
ARGP4
ADDRLP4 364
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 364
INDIRI4
CNSTI4 0
EQI4 $623
line 1426
;1425:						//
;1426:						BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, target, bs->entitynum, MASK_SHOT);
ADDRLP4 248
ARGP4
ADDRLP4 368
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 368
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 372
CNSTP4 0
ASGNP4
ADDRLP4 372
INDIRP4
ARGP4
ADDRLP4 372
INDIRP4
ARGP4
ADDRLP4 236
ARGP4
ADDRLP4 368
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
line 1428
;1427:						// if the mine is visible from the current position
;1428:						if (bsptrace.fraction >= 1.0 || bsptrace.ent == state.number) {
ADDRLP4 248+8
INDIRF4
CNSTF4 1065353216
GEF4 $629
ADDRLP4 248+80
INDIRI4
ADDRLP4 12
INDIRI4
NEI4 $625
LABELV $629
line 1430
;1429:							// shoot at the mine
;1430:							trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 1431
;1431:						}
LABELV $625
line 1432
;1432:					}
LABELV $623
line 1433
;1433:				}
LABELV $621
line 1434
;1434:			}
LABELV $619
line 1435
;1435:		}
LABELV $604
line 1436
;1436:	}
LABELV $586
line 1437
;1437:}
LABELV $559
endproc BotClearPath 376 28
export AIEnter_Seek_ActivateEntity
proc AIEnter_Seek_ActivateEntity 0 16
line 1444
;1438:
;1439:/*
;1440:==================
;1441:AIEnter_Seek_ActivateEntity
;1442:==================
;1443:*/
;1444:void AIEnter_Seek_ActivateEntity(bot_state_t *bs, char *s) {
line 1445
;1445:	BotRecordNodeSwitch(bs, "activate entity", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $631
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1446
;1446:	bs->ainode = AINode_Seek_ActivateEntity;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Seek_ActivateEntity
ASGNP4
line 1447
;1447:}
LABELV $630
endproc AIEnter_Seek_ActivateEntity 0 16
export AINode_Seek_ActivateEntity
proc AINode_Seek_ActivateEntity 372 28
line 1454
;1448:
;1449:/*
;1450:==================
;1451:AINode_Seek_Activate_Entity
;1452:==================
;1453:*/
;1454:int AINode_Seek_ActivateEntity(bot_state_t *bs) {
line 1462
;1455:	bot_goal_t *goal;
;1456:	vec3_t target, dir, ideal_viewangles;
;1457:	bot_moveresult_t moveresult;
;1458:	int targetvisible;
;1459:	bsp_trace_t bsptrace;
;1460:	aas_entityinfo_t entinfo;
;1461:
;1462:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 320
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 320
INDIRI4
CNSTI4 0
EQI4 $633
line 1463
;1463:		BotClearActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotClearActivateGoalStack
CALLV
pop
line 1464
;1464:		AIEnter_Observer(bs, "active entity: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $635
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 1465
;1465:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $633
line 1468
;1466:	}
;1467:	//if in the intermission
;1468:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 324
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 324
INDIRI4
CNSTI4 0
EQI4 $636
line 1469
;1469:		BotClearActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotClearActivateGoalStack
CALLV
pop
line 1470
;1470:		AIEnter_Intermission(bs, "activate entity: intermission");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $638
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 1471
;1471:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $636
line 1474
;1472:	}
;1473:	//respawn if dead
;1474:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 328
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 328
INDIRI4
CNSTI4 0
EQI4 $639
line 1475
;1475:		BotClearActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotClearActivateGoalStack
CALLV
pop
line 1476
;1476:		AIEnter_Respawn(bs, "activate entity: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $641
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 1477
;1477:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $639
line 1480
;1478:	}
;1479:	//
;1480:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 1481
;1481:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $642
ADDRLP4 332
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 332
INDIRP4
ADDRLP4 332
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $642
line 1483
;1482:	// if in lava or slime the bot should be able to get out
;1483:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 336
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 336
INDIRI4
CNSTI4 0
EQI4 $645
ADDRLP4 340
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 340
INDIRP4
ADDRLP4 340
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $645
line 1485
;1484:	// map specific code
;1485:	BotMapScripts(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotMapScripts
CALLV
pop
line 1487
;1486:	// no enemy
;1487:	bs->enemy = -1;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
CNSTI4 -1
ASGNI4
line 1489
;1488:	// if the bot has no activate goal
;1489:	if (!bs->activatestack) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $647
line 1490
;1490:		BotClearActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotClearActivateGoalStack
CALLV
pop
line 1491
;1491:		AIEnter_Seek_NBG(bs, "activate entity: no goal");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $649
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 1492
;1492:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $647
line 1495
;1493:	}
;1494:	//
;1495:	goal = &bs->activatestack->goal;
ADDRLP4 52
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 4
ADDP4
ASGNP4
line 1497
;1496:	// initialize target being visible to false
;1497:	targetvisible = qfalse;
ADDRLP4 68
CNSTI4 0
ASGNI4
line 1499
;1498:	// if the bot has to shoot at a target to activate something
;1499:	if (bs->activatestack->shoot) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
EQI4 $650
line 1501
;1500:		//
;1501:		BotAI_Trace(&bsptrace, bs->eye, NULL, NULL, bs->activatestack->target, bs->entitynum, MASK_SHOT);
ADDRLP4 72
ARGP4
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 348
CNSTP4 0
ASGNP4
ADDRLP4 348
INDIRP4
ARGP4
ADDRLP4 348
INDIRP4
ARGP4
ADDRLP4 344
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 80
ADDP4
ARGP4
ADDRLP4 344
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
line 1503
;1502:		// if the shootable entity is visible from the current position
;1503:		if (bsptrace.fraction >= 1.0 || bsptrace.ent == goal->entitynum) {
ADDRLP4 72+8
INDIRF4
CNSTF4 1065353216
GEF4 $656
ADDRLP4 72+80
INDIRI4
ADDRLP4 52
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
NEI4 $652
LABELV $656
line 1504
;1504:			targetvisible = qtrue;
ADDRLP4 68
CNSTI4 1
ASGNI4
line 1506
;1505:			// if holding the right weapon
;1506:			if (bs->cur_ps.weapon == bs->activatestack->weapon) {
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 352
INDIRP4
CNSTI4 160
ADDP4
INDIRI4
ADDRLP4 352
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
NEI4 $657
line 1507
;1507:				VectorSubtract(bs->activatestack->target, bs->eye, dir);
ADDRLP4 356
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 360
ADDRLP4 356
INDIRP4
CNSTI4 7116
ADDP4
ASGNP4
ADDRLP4 56
ADDRLP4 360
INDIRP4
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ADDRLP4 356
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 360
INDIRP4
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ADDRLP4 356
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 364
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56+8
ADDRLP4 364
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 88
ADDP4
INDIRF4
ADDRLP4 364
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1508
;1508:				vectoangles(dir, ideal_viewangles);
ADDRLP4 56
ARGP4
ADDRLP4 308
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1510
;1509:				// if the bot is pretty close with it's aim
;1510:				if (InFieldOfVision(bs->viewangles, 20, ideal_viewangles)) {
ADDRFP4 0
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1101004800
ARGF4
ADDRLP4 308
ARGP4
ADDRLP4 368
ADDRGP4 InFieldOfVision
CALLI4
ASGNI4
ADDRLP4 368
INDIRI4
CNSTI4 0
EQI4 $661
line 1511
;1511:					trap_EA_Attack(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Attack
CALLV
pop
line 1512
;1512:				}
LABELV $661
line 1513
;1513:			}
LABELV $657
line 1514
;1514:		}
LABELV $652
line 1515
;1515:	}
LABELV $650
line 1517
;1516:	// if the shoot target is visible
;1517:	if (targetvisible) {
ADDRLP4 68
INDIRI4
CNSTI4 0
EQI4 $663
line 1519
;1518:		// get the entity info of the entity the bot is shooting at
;1519:		BotEntityInfo(goal->entitynum, &entinfo);
ADDRLP4 52
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
ARGI4
ADDRLP4 156
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 1521
;1520:		// if the entity the bot shoots at moved
;1521:		if (!VectorCompare(bs->activatestack->origin, entinfo.origin)) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 156+24
ARGP4
ADDRLP4 344
ADDRGP4 VectorCompare
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
NEI4 $665
line 1525
;1522:#ifdef DEBUG
;1523:			BotAI_Print(PRT_MESSAGE, "hit shootable button or trigger\n");
;1524:#endif //DEBUG
;1525:			bs->activatestack->time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1526
;1526:		}
LABELV $665
line 1528
;1527:		// if the activate goal has been activated or the bot takes too long
;1528:		if (bs->activatestack->time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $668
line 1529
;1529:			BotPopFromActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotPopFromActivateGoalStack
CALLI4
pop
line 1531
;1530:			// if there are more activate goals on the stack
;1531:			if (bs->activatestack) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $670
line 1532
;1532:				bs->activatestack->time = FloatTime() + 10;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
line 1533
;1533:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $670
line 1535
;1534:			}
;1535:			AIEnter_Seek_NBG(bs, "activate entity: time out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $672
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 1536
;1536:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $668
line 1538
;1537:		}
;1538:		memset(&moveresult, 0, sizeof(bot_moveresult_t));
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
CNSTI4 52
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1539
;1539:	}
ADDRGP4 $664
JUMPV
LABELV $663
line 1540
;1540:	else {
line 1542
;1541:		// if the bot has no goal
;1542:		if (!goal) {
ADDRLP4 52
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $673
line 1543
;1543:			bs->activatestack->time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1544
;1544:		}
ADDRGP4 $674
JUMPV
LABELV $673
line 1546
;1545:		// if the bot does not have a shoot goal
;1546:		else if (!bs->activatestack->shoot) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
NEI4 $675
line 1548
;1547:			//if the bot touches the current goal
;1548:			if (trap_BotTouchingGoal(bs->origin, goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 52
INDIRP4
ARGP4
ADDRLP4 344
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
EQI4 $677
line 1552
;1549:#ifdef DEBUG
;1550:				BotAI_Print(PRT_MESSAGE, "touched button or trigger\n");
;1551:#endif //DEBUG
;1552:				bs->activatestack->time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1553
;1553:			}
LABELV $677
line 1554
;1554:		}
LABELV $675
LABELV $674
line 1556
;1555:		// if the activate goal has been activated or the bot takes too long
;1556:		if (bs->activatestack->time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $679
line 1557
;1557:			BotPopFromActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotPopFromActivateGoalStack
CALLI4
pop
line 1559
;1558:			// if there are more activate goals on the stack
;1559:			if (bs->activatestack) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $681
line 1560
;1560:				bs->activatestack->time = FloatTime() + 10;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
ADDF4
ASGNF4
line 1561
;1561:				return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $681
line 1563
;1562:			}
;1563:			AIEnter_Seek_NBG(bs, "activate entity: activated");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $683
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 1564
;1564:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $679
line 1567
;1565:		}
;1566:		//predict obstacles
;1567:		if (BotAIPredictObstacles(bs, goal))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 52
INDIRP4
ARGP4
ADDRLP4 344
ADDRGP4 BotAIPredictObstacles
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
EQI4 $684
line 1568
;1568:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $632
JUMPV
LABELV $684
line 1570
;1569:		//initialize the movement state
;1570:		BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 1572
;1571:		//move towards the goal
;1572:		trap_BotMoveToGoal(&moveresult, bs->ms, goal, bs->tfl);
ADDRLP4 0
ARGP4
ADDRLP4 348
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 348
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
INDIRP4
ARGP4
ADDRLP4 348
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 1574
;1573:		//if the movement failed
;1574:		if (moveresult.failure) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $686
line 1576
;1575:			//reset the avoid reach, otherwise bot is stuck in current area
;1576:			trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 1578
;1577:			//
;1578:			bs->activatestack->time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 60
ADDP4
CNSTF4 0
ASGNF4
line 1579
;1579:		}
LABELV $686
line 1581
;1580:		//check if the bot is blocked
;1581:		BotAIBlocked(bs, &moveresult, qtrue);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 1582
;1582:	}
LABELV $664
line 1584
;1583:	//
;1584:	BotClearPath(bs, &moveresult);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotClearPath
CALLV
pop
line 1586
;1585:	// if the bot has to shoot to activate
;1586:	if (bs->activatestack->shoot) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CNSTI4 0
EQI4 $688
line 1588
;1587:		// if the view angles aren't yet used for the movement
;1588:		if (!(moveresult.flags & MOVERESULT_MOVEMENTVIEW)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $690
line 1589
;1589:			VectorSubtract(bs->activatestack->target, bs->eye, dir);
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 348
ADDRLP4 344
INDIRP4
CNSTI4 7116
ADDP4
ASGNP4
ADDRLP4 56
ADDRLP4 348
INDIRP4
INDIRP4
CNSTI4 80
ADDP4
INDIRF4
ADDRLP4 344
INDIRP4
CNSTI4 4936
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 348
INDIRP4
INDIRP4
CNSTI4 84
ADDP4
INDIRF4
ADDRLP4 344
INDIRP4
CNSTI4 4940
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56+8
ADDRLP4 352
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 88
ADDP4
INDIRF4
ADDRLP4 352
INDIRP4
CNSTI4 4944
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1590
;1590:			vectoangles(dir, moveresult.ideal_viewangles);
ADDRLP4 56
ARGP4
ADDRLP4 0+40
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1591
;1591:			moveresult.flags |= MOVERESULT_MOVEMENTVIEW;
ADDRLP4 0+20
ADDRLP4 0+20
INDIRI4
CNSTI4 1
BORI4
ASGNI4
line 1592
;1592:		}
LABELV $690
line 1594
;1593:		// if there's no weapon yet used for the movement
;1594:		if (!(moveresult.flags & MOVERESULT_MOVEMENTWEAPON)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
NEI4 $697
line 1595
;1595:			moveresult.flags |= MOVERESULT_MOVEMENTWEAPON;
ADDRLP4 0+20
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BORI4
ASGNI4
line 1597
;1596:			//
;1597:			bs->activatestack->weapon = BotSelectActivateWeapon(bs);
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
ARGP4
ADDRLP4 348
ADDRGP4 BotSelectActivateWeapon
CALLI4
ASGNI4
ADDRLP4 344
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 76
ADDP4
ADDRLP4 348
INDIRI4
ASGNI4
line 1598
;1598:			if (bs->activatestack->weapon == -1) {
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
CNSTI4 -1
NEI4 $701
line 1600
;1599:				//FIXME: find a decent weapon first
;1600:				bs->activatestack->weapon = 0;
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 76
ADDP4
CNSTI4 0
ASGNI4
line 1601
;1601:			}
LABELV $701
line 1602
;1602:			moveresult.weapon = bs->activatestack->weapon;
ADDRLP4 0+24
ADDRFP4 0
INDIRP4
CNSTI4 7116
ADDP4
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
line 1603
;1603:		}
LABELV $697
line 1604
;1604:	}
LABELV $688
line 1606
;1605:	// if the ideal view angles are set for movement
;1606:	if (moveresult.flags & (MOVERESULT_MOVEMENTVIEWSET|MOVERESULT_MOVEMENTVIEW|MOVERESULT_SWIMVIEW)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 11
BANDI4
CNSTI4 0
EQI4 $704
line 1607
;1607:		VectorCopy(moveresult.ideal_viewangles, bs->ideal_viewangles);
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ADDRLP4 0+40
INDIRB
ASGNB 12
line 1608
;1608:	}
ADDRGP4 $705
JUMPV
LABELV $704
line 1610
;1609:	// if waiting for something
;1610:	else if (moveresult.flags & MOVERESULT_WAITING) {
ADDRLP4 0+20
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $708
line 1611
;1611:		if (random() < bs->thinktime * 0.8) {
ADDRLP4 344
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1061997773
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $709
line 1612
;1612:			BotRoamGoal(bs, target);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 296
ARGP4
ADDRGP4 BotRoamGoal
CALLV
pop
line 1613
;1613:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 348
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56
ADDRLP4 296
INDIRF4
ADDRLP4 348
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 296+4
INDIRF4
ADDRLP4 348
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56+8
ADDRLP4 296+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1614
;1614:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 56
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1615
;1615:			bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 352
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 352
INDIRP4
CNSTF4 1056964608
ADDRLP4 352
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1616
;1616:		}
line 1617
;1617:	}
ADDRGP4 $709
JUMPV
LABELV $708
line 1618
;1618:	else if (!(bs->flags & BFL_IDEALVIEWSET)) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $717
line 1619
;1619:		if (trap_BotMovementViewTarget(bs->ms, goal, bs->tfl, 300, target)) {
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
INDIRP4
ARGP4
ADDRLP4 344
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTF4 1133903872
ARGF4
ADDRLP4 296
ARGP4
ADDRLP4 348
ADDRGP4 trap_BotMovementViewTarget
CALLI4
ASGNI4
ADDRLP4 348
INDIRI4
CNSTI4 0
EQI4 $719
line 1620
;1620:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 56
ADDRLP4 296
INDIRF4
ADDRLP4 352
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56+4
ADDRLP4 296+4
INDIRF4
ADDRLP4 352
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 56+8
ADDRLP4 296+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1621
;1621:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 56
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1622
;1622:		}
ADDRGP4 $720
JUMPV
LABELV $719
line 1623
;1623:		else {
line 1624
;1624:			vectoangles(moveresult.movedir, bs->ideal_viewangles);
ADDRLP4 0+28
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1625
;1625:		}
LABELV $720
line 1626
;1626:		bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 352
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 352
INDIRP4
CNSTF4 1056964608
ADDRLP4 352
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1627
;1627:	}
LABELV $717
LABELV $709
LABELV $705
line 1629
;1628:	// if the weapon is used for the bot movement
;1629:	if (moveresult.flags & MOVERESULT_MOVEMENTWEAPON)
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $726
line 1630
;1630:		bs->weaponnum = moveresult.weapon;
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0+24
INDIRI4
ASGNI4
LABELV $726
line 1632
;1631:	// if there is an enemy
;1632:	if (BotFindEnemy(bs, -1)) {
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 344
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
EQI4 $730
line 1633
;1633:		if (BotWantsToRetreat(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 348
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 348
INDIRI4
CNSTI4 0
EQI4 $732
line 1635
;1634:			//keep the current long term goal and retreat
;1635:			AIEnter_Battle_NBG(bs, "activate entity: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $734
ARGP4
ADDRGP4 AIEnter_Battle_NBG
CALLV
pop
line 1636
;1636:		}
ADDRGP4 $733
JUMPV
LABELV $732
line 1637
;1637:		else {
line 1638
;1638:			trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 1640
;1639:			//empty the goal stack
;1640:			trap_BotEmptyGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEmptyGoalStack
CALLV
pop
line 1642
;1641:			//go fight
;1642:			AIEnter_Battle_Fight(bs, "activate entity: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $734
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 1643
;1643:		}
LABELV $733
line 1644
;1644:		BotClearActivateGoalStack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotClearActivateGoalStack
CALLV
pop
line 1645
;1645:	}
LABELV $730
line 1646
;1646:	return qtrue;
CNSTI4 1
RETI4
LABELV $632
endproc AINode_Seek_ActivateEntity 372 28
export AIEnter_Seek_NBG
proc AIEnter_Seek_NBG 204 16
line 1654
;1647:}
;1648:
;1649:/*
;1650:==================
;1651:AIEnter_Seek_NBG
;1652:==================
;1653:*/
;1654:void AIEnter_Seek_NBG(bot_state_t *bs, char *s) {
line 1658
;1655:	bot_goal_t goal;
;1656:	char buf[144];
;1657:
;1658:	if (trap_BotGetTopGoal(bs->gs, &goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 200
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 200
INDIRI4
CNSTI4 0
EQI4 $736
line 1659
;1659:		trap_BotGoalName(goal.number, buf, 144);
ADDRLP4 0+44
INDIRI4
ARGI4
ADDRLP4 56
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 1660
;1660:		BotRecordNodeSwitch(bs, "seek NBG", buf, s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $739
ARGP4
ADDRLP4 56
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1661
;1661:	}
ADDRGP4 $737
JUMPV
LABELV $736
line 1662
;1662:	else {
line 1663
;1663:		BotRecordNodeSwitch(bs, "seek NBG", "no goal", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $739
ARGP4
ADDRGP4 $740
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1664
;1664:	}
LABELV $737
line 1665
;1665:	bs->ainode = AINode_Seek_NBG;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Seek_NBG
ASGNP4
line 1666
;1666:}
LABELV $735
endproc AIEnter_Seek_NBG 204 16
export AINode_Seek_NBG
proc AINode_Seek_NBG 192 20
line 1673
;1667:
;1668:/*
;1669:==================
;1670:AINode_Seek_NBG
;1671:==================
;1672:*/
;1673:int AINode_Seek_NBG(bot_state_t *bs) {
line 1678
;1674:	bot_goal_t goal;
;1675:	vec3_t target, dir;
;1676:	bot_moveresult_t moveresult;
;1677:
;1678:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 132
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 132
INDIRI4
CNSTI4 0
EQI4 $742
line 1679
;1679:		AIEnter_Observer(bs, "seek nbg: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $744
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 1680
;1680:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $741
JUMPV
LABELV $742
line 1683
;1681:	}
;1682:	//if in the intermission
;1683:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 136
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 136
INDIRI4
CNSTI4 0
EQI4 $745
line 1684
;1684:		AIEnter_Intermission(bs, "seek nbg: intermision");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $747
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 1685
;1685:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $741
JUMPV
LABELV $745
line 1688
;1686:	}
;1687:	//respawn if dead
;1688:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $748
line 1689
;1689:		AIEnter_Respawn(bs, "seek nbg: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $750
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 1690
;1690:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $741
JUMPV
LABELV $748
line 1693
;1691:	}
;1692:	//
;1693:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 1694
;1694:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $751
ADDRLP4 144
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 144
INDIRP4
ADDRLP4 144
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $751
line 1696
;1695:	//if in lava or slime the bot should be able to get out
;1696:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 148
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
EQI4 $754
ADDRLP4 152
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 152
INDIRP4
ADDRLP4 152
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $754
line 1698
;1697:	//
;1698:	if (BotCanAndWantsToRocketJump(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 156
ADDRGP4 BotCanAndWantsToRocketJump
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
EQI4 $756
line 1699
;1699:		bs->tfl |= TFL_ROCKETJUMP;
ADDRLP4 160
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 160
INDIRP4
ADDRLP4 160
INDIRP4
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1700
;1700:	}
LABELV $756
line 1702
;1701:	//map specific code
;1702:	BotMapScripts(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotMapScripts
CALLV
pop
line 1704
;1703:	//no enemy
;1704:	bs->enemy = -1;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
CNSTI4 -1
ASGNI4
line 1706
;1705:	//if the bot has no goal
;1706:	if (!trap_BotGetTopGoal(bs->gs, &goal)) bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 160
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 160
INDIRI4
CNSTI4 0
NEI4 $758
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
ADDRGP4 $759
JUMPV
LABELV $758
line 1708
;1707:	//if the bot touches the current goal
;1708:	else if (BotReachedGoal(bs, &goal)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 52
ARGP4
ADDRLP4 164
ADDRGP4 BotReachedGoal
CALLI4
ASGNI4
ADDRLP4 164
INDIRI4
CNSTI4 0
EQI4 $760
line 1709
;1709:		BotChooseWeapon(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotChooseWeapon
CALLV
pop
line 1710
;1710:		bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
line 1711
;1711:	}
LABELV $760
LABELV $759
line 1713
;1712:	//
;1713:	if (bs->nbg_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $762
line 1715
;1714:		//pop the current goal from the stack
;1715:		trap_BotPopGoal(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotPopGoal
CALLV
pop
line 1718
;1716:		//check for new nearby items right away
;1717:		//NOTE: we canNOT reset the check_time to zero because it would create an endless loop of node switches
;1718:		bs->check_time = FloatTime() + 0.05;
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1028443341
ADDF4
ASGNF4
line 1720
;1719:		//go back to seek ltg
;1720:		AIEnter_Seek_LTG(bs, "seek nbg: time out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $764
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 1721
;1721:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $741
JUMPV
LABELV $762
line 1724
;1722:	}
;1723:	//predict obstacles
;1724:	if (BotAIPredictObstacles(bs, &goal))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 52
ARGP4
ADDRLP4 168
ADDRGP4 BotAIPredictObstacles
CALLI4
ASGNI4
ADDRLP4 168
INDIRI4
CNSTI4 0
EQI4 $765
line 1725
;1725:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $741
JUMPV
LABELV $765
line 1727
;1726:	//initialize the movement state
;1727:	BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 1729
;1728:	//move towards the goal
;1729:	trap_BotMoveToGoal(&moveresult, bs->ms, &goal, bs->tfl);
ADDRLP4 0
ARGP4
ADDRLP4 172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 172
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 172
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 1731
;1730:	//if the movement failed
;1731:	if (moveresult.failure) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $767
line 1733
;1732:		//reset the avoid reach, otherwise bot is stuck in current area
;1733:		trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 1734
;1734:		bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
line 1735
;1735:	}
LABELV $767
line 1737
;1736:	//check if the bot is blocked
;1737:	BotAIBlocked(bs, &moveresult, qtrue);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 1739
;1738:	//
;1739:	BotClearPath(bs, &moveresult);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotClearPath
CALLV
pop
line 1741
;1740:	//if the viewangles are used for the movement
;1741:	if (moveresult.flags & (MOVERESULT_MOVEMENTVIEWSET|MOVERESULT_MOVEMENTVIEW|MOVERESULT_SWIMVIEW)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 11
BANDI4
CNSTI4 0
EQI4 $769
line 1742
;1742:		VectorCopy(moveresult.ideal_viewangles, bs->ideal_viewangles);
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ADDRLP4 0+40
INDIRB
ASGNB 12
line 1743
;1743:	}
ADDRGP4 $770
JUMPV
LABELV $769
line 1745
;1744:	//if waiting for something
;1745:	else if (moveresult.flags & MOVERESULT_WAITING) {
ADDRLP4 0+20
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $773
line 1746
;1746:		if (random() < bs->thinktime * 0.8) {
ADDRLP4 176
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1061997773
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $774
line 1747
;1747:			BotRoamGoal(bs, target);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 108
ARGP4
ADDRGP4 BotRoamGoal
CALLV
pop
line 1748
;1748:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 180
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 120
ADDRLP4 108
INDIRF4
ADDRLP4 180
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 120+4
ADDRLP4 108+4
INDIRF4
ADDRLP4 180
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 120+8
ADDRLP4 108+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1749
;1749:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 120
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1750
;1750:			bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 184
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 184
INDIRP4
CNSTF4 1056964608
ADDRLP4 184
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1751
;1751:		}
line 1752
;1752:	}
ADDRGP4 $774
JUMPV
LABELV $773
line 1753
;1753:	else if (!(bs->flags & BFL_IDEALVIEWSET)) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $782
line 1754
;1754:		if (!trap_BotGetSecondGoal(bs->gs, &goal)) trap_BotGetTopGoal(bs->gs, &goal);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 176
ADDRGP4 trap_BotGetSecondGoal
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 0
NEI4 $784
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRGP4 trap_BotGetTopGoal
CALLI4
pop
LABELV $784
line 1755
;1755:		if (trap_BotMovementViewTarget(bs->ms, &goal, bs->tfl, 300, target)) {
ADDRLP4 180
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 180
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 180
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTF4 1133903872
ARGF4
ADDRLP4 108
ARGP4
ADDRLP4 184
ADDRGP4 trap_BotMovementViewTarget
CALLI4
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 0
EQI4 $786
line 1756
;1756:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 188
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 120
ADDRLP4 108
INDIRF4
ADDRLP4 188
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 120+4
ADDRLP4 108+4
INDIRF4
ADDRLP4 188
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 120+8
ADDRLP4 108+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1757
;1757:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 120
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1758
;1758:		}
ADDRGP4 $787
JUMPV
LABELV $786
line 1760
;1759:		//FIXME: look at cluster portals?
;1760:		else vectoangles(moveresult.movedir, bs->ideal_viewangles);
ADDRLP4 0+28
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
LABELV $787
line 1761
;1761:		bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 188
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 188
INDIRP4
CNSTF4 1056964608
ADDRLP4 188
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1762
;1762:	}
LABELV $782
LABELV $774
LABELV $770
line 1764
;1763:	//if the weapon is used for the bot movement
;1764:	if (moveresult.flags & MOVERESULT_MOVEMENTWEAPON) bs->weaponnum = moveresult.weapon;
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $793
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0+24
INDIRI4
ASGNI4
LABELV $793
line 1766
;1765:	//if there is an enemy
;1766:	if (BotFindEnemy(bs, -1)) {
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 176
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 0
EQI4 $797
line 1767
;1767:		if (BotWantsToRetreat(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 180
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 0
EQI4 $799
line 1769
;1768:			//keep the current long term goal and retreat
;1769:			AIEnter_Battle_NBG(bs, "seek nbg: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $801
ARGP4
ADDRGP4 AIEnter_Battle_NBG
CALLV
pop
line 1770
;1770:		}
ADDRGP4 $800
JUMPV
LABELV $799
line 1771
;1771:		else {
line 1772
;1772:			trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 1774
;1773:			//empty the goal stack
;1774:			trap_BotEmptyGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEmptyGoalStack
CALLV
pop
line 1776
;1775:			//go fight
;1776:			AIEnter_Battle_Fight(bs, "seek nbg: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $801
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 1777
;1777:		}
LABELV $800
line 1778
;1778:	}
LABELV $797
line 1779
;1779:	return qtrue;
CNSTI4 1
RETI4
LABELV $741
endproc AINode_Seek_NBG 192 20
export AIEnter_Seek_LTG
proc AIEnter_Seek_LTG 204 16
line 1787
;1780:}
;1781:
;1782:/*
;1783:==================
;1784:AIEnter_Seek_LTG
;1785:==================
;1786:*/
;1787:void AIEnter_Seek_LTG(bot_state_t *bs, char *s) {
line 1791
;1788:	bot_goal_t goal;
;1789:	char buf[144];
;1790:
;1791:	if (trap_BotGetTopGoal(bs->gs, &goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 200
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 200
INDIRI4
CNSTI4 0
EQI4 $803
line 1792
;1792:		trap_BotGoalName(goal.number, buf, 144);
ADDRLP4 0+44
INDIRI4
ARGI4
ADDRLP4 56
ARGP4
CNSTI4 144
ARGI4
ADDRGP4 trap_BotGoalName
CALLV
pop
line 1793
;1793:		BotRecordNodeSwitch(bs, "seek LTG", buf, s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $806
ARGP4
ADDRLP4 56
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1794
;1794:	}
ADDRGP4 $804
JUMPV
LABELV $803
line 1795
;1795:	else {
line 1796
;1796:		BotRecordNodeSwitch(bs, "seek LTG", "no goal", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $806
ARGP4
ADDRGP4 $740
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1797
;1797:	}
LABELV $804
line 1798
;1798:	bs->ainode = AINode_Seek_LTG;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Seek_LTG
ASGNP4
line 1799
;1799:}
LABELV $802
endproc AIEnter_Seek_LTG 204 16
export AINode_Seek_LTG
proc AINode_Seek_LTG 212 20
line 1807
;1800:
;1801:/*
;1802:==================
;1803:AINode_Seek_LTG
;1804:==================
;1805:*/
;1806:int AINode_Seek_LTG(bot_state_t *bs)
;1807:{
line 1815
;1808:	bot_goal_t goal;
;1809:	vec3_t target, dir;
;1810:	bot_moveresult_t moveresult;
;1811:	int range;
;1812:	//char buf[128];
;1813:	//bot_goal_t tmpgoal;
;1814:
;1815:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 136
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 136
INDIRI4
CNSTI4 0
EQI4 $808
line 1816
;1816:		AIEnter_Observer(bs, "seek ltg: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $810
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 1817
;1817:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $808
line 1820
;1818:	}
;1819:	//if in the intermission
;1820:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $811
line 1821
;1821:		AIEnter_Intermission(bs, "seek ltg: intermission");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $813
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 1822
;1822:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $811
line 1825
;1823:	}
;1824:	//respawn if dead
;1825:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
EQI4 $814
line 1826
;1826:		AIEnter_Respawn(bs, "seek ltg: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $816
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 1827
;1827:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $814
line 1830
;1828:	}
;1829:	//
;1830:	if (BotChat_Random(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 148
ADDRGP4 BotChat_Random
CALLI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 0
EQI4 $817
line 1831
;1831:		bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 152
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 152
INDIRP4
ARGP4
ADDRLP4 156
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 152
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 156
INDIRF4
ADDF4
ASGNF4
line 1832
;1832:		AIEnter_Stand(bs, "seek ltg: random chat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $819
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 1833
;1833:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $817
line 1836
;1834:	}
;1835:	//
;1836:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 1837
;1837:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $820
ADDRLP4 152
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 152
INDIRP4
ADDRLP4 152
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $820
line 1839
;1838:	//if in lava or slime the bot should be able to get out
;1839:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 156
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
EQI4 $823
ADDRLP4 160
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 160
INDIRP4
ADDRLP4 160
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $823
line 1841
;1840:	//
;1841:	if (BotCanAndWantsToRocketJump(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 164
ADDRGP4 BotCanAndWantsToRocketJump
CALLI4
ASGNI4
ADDRLP4 164
INDIRI4
CNSTI4 0
EQI4 $825
line 1842
;1842:		bs->tfl |= TFL_ROCKETJUMP;
ADDRLP4 168
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 168
INDIRP4
ADDRLP4 168
INDIRP4
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 1843
;1843:	}
LABELV $825
line 1845
;1844:	//map specific code
;1845:	BotMapScripts(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotMapScripts
CALLV
pop
line 1847
;1846:	//no enemy
;1847:	bs->enemy = -1;
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
CNSTI4 -1
ASGNI4
line 1849
;1848:	//
;1849:	if (bs->killedenemy_time > FloatTime() - 2) {
ADDRFP4 0
INDIRP4
CNSTI4 6168
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
LEF4 $827
line 1850
;1850:		if (random() < bs->thinktime * 1) {
ADDRLP4 168
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 168
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1065353216
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $829
line 1851
;1851:			trap_EA_Gesture(bs->client);
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_EA_Gesture
CALLV
pop
line 1852
;1852:		}
LABELV $829
line 1853
;1853:	}
LABELV $827
line 1855
;1854:	//if there is an enemy
;1855:	if (BotFindEnemy(bs, -1)) {
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 168
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 168
INDIRI4
CNSTI4 0
EQI4 $831
line 1856
;1856:		if (BotWantsToRetreat(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 172
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $833
line 1858
;1857:			//keep the current long term goal and retreat
;1858:			AIEnter_Battle_Retreat(bs, "seek ltg: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $835
ARGP4
ADDRGP4 AIEnter_Battle_Retreat
CALLV
pop
line 1859
;1859:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $833
line 1861
;1860:		}
;1861:		else {
line 1862
;1862:			trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 1864
;1863:			//empty the goal stack
;1864:			trap_BotEmptyGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEmptyGoalStack
CALLV
pop
line 1866
;1865:			//go fight
;1866:			AIEnter_Battle_Fight(bs, "seek ltg: found enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $835
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 1867
;1867:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $831
line 1871
;1868:		}
;1869:	}
;1870:	//
;1871:	BotTeamGoals(bs, qfalse);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotTeamGoals
CALLV
pop
line 1873
;1872:	//get the current long term goal
;1873:	if (!BotLongTermGoal(bs, bs->tfl, qfalse, &goal)) {
ADDRLP4 172
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 172
INDIRP4
ARGP4
ADDRLP4 172
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTI4 0
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 176
ADDRGP4 BotLongTermGoal
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 0
NEI4 $836
line 1874
;1874:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $807
JUMPV
LABELV $836
line 1877
;1875:	}
;1876:	//check for nearby goals periodicly
;1877:	if (bs->check_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $838
line 1878
;1878:		bs->check_time = FloatTime() + 0.5;
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1056964608
ADDF4
ASGNF4
line 1880
;1879:		//check if the bot wants to camp
;1880:		BotWantsToCamp(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotWantsToCamp
CALLI4
pop
line 1882
;1881:		//
;1882:		if (bs->ltgtype == LTG_DEFENDKEYAREA) range = 400;
ADDRFP4 0
INDIRP4
CNSTI4 6600
ADDP4
INDIRI4
CNSTI4 3
NEI4 $840
ADDRLP4 108
CNSTI4 400
ASGNI4
ADDRGP4 $841
JUMPV
LABELV $840
line 1883
;1883:		else range = 150;
ADDRLP4 108
CNSTI4 150
ASGNI4
LABELV $841
line 1886
;1884:		//
;1885:#ifdef CTF
;1886:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $842
line 1888
;1887:			//if carrying a flag the bot shouldn't be distracted too much
;1888:			if (BotCTFCarryingFlag(bs))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 180
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 0
EQI4 $844
line 1889
;1889:				range = 50;
ADDRLP4 108
CNSTI4 50
ASGNI4
LABELV $844
line 1890
;1890:		}
LABELV $842
line 1903
;1891:#endif //CTF
;1892:#ifdef MISSIONPACK
;1893:		else if (gametype == GT_1FCTF) {
;1894:			if (Bot1FCTFCarryingFlag(bs))
;1895:				range = 50;
;1896:		}
;1897:		else if (gametype == GT_HARVESTER) {
;1898:			if (BotHarvesterCarryingCubes(bs))
;1899:				range = 80;
;1900:		}
;1901:#endif
;1902:		//
;1903:		if (BotNearbyGoal(bs, bs->tfl, &goal, range)) {
ADDRLP4 180
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 180
INDIRP4
ARGP4
ADDRLP4 180
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 108
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 184
ADDRGP4 BotNearbyGoal
CALLI4
ASGNI4
ADDRLP4 184
INDIRI4
CNSTI4 0
EQI4 $846
line 1904
;1904:			trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 1910
;1905:			//get the goal at the top of the stack
;1906:			//trap_BotGetTopGoal(bs->gs, &tmpgoal);
;1907:			//trap_BotGoalName(tmpgoal.number, buf, 144);
;1908:			//BotAI_Print(PRT_MESSAGE, "new nearby goal %s\n", buf);
;1909:			//time the bot gets to pick up the nearby goal item
;1910:			bs->nbg_time = FloatTime() + 4 + range * 0.01;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1082130432
ADDF4
CNSTF4 1008981770
ADDRLP4 108
INDIRI4
CVIF4 4
MULF4
ADDF4
ASGNF4
line 1911
;1911:			AIEnter_Seek_NBG(bs, "ltg seek: nbg");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $848
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 1912
;1912:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $846
line 1914
;1913:		}
;1914:	}
LABELV $838
line 1916
;1915:	//predict obstacles
;1916:	if (BotAIPredictObstacles(bs, &goal))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 52
ARGP4
ADDRLP4 180
ADDRGP4 BotAIPredictObstacles
CALLI4
ASGNI4
ADDRLP4 180
INDIRI4
CNSTI4 0
EQI4 $849
line 1917
;1917:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $807
JUMPV
LABELV $849
line 1919
;1918:	//initialize the movement state
;1919:	BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 1921
;1920:	//move towards the goal
;1921:	trap_BotMoveToGoal(&moveresult, bs->ms, &goal, bs->tfl);
ADDRLP4 0
ARGP4
ADDRLP4 184
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 184
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 184
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 1923
;1922:	//if the movement failed
;1923:	if (moveresult.failure) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $851
line 1925
;1924:		//reset the avoid reach, otherwise bot is stuck in current area
;1925:		trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 1927
;1926:		//BotAI_Print(PRT_MESSAGE, "movement failure %d\n", moveresult.traveltype);
;1927:		bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 1928
;1928:	}
LABELV $851
line 1930
;1929:	//
;1930:	BotAIBlocked(bs, &moveresult, qtrue);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 1932
;1931:	//
;1932:	BotClearPath(bs, &moveresult);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 BotClearPath
CALLV
pop
line 1934
;1933:	//if the viewangles are used for the movement
;1934:	if (moveresult.flags & (MOVERESULT_MOVEMENTVIEWSET|MOVERESULT_MOVEMENTVIEW|MOVERESULT_SWIMVIEW)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 11
BANDI4
CNSTI4 0
EQI4 $853
line 1935
;1935:		VectorCopy(moveresult.ideal_viewangles, bs->ideal_viewangles);
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ADDRLP4 0+40
INDIRB
ASGNB 12
line 1936
;1936:	}
ADDRGP4 $854
JUMPV
LABELV $853
line 1938
;1937:	//if waiting for something
;1938:	else if (moveresult.flags & MOVERESULT_WAITING) {
ADDRLP4 0+20
INDIRI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $857
line 1939
;1939:		if (random() < bs->thinktime * 0.8) {
ADDRLP4 188
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 188
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1061997773
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $858
line 1940
;1940:			BotRoamGoal(bs, target);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 112
ARGP4
ADDRGP4 BotRoamGoal
CALLV
pop
line 1941
;1941:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 124
ADDRLP4 112
INDIRF4
ADDRLP4 192
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 112+4
INDIRF4
ADDRLP4 192
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 112+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1942
;1942:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 124
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1943
;1943:			bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 196
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 196
INDIRP4
CNSTF4 1056964608
ADDRLP4 196
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1944
;1944:		}
line 1945
;1945:	}
ADDRGP4 $858
JUMPV
LABELV $857
line 1946
;1946:	else if (!(bs->flags & BFL_IDEALVIEWSET)) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $866
line 1947
;1947:		if (trap_BotMovementViewTarget(bs->ms, &goal, bs->tfl, 300, target)) {
ADDRLP4 188
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 188
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 188
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTF4 1133903872
ARGF4
ADDRLP4 112
ARGP4
ADDRLP4 192
ADDRGP4 trap_BotMovementViewTarget
CALLI4
ASGNI4
ADDRLP4 192
INDIRI4
CNSTI4 0
EQI4 $868
line 1948
;1948:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 196
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 124
ADDRLP4 112
INDIRF4
ADDRLP4 196
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 112+4
INDIRF4
ADDRLP4 196
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 112+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1949
;1949:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 124
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1950
;1950:		}
ADDRGP4 $869
JUMPV
LABELV $868
line 1952
;1951:		//FIXME: look at cluster portals?
;1952:		else if (VectorLengthSquared(moveresult.movedir)) {
ADDRLP4 0+28
ARGP4
ADDRLP4 196
ADDRGP4 VectorLengthSquared
CALLF4
ASGNF4
ADDRLP4 196
INDIRF4
CNSTF4 0
EQF4 $874
line 1953
;1953:			vectoangles(moveresult.movedir, bs->ideal_viewangles);
ADDRLP4 0+28
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1954
;1954:		}
ADDRGP4 $875
JUMPV
LABELV $874
line 1955
;1955:		else if (random() < bs->thinktime * 0.8) {
ADDRLP4 200
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 200
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1061997773
ADDRFP4 0
INDIRP4
CNSTI4 4904
ADDP4
INDIRF4
MULF4
GEF4 $878
line 1956
;1956:			BotRoamGoal(bs, target);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 112
ARGP4
ADDRGP4 BotRoamGoal
CALLV
pop
line 1957
;1957:			VectorSubtract(target, bs->origin, dir);
ADDRLP4 204
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 124
ADDRLP4 112
INDIRF4
ADDRLP4 204
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 112+4
INDIRF4
ADDRLP4 204
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 112+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 1958
;1958:			vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 124
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 1959
;1959:			bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 208
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 208
INDIRP4
CNSTF4 1056964608
ADDRLP4 208
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1960
;1960:		}
LABELV $878
LABELV $875
LABELV $869
line 1961
;1961:		bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 204
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 204
INDIRP4
CNSTF4 1056964608
ADDRLP4 204
INDIRP4
INDIRF4
MULF4
ASGNF4
line 1962
;1962:	}
LABELV $866
LABELV $858
LABELV $854
line 1964
;1963:	//if the weapon is used for the bot movement
;1964:	if (moveresult.flags & MOVERESULT_MOVEMENTWEAPON) bs->weaponnum = moveresult.weapon;
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $884
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0+24
INDIRI4
ASGNI4
LABELV $884
line 1966
;1965:	//
;1966:	return qtrue;
CNSTI4 1
RETI4
LABELV $807
endproc AINode_Seek_LTG 212 20
export AIEnter_Battle_Fight
proc AIEnter_Battle_Fight 0 16
line 1974
;1967:}
;1968:
;1969:/*
;1970:==================
;1971:AIEnter_Battle_Fight
;1972:==================
;1973:*/
;1974:void AIEnter_Battle_Fight(bot_state_t *bs, char *s) {
line 1975
;1975:	BotRecordNodeSwitch(bs, "battle fight", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $889
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1976
;1976:	trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 1977
;1977:	bs->ainode = AINode_Battle_Fight;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Battle_Fight
ASGNP4
line 1978
;1978:}
LABELV $888
endproc AIEnter_Battle_Fight 0 16
export AIEnter_Battle_SuicidalFight
proc AIEnter_Battle_SuicidalFight 4 16
line 1985
;1979:
;1980:/*
;1981:==================
;1982:AIEnter_Battle_Fight
;1983:==================
;1984:*/
;1985:void AIEnter_Battle_SuicidalFight(bot_state_t *bs, char *s) {
line 1986
;1986:	BotRecordNodeSwitch(bs, "battle fight", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $889
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 1987
;1987:	trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 1988
;1988:	bs->ainode = AINode_Battle_Fight;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Battle_Fight
ASGNP4
line 1989
;1989:	bs->flags |= BFL_FIGHTSUICIDAL;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
line 1990
;1990:}
LABELV $890
endproc AIEnter_Battle_SuicidalFight 4 16
export AINode_Battle_Fight
proc AINode_Battle_Fight 292 20
line 1997
;1991:
;1992:/*
;1993:==================
;1994:AINode_Battle_Fight
;1995:==================
;1996:*/
;1997:int AINode_Battle_Fight(bot_state_t *bs) {
line 2003
;1998:	int areanum;
;1999:	vec3_t target;
;2000:	aas_entityinfo_t entinfo;
;2001:	bot_moveresult_t moveresult;
;2002:
;2003:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 208
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 208
INDIRI4
CNSTI4 0
EQI4 $892
line 2004
;2004:		AIEnter_Observer(bs, "battle fight: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $894
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 2005
;2005:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $892
line 2009
;2006:	}
;2007:
;2008:	//if in the intermission
;2009:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 212
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 212
INDIRI4
CNSTI4 0
EQI4 $895
line 2010
;2010:		AIEnter_Intermission(bs, "battle fight: intermission");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $897
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 2011
;2011:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $895
line 2014
;2012:	}
;2013:	//respawn if dead
;2014:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 216
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 216
INDIRI4
CNSTI4 0
EQI4 $898
line 2015
;2015:		AIEnter_Respawn(bs, "battle fight: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $900
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 2016
;2016:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $898
line 2019
;2017:	}
;2018:	//if there is another better enemy
;2019:	if (BotFindEnemy(bs, bs->enemy)) {
ADDRLP4 220
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 220
INDIRP4
ARGP4
ADDRLP4 220
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 224
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 224
INDIRI4
CNSTI4 0
EQI4 $901
line 2023
;2020:#ifdef DEBUG
;2021:		BotAI_Print(PRT_MESSAGE, "found new better enemy\n");
;2022:#endif
;2023:	}
LABELV $901
line 2025
;2024:	//if no enemy
;2025:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $903
line 2026
;2026:		AIEnter_Seek_LTG(bs, "battle fight: no enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $905
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2027
;2027:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $903
line 2030
;2028:	}
;2029:	//
;2030:	BotEntityInfo(bs->enemy, &entinfo);
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
line 2032
;2031:	//if the enemy is dead
;2032:	if (bs->enemydeath_time) {
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
INDIRF4
CNSTF4 0
EQF4 $906
line 2033
;2033:		if (bs->enemydeath_time < FloatTime() - 1.0) {
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
SUBF4
GEF4 $907
line 2034
;2034:			bs->enemydeath_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
CNSTF4 0
ASGNF4
line 2035
;2035:			if (bs->enemysuicide) {
ADDRFP4 0
INDIRP4
CNSTI4 6012
ADDP4
INDIRI4
CNSTI4 0
EQI4 $910
line 2036
;2036:				BotChat_EnemySuicide(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotChat_EnemySuicide
CALLI4
pop
line 2037
;2037:			}
LABELV $910
line 2038
;2038:			if (bs->lastkilledplayer == bs->enemy && BotChat_Kill(bs)) {
ADDRLP4 228
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 228
INDIRP4
CNSTI4 5992
ADDP4
INDIRI4
ADDRLP4 228
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
NEI4 $912
ADDRLP4 228
INDIRP4
ARGP4
ADDRLP4 232
ADDRGP4 BotChat_Kill
CALLI4
ASGNI4
ADDRLP4 232
INDIRI4
CNSTI4 0
EQI4 $912
line 2039
;2039:				bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 236
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 236
INDIRP4
ARGP4
ADDRLP4 240
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 236
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 240
INDIRF4
ADDF4
ASGNF4
line 2040
;2040:				AIEnter_Stand(bs, "battle fight: enemy dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $914
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 2041
;2041:			}
ADDRGP4 $913
JUMPV
LABELV $912
line 2042
;2042:			else {
line 2043
;2043:				bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2044
;2044:				AIEnter_Seek_LTG(bs, "battle fight: enemy dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $914
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2045
;2045:			}
LABELV $913
line 2046
;2046:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
line 2048
;2047:		}
;2048:	}
LABELV $906
line 2049
;2049:	else {
line 2050
;2050:		if (EntityIsDead(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 228
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 228
INDIRI4
CNSTI4 0
EQI4 $915
line 2051
;2051:			bs->enemydeath_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6136
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2052
;2052:		}
LABELV $915
line 2053
;2053:	}
LABELV $907
line 2055
;2054:	//if the enemy is invisible and not shooting the bot looses track easily
;2055:	if (EntityIsInvisible(&entinfo) && !EntityIsShooting(&entinfo)) {
ADDRLP4 0
ARGP4
ADDRLP4 228
ADDRGP4 EntityIsInvisible
CALLI4
ASGNI4
ADDRLP4 228
INDIRI4
CNSTI4 0
EQI4 $917
ADDRLP4 0
ARGP4
ADDRLP4 232
ADDRGP4 EntityIsShooting
CALLI4
ASGNI4
ADDRLP4 232
INDIRI4
CNSTI4 0
NEI4 $917
line 2056
;2056:		if (random() < 0.2) {
ADDRLP4 236
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 236
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1045220557
GEF4 $919
line 2057
;2057:			AIEnter_Seek_LTG(bs, "battle fight: invisible");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $921
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2058
;2058:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $919
line 2060
;2059:		}
;2060:	}
LABELV $917
line 2062
;2061:	//
;2062:	VectorCopy(entinfo.origin, target);
ADDRLP4 196
ADDRLP4 0+24
INDIRB
ASGNB 12
line 2064
;2063:	// if not a player enemy
;2064:	if (bs->enemy >= MAX_CLIENTS) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 64
LTI4 $923
line 2072
;2065:#ifdef MISSIONPACK
;2066:		// if attacking an obelisk
;2067:		if ( bs->enemy == redobelisk.entitynum ||
;2068:			bs->enemy == blueobelisk.entitynum ) {
;2069:			target[2] += 16;
;2070:		}
;2071:#endif
;2072:	}
LABELV $923
line 2074
;2073:	//update the reachability area and origin if possible
;2074:	areanum = BotPointAreaNum(target);
ADDRLP4 196
ARGP4
ADDRLP4 236
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 192
ADDRLP4 236
INDIRI4
ASGNI4
line 2075
;2075:	if (areanum && trap_AAS_AreaReachability(areanum)) {
ADDRLP4 192
INDIRI4
CNSTI4 0
EQI4 $925
ADDRLP4 192
INDIRI4
ARGI4
ADDRLP4 244
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 244
INDIRI4
CNSTI4 0
EQI4 $925
line 2076
;2076:		VectorCopy(target, bs->lastenemyorigin);
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
ADDRLP4 196
INDIRB
ASGNB 12
line 2077
;2077:		bs->lastenemyareanum = areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6544
ADDP4
ADDRLP4 192
INDIRI4
ASGNI4
line 2078
;2078:	}
LABELV $925
line 2080
;2079:	//update the attack inventory values
;2080:	BotUpdateBattleInventory(bs, bs->enemy);
ADDRLP4 248
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 248
INDIRP4
ARGP4
ADDRLP4 248
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 2082
;2081:	//if the bot's health decreased
;2082:	if (bs->lastframe_health > bs->inventory[INVENTORY_HEALTH]) {
ADDRLP4 252
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 252
INDIRP4
CNSTI4 6044
ADDP4
INDIRI4
ADDRLP4 252
INDIRP4
CNSTI4 5068
ADDP4
INDIRI4
LEI4 $927
line 2083
;2083:		if (BotChat_HitNoDeath(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 256
ADDRGP4 BotChat_HitNoDeath
CALLI4
ASGNI4
ADDRLP4 256
INDIRI4
CNSTI4 0
EQI4 $929
line 2084
;2084:			bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 260
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
INDIRP4
ARGP4
ADDRLP4 264
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 260
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 264
INDIRF4
ADDF4
ASGNF4
line 2085
;2085:			AIEnter_Stand(bs, "battle fight: chat health decreased");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $931
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 2086
;2086:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $929
line 2088
;2087:		}
;2088:	}
LABELV $927
line 2090
;2089:	//if the bot hit someone
;2090:	if (bs->cur_ps.persistant[PERS_HITS] > bs->lasthitcount) {
ADDRLP4 256
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 256
INDIRP4
CNSTI4 268
ADDP4
INDIRI4
ADDRLP4 256
INDIRP4
CNSTI4 6048
ADDP4
INDIRI4
LEI4 $932
line 2091
;2091:		if (BotChat_HitNoKill(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 260
ADDRGP4 BotChat_HitNoKill
CALLI4
ASGNI4
ADDRLP4 260
INDIRI4
CNSTI4 0
EQI4 $934
line 2092
;2092:			bs->stand_time = FloatTime() + BotChatTime(bs);
ADDRLP4 264
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 264
INDIRP4
ARGP4
ADDRLP4 268
ADDRGP4 BotChatTime
CALLF4
ASGNF4
ADDRLP4 264
INDIRP4
CNSTI4 6096
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 268
INDIRF4
ADDF4
ASGNF4
line 2093
;2093:			AIEnter_Stand(bs, "battle fight: chat hit someone");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $936
ARGP4
ADDRGP4 AIEnter_Stand
CALLV
pop
line 2094
;2094:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $934
line 2096
;2095:		}
;2096:	}
LABELV $932
line 2098
;2097:	//if the enemy is not visible
;2098:	if (!BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy)) {
ADDRLP4 260
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 260
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 260
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 260
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 260
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 264
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 264
INDIRF4
CNSTF4 0
NEF4 $937
line 2099
;2099:		if (BotWantsToChase(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 268
ADDRGP4 BotWantsToChase
CALLI4
ASGNI4
ADDRLP4 268
INDIRI4
CNSTI4 0
EQI4 $939
line 2100
;2100:			AIEnter_Battle_Chase(bs, "battle fight: enemy out of sight");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $941
ARGP4
ADDRGP4 AIEnter_Battle_Chase
CALLV
pop
line 2101
;2101:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $939
line 2103
;2102:		}
;2103:		else {
line 2104
;2104:			AIEnter_Seek_LTG(bs, "battle fight: enemy out of sight");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $941
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2105
;2105:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $891
JUMPV
LABELV $937
line 2109
;2106:		}
;2107:	}
;2108:	//use holdable items
;2109:	BotBattleUseItems(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotBattleUseItems
CALLV
pop
line 2111
;2110:	//
;2111:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 2112
;2112:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $942
ADDRLP4 268
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 268
INDIRP4
ADDRLP4 268
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $942
line 2114
;2113:	//if in lava or slime the bot should be able to get out
;2114:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 272
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 272
INDIRI4
CNSTI4 0
EQI4 $945
ADDRLP4 276
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 276
INDIRP4
ADDRLP4 276
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $945
line 2116
;2115:	//
;2116:	if (BotCanAndWantsToRocketJump(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
ADDRGP4 BotCanAndWantsToRocketJump
CALLI4
ASGNI4
ADDRLP4 280
INDIRI4
CNSTI4 0
EQI4 $947
line 2117
;2117:		bs->tfl |= TFL_ROCKETJUMP;
ADDRLP4 284
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 284
INDIRP4
ADDRLP4 284
INDIRP4
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 2118
;2118:	}
LABELV $947
line 2120
;2119:	//choose the best weapon to fight with
;2120:	BotChooseWeapon(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotChooseWeapon
CALLV
pop
line 2122
;2121:	//do attack movements
;2122:	moveresult = BotAttackMove(bs, bs->tfl);
ADDRLP4 140
ARGP4
ADDRLP4 284
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 284
INDIRP4
ARGP4
ADDRLP4 284
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotAttackMove
CALLV
pop
line 2124
;2123:	//if the movement failed
;2124:	if (moveresult.failure) {
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $949
line 2126
;2125:		//reset the avoid reach, otherwise bot is stuck in current area
;2126:		trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 2128
;2127:		//BotAI_Print(PRT_MESSAGE, "movement failure %d\n", moveresult.traveltype);
;2128:		bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2129
;2129:	}
LABELV $949
line 2131
;2130:	//
;2131:	BotAIBlocked(bs, &moveresult, qfalse);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 2133
;2132:	//aim at the enemy
;2133:	BotAimAtEnemy(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotAimAtEnemy
CALLV
pop
line 2135
;2134:	//attack the enemy if possible
;2135:	BotCheckAttack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckAttack
CALLV
pop
line 2137
;2136:	//if the bot wants to retreat
;2137:	if (!(bs->flags & BFL_FIGHTSUICIDAL)) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 64
BANDI4
CNSTI4 0
NEI4 $951
line 2138
;2138:		if (BotWantsToRetreat(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 288
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 288
INDIRI4
CNSTI4 0
EQI4 $953
line 2139
;2139:			AIEnter_Battle_Retreat(bs, "battle fight: wants to retreat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $955
ARGP4
ADDRGP4 AIEnter_Battle_Retreat
CALLV
pop
line 2140
;2140:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $891
JUMPV
LABELV $953
line 2142
;2141:		}
;2142:	}
LABELV $951
line 2143
;2143:	return qtrue;
CNSTI4 1
RETI4
LABELV $891
endproc AINode_Battle_Fight 292 20
export AIEnter_Battle_Chase
proc AIEnter_Battle_Chase 0 16
line 2151
;2144:}
;2145:
;2146:/*
;2147:==================
;2148:AIEnter_Battle_Chase
;2149:==================
;2150:*/
;2151:void AIEnter_Battle_Chase(bot_state_t *bs, char *s) {
line 2152
;2152:	BotRecordNodeSwitch(bs, "battle chase", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $957
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 2153
;2153:	bs->chase_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6084
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2154
;2154:	bs->ainode = AINode_Battle_Chase;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Battle_Chase
ASGNP4
line 2155
;2155:}
LABELV $956
endproc AIEnter_Battle_Chase 0 16
export AINode_Battle_Chase
proc AINode_Battle_Chase 204 20
line 2163
;2156:
;2157:/*
;2158:==================
;2159:AINode_Battle_Chase
;2160:==================
;2161:*/
;2162:int AINode_Battle_Chase(bot_state_t *bs)
;2163:{
line 2169
;2164:	bot_goal_t goal;
;2165:	vec3_t target, dir;
;2166:	bot_moveresult_t moveresult;
;2167:	float range;
;2168:
;2169:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 136
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 136
INDIRI4
CNSTI4 0
EQI4 $959
line 2170
;2170:		AIEnter_Observer(bs, "battle chase: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $961
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 2171
;2171:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $959
line 2174
;2172:	}
;2173:	//if in the intermission
;2174:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 140
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 0
EQI4 $962
line 2175
;2175:		AIEnter_Intermission(bs, "battle chase: intermission");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $964
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 2176
;2176:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $962
line 2179
;2177:	}
;2178:	//respawn if dead
;2179:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 144
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
EQI4 $965
line 2180
;2180:		AIEnter_Respawn(bs, "battle chase: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $967
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 2181
;2181:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $965
line 2184
;2182:	}
;2183:	//if no enemy
;2184:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $968
line 2185
;2185:		AIEnter_Seek_LTG(bs, "battle chase: no enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $970
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2186
;2186:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $968
line 2189
;2187:	}
;2188:	//if the enemy is visible
;2189:	if (BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy)) {
ADDRLP4 148
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 148
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 148
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 148
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 148
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 152
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 152
INDIRF4
CNSTF4 0
EQF4 $971
line 2190
;2190:		AIEnter_Battle_Fight(bs, "battle chase");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $957
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 2191
;2191:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $971
line 2194
;2192:	}
;2193:	//if there is another enemy
;2194:	if (BotFindEnemy(bs, -1)) {
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 156
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 156
INDIRI4
CNSTI4 0
EQI4 $973
line 2195
;2195:		AIEnter_Battle_Fight(bs, "battle chase: better enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $975
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 2196
;2196:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $973
line 2199
;2197:	}
;2198:	//there is no last enemy area
;2199:	if (!bs->lastenemyareanum) {
ADDRFP4 0
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
CNSTI4 0
NEI4 $976
line 2200
;2200:		AIEnter_Seek_LTG(bs, "battle chase: no enemy area");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $978
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2201
;2201:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $976
line 2204
;2202:	}
;2203:	//
;2204:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 2205
;2205:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $979
ADDRLP4 160
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 160
INDIRP4
ADDRLP4 160
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $979
line 2207
;2206:	//if in lava or slime the bot should be able to get out
;2207:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 164
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 164
INDIRI4
CNSTI4 0
EQI4 $982
ADDRLP4 168
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 168
INDIRP4
ADDRLP4 168
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $982
line 2209
;2208:	//
;2209:	if (BotCanAndWantsToRocketJump(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 172
ADDRGP4 BotCanAndWantsToRocketJump
CALLI4
ASGNI4
ADDRLP4 172
INDIRI4
CNSTI4 0
EQI4 $984
line 2210
;2210:		bs->tfl |= TFL_ROCKETJUMP;
ADDRLP4 176
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 176
INDIRP4
ADDRLP4 176
INDIRP4
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 2211
;2211:	}
LABELV $984
line 2213
;2212:	//map specific code
;2213:	BotMapScripts(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotMapScripts
CALLV
pop
line 2215
;2214:	//create the chase goal
;2215:	goal.entitynum = bs->enemy;
ADDRLP4 0+40
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ASGNI4
line 2216
;2216:	goal.areanum = bs->lastenemyareanum;
ADDRLP4 0+12
ADDRFP4 0
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
ASGNI4
line 2217
;2217:	VectorCopy(bs->lastenemyorigin, goal.origin);
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
INDIRB
ASGNB 12
line 2218
;2218:	VectorSet(goal.mins, -8, -8, -8);
ADDRLP4 0+16
CNSTF4 3238002688
ASGNF4
ADDRLP4 0+16+4
CNSTF4 3238002688
ASGNF4
ADDRLP4 0+16+8
CNSTF4 3238002688
ASGNF4
line 2219
;2219:	VectorSet(goal.maxs, 8, 8, 8);
ADDRLP4 0+28
CNSTF4 1090519040
ASGNF4
ADDRLP4 0+28+4
CNSTF4 1090519040
ASGNF4
ADDRLP4 0+28+8
CNSTF4 1090519040
ASGNF4
line 2221
;2220:	//if the last seen enemy spot is reached the enemy could not be found
;2221:	if (trap_BotTouchingGoal(bs->origin, &goal)) bs->chase_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 4908
ADDP4
ARGP4
ADDRLP4 0
ARGP4
ADDRLP4 176
ADDRGP4 trap_BotTouchingGoal
CALLI4
ASGNI4
ADDRLP4 176
INDIRI4
CNSTI4 0
EQI4 $998
ADDRFP4 0
INDIRP4
CNSTI4 6084
ADDP4
CNSTF4 0
ASGNF4
LABELV $998
line 2223
;2222:	//if there's no chase time left
;2223:	if (!bs->chase_time || bs->chase_time < FloatTime() - 10) {
ADDRLP4 180
ADDRFP4 0
INDIRP4
CNSTI4 6084
ADDP4
INDIRF4
ASGNF4
ADDRLP4 180
INDIRF4
CNSTF4 0
EQF4 $1002
ADDRLP4 180
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1092616192
SUBF4
GEF4 $1000
LABELV $1002
line 2224
;2224:		AIEnter_Seek_LTG(bs, "battle chase: time out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1003
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2225
;2225:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $1000
line 2228
;2226:	}
;2227:	//check for nearby goals periodicly
;2228:	if (bs->check_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1004
line 2229
;2229:		bs->check_time = FloatTime() + 1;
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2230
;2230:		range = 150;
ADDRLP4 108
CNSTF4 1125515264
ASGNF4
line 2232
;2231:		//
;2232:		if (BotNearbyGoal(bs, bs->tfl, &goal, range)) {
ADDRLP4 184
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 184
INDIRP4
ARGP4
ADDRLP4 184
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 108
INDIRF4
ARGF4
ADDRLP4 188
ADDRGP4 BotNearbyGoal
CALLI4
ASGNI4
ADDRLP4 188
INDIRI4
CNSTI4 0
EQI4 $1006
line 2234
;2233:			//the bot gets 5 seconds to pick up the nearby goal item
;2234:			bs->nbg_time = FloatTime() + 0.1 * range + 1;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1036831949
ADDRLP4 108
INDIRF4
MULF4
ADDF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2235
;2235:			trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 2236
;2236:			AIEnter_Battle_NBG(bs, "battle chase: nbg");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1008
ARGP4
ADDRGP4 AIEnter_Battle_NBG
CALLV
pop
line 2237
;2237:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $958
JUMPV
LABELV $1006
line 2239
;2238:		}
;2239:	}
LABELV $1004
line 2241
;2240:	//
;2241:	BotUpdateBattleInventory(bs, bs->enemy);
ADDRLP4 184
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 184
INDIRP4
ARGP4
ADDRLP4 184
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 2243
;2242:	//initialize the movement state
;2243:	BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2245
;2244:	//move towards the goal
;2245:	trap_BotMoveToGoal(&moveresult, bs->ms, &goal, bs->tfl);
ADDRLP4 56
ARGP4
ADDRLP4 188
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 188
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 188
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 2247
;2246:	//if the movement failed
;2247:	if (moveresult.failure) {
ADDRLP4 56
INDIRI4
CNSTI4 0
EQI4 $1009
line 2249
;2248:		//reset the avoid reach, otherwise bot is stuck in current area
;2249:		trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 2251
;2250:		//BotAI_Print(PRT_MESSAGE, "movement failure %d\n", moveresult.traveltype);
;2251:		bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2252
;2252:	}
LABELV $1009
line 2254
;2253:	//
;2254:	BotAIBlocked(bs, &moveresult, qfalse);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 56
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 2256
;2255:	//
;2256:	if (moveresult.flags & (MOVERESULT_MOVEMENTVIEWSET|MOVERESULT_MOVEMENTVIEW|MOVERESULT_SWIMVIEW)) {
ADDRLP4 56+20
INDIRI4
CNSTI4 11
BANDI4
CNSTI4 0
EQI4 $1011
line 2257
;2257:		VectorCopy(moveresult.ideal_viewangles, bs->ideal_viewangles);
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ADDRLP4 56+40
INDIRB
ASGNB 12
line 2258
;2258:	}
ADDRGP4 $1012
JUMPV
LABELV $1011
line 2259
;2259:	else if (!(bs->flags & BFL_IDEALVIEWSET)) {
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
NEI4 $1015
line 2260
;2260:		if (bs->chase_time > FloatTime() - 2) {
ADDRFP4 0
INDIRP4
CNSTI4 6084
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1073741824
SUBF4
LEF4 $1017
line 2261
;2261:			BotAimAtEnemy(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotAimAtEnemy
CALLV
pop
line 2262
;2262:		}
ADDRGP4 $1018
JUMPV
LABELV $1017
line 2263
;2263:		else {
line 2264
;2264:			if (trap_BotMovementViewTarget(bs->ms, &goal, bs->tfl, 300, target)) {
ADDRLP4 192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 192
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRLP4 192
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTF4 1133903872
ARGF4
ADDRLP4 112
ARGP4
ADDRLP4 196
ADDRGP4 trap_BotMovementViewTarget
CALLI4
ASGNI4
ADDRLP4 196
INDIRI4
CNSTI4 0
EQI4 $1019
line 2265
;2265:				VectorSubtract(target, bs->origin, dir);
ADDRLP4 200
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 124
ADDRLP4 112
INDIRF4
ADDRLP4 200
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+4
ADDRLP4 112+4
INDIRF4
ADDRLP4 200
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 124+8
ADDRLP4 112+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2266
;2266:				vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 124
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2267
;2267:			}
ADDRGP4 $1020
JUMPV
LABELV $1019
line 2268
;2268:			else {
line 2269
;2269:				vectoangles(moveresult.movedir, bs->ideal_viewangles);
ADDRLP4 56+28
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2270
;2270:			}
LABELV $1020
line 2271
;2271:		}
LABELV $1018
line 2272
;2272:		bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 192
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 192
INDIRP4
CNSTF4 1056964608
ADDRLP4 192
INDIRP4
INDIRF4
MULF4
ASGNF4
line 2273
;2273:	}
LABELV $1015
LABELV $1012
line 2275
;2274:	//if the weapon is used for the bot movement
;2275:	if (moveresult.flags & MOVERESULT_MOVEMENTWEAPON) bs->weaponnum = moveresult.weapon;
ADDRLP4 56+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $1026
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 56+24
INDIRI4
ASGNI4
LABELV $1026
line 2277
;2276:	//if the bot is in the area the enemy was last seen in
;2277:	if (bs->areanum == bs->lastenemyareanum) bs->chase_time = 0;
ADDRLP4 192
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 192
INDIRP4
CNSTI4 4948
ADDP4
INDIRI4
ADDRLP4 192
INDIRP4
CNSTI4 6544
ADDP4
INDIRI4
NEI4 $1030
ADDRFP4 0
INDIRP4
CNSTI4 6084
ADDP4
CNSTF4 0
ASGNF4
LABELV $1030
line 2279
;2278:	//if the bot wants to retreat (the bot could have been damage during the chase)
;2279:	if (BotWantsToRetreat(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 196
ADDRGP4 BotWantsToRetreat
CALLI4
ASGNI4
ADDRLP4 196
INDIRI4
CNSTI4 0
EQI4 $1032
line 2280
;2280:		AIEnter_Battle_Retreat(bs, "battle chase: wants to retreat");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1034
ARGP4
ADDRGP4 AIEnter_Battle_Retreat
CALLV
pop
line 2281
;2281:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $958
JUMPV
LABELV $1032
line 2283
;2282:	}
;2283:	return qtrue;
CNSTI4 1
RETI4
LABELV $958
endproc AINode_Battle_Chase 204 20
export AIEnter_Battle_Retreat
proc AIEnter_Battle_Retreat 0 16
line 2291
;2284:}
;2285:
;2286:/*
;2287:==================
;2288:AIEnter_Battle_Retreat
;2289:==================
;2290:*/
;2291:void AIEnter_Battle_Retreat(bot_state_t *bs, char *s) {
line 2292
;2292:	BotRecordNodeSwitch(bs, "battle retreat", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1036
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 2293
;2293:	bs->ainode = AINode_Battle_Retreat;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Battle_Retreat
ASGNP4
line 2294
;2294:}
LABELV $1035
endproc AIEnter_Battle_Retreat 0 16
export AINode_Battle_Retreat
proc AINode_Battle_Retreat 368 20
line 2301
;2295:
;2296:/*
;2297:==================
;2298:AINode_Battle_Retreat
;2299:==================
;2300:*/
;2301:int AINode_Battle_Retreat(bot_state_t *bs) {
line 2309
;2302:	bot_goal_t goal;
;2303:	aas_entityinfo_t entinfo;
;2304:	bot_moveresult_t moveresult;
;2305:	vec3_t target, dir;
;2306:	float attack_skill, range;
;2307:	int areanum;
;2308:
;2309:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 284
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 284
INDIRI4
CNSTI4 0
EQI4 $1038
line 2310
;2310:		AIEnter_Observer(bs, "battle retreat: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1040
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 2311
;2311:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1038
line 2314
;2312:	}
;2313:	//if in the intermission
;2314:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 288
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 288
INDIRI4
CNSTI4 0
EQI4 $1041
line 2315
;2315:		AIEnter_Intermission(bs, "battle retreat: intermission");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1043
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 2316
;2316:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1041
line 2319
;2317:	}
;2318:	//respawn if dead
;2319:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 292
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 292
INDIRI4
CNSTI4 0
EQI4 $1044
line 2320
;2320:		AIEnter_Respawn(bs, "battle retreat: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1046
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 2321
;2321:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1044
line 2324
;2322:	}
;2323:	//if no enemy
;2324:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $1047
line 2325
;2325:		AIEnter_Seek_LTG(bs, "battle retreat: no enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1049
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2326
;2326:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1047
line 2329
;2327:	}
;2328:	//
;2329:	BotEntityInfo(bs->enemy, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 108
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2330
;2330:	if (EntityIsDead(&entinfo)) {
ADDRLP4 108
ARGP4
ADDRLP4 296
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 296
INDIRI4
CNSTI4 0
EQI4 $1050
line 2331
;2331:		AIEnter_Seek_LTG(bs, "battle retreat: enemy dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1052
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2332
;2332:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1050
line 2335
;2333:	}
;2334:	//if there is another better enemy
;2335:	if (BotFindEnemy(bs, bs->enemy)) {
ADDRLP4 300
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 300
INDIRP4
ARGP4
ADDRLP4 300
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 304
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 304
INDIRI4
CNSTI4 0
EQI4 $1053
line 2339
;2336:#ifdef DEBUG
;2337:		BotAI_Print(PRT_MESSAGE, "found new better enemy\n");
;2338:#endif
;2339:	}
LABELV $1053
line 2341
;2340:	//
;2341:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 2342
;2342:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $1055
ADDRLP4 308
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 308
INDIRP4
ADDRLP4 308
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $1055
line 2344
;2343:	//if in lava or slime the bot should be able to get out
;2344:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 312
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 312
INDIRI4
CNSTI4 0
EQI4 $1058
ADDRLP4 316
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 316
INDIRP4
ADDRLP4 316
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $1058
line 2346
;2345:	//map specific code
;2346:	BotMapScripts(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotMapScripts
CALLV
pop
line 2348
;2347:	//update the attack inventory values
;2348:	BotUpdateBattleInventory(bs, bs->enemy);
ADDRLP4 320
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 320
INDIRP4
ARGP4
ADDRLP4 320
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 2350
;2349:	//if the bot doesn't want to retreat anymore... probably picked up some nice items
;2350:	if (BotWantsToChase(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 324
ADDRGP4 BotWantsToChase
CALLI4
ASGNI4
ADDRLP4 324
INDIRI4
CNSTI4 0
EQI4 $1060
line 2352
;2351:		//empty the goal stack, when chasing, only the enemy is the goal
;2352:		trap_BotEmptyGoalStack(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotEmptyGoalStack
CALLV
pop
line 2354
;2353:		//go chase the enemy
;2354:		AIEnter_Battle_Chase(bs, "battle retreat: wants to chase");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1062
ARGP4
ADDRGP4 AIEnter_Battle_Chase
CALLV
pop
line 2355
;2355:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1060
line 2358
;2356:	}
;2357:	//update the last time the enemy was visible
;2358:	if (BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy)) {
ADDRLP4 328
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 328
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 328
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 328
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 328
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 332
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 332
INDIRF4
CNSTF4 0
EQF4 $1063
line 2359
;2359:		bs->enemyvisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2360
;2360:		VectorCopy(entinfo.origin, target);
ADDRLP4 252
ADDRLP4 108+24
INDIRB
ASGNB 12
line 2362
;2361:		// if not a player enemy
;2362:		if (bs->enemy >= MAX_CLIENTS) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 64
LTI4 $1066
line 2370
;2363:#ifdef MISSIONPACK
;2364:			// if attacking an obelisk
;2365:			if ( bs->enemy == redobelisk.entitynum ||
;2366:				bs->enemy == blueobelisk.entitynum ) {
;2367:				target[2] += 16;
;2368:			}
;2369:#endif
;2370:		}
LABELV $1066
line 2372
;2371:		//update the reachability area and origin if possible
;2372:		areanum = BotPointAreaNum(target);
ADDRLP4 252
ARGP4
ADDRLP4 336
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 248
ADDRLP4 336
INDIRI4
ASGNI4
line 2373
;2373:		if (areanum && trap_AAS_AreaReachability(areanum)) {
ADDRLP4 340
ADDRLP4 248
INDIRI4
ASGNI4
ADDRLP4 340
INDIRI4
CNSTI4 0
EQI4 $1068
ADDRLP4 340
INDIRI4
ARGI4
ADDRLP4 344
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
EQI4 $1068
line 2374
;2374:			VectorCopy(target, bs->lastenemyorigin);
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
ADDRLP4 252
INDIRB
ASGNB 12
line 2375
;2375:			bs->lastenemyareanum = areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6544
ADDP4
ADDRLP4 248
INDIRI4
ASGNI4
line 2376
;2376:		}
LABELV $1068
line 2377
;2377:	}
LABELV $1063
line 2379
;2378:	//if the enemy is NOT visible for 4 seconds
;2379:	if (bs->enemyvisible_time < FloatTime() - 4) {
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
CNSTF4 1082130432
SUBF4
GEF4 $1070
line 2380
;2380:		AIEnter_Seek_LTG(bs, "battle retreat: lost enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1072
ARGP4
ADDRGP4 AIEnter_Seek_LTG
CALLV
pop
line 2381
;2381:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1070
line 2384
;2382:	}
;2383:	//else if the enemy is NOT visible
;2384:	else if (bs->enemyvisible_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1073
line 2386
;2385:		//if there is another enemy
;2386:		if (BotFindEnemy(bs, -1)) {
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 -1
ARGI4
ADDRLP4 336
ADDRGP4 BotFindEnemy
CALLI4
ASGNI4
ADDRLP4 336
INDIRI4
CNSTI4 0
EQI4 $1075
line 2387
;2387:			AIEnter_Battle_Fight(bs, "battle retreat: another enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1077
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
line 2388
;2388:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1075
line 2390
;2389:		}
;2390:	}
LABELV $1073
line 2392
;2391:	//
;2392:	BotTeamGoals(bs, qtrue);
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 1
ARGI4
ADDRGP4 BotTeamGoals
CALLV
pop
line 2394
;2393:	//use holdable items
;2394:	BotBattleUseItems(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotBattleUseItems
CALLV
pop
line 2396
;2395:	//get the current long term goal while retreating
;2396:	if (!BotLongTermGoal(bs, bs->tfl, qtrue, &goal)) {
ADDRLP4 336
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 336
INDIRP4
ARGP4
ADDRLP4 336
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 340
ADDRGP4 BotLongTermGoal
CALLI4
ASGNI4
ADDRLP4 340
INDIRI4
CNSTI4 0
NEI4 $1078
line 2397
;2397:		AIEnter_Battle_SuicidalFight(bs, "battle retreat: no way out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1080
ARGP4
ADDRGP4 AIEnter_Battle_SuicidalFight
CALLV
pop
line 2398
;2398:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1078
line 2401
;2399:	}
;2400:	//check for nearby goals periodicly
;2401:	if (bs->check_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1081
line 2402
;2402:		bs->check_time = FloatTime() + 1;
ADDRFP4 0
INDIRP4
CNSTI4 6092
ADDP4
ADDRGP4 floattime
INDIRF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2403
;2403:		range = 150;
ADDRLP4 264
CNSTF4 1125515264
ASGNF4
line 2405
;2404:#ifdef CTF
;2405:		if (gametype == GT_CTF) {
ADDRGP4 gametype
INDIRI4
CNSTI4 4
NEI4 $1083
line 2407
;2406:			//if carrying a flag the bot shouldn't be distracted too much
;2407:			if (BotCTFCarryingFlag(bs))
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 344
ADDRGP4 BotCTFCarryingFlag
CALLI4
ASGNI4
ADDRLP4 344
INDIRI4
CNSTI4 0
EQI4 $1085
line 2408
;2408:				range = 50;
ADDRLP4 264
CNSTF4 1112014848
ASGNF4
LABELV $1085
line 2409
;2409:		}
LABELV $1083
line 2422
;2410:#endif //CTF
;2411:#ifdef MISSIONPACK
;2412:		else if (gametype == GT_1FCTF) {
;2413:			if (Bot1FCTFCarryingFlag(bs))
;2414:				range = 50;
;2415:		}
;2416:		else if (gametype == GT_HARVESTER) {
;2417:			if (BotHarvesterCarryingCubes(bs))
;2418:				range = 80;
;2419:		}
;2420:#endif
;2421:		//
;2422:		if (BotNearbyGoal(bs, bs->tfl, &goal, range)) {
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
ARGP4
ADDRLP4 344
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 264
INDIRF4
ARGF4
ADDRLP4 348
ADDRGP4 BotNearbyGoal
CALLI4
ASGNI4
ADDRLP4 348
INDIRI4
CNSTI4 0
EQI4 $1087
line 2423
;2423:			trap_BotResetLastAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetLastAvoidReach
CALLV
pop
line 2425
;2424:			//time the bot gets to pick up the nearby goal item
;2425:			bs->nbg_time = FloatTime() + range / 100 + 1;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
ADDRGP4 floattime
INDIRF4
ADDRLP4 264
INDIRF4
CNSTF4 1120403456
DIVF4
ADDF4
CNSTF4 1065353216
ADDF4
ASGNF4
line 2426
;2426:			AIEnter_Battle_NBG(bs, "battle retreat: nbg");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1089
ARGP4
ADDRGP4 AIEnter_Battle_NBG
CALLV
pop
line 2427
;2427:			return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1037
JUMPV
LABELV $1087
line 2429
;2428:		}
;2429:	}
LABELV $1081
line 2431
;2430:	//initialize the movement state
;2431:	BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2433
;2432:	//move towards the goal
;2433:	trap_BotMoveToGoal(&moveresult, bs->ms, &goal, bs->tfl);
ADDRLP4 0
ARGP4
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 344
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 2435
;2434:	//if the movement failed
;2435:	if (moveresult.failure) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1090
line 2437
;2436:		//reset the avoid reach, otherwise bot is stuck in current area
;2437:		trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 2439
;2438:		//BotAI_Print(PRT_MESSAGE, "movement failure %d\n", moveresult.traveltype);
;2439:		bs->ltg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6068
ADDP4
CNSTF4 0
ASGNF4
line 2440
;2440:	}
LABELV $1090
line 2442
;2441:	//
;2442:	BotAIBlocked(bs, &moveresult, qfalse);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 2444
;2443:	//choose the best weapon to fight with
;2444:	BotChooseWeapon(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotChooseWeapon
CALLV
pop
line 2446
;2445:	//if the view is fixed for the movement
;2446:	if (moveresult.flags & (MOVERESULT_MOVEMENTVIEW|MOVERESULT_SWIMVIEW)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 0
EQI4 $1092
line 2447
;2447:		VectorCopy(moveresult.ideal_viewangles, bs->ideal_viewangles);
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ADDRLP4 0+40
INDIRB
ASGNB 12
line 2448
;2448:	}
ADDRGP4 $1093
JUMPV
LABELV $1092
line 2449
;2449:	else if (!(moveresult.flags & MOVERESULT_MOVEMENTVIEWSET)
ADDRLP4 348
CNSTI4 0
ASGNI4
ADDRLP4 0+20
INDIRI4
CNSTI4 8
BANDI4
ADDRLP4 348
INDIRI4
NEI4 $1096
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 32
BANDI4
ADDRLP4 348
INDIRI4
NEI4 $1096
line 2450
;2450:				&& !(bs->flags & BFL_IDEALVIEWSET) ) {
line 2451
;2451:		attack_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ATTACK_SKILL, 0, 1);
ADDRFP4 0
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
ADDRLP4 352
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 268
ADDRLP4 352
INDIRF4
ASGNF4
line 2453
;2452:		//if the bot is skilled anough
;2453:		if (attack_skill > 0.3) {
ADDRLP4 268
INDIRF4
CNSTF4 1050253722
LEF4 $1099
line 2454
;2454:			BotAimAtEnemy(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotAimAtEnemy
CALLV
pop
line 2455
;2455:		}
ADDRGP4 $1100
JUMPV
LABELV $1099
line 2456
;2456:		else {
line 2457
;2457:			if (trap_BotMovementViewTarget(bs->ms, &goal, bs->tfl, 300, target)) {
ADDRLP4 356
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 356
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 356
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTF4 1133903872
ARGF4
ADDRLP4 252
ARGP4
ADDRLP4 360
ADDRGP4 trap_BotMovementViewTarget
CALLI4
ASGNI4
ADDRLP4 360
INDIRI4
CNSTI4 0
EQI4 $1101
line 2458
;2458:				VectorSubtract(target, bs->origin, dir);
ADDRLP4 364
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 272
ADDRLP4 252
INDIRF4
ADDRLP4 364
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 272+4
ADDRLP4 252+4
INDIRF4
ADDRLP4 364
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 272+8
ADDRLP4 252+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2459
;2459:				vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 272
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2460
;2460:			}
ADDRGP4 $1102
JUMPV
LABELV $1101
line 2461
;2461:			else {
line 2462
;2462:				vectoangles(moveresult.movedir, bs->ideal_viewangles);
ADDRLP4 0+28
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2463
;2463:			}
LABELV $1102
line 2464
;2464:			bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 364
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 364
INDIRP4
CNSTF4 1056964608
ADDRLP4 364
INDIRP4
INDIRF4
MULF4
ASGNF4
line 2465
;2465:		}
LABELV $1100
line 2466
;2466:	}
LABELV $1096
LABELV $1093
line 2468
;2467:	//if the weapon is used for the bot movement
;2468:	if (moveresult.flags & MOVERESULT_MOVEMENTWEAPON) bs->weaponnum = moveresult.weapon;
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $1108
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0+24
INDIRI4
ASGNI4
LABELV $1108
line 2470
;2469:	//attack the enemy if possible
;2470:	BotCheckAttack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckAttack
CALLV
pop
line 2472
;2471:	//
;2472:	return qtrue;
CNSTI4 1
RETI4
LABELV $1037
endproc AINode_Battle_Retreat 368 20
export AIEnter_Battle_NBG
proc AIEnter_Battle_NBG 0 16
line 2480
;2473:}
;2474:
;2475:/*
;2476:==================
;2477:AIEnter_Battle_NBG
;2478:==================
;2479:*/
;2480:void AIEnter_Battle_NBG(bot_state_t *bs, char *s) {
line 2481
;2481:	BotRecordNodeSwitch(bs, "battle NBG", "", s);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1113
ARGP4
ADDRGP4 $64
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 BotRecordNodeSwitch
CALLV
pop
line 2482
;2482:	bs->ainode = AINode_Battle_NBG;
ADDRFP4 0
INDIRP4
CNSTI4 4900
ADDP4
ADDRGP4 AINode_Battle_NBG
ASGNP4
line 2483
;2483:}
LABELV $1112
endproc AIEnter_Battle_NBG 0 16
export AINode_Battle_NBG
proc AINode_Battle_NBG 356 20
line 2490
;2484:
;2485:/*
;2486:==================
;2487:AINode_Battle_NBG
;2488:==================
;2489:*/
;2490:int AINode_Battle_NBG(bot_state_t *bs) {
line 2498
;2491:	int areanum;
;2492:	bot_goal_t goal;
;2493:	aas_entityinfo_t entinfo;
;2494:	bot_moveresult_t moveresult;
;2495:	float attack_skill;
;2496:	vec3_t target, dir;
;2497:
;2498:	if (BotIsObserver(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 280
ADDRGP4 BotIsObserver
CALLI4
ASGNI4
ADDRLP4 280
INDIRI4
CNSTI4 0
EQI4 $1115
line 2499
;2499:		AIEnter_Observer(bs, "battle nbg: observer");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1117
ARGP4
ADDRGP4 AIEnter_Observer
CALLV
pop
line 2500
;2500:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1114
JUMPV
LABELV $1115
line 2503
;2501:	}
;2502:	//if in the intermission
;2503:	if (BotIntermission(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 284
ADDRGP4 BotIntermission
CALLI4
ASGNI4
ADDRLP4 284
INDIRI4
CNSTI4 0
EQI4 $1118
line 2504
;2504:		AIEnter_Intermission(bs, "battle nbg: intermission");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1120
ARGP4
ADDRGP4 AIEnter_Intermission
CALLV
pop
line 2505
;2505:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1114
JUMPV
LABELV $1118
line 2508
;2506:	}
;2507:	//respawn if dead
;2508:	if (BotIsDead(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 288
ADDRGP4 BotIsDead
CALLI4
ASGNI4
ADDRLP4 288
INDIRI4
CNSTI4 0
EQI4 $1121
line 2509
;2509:		AIEnter_Respawn(bs, "battle nbg: bot dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1123
ARGP4
ADDRGP4 AIEnter_Respawn
CALLV
pop
line 2510
;2510:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1114
JUMPV
LABELV $1121
line 2513
;2511:	}
;2512:	//if no enemy
;2513:	if (bs->enemy < 0) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 0
GEI4 $1124
line 2514
;2514:		AIEnter_Seek_NBG(bs, "battle nbg: no enemy");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1126
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 2515
;2515:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1114
JUMPV
LABELV $1124
line 2518
;2516:	}
;2517:	//
;2518:	BotEntityInfo(bs->enemy, &entinfo);
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 108
ARGP4
ADDRGP4 BotEntityInfo
CALLV
pop
line 2519
;2519:	if (EntityIsDead(&entinfo)) {
ADDRLP4 108
ARGP4
ADDRLP4 292
ADDRGP4 EntityIsDead
CALLI4
ASGNI4
ADDRLP4 292
INDIRI4
CNSTI4 0
EQI4 $1127
line 2520
;2520:		AIEnter_Seek_NBG(bs, "battle nbg: enemy dead");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1129
ARGP4
ADDRGP4 AIEnter_Seek_NBG
CALLV
pop
line 2521
;2521:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1114
JUMPV
LABELV $1127
line 2524
;2522:	}
;2523:	//
;2524:	bs->tfl = TFL_DEFAULT;
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
CNSTI4 18616254
ASGNI4
line 2525
;2525:	if (bot_grapple.integer) bs->tfl |= TFL_GRAPPLEHOOK;
ADDRGP4 bot_grapple+12
INDIRI4
CNSTI4 0
EQI4 $1130
ADDRLP4 296
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 296
INDIRP4
ADDRLP4 296
INDIRP4
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
LABELV $1130
line 2527
;2526:	//if in lava or slime the bot should be able to get out
;2527:	if (BotInLavaOrSlime(bs)) bs->tfl |= TFL_LAVA|TFL_SLIME;
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 300
ADDRGP4 BotInLavaOrSlime
CALLI4
ASGNI4
ADDRLP4 300
INDIRI4
CNSTI4 0
EQI4 $1133
ADDRLP4 304
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 304
INDIRP4
ADDRLP4 304
INDIRP4
INDIRI4
CNSTI4 6291456
BORI4
ASGNI4
LABELV $1133
line 2529
;2528:	//
;2529:	if (BotCanAndWantsToRocketJump(bs)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 308
ADDRGP4 BotCanAndWantsToRocketJump
CALLI4
ASGNI4
ADDRLP4 308
INDIRI4
CNSTI4 0
EQI4 $1135
line 2530
;2530:		bs->tfl |= TFL_ROCKETJUMP;
ADDRLP4 312
ADDRFP4 0
INDIRP4
CNSTI4 5976
ADDP4
ASGNP4
ADDRLP4 312
INDIRP4
ADDRLP4 312
INDIRP4
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
line 2531
;2531:	}
LABELV $1135
line 2533
;2532:	//map specific code
;2533:	BotMapScripts(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotMapScripts
CALLV
pop
line 2535
;2534:	//update the last time the enemy was visible
;2535:	if (BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy)) {
ADDRLP4 312
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 312
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ARGI4
ADDRLP4 312
INDIRP4
CNSTI4 4936
ADDP4
ARGP4
ADDRLP4 312
INDIRP4
CNSTI4 6564
ADDP4
ARGP4
CNSTF4 1135869952
ARGF4
ADDRLP4 312
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRLP4 316
ADDRGP4 BotEntityVisible
CALLF4
ASGNF4
ADDRLP4 316
INDIRF4
CNSTF4 0
EQF4 $1137
line 2536
;2536:		bs->enemyvisible_time = FloatTime();
ADDRFP4 0
INDIRP4
CNSTI4 6088
ADDP4
ADDRGP4 floattime
INDIRF4
ASGNF4
line 2537
;2537:		VectorCopy(entinfo.origin, target);
ADDRLP4 252
ADDRLP4 108+24
INDIRB
ASGNB 12
line 2539
;2538:		// if not a player enemy
;2539:		if (bs->enemy >= MAX_CLIENTS) {
ADDRFP4 0
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
CNSTI4 64
LTI4 $1140
line 2547
;2540:#ifdef MISSIONPACK
;2541:			// if attacking an obelisk
;2542:			if ( bs->enemy == redobelisk.entitynum ||
;2543:				bs->enemy == blueobelisk.entitynum ) {
;2544:				target[2] += 16;
;2545:			}
;2546:#endif
;2547:		}
LABELV $1140
line 2549
;2548:		//update the reachability area and origin if possible
;2549:		areanum = BotPointAreaNum(target);
ADDRLP4 252
ARGP4
ADDRLP4 320
ADDRGP4 BotPointAreaNum
CALLI4
ASGNI4
ADDRLP4 248
ADDRLP4 320
INDIRI4
ASGNI4
line 2550
;2550:		if (areanum && trap_AAS_AreaReachability(areanum)) {
ADDRLP4 324
ADDRLP4 248
INDIRI4
ASGNI4
ADDRLP4 324
INDIRI4
CNSTI4 0
EQI4 $1142
ADDRLP4 324
INDIRI4
ARGI4
ADDRLP4 328
ADDRGP4 trap_AAS_AreaReachability
CALLI4
ASGNI4
ADDRLP4 328
INDIRI4
CNSTI4 0
EQI4 $1142
line 2551
;2551:			VectorCopy(target, bs->lastenemyorigin);
ADDRFP4 0
INDIRP4
CNSTI4 6548
ADDP4
ADDRLP4 252
INDIRB
ASGNB 12
line 2552
;2552:			bs->lastenemyareanum = areanum;
ADDRFP4 0
INDIRP4
CNSTI4 6544
ADDP4
ADDRLP4 248
INDIRI4
ASGNI4
line 2553
;2553:		}
LABELV $1142
line 2554
;2554:	}
LABELV $1137
line 2556
;2555:	//if the bot has no goal or touches the current goal
;2556:	if (!trap_BotGetTopGoal(bs->gs, &goal)) {
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 320
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 320
INDIRI4
CNSTI4 0
NEI4 $1144
line 2557
;2557:		bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
line 2558
;2558:	}
ADDRGP4 $1145
JUMPV
LABELV $1144
line 2559
;2559:	else if (BotReachedGoal(bs, &goal)) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 52
ARGP4
ADDRLP4 324
ADDRGP4 BotReachedGoal
CALLI4
ASGNI4
ADDRLP4 324
INDIRI4
CNSTI4 0
EQI4 $1146
line 2560
;2560:		bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
line 2561
;2561:	}
LABELV $1146
LABELV $1145
line 2563
;2562:	//
;2563:	if (bs->nbg_time < FloatTime()) {
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
INDIRF4
ADDRGP4 floattime
INDIRF4
GEF4 $1148
line 2565
;2564:		//pop the current goal from the stack
;2565:		trap_BotPopGoal(bs->gs);
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotPopGoal
CALLV
pop
line 2567
;2566:		//if the bot still has a goal
;2567:		if (trap_BotGetTopGoal(bs->gs, &goal))
ADDRFP4 0
INDIRP4
CNSTI4 6528
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 328
ADDRGP4 trap_BotGetTopGoal
CALLI4
ASGNI4
ADDRLP4 328
INDIRI4
CNSTI4 0
EQI4 $1150
line 2568
;2568:			AIEnter_Battle_Retreat(bs, "battle nbg: time out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1152
ARGP4
ADDRGP4 AIEnter_Battle_Retreat
CALLV
pop
ADDRGP4 $1151
JUMPV
LABELV $1150
line 2570
;2569:		else
;2570:			AIEnter_Battle_Fight(bs, "battle nbg: time out");
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 $1152
ARGP4
ADDRGP4 AIEnter_Battle_Fight
CALLV
pop
LABELV $1151
line 2572
;2571:		//
;2572:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $1114
JUMPV
LABELV $1148
line 2575
;2573:	}
;2574:	//initialize the movement state
;2575:	BotSetupForMovement(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotSetupForMovement
CALLV
pop
line 2577
;2576:	//move towards the goal
;2577:	trap_BotMoveToGoal(&moveresult, bs->ms, &goal, bs->tfl);
ADDRLP4 0
ARGP4
ADDRLP4 328
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 328
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 328
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotMoveToGoal
CALLV
pop
line 2579
;2578:	//if the movement failed
;2579:	if (moveresult.failure) {
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $1153
line 2581
;2580:		//reset the avoid reach, otherwise bot is stuck in current area
;2581:		trap_BotResetAvoidReach(bs->ms);
ADDRFP4 0
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRGP4 trap_BotResetAvoidReach
CALLV
pop
line 2583
;2582:		//BotAI_Print(PRT_MESSAGE, "movement failure %d\n", moveresult.traveltype);
;2583:		bs->nbg_time = 0;
ADDRFP4 0
INDIRP4
CNSTI4 6072
ADDP4
CNSTF4 0
ASGNF4
line 2584
;2584:	}
LABELV $1153
line 2586
;2585:	//
;2586:	BotAIBlocked(bs, &moveresult, qfalse);
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BotAIBlocked
CALLV
pop
line 2588
;2587:	//update the attack inventory values
;2588:	BotUpdateBattleInventory(bs, bs->enemy);
ADDRLP4 332
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 332
INDIRP4
ARGP4
ADDRLP4 332
INDIRP4
CNSTI4 6540
ADDP4
INDIRI4
ARGI4
ADDRGP4 BotUpdateBattleInventory
CALLV
pop
line 2590
;2589:	//choose the best weapon to fight with
;2590:	BotChooseWeapon(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotChooseWeapon
CALLV
pop
line 2592
;2591:	//if the view is fixed for the movement
;2592:	if (moveresult.flags & (MOVERESULT_MOVEMENTVIEW|MOVERESULT_SWIMVIEW)) {
ADDRLP4 0+20
INDIRI4
CNSTI4 3
BANDI4
CNSTI4 0
EQI4 $1155
line 2593
;2593:		VectorCopy(moveresult.ideal_viewangles, bs->ideal_viewangles);
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ADDRLP4 0+40
INDIRB
ASGNB 12
line 2594
;2594:	}
ADDRGP4 $1156
JUMPV
LABELV $1155
line 2595
;2595:	else if (!(moveresult.flags & MOVERESULT_MOVEMENTVIEWSET)
ADDRLP4 336
CNSTI4 0
ASGNI4
ADDRLP4 0+20
INDIRI4
CNSTI4 8
BANDI4
ADDRLP4 336
INDIRI4
NEI4 $1159
ADDRFP4 0
INDIRP4
CNSTI4 5980
ADDP4
INDIRI4
CNSTI4 32
BANDI4
ADDRLP4 336
INDIRI4
NEI4 $1159
line 2596
;2596:				&& !(bs->flags & BFL_IDEALVIEWSET)) {
line 2597
;2597:		attack_skill = trap_Characteristic_BFloat(bs->character, CHARACTERISTIC_ATTACK_SKILL, 0, 1);
ADDRFP4 0
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
ADDRLP4 340
ADDRGP4 trap_Characteristic_BFloat
CALLF4
ASGNF4
ADDRLP4 264
ADDRLP4 340
INDIRF4
ASGNF4
line 2599
;2598:		//if the bot is skilled anough and the enemy is visible
;2599:		if (attack_skill > 0.3) {
ADDRLP4 264
INDIRF4
CNSTF4 1050253722
LEF4 $1162
line 2601
;2600:			//&& BotEntityVisible(bs->entitynum, bs->eye, bs->viewangles, 360, bs->enemy)
;2601:			BotAimAtEnemy(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotAimAtEnemy
CALLV
pop
line 2602
;2602:		}
ADDRGP4 $1163
JUMPV
LABELV $1162
line 2603
;2603:		else {
line 2604
;2604:			if (trap_BotMovementViewTarget(bs->ms, &goal, bs->tfl, 300, target)) {
ADDRLP4 344
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 344
INDIRP4
CNSTI4 6524
ADDP4
INDIRI4
ARGI4
ADDRLP4 52
ARGP4
ADDRLP4 344
INDIRP4
CNSTI4 5976
ADDP4
INDIRI4
ARGI4
CNSTF4 1133903872
ARGF4
ADDRLP4 252
ARGP4
ADDRLP4 348
ADDRGP4 trap_BotMovementViewTarget
CALLI4
ASGNI4
ADDRLP4 348
INDIRI4
CNSTI4 0
EQI4 $1164
line 2605
;2605:				VectorSubtract(target, bs->origin, dir);
ADDRLP4 352
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 268
ADDRLP4 252
INDIRF4
ADDRLP4 352
INDIRP4
CNSTI4 4908
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 268+4
ADDRLP4 252+4
INDIRF4
ADDRLP4 352
INDIRP4
CNSTI4 4912
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 268+8
ADDRLP4 252+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 4916
ADDP4
INDIRF4
SUBF4
ASGNF4
line 2606
;2606:				vectoangles(dir, bs->ideal_viewangles);
ADDRLP4 268
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2607
;2607:			}
ADDRGP4 $1165
JUMPV
LABELV $1164
line 2608
;2608:			else {
line 2609
;2609:				vectoangles(moveresult.movedir, bs->ideal_viewangles);
ADDRLP4 0+28
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 6576
ADDP4
ARGP4
ADDRGP4 vectoangles
CALLV
pop
line 2610
;2610:			}
LABELV $1165
line 2611
;2611:			bs->ideal_viewangles[2] *= 0.5;
ADDRLP4 352
ADDRFP4 0
INDIRP4
CNSTI4 6584
ADDP4
ASGNP4
ADDRLP4 352
INDIRP4
CNSTF4 1056964608
ADDRLP4 352
INDIRP4
INDIRF4
MULF4
ASGNF4
line 2612
;2612:		}
LABELV $1163
line 2613
;2613:	}
LABELV $1159
LABELV $1156
line 2615
;2614:	//if the weapon is used for the bot movement
;2615:	if (moveresult.flags & MOVERESULT_MOVEMENTWEAPON) bs->weaponnum = moveresult.weapon;
ADDRLP4 0+20
INDIRI4
CNSTI4 16
BANDI4
CNSTI4 0
EQI4 $1171
ADDRFP4 0
INDIRP4
CNSTI4 6560
ADDP4
ADDRLP4 0+24
INDIRI4
ASGNI4
LABELV $1171
line 2617
;2616:	//attack the enemy if possible
;2617:	BotCheckAttack(bs);
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BotCheckAttack
CALLV
pop
line 2619
;2618:	//
;2619:	return qtrue;
CNSTI4 1
RETI4
LABELV $1114
endproc AINode_Battle_NBG 356 20
bss
export nodeswitch
align 1
LABELV nodeswitch
skip 7344
export numnodeswitches
align 4
LABELV numnodeswitches
skip 4
import BotVoiceChatOnly
import BotVoiceChat
import BotSetTeamMateTaskPreference
import BotGetTeamMateTaskPreference
import BotTeamAI
import AIEnter_Seek_Camp
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
import ctf_blueflag
import ctf_redflag
import bot_challenge
import bot_testrchat
import bot_nochat
import bot_fastchat
import bot_rocketjump
import bot_grapple
import maxclients
import gametype
import BotMapScripts
import BotPointAreaNum
import ClientOnSameTeamFromName
import ClientFromName
import stristr
import BotFindWayPoint
import BotCreateWayPoint
import BotAlternateRoute
import BotGetAlternateRouteGoal
import BotCTFRetreatGoals
import BotCTFSeekGoals
import BotRememberLastOrderedTask
import BotCTFCarryingFlag
import BotOppositeTeam
import BotTeam
import BotClearActivateGoalStack
import BotPopFromActivateGoalStack
import BotEnableActivateGoalAreas
import BotAIPredictObstacles
import BotAIBlocked
import BotCheckAttack
import BotAimAtEnemy
import BotEntityVisible
import BotRoamGoal
import BotFindEnemy
import InFieldOfVision
import BotVisibleTeamMatesAndEnemies
import BotEnemyFlagCarrierVisible
import BotTeamFlagCarrierVisible
import BotTeamFlagCarrier
import TeamPlayIsOn
import BotSameTeam
import BotAttackMove
import BotWantsToCamp
import BotHasPersistantPowerupAndWeapon
import BotCanAndWantsToRocketJump
import BotWantsToHelp
import BotWantsToChase
import BotWantsToRetreat
import BotFeelingBad
import BotAggression
import BotTeamGoals
import BotSetLastOrderedTask
import BotSynonymContext
import ClientSkin
import EasyClientName
import ClientName
import BotSetTeamStatus
import BotSetUserInfo
import EntityIsShooting
import EntityIsInvisible
import EntityIsDead
import BotInLavaOrSlime
import BotIntermission
import BotIsObserver
import BotIsDead
import BotBattleUseItems
import BotUpdateBattleInventory
import BotUpdateInventory
import BotSetupForMovement
import BotChooseWeapon
import BotFreeWaypoints
import BotDeathmatchAI
import BotShutdownDeathmatchAI
import BotSetupDeathmatchAI
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
LABELV $1152
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $1129
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $1126
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $1123
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $1120
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $1117
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $1113
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 78
byte 1 66
byte 1 71
byte 1 0
align 1
LABELV $1089
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 0
align 1
LABELV $1080
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 119
byte 1 97
byte 1 121
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $1077
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 97
byte 1 110
byte 1 111
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $1072
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 108
byte 1 111
byte 1 115
byte 1 116
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $1062
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 110
byte 1 116
byte 1 115
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 0
align 1
LABELV $1052
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $1049
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $1046
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $1043
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $1040
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $1036
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $1034
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 110
byte 1 116
byte 1 115
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $1008
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 0
align 1
LABELV $1003
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $978
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 97
byte 1 0
align 1
LABELV $975
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 98
byte 1 101
byte 1 116
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $970
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $967
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $964
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $961
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $957
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 115
byte 1 101
byte 1 0
align 1
LABELV $955
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 110
byte 1 116
byte 1 115
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 114
byte 1 101
byte 1 116
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $941
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 115
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $936
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 104
byte 1 105
byte 1 116
byte 1 32
byte 1 115
byte 1 111
byte 1 109
byte 1 101
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $931
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 32
byte 1 100
byte 1 101
byte 1 99
byte 1 114
byte 1 101
byte 1 97
byte 1 115
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $921
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 118
byte 1 105
byte 1 115
byte 1 105
byte 1 98
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $914
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $905
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $900
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $897
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $894
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $889
byte 1 98
byte 1 97
byte 1 116
byte 1 116
byte 1 108
byte 1 101
byte 1 32
byte 1 102
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $848
byte 1 108
byte 1 116
byte 1 103
byte 1 32
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 58
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 0
align 1
LABELV $835
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 108
byte 1 116
byte 1 103
byte 1 58
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $819
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 108
byte 1 116
byte 1 103
byte 1 58
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $816
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 108
byte 1 116
byte 1 103
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $813
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 108
byte 1 116
byte 1 103
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $810
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 108
byte 1 116
byte 1 103
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $806
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 76
byte 1 84
byte 1 71
byte 1 0
align 1
LABELV $801
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $764
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $750
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $747
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $744
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 110
byte 1 98
byte 1 103
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $740
byte 1 110
byte 1 111
byte 1 32
byte 1 103
byte 1 111
byte 1 97
byte 1 108
byte 1 0
align 1
LABELV $739
byte 1 115
byte 1 101
byte 1 101
byte 1 107
byte 1 32
byte 1 78
byte 1 66
byte 1 71
byte 1 0
align 1
LABELV $734
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $683
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $672
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $649
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 103
byte 1 111
byte 1 97
byte 1 108
byte 1 0
align 1
LABELV $641
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 32
byte 1 100
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $638
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $635
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $631
byte 1 97
byte 1 99
byte 1 116
byte 1 105
byte 1 118
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $537
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 58
byte 1 32
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $529
byte 1 114
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 0
align 1
LABELV $527
byte 1 115
byte 1 116
byte 1 97
byte 1 110
byte 1 100
byte 1 58
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 0
align 1
LABELV $524
byte 1 115
byte 1 116
byte 1 97
byte 1 110
byte 1 100
byte 1 58
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 101
byte 1 110
byte 1 101
byte 1 109
byte 1 121
byte 1 0
align 1
LABELV $514
byte 1 115
byte 1 116
byte 1 97
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $512
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 58
byte 1 32
byte 1 108
byte 1 101
byte 1 102
byte 1 116
byte 1 32
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $508
byte 1 111
byte 1 98
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $506
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 58
byte 1 32
byte 1 99
byte 1 104
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $498
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 111
byte 1 110
byte 1 0
align 1
LABELV $467
byte 1 102
byte 1 111
byte 1 108
byte 1 108
byte 1 111
byte 1 119
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $464
byte 1 108
byte 1 101
byte 1 97
byte 1 100
byte 1 95
byte 1 115
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $446
byte 1 111
byte 1 110
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $445
byte 1 114
byte 1 101
byte 1 116
byte 1 117
byte 1 114
byte 1 110
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $411
byte 1 111
byte 1 110
byte 1 103
byte 1 101
byte 1 116
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $410
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $401
byte 1 112
byte 1 97
byte 1 116
byte 1 114
byte 1 111
byte 1 108
byte 1 95
byte 1 115
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $388
byte 1 112
byte 1 97
byte 1 116
byte 1 114
byte 1 111
byte 1 108
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $387
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 0
align 1
LABELV $354
byte 1 105
byte 1 110
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
LABELV $353
byte 1 99
byte 1 97
byte 1 109
byte 1 112
byte 1 95
byte 1 97
byte 1 114
byte 1 114
byte 1 105
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $344
byte 1 99
byte 1 97
byte 1 109
byte 1 112
byte 1 95
byte 1 115
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $339
byte 1 99
byte 1 97
byte 1 109
byte 1 112
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $331
byte 1 103
byte 1 101
byte 1 116
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 103
byte 1 111
byte 1 116
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $328
byte 1 103
byte 1 101
byte 1 116
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 110
byte 1 111
byte 1 116
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 101
byte 1 0
align 1
LABELV $323
byte 1 103
byte 1 101
byte 1 116
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $316
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 95
byte 1 100
byte 1 111
byte 1 110
byte 1 101
byte 1 0
align 1
LABELV $313
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $302
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 100
byte 1 95
byte 1 115
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $299
byte 1 111
byte 1 110
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 115
byte 1 101
byte 1 0
align 1
LABELV $298
byte 1 100
byte 1 101
byte 1 102
byte 1 101
byte 1 110
byte 1 100
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $289
byte 1 97
byte 1 99
byte 1 99
byte 1 111
byte 1 109
byte 1 112
byte 1 97
byte 1 110
byte 1 121
byte 1 95
byte 1 99
byte 1 97
byte 1 110
byte 1 110
byte 1 111
byte 1 116
byte 1 102
byte 1 105
byte 1 110
byte 1 100
byte 1 0
align 1
LABELV $280
byte 1 66
byte 1 111
byte 1 116
byte 1 76
byte 1 111
byte 1 110
byte 1 103
byte 1 84
byte 1 101
byte 1 114
byte 1 109
byte 1 71
byte 1 111
byte 1 97
byte 1 108
byte 1 58
byte 1 32
byte 1 103
byte 1 111
byte 1 32
byte 1 102
byte 1 111
byte 1 114
byte 1 32
byte 1 97
byte 1 105
byte 1 114
byte 1 0
align 1
LABELV $258
byte 1 97
byte 1 99
byte 1 99
byte 1 111
byte 1 109
byte 1 112
byte 1 97
byte 1 110
byte 1 121
byte 1 95
byte 1 97
byte 1 114
byte 1 114
byte 1 105
byte 1 118
byte 1 101
byte 1 0
align 1
LABELV $165
byte 1 97
byte 1 99
byte 1 99
byte 1 111
byte 1 109
byte 1 112
byte 1 97
byte 1 110
byte 1 121
byte 1 95
byte 1 115
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $162
byte 1 97
byte 1 99
byte 1 99
byte 1 111
byte 1 109
byte 1 112
byte 1 97
byte 1 110
byte 1 121
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $136
byte 1 121
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $135
byte 1 104
byte 1 101
byte 1 108
byte 1 112
byte 1 95
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 0
align 1
LABELV $66
byte 1 37
byte 1 115
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 50
byte 1 46
byte 1 49
byte 1 102
byte 1 32
byte 1 101
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 101
byte 1 100
byte 1 32
byte 1 37
byte 1 115
byte 1 58
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
byte 1 115
byte 1 10
byte 1 0
align 1
LABELV $64
byte 1 0
align 1
LABELV $59
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
