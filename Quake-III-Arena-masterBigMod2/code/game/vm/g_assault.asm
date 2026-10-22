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
line 94
;93:	case 0:
;94:		return "A";
ADDRGP4 $85
RETP4
ADDRGP4 $81
JUMPV
LABELV $86
line 96
;95:	case 1:
;96:		return "B";
ADDRGP4 $87
RETP4
ADDRGP4 $81
JUMPV
LABELV $88
line 98
;97:	case 2:
;98:		return "C";
ADDRGP4 $89
RETP4
ADDRGP4 $81
JUMPV
LABELV $82
line 100
;99:	default:
;100:		return "?";
ADDRGP4 $90
RETP4
LABELV $81
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
EQI4 $100
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
EQI4 $100
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $97
LABELV $100
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 3
NEI4 $97
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $98
JUMPV
LABELV $97
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $98
ADDRLP4 0
INDIRI4
RETI4
LABELV $91
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
NEI4 $102
line 116
;116:		return assault.activeStage;
ADDRGP4 assault+340
INDIRI4
RETI4
ADDRGP4 $101
JUMPV
LABELV $102
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
LABELV $101
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
NEU4 $109
line 130
;130:		return;
ADDRGP4 $108
JUMPV
LABELV $109
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
LABELV $108
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
EQI4 $114
ADDRLP4 8
INDIRI4
CNSTI4 2
NEI4 $112
LABELV $114
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
LABELV $112
line 151
;150:
;151:	for( i = 0; i < ASSAULT_MAX_POINTS; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $115
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
NEU4 $119
line 153
;153:			continue;
ADDRGP4 $116
JUMPV
LABELV $119
line 156
;154:		}
;155:
;156:		if( i == activePoint ) {
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
NEI4 $122
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
ADDRGP4 $116
JUMPV
LABELV $122
line 163
;161:		}
;162:
;163:		if( i == 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $125
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
ADDRGP4 $126
JUMPV
LABELV $125
line 168
;168:		else if( i == 1 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $128
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
ADDRGP4 $129
JUMPV
LABELV $128
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
LABELV $129
LABELV $126
line 178
;178:	}
LABELV $116
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
LTI4 $115
line 179
;179:}
LABELV $111
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
NEU4 $134
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
ADDRGP4 $137
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
ADDRGP4 $138
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
LABELV $134
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
LABELV $132
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
EQI4 $142
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
EQI4 $142
line 223
;223:		trap_AAS_AreaReachability(area) ) {
line 224
;224:		return area;
ADDRLP4 72
INDIRI4
RETI4
ADDRGP4 $141
JUMPV
LABELV $142
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
ADDRGP4 $149
JUMPV
LABELV $146
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
EQI4 $150
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
ADDRGP4 $141
JUMPV
LABELV $150
line 245
;244:		}
;245:	}
LABELV $147
line 241
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $149
ADDRLP4 0
INDIRI4
ADDRLP4 68
INDIRI4
LTI4 $146
line 247
;246:
;247:	return 0;
CNSTI4 0
RETI4
LABELV $141
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
NEI4 $155
ADDRLP4 0
INDIRI4
ADDRLP4 84
INDIRI4
NEI4 $155
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
GEF4 $155
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
ADDRGP4 $156
JUMPV
LABELV $155
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
LABELV $156
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
LABELV $152
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
ADDRGP4 $162
JUMPV
LABELV $161
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
NEI4 $164
line 313
;313:			continue;
ADDRGP4 $162
JUMPV
LABELV $164
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
EQI4 $166
line 319
;319:			continue;
ADDRGP4 $162
JUMPV
LABELV $166
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
LABELV $162
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
NEU4 $161
line 326
;326:}
LABELV $160
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
LEI4 $170
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $171
JUMPV
LABELV $170
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $171
ADDRLP4 4
INDIRI4
RETI4
LABELV $168
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
LTI4 $176
ADDRLP4 20
INDIRI4
CNSTI4 13
LEI4 $174
LABELV $176
line 366
;366:		choice > ASSAULT_MIDDLE_ITEM_COUNT ) {
line 367
;367:		choice = 0;
ADDRLP4 20
CNSTI4 0
ASGNI4
line 368
;368:	}
LABELV $174
line 373
;369:
;370:	/*
;371:	 * All: select uniformly from every supported entity.
;372:	 */
;373:	if( choice == 0 ) {
ADDRLP4 20
INDIRI4
CNSTI4 0
NEI4 $177
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
LABELV $179
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
LABELV $180
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
LTI4 $179
line 391
;390:
;391:		if( seen > 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
LEI4 $178
line 392
;392:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $172
JUMPV
line 394
;393:		}
;394:	}
LABELV $177
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
EQI4 $185
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
ADDRGP4 $172
JUMPV
LABELV $185
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
LABELV $188
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
EQI4 $192
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
ADDRGP4 $172
JUMPV
LABELV $192
line 424
;423:			}
;424:		}
LABELV $189
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
LTI4 $188
line 425
;425:	}
LABELV $178
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
EQI4 $214
ADDRLP4 36
CNSTI4 1
ASGNI4
ADDRGP4 $215
JUMPV
LABELV $214
ADDRLP4 36
CNSTI4 0
ASGNI4
LABELV $215
ADDRLP4 36
INDIRI4
RETI4
LABELV $172
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
ADDRGP4 $218
JUMPV
LABELV $217
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
LABELV $218
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
NEU4 $217
line 458
;458:}
LABELV $216
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
ADDRGP4 $224
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
NEI4 $222
line 476
;471:		"team_CTF_blueflag",
;472:		-1,
;473:		assault.points[0],
;474:		&assault.pointAreas[0],
;475:		&unusedItem
;476:	) ) {
line 477
;477:		G_Printf(
ADDRGP4 $227
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
ADDRGP4 $220
JUMPV
LABELV $222
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
ADDRGP4 $231
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
NEI4 $229
line 494
;489:		"team_CTF_redflag",
;490:		-1,
;491:		assault.points[2],
;492:		&assault.pointAreas[2],
;493:		&unusedItem
;494:	) ) {
line 495
;495:		G_Printf(
ADDRGP4 $236
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
ADDRGP4 $220
JUMPV
LABELV $229
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
NEI4 $239
line 510
;507:		assault.points[1],
;508:		&assault.pointAreas[1],
;509:		&selectedItem
;510:	) ) {
line 511
;511:		G_Printf(
ADDRGP4 $245
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
ADDRGP4 $220
JUMPV
LABELV $239
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
ADDRGP4 $224
ARGP4
ADDRGP4 AssaultRemoveMapClass
CALLV
pop
line 525
;523:		"team_CTF_blueflag"
;524:	);
;525:	AssaultRemoveMapClass(
ADDRGP4 $231
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
ADDRGP4 $251
JUMPV
LABELV $248
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
LABELV $249
line 529
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $251
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $248
line 533
;532:
;533:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $253
line 534
;534:		G_Printf(
ADDRGP4 $255
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
ADDRGP4 $254
JUMPV
LABELV $253
line 539
;539:	else {
line 540
;540:		G_Printf(
ADDRGP4 $256
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 543
;541:			"Assault: point B placed at map midpoint.\n"
;542:		);
;543:	}
LABELV $254
line 545
;544:
;545:	return qtrue;
CNSTI4 1
RETI4
LABELV $220
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
NEI4 $259
line 559
;557:		&redSpot,
;558:		&blueSpot
;559:	) ) {
line 560
;560:		G_Printf(
ADDRGP4 $261
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
ADDRGP4 $257
JUMPV
LABELV $259
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
NEI4 $265
line 578
;578:		G_Printf(
ADDRGP4 $268
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
ADDRGP4 $257
JUMPV
LABELV $265
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
NEI4 $276
line 598
;598:		G_Printf(
ADDRGP4 $280
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
ADDRGP4 $257
JUMPV
LABELV $276
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
NEI4 $283
line 613
;610:		assault.points[1],
;611:		&assault.pointAreas[1],
;612:		&selectedItem
;613:	) ) {
line 614
;614:		G_Printf(
ADDRGP4 $289
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
ADDRGP4 $257
JUMPV
LABELV $283
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
ADDRGP4 $295
JUMPV
LABELV $292
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
LABELV $293
line 622
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $295
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $292
line 626
;625:
;626:	if( selectedItem >= 0 ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
LTI4 $297
line 627
;627:		G_Printf(
ADDRGP4 $299
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
ADDRGP4 $298
JUMPV
LABELV $297
line 632
;632:	else {
line 633
;633:		G_Printf(
ADDRGP4 $300
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 636
;634:			"Assault TDM: point B placed at map midpoint.\n"
;635:		);
;636:	}
LABELV $298
line 638
;637:
;638:	return qtrue;
CNSTI4 1
RETI4
LABELV $257
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
EQI4 $302
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
ADDRGP4 $303
JUMPV
LABELV $302
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
LABELV $303
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
CNSTI4 808
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
NEI4 $319
ADDRLP4 0
INDIRI4
ADDRLP4 104
INDIRI4
NEI4 $319
ADDRLP4 0+8
INDIRF4
CNSTF4 1065353216
EQF4 $319
ADDRLP4 0+44
INDIRI4
CNSTI4 4
BANDI4
ADDRLP4 104
INDIRI4
EQI4 $312
LABELV $319
line 681
;679:		trace.allsolid ||
;680:		trace.fraction == 1.0f ||
;681:		(trace.surfaceFlags & SURF_SKY) ) {
line 682
;682:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $301
JUMPV
LABELV $312
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
LABELV $301
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
CNSTI4 808
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
EQI4 $322
line 697
;697:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $321
JUMPV
LABELV $322
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
EQI4 $324
line 701
;701:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $326
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
ADDRGP4 $321
JUMPV
LABELV $324
line 708
;706:	}
;707:
;708:	if( assault.editorClient == -1 ) {
ADDRGP4 assault+336
INDIRI4
CNSTI4 -1
NEI4 $327
line 709
;709:		assault.editorClient = clientNum;
ADDRGP4 assault+336
ADDRLP4 0
INDIRI4
ASGNI4
line 711
;710:
;711:		trap_SendServerCommand(
ADDRGP4 $331
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
LABELV $327
line 720
;719:
;720:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $332
line 721
;721:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $335
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
ADDRGP4 $321
JUMPV
LABELV $332
line 728
;726:	}
;727:
;728:	return qtrue;
CNSTI4 1
RETI4
LABELV $321
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
CNSTI4 808
DIVI4
ASGNI4
line 739
;738:
;739:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $337
line 740
;740:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $339
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 744
;741:			clientNum,
;742:			"print \"The match has already started.\n\""
;743:		);
;744:		return;
ADDRGP4 $336
JUMPV
LABELV $337
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
LTI4 $343
ADDRLP4 24
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $340
LABELV $343
line 748
;748:		trap_SendServerCommand(
ADDRGP4 $344
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
ADDRGP4 $336
JUMPV
LABELV $340
line 758
;756:	}
;757:
;758:	if( assault.editorClient != clientNum ) {
ADDRGP4 assault+336
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $346
line 759
;759:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $349
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 763
;760:			clientNum,
;761:			"print \"Use /assault_edit first.\n\""
;762:		);
;763:		return;
ADDRGP4 $336
JUMPV
LABELV $346
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
EQI4 $350
line 767
;767:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $326
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 771
;768:			clientNum,
;769:			"print \"Point placement requires spectator mode.\n\""
;770:		);
;771:		return;
ADDRGP4 $336
JUMPV
LABELV $350
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
NEI4 $352
line 775
;775:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $354
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 779
;776:			clientNum,
;777:			"print \"Unable to place a point there.\n\""
;778:		);
;779:		return;
ADDRGP4 $336
JUMPV
LABELV $352
line 782
;780:	}
;781:
;782:	for( otherPoint = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $358
JUMPV
LABELV $355
line 784
;783:		otherPoint < assault.pointCount;
;784:		otherPoint++ ) {
line 785
;785:		if( otherPoint == point ||
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $363
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $360
LABELV $363
line 786
;786:			!assault.pointSet[otherPoint] ) {
line 787
;787:			continue;
ADDRGP4 $356
JUMPV
LABELV $360
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
GEF4 $364
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
ADDRGP4 $367
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 800
;797:				clientNum,
;798:				"print \"The points are too close together.\n\""
;799:			);
;800:			return;
ADDRGP4 $336
JUMPV
LABELV $364
line 802
;801:		}
;802:	}
LABELV $356
line 784
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $358
line 783
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $355
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
ADDRGP4 $371
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
NEI4 $372
line 821
;821:		trap_SendServerCommand(
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 $374
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 825
;822:			clientNum,
;823:			"print \"Warning: the point has no AAS area; bots may not reach it.\n\""
;824:		);
;825:	}
LABELV $372
line 826
;826:}
LABELV $336
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
ADDRGP4 $379
JUMPV
LABELV $376
line 833
;833:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
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
EQU4 $383
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $381
LABELV $383
line 836
;836:			ent->client->pers.connected != CON_CONNECTED ) {
line 837
;837:			continue;
ADDRGP4 $377
JUMPV
LABELV $381
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
EQI4 $384
ADDRLP4 12
INDIRI4
CNSTI4 2
EQI4 $384
line 841
;841:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 842
;842:			continue;
ADDRGP4 $377
JUMPV
LABELV $384
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
LABELV $377
line 832
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $379
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $376
line 847
;847:}
LABELV $375
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
LEF4 $395
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
ADDRGP4 $396
JUMPV
LABELV $395
line 863
;863:	else {
line 864
;864:		normalLimit = 7 * 60 * 1000;
ADDRLP4 0
CNSTI4 420000
ASGNI4
line 865
;865:	}
LABELV $396
line 867
;866:
;867:	if( normalLimit < 30000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 30000
GEI4 $399
line 868
;868:		normalLimit = 30000;
ADDRLP4 0
CNSTI4 30000
ASGNI4
line 869
;869:	}
LABELV $399
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
NEI4 $402
line 874
;874:		assault.phase = ASSAULT_ROUND_RED;
ADDRGP4 assault
CNSTI4 1
ASGNI4
line 875
;875:	}
ADDRGP4 $403
JUMPV
LABELV $402
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
NEI4 $404
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+356
INDIRI4
GEI4 $404
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
LABELV $404
line 888
;888:	}
LABELV $403
line 890
;889:
;890:	level.startTime = level.time;
ADDRGP4 level+40
ADDRGP4 level+32
INDIRI4
ASGNI4
line 891
;891:	trap_SetConfigstring(
ADDRGP4 $416
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
ADDRGP4 $418
ARGP4
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $422
ADDRLP4 8
ADDRGP4 $419
ASGNP4
ADDRGP4 $423
JUMPV
LABELV $422
ADDRLP4 8
ADDRGP4 $420
ASGNP4
LABELV $423
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
LABELV $386
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
NEI4 $430
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $431
JUMPV
LABELV $430
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $431
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
NEI4 $437
ADDRLP4 4
CNSTI4 1
ASGNI4
ADDRGP4 $438
JUMPV
LABELV $437
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $438
ADDRGP4 level+44+8
ADDRLP4 4
INDIRI4
ASGNI4
line 918
;915:		assault.blueResult.completedPoints ==
;916:		assault.pointCount ? 1 : 0;
;917:
;918:	trap_SetConfigstring(
ADDRGP4 $416
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
ADDRGP4 $416
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
LABELV $424
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
LEI4 $444
line 937
;937:		assault.blueResult.completedPoints ) {
line 938
;938:		winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 939
;939:	}
ADDRGP4 $445
JUMPV
LABELV $444
line 940
;940:	else if( assault.blueResult.completedPoints >
ADDRGP4 assault+384
INDIRI4
ADDRGP4 assault+372
INDIRI4
LEI4 $448
line 941
;941:		assault.redResult.completedPoints ) {
line 942
;942:		winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 943
;943:	}
ADDRGP4 $449
JUMPV
LABELV $448
line 944
;944:	else if( assault.redResult.completedPoints == assault.pointCount ) {
ADDRGP4 assault+372
INDIRI4
ADDRGP4 assault+332
INDIRI4
NEI4 $452
line 945
;945:		if( assault.redResult.elapsedTime <
ADDRGP4 assault+372+8
INDIRI4
ADDRGP4 assault+384+8
INDIRI4
GEI4 $456
line 946
;946:			assault.blueResult.elapsedTime ) {
line 947
;947:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 948
;948:		}
ADDRGP4 $453
JUMPV
LABELV $456
line 949
;949:		else if( assault.blueResult.elapsedTime <
ADDRGP4 assault+384+8
INDIRI4
ADDRGP4 assault+372+8
INDIRI4
GEI4 $453
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
ADDRGP4 $453
JUMPV
LABELV $452
line 954
;954:	else {
line 955
;955:		if( assault.redResult.progress >
ADDRGP4 assault+372+4
INDIRI4
ADDRGP4 assault+384+4
INDIRI4
LEI4 $468
line 956
;956:			assault.blueResult.progress ) {
line 957
;957:			winner = TEAM_RED;
ADDRLP4 0
CNSTI4 1
ASGNI4
line 958
;958:		}
ADDRGP4 $469
JUMPV
LABELV $468
line 959
;959:		else if( assault.blueResult.progress >
ADDRGP4 assault+384+4
INDIRI4
ADDRGP4 assault+372+4
INDIRI4
LEI4 $474
line 960
;960:			assault.redResult.progress ) {
line 961
;961:			winner = TEAM_BLUE;
ADDRLP4 0
CNSTI4 2
ASGNI4
line 962
;962:		}
LABELV $474
LABELV $469
line 963
;963:	}
LABELV $453
LABELV $449
LABELV $445
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
NEI4 $480
line 970
;970:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $482
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 974
;971:			-1,
;972:			"cp \"Red team wins Assault\""
;973:		);
;974:		LogExit( "Red team won Assault." );
ADDRGP4 $483
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 975
;975:	}
ADDRGP4 $481
JUMPV
LABELV $480
line 976
;976:	else if( winner == TEAM_BLUE ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $484
line 977
;977:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $486
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 981
;978:			-1,
;979:			"cp \"Blue team wins Assault\""
;980:		);
;981:		LogExit( "Blue team won Assault." );
ADDRGP4 $487
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 982
;982:	}
ADDRGP4 $485
JUMPV
LABELV $484
line 983
;983:	else {
line 984
;984:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $488
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 988
;985:			-1,
;986:			"cp \"Assault ended in a draw\""
;987:		);
;988:		LogExit( "Assault draw." );
ADDRGP4 $489
ARGP4
ADDRGP4 LogExit
CALLI4
pop
line 989
;989:	}
LABELV $485
LABELV $481
line 990
;990:}
LABELV $443
endproc AssaultFinishMatch 4 8
proc AssaultStoreRoundResult 4 4
line 992
;991:
;992:static void AssaultStoreRoundResult( qboolean completed ) {
line 995
;993:	assaultResult_t *result;
;994:
;995:	AssaultUpdateScores();
ADDRGP4 AssaultUpdateScores
CALLV
pop
line 996
;996:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $491
line 997
;997:		result = &assault.redResult;
ADDRLP4 0
ADDRGP4 assault+372
ASGNP4
line 998
;998:	}
ADDRGP4 $492
JUMPV
LABELV $491
line 999
;999:	else {
line 1000
;1000:		result = &assault.blueResult;
ADDRLP4 0
ADDRGP4 assault+384
ASGNP4
line 1001
;1001:	}
LABELV $492
line 1003
;1002:
;1003:	if( completed ) {
ADDRFP4 0
INDIRI4
CNSTI4 0
EQI4 $496
line 1004
;1004:		result->completedPoints = assault.pointCount;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+332
INDIRI4
ASGNI4
line 1005
;1005:		result->progress = (int)(g_assaultHoldTime.value * 1000.0f);
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
line 1006
;1006:		result->elapsedTime =
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
line 1008
;1007:			level.time - assault.roundStartTime;
;1008:	}
ADDRGP4 $497
JUMPV
LABELV $496
line 1009
;1009:	else {
line 1010
;1010:		result->completedPoints = assault.activeStage;
ADDRLP4 0
INDIRP4
ADDRGP4 assault+340
INDIRI4
ASGNI4
line 1011
;1011:		result->progress = assault.captureProgress;
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRGP4 assault+344
INDIRI4
ASGNI4
line 1012
;1012:		result->elapsedTime = assault.roundLimit;
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRGP4 assault+356
INDIRI4
ASGNI4
line 1013
;1013:	}
LABELV $497
line 1015
;1014:
;1015:	if( assault.attackingTeam == TEAM_RED ) {
ADDRGP4 assault+368
INDIRI4
CNSTI4 1
NEI4 $505
line 1016
;1016:		AssaultStartRound( TEAM_BLUE );
CNSTI4 2
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1017
;1017:	}
ADDRGP4 $506
JUMPV
LABELV $505
line 1018
;1018:	else {
line 1019
;1019:		AssaultFinishMatch();
ADDRGP4 AssaultFinishMatch
CALLV
pop
line 1020
;1020:	}
LABELV $506
line 1021
;1021:}
LABELV $490
endproc AssaultStoreRoundResult 4 4
proc AssaultCompletePoint 32 8
line 1023
;1022:
;1023:static void AssaultCompletePoint( void ) {
line 1026
;1024:	int completedPoint;
;1025:
;1026:	completedPoint = AssaultActualPoint();
ADDRLP4 4
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 4
INDIRI4
ASGNI4
line 1028
;1027:
;1028:	trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $509
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
line 1036
;1029:		-1,
;1030:		va(
;1031:			"cp \"Point %s captured\"",
;1032:			AssaultPointName(completedPoint)
;1033:		)
;1034:	);
;1035:
;1036:	assault.activeStage++;
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
line 1037
;1037:	assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1038
;1038:	assault.announcedQuarter = 0;
ADDRGP4 assault+348
CNSTI4 0
ASGNI4
line 1040
;1039:
;1040:	if( assault.activeStage >= assault.pointCount ) {
ADDRGP4 assault+340
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $513
line 1041
;1041:		AssaultStoreRoundResult( qtrue );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1042
;1042:		return;
ADDRGP4 $508
JUMPV
LABELV $513
line 1045
;1043:	}
;1044:
;1045:	AssaultUpdateMarkers();
ADDRGP4 AssaultUpdateMarkers
CALLV
pop
line 1047
;1046:
;1047:	trap_SendServerCommand(
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
ADDRGP4 $517
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
line 1054
;1048:		-1,
;1049:		va(
;1050:			"cp \"Attack point %s\"",
;1051:			AssaultPointName(AssaultActualPoint())
;1052:		)
;1053:	);
;1054:}
LABELV $508
endproc AssaultCompletePoint 32 8
proc AssaultCountPlayers 28 8
line 1060
;1055:
;1056:static void AssaultCountPlayers(
;1057:	int point,
;1058:	int *attackers,
;1059:	int *defenders
;1060:) {
line 1065
;1061:	int i;
;1062:	float radiusSquared;
;1063:	gentity_t *ent;
;1064:
;1065:	*attackers = 0;
ADDRFP4 4
INDIRP4
CNSTI4 0
ASGNI4
line 1066
;1066:	*defenders = 0;
ADDRFP4 8
INDIRP4
CNSTI4 0
ASGNI4
line 1068
;1067:
;1068:	radiusSquared =
ADDRLP4 8
ADDRGP4 g_assaultRadius+8
INDIRF4
ADDRGP4 g_assaultRadius+8
INDIRF4
MULF4
ASGNF4
line 1072
;1069:		g_assaultRadius.value *
;1070:		g_assaultRadius.value;
;1071:
;1072:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $524
JUMPV
LABELV $521
line 1073
;1073:		ent = &g_entities[i];
ADDRLP4 0
CNSTI4 808
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1075
;1074:
;1075:		if( !ent->client ||
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
EQU4 $529
ADDRLP4 12
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
NEI4 $529
ADDRLP4 12
INDIRP4
CNSTI4 184
ADDP4
INDIRI4
CNSTI4 0
GTI4 $526
LABELV $529
line 1077
;1076:			ent->client->pers.connected != CON_CONNECTED ||
;1077:			ent->client->ps.stats[STAT_HEALTH] <= 0 ) {
line 1078
;1078:			continue;
ADDRGP4 $522
JUMPV
LABELV $526
line 1081
;1079:		}
;1080:
;1081:		if( ent->client->sess.sessionTeam != TEAM_RED &&
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
EQI4 $530
ADDRLP4 16
INDIRI4
CNSTI4 2
EQI4 $530
line 1082
;1082:			ent->client->sess.sessionTeam != TEAM_BLUE ) {
line 1083
;1083:			continue;
ADDRGP4 $522
JUMPV
LABELV $530
line 1086
;1084:		}
;1085:
;1086:		if( DistanceSquared(
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
LEF4 $532
line 1089
;1087:			ent->client->ps.origin,
;1088:			assault.points[point]
;1089:		) > radiusSquared ) {
line 1090
;1090:			continue;
ADDRGP4 $522
JUMPV
LABELV $532
line 1093
;1091:		}
;1092:
;1093:		if( ent->client->sess.sessionTeam ==
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
NEI4 $535
line 1094
;1094:			assault.attackingTeam ) {
line 1095
;1095:			(*attackers)++;
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
line 1096
;1096:		}
ADDRGP4 $536
JUMPV
LABELV $535
line 1097
;1097:		else {
line 1098
;1098:			(*defenders)++;
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
line 1099
;1099:		}
LABELV $536
line 1100
;1100:	}
LABELV $522
line 1072
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $524
ADDRLP4 4
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $521
line 1101
;1101:}
LABELV $518
endproc AssaultCountPlayers 28 8
proc AssaultStartMatch 20 12
line 1103
;1102:
;1103:static void AssaultStartMatch( gentity_t *ent ) {
line 1107
;1104:	int clientNum;
;1105:	int i;
;1106:
;1107:	clientNum = ent ? ent - g_entities : -1;
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $540
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
ADDRGP4 $541
JUMPV
LABELV $540
ADDRLP4 8
CNSTI4 -1
ASGNI4
LABELV $541
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1109
;1108:
;1109:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $542
line 1110
;1110:		ASSAULT_MODE_EDITOR ) {
line 1111
;1111:		if( !ent ||
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $548
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $545
LABELV $548
line 1112
;1112:			assault.editorClient != clientNum ) {
line 1113
;1113:			trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $549
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1117
;1114:				clientNum,
;1115:				"print \"Only the point editor can start the match.\n\""
;1116:			);
;1117:			return;
ADDRGP4 $538
JUMPV
LABELV $545
line 1119
;1118:		}
;1119:	}
LABELV $542
line 1121
;1120:
;1121:	for( i = 0; i < assault.pointCount; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $553
JUMPV
LABELV $550
line 1122
;1122:		if( !assault.pointSet[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
INDIRI4
CNSTI4 0
NEI4 $555
line 1123
;1123:			trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $558
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
line 1130
;1124:				clientNum,
;1125:				va(
;1126:					"print \"Assault: points are invalid. Point %s is missing.\n\"",
;1127:					AssaultPointName(i)
;1128:				)
;1129:			);
;1130:			return;
ADDRGP4 $538
JUMPV
LABELV $555
line 1132
;1131:		}
;1132:	}
LABELV $551
line 1121
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $553
ADDRLP4 0
INDIRI4
ADDRGP4 assault+332
INDIRI4
LTI4 $550
line 1134
;1133:
;1134:	if( TeamCount(-1, TEAM_RED) < 1 ||
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
LTI4 $561
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
GEI4 $559
LABELV $561
line 1135
;1135:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1136
;1136:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $562
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1140
;1137:			clientNum,
;1138:			"print \"Both teams need at least one player.\n\""
;1139:		);
;1140:		return;
ADDRGP4 $538
JUMPV
LABELV $559
line 1143
;1141:	}
;1142:
;1143:	level.warmupTime = 0;
ADDRGP4 level+16
CNSTI4 0
ASGNI4
line 1144
;1144:	trap_SetConfigstring( CS_WARMUP, "0" );
CNSTI4 5
ARGI4
ADDRGP4 $564
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1146
;1145:
;1146:	memset(
ADDRGP4 assault+372
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1151
;1147:		&assault.redResult,
;1148:		0,
;1149:		sizeof(assault.redResult)
;1150:	);
;1151:	memset(
ADDRGP4 assault+384
ARGP4
CNSTI4 0
ARGI4
CNSTI4 12
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1157
;1152:		&assault.blueResult,
;1153:		0,
;1154:		sizeof(assault.blueResult)
;1155:	);
;1156:	
;1157:	level.teamScores[TEAM_RED] = 0;
ADDRGP4 level+44+4
CNSTI4 0
ASGNI4
line 1158
;1158:	level.teamScores[TEAM_BLUE] = 0;
ADDRGP4 level+44+8
CNSTI4 0
ASGNI4
line 1160
;1159:
;1160:	trap_SetConfigstring( CS_SCORES1, "0" );
CNSTI4 6
ARGI4
ADDRGP4 $564
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1161
;1161:	trap_SetConfigstring( CS_SCORES2, "0" );
CNSTI4 7
ARGI4
ADDRGP4 $564
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1163
;1162:
;1163:	AssaultStartRound( TEAM_RED );
CNSTI4 1
ARGI4
ADDRGP4 AssaultStartRound
CALLV
pop
line 1164
;1164:}
LABELV $538
endproc AssaultStartMatch 20 12
proc AssaultSetPointCount 24 12
line 1170
;1165:
;1166:
;1167:static void AssaultSetPointCount(
;1168:	gentity_t *ent,
;1169:	int pointCount
;1170:) {
line 1174
;1171:	int i;
;1172:	int clientNum;
;1173:
;1174:	clientNum = ent - g_entities;
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
line 1176
;1175:
;1176:	if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $574
line 1177
;1177:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $339
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1181
;1178:			clientNum,
;1179:			"print \"The match has already started.\n\""
;1180:		);
;1181:		return;
ADDRGP4 $573
JUMPV
LABELV $574
line 1184
;1182:	}
;1183:
;1184:	if( ent->r.svFlags & SVF_BOT ) {
ADDRFP4 0
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $576
line 1185
;1185:		return;
ADDRGP4 $573
JUMPV
LABELV $576
line 1188
;1186:	}
;1187:
;1188:	if( pointCount < 1 ||
ADDRLP4 8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
LTI4 $580
ADDRLP4 8
INDIRI4
CNSTI4 3
LEI4 $578
LABELV $580
line 1189
;1189:		pointCount > ASSAULT_MAX_POINTS ) {
line 1190
;1190:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $581
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1194
;1191:			clientNum,
;1192:			"print \"Usage: /assault_set 1|2|3\n\""
;1193:		);
;1194:		return;
ADDRGP4 $573
JUMPV
LABELV $578
line 1197
;1195:	}
;1196:
;1197:	if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $582
ADDRGP4 assault+336
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $582
line 1198
;1198:		assault.editorClient != clientNum ) {
line 1199
;1199:		trap_SendServerCommand(
ADDRLP4 4
INDIRI4
ARGI4
ADDRGP4 $586
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1203
;1200:			clientNum,
;1201:			"print \"Another player is editing Assault.\n\""
;1202:		);
;1203:		return;
ADDRGP4 $573
JUMPV
LABELV $582
line 1206
;1204:	}
;1205:
;1206:	for( i = pointCount;
ADDRLP4 0
ADDRFP4 4
INDIRI4
ASGNI4
ADDRGP4 $590
JUMPV
LABELV $587
line 1208
;1207:		i < ASSAULT_MAX_POINTS;
;1208:		i++ ) {
line 1209
;1209:		if( assault.markers[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $591
line 1210
;1210:			G_FreeEntity( assault.markers[i] );
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
line 1211
;1211:			assault.markers[i] = NULL;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+64
ADDP4
CNSTP4 0
ASGNP4
line 1212
;1212:		}
LABELV $591
line 1214
;1213:
;1214:		assault.pointSet[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+52
ADDP4
CNSTI4 0
ASGNI4
line 1215
;1215:		assault.pointAreas[i] = 0;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+40
ADDP4
CNSTI4 0
ASGNI4
line 1216
;1216:		VectorClear( assault.points[i] );
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
line 1217
;1217:	}
LABELV $588
line 1208
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $590
line 1207
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $587
line 1219
;1218:
;1219:	assault.pointCount = pointCount;
ADDRGP4 assault+332
ADDRFP4 4
INDIRI4
ASGNI4
line 1221
;1220:
;1221:	trap_SendServerCommand(
ADDRGP4 $604
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
NEI4 $608
ADDRLP4 12
ADDRGP4 $605
ASGNP4
ADDRGP4 $609
JUMPV
LABELV $608
ADDRLP4 12
ADDRGP4 $606
ASGNP4
LABELV $609
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
line 1229
;1222:		-1,
;1223:		va(
;1224:			"print \"Assault will use %i point%s.\n\"",
;1225:			pointCount,
;1226:			pointCount == 1 ? "" : "s"
;1227:		)
;1228:	);
;1229:}
LABELV $573
endproc AssaultSetPointCount 24 12
export G_AssaultClientCommand
proc G_AssaultClientCommand 1048 12
line 1234
;1230:
;1231:qboolean G_AssaultClientCommand(
;1232:	gentity_t *ent,
;1233:	const char *cmd
;1234:) {
line 1238
;1235:	char arg[MAX_TOKEN_CHARS];
;1236:	int value;
;1237:
;1238:	if( !G_AssaultEnabled() ) {
ADDRLP4 1028
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 1028
INDIRI4
CNSTI4 0
NEI4 $611
line 1239
;1239:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $610
JUMPV
LABELV $611
line 1242
;1240:	}
;1241:
;1242:	if( !Q_stricmp(cmd, "assault_set") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $615
ARGP4
ADDRLP4 1032
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CNSTI4 0
NEI4 $613
line 1243
;1243:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1244
;1244:		AssaultSetPointCount( ent, atoi(arg) );
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
line 1245
;1245:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $610
JUMPV
LABELV $613
line 1248
;1246:	}
;1247:
;1248:	if( !Q_stricmp(cmd, "assault_edit") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $618
ARGP4
ADDRLP4 1036
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1036
INDIRI4
CNSTI4 0
NEI4 $616
line 1249
;1249:		if( assault.phase != ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
EQI4 $619
line 1250
;1250:			trap_SendServerCommand(
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
ADDRGP4 $339
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1254
;1251:				ent - g_entities,
;1252:				"print \"The match has already started.\n\""
;1253:			);
;1254:			return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $610
JUMPV
LABELV $619
line 1257
;1255:		}
;1256:
;1257:		AssaultClaimEditor( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultClaimEditor
CALLI4
pop
line 1258
;1258:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $610
JUMPV
LABELV $616
line 1261
;1259:	}
;1260:
;1261:	if( !Q_stricmp(cmd, "assault_place") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $623
ARGP4
ADDRLP4 1040
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1040
INDIRI4
CNSTI4 0
NEI4 $621
line 1262
;1262:		trap_Argv( 1, arg, sizeof(arg) );
CNSTI4 1
ARGI4
ADDRLP4 0
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 trap_Argv
CALLV
pop
line 1263
;1263:		value = atoi(arg) - 1;
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
line 1264
;1264:		AssaultPlacePoint( ent, value );
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 1024
INDIRI4
ARGI4
ADDRGP4 AssaultPlacePoint
CALLV
pop
line 1265
;1265:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $610
JUMPV
LABELV $621
line 1268
;1266:	}
;1267:
;1268:	if( !Q_stricmp(cmd, "assault_ready") ) {
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $626
ARGP4
ADDRLP4 1044
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 1044
INDIRI4
CNSTI4 0
NEI4 $624
line 1269
;1269:		AssaultStartMatch( ent );
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1270
;1270:		return qtrue;
CNSTI4 1
RETI4
ADDRGP4 $610
JUMPV
LABELV $624
line 1273
;1271:	}
;1272:
;1273:	return qfalse;
CNSTI4 0
RETI4
LABELV $610
endproc G_AssaultClientCommand 1048 12
export G_AssaultInit
proc G_AssaultInit 12 12
line 1276
;1274:}
;1275:
;1276:void G_AssaultInit( void ) {
line 1277
;1277:	memset( &assault, 0, sizeof(assault) );
ADDRGP4 assault
ARGP4
CNSTI4 0
ARGI4
CNSTI4 396
ARGI4
ADDRGP4 memset
CALLP4
pop
line 1279
;1278:
;1279:	assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1280
;1280:	assault.phase = ASSAULT_SETUP;
ADDRGP4 assault
CNSTI4 0
ASGNI4
line 1282
;1281:
;1282:	if( !G_AssaultEnabled() ) {
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $629
line 1283
;1283:		return;
ADDRGP4 $627
JUMPV
LABELV $629
line 1286
;1284:	}
;1285:
;1286:	level.warmupTime = -1;
ADDRGP4 level+16
CNSTI4 -1
ASGNI4
line 1287
;1287:	trap_SetConfigstring( CS_WARMUP, "-1" );
CNSTI4 5
ARGI4
ADDRGP4 $632
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
line 1289
;1288:
;1289:if( g_assaultMode.integer == ASSAULT_MODE_BASE ||
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 1
EQI4 $637
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $633
LABELV $637
line 1290
;1290:	g_assaultMode.integer == ASSAULT_MODE_TDM_BASE ) {
line 1293
;1291:	qboolean setupResult;
;1292:
;1293:	assault.pointCount = 3;
ADDRGP4 assault+332
CNSTI4 3
ASGNI4
line 1295
;1294:
;1295:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 3
NEI4 $639
line 1296
;1296:		ASSAULT_MODE_TDM_BASE ) {
line 1297
;1297:		setupResult =
ADDRLP4 8
ADDRGP4 AssaultSetupTDMBasePoints
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1299
;1298:			AssaultSetupTDMBasePoints();
;1299:	}
ADDRGP4 $640
JUMPV
LABELV $639
line 1300
;1300:	else {
line 1301
;1301:		setupResult =
ADDRLP4 8
ADDRGP4 AssaultSetupBasePoints
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 8
INDIRI4
ASGNI4
line 1303
;1302:			AssaultSetupBasePoints();
;1303:	}
LABELV $640
line 1305
;1304:
;1305:	if( setupResult ) {
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $642
line 1306
;1306:		G_Printf(
ADDRGP4 $644
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1309
;1307:			"Assault: automatic points ready; waiting for teams.\n"
;1308:		);
;1309:	}
ADDRGP4 $627
JUMPV
LABELV $642
line 1310
;1310:	else {
line 1311
;1311:		G_Printf(
ADDRGP4 $645
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1314
;1312:			"Assault: automatic setup failed.\n"
;1313:		);
;1314:	}
line 1316
;1315:
;1316:	return;
ADDRGP4 $627
JUMPV
LABELV $633
line 1319
;1317:}
;1318:
;1319:	assault.pointCount = ASSAULT_DEFAULT_POINTS;
ADDRGP4 assault+332
CNSTI4 2
ASGNI4
line 1321
;1320:
;1321:	G_Printf(
ADDRGP4 $647
ARGP4
ADDRGP4 G_Printf
CALLV
pop
line 1324
;1322:		"Assault Editor: waiting for point placement.\n"
;1323:	);
;1324:}
LABELV $627
endproc G_AssaultInit 12 12
export G_AssaultBlocksWarmup
proc G_AssaultBlocksWarmup 12 0
line 1326
;1325:
;1326:qboolean G_AssaultBlocksWarmup( void ) {
line 1327
;1327:	return G_AssaultEnabled() &&
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
EQI4 $650
ADDRGP4 assault
INDIRI4
ADDRLP4 8
INDIRI4
NEI4 $650
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $651
JUMPV
LABELV $650
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $651
ADDRLP4 0
INDIRI4
RETI4
LABELV $648
endproc G_AssaultBlocksWarmup 12 0
export G_AssaultControlsExitRules
proc G_AssaultControlsExitRules 4 0
line 1331
;1328:		assault.phase == ASSAULT_SETUP;
;1329:}
;1330:
;1331:qboolean G_AssaultControlsExitRules( void ) {
line 1332
;1332:	return G_AssaultEnabled();
ADDRLP4 0
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
RETI4
LABELV $652
endproc G_AssaultControlsExitRules 4 0
export G_AssaultGetActiveGoal
proc G_AssaultGetActiveGoal 16 0
line 1339
;1333:}
;1334:
;1335:qboolean G_AssaultGetActiveGoal(
;1336:	vec3_t origin,
;1337:	int *area,
;1338:	team_t *attackingTeam
;1339:) {
line 1342
;1340:	int point;
;1341:
;1342:	if( !G_AssaultEnabled() ||
ADDRLP4 4
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $656
ADDRLP4 8
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1
EQI4 $654
ADDRLP4 8
INDIRI4
CNSTI4 2
EQI4 $654
LABELV $656
line 1344
;1343:		(assault.phase != ASSAULT_ROUND_RED &&
;1344:		 assault.phase != ASSAULT_ROUND_BLUE) ) {
line 1345
;1345:		return qfalse;
CNSTI4 0
RETI4
ADDRGP4 $653
JUMPV
LABELV $654
line 1348
;1346:	}
;1347:
;1348:	point = AssaultActualPoint();
ADDRLP4 12
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 0
ADDRLP4 12
INDIRI4
ASGNI4
line 1350
;1349:
;1350:	VectorCopy( assault.points[point], origin );
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
line 1351
;1351:	*area = assault.pointAreas[point];
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
line 1352
;1352:	*attackingTeam = assault.attackingTeam;
ADDRFP4 8
INDIRP4
ADDRGP4 assault+368
INDIRI4
ASGNI4
line 1354
;1353:
;1354:	return qtrue;
CNSTI4 1
RETI4
LABELV $653
endproc G_AssaultGetActiveGoal 16 0
proc AssaultShowInstructions 12 8
line 1357
;1355:}
;1356:
;1357:static void AssaultShowInstructions( void ) {
line 1361
;1358:	int i;
;1359:	gentity_t *ent;
;1360:
;1361:	for( i = 0; i < level.maxclients; i++ ) {
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $664
JUMPV
LABELV $661
line 1362
;1362:		ent = &g_entities[i];
ADDRLP4 4
CNSTI4 808
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
line 1364
;1363:
;1364:		if( !ent->client ||
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
EQU4 $668
ADDRLP4 8
INDIRP4
CNSTI4 468
ADDP4
INDIRI4
CNSTI4 2
EQI4 $666
LABELV $668
line 1365
;1365:			ent->client->pers.connected != CON_CONNECTED ) {
line 1366
;1366:			assault.instructionsShown[i] = qfalse;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 0
ASGNI4
line 1367
;1367:			continue;
ADDRGP4 $662
JUMPV
LABELV $666
line 1370
;1368:		}
;1369:
;1370:		if( ent->r.svFlags & SVF_BOT ) {
ADDRLP4 4
INDIRP4
CNSTI4 424
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $670
line 1371
;1371:			continue;
ADDRGP4 $662
JUMPV
LABELV $670
line 1374
;1372:		}
;1373:
;1374:		if( assault.instructionsShown[i] ) {
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
INDIRI4
CNSTI4 0
EQI4 $672
line 1375
;1375:			continue;
ADDRGP4 $662
JUMPV
LABELV $672
line 1378
;1376:		}
;1377:
;1378:		assault.instructionsShown[i] = qtrue;
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 assault+76
ADDP4
CNSTI4 1
ASGNI4
line 1380
;1379:
;1380:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $676
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1384
;1381:			i,
;1382:			"print \"\n=== ASSAULT SETUP ===\n\""
;1383:		);
;1384:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $677
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1388
;1385:			i,
;1386:			"print \"Set point count: /assault_set 1, 2 or 3\n\""
;1387:		);
;1388:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $678
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1392
;1389:			i,
;1390:			"print \"Enter spectator mode: /team spectator\n\""
;1391:		);
;1392:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $679
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1396
;1393:			i,
;1394:			"print \"Begin editing: /assault_edit\n\""
;1395:		);
;1396:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $680
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1400
;1397:			i,
;1398:			"print \"Aim and place points: /assault_place 1|2|3\n\""
;1399:		);
;1400:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $681
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1404
;1401:			i,
;1402:			"print \"After placement, join Red or Blue team.\n\""
;1403:		);
;1404:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $682
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1408
;1405:			i,
;1406:			"print \"IMPORTANT: add bots before starting the match.\n\""
;1407:		);
;1408:		trap_SendServerCommand(
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 $683
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1412
;1409:			i,
;1410:			"print \"Start the match: /assault_ready\n\n\""
;1411:		);
;1412:	}
LABELV $662
line 1361
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $664
ADDRLP4 0
INDIRI4
ADDRGP4 level+24
INDIRI4
LTI4 $661
line 1413
;1413:}
LABELV $660
endproc AssaultShowInstructions 12 8
proc AssaultCurrentHoldTime 8 0
line 1415
;1414:
;1415:static int AssaultCurrentHoldTime( void ) {
line 1419
;1416:	int holdTime;
;1417:	int multiplier;
;1418:
;1419:	multiplier = 1 << assault.activeStage;
ADDRLP4 4
CNSTI4 1
ADDRGP4 assault+340
INDIRI4
LSHI4
ASGNI4
line 1421
;1420:
;1421:	holdTime = (int)(
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
line 1427
;1422:		g_assaultHoldTime.value *
;1423:		1000.0f *
;1424:		multiplier
;1425:	);
;1426:
;1427:	if( holdTime < 1000 ) {
ADDRLP4 0
INDIRI4
CNSTI4 1000
GEI4 $687
line 1428
;1428:		holdTime = 1000;
ADDRLP4 0
CNSTI4 1000
ASGNI4
line 1429
;1429:	}
LABELV $687
line 1431
;1430:
;1431:	return holdTime;
ADDRLP4 0
INDIRI4
RETI4
LABELV $684
endproc AssaultCurrentHoldTime 8 0
export G_AssaultRunFrame
proc G_AssaultRunFrame 56 12
line 1434
;1432:}
;1433:
;1434:void G_AssaultRunFrame( void ) {
line 1442
;1435:	int point;
;1436:	int attackers;
;1437:	int defenders;
;1438:	int frameTime;
;1439:	int holdTime;
;1440:	int quarter;
;1441:
;1442:	if( !G_AssaultEnabled() ) {
ADDRLP4 24
ADDRGP4 G_AssaultEnabled
CALLI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
NEI4 $690
line 1443
;1443:		return;
ADDRGP4 $689
JUMPV
LABELV $690
line 1446
;1444:	}
;1445:
;1446:if( assault.phase == ASSAULT_SETUP ) {
ADDRGP4 assault
INDIRI4
CNSTI4 0
NEI4 $692
line 1447
;1447:	if( g_assaultMode.integer ==
ADDRGP4 g_assaultMode+12
INDIRI4
CNSTI4 2
NEI4 $694
line 1448
;1448:		ASSAULT_MODE_EDITOR ) {
line 1449
;1449:		AssaultShowInstructions();
ADDRGP4 AssaultShowInstructions
CALLV
pop
line 1451
;1450:
;1451:		if( assault.editorClient >= 0 &&
ADDRGP4 assault+336
INDIRI4
CNSTI4 0
LTI4 $689
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
EQI4 $689
line 1453
;1452:			level.clients[assault.editorClient].
;1453:				pers.connected != CON_CONNECTED ) {
line 1454
;1454:			assault.editorClient = -1;
ADDRGP4 assault+336
CNSTI4 -1
ASGNI4
line 1455
;1455:		}
line 1457
;1456:
;1457:		return;
ADDRGP4 $689
JUMPV
LABELV $694
line 1460
;1458:	}
;1459:
;1460:	if( !assault.pointSet[0] ||
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 assault+52
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $710
ADDRGP4 assault+52+4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $710
ADDRGP4 assault+52+8
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $702
LABELV $710
line 1462
;1461:		!assault.pointSet[1] ||
;1462:		!assault.pointSet[2] ) {
line 1463
;1463:		return;
ADDRGP4 $689
JUMPV
LABELV $702
line 1466
;1464:	}
;1465:
;1466:	if( TeamCount(-1, TEAM_RED) < 1 ||
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
LTI4 $713
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
GEI4 $711
LABELV $713
line 1467
;1467:		TeamCount(-1, TEAM_BLUE) < 1 ) {
line 1468
;1468:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1469
;1469:		return;
ADDRGP4 $689
JUMPV
LABELV $711
line 1472
;1470:	}
;1471:
;1472:	if( !assault.autoStartTime ) {
ADDRGP4 assault+364
INDIRI4
CNSTI4 0
NEI4 $715
line 1473
;1473:		assault.autoStartTime =
ADDRGP4 assault+364
ADDRGP4 level+32
INDIRI4
CNSTI4 2000
ADDI4
ASGNI4
line 1476
;1474:			level.time + ASSAULT_AUTO_START_DELAY;
;1475:
;1476:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $720
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1480
;1477:			-1,
;1478:			"cp \"Base Assault starts in 2 seconds\""
;1479:		);
;1480:		return;
ADDRGP4 $689
JUMPV
LABELV $715
line 1483
;1481:	}
;1482:
;1483:	if( level.time >= assault.autoStartTime ) {
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+364
INDIRI4
LTI4 $689
line 1484
;1484:		assault.autoStartTime = 0;
ADDRGP4 assault+364
CNSTI4 0
ASGNI4
line 1485
;1485:		AssaultStartMatch( NULL );
CNSTP4 0
ARGP4
ADDRGP4 AssaultStartMatch
CALLV
pop
line 1486
;1486:	}
line 1488
;1487:
;1488:	return;
ADDRGP4 $689
JUMPV
LABELV $692
line 1491
;1489:}
;1490:
;1491:	if( assault.phase != ASSAULT_ROUND_RED &&
ADDRLP4 28
ADDRGP4 assault
INDIRI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1
EQI4 $726
ADDRLP4 28
INDIRI4
CNSTI4 2
EQI4 $726
line 1492
;1492:		assault.phase != ASSAULT_ROUND_BLUE ) {
line 1493
;1493:		return;
ADDRGP4 $689
JUMPV
LABELV $726
line 1496
;1494:	}
;1495:
;1496:	if( level.time - assault.roundStartTime >=
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+352
INDIRI4
SUBI4
ADDRGP4 assault+356
INDIRI4
LTI4 $728
line 1497
;1497:		assault.roundLimit ) {
line 1498
;1498:		trap_SendServerCommand(
CNSTI4 -1
ARGI4
ADDRGP4 $733
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
line 1502
;1499:			-1,
;1500:			"cp \"Assault round time expired\""
;1501:		);
;1502:		AssaultStoreRoundResult( qfalse );
CNSTI4 0
ARGI4
ADDRGP4 AssaultStoreRoundResult
CALLV
pop
line 1503
;1503:		return;
ADDRGP4 $689
JUMPV
LABELV $728
line 1506
;1504:	}
;1505:
;1506:	frameTime = level.time - assault.lastFrameTime;
ADDRLP4 0
ADDRGP4 level+32
INDIRI4
ADDRGP4 assault+360
INDIRI4
SUBI4
ASGNI4
line 1507
;1507:	assault.lastFrameTime = level.time;
ADDRGP4 assault+360
ADDRGP4 level+32
INDIRI4
ASGNI4
line 1509
;1508:
;1509:	if( frameTime < 0 ) {
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $738
line 1510
;1510:		frameTime = 0;
ADDRLP4 0
CNSTI4 0
ASGNI4
line 1511
;1511:	}
ADDRGP4 $739
JUMPV
LABELV $738
line 1512
;1512:	else if( frameTime > 200 ) {
ADDRLP4 0
INDIRI4
CNSTI4 200
LEI4 $740
line 1513
;1513:		frameTime = 200;
ADDRLP4 0
CNSTI4 200
ASGNI4
line 1514
;1514:	}
LABELV $740
LABELV $739
line 1516
;1515:
;1516:	point = AssaultActualPoint();
ADDRLP4 32
ADDRGP4 AssaultActualPoint
CALLI4
ASGNI4
ADDRLP4 12
ADDRLP4 32
INDIRI4
ASGNI4
line 1518
;1517:
;1518:	AssaultCountPlayers(
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
line 1524
;1519:		point,
;1520:		&attackers,
;1521:		&defenders
;1522:	);
;1523:
;1524:	if( attackers > 0 && defenders == 0 ) {
ADDRLP4 36
CNSTI4 0
ASGNI4
ADDRLP4 16
INDIRI4
ADDRLP4 36
INDIRI4
LEI4 $742
ADDRLP4 20
INDIRI4
ADDRLP4 36
INDIRI4
NEI4 $742
line 1525
;1525:		assault.captureProgress += frameTime;
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
line 1526
;1526:	}
ADDRGP4 $743
JUMPV
LABELV $742
line 1527
;1527:	else if( attackers == 0 ) {
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $745
line 1528
;1528:		assault.captureProgress -= frameTime / 2;
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
line 1530
;1529:
;1530:		if( assault.captureProgress < 0 ) {
ADDRGP4 assault+344
INDIRI4
CNSTI4 0
GEI4 $748
line 1531
;1531:			assault.captureProgress = 0;
ADDRGP4 assault+344
CNSTI4 0
ASGNI4
line 1532
;1532:		}
LABELV $748
line 1533
;1533:	}
LABELV $745
LABELV $743
line 1535
;1534:
;1535:	holdTime = AssaultCurrentHoldTime();
ADDRLP4 40
ADDRGP4 AssaultCurrentHoldTime
CALLI4
ASGNI4
ADDRLP4 8
ADDRLP4 40
INDIRI4
ASGNI4
line 1537
;1536:
;1537:	quarter =
ADDRLP4 4
ADDRGP4 assault+344
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
INDIRI4
DIVI4
ASGNI4
line 1540
;1538:		(assault.captureProgress * 4) / holdTime;
;1539:
;1540:	if( quarter > assault.announcedQuarter &&
ADDRLP4 4
INDIRI4
ADDRGP4 assault+348
INDIRI4
LEI4 $753
ADDRLP4 4
INDIRI4
CNSTI4 4
GEI4 $753
line 1541
;1541:		quarter < 4 ) {
line 1542
;1542:		assault.announcedQuarter = quarter;
ADDRGP4 assault+348
ADDRLP4 4
INDIRI4
ASGNI4
line 1544
;1543:
;1544:		trap_SendServerCommand(
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 48
ADDRGP4 AssaultPointName
CALLP4
ASGNP4
ADDRGP4 $757
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
line 1552
;1545:			-1,
;1546:			va(
;1547:				"cp \"Point %s: %i%%\"",
;1548:				AssaultPointName(point),
;1549:				quarter * 25
;1550:			)
;1551:		);
;1552:	}
LABELV $753
line 1554
;1553:
;1554:	if( assault.captureProgress >= holdTime ) {
ADDRGP4 assault+344
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $758
line 1555
;1555:		AssaultCompletePoint();
ADDRGP4 AssaultCompletePoint
CALLV
pop
line 1556
;1556:	}
LABELV $758
line 1557
;1557:}
LABELV $689
endproc G_AssaultRunFrame 56 12
import LogExit
bss
align 4
LABELV assault
skip 396
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
LABELV $757
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
LABELV $733
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
LABELV $720
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
LABELV $683
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
LABELV $682
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
LABELV $681
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
LABELV $680
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
LABELV $679
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
LABELV $678
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
LABELV $677
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
LABELV $676
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
LABELV $647
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
LABELV $645
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
LABELV $644
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
LABELV $632
byte 1 45
byte 1 49
byte 1 0
align 1
LABELV $626
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
LABELV $623
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
LABELV $618
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
LABELV $615
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
LABELV $606
byte 1 115
byte 1 0
align 1
LABELV $605
byte 1 0
align 1
LABELV $604
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
LABELV $586
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
LABELV $581
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
LABELV $564
byte 1 48
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
LABELV $549
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
LABELV $517
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
LABELV $509
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
LABELV $489
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
LABELV $488
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
LABELV $487
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
LABELV $486
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
LABELV $483
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
LABELV $482
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
LABELV $420
byte 1 66
byte 1 108
byte 1 117
byte 1 101
byte 1 0
align 1
LABELV $419
byte 1 82
byte 1 101
byte 1 100
byte 1 0
align 1
LABELV $418
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
LABELV $416
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $374
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
LABELV $371
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
LABELV $354
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
LABELV $349
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
LABELV $344
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
LABELV $339
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
LABELV $335
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
LABELV $331
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
LABELV $326
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
LABELV $300
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
LABELV $299
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
LABELV $280
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
LABELV $268
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
LABELV $261
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
LABELV $256
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
LABELV $245
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
LABELV $236
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
LABELV $231
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
LABELV $227
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
LABELV $224
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
LABELV $138
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
LABELV $137
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
