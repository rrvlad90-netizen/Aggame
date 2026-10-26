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
line 91
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
;12:
;13:typedef enum {
;14:	ASSAULT_SETUP,
;15:	ASSAULT_ROUND_RED,
;16:	ASSAULT_ROUND_BLUE,
;17:	ASSAULT_FINISHED
;18:} assaultPhase_t;
;19:
;20:typedef struct {
;21:	int completedPoints;
;22:	int progress;
;23:	int elapsedTime;
;24:} assaultResult_t;
;25:
;26:typedef struct {
;27:	assaultPhase_t phase;
;28:
;29:	vec3_t points[ASSAULT_MAX_POINTS];
;30:	int pointAreas[ASSAULT_MAX_POINTS];
;31:	qboolean pointSet[ASSAULT_MAX_POINTS];
;32:	gentity_t *markers[ASSAULT_MAX_POINTS];
;33:	qboolean instructionsShown[MAX_CLIENTS];
;34:
;35:	int pointCount;
;36:
;37:	int editorClient;
;38:	int activeStage;
;39:	int captureProgress;
;40:	int announcedQuarter;
;41:
;42:	int roundStartTime;
;43:	int roundLimit;
;44:	int lastFrameTime;
;45:	int autoStartTime;
;46:
;47:	team_t attackingTeam;
;48:
;49:	assaultResult_t redResult;
;50:	assaultResult_t blueResult;
;51:} assaultState_t;
;52:
;53:static assaultState_t assault;
;54:
;55:static char *assaultMiddleClassnames[
;56:	ASSAULT_MIDDLE_ITEM_COUNT
;57:] = {
;58:	"item_armor_body",
;59:	"item_armor_combat",
;60:	"item_health_mega",
;61:	"holdable_medkit",
;62:	"item_haste",
;63:	"weapon_bfg",
;64:	"weapon_railgun",
;65:	"weapon_shotgun",
;66:	"weapon_rocketlauncher",
;67:	"weapon_grenadelauncher",
;68:	"weapon_lightning",
;69:	"holdable_teleporter",
;70:	"weapon_plasmagun"
;71:};
;72:
;73:static char *assaultMiddleNames[
;74:	ASSAULT_MIDDLE_ITEM_COUNT
;75:] = {
;76:	"Heavy Armor",
;77:	"Armor",
;78:	"Mega Health",
;79:	"Medkit",
;80:	"Haste",
;81:	"BFG",
;82:	"Railgun",
;83:	"Shotgun",
;84:	"Rocket Launcher",
;85:	"Grenade Launcher",
;86:	"Lightning Gun",
;87:	"Personal Teleporter",
;88:	"Plasma Gun"
;89:};
;90:
;91:static char *AssaultPointName( int point ) {
line 92
;92:	switch( point ) {
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
line 94
;93:	case 0:
;94:		return "A";
ADDRGP4 $89
RETP4
ADDRGP4 $85
JUMPV
LABELV $90
line 96
;95:	case 1:
;96:		return "B";
ADDRGP4 $91
RETP4
ADDRGP4 $85
JUMPV
LABELV $92
line 98
;97:	case 2:
;98:		return "C";
ADDRGP4 $93
RETP4
ADDRGP4 $85
JUMPV
LABELV $86
line 100
;99:	default:
;100:		return "?";
ADDRGP4 $94
RETP4
LABELV $85
endproc AssaultPointName 4 0
export G_AssaultEnabled
proc G_AssaultEnabled 4 0
line 104
;101:	}
;102:}
;103:
;104:qboolean G_AssaultEnabled( void ) {
line 106
;105:	return
;106:		(
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
line 114
;107:			g_assaultMode.integer == ASSAULT_MODE_BASE ||
;108:			g_assaultMode.integer == ASSAULT_MODE_EDITOR ||
;109:			g_assaultMode.integer == ASSAULT_MODE_TDM_BASE
;110:		) &&
;111:		g_gametype.integer == GT_TEAM;
;112:}
;113:
;114:static int AssaultActualPoint( void ) {
line 115
;115:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $106
line 116
;116:		return assault.activeStage;
ADDRGP4 assault+340
INDIRI4
RETI4
ADDRGP4 $105
JUMPV
LABELV $106
line 119
;117:	}
;118:
;119:	return assault.pointCount - 1 - assault.activeStage;
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
line 128
;120:}
;121:
;122:static void AssaultSetMarkerLight(
;123:	gentity_t *marker,
;124:	int red,
;125:	int green,
;126:	int blue,
;127:	int intensity
;128:) {
line 129
;129:	if( !marker ) {
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $113
line 130
;130:		return;
ADDRGP4 $112
JUMPV
LABELV $113
line 133
;131:	}
;132:
;133:	marker->s.constantLight =
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
line 138
;134:		red |
;135:		(green << 8) |
;136:		(blue << 16) |
;137:		(intensity << 24);
;138:}
LABELV $112
endproc AssaultSetMarkerLight 0 0
proc AssaultUpdateMarkers 16 20
line 140
;139:
;140:static void AssaultUpdateMarkers( void ) {
line 144
;141:	int activePoint;
;142:	int i;
;143:
;144:	activePoint = -1;
ADDRLP4 4
CNSTI4 -1
ASGNI4
line 146
;145:
;146:	if( assault.phase == ASSAULT_ROUND_RED ||
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
line 147
;147:		assault.phase == ASSAULT_ROUND_BLUE ) {
line 148
;148:		activePoint = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ASGNI4
line 149
;149:	}
LABELV $116
line 151
;150:
;151:	for( i = 0; i < ASSAULT_MAX_POINTS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $119
line 152
;152:		if( !assault.markers[i] ) {
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
line 153
;153:			continue;
ADDRGP4 $120
JUMPV
LABELV $123
line 156
;154:		}
;155:
;156:		if( i == activePoint ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $126
line 157
;157:			AssaultSetMarkerLight(
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
line 160
;158:				assault.markers[i], 32, 255, 32, 100
;159:			);
;160:			continue;
ADDRGP4 $120
JUMPV
LABELV $126
line 163
;161:		}
;162:
;163:		if( i == 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $129
line 164
;164:			AssaultSetMarkerLight(
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
line 167
;165:				assault.markers[i], 255, 48, 32, 55
;166:			);
;167:		}
ADDRGP4 $130
JUMPV
LABELV $129
line 168
;168:		else if( i == 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $132
line 169
;169:			AssaultSetMarkerLight(
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
line 172
;170:				assault.markers[i], 48, 96, 255, 55
;171:			);
;172:		}
ADDRGP4 $133
JUMPV
LABELV $132
line 173
;173:		else {
line 174
;174:			AssaultSetMarkerLight(
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
line 177
;175:				assault.markers[i], 255, 192, 32, 55
;176:			);
;177:		}
LABELV $133
LABELV $130
line 178
;178:	}
LABELV $120
line 151
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
line 179
;179:}
LABELV $115
endproc AssaultUpdateMarkers 16 20
proc AssaultCreateOrMoveMarker 16 8
line 181
;180:
;181:static void AssaultCreateOrMoveMarker( int point ) {
line 184
;182:	gentity_t *marker;
;183:
;184:	marker = assault.markers[point];
ADDRLP4 0
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
ASGNP4
line 186
;185:
;186:	if( !marker ) {
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $138
line 187
;187:		marker = G_Spawn();
ADDRLP4 4
ADDRGP4 G_Spawn
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
line 188
;188:		assault.markers[point] = marker;
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
line 190
;189:
;190:		marker->classname = "assault_marker";
ADDRLP4 0
INDIRP4
CNSTI4 524
ADDP4
ADDRGP4 $141
ASGNP4
line 191
;191:		marker->s.eType = ET_GENERAL;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 0
ASGNI4
line 192
;192:		marker->s.modelindex = G_ModelIndex( ASSAULT_MARKER_MODEL );
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
line 193
;193:		marker->s.apos.trType = TR_LINEAR;
ADDRLP4 0
INDIRP4
CNSTI4 48
ADDP4
CNSTI4 2
ASGNI4
line 194
;194:		marker->s.apos.trTime = level.time;
ADDRLP4 0
INDIRP4
CNSTI4 52
ADDP4
ADDRGP4 level+32
INDIRI4
ASGNI4
line 195
;195:		VectorSet(
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
line 202
;196:			marker->s.apos.trDelta,
;197:			0.0f,
;198:			45.0f,
;199:			0.0f
;200:		);
;201:
;202:		marker->r.svFlags |= SVF_BROADCAST;
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
line 203
;203:		marker->r.contents = 0;
ADDRLP4 0
INDIRP4
CNSTI4 460
ADDP4
CNSTI4 0
ASGNI4
line 204
;204:	}
LABELV $138
line 206
;205:
;206:	G_SetOrigin( marker, assault.points[point] );
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
line 207
;207:	trap_LinkEntity( marker );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
line 209
;208:
;209:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 210
;210:}
LABELV $136
endproc AssaultCreateOrMoveMarker 16 8
proc AssaultPointAreaNum 120 20
line 212
;211:
;212:static int AssaultPointAreaNum( vec3_t origin ) {
line 220
;213:	int area;
;214:	int areas[16];
;215:	int numAreas;
;216:	int i;
;217:	vec3_t start;
;218:	vec3_t end;
;219:
;220:	area = trap_AAS_PointAreaNum( origin );
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
line 222
;221:
;222:	if( area &&
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
line 223
;223:		trap_AAS_AreaReachability(area) ) {
line 224
;224:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $145
JUMPV
LABELV $146
line 227
;225:	}
;226:
;227:	VectorCopy( origin, start );
ADDRLP4 76
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 228
;228:	VectorCopy( origin, end );
ADDRLP4 88
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 230
;229:
;230:	start[2] -= 32.0f;
ADDRLP4 76+8
ADDRLP4 76+8
INDIRF4
CNSTF4 1107296256
SUBF4
ASGNF4
line 231
;231:	end[2] += 64.0f;
ADDRLP4 88+8
ADDRLP4 88+8
INDIRF4
CNSTF4 1115684864
ADDF4
ASGNF4
line 233
;232:
;233:	numAreas = trap_AAS_TraceAreas(
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
line 241
;234:		start,
;235:		end,
;236:		areas,
;237:		NULL,
;238:		16
;239:	);
;240:
;241:	for( i = 0; i < numAreas; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $153
JUMPV
LABELV $150
line 242
;242:		if( trap_AAS_AreaReachability(areas[i]) ) {
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
line 243
;243:			return areas[i];
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
line 245
;244:		}
;245:	}
LABELV $151
line 241
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
line 247
;246:
;247:	return 0;
CNSTI4 0
RETI4
LABELV $145
endproc AssaultPointAreaNum 120 20
proc AssaultGroundOrigin 92 28
line 253
;248:}
;249:
;250:static void AssaultGroundOrigin(
;251:	vec3_t source,
;252:	vec3_t result
;253:) {
line 258
;254:	trace_t trace;
;255:	vec3_t start;
;256:	vec3_t end;
;257:
;258:	VectorCopy( source, start );
ADDRLP4 56
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 259
;259:	VectorCopy( source, end );
ADDRLP4 68
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 261
;260:
;261:	start[2] += 32.0f;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1107296256
ADDF4
ASGNF4
line 262
;262:	end[2] -= 256.0f;
ADDRLP4 68+8
ADDRLP4 68+8
INDIRF4
CNSTF4 1132462080
SUBF4
ASGNF4
line 264
;263:
;264:	trap_Trace(
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
line 274
;265:		&trace,
;266:		start,
;267:		NULL,
;268:		NULL,
;269:		end,
;270:		ENTITYNUM_NONE,
;271:		MASK_SOLID
;272:	);
;273:
;274:	if( !trace.startsolid &&
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
line 276
;275:		!trace.allsolid &&
;276:		trace.fraction < 1.0f ) {
line 277
;277:		VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 278
;278:	}
ADDRGP4 $160
JUMPV
LABELV $159
line 279
;279:	else {
line 280
;280:		VectorCopy( source, result );
ADDRFP4 4
INDIRP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
line 281
;281:	}
LABELV $160
line 283
;282:
;283:	result[2] += 8.0f;
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
line 284
;284:}
LABELV $156
endproc AssaultGroundOrigin 92 28
proc AssaultConsiderClassname 32 12
line 293
;285:
;286:static void AssaultConsiderClassname(
;287:	const char *classname,
;288:	int itemIndex,
;289:	int *seen,
;290:	vec3_t selectedOrigin,
;291:	int *selectedArea,
;292:	int *selectedItem
;293:) {
line 298
;294:	gentity_t *ent;
;295:	vec3_t origin;
;296:	int area;
;297:
;298:	ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $166
JUMPV
LABELV $165
line 304
;299:
;300:	while( (ent = G_Find(
;301:		ent,
;302:		FOFS(classname),
;303:		classname
;304:	)) != NULL ) {
line 305
;305:		AssaultGroundOrigin(
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
line 310
;306:			ent->s.origin,
;307:			origin
;308:		);
;309:
;310:		area = AssaultPointAreaNum( origin );
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
line 312
;311:
;312:		if( !area ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $168
line 313
;313:			continue;
ADDRGP4 $166
JUMPV
LABELV $168
line 316
;314:		}
;315:
;316:		(*seen)++;
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
line 318
;317:
;318:		if( rand() % (*seen) != 0 ) {
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
line 319
;319:			continue;
ADDRGP4 $166
JUMPV
LABELV $170
line 322
;320:		}
;321:
;322:		VectorCopy( origin, selectedOrigin );
ADDRFP4 12
INDIRP4
ADDRLP4 4
INDIRB
ASGNB 12
line 323
;323:		*selectedArea = area;
ADDRFP4 16
INDIRP4
ADDRLP4 16
INDIRI4
ASGNI4
line 324
;324:		*selectedItem = itemIndex;
ADDRFP4 20
INDIRP4
ADDRFP4 4
INDIRI4
ASGNI4
line 325
;325:	}
LABELV $166
line 300
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
line 326
;326:}
LABELV $164
endproc AssaultConsiderClassname 32 12
proc AssaultPickClassname 8 24
line 334
;327:
;328:static qboolean AssaultPickClassname(
;329:	const char *classname,
;330:	int itemIndex,
;331:	vec3_t origin,
;332:	int *area,
;333:	int *selectedItem
;334:) {
line 337
;335:	int seen;
;336:
;337:	seen = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 338
;338:	*area = 0;
ADDRFP4 12
INDIRP4
CNSTI4 0
ASGNI4
line 339
;339:	*selectedItem = -1;
ADDRFP4 16
INDIRP4
CNSTI4 -1
ASGNI4
line 341
;340:
;341:	AssaultConsiderClassname(
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
line 350
;342:		classname,
;343:		itemIndex,
;344:		&seen,
;345:		origin,
;346:		area,
;347:		selectedItem
;348:	);
;349:
;350:	return seen > 0;
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
line 357
;351:}
;352:
;353:static qboolean AssaultSelectMiddlePoint(
;354:	vec3_t origin,
;355:	int *area,
;356:	int *selectedItem
;357:) {
line 363
;358:	int choice;
;359:	int seen;
;360:	int i;
;361:	vec3_t midpoint;
;362:
;363:	choice = g_assaultMiddleItem.integer;
ADDRLP4 20
ADDRGP4 g_assaultMiddleItem+12
INDIRI4
ASGNI4
line 365
;364:
;365:	if( choice < 0 ||
ADDRLP4 20
INDIRI4
CNSTI4 0
LTI4 $180
ADDRLP4 20
INDIRI4
CNSTI4 13
LEI4 $178
LABELV $180
line 366
;366:		choice > ASSAULT_MIDDLE_ITEM_COUNT ) {
line 367
;367:		choice = 0;
ADDRLP4 20
CNSTI4 0
ASGNI4
line 368
;368:	}
LABELV $178
line 373
;369:
;370:	/*
;371:	 * All: select uniformly from every supported entity.
;372:	 */
;373:	if( choice == 0 ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $181
line 374
;374:		seen = 0;
ADDRLP4 16
CNSTI4 0
ASGNI4
line 375
;375:		*area = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 376
;376:		*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 378
;377:
;378:		for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $183
line 380
;379:			i < ASSAULT_MIDDLE_ITEM_COUNT;
;380:			i++ ) {
line 381
;381:			AssaultConsiderClassname(
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
line 389
;382:				assaultMiddleClassnames[i],
;383:				i,
;384:				&seen,
;385:				origin,
;386:				area,
;387:				selectedItem
;388:			);
;389:		}
LABELV $184
line 380
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 379
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $183
line 391
;390:
;391:		if( seen > 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $182
line 392
;392:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $176
JUMPV
line 394
;393:		}
;394:	}
LABELV $181
line 395
;395:	else {
line 399
;396:		/*
;397:		 * Explicitly selected entity.
;398:		 */
;399:		if( AssaultPickClassname(
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
EQI4 $189
line 405
;400:			assaultMiddleClassnames[choice - 1],
;401:			choice - 1,
;402:			origin,
;403:			area,
;404:			selectedItem
;405:		) ) {
line 406
;406:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $176
JUMPV
LABELV $189
line 412
;407:		}
;408:
;409:		/*
;410:		 * Selected entity is absent. Try the fallback list.
;411:		 */
;412:		for( i = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $192
line 414
;413:			i < ASSAULT_MIDDLE_ITEM_COUNT;
;414:			i++ ) {
line 415
;415:			if( AssaultPickClassname(
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
EQI4 $196
line 421
;416:				assaultMiddleClassnames[i],
;417:				i,
;418:				origin,
;419:				area,
;420:				selectedItem
;421:			) ) {
line 422
;422:				return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $176
JUMPV
LABELV $196
line 424
;423:			}
;424:		}
LABELV $193
line 414
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
line 413
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $192
line 425
;425:	}
LABELV $182
line 430
;426:
;427:	/*
;428:	 * Last fallback: midpoint between the flags.
;429:	 */
;430:	VectorAdd(
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
line 435
;431:		assault.points[0],
;432:		assault.points[2],
;433:		midpoint
;434:	);
;435:	VectorScale( midpoint, 0.5f, midpoint );
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
line 437
;436:
;437:	AssaultGroundOrigin( midpoint, origin );
ADDRLP4 4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultGroundOrigin
CALLV
pop
line 438
;438:	*area = AssaultPointAreaNum( origin );
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
line 439
;439:	*selectedItem = -1;
ADDRFP4 8
INDIRP4
CNSTI4 -1
ASGNI4
line 441
;440:
;441:	return *area != 0;
ADDRFP4 4
INDIRP4
INDIRI4
CNSTI4 0
EQI4 $218
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $219
JUMPV
LABELV $218
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $219
ADDRLP4 36
INDIRI4
RETI4
LABELV $176
endproc AssaultSelectMiddlePoint 44 24
proc AssaultRemoveMapClass 8 12
line 446
;442:}
;443:
;444:static void AssaultRemoveMapClass(
;445:	const char *classname
;446:) {
line 449
;447:	gentity_t *ent;
;448:
;449:	ent = NULL;
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $222
JUMPV
LABELV $221
line 455
;450:
;451:	while( (ent = G_Find(
;452:		ent,
;453:		FOFS(classname),
;454:		classname
;455:	)) != NULL ) {
line 456
;456:		G_FreeEntity( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
line 457
;457:	}
LABELV $222
line 451
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
NEU4 $221
line 458
;458:}
LABELV $220
endproc AssaultRemoveMapClass 8 12
proc AssaultSetupBasePoints 24 20
line 460
;459:
;460:static qboolean AssaultSetupBasePoints( void ) {
line 465
;461:	int selectedItem;
;462:	int unusedItem;
;463:	int i;
;464:
;465:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 470
;466:
;467:	/*
;468:	 * A: blue flag.
;469:	 */
;470:	if( !AssaultPickClassname(
ADDRGP4 $228
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
NEI4 $226
line 476
;471:		"team_CTF_blueflag",
;472:		-1,
;473:		assault.points[0],
;474:		&assault.pointAreas[0],
;475:		&unusedItem
;476:	) ) {
line 477
;477:		G_Printf(
ADDRGP4 $231
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 480
;478:			"Assault: blue flag position not found.\n"
;479:		);
;480:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $224
JUMPV
LABELV $226
line 483
;481:	}
;482:
;483:	assault.pointSet[0] = qtrue;
ADDRGP4 assault+52
CNSTI4 1
ASGNI4
line 488
;484:
;485:	/*
;486:	 * C: red flag.
;487:	 */
;488:	if( !AssaultPickClassname(
ADDRGP4 $235
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
NEI4 $233
line 494
;489:		"team_CTF_redflag",
;490:		-1,
;491:		assault.points[2],
;492:		&assault.pointAreas[2],
;493:		&unusedItem
;494:	) ) {
line 495
;495:		G_Printf(
ADDRGP4 $240
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 498
;496:			"Assault: red flag position not found.\n"
;497:		);
;498:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $224
JUMPV
LABELV $233
line 501
;499:	}
;500:
;501:	assault.pointSet[2] = qtrue;
ADDRGP4 assault+52+8
CNSTI4 1
ASGNI4
line 506
;502:
;503:	/*
;504:	 * B: selected item or automatic fallback.
;505:	 */
;506:	if( !AssaultSelectMiddlePoint(
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
NEI4 $243
line 510
;507:		assault.points[1],
;508:		&assault.pointAreas[1],
;509:		&selectedItem
;510:	) ) {
line 511
;511:		G_Printf(
ADDRGP4 $249
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 514
;512:			"Assault: unable to create point B.\n"
;513:		);
;514:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $224
JUMPV
LABELV $243
line 517
;515:	}
;516:
;517:	assault.pointSet[1] = qtrue;
ADDRGP4 assault+52+4
CNSTI4 1
ASGNI4
line 522
;518:
;519:	/*
;520:	 * Flags are anchors only; remove their normal entities.
;521:	 */
;522:	AssaultRemoveMapClass(
ADDRGP4 $228
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 525
;523:		"team_CTF_blueflag"
;524:	);
;525:	AssaultRemoveMapClass(
ADDRGP4 $235
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 529
;526:		"team_CTF_redflag"
;527:	);
;528:
;529:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $255
JUMPV
LABELV $252
line 530
;530:		AssaultCreateOrMoveMarker( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 531
;531:	}
LABELV $253
line 529
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $255
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $252
line 533
;532:
;533:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $257
line 534
;534:		G_Printf(
ADDRGP4 $259
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
line 538
;535:			"Assault: point B placed at %s.\n",
;536:			assaultMiddleNames[selectedItem]
;537:		);
;538:	}
ADDRGP4 $258
JUMPV
LABELV $257
line 539
;539:	else {
line 540
;540:		G_Printf(
ADDRGP4 $260
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 543
;541:			"Assault: point B placed at map midpoint.\n"
;542:		);
;543:	}
LABELV $258
line 545
;544:
;545:	return qtrue;
CNSTI4 1
RETI4
LABELV $224
endproc AssaultSetupBasePoints 24 20
proc AssaultSetupTDMBasePoints 32 12
line 548
;546:}
;547:
;548:static qboolean AssaultSetupTDMBasePoints( void ) {
line 554
;549:	gentity_t *redSpot;
;550:	gentity_t *blueSpot;
;551:	int selectedItem;
;552:	int i;
;553:
;554:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 556
;555:
;556:	if( !G_FindAutomaticBaseSpots(
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
NEI4 $263
line 559
;557:		&redSpot,
;558:		&blueSpot
;559:	) ) {
line 560
;560:		G_Printf(
ADDRGP4 $265
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 563
;561:			"Assault TDM: map needs at least two spawn points.\n"
;562:		);
;563:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $263
line 569
;564:	}
;565:
;566:	/*
;567:	 * A: blue team's automatic base.
;568:	 */
;569:	AssaultGroundOrigin(
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
line 574
;570:		blueSpot->s.origin,
;571:		assault.points[0]
;572:	);
;573:
;574:	assault.pointAreas[0] =
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
line 577
;575:		AssaultPointAreaNum(assault.points[0]);
;576:
;577:	if( !assault.pointAreas[0] ) {
ADDRGP4 assault+40
INDIRI4
CNSTI4 0
NEI4 $269
line 578
;578:		G_Printf(
ADDRGP4 $272
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 581
;579:			"Assault TDM: point A has no reachable AAS area.\n"
;580:		);
;581:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $269
line 584
;582:	}
;583:
;584:	assault.pointSet[0] = qtrue;
ADDRGP4 assault+52
CNSTI4 1
ASGNI4
line 589
;585:
;586:	/*
;587:	 * C: red team's automatic base.
;588:	 */
;589:	AssaultGroundOrigin(
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
line 594
;590:		redSpot->s.origin,
;591:		assault.points[2]
;592:	);
;593:
;594:	assault.pointAreas[2] =
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
line 597
;595:		AssaultPointAreaNum(assault.points[2]);
;596:
;597:	if( !assault.pointAreas[2] ) {
ADDRGP4 assault+40+8
INDIRI4
CNSTI4 0
NEI4 $280
line 598
;598:		G_Printf(
ADDRGP4 $284
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 601
;599:			"Assault TDM: point C has no reachable AAS area.\n"
;600:		);
;601:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $280
line 604
;602:	}
;603:
;604:	assault.pointSet[2] = qtrue;
ADDRGP4 assault+52+8
CNSTI4 1
ASGNI4
line 609
;605:
;606:	/*
;607:	 * B: selected map item or automatic fallback.
;608:	 */
;609:	if( !AssaultSelectMiddlePoint(
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
NEI4 $287
line 613
;610:		assault.points[1],
;611:		&assault.pointAreas[1],
;612:		&selectedItem
;613:	) ) {
line 614
;614:		G_Printf(
ADDRGP4 $293
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 617
;615:			"Assault TDM: unable to create point B.\n"
;616:		);
;617:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $261
JUMPV
LABELV $287
line 620
;618:	}
;619:
;620:	assault.pointSet[1] = qtrue;
ADDRGP4 assault+52+4
CNSTI4 1
ASGNI4
line 622
;621:
;622:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $299
JUMPV
LABELV $296
line 623
;623:		AssaultCreateOrMoveMarker( i );
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 624
;624:	}
LABELV $297
line 622
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $299
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $296
line 626
;625:
;626:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $301
line 627
;627:		G_Printf(
ADDRGP4 $303
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
line 631
;628:			"Assault TDM: point B placed at %s.\n",
;629:			assaultMiddleNames[selectedItem]
;630:		);
;631:	}
ADDRGP4 $302
JUMPV
LABELV $301
line 632
;632:	else {
line 633
;633:		G_Printf(
ADDRGP4 $304
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 636
;634:			"Assault TDM: point B placed at map midpoint.\n"
;635:		);
;636:	}
LABELV $302
line 638
;637:
;638:	return qtrue;
CNSTI4 1
RETI4
LABELV $261
endproc AssaultSetupTDMBasePoints 32 12
proc AssaultTracePlacement 112 28
line 644
;639:}
;640:
;641:static qboolean AssaultTracePlacement(
;642:	gentity_t *ent,
;643:	vec3_t result
;644:) {
line 650
;645:	trace_t trace;
;646:	vec3_t start;
;647:	vec3_t end;
;648:	vec3_t forward;
;649:
;650:	VectorCopy( ent->client->ps.origin, start );
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
line 652
;651:
;652:	if( ent->client->ps.viewheight ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 164
ADDP4
INDIRI4
CNSTI4 0
EQI4 $306
line 653
;653:		start[2] += ent->client->ps.viewheight;
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
line 654
;654:	}
ADDRGP4 $307
JUMPV
LABELV $306
line 655
;655:	else {
line 656
;656:		start[2] += 26;
ADDRLP4 56+8
ADDRLP4 56+8
INDIRF4
CNSTF4 1104150528
ADDF4
ASGNF4
line 657
;657:	}
LABELV $307
line 659
;658:
;659:	AngleVectors(
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
line 666
;660:		ent->client->ps.viewangles,
;661:		forward,
;662:		NULL,
;663:		NULL
;664:	);
;665:
;666:	VectorMA( start, 8192.0f, forward, end );
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
line 668
;667:
;668:	trap_Trace(
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
line 678
;669:		&trace,
;670:		start,
;671:		NULL,
;672:		NULL,
;673:		end,
;674:		ent - g_entities,
;675:		MASK_SOLID
;676:	);
;677:
;678:	if( trace.startsolid ||
ADDRLP4 104
CNSTI4 0
ASGNI4
ADDRLP4 0+4
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $323
ADDRLP4 0
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $323
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $323
ADDRLP4 0+44
INDIRI4
CNSTI4 4
BANDI4
ADDRLP4 104
INDIRI4
EQI4 $316
LABELV $323
line 681
;679:		trace.allsolid ||
;680:		trace.fraction == 1.0f ||
;681:		(trace.surfaceFlags & SURF_SKY) ) {
line 682
;682:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $305
JUMPV
LABELV $316
line 685
;683:	}
;684:
;685:	VectorCopy( trace.endpos, result );
ADDRFP4 4
INDIRP4
ADDRLP4 0+12
INDIRB
ASGNB 12
line 686
;686:	result[2] += 8.0f;
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
line 688
;687:
;688:	return qtrue;
CNSTI4 1
RETI4
LABELV $305
endproc AssaultTracePlacement 112 28
proc AssaultClaimEditor 8 8
line 691
;689:}
;690:
;691:static qboolean AssaultClaimEditor( gentity_t *ent ) {
line 694
;692:	int clientNum;
;693:
;694:	clientNum = ent - g_entities;
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
line 696
;695:
;696:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $326
line 697
;697:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $325
JUMPV
LABELV $326
line 700
;698:	}
;699:
;700:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $328
line 701
;701:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $330
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 705
;702:			clientNum,
;703:			"print \"Point placement requires spectator mode.\n\""
;704:		);
;705:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $325
JUMPV
LABELV $328
line 708
;706:	}
;707:
;708:	if( assault.editorClient == -1 ) {
ADDRGP4 assault+336
INDIRI4
CNSTI4 -1
NEI4 $331
line 709
;709:		assault.editorClient = clientNum;
ADDRGP4 assault+336
ADDRLP4 0
INDIRI4
ASGNI4
line 711
;710:
;711:		trap_SendServerCommand(
ADDRGP4 $335
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
line 718
;712:			-1,
;713:			va(
;714:				"print \"%s is placing Assault points.\n\"",
;715:				ent->client->pers.netname
;716:			)
;717:		);
;718:	}
LABELV $331
line 720
;719:
;720:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $336
line 721
;721:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $339
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 725
;722:			clientNum,
;723:			"print \"Another player is placing the points.\n\""
;724:		);
;725:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $325
JUMPV
LABELV $336
line 728
;726:	}
;727:
;728:	return qtrue;
CNSTI4 1
RETI4
LABELV $325
endproc AssaultClaimEditor 8 8
proc AssaultPlacePoint 44 8
line 731
;729:}
;730:
;731:static void AssaultPlacePoint( gentity_t *ent, int point ) {
line 737
;732:	vec3_t origin;
;733:	int otherPoint;
;734:	int area;
;735:	int clientNum;
;736:
;737:	clientNum = ent - g_entities;
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
line 739
;738:
;739:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $341
line 740
;740:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $343
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 744
;741:			clientNum,
;742:			"print \"The match has already started.\n\""
;743:		);
;744:		return;
ADDRGP4 $340
JUMPV
LABELV $341
line 747
;745:	}
;746:
;747:	if( point < 0 || point >= assault.pointCount ) {
ADDRLP4 24
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
LTI4 $347
ADDRLP4 24
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $344
LABELV $347
line 748
;748:		trap_SendServerCommand(
ADDRGP4 $348
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
line 755
;749:			clientNum,
;750:			va(
;751:				"print \"Point number must be from 1 to %i.\n\"",
;752:				assault.pointCount
;753:			)
;754:		);
;755:		return;
ADDRGP4 $340
JUMPV
LABELV $344
line 758
;756:	}
;757:
;758:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $350
line 759
;759:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $353
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 763
;760:			clientNum,
;761:			"print \"Use /assault_edit first.\n\""
;762:		);
;763:		return;
ADDRGP4 $340
JUMPV
LABELV $350
line 766
;764:	}
;765:
;766:	if( ent->client->sess.sessionTeam != TEAM_SPECTATOR ) {
ADDRFP4 0
INDIRP4
CNSTI4 516
ADDP4
INDIRP4
CNSTI4 616
ADDP4
INDIRI4
CNSTI4 3
EQI4 $354
line 767
;767:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $330
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 771
;768:			clientNum,
;769:			"print \"Point placement requires spectator mode.\n\""
;770:		);
;771:		return;
ADDRGP4 $340
JUMPV
LABELV $354
line 774
;772:	}
;773:
;774:	if( !AssaultTracePlacement(ent, origin) ) {
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
NEI4 $356
line 775
;775:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $358
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 779
;776:			clientNum,
;777:			"print \"Unable to place a point there.\n\""
;778:		);
;779:		return;
ADDRGP4 $340
JUMPV
LABELV $356
line 782
;780:	}
;781:
;782:	for( otherPoint = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $362
JUMPV
LABELV $359
line 784
;783:		otherPoint < assault.pointCount;
;784:		otherPoint++ ) {
line 785
;785:		if( otherPoint == point ||
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $367
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $364
LABELV $367
line 786
;786:			!assault.pointSet[otherPoint] ) {
line 787
;787:			continue;
ADDRGP4 $360
JUMPV
LABELV $364
line 790
;788:		}
;789:
;790:		if( DistanceSquared(
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
GEF4 $368
line 795
;791:			origin,
;792:			assault.points[otherPoint]
;793:		) <
;794:			ASSAULT_MIN_POINT_DISTANCE *
;795:			ASSAULT_MIN_POINT_DISTANCE ) {
line 796
;796:			trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $371
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 800
;797:				clientNum,
;798:				"print \"The points are too close together.\n\""
;799:			);
;800:			return;
ADDRGP4 $340
JUMPV
LABELV $368
line 802
;801:		}
;802:	}
LABELV $360
line 784
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $362
line 783
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $359
line 804
;803:
;804:	area = AssaultPointAreaNum( origin );
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
line 806
;805:
;806:	VectorCopy( origin, assault.points[point] );
CNSTI4 12
ADDRFP4 4
INDIRI4
MULI4
ADDRGP4 assault+4
ADDP4
ADDRLP4 4
INDIRB
ASGNB 12
line 807
;807:	assault.pointAreas[point] = area;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
line 808
;808:	assault.pointSet[point] = qtrue;
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 1
ASGNI4
line 810
;809:
;810:	AssaultCreateOrMoveMarker( point );
ADDRFP4 4
INDIRI4
ARGI4
ADDRGP4 AssaultCreateOrMoveMarker
CALLV
pop
line 812
;811:
;812:	trap_SendServerCommand(
ADDRFP4 4
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $375
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
line 820
;813:		-1,
;814:		va(
;815:			"cp \"Assault point %s placed\"",
;816:			AssaultPointName(point)
;817:		)
;818:	);
;819:
;820:	if( !area ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $376
line 821
;821:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $378
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 825
;822:			clientNum,
;823:			"print \"Warning: the point has no AAS area; bots may not reach it.\n\""
;824:		);
;825:	}
LABELV $376
line 826
;826:}
LABELV $340
endproc AssaultPlacePoint 44 8
proc AssaultRespawnTeams 16 4
line 828
;827:
;828:static void AssaultRespawnTeams( void ) {
line 832
;829:	int i;
;830:	gentity_t *ent;
;831:
;832:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $383
JUMPV
LABELV $380
line 833
;833:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 835
;834:
;835:		if( !ent->client ||
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
EQU4 $387
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $385
LABELV $387
line 836
;836:			ent->client->pers.connected != CON_CONNECTED ) {
line 837
;837:			continue;
ADDRGP4 $381
JUMPV
LABELV $385
line 840
;838:		}
;839:
;840:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $388
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $388
line 841
;841:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 842
;842:			continue;
ADDRGP4 $381
JUMPV
LABELV $388
line 845
;843:		}
;844:
;845:		ClientSpawn( ent );
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 ClientSpawn
CALLV
pop
line 846
;846:	}
LABELV $381
line 832
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $383
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $380
line 847
;847:}
LABELV $379
endproc AssaultRespawnTeams 16 4
proc AssaultStartRound 24 12
line 849
;848:
;849:static void AssaultStartRound( team_t attackingTeam ) {
line 852
;850:	int normalLimit;
;851:
;852:	assault.attackingTeam = attackingTeam;
ADDRGP4 assault+368
ADDRFP4 0
INDIRI4
ASGNI4
line 853
;853:	assault.activeStage = 0;
ADDRGP4 assault+340
CNSTI4 0
ASGNI4
line 854
;854:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 855
;855:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 856
;856:	assault.roundStartTime = level.time;
ADDRGP4 assault+352
ADDRGP4 level+32
INDIRI4
ASGNI4
line 857
;857:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 859
;858:
;859:	if( g_timelimit.value > 0.0f ) {
ADDRGP4 g_timelimit+8
INDIRF4
CNSTF4 0
LEF4 $399
line 860
;860:		normalLimit =
ADDRLP4 0
CNSTF4 1198153728
ADDRGP4 g_timelimit+8
INDIRF4
MULF4
CVFI4 4
ASGNI4
line 862
;861:			(int)(g_timelimit.value * 60000.0f);
;862:	}
ADDRGP4 $400
JUMPV
LABELV $399
line 863
;863:	else {
line 864
;864:		normalLimit = 7 * 60 * 1000;
ADDRLP4 0
CNSTI4 420000
ASGNI4
line 865
;865:	}
LABELV $400
line 867
;866:
;867:	if( normalLimit < 30000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 30000
GEI4 $403
line 868
;868:		normalLimit = 30000;
ADDRLP4 0
CNSTI4 30000
ASGNI4
line 869
;869:	}
LABELV $403
line 871
;870:
;871:	assault.roundLimit = normalLimit;
ADDRGP4 assault+356
ADDRLP4 0
INDIRI4
ASGNI4
line 873
;872:
;873:	if( attackingTeam == TEAM_RED ) {
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $406
line 874
;874:		assault.phase = ASSAULT_ROUND_RED;
ADDRGP4 assault
CNSTI4 1
ASGNI4
line 875
;875:	}
ADDRGP4 $407
JUMPV
LABELV $406
line 876
;876:	else {
line 877
;877:		assault.phase = ASSAULT_ROUND_BLUE;
ADDRGP4 assault
CNSTI4 2
ASGNI4
line 882
;878:
;879:		/*
;880:		 * If Red completed the route, Blue must beat Red's time.
;881:		 */
;882:		if( assault.redResult.completedPoints == assault.pointCount &&
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $408
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+356
INDIRI4
GEI4 $408
line 884
;883:			assault.redResult.elapsedTime <
;884:			assault.roundLimit ) {
line 885
;885:			assault.roundLimit =
ADDRGP4 assault+356
ADDRGP4 assault+372+8
INDIRI4
ASGNI4
line 887
;886:				assault.redResult.elapsedTime;
;887:		}
LABELV $408
line 888
;888:	}
LABELV $407
line 890
;889:
;890:	level.startTime = level.time;
ADDRGP4 level+40
ADDRGP4 level+32
INDIRI4
ASGNI4
line 891
;891:	trap_SetConfigstring(
ADDRGP4 $420
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
line 896
;892:		CS_LEVEL_START_TIME,
;893:		va("%i", level.startTime)
;894:	);
;895:
;896:	AssaultRespawnTeams();
ADDRGP4 AssaultRespawnTeams
CALLV
pop
line 897
;897:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 899
;898:
;899:	trap_SendServerCommand(
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
ADDRGP4 $422
ARGP4
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $426
ADDRLP4 8
ADDRGP4 $423
ASGNP4
ADDRGP4 $427
JUMPV
LABELV $426
ADDRLP4 8
ADDRGP4 $424
ASGNP4
LABELV $427
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
line 907
;900:		-1,
;901:		va(
;902:			"cp \"%s attacks point %s\"",
;903:			attackingTeam == TEAM_RED ? "Red" : "Blue",
;904:			AssaultPointName(AssaultActualPoint())
;905:		)
;906:	);
;907:}
LABELV $390
endproc AssaultStartRound 24 12
proc AssaultUpdateScores 16 8
line 909
;908:
;909:static void AssaultUpdateScores( void ) {
line 910
;910:	level.teamScores[TEAM_RED] =
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $434
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $435
JUMPV
LABELV $434
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $435
ADDRGP4 level+44+4
ADDRLP4 0
INDIRI4
ASGNI4
line 914
;911:		assault.redResult.completedPoints ==
;912:		assault.pointCount ? 1 : 0;
;913:
;914:	level.teamScores[TEAM_BLUE] =
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $441
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $442
JUMPV
LABELV $441
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $442
ADDRGP4 level+44+8
ADDRLP4 4
INDIRI4
ASGNI4
line 918
;915:		assault.blueResult.completedPoints ==
;916:		assault.pointCount ? 1 : 0;
;917:
;918:	trap_SetConfigstring(
ADDRGP4 $420
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
line 923
;919:		CS_SCORES1,
;920:		va("%i", level.teamScores[TEAM_RED])
;921:	);
;922:
;923:	trap_SetConfigstring(
ADDRGP4 $420
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
line 928
;924:		CS_SCORES2,
;925:		va("%i", level.teamScores[TEAM_BLUE])
;926:	);
;927:
;928:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 929
;929:}
LABELV $428
endproc AssaultUpdateScores 16 8
proc AssaultFinishMatch 4 8
line 931
;930:
;931:static void AssaultFinishMatch( void ) {
line 934
;932:	int winner;
;933:
;934:	winner = TEAM_FREE;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 936
;935:
;936:	if( assault.redResult.completedPoints >
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+384
INDIRI4
LEI4 $448
line 937
;937:		assault.blueResult.completedPoints ) {
line 938
;938:		winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 939
;939:	}
ADDRGP4 $449
JUMPV
LABELV $448
line 940
;940:	else if( assault.blueResult.completedPoints >
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+372
INDIRI4
LEI4 $452
line 941
;941:		assault.redResult.completedPoints ) {
line 942
;942:		winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 943
;943:	}
ADDRGP4 $453
JUMPV
LABELV $452
line 944
;944:	else if( assault.redResult.completedPoints == assault.pointCount ) {
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $456
line 945
;945:		if( assault.redResult.elapsedTime <
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+384+8
INDIRI4
GEI4 $460
line 946
;946:			assault.blueResult.elapsedTime ) {
line 947
;947:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 948
;948:		}
ADDRGP4 $457
JUMPV
LABELV $460
line 949
;949:		else if( assault.blueResult.elapsedTime <
ADDRGP4 assault+384+8
INDIRI4
ADDRGP4 assault+372+8
INDIRI4
GEI4 $457
line 950
;950:			assault.redResult.elapsedTime ) {
line 951
;951:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 952
;952:		}
line 953
;953:	}
ADDRGP4 $457
JUMPV
LABELV $456
line 954
;954:	else {
line 955
;955:		if( assault.redResult.progress >
ADDRGP4 assault+372+4
INDIRI4
ADDRGP4 assault+384+4
INDIRI4
LEI4 $472
line 956
;956:			assault.blueResult.progress ) {
line 957
;957:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 958
;958:		}
ADDRGP4 $473
JUMPV
LABELV $472
line 959
;959:		else if( assault.blueResult.progress >
ADDRGP4 assault+384+4
INDIRI4
ADDRGP4 assault+372+4
INDIRI4
LEI4 $478
line 960
;960:			assault.redResult.progress ) {
line 961
;961:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 962
;962:		}
LABELV $478
LABELV $473
line 963
;963:	}
LABELV $457
LABELV $453
LABELV $449
line 965
;964:
;965:	assault.phase = ASSAULT_FINISHED;
ADDRGP4 assault
CNSTI4 3
ASGNI4
line 967
;966:
;967:	CalculateRanks();
ADDRGP4 CalculateRanks
CALLV
pop
line 969
;968:
;969:	if( winner == TEAM_RED ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $484
line 970
;970:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $486
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 974
;971:			-1,
;972:			"cp \"Red team wins Assault\""
;973:		);
;974:		LogExit( "Red team won Assault." );
ADDRGP4 $487
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 975
;975:	}
ADDRGP4 $485
JUMPV
LABELV $484
line 976
;976:	else if( winner == TEAM_BLUE ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $488
line 977
;977:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $490
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 981
;978:			-1,
;979:			"cp \"Blue team wins Assault\""
;980:		);
;981:		LogExit( "Blue team won Assault." );
ADDRGP4 $491
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 982
;982:	}
ADDRGP4 $489
JUMPV
LABELV $488
line 983
;983:	else {
line 984
;984:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $492
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 988
;985:			-1,
;986:			"cp \"Assault ended in a draw\""
;987:		);
;988:		LogExit( "Assault draw." );
ADDRGP4 $493
ARGP4
ADDRGP4 LogExit
CALLV
pop
line 989
;989:	}
LABELV $489
LABELV $485
line 990
;990:}
LABELV $447
endproc AssaultFinishMatch 4 8
proc AssaultStoreRoundResult 4 4
line 992
;991:
;992:static void AssaultStoreRoundResult( qboolean completed ) {
line 995
;993:	assaultResult_t *result;
;994:
;995:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $495
line 996
;996:		result = &assault.redResult;
ADDRLP4 0
ADDRGP4 assault+372
ASGNP4
line 997
;997:	}
ADDRGP4 $496
JUMPV
LABELV $495
line 998
;998:	else {
line 999
;999:		result = &assault.blueResult;
ADDRLP4 0
ADDRGP4 assault+384
ASGNP4
line 1000
;1000:	}
LABELV $496
line 1002
;1001:
;1002:	if( completed ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
EQI4 $500
line 1003
;1003:		result->completedPoints = assault.pointCount;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+332
INDIRI4
ASGNI4
line 1004
;1004:		result->progress = (int)(g_assaultHoldTime.value * 1000.0f);
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
line 1005
;1005:		result->elapsedTime =
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
line 1007
;1006:			level.time - assault.roundStartTime;
;1007:	}
ADDRGP4 $501
JUMPV
LABELV $500
line 1008
;1008:	else {
line 1009
;1009:		result->completedPoints = assault.activeStage;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+340
INDIRI4
ASGNI4
line 1010
;1010:		result->progress = assault.captureProgress;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 assault+344
INDIRI4
ASGNI4
line 1011
;1011:		result->elapsedTime = assault.roundLimit;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 assault+356
INDIRI4
ASGNI4
line 1012
;1012:	}
LABELV $501
line 1017
;1013:
;1014:	/*
;1015:	 * Update team scores only after storing the round result.
;1016:	 */
;1017:	AssaultUpdateScores();
ADDRGP4 AssaultUpdateScores
CALLV
pop
line 1019
;1018:
;1019:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $509
line 1020
;1020:		AssaultStartRound( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1021
;1021:	}
ADDRGP4 $510
JUMPV
LABELV $509
line 1022
;1022:	else {
line 1023
;1023:		AssaultFinishMatch();
ADDRGP4 AssaultFinishMatch
CALLV
pop
line 1024
;1024:	}
LABELV $510
line 1025
;1025:}
LABELV $494
endproc AssaultStoreRoundResult 4 4
proc AssaultCompletePoint 32 8
line 1027
;1026:
;1027:static void AssaultCompletePoint( void ) {
line 1030
;1028:	int completedPoint;
;1029:
;1030:	completedPoint = AssaultActualPoint();
ADDRLP4 4
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 1032
;1031:
;1032:	trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $513
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
line 1040
;1033:		-1,
;1034:		va(
;1035:			"cp \"Point %s captured\"",
;1036:			AssaultPointName(completedPoint)
;1037:		)
;1038:	);
;1039:
;1040:	assault.activeStage++;
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
line 1041
;1041:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1042
;1042:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 1044
;1043:
;1044:	if( assault.activeStage >= assault.pointCount ) {
ADDRGP4 assault+340
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $517
line 1045
;1045:		AssaultStoreRoundResult( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1046
;1046:		return;
ADDRGP4 $512
JUMPV
LABELV $517
line 1049
;1047:	}
;1048:
;1049:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 1051
;1050:
;1051:	trap_SendServerCommand(
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
ADDRGP4 $521
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
line 1058
;1052:		-1,
;1053:		va(
;1054:			"cp \"Attack point %s\"",
;1055:			AssaultPointName(AssaultActualPoint())
;1056:		)
;1057:	);
;1058:}
LABELV $512
endproc AssaultCompletePoint 32 8
proc AssaultCountPlayers 28 8
line 1064
;1059:
;1060:static void AssaultCountPlayers(
;1061:	int point,
;1062:	int *attackers,
;1063:	int *defenders
;1064:) {
line 1069
;1065:	int i;
;1066:	float radiusSquared;
;1067:	gentity_t *ent;
;1068:
;1069:	*attackers = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 1070
;1070:	*defenders = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
line 1072
;1071:
;1072:	radiusSquared =
ADDRLP4 8
ADDRGP4 g_assaultRadius+8
INDIRF4
ADDRGP4 g_assaultRadius+8
INDIRF4
MULF4
ASGNF4
line 1076
;1073:		g_assaultRadius.value *
;1074:		g_assaultRadius.value;
;1075:
;1076:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $528
JUMPV
LABELV $525
line 1077
;1077:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 884
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1079
;1078:
;1079:		if( !ent->client ||
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
EQU4 $533
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $533
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $530
LABELV $533
line 1081
;1080:			ent->client->pers.connected != CON_CONNECTED ||
;1081:			ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
line 1082
;1082:			continue;
ADDRGP4 $526
JUMPV
LABELV $530
line 1085
;1083:		}
;1084:
;1085:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $534
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $534
line 1086
;1086:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 1087
;1087:			continue;
ADDRGP4 $526
JUMPV
LABELV $534
line 1090
;1088:		}
;1089:
;1090:		if( DistanceSquared(
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
LEF4 $536
line 1093
;1091:			ent->client->ps.origin,
;1092:			assault.points[point]
;1093:		) > radiusSquared ) {
line 1094
;1094:			continue;
ADDRGP4 $526
JUMPV
LABELV $536
line 1097
;1095:		}
;1096:
;1097:		if( ent->client->sess.sessionTeam ==
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
NEI4 $539
line 1098
;1098:			assault.attackingTeam ) {
line 1099
;1099:			(*attackers)++;
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
line 1100
;1100:		}
ADDRGP4 $540
JUMPV
LABELV $539
line 1101
;1101:		else {
line 1102
;1102:			(*defenders)++;
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
line 1103
;1103:		}
LABELV $540
line 1104
;1104:	}
LABELV $526
line 1076
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $528
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $525
line 1105
;1105:}
LABELV $522
endproc AssaultCountPlayers 28 8
proc AssaultStartMatch 20 12
line 1107
;1106:
;1107:static void AssaultStartMatch( gentity_t *ent ) {
line 1111
;1108:	int clientNum;
;1109:	int i;
;1110:
;1111:	clientNum = ent ? ent - g_entities : -1;
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $544
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
ADDRGP4 $545
JUMPV
LABELV $544
ADDRLP4 8
CNSTI4 -1
ASGNI4
LABELV $545
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1113
;1112:
;1113:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $546
line 1114
;1114:		ASSAULT_MODE_EDITOR ) {
line 1115
;1115:		if( !ent ||
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $552
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $549
LABELV $552
line 1116
;1116:			assault.editorClient != clientNum ) {
line 1117
;1117:			trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $553
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1121
;1118:				clientNum,
;1119:				"print \"Only the point editor can start the match.\n\""
;1120:			);
;1121:			return;
ADDRGP4 $542
JUMPV
LABELV $549
line 1123
;1122:		}
;1123:	}
LABELV $546
line 1125
;1124:
;1125:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $557
JUMPV
LABELV $554
line 1126
;1126:		if( !assault.pointSet[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $559
line 1127
;1127:			trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $562
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
line 1134
;1128:				clientNum,
;1129:				va(
;1130:					"print \"Assault: points are invalid. Point %s is missing.\n\"",
;1131:					AssaultPointName(i)
;1132:				)
;1133:			);
;1134:			return;
ADDRGP4 $542
JUMPV
LABELV $559
line 1136
;1135:		}
;1136:	}
LABELV $555
line 1125
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $557
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $554
line 1138
;1137:
;1138:	if( TeamCount(-1, TEAM_RED) < 1 ||
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
LTI4 $565
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
GEI4 $563
LABELV $565
line 1139
;1139:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1140
;1140:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $566
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1144
;1141:			clientNum,
;1142:			"print \"Both teams need at least one player.\n\""
;1143:		);
;1144:		return;
ADDRGP4 $542
JUMPV
LABELV $563
line 1147
;1145:	}
;1146:
;1147:	level.warmupTime = 0;
ADDRGP4 level+16
CNSTI4 0
ASGNI4
line 1148
;1148:	trap_SetConfigstring( CS_WARMUP, "0" );
CNSTI4 5
ARGI4
ADDRGP4 $568
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1150
;1149:
;1150:	memset(
ADDRGP4 assault+372
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1155
;1151:		&assault.redResult,
;1152:		0,
;1153:		sizeof(assault.redResult)
;1154:	);
;1155:	memset(
ADDRGP4 assault+384
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1161
;1156:		&assault.blueResult,
;1157:		0,
;1158:		sizeof(assault.blueResult)
;1159:	);
;1160:	
;1161:	level.teamScores[TEAM_RED] = 0;
ADDRGP4 level+44+4
CNSTI4 0
ASGNI4
line 1162
;1162:	level.teamScores[TEAM_BLUE] = 0;
ADDRGP4 level+44+8
CNSTI4 0
ASGNI4
line 1164
;1163:
;1164:	trap_SetConfigstring( CS_SCORES1, "0" );
CNSTI4 6
ARGI4
ADDRGP4 $568
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1165
;1165:	trap_SetConfigstring( CS_SCORES2, "0" );
CNSTI4 7
ARGI4
ADDRGP4 $568
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1167
;1166:
;1167:	AssaultStartRound( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1168
;1168:}
LABELV $542
endproc AssaultStartMatch 20 12
proc AssaultSetPointCount 24 12
line 1174
;1169:
;1170:
;1171:static void AssaultSetPointCount(
;1172:	gentity_t *ent,
;1173:	int pointCount
;1174:) {
line 1178
;1175:	int i;
;1176:	int clientNum;
;1177:
;1178:	clientNum = ent - g_entities;
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
line 1180
;1179:
;1180:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $578
line 1181
;1181:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $343
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1185
;1182:			clientNum,
;1183:			"print \"The match has already started.\n\""
;1184:		);
;1185:		return;
ADDRGP4 $577
JUMPV
LABELV $578
line 1188
;1186:	}
;1187:
;1188:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $580
line 1189
;1189:		return;
ADDRGP4 $577
JUMPV
LABELV $580
line 1192
;1190:	}
;1191:
;1192:	if( pointCount < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $584
ADDRLP4 8
INDIRI4
CNSTI4 3
LEI4 $582
LABELV $584
line 1193
;1193:		pointCount > ASSAULT_MAX_POINTS ) {
line 1194
;1194:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $585
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1198
;1195:			clientNum,
;1196:			"print \"Usage: /assault_set 1|2|3\n\""
;1197:		);
;1198:		return;
ADDRGP4 $577
JUMPV
LABELV $582
line 1201
;1199:	}
;1200:
;1201:	if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $586
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $586
line 1202
;1202:		assault.editorClient != clientNum ) {
line 1203
;1203:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $590
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1207
;1204:			clientNum,
;1205:			"print \"Another player is editing Assault.\n\""
;1206:		);
;1207:		return;
ADDRGP4 $577
JUMPV
LABELV $586
line 1210
;1208:	}
;1209:
;1210:	for( i = pointCount;
ADDRLP4 0
ADDRFP4 4
INDIRI4
ASGNI4
ADDRGP4 $594
JUMPV
LABELV $591
line 1212
;1211:		i < ASSAULT_MAX_POINTS;
;1212:		i++ ) {
line 1213
;1213:		if( assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $595
line 1214
;1214:			G_FreeEntity( assault.markers[i] );
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
line 1215
;1215:			assault.markers[i] = NULL;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
CNSTP4 0
ASGNP4
line 1216
;1216:		}
LABELV $595
line 1218
;1217:
;1218:		assault.pointSet[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 0
ASGNI4
line 1219
;1219:		assault.pointAreas[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
CNSTI4 0
ASGNI4
line 1220
;1220:		VectorClear( assault.points[i] );
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
line 1221
;1221:	}
LABELV $592
line 1212
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $594
line 1211
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $591
line 1223
;1222:
;1223:	assault.pointCount = pointCount;
ADDRGP4 assault+332
ADDRFP4 4
INDIRI4
ASGNI4
line 1225
;1224:
;1225:	trap_SendServerCommand(
ADDRGP4 $608
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
NEI4 $612
ADDRLP4 12
ADDRGP4 $609
ASGNP4
ADDRGP4 $613
JUMPV
LABELV $612
ADDRLP4 12
ADDRGP4 $610
ASGNP4
LABELV $613
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
line 1233
;1226:		-1,
;1227:		va(
;1228:			"print \"Assault will use %i point%s.\n\"",
;1229:			pointCount,
;1230:			pointCount == 1 ? "" : "s"
;1231:		)
;1232:	);
;1233:}
LABELV $577
endproc AssaultSetPointCount 24 12
export G_AssaultClientCommand
proc G_AssaultClientCommand 1048 12
line 1238
;1234:
;1235:qboolean G_AssaultClientCommand(
;1236:	gentity_t *ent,
;1237:	const char *cmd
;1238:) {
line 1242
;1239:	char arg[MAX_TOKEN_CHARS];
;1240:	int value;
;1241:
;1242:	if( !G_AssaultEnabled() ) {
ADDRLP4 1028
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 1028
INDIRI4
CNSTI4 0
NEI4 $615
line 1243
;1243:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $614
JUMPV
LABELV $615
line 1246
;1244:	}
;1245:
;1246:	if( !Q_stricmp(cmd, "assault_set") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $619
ARGP4
ADDRLP4 1032
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 0
NEI4 $617
line 1247
;1247:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1248
;1248:		AssaultSetPointCount( ent, atoi(arg) );
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
line 1249
;1249:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $614
JUMPV
LABELV $617
line 1252
;1250:	}
;1251:
;1252:	if( !Q_stricmp(cmd, "assault_edit") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $622
ARGP4
ADDRLP4 1036
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1036
INDIRI4
CNSTI4 0
NEI4 $620
line 1253
;1253:		if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $623
line 1254
;1254:			trap_SendServerCommand(
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
ADDRGP4 $343
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1258
;1255:				ent - g_entities,
;1256:				"print \"The match has already started.\n\""
;1257:			);
;1258:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $614
JUMPV
LABELV $623
line 1261
;1259:		}
;1260:
;1261:		AssaultClaimEditor( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultClaimEditor
CALLI4
pop
line 1262
;1262:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $614
JUMPV
LABELV $620
line 1265
;1263:	}
;1264:
;1265:	if( !Q_stricmp(cmd, "assault_place") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $627
ARGP4
ADDRLP4 1040
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
NEI4 $625
line 1266
;1266:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1267
;1267:		value = atoi(arg) - 1;
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
line 1268
;1268:		AssaultPlacePoint( ent, value );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1024
INDIRI4
ARGI4
ADDRGP4 AssaultPlacePoint
CALLV
pop
line 1269
;1269:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $614
JUMPV
LABELV $625
line 1272
;1270:	}
;1271:
;1272:	if( !Q_stricmp(cmd, "assault_ready") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $630
ARGP4
ADDRLP4 1044
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1044
INDIRI4
CNSTI4 0
NEI4 $628
line 1273
;1273:		AssaultStartMatch( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1274
;1274:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $614
JUMPV
LABELV $628
line 1277
;1275:	}
;1276:
;1277:	return qfalse;
CNSTI4 0
RETI4
LABELV $614
endproc G_AssaultClientCommand 1048 12
export G_AssaultInit
proc G_AssaultInit 12 12
line 1280
;1278:}
;1279:
;1280:void G_AssaultInit( void ) {
line 1281
;1281:	memset( &assault, 0, sizeof(assault) );
ADDRGP4 assault
ARGP4
CNSTI4 0
ARGI4
CNSTI4 396
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1283
;1282:
;1283:	assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1284
;1284:	assault.phase = ASSAULT_SETUP;
ADDRGP4 assault
CNSTI4 0
ASGNI4
line 1286
;1285:
;1286:	if( !G_AssaultEnabled() ) {
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $633
line 1287
;1287:		return;
ADDRGP4 $631
JUMPV
LABELV $633
line 1290
;1288:	}
;1289:
;1290:	level.warmupTime = -1;
ADDRGP4 level+16
CNSTI4 -1
ASGNI4
line 1291
;1291:	trap_SetConfigstring( CS_WARMUP, "-1" );
CNSTI4 5
ARGI4
ADDRGP4 $636
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1293
;1292:
;1293:if( g_assaultMode.integer == ASSAULT_MODE_BASE ||
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
EQI4 $641
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $637
LABELV $641
line 1294
;1294:	g_assaultMode.integer == ASSAULT_MODE_TDM_BASE ) {
line 1297
;1295:	qboolean setupResult;
;1296:
;1297:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 1299
;1298:
;1299:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $643
line 1300
;1300:		ASSAULT_MODE_TDM_BASE ) {
line 1301
;1301:		setupResult =
ADDRLP4 8
ADDRGP4 AssaultSetupTDMBasePoints
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1303
;1302:			AssaultSetupTDMBasePoints();
;1303:	}
ADDRGP4 $644
JUMPV
LABELV $643
line 1304
;1304:	else {
line 1305
;1305:		setupResult =
ADDRLP4 8
ADDRGP4 AssaultSetupBasePoints
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1307
;1306:			AssaultSetupBasePoints();
;1307:	}
LABELV $644
line 1309
;1308:
;1309:	if( setupResult ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $646
line 1310
;1310:		G_Printf(
ADDRGP4 $648
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1313
;1311:			"Assault: automatic points ready; waiting for teams.\n"
;1312:		);
;1313:	}
ADDRGP4 $631
JUMPV
LABELV $646
line 1314
;1314:	else {
line 1315
;1315:		G_Printf(
ADDRGP4 $649
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1318
;1316:			"Assault: automatic setup failed.\n"
;1317:		);
;1318:	}
line 1320
;1319:
;1320:	return;
ADDRGP4 $631
JUMPV
LABELV $637
line 1323
;1321:}
;1322:
;1323:	assault.pointCount = ASSAULT_DEFAULT_POINTS;
ADDRGP4 assault+332
CNSTI4 2
ASGNI4
line 1325
;1324:
;1325:	G_Printf(
ADDRGP4 $651
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1328
;1326:		"Assault Editor: waiting for point placement.\n"
;1327:	);
;1328:}
LABELV $631
endproc G_AssaultInit 12 12
export G_AssaultBlocksWarmup
proc G_AssaultBlocksWarmup 12 0
line 1330
;1329:
;1330:qboolean G_AssaultBlocksWarmup( void ) {
line 1331
;1331:	return G_AssaultEnabled() &&
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
EQI4 $654
ADDRGP4 assault
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $654
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $655
JUMPV
LABELV $654
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $655
ADDRLP4 0
INDIRI4
RETI4
LABELV $652
endproc G_AssaultBlocksWarmup 12 0
export G_AssaultControlsExitRules
proc G_AssaultControlsExitRules 4 0
line 1335
;1332:		assault.phase == ASSAULT_SETUP;
;1333:}
;1334:
;1335:qboolean G_AssaultControlsExitRules( void ) {
line 1336
;1336:	return G_AssaultEnabled();
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $656
endproc G_AssaultControlsExitRules 4 0
export G_AssaultGetActiveGoal
proc G_AssaultGetActiveGoal 16 0
line 1343
;1337:}
;1338:
;1339:qboolean G_AssaultGetActiveGoal(
;1340:	vec3_t origin,
;1341:	int *area,
;1342:	team_t *attackingTeam
;1343:) {
line 1346
;1344:	int point;
;1345:
;1346:	if( !G_AssaultEnabled() ||
ADDRLP4 4
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $660
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $658
ADDRLP4 8
INDIRI4
CNSTI4 2
EQI4 $658
LABELV $660
line 1348
;1347:		(assault.phase != ASSAULT_ROUND_RED &&
;1348:		 assault.phase != ASSAULT_ROUND_BLUE) ) {
line 1349
;1349:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $657
JUMPV
LABELV $658
line 1352
;1350:	}
;1351:
;1352:	point = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 1354
;1353:
;1354:	VectorCopy( assault.points[point], origin );
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
line 1355
;1355:	*area = assault.pointAreas[point];
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
line 1356
;1356:	*attackingTeam = assault.attackingTeam;
ADDRFP4 8
INDIRP4
ADDRGP4 assault+368
INDIRI4
ASGNI4
line 1358
;1357:
;1358:	return qtrue;
CNSTI4 1
RETI4
LABELV $657
endproc G_AssaultGetActiveGoal 16 0
proc AssaultShowInstructions 12 8
line 1361
;1359:}
;1360:
;1361:static void AssaultShowInstructions( void ) {
line 1365
;1362:	int i;
;1363:	gentity_t *ent;
;1364:
;1365:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $668
JUMPV
LABELV $665
line 1366
;1366:		ent = &g_entities[i];
ADDRLP4 4
CNSTI4 884
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1368
;1367:
;1368:		if( !ent->client ||
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
EQU4 $672
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $670
LABELV $672
line 1369
;1369:			ent->client->pers.connected != CON_CONNECTED ) {
line 1370
;1370:			assault.instructionsShown[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 0
ASGNI4
line 1371
;1371:			continue;
ADDRGP4 $666
JUMPV
LABELV $670
line 1374
;1372:		}
;1373:
;1374:		if( ent->r.svFlags & SVF_BOT ) {
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $674
line 1375
;1375:			continue;
ADDRGP4 $666
JUMPV
LABELV $674
line 1378
;1376:		}
;1377:
;1378:		if( assault.instructionsShown[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
INDIRI4
CNSTI4 0
EQI4 $676
line 1379
;1379:			continue;
ADDRGP4 $666
JUMPV
LABELV $676
line 1382
;1380:		}
;1381:
;1382:		assault.instructionsShown[i] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 1
ASGNI4
line 1384
;1383:
;1384:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $680
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1388
;1385:			i,
;1386:			"print \"\n=== ASSAULT SETUP ===\n\""
;1387:		);
;1388:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $681
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1392
;1389:			i,
;1390:			"print \"Set point count: /assault_set 1, 2 or 3\n\""
;1391:		);
;1392:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $682
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1396
;1393:			i,
;1394:			"print \"Enter spectator mode: /team spectator\n\""
;1395:		);
;1396:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $683
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1400
;1397:			i,
;1398:			"print \"Begin editing: /assault_edit\n\""
;1399:		);
;1400:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $684
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1404
;1401:			i,
;1402:			"print \"Aim and place points: /assault_place 1|2|3\n\""
;1403:		);
;1404:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $685
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1408
;1405:			i,
;1406:			"print \"After placement, join Red or Blue team.\n\""
;1407:		);
;1408:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $686
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1412
;1409:			i,
;1410:			"print \"IMPORTANT: add bots before starting the match.\n\""
;1411:		);
;1412:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $687
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1416
;1413:			i,
;1414:			"print \"Start the match: /assault_ready\n\n\""
;1415:		);
;1416:	}
LABELV $666
line 1365
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $668
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $665
line 1417
;1417:}
LABELV $664
endproc AssaultShowInstructions 12 8
proc AssaultCurrentHoldTime 8 0
line 1419
;1418:
;1419:static int AssaultCurrentHoldTime( void ) {
line 1423
;1420:	int holdTime;
;1421:	int multiplier;
;1422:
;1423:	multiplier = 1 << assault.activeStage;
ADDRLP4 4
CNSTI4 1
ADDRGP4 assault+340
INDIRI4
LSHI4
ASGNI4
line 1425
;1424:
;1425:	holdTime = (int)(
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
line 1431
;1426:		g_assaultHoldTime.value *
;1427:		1000.0f *
;1428:		multiplier
;1429:	);
;1430:
;1431:	if( holdTime < 1000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1000
GEI4 $691
line 1432
;1432:		holdTime = 1000;
ADDRLP4 0
CNSTI4 1000
ASGNI4
line 1433
;1433:	}
LABELV $691
line 1435
;1434:
;1435:	return holdTime;
ADDRLP4 0
INDIRI4
RETI4
LABELV $688
endproc AssaultCurrentHoldTime 8 0
export G_AssaultRunFrame
proc G_AssaultRunFrame 56 12
line 1438
;1436:}
;1437:
;1438:void G_AssaultRunFrame( void ) {
line 1446
;1439:	int point;
;1440:	int attackers;
;1441:	int defenders;
;1442:	int frameTime;
;1443:	int holdTime;
;1444:	int quarter;
;1445:
;1446:	if( !G_AssaultEnabled() ) {
ADDRLP4 24
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $694
line 1447
;1447:		return;
ADDRGP4 $693
JUMPV
LABELV $694
line 1450
;1448:	}
;1449:
;1450:if( assault.phase == ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
NEI4 $696
line 1451
;1451:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $698
line 1452
;1452:		ASSAULT_MODE_EDITOR ) {
line 1453
;1453:		AssaultShowInstructions();
ADDRGP4 AssaultShowInstructions
CALLV
pop
line 1455
;1454:
;1455:		if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $693
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
EQI4 $693
line 1457
;1456:			level.clients[assault.editorClient].
;1457:				pers.connected != CON_CONNECTED ) {
line 1458
;1458:			assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1459
;1459:		}
line 1461
;1460:
;1461:		return;
ADDRGP4 $693
JUMPV
LABELV $698
line 1464
;1462:	}
;1463:
;1464:	if( !assault.pointSet[0] ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 assault+52
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $714
ADDRGP4 assault+52+4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $714
ADDRGP4 assault+52+8
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $706
LABELV $714
line 1466
;1465:		!assault.pointSet[1] ||
;1466:		!assault.pointSet[2] ) {
line 1467
;1467:		return;
ADDRGP4 $693
JUMPV
LABELV $706
line 1470
;1468:	}
;1469:
;1470:	if( TeamCount(-1, TEAM_RED) < 1 ||
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
LTI4 $717
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
GEI4 $715
LABELV $717
line 1471
;1471:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1472
;1472:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1473
;1473:		return;
ADDRGP4 $693
JUMPV
LABELV $715
line 1476
;1474:	}
;1475:
;1476:	if( !assault.autoStartTime ) {
ADDRGP4 assault+364
INDIRI4
CNSTI4 0
NEI4 $719
line 1477
;1477:		assault.autoStartTime =
ADDRGP4 assault+364
ADDRGP4 level+32
INDIRI4
CNSTI4 2000
ADDI4
ASGNI4
line 1480
;1478:			level.time + ASSAULT_AUTO_START_DELAY;
;1479:
;1480:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $724
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1484
;1481:			-1,
;1482:			"cp \"Base Assault starts in 2 seconds\""
;1483:		);
;1484:		return;
ADDRGP4 $693
JUMPV
LABELV $719
line 1487
;1485:	}
;1486:
;1487:	if( level.time >= assault.autoStartTime ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+364
INDIRI4
LTI4 $693
line 1488
;1488:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1489
;1489:		AssaultStartMatch( NULL );
CNSTP4 0
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1490
;1490:	}
line 1492
;1491:
;1492:	return;
ADDRGP4 $693
JUMPV
LABELV $696
line 1495
;1493:}
;1494:
;1495:	if( assault.phase != ASSAULT_ROUND_RED &&
ADDRLP4 28
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
EQI4 $730
ADDRLP4 28
INDIRI4
CNSTI4 2
EQI4 $730
line 1496
;1496:		assault.phase != ASSAULT_ROUND_BLUE ) {
line 1497
;1497:		return;
ADDRGP4 $693
JUMPV
LABELV $730
line 1500
;1498:	}
;1499:
;1500:	if( level.time - assault.roundStartTime >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+352
INDIRI4
SUBI4
ADDRGP4 assault+356
INDIRI4
LTI4 $732
line 1501
;1501:		assault.roundLimit ) {
line 1502
;1502:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $737
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1506
;1503:			-1,
;1504:			"cp \"Assault round time expired\""
;1505:		);
;1506:		AssaultStoreRoundResult( qfalse );
CNSTI4 0
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1507
;1507:		return;
ADDRGP4 $693
JUMPV
LABELV $732
line 1510
;1508:	}
;1509:
;1510:	frameTime = level.time - assault.lastFrameTime;
ADDRLP4 0
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+360
INDIRI4
SUBI4
ASGNI4
line 1511
;1511:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1513
;1512:
;1513:	if( frameTime < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $742
line 1514
;1514:		frameTime = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1515
;1515:	}
ADDRGP4 $743
JUMPV
LABELV $742
line 1516
;1516:	else if( frameTime > 200 ) {
ADDRLP4 0
INDIRI4
CNSTI4 200
LEI4 $744
line 1517
;1517:		frameTime = 200;
ADDRLP4 0
CNSTI4 200
ASGNI4
line 1518
;1518:	}
LABELV $744
LABELV $743
line 1520
;1519:
;1520:	point = AssaultActualPoint();
ADDRLP4 32
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 1522
;1521:
;1522:	AssaultCountPlayers(
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
line 1528
;1523:		point,
;1524:		&attackers,
;1525:		&defenders
;1526:	);
;1527:
;1528:	if( attackers > 0 && defenders == 0 ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $746
ADDRLP4 20
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $746
line 1529
;1529:		assault.captureProgress += frameTime;
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
line 1530
;1530:	}
ADDRGP4 $747
JUMPV
LABELV $746
line 1531
;1531:	else if( attackers == 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $749
line 1532
;1532:		assault.captureProgress -= frameTime / 2;
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
line 1534
;1533:
;1534:		if( assault.captureProgress < 0 ) {
ADDRGP4 assault+344
INDIRI4
CNSTI4 0
GEI4 $752
line 1535
;1535:			assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1536
;1536:		}
LABELV $752
line 1537
;1537:	}
LABELV $749
LABELV $747
line 1539
;1538:
;1539:	holdTime = AssaultCurrentHoldTime();
ADDRLP4 40
ADDRGP4 AssaultCurrentHoldTime
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 40
INDIRI4
ASGNI4
line 1541
;1540:
;1541:	quarter =
ADDRLP4 4
ADDRGP4 assault+344
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
INDIRI4
DIVI4
ASGNI4
line 1544
;1542:		(assault.captureProgress * 4) / holdTime;
;1543:
;1544:	if( quarter > assault.announcedQuarter &&
ADDRLP4 4
INDIRI4
ADDRGP4 assault+348
INDIRI4
LEI4 $757
ADDRLP4 4
INDIRI4
CNSTI4 4
GEI4 $757
line 1545
;1545:		quarter < 4 ) {
line 1546
;1546:		assault.announcedQuarter = quarter;
ADDRGP4 assault+348
ADDRLP4 4
INDIRI4
ASGNI4
line 1548
;1547:
;1548:		trap_SendServerCommand(
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 48
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $761
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
line 1556
;1549:			-1,
;1550:			va(
;1551:				"cp \"Point %s: %i%%\"",
;1552:				AssaultPointName(point),
;1553:				quarter * 25
;1554:			)
;1555:		);
;1556:	}
LABELV $757
line 1558
;1557:
;1558:	if( assault.captureProgress >= holdTime ) {
ADDRGP4 assault+344
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $762
line 1559
;1559:		AssaultCompletePoint();
ADDRGP4 AssaultCompletePoint
CALLV
pop
line 1560
;1560:	}
LABELV $762
line 1561
;1561:}
LABELV $693
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
LABELV $761
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
LABELV $737
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
LABELV $724
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
LABELV $687
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
LABELV $686
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
LABELV $685
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
LABELV $684
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
LABELV $683
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
LABELV $682
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
LABELV $681
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
LABELV $680
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
LABELV $651
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
LABELV $649
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
LABELV $648
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
LABELV $636
byte 1 45
byte 1 49
byte 1 0
align 1
LABELV $630
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
LABELV $627
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
LABELV $622
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
LABELV $619
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
LABELV $610
byte 1 115
byte 1 0
align 1
LABELV $609
byte 1 0
align 1
LABELV $608
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
LABELV $590
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
LABELV $585
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
LABELV $568
byte 1 48
byte 1 0
align 1
LABELV $566
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
LABELV $562
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
LABELV $553
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
LABELV $521
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
LABELV $513
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
LABELV $493
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
LABELV $492
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
LABELV $491
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
LABELV $490
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
LABELV $487
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
LABELV $486
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
LABELV $424
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $423
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $422
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
LABELV $420
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $378
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
LABELV $375
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
LABELV $371
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
LABELV $358
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
LABELV $353
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
LABELV $348
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
LABELV $343
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
LABELV $339
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
LABELV $335
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
LABELV $330
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
LABELV $304
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
LABELV $303
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
LABELV $293
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
LABELV $284
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
LABELV $272
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
LABELV $265
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
LABELV $260
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
LABELV $259
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
LABELV $249
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
LABELV $240
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
LABELV $235
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
LABELV $231
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
LABELV $228
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
