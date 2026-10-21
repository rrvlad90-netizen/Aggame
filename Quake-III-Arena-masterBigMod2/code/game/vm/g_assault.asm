code
proc AssaultPointName 4 0
file "../g_assault.c"
line 48
;1:#include "g_local.h"
;2:
;3:#define ASSAULT_MIN_POINT_DISTANCE 512.0f
;4:#define ASSAULT_MARKER_MODEL "models/powerups/teleporter/tele_exit.md3"
;5:#define ASSAULT_MAX_POINTS 3
;6:#define ASSAULT_DEFAULT_POINTS 2
;7:
;8:typedef enum {
;9:	ASSAULT_SETUP,
;10:	ASSAULT_ROUND_RED,
;11:	ASSAULT_ROUND_BLUE,
;12:	ASSAULT_FINISHED
;13:} assaultPhase_t;
;14:
;15:typedef struct {
;16:	int completedPoints;
;17:	int progress;
;18:	int elapsedTime;
;19:} assaultResult_t;
;20:
;21:typedef struct {
;22:	assaultPhase_t phase;
;23:
;24:	vec3_t points[ASSAULT_MAX_POINTS];
;25:	int pointAreas[ASSAULT_MAX_POINTS];
;26:	qboolean pointSet[ASSAULT_MAX_POINTS];
;27:	gentity_t *markers[ASSAULT_MAX_POINTS];
;28:
;29:	int pointCount;
;30:
;31:	int editorClient;
;32:	int activeStage;
;33:	int captureProgress;
;34:	int announcedQuarter;
;35:
;36:	int roundStartTime;
;37:	int roundLimit;
;38:	int lastFrameTime;
;39:
;40:	team_t attackingTeam;
;41:
;42:	assaultResult_t redResult;
;43:	assaultResult_t blueResult;
;44:} assaultState_t;
;45:
;46:static assaultState_t assault;
;47:
;48:static char *AssaultPointName( int point ) {
line 49
;49:	switch( point ) {
ADDRLP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $58
ADDRLP4 0
INDIRI4
CNSTI4 1
EQI4 $60
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $62
ADDRGP4 $56
JUMPV
LABELV $58
line 51
;50:	case 0:
;51:		return "A";
ADDRGP4 $59
RETP4
ADDRGP4 $55
JUMPV
LABELV $60
line 53
;52:	case 1:
;53:		return "B";
ADDRGP4 $61
RETP4
ADDRGP4 $55
JUMPV
LABELV $62
line 55
;54:	case 2:
;55:		return "C";
ADDRGP4 $63
RETP4
ADDRGP4 $55
JUMPV
LABELV $56
line 57
;56:	default:
;57:		return "?";
ADDRGP4 $64
RETP4
LABELV $55
endproc AssaultPointName 4 0
export G_AssaultEnabled
proc G_AssaultEnabled 4 0
line 61
;58:	}
;59:}
;60:
;61:qboolean G_AssaultEnabled( void ) {
line 62
;62:	return g_assaultMode.integer &&
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 0
EQI4 $69
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $69
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $70
JUMPV
LABELV $69
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $70
ADDRLP4 0
INDIRI4
RETI4
LABELV $65
endproc G_AssaultEnabled 4 0
proc AssaultActualPoint 0 0
line 66
;63:		g_gametype.integer == GT_TEAM;
;64:}
;65:
;66:static int AssaultActualPoint( void ) {
line 67
;67:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+108
INDIRI4
CNSTI4 1
NEI4 $72
line 68
;68:		return assault.activeStage;
ADDRGP4 assault+84
INDIRI4
RETI4
ADDRGP4 $71
JUMPV
LABELV $72
line 71
;69:	}
;70:
;71:	return assault.pointCount - 1 - assault.activeStage;
ADDRGP4 assault+76
INDIRI4
CNSTI4 1
SUBI4
ADDRGP4 assault+84
INDIRI4
SUBI4
RETI4
LABELV $71
endproc AssaultActualPoint 0 0
proc AssaultSetMarkerLight 0 0
line 80
;72:}
;73:
;74:static void AssaultSetMarkerLight(
;75:	gentity_t *marker,
;76:	int red,
;77:	int green,
;78:	int blue,
;79:	int intensity
;80:) {
line 81
;81:	if( !marker ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $79
line 82
;82:		return;
ADDRGP4 $78
JUMPV
LABELV $79
line 85
;83:	}
;84:
;85:	marker->s.constantLight =
ADDRFP4 0
INDIRP4
CNSTI4 152
ADDP4
ADDRFP4 4
INDIRI4
ADDRFP4 8
INDIRI4
CNSTI4 8
LSHI4
BORI4
ADDRFP4 12
INDIRI4
CNSTI4 16
LSHI4
BORI4
ADDRFP4 16
INDIRI4
CNSTI4 24
LSHI4
BORI4
ASGNI4
line 90
;86:		red |
;87:		(green << 8) |
;88:		(blue << 16) |
;89:		(intensity << 24);
;90:}
LABELV $78
endproc AssaultSetMarkerLight 0 0
proc AssaultUpdateMarkers 16 20
line 92
;91:
;92:static void AssaultUpdateMarkers( void ) {
line 96
;93:	int activePoint;
;94:	int i;
;95:
;96:	activePoint = -1;
ADDRLP4 4
CNSTI4 -1
ASGNI4
line 98
;97:
;98:	if( assault.phase == ASSAULT_ROUND_RED ||
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $84
ADDRLP4 8
INDIRI4
CNSTI4 2
NEI4 $82
LABELV $84
line 99
;99:		assault.phase == ASSAULT_ROUND_BLUE ) {
line 100
;100:		activePoint = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ASGNI4
line 101
;101:	}
LABELV $82
line 103
;102:
;103:	for( i = 0; i < ASSAULT_MAX_POINTS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $85
line 104
;104:		if( !assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $89
line 105
;105:			continue;
ADDRGP4 $86
JUMPV
LABELV $89
line 108
;106:		}
;107:
;108:		if( i == activePoint ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $92
line 109
;109:			AssaultSetMarkerLight(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ARGP4
ADDRLP4 12
CNSTI4 32
ASGNI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTI4 255
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTI4 100
ARGI4
ADDRGP4 AssaultSetMarkerLight
CALLV
pop
line 112
;110:				assault.markers[i], 32, 255, 32, 100
;111:			);
;112:			continue;
ADDRGP4 $86
JUMPV
LABELV $92
line 115
;113:		}
;114:
;115:		if( i == 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $95
line 116
;116:			AssaultSetMarkerLight(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ARGP4
CNSTI4 255
ARGI4
CNSTI4 48
ARGI4
CNSTI4 32
ARGI4
CNSTI4 55
ARGI4
ADDRGP4 AssaultSetMarkerLight
CALLV
pop
line 119
;117:				assault.markers[i], 255, 48, 32, 55
;118:			);
;119:		}
ADDRGP4 $96
JUMPV
LABELV $95
line 120
;120:		else if( i == 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $98
line 121
;121:			AssaultSetMarkerLight(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ARGP4
CNSTI4 48
ARGI4
CNSTI4 96
ARGI4
CNSTI4 255
ARGI4
CNSTI4 55
ARGI4
ADDRGP4 AssaultSetMarkerLight
CALLV
pop
line 124
;122:				assault.markers[i], 48, 96, 255, 55
;123:			);
;124:		}
ADDRGP4 $99
JUMPV
LABELV $98
line 125
;125:		else {
line 126
;126:			AssaultSetMarkerLight(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ARGP4
CNSTI4 255
ARGI4
CNSTI4 192
ARGI4
CNSTI4 32
ARGI4
CNSTI4 55
ARGI4
ADDRGP4 AssaultSetMarkerLight
CALLV
pop
line 129
;127:				assault.markers[i], 255, 192, 32, 55
;128:			);
;129:		}
LABELV $99
LABELV $96
line 130
;130:	}
LABELV $86
line 103
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $85
line 131
;131:}
LABELV $81
endproc AssaultUpdateMarkers 16 20
proc AssaultCreateOrMoveMarker 16 8
line 133
;132:
;133:static void AssaultCreateOrMoveMarker( int point ) {
line 136
;134:	gentity_t *marker;
;135:
;136:	marker = assault.markers[point];
ADDRLP4 0
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ASGNP4
line 138
;137:
;138:	if( !marker ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $104
line 139
;139:		marker = G_Spawn();
ADDRLP4 4
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 140
;140:		assault.markers[point] = marker;
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 142
;141:
;142:		marker->classname = "assault_marker";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $107
ASGNP4
line 143
;143:		marker->s.eType = ET_GENERAL;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 0
ASGNI4
line 144
;144:		marker->s.modelindex = G_ModelIndex( ASSAULT_MARKER_MODEL );
ADDRGP4 $108
ARGP4
ADDRLP4 8
ADDRGP4 G_ModelIndex
CALLI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 160
ADDP4
ADDRLP4 8
INDIRI4
ASGNI4
line 145
;145:		marker->s.apos.trType = TR_LINEAR;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 146
;146:		marker->s.apos.trTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 147
;147:		VectorSet(
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
CNSTF4 0
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
CNSTF4 1110704128
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 80
ADDP4
CNSTF4 0
ASGNF4
line 154
;148:			marker->s.apos.trDelta,
;149:			0.0f,
;150:			45.0f,
;151:			0.0f
;152:		);
;153:
;154:		marker->r.svFlags |= SVF_BROADCAST;
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 424
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
line 155
;155:		marker->r.contents = 0;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 156
;156:	}
LABELV $104
line 158
;157:
;158:	G_SetOrigin( marker, assault.points[point] );
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 12
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ARGP4
ADDRGP4 G_SetOrigin
CALLV
pop
line 159
;159:	trap_LinkEntity( marker );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 161
;160:
;161:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 162
;162:}
LABELV $102
endproc AssaultCreateOrMoveMarker 16 8
proc AssaultPointAreaNum 120 20
line 164
;163:
;164:static int AssaultPointAreaNum( vec3_t origin ) {
line 172
;165:	int area;
;166:	int areas[16];
;167:	int numAreas;
;168:	int i;
;169:	vec3_t start;
;170:	vec3_t end;
;171:
;172:	area = trap_AAS_PointAreaNum( origin );
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
line 174
;173:
;174:	if( area &&
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $112
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
EQI4 $112
line 175
;175:		trap_AAS_AreaReachability(area) ) {
line 176
;176:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $111
JUMPV
LABELV $112
line 179
;177:	}
;178:
;179:	VectorCopy( origin, start );
ADDRLP4 76
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 180
;180:	VectorCopy( origin, end );
ADDRLP4 88
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 182
;181:
;182:	start[2] -= 32.0f;
ADDRLP4 76+8
ADDRLP4 76+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 183
;183:	end[2] += 64.0f;
ADDRLP4 88+8
ADDRLP4 88+8
INDIRF4
CNSTF4 1115684864
ADDF4
ASGNF4
line 185
;184:
;185:	numAreas = trap_AAS_TraceAreas(
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
line 193
;186:		start,
;187:		end,
;188:		areas,
;189:		NULL,
;190:		16
;191:	);
;192:
;193:	for( i = 0; i < numAreas; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $119
JUMPV
LABELV $116
line 194
;194:		if( trap_AAS_AreaReachability(areas[i]) ) {
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
EQI4 $120
line 195
;195:			return areas[i];
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
RETI4
ADDRGP4 $111
JUMPV
LABELV $120
line 197
;196:		}
;197:	}
LABELV $117
line 193
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $119
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $116
line 199
;198:
;199:	return 0;
CNSTI4 0
RETI4
LABELV $111
endproc AssaultPointAreaNum 120 20
proc AssaultTracePlacement 112 28
line 205
;200:}
;201:
;202:static qboolean AssaultTracePlacement(
;203:	gentity_t *ent,
;204:	vec3_t result
;205:) {
line 211
;206:	trace_t trace;
;207:	vec3_t start;
;208:	vec3_t end;
;209:	vec3_t forward;
;210:
;211:	VectorCopy( ent->client->ps.origin, start );
ADDRLP4 56
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
INDIRB
ASGNB 12
line 213
;212:
;213:	if( ent->client->ps.viewheight ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $123
line 214
;214:		start[2] += ent->client->ps.viewheight;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CVIF4 4
ADDF4
ASGNF4
line 215
;215:	}
ADDRGP4 $124
JUMPV
LABELV $123
line 216
;216:	else {
line 217
;217:		start[2] += 26;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1104150528
ADDF4
ASGNF4
line 218
;218:	}
LABELV $124
line 220
;219:
;220:	AngleVectors(
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 152
ADDP4
ARGP4
ADDRLP4 80
ARGP4
ADDRLP4 92
CNSTP4 0
ASGNP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRLP4 92
INDIRP4
ARGP4
ADDRGP4 AngleVectors
CALLV
pop
line 227
;221:		ent->client->ps.viewangles,
;222:		forward,
;223:		NULL,
;224:		NULL
;225:	);
;226:
;227:	VectorMA( start, 8192.0f, forward, end );
ADDRLP4 96
CNSTF4 1174405120
ASGNF4
ADDRLP4 68
ADDRLP4 56
INDIRF4
ADDRLP4 96
INDIRF4
ADDRLP4 80
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68+4
ADDRLP4 56+4
INDIRF4
ADDRLP4 96
INDIRF4
ADDRLP4 80+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1174405120
ADDRLP4 80+8
INDIRF4
MULF4
ADDF4
ASGNF4
line 229
;228:
;229:	trap_Trace(
ADDRLP4 0
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 100
CNSTP4 0
ASGNP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 100
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 239
;230:		&trace,
;231:		start,
;232:		NULL,
;233:		NULL,
;234:		end,
;235:		ent - g_entities,
;236:		MASK_SOLID
;237:	);
;238:
;239:	if( trace.startsolid ||
ADDRLP4 104
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $140
ADDRLP4 0
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $140
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $140
ADDRLP4 0+44
INDIRI4
CNSTI4 4
BANDI4
ADDRLP4 104
INDIRI4
EQI4 $133
LABELV $140
line 242
;240:		trace.allsolid ||
;241:		trace.fraction == 1.0f ||
;242:		(trace.surfaceFlags & SURF_SKY) ) {
line 243
;243:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $122
JUMPV
LABELV $133
line 246
;244:	}
;245:
;246:	VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 247
;247:	result[2] += 8.0f;
ADDRLP4 108
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 108
INDIRP4
ADDRLP4 108
INDIRP4
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 249
;248:
;249:	return qtrue;
CNSTI4 1
RETI4
LABELV $122
endproc AssaultTracePlacement 112 28
proc AssaultClaimEditor 8 8
line 252
;250:}
;251:
;252:static qboolean AssaultClaimEditor( gentity_t *ent ) {
line 255
;253:	int clientNum;
;254:
;255:	clientNum = ent - g_entities;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ASGNI4
line 257
;256:
;257:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $143
line 258
;258:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $142
JUMPV
LABELV $143
line 261
;259:	}
;260:
;261:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $145
line 262
;262:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $147
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 266
;263:			clientNum,
;264:			"print \"Point placement requires spectator mode.\n\""
;265:		);
;266:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $142
JUMPV
LABELV $145
line 269
;267:	}
;268:
;269:	if( assault.editorClient == -1 ) {
ADDRGP4 assault+80
INDIRI4
CNSTI4 -1
NEI4 $148
line 270
;270:		assault.editorClient = clientNum;
ADDRGP4 assault+80
ADDRLP4 0
INDIRI4
ASGNI4
line 272
;271:
;272:		trap_SendServerCommand(
ADDRGP4 $152
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 512
ADDP4
ARGP4
ADDRLP4 4
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 279
;273:			-1,
;274:			va(
;275:				"print \"%s is placing Assault points.\n\"",
;276:				ent->client->pers.netname
;277:			)
;278:		);
;279:	}
LABELV $148
line 281
;280:
;281:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+80
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $153
line 282
;282:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $156
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 286
;283:			clientNum,
;284:			"print \"Another player is placing the points.\n\""
;285:		);
;286:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $142
JUMPV
LABELV $153
line 289
;287:	}
;288:
;289:	return qtrue;
CNSTI4 1
RETI4
LABELV $142
endproc AssaultClaimEditor 8 8
proc AssaultPlacePoint 44 8
line 292
;290:}
;291:
;292:static void AssaultPlacePoint( gentity_t *ent, int point ) {
line 298
;293:	vec3_t origin;
;294:	int otherPoint;
;295:	int area;
;296:	int clientNum;
;297:
;298:	clientNum = ent - g_entities;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ASGNI4
line 300
;299:
;300:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $158
line 301
;301:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $160
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 305
;302:			clientNum,
;303:			"print \"The match has already started.\n\""
;304:		);
;305:		return;
ADDRGP4 $157
JUMPV
LABELV $158
line 308
;306:	}
;307:
;308:	if( point < 0 || point >= assault.pointCount ) {
ADDRLP4 24
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
LTI4 $164
ADDRLP4 24
INDIRI4
ADDRGP4 assault+76
INDIRI4
LTI4 $161
LABELV $164
line 309
;309:		trap_SendServerCommand(
ADDRGP4 $165
ARGP4
ADDRGP4 assault+76
INDIRI4
ARGI4
ADDRLP4 28
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 316
;310:			clientNum,
;311:			va(
;312:				"print \"Point number must be from 1 to %i.\n\"",
;313:				assault.pointCount
;314:			)
;315:		);
;316:		return;
ADDRGP4 $157
JUMPV
LABELV $161
line 319
;317:	}
;318:
;319:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+80
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $167
line 320
;320:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $170
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 324
;321:			clientNum,
;322:			"print \"Use /assault_edit first.\n\""
;323:		);
;324:		return;
ADDRGP4 $157
JUMPV
LABELV $167
line 327
;325:	}
;326:
;327:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $171
line 328
;328:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $147
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 332
;329:			clientNum,
;330:			"print \"Point placement requires spectator mode.\n\""
;331:		);
;332:		return;
ADDRGP4 $157
JUMPV
LABELV $171
line 335
;333:	}
;334:
;335:	if( !AssaultTracePlacement(ent, origin) ) {
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 28
ADDRGP4 AssaultTracePlacement
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $173
line 336
;336:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $175
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 340
;337:			clientNum,
;338:			"print \"Unable to place a point there.\n\""
;339:		);
;340:		return;
ADDRGP4 $157
JUMPV
LABELV $173
line 343
;341:	}
;342:
;343:	for( otherPoint = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $179
JUMPV
LABELV $176
line 345
;344:		otherPoint < assault.pointCount;
;345:		otherPoint++ ) {
line 346
;346:		if( otherPoint == point ||
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $184
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $181
LABELV $184
line 347
;347:			!assault.pointSet[otherPoint] ) {
line 348
;348:			continue;
ADDRGP4 $177
JUMPV
LABELV $181
line 351
;349:		}
;350:
;351:		if( DistanceSquared(
ADDRLP4 4
ARGP4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ARGP4
ADDRLP4 36
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 1216348160
GEF4 $185
line 356
;352:			origin,
;353:			assault.points[otherPoint]
;354:		) <
;355:			ASSAULT_MIN_POINT_DISTANCE *
;356:			ASSAULT_MIN_POINT_DISTANCE ) {
line 357
;357:			trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $188
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 361
;358:				clientNum,
;359:				"print \"The points are too close together.\n\""
;360:			);
;361:			return;
ADDRGP4 $157
JUMPV
LABELV $185
line 363
;362:		}
;363:	}
LABELV $177
line 345
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $179
line 344
ADDRLP4 0
INDIRI4
ADDRGP4 assault+76
INDIRI4
LTI4 $176
line 365
;364:
;365:	area = AssaultPointAreaNum( origin );
ADDRLP4 4
ARGP4
ADDRLP4 32
ADDRGP4 AssaultPointAreaNum
CALLI4
ASGNI4
ADDRLP4 20
ADDRLP4 32
INDIRI4
ASGNI4
line 367
;366:
;367:	VectorCopy( origin, assault.points[point] );
CNSTI4 12
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 368
;368:	assault.pointAreas[point] = area;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 369
;369:	assault.pointSet[point] = qtrue;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 1
ASGNI4
line 371
;370:
;371:	AssaultCreateOrMoveMarker( point );
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 373
;372:
;373:	trap_SendServerCommand(
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $192
ARGP4
ADDRLP4 36
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 40
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 381
;374:		-1,
;375:		va(
;376:			"cp \"Assault point %s placed\"",
;377:			AssaultPointName(point)
;378:		)
;379:	);
;380:
;381:	if( !area ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $193
line 382
;382:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $195
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 386
;383:			clientNum,
;384:			"print \"Warning: the point has no AAS area; bots may not reach it.\n\""
;385:		);
;386:	}
LABELV $193
line 387
;387:}
LABELV $157
endproc AssaultPlacePoint 44 8
proc AssaultRespawnTeams 16 4
line 389
;388:
;389:static void AssaultRespawnTeams( void ) {
line 393
;390:	int i;
;391:	gentity_t *ent;
;392:
;393:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $200
JUMPV
LABELV $197
line 394
;394:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 396
;395:
;396:		if( !ent->client ||
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $204
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $202
LABELV $204
line 397
;397:			ent->client->pers.connected != CON_CONNECTED ) {
line 398
;398:			continue;
ADDRGP4 $198
JUMPV
LABELV $202
line 401
;399:		}
;400:
;401:		if( ent->client->sess.sessionTeam != TEAM_RED &&
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 1
EQI4 $205
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $205
line 402
;402:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 403
;403:			continue;
ADDRGP4 $198
JUMPV
LABELV $205
line 406
;404:		}
;405:
;406:		ClientSpawn( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 ClientSpawn
CALLV
pop
line 407
;407:	}
LABELV $198
line 393
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $200
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $197
line 408
;408:}
LABELV $196
endproc AssaultRespawnTeams 16 4
proc AssaultStartRound 24 12
line 410
;409:
;410:static void AssaultStartRound( team_t attackingTeam ) {
line 413
;411:	int normalLimit;
;412:
;413:	assault.attackingTeam = attackingTeam;
ADDRGP4 assault+108
ADDRFP4 0
INDIRI4
ASGNI4
line 414
;414:	assault.activeStage = 0;
ADDRGP4 assault+84
CNSTI4 0
ASGNI4
line 415
;415:	assault.captureProgress = 0;
ADDRGP4 assault+88
CNSTI4 0
ASGNI4
line 416
;416:	assault.announcedQuarter = 0;
ADDRGP4 assault+92
CNSTI4 0
ASGNI4
line 417
;417:	assault.roundStartTime = level.time;
ADDRGP4 assault+96
ADDRGP4 level+32
INDIRI4
ASGNI4
line 418
;418:	assault.lastFrameTime = level.time;
ADDRGP4 assault+104
ADDRGP4 level+32
INDIRI4
ASGNI4
line 420
;419:
;420:	normalLimit = g_assaultRoundTime.integer * 1000;
ADDRLP4 0
CNSTI4 1000
ADDRGP4 g_assaultRoundTime+12
INDIRI4
MULI4
ASGNI4
line 422
;421:
;422:	if( normalLimit < 30000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 30000
GEI4 $217
line 423
;423:		normalLimit = 30000;
ADDRLP4 0
CNSTI4 30000
ASGNI4
line 424
;424:	}
LABELV $217
line 426
;425:
;426:	assault.roundLimit = normalLimit;
ADDRGP4 assault+100
ADDRLP4 0
INDIRI4
ASGNI4
line 428
;427:
;428:	if( attackingTeam == TEAM_RED ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $220
line 429
;429:		assault.phase = ASSAULT_ROUND_RED;
ADDRGP4 assault
CNSTI4 1
ASGNI4
line 430
;430:	}
ADDRGP4 $221
JUMPV
LABELV $220
line 431
;431:	else {
line 432
;432:		assault.phase = ASSAULT_ROUND_BLUE;
ADDRGP4 assault
CNSTI4 2
ASGNI4
line 437
;433:
;434:		/*
;435:		 * If Red completed the route, Blue must beat Red's time.
;436:		 */
;437:		if( assault.redResult.completedPoints == assault.pointCount &&
ADDRGP4 assault+112
INDIRI4
ADDRGP4 assault+76
INDIRI4
NEI4 $222
ADDRGP4 assault+112+8
INDIRI4
ADDRGP4 assault+100
INDIRI4
GEI4 $222
line 439
;438:			assault.redResult.elapsedTime <
;439:			assault.roundLimit ) {
line 440
;440:			assault.roundLimit =
ADDRGP4 assault+100
ADDRGP4 assault+112+8
INDIRI4
ASGNI4
line 442
;441:				assault.redResult.elapsedTime;
;442:		}
LABELV $222
line 443
;443:	}
LABELV $221
line 445
;444:
;445:	level.teamScores[TEAM_RED] = 0;
ADDRGP4 level+44+4
CNSTI4 0
ASGNI4
line 446
;446:	level.teamScores[TEAM_BLUE] = 0;
ADDRGP4 level+44+8
CNSTI4 0
ASGNI4
line 448
;447:
;448:	trap_SetConfigstring( CS_SCORES1, "0" );
CNSTI4 6
ARGI4
ADDRGP4 $236
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 449
;449:	trap_SetConfigstring( CS_SCORES2, "0" );
CNSTI4 7
ARGI4
ADDRGP4 $236
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 451
;450:
;451:	level.startTime = level.time;
ADDRGP4 level+40
ADDRGP4 level+32
INDIRI4
ASGNI4
line 452
;452:	trap_SetConfigstring(
ADDRGP4 $239
ARGP4
ADDRGP4 level+40
INDIRI4
ARGI4
ADDRLP4 4
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 21
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 457
;453:		CS_LEVEL_START_TIME,
;454:		va("%i", level.startTime)
;455:	);
;456:
;457:	AssaultRespawnTeams();
ADDRGP4 AssaultRespawnTeams
CALLV
pop
line 458
;458:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 460
;459:
;460:	trap_SendServerCommand(
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $241
ARGP4
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $245
ADDRLP4 8
ADDRGP4 $242
ASGNP4
ADDRGP4 $246
JUMPV
LABELV $245
ADDRLP4 8
ADDRGP4 $243
ASGNP4
LABELV $246
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 468
;461:		-1,
;462:		va(
;463:			"cp \"%s attacks point %s\"",
;464:			attackingTeam == TEAM_RED ? "Red" : "Blue",
;465:			AssaultPointName(AssaultActualPoint())
;466:		)
;467:	);
;468:}
LABELV $207
endproc AssaultStartRound 24 12
proc AssaultFinishMatch 20 8
line 470
;469:
;470:static void AssaultFinishMatch( void ) {
line 473
;471:	int winner;
;472:
;473:	winner = TEAM_FREE;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 475
;474:
;475:	if( assault.redResult.completedPoints >
ADDRGP4 assault+112
INDIRI4
ADDRGP4 assault+124
INDIRI4
LEI4 $248
line 476
;476:		assault.blueResult.completedPoints ) {
line 477
;477:		winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 478
;478:	}
ADDRGP4 $249
JUMPV
LABELV $248
line 479
;479:	else if( assault.blueResult.completedPoints >
ADDRGP4 assault+124
INDIRI4
ADDRGP4 assault+112
INDIRI4
LEI4 $252
line 480
;480:		assault.redResult.completedPoints ) {
line 481
;481:		winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 482
;482:	}
ADDRGP4 $253
JUMPV
LABELV $252
line 483
;483:	else if( assault.redResult.completedPoints == assault.pointCount ) {
ADDRGP4 assault+112
INDIRI4
ADDRGP4 assault+76
INDIRI4
NEI4 $256
line 484
;484:		if( assault.redResult.elapsedTime <
ADDRGP4 assault+112+8
INDIRI4
ADDRGP4 assault+124+8
INDIRI4
GEI4 $260
line 485
;485:			assault.blueResult.elapsedTime ) {
line 486
;486:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 487
;487:		}
ADDRGP4 $257
JUMPV
LABELV $260
line 488
;488:		else if( assault.blueResult.elapsedTime <
ADDRGP4 assault+124+8
INDIRI4
ADDRGP4 assault+112+8
INDIRI4
GEI4 $257
line 489
;489:			assault.redResult.elapsedTime ) {
line 490
;490:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 491
;491:		}
line 492
;492:	}
ADDRGP4 $257
JUMPV
LABELV $256
line 493
;493:	else {
line 494
;494:		if( assault.redResult.progress >
ADDRGP4 assault+112+4
INDIRI4
ADDRGP4 assault+124+4
INDIRI4
LEI4 $272
line 495
;495:			assault.blueResult.progress ) {
line 496
;496:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 497
;497:		}
ADDRGP4 $273
JUMPV
LABELV $272
line 498
;498:		else if( assault.blueResult.progress >
ADDRGP4 assault+124+4
INDIRI4
ADDRGP4 assault+112+4
INDIRI4
LEI4 $278
line 499
;499:			assault.redResult.progress ) {
line 500
;500:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 501
;501:		}
LABELV $278
LABELV $273
line 502
;502:	}
LABELV $257
LABELV $253
LABELV $249
line 504
;503:
;504:	assault.phase = ASSAULT_FINISHED;
ADDRGP4 assault
CNSTI4 3
ASGNI4
line 506
;505:
;506:	level.teamScores[TEAM_RED] =
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $287
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $288
JUMPV
LABELV $287
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $288
ADDRGP4 level+44+4
ADDRLP4 4
INDIRI4
ASGNI4
line 508
;507:		winner == TEAM_RED ? 1 : 0;
;508:	level.teamScores[TEAM_BLUE] =
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $292
ADDRLP4 8
CNSTI4 1
ASGNI4
ADDRGP4 $293
JUMPV
LABELV $292
ADDRLP4 8
CNSTI4 0
ASGNI4
LABELV $293
ADDRGP4 level+44+8
ADDRLP4 8
INDIRI4
ASGNI4
line 511
;509:		winner == TEAM_BLUE ? 1 : 0;
;510:
;511:	trap_SetConfigstring(
ADDRGP4 $239
ARGP4
ADDRGP4 level+44+4
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 6
ARGI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 515
;512:		CS_SCORES1,
;513:		va("%i", level.teamScores[TEAM_RED])
;514:	);
;515:	trap_SetConfigstring(
ADDRGP4 $239
ARGP4
ADDRGP4 level+44+8
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 7
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 520
;516:		CS_SCORES2,
;517:		va("%i", level.teamScores[TEAM_BLUE])
;518:	);
;519:
;520:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 522
;521:
;522:	if( winner == TEAM_RED ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $298
line 523
;523:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $300
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 527
;524:			-1,
;525:			"cp \"Red team wins Assault\""
;526:		);
;527:		LogExit( "Red team won Assault." );
ADDRGP4 $301
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 528
;528:	}
ADDRGP4 $299
JUMPV
LABELV $298
line 529
;529:	else if( winner == TEAM_BLUE ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $302
line 530
;530:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $304
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 534
;531:			-1,
;532:			"cp \"Blue team wins Assault\""
;533:		);
;534:		LogExit( "Blue team won Assault." );
ADDRGP4 $305
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 535
;535:	}
ADDRGP4 $303
JUMPV
LABELV $302
line 536
;536:	else {
line 537
;537:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $306
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 541
;538:			-1,
;539:			"cp \"Assault ended in a draw\""
;540:		);
;541:		LogExit( "Assault draw." );
ADDRGP4 $307
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 542
;542:	}
LABELV $303
LABELV $299
line 543
;543:}
LABELV $247
endproc AssaultFinishMatch 20 8
proc AssaultStoreRoundResult 4 4
line 545
;544:
;545:static void AssaultStoreRoundResult( qboolean completed ) {
line 548
;546:	assaultResult_t *result;
;547:
;548:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+108
INDIRI4
CNSTI4 1
NEI4 $309
line 549
;549:		result = &assault.redResult;
ADDRLP4 0
ADDRGP4 assault+112
ASGNP4
line 550
;550:	}
ADDRGP4 $310
JUMPV
LABELV $309
line 551
;551:	else {
line 552
;552:		result = &assault.blueResult;
ADDRLP4 0
ADDRGP4 assault+124
ASGNP4
line 553
;553:	}
LABELV $310
line 555
;554:
;555:	if( completed ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
EQI4 $314
line 556
;556:		result->completedPoints = assault.pointCount;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+76
INDIRI4
ASGNI4
line 557
;557:		result->progress =
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 1000
ADDRGP4 g_assaultHoldTime+12
INDIRI4
MULI4
ASGNI4
line 559
;558:			g_assaultHoldTime.integer * 1000;
;559:		result->elapsedTime =
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+96
INDIRI4
SUBI4
ASGNI4
line 561
;560:			level.time - assault.roundStartTime;
;561:	}
ADDRGP4 $315
JUMPV
LABELV $314
line 562
;562:	else {
line 563
;563:		result->completedPoints = assault.activeStage;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+84
INDIRI4
ASGNI4
line 564
;564:		result->progress = assault.captureProgress;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 assault+88
INDIRI4
ASGNI4
line 565
;565:		result->elapsedTime = assault.roundLimit;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 assault+100
INDIRI4
ASGNI4
line 566
;566:	}
LABELV $315
line 568
;567:
;568:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+108
INDIRI4
CNSTI4 1
NEI4 $323
line 569
;569:		AssaultStartRound( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 570
;570:	}
ADDRGP4 $324
JUMPV
LABELV $323
line 571
;571:	else {
line 572
;572:		AssaultFinishMatch();
ADDRGP4 AssaultFinishMatch
CALLV
pop
line 573
;573:	}
LABELV $324
line 574
;574:}
LABELV $308
endproc AssaultStoreRoundResult 4 4
proc AssaultCompletePoint 32 8
line 576
;575:
;576:static void AssaultCompletePoint( void ) {
line 579
;577:	int completedPoint;
;578:
;579:	completedPoint = AssaultActualPoint();
ADDRLP4 4
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 581
;580:
;581:	trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $327
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 589
;582:		-1,
;583:		va(
;584:			"cp \"Point %s captured\"",
;585:			AssaultPointName(completedPoint)
;586:		)
;587:	);
;588:
;589:	assault.activeStage++;
ADDRLP4 16
ADDRGP4 assault+84
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 590
;590:	assault.captureProgress = 0;
ADDRGP4 assault+88
CNSTI4 0
ASGNI4
line 591
;591:	assault.announcedQuarter = 0;
ADDRGP4 assault+92
CNSTI4 0
ASGNI4
line 593
;592:
;593:	if( assault.activeStage >= assault.pointCount ) {
ADDRGP4 assault+84
INDIRI4
ADDRGP4 assault+76
INDIRI4
LTI4 $331
line 594
;594:		AssaultStoreRoundResult( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 595
;595:		return;
ADDRGP4 $326
JUMPV
LABELV $331
line 598
;596:	}
;597:
;598:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 600
;599:
;600:	trap_SendServerCommand(
ADDRLP4 20
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
ARGI4
ADDRLP4 24
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $335
ARGP4
ADDRLP4 24
INDIRP4
ARGP4
ADDRLP4 28
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 28
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 607
;601:		-1,
;602:		va(
;603:			"cp \"Attack point %s\"",
;604:			AssaultPointName(AssaultActualPoint())
;605:		)
;606:	);
;607:}
LABELV $326
endproc AssaultCompletePoint 32 8
proc AssaultCountPlayers 28 8
line 613
;608:
;609:static void AssaultCountPlayers(
;610:	int point,
;611:	int *attackers,
;612:	int *defenders
;613:) {
line 618
;614:	int i;
;615:	float radiusSquared;
;616:	gentity_t *ent;
;617:
;618:	*attackers = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 619
;619:	*defenders = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
line 621
;620:
;621:	radiusSquared =
ADDRLP4 8
ADDRGP4 g_assaultRadius+8
INDIRF4
ADDRGP4 g_assaultRadius+8
INDIRF4
MULF4
ASGNF4
line 625
;622:		g_assaultRadius.value *
;623:		g_assaultRadius.value;
;624:
;625:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $342
JUMPV
LABELV $339
line 626
;626:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 628
;627:
;628:		if( !ent->client ||
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $347
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $347
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $344
LABELV $347
line 630
;629:			ent->client->pers.connected != CON_CONNECTED ||
;630:			ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
line 631
;631:			continue;
ADDRGP4 $340
JUMPV
LABELV $344
line 634
;632:		}
;633:
;634:		if( ent->client->sess.sessionTeam != TEAM_RED &&
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 1
EQI4 $348
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $348
line 635
;635:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 636
;636:			continue;
ADDRGP4 $340
JUMPV
LABELV $348
line 639
;637:		}
;638:
;639:		if( DistanceSquared(
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 20
ADDP4
ARGP4
CNSTI4 12
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ARGP4
ADDRLP4 20
ADDRGP4 DistanceSquared
CALLF4
ASGNF4
ADDRLP4 20
INDIRF4
ADDRLP4 8
INDIRF4
LEF4 $350
line 642
;640:			ent->client->ps.origin,
;641:			assault.points[point]
;642:		) > radiusSquared ) {
line 643
;643:			continue;
ADDRGP4 $340
JUMPV
LABELV $350
line 646
;644:		}
;645:
;646:		if( ent->client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ADDRGP4 assault+108
INDIRI4
NEI4 $353
line 647
;647:			assault.attackingTeam ) {
line 648
;648:			(*attackers)++;
ADDRLP4 24
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 649
;649:		}
ADDRGP4 $354
JUMPV
LABELV $353
line 650
;650:		else {
line 651
;651:			(*defenders)++;
ADDRLP4 24
ADDRFP4 8
INDIRP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 652
;652:		}
LABELV $354
line 653
;653:	}
LABELV $340
line 625
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $342
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $339
line 654
;654:}
LABELV $336
endproc AssaultCountPlayers 28 8
proc AssaultStartMatch 12 12
line 656
;655:
;656:static void AssaultStartMatch( gentity_t *ent ) {
line 657
;657:	if( assault.editorClient != ent - g_entities ) {
ADDRGP4 assault+80
INDIRI4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
EQI4 $357
line 658
;658:		trap_SendServerCommand(
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ARGI4
ADDRGP4 $360
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 662
;659:			ent - g_entities,
;660:			"print \"Only the point editor can start the match.\n\""
;661:		);
;662:		return;
ADDRGP4 $356
JUMPV
LABELV $357
line 665
;663:	}
;664:
;665:	{
line 668
;666:		int i;
;667:
;668:		for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $364
JUMPV
LABELV $361
line 669
;669:			if( !assault.pointSet[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $366
line 670
;670:				trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $369
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 677
;671:					ent - g_entities,
;672:					va(
;673:						"print \"Assault: points are invalid. Point %s is missing.\n\"",
;674:						AssaultPointName(i)
;675:					)
;676:				);
;677:				return;
ADDRGP4 $356
JUMPV
LABELV $366
line 679
;678:			}
;679:		}
LABELV $362
line 668
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $364
ADDRLP4 0
INDIRI4
ADDRGP4 assault+76
INDIRI4
LTI4 $361
line 680
;680:	}
line 682
;681:
;682:	if( TeamCount(-1, TEAM_RED) < 1 ||
CNSTI4 -1
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 0
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 1
LTI4 $372
CNSTI4 -1
ARGI4
CNSTI4 2
ARGI4
ADDRLP4 4
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 1
GEI4 $370
LABELV $372
line 683
;683:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 684
;684:		trap_SendServerCommand(
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ARGI4
ADDRGP4 $373
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 688
;685:			ent - g_entities,
;686:			"print \"Both teams need at least one player.\n\""
;687:		);
;688:		return;
ADDRGP4 $356
JUMPV
LABELV $370
line 691
;689:	}
;690:
;691:	level.warmupTime = 0;
ADDRGP4 level+16
CNSTI4 0
ASGNI4
line 692
;692:	trap_SetConfigstring( CS_WARMUP, "0" );
CNSTI4 5
ARGI4
ADDRGP4 $236
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 694
;693:
;694:	memset(
ADDRGP4 assault+112
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 699
;695:		&assault.redResult,
;696:		0,
;697:		sizeof(assault.redResult)
;698:	);
;699:	memset(
ADDRGP4 assault+124
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 705
;700:		&assault.blueResult,
;701:		0,
;702:		sizeof(assault.blueResult)
;703:	);
;704:
;705:	AssaultStartRound( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 706
;706:}
LABELV $356
endproc AssaultStartMatch 12 12
proc AssaultSetPointCount 24 12
line 712
;707:
;708:
;709:static void AssaultSetPointCount(
;710:	gentity_t *ent,
;711:	int pointCount
;712:) {
line 716
;713:	int i;
;714:	int clientNum;
;715:
;716:	clientNum = ent - g_entities;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ASGNI4
line 718
;717:
;718:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $380
line 719
;719:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $160
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 723
;720:			clientNum,
;721:			"print \"The match has already started.\n\""
;722:		);
;723:		return;
ADDRGP4 $379
JUMPV
LABELV $380
line 726
;724:	}
;725:
;726:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $382
line 727
;727:		return;
ADDRGP4 $379
JUMPV
LABELV $382
line 730
;728:	}
;729:
;730:	if( pointCount < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $386
ADDRLP4 8
INDIRI4
CNSTI4 3
LEI4 $384
LABELV $386
line 731
;731:		pointCount > ASSAULT_MAX_POINTS ) {
line 732
;732:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $387
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 736
;733:			clientNum,
;734:			"print \"Usage: /assault_set 1|2|3\n\""
;735:		);
;736:		return;
ADDRGP4 $379
JUMPV
LABELV $384
line 739
;737:	}
;738:
;739:	if( assault.editorClient >= 0 &&
ADDRGP4 assault+80
INDIRI4
CNSTI4 0
LTI4 $388
ADDRGP4 assault+80
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $388
line 740
;740:		assault.editorClient != clientNum ) {
line 741
;741:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $392
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 745
;742:			clientNum,
;743:			"print \"Another player is editing Assault.\n\""
;744:		);
;745:		return;
ADDRGP4 $379
JUMPV
LABELV $388
line 748
;746:	}
;747:
;748:	for( i = pointCount;
ADDRLP4 0
ADDRFP4 4
INDIRI4
ASGNI4
ADDRGP4 $396
JUMPV
LABELV $393
line 750
;749:		i < ASSAULT_MAX_POINTS;
;750:		i++ ) {
line 751
;751:		if( assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $397
line 752
;752:			G_FreeEntity( assault.markers[i] );
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 753
;753:			assault.markers[i] = NULL;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
CNSTP4 0
ASGNP4
line 754
;754:		}
LABELV $397
line 756
;755:
;756:		assault.pointSet[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 0
ASGNI4
line 757
;757:		assault.pointAreas[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
CNSTI4 0
ASGNI4
line 758
;758:		VectorClear( assault.points[i] );
ADDRLP4 12
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 16
CNSTF4 0
ASGNF4
ADDRLP4 12
INDIRI4
ADDRGP4 assault+4+8
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 12
INDIRI4
ADDRGP4 assault+4+4
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 12
INDIRI4
ADDRGP4 assault+4
ADDP4
ADDRLP4 16
INDIRF4
ASGNF4
line 759
;759:	}
LABELV $394
line 750
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $396
line 749
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $393
line 761
;760:
;761:	assault.pointCount = pointCount;
ADDRGP4 assault+76
ADDRFP4 4
INDIRI4
ASGNI4
line 763
;762:
;763:	trap_SendServerCommand(
ADDRGP4 $410
ARGP4
ADDRLP4 16
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
ARGI4
ADDRLP4 16
INDIRI4
CNSTI4 1
NEI4 $414
ADDRLP4 12
ADDRGP4 $411
ASGNP4
ADDRGP4 $415
JUMPV
LABELV $414
ADDRLP4 12
ADDRGP4 $412
ASGNP4
LABELV $415
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 20
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 771
;764:		-1,
;765:		va(
;766:			"print \"Assault will use %i point%s.\n\"",
;767:			pointCount,
;768:			pointCount == 1 ? "" : "s"
;769:		)
;770:	);
;771:}
LABELV $379
endproc AssaultSetPointCount 24 12
export G_AssaultClientCommand
proc G_AssaultClientCommand 1048 12
line 776
;772:
;773:qboolean G_AssaultClientCommand(
;774:	gentity_t *ent,
;775:	const char *cmd
;776:) {
line 780
;777:	char arg[MAX_TOKEN_CHARS];
;778:	int value;
;779:
;780:	if( !G_AssaultEnabled() ) {
ADDRLP4 1028
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 1028
INDIRI4
CNSTI4 0
NEI4 $417
line 781
;781:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $416
JUMPV
LABELV $417
line 784
;782:	}
;783:
;784:	if( !Q_stricmp(cmd, "assault_set") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $421
ARGP4
ADDRLP4 1032
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 0
NEI4 $419
line 785
;785:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 786
;786:		AssaultSetPointCount( ent, atoi(arg) );
ADDRLP4 0
ARGP4
ADDRLP4 1036
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1036
INDIRI4
ARGI4
ADDRGP4 AssaultSetPointCount
CALLV
pop
line 787
;787:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $416
JUMPV
LABELV $419
line 790
;788:	}
;789:
;790:	if( !Q_stricmp(cmd, "assault_edit") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $424
ARGP4
ADDRLP4 1036
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1036
INDIRI4
CNSTI4 0
NEI4 $422
line 791
;791:		if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $425
line 792
;792:			trap_SendServerCommand(
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 808
DIVI4
ARGI4
ADDRGP4 $160
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 796
;793:				ent - g_entities,
;794:				"print \"The match has already started.\n\""
;795:			);
;796:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $416
JUMPV
LABELV $425
line 799
;797:		}
;798:
;799:		AssaultClaimEditor( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultClaimEditor
CALLI4
pop
line 800
;800:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $416
JUMPV
LABELV $422
line 803
;801:	}
;802:
;803:	if( !Q_stricmp(cmd, "assault_place") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $429
ARGP4
ADDRLP4 1040
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
NEI4 $427
line 804
;804:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 805
;805:		value = atoi(arg) - 1;
ADDRLP4 0
ARGP4
ADDRLP4 1044
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 1024
ADDRLP4 1044
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
line 806
;806:		AssaultPlacePoint( ent, value );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1024
INDIRI4
ARGI4
ADDRGP4 AssaultPlacePoint
CALLV
pop
line 807
;807:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $416
JUMPV
LABELV $427
line 810
;808:	}
;809:
;810:	if( !Q_stricmp(cmd, "assault_ready") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $432
ARGP4
ADDRLP4 1044
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1044
INDIRI4
CNSTI4 0
NEI4 $430
line 811
;811:		AssaultStartMatch( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 812
;812:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $416
JUMPV
LABELV $430
line 815
;813:	}
;814:
;815:	return qfalse;
CNSTI4 0
RETI4
LABELV $416
endproc G_AssaultClientCommand 1048 12
export G_AssaultInit
proc G_AssaultInit 4 12
line 818
;816:}
;817:
;818:void G_AssaultInit( void ) {
line 819
;819:	memset( &assault, 0, sizeof(assault) );
ADDRGP4 assault
ARGP4
CNSTI4 0
ARGI4
CNSTI4 136
ARGI4
ADDRGP4 memset
CALLP4
pop
line 820
;820:	assault.editorClient = -1;
ADDRGP4 assault+80
CNSTI4 -1
ASGNI4
line 821
;821:	assault.phase = ASSAULT_SETUP;
ADDRGP4 assault
CNSTI4 0
ASGNI4
line 822
;822:	assault.pointCount = ASSAULT_DEFAULT_POINTS;
ADDRGP4 assault+76
CNSTI4 2
ASGNI4
line 824
;823:
;824:	if( !G_AssaultEnabled() ) {
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $436
line 825
;825:		return;
ADDRGP4 $433
JUMPV
LABELV $436
line 828
;826:	}
;827:
;828:	level.warmupTime = -1;
ADDRGP4 level+16
CNSTI4 -1
ASGNI4
line 829
;829:	trap_SetConfigstring( CS_WARMUP, "-1" );
CNSTI4 5
ARGI4
ADDRGP4 $439
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 831
;830:
;831:	G_Printf(
ADDRGP4 $440
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 834
;832:		"Assault: waiting for point placement.\n"
;833:	);
;834:}
LABELV $433
endproc G_AssaultInit 4 12
export G_AssaultBlocksWarmup
proc G_AssaultBlocksWarmup 12 0
line 836
;835:
;836:qboolean G_AssaultBlocksWarmup( void ) {
line 837
;837:	return G_AssaultEnabled() &&
ADDRLP4 4
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRLP4 4
INDIRI4
ADDRLP4 8
INDIRI4
EQI4 $443
ADDRGP4 assault
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $443
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $444
JUMPV
LABELV $443
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $444
ADDRLP4 0
INDIRI4
RETI4
LABELV $441
endproc G_AssaultBlocksWarmup 12 0
export G_AssaultControlsExitRules
proc G_AssaultControlsExitRules 4 0
line 841
;838:		assault.phase == ASSAULT_SETUP;
;839:}
;840:
;841:qboolean G_AssaultControlsExitRules( void ) {
line 842
;842:	return G_AssaultEnabled();
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $445
endproc G_AssaultControlsExitRules 4 0
export G_AssaultGetActiveGoal
proc G_AssaultGetActiveGoal 16 0
line 849
;843:}
;844:
;845:qboolean G_AssaultGetActiveGoal(
;846:	vec3_t origin,
;847:	int *area,
;848:	team_t *attackingTeam
;849:) {
line 852
;850:	int point;
;851:
;852:	if( !G_AssaultEnabled() ||
ADDRLP4 4
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $449
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $447
ADDRLP4 8
INDIRI4
CNSTI4 2
EQI4 $447
LABELV $449
line 854
;853:		(assault.phase != ASSAULT_ROUND_RED &&
;854:		 assault.phase != ASSAULT_ROUND_BLUE) ) {
line 855
;855:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $446
JUMPV
LABELV $447
line 858
;856:	}
;857:
;858:	point = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 860
;859:
;860:	VectorCopy( assault.points[point], origin );
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
INDIRB
ASGNB 12
line 861
;861:	*area = assault.pointAreas[point];
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
INDIRI4
ASGNI4
line 862
;862:	*attackingTeam = assault.attackingTeam;
ADDRFP4 8
INDIRP4
ADDRGP4 assault+108
INDIRI4
ASGNI4
line 864
;863:
;864:	return qtrue;
CNSTI4 1
RETI4
LABELV $446
endproc G_AssaultGetActiveGoal 16 0
export G_AssaultRunFrame
proc G_AssaultRunFrame 52 12
line 867
;865:}
;866:
;867:void G_AssaultRunFrame( void ) {
line 875
;868:	int point;
;869:	int attackers;
;870:	int defenders;
;871:	int frameTime;
;872:	int holdTime;
;873:	int quarter;
;874:
;875:	if( !G_AssaultEnabled() ) {
ADDRLP4 24
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $454
line 876
;876:		return;
ADDRGP4 $453
JUMPV
LABELV $454
line 879
;877:	}
;878:
;879:	if( assault.phase == ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
NEI4 $456
line 880
;880:		if( assault.editorClient >= 0 &&
ADDRGP4 assault+80
INDIRI4
CNSTI4 0
LTI4 $453
CNSTI4 780
ADDRGP4 assault+80
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $453
line 882
;881:			level.clients[assault.editorClient].
;882:				pers.connected != CON_CONNECTED ) {
line 883
;883:			assault.editorClient = -1;
ADDRGP4 assault+80
CNSTI4 -1
ASGNI4
line 884
;884:		}
line 885
;885:		return;
ADDRGP4 $453
JUMPV
LABELV $456
line 888
;886:	}
;887:
;888:	if( assault.phase != ASSAULT_ROUND_RED &&
ADDRLP4 28
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
EQI4 $463
ADDRLP4 28
INDIRI4
CNSTI4 2
EQI4 $463
line 889
;889:		assault.phase != ASSAULT_ROUND_BLUE ) {
line 890
;890:		return;
ADDRGP4 $453
JUMPV
LABELV $463
line 893
;891:	}
;892:
;893:	if( level.time - assault.roundStartTime >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+96
INDIRI4
SUBI4
ADDRGP4 assault+100
INDIRI4
LTI4 $465
line 894
;894:		assault.roundLimit ) {
line 895
;895:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $470
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 899
;896:			-1,
;897:			"cp \"Assault round time expired\""
;898:		);
;899:		AssaultStoreRoundResult( qfalse );
CNSTI4 0
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 900
;900:		return;
ADDRGP4 $453
JUMPV
LABELV $465
line 903
;901:	}
;902:
;903:	frameTime = level.time - assault.lastFrameTime;
ADDRLP4 4
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+104
INDIRI4
SUBI4
ASGNI4
line 904
;904:	assault.lastFrameTime = level.time;
ADDRGP4 assault+104
ADDRGP4 level+32
INDIRI4
ASGNI4
line 906
;905:
;906:	if( frameTime < 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $475
line 907
;907:		frameTime = 0;
ADDRLP4 4
CNSTI4 0
ASGNI4
line 908
;908:	}
ADDRGP4 $476
JUMPV
LABELV $475
line 909
;909:	else if( frameTime > 200 ) {
ADDRLP4 4
INDIRI4
CNSTI4 200
LEI4 $477
line 910
;910:		frameTime = 200;
ADDRLP4 4
CNSTI4 200
ASGNI4
line 911
;911:	}
LABELV $477
LABELV $476
line 913
;912:
;913:	point = AssaultActualPoint();
ADDRLP4 32
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 915
;914:
;915:	AssaultCountPlayers(
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRLP4 20
ARGP4
ADDRGP4 AssaultCountPlayers
CALLV
pop
line 921
;916:		point,
;917:		&attackers,
;918:		&defenders
;919:	);
;920:
;921:	if( attackers > 0 && defenders == 0 ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $479
ADDRLP4 20
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $479
line 922
;922:		assault.captureProgress += frameTime;
ADDRLP4 40
ADDRGP4 assault+88
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
ADDI4
ASGNI4
line 923
;923:	}
ADDRGP4 $480
JUMPV
LABELV $479
line 924
;924:	else if( attackers == 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $482
line 925
;925:		assault.captureProgress -= frameTime / 2;
ADDRLP4 40
ADDRGP4 assault+88
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
ADDRLP4 4
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ASGNI4
line 927
;926:
;927:		if( assault.captureProgress < 0 ) {
ADDRGP4 assault+88
INDIRI4
CNSTI4 0
GEI4 $485
line 928
;928:			assault.captureProgress = 0;
ADDRGP4 assault+88
CNSTI4 0
ASGNI4
line 929
;929:		}
LABELV $485
line 930
;930:	}
LABELV $482
LABELV $480
line 932
;931:
;932:	holdTime = g_assaultHoldTime.integer * 1000;
ADDRLP4 0
CNSTI4 1000
ADDRGP4 g_assaultHoldTime+12
INDIRI4
MULI4
ASGNI4
line 934
;933:
;934:	if( holdTime < 1000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1000
GEI4 $490
line 935
;935:		holdTime = 1000;
ADDRLP4 0
CNSTI4 1000
ASGNI4
line 936
;936:	}
LABELV $490
line 938
;937:
;938:	quarter =
ADDRLP4 8
ADDRGP4 assault+88
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 0
INDIRI4
DIVI4
ASGNI4
line 941
;939:		(assault.captureProgress * 4) / holdTime;
;940:
;941:	if( quarter > assault.announcedQuarter &&
ADDRLP4 8
INDIRI4
ADDRGP4 assault+92
INDIRI4
LEI4 $493
ADDRLP4 8
INDIRI4
CNSTI4 4
GEI4 $493
line 942
;942:		quarter < 4 ) {
line 943
;943:		assault.announcedQuarter = quarter;
ADDRGP4 assault+92
ADDRLP4 8
INDIRI4
ASGNI4
line 945
;944:
;945:		trap_SendServerCommand(
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 44
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $497
ARGP4
ADDRLP4 44
INDIRP4
ARGP4
CNSTI4 25
ADDRLP4 8
INDIRI4
MULI4
ARGI4
ADDRLP4 48
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 48
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 953
;946:			-1,
;947:			va(
;948:				"cp \"Point %s: %i%%\"",
;949:				AssaultPointName(point),
;950:				quarter * 25
;951:			)
;952:		);
;953:	}
LABELV $493
line 955
;954:
;955:	if( assault.captureProgress >= holdTime ) {
ADDRGP4 assault+88
INDIRI4
ADDRLP4 0
INDIRI4
LTI4 $498
line 956
;956:		AssaultCompletePoint();
ADDRGP4 AssaultCompletePoint
CALLV
pop
line 957
;957:	}
LABELV $498
line 958
;958:}
LABELV $453
endproc G_AssaultRunFrame 52 12
import LogExit
bss
align 4
LABELV assault
skip 136
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
import g_assaultRadius
import g_assaultRoundTime
import g_assaultHoldTime
import g_assaultMode
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
LABELV $497
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 58
byte 1 32
byte 1 37
byte 1 105
byte 1 37
byte 1 37
byte 1 34
byte 1 0
align 1
LABELV $470
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 114
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 101
byte 1 120
byte 1 112
byte 1 105
byte 1 114
byte 1 101
byte 1 100
byte 1 34
byte 1 0
align 1
LABELV $440
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 102
byte 1 111
byte 1 114
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 109
byte 1 101
byte 1 110
byte 1 116
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $439
byte 1 45
byte 1 49
byte 1 0
align 1
LABELV $432
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 114
byte 1 101
byte 1 97
byte 1 100
byte 1 121
byte 1 0
align 1
LABELV $429
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 0
align 1
LABELV $424
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $421
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 115
byte 1 101
byte 1 116
byte 1 0
align 1
LABELV $412
byte 1 115
byte 1 0
align 1
LABELV $411
byte 1 0
align 1
LABELV $410
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 119
byte 1 105
byte 1 108
byte 1 108
byte 1 32
byte 1 117
byte 1 115
byte 1 101
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 37
byte 1 115
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $392
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 65
byte 1 110
byte 1 111
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $387
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 85
byte 1 115
byte 1 97
byte 1 103
byte 1 101
byte 1 58
byte 1 32
byte 1 47
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 115
byte 1 101
byte 1 116
byte 1 32
byte 1 49
byte 1 124
byte 1 50
byte 1 124
byte 1 51
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $373
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 66
byte 1 111
byte 1 116
byte 1 104
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 115
byte 1 32
byte 1 110
byte 1 101
byte 1 101
byte 1 100
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 108
byte 1 101
byte 1 97
byte 1 115
byte 1 116
byte 1 32
byte 1 111
byte 1 110
byte 1 101
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $369
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 32
byte 1 105
byte 1 110
byte 1 118
byte 1 97
byte 1 108
byte 1 105
byte 1 100
byte 1 46
byte 1 32
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 109
byte 1 105
byte 1 115
byte 1 115
byte 1 105
byte 1 110
byte 1 103
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $360
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 79
byte 1 110
byte 1 108
byte 1 121
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 111
byte 1 114
byte 1 32
byte 1 99
byte 1 97
byte 1 110
byte 1 32
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 109
byte 1 97
byte 1 116
byte 1 99
byte 1 104
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $335
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 65
byte 1 116
byte 1 116
byte 1 97
byte 1 99
byte 1 107
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 34
byte 1 0
align 1
LABELV $327
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 99
byte 1 97
byte 1 112
byte 1 116
byte 1 117
byte 1 114
byte 1 101
byte 1 100
byte 1 34
byte 1 0
align 1
LABELV $307
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 46
byte 1 0
align 1
LABELV $306
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 101
byte 1 110
byte 1 100
byte 1 101
byte 1 100
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 97
byte 1 32
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 34
byte 1 0
align 1
LABELV $305
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 119
byte 1 111
byte 1 110
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 46
byte 1 0
align 1
LABELV $304
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 119
byte 1 105
byte 1 110
byte 1 115
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 34
byte 1 0
align 1
LABELV $301
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 119
byte 1 111
byte 1 110
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 46
byte 1 0
align 1
LABELV $300
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 119
byte 1 105
byte 1 110
byte 1 115
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 34
byte 1 0
align 1
LABELV $243
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $242
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $241
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 32
byte 1 97
byte 1 116
byte 1 116
byte 1 97
byte 1 99
byte 1 107
byte 1 115
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 34
byte 1 0
align 1
LABELV $239
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $236
byte 1 48
byte 1 0
align 1
LABELV $195
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 87
byte 1 97
byte 1 114
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 58
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 110
byte 1 111
byte 1 32
byte 1 65
byte 1 65
byte 1 83
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 97
byte 1 59
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 32
byte 1 109
byte 1 97
byte 1 121
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 114
byte 1 101
byte 1 97
byte 1 99
byte 1 104
byte 1 32
byte 1 105
byte 1 116
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $192
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 100
byte 1 34
byte 1 0
align 1
LABELV $188
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 84
byte 1 104
byte 1 101
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 111
byte 1 32
byte 1 99
byte 1 108
byte 1 111
byte 1 115
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 103
byte 1 101
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $175
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 85
byte 1 110
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 32
byte 1 97
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 101
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $170
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 85
byte 1 115
byte 1 101
byte 1 32
byte 1 47
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 114
byte 1 115
byte 1 116
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $165
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 110
byte 1 117
byte 1 109
byte 1 98
byte 1 101
byte 1 114
byte 1 32
byte 1 109
byte 1 117
byte 1 115
byte 1 116
byte 1 32
byte 1 98
byte 1 101
byte 1 32
byte 1 102
byte 1 114
byte 1 111
byte 1 109
byte 1 32
byte 1 49
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 37
byte 1 105
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $160
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 84
byte 1 104
byte 1 101
byte 1 32
byte 1 109
byte 1 97
byte 1 116
byte 1 99
byte 1 104
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 97
byte 1 108
byte 1 114
byte 1 101
byte 1 97
byte 1 100
byte 1 121
byte 1 32
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $156
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 65
byte 1 110
byte 1 111
byte 1 116
byte 1 104
byte 1 101
byte 1 114
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $152
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 105
byte 1 110
byte 1 103
byte 1 32
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $147
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 80
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 109
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 114
byte 1 101
byte 1 113
byte 1 117
byte 1 105
byte 1 114
byte 1 101
byte 1 115
byte 1 32
byte 1 115
byte 1 112
byte 1 101
byte 1 99
byte 1 116
byte 1 97
byte 1 116
byte 1 111
byte 1 114
byte 1 32
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $108
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
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 101
byte 1 114
byte 1 47
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 95
byte 1 101
byte 1 120
byte 1 105
byte 1 116
byte 1 46
byte 1 109
byte 1 100
byte 1 51
byte 1 0
align 1
LABELV $107
byte 1 97
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 95
byte 1 109
byte 1 97
byte 1 114
byte 1 107
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $64
byte 1 63
byte 1 0
align 1
LABELV $63
byte 1 67
byte 1 0
align 1
LABELV $61
byte 1 66
byte 1 0
align 1
LABELV $59
byte 1 65
byte 1 0
