data
align 4
LABELV assaultMiddleClassnames
address $55
address $56
address $57
address $58
address $59
address $60
address $61
address $62
address $63
address $64
address $65
address $66
address $67
align 4
LABELV assaultMiddleNames
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
code
proc AssaultPointName 4 0
file "../g_assault.c"
line 90
;1:#include "g_local.h"
;2:
;3:#define ASSAULT_MIN_POINT_DISTANCE 512.0f
;4:#define ASSAULT_MARKER_MODEL "models/powerups/teleporter/tele_exit.md3"
;5:#define ASSAULT_MAX_POINTS 3
;6:#define ASSAULT_DEFAULT_POINTS 2
;7:#define ASSAULT_MODE_BASE 1
;8:#define ASSAULT_MODE_EDITOR 2
;9:#define ASSAULT_AUTO_START_DELAY 2000
;10:#define ASSAULT_MIDDLE_ITEM_COUNT 13
;11:
;12:typedef enum {
;13:	ASSAULT_SETUP,
;14:	ASSAULT_ROUND_RED,
;15:	ASSAULT_ROUND_BLUE,
;16:	ASSAULT_FINISHED
;17:} assaultPhase_t;
;18:
;19:typedef struct {
;20:	int completedPoints;
;21:	int progress;
;22:	int elapsedTime;
;23:} assaultResult_t;
;24:
;25:typedef struct {
;26:	assaultPhase_t phase;
;27:
;28:	vec3_t points[ASSAULT_MAX_POINTS];
;29:	int pointAreas[ASSAULT_MAX_POINTS];
;30:	qboolean pointSet[ASSAULT_MAX_POINTS];
;31:	gentity_t *markers[ASSAULT_MAX_POINTS];
;32:	qboolean instructionsShown[MAX_CLIENTS];
;33:
;34:	int pointCount;
;35:
;36:	int editorClient;
;37:	int activeStage;
;38:	int captureProgress;
;39:	int announcedQuarter;
;40:
;41:	int roundStartTime;
;42:	int roundLimit;
;43:	int lastFrameTime;
;44:	int autoStartTime;
;45:
;46:	team_t attackingTeam;
;47:
;48:	assaultResult_t redResult;
;49:	assaultResult_t blueResult;
;50:} assaultState_t;
;51:
;52:static assaultState_t assault;
;53:
;54:static char *assaultMiddleClassnames[
;55:	ASSAULT_MIDDLE_ITEM_COUNT
;56:] = {
;57:	"item_armor_body",
;58:	"item_armor_combat",
;59:	"item_health_mega",
;60:	"holdable_medkit",
;61:	"item_haste",
;62:	"weapon_bfg",
;63:	"weapon_railgun",
;64:	"weapon_shotgun",
;65:	"weapon_rocketlauncher",
;66:	"weapon_grenadelauncher",
;67:	"weapon_lightning",
;68:	"holdable_teleporter",
;69:	"weapon_plasmagun"
;70:};
;71:
;72:static char *assaultMiddleNames[
;73:	ASSAULT_MIDDLE_ITEM_COUNT
;74:] = {
;75:	"Heavy Armor",
;76:	"Armor",
;77:	"Mega Health",
;78:	"Medkit",
;79:	"Haste",
;80:	"BFG",
;81:	"Railgun",
;82:	"Shotgun",
;83:	"Rocket Launcher",
;84:	"Grenade Launcher",
;85:	"Lightning Gun",
;86:	"Personal Teleporter",
;87:	"Plasma Gun"
;88:};
;89:
;90:static char *AssaultPointName( int point ) {
line 91
;91:	switch( point ) {
ADDRLP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $84
ADDRLP4 0
INDIRI4
CNSTI4 1
EQI4 $86
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $88
ADDRGP4 $82
JUMPV
LABELV $84
line 93
;92:	case 0:
;93:		return "A";
ADDRGP4 $85
RETP4
ADDRGP4 $81
JUMPV
LABELV $86
line 95
;94:	case 1:
;95:		return "B";
ADDRGP4 $87
RETP4
ADDRGP4 $81
JUMPV
LABELV $88
line 97
;96:	case 2:
;97:		return "C";
ADDRGP4 $89
RETP4
ADDRGP4 $81
JUMPV
LABELV $82
line 99
;98:	default:
;99:		return "?";
ADDRGP4 $90
RETP4
LABELV $81
endproc AssaultPointName 4 0
export G_AssaultEnabled
proc G_AssaultEnabled 4 0
line 103
;100:	}
;101:}
;102:
;103:qboolean G_AssaultEnabled( void ) {
line 105
;104:	return
;105:		(
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
EQI4 $98
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $96
LABELV $98
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $96
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $97
JUMPV
LABELV $96
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $97
ADDRLP4 0
INDIRI4
RETI4
LABELV $91
endproc G_AssaultEnabled 4 0
proc AssaultActualPoint 0 0
line 112
;106:			g_assaultMode.integer == ASSAULT_MODE_BASE ||
;107:			g_assaultMode.integer == ASSAULT_MODE_EDITOR
;108:		) &&
;109:		g_gametype.integer == GT_TEAM;
;110:}
;111:
;112:static int AssaultActualPoint( void ) {
line 113
;113:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $100
line 114
;114:		return assault.activeStage;
ADDRGP4 assault+340
INDIRI4
RETI4
ADDRGP4 $99
JUMPV
LABELV $100
line 117
;115:	}
;116:
;117:	return assault.pointCount - 1 - assault.activeStage;
ADDRGP4 assault+332
INDIRI4
CNSTI4 1
SUBI4
ADDRGP4 assault+340
INDIRI4
SUBI4
RETI4
LABELV $99
endproc AssaultActualPoint 0 0
proc AssaultSetMarkerLight 0 0
line 126
;118:}
;119:
;120:static void AssaultSetMarkerLight(
;121:	gentity_t *marker,
;122:	int red,
;123:	int green,
;124:	int blue,
;125:	int intensity
;126:) {
line 127
;127:	if( !marker ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $107
line 128
;128:		return;
ADDRGP4 $106
JUMPV
LABELV $107
line 131
;129:	}
;130:
;131:	marker->s.constantLight =
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
line 136
;132:		red |
;133:		(green << 8) |
;134:		(blue << 16) |
;135:		(intensity << 24);
;136:}
LABELV $106
endproc AssaultSetMarkerLight 0 0
proc AssaultUpdateMarkers 16 20
line 138
;137:
;138:static void AssaultUpdateMarkers( void ) {
line 142
;139:	int activePoint;
;140:	int i;
;141:
;142:	activePoint = -1;
ADDRLP4 4
CNSTI4 -1
ASGNI4
line 144
;143:
;144:	if( assault.phase == ASSAULT_ROUND_RED ||
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $112
ADDRLP4 8
INDIRI4
CNSTI4 2
NEI4 $110
LABELV $112
line 145
;145:		assault.phase == ASSAULT_ROUND_BLUE ) {
line 146
;146:		activePoint = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ASGNI4
line 147
;147:	}
LABELV $110
line 149
;148:
;149:	for( i = 0; i < ASSAULT_MAX_POINTS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $113
line 150
;150:		if( !assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $117
line 151
;151:			continue;
ADDRGP4 $114
JUMPV
LABELV $117
line 154
;152:		}
;153:
;154:		if( i == activePoint ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $120
line 155
;155:			AssaultSetMarkerLight(
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
line 158
;156:				assault.markers[i], 32, 255, 32, 100
;157:			);
;158:			continue;
ADDRGP4 $114
JUMPV
LABELV $120
line 161
;159:		}
;160:
;161:		if( i == 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $123
line 162
;162:			AssaultSetMarkerLight(
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
line 165
;163:				assault.markers[i], 255, 48, 32, 55
;164:			);
;165:		}
ADDRGP4 $124
JUMPV
LABELV $123
line 166
;166:		else if( i == 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $126
line 167
;167:			AssaultSetMarkerLight(
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
line 170
;168:				assault.markers[i], 48, 96, 255, 55
;169:			);
;170:		}
ADDRGP4 $127
JUMPV
LABELV $126
line 171
;171:		else {
line 172
;172:			AssaultSetMarkerLight(
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
line 175
;173:				assault.markers[i], 255, 192, 32, 55
;174:			);
;175:		}
LABELV $127
LABELV $124
line 176
;176:	}
LABELV $114
line 149
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $113
line 177
;177:}
LABELV $109
endproc AssaultUpdateMarkers 16 20
proc AssaultCreateOrMoveMarker 16 8
line 179
;178:
;179:static void AssaultCreateOrMoveMarker( int point ) {
line 182
;180:	gentity_t *marker;
;181:
;182:	marker = assault.markers[point];
ADDRLP4 0
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ASGNP4
line 184
;183:
;184:	if( !marker ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $132
line 185
;185:		marker = G_Spawn();
ADDRLP4 4
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 186
;186:		assault.markers[point] = marker;
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 188
;187:
;188:		marker->classname = "assault_marker";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $135
ASGNP4
line 189
;189:		marker->s.eType = ET_GENERAL;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 0
ASGNI4
line 190
;190:		marker->s.modelindex = G_ModelIndex( ASSAULT_MARKER_MODEL );
ADDRGP4 $136
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
line 191
;191:		marker->s.apos.trType = TR_LINEAR;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 192
;192:		marker->s.apos.trTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 193
;193:		VectorSet(
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
line 200
;194:			marker->s.apos.trDelta,
;195:			0.0f,
;196:			45.0f,
;197:			0.0f
;198:		);
;199:
;200:		marker->r.svFlags |= SVF_BROADCAST;
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
line 201
;201:		marker->r.contents = 0;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 202
;202:	}
LABELV $132
line 204
;203:
;204:	G_SetOrigin( marker, assault.points[point] );
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
line 205
;205:	trap_LinkEntity( marker );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 207
;206:
;207:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 208
;208:}
LABELV $130
endproc AssaultCreateOrMoveMarker 16 8
proc AssaultPointAreaNum 120 20
line 210
;209:
;210:static int AssaultPointAreaNum( vec3_t origin ) {
line 218
;211:	int area;
;212:	int areas[16];
;213:	int numAreas;
;214:	int i;
;215:	vec3_t start;
;216:	vec3_t end;
;217:
;218:	area = trap_AAS_PointAreaNum( origin );
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
line 220
;219:
;220:	if( area &&
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $140
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
EQI4 $140
line 221
;221:		trap_AAS_AreaReachability(area) ) {
line 222
;222:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $139
JUMPV
LABELV $140
line 225
;223:	}
;224:
;225:	VectorCopy( origin, start );
ADDRLP4 76
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 226
;226:	VectorCopy( origin, end );
ADDRLP4 88
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 228
;227:
;228:	start[2] -= 32.0f;
ADDRLP4 76+8
ADDRLP4 76+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 229
;229:	end[2] += 64.0f;
ADDRLP4 88+8
ADDRLP4 88+8
INDIRF4
CNSTF4 1115684864
ADDF4
ASGNF4
line 231
;230:
;231:	numAreas = trap_AAS_TraceAreas(
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
line 239
;232:		start,
;233:		end,
;234:		areas,
;235:		NULL,
;236:		16
;237:	);
;238:
;239:	for( i = 0; i < numAreas; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $147
JUMPV
LABELV $144
line 240
;240:		if( trap_AAS_AreaReachability(areas[i]) ) {
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
EQI4 $148
line 241
;241:			return areas[i];
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
RETI4
ADDRGP4 $139
JUMPV
LABELV $148
line 243
;242:		}
;243:	}
LABELV $145
line 239
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $147
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $144
line 245
;244:
;245:	return 0;
CNSTI4 0
RETI4
LABELV $139
endproc AssaultPointAreaNum 120 20
proc AssaultGroundOrigin 92 28
line 251
;246:}
;247:
;248:static void AssaultGroundOrigin(
;249:	vec3_t source,
;250:	vec3_t result
;251:) {
line 256
;252:	trace_t trace;
;253:	vec3_t start;
;254:	vec3_t end;
;255:
;256:	VectorCopy( source, start );
ADDRLP4 56
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 257
;257:	VectorCopy( source, end );
ADDRLP4 68
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 259
;258:
;259:	start[2] += 32.0f;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 260
;260:	end[2] -= 256.0f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1132462080
SUBF4
ASGNF4
line 262
;261:
;262:	trap_Trace(
ADDRLP4 0
ARGP4
ADDRLP4 56
ARGP4
ADDRLP4 80
CNSTP4 0
ASGNP4
ADDRLP4 80
INDIRP4
ARGP4
ADDRLP4 80
INDIRP4
ARGP4
ADDRLP4 68
ARGP4
CNSTI4 1023
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 272
;263:		&trace,
;264:		start,
;265:		NULL,
;266:		NULL,
;267:		end,
;268:		ENTITYNUM_NONE,
;269:		MASK_SOLID
;270:	);
;271:
;272:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $153
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $153
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $153
line 274
;273:		!trace.allsolid &&
;274:		trace.fraction < 1.0f ) {
line 275
;275:		VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 276
;276:	}
ADDRGP4 $154
JUMPV
LABELV $153
line 277
;277:	else {
line 278
;278:		VectorCopy( source, result );
ADDRFP4 4
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 279
;279:	}
LABELV $154
line 281
;280:
;281:	result[2] += 8.0f;
ADDRLP4 88
ADDRFP4 4
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRF4
CNSTF4 1090519040
ADDF4
ASGNF4
line 282
;282:}
LABELV $150
endproc AssaultGroundOrigin 92 28
proc AssaultConsiderClassname 32 12
line 291
;283:
;284:static void AssaultConsiderClassname(
;285:	const char *classname,
;286:	int itemIndex,
;287:	int *seen,
;288:	vec3_t selectedOrigin,
;289:	int *selectedArea,
;290:	int *selectedItem
;291:) {
line 296
;292:	gentity_t *ent;
;293:	vec3_t origin;
;294:	int area;
;295:
;296:	ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $160
JUMPV
LABELV $159
line 302
;297:
;298:	while( (ent = G_Find(
;299:		ent,
;300:		FOFS(classname),
;301:		classname
;302:	)) != NULL ) {
line 303
;303:		AssaultGroundOrigin(
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 308
;304:			ent->s.origin,
;305:			origin
;306:		);
;307:
;308:		area = AssaultPointAreaNum( origin );
ADDRLP4 4
ARGP4
ADDRLP4 20
ADDRGP4 AssaultPointAreaNum
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
line 310
;309:
;310:		if( !area ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $162
line 311
;311:			continue;
ADDRGP4 $160
JUMPV
LABELV $162
line 314
;312:		}
;313:
;314:		(*seen)++;
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
line 316
;315:
;316:		if( rand() % (*seen) != 0 ) {
ADDRLP4 28
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
ADDRFP4 8
INDIRP4
INDIRI4
MODI4
CNSTI4 0
EQI4 $164
line 317
;317:			continue;
ADDRGP4 $160
JUMPV
LABELV $164
line 320
;318:		}
;319:
;320:		VectorCopy( origin, selectedOrigin );
ADDRFP4 12
INDIRP4
ADDRLP4 4
INDIRB
ASGNB 12
line 321
;321:		*selectedArea = area;
ADDRFP4 16
INDIRP4
ADDRLP4 16
INDIRI4
ASGNI4
line 322
;322:		*selectedItem = itemIndex;
ADDRFP4 20
INDIRP4
ADDRFP4 4
INDIRI4
ASGNI4
line 323
;323:	}
LABELV $160
line 298
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 20
INDIRP4
ASGNP4
ADDRLP4 20
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $159
line 324
;324:}
LABELV $158
endproc AssaultConsiderClassname 32 12
proc AssaultPickClassname 8 24
line 332
;325:
;326:static qboolean AssaultPickClassname(
;327:	const char *classname,
;328:	int itemIndex,
;329:	vec3_t origin,
;330:	int *area,
;331:	int *selectedItem
;332:) {
line 335
;333:	int seen;
;334:
;335:	seen = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 336
;336:	*area = 0;
ADDRFP4 12
INDIRP4
CNSTI4 0
ASGNI4
line 337
;337:	*selectedItem = -1;
ADDRFP4 16
INDIRP4
CNSTI4 -1
ASGNI4
line 339
;338:
;339:	AssaultConsiderClassname(
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 0
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 16
INDIRP4
ARGP4
ADDRGP4 AssaultConsiderClassname
CALLV
pop
line 348
;340:		classname,
;341:		itemIndex,
;342:		&seen,
;343:		origin,
;344:		area,
;345:		selectedItem
;346:	);
;347:
;348:	return seen > 0;
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $168
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $169
JUMPV
LABELV $168
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $169
ADDRLP4 4
INDIRI4
RETI4
LABELV $166
endproc AssaultPickClassname 8 24
proc AssaultSelectMiddlePoint 44 24
line 355
;349:}
;350:
;351:static qboolean AssaultSelectMiddlePoint(
;352:	vec3_t origin,
;353:	int *area,
;354:	int *selectedItem
;355:) {
line 361
;356:	int choice;
;357:	int seen;
;358:	int i;
;359:	vec3_t midpoint;
;360:
;361:	choice = g_assaultMiddleItem.integer;
ADDRLP4 20
ADDRGP4 g_assaultMiddleItem+12
INDIRI4
ASGNI4
line 363
;362:
;363:	if( choice < 0 ||
ADDRLP4 20
INDIRI4
CNSTI4 0
LTI4 $174
ADDRLP4 20
INDIRI4
CNSTI4 13
LEI4 $172
LABELV $174
line 364
;364:		choice > ASSAULT_MIDDLE_ITEM_COUNT ) {
line 365
;365:		choice = 0;
ADDRLP4 20
CNSTI4 0
ASGNI4
line 366
;366:	}
LABELV $172
line 371
;367:
;368:	/*
;369:	 * All: select uniformly from every supported entity.
;370:	 */
;371:	if( choice == 0 ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $175
line 372
;372:		seen = 0;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 373
;373:		*area = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 374
;374:		*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 376
;375:
;376:		for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $177
line 378
;377:			i < ASSAULT_MIDDLE_ITEM_COUNT;
;378:			i++ ) {
line 379
;379:			AssaultConsiderClassname(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assaultMiddleClassnames
ADDP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 16
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 AssaultConsiderClassname
CALLV
pop
line 387
;380:				assaultMiddleClassnames[i],
;381:				i,
;382:				&seen,
;383:				origin,
;384:				area,
;385:				selectedItem
;386:			);
;387:		}
LABELV $178
line 378
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 377
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $177
line 389
;388:
;389:		if( seen > 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $176
line 390
;390:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $170
JUMPV
line 392
;391:		}
;392:	}
LABELV $175
line 393
;393:	else {
line 397
;394:		/*
;395:		 * Explicitly selected entity.
;396:		 */
;397:		if( AssaultPickClassname(
ADDRLP4 20
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assaultMiddleClassnames-4
ADDP4
INDIRP4
ARGP4
ADDRLP4 20
INDIRI4
CNSTI4 1
SUBI4
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 AssaultPickClassname
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 0
EQI4 $183
line 403
;398:			assaultMiddleClassnames[choice - 1],
;399:			choice - 1,
;400:			origin,
;401:			area,
;402:			selectedItem
;403:		) ) {
line 404
;404:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $170
JUMPV
LABELV $183
line 410
;405:		}
;406:
;407:		/*
;408:		 * Selected entity is absent. Try the fallback list.
;409:		 */
;410:		for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $186
line 412
;411:			i < ASSAULT_MIDDLE_ITEM_COUNT;
;412:			i++ ) {
line 413
;413:			if( AssaultPickClassname(
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assaultMiddleClassnames
ADDP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRLP4 40
ADDRGP4 AssaultPickClassname
CALLI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
EQI4 $190
line 419
;414:				assaultMiddleClassnames[i],
;415:				i,
;416:				origin,
;417:				area,
;418:				selectedItem
;419:			) ) {
line 420
;420:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $170
JUMPV
LABELV $190
line 422
;421:			}
;422:		}
LABELV $187
line 412
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 411
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $186
line 423
;423:	}
LABELV $176
line 428
;424:
;425:	/*
;426:	 * Last fallback: midpoint between the flags.
;427:	 */
;428:	VectorAdd(
ADDRLP4 4
ADDRGP4 assault+4
INDIRF4
ADDRGP4 assault+4+24
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+4
ADDRGP4 assault+4+4
INDIRF4
ADDRGP4 assault+4+24+4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 4+8
ADDRGP4 assault+4+8
INDIRF4
ADDRGP4 assault+4+24+8
INDIRF4
ADDF4
ASGNF4
line 433
;429:		assault.points[0],
;430:		assault.points[2],
;431:		midpoint
;432:	);
;433:	VectorScale( midpoint, 0.5f, midpoint );
ADDRLP4 28
CNSTF4 1056964608
ASGNF4
ADDRLP4 4
ADDRLP4 28
INDIRF4
ADDRLP4 4
INDIRF4
MULF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 28
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
line 435
;434:
;435:	AssaultGroundOrigin( midpoint, origin );
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 436
;436:	*area = AssaultPointAreaNum( origin );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 32
ADDRGP4 AssaultPointAreaNum
CALLI4
ASGNI4
ADDRFP4 4
INDIRP4
ADDRLP4 32
INDIRI4
ASGNI4
line 437
;437:	*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 439
;438:
;439:	return *area != 0;
ADDRFP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $212
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $213
JUMPV
LABELV $212
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $213
ADDRLP4 36
INDIRI4
RETI4
LABELV $170
endproc AssaultSelectMiddlePoint 44 24
proc AssaultRemoveMapClass 8 12
line 444
;440:}
;441:
;442:static void AssaultRemoveMapClass(
;443:	const char *classname
;444:) {
line 447
;445:	gentity_t *ent;
;446:
;447:	ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $216
JUMPV
LABELV $215
line 453
;448:
;449:	while( (ent = G_Find(
;450:		ent,
;451:		FOFS(classname),
;452:		classname
;453:	)) != NULL ) {
line 454
;454:		G_FreeEntity( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 455
;455:	}
LABELV $216
line 449
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 524
ARGI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
ADDRLP4 4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $215
line 456
;456:}
LABELV $214
endproc AssaultRemoveMapClass 8 12
proc AssaultSetupBasePoints 24 20
line 458
;457:
;458:static qboolean AssaultSetupBasePoints( void ) {
line 463
;459:	int selectedItem;
;460:	int unusedItem;
;461:	int i;
;462:
;463:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 468
;464:
;465:	/*
;466:	 * A: blue flag.
;467:	 */
;468:	if( !AssaultPickClassname(
ADDRGP4 $222
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 assault+4
ARGP4
ADDRGP4 assault+40
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 12
ADDRGP4 AssaultPickClassname
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $220
line 474
;469:		"team_CTF_blueflag",
;470:		-1,
;471:		assault.points[0],
;472:		&assault.pointAreas[0],
;473:		&unusedItem
;474:	) ) {
line 475
;475:		G_Printf(
ADDRGP4 $225
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 478
;476:			"Assault: blue flag position not found.\n"
;477:		);
;478:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $218
JUMPV
LABELV $220
line 481
;479:	}
;480:
;481:	assault.pointSet[0] = qtrue;
ADDRGP4 assault+52
CNSTI4 1
ASGNI4
line 486
;482:
;483:	/*
;484:	 * C: red flag.
;485:	 */
;486:	if( !AssaultPickClassname(
ADDRGP4 $229
ARGP4
CNSTI4 -1
ARGI4
ADDRGP4 assault+4+24
ARGP4
ADDRGP4 assault+40+8
ARGP4
ADDRLP4 8
ARGP4
ADDRLP4 16
ADDRGP4 AssaultPickClassname
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $227
line 492
;487:		"team_CTF_redflag",
;488:		-1,
;489:		assault.points[2],
;490:		&assault.pointAreas[2],
;491:		&unusedItem
;492:	) ) {
line 493
;493:		G_Printf(
ADDRGP4 $234
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 496
;494:			"Assault: red flag position not found.\n"
;495:		);
;496:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $218
JUMPV
LABELV $227
line 499
;497:	}
;498:
;499:	assault.pointSet[2] = qtrue;
ADDRGP4 assault+52+8
CNSTI4 1
ASGNI4
line 504
;500:
;501:	/*
;502:	 * B: selected item or automatic fallback.
;503:	 */
;504:	if( !AssaultSelectMiddlePoint(
ADDRGP4 assault+4+12
ARGP4
ADDRGP4 assault+40+4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 20
ADDRGP4 AssaultSelectMiddlePoint
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $237
line 508
;505:		assault.points[1],
;506:		&assault.pointAreas[1],
;507:		&selectedItem
;508:	) ) {
line 509
;509:		G_Printf(
ADDRGP4 $243
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 512
;510:			"Assault: unable to create point B.\n"
;511:		);
;512:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $218
JUMPV
LABELV $237
line 515
;513:	}
;514:
;515:	assault.pointSet[1] = qtrue;
ADDRGP4 assault+52+4
CNSTI4 1
ASGNI4
line 520
;516:
;517:	/*
;518:	 * Flags are anchors only; remove their normal entities.
;519:	 */
;520:	AssaultRemoveMapClass(
ADDRGP4 $222
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 523
;521:		"team_CTF_blueflag"
;522:	);
;523:	AssaultRemoveMapClass(
ADDRGP4 $229
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 527
;524:		"team_CTF_redflag"
;525:	);
;526:
;527:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $249
JUMPV
LABELV $246
line 528
;528:		AssaultCreateOrMoveMarker( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 529
;529:	}
LABELV $247
line 527
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $249
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $246
line 531
;530:
;531:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $251
line 532
;532:		G_Printf(
ADDRGP4 $253
ARGP4
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assaultMiddleNames
ADDP4
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 536
;533:			"Assault: point B placed at %s.\n",
;534:			assaultMiddleNames[selectedItem]
;535:		);
;536:	}
ADDRGP4 $252
JUMPV
LABELV $251
line 537
;537:	else {
line 538
;538:		G_Printf(
ADDRGP4 $254
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 541
;539:			"Assault: point B placed at map midpoint.\n"
;540:		);
;541:	}
LABELV $252
line 543
;542:
;543:	return qtrue;
CNSTI4 1
RETI4
LABELV $218
endproc AssaultSetupBasePoints 24 20
proc AssaultTracePlacement 112 28
line 549
;544:}
;545:
;546:static qboolean AssaultTracePlacement(
;547:	gentity_t *ent,
;548:	vec3_t result
;549:) {
line 555
;550:	trace_t trace;
;551:	vec3_t start;
;552:	vec3_t end;
;553:	vec3_t forward;
;554:
;555:	VectorCopy( ent->client->ps.origin, start );
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
line 557
;556:
;557:	if( ent->client->ps.viewheight ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $256
line 558
;558:		start[2] += ent->client->ps.viewheight;
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
line 559
;559:	}
ADDRGP4 $257
JUMPV
LABELV $256
line 560
;560:	else {
line 561
;561:		start[2] += 26;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1104150528
ADDF4
ASGNF4
line 562
;562:	}
LABELV $257
line 564
;563:
;564:	AngleVectors(
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
line 571
;565:		ent->client->ps.viewangles,
;566:		forward,
;567:		NULL,
;568:		NULL
;569:	);
;570:
;571:	VectorMA( start, 8192.0f, forward, end );
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
line 573
;572:
;573:	trap_Trace(
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
line 583
;574:		&trace,
;575:		start,
;576:		NULL,
;577:		NULL,
;578:		end,
;579:		ent - g_entities,
;580:		MASK_SOLID
;581:	);
;582:
;583:	if( trace.startsolid ||
ADDRLP4 104
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $273
ADDRLP4 0
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $273
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $273
ADDRLP4 0+44
INDIRI4
CNSTI4 4
BANDI4
ADDRLP4 104
INDIRI4
EQI4 $266
LABELV $273
line 586
;584:		trace.allsolid ||
;585:		trace.fraction == 1.0f ||
;586:		(trace.surfaceFlags & SURF_SKY) ) {
line 587
;587:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $255
JUMPV
LABELV $266
line 590
;588:	}
;589:
;590:	VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 591
;591:	result[2] += 8.0f;
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
line 593
;592:
;593:	return qtrue;
CNSTI4 1
RETI4
LABELV $255
endproc AssaultTracePlacement 112 28
proc AssaultClaimEditor 8 8
line 596
;594:}
;595:
;596:static qboolean AssaultClaimEditor( gentity_t *ent ) {
line 599
;597:	int clientNum;
;598:
;599:	clientNum = ent - g_entities;
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
line 601
;600:
;601:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $276
line 602
;602:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $275
JUMPV
LABELV $276
line 605
;603:	}
;604:
;605:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $278
line 606
;606:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $280
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 610
;607:			clientNum,
;608:			"print \"Point placement requires spectator mode.\n\""
;609:		);
;610:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $275
JUMPV
LABELV $278
line 613
;611:	}
;612:
;613:	if( assault.editorClient == -1 ) {
ADDRGP4 assault+336
INDIRI4
CNSTI4 -1
NEI4 $281
line 614
;614:		assault.editorClient = clientNum;
ADDRGP4 assault+336
ADDRLP4 0
INDIRI4
ASGNI4
line 616
;615:
;616:		trap_SendServerCommand(
ADDRGP4 $285
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
line 623
;617:			-1,
;618:			va(
;619:				"print \"%s is placing Assault points.\n\"",
;620:				ent->client->pers.netname
;621:			)
;622:		);
;623:	}
LABELV $281
line 625
;624:
;625:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $286
line 626
;626:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $289
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 630
;627:			clientNum,
;628:			"print \"Another player is placing the points.\n\""
;629:		);
;630:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $275
JUMPV
LABELV $286
line 633
;631:	}
;632:
;633:	return qtrue;
CNSTI4 1
RETI4
LABELV $275
endproc AssaultClaimEditor 8 8
proc AssaultPlacePoint 44 8
line 636
;634:}
;635:
;636:static void AssaultPlacePoint( gentity_t *ent, int point ) {
line 642
;637:	vec3_t origin;
;638:	int otherPoint;
;639:	int area;
;640:	int clientNum;
;641:
;642:	clientNum = ent - g_entities;
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
line 644
;643:
;644:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $291
line 645
;645:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $293
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 649
;646:			clientNum,
;647:			"print \"The match has already started.\n\""
;648:		);
;649:		return;
ADDRGP4 $290
JUMPV
LABELV $291
line 652
;650:	}
;651:
;652:	if( point < 0 || point >= assault.pointCount ) {
ADDRLP4 24
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
LTI4 $297
ADDRLP4 24
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $294
LABELV $297
line 653
;653:		trap_SendServerCommand(
ADDRGP4 $298
ARGP4
ADDRGP4 assault+332
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
line 660
;654:			clientNum,
;655:			va(
;656:				"print \"Point number must be from 1 to %i.\n\"",
;657:				assault.pointCount
;658:			)
;659:		);
;660:		return;
ADDRGP4 $290
JUMPV
LABELV $294
line 663
;661:	}
;662:
;663:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $300
line 664
;664:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $303
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 668
;665:			clientNum,
;666:			"print \"Use /assault_edit first.\n\""
;667:		);
;668:		return;
ADDRGP4 $290
JUMPV
LABELV $300
line 671
;669:	}
;670:
;671:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $304
line 672
;672:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $280
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 676
;673:			clientNum,
;674:			"print \"Point placement requires spectator mode.\n\""
;675:		);
;676:		return;
ADDRGP4 $290
JUMPV
LABELV $304
line 679
;677:	}
;678:
;679:	if( !AssaultTracePlacement(ent, origin) ) {
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
NEI4 $306
line 680
;680:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $308
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 684
;681:			clientNum,
;682:			"print \"Unable to place a point there.\n\""
;683:		);
;684:		return;
ADDRGP4 $290
JUMPV
LABELV $306
line 687
;685:	}
;686:
;687:	for( otherPoint = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $312
JUMPV
LABELV $309
line 689
;688:		otherPoint < assault.pointCount;
;689:		otherPoint++ ) {
line 690
;690:		if( otherPoint == point ||
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $317
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $314
LABELV $317
line 691
;691:			!assault.pointSet[otherPoint] ) {
line 692
;692:			continue;
ADDRGP4 $310
JUMPV
LABELV $314
line 695
;693:		}
;694:
;695:		if( DistanceSquared(
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
GEF4 $318
line 700
;696:			origin,
;697:			assault.points[otherPoint]
;698:		) <
;699:			ASSAULT_MIN_POINT_DISTANCE *
;700:			ASSAULT_MIN_POINT_DISTANCE ) {
line 701
;701:			trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $321
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 705
;702:				clientNum,
;703:				"print \"The points are too close together.\n\""
;704:			);
;705:			return;
ADDRGP4 $290
JUMPV
LABELV $318
line 707
;706:		}
;707:	}
LABELV $310
line 689
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $312
line 688
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $309
line 709
;708:
;709:	area = AssaultPointAreaNum( origin );
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
line 711
;710:
;711:	VectorCopy( origin, assault.points[point] );
CNSTI4 12
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 712
;712:	assault.pointAreas[point] = area;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 713
;713:	assault.pointSet[point] = qtrue;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 1
ASGNI4
line 715
;714:
;715:	AssaultCreateOrMoveMarker( point );
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 717
;716:
;717:	trap_SendServerCommand(
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $325
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
line 725
;718:		-1,
;719:		va(
;720:			"cp \"Assault point %s placed\"",
;721:			AssaultPointName(point)
;722:		)
;723:	);
;724:
;725:	if( !area ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $326
line 726
;726:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $328
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 730
;727:			clientNum,
;728:			"print \"Warning: the point has no AAS area; bots may not reach it.\n\""
;729:		);
;730:	}
LABELV $326
line 731
;731:}
LABELV $290
endproc AssaultPlacePoint 44 8
proc AssaultRespawnTeams 16 4
line 733
;732:
;733:static void AssaultRespawnTeams( void ) {
line 737
;734:	int i;
;735:	gentity_t *ent;
;736:
;737:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $333
JUMPV
LABELV $330
line 738
;738:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 740
;739:
;740:		if( !ent->client ||
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
EQU4 $337
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $335
LABELV $337
line 741
;741:			ent->client->pers.connected != CON_CONNECTED ) {
line 742
;742:			continue;
ADDRGP4 $331
JUMPV
LABELV $335
line 745
;743:		}
;744:
;745:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $338
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $338
line 746
;746:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 747
;747:			continue;
ADDRGP4 $331
JUMPV
LABELV $338
line 750
;748:		}
;749:
;750:		ClientSpawn( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 ClientSpawn
CALLV
pop
line 751
;751:	}
LABELV $331
line 737
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $333
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $330
line 752
;752:}
LABELV $329
endproc AssaultRespawnTeams 16 4
proc AssaultStartRound 24 12
line 754
;753:
;754:static void AssaultStartRound( team_t attackingTeam ) {
line 757
;755:	int normalLimit;
;756:
;757:	assault.attackingTeam = attackingTeam;
ADDRGP4 assault+368
ADDRFP4 0
INDIRI4
ASGNI4
line 758
;758:	assault.activeStage = 0;
ADDRGP4 assault+340
CNSTI4 0
ASGNI4
line 759
;759:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 760
;760:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 761
;761:	assault.roundStartTime = level.time;
ADDRGP4 assault+352
ADDRGP4 level+32
INDIRI4
ASGNI4
line 762
;762:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 764
;763:
;764:	if( g_timelimit.value > 0.0f ) {
ADDRGP4 g_timelimit+8
INDIRF4
CNSTF4 0
LEF4 $349
line 765
;765:		normalLimit =
ADDRLP4 0
CNSTF4 1198153728
ADDRGP4 g_timelimit+8
INDIRF4
MULF4
CVFI4 4
ASGNI4
line 767
;766:			(int)(g_timelimit.value * 60000.0f);
;767:	}
ADDRGP4 $350
JUMPV
LABELV $349
line 768
;768:	else {
line 769
;769:		normalLimit = 7 * 60 * 1000;
ADDRLP4 0
CNSTI4 420000
ASGNI4
line 770
;770:	}
LABELV $350
line 772
;771:
;772:	if( normalLimit < 30000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 30000
GEI4 $353
line 773
;773:		normalLimit = 30000;
ADDRLP4 0
CNSTI4 30000
ASGNI4
line 774
;774:	}
LABELV $353
line 776
;775:
;776:	assault.roundLimit = normalLimit;
ADDRGP4 assault+356
ADDRLP4 0
INDIRI4
ASGNI4
line 778
;777:
;778:	if( attackingTeam == TEAM_RED ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $356
line 779
;779:		assault.phase = ASSAULT_ROUND_RED;
ADDRGP4 assault
CNSTI4 1
ASGNI4
line 780
;780:	}
ADDRGP4 $357
JUMPV
LABELV $356
line 781
;781:	else {
line 782
;782:		assault.phase = ASSAULT_ROUND_BLUE;
ADDRGP4 assault
CNSTI4 2
ASGNI4
line 787
;783:
;784:		/*
;785:		 * If Red completed the route, Blue must beat Red's time.
;786:		 */
;787:		if( assault.redResult.completedPoints == assault.pointCount &&
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $358
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+356
INDIRI4
GEI4 $358
line 789
;788:			assault.redResult.elapsedTime <
;789:			assault.roundLimit ) {
line 790
;790:			assault.roundLimit =
ADDRGP4 assault+356
ADDRGP4 assault+372+8
INDIRI4
ASGNI4
line 792
;791:				assault.redResult.elapsedTime;
;792:		}
LABELV $358
line 793
;793:	}
LABELV $357
line 795
;794:
;795:	level.startTime = level.time;
ADDRGP4 level+40
ADDRGP4 level+32
INDIRI4
ASGNI4
line 796
;796:	trap_SetConfigstring(
ADDRGP4 $370
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
line 801
;797:		CS_LEVEL_START_TIME,
;798:		va("%i", level.startTime)
;799:	);
;800:
;801:	AssaultRespawnTeams();
ADDRGP4 AssaultRespawnTeams
CALLV
pop
line 802
;802:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 804
;803:
;804:	trap_SendServerCommand(
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
ADDRGP4 $372
ARGP4
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $376
ADDRLP4 8
ADDRGP4 $373
ASGNP4
ADDRGP4 $377
JUMPV
LABELV $376
ADDRLP4 8
ADDRGP4 $374
ASGNP4
LABELV $377
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
line 812
;805:		-1,
;806:		va(
;807:			"cp \"%s attacks point %s\"",
;808:			attackingTeam == TEAM_RED ? "Red" : "Blue",
;809:			AssaultPointName(AssaultActualPoint())
;810:		)
;811:	);
;812:}
LABELV $340
endproc AssaultStartRound 24 12
proc AssaultUpdateScores 16 8
line 814
;813:
;814:static void AssaultUpdateScores( void ) {
line 815
;815:	level.teamScores[TEAM_RED] =
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $384
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $385
JUMPV
LABELV $384
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $385
ADDRGP4 level+44+4
ADDRLP4 0
INDIRI4
ASGNI4
line 819
;816:		assault.redResult.completedPoints ==
;817:		assault.pointCount ? 1 : 0;
;818:
;819:	level.teamScores[TEAM_BLUE] =
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $391
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $392
JUMPV
LABELV $391
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $392
ADDRGP4 level+44+8
ADDRLP4 4
INDIRI4
ASGNI4
line 823
;820:		assault.blueResult.completedPoints ==
;821:		assault.pointCount ? 1 : 0;
;822:
;823:	trap_SetConfigstring(
ADDRGP4 $370
ARGP4
ADDRGP4 level+44+4
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 6
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 828
;824:		CS_SCORES1,
;825:		va("%i", level.teamScores[TEAM_RED])
;826:	);
;827:
;828:	trap_SetConfigstring(
ADDRGP4 $370
ARGP4
ADDRGP4 level+44+8
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 7
ARGI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 833
;829:		CS_SCORES2,
;830:		va("%i", level.teamScores[TEAM_BLUE])
;831:	);
;832:
;833:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 834
;834:}
LABELV $378
endproc AssaultUpdateScores 16 8
proc AssaultFinishMatch 4 8
line 836
;835:
;836:static void AssaultFinishMatch( void ) {
line 839
;837:	int winner;
;838:
;839:	winner = TEAM_FREE;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 841
;840:
;841:	if( assault.redResult.completedPoints >
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+384
INDIRI4
LEI4 $398
line 842
;842:		assault.blueResult.completedPoints ) {
line 843
;843:		winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 844
;844:	}
ADDRGP4 $399
JUMPV
LABELV $398
line 845
;845:	else if( assault.blueResult.completedPoints >
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+372
INDIRI4
LEI4 $402
line 846
;846:		assault.redResult.completedPoints ) {
line 847
;847:		winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 848
;848:	}
ADDRGP4 $403
JUMPV
LABELV $402
line 849
;849:	else if( assault.redResult.completedPoints == assault.pointCount ) {
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $406
line 850
;850:		if( assault.redResult.elapsedTime <
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+384+8
INDIRI4
GEI4 $410
line 851
;851:			assault.blueResult.elapsedTime ) {
line 852
;852:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 853
;853:		}
ADDRGP4 $407
JUMPV
LABELV $410
line 854
;854:		else if( assault.blueResult.elapsedTime <
ADDRGP4 assault+384+8
INDIRI4
ADDRGP4 assault+372+8
INDIRI4
GEI4 $407
line 855
;855:			assault.redResult.elapsedTime ) {
line 856
;856:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 857
;857:		}
line 858
;858:	}
ADDRGP4 $407
JUMPV
LABELV $406
line 859
;859:	else {
line 860
;860:		if( assault.redResult.progress >
ADDRGP4 assault+372+4
INDIRI4
ADDRGP4 assault+384+4
INDIRI4
LEI4 $422
line 861
;861:			assault.blueResult.progress ) {
line 862
;862:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 863
;863:		}
ADDRGP4 $423
JUMPV
LABELV $422
line 864
;864:		else if( assault.blueResult.progress >
ADDRGP4 assault+384+4
INDIRI4
ADDRGP4 assault+372+4
INDIRI4
LEI4 $428
line 865
;865:			assault.redResult.progress ) {
line 866
;866:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 867
;867:		}
LABELV $428
LABELV $423
line 868
;868:	}
LABELV $407
LABELV $403
LABELV $399
line 870
;869:
;870:	assault.phase = ASSAULT_FINISHED;
ADDRGP4 assault
CNSTI4 3
ASGNI4
line 872
;871:
;872:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 874
;873:
;874:	if( winner == TEAM_RED ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $434
line 875
;875:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $436
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 879
;876:			-1,
;877:			"cp \"Red team wins Assault\""
;878:		);
;879:		LogExit( "Red team won Assault." );
ADDRGP4 $437
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 880
;880:	}
ADDRGP4 $435
JUMPV
LABELV $434
line 881
;881:	else if( winner == TEAM_BLUE ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $438
line 882
;882:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $440
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 886
;883:			-1,
;884:			"cp \"Blue team wins Assault\""
;885:		);
;886:		LogExit( "Blue team won Assault." );
ADDRGP4 $441
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 887
;887:	}
ADDRGP4 $439
JUMPV
LABELV $438
line 888
;888:	else {
line 889
;889:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $442
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 893
;890:			-1,
;891:			"cp \"Assault ended in a draw\""
;892:		);
;893:		LogExit( "Assault draw." );
ADDRGP4 $443
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 894
;894:	}
LABELV $439
LABELV $435
line 895
;895:}
LABELV $397
endproc AssaultFinishMatch 4 8
proc AssaultStoreRoundResult 4 4
line 897
;896:
;897:static void AssaultStoreRoundResult( qboolean completed ) {
line 900
;898:	assaultResult_t *result;
;899:
;900:	AssaultUpdateScores();
ADDRGP4 AssaultUpdateScores
CALLV
pop
line 901
;901:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $445
line 902
;902:		result = &assault.redResult;
ADDRLP4 0
ADDRGP4 assault+372
ASGNP4
line 903
;903:	}
ADDRGP4 $446
JUMPV
LABELV $445
line 904
;904:	else {
line 905
;905:		result = &assault.blueResult;
ADDRLP4 0
ADDRGP4 assault+384
ASGNP4
line 906
;906:	}
LABELV $446
line 908
;907:
;908:	if( completed ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
EQI4 $450
line 909
;909:		result->completedPoints = assault.pointCount;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+332
INDIRI4
ASGNI4
line 910
;910:		result->progress = (int)(g_assaultHoldTime.value * 1000.0f);
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTF4 1148846080
ADDRGP4 g_assaultHoldTime+8
INDIRF4
MULF4
CVFI4 4
ASGNI4
line 911
;911:		result->elapsedTime =
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+352
INDIRI4
SUBI4
ASGNI4
line 913
;912:			level.time - assault.roundStartTime;
;913:	}
ADDRGP4 $451
JUMPV
LABELV $450
line 914
;914:	else {
line 915
;915:		result->completedPoints = assault.activeStage;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+340
INDIRI4
ASGNI4
line 916
;916:		result->progress = assault.captureProgress;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 assault+344
INDIRI4
ASGNI4
line 917
;917:		result->elapsedTime = assault.roundLimit;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 assault+356
INDIRI4
ASGNI4
line 918
;918:	}
LABELV $451
line 920
;919:
;920:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $459
line 921
;921:		AssaultStartRound( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 922
;922:	}
ADDRGP4 $460
JUMPV
LABELV $459
line 923
;923:	else {
line 924
;924:		AssaultFinishMatch();
ADDRGP4 AssaultFinishMatch
CALLV
pop
line 925
;925:	}
LABELV $460
line 926
;926:}
LABELV $444
endproc AssaultStoreRoundResult 4 4
proc AssaultCompletePoint 32 8
line 928
;927:
;928:static void AssaultCompletePoint( void ) {
line 931
;929:	int completedPoint;
;930:
;931:	completedPoint = AssaultActualPoint();
ADDRLP4 4
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 933
;932:
;933:	trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $463
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
line 941
;934:		-1,
;935:		va(
;936:			"cp \"Point %s captured\"",
;937:			AssaultPointName(completedPoint)
;938:		)
;939:	);
;940:
;941:	assault.activeStage++;
ADDRLP4 16
ADDRGP4 assault+340
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 942
;942:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 943
;943:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 945
;944:
;945:	if( assault.activeStage >= assault.pointCount ) {
ADDRGP4 assault+340
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $467
line 946
;946:		AssaultStoreRoundResult( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 947
;947:		return;
ADDRGP4 $462
JUMPV
LABELV $467
line 950
;948:	}
;949:
;950:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 952
;951:
;952:	trap_SendServerCommand(
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
ADDRGP4 $471
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
line 959
;953:		-1,
;954:		va(
;955:			"cp \"Attack point %s\"",
;956:			AssaultPointName(AssaultActualPoint())
;957:		)
;958:	);
;959:}
LABELV $462
endproc AssaultCompletePoint 32 8
proc AssaultCountPlayers 28 8
line 965
;960:
;961:static void AssaultCountPlayers(
;962:	int point,
;963:	int *attackers,
;964:	int *defenders
;965:) {
line 970
;966:	int i;
;967:	float radiusSquared;
;968:	gentity_t *ent;
;969:
;970:	*attackers = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 971
;971:	*defenders = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
line 973
;972:
;973:	radiusSquared =
ADDRLP4 8
ADDRGP4 g_assaultRadius+8
INDIRF4
ADDRGP4 g_assaultRadius+8
INDIRF4
MULF4
ASGNF4
line 977
;974:		g_assaultRadius.value *
;975:		g_assaultRadius.value;
;976:
;977:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $478
JUMPV
LABELV $475
line 978
;978:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 980
;979:
;980:		if( !ent->client ||
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
EQU4 $483
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $483
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $480
LABELV $483
line 982
;981:			ent->client->pers.connected != CON_CONNECTED ||
;982:			ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
line 983
;983:			continue;
ADDRGP4 $476
JUMPV
LABELV $480
line 986
;984:		}
;985:
;986:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $484
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $484
line 987
;987:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 988
;988:			continue;
ADDRGP4 $476
JUMPV
LABELV $484
line 991
;989:		}
;990:
;991:		if( DistanceSquared(
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
LEF4 $486
line 994
;992:			ent->client->ps.origin,
;993:			assault.points[point]
;994:		) > radiusSquared ) {
line 995
;995:			continue;
ADDRGP4 $476
JUMPV
LABELV $486
line 998
;996:		}
;997:
;998:		if( ent->client->sess.sessionTeam ==
ADDRLP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
ADDRGP4 assault+368
INDIRI4
NEI4 $489
line 999
;999:			assault.attackingTeam ) {
line 1000
;1000:			(*attackers)++;
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
line 1001
;1001:		}
ADDRGP4 $490
JUMPV
LABELV $489
line 1002
;1002:		else {
line 1003
;1003:			(*defenders)++;
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
line 1004
;1004:		}
LABELV $490
line 1005
;1005:	}
LABELV $476
line 977
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $478
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $475
line 1006
;1006:}
LABELV $472
endproc AssaultCountPlayers 28 8
proc AssaultStartMatch 20 12
line 1008
;1007:
;1008:static void AssaultStartMatch( gentity_t *ent ) {
line 1012
;1009:	int clientNum;
;1010:	int i;
;1011:
;1012:	clientNum = ent ? ent - g_entities : -1;
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $494
ADDRLP4 8
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
ADDRGP4 $495
JUMPV
LABELV $494
ADDRLP4 8
CNSTI4 -1
ASGNI4
LABELV $495
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1014
;1013:
;1014:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $496
line 1015
;1015:		ASSAULT_MODE_EDITOR ) {
line 1016
;1016:		if( !ent ||
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $502
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $499
LABELV $502
line 1017
;1017:			assault.editorClient != clientNum ) {
line 1018
;1018:			trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $503
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1022
;1019:				clientNum,
;1020:				"print \"Only the point editor can start the match.\n\""
;1021:			);
;1022:			return;
ADDRGP4 $492
JUMPV
LABELV $499
line 1024
;1023:		}
;1024:	}
LABELV $496
line 1026
;1025:
;1026:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $507
JUMPV
LABELV $504
line 1027
;1027:		if( !assault.pointSet[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $509
line 1028
;1028:			trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $512
ARGP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1035
;1029:				clientNum,
;1030:				va(
;1031:					"print \"Assault: points are invalid. Point %s is missing.\n\"",
;1032:					AssaultPointName(i)
;1033:				)
;1034:			);
;1035:			return;
ADDRGP4 $492
JUMPV
LABELV $509
line 1037
;1036:		}
;1037:	}
LABELV $505
line 1026
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $507
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $504
line 1039
;1038:
;1039:	if( TeamCount(-1, TEAM_RED) < 1 ||
CNSTI4 -1
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 12
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 1
LTI4 $515
CNSTI4 -1
ARGI4
CNSTI4 2
ARGI4
ADDRLP4 16
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 1
GEI4 $513
LABELV $515
line 1040
;1040:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1041
;1041:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $516
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1045
;1042:			clientNum,
;1043:			"print \"Both teams need at least one player.\n\""
;1044:		);
;1045:		return;
ADDRGP4 $492
JUMPV
LABELV $513
line 1048
;1046:	}
;1047:
;1048:	level.warmupTime = 0;
ADDRGP4 level+16
CNSTI4 0
ASGNI4
line 1049
;1049:	trap_SetConfigstring( CS_WARMUP, "0" );
CNSTI4 5
ARGI4
ADDRGP4 $518
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1051
;1050:
;1051:	memset(
ADDRGP4 assault+372
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1056
;1052:		&assault.redResult,
;1053:		0,
;1054:		sizeof(assault.redResult)
;1055:	);
;1056:	memset(
ADDRGP4 assault+384
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1062
;1057:		&assault.blueResult,
;1058:		0,
;1059:		sizeof(assault.blueResult)
;1060:	);
;1061:	
;1062:	level.teamScores[TEAM_RED] = 0;
ADDRGP4 level+44+4
CNSTI4 0
ASGNI4
line 1063
;1063:	level.teamScores[TEAM_BLUE] = 0;
ADDRGP4 level+44+8
CNSTI4 0
ASGNI4
line 1065
;1064:
;1065:	trap_SetConfigstring( CS_SCORES1, "0" );
CNSTI4 6
ARGI4
ADDRGP4 $518
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1066
;1066:	trap_SetConfigstring( CS_SCORES2, "0" );
CNSTI4 7
ARGI4
ADDRGP4 $518
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1068
;1067:
;1068:	AssaultStartRound( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1069
;1069:}
LABELV $492
endproc AssaultStartMatch 20 12
proc AssaultSetPointCount 24 12
line 1075
;1070:
;1071:
;1072:static void AssaultSetPointCount(
;1073:	gentity_t *ent,
;1074:	int pointCount
;1075:) {
line 1079
;1076:	int i;
;1077:	int clientNum;
;1078:
;1079:	clientNum = ent - g_entities;
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
line 1081
;1080:
;1081:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $528
line 1082
;1082:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $293
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1086
;1083:			clientNum,
;1084:			"print \"The match has already started.\n\""
;1085:		);
;1086:		return;
ADDRGP4 $527
JUMPV
LABELV $528
line 1089
;1087:	}
;1088:
;1089:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $530
line 1090
;1090:		return;
ADDRGP4 $527
JUMPV
LABELV $530
line 1093
;1091:	}
;1092:
;1093:	if( pointCount < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $534
ADDRLP4 8
INDIRI4
CNSTI4 3
LEI4 $532
LABELV $534
line 1094
;1094:		pointCount > ASSAULT_MAX_POINTS ) {
line 1095
;1095:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $535
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1099
;1096:			clientNum,
;1097:			"print \"Usage: /assault_set 1|2|3\n\""
;1098:		);
;1099:		return;
ADDRGP4 $527
JUMPV
LABELV $532
line 1102
;1100:	}
;1101:
;1102:	if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $536
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $536
line 1103
;1103:		assault.editorClient != clientNum ) {
line 1104
;1104:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $540
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1108
;1105:			clientNum,
;1106:			"print \"Another player is editing Assault.\n\""
;1107:		);
;1108:		return;
ADDRGP4 $527
JUMPV
LABELV $536
line 1111
;1109:	}
;1110:
;1111:	for( i = pointCount;
ADDRLP4 0
ADDRFP4 4
INDIRI4
ASGNI4
ADDRGP4 $544
JUMPV
LABELV $541
line 1113
;1112:		i < ASSAULT_MAX_POINTS;
;1113:		i++ ) {
line 1114
;1114:		if( assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $545
line 1115
;1115:			G_FreeEntity( assault.markers[i] );
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
line 1116
;1116:			assault.markers[i] = NULL;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
CNSTP4 0
ASGNP4
line 1117
;1117:		}
LABELV $545
line 1119
;1118:
;1119:		assault.pointSet[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 0
ASGNI4
line 1120
;1120:		assault.pointAreas[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
CNSTI4 0
ASGNI4
line 1121
;1121:		VectorClear( assault.points[i] );
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
line 1122
;1122:	}
LABELV $542
line 1113
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $544
line 1112
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $541
line 1124
;1123:
;1124:	assault.pointCount = pointCount;
ADDRGP4 assault+332
ADDRFP4 4
INDIRI4
ASGNI4
line 1126
;1125:
;1126:	trap_SendServerCommand(
ADDRGP4 $558
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
NEI4 $562
ADDRLP4 12
ADDRGP4 $559
ASGNP4
ADDRGP4 $563
JUMPV
LABELV $562
ADDRLP4 12
ADDRGP4 $560
ASGNP4
LABELV $563
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
line 1134
;1127:		-1,
;1128:		va(
;1129:			"print \"Assault will use %i point%s.\n\"",
;1130:			pointCount,
;1131:			pointCount == 1 ? "" : "s"
;1132:		)
;1133:	);
;1134:}
LABELV $527
endproc AssaultSetPointCount 24 12
export G_AssaultClientCommand
proc G_AssaultClientCommand 1048 12
line 1139
;1135:
;1136:qboolean G_AssaultClientCommand(
;1137:	gentity_t *ent,
;1138:	const char *cmd
;1139:) {
line 1143
;1140:	char arg[MAX_TOKEN_CHARS];
;1141:	int value;
;1142:
;1143:	if( !G_AssaultEnabled() ) {
ADDRLP4 1028
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 1028
INDIRI4
CNSTI4 0
NEI4 $565
line 1144
;1144:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $564
JUMPV
LABELV $565
line 1147
;1145:	}
;1146:
;1147:	if( !Q_stricmp(cmd, "assault_set") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $569
ARGP4
ADDRLP4 1032
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 0
NEI4 $567
line 1148
;1148:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1149
;1149:		AssaultSetPointCount( ent, atoi(arg) );
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
line 1150
;1150:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $564
JUMPV
LABELV $567
line 1153
;1151:	}
;1152:
;1153:	if( !Q_stricmp(cmd, "assault_edit") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $572
ARGP4
ADDRLP4 1036
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1036
INDIRI4
CNSTI4 0
NEI4 $570
line 1154
;1154:		if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $573
line 1155
;1155:			trap_SendServerCommand(
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
ADDRGP4 $293
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1159
;1156:				ent - g_entities,
;1157:				"print \"The match has already started.\n\""
;1158:			);
;1159:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $564
JUMPV
LABELV $573
line 1162
;1160:		}
;1161:
;1162:		AssaultClaimEditor( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultClaimEditor
CALLI4
pop
line 1163
;1163:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $564
JUMPV
LABELV $570
line 1166
;1164:	}
;1165:
;1166:	if( !Q_stricmp(cmd, "assault_place") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $577
ARGP4
ADDRLP4 1040
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
NEI4 $575
line 1167
;1167:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1168
;1168:		value = atoi(arg) - 1;
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
line 1169
;1169:		AssaultPlacePoint( ent, value );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1024
INDIRI4
ARGI4
ADDRGP4 AssaultPlacePoint
CALLV
pop
line 1170
;1170:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $564
JUMPV
LABELV $575
line 1173
;1171:	}
;1172:
;1173:	if( !Q_stricmp(cmd, "assault_ready") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $580
ARGP4
ADDRLP4 1044
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1044
INDIRI4
CNSTI4 0
NEI4 $578
line 1174
;1174:		AssaultStartMatch( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1175
;1175:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $564
JUMPV
LABELV $578
line 1178
;1176:	}
;1177:
;1178:	return qfalse;
CNSTI4 0
RETI4
LABELV $564
endproc G_AssaultClientCommand 1048 12
export G_AssaultInit
proc G_AssaultInit 8 12
line 1181
;1179:}
;1180:
;1181:void G_AssaultInit( void ) {
line 1182
;1182:	memset( &assault, 0, sizeof(assault) );
ADDRGP4 assault
ARGP4
CNSTI4 0
ARGI4
CNSTI4 396
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1184
;1183:
;1184:	assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1185
;1185:	assault.phase = ASSAULT_SETUP;
ADDRGP4 assault
CNSTI4 0
ASGNI4
line 1187
;1186:
;1187:	if( !G_AssaultEnabled() ) {
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $583
line 1188
;1188:		return;
ADDRGP4 $581
JUMPV
LABELV $583
line 1191
;1189:	}
;1190:
;1191:	level.warmupTime = -1;
ADDRGP4 level+16
CNSTI4 -1
ASGNI4
line 1192
;1192:	trap_SetConfigstring( CS_WARMUP, "-1" );
CNSTI4 5
ARGI4
ADDRGP4 $586
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1194
;1193:
;1194:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
NEI4 $587
line 1195
;1195:		ASSAULT_MODE_BASE ) {
line 1196
;1196:		assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 1198
;1197:
;1198:		if( AssaultSetupBasePoints() ) {
ADDRLP4 4
ADDRGP4 AssaultSetupBasePoints
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $591
line 1199
;1199:			G_Printf(
ADDRGP4 $593
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1202
;1200:				"Assault: automatic points ready; waiting for teams.\n"
;1201:			);
;1202:		}
ADDRGP4 $581
JUMPV
LABELV $591
line 1203
;1203:		else {
line 1204
;1204:			G_Printf(
ADDRGP4 $594
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1207
;1205:				"Assault: automatic setup failed.\n"
;1206:			);
;1207:		}
line 1209
;1208:
;1209:		return;
ADDRGP4 $581
JUMPV
LABELV $587
line 1212
;1210:	}
;1211:
;1212:	assault.pointCount = ASSAULT_DEFAULT_POINTS;
ADDRGP4 assault+332
CNSTI4 2
ASGNI4
line 1214
;1213:
;1214:	G_Printf(
ADDRGP4 $596
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1217
;1215:		"Assault Editor: waiting for point placement.\n"
;1216:	);
;1217:}
LABELV $581
endproc G_AssaultInit 8 12
export G_AssaultBlocksWarmup
proc G_AssaultBlocksWarmup 12 0
line 1219
;1218:
;1219:qboolean G_AssaultBlocksWarmup( void ) {
line 1220
;1220:	return G_AssaultEnabled() &&
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
EQI4 $599
ADDRGP4 assault
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $599
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $600
JUMPV
LABELV $599
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $600
ADDRLP4 0
INDIRI4
RETI4
LABELV $597
endproc G_AssaultBlocksWarmup 12 0
export G_AssaultControlsExitRules
proc G_AssaultControlsExitRules 4 0
line 1224
;1221:		assault.phase == ASSAULT_SETUP;
;1222:}
;1223:
;1224:qboolean G_AssaultControlsExitRules( void ) {
line 1225
;1225:	return G_AssaultEnabled();
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $601
endproc G_AssaultControlsExitRules 4 0
export G_AssaultGetActiveGoal
proc G_AssaultGetActiveGoal 16 0
line 1232
;1226:}
;1227:
;1228:qboolean G_AssaultGetActiveGoal(
;1229:	vec3_t origin,
;1230:	int *area,
;1231:	team_t *attackingTeam
;1232:) {
line 1235
;1233:	int point;
;1234:
;1235:	if( !G_AssaultEnabled() ||
ADDRLP4 4
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $605
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $603
ADDRLP4 8
INDIRI4
CNSTI4 2
EQI4 $603
LABELV $605
line 1237
;1236:		(assault.phase != ASSAULT_ROUND_RED &&
;1237:		 assault.phase != ASSAULT_ROUND_BLUE) ) {
line 1238
;1238:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $602
JUMPV
LABELV $603
line 1241
;1239:	}
;1240:
;1241:	point = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 1243
;1242:
;1243:	VectorCopy( assault.points[point], origin );
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
line 1244
;1244:	*area = assault.pointAreas[point];
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
line 1245
;1245:	*attackingTeam = assault.attackingTeam;
ADDRFP4 8
INDIRP4
ADDRGP4 assault+368
INDIRI4
ASGNI4
line 1247
;1246:
;1247:	return qtrue;
CNSTI4 1
RETI4
LABELV $602
endproc G_AssaultGetActiveGoal 16 0
proc AssaultShowInstructions 12 8
line 1250
;1248:}
;1249:
;1250:static void AssaultShowInstructions( void ) {
line 1254
;1251:	int i;
;1252:	gentity_t *ent;
;1253:
;1254:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $613
JUMPV
LABELV $610
line 1255
;1255:		ent = &g_entities[i];
ADDRLP4 4
CNSTI4 808
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1257
;1256:
;1257:		if( !ent->client ||
ADDRLP4 8
ADDRLP4 4
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $617
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $615
LABELV $617
line 1258
;1258:			ent->client->pers.connected != CON_CONNECTED ) {
line 1259
;1259:			assault.instructionsShown[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 0
ASGNI4
line 1260
;1260:			continue;
ADDRGP4 $611
JUMPV
LABELV $615
line 1263
;1261:		}
;1262:
;1263:		if( ent->r.svFlags & SVF_BOT ) {
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $619
line 1264
;1264:			continue;
ADDRGP4 $611
JUMPV
LABELV $619
line 1267
;1265:		}
;1266:
;1267:		if( assault.instructionsShown[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
INDIRI4
CNSTI4 0
EQI4 $621
line 1268
;1268:			continue;
ADDRGP4 $611
JUMPV
LABELV $621
line 1271
;1269:		}
;1270:
;1271:		assault.instructionsShown[i] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 1
ASGNI4
line 1273
;1272:
;1273:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $625
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1277
;1274:			i,
;1275:			"print \"\n=== ASSAULT SETUP ===\n\""
;1276:		);
;1277:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $626
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1281
;1278:			i,
;1279:			"print \"Set point count: /assault_set 1, 2 or 3\n\""
;1280:		);
;1281:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $627
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1285
;1282:			i,
;1283:			"print \"Enter spectator mode: /team spectator\n\""
;1284:		);
;1285:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $628
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1289
;1286:			i,
;1287:			"print \"Begin editing: /assault_edit\n\""
;1288:		);
;1289:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $629
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1293
;1290:			i,
;1291:			"print \"Aim and place points: /assault_place 1|2|3\n\""
;1292:		);
;1293:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $630
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1297
;1294:			i,
;1295:			"print \"After placement, join Red or Blue team.\n\""
;1296:		);
;1297:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $631
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1301
;1298:			i,
;1299:			"print \"IMPORTANT: add bots before starting the match.\n\""
;1300:		);
;1301:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $632
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1305
;1302:			i,
;1303:			"print \"Start the match: /assault_ready\n\n\""
;1304:		);
;1305:	}
LABELV $611
line 1254
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $613
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $610
line 1306
;1306:}
LABELV $609
endproc AssaultShowInstructions 12 8
proc AssaultCurrentHoldTime 8 0
line 1308
;1307:
;1308:static int AssaultCurrentHoldTime( void ) {
line 1312
;1309:	int holdTime;
;1310:	int multiplier;
;1311:
;1312:	multiplier = 1 << assault.activeStage;
ADDRLP4 4
CNSTI4 1
ADDRGP4 assault+340
INDIRI4
LSHI4
ASGNI4
line 1314
;1313:
;1314:	holdTime = (int)(
ADDRLP4 0
CNSTF4 1148846080
ADDRGP4 g_assaultHoldTime+8
INDIRF4
MULF4
ADDRLP4 4
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
line 1320
;1315:		g_assaultHoldTime.value *
;1316:		1000.0f *
;1317:		multiplier
;1318:	);
;1319:
;1320:	if( holdTime < 1000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1000
GEI4 $636
line 1321
;1321:		holdTime = 1000;
ADDRLP4 0
CNSTI4 1000
ASGNI4
line 1322
;1322:	}
LABELV $636
line 1324
;1323:
;1324:	return holdTime;
ADDRLP4 0
INDIRI4
RETI4
LABELV $633
endproc AssaultCurrentHoldTime 8 0
export G_AssaultRunFrame
proc G_AssaultRunFrame 56 12
line 1327
;1325:}
;1326:
;1327:void G_AssaultRunFrame( void ) {
line 1335
;1328:	int point;
;1329:	int attackers;
;1330:	int defenders;
;1331:	int frameTime;
;1332:	int holdTime;
;1333:	int quarter;
;1334:
;1335:	if( !G_AssaultEnabled() ) {
ADDRLP4 24
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $639
line 1336
;1336:		return;
ADDRGP4 $638
JUMPV
LABELV $639
line 1339
;1337:	}
;1338:
;1339:if( assault.phase == ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
NEI4 $641
line 1340
;1340:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $643
line 1341
;1341:		ASSAULT_MODE_EDITOR ) {
line 1342
;1342:		AssaultShowInstructions();
ADDRGP4 AssaultShowInstructions
CALLV
pop
line 1344
;1343:
;1344:		if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $638
CNSTI4 780
ADDRGP4 assault+336
INDIRI4
MULI4
ADDRGP4 level
INDIRP4
ADDP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $638
line 1346
;1345:			level.clients[assault.editorClient].
;1346:				pers.connected != CON_CONNECTED ) {
line 1347
;1347:			assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1348
;1348:		}
line 1350
;1349:
;1350:		return;
ADDRGP4 $638
JUMPV
LABELV $643
line 1353
;1351:	}
;1352:
;1353:	if( !assault.pointSet[0] ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 assault+52
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $659
ADDRGP4 assault+52+4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $659
ADDRGP4 assault+52+8
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $651
LABELV $659
line 1355
;1354:		!assault.pointSet[1] ||
;1355:		!assault.pointSet[2] ) {
line 1356
;1356:		return;
ADDRGP4 $638
JUMPV
LABELV $651
line 1359
;1357:	}
;1358:
;1359:	if( TeamCount(-1, TEAM_RED) < 1 ||
CNSTI4 -1
ARGI4
CNSTI4 1
ARGI4
ADDRLP4 32
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 32
INDIRI4
CNSTI4 1
LTI4 $662
CNSTI4 -1
ARGI4
CNSTI4 2
ARGI4
ADDRLP4 36
ADDRGP4 TeamCount
CALLI4
ASGNI4
ADDRLP4 36
INDIRI4
CNSTI4 1
GEI4 $660
LABELV $662
line 1360
;1360:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1361
;1361:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1362
;1362:		return;
ADDRGP4 $638
JUMPV
LABELV $660
line 1365
;1363:	}
;1364:
;1365:	if( !assault.autoStartTime ) {
ADDRGP4 assault+364
INDIRI4
CNSTI4 0
NEI4 $664
line 1366
;1366:		assault.autoStartTime =
ADDRGP4 assault+364
ADDRGP4 level+32
INDIRI4
CNSTI4 2000
ADDI4
ASGNI4
line 1369
;1367:			level.time + ASSAULT_AUTO_START_DELAY;
;1368:
;1369:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $669
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1373
;1370:			-1,
;1371:			"cp \"Base Assault starts in 2 seconds\""
;1372:		);
;1373:		return;
ADDRGP4 $638
JUMPV
LABELV $664
line 1376
;1374:	}
;1375:
;1376:	if( level.time >= assault.autoStartTime ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+364
INDIRI4
LTI4 $638
line 1377
;1377:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1378
;1378:		AssaultStartMatch( NULL );
CNSTP4 0
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1379
;1379:	}
line 1381
;1380:
;1381:	return;
ADDRGP4 $638
JUMPV
LABELV $641
line 1384
;1382:}
;1383:
;1384:	if( assault.phase != ASSAULT_ROUND_RED &&
ADDRLP4 28
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
EQI4 $675
ADDRLP4 28
INDIRI4
CNSTI4 2
EQI4 $675
line 1385
;1385:		assault.phase != ASSAULT_ROUND_BLUE ) {
line 1386
;1386:		return;
ADDRGP4 $638
JUMPV
LABELV $675
line 1389
;1387:	}
;1388:
;1389:	if( level.time - assault.roundStartTime >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+352
INDIRI4
SUBI4
ADDRGP4 assault+356
INDIRI4
LTI4 $677
line 1390
;1390:		assault.roundLimit ) {
line 1391
;1391:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $682
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1395
;1392:			-1,
;1393:			"cp \"Assault round time expired\""
;1394:		);
;1395:		AssaultStoreRoundResult( qfalse );
CNSTI4 0
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1396
;1396:		return;
ADDRGP4 $638
JUMPV
LABELV $677
line 1399
;1397:	}
;1398:
;1399:	frameTime = level.time - assault.lastFrameTime;
ADDRLP4 0
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+360
INDIRI4
SUBI4
ASGNI4
line 1400
;1400:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1402
;1401:
;1402:	if( frameTime < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $687
line 1403
;1403:		frameTime = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1404
;1404:	}
ADDRGP4 $688
JUMPV
LABELV $687
line 1405
;1405:	else if( frameTime > 200 ) {
ADDRLP4 0
INDIRI4
CNSTI4 200
LEI4 $689
line 1406
;1406:		frameTime = 200;
ADDRLP4 0
CNSTI4 200
ASGNI4
line 1407
;1407:	}
LABELV $689
LABELV $688
line 1409
;1408:
;1409:	point = AssaultActualPoint();
ADDRLP4 32
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 1411
;1410:
;1411:	AssaultCountPlayers(
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
line 1417
;1412:		point,
;1413:		&attackers,
;1414:		&defenders
;1415:	);
;1416:
;1417:	if( attackers > 0 && defenders == 0 ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $691
ADDRLP4 20
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $691
line 1418
;1418:		assault.captureProgress += frameTime;
ADDRLP4 40
ADDRGP4 assault+344
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
ADDRLP4 0
INDIRI4
ADDI4
ASGNI4
line 1419
;1419:	}
ADDRGP4 $692
JUMPV
LABELV $691
line 1420
;1420:	else if( attackers == 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $694
line 1421
;1421:		assault.captureProgress -= frameTime / 2;
ADDRLP4 40
ADDRGP4 assault+344
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
ADDRLP4 0
INDIRI4
CNSTI4 2
DIVI4
SUBI4
ASGNI4
line 1423
;1422:
;1423:		if( assault.captureProgress < 0 ) {
ADDRGP4 assault+344
INDIRI4
CNSTI4 0
GEI4 $697
line 1424
;1424:			assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1425
;1425:		}
LABELV $697
line 1426
;1426:	}
LABELV $694
LABELV $692
line 1428
;1427:
;1428:	holdTime = AssaultCurrentHoldTime();
ADDRLP4 40
ADDRGP4 AssaultCurrentHoldTime
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 40
INDIRI4
ASGNI4
line 1430
;1429:
;1430:	quarter =
ADDRLP4 4
ADDRGP4 assault+344
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
INDIRI4
DIVI4
ASGNI4
line 1433
;1431:		(assault.captureProgress * 4) / holdTime;
;1432:
;1433:	if( quarter > assault.announcedQuarter &&
ADDRLP4 4
INDIRI4
ADDRGP4 assault+348
INDIRI4
LEI4 $702
ADDRLP4 4
INDIRI4
CNSTI4 4
GEI4 $702
line 1434
;1434:		quarter < 4 ) {
line 1435
;1435:		assault.announcedQuarter = quarter;
ADDRGP4 assault+348
ADDRLP4 4
INDIRI4
ASGNI4
line 1437
;1436:
;1437:		trap_SendServerCommand(
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 48
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $706
ARGP4
ADDRLP4 48
INDIRP4
ARGP4
CNSTI4 25
ADDRLP4 4
INDIRI4
MULI4
ARGI4
ADDRLP4 52
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 52
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1445
;1438:			-1,
;1439:			va(
;1440:				"cp \"Point %s: %i%%\"",
;1441:				AssaultPointName(point),
;1442:				quarter * 25
;1443:			)
;1444:		);
;1445:	}
LABELV $702
line 1447
;1446:
;1447:	if( assault.captureProgress >= holdTime ) {
ADDRGP4 assault+344
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $707
line 1448
;1448:		AssaultCompletePoint();
ADDRGP4 AssaultCompletePoint
CALLV
pop
line 1449
;1449:	}
LABELV $707
line 1450
;1450:}
LABELV $638
endproc G_AssaultRunFrame 56 12
import LogExit
bss
align 4
LABELV assault
skip 396
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
import g_respawnTime
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
LABELV $706
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
LABELV $682
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
LABELV $669
byte 1 99
byte 1 112
byte 1 32
byte 1 34
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
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 115
byte 1 32
byte 1 105
byte 1 110
byte 1 32
byte 1 50
byte 1 32
byte 1 115
byte 1 101
byte 1 99
byte 1 111
byte 1 110
byte 1 100
byte 1 115
byte 1 34
byte 1 0
align 1
LABELV $632
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 83
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
byte 1 114
byte 1 101
byte 1 97
byte 1 100
byte 1 121
byte 1 10
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $631
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 73
byte 1 77
byte 1 80
byte 1 79
byte 1 82
byte 1 84
byte 1 65
byte 1 78
byte 1 84
byte 1 58
byte 1 32
byte 1 97
byte 1 100
byte 1 100
byte 1 32
byte 1 98
byte 1 111
byte 1 116
byte 1 115
byte 1 32
byte 1 98
byte 1 101
byte 1 102
byte 1 111
byte 1 114
byte 1 101
byte 1 32
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 110
byte 1 103
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
LABELV $630
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 65
byte 1 102
byte 1 116
byte 1 101
byte 1 114
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
byte 1 44
byte 1 32
byte 1 106
byte 1 111
byte 1 105
byte 1 110
byte 1 32
byte 1 82
byte 1 101
byte 1 100
byte 1 32
byte 1 111
byte 1 114
byte 1 32
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 46
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $629
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 65
byte 1 105
byte 1 109
byte 1 32
byte 1 97
byte 1 110
byte 1 100
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
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
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
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
LABELV $628
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 66
byte 1 101
byte 1 103
byte 1 105
byte 1 110
byte 1 32
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 105
byte 1 110
byte 1 103
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
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $627
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 69
byte 1 110
byte 1 116
byte 1 101
byte 1 114
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
byte 1 58
byte 1 32
byte 1 47
byte 1 116
byte 1 101
byte 1 97
byte 1 109
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
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $626
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 83
byte 1 101
byte 1 116
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 99
byte 1 111
byte 1 117
byte 1 110
byte 1 116
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
byte 1 44
byte 1 32
byte 1 50
byte 1 32
byte 1 111
byte 1 114
byte 1 32
byte 1 51
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $625
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 10
byte 1 61
byte 1 61
byte 1 61
byte 1 32
byte 1 65
byte 1 83
byte 1 83
byte 1 65
byte 1 85
byte 1 76
byte 1 84
byte 1 32
byte 1 83
byte 1 69
byte 1 84
byte 1 85
byte 1 80
byte 1 32
byte 1 61
byte 1 61
byte 1 61
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $596
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 69
byte 1 100
byte 1 105
byte 1 116
byte 1 111
byte 1 114
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
LABELV $594
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 97
byte 1 117
byte 1 116
byte 1 111
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 99
byte 1 32
byte 1 115
byte 1 101
byte 1 116
byte 1 117
byte 1 112
byte 1 32
byte 1 102
byte 1 97
byte 1 105
byte 1 108
byte 1 101
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $593
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 97
byte 1 117
byte 1 116
byte 1 111
byte 1 109
byte 1 97
byte 1 116
byte 1 105
byte 1 99
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 32
byte 1 114
byte 1 101
byte 1 97
byte 1 100
byte 1 121
byte 1 59
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
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 115
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $586
byte 1 45
byte 1 49
byte 1 0
align 1
LABELV $580
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
LABELV $577
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
LABELV $572
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
LABELV $569
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
LABELV $560
byte 1 115
byte 1 0
align 1
LABELV $559
byte 1 0
align 1
LABELV $558
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
LABELV $540
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
LABELV $535
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
LABELV $518
byte 1 48
byte 1 0
align 1
LABELV $516
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
LABELV $512
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
LABELV $503
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
LABELV $471
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
LABELV $463
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
LABELV $443
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
LABELV $442
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
LABELV $441
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
LABELV $440
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
LABELV $437
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
LABELV $436
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
LABELV $374
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $373
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $372
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
LABELV $370
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $328
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
LABELV $325
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
LABELV $321
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
LABELV $308
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
LABELV $303
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
LABELV $298
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
LABELV $293
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
LABELV $289
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
LABELV $285
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
LABELV $280
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
LABELV $254
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
byte 1 32
byte 1 66
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 100
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 109
byte 1 97
byte 1 112
byte 1 32
byte 1 109
byte 1 105
byte 1 100
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $253
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
byte 1 32
byte 1 66
byte 1 32
byte 1 112
byte 1 108
byte 1 97
byte 1 99
byte 1 101
byte 1 100
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $243
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 117
byte 1 110
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 32
byte 1 116
byte 1 111
byte 1 32
byte 1 99
byte 1 114
byte 1 101
byte 1 97
byte 1 116
byte 1 101
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 66
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $234
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 114
byte 1 101
byte 1 100
byte 1 32
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 32
byte 1 112
byte 1 111
byte 1 115
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $229
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
LABELV $225
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 58
byte 1 32
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 32
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 32
byte 1 112
byte 1 111
byte 1 115
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 32
byte 1 110
byte 1 111
byte 1 116
byte 1 32
byte 1 102
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $222
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
LABELV $136
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
LABELV $135
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
LABELV $90
byte 1 63
byte 1 0
align 1
LABELV $89
byte 1 67
byte 1 0
align 1
LABELV $87
byte 1 66
byte 1 0
align 1
LABELV $85
byte 1 65
byte 1 0
align 1
LABELV $80
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
LABELV $79
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
LABELV $78
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
LABELV $77
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
LABELV $76
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
LABELV $75
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $74
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $73
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $72
byte 1 72
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $71
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $70
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
LABELV $69
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $68
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
LABELV $67
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 112
byte 1 108
byte 1 97
byte 1 115
byte 1 109
byte 1 97
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $66
byte 1 104
byte 1 111
byte 1 108
byte 1 100
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 95
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
byte 1 0
align 1
LABELV $65
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 108
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
LABELV $64
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 103
byte 1 114
byte 1 101
byte 1 110
byte 1 97
byte 1 100
byte 1 101
byte 1 108
byte 1 97
byte 1 117
byte 1 110
byte 1 99
byte 1 104
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $63
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 114
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 116
byte 1 108
byte 1 97
byte 1 117
byte 1 110
byte 1 99
byte 1 104
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $62
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $61
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 114
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $60
byte 1 119
byte 1 101
byte 1 97
byte 1 112
byte 1 111
byte 1 110
byte 1 95
byte 1 98
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $59
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 104
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $58
byte 1 104
byte 1 111
byte 1 108
byte 1 100
byte 1 97
byte 1 98
byte 1 108
byte 1 101
byte 1 95
byte 1 109
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $57
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 104
byte 1 101
byte 1 97
byte 1 108
byte 1 116
byte 1 104
byte 1 95
byte 1 109
byte 1 101
byte 1 103
byte 1 97
byte 1 0
align 1
LABELV $56
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 97
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 95
byte 1 99
byte 1 111
byte 1 109
byte 1 98
byte 1 97
byte 1 116
byte 1 0
align 1
LABELV $55
byte 1 105
byte 1 116
byte 1 101
byte 1 109
byte 1 95
byte 1 97
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 95
byte 1 98
byte 1 111
byte 1 100
byte 1 121
byte 1 0
