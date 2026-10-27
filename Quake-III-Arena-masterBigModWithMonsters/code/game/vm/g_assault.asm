data
align 4
LABELV assaultMiddleClassnames
address $59
address $60
address $61
address $62
address $63
address $64
address $65
address $66
address $67
address $68
address $69
address $70
address $71
align 4
LABELV assaultMiddleNames
address $72
address $73
address $74
address $75
address $76
address $77
address $78
address $79
address $80
address $81
address $82
address $83
address $84
code
proc AssaultPointName 4 0
file "../g_assault.c"
line 92
;1:#include "g_local.h"
;2:
;3:#define ASSAULT_MIN_POINT_DISTANCE 512.0f
;4:#define ASSAULT_MARKER_MODEL "models/powerups/teleporter/tele_exit.md3"
;5:#define ASSAULT_MAX_POINTS 3
;6:#define ASSAULT_DEFAULT_POINTS 2
;7:#define ASSAULT_MODE_BASE 1
;8:#define ASSAULT_MODE_EDITOR 2
;9:#define ASSAULT_MODE_TDM_BASE 3
;10:#define ASSAULT_AUTO_START_DELAY 2000
;11:#define ASSAULT_MIDDLE_ITEM_COUNT 13
;12:#define ASSAULT_MIDDLE_POINT_CHOICE (ASSAULT_MIDDLE_ITEM_COUNT + 1)
;13:
;14:typedef enum {
;15:	ASSAULT_SETUP,
;16:	ASSAULT_ROUND_RED,
;17:	ASSAULT_ROUND_BLUE,
;18:	ASSAULT_FINISHED
;19:} assaultPhase_t;
;20:
;21:typedef struct {
;22:	int completedPoints;
;23:	int progress;
;24:	int elapsedTime;
;25:} assaultResult_t;
;26:
;27:typedef struct {
;28:	assaultPhase_t phase;
;29:
;30:	vec3_t points[ASSAULT_MAX_POINTS];
;31:	int pointAreas[ASSAULT_MAX_POINTS];
;32:	qboolean pointSet[ASSAULT_MAX_POINTS];
;33:	gentity_t *markers[ASSAULT_MAX_POINTS];
;34:	qboolean instructionsShown[MAX_CLIENTS];
;35:
;36:	int pointCount;
;37:
;38:	int editorClient;
;39:	int activeStage;
;40:	int captureProgress;
;41:	int announcedQuarter;
;42:
;43:	int roundStartTime;
;44:	int roundLimit;
;45:	int lastFrameTime;
;46:	int autoStartTime;
;47:
;48:	team_t attackingTeam;
;49:
;50:	assaultResult_t redResult;
;51:	assaultResult_t blueResult;
;52:} assaultState_t;
;53:
;54:static assaultState_t assault;
;55:
;56:static char *assaultMiddleClassnames[
;57:	ASSAULT_MIDDLE_ITEM_COUNT
;58:] = {
;59:	"item_armor_body",
;60:	"item_armor_combat",
;61:	"item_health_mega",
;62:	"holdable_medkit",
;63:	"item_haste",
;64:	"weapon_bfg",
;65:	"weapon_railgun",
;66:	"weapon_shotgun",
;67:	"weapon_rocketlauncher",
;68:	"weapon_grenadelauncher",
;69:	"weapon_lightning",
;70:	"holdable_teleporter",
;71:	"weapon_plasmagun"
;72:};
;73:
;74:static char *assaultMiddleNames[
;75:	ASSAULT_MIDDLE_ITEM_COUNT
;76:] = {
;77:	"Heavy Armor",
;78:	"Armor",
;79:	"Mega Health",
;80:	"Medkit",
;81:	"Haste",
;82:	"BFG",
;83:	"Railgun",
;84:	"Shotgun",
;85:	"Rocket Launcher",
;86:	"Grenade Launcher",
;87:	"Lightning Gun",
;88:	"Personal Teleporter",
;89:	"Plasma Gun"
;90:};
;91:
;92:static char *AssaultPointName( int point ) {
line 93
;93:	switch( point ) {
ADDRLP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $88
ADDRLP4 0
INDIRI4
CNSTI4 1
EQI4 $90
ADDRLP4 0
INDIRI4
CNSTI4 2
EQI4 $92
ADDRGP4 $86
JUMPV
LABELV $88
line 95
;94:	case 0:
;95:		return "A";
ADDRGP4 $89
RETP4
ADDRGP4 $85
JUMPV
LABELV $90
line 97
;96:	case 1:
;97:		return "B";
ADDRGP4 $91
RETP4
ADDRGP4 $85
JUMPV
LABELV $92
line 99
;98:	case 2:
;99:		return "C";
ADDRGP4 $93
RETP4
ADDRGP4 $85
JUMPV
LABELV $86
line 101
;100:	default:
;101:		return "?";
ADDRGP4 $94
RETP4
LABELV $85
endproc AssaultPointName 4 0
export G_AssaultEnabled
proc G_AssaultEnabled 4 0
line 105
;102:	}
;103:}
;104:
;105:qboolean G_AssaultEnabled( void ) {
line 107
;106:	return
;107:		(
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
EQI4 $104
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
EQI4 $104
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $101
LABELV $104
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $101
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $102
JUMPV
LABELV $101
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $102
ADDRLP4 0
INDIRI4
RETI4
LABELV $95
endproc G_AssaultEnabled 4 0
proc AssaultActualPoint 0 0
line 115
;108:			g_assaultMode.integer == ASSAULT_MODE_BASE ||
;109:			g_assaultMode.integer == ASSAULT_MODE_EDITOR ||
;110:			g_assaultMode.integer == ASSAULT_MODE_TDM_BASE
;111:		) &&
;112:		g_gametype.integer == GT_TEAM;
;113:}
;114:
;115:static int AssaultActualPoint( void ) {
line 116
;116:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $106
line 117
;117:		return assault.activeStage;
ADDRGP4 assault+340
INDIRI4
RETI4
ADDRGP4 $105
JUMPV
LABELV $106
line 120
;118:	}
;119:
;120:	return assault.pointCount - 1 - assault.activeStage;
ADDRGP4 assault+332
INDIRI4
CNSTI4 1
SUBI4
ADDRGP4 assault+340
INDIRI4
SUBI4
RETI4
LABELV $105
endproc AssaultActualPoint 0 0
proc AssaultSetMarkerLight 0 0
line 129
;121:}
;122:
;123:static void AssaultSetMarkerLight(
;124:	gentity_t *marker,
;125:	int red,
;126:	int green,
;127:	int blue,
;128:	int intensity
;129:) {
line 130
;130:	if( !marker ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $113
line 131
;131:		return;
ADDRGP4 $112
JUMPV
LABELV $113
line 134
;132:	}
;133:
;134:	marker->s.constantLight =
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
line 139
;135:		red |
;136:		(green << 8) |
;137:		(blue << 16) |
;138:		(intensity << 24);
;139:}
LABELV $112
endproc AssaultSetMarkerLight 0 0
proc AssaultUpdateMarkers 16 20
line 141
;140:
;141:static void AssaultUpdateMarkers( void ) {
line 145
;142:	int activePoint;
;143:	int i;
;144:
;145:	activePoint = -1;
ADDRLP4 4
CNSTI4 -1
ASGNI4
line 147
;146:
;147:	if( assault.phase == ASSAULT_ROUND_RED ||
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $118
ADDRLP4 8
INDIRI4
CNSTI4 2
NEI4 $116
LABELV $118
line 148
;148:		assault.phase == ASSAULT_ROUND_BLUE ) {
line 149
;149:		activePoint = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ASGNI4
line 150
;150:	}
LABELV $116
line 152
;151:
;152:	for( i = 0; i < ASSAULT_MAX_POINTS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $119
line 153
;153:		if( !assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $123
line 154
;154:			continue;
ADDRGP4 $120
JUMPV
LABELV $123
line 157
;155:		}
;156:
;157:		if( i == activePoint ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $126
line 158
;158:			AssaultSetMarkerLight(
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
line 161
;159:				assault.markers[i], 32, 255, 32, 100
;160:			);
;161:			continue;
ADDRGP4 $120
JUMPV
LABELV $126
line 164
;162:		}
;163:
;164:		if( i == 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $129
line 165
;165:			AssaultSetMarkerLight(
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
line 168
;166:				assault.markers[i], 255, 48, 32, 55
;167:			);
;168:		}
ADDRGP4 $130
JUMPV
LABELV $129
line 169
;169:		else if( i == 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $132
line 170
;170:			AssaultSetMarkerLight(
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
line 173
;171:				assault.markers[i], 48, 96, 255, 55
;172:			);
;173:		}
ADDRGP4 $133
JUMPV
LABELV $132
line 174
;174:		else {
line 175
;175:			AssaultSetMarkerLight(
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
line 178
;176:				assault.markers[i], 255, 192, 32, 55
;177:			);
;178:		}
LABELV $133
LABELV $130
line 179
;179:	}
LABELV $120
line 152
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $119
line 180
;180:}
LABELV $115
endproc AssaultUpdateMarkers 16 20
proc AssaultCreateOrMoveMarker 16 8
line 182
;181:
;182:static void AssaultCreateOrMoveMarker( int point ) {
line 185
;183:	gentity_t *marker;
;184:
;185:	marker = assault.markers[point];
ADDRLP4 0
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ASGNP4
line 187
;186:
;187:	if( !marker ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $138
line 188
;188:		marker = G_Spawn();
ADDRLP4 4
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 189
;189:		assault.markers[point] = marker;
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 191
;190:
;191:		marker->classname = "assault_marker";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $141
ASGNP4
line 192
;192:		marker->s.eType = ET_GENERAL;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 0
ASGNI4
line 193
;193:		marker->s.modelindex = G_ModelIndex( ASSAULT_MARKER_MODEL );
ADDRGP4 $142
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
line 194
;194:		marker->s.apos.trType = TR_LINEAR;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 195
;195:		marker->s.apos.trTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 196
;196:		VectorSet(
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
line 203
;197:			marker->s.apos.trDelta,
;198:			0.0f,
;199:			45.0f,
;200:			0.0f
;201:		);
;202:
;203:		marker->r.svFlags |= SVF_BROADCAST;
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
line 204
;204:		marker->r.contents = 0;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 205
;205:	}
LABELV $138
line 207
;206:
;207:	G_SetOrigin( marker, assault.points[point] );
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
line 208
;208:	trap_LinkEntity( marker );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 210
;209:
;210:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 211
;211:}
LABELV $136
endproc AssaultCreateOrMoveMarker 16 8
proc AssaultPointAreaNum 120 20
line 213
;212:
;213:static int AssaultPointAreaNum( vec3_t origin ) {
line 221
;214:	int area;
;215:	int areas[16];
;216:	int numAreas;
;217:	int i;
;218:	vec3_t start;
;219:	vec3_t end;
;220:
;221:	area = trap_AAS_PointAreaNum( origin );
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
line 223
;222:
;223:	if( area &&
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $146
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
EQI4 $146
line 224
;224:		trap_AAS_AreaReachability(area) ) {
line 225
;225:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $145
JUMPV
LABELV $146
line 228
;226:	}
;227:
;228:	VectorCopy( origin, start );
ADDRLP4 76
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 229
;229:	VectorCopy( origin, end );
ADDRLP4 88
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 231
;230:
;231:	start[2] -= 32.0f;
ADDRLP4 76+8
ADDRLP4 76+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 232
;232:	end[2] += 64.0f;
ADDRLP4 88+8
ADDRLP4 88+8
INDIRF4
CNSTF4 1115684864
ADDF4
ASGNF4
line 234
;233:
;234:	numAreas = trap_AAS_TraceAreas(
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
line 242
;235:		start,
;236:		end,
;237:		areas,
;238:		NULL,
;239:		16
;240:	);
;241:
;242:	for( i = 0; i < numAreas; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $153
JUMPV
LABELV $150
line 243
;243:		if( trap_AAS_AreaReachability(areas[i]) ) {
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
EQI4 $154
line 244
;244:			return areas[i];
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 4
ADDP4
INDIRI4
RETI4
ADDRGP4 $145
JUMPV
LABELV $154
line 246
;245:		}
;246:	}
LABELV $151
line 242
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $153
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $150
line 248
;247:
;248:	return 0;
CNSTI4 0
RETI4
LABELV $145
endproc AssaultPointAreaNum 120 20
proc AssaultGroundOrigin 92 28
line 254
;249:}
;250:
;251:static void AssaultGroundOrigin(
;252:	vec3_t source,
;253:	vec3_t result
;254:) {
line 259
;255:	trace_t trace;
;256:	vec3_t start;
;257:	vec3_t end;
;258:
;259:	VectorCopy( source, start );
ADDRLP4 56
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 260
;260:	VectorCopy( source, end );
ADDRLP4 68
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 262
;261:
;262:	start[2] += 32.0f;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 263
;263:	end[2] -= 256.0f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1132462080
SUBF4
ASGNF4
line 265
;264:
;265:	trap_Trace(
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
line 275
;266:		&trace,
;267:		start,
;268:		NULL,
;269:		NULL,
;270:		end,
;271:		ENTITYNUM_NONE,
;272:		MASK_SOLID
;273:	);
;274:
;275:	if( !trace.startsolid &&
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $159
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $159
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $159
line 277
;276:		!trace.allsolid &&
;277:		trace.fraction < 1.0f ) {
line 278
;278:		VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 279
;279:	}
ADDRGP4 $160
JUMPV
LABELV $159
line 280
;280:	else {
line 281
;281:		VectorCopy( source, result );
ADDRFP4 4
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 282
;282:	}
LABELV $160
line 284
;283:
;284:	result[2] += 8.0f;
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
line 285
;285:}
LABELV $156
endproc AssaultGroundOrigin 92 28
proc AssaultConsiderClassname 32 12
line 294
;286:
;287:static void AssaultConsiderClassname(
;288:	const char *classname,
;289:	int itemIndex,
;290:	int *seen,
;291:	vec3_t selectedOrigin,
;292:	int *selectedArea,
;293:	int *selectedItem
;294:) {
line 299
;295:	gentity_t *ent;
;296:	vec3_t origin;
;297:	int area;
;298:
;299:	ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $166
JUMPV
LABELV $165
line 305
;300:
;301:	while( (ent = G_Find(
;302:		ent,
;303:		FOFS(classname),
;304:		classname
;305:	)) != NULL ) {
line 306
;306:		AssaultGroundOrigin(
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
line 311
;307:			ent->s.origin,
;308:			origin
;309:		);
;310:
;311:		area = AssaultPointAreaNum( origin );
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
line 313
;312:
;313:		if( !area ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $168
line 314
;314:			continue;
ADDRGP4 $166
JUMPV
LABELV $168
line 317
;315:		}
;316:
;317:		(*seen)++;
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
line 319
;318:
;319:		if( rand() % (*seen) != 0 ) {
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
EQI4 $170
line 320
;320:			continue;
ADDRGP4 $166
JUMPV
LABELV $170
line 323
;321:		}
;322:
;323:		VectorCopy( origin, selectedOrigin );
ADDRFP4 12
INDIRP4
ADDRLP4 4
INDIRB
ASGNB 12
line 324
;324:		*selectedArea = area;
ADDRFP4 16
INDIRP4
ADDRLP4 16
INDIRI4
ASGNI4
line 325
;325:		*selectedItem = itemIndex;
ADDRFP4 20
INDIRP4
ADDRFP4 4
INDIRI4
ASGNI4
line 326
;326:	}
LABELV $166
line 301
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
NEU4 $165
line 327
;327:}
LABELV $164
endproc AssaultConsiderClassname 32 12
proc AssaultPickClassname 8 24
line 335
;328:
;329:static qboolean AssaultPickClassname(
;330:	const char *classname,
;331:	int itemIndex,
;332:	vec3_t origin,
;333:	int *area,
;334:	int *selectedItem
;335:) {
line 338
;336:	int seen;
;337:
;338:	seen = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 339
;339:	*area = 0;
ADDRFP4 12
INDIRP4
CNSTI4 0
ASGNI4
line 340
;340:	*selectedItem = -1;
ADDRFP4 16
INDIRP4
CNSTI4 -1
ASGNI4
line 342
;341:
;342:	AssaultConsiderClassname(
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
line 351
;343:		classname,
;344:		itemIndex,
;345:		&seen,
;346:		origin,
;347:		area,
;348:		selectedItem
;349:	);
;350:
;351:	return seen > 0;
ADDRLP4 0
INDIRI4
CNSTI4 0
LEI4 $174
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $175
JUMPV
LABELV $174
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $175
ADDRLP4 4
INDIRI4
RETI4
LABELV $172
endproc AssaultPickClassname 8 24
proc AssaultSelectMiddlePoint 44 24
line 358
;352:}
;353:
;354:static qboolean AssaultSelectMiddlePoint(
;355:	vec3_t origin,
;356:	int *area,
;357:	int *selectedItem
;358:) {
line 364
;359:	int choice;
;360:	int seen;
;361:	int i;
;362:	vec3_t midpoint;
;363:
;364:	choice = g_assaultMiddleItem.integer;
ADDRLP4 16
ADDRGP4 g_assaultMiddleItem+12
INDIRI4
ASGNI4
line 366
;365:
;366:	if( choice < 0 || choice > ASSAULT_MIDDLE_POINT_CHOICE ) 
ADDRLP4 16
INDIRI4
CNSTI4 0
LTI4 $180
ADDRLP4 16
INDIRI4
CNSTI4 14
LEI4 $178
LABELV $180
line 367
;367:	{ 
line 368
;368:		choice = 0;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 369
;369:	}
LABELV $178
line 374
;370:	
;371:	/*
;372:	 * Explicit middle point between A and C.
;373:	 */
;374:	if( choice == ASSAULT_MIDDLE_POINT_CHOICE ) {
ADDRLP4 16
INDIRI4
CNSTI4 14
NEI4 $181
line 375
;375:		VectorAdd(
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
line 381
;376:			assault.points[0],
;377:			assault.points[2],
;378:			midpoint
;379:		);
;380:
;381:		VectorScale(
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
line 387
;382:			midpoint,
;383:			0.5f,
;384:			midpoint
;385:		);
;386:
;387:		AssaultGroundOrigin(
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 392
;388:			midpoint,
;389:			origin
;390:		);
;391:
;392:		*area =
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
line 395
;393:			AssaultPointAreaNum(origin);
;394:
;395:		*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 397
;396:
;397:		return *area != 0;
ADDRFP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $203
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $204
JUMPV
LABELV $203
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $204
ADDRLP4 36
INDIRI4
RETI4
ADDRGP4 $176
JUMPV
LABELV $181
line 403
;398:	}
;399:
;400:	/*
;401:	 * All: select uniformly from every supported entity.
;402:	 */
;403:	if( choice == 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $205
line 404
;404:		seen = 0;
ADDRLP4 20
CNSTI4 0
ASGNI4
line 405
;405:		*area = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 406
;406:		*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 408
;407:
;408:		for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $207
line 410
;409:			i < ASSAULT_MIDDLE_ITEM_COUNT;
;410:			i++ ) {
line 411
;411:			AssaultConsiderClassname(
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
ADDRLP4 20
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
line 419
;412:				assaultMiddleClassnames[i],
;413:				i,
;414:				&seen,
;415:				origin,
;416:				area,
;417:				selectedItem
;418:			);
;419:		}
LABELV $208
line 410
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 409
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $207
line 421
;420:
;421:		if( seen > 0 ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
LEI4 $206
line 422
;422:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $176
JUMPV
line 424
;423:		}
;424:	}
LABELV $205
line 425
;425:	else {
line 429
;426:		/*
;427:		 * Explicitly selected entity.
;428:		 */
;429:		if( AssaultPickClassname(
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assaultMiddleClassnames-4
ADDP4
INDIRP4
ARGP4
ADDRLP4 16
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
EQI4 $213
line 435
;430:			assaultMiddleClassnames[choice - 1],
;431:			choice - 1,
;432:			origin,
;433:			area,
;434:			selectedItem
;435:		) ) {
line 436
;436:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $176
JUMPV
LABELV $213
line 442
;437:		}
;438:
;439:		/*
;440:		 * Selected entity is absent. Try the fallback list.
;441:		 */
;442:		for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $216
line 444
;443:			i < ASSAULT_MIDDLE_ITEM_COUNT;
;444:			i++ ) {
line 445
;445:			if( AssaultPickClassname(
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
EQI4 $220
line 451
;446:				assaultMiddleClassnames[i],
;447:				i,
;448:				origin,
;449:				area,
;450:				selectedItem
;451:			) ) {
line 452
;452:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $176
JUMPV
LABELV $220
line 454
;453:			}
;454:		}
LABELV $217
line 444
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 443
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $216
line 455
;455:	}
LABELV $206
line 460
;456:
;457:	/*
;458:	 * Last fallback: midpoint between the flags.
;459:	 */
;460:	VectorAdd(
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
line 465
;461:		assault.points[0],
;462:		assault.points[2],
;463:		midpoint
;464:	);
;465:	VectorScale( midpoint, 0.5f, midpoint );
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
line 467
;466:
;467:	AssaultGroundOrigin( midpoint, origin );
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 468
;468:	*area = AssaultPointAreaNum( origin );
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
line 469
;469:	*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 471
;470:
;471:	return *area != 0;
ADDRFP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $242
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $243
JUMPV
LABELV $242
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $243
ADDRLP4 36
INDIRI4
RETI4
LABELV $176
endproc AssaultSelectMiddlePoint 44 24
proc AssaultRemoveMapClass 8 12
line 476
;472:}
;473:
;474:static void AssaultRemoveMapClass(
;475:	const char *classname
;476:) {
line 479
;477:	gentity_t *ent;
;478:
;479:	ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $246
JUMPV
LABELV $245
line 485
;480:
;481:	while( (ent = G_Find(
;482:		ent,
;483:		FOFS(classname),
;484:		classname
;485:	)) != NULL ) {
line 486
;486:		G_FreeEntity( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 487
;487:	}
LABELV $246
line 481
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
NEU4 $245
line 488
;488:}
LABELV $244
endproc AssaultRemoveMapClass 8 12
proc AssaultSetupBasePoints 24 20
line 490
;489:
;490:static qboolean AssaultSetupBasePoints( void ) {
line 495
;491:	int selectedItem;
;492:	int unusedItem;
;493:	int i;
;494:
;495:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 500
;496:
;497:	/*
;498:	 * A: blue flag.
;499:	 */
;500:	if( !AssaultPickClassname(
ADDRGP4 $252
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
NEI4 $250
line 506
;501:		"team_CTF_blueflag",
;502:		-1,
;503:		assault.points[0],
;504:		&assault.pointAreas[0],
;505:		&unusedItem
;506:	) ) {
line 507
;507:		G_Printf(
ADDRGP4 $255
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 510
;508:			"Assault: blue flag position not found.\n"
;509:		);
;510:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $248
JUMPV
LABELV $250
line 513
;511:	}
;512:
;513:	assault.pointSet[0] = qtrue;
ADDRGP4 assault+52
CNSTI4 1
ASGNI4
line 518
;514:
;515:	/*
;516:	 * C: red flag.
;517:	 */
;518:	if( !AssaultPickClassname(
ADDRGP4 $259
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
NEI4 $257
line 524
;519:		"team_CTF_redflag",
;520:		-1,
;521:		assault.points[2],
;522:		&assault.pointAreas[2],
;523:		&unusedItem
;524:	) ) {
line 525
;525:		G_Printf(
ADDRGP4 $264
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 528
;526:			"Assault: red flag position not found.\n"
;527:		);
;528:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $248
JUMPV
LABELV $257
line 531
;529:	}
;530:
;531:	assault.pointSet[2] = qtrue;
ADDRGP4 assault+52+8
CNSTI4 1
ASGNI4
line 536
;532:
;533:	/*
;534:	 * B: selected item or automatic fallback.
;535:	 */
;536:	if( !AssaultSelectMiddlePoint(
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
NEI4 $267
line 540
;537:		assault.points[1],
;538:		&assault.pointAreas[1],
;539:		&selectedItem
;540:	) ) {
line 541
;541:		G_Printf(
ADDRGP4 $273
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 544
;542:			"Assault: unable to create point B.\n"
;543:		);
;544:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $248
JUMPV
LABELV $267
line 547
;545:	}
;546:
;547:	assault.pointSet[1] = qtrue;
ADDRGP4 assault+52+4
CNSTI4 1
ASGNI4
line 552
;548:
;549:	/*
;550:	 * Flags are anchors only; remove their normal entities.
;551:	 */
;552:	AssaultRemoveMapClass(
ADDRGP4 $252
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 555
;553:		"team_CTF_blueflag"
;554:	);
;555:	AssaultRemoveMapClass(
ADDRGP4 $259
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 559
;556:		"team_CTF_redflag"
;557:	);
;558:
;559:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $279
JUMPV
LABELV $276
line 560
;560:		AssaultCreateOrMoveMarker( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 561
;561:	}
LABELV $277
line 559
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $279
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $276
line 563
;562:
;563:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $281
line 564
;564:		G_Printf(
ADDRGP4 $283
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
line 568
;565:			"Assault: point B placed at %s.\n",
;566:			assaultMiddleNames[selectedItem]
;567:		);
;568:	}
ADDRGP4 $282
JUMPV
LABELV $281
line 569
;569:	else {
line 570
;570:		G_Printf(
ADDRGP4 $284
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 573
;571:			"Assault: point B placed at map midpoint.\n"
;572:		);
;573:	}
LABELV $282
line 575
;574:
;575:	return qtrue;
CNSTI4 1
RETI4
LABELV $248
endproc AssaultSetupBasePoints 24 20
proc AssaultSetupTDMBasePoints 32 12
line 578
;576:}
;577:
;578:static qboolean AssaultSetupTDMBasePoints( void ) {
line 584
;579:	gentity_t *redSpot;
;580:	gentity_t *blueSpot;
;581:	int selectedItem;
;582:	int i;
;583:
;584:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 586
;585:
;586:	if( !G_FindAutomaticBaseSpots(
ADDRLP4 8
ARGP4
ADDRLP4 12
ARGP4
ADDRLP4 16
ADDRGP4 G_FindAutomaticBaseSpots
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $287
line 589
;587:		&redSpot,
;588:		&blueSpot
;589:	) ) {
line 590
;590:		G_Printf(
ADDRGP4 $289
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 593
;591:			"Assault TDM: map needs at least two spawn points.\n"
;592:		);
;593:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $287
line 599
;594:	}
;595:
;596:	/*
;597:	 * A: blue team's automatic base.
;598:	 */
;599:	AssaultGroundOrigin(
ADDRLP4 12
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRGP4 assault+4
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 604
;600:		blueSpot->s.origin,
;601:		assault.points[0]
;602:	);
;603:
;604:	assault.pointAreas[0] =
ADDRGP4 assault+4
ARGP4
ADDRLP4 20
ADDRGP4 AssaultPointAreaNum
CALLI4
ASGNI4
ADDRGP4 assault+40
ADDRLP4 20
INDIRI4
ASGNI4
line 607
;605:		AssaultPointAreaNum(assault.points[0]);
;606:
;607:	if( !assault.pointAreas[0] ) {
ADDRGP4 assault+40
INDIRI4
CNSTI4 0
NEI4 $293
line 608
;608:		G_Printf(
ADDRGP4 $296
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 611
;609:			"Assault TDM: point A has no reachable AAS area.\n"
;610:		);
;611:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $293
line 614
;612:	}
;613:
;614:	assault.pointSet[0] = qtrue;
ADDRGP4 assault+52
CNSTI4 1
ASGNI4
line 619
;615:
;616:	/*
;617:	 * C: red team's automatic base.
;618:	 */
;619:	AssaultGroundOrigin(
ADDRLP4 8
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRGP4 assault+4+24
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 624
;620:		redSpot->s.origin,
;621:		assault.points[2]
;622:	);
;623:
;624:	assault.pointAreas[2] =
ADDRGP4 assault+4+24
ARGP4
ADDRLP4 24
ADDRGP4 AssaultPointAreaNum
CALLI4
ASGNI4
ADDRGP4 assault+40+8
ADDRLP4 24
INDIRI4
ASGNI4
line 627
;625:		AssaultPointAreaNum(assault.points[2]);
;626:
;627:	if( !assault.pointAreas[2] ) {
ADDRGP4 assault+40+8
INDIRI4
CNSTI4 0
NEI4 $304
line 628
;628:		G_Printf(
ADDRGP4 $308
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 631
;629:			"Assault TDM: point C has no reachable AAS area.\n"
;630:		);
;631:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $304
line 634
;632:	}
;633:
;634:	assault.pointSet[2] = qtrue;
ADDRGP4 assault+52+8
CNSTI4 1
ASGNI4
line 639
;635:
;636:	/*
;637:	 * B: selected map item or automatic fallback.
;638:	 */
;639:	if( !AssaultSelectMiddlePoint(
ADDRGP4 assault+4+12
ARGP4
ADDRGP4 assault+40+4
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 28
ADDRGP4 AssaultSelectMiddlePoint
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $311
line 643
;640:		assault.points[1],
;641:		&assault.pointAreas[1],
;642:		&selectedItem
;643:	) ) {
line 644
;644:		G_Printf(
ADDRGP4 $317
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 647
;645:			"Assault TDM: unable to create point B.\n"
;646:		);
;647:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $285
JUMPV
LABELV $311
line 650
;648:	}
;649:
;650:	assault.pointSet[1] = qtrue;
ADDRGP4 assault+52+4
CNSTI4 1
ASGNI4
line 652
;651:
;652:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $323
JUMPV
LABELV $320
line 653
;653:		AssaultCreateOrMoveMarker( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 654
;654:	}
LABELV $321
line 652
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $323
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $320
line 656
;655:
;656:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $325
line 657
;657:		G_Printf(
ADDRGP4 $327
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
line 661
;658:			"Assault TDM: point B placed at %s.\n",
;659:			assaultMiddleNames[selectedItem]
;660:		);
;661:	}
ADDRGP4 $326
JUMPV
LABELV $325
line 662
;662:	else {
line 663
;663:		G_Printf(
ADDRGP4 $328
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 666
;664:			"Assault TDM: point B placed at map midpoint.\n"
;665:		);
;666:	}
LABELV $326
line 668
;667:
;668:	return qtrue;
CNSTI4 1
RETI4
LABELV $285
endproc AssaultSetupTDMBasePoints 32 12
proc AssaultTracePlacement 112 28
line 674
;669:}
;670:
;671:static qboolean AssaultTracePlacement(
;672:	gentity_t *ent,
;673:	vec3_t result
;674:) {
line 680
;675:	trace_t trace;
;676:	vec3_t start;
;677:	vec3_t end;
;678:	vec3_t forward;
;679:
;680:	VectorCopy( ent->client->ps.origin, start );
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
line 682
;681:
;682:	if( ent->client->ps.viewheight ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $330
line 683
;683:		start[2] += ent->client->ps.viewheight;
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
line 684
;684:	}
ADDRGP4 $331
JUMPV
LABELV $330
line 685
;685:	else {
line 686
;686:		start[2] += 26;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1104150528
ADDF4
ASGNF4
line 687
;687:	}
LABELV $331
line 689
;688:
;689:	AngleVectors(
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
line 696
;690:		ent->client->ps.viewangles,
;691:		forward,
;692:		NULL,
;693:		NULL
;694:	);
;695:
;696:	VectorMA( start, 8192.0f, forward, end );
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
line 698
;697:
;698:	trap_Trace(
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
CNSTI4 884
DIVI4
ARGI4
CNSTI4 1
ARGI4
ADDRGP4 trap_Trace
CALLV
pop
line 708
;699:		&trace,
;700:		start,
;701:		NULL,
;702:		NULL,
;703:		end,
;704:		ent - g_entities,
;705:		MASK_SOLID
;706:	);
;707:
;708:	if( trace.startsolid ||
ADDRLP4 104
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $347
ADDRLP4 0
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $347
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $347
ADDRLP4 0+44
INDIRI4
CNSTI4 4
BANDI4
ADDRLP4 104
INDIRI4
EQI4 $340
LABELV $347
line 711
;709:		trace.allsolid ||
;710:		trace.fraction == 1.0f ||
;711:		(trace.surfaceFlags & SURF_SKY) ) {
line 712
;712:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $329
JUMPV
LABELV $340
line 715
;713:	}
;714:
;715:	VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 716
;716:	result[2] += 8.0f;
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
line 718
;717:
;718:	return qtrue;
CNSTI4 1
RETI4
LABELV $329
endproc AssaultTracePlacement 112 28
proc AssaultClaimEditor 8 8
line 721
;719:}
;720:
;721:static qboolean AssaultClaimEditor( gentity_t *ent ) {
line 724
;722:	int clientNum;
;723:
;724:	clientNum = ent - g_entities;
ADDRLP4 0
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ASGNI4
line 726
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
EQI4 $350
line 727
;727:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $349
JUMPV
LABELV $350
line 730
;728:	}
;729:
;730:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $352
line 731
;731:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $354
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 735
;732:			clientNum,
;733:			"print \"Point placement requires spectator mode.\n\""
;734:		);
;735:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $349
JUMPV
LABELV $352
line 738
;736:	}
;737:
;738:	if( assault.editorClient == -1 ) {
ADDRGP4 assault+336
INDIRI4
CNSTI4 -1
NEI4 $355
line 739
;739:		assault.editorClient = clientNum;
ADDRGP4 assault+336
ADDRLP4 0
INDIRI4
ASGNI4
line 741
;740:
;741:		trap_SendServerCommand(
ADDRGP4 $359
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
line 748
;742:			-1,
;743:			va(
;744:				"print \"%s is placing Assault points.\n\"",
;745:				ent->client->pers.netname
;746:			)
;747:		);
;748:	}
LABELV $355
line 750
;749:
;750:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $360
line 751
;751:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $363
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 755
;752:			clientNum,
;753:			"print \"Another player is placing the points.\n\""
;754:		);
;755:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $349
JUMPV
LABELV $360
line 758
;756:	}
;757:
;758:	return qtrue;
CNSTI4 1
RETI4
LABELV $349
endproc AssaultClaimEditor 8 8
proc AssaultPlacePoint 44 8
line 761
;759:}
;760:
;761:static void AssaultPlacePoint( gentity_t *ent, int point ) {
line 767
;762:	vec3_t origin;
;763:	int otherPoint;
;764:	int area;
;765:	int clientNum;
;766:
;767:	clientNum = ent - g_entities;
ADDRLP4 16
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ASGNI4
line 769
;768:
;769:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $365
line 770
;770:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $367
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 774
;771:			clientNum,
;772:			"print \"The match has already started.\n\""
;773:		);
;774:		return;
ADDRGP4 $364
JUMPV
LABELV $365
line 777
;775:	}
;776:
;777:	if( point < 0 || point >= assault.pointCount ) {
ADDRLP4 24
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
LTI4 $371
ADDRLP4 24
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $368
LABELV $371
line 778
;778:		trap_SendServerCommand(
ADDRGP4 $372
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
line 785
;779:			clientNum,
;780:			va(
;781:				"print \"Point number must be from 1 to %i.\n\"",
;782:				assault.pointCount
;783:			)
;784:		);
;785:		return;
ADDRGP4 $364
JUMPV
LABELV $368
line 788
;786:	}
;787:
;788:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $374
line 789
;789:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $377
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 793
;790:			clientNum,
;791:			"print \"Use /assault_edit first.\n\""
;792:		);
;793:		return;
ADDRGP4 $364
JUMPV
LABELV $374
line 796
;794:	}
;795:
;796:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $378
line 797
;797:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $354
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 801
;798:			clientNum,
;799:			"print \"Point placement requires spectator mode.\n\""
;800:		);
;801:		return;
ADDRGP4 $364
JUMPV
LABELV $378
line 804
;802:	}
;803:
;804:	if( !AssaultTracePlacement(ent, origin) ) {
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
NEI4 $380
line 805
;805:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $382
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 809
;806:			clientNum,
;807:			"print \"Unable to place a point there.\n\""
;808:		);
;809:		return;
ADDRGP4 $364
JUMPV
LABELV $380
line 812
;810:	}
;811:
;812:	for( otherPoint = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $386
JUMPV
LABELV $383
line 814
;813:		otherPoint < assault.pointCount;
;814:		otherPoint++ ) {
line 815
;815:		if( otherPoint == point ||
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $391
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $388
LABELV $391
line 816
;816:			!assault.pointSet[otherPoint] ) {
line 817
;817:			continue;
ADDRGP4 $384
JUMPV
LABELV $388
line 820
;818:		}
;819:
;820:		if( DistanceSquared(
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
GEF4 $392
line 825
;821:			origin,
;822:			assault.points[otherPoint]
;823:		) <
;824:			ASSAULT_MIN_POINT_DISTANCE *
;825:			ASSAULT_MIN_POINT_DISTANCE ) {
line 826
;826:			trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $395
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 830
;827:				clientNum,
;828:				"print \"The points are too close together.\n\""
;829:			);
;830:			return;
ADDRGP4 $364
JUMPV
LABELV $392
line 832
;831:		}
;832:	}
LABELV $384
line 814
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $386
line 813
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $383
line 834
;833:
;834:	area = AssaultPointAreaNum( origin );
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
line 836
;835:
;836:	VectorCopy( origin, assault.points[point] );
CNSTI4 12
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 837
;837:	assault.pointAreas[point] = area;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 838
;838:	assault.pointSet[point] = qtrue;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 1
ASGNI4
line 840
;839:
;840:	AssaultCreateOrMoveMarker( point );
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 842
;841:
;842:	trap_SendServerCommand(
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $399
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
line 850
;843:		-1,
;844:		va(
;845:			"cp \"Assault point %s placed\"",
;846:			AssaultPointName(point)
;847:		)
;848:	);
;849:
;850:	if( !area ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $400
line 851
;851:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $402
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 855
;852:			clientNum,
;853:			"print \"Warning: the point has no AAS area; bots may not reach it.\n\""
;854:		);
;855:	}
LABELV $400
line 856
;856:}
LABELV $364
endproc AssaultPlacePoint 44 8
proc AssaultRespawnTeams 16 4
line 858
;857:
;858:static void AssaultRespawnTeams( void ) {
line 862
;859:	int i;
;860:	gentity_t *ent;
;861:
;862:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $407
JUMPV
LABELV $404
line 863
;863:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 865
;864:
;865:		if( !ent->client ||
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
EQU4 $411
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $409
LABELV $411
line 866
;866:			ent->client->pers.connected != CON_CONNECTED ) {
line 867
;867:			continue;
ADDRGP4 $405
JUMPV
LABELV $409
line 870
;868:		}
;869:
;870:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $412
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $412
line 871
;871:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 872
;872:			continue;
ADDRGP4 $405
JUMPV
LABELV $412
line 875
;873:		}
;874:
;875:		ClientSpawn( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 ClientSpawn
CALLV
pop
line 876
;876:	}
LABELV $405
line 862
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $407
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $404
line 877
;877:}
LABELV $403
endproc AssaultRespawnTeams 16 4
proc AssaultStartRound 24 12
line 879
;878:
;879:static void AssaultStartRound( team_t attackingTeam ) {
line 882
;880:	int normalLimit;
;881:
;882:	assault.attackingTeam = attackingTeam;
ADDRGP4 assault+368
ADDRFP4 0
INDIRI4
ASGNI4
line 883
;883:	assault.activeStage = 0;
ADDRGP4 assault+340
CNSTI4 0
ASGNI4
line 884
;884:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 885
;885:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 886
;886:	assault.roundStartTime = level.time;
ADDRGP4 assault+352
ADDRGP4 level+32
INDIRI4
ASGNI4
line 887
;887:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 889
;888:
;889:	if( g_timelimit.value > 0.0f ) {
ADDRGP4 g_timelimit+8
INDIRF4
CNSTF4 0
LEF4 $423
line 890
;890:		normalLimit =
ADDRLP4 0
CNSTF4 1198153728
ADDRGP4 g_timelimit+8
INDIRF4
MULF4
CVFI4 4
ASGNI4
line 892
;891:			(int)(g_timelimit.value * 60000.0f);
;892:	}
ADDRGP4 $424
JUMPV
LABELV $423
line 893
;893:	else {
line 894
;894:		normalLimit = 7 * 60 * 1000;
ADDRLP4 0
CNSTI4 420000
ASGNI4
line 895
;895:	}
LABELV $424
line 897
;896:
;897:	if( normalLimit < 30000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 30000
GEI4 $427
line 898
;898:		normalLimit = 30000;
ADDRLP4 0
CNSTI4 30000
ASGNI4
line 899
;899:	}
LABELV $427
line 901
;900:
;901:	assault.roundLimit = normalLimit;
ADDRGP4 assault+356
ADDRLP4 0
INDIRI4
ASGNI4
line 903
;902:
;903:	if( attackingTeam == TEAM_RED ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $430
line 904
;904:		assault.phase = ASSAULT_ROUND_RED;
ADDRGP4 assault
CNSTI4 1
ASGNI4
line 905
;905:	}
ADDRGP4 $431
JUMPV
LABELV $430
line 906
;906:	else {
line 907
;907:		assault.phase = ASSAULT_ROUND_BLUE;
ADDRGP4 assault
CNSTI4 2
ASGNI4
line 912
;908:
;909:		/*
;910:		 * If Red completed the route, Blue must beat Red's time.
;911:		 */
;912:		if( assault.redResult.completedPoints == assault.pointCount &&
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $432
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+356
INDIRI4
GEI4 $432
line 914
;913:			assault.redResult.elapsedTime <
;914:			assault.roundLimit ) {
line 915
;915:			assault.roundLimit =
ADDRGP4 assault+356
ADDRGP4 assault+372+8
INDIRI4
ASGNI4
line 917
;916:				assault.redResult.elapsedTime;
;917:		}
LABELV $432
line 918
;918:	}
LABELV $431
line 920
;919:
;920:	level.startTime = level.time;
ADDRGP4 level+40
ADDRGP4 level+32
INDIRI4
ASGNI4
line 921
;921:	trap_SetConfigstring(
ADDRGP4 $444
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
line 926
;922:		CS_LEVEL_START_TIME,
;923:		va("%i", level.startTime)
;924:	);
;925:
;926:	AssaultRespawnTeams();
ADDRGP4 AssaultRespawnTeams
CALLV
pop
line 927
;927:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 929
;928:
;929:	trap_SendServerCommand(
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
ADDRGP4 $446
ARGP4
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $450
ADDRLP4 8
ADDRGP4 $447
ASGNP4
ADDRGP4 $451
JUMPV
LABELV $450
ADDRLP4 8
ADDRGP4 $448
ASGNP4
LABELV $451
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
line 937
;930:		-1,
;931:		va(
;932:			"cp \"%s attacks point %s\"",
;933:			attackingTeam == TEAM_RED ? "Red" : "Blue",
;934:			AssaultPointName(AssaultActualPoint())
;935:		)
;936:	);
;937:}
LABELV $414
endproc AssaultStartRound 24 12
proc AssaultUpdateScores 16 8
line 939
;938:
;939:static void AssaultUpdateScores( void ) {
line 940
;940:	level.teamScores[TEAM_RED] =
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $458
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $459
JUMPV
LABELV $458
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $459
ADDRGP4 level+44+4
ADDRLP4 0
INDIRI4
ASGNI4
line 944
;941:		assault.redResult.completedPoints ==
;942:		assault.pointCount ? 1 : 0;
;943:
;944:	level.teamScores[TEAM_BLUE] =
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $465
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $466
JUMPV
LABELV $465
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $466
ADDRGP4 level+44+8
ADDRLP4 4
INDIRI4
ASGNI4
line 948
;945:		assault.blueResult.completedPoints ==
;946:		assault.pointCount ? 1 : 0;
;947:
;948:	trap_SetConfigstring(
ADDRGP4 $444
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
line 953
;949:		CS_SCORES1,
;950:		va("%i", level.teamScores[TEAM_RED])
;951:	);
;952:
;953:	trap_SetConfigstring(
ADDRGP4 $444
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
line 958
;954:		CS_SCORES2,
;955:		va("%i", level.teamScores[TEAM_BLUE])
;956:	);
;957:
;958:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 959
;959:}
LABELV $452
endproc AssaultUpdateScores 16 8
proc AssaultFinishMatch 4 8
line 961
;960:
;961:static void AssaultFinishMatch( void ) {
line 964
;962:	int winner;
;963:
;964:	winner = TEAM_FREE;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 966
;965:
;966:	if( assault.redResult.completedPoints >
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+384
INDIRI4
LEI4 $472
line 967
;967:		assault.blueResult.completedPoints ) {
line 968
;968:		winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 969
;969:	}
ADDRGP4 $473
JUMPV
LABELV $472
line 970
;970:	else if( assault.blueResult.completedPoints >
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+372
INDIRI4
LEI4 $476
line 971
;971:		assault.redResult.completedPoints ) {
line 972
;972:		winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 973
;973:	}
ADDRGP4 $477
JUMPV
LABELV $476
line 974
;974:	else if( assault.redResult.completedPoints == assault.pointCount ) {
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $480
line 975
;975:		if( assault.redResult.elapsedTime <
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+384+8
INDIRI4
GEI4 $484
line 976
;976:			assault.blueResult.elapsedTime ) {
line 977
;977:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 978
;978:		}
ADDRGP4 $481
JUMPV
LABELV $484
line 979
;979:		else if( assault.blueResult.elapsedTime <
ADDRGP4 assault+384+8
INDIRI4
ADDRGP4 assault+372+8
INDIRI4
GEI4 $481
line 980
;980:			assault.redResult.elapsedTime ) {
line 981
;981:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 982
;982:		}
line 983
;983:	}
ADDRGP4 $481
JUMPV
LABELV $480
line 984
;984:	else {
line 985
;985:		if( assault.redResult.progress >
ADDRGP4 assault+372+4
INDIRI4
ADDRGP4 assault+384+4
INDIRI4
LEI4 $496
line 986
;986:			assault.blueResult.progress ) {
line 987
;987:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 988
;988:		}
ADDRGP4 $497
JUMPV
LABELV $496
line 989
;989:		else if( assault.blueResult.progress >
ADDRGP4 assault+384+4
INDIRI4
ADDRGP4 assault+372+4
INDIRI4
LEI4 $502
line 990
;990:			assault.redResult.progress ) {
line 991
;991:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 992
;992:		}
LABELV $502
LABELV $497
line 993
;993:	}
LABELV $481
LABELV $477
LABELV $473
line 995
;994:
;995:	assault.phase = ASSAULT_FINISHED;
ADDRGP4 assault
CNSTI4 3
ASGNI4
line 997
;996:
;997:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 999
;998:
;999:	if( winner == TEAM_RED ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $508
line 1000
;1000:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $510
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1004
;1001:			-1,
;1002:			"cp \"Red team wins Assault\""
;1003:		);
;1004:		LogExit( "Red team won Assault." );
ADDRGP4 $511
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1005
;1005:	}
ADDRGP4 $509
JUMPV
LABELV $508
line 1006
;1006:	else if( winner == TEAM_BLUE ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $512
line 1007
;1007:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $514
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1011
;1008:			-1,
;1009:			"cp \"Blue team wins Assault\""
;1010:		);
;1011:		LogExit( "Blue team won Assault." );
ADDRGP4 $515
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1012
;1012:	}
ADDRGP4 $513
JUMPV
LABELV $512
line 1013
;1013:	else {
line 1014
;1014:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $516
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1018
;1015:			-1,
;1016:			"cp \"Assault ended in a draw\""
;1017:		);
;1018:		LogExit( "Assault draw." );
ADDRGP4 $517
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 1019
;1019:	}
LABELV $513
LABELV $509
line 1020
;1020:}
LABELV $471
endproc AssaultFinishMatch 4 8
proc AssaultStoreRoundResult 4 4
line 1022
;1021:
;1022:static void AssaultStoreRoundResult( qboolean completed ) {
line 1025
;1023:	assaultResult_t *result;
;1024:
;1025:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $519
line 1026
;1026:		result = &assault.redResult;
ADDRLP4 0
ADDRGP4 assault+372
ASGNP4
line 1027
;1027:	}
ADDRGP4 $520
JUMPV
LABELV $519
line 1028
;1028:	else {
line 1029
;1029:		result = &assault.blueResult;
ADDRLP4 0
ADDRGP4 assault+384
ASGNP4
line 1030
;1030:	}
LABELV $520
line 1032
;1031:
;1032:	if( completed ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
EQI4 $524
line 1033
;1033:		result->completedPoints = assault.pointCount;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+332
INDIRI4
ASGNI4
line 1034
;1034:		result->progress = (int)(g_assaultHoldTime.value * 1000.0f);
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
line 1035
;1035:		result->elapsedTime =
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
line 1037
;1036:			level.time - assault.roundStartTime;
;1037:	}
ADDRGP4 $525
JUMPV
LABELV $524
line 1038
;1038:	else {
line 1039
;1039:		result->completedPoints = assault.activeStage;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+340
INDIRI4
ASGNI4
line 1040
;1040:		result->progress = assault.captureProgress;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 assault+344
INDIRI4
ASGNI4
line 1041
;1041:		result->elapsedTime = assault.roundLimit;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 assault+356
INDIRI4
ASGNI4
line 1042
;1042:	}
LABELV $525
line 1047
;1043:
;1044:	/*
;1045:	 * Update team scores only after storing the round result.
;1046:	 */
;1047:	AssaultUpdateScores();
ADDRGP4 AssaultUpdateScores
CALLV
pop
line 1049
;1048:
;1049:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $533
line 1050
;1050:		AssaultStartRound( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1051
;1051:	}
ADDRGP4 $534
JUMPV
LABELV $533
line 1052
;1052:	else {
line 1053
;1053:		AssaultFinishMatch();
ADDRGP4 AssaultFinishMatch
CALLV
pop
line 1054
;1054:	}
LABELV $534
line 1055
;1055:}
LABELV $518
endproc AssaultStoreRoundResult 4 4
proc AssaultCompletePoint 32 8
line 1057
;1056:
;1057:static void AssaultCompletePoint( void ) {
line 1060
;1058:	int completedPoint;
;1059:
;1060:	completedPoint = AssaultActualPoint();
ADDRLP4 4
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 1062
;1061:
;1062:	trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $537
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
line 1070
;1063:		-1,
;1064:		va(
;1065:			"cp \"Point %s captured\"",
;1066:			AssaultPointName(completedPoint)
;1067:		)
;1068:	);
;1069:
;1070:	assault.activeStage++;
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
line 1071
;1071:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1072
;1072:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 1074
;1073:
;1074:	if( assault.activeStage >= assault.pointCount ) {
ADDRGP4 assault+340
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $541
line 1075
;1075:		AssaultStoreRoundResult( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1076
;1076:		return;
ADDRGP4 $536
JUMPV
LABELV $541
line 1079
;1077:	}
;1078:
;1079:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 1081
;1080:
;1081:	trap_SendServerCommand(
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
ADDRGP4 $545
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
line 1088
;1082:		-1,
;1083:		va(
;1084:			"cp \"Attack point %s\"",
;1085:			AssaultPointName(AssaultActualPoint())
;1086:		)
;1087:	);
;1088:}
LABELV $536
endproc AssaultCompletePoint 32 8
proc AssaultCountPlayers 28 8
line 1094
;1089:
;1090:static void AssaultCountPlayers(
;1091:	int point,
;1092:	int *attackers,
;1093:	int *defenders
;1094:) {
line 1099
;1095:	int i;
;1096:	float radiusSquared;
;1097:	gentity_t *ent;
;1098:
;1099:	*attackers = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 1100
;1100:	*defenders = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
line 1102
;1101:
;1102:	radiusSquared =
ADDRLP4 8
ADDRGP4 g_assaultRadius+8
INDIRF4
ADDRGP4 g_assaultRadius+8
INDIRF4
MULF4
ASGNF4
line 1106
;1103:		g_assaultRadius.value *
;1104:		g_assaultRadius.value;
;1105:
;1106:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $552
JUMPV
LABELV $549
line 1107
;1107:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1109
;1108:
;1109:		if( !ent->client ||
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
EQU4 $557
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $557
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $554
LABELV $557
line 1111
;1110:			ent->client->pers.connected != CON_CONNECTED ||
;1111:			ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
line 1112
;1112:			continue;
ADDRGP4 $550
JUMPV
LABELV $554
line 1115
;1113:		}
;1114:
;1115:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $558
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $558
line 1116
;1116:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 1117
;1117:			continue;
ADDRGP4 $550
JUMPV
LABELV $558
line 1120
;1118:		}
;1119:
;1120:		if( DistanceSquared(
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
LEF4 $560
line 1123
;1121:			ent->client->ps.origin,
;1122:			assault.points[point]
;1123:		) > radiusSquared ) {
line 1124
;1124:			continue;
ADDRGP4 $550
JUMPV
LABELV $560
line 1127
;1125:		}
;1126:
;1127:		if( ent->client->sess.sessionTeam ==
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
NEI4 $563
line 1128
;1128:			assault.attackingTeam ) {
line 1129
;1129:			(*attackers)++;
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
line 1130
;1130:		}
ADDRGP4 $564
JUMPV
LABELV $563
line 1131
;1131:		else {
line 1132
;1132:			(*defenders)++;
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
line 1133
;1133:		}
LABELV $564
line 1134
;1134:	}
LABELV $550
line 1106
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $552
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $549
line 1135
;1135:}
LABELV $546
endproc AssaultCountPlayers 28 8
proc AssaultStartMatch 20 12
line 1137
;1136:
;1137:static void AssaultStartMatch( gentity_t *ent ) {
line 1141
;1138:	int clientNum;
;1139:	int i;
;1140:
;1141:	clientNum = ent ? ent - g_entities : -1;
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $568
ADDRLP4 8
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ASGNI4
ADDRGP4 $569
JUMPV
LABELV $568
ADDRLP4 8
CNSTI4 -1
ASGNI4
LABELV $569
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1143
;1142:
;1143:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $570
line 1144
;1144:		ASSAULT_MODE_EDITOR ) {
line 1145
;1145:		if( !ent ||
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $576
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $573
LABELV $576
line 1146
;1146:			assault.editorClient != clientNum ) {
line 1147
;1147:			trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $577
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1151
;1148:				clientNum,
;1149:				"print \"Only the point editor can start the match.\n\""
;1150:			);
;1151:			return;
ADDRGP4 $566
JUMPV
LABELV $573
line 1153
;1152:		}
;1153:	}
LABELV $570
line 1155
;1154:
;1155:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $581
JUMPV
LABELV $578
line 1156
;1156:		if( !assault.pointSet[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $583
line 1157
;1157:			trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $586
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
line 1164
;1158:				clientNum,
;1159:				va(
;1160:					"print \"Assault: points are invalid. Point %s is missing.\n\"",
;1161:					AssaultPointName(i)
;1162:				)
;1163:			);
;1164:			return;
ADDRGP4 $566
JUMPV
LABELV $583
line 1166
;1165:		}
;1166:	}
LABELV $579
line 1155
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $581
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $578
line 1168
;1167:
;1168:	if( TeamCount(-1, TEAM_RED) < 1 ||
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
LTI4 $589
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
GEI4 $587
LABELV $589
line 1169
;1169:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1170
;1170:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $590
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1174
;1171:			clientNum,
;1172:			"print \"Both teams need at least one player.\n\""
;1173:		);
;1174:		return;
ADDRGP4 $566
JUMPV
LABELV $587
line 1177
;1175:	}
;1176:
;1177:	level.warmupTime = 0;
ADDRGP4 level+16
CNSTI4 0
ASGNI4
line 1178
;1178:	trap_SetConfigstring( CS_WARMUP, "0" );
CNSTI4 5
ARGI4
ADDRGP4 $592
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1180
;1179:
;1180:	memset(
ADDRGP4 assault+372
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1185
;1181:		&assault.redResult,
;1182:		0,
;1183:		sizeof(assault.redResult)
;1184:	);
;1185:	memset(
ADDRGP4 assault+384
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1191
;1186:		&assault.blueResult,
;1187:		0,
;1188:		sizeof(assault.blueResult)
;1189:	);
;1190:	
;1191:	level.teamScores[TEAM_RED] = 0;
ADDRGP4 level+44+4
CNSTI4 0
ASGNI4
line 1192
;1192:	level.teamScores[TEAM_BLUE] = 0;
ADDRGP4 level+44+8
CNSTI4 0
ASGNI4
line 1194
;1193:
;1194:	trap_SetConfigstring( CS_SCORES1, "0" );
CNSTI4 6
ARGI4
ADDRGP4 $592
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1195
;1195:	trap_SetConfigstring( CS_SCORES2, "0" );
CNSTI4 7
ARGI4
ADDRGP4 $592
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1197
;1196:
;1197:	AssaultStartRound( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1198
;1198:}
LABELV $566
endproc AssaultStartMatch 20 12
proc AssaultSetPointCount 24 12
line 1204
;1199:
;1200:
;1201:static void AssaultSetPointCount(
;1202:	gentity_t *ent,
;1203:	int pointCount
;1204:) {
line 1208
;1205:	int i;
;1206:	int clientNum;
;1207:
;1208:	clientNum = ent - g_entities;
ADDRLP4 4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ASGNI4
line 1210
;1209:
;1210:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $602
line 1211
;1211:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $367
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1215
;1212:			clientNum,
;1213:			"print \"The match has already started.\n\""
;1214:		);
;1215:		return;
ADDRGP4 $601
JUMPV
LABELV $602
line 1218
;1216:	}
;1217:
;1218:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $604
line 1219
;1219:		return;
ADDRGP4 $601
JUMPV
LABELV $604
line 1222
;1220:	}
;1221:
;1222:	if( pointCount < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $608
ADDRLP4 8
INDIRI4
CNSTI4 3
LEI4 $606
LABELV $608
line 1223
;1223:		pointCount > ASSAULT_MAX_POINTS ) {
line 1224
;1224:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $609
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1228
;1225:			clientNum,
;1226:			"print \"Usage: /assault_set 1|2|3\n\""
;1227:		);
;1228:		return;
ADDRGP4 $601
JUMPV
LABELV $606
line 1231
;1229:	}
;1230:
;1231:	if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $610
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $610
line 1232
;1232:		assault.editorClient != clientNum ) {
line 1233
;1233:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $614
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1237
;1234:			clientNum,
;1235:			"print \"Another player is editing Assault.\n\""
;1236:		);
;1237:		return;
ADDRGP4 $601
JUMPV
LABELV $610
line 1240
;1238:	}
;1239:
;1240:	for( i = pointCount;
ADDRLP4 0
ADDRFP4 4
INDIRI4
ASGNI4
ADDRGP4 $618
JUMPV
LABELV $615
line 1242
;1241:		i < ASSAULT_MAX_POINTS;
;1242:		i++ ) {
line 1243
;1243:		if( assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $619
line 1244
;1244:			G_FreeEntity( assault.markers[i] );
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
line 1245
;1245:			assault.markers[i] = NULL;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
CNSTP4 0
ASGNP4
line 1246
;1246:		}
LABELV $619
line 1248
;1247:
;1248:		assault.pointSet[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 0
ASGNI4
line 1249
;1249:		assault.pointAreas[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
CNSTI4 0
ASGNI4
line 1250
;1250:		VectorClear( assault.points[i] );
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
line 1251
;1251:	}
LABELV $616
line 1242
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $618
line 1241
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $615
line 1253
;1252:
;1253:	assault.pointCount = pointCount;
ADDRGP4 assault+332
ADDRFP4 4
INDIRI4
ASGNI4
line 1255
;1254:
;1255:	trap_SendServerCommand(
ADDRGP4 $632
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
NEI4 $636
ADDRLP4 12
ADDRGP4 $633
ASGNP4
ADDRGP4 $637
JUMPV
LABELV $636
ADDRLP4 12
ADDRGP4 $634
ASGNP4
LABELV $637
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
line 1263
;1256:		-1,
;1257:		va(
;1258:			"print \"Assault will use %i point%s.\n\"",
;1259:			pointCount,
;1260:			pointCount == 1 ? "" : "s"
;1261:		)
;1262:	);
;1263:}
LABELV $601
endproc AssaultSetPointCount 24 12
export G_AssaultClientCommand
proc G_AssaultClientCommand 1048 12
line 1268
;1264:
;1265:qboolean G_AssaultClientCommand(
;1266:	gentity_t *ent,
;1267:	const char *cmd
;1268:) {
line 1272
;1269:	char arg[MAX_TOKEN_CHARS];
;1270:	int value;
;1271:
;1272:	if( !G_AssaultEnabled() ) {
ADDRLP4 1028
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 1028
INDIRI4
CNSTI4 0
NEI4 $639
line 1273
;1273:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $638
JUMPV
LABELV $639
line 1276
;1274:	}
;1275:
;1276:	if( !Q_stricmp(cmd, "assault_set") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $643
ARGP4
ADDRLP4 1032
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 0
NEI4 $641
line 1277
;1277:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1278
;1278:		AssaultSetPointCount( ent, atoi(arg) );
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
line 1279
;1279:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $638
JUMPV
LABELV $641
line 1282
;1280:	}
;1281:
;1282:	if( !Q_stricmp(cmd, "assault_edit") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $646
ARGP4
ADDRLP4 1036
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1036
INDIRI4
CNSTI4 0
NEI4 $644
line 1283
;1283:		if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $647
line 1284
;1284:			trap_SendServerCommand(
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 884
DIVI4
ARGI4
ADDRGP4 $367
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1288
;1285:				ent - g_entities,
;1286:				"print \"The match has already started.\n\""
;1287:			);
;1288:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $638
JUMPV
LABELV $647
line 1291
;1289:		}
;1290:
;1291:		AssaultClaimEditor( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultClaimEditor
CALLI4
pop
line 1292
;1292:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $638
JUMPV
LABELV $644
line 1295
;1293:	}
;1294:
;1295:	if( !Q_stricmp(cmd, "assault_place") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $651
ARGP4
ADDRLP4 1040
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
NEI4 $649
line 1296
;1296:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1297
;1297:		value = atoi(arg) - 1;
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
line 1298
;1298:		AssaultPlacePoint( ent, value );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1024
INDIRI4
ARGI4
ADDRGP4 AssaultPlacePoint
CALLV
pop
line 1299
;1299:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $638
JUMPV
LABELV $649
line 1302
;1300:	}
;1301:
;1302:	if( !Q_stricmp(cmd, "assault_ready") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $654
ARGP4
ADDRLP4 1044
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1044
INDIRI4
CNSTI4 0
NEI4 $652
line 1303
;1303:		AssaultStartMatch( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1304
;1304:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $638
JUMPV
LABELV $652
line 1307
;1305:	}
;1306:
;1307:	return qfalse;
CNSTI4 0
RETI4
LABELV $638
endproc G_AssaultClientCommand 1048 12
export G_AssaultInit
proc G_AssaultInit 12 12
line 1310
;1308:}
;1309:
;1310:void G_AssaultInit( void ) {
line 1311
;1311:	memset( &assault, 0, sizeof(assault) );
ADDRGP4 assault
ARGP4
CNSTI4 0
ARGI4
CNSTI4 396
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1313
;1312:
;1313:	assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1314
;1314:	assault.phase = ASSAULT_SETUP;
ADDRGP4 assault
CNSTI4 0
ASGNI4
line 1316
;1315:
;1316:	if( !G_AssaultEnabled() ) {
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $657
line 1317
;1317:		return;
ADDRGP4 $655
JUMPV
LABELV $657
line 1320
;1318:	}
;1319:
;1320:	level.warmupTime = -1;
ADDRGP4 level+16
CNSTI4 -1
ASGNI4
line 1321
;1321:	trap_SetConfigstring( CS_WARMUP, "-1" );
CNSTI4 5
ARGI4
ADDRGP4 $660
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1323
;1322:
;1323:if( g_assaultMode.integer == ASSAULT_MODE_BASE ||
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
EQI4 $665
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $661
LABELV $665
line 1324
;1324:	g_assaultMode.integer == ASSAULT_MODE_TDM_BASE ) {
line 1327
;1325:	qboolean setupResult;
;1326:
;1327:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 1329
;1328:
;1329:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $667
line 1330
;1330:		ASSAULT_MODE_TDM_BASE ) {
line 1331
;1331:		setupResult =
ADDRLP4 8
ADDRGP4 AssaultSetupTDMBasePoints
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1333
;1332:			AssaultSetupTDMBasePoints();
;1333:	}
ADDRGP4 $668
JUMPV
LABELV $667
line 1334
;1334:	else {
line 1335
;1335:		setupResult =
ADDRLP4 8
ADDRGP4 AssaultSetupBasePoints
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1337
;1336:			AssaultSetupBasePoints();
;1337:	}
LABELV $668
line 1339
;1338:
;1339:	if( setupResult ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $670
line 1340
;1340:		G_Printf(
ADDRGP4 $672
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1343
;1341:			"Assault: automatic points ready; waiting for teams.\n"
;1342:		);
;1343:	}
ADDRGP4 $655
JUMPV
LABELV $670
line 1344
;1344:	else {
line 1345
;1345:		G_Printf(
ADDRGP4 $673
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1348
;1346:			"Assault: automatic setup failed.\n"
;1347:		);
;1348:	}
line 1350
;1349:
;1350:	return;
ADDRGP4 $655
JUMPV
LABELV $661
line 1353
;1351:}
;1352:
;1353:	assault.pointCount = ASSAULT_DEFAULT_POINTS;
ADDRGP4 assault+332
CNSTI4 2
ASGNI4
line 1355
;1354:
;1355:	G_Printf(
ADDRGP4 $675
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1358
;1356:		"Assault Editor: waiting for point placement.\n"
;1357:	);
;1358:}
LABELV $655
endproc G_AssaultInit 12 12
export G_AssaultBlocksWarmup
proc G_AssaultBlocksWarmup 12 0
line 1360
;1359:
;1360:qboolean G_AssaultBlocksWarmup( void ) {
line 1361
;1361:	return G_AssaultEnabled() &&
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
EQI4 $678
ADDRGP4 assault
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $678
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $679
JUMPV
LABELV $678
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $679
ADDRLP4 0
INDIRI4
RETI4
LABELV $676
endproc G_AssaultBlocksWarmup 12 0
export G_AssaultControlsExitRules
proc G_AssaultControlsExitRules 4 0
line 1365
;1362:		assault.phase == ASSAULT_SETUP;
;1363:}
;1364:
;1365:qboolean G_AssaultControlsExitRules( void ) {
line 1366
;1366:	return G_AssaultEnabled();
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $680
endproc G_AssaultControlsExitRules 4 0
export G_AssaultGetActiveGoal
proc G_AssaultGetActiveGoal 16 0
line 1373
;1367:}
;1368:
;1369:qboolean G_AssaultGetActiveGoal(
;1370:	vec3_t origin,
;1371:	int *area,
;1372:	team_t *attackingTeam
;1373:) {
line 1376
;1374:	int point;
;1375:
;1376:	if( !G_AssaultEnabled() ||
ADDRLP4 4
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $684
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $682
ADDRLP4 8
INDIRI4
CNSTI4 2
EQI4 $682
LABELV $684
line 1378
;1377:		(assault.phase != ASSAULT_ROUND_RED &&
;1378:		 assault.phase != ASSAULT_ROUND_BLUE) ) {
line 1379
;1379:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $681
JUMPV
LABELV $682
line 1382
;1380:	}
;1381:
;1382:	point = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 1384
;1383:
;1384:	VectorCopy( assault.points[point], origin );
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
line 1385
;1385:	*area = assault.pointAreas[point];
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
line 1386
;1386:	*attackingTeam = assault.attackingTeam;
ADDRFP4 8
INDIRP4
ADDRGP4 assault+368
INDIRI4
ASGNI4
line 1388
;1387:
;1388:	return qtrue;
CNSTI4 1
RETI4
LABELV $681
endproc G_AssaultGetActiveGoal 16 0
proc AssaultShowInstructions 12 8
line 1391
;1389:}
;1390:
;1391:static void AssaultShowInstructions( void ) {
line 1395
;1392:	int i;
;1393:	gentity_t *ent;
;1394:
;1395:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $692
JUMPV
LABELV $689
line 1396
;1396:		ent = &g_entities[i];
ADDRLP4 4
CNSTI4 884
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1398
;1397:
;1398:		if( !ent->client ||
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
EQU4 $696
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $694
LABELV $696
line 1399
;1399:			ent->client->pers.connected != CON_CONNECTED ) {
line 1400
;1400:			assault.instructionsShown[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 0
ASGNI4
line 1401
;1401:			continue;
ADDRGP4 $690
JUMPV
LABELV $694
line 1404
;1402:		}
;1403:
;1404:		if( ent->r.svFlags & SVF_BOT ) {
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $698
line 1405
;1405:			continue;
ADDRGP4 $690
JUMPV
LABELV $698
line 1408
;1406:		}
;1407:
;1408:		if( assault.instructionsShown[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
INDIRI4
CNSTI4 0
EQI4 $700
line 1409
;1409:			continue;
ADDRGP4 $690
JUMPV
LABELV $700
line 1412
;1410:		}
;1411:
;1412:		assault.instructionsShown[i] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 1
ASGNI4
line 1414
;1413:
;1414:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $704
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1418
;1415:			i,
;1416:			"print \"\n=== ASSAULT SETUP ===\n\""
;1417:		);
;1418:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $705
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1422
;1419:			i,
;1420:			"print \"Set point count: /assault_set 1, 2 or 3\n\""
;1421:		);
;1422:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $706
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1426
;1423:			i,
;1424:			"print \"Enter spectator mode: /team spectator\n\""
;1425:		);
;1426:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $707
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1430
;1427:			i,
;1428:			"print \"Begin editing: /assault_edit\n\""
;1429:		);
;1430:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $708
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1434
;1431:			i,
;1432:			"print \"Aim and place points: /assault_place 1|2|3\n\""
;1433:		);
;1434:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $709
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1438
;1435:			i,
;1436:			"print \"After placement, join Red or Blue team.\n\""
;1437:		);
;1438:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $710
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1442
;1439:			i,
;1440:			"print \"IMPORTANT: add bots before starting the match.\n\""
;1441:		);
;1442:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $711
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1446
;1443:			i,
;1444:			"print \"Start the match: /assault_ready\n\n\""
;1445:		);
;1446:	}
LABELV $690
line 1395
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $692
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $689
line 1447
;1447:}
LABELV $688
endproc AssaultShowInstructions 12 8
proc AssaultCurrentHoldTime 8 0
line 1449
;1448:
;1449:static int AssaultCurrentHoldTime( void ) {
line 1453
;1450:	int holdTime;
;1451:	int multiplier;
;1452:
;1453:	multiplier = 1 << assault.activeStage;
ADDRLP4 4
CNSTI4 1
ADDRGP4 assault+340
INDIRI4
LSHI4
ASGNI4
line 1455
;1454:
;1455:	holdTime = (int)(
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
line 1461
;1456:		g_assaultHoldTime.value *
;1457:		1000.0f *
;1458:		multiplier
;1459:	);
;1460:
;1461:	if( holdTime < 1000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1000
GEI4 $715
line 1462
;1462:		holdTime = 1000;
ADDRLP4 0
CNSTI4 1000
ASGNI4
line 1463
;1463:	}
LABELV $715
line 1465
;1464:
;1465:	return holdTime;
ADDRLP4 0
INDIRI4
RETI4
LABELV $712
endproc AssaultCurrentHoldTime 8 0
export G_AssaultRunFrame
proc G_AssaultRunFrame 56 12
line 1468
;1466:}
;1467:
;1468:void G_AssaultRunFrame( void ) {
line 1476
;1469:	int point;
;1470:	int attackers;
;1471:	int defenders;
;1472:	int frameTime;
;1473:	int holdTime;
;1474:	int quarter;
;1475:
;1476:	if( !G_AssaultEnabled() ) {
ADDRLP4 24
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $718
line 1477
;1477:		return;
ADDRGP4 $717
JUMPV
LABELV $718
line 1480
;1478:	}
;1479:
;1480:if( assault.phase == ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
NEI4 $720
line 1481
;1481:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $722
line 1482
;1482:		ASSAULT_MODE_EDITOR ) {
line 1483
;1483:		AssaultShowInstructions();
ADDRGP4 AssaultShowInstructions
CALLV
pop
line 1485
;1484:
;1485:		if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $717
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
EQI4 $717
line 1487
;1486:			level.clients[assault.editorClient].
;1487:				pers.connected != CON_CONNECTED ) {
line 1488
;1488:			assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1489
;1489:		}
line 1491
;1490:
;1491:		return;
ADDRGP4 $717
JUMPV
LABELV $722
line 1494
;1492:	}
;1493:
;1494:	if( !assault.pointSet[0] ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 assault+52
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $738
ADDRGP4 assault+52+4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $738
ADDRGP4 assault+52+8
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $730
LABELV $738
line 1496
;1495:		!assault.pointSet[1] ||
;1496:		!assault.pointSet[2] ) {
line 1497
;1497:		return;
ADDRGP4 $717
JUMPV
LABELV $730
line 1500
;1498:	}
;1499:
;1500:	if( TeamCount(-1, TEAM_RED) < 1 ||
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
LTI4 $741
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
GEI4 $739
LABELV $741
line 1501
;1501:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1502
;1502:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1503
;1503:		return;
ADDRGP4 $717
JUMPV
LABELV $739
line 1506
;1504:	}
;1505:
;1506:	if( !assault.autoStartTime ) {
ADDRGP4 assault+364
INDIRI4
CNSTI4 0
NEI4 $743
line 1507
;1507:		assault.autoStartTime =
ADDRGP4 assault+364
ADDRGP4 level+32
INDIRI4
CNSTI4 2000
ADDI4
ASGNI4
line 1510
;1508:			level.time + ASSAULT_AUTO_START_DELAY;
;1509:
;1510:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $748
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1514
;1511:			-1,
;1512:			"cp \"Base Assault starts in 2 seconds\""
;1513:		);
;1514:		return;
ADDRGP4 $717
JUMPV
LABELV $743
line 1517
;1515:	}
;1516:
;1517:	if( level.time >= assault.autoStartTime ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+364
INDIRI4
LTI4 $717
line 1518
;1518:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1519
;1519:		AssaultStartMatch( NULL );
CNSTP4 0
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1520
;1520:	}
line 1522
;1521:
;1522:	return;
ADDRGP4 $717
JUMPV
LABELV $720
line 1525
;1523:}
;1524:
;1525:	if( assault.phase != ASSAULT_ROUND_RED &&
ADDRLP4 28
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
EQI4 $754
ADDRLP4 28
INDIRI4
CNSTI4 2
EQI4 $754
line 1526
;1526:		assault.phase != ASSAULT_ROUND_BLUE ) {
line 1527
;1527:		return;
ADDRGP4 $717
JUMPV
LABELV $754
line 1530
;1528:	}
;1529:
;1530:	if( level.time - assault.roundStartTime >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+352
INDIRI4
SUBI4
ADDRGP4 assault+356
INDIRI4
LTI4 $756
line 1531
;1531:		assault.roundLimit ) {
line 1532
;1532:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $761
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1536
;1533:			-1,
;1534:			"cp \"Assault round time expired\""
;1535:		);
;1536:		AssaultStoreRoundResult( qfalse );
CNSTI4 0
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1537
;1537:		return;
ADDRGP4 $717
JUMPV
LABELV $756
line 1540
;1538:	}
;1539:
;1540:	frameTime = level.time - assault.lastFrameTime;
ADDRLP4 0
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+360
INDIRI4
SUBI4
ASGNI4
line 1541
;1541:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1543
;1542:
;1543:	if( frameTime < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $766
line 1544
;1544:		frameTime = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1545
;1545:	}
ADDRGP4 $767
JUMPV
LABELV $766
line 1546
;1546:	else if( frameTime > 200 ) {
ADDRLP4 0
INDIRI4
CNSTI4 200
LEI4 $768
line 1547
;1547:		frameTime = 200;
ADDRLP4 0
CNSTI4 200
ASGNI4
line 1548
;1548:	}
LABELV $768
LABELV $767
line 1550
;1549:
;1550:	point = AssaultActualPoint();
ADDRLP4 32
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 1552
;1551:
;1552:	AssaultCountPlayers(
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
line 1558
;1553:		point,
;1554:		&attackers,
;1555:		&defenders
;1556:	);
;1557:
;1558:	if( attackers > 0 && defenders == 0 ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $770
ADDRLP4 20
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $770
line 1559
;1559:		assault.captureProgress += frameTime;
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
line 1560
;1560:	}
ADDRGP4 $771
JUMPV
LABELV $770
line 1561
;1561:	else if( attackers == 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $773
line 1562
;1562:		assault.captureProgress -= frameTime / 2;
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
line 1564
;1563:
;1564:		if( assault.captureProgress < 0 ) {
ADDRGP4 assault+344
INDIRI4
CNSTI4 0
GEI4 $776
line 1565
;1565:			assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1566
;1566:		}
LABELV $776
line 1567
;1567:	}
LABELV $773
LABELV $771
line 1569
;1568:
;1569:	holdTime = AssaultCurrentHoldTime();
ADDRLP4 40
ADDRGP4 AssaultCurrentHoldTime
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 40
INDIRI4
ASGNI4
line 1571
;1570:
;1571:	quarter =
ADDRLP4 4
ADDRGP4 assault+344
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
INDIRI4
DIVI4
ASGNI4
line 1574
;1572:		(assault.captureProgress * 4) / holdTime;
;1573:
;1574:	if( quarter > assault.announcedQuarter &&
ADDRLP4 4
INDIRI4
ADDRGP4 assault+348
INDIRI4
LEI4 $781
ADDRLP4 4
INDIRI4
CNSTI4 4
GEI4 $781
line 1575
;1575:		quarter < 4 ) {
line 1576
;1576:		assault.announcedQuarter = quarter;
ADDRGP4 assault+348
ADDRLP4 4
INDIRI4
ASGNI4
line 1578
;1577:
;1578:		trap_SendServerCommand(
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 48
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $785
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
line 1586
;1579:			-1,
;1580:			va(
;1581:				"cp \"Point %s: %i%%\"",
;1582:				AssaultPointName(point),
;1583:				quarter * 25
;1584:			)
;1585:		);
;1586:	}
LABELV $781
line 1588
;1587:
;1588:	if( assault.captureProgress >= holdTime ) {
ADDRGP4 assault+344
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $786
line 1589
;1589:		AssaultCompletePoint();
ADDRGP4 AssaultCompletePoint
CALLV
pop
line 1590
;1590:	}
LABELV $786
line 1591
;1591:}
LABELV $717
endproc G_AssaultRunFrame 56 12
bss
align 4
LABELV assault
skip 396
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
import g_noLightning
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
LABELV $785
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
LABELV $761
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
LABELV $748
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
LABELV $711
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
LABELV $710
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
LABELV $709
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
LABELV $708
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
LABELV $707
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
LABELV $706
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
LABELV $705
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
LABELV $704
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
LABELV $675
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
LABELV $673
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
LABELV $672
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
LABELV $660
byte 1 45
byte 1 49
byte 1 0
align 1
LABELV $654
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
LABELV $651
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
LABELV $646
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
LABELV $643
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
LABELV $634
byte 1 115
byte 1 0
align 1
LABELV $633
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
LABELV $614
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
LABELV $609
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
LABELV $592
byte 1 48
byte 1 0
align 1
LABELV $590
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
LABELV $586
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
LABELV $577
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
LABELV $545
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
LABELV $537
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
LABELV $517
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
LABELV $516
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
LABELV $515
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
LABELV $514
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
LABELV $511
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
LABELV $510
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
LABELV $448
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $447
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $446
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
LABELV $444
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $402
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
LABELV $399
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
LABELV $395
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
LABELV $382
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
LABELV $377
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
LABELV $372
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
LABELV $367
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
LABELV $363
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
LABELV $359
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
LABELV $354
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
LABELV $328
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 84
byte 1 68
byte 1 77
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
LABELV $327
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 84
byte 1 68
byte 1 77
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
LABELV $317
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 84
byte 1 68
byte 1 77
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
LABELV $308
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 84
byte 1 68
byte 1 77
byte 1 58
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 67
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 110
byte 1 111
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
byte 1 65
byte 1 65
byte 1 83
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 97
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $296
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 84
byte 1 68
byte 1 77
byte 1 58
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 65
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 110
byte 1 111
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
byte 1 65
byte 1 65
byte 1 83
byte 1 32
byte 1 97
byte 1 114
byte 1 101
byte 1 97
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $289
byte 1 65
byte 1 115
byte 1 115
byte 1 97
byte 1 117
byte 1 108
byte 1 116
byte 1 32
byte 1 84
byte 1 68
byte 1 77
byte 1 58
byte 1 32
byte 1 109
byte 1 97
byte 1 112
byte 1 32
byte 1 110
byte 1 101
byte 1 101
byte 1 100
byte 1 115
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
byte 1 116
byte 1 119
byte 1 111
byte 1 32
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 32
byte 1 112
byte 1 111
byte 1 105
byte 1 110
byte 1 116
byte 1 115
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $284
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
LABELV $283
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
LABELV $273
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
LABELV $264
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
LABELV $259
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
LABELV $255
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
LABELV $252
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
LABELV $142
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
LABELV $141
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
LABELV $94
byte 1 63
byte 1 0
align 1
LABELV $93
byte 1 67
byte 1 0
align 1
LABELV $91
byte 1 66
byte 1 0
align 1
LABELV $89
byte 1 65
byte 1 0
align 1
LABELV $84
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
LABELV $83
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
LABELV $82
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
LABELV $81
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
LABELV $80
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
LABELV $79
byte 1 83
byte 1 104
byte 1 111
byte 1 116
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $78
byte 1 82
byte 1 97
byte 1 105
byte 1 108
byte 1 103
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $77
byte 1 66
byte 1 70
byte 1 71
byte 1 0
align 1
LABELV $76
byte 1 72
byte 1 97
byte 1 115
byte 1 116
byte 1 101
byte 1 0
align 1
LABELV $75
byte 1 77
byte 1 101
byte 1 100
byte 1 107
byte 1 105
byte 1 116
byte 1 0
align 1
LABELV $74
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
LABELV $73
byte 1 65
byte 1 114
byte 1 109
byte 1 111
byte 1 114
byte 1 0
align 1
LABELV $72
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
LABELV $71
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
LABELV $70
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
LABELV $69
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
LABELV $68
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
LABELV $67
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
LABELV $66
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
LABELV $65
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
LABELV $64
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
LABELV $63
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
LABELV $62
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
LABELV $61
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
LABELV $60
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
LABELV $59
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
